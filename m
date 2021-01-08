Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64712EF00D
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 10:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbhAHJu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 04:50:56 -0500
Received: from outbound-ip24a.ess.barracuda.com ([209.222.82.206]:38810 "EHLO
        outbound-ip24a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725791AbhAHJu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 04:50:56 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2043.outbound.protection.outlook.com [104.47.74.43]) by mx-outbound42-242.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 08 Jan 2021 09:49:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=APkC6rCznpuIHo0T9bwBOAs5W6lg0gOLucIuj0OpamxPbSSMzYA8pv8J0z27vsoe1N0N0BvCBXkCzJ7zRQSZmXXCIOnyX1kVtd5jj3HBx9FuubWIzSCcKVTNtK/1mWHOz7vE1EWxqwaSZKLCV8b607xXp7Cd1Dpy++h9b1VhAjy0DAk5OrFYuRE/mhCgWoQeWbLWflXEqqFPox9qo0lCav2wZtu2bO4hlz+BMxNeVFJ0nP/TYMgTtzAIyD/vHbBo1SdijpovnFD6mLZJATPZTYThPVDAz97dS37fCCUjkw5kAnNgoawrpdQ98/KCLOteoLIKbHw7EIoTz4AzeaaFmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AH/JqtHPqY0yofVpHN+rrZNBaSzFRirE5SqsXgjwcsA=;
 b=dqN6z0SN4EPgPOC/WoBd9PWWQzyg7ALws7ni8I0y2v2rch6tFb9I76mfX/Jo6nNsl22/TR3AySsZNawnzofij6BtpQriXb/t19t2TNIj9IdXOC/onECdHF6TweL+n4MCeKqQIJZ4FvTheqgm/7zPvGyeGeEIPxIAY3cNh9o6ZxWGggc/2kP1EfatKsSvNHmku9nTQvii+brzHtHzUpoSnFW7uyP8CQArzrFdPTtDw5qsN42HgakkVfdnqJN2brw9/Lvl395KTzRUqcyTdYQTwn17wSApqHBMbMfKbt0OXS7vcEODfpiumR0Sf4UxqgK5jArdOfpncAzaKuHoQSBp9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AH/JqtHPqY0yofVpHN+rrZNBaSzFRirE5SqsXgjwcsA=;
 b=SmHgcMe90zle9NGcBuJxaRFLoPwmdiESExE0j4HFaoi++nZhN6GE9C6Kod7yCneHBp9Vxen6/F/oIMPrevMo5FTrZEoBpL+0noRrB9o96YOGyzHGfd690BPdVggJrXG56bOk4iF4Oviir+o6+ExAG0Kt+rx6bSzFarlcBEvM0Sc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=digi.com;
