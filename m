Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D7A2EF008
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 10:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbhAHJty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 04:49:54 -0500
Received: from outbound-ip24b.ess.barracuda.com ([209.222.82.221]:36244 "EHLO
        outbound-ip24b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726683AbhAHJtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 04:49:53 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103]) by mx-outbound44-209.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 08 Jan 2021 09:48:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=errL7bxzcMrKggOApRBj5bTgK4LiJ8qn5HDFYlci8yK8GpXB2ZDd9idFzeZf0qmSbGS4vLOvXszoEWNs4/x9mFN+hmELnO3/b/Zvq6CGx6w0zPMzKNcg1hewJKrEs6q2eWL4WNPagFzH8MhCmSYbhs8KusbiINsMJuRZ0vJUf41VIVnPgoA6il67it/O6MQk6aTv0VwmGUJ0z8QuAyqFmhaGm3s5vUTNN71nldOrQG25O4wEidRCTbwxz7uDT1UFc8HsgMyGjuPtxTUrIUS6nqTz9xfagM5I8FI+pRPkSiKuOu2XKyNvYCZQlL5CO75ERM4hMAXo/2MgnkGjEFvoEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7xgDIn+Ovnpp+KPMZ4dpwrlnxaW6UXWT17nM7icpW5I=;
 b=WxVVHme5RMRM1A+1zJI9xjNaNNTp30KYszqIljY1tzJTCazR7uFygdkGPvOSWLe/NpRL+Y8niPXzr3r+eSpFJ1n+sNa29aHcYcRuKqu5VPnmlfGLUgPwQbLxFQVk4Z9FS2mMNFRSHi+HdvS8tJIeNAKYv5ezT3gfoAPJanxAHhaeVXylj5J6V2GnMzKImDPJ+yTYWPUXo92XQJAmQt1Z6sUxjHklyCpqQOtgcNI/FY34bUREeAU/zJoE32iDXb2FTI86snRBt0qlivMqAmXVUZkCFOCOPBs4P83GpGieSZnFpDuIK2eOD/ds7mJSmHF4G7Yx74UveyKwS4IQoIDiUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7xgDIn+Ovnpp+KPMZ4dpwrlnxaW6UXWT17nM7icpW5I=;
 b=fuSems3gSIhCDwFROnqbgHAWebSwzietm4WHrNt1ujIfPVxz1/59lOBxT05QocMDKVUa80Yhbhw7xT9BXOwaiiwSAiOaVccWFIGbqz0BI/RuGmyX0DIylBiTOfE1SWSIBqyTT3Gknc/zpBH16wWOySBGfsC7QjRQ1JIncmzw+n0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=digi.com;
