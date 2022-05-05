Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7750551BA6D
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 10:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348951AbiEEIcv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 5 May 2022 04:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348963AbiEEIcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 04:32:48 -0400
Received: from de-smtp-delivery-213.mimecast.com (de-smtp-delivery-213.mimecast.com [194.104.111.213])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 996FB340E9
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 01:29:09 -0700 (PDT)
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com
 (mail-zr0che01lp2113.outbound.protection.outlook.com [104.47.22.113]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-26-72qKpnm1Nw6okGxsdzR0Zg-1; Thu, 05 May 2022 10:29:03 +0200
X-MC-Unique: 72qKpnm1Nw6okGxsdzR0Zg-1
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 GVAP278MB0151.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:3f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.24; Thu, 5 May 2022 08:29:02 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2%9]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 08:29:02 +0000
Date:   Thu, 5 May 2022 10:29:01 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Joakim Zhang <qiangqing.zhang@nxp.com>, netdev@vger.kernel.org
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        Andy Duan <fugang.duan@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fabio Estevam <festevam@gmail.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: FEC MDIO read timeout on linkup
Message-ID: <20220505082901.GA195398@francesco-nb.int.toradex.com>
References: <20220422152612.GA510015@francesco-nb.int.toradex.com>
 <20220502170527.GA137942@francesco-nb.int.toradex.com>
 <YnAh9Q1lwz6Wu9R8@lunn.ch>
 <20220502183443.GB400423@francesco-nb.int.toradex.com>
 <20220503161356.GA35226@francesco-nb.int.toradex.com>
 <YnGqF4/040/Y9RjS@lunn.ch>
In-Reply-To: <YnGqF4/040/Y9RjS@lunn.ch>
X-ClientProxiedBy: MR2P264CA0184.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501::23)
 To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 727cdc76-6f5e-4732-577d-08da2e714f5d
