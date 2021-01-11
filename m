Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7812F0CB4
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 07:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbhAKF7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 00:59:08 -0500
Received: from outbound-ip23b.ess.barracuda.com ([209.222.82.220]:42824 "EHLO
        outbound-ip23b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727055AbhAKF7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 00:59:07 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100]) by mx-outbound17-131.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 11 Jan 2021 05:57:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=am/AOHVMkVPaYVASEvXDUA2ncmLiWdhtNLcA9kWfOILb4Tm0tNMwbhOyRSk+AB8vmQyD+EjQyhhffXLSszGh7v77Ei2fVurLWlkRdFOqWzlxZ0r7huprEIrHmtsBhB/OApclNfit3IM5vfHuCOmiUbJKeQZp8crVHpixdWwrmlk3yKa/gVK7l8G2URvnFFpUZ71px+ty50ua7hbWB/4nroIIpkkBakbKwyIJ+zQPzCmPXvOH2U0E2vIq2GG0GKgjod5XqEQRwlm6Pfp3M21fMz2LGoC+8lvAKCSzFAP5tB5tYDHAhmvwW4kHQ+mCL7UUSkIFdB+E/iPn4iqAkW6zvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJYyfwbWSGoEulSagZV9TAkaEvmPpp94rL/RuhGLB4I=;
 b=Wmb+w0N2/jC2njWzQ4ZYU96S2spG9r72vW4ii41aqkzrd5NXD39zgCEum0753jd5yZHga3SbDFg2VtLLbqOmVRvuOvl6Bit3/kMnwAsB7YRNXO9ePa4XFWSLRjt7QEE8qNXT5DsPo/I1WqE2CCUFJAr4ZiISAquVxE59sXZj+rpP93UP5cuD0TPT1NV9QejqVnqlOuElIHUV8OIYlGmhDyZHhvXDLrHrzpD+wJHVk4v1xfffdAIZ1888YdJJgFT4Pt/zWMItW1+rsNdWBUB07FsBhgy0L0AmRm9aI5J27NjAjku/JEBxFXCt+AMikeOdFXdVw5l/m+5yccSPxmaCZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJYyfwbWSGoEulSagZV9TAkaEvmPpp94rL/RuhGLB4I=;
 b=qWVLVal81pViyxDA7hsqAiVh2NjHphBfg3hTm60+dJYHqkJ0aV+x5X/mnm0wGRaSi5ocGsjK98xwCCt8U3xPHg+tqb4MSjhZ7yisRuQPCjQ6HSAnl1OX+f71951jdXgXQ/657GdUTJ3to2ddBO4PUfgSFqoCIyBW7O7He9xF+uo=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=digi.com;
