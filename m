Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC52E39F2E0
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 11:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhFHJxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 05:53:13 -0400
Received: from mail-dm6nam10on2076.outbound.protection.outlook.com ([40.107.93.76]:59680
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231259AbhFHJxK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 05:53:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YQA6PCcaO3BzgEyRhznnU9CJ4jQX8PoCiytqzsJOv1j69S90hNNCp3QmmX71G7/hE8j9qSIQ65niM60A1CJ8M2oWNotLbrTBb4LlYsqmW1cRfLhe5O/eqBQy2OZIuJB9oynftYyhalVlfnJx2zzrkF0ZWHl4DTk93ybX9f5MjTc8YFjOwP3awtsLZJdnugPVSkskfU3n5KOFHkNcsw3BwPGwZgVntr1ciB3xIYwioflJzYI7lvJT0ZM2F8m5Jgvs/SJH2f/7sSGnuQLJ2tTwacemVAIOubyay8IS2L0nfw87V+/WvDaTWUciADYbhZcQq7DdPoJaF8cQuVRi37WHTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q85lmeONf4GDrPJgXGsBEkGLbuNpc5j3xw1yeExahzg=;
 b=PJC6NnUAFuI6IsAMrm6xMI+qcj2lzrgq79uL1WUiK2xVg+oYI3vdajcRYIKW1B+ovGEQd0/K7UufuSL1Ws8viSlkv7YDZ6PN5eAAi4w9dkJUig2HJzj59GH7hGkfDNn2h3GpLUOsmRDOlIMktvz5AG6DkjnZ4mj3BlIQVAX5u6LtducoJTiUmyvbveVVDYGso6DYuxk5CaMOjQK5+M8G4yEcW2we/OU8piETwnSTazTbhb9uzJ33sfTkjdHFxh7V5on7svmwgHebpoNPHSUD4T9ijTiJK2x89jc/tfDI25Kvdnv/aEvsHRT5cSv3XnyDjqSP80kKW0IIKWPBQqkMQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q85lmeONf4GDrPJgXGsBEkGLbuNpc5j3xw1yeExahzg=;
 b=bQzzCQMbPfABwvBbctUjF6cI1nc97j9uD/ZMMXCOOj3iZ+/uMgc7mt5X5F+DJoKy/w+E8aYKJjbAeyT4ToG7ZOoaDnI2DENqJ+SbAWQOPKNl+YUsIo+CoJbfKZzkTLTflGu1MAhV/otJn1AvxUFKOmELyyPEoqbc/izJkXELRZw=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=synaptics.com;
Received: from BN9PR03MB6058.namprd03.prod.outlook.com (2603:10b6:408:137::15)
 by BN8PR03MB5012.namprd03.prod.outlook.com (2603:10b6:408:dd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Tue, 8 Jun
 2021 09:51:16 +0000
Received: from BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::502a:5487:b3ee:f61c]) by BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::502a:5487:b3ee:f61c%4]) with mapi id 15.20.4219.021; Tue, 8 Jun 2021
 09:51:16 +0000
Date:   Tue, 8 Jun 2021 17:51:04 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com, linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 net-next 3/4] net: phy: realtek: add dt property to
 enable ALDPS mode