X-MS-TrafficTypeDiagnostic: GVAP278MB0151:EE_
X-Microsoft-Antispam-PRVS: <GVAP278MB0151178B1E199B2E7D561922E2C29@GVAP278MB0151.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: QDRz845+ZSepvpZ7nc7kVdYDy+lm3tPaM1cvEqHpdFlE2jkfV2+nAHWwmlXRyzlWDpoaIXGNGpSQuK91USgQw6BXhWkvvxCpzCH8tQ8vwK8gZworcFGPYBcayTftn8eS4xV9xXPX4XwWqQ8tiA8qv0KCpusY9hgm5XafDBfgPKvBJlZbCd417NoKwrjEWMXb83q97dqJHUU/aLp7sW8HjLP9ELdjTCCJ75GHS8Ul+VXeuvwEp6GoaRlVBuokV67UcmZbsgUY94xpOmh4mpjuhNTtJkiRZMws9H8t2xTRGhcmtCnITFdKLCve5be+deEr8ChAhZZZMsEC150Fz9xIC5WZqsNTHNqQJVQbp4g8rCPrURh9jCSbmFzunxs+N+UZfdjABvck+UFWRjNHxJV5ChtoVBDiIjzqJeSPIdcZnBO9lCEnZbWF+3zUGqd/BgzZ+rUPHJxO7V4NPFgfLXcVkh9cQ8TIjdJ4xh5i3/BkVFoe3z+1pqTnzB6FW1eeQfn9p3YV+iaKi3sEL267o+VX/Qxc3qMYkKZjqIeKYkYrbOSZgV1ZAE3ojXLqrFm3qO8+yDQZ/qs4IrzqENS/GDODAqfEA/4swUhJur42ZExRME9O/paT0MxWDloN9zjyi9ncaQpmA4VlZJnQ9LnR7jWYwkOEcT4S1XwhjmuCdni2BC8jWzyHPJgKFt9M4QT1GMj+1IVHoRANEGpMfsi+TQfcfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(346002)(376002)(136003)(39850400004)(396003)(8676002)(4326008)(83380400001)(6506007)(66556008)(7416002)(66946007)(33656002)(2906002)(66476007)(1076003)(6512007)(52116002)(26005)(8936002)(38350700002)(186003)(5660300002)(38100700002)(86362001)(508600001)(44832011)(6486002)(316002)(110136005)(54906003);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rcAKZBr3nJT809iUvkL5r4UzPZlMQJhXECOVmK6kJ3qHngK+nebjsU1bWjJd?=
 =?us-ascii?Q?AJJC+m4TylBWriNTPbQa7Das8CkivWJDzl3R/yAzj3AR+9mnWZiVgMbRAsW8?=
 =?us-ascii?Q?CEXfZ2DlCaVXdICUbt6AAI2YNAVJFi6XsdROJtp1Q80vGQRGg8wdUaqdyW2u?=
 =?us-ascii?Q?h5uKFL0X5/IyCssKG9jU+hTjwbLw0rB88vldE510wZ+ZbtOaAjtIpmwnlWQb?=
 =?us-ascii?Q?pm7rT7rpbuW9dl97gFr4FNWx4e4oTwoySrQBBTcoorrbFWuQqSvU2ZxSreft?=
 =?us-ascii?Q?wULYevY9pOiI41L/hRxkoMxDfQsT+hgJyO71DZlmtFrUojsGPLfqIkNOqjTa?=
 =?us-ascii?Q?BXdkKl5zaGCChWFY85C55bFI/wbULyMhQMDf18oX7vgKoP1fIOlbwrCz1Qwc?=
 =?us-ascii?Q?05H0OkE/7OwW986p/PZ6Ln/hwmY8uEyxuWuZKFEVOEq1SCU3BA+0K12KCP4U?=
 =?us-ascii?Q?B5rmXAGFEhTMm6If6KOZ0UwiClrpzrPDC+8jMUQ5T0/hDWC3qUuSf9WpmwVj?=
 =?us-ascii?Q?pBIvDCa/WJS7BTAZ097l+6tLrMi+bcF4N6CdwY6jymPIEsYdFNNxV4aZTRjO?=
 =?us-ascii?Q?1HiURgl5Rj+m6tAQDb+Ue6rjZdD6uzhXLNdhGusB3TPg7eVHXYKHkFfNTBxG?=
 =?us-ascii?Q?L22vXVpWQLJVsQR9dyIa+VuFP3xi5g7B1SRzi+grNmXXbwG/oFMmwjrXLlJ9?=
 =?us-ascii?Q?VtA8nuuXV+h8R1V0n8spT+7rH8+aNZpyRuCzNgQjrSL45KrGnKMwxJDGbVpS?=
 =?us-ascii?Q?AxFsxi57gRFaOD/Ypkx6Is2xrGJ10zUwMuYlIkPymSDn1Vi52a+nnER2yNNu?=
 =?us-ascii?Q?e49bMfCfBlBufDnfPBJVEZcGzFvHLQN3vV9mrvf93c4oJ+/u/Rb6HVeN94uN?=
 =?us-ascii?Q?NuOqJhIT5pi83x0aG2vBfC8TPUINKVYmv1mfaT9YdIyLA590Qs0Z5mRgl0cf?=
 =?us-ascii?Q?zjl174vU5d51hp/NU8ptJpqzsoUrb853nfYxtTHDFKnkl3RZn5OO72kYIA0s?=
 =?us-ascii?Q?i1x5Pw5vozc5cQQQVjF0Kn6Nfkp0nCkZxrnosuAlh0wn2xgmFIMvLtY9wF4Q?=
 =?us-ascii?Q?W41Pxmw5mIjC405rZacybm37z9zmHysLRnjdnnImH+5Ep62Vli3do/pNnsK4?=
 =?us-ascii?Q?6LCl4HJOASN0WQJPXP8TcsG3MyCm+KmJCtJiAXETDiL+YUrcI/4YjivVqQkC?=
 =?us-ascii?Q?0/prmyO6kbE/sim315uWX8nWRHxwOgHjfGCYoi+iA3FZJj53ENjl8lbi9l8J?=
 =?us-ascii?Q?mO5l0NN3olcwm0MnnGgBhX5RsMFcjrr+huzC8laqg3ToClV9hXNDFVT+9P35?=
 =?us-ascii?Q?H/ldg6UrK8FCgz9qfEstwbib22oPDIwHbcTy8CiUgvaYP33hNLhsQlV7N8qw?=
 =?us-ascii?Q?wjxYe581VkGK862pVwQmXSO2tvNJUr1dXe908jZKwe9aQSv9bjT5XBBxm8Jk?=
 =?us-ascii?Q?xF6QnB/URAWtzeuzKQj3/HD15CeDIdsiSe3kTLdInLLML4ZI/CKPv6H5zTho?=
 =?us-ascii?Q?PLcwYmd97nbN1I0pf4gbIsBKHCN8kav/FGTHadG392fkEkX2eIw0MWmHio+l?=
 =?us-ascii?Q?gOTCxFroLcZIE5KuiqFAGcTE6IE0ryi76qpNWm/dc7BLFrJ/9MONH176wcLN?=
 =?us-ascii?Q?/B7fTBPZ91vslbNuDT2YZUwr4fWuMkp2Ycl6OIHUw46v9KPy+cx0j/PL6hUi?=
 =?us-ascii?Q?XwtE6lwu/eX5saeip/QmgDonrx13UXG+K7gP0vjscjfqZ0fsPgkvJ3eTv6GK?=
 =?us-ascii?Q?p3GC8O1xO1oxk6lP3NQyA2WuFE14zQo=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 727cdc76-6f5e-4732-577d-08da2e714f5d
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 08:29:02.5140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KF5l0R0C2AhXfMt4WMAqegt4fjfbzjgtyoDUOAZpmKvHw29xjhdkta2H8awfcPWce3ZtiiYyikTAA3wIzBB3buOFv0wZT8Q3x3Mk2BlmfHw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVAP278MB0151
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CDE13A77 smtp.mailfrom=francesco.dolcini@toradex.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: toradex.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew and all, I believe I finally found the problem and I'm
preparing a patch for it.

