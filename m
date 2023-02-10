Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 153D0691FAD
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 14:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbjBJNVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 08:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbjBJNVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 08:21:12 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2132.outbound.protection.outlook.com [40.107.237.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEA256ED2;
        Fri, 10 Feb 2023 05:21:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Td8BUPTucvDX5jcKdqaaw2q1YC//74o5QqbiQzTYQRmywHDbFd4wzig4AxTyhiyRHip2l3k1BQG+VikMYmOvC6JVDZHO75h7XJK3v+mblbF3Dr2aFXe0DxEv3N+bHZyULp7El7+K24fbBluckkkBaTLK62OkU8FeAOQmBDvka/7HSrdXVfQBttssQjXR+8pp0BAY+oQgw8WjaW/5HoSssr+sxMXw5UPAUvxeA0nTNhgtnqdVIgXveJa8Fn2HdTnkUZGmOelUsaRwUqeGpepFY0jNlNJ/x+ZmKrsqPcnpKtFXkS76u95tEC7P+9p6XlbQLsnjw3Ks7Elu395xgdI06w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UzaphirltqV6E1UTL//gHasRX544h1gbNE4jckU089Q=;
 b=cYj/RcLjSZ2xtmdZYLcAG7njJr1WabZZSnG1BPR2ZYEWFKWWM/CIqhdky4zeokF/x04UhVlBD8TtGFcOZaKicXCTxZY52lLx7cpWBAF+SHyoR/GKLVJFIW7EP4/E4yvGpQ0iPE8i9oWjmYTK5sr2Ai/zBiXLRAn4gOqUJW6v5PeiP0QK1xCMgRc1ta7fcFIIWcvUwqi/cjkYyt89Lei6DARq0XiDYDWGXt9lB9w0pXCKyT/Ld3cC2gmO3BdGUkEWeRJl90GcZz1h7W93fvunb17RjlS1NUvI7NNjnJ84J+ghIxMjUdEmIIjD2ry/baB91hnDEYm8+wNwyYviFLFhOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UzaphirltqV6E1UTL//gHasRX544h1gbNE4jckU089Q=;
 b=KfzAPX3cBjy9B2i257OVE70usksVc/YfRJlq4F+F79C44aXaFmdryLJh45KaoexwM5ITVVCpfCc4w84A+EPVcLNSwXn/9rtvaaozxLcs6PSppdT6Vl7m+gJinGpFot5kv0RVNatub2dI3ZLKfrWUNMmaRfA8wLxxIseEjSz/8wo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5681.namprd13.prod.outlook.com (2603:10b6:510:110::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 13:21:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%9]) with mapi id 15.20.6086.021; Fri, 10 Feb 2023
 13:21:09 +0000
Date:   Fri, 10 Feb 2023 14:21:00 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     linux-wireless@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Po-Hao Huang <phhuang@realtek.com>,
        Andreas Henriksson <andreas@fatal.se>,
        Viktor Petrenko <g0000ga@gmail.com>
Subject: Re: [PATCH 2/2] wifi: rtw88: usb: Fix urbs with size multiple of
 bulkout_size
Message-ID: <Y+ZEvCuQXx24l4yP@corigine.com>
References: <20230210092642.685905-1-s.hauer@pengutronix.de>
 <20230210092642.685905-3-s.hauer@pengutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210092642.685905-3-s.hauer@pengutronix.de>
