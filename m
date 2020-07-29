Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469FC231C75
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 12:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgG2KEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 06:04:35 -0400
Received: from mail-mw2nam10on2058.outbound.protection.outlook.com ([40.107.94.58]:26107
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726341AbgG2KEe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 06:04:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XeJ7AJgoA0G92VKC4gO27iZcz74OiJX2L+myoTfTUeMjdQh2EGLhPEtimV/GOP69Fsog1Z3HpkNQ9dAOhdnslt+ioBWgJ6Z+OuouVuujSC00EGR2E+zxcj9L37mTd74jSBt6xawVjxCn9JV6Km27h+21YCzkeIQOjkRh4ZYqgcWUQDoMAsU/emx+QdBhmBBJfSfpExPQkLbo7ruhmCYDHDST4FSMzQAdXi0dynp3BCe1zIX5AAOc7U4Z2K1PK4eE6IorTjgKDj7yufgw9G4F7Ww6btIuBKtphon/Eb9MwjgakRWujYgiyWIR+kvvMSJjvdSZ68noioIV91XmR/2ZSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DGOgm8UtsBCseLjrGEEIhblHrobCRqenih/ceyBpZUw=;
 b=Tpq0KbX/Whkj4aIPQjqcUJ/yJakwO58LPLuq2ClUKM2UbN2J9AQ14v0dvXjftlvwYAFLfLcVzaOX+kZNypvdnKprGvMJ0zZGUxCiEMLzHxN20VOTfdQDFPSekXLKPY/NXMPS0COg+xHDFkDuYLqT7Tc7a2h9CpCsYfbpn40aoYaUtvQFvJK41PdxUTln53gu7GpzH69XVxOShcMbXMexVB2JVAo0o2+FErEJxysKxCSG3ic3fvb+ZfNjcvx+oNF+Hm8Vr/fiUZjajGsgjwRtUXVJMLcfbCWa5UZ8W5zppAv2lUclSj2JS+syZ+/krAvfqadRvhA5VAS3LGc3MJ0LYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DGOgm8UtsBCseLjrGEEIhblHrobCRqenih/ceyBpZUw=;
 b=dNW+bhCBLEnVLnieeyR2eSfR7r+sRgBItMRFRWhYXdoRlckLTCjflYrHb4SQwbZhyFOE6QEBvAUem4zzl9jmb70ZzX1m9o/rnPgk1LTthzSSUCU0aRyc9DAZFPmjWU/roQ9aTncpcAuDlVokPgB+IKaAPCXkn7lpWi65/S3UQa0=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BY5PR03MB5096.namprd03.prod.outlook.com (2603:10b6:a03:1e6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Wed, 29 Jul
 2020 10:04:31 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::b5cc:ca6b:3c25:a99c]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::b5cc:ca6b:3c25:a99c%4]) with mapi id 15.20.3216.033; Wed, 29 Jul 2020
 10:04:31 +0000
Date:   Wed, 29 Jul 2020 18:02:46 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Lu Wei <luwei32@huawei.com>
Cc:     <ulli.kroll@googlemail.com>, <linus.walleij@linaro.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <mirq-linux@rere.qmqm.pl>, <linux-arm-kernel@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: ethernet: fix potential memory leak in
 gemini_ethernet_port_probe()
