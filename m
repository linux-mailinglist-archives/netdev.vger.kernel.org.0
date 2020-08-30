Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063CC256CAE
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 09:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbgH3HuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 03:50:14 -0400
Received: from mail-am6eur05on2116.outbound.protection.outlook.com ([40.107.22.116]:63009
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726201AbgH3HuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Aug 2020 03:50:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KyONkyM9QkOifhK0Wv4P831FMcQPYV7eaFNh+ljUGd97IFsdwpW9TDLyy5DYVIAmWfAuQQ3Yxy17cxHCBOEB/tx6qMZEhtkjglgIZKOgURt4oGOIE3qimlLRGKtjyEbW9zZ7b6nSH9MDXMdk49Wd5LcZLuzp7mjKwnDcuWNsfIwEpXTW5jewmy6FSkVUk7tQksNEhF551+eQ3d/sw1auK6B6NCgmHEF7nlHOkHovkE5jH49ouAkbpN69ve+YSyNDutPffx5xUVR5eB7M3CJ+eqXES1klQTJQS8tKOLLehGj2Jsd9eKuZBIP5sXm6bVxFQZBkO3n6ft3L8imQ0XHPww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mjc6Qi9eQXSe3lEptsNtQrAdwg2qaURMF5tNmX6BeMs=;
 b=CpgFbIHS9ZxNq6SXJPAZJaa+PeoSzs3rZB0bhCPO2etPJenfuSWXDOhJec2TqAxAKb71F+IZCXjU/atj3D3NYLfgc4UwTkHrmYmCPvCorYEPH7p1e2OCOklikaBu37MmMV6xer00OlfN6PV07fJQVEq8IXg4FLFNcSAmtUrUhVbKnUIvZPNK3hIwHPobDjr+s5dUT/8Eh5zWMPJKIAvwvLJ7OL4ZqO/3Z14StYbP51vOWriXVKvfCNirmO5eBE2PkZ1PGdhOlnKX0rr4b4EcsnzfmfIed9D9z8PoLIAJWk3YLpy97USNdRuA0N79cF68Kv+A+By/ne9gdMEkbDuJgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mjc6Qi9eQXSe3lEptsNtQrAdwg2qaURMF5tNmX6BeMs=;
 b=u4+TwwpLAT+1BpMcIJyTzgQzT+oxdjCpuEKDEWAK4bkBC/k1CTavuUZrriC7oB+k8aghuQwVM6zbjzG3+Kev3XYHavh0L4fez86Zspi51ag4MIUPxbcSyAaqJAnCw41TT5rsXd5BRe+vkH/EFhKSuE8iT5jrvscRGXN6dgOpe/g=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0185.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:cc::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3326.25; Sun, 30 Aug 2020 07:50:06 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305%6]) with mapi id 15.20.3326.025; Sun, 30 Aug 2020
 07:50:06 +0000
Date:   Sun, 30 Aug 2020 10:49:58 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, jiri@mellanox.com, idosch@mellanox.com,
        andrew@lunn.ch, oleksandr.mazur@plvision.eu,
        serhiy.boiko@plvision.eu, serhiy.pshyk@plvision.eu,
        volodymyr.mytnyk@plvision.eu, taras.chornyi@plvision.eu,
        andrii.savka@plvision.eu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        mickeyr@marvell.com