Received: from PH0PR10MB4693.namprd10.prod.outlook.com (2603:10b6:510:3c::12)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 05:57:47 +0000
Received: from PH0PR10MB4693.namprd10.prod.outlook.com
 ([fe80::4060:f3f0:5449:c60e]) by PH0PR10MB4693.namprd10.prod.outlook.com
 ([fe80::4060:f3f0:5449:c60e%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 05:57:46 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     kabel@kernel.org
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com,
        chris.packham@alliedtelesis.co.nz, davem@davemloft.net,
        f.fainelli@gmail.com, kuba@kernel.org, linux@armlinux.org.uk,
        lkp@intel.com, netdev@vger.kernel.org, olteanv@gmail.com,
        pavana.sharma@digi.com, vivien.didelot@gmail.com
Subject: [PATCH net-next v14 4/6] net: dsa: mv88e6xxx: wrap .set_egress_port method
Date:   Mon, 11 Jan 2021 15:57:01 +1000
Message-Id: <20210111055701.13245-1-pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210111012156.27799-5-kabel@kernel.org>
References: <20210111012156.27799-5-kabel@kernel.org>
Content-Type: text/plain
X-Originating-IP: [14.200.71.209]
X-ClientProxiedBy: SY6PR01CA0058.ausprd01.prod.outlook.com
 (2603:10c6:10:ea::9) To PH0PR10MB4693.namprd10.prod.outlook.com
 (2603:10b6:510:3c::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (14.200.71.209) by SY6PR01CA0058.ausprd01.prod.outlook.com (2603:10c6:10:ea::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 05:57:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f73b6e99-1fcb-4622-cc39-08d8b5f5d20a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4616:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46163CD444A1972BE5AF059D95AB0@PH0PR10MB4616.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g0TArISOPlAiOp38FodZlHwygtD3VoKnvkv8BA6K95sNnpzvU1O9Wf4v6M5B9m/gyUoypItRY7CROVbJNLi6jcVOnOzgn+oG4FebWc3LDqUAwl7QoZws1lV5qyqKkBl4TCRlebmoNxDAxWiYTv/wDIHJtY8zpNr19RZTAqFavTHcl29gLn9BxC7N7DtU/Iyfcm0pLQa39uxK9w1wEDwrKTIgCEKd7w192BQSq0O076agitdyhj2K3w5hIDM0ET9lYf27sOXUlk/MzkwgzB5vRuUcBxlCFUyq8309j7m8wmdrGygX5YctS8SKC2R7FWStnMhnfDpBBN4eOYQtPXHQ9u0+87sSsJoyJheC0wgRK3B8GhwicwWiPrsjpuVrap3cMlSGZpo+0mYzDX6dAqmwSjm04YkzU4UpI4/OikG3d7wNpR3vO2XLKK12u3gGQgL6ezuEWWCBODlWDpW1CGPmiQ3xCjKrtnujYDga4giCyqw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4693.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(376002)(136003)(346002)(396003)(366004)(6916009)(86362001)(4326008)(16526019)(26005)(316002)(7416002)(8936002)(956004)(8676002)(69590400011)(2906002)(6486002)(66946007)(6512007)(2616005)(66556008)(19618925003)(186003)(558084003)(5660300002)(1076003)(66476007)(52116002)(6506007)(478600001)(36756003)(6666004)(4270600006)(44832011)(142923001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KtR9wqasP4R3rMqInbxPCQi813pd0tZQrv6K4BpOSqElLpjrJiRE5HRkdLIp?=
 =?us-ascii?Q?uBE1Ov4grLbe/yAE2eyvPaM/4q98YxFUXCm3D5jxC3ZSPrkZo7GHIEf3rKCQ?=
 =?us-ascii?Q?eORjJwDXA574T/OvtCcpfZtJPGSU5bwWInj7Gx6B0X19gvLGdgkdU4FRd1jq?=
 =?us-ascii?Q?LuqULxw3YUATsNdwl0RRRU7pI+mTDIH8A2eYgMhY93th+G8btgakUMbMeEFL?=
 =?us-ascii?Q?qQ/Tigj9uK0HfsdEUfNrS8xpX2uzbh3d64vmfdoWV3EXyA6J+9nsCw2EnCAj?=
 =?us-ascii?Q?63T70yVDfV4PDfcG6e2nEgm0i4wHvYuWxa7gSdh8sPZ8/xhb8fUrMeZOJl1Z?=
 =?us-ascii?Q?WVcB2Z7YtcRuBStsRJhhe2olEh+ZR7FciZyCSJPGh4IdX4UMpvhl30OPB5bs?=
 =?us-ascii?Q?y5o512YMkxgaFh2khLuy5QbkrMbeJzj1m75jW2PHB0JpYUWE7Cy/cBnpIwxS?=
 =?us-ascii?Q?sv1uaPtXrfwUUeAfNQQ67BfIwEMgeTAhu1nocfEpivqu8M1JGYTuP5uIzjrp?=
 =?us-ascii?Q?3yRCzHI6joX4HhkBprm8vFHX+ahHAf+Uia3cPxGNdSyOE9tPu5wPx0NPpVuS?=
 =?us-ascii?Q?g7TlHezjiL8hfmc64wF6d1TZkQaQCB2qWy779QYpE3nEryNYS748vYsh3F8l?=
 =?us-ascii?Q?iEcW1BOv5qldOVZf5L997RgKKXEHplVdiuhLcqI+zEiC9wnT+PbeatzIxw9d?=
 =?us-ascii?Q?BIZlcs1XcBu+oNWEBSUKe2MO1yMJQw/lUU224ZsXR3pCW/j8m83Gpl0HueYb?=
 =?us-ascii?Q?2/SwzqKYD+UebB+atgu59QVtNcfr/1Vepo3Yxq363RIrexEaNQ/Lk72vQ2yo?=
 =?us-ascii?Q?S+nl1/NOqT7jY6C/9W8yzM9TMBjy+z3zX+MUOI8wIM140bF4Y4ir/8UiYy9+?=
 =?us-ascii?Q?NaLXTBoRSEEb/kdNiTv4qbF3rkPvNjlX2/7iGTeh7m/n1KiBhxprl3WZZPyx?=
 =?us-ascii?Q?oGpsPxtIog8ObG0i99tKRQojb1lnFehxFAGDJOUlCbU/x7zdmNxGAiiMEKXH?=
 =?us-ascii?Q?03o6?=
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4693.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 05:57:46.5705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-Network-Message-Id: f73b6e99-1fcb-4622-cc39-08d8b5f5d20a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b7ZZzYMZne4HXjjgmeILTbigLpkrz6JkgfRhPpdj1oHXas6uwgsOwHCVa4coEG7afxb9iRNi/tOYnxM+/SsevQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-BESS-ID: 1610344669-104483-5404-52451-1
X-BESS-VER: 2019.1_20210108.2336
X-BESS-Apparent-Source-IP: 104.47.70.100
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.229468 [from 
        cloudscan19-13.us-east-2b.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 MSGID_FROM_MTA_HEADER  META: Message-Id was added by a relay 
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=MSGID_FROM_MTA_HEADER, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Pavana Sharma <pavana.sharma@digi.com>
