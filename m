Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB0D1B4AD8
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgDVQtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:49:10 -0400
Received: from mail-db8eur05on2047.outbound.protection.outlook.com ([40.107.20.47]:29032
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726057AbgDVQtK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 12:49:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IAOJqUpz3fzmSvRTr8Jaqa7UPXroj1TF7eHjuJ/94IlQEsLV/ZjAM06fLA1tCZ0ZRpz/SujHW9w0yYO/Wlrl95gq5wXQjaXBleG4UgagTh8soKLaH9U6MM7frel2EB4RhJC4zSVeM2A4D+/Kf2w6rLNYlzWupb9OT4wyu7w6+mqRKLqwn5Y+tjwZWYAPg2IKbEBgffYuiC49LXgdWVzfs3jL3b9qG5fRHZRWeoVgrd93Xtf7cnadjDFYRzJRTDOQiOZr08PNl4BzZRZvnQ6sSdOrbrzy5AiAnoUoDAzPNkPFH4ZbYsu5luPc/agSe3hTon3EMJkO3iNSpzJEf6j9xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+RND5TfOq5dAvNZ100Rj77k9nOAIqVBFtkXinD86ug=;
 b=WjO48N+FZ8M7CCRfLZ/ovqhX+Htn1JeLSKEUFWWq5a3BOVR8ec2Z4b/m0rZzldYhZYZSG+3Ta1EboBuWNNUsW1nNRLq+4KAWf+c2PddepfK0/um8ICOhjCHb+xGErpHKfkTJ+C/VAK1dLw1adv3wJ4Dx7GTmMRk5MGHMNXx/kiCUsSpWhxGO/Oho3kytMO7axRoP2md8K6CfbKUq8ZjJrvKHmso61GER5iF8W2WLtrk7Uj0N0r8ihsYr/0rUlPCkk86xAzSPZsmJ6ewooMV0tb89POa8R8axfveI3yb92OLQUEWP52p3nYZ2bX5721uRWdF5CUxCWGc9kZyu+FXukQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+RND5TfOq5dAvNZ100Rj77k9nOAIqVBFtkXinD86ug=;
 b=kkY2InSvv6nYRMtNto4RJ2y8aU7MsA+2NT4JL0n6f50nGMEoDQTgS453GuOiZDzpBWTiYzUHm1CTniX+ptSwvweeTESJz8obAJjSLDtt2UbeXbNgyFmhSI6nqfNJogBvIbDrzWohhSoinTAGDOCraZe1sUUogY1JA1h0j1MJF08=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3498.eurprd05.prod.outlook.com (2603:10a6:7:33::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.29; Wed, 22 Apr 2020 16:49:05 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2921.030; Wed, 22 Apr 2020
 16:49:05 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, davem@davemloft.net,
        kuba@kernel.org, Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 0/2] Add selftests for pedit ex munge ip6 dsfield
Date:   Wed, 22 Apr 2020 19:48:28 +0300
Message-Id: <20200422164830.19339-1-petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0203.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::23) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR0P264CA0203.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1f::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Wed, 22 Apr 2020 16:49:04 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0340ce00-b178-4562-7340-08d7e6dd119a
X-MS-TrafficTypeDiagnostic: HE1PR05MB3498:|HE1PR05MB3498:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB349803E47499739E9BCA5E7DDBD20@HE1PR05MB3498.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(4744005)(8936002)(66476007)(6512007)(6486002)(52116002)(54906003)(498600001)(36756003)(1076003)(6506007)(8676002)(81156014)(6916009)(66946007)(86362001)(956004)(2616005)(26005)(66556008)(5660300002)(6666004)(4326008)(186003)(16526019)(2906002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BvJOZ41Q++ONL2UYvIJ0pweJXs8g3zOmBoT1/5yV6UW93vpwdMyAYEAit1vhAeOaKqKUAwdvlvc4ffG6MEyrDoT/jHnO/ig1rQNJddZjA3BUyOEt8rnz1FsKPg9e/jmidFbPr6iWRDlXoh3YJ/66lqGZE1CIc36uYBjRXe9N1FQpzCphpa+jh4AdOuYAvg3ANVba5DM62fAjBbQbEDPhs7qlAJpYNlhKziizdSPuvNYMyZDsd2YoDCMfjiq/PLP4uIYTPtcvxC5pjk2NVfdAemPDOJyVxIgmSo8D1ELBu3oy1iZaFMA0bsvUDDRRZ1B0btbk3GpQSTnLnyPJi7JeiAkSSOgkUwKF21ZNEjAbORfZquHvsIKM6UMeFO/fuV++honHnzl9SgcSiiC+Eg2lN5NrbbY4Voi7/SKt6dSlsGJnchdmvD+cDwmVyXm9zENn
X-MS-Exchange-AntiSpam-MessageData: F1mT6kJ7dKIwgzikQM3cSZBuX9v2PiCFHmu7XMcy6ODAMZBrRcORVDf4EBYrTxRgTCzUVjk6gTNsbzFIM4iwAYLwA50+9NCVsuR8MDKywfZeQC9u49nAHKviuwyc5/Ge9BiUBg3oJHUsdwOKapVZ0w==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0340ce00-b178-4562-7340-08d7e6dd119a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2020 16:49:05.6268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kEUDeKM2sROF3MbXli4viOrNDA9WhbxdjyQPlbk/RqYVJlHlBpGscff78x8CNlWJse5yLC+AWWzWoXIiE9rhWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3498
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch #1 extends the existing generic forwarding selftests to cover pedit
ex munge ip6 traffic_class as well. Patch #2 adds TDC test coverage.

Petr Machata (2):
  selftests: forwarding: pedit_dsfield: Add pedit munge ip6 dsfield
  selftests: tc-testing: Add a TDC test for pedit munge ip6 dsfield

 .../selftests/net/forwarding/pedit_dsfield.sh | 66 +++++++++++++++++++
 .../tc-testing/tc-tests/actions/pedit.json    | 25 +++++++
 2 files changed, 91 insertions(+)

-- 
2.20.1

