Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9412EB156
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 18:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729926AbhAERZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 12:25:29 -0500
Received: from mail-db8eur05on2103.outbound.protection.outlook.com ([40.107.20.103]:36929
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726151AbhAERZ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 12:25:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3xAD7867+BAAZn+B++D7rGAHJ77Uxw68D16zhXEFbFNgbmuoIwOdYh6L2yg5i51h2dHnKSWnQZ8SKuF2SmQP3J1NYpcSBfK5+c6cEkhe3fkMIWqJJk7DAHwd6xuUXBOcpN8WkvD0yFGX1eE8JoHDiAwgKMUB2pBP3anyDPqSYJKP09aj38jRIJ2QZOJUhFSJlOIQbpGvSzKixq+jzYIrNFLBUcphhx5lNwvZLMzPDoOhc0pF6CcEVdYVi/m0CzrqDJ4Gb5LG7/Ge5+uhrS6+3jkkk1wPzY7pA8CWQMV4LGFI9JkOiZPJpdCXFQ6LNilmtoH11dpkoKfUhKp4S2g6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+jVxHhhT77+ThHFhr2RIUfkXVgecIc5iT0QXBLuIwHc=;
 b=h4VMlY1iLStWZTxkUhqXKUI/vQYY1BImdgk6koSBs66R2JPsc+YpIUd+U81hMuIPXQfP04DaJ1V0uVBGzqC9ez+J8dr9XmLc+xcpgL+tcJQHPxqZZP7KMGl3UK3rQym7L/PzXyYbKwoClXlYosxPWdOyafyl9LrLGx67SlYRFI0HekloTs7+HqQuk4uxyFTJYn1G2GyAJUcBOsnV075T71Gf7AyHhiXaHFczrsT1EpjwhL9obtdaQ/OBKOl1fsZ1E/+Yy9pbdXjxI500wnH/8UQlEM0ncmLXXZC4XLVHD2OaUFNYrCFnvXmDGQFRNby6u+xuJZvPsYkotjXvah8z0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+jVxHhhT77+ThHFhr2RIUfkXVgecIc5iT0QXBLuIwHc=;
 b=cfLZ7EwA4IWEfJeLPi8BqizoMfLLcefcmRCvnLepcTxtkE9AXSWOIt3d6dLiqWiRrpYms+XF9gBlO+yOAJT/AydtEsarfSKtd2EWmsDyzNq6dfPptYB/2RsRYwJgfgHjYowe67O/Ftp79a2o28dzMoK2TIw1YTkhJbp5CXMZmg0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM4PR05MB3268.eurprd05.prod.outlook.com (2603:10a6:205:4::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 5 Jan
 2021 17:24:38 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::25c0:d4fd:dcbb:d34b]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::25c0:d4fd:dcbb:d34b%6]) with mapi id 15.20.3742.006; Tue, 5 Jan 2021
 17:24:38 +0000