Subject: Re: [net-next v5 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200830074958.GA2568@plvision.eu>
References: <20200825122013.2844-2-vadym.kochan@plvision.eu>
 <20200825.172003.1417643181819895272.davem@davemloft.net>
 <20200826081744.GA2729@plvision.eu>
 <20200826.073446.971357864812593855.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826.073446.971357864812593855.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM7PR02CA0002.eurprd02.prod.outlook.com
 (2603:10a6:20b:100::12) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM7PR02CA0002.eurprd02.prod.outlook.com (2603:10a6:20b:100::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Sun, 30 Aug 2020 07:50:04 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1499e905-61b1-4dd8-6cbc-08d84cb94f4f
X-MS-TrafficTypeDiagnostic: HE1P190MB0185:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0185C819E6023E897968090F95500@HE1P190MB0185.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8vRoxmkw7AR8iph8/6gTvBLouTG9+yBi8yT8XCzndGoEYOfBY++44ZpYIvBN+cbAm94gSDWASlgWNhCtJXVm1kPwFXmBm42gFH9YdmGkTFCu4wphS69nn1L/3DNdasb6XMAg4Kb3H6BycrUv2/EuTCtGqAmjJBrqFtBWBVqW4DRVamyEdnG5xT49DaS6+9tSuvqy3q5Qt+s7613hwQ04WDOiCCKB9QdtHdRnF8x9hyZ8nXLAmUs4fBbO70wTOhtBOIIL/n2kpDYvuQgOdH13cWDqF4tdtQgUmGT11twsf/jf+hm5QYq3v/ZyuoTlil4Qy/l+EFKokKlE4UStGDodzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(39830400003)(136003)(366004)(396003)(376002)(86362001)(8676002)(1076003)(8936002)(55016002)(5660300002)(2906002)(4326008)(7696005)(52116002)(36756003)(316002)(8886007)(33656002)(66946007)(26005)(66556008)(66476007)(6916009)(16526019)(186003)(2616005)(956004)(478600001)(83380400001)(44832011)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: GhFYvc706wn9eIseFpkbsUQXl8h8VXUhMZDIAQsCuYl0GoHkRw9mL5fnF2GfRPD4StRiIS5jGR1CdHyYHHIiyvp7xPfQLSR/i2MiW0RQj0PoFoB2U1Vfxak1FyHGvbEIgHGMFkFY47Q3RHfYggJu922nMFPWFFLiN5mF9gC/zotKM0hDdJsFiEa984zeiEvtxJsQg07hPbxGB1ysnq9oVQLWoucUE+Prhbn70OyDnA0txbP+1zzxlIxNBzQg7qmJ/KFHn2WkAisCm8+JT2/FXpITTUTGTOV6Ogm2afumJVp2f/nPNJ3QiGBjf/odETokvgjqMiCQtgV2c3ubK461346E5EmQDzYShQ0N/4yS/uVZBuMC+foVI3U2Ixo3F0CGlpiUncxqNhHL5TCEh64cxXbMvKmWGGF/yaH76MBjj75znCKo1zosHScIzvFF+0te9bIU4uUgVr2c+E6ymQN4sq+9FDryapb+1G/9RYRz4UCkS7gGCw3Br/qOZ28w5DFL/d6eOehk1c46I3Gnn3ViuPyLsZEsotekAnuHQ2uNkiuybHHHgBzs7YnoZCTdvBEu/rOcJCQFfAsDWBlEoWD2+kUDp+JEHh2DjbvyMLXTdjKdx3+2HRR+Ex6aai85KZTRDT8Gj55ivaol0sRQqq1xJw==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 1499e905-61b1-4dd8-6cbc-08d84cb94f4f
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2020 07:50:06.2037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cSRZGrPUkU1WrL8gt7jmPkCBAD/MjYwjgwt4DbOJniir3etbOF6UaiGAurGl4OlhcZFHMWhpdNZVjAzqDqfbNaFL7Z3MsbflrvAGY4m2EpM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0185
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Wed, Aug 26, 2020 at 07:34:46AM -0700, David Miller wrote:
> From: Vadym Kochan <vadym.kochan@plvision.eu>
> Date: Wed, 26 Aug 2020 11:17:44 +0300
> 
> > Initially there was (in RFC patch set), not locking, but _rcu list API
> > used, because the port list is modified only by 1 writer when creating
> > the port or deleting it on switch uninit (the really theoretical case
> > which might happen is that event might be received at that time which
> > causes to loop over this list to find the port), as I understand
> > correctly list_add_rcu is safe to use with no additional locking if there is 1
> > writer and many readers ? So can I use back this approach ?
> 
> Are you really certain only one writer can exist at one time?

Yes, list_add() is called on:

    prestera_pci_probe() -> prestera_device_register() -> prestera_switch_init() -> prestera_create_ports()

and list_del() is called on:

    prestera_pci_remove() -> prestera_device_unregister() -> prestera_switch_fini() -> prestera_destroy_ports()

in all other cases the port_list is used for port lookup on rx or when
event is received from the fw. So I really think that at least RCU list
API might be used or rw lock. In early version the ports were creating
before fw event handlers registration, but in this version the ports are
creating after event handlers are registered so it really needs locking.

Regarding DMA comments, looks like I can get rid of those bounce buffer
handling because swiotlb can handle this ? In that case looks like just
DMA map/unmap and sync should be enough.

Regards,
Vadym Kochan