Message-ID: <20200729175957.011642f1@xhacker.debian>
In-Reply-To: <20200729034606.89041-1-luwei32@huawei.com>
References: <20200729034606.89041-1-luwei32@huawei.com>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCPR01CA0080.jpnprd01.prod.outlook.com
 (2603:1096:405:3::20) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TYCPR01CA0080.jpnprd01.prod.outlook.com (2603:1096:405:3::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Wed, 29 Jul 2020 10:04:29 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00f23682-e285-45db-657d-08d833a6c99f
X-MS-TrafficTypeDiagnostic: BY5PR03MB5096:
X-Microsoft-Antispam-PRVS: <BY5PR03MB5096C307423F317EAC418D92ED700@BY5PR03MB5096.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3IkV0ZkNo+ZQt95/xi/+rlYcb8IbmPToGCQSX9dxyMxSnlrNVe+GsJ3tBcRheLkfx2z/p1dIfMmYX4ln+fozRbimsztDFK/ej+uLHRjrr0SwnOl+a/4A3Y93Ue1Mz37znmKVO7LEyEU5s7XMgwJNbDCijyCmA0csVAWpby8ad3VUdIzrAL7FukVsXQjswOv4Y61aXuI81DjwKtYu4FsAg1VvOJFDxpU+26PFXZ53EcIVEQCSHalE+po8D7xsZekhLiu/V8sABFO8PXPADV6bokfuxD+4lGwBlft42wIwOr1rAdkwC/ip8KyQ6OTWyPCmKMv3VzWUFdrL9LhqD/Nxy+BizIEyaVJV+z3TwwE75uwsz9aTtxKgpDRxrpClcTBI9AQVQ9jgHKLCOddSe5uWfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(136003)(346002)(366004)(396003)(39850400004)(66946007)(66476007)(5660300002)(316002)(478600001)(6916009)(966005)(66556008)(2906002)(83380400001)(86362001)(8936002)(16526019)(8676002)(26005)(186003)(1076003)(956004)(55016002)(54906003)(6666004)(9686003)(6506007)(7696005)(52116002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: JtmvW6MaY6FlAbGUEVlUKMozMnp0R4QWlvNsGZYKixsYQqFitoPld4pVnsJTEAzNUSbHrbA+Tkimh2Ih+02M2AzCpR5PF/SS295k9dW59PoqUETTumkSEnDByD7g9nVdZiMvGPphXylXsJz2drxFmV94nJxRelm02Taaveo5WPE1mOCyMbF4RE/YZ+m9BKdoIwhQlAcmVt2L3g8jhbltSJL0+CBghSxEKSdiot6phuT2GiSYVzJifN31NGmhsUyQEIVKkK/cntLEB6aqP3x+XwHlN/d5JsFf+M6KNl5kPq8JVq5YPCPHwSHvJ6qYWxUU65qneEhBON39W5cOV513KImJCC64HYx/we0PzlQhbPpy81gWHvAOasVeu4YOjseEAZvbZ1or0iWLpgeqYzcW0Jv+elprej8IEL7xRCpTTF2NL5Lj6q4vKG11MROc58UYaXS8DmYY6jWL1p0IBI01a72hHe6dhIjGgUhfnjJu+cyby+ftUUWsLOiFq2iL+0o4jPsDqmQv0YnTAKV+KPVnJrN0CvVwJiTGoNoIRiqskVCijS3d1hte5SISM2VgCGvvT0pOezz6OxKWhsej5vW25IBuHIbqoR6Jbpz5fuBiPAFry0Y+31l9edHJOUMcuxLPndJW3kk4YnLwQOBo5BBuxA==
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00f23682-e285-45db-657d-08d833a6c99f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3573.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2020 10:04:31.6357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7N/Ls4gyj1mUJBi9o2TLF2S89eD9w8vH+vsy4bjzGmOxau0KMZuG+TSUvavYiFRrrK+iGghJFkM7xwX+s5KuVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB5096
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jul 2020 11:46:06 +0800 Lu Wei wrote:


> 
> 
> If some processes in gemini_ethernet_port_probe() fail,
> free_netdev(dev) needs to be called to avoid a memory leak.

Using devm_alloc_etherdev_mqs() would be much simpler

> 
> Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Lu Wei <luwei32@huawei.com>
> ---
>  drivers/net/ethernet/cortina/gemini.c | 24 +++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
> index 8d13ea370db1..5e93a1a570b6 100644
> --- a/drivers/net/ethernet/cortina/gemini.c
> +++ b/drivers/net/ethernet/cortina/gemini.c
> @@ -2407,37 +2407,48 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
>         dmares = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         if (!dmares) {
>                 dev_err(dev, "no DMA resource\n");
> +               free_netdev(netdev);
>                 return -ENODEV;
>         }
>         port->dma_base = devm_ioremap_resource(dev, dmares);
> -       if (IS_ERR(port->dma_base))
> +       if (IS_ERR(port->dma_base)) {
> +               free_netdev(netdev);
>                 return PTR_ERR(port->dma_base);
> +       }
> 
>         /* GMAC config memory */
>         gmacres = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>         if (!gmacres) {
>                 dev_err(dev, "no GMAC resource\n");
> +               free_netdev(netdev);
>                 return -ENODEV;
>         }
>         port->gmac_base = devm_ioremap_resource(dev, gmacres);
> -       if (IS_ERR(port->gmac_base))
> +       if (IS_ERR(port->gmac_base)) {
> +               free_netdev(netdev);
>                 return PTR_ERR(port->gmac_base);
> +       }
> 
>         /* Interrupt */
>         irq = platform_get_irq(pdev, 0);
> -       if (irq <= 0)
> +       if (irq <= 0) {
> +               free_netdev(netdev);
>                 return irq ? irq : -ENODEV;
> +       }
>         port->irq = irq;
> 
>         /* Clock the port */
>         port->pclk = devm_clk_get(dev, "PCLK");
>         if (IS_ERR(port->pclk)) {
>                 dev_err(dev, "no PCLK\n");
> +               free_netdev(netdev);
>                 return PTR_ERR(port->pclk);
>         }
>         ret = clk_prepare_enable(port->pclk);
> -       if (ret)
> +       if (ret) {
> +               free_netdev(netdev);
>                 return ret;
> +       }
> 
>         /* Maybe there is a nice ethernet address we should use */
>         gemini_port_save_mac_addr(port);
> @@ -2446,6 +2457,7 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
>         port->reset = devm_reset_control_get_exclusive(dev, NULL);
>         if (IS_ERR(port->reset)) {
>                 dev_err(dev, "no reset\n");
> +               free_netdev(netdev);
>                 return PTR_ERR(port->reset);
>         }
>         reset_control_reset(port->reset);
> @@ -2501,8 +2513,10 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
>                                         IRQF_SHARED,
>                                         port_names[port->id],
>                                         port);
> -       if (ret)
> +       if (ret) {
> +               free_netdev(netdev);
>                 return ret;
> +       }
> 
>         ret = register_netdev(netdev);
>         if (!ret) {
> --
> 2.17.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> https://urldefense.proofpoint.com/v2/url?u=http-3A__lists.infradead.org_mailman_listinfo_linux-2Darm-2Dkernel&d=DwICAg&c=7dfBJ8cXbWjhc0BhImu8wQ&r=wlaKTGoVCDxOzHc2QUzpzGEf9oY3eidXlAe3OF1omvo&m=56ruRjtNY-BIzquRyoO0KSbrR7UBB81VfqotT_rfFus&s=Axiqv0SZYKFXgMc1zJLilZCk9wbRAt4LkKtW6VjKTgw&e=

