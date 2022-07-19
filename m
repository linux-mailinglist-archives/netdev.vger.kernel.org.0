Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAAD579EB5
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242697AbiGSNFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243178AbiGSNEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:04:49 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C6C9E453;
        Tue, 19 Jul 2022 05:26:41 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id b11so26819927eju.10;
        Tue, 19 Jul 2022 05:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RSZdkbs7G5hpiwtEWakB2gPa7jiA92IHYDoa8/9e8k4=;
        b=Br7VhjTprCTlBd54jgegp22vK1wZcz92cjq5uvwAbO8jfJwmwH87LR8WMK+POisPrg
         w1msUFPvl54GLQ3ROFy/yaVLWe72v0jzwx+rjvbGf+SMYaL3gq1Wjq6y8g6Qb0hDojbA
         6z3NUj0xFOK/J3/SFL+AUbpyqXitHvGRZtNAf+W4HVt61VYBpVgz2b8XX8K5HkF6aPoC
         f3CBoImm9z+8s0Kjgaf/0gVsxt6A6iqH8EzjwE3/v+XCh3F6nzPL2se82Wi/rLTbadHs
         GyczTlswct9rygp3/JYntJa6UdiFDiIVl7KsIVEGzQoJHoQO+H8JdzzeSRFyRAJJEZX9
         FnBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RSZdkbs7G5hpiwtEWakB2gPa7jiA92IHYDoa8/9e8k4=;
        b=R9dl9XZJ5kT1JFN8rm9XPRIb0EM6OZpFTcP06JXNv4jHxAe1rE54ogtD6C0I5/wk6c
         qgadD9K3qF0ivQDSdMXH2Iv9bjVQjgHfqBdoTYdktnUl9vEtEb734wRS+Iv2PmruBUUM
         J8DWl1vyctNMd0Ai388KFC+G3y/wgmt0sGP3ksR0//AumQkPiavIJVlMbmU7y3k+l1LG
         UrCfW/LNx86KDGmfLLqVvuAXI7s0Zi4UnY1XuUp3VEfwvCHEj05w+ejcu6BpcLmXp3Lh
         8OfyKDgBpYyl7PdK4ij7ocjpBxlDdCkgFUTOzgxobLPfcIP363BERmFxCECQJrjuY2ck
         2Svw==
X-Gm-Message-State: AJIora+3JB4Y3xtI4AFARBQYuDTghYWux9in4NbFtlv0yjvFiA9iiT+a
        z0fEIjfJv24Fqd4X6ckkv34=
X-Google-Smtp-Source: AGRyM1tURG3fThixiG3XqEDGKnIhCymWFz4fxyXTcpaisc9YP/lagOO4waqgRh+b0WOC4y9v8Ye0Ew==
X-Received: by 2002:a17:907:2e0d:b0:72b:8cd4:ca52 with SMTP id ig13-20020a1709072e0d00b0072b8cd4ca52mr29446627ejc.541.1658233599652;
        Tue, 19 Jul 2022 05:26:39 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id n23-20020aa7c697000000b0043a71c376a2sm10493515edq.33.2022.07.19.05.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 05:26:38 -0700 (PDT)
Date:   Tue, 19 Jul 2022 15:26:36 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH v2 01/15] net: dsa: qca8k: make mib autocast
 feature optional
Message-ID: <20220719122636.rsfkejgampb5kcp2@skbuf>
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-2-ansuelsmth@gmail.com>
 <20220719005726.8739-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719005726.8739-2-ansuelsmth@gmail.com>
 <20220719005726.8739-2-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 02:57:11AM +0200, Christian Marangi wrote:
> Some switch may not support mib autocast feature and require the legacy
> way of reading the regs directly.
> Make the mib autocast feature optional and permit to declare support for
> it using match_data struct.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca/qca8k.c | 11 +++++++----
>  drivers/net/dsa/qca/qca8k.h |  1 +
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca/qca8k.c b/drivers/net/dsa/qca/qca8k.c
> index 1cbb05b0323f..a57c53ce2f0c 100644
> --- a/drivers/net/dsa/qca/qca8k.c
> +++ b/drivers/net/dsa/qca/qca8k.c
> @@ -2112,12 +2112,12 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
>  	u32 hi = 0;
>  	int ret;
>  
> -	if (priv->mgmt_master &&
> -	    qca8k_get_ethtool_stats_eth(ds, port, data) > 0)
> -		return;
> -
>  	match_data = of_device_get_match_data(priv->dev);

I didn't notice at the time that you already call of_device_get_match_data()
at driver runtime, but please be aware that it is a relatively expensive
operation (takes raw spinlocks, iterates etc), or at least much more
expensive than it needs to be. What other drivers do is cache the result
of this function once in priv->info and just use priv->info, since it
won't change during the lifetime of the driver.

>  
> +	if (priv->mgmt_master && match_data->autocast_mib &&
> +	    match_data->autocast_mib(ds, port, data) > 0)
> +		return;
> +
>  	for (i = 0; i < match_data->mib_count; i++) {
>  		mib = &ar8327_mib[i];
>  		reg = QCA8K_PORT_MIB_COUNTER(port) + mib->offset;
> @@ -3260,16 +3260,19 @@ static const struct qca8k_match_data qca8327 = {
>  	.id = QCA8K_ID_QCA8327,
>  	.reduced_package = true,
>  	.mib_count = QCA8K_QCA832X_MIB_COUNT,
> +	.autocast_mib = qca8k_get_ethtool_stats_eth,

I thought you were going to create a dedicated sub-structure for
function pointers?

>  };
>  
>  static const struct qca8k_match_data qca8328 = {
>  	.id = QCA8K_ID_QCA8327,
>  	.mib_count = QCA8K_QCA832X_MIB_COUNT,
> +	.autocast_mib = qca8k_get_ethtool_stats_eth,
>  };
>  
>  static const struct qca8k_match_data qca833x = {
>  	.id = QCA8K_ID_QCA8337,
>  	.mib_count = QCA8K_QCA833X_MIB_COUNT,
> +	.autocast_mib = qca8k_get_ethtool_stats_eth,
>  };
>  
>  static const struct of_device_id qca8k_of_match[] = {
> diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
> index ec58d0e80a70..c3df0a56cda4 100644
> --- a/drivers/net/dsa/qca/qca8k.h
> +++ b/drivers/net/dsa/qca/qca8k.h
> @@ -328,6 +328,7 @@ struct qca8k_match_data {
>  	u8 id;
>  	bool reduced_package;
>  	u8 mib_count;
> +	int (*autocast_mib)(struct dsa_switch *ds, int port, u64 *data);
>  };
>  
>  enum {
> -- 
> 2.36.1
> 

