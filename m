Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96EEB17FFDD
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 15:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgCJOLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 10:11:25 -0400
Received: from mail-db8eur05on2082.outbound.protection.outlook.com ([40.107.20.82]:11392
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726273AbgCJOLZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 10:11:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OIA+34ccNlNTIX38XMsL8Qe/JzfRkeM60lLJ+XueQMy8jSvRsTBrBtO7ordDQGJC1eqpK8CamV4EAw4dbPjRLOhxN74RxRraveFnM56gREQGQd+4gBXpzFaq2plSeXh1EPCexKjEe5IWB5mWm99SwrHdcXYUpmIPSS2BQXiCBHgCHlCRUnTiHlxkkMeYsArCYnSXmRfiqB0Tek73By7SFuTkulb6ZyAT3NbiM/+VS/DWlPdoqvBk2jlmeCgs8D8+Jj/fngVS4/Mxo0XumzXxHWunGVVlyeVXp1EUqJ3LuAIR4W2nQt8mGrl6aLJIW4Jzzaq6168f3k0HVk0Etk/Xhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tXSeJpp5/4tQwLHYJPWDEfDUC2iZ0z7tGp+ZPO4/05A=;
 b=j5vYe2We0YAl8RL/EAcJkcMCaX6aPy6pUvs0Ja/mxFvaSgOoAFGrI275yR1c8Vto1qLZ0TbGlOO2R1LMSYW8cH3r4jh+0ATexBhTGDZRg9L5XjcZFXLSGSnPn2xLJsxEsUFD36Ayvo7eqoIBsAYb0xHaWErsKPxhAp6CCTr+hIb4T4L+WlJPlXFJsXSwmPWh42gLLqCbXkqpZ/BjWIRQddUuMIF/wozZ0NboB0zBEERYv/gV1eGr3Ml8CD+XnN/SKkp73SVPRZw0elhDjAm092pCVwq0ZhwfWvruRDqus1WEP+iWchYvlCFvAIrsgNYdLOHsC6WtcJipYNNP6ImJGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tXSeJpp5/4tQwLHYJPWDEfDUC2iZ0z7tGp+ZPO4/05A=;
 b=PAh7LFqgDYr75mJISYGK11aZdk6yY3fj7JhFmAmh4NUSazrYdmyHWjQxe73/xJl+BN6ogmOsdJcWNJVpuGgHYe0kVjM6LVmt4y4u1pvEeRwHCR1WyuDDZiXnYgb4wVlsZv5/kZYcUr3yuXjg1tk+pYfbYWSPbL+EL1MDC4uryYA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com (10.169.134.20) by
 VI1PR0501MB2320.eurprd05.prod.outlook.com (10.169.136.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Tue, 10 Mar 2020 14:11:22 +0000
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::798f:9b6f:fe10:27aa]) by VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::798f:9b6f:fe10:27aa%10]) with mapi id 15.20.2793.018; Tue, 10 Mar
 2020 14:11:22 +0000
Subject: Re: [PATCH net-next 10/15] net: mlx4: reject unsupported coalescing
 params
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, akiyano@amazon.com, netanel@amazon.com,
        gtzalik@amazon.com, irusskikh@marvell.com, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, rmody@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, aelior@marvell.com,
        skalluru@marvell.com, GR-everest-linux-l2@marvell.com,
        opendmb@gmail.com, siva.kallam@broadcom.com, prashant@broadcom.com,
        mchan@broadcom.com, dchickles@marvell.com, sburla@marvell.com,
        fmanlunas@marvell.com, tariqt@mellanox.com, vishal@chelsio.com,
        leedom@chelsio.com, ulli.kroll@googlemail.com,
        linus.walleij@linaro.org
References: <20200310021512.1861626-1-kuba@kernel.org>
 <20200310021512.1861626-11-kuba@kernel.org>