Date:   Tue, 5 Jan 2021 18:24:37 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Matteo Croce <mcroce@microsoft.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH net-next] net: mvpp2: increase MTU limit when XDP enabled
Message-ID: <20210105172437.5bd2wypkfw775a4v@svensmacbookair.sven.lan>
References: <20210105171921.8022-1-kabel@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210105171921.8022-1-kabel@kernel.org>
X-Originating-IP: [37.209.79.82]
X-ClientProxiedBy: AM0PR03CA0049.eurprd03.prod.outlook.com (2603:10a6:208::26)
 To AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from svensmacbookair.sven.lan (37.209.79.82) by AM0PR03CA0049.eurprd03.prod.outlook.com (2603:10a6:208::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 5 Jan 2021 17:24:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a489a1d-160d-45d9-c14f-08d8b19ec7cf
X-MS-TrafficTypeDiagnostic: AM4PR05MB3268:
X-Microsoft-Antispam-PRVS: <AM4PR05MB3268396400A0CEBDE05268DAEFD10@AM4PR05MB3268.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o/bZDPF8pBdt4W42rdE5YQDbPl7cr2Qu4vPiesXFO2vw5qDm45xD7Q7fkrPpnkkrBoKxTddLxusTjdt9CaEK6d7sPdnT5X2Al18usC1RNp5Ed9AorXEtZ2W1uw/XrIB+sOqIafYesG9xesqhBSEJeTIifLDdlYIuQPTdw+um0JWor79hMyNUHOroZVZGAh+K+yf/BB7RTwAuIN8h9MVvQOeRvkTcOd9P0MLk0VKjlkbHP4hC2Rc3RYwAelgr8K8+QeFcOGT7BRpXaOsZog3XRBtdC9SCUY9FyqGPGDV4zmBzjRCqi4RbIl49zuLzx1eGLP/j0FPqhUQIIn8f2so/PhAteVAyBh3jU5bvttkVpf9eMBEoFMeHJKcDoRRT4ynbo0ks098r7eG1eYkEf+WhMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39830400003)(346002)(136003)(376002)(366004)(396003)(66476007)(86362001)(66556008)(66946007)(16526019)(55016002)(6916009)(5660300002)(8676002)(9686003)(186003)(956004)(26005)(45080400002)(8936002)(2906002)(478600001)(44832011)(7696005)(52116002)(6506007)(1076003)(4326008)(83380400001)(54906003)(66574015)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?GhRndj+53LB7+8etUlIbTo0R7+hn86n1fzqIIXAYkb95P+te3EbhBvPpza?=
 =?iso-8859-1?Q?4RNRY+s++HPqBNYFtSiurrLlZDJngBNbnK0LhtzEoF6FXiZkARv64Xj2Yj?=
 =?iso-8859-1?Q?O/Vh6cPXlIaks3PCxA3nGFCQo+CaAgfgvWHlEUxC+0PeWzfjj2TM+yAKNM?=
 =?iso-8859-1?Q?C3mVF8YeGW10mHNeJQCSQr4x/aSsSGBLhyGLjpQvun3gKbIs4cY1tv7Uk5?=
 =?iso-8859-1?Q?qZyREPNhB1MXoQkHIDYNT25q6ujDIukO0/P3SwR3KzzSKl7/nnfmOlldZY?=
 =?iso-8859-1?Q?xcg/Yx+0TG0AVjplD5tcVOKrZQzx8iB4/HTIYMOVRHR/nEqyh0nnV7yxY6?=
 =?iso-8859-1?Q?Vyyo563H3G5oNB3JBhg+p3+PrOOVeYJuE8JaQWVXtIf1m1vSd0nZCD/EmZ?=
 =?iso-8859-1?Q?m/ltObIfHwO48y4/Pyqx9H/gfH94lyJLIrFC66N+iGUDsBgY31i9mDTq0z?=
 =?iso-8859-1?Q?eIdMrmHQhFkUdIyyBecZ/KttYkGO9azJOQPoAwbutZ/YZCBCRDl7XEb+ky?=
 =?iso-8859-1?Q?U+0vLzEnbKPfh78A4hCKwbXWyXyjUjzjv9SpM7TD65MtP06ONGpk4Lkv93?=
 =?iso-8859-1?Q?vxCMUSqg/Nc8GGX0rYxk+tmpK/4pznEpngBzXEM/fn4hkXwzZpqT0luhdh?=
 =?iso-8859-1?Q?svyAsC+rn/RUTviDakoZg2jUDXpnrGJcJsPQiOikm4Cebn6IObmMsAx7WY?=
 =?iso-8859-1?Q?PsUY1eyXoOJYGCwsMdd1KGBa/LobDR0n2NyqnVYp/svjeNGMaTNs29Itt6?=
 =?iso-8859-1?Q?2x0ztpxzJ1kkfSvt8tW9G0yU8E4LsHZThPO967qkVvzgsxh/UOPfBQgx83?=
 =?iso-8859-1?Q?YYZcwlvit8XPGlvkpPpuFQqYo2qXxGHfl5QpItkoayMosXTf3fOIJg6GRM?=
 =?iso-8859-1?Q?cduku0TpXbSU3D8/Vpmwfp3ZNEFM+plMeEEM5LXIu8iVLmffBIjlOKMcVk?=
 =?iso-8859-1?Q?nx5ykH1ddYd4YTKjjtoUXVgsxycMNE1vD4Kvno+8COe2eCezePUEi4cdrN?=
 =?iso-8859-1?Q?QQ4SKV+ElEtUCoFDa1i56J2EPZjxHRkLr2evTG?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2021 17:24:38.7060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a489a1d-160d-45d9-c14f-08d8b19ec7cf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 17Ej4gfIvi+/LP1rOZJiVOziFQ7Xgvf7ioRcExwpKRsAtbwxo7MSbav1GD85CgwuotolPVrMcqYdSwuWTwDZyRE38LRl3tu96LMiO0XH0i8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3268
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 06:19:21PM +0100, Marek Behún wrote:
> Currently mvpp2_xdp_setup won't allow attaching XDP program if
>   mtu > ETH_DATA_LEN (1500).
> 
> The mvpp2_change_mtu on the other hand checks whether
>   MVPP2_RX_PKT_SIZE(mtu) > MVPP2_BM_LONG_PKT_SIZE.
> 
> These two checks are semantically different.
> 
> Moreover this limit can be increased to MVPP2_MAX_RX_BUF_SIZE, since in
> mvpp2_rx we have
>   xdp.data = data + MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM;
>   xdp.frame_sz = PAGE_SIZE;
> 
> Change the checks to check whether
>   mtu > MVPP2_MAX_RX_BUF_SIZE