X-ClientProxiedBy: AS4P195CA0002.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5681:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f69aa9b-3efb-4e9e-5e96-08db0b69abbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3bDvqs8/YrKthmHK74KMpa/MiwtqySunRqjL1t9kVK/mW0Kt+B7v/0qN3Xs5vG+9LZqGxTsSEQKEgMKhfyD4RXaqDIt3CBkfRGcp9V1rKCXcNRt+2VpDQGMH6HYyhpKzwK39S8Y6AmY2NkkCfw9n71p56t9lCbkOz7OktjyhpY3h+i5qi+yx17ylRvA/ShQE4gHq5VaPJ5QbXv7mN1GcoxxLx07tgalAxxpPNIjhOtjdryWYUlWpj+KdoPHPUSQqW1ex0b1BroI1cdbmcRaZEcrGT4sHgLf3WHYqEthkci+V9ukjEt9XIGsVl8kjn1qZNVNZB5rgXDSZcBZd/Z0nR/QzUKjuh+1l1YvkfSERXJgw9rMQttiq2yUozfF3FnUG3ZMFA/Fyq9I+CG+bCpQa0QrObmgB0BDPtWRbSIfETDqZhhGQF1K/IahqBSN+Vg0Xgw2uxBCCutiMVRN/0ioRX9c7mHVHXCUcogDbZ0ywmL1fS+S7TeOaQM7IRgksXLHWoMSX1oSQQKLL+8sAhpj/PG9pcOsI+IECwndr1aUPxJj1bu+Vvd2KGKhrHsAK7zAa2RDiGZmVz7kUOx6pBiudo4eyyGVxND9Q22KPmMusTZep6L7NG4qNciz6nUExxHGVbN4xhDqNpyYMYsZhUFMikwJHeEApvAjL0H1sqBqtltcD+D+Hx+7p07NIVG4MA/4T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39840400004)(366004)(136003)(396003)(451199018)(66556008)(2616005)(2906002)(38100700002)(316002)(4326008)(478600001)(8936002)(41300700001)(66946007)(6916009)(66476007)(8676002)(5660300002)(7416002)(44832011)(6486002)(6666004)(6506007)(186003)(54906003)(86362001)(83380400001)(36756003)(6512007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UtFDEANMRz+Tbf972yE6CTrWicOmjdTWrswRaBe1fmquqhvcOPbeJLqlmXYf?=
 =?us-ascii?Q?rDAayon08xqxmxNz6/vSaYQwLmuV/KPHBglXPXY2jp9owq9jJYAahnpDCmpk?=
 =?us-ascii?Q?a3wWGWhwF8Ui4sXUDxGX7AQxRZuPdNMsA/uAKcTR0c10h/n1aywaz+DgwNN/?=
 =?us-ascii?Q?mx6Hk/DyCQpJeRIN+xWL+rF7f3tA10wYZDPX0MFbI83Az+559dTp6IXHJXtC?=
 =?us-ascii?Q?gwdiUmd5EhR0DScTamkRQ74Rh24nl/fmTzM68ycJesXII/Qqw0AybjxBrc5J?=
 =?us-ascii?Q?6wDwFzonq+4uITUarZJF4fF/XoKOgfvQde3/ceX1vEidny+6iw6PB8BRL6GD?=
 =?us-ascii?Q?+rg4riFcxqN1iRgD4ztFMucVXsiNYViM9nHET0ycXnwde7uAYqWqckukGP8j?=
 =?us-ascii?Q?dxhQIPgmoeTcXOSVvtxsFGNLVkhhhorfMSPFg3/m6zflDvR9JAg2WHyZKLwp?=
 =?us-ascii?Q?JYZGCtGHIW4Gg2IZB9cIR1kfkDI+V1bGotT8UKOgLoaPheqIp3gOVS/yYTKx?=
 =?us-ascii?Q?TqLvHJ0EtfoSbArpKoQGIqwLbXurWZsUFdlbehMFxCFwEurzHjWCxGf3QIcp?=
 =?us-ascii?Q?dbVrSBQTR2bXivN1O6BE6ojZfPZV3fi4Bw25wt1LeXgH/laeu+a1oH4WjcZR?=
 =?us-ascii?Q?ZvjnaZduN3IwPjRsS3uwp4w+JZ8UO2zv26Q012o9YM+c+wwVheTPRBXPL5ad?=
 =?us-ascii?Q?/c0I7G8D3cqqxd4Uq4VKtUb/Zz+MJRH7LcjkFt8CFDg41o+gaEDHaUZhpjsw?=
 =?us-ascii?Q?H1HEiFYLaZ4M0CsB5JzRNXoAL6MKbZ3HOFZVz/x2uATtxaFQ+fN/UiiNieTd?=
 =?us-ascii?Q?w2FXsRR4B+Uh+i4H99SHFEjAv7encqIGFpE/ex+0Iekqk404wL6M2Dh2fq8K?=
 =?us-ascii?Q?HcTiiaF2y/bmFWCfY+0LbSdVzccNBgD6PB3ZYl2Yzml/yRF9cD6mad2rM5jU?=
 =?us-ascii?Q?X0lX87wv7m78B7Z5zlzDKfV5mlgAtrNTYiURribLwkKjhhNYJ5uzeA3JgtOh?=
 =?us-ascii?Q?jvkJVUT/e7FO8THEWPxxpxZ+gntdMF/7dhSX7svHqeN7AWRtcvKmAHcEukWc?=
 =?us-ascii?Q?BnLxj1G9qq8jOD3M/n7J0yWql54kyUwA14F042stlRdW6DmKQrqhZaS9xvNA?=
 =?us-ascii?Q?7Gz+6fro4Ut2r/jG9LcmzKIveqJ7Ver56yUoS0XRlanN4Iwiu/jZ9jWmGHuv?=
 =?us-ascii?Q?v5PJTMX7yislDmNI9wxe0Kxso6YqPR5U3X/as9aNIMrd6TbmoIVlZfs4hRsB?=
 =?us-ascii?Q?/JcPiON7H9IkhL4SED6qk1hIwQYnas+qb9XKkmRRttEmZIQT9vesmnJYyKUL?=
 =?us-ascii?Q?+euMC/VFQF/ySOm6xKdpONJCfmo/aVBY8UcwZjXyeYXwTYODrbb2SFQxh9HW?=
 =?us-ascii?Q?DrsuZDitFKFNwW+lvaV4rSnvp5nYrcwLLAX+3CBWDVWZWKVLNRi9gk9N2Bfs?=
 =?us-ascii?Q?qzE0B8PJUmBG6FGs4ucJ29RN6MpX73RYeh2cCM+L6+XplUPJQSMGsdGGjBNg?=
 =?us-ascii?Q?VG2NqPofST9L8UeIOU7/pky9mLK7fiyKrZAhe64LY5Kr0s4TpLZOKJaaTBG9?=
 =?us-ascii?Q?MIadj1632Tzw/h0esSJB4Kv5DNY80oRs1deAbkgYlvsLutd4YbFo5QhqjEFl?=
 =?us-ascii?Q?q6nwJSkJ/LTo7bc0AG8oHhwgs+LoN7OUtnVc2/GHFBJcMVfUR1qJVKO2Pl62?=
 =?us-ascii?Q?1MSh/Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f69aa9b-3efb-4e9e-5e96-08db0b69abbf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 13:21:09.3359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WYDy3U+HYHmbmF67tP2hY2R1j6ZOTIA4EuueeKMSt52Rwj0nWyWx0Ku5uK5+66EjQvWJeo2WUHeCS4yIozNe51J2FPNbsSjSQony0bgDKOQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5681
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 10:26:42AM +0100, Sascha Hauer wrote:
> The hardware can't handle urbs with a data size of multiple of
> bulkout_size. With such a packet the endpoint gets stuck and only
> replugging the hardware helps.
> 
> Fix this by moving the header eight bytes down, thus making the packet
> eight bytes bigger. The same is done in rtw_usb_write_data_rsvd_page()
> already, but not yet for the tx data.
> 
> Fixes: a82dfd33d1237 ("wifi: rtw88: Add common USB chip support")
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  drivers/net/wireless/realtek/rtw88/tx.h  |  2 ++
>  drivers/net/wireless/realtek/rtw88/usb.c | 34 +++++++++++++++---------
>  2 files changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/tx.h b/drivers/net/wireless/realtek/rtw88/tx.h
> index a2f3ac326041b..38ce9c7ae62ed 100644
> --- a/drivers/net/wireless/realtek/rtw88/tx.h
> +++ b/drivers/net/wireless/realtek/rtw88/tx.h
> @@ -75,6 +75,8 @@
>  	le32p_replace_bits((__le32 *)(txdesc) + 0x07, value, GENMASK(15, 0))
>  #define SET_TX_DESC_DMA_TXAGG_NUM(txdesc, value)				\
>  	le32p_replace_bits((__le32 *)(txdesc) + 0x07, value, GENMASK(31, 24))
> +#define GET_TX_DESC_OFFSET(txdesc)	                                      \
> +	le32_get_bits(*((__le32 *)(txdesc) + 0x00), GENMASK(23, 16))
>  #define GET_TX_DESC_PKT_OFFSET(txdesc)						\
>  	le32_get_bits(*((__le32 *)(txdesc) + 0x01), GENMASK(28, 24))
>  #define GET_TX_DESC_QSEL(txdesc)						\
> diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
> index d9e995544e405..08cd480958b6b 100644
> --- a/drivers/net/wireless/realtek/rtw88/usb.c
> +++ b/drivers/net/wireless/realtek/rtw88/usb.c
> @@ -281,6 +281,7 @@ static int rtw_usb_write_port(struct rtw_dev *rtwdev, u8 qsel, struct sk_buff *s
>  static bool rtw_usb_tx_agg_skb(struct rtw_usb *rtwusb, struct sk_buff_head *list)
>  {
>  	struct rtw_dev *rtwdev = rtwusb->rtwdev;
> +	const struct rtw_chip_info *chip = rtwdev->chip;

nit: Local variable should be sorted from longest line to shortest line,
     aka reverse xmas tree.

     As you've said you will post a v2 I feel better about pointing this out -
     it's not worth a respin in it's own right.
