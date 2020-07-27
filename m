Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089F522EAB2
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgG0LGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:06:03 -0400
Received: from mail-dm6nam11on2071.outbound.protection.outlook.com ([40.107.223.71]:44641
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728477AbgG0LGB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 07:06:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8pP8L3UEnGBccQIJruBnSxi4QojAjaLN7oOEqToFVmkX5n9otTyOcXYu6joYysr3aRiJVmfhRzBlgk3flzzmYix0To9LeuvMOHMuSC3Ps9/qListt/IteIgcbl4inHjvAU+DHSDg5edbd95L5rCY+gNu45rFgvwwpsCxPkBbkZq5SdkcecQCoTjGesXqTLz0EnHW4NvmOKLREa/34DcUY+moAWJhUfwF2yBZ1oBBAHEPbFguIBRnBEjvhqqx3YPxlgG20YVAD+J0T7DaDA4xxKwtq0witMygxbOjoIWWLb+Rout3oFdfd+o40cVNPwouhsTisHa0/cZcf+MGz1OuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1A7sHR8uiWBtmOF1hdFHvxyW6wgy3YDB48gZ3sURZhs=;
 b=aXgAWamQP7kR7ZTCEtxvoj5NOkrE9ao+EYnF9kX13zYaU935NEItj0JDKjMM2O62YVIl1EeCCVENvDkFEaS9gGXn3YzzbUdzAlp5nr6Ua9saC8XlLtGC23lxZHuNNf2WCOoZJzFYKKiDoIiECTgbo8xTRpCyn4TiMkfK1V+CUtGqkqJc3JQa5Bvf5T/Vu8fJB0DUIHPRBAW4v9wYj0WmNrvON8FPXLjD1n1OIvM7EMja8SoLywY4Rde1Ni5BHVsWZAaH30Fwmu0xBY5087Ww/i9qXrtsB5QitCqukfmae38ppjCgJ4xPvuPvbAvfM1RgXMb/mkWaDQqxH9dxe0/g1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1A7sHR8uiWBtmOF1hdFHvxyW6wgy3YDB48gZ3sURZhs=;
 b=C3bFz2EL+8OeugftTG01Ifd1eu/G7wWlbuyAzNNnMykeRE60xO07e+t2blU30nEdFgphHYCneQk1JYVDRfxhqwy2/8j512GE9uKZLzfTNOnOFt7go0QsMSO13oWMH8pBwvzyhvxL8HQUhiPAtQ7P8NWvUJ2lIUXPEw0dZDAHY2w=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BYAPR03MB4198.namprd03.prod.outlook.com (2603:10b6:a03:7e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21; Mon, 27 Jul
 2020 11:05:59 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::b5cc:ca6b:3c25:a99c]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::b5cc:ca6b:3c25:a99c%4]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 11:05:59 +0000
Date:   Mon, 27 Jul 2020 19:01:07 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] net: stmmac: improve WOL
Message-ID: <20200727190045.36f247cc@xhacker.debian>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY2PR01CA0012.jpnprd01.prod.outlook.com
 (2603:1096:404:a::24) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TY2PR01CA0012.jpnprd01.prod.outlook.com (2603:1096:404:a::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Mon, 27 Jul 2020 11:05:56 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc3e2fe7-3a40-4d5f-3b01-08d8321d0ad3
X-MS-TrafficTypeDiagnostic: BYAPR03MB4198:
X-Microsoft-Antispam-PRVS: <BYAPR03MB4198BAA3936E6CDAE1A4D5B5ED720@BYAPR03MB4198.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jPwKJJfaQ3ukUOMqnMvpbZjLIjAkKjzqmpjfgtXyfbtia37ZUR4uDOjZL67A/h62EBk6Lrz7ys7Mw7w1gJ+7qUH3AsRrl/ovG88Mz/RrL8oLFXaivNcPkjq81HPo3mkPfS8UHZkicakaO6Xn6QI7fCIWj6ZGCWm+HVySXIuRyrggivOJLaMD6nb04TyNzFNJWX/ItWWffuKgdORi0t32GxCgQuh02ICDZnybFS2CsHKFLWdwWbTDrDIg/g5QNu0AVeZCDq4JUZ8nxaWNbxjE+QRn+6OI+IqPgSqwn7lvO9gsxu7TvTMz0WIxxuLQrR8J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(346002)(376002)(396003)(136003)(66946007)(66476007)(66556008)(5660300002)(6506007)(55016002)(86362001)(52116002)(9686003)(4744005)(8676002)(478600001)(110136005)(7696005)(316002)(1076003)(4326008)(16526019)(8936002)(26005)(956004)(83380400001)(2906002)(6666004)(7416002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: aeQngkP+Aia67IILNklrGXdaycb/knf/efRBWVM97JkEcgy0QtN197Y6T92xzUmdbbfGExGzoA2mjQ8YiG3vkG4WFXNO7SA5lTPb8JuQUwUlHlVppnxIjkxbPR4zgZlzogQMLEM3q9xgkm4VsUhQ61LDoIeSsgLJfBk8jnJMB3ntHv6vLCsvXiVWWT3J9O53UvAoowawL33dE6fanSabtsVjm7IpxHlVj9GhNpDuvyn72+yH5WYV2g2oB0L0HpMMa683HXbMkiOLsvpm3M+ZOni6vUKDnYKOeJN+2WQwTFfsPtqJbG0rCazdBnzLVyyUeyJ7CqzbHHIgeq+QQamibZxUhbFeo94cV+f6imQwQkDpBri467yWDHSTV2aIN0c80dAOfWr+FRNmvU7zwFbvQG2QWDL9eibEIjZlBnlEWFlTqfU3vwGW/AGw7jtc1Qaflc95zWdjxjn37Lox/pkIzT1c3NOeYCPbjMBMqpH8CQQLybYFAIrKSqBztdtjE1zh
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc3e2fe7-3a40-4d5f-3b01-08d8321d0ad3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3573.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2020 11:05:59.2849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jRatiSHMnpA+xtcLLtUb1k/BKAz7JaIA9v02Cv9MVdHj6bi6JTqZZMWR9xBNA45dPTqmCRnFVNpZXf04Z81xwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4198
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, stmmac driver relies on the HW PMT to support WOL. We want
to support phy based WOL.

patch1 is a small improvement to disable WAKE_MAGIC for PMT case if
no pmt_magic_frame.
patch2 and patch3 are two prepation patches.
patch4 implement the phy based WOL
patch5 tries to save a bit energy if WOL is enabled.

Jisheng Zhang (5):
  net: stmmac: Remove WAKE_MAGIC if HW shows no pmt_magic_frame
  net: stmmac: Move device_can_wakeup() check earlier in set_wol
  net: stmmac: only call pmt() during suspend/resume if HW enables PMT
  net: stmmac: Support WOL with phy
  net: stmmac: speed down the PHY, if WoL used, to save energy

 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  | 19 ++++++++++++++++---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 18 +++++++++++++++---
 2 files changed, 31 insertions(+), 6 deletions(-)

-- 
2.28.0.rc0

