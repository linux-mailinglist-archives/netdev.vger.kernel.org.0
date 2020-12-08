Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478DD2D28C4
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 11:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgLHKZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 05:25:22 -0500
Received: from mail-eopbgr770053.outbound.protection.outlook.com ([40.107.77.53]:19846
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726703AbgLHKZV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 05:25:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vl15DW/pL1SgflhdIpzRKXiEa6/scWkvBwenkD3iNKqZykIQs5KDDV6ysOl32taypUN4YUsSwAU0Fa6YdC1ZeYWL+ASc37at2+q9gg5lN5BtUZLpjDnln3/v5FEfhSN7lTDD3OqxDfQcHj8Su6h9oSRCGFE3LvQ+CXGo7AnTxhiHNQ3ri973Tl1/4P09kXqILp7xfcGxeQBzh8mwUVjdZ8Aak33yHGhEFfHhyirfAM6CCl/Lu/AXBrXmNkER5XgqEueVlrwR1OKl1Ja9nMfgdRuA1sd1H5yx4VnSlvNKPPXZaClpGdfgN0U26arosBqhOdBMj6hftG7ws/O8EUSLYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8e6zctXSGUb1wDry5ppQMgg4JK+zht07+rTm8+GyeEs=;
 b=HLYtn3GorW43KwlgWPXDQ+RLEokbYViaYCQSObMcjqloQ1gtTb9vRtGvEKKyVPZ9yKVN7bEKWbRdwpdQGSmt7QpF09ADhLHBJtsMUJuOYQZi1awBzl9/lMB3e3iAAmUnzrg0aIhfmd1KZMGR3vPXjOHIqPDD4k/plSbAAQmPndAgcnVuvB/5GtGWhKKH8UpU9WAOGjDnyoKAW1gQFBhW0E9y0C1e4gzrHwTyVhuEpOqW9dcmm+RvfKT3+1QR4goi8vKvXRvfgKXcCkQDnA4iMsF7FKP676l/1YQh0Z8ooEdqdBj+C+4vQE+/h1eoB4ner/eXh0N8s2Ajg2cc4AiqjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8e6zctXSGUb1wDry5ppQMgg4JK+zht07+rTm8+GyeEs=;
 b=aHv+lQWv8/DkVaKyLA2cA4QdjWlPZ9yZoE19YPj99hkULz1JkOmok+0ZHs/hzOLB+vXMDbDXHj0GZkWe53MELzHdQ7qG4wqlGIH3Ihxd4jbJsjHFrVff6d3bjcHk/S6ZAEjGSnzgVPniOYNb53m1qtXuxsxSDblbjZ7YWmonYNU=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=synaptics.com;
Received: from SN2PR03MB2383.namprd03.prod.outlook.com (2603:10b6:804:d::23)
 by SA2PR03MB5884.namprd03.prod.outlook.com (2603:10b6:806:f8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 10:24:36 +0000
Received: from SN2PR03MB2383.namprd03.prod.outlook.com
 ([fe80::412b:8366:f594:a39]) by SN2PR03MB2383.namprd03.prod.outlook.com
 ([fe80::412b:8366:f594:a39%9]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 10:24:36 +0000
Date:   Tue, 8 Dec 2020 18:24:22 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-imx@nxp.com
Subject: Re: [PATCH RFC] ethernet: stmmac: clean up the code for
 release/suspend/resume function
Message-ID: <20201208182422.156f7ef1@xhacker.debian>
In-Reply-To: <20201207113849.27930-1-qiangqing.zhang@nxp.com>
References: <20201207113849.27930-1-qiangqing.zhang@nxp.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: BY5PR16CA0018.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::31) To SN2PR03MB2383.namprd03.prod.outlook.com
 (2603:10b6:804:d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by BY5PR16CA0018.namprd16.prod.outlook.com (2603:10b6:a03:1a0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 10:24:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8080793-914f-416b-a71e-08d89b63763c
X-MS-TrafficTypeDiagnostic: SA2PR03MB5884:
X-Microsoft-Antispam-PRVS: <SA2PR03MB5884D7C3E090B78C38498FE9EDCD0@SA2PR03MB5884.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:480;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FF61DecXzwK+RnI73GdiBZ+n20godG9DMSyDkQK512pRhpBzOzVd6vTTocAMVTVywIVXZc30c4wvghvJeEkO/praFCO/+/GVnUNtQOPclU7h1MwvBugr87NnR3JnAbnFXLwiiI+aI9mxkw8UWWnf/ufqd4ZGP5adurJKv0ynL/wh6xJKGp2cyXb33ANk4eJPpXrZpG1nEVq15a4zHgQN0ef23LbRNble6O+HnuHv6JV8FWIGxQFiS+3yU9yqLenApGoQR0Gv4nlPybykaJ+3NOCloVfFMOo2QKSVzlZOvAoaeGrzrLmVxxfSqxCo6Syh/ub8SPNxNpiIHbu8lSYHAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN2PR03MB2383.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(2906002)(8676002)(5660300002)(26005)(186003)(956004)(6506007)(4326008)(83380400001)(66946007)(16526019)(15650500001)(8936002)(55016002)(9686003)(7696005)(478600001)(66556008)(52116002)(1076003)(316002)(6666004)(6916009)(66476007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Y4wMW2jDQYilhIXyI1UKxCnDvCa+JKrRSUidbYNPhenPADwFrfhU0hycdR54?=
 =?us-ascii?Q?BAe0ZvTqj0Aoqxp0Kjpx13FZ8gTuy56Rd1rgz7ffs5jQM16vJztZ4c9O6fTu?=
 =?us-ascii?Q?fxMnFa0Q6GLlDwO6oTXh4Z7Woh3+mJ1sXMx4HqYQ1SYqUbBqZDPGQJ4N3y/x?=
 =?us-ascii?Q?ysl/xCcBAMmRXRjMvyIi1J2MXskm5Vi6hmlD13I1AR7P6S1VX/xygZTRjXD4?=
 =?us-ascii?Q?JUcBirFB8/w1Bcgi7kLo+t7OILgjHJoEaDR+FjW8d4uOOW2Wh4P0PKsTjn1K?=
 =?us-ascii?Q?cNhg1aADok9sU49T+xhEZugqxq/S3y/HV3Kf6FbDO+uQI3wvebKU554D0CQW?=
 =?us-ascii?Q?mTd6uU/vmRqzYBlC3grJxn5/3V0c6uS5wIMuBhLpvgVzqiTe1o4kF5KugnlL?=
 =?us-ascii?Q?KeCa7R6KNbdWGSTtKlM2t6h+JcVyWd90mKIcvRfWOGAooDhWiOW8lwJ/dUgp?=
 =?us-ascii?Q?V2ojMlp81YID3KOwOtSPXeqsPy9HVNnt/sX7a9fCq2098SvHHunsqH/5d0MZ?=
 =?us-ascii?Q?iChqfzUQYJFLFG7ZsIwYpZWKVNlLpjgJttm1ktwEIwe/jQv2bKmdR5xPKd5g?=
 =?us-ascii?Q?TOkrFQDGqnWcbZcPqAbnpVNwAwuXyO/pdSQLRto/Iqun6Yw1gYmb1flXMrIw?=
 =?us-ascii?Q?su9jiIK2wxJgHmTQ1R72LVz3XzjPlNC5dFSOnYjvy/WS8+tpARE1YsrMMZlS?=
 =?us-ascii?Q?lPhZb83gGedtyrBW6xnGvWMNGCSzhFP5nCsnyN3o6R27RzERwVIlKNANbU8F?=
 =?us-ascii?Q?rTkYx/j3Whq4Q3cj8XqcWYZSWaQSerur6Dxf/bCIY2TIBLQs/8NFl4LS5JFv?=
 =?us-ascii?Q?LUdnoUg69VBcbedmDWDZeMGwOP0Ww/KbHH8Tww5RzRH4FCsXSeA74aG5LZ8R?=
 =?us-ascii?Q?teRDJ0GHCZ0hrySI66GG/D7KyhZ5oGdEQLjU/gBCxtEFAgupnwfa6kaNz3Ws?=
 =?us-ascii?Q?nQcWYhVZtRH0yLhzmolGekcSaDsbhlsaUuf6zOeVT8d71m+0FgzP47ubVPih?=
 =?us-ascii?Q?/+f6?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-AuthSource: SN2PR03MB2383.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 10:24:35.9289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-Network-Message-Id: f8080793-914f-416b-a71e-08d89b63763c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f80DMC4oHcZKghMe9EecInU8K23uZu0O3RCI23eddGdVO8OErIzz1VnrbQ8VTljvuu/tD6W3pKlW9H5Da3pt0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR03MB5884
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Dec 2020 19:38:49 +0800 Joakim Zhang wrote:


> 
> commit 1c35cc9cf6a0 ("net: stmmac: remove redundant null check before clk_disable_unprepare()"),
> have not clean up check NULL clock parameter completely, this patch did it.
> 
> commit e8377e7a29efb ("net: stmmac: only call pmt() during suspend/resume if HW enables PMT"),
> after this patch, we use
> if (device_may_wakeup(priv->device) && priv->plat->pmt) check MAC wakeup
> if (device_may_wakeup(priv->device)) check PHY wakeup
> Add oneline comment for readability.
> 
> commit 77b2898394e3b ("net: stmmac: Speed down the PHY if WoL to save energy"),
> slow down phy speed when release net device under any condition.
> 
> Slightly adjust the order of the codes so that suspend/resume look more
> symmetrical, generally speaking they should appear symmetrically.
> 
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c | 22 +++++++++----------
>  1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index c33db79cdd0a..a46e865c4acc 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -2908,8 +2908,7 @@ static int stmmac_release(struct net_device *dev)
>         struct stmmac_priv *priv = netdev_priv(dev);
>         u32 chan;
> 
> -       if (device_may_wakeup(priv->device))

This check is to prevent link speed down if the stmmac isn't a wakeup device.

> -               phylink_speed_down(priv->phylink, false);
> +       phylink_speed_down(priv->phylink, false);
>         /* Stop and disconnect the PHY */
>         phylink_stop(priv->phylink);
>         phylink_disconnect_phy(priv->phylink);
> @@ -5183,6 +5182,7 @@ int stmmac_suspend(struct device *dev)
>         } else {
>                 mutex_unlock(&priv->lock);
>                 rtnl_lock();
> +               /* For PHY wakeup case */
>                 if (device_may_wakeup(priv->device))
>                         phylink_speed_down(priv->phylink, false);
>                 phylink_stop(priv->phylink);
> @@ -5260,11 +5260,17 @@ int stmmac_resume(struct device *dev)
>                 /* enable the clk previously disabled */
>                 clk_prepare_enable(priv->plat->stmmac_clk);
>                 clk_prepare_enable(priv->plat->pclk);
> -               if (priv->plat->clk_ptp_ref)
> -                       clk_prepare_enable(priv->plat->clk_ptp_ref);
> +               clk_prepare_enable(priv->plat->clk_ptp_ref);

I think this 3 line modifications can be a separated patch.

>                 /* reset the phy so that it's ready */
>                 if (priv->mii)
>                         stmmac_mdio_reset(priv->mii);
> +
> +               rtnl_lock();
> +               phylink_start(priv->phylink);
> +               /* We may have called phylink_speed_down before */
> +               if (device_may_wakeup(priv->device))
> +                       phylink_speed_up(priv->phylink);
> +               rtnl_unlock();

This is moving phylink op before mac setup, I'm not sure whether this is safe.

>         }
> 
>         if (priv->plat->serdes_powerup) {
> @@ -5275,14 +5281,6 @@ int stmmac_resume(struct device *dev)
>                         return ret;
>         }
> 
> -       if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
> -               rtnl_lock();
> -               phylink_start(priv->phylink);
> -               /* We may have called phylink_speed_down before */
> -               phylink_speed_up(priv->phylink);
> -               rtnl_unlock();
> -       }
> -
>         rtnl_lock();
>         mutex_lock(&priv->lock);
> 
> --
> 2.17.1
> 

