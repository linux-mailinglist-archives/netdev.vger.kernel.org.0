Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8EFF29CD2D
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 02:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbgJ1Bih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 21:38:37 -0400
Received: from outbound-ip24a.ess.barracuda.com ([209.222.82.206]:36828 "EHLO
        outbound-ip24a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1833079AbgJ1AI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 20:08:27 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175]) by mx4.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 28 Oct 2020 00:08:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ll8p98a/GG6zJM8SPdZ2P2RJc47KAG1isqgAX0ggeaAgd112p1XQnh3yZpz3kOhPqhUUop/AGkIVDaDUWpWumGimPiYE1eXVH290glK9tdq765gpeTIuBKFMf4q8p1/0uARxBhbvwHxTDiKm7LQVN9TqzCGlUoFP0Lz1CA1ZPlxVzq4r19H2QBEUvnYr+u2+aNdWKhAldUEVX3fZ1/tGdA8nF2cefpuPvvmjXGqd7joGGdUvnOJJq9pou0/Me9KxVtwbkW6t1E2gNGZTZB5kT2SqqlJnukZxkauZW3a2b/NkIlDCAPrAZW8ALVs1S4mq2nUcse6PeZxTx2r6AeB6Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zrv5a7Oqe1B5fH9p8PXSYMSFe++nHvUljFiZ41v+VhY=;
 b=LArhyGkgnFeFqeKsbFR59HIF2lE6G43hIPO1P+7jjs3q/HDW1kz1fM4ZiJXAGFr9MmW2iWmNJoCTMaQNVg1IQsBVMfMZ0T3iF0LtihH727vLuDAMMJl2I5nHtYjPYXGGk83bo612qDfyk+5WtEsKsHB1O8D8H2nLYvHPYu9Ep8QjFmL3hYehIcyAxXRheq5PX9XwrquSyab5fgWncEj/9zOP4f8D3LKgJgs3i3Ep+GS85hB/1uVmmxrzJfmPgzE/cU4SQeF9sNJT6bzR1WJLtMEJLiUPIc4LNsCxyg73ja7MUgmbiAbQsOa7mi+dLG74pE4FRL6hCOS2ncDjtdzCUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zrv5a7Oqe1B5fH9p8PXSYMSFe++nHvUljFiZ41v+VhY=;
 b=YeYRhhTHrM/I6oAVvLT/EUUDOzmRTGePRT3jLHYUvJiCapkjPm/NTucA2Eom2j1tjpQ0va6yvfQcex6bfSZ0gxrdhDD60ZwDFB187O9IyZanXEw4Z9ZiTT/pXXB+KgtchnV6LsagtGgQGVNUFdH0vVpxHAyozDNlOLdYMCMOF/4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by BL0PR10MB2819.namprd10.prod.outlook.com (2603:10b6:208:74::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Wed, 28 Oct
 2020 00:08:13 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%8]) with mapi id 15.20.3477.028; Wed, 28 Oct 2020
 00:08:13 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     f.fainelli@gmail.com
