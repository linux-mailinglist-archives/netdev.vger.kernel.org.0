Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCC1195D36
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 18:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgC0Rz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 13:55:59 -0400
Received: from mail-db8eur05on2063.outbound.protection.outlook.com ([40.107.20.63]:40096
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726275AbgC0Rz7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 13:55:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B71YUNIN2tozomcqs9HVwAlmtbLTczlL/0Llo3A94WPw9UJT47w/59Qzodb/5q90HdgfpQZEsJv3W+wNp5aslU1gZEPFd6vf4WaSuRVdnhUUXpU+2xh1v67+KnjZ+gaSLaBQvU16QxGLAh3jRVcA2j1VP9zbl7eqg/pGMTK1uaB/pySlgBtbIsBc3HbtubbOIyq7ltqXtjCet3zdEYljn/wc/SymawckXF/5WpAcc0YkxASLizWunoDOW+vmyDfiMcNxhBcOXu5Xi9xr8JoD1NToJHxVrxys9NJ63fZptU09pXbeUkRPHJH3soeOFSrBoRju2O2t2CJPmgIO/BACVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2MbupAS61cPH/g0WSb0ac5KKTcFCU/rg9uI3Fhn+pE=;
 b=eqq5zVks/mghNGBYu8qKhFdFX2Cd4J+TJTrQJwEokjIwDTfxvNuw0Ed4wwCKuzjqlSLImS+OZV9rnfLXYNVEIdeX1WaW35ZdoLcI4q+Fav92DKmeH8lwDTbe9OQ/jqYTqNfQ8hvbocbLyB/pvOxWqGH96sm0AYySWNfle87x67QYbik7mR46BNd8qfnUUxR1L00/vejsdCtIEA92mVAFXEMYu6wJ2i3ZXgpk/8frb+hGPXco7p86X1t+IeIABWf26g/fdmsWrEBmlBCr+7kog45i5oPFl4w6UsQWUaGfRtkKgJpOkDhqQhy2UJsTeXZ9GP22ETS8LDouVcOvH1eYFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2MbupAS61cPH/g0WSb0ac5KKTcFCU/rg9uI3Fhn+pE=;
 b=UbShin/KHQgHs05s01h0IORlRs1tEZ98dQSMHDQixDGNH8bs0Wp9nnP9QKX4c8dIMfcQJQqM096kDbXThofMC0hP2tOwOrzwEVLi004O1+6GfC0ngNyrOUQDrUHF66A3qe8I+yuEOwc4EA5ctyyrkv9CC63LWQDYfa8CZ2xZPnE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3402.eurprd05.prod.outlook.com (10.170.244.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Fri, 27 Mar 2020 17:55:55 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2835.023; Fri, 27 Mar 2020
 17:55:55 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next 0/3] Support pedit of ip6 dsfield
Date:   Fri, 27 Mar 2020 20:55:07 +0300
Message-Id: <cover.1585331173.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P189CA0019.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:52::24) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR3P189CA0019.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:52::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Fri, 27 Mar 2020 17:55:54 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 35ebb347-255e-495e-c6a0-08d7d27818da
X-MS-TrafficTypeDiagnostic: HE1PR05MB3402:|HE1PR05MB3402:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB340205B5B1BDBB011239DB5ADBCC0@HE1PR05MB3402.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0355F3A3AE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(376002)(136003)(396003)(39860400002)(346002)(6916009)(26005)(2906002)(66476007)(66946007)(6506007)(8936002)(36756003)(86362001)(5660300002)(81156014)(6666004)(6512007)(66556008)(8676002)(81166006)(316002)(186003)(16526019)(2616005)(956004)(4744005)(52116002)(54906003)(478600001)(4326008)(6486002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WH2p29QDz3RNF+OP/JQCp/QcB9SLOHC0yA+JSTXBSZlHbbSCjU1o5v0LVu5m5oIxZNu7RH1BVCYynHOoPwBYlHUb5RRIVFuCzZo0rtF4ep0HoJ5bEvX14pOwEzUOiZjP3pY32sQBepZ4fdakAk8a/mb1B0/oer3Z1Zl+Ux4+qwDmT2ILJiXWabonnpATLfGyFoh8q+kMVrC4ifCqZlGgqL6f/GBcNRfkHEQ1x5f7mIwpLW4FglcQfiq+13V8FsHb6KdEblrbyef+BA92LwPCLKsCEqLjeYRQn1iUCq7XH75hAVOTmBad3CopmcURgR6FhOrEpddeCIV9hTuL+MKHRrW/DURDerRqPNUYgaAcmN+6UthETs9HEH+5ofoJ9pcaCoJLoWpbXi97ZZqv/uAeJTYzPXoSvqt74F4UnZVpdr3Dyzf3RKqS7iItCPBy96Tg
X-MS-Exchange-AntiSpam-MessageData: u+YHF+kxol3Pe+sZki7z8ZIM8yXoOOO8Yu+i9sVIhrNGvx+DtWLKji+IGremBVEunSUN6GM6bOlCNK5yR464Fum8M+s3filKsoMEvUvef3TzY3SA++aXMZ4DK+mOgJsXRurLQMy335XwcEv9sFiP0g==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35ebb347-255e-495e-c6a0-08d7d27818da
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2020 17:55:55.4042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8smvVOIyfYsr0LNpWsbXSfgtTHe/8h35Y9BkFBWOrVc0w9hzxlmXx3NA81A5NG9RF5RIR5w6bwPqIgbJaQ6KKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3402
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pedit action supports dsfield (and its synonyms, such as tos) for IPv4,
but not for IPv6. Patch #1 of this series adds the IPv6 support. Patch #2
then adds two related examples to man page, and patch #3 removes from the
man page a claim that the extended notation is only available for IPv4.

Petr Machata (3):
  tc: p_ip6: Support pedit of IPv6 dsfield
  man: tc-pedit: Add examples for dsfield and retain
  man: tc-pedit: Drop the claim that pedit ex is only for IPv4

 man/man8/tc-pedit.8 | 39 +++++++++++++++++++++++++++++++++++----
 tc/p_ip6.c          | 16 ++++++++++++++++
 2 files changed, 51 insertions(+), 4 deletions(-)

-- 
2.20.1

