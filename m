Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5D02B8CC0
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 09:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgKSIC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 03:02:29 -0500
Received: from outbound-ip23a.ess.barracuda.com ([209.222.82.205]:48306 "EHLO
        outbound-ip23a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726118AbgKSIC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 03:02:28 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105]) by mx5.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 19 Nov 2020 08:02:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Te453neV1452RxRULSb+mM83Sex2kNyj9cVktHQwibpgA6vhwNacu2WV2LTZ5iwqL32Wa/cGwE1pFf9AR5ecPsEVGmm8MtnojkBot7BEqslD4Qs3H+W6ILuZnF6Mt1YUnSW85oFxw57Y4r+zrs0azAAOA/EHFtSS3oiMZgkii27EpLL9OJaN4mdmxBVHn0xwkQZW9TY0EUoXjVL2RgVKGdsS2gXFEzffzO+15Hy7CzKvLq887cXL1OkblLihdNJ/Pz2z7Q8y/gmSIF+7Wbn16F2nV+YjUYdXH6HyThbI/Jju1NbD7kqdKyW6R2HpnBc0/NMKDXdB9zrrTiSn2e9EvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5ySSf22i8RgYnCI8e2eIKHtDHVqIAxzZ+1vI6zLk8s=;
 b=V/d/xzVVHU3Dy5Tg9FhHaolV2j+7B0X2Z3bttMC714x3tKv4VuNOtYmI3kQVf3W4SPSSCFH8lVopnwFt0Ae1jQdjqvSprqJrJcQLH0ixyRyaRnQA6p89/qvgJwxuwacF5BfybbHztF3bPqwQo9fdTmXjoFil205KAbRWEslV5v71bK1E2ZWVJywEuiiMIhVh7pBqVbfp2GE4jIJd9h4J5RxvldGWovFmDlHs/wudo5fJkGCU6lEW51WrsVoBtktUK/oola/jBaTFzeJDx41Ina4utWLAWIMk/nzRQ07/edwH/M2tt2YkD/A4JhkjbKOrVtVISlnbo7t6Itz/B8r/IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5ySSf22i8RgYnCI8e2eIKHtDHVqIAxzZ+1vI6zLk8s=;
 b=KUXQcjsLaxK1RvcEdb+FwoiatVctfbU7lGDdmGak0gu2GLsVHXPlPkJ6Zo5XCV4jl0QjNzuzYtd7At5eSrMwsl6qEoRVzk51FWGbNyMENWTZOwk5/Z7PpmAOurKTxC90A42ix+dhY+2kshjXXJ+0qSmWntn1/ri7+sp/10pQqNE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by MN2PR10MB3757.namprd10.prod.outlook.com (2603:10b6:208:182::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Thu, 19 Nov
 2020 08:02:06 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%9]) with mapi id 15.20.3564.028; Thu, 19 Nov 2020
 08:02:06 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     kuba@kernel.org
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, marek.behun@nic.cz,
        netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v9 0/4] Add support for mv88e6393x family of Marvell