Message-ID: <20210608175104.7ce18d1d@xhacker.debian>
In-Reply-To: <20210608031535.3651-4-qiangqing.zhang@nxp.com>
References: <20210608031535.3651-1-qiangqing.zhang@nxp.com>
        <20210608031535.3651-4-qiangqing.zhang@nxp.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: BY5PR17CA0004.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::17) To BN9PR03MB6058.namprd03.prod.outlook.com
 (2603:10b6:408:137::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by BY5PR17CA0004.namprd17.prod.outlook.com (2603:10b6:a03:1b8::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Tue, 8 Jun 2021 09:51:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f859fe79-94fc-470d-568d-08d92a62f53d
X-MS-TrafficTypeDiagnostic: BN8PR03MB5012:
X-Microsoft-Antispam-PRVS: <BN8PR03MB50127D3BEA9593D610FCCEDFED379@BN8PR03MB5012.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BH1z54RXV+PCx5sWoYoGOmwedcdLRMs7BqOSvqHsLTwZ2Ars+f2BtG9+Q0TAVFOztY1/hqq9X5f3JMupgX/I327KDZR3NXjArGNJ31aaoacp6mtZDQGMcTlHd7Jd0lbJZWDk4FG9FnVOzgKBvdXqgS1fZFVLqoBHB0dkNIu6PV6NFRHB20UceAUMF7y/5urWflyIUy59o4CMLsfUy0cOsXpRtVi1Q64+PUWKVKDS+pL6KxDcDB56E4Jv6d4Znw1m8+Bk98XVTW+isH7NVdnEei6WgJ9MTZdHe+8C4+qPkD2ka9CNJAtaTP6dy0QWYIoaLMJ839lSZtwtwufg/AzAgDvqIsnMClI0qCr31QZxeDEqxJ5SWw+JU9B0iD6AXDsWglp877+/Tb7uB3MLL9pup1D/ZBQUAu1IcYtjBbttlEKK1IYKE4WfRJCUaxytIQHGOYwEmm2sW3ecMRyQWP/jr7YwwC4IEuYhSVhohceCZUR4oDiGoMV3/P6j+aE3H8NLMuirgt1vnVz0BUFFtokmtvzRlMjxtCkbBxql3OBD05BFAHFJ/s+MHdrG153BIMrNL4uwW0++ArGcRQBUd4s/M975aH3796csSi1dWzUAf/I7RjvBywe/NMuUhxxbfRGiyItXhk58qohIXXemMVJvZAs/2Qn5SL6gNU34NScLkWU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR03MB6058.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(396003)(366004)(39850400004)(52116002)(38350700002)(38100700002)(9686003)(6506007)(7696005)(66556008)(66476007)(66946007)(5660300002)(16526019)(8936002)(186003)(8676002)(55016002)(26005)(478600001)(956004)(6916009)(4326008)(83380400001)(86362001)(7416002)(316002)(6666004)(2906002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dvpOoAdh0f5aJAHxmnYGStJ833KLusdNtxXu9592W8eyYVr/h3QKFAZ6mSAg?=
 =?us-ascii?Q?DqWEwkOhMVAMbRUhbH7M5bAPPOhM/Ht/w2Dz87rAvq30QAG8FEZDVRU3yJCW?=
 =?us-ascii?Q?7IP7q04Z07NpxNBFaMGD1eeRxdEZ9C9gJIBUl/dwv0bm9OMC2fJnfQOLztdV?=
 =?us-ascii?Q?naUBRLx++aL1eH0892ciOjC5L3gPafKX/PgU6G/4+/7+kT34kx9Ww+bjwIH6?=
 =?us-ascii?Q?Gy64MiFNSa0ERsOn6vsYIeaT0rRd+PKP1+w84abFGhwJcLRakIPdYEQmv9iq?=
 =?us-ascii?Q?sJ4d40K8XiTfgrqvog1bfrPw/JK0O2Z4DsYgjuX8frVbGCRdTyjhdLVfppRq?=
 =?us-ascii?Q?81y3u7sURbTNM5ZHLnKxzahmz/w62CrmROf16Gc0JcIAM/7OrlPPG6Gta9Lg?=
 =?us-ascii?Q?3aS6blb1qxcTLKlHV10XnloHsoMeAEgxnhy2haKegyVQDyqjsgDxGhy0DKAC?=
 =?us-ascii?Q?vPs/EJlUAISiSjeIPL9gLrJDQDmWuQSnS12wcuOKLTd0ALek6r1dOJfS0J/V?=
 =?us-ascii?Q?wJix3fVL9dHMAtjOh5Ok4r6LB7fg4ruhy+PBvmQQ5XE4czQXPsZhPof/Dl8w?=
 =?us-ascii?Q?bNhlSzmKH8HV9F6C3C+os3oyyCaG/E+rXrFcakn5WFg66EwLW4QZ0ozAXtPJ?=
 =?us-ascii?Q?sE2oY4L38edCh1sLU6Ystgs0OP2erfNQPhQA7Y8s5r07W7mjXnCtOQ10WUf9?=
 =?us-ascii?Q?5sLlk1zfMj8krytLkP/Czs50Vgh5dNUXkswg/TlH9eFAdAlmLej/D0rZ8teF?=
 =?us-ascii?Q?pUfu8QtEkr0QeT2AVUXJxz22ItWjg/4UAwdrbQraQZ3vBbTsPBcTsR8NCJUW?=
 =?us-ascii?Q?lFaJWnvaVyabxhpfWw0tpC4Qo6jD0uczWTPeCFae+Q4VDjKXGrCpqVsALChP?=
 =?us-ascii?Q?yqIdhWVGgC0ypH6dC534bgh6BNgw9YRsHp0cR+6kww6OytxU89pTf/7y4+fQ?=
 =?us-ascii?Q?gw0fAoXI3nDbXh6PTMOL0CKY7Hsd6NBL8kJ9qow26JcCvNb6Hd2YL9DAwV5W?=
 =?us-ascii?Q?pX6l5soiqFH1ZCc0WFmJPnwHF0SA8rUblduksejPmnjObVZuXSEJcZ4id2v+?=
 =?us-ascii?Q?JfyZJrKJ55LoaTOky3ePRTbm5Bm8DM/xJExIuz0E1FG6YjS/Vd8vqoXh7c2r?=
 =?us-ascii?Q?NZrI9wkWM91FKfoNdoWNVr47ycYzxNYoJfMQPsH9Y9aqxIDhq3KVXaYYs54A?=
 =?us-ascii?Q?FVIgTsCB+BfbljLOz/Gd90ORsFIfT+DKAtAe+ZK8aVv+gT52jARcpXRs0VPF?=
 =?us-ascii?Q?6m+lVESDwR0PrqFuXD9yhTuIKAKIi4awyHKx4JFJBsNkP5rQNppvk9OH9qnL?=
 =?us-ascii?Q?hSbDUAW+meepWsd+gIk3ic7f?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f859fe79-94fc-470d-568d-08d92a62f53d
X-MS-Exchange-CrossTenant-AuthSource: BN9PR03MB6058.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 09:51:16.0828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: co66HI3yjZ5ClrIZhlAeNdEcF35nd0bZ3/SrFJ8E+3lpyNG7HU3ZHpo1304hOxouqfE6RUCa3ROMzokAHFRq3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR03MB5012
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Jun 2021 11:15:34 +0800
Joakim Zhang <qiangqing.zhang@nxp.com> wrote:


> 
> 
> If enable Advance Link Down Power Saving (ALDPS) mode, it will change
> crystal/clock behavior, which cause RXC clock stop for dozens to hundreds
> of miliseconds. This is comfirmed by Realtek engineer. For some MACs, it
> needs RXC clock to support RX logic, after this patch, PHY can generate
> continuous RXC clock during auto-negotiation.
> 
> ALDPS default is disabled after hardware reset, it's more reasonable to
> add a property to enable this feature, since ALDPS would introduce side effect.
> This patch adds dt property "realtek,aldps-enable" to enable ALDPS mode
> per users' requirement.
> 
> Jisheng Zhang enables this feature, changes the default behavior. Since
> mine patch breaks the rule that new implementation should not break
> existing design, so Cc'ed let him know to see if it can be accepted.
> 
> Cc: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
>  drivers/net/phy/realtek.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> index ca258f2a9613..79dc55bb4091 100644
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -76,6 +76,7 @@ MODULE_AUTHOR("Johnson Leung");
>  MODULE_LICENSE("GPL");
> 
>  struct rtl821x_priv {
> +       u16 phycr1;
>         u16 phycr2;
>  };
> 
> @@ -98,6 +99,14 @@ static int rtl821x_probe(struct phy_device *phydev)
>         if (!priv)
>                 return -ENOMEM;
> 
> +       priv->phycr1 = phy_read_paged(phydev, 0xa43, RTL8211F_PHYCR1);
> +       if (priv->phycr1 < 0)
> +               return priv->phycr1;
> +
> +       priv->phycr1 &= (RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF);

priv->phycr1 is 0 by default, so above 5 LoCs can be removed

> +       if (of_property_read_bool(dev->of_node, "realtek,aldps-enable"))
> +               priv->phycr1 |= RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF;
> +
>         priv->phycr2 = phy_read_paged(phydev, 0xa43, RTL8211F_PHYCR2);
>         if (priv->phycr2 < 0)
>                 return priv->phycr2;
> @@ -324,11 +333,16 @@ static int rtl8211f_config_init(struct phy_device *phydev)
>         struct rtl821x_priv *priv = phydev->priv;
>         struct device *dev = &phydev->mdio.dev;
>         u16 val_txdly, val_rxdly;
> -       u16 val;
>         int ret;
> 
> -       val = RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_XTAL_OFF;
> -       phy_modify_paged_changed(phydev, 0xa43, RTL8211F_PHYCR1, val, val);
> +       ret = phy_modify_paged_changed(phydev, 0xa43, RTL8211F_PHYCR1,
> +                                      RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF,
> +                                      priv->phycr1);
> +       if (ret < 0) {
> +               dev_err(dev, "aldps mode  configuration failed: %pe\n",
> +                       ERR_PTR(ret));
> +               return ret;
> +       }
> 
>         switch (phydev->interface) {
>         case PHY_INTERFACE_MODE_RGMII:
> --
> 2.17.1
> 