Received: from PH0PR10MB4693.namprd10.prod.outlook.com (2603:10b6:510:3c::12)
 by PH0PR10MB4789.namprd10.prod.outlook.com (2603:10b6:510:3c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 8 Jan
 2021 09:48:46 +0000
Received: from PH0PR10MB4693.namprd10.prod.outlook.com
 ([fe80::4060:f3f0:5449:c60e]) by PH0PR10MB4693.namprd10.prod.outlook.com
 ([fe80::4060:f3f0:5449:c60e%7]) with mapi id 15.20.3742.009; Fri, 8 Jan 2021
 09:48:46 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     kabel@kernel.org
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com, davem@davemloft.net,
        f.fainelli@gmail.com, kuba@kernel.org, lkp@intel.com,
        netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com
Subject: [net-next PATCH v13 0/4] Add support for mv88e6393x family of Marvell
Date:   Fri,  8 Jan 2021 19:47:58 +1000
Message-Id: <cover.1610071984.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210105123755.30552-1-kabel@kernel.org>
References: <20210105123755.30552-1-kabel@kernel.org>
Content-Type: text/plain
X-Originating-IP: [203.194.46.17]
X-ClientProxiedBy: SY3PR01CA0112.ausprd01.prod.outlook.com
 (2603:10c6:0:1a::21) To PH0PR10MB4693.namprd10.prod.outlook.com
 (2603:10b6:510:3c::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (203.194.46.17) by SY3PR01CA0112.ausprd01.prod.outlook.com (2603:10c6:0:1a::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Fri, 8 Jan 2021 09:48:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18c2f10e-dda7-4d46-c0cf-08d8b3ba97d5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4789:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47897547731B2D44DE59D2B495AE0@PH0PR10MB4789.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xf70D2/dnLQmD+QfvBx8y63s/X1UuPKtbldPA8HaRpphDTLgRvu8gL/zyhpVSPV++ifX7999uSMAz9mkcHs4XoeRYzo7jvstzCYdsUJifFWV5S9EkKbv2A0UFZKqnUEMbzqS//vY1HNPlofLe7PhRfukJiz3SKEIwDob3ch+WifWR5TYSQK9NToMUOss41obDTFa1CkEosIcsMqoXYmmXXnlpNAZ9ZUYj4AI25HsUBmHyfQFt5/YoJ3S/esbi5pZD9FTDtyg/lG6kakoTUwabHOGKCBnPIHgvth5BtZHCOej9WdwbkjXWB+V+nWz7Mrj6nbMznIqaHvgn5sFHn0SshSGTQL8p6tyd2I6NUQiJhv1kYUtZHan1+59H8BDviWYiYIq20KfejmWs86+CZYFCkiQS7CMdzFsPNzOaeAS3HqWo+uexqi0pM/ZuL9TRNbH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4693.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(136003)(39850400004)(346002)(2616005)(16526019)(956004)(186003)(6666004)(6506007)(36756003)(26005)(4326008)(6512007)(4744005)(6486002)(44832011)(83380400001)(5660300002)(66946007)(66476007)(66556008)(6916009)(316002)(86362001)(2906002)(8676002)(69590400011)(8936002)(52116002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8llpfLmbXrr03TcjOj8FctW4RnxXCbKxeYZjIOwFdBJfCTUq2ksLy/Q14hMG?=
 =?us-ascii?Q?OYHvWPAK2ndT8PHvwk1hTjzKFohkfhcfByLviPW4SOIw0gj7Q4IdFP8tA5JR?=
 =?us-ascii?Q?o8GO30EA9WjrFYEfwjpH013grJBLAjxQtsXY9DEDbTfQ+9HgvGI7fgMq3v05?=
 =?us-ascii?Q?NW609L8otiyDSjYAAsZt5tg2yXiKYnuVqd9jSTEVIKiZ6vuBFCaJkU0aw1wL?=
 =?us-ascii?Q?NlusdyujItSaNYqDws+C7XKBhX0MJEySJhKj9q3PDcBv6SsjXqHGisDwoa95?=
 =?us-ascii?Q?dxIN9KWkO8uVOR7lCcFB3Escw5h2W0UK1USuSJCDzmY+NrkJinfsI4tPFlid?=
 =?us-ascii?Q?vvr/JLM4yraN4ureVPotHUo6++TvkIoi/QJ0s6slIIQ0kyRxTpnRzhQhQDxD?=
 =?us-ascii?Q?VnDkzhsa8f5B4weSPcdrkgSQmhLwM5SGFBK0UJLiOjZv5RDlJg6UV6CIECw2?=
 =?us-ascii?Q?pcCa7xEMmbDaJRxOWCCUGJzZuL4sSl8gc4cE2bVkB/t+LyFVeprsNkbxgS5G?=
 =?us-ascii?Q?naxcyDGgv8NJj/LpnsmUHuh57mWzx0Oa7uOF/89/5kj0ohCy6BNwlrzDC5fB?=
 =?us-ascii?Q?i6XVPyeYA5R2oQ8osBuyyduJD/k+YRbZzQvMhcyFpcRS+O6aWhoUOq9Vilbb?=
 =?us-ascii?Q?hwm7zwQ0leo+Plr0IiOwhZuEm4zwNen+/2F5W+DUnvJ/QgE4cJ4OroXiuYc/?=
 =?us-ascii?Q?eXioauHOAMT6rL8sSRDRxfx49NfhVmU3AlAFfYYnJmFvs6vf6ra5HA82OarH?=
 =?us-ascii?Q?QKdJjUTGbmeLQDLRm05y+bgsbVG9FmYnTrpDDSnet8w5WCKmhD0SKViVCAvx?=
 =?us-ascii?Q?v9LkeUw6ADv2LFpV4Lb0w/YX36T2/N2c5i93qygrsIwVS3oyalxNtjIKOzZ+?=
 =?us-ascii?Q?f6PmbMcC1I/AY+62DpEAkHCExeD2qYMUIGJcXQ4k2nf6wdiuoMhnTqJ7MyCo?=
 =?us-ascii?Q?wjiJpcoojVtBkM94cmbw/6QMPkGFT6Z40qNKPzwIwUszZhK1dsEFNubh1Qk4?=
 =?us-ascii?Q?Xgxx?=
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4693.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2021 09:48:46.3302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-Network-Message-Id: 18c2f10e-dda7-4d46-c0cf-08d8b3ba97d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YFh9f2wKGCV3oI+ZPeTulSv9i8GIdZAKbfJYz+6QtCKqzl9HWC/saurmNMequgHwJp43Z6lcMupsjgMXvA7MmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4789
X-BESS-ID: 1610099329-111473-5632-27916-1
X-BESS-VER: 2019.1_20210107.2235
X-BESS-Apparent-Source-IP: 104.47.70.103
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.229399 [from 
        cloudscan23-139.us-east-2b.ess.aws.cudaops.com]
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

Updated patchset with fixes for enbling IRQ for 5GBASER and 10BASER.

Pavana Sharma (4):
  dt-bindings: net: Add 5GBASER phy interface
  net: phy: Add 5GBASER interface mode
  net: dsa: mv88e6xxx: Change serdes lane parameter type from u8 type to
    int
  net: dsa: mv88e6xxx: Add support for mv88e6393x family of Marvell

 .../bindings/net/ethernet-controller.yaml     |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c              | 164 ++++++-
 drivers/net/dsa/mv88e6xxx/chip.h              |  20 +-
 drivers/net/dsa/mv88e6xxx/global1.h           |   2 +
 drivers/net/dsa/mv88e6xxx/global2.h           |   8 +
 drivers/net/dsa/mv88e6xxx/port.c              | 238 ++++++++++-
 drivers/net/dsa/mv88e6xxx/port.h              |  43 +-
 drivers/net/dsa/mv88e6xxx/serdes.c            | 401 ++++++++++++++++--
 drivers/net/dsa/mv88e6xxx/serdes.h            | 108 +++--
 include/linux/phy.h                           |   4 +
 10 files changed, 888 insertions(+), 101 deletions(-)

-- 
2.17.1