On Wed, May 04, 2022 at 12:17:59AM +0200, Andrew Lunn wrote:
> > I'm wondering could this be related to
> > fec_enet_adjust_link()->fec_restart() during a fec_enet_mdio_read()
> > and one of the many register write in fec_restart() just creates the
> > issue, maybe while resetting the FEC? Does this makes any sense?
> 
> phylib is 'single threaded', in that only one thing will be active at
> once for a PHY. While fec_enet_adjust_link() is being called, there
> will not be any read/writes occurring for that PHY.

I think this is not the whole story here. We can have a phy interrupt
handler that runs in its own context and it could be doing a MDIO
transaction, and this is exactly my case.

Thread 1 (phylib WQ)       | Thread 2 (phy interrupt)
                           |
                           | phy_interrupt()            <-- PHY IRQ
	                   |  handle_interrupt()
	                   |   phy_read()
	                   |   phy_trigger_machine()
	                   |    --> schedule WQ
                           |
	                   |
phy_state_machine()        |                        
 phy_check_link_status()   |
  phy_link_change()        |
   phydev->adjust_link()   |
    fec_enet_adjust_link() | 
     --> FEC reset         | phy_interrupt()            <-- PHY IRQ
	                   |  phy_read()
	 	           |

To confirm this I have added a spinlock to detect this race condition
with just a trylock and a WARN_ON(1) when the locking is failing. On
"MDIO read timeout" acquiring the spinlock fails.

This is also in agreement with the fact that polling the PHY instead of
having the interrupt is working just fine.

For my specific problem just taking the MDIO lock in
fec_enet_adjust_link() should do the work, however there are other
code path in the FEC that could create this issues:
 - fec_enet_set_pauseparam() => fec_stop()/fec_restart()
 - fec_enet_close() => fec_stop() 
 - fec_set_features() => fec_stop()
 - fec_suspend() => fec_stop()

1. Should all of those be protected? Are these real issues?
2. Which fixes tag to use? This seems likely a quite old issue, not
introduced with the MII polling.

Francesco