Received: from PH0PR10MB4693.namprd10.prod.outlook.com (2603:10b6:510:3c::12)
 by PH0PR10MB4789.namprd10.prod.outlook.com (2603:10b6:510:3c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 8 Jan
 2021 09:49:20 +0000
Received: from PH0PR10MB4693.namprd10.prod.outlook.com
 ([fe80::4060:f3f0:5449:c60e]) by PH0PR10MB4693.namprd10.prod.outlook.com
 ([fe80::4060:f3f0:5449:c60e%7]) with mapi id 15.20.3742.009; Fri, 8 Jan 2021
 09:49:20 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     kabel@kernel.org
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com, davem@davemloft.net,
        f.fainelli@gmail.com, kuba@kernel.org, lkp@intel.com,
        netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com
Subject: [net-next PATCH v13 1/4] dt-bindings: net: Add 5GBASER phy interface
Date:   Fri,  8 Jan 2021 19:48:59 +1000
Message-Id: <8a6d2449c20e8b224e99c95df6352ee88ec378df.1610071984.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1610071984.git.pavana.sharma@digi.com>
References: <cover.1610071984.git.pavana.sharma@digi.com>
Content-Type: text/plain
X-Originating-IP: [203.194.46.17]
X-ClientProxiedBy: SYBPR01CA0147.ausprd01.prod.outlook.com
 (2603:10c6:10:d::15) To PH0PR10MB4693.namprd10.prod.outlook.com
 (2603:10b6:510:3c::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (203.194.46.17) by SYBPR01CA0147.ausprd01.prod.outlook.com (2603:10c6:10:d::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Fri, 8 Jan 2021 09:49:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b742d336-ef63-4ec1-4758-08d8b3baabe6
X-MS-TrafficTypeDiagnostic: PH0PR10MB4789:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB478971E717FE07492490D73095AE0@PH0PR10MB4789.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wcztOjiiSR82eH31lD5eKAfL2al11LcoqpyNgG91qc9FFYKKGrWFd9MdoLmgbj22agLQrTH+VBu3Ak7wKXvI90e3RD1A3lItUHl5fvHn1TYKKa3Gf93owflZC+d04QG9ZlN/bH6BirExo7GdjJRYUIDQw5SleE/nWLxbcRxPGiWFNFHhomMm74PKi1HWFacUucXKY50RO8wnUosRZUqcRn6eYySwBJ6sT45Tgtj17KzqM7SPwCgSw/bmjsGyNKaVSE3YNrYvwBnvQU9O1nuRBzaDwduG2KSABeB1CesyYipMbHXjpQl5Ui0am6yvtVapjrifyeDCR++ZF9R4JcbvN0fFnEUb2fxWc3hNKCpwbJZw5t2h7HWixLHnFMiPeafMS4zElJsUImagwHvp5x2fZQ0OD+vPOKNNP+o/icfm2vMS2EHc2k8IDweh5dZP53nq2GPn/C5Lu31PDmfN08svmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4693.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(136003)(39850400004)(346002)(2616005)(16526019)(956004)(186003)(6666004)(6506007)(36756003)(26005)(4326008)(6512007)(4744005)(6486002)(44832011)(5660300002)(66946007)(66476007)(66556008)(6916009)(316002)(86362001)(2906002)(8676002)(69590400011)(8936002)(52116002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pa/lsUkjO7JZHAKr6cuMBqyEIr5H29BC6n+DJBpNGHcQaY75lPX8alY+HsgR?=
 =?us-ascii?Q?eWg2LLyczLtH+wIVITH26AMru96OcQ84wszSuy4dU1KISEGGhTWVCJXyydaz?=
 =?us-ascii?Q?DfWaWQDxK5xQIJZgR17pYuhHxwW8tVe/GV5Z0xK0fkd7ekGM9FxYdkIyppr9?=
 =?us-ascii?Q?XbZdHpXMTvwrR/isS/9wjAw4w9hB2CoqM3lKRFLr0+Zv06V5c7tNJAM9xIrv?=
 =?us-ascii?Q?vJf0LZbjBLFB+Yd76Lv2IEogMDwE9gsM/Apm/hlp7LmXYcWRHHcEOFWeJwQw?=
 =?us-ascii?Q?gGi4g9TFIF9b+Lp1BORDNW7YDb0zYq7YrVOicP/L4g+MGsciBDsM9LPF+tRz?=
 =?us-ascii?Q?OLJqZc3mJn85DVf59KtoC3jPEgJA2GnBJ+v9ImRKT8m6Ws9tRrbeoeZB82Ck?=
 =?us-ascii?Q?bb4PECmtAXHiYfcRYy80HLdC3OYqvrz+LO4Z55KD9Jl0pesPHpJmf8S9YhxD?=
 =?us-ascii?Q?DnsIqQUyrAYd4cMumDJwTtvmEqnpF8dd2CXf/x/wSteoAa3fGFcRPO92bGKu?=
 =?us-ascii?Q?14qBB0N9+7EZZ5gfn/2leZ9cGgcj/l/KrCiH8dH//l/kfYkj0UvS2BRUioKZ?=
 =?us-ascii?Q?qIhGJlzUzVW+cAHOvhubl1kMkn35FilHx1/g+wYuI0WLDRXXHOKT7KxcdvEc?=
 =?us-ascii?Q?TssofN6UbEETzel0jwtPZzMkbTruvXQajOYgX93hWAWRn3yns83jUQtXGNf/?=
 =?us-ascii?Q?IgqVcMgO8wDRehz8feiYNMRwBIJnllwxHAF4TxjFqS6/Nve6Lj6U675/t3Tt?=
 =?us-ascii?Q?nHBVldZBQk5cQdbEn/P7Fwh/Eo93RHE++lZlnI/Qzs5CDuY5Rvv3Pkr6vYcE?=
 =?us-ascii?Q?0fSVdvKKM9Dad+7Wn7Hv1Ccv0ERSIm6ouXzCluwSv/ssaTAhXQFq/FtJurM8?=
 =?us-ascii?Q?swtN+5/Du7LLMVy/PQXdgpE50azeD9mCFTx0J1KAgLNEcj9MuosXUQdsoQlY?=
 =?us-ascii?Q?azCDcANtzR3Xe13AHlPxEqD+mXhInqk9EVkQQ+duaskad7ISVNrqjJLXOETT?=
 =?us-ascii?Q?uPNt?=
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4693.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2021 09:49:20.0785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-Network-Message-Id: b742d336-ef63-4ec1-4758-08d8b3baabe6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7GHAQKVWxR7MHbALiH8DBldkTmOv/ZjTY8+UQHITgQ1xw4NnjDgApYm4+9aXsslV1SrDBNhrvi8V3iyGFKtK2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4789
X-BESS-ID: 1610099395-110994-5410-11400-1
X-BESS-VER: 2019.1_20210107.2235
X-BESS-Apparent-Source-IP: 104.47.74.43
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.229399 [from 
        cloudscan14-24.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
        0.00 MSGID_FROM_MTA_HEADER  META: Message-Id was added by a relay 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, MSGID_FROM_MTA_HEADER
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 5gbase-r PHY interface mode.

Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/ethernet-controller.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 0965f6515f9e..5507ae3c478d 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -89,6 +89,7 @@ properties:
       - trgmii
       - 1000base-x
       - 2500base-x
+      - 5gbase-r
       - rxaui
       - xaui
 
-- 
2.17.1

