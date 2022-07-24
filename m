Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379E557F754
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 00:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiGXWal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 18:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiGXWak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 18:30:40 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1A75FE2;
        Sun, 24 Jul 2022 15:30:35 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id ez10so17346874ejc.13;
        Sun, 24 Jul 2022 15:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2Qzx1Z7L+EZixzsm8VAelEwWs1b6t7AVKnbC6Ax2JIM=;
        b=P7HIlS9EU0iDpPgoa0C7GYzm6uzV2IqroC7M0gsKPXwJllyQh7ylAnnHYeCIDQ3nnq
         Eh7cndMCdSdb0Cy/tcfEVD0mEB/1V4JdYjlh3dAVwHatkPMk40dB+B0fZ+Ko3xSQhegF
         4XpVkUri476bRfSTXdIj6rkIe+bCr2XgAisZrJsV4d2anhygD6DhfH2XDstMFxO8zXBE
         Q4YvGgJvsQKuyTHerbwSKGyKbwpwS2TcU92o2FjI1ZbeQv/gMZvOgcMtyGcKCcMAozXx
         F2uk00F1uGbOvh9uFWRpzRgJRBiEPtEmSidaYAB5S6EKHgW87Ivk/p51j+5mB1socjgf
         ky9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2Qzx1Z7L+EZixzsm8VAelEwWs1b6t7AVKnbC6Ax2JIM=;
        b=M+hKQLmefYX9OuEkDBmsNS/XpoplCVSTT0ThzPjdKtFBNP+qxf3i4Dsr/PDuToFUJB
         80/pjVlRROOTJ8Az1VXsAr9vW9O7ihHMzfL05oY2haeI0KIwdTejdV2CMAukjiKIKZA6
         4T7sD8kOSwD/rYgjcm9d/ORFsDpvhyxxtWBZGN5hKH20ohif49mmXFfbHU+35XKRqbku
         yd0u8F/YxczBP+7oOeR9ylCo8YYfiITMp4l+g5opc3+UlSxgFhDRYzxy1BfvTwD8PDuw
         mtik9vHMGwpPZa3AGQxFmly0jDQsoCD1rU2D8fWFwgbX9z+nCsPwIzuZTVU6lF4XFG7n
         jcIw==
X-Gm-Message-State: AJIora/B/sqxO3C1lOpzaK8Y2cx0q4e8KXQbRVExwRT6MsR8orEw5gub
        P9VMRe5UQG6XDkLc29kCYog=
X-Google-Smtp-Source: AGRyM1varIJtrZ+zurOQr5356vVX2dxwfzORj61kyaEFoy0mj5AqismRkQPo8DtDcMcZUQ//DGlnRg==
X-Received: by 2002:a17:907:6d99:b0:72f:4633:65 with SMTP id sb25-20020a1709076d9900b0072f46330065mr7791124ejc.320.1658701834521;
        Sun, 24 Jul 2022 15:30:34 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id k14-20020a170906578e00b0072f03d10fa0sm4604917ejq.207.2022.07.24.15.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 15:30:33 -0700 (PDT)
Date:   Mon, 25 Jul 2022 01:30:31 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH v3 01/14] net: dsa: qca8k: cache match data to
 speed up access
Message-ID: <20220724223031.2ceczkbov6bcgrtq@skbuf>
References: <20220723141845.10570-1-ansuelsmth@gmail.com>
 <20220723141845.10570-1-ansuelsmth@gmail.com>
 <20220723141845.10570-2-ansuelsmth@gmail.com>
 <20220723141845.10570-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220723141845.10570-2-ansuelsmth@gmail.com>
 <20220723141845.10570-2-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 23, 2022 at 04:18:32PM +0200, Christian Marangi wrote:
> Using of_device_get_match_data is expensive. Cache match data to speed

'is expensive' sounds like it's terribly expensive. It's just more than
it needs to be.

> up access and rework user of match data to use the new cached value.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca/qca8k.c | 28 ++++++++++------------------
>  drivers/net/dsa/qca/qca8k.h |  1 +
>  2 files changed, 11 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca/qca8k.c b/drivers/net/dsa/qca/qca8k.c
> index 1cbb05b0323f..212b284f9f73 100644
> --- a/drivers/net/dsa/qca/qca8k.c
> +++ b/drivers/net/dsa/qca/qca8k.c
> @@ -3168,6 +3155,11 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
>  	if (ret)
>  		return ret;
>  
> +	/* Cache match data in priv struct.
> +	 * Match data is already checked in read_switch_id.
> +	 */
> +	priv->info = of_device_get_match_data(priv->dev);
> +

So why don't you set priv->info right before calling qca8k_read_switch_id(),
then?

>  	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
>  	if (!priv->ds)
>  		return -ENOMEM;
> diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
> index ec58d0e80a70..0b990b46890a 100644
> --- a/drivers/net/dsa/qca/qca8k.h
> +++ b/drivers/net/dsa/qca/qca8k.h
> @@ -401,6 +401,7 @@ struct qca8k_priv {
>  	struct qca8k_mdio_cache mdio_cache;
>  	struct qca8k_pcs pcs_port_0;
>  	struct qca8k_pcs pcs_port_6;
> +	const struct qca8k_match_data *info;
>  };
>  
>  struct qca8k_mib_desc {
> -- 
> 2.36.1
> 