Cc:     andrew@lunn.ch, davem@davemloft.net, gregkh@linuxfoundation.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com
Subject: [PATCH v5 0/3] Add support for mv88e6393x family of Marvell
Date:   Wed, 28 Oct 2020 10:07:43 +1000
Message-Id: <cover.1603837678.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <3746c90e-a3da-5484-2a85-a1bb6fa926a3@gmail.com>
References: <3746c90e-a3da-5484-2a85-a1bb6fa926a3@gmail.com>
Content-Type: text/plain
X-Originating-IP: [58.84.104.89]
X-ClientProxiedBy: SYBPR01CA0007.ausprd01.prod.outlook.com (2603:10c6:10::19)
 To MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (58.84.104.89) by SYBPR01CA0007.ausprd01.prod.outlook.com (2603:10c6:10::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Wed, 28 Oct 2020 00:08:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f38377de-5504-4902-cf3b-08d87ad58fa9
X-MS-TrafficTypeDiagnostic: BL0PR10MB2819:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR10MB281945FD896948C6018B1EE295170@BL0PR10MB2819.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8J6PtjQIpKZGX+aNhmv2ROhDpPAgJD7P6gUBoMQJnt2lNOsvAhbcxNAvvAgRBF+HzYTaxp2UmZ9YIbpXNpDyIL9oXcGfBr5YG4pAoRkFGZzJbZkaC5JtL+sI1OaFtLB6UjFP2CN/aQ4ce16uWLNFHcnqjPOfiqFIWZ/M/u3KKXuU65GURE0Vf9+a3kS6VpCa0DEkayECStlncpQUU/ASsl1GNsff+ZiAy9wXWYZXkmdZ1wFHW/n4Q4J7QiareIln4G0Dxv0kFkxTVzM9mQtv72Y1ycFHy1qmu6DmX9z4ZOtsHfGDJuK+k7jhqLLvgl98sm32Lu6DB8ljk/Zg2RNrEN72SaM8mkJ+WhKVv/Oa+36hV8RXbncP/Hu+GlB9NQ1i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39850400004)(376002)(346002)(366004)(52116002)(4326008)(6512007)(6666004)(6486002)(2906002)(478600001)(44832011)(956004)(316002)(86362001)(36756003)(6916009)(66556008)(8676002)(66476007)(66946007)(8936002)(69590400008)(83380400001)(2616005)(5660300002)(4744005)(26005)(16526019)(6506007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: AWLLbZyN38fEzZdWtlXc8rsXJdnFNvYq4AK3bUpCaTPESxbyF1BHXW8P+lRIXmIK259II1XMYV+g58n8krGhOtIgZjthMBl5N2I7FTPqgxH2dXo1FVFqYDMeoXGWa5Dmuh99H1GvwgChJ4QuGUOsYQdY+K6tQn9FDiYuEOnv3G0WDWZRPZ3St58Rb2IRxBQddSqiP2MNmskZURwh4ZbTfYwYgiCdn1lcNwaL9i97jyEkhiJAt8VnzccgzrPS38o80kGtk5IOxtW2C1SYdgJRoNEKYxwXnl1vFxpxhlTcxWQo936e40tMivNR8Z++4YDmbspKTlbdq/0hK5PAah728IrMszWWAfg78PcZXZ01icPciB8rIkE/Fq4pRoTMeld6z61ZtdrKRDduD7w5lIvTBa8gnQxN1neWAfP+cfa6ZZYhtNGVS+dm84oE2FO+cGuCcFBhL/ksdBUT8Zlt1OB5hBg7o7qI1Hwv5DZ4g3SpLsChrbVD+36fUtdkXS73MxRUsS2AlbrhgEdAP/nXCYiMHGP/Fwcc/lpJCTNlO9YqIovksbykg+gjxwPIy3jX6OUvm0bJ2R7AHh1HKaK4ZO3cizFRv9E6vFudDCwJEuZMs5eddNkYEZ7iOac/85h93KwXd6ryl5Hwp54ptznNrtmrwA==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f38377de-5504-4902-cf3b-08d87ad58fa9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2020 00:08:13.4746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LywPOimY0zV2/ok0uvts947HOZFUxJ7l2fWYNchWoguSwAHsl5P1f6VMEMyMHrrs66uriEi/5h8pLKeG9bBmUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2819
X-BESS-ID: 1603843695-893006-27624-111482-1
X-BESS-VER: 2019.1_20201026.1928
X-BESS-Apparent-Source-IP: 104.47.58.175
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.227828 [from 
        cloudscan21-22.us-east-2b.ess.aws.cudaops.com]
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

Updated patchset.


Pavana Sharma (3):
  net: phy: Add 5GBASER interface mode
  dt-bindings: net: Add 5GBASER phy interface mode
  net: dsa: mv88e6xxx: Add support for mv88e6393x family of Marvell

 .../bindings/net/ethernet-controller.yaml     |   2 +
 drivers/net/dsa/mv88e6xxx/chip.c              | 119 ++++++-
 drivers/net/dsa/mv88e6xxx/chip.h              |  20 +-
 drivers/net/dsa/mv88e6xxx/global1.h           |   2 +
 drivers/net/dsa/mv88e6xxx/global2.h           |   8 +
 drivers/net/dsa/mv88e6xxx/port.c              | 240 +++++++++++++-
 drivers/net/dsa/mv88e6xxx/port.h              |  40 ++-
 drivers/net/dsa/mv88e6xxx/serdes.c            | 296 +++++++++++++++---
 drivers/net/dsa/mv88e6xxx/serdes.h            |  89 ++++--
 include/linux/phy.h                           |   3 +
 10 files changed, 732 insertions(+), 87 deletions(-)

-- 
2.17.1