Date:   Thu, 19 Nov 2020 18:01:04 +1000
Message-Id: <cover.1605684865.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201105175252.12bdc0d3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201105175252.12bdc0d3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain
X-Originating-IP: [14.200.39.236]
X-ClientProxiedBy: SY2PR01CA0032.ausprd01.prod.outlook.com
 (2603:10c6:1:15::20) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (14.200.39.236) by SY2PR01CA0032.ausprd01.prod.outlook.com (2603:10c6:1:15::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Thu, 19 Nov 2020 08:02:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99612c00-aafd-4b6b-63aa-08d88c6167bb
X-MS-TrafficTypeDiagnostic: MN2PR10MB3757:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB3757D06615E0033AAE12D64895E00@MN2PR10MB3757.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DdXKHutQ1o+AYN5Cy08bsQaYrIezJ8S9/ApPXR67g2PIZvp/eO/A4jEhYHmcv9BpSjDeQkShlSgkWNkYXMvR9pDtGVEdLo32dF8F/IlZETXmF4Pj/FDDG6NlBuPb4b/dTnezGZ+7cp4Hugs87e7bLuFaGhtokm2lLdReL9Z10taLg9xbBAUO7R4vu8Me7kr9UucHig5uzoApETr2GaaJjRy24ybX+/+6ha4wM3ubFiNIM1X2Q/SMm3SgceYNLlyW+FDABLlnQV6XcriP0ya/siDAw8qIrWEIFaoEhZtSfN767eX+7isEDkgutxLOBxASyDE8CjbzS2JYJITNQyzZpBZ8B7w9qHDyklOC2cvqkD3hrripPKCsakVjI4TmCV4u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(396003)(39850400004)(346002)(5660300002)(316002)(186003)(36756003)(7416002)(8936002)(52116002)(69590400008)(66946007)(6486002)(478600001)(6916009)(6512007)(2906002)(4744005)(4326008)(66476007)(66556008)(2616005)(6506007)(86362001)(44832011)(8676002)(956004)(16526019)(26005)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: nkI2djJcVE2GSrosNMhaGbcRWQifLD+Ub5/DK9v+MhVUhgcVpWkEJcxd4ceHHL/Swi7ULxG0YrMx/goyVLtTALzmK2b2R8LZ0tGEZibjaPXsnst+nN4QIEkus9yF76UdgmHzczQORcBq2G80vr7o3RVZFQM6SsX3NWE2OIqmBCUlBR7BQHhy9OPv3h1t6W/c1wps3PNCQgWBp9JyIGinok/tgZ+NZnvLzLOtEAwGSLn+pf8KdHhwxj/QK413VP8FTm1z3z58nFLa6cNX8Rt0zSVxH/Uv+k+CwYha5ilOgEq0YEXx7p16ZqwvuGEj1iKkCI69t1zeemf2v9LqLPryUvhYaZ6oFoGLYhrecYHoDwndqeE8HpBTq0leQHFSxYPAn7SsAzGuNCCy7HEURdPTigYGmL8o+G0iGjBp1+C4yessiJk6KtRJ8UBi6OaIYbWUzCHfCz4BpwJsNI/UumR/WljIp7BIIzQt0juimHRQIG+Xe8gggVwGEgShEJRbs/rpj2SWmj8hVWY35WPVhOtg2wY4dVXwcpUaEthSHo3OnctlmO3GLCa59At4MCVkQDvbzI4vgN/Iyuf5D7UFyVxOsVYJU0ztTBAkZ8PdJSx5nXWMYpdktBGP/9AE4xYTy452hbZilKqkqEUS82PYppEXvjGTFEddVRjKsz9Mg5TwK3kmJTxydx2vxy2wTo1WrEJ8+EAtp+BoaNQTHmj9uqv8pGz5hTqnOqWeM29l4lJB5LlVGLZ5n/Q3p68MsC7O5aTgJY4KT5ulN4FUfoHx7lHKf5AOjkcsdsfwFMmKeE1L7em9v8lnsP3rRvQKgu/nF1mZPXzfPT9ZHYovn7wfxxHo7TiJ+YsWgSgr5r22OsO6yyIXxODmMQ9oMJQsyQQxBnn/fHvthghQymzaVxDIGLE74Q==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99612c00-aafd-4b6b-63aa-08d88c6167bb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2020 08:02:06.1637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bugYWkAS1WFvFUkash3Z+mBpmTuLW1KUxjyDVEQwrkGLSwAA4EoRUvlj6xb9jH4tqd/BLdc4MDwBzQBK5iUklA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3757
X-BESS-ID: 1605772929-893008-27031-54173-1
X-BESS-VER: 2019.1_20201118.2036
X-BESS-Apparent-Source-IP: 104.47.70.105
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228292 [from 
        cloudscan9-45.us-east-2a.ess.aws.cudaops.com]
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

Thanks for the review.
Here's updated patchset.
All possible checkpatch 'checks' are attended.

Pavana Sharma (4):
  dt-bindings: net: Add 5GBASER phy interface mode
  net: phy: Add 5GBASER interface mode
  net: dsa: mv88e6xxx: Change serdes lane parameter from  u8 type to int
  net: dsa: mv88e6xxx: Add support for mv88e6393x family  of Marvell

 .../bindings/net/ethernet-controller.yaml     |   2 +
 drivers/net/dsa/mv88e6xxx/chip.c              | 164 +++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h              |  20 +-
 drivers/net/dsa/mv88e6xxx/global1.h           |   2 +
 drivers/net/dsa/mv88e6xxx/global2.h           |   8 +
 drivers/net/dsa/mv88e6xxx/port.c              | 240 +++++++++++++-
 drivers/net/dsa/mv88e6xxx/port.h              |  43 ++-
 drivers/net/dsa/mv88e6xxx/serdes.c            | 296 +++++++++++++++---
 drivers/net/dsa/mv88e6xxx/serdes.h            |  93 ++++--
 include/linux/phy.h                           |   5 +
 10 files changed, 781 insertions(+), 92 deletions(-)

-- 
2.17.1