Hello Marek,

in general, XDP is based on the model, that packets are not bigger than 1500.
I am not sure if that has changed, I don't believe Jumbo Frames are upstreamed yet.
You are correct that the MVPP2 driver can handle bigger packets without a problem but
if you do XDP redirect that won't work with other drivers and your packets will disappear.

Best
Sven

> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Cc: Sven Auhagen <sven.auhagen@voleatech.de>
> Cc: Matteo Croce <mcroce@microsoft.com>
> Cc: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index afdd22827223..65490a0eb657 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -4623,11 +4623,12 @@ static int mvpp2_change_mtu(struct net_device *dev, int mtu)
>  		mtu = ALIGN(MVPP2_RX_PKT_SIZE(mtu), 8);
>  	}
>  
> +	if (port->xdp_prog && mtu > MVPP2_MAX_RX_BUF_SIZE) {
> +		netdev_err(dev, "Illegal MTU value %d for XDP mode\n", mtu);
> +		return -EINVAL;
> +	}
> +
>  	if (MVPP2_RX_PKT_SIZE(mtu) > MVPP2_BM_LONG_PKT_SIZE) {
> -		if (port->xdp_prog) {
> -			netdev_err(dev, "Jumbo frames are not supported with XDP\n");
> -			return -EINVAL;
> -		}
>  		if (priv->percpu_pools) {
>  			netdev_warn(dev, "mtu %d too high, switching to shared buffers", mtu);
>  			mvpp2_bm_switch_buffers(priv, false);
> @@ -4913,8 +4914,8 @@ static int mvpp2_xdp_setup(struct mvpp2_port *port, struct netdev_bpf *bpf)
>  	bool running = netif_running(port->dev);
>  	bool reset = !prog != !port->xdp_prog;
>  
> -	if (port->dev->mtu > ETH_DATA_LEN) {
> -		NL_SET_ERR_MSG_MOD(bpf->extack, "XDP is not supported with jumbo frames enabled");
> +	if (port->dev->mtu > MVPP2_MAX_RX_BUF_SIZE) {
> +		NL_SET_ERR_MSG_MOD(bpf->extack, "MTU too large for XDP");
>  		return -EOPNOTSUPP;
>  	}
>  
> -- 
> 2.26.2
> 