From:   Tariq Toukan <tariqt@mellanox.com>
Message-ID: <68c7fee0-baf7-40ec-95c9-9a08f6bd3f60@mellanox.com>
Date:   Tue, 10 Mar 2020 16:11:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
In-Reply-To: <20200310021512.1861626-11-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR0102CA0043.eurprd01.prod.exchangelabs.com
 (2603:10a6:208::20) To VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.80.2.90] (193.47.165.251) by AM0PR0102CA0043.eurprd01.prod.exchangelabs.com (2603:10a6:208::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11 via Frontend Transport; Tue, 10 Mar 2020 14:11:18 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 679fcd3d-72ee-4ac9-e17f-08d7c4fce8f7
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2320:|VI1PR0501MB2320:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB23206BA6BD99856B674F90B3AEFF0@VI1PR0501MB2320.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(136003)(39860400002)(199004)(189003)(2616005)(5660300002)(16526019)(956004)(2906002)(26005)(186003)(4326008)(53546011)(31696002)(52116002)(8936002)(16576012)(81156014)(81166006)(36756003)(31686004)(6486002)(86362001)(66946007)(8676002)(66476007)(316002)(7416002)(66556008)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2320;H:VI1PR0501MB2205.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i7edJXZjkPR783IWsADt5Uxb+HW9/KPw/k7kFqwgTKrh1kjWRcGwkonQiKfJrSaFna6DOfnwX6Z+1pEPTf4iOJIFGPHWlLBqPNKq9uHkTnCeMeyT7RTAn5Vnyg7KjVW5t47sgSgpREwaYx6hukN5ctCLXvGwylsgiIweOBnqBOKmGepWuyjM47Kdl/9qj839+WBZ+mTXA3o9JfKb54lXH04GoVIdKawyoYawFxOeoAL5kzSB2gWIuxI9VtLu/lPXKn7ZslJW21TZA+DBuobKJOVe/zvrgNKsKTGksWb2T5H+KqPUKRAqfAgPU0yfGoztTpG/GP18aukFmdJXUfInhqyDKUTa8xQMFnq+X71gPFOe3BGC81vq2RQSxy66yPpSHAB+nqVFSsqTyf3GuqL/Y3juOvlSBvVeWtgkm5wdI83WepUvjgLmF/TrT7zvfu/f
X-MS-Exchange-AntiSpam-MessageData: UgfUbjV1sKe3AShZVGU34jqRyiEqsQmCYAPhU84w4tUE+gtC/gZUivRv7VO6i1hef8NhWHoBk8ycXrkEqi9ZeAEaKkVF6H4FAWbjP1Z2UBIaLSQxp6yb7VopXpnTSZ4qO2PUwTlUtLZZczC/G9jkwA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 679fcd3d-72ee-4ac9-e17f-08d7c4fce8f7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 14:11:21.7805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rwfpX4lODOn68Y1QJNAH1tuRckgswps5jhEhAeg92f+uqPBwtuMGiYuEAZJmFbnp2lf35xoXHDhhkvlBf/yaNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2320
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/10/2020 4:15 AM, Jakub Kicinski wrote:
> Set ethtool_ops->supported_coalesce_params to let
> the core reject unsupported coalescing parameters.
> 
> This driver did not previously reject unsupported parameters.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
> index 8bf1f08fdee2..8a5ea2543670 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
> @@ -2121,6 +2121,10 @@ static int mlx4_en_set_phys_id(struct net_device *dev,
>   }
>   
>   const struct ethtool_ops mlx4_en_ethtool_ops = {
> +	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
> +				     ETHTOOL_COALESCE_MAX_FRAMES |
> +				     ETHTOOL_COALESCE_TX_MAX_FRAMES_IRQ |
> +				     ETHTOOL_COALESCE_PKT_RATE_RX_USECS,
Hi Jakub,

We support several more params:

ETHTOOL_COALESCE_RX_USECS_LOW
ETHTOOL_COALESCE_RX_USECS_HIGH
ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL
ETHTOOL_COALESCE_PKT_RATE_LOW
ETHTOOL_COALESCE_PKT_RATE_HIGH
ETHTOOL_COALESCE_USE_ADAPTIVE_RX
ETHTOOL_COALESCE_TX_MAX_FRAMES_LOW
ETHTOOL_COALESCE_TX_USECS


>   	.get_drvinfo = mlx4_en_get_drvinfo,
>   	.get_link_ksettings = mlx4_en_get_link_ksettings,
>   	.set_link_ksettings = mlx4_en_set_link_ksettings,
> 

