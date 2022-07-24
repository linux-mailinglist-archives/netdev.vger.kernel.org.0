Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF6257F759
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 00:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbiGXWdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 18:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiGXWdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 18:33:53 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9357B6176;
        Sun, 24 Jul 2022 15:33:52 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id ss3so17389815ejc.11;
        Sun, 24 Jul 2022 15:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b3VSvKp8fXTk4ug7ffkxMisEEs2oxQK6593xJQY9zGo=;
        b=IV+Q4zWxZP4cRCbJYRRl5nEpcWQZFN7c1UO+OmjXNrEf4Uvq1z4Hy5TWx/TT3ki7tR
         AoOnC5eKwmIqrNuYEgaIpZB+PMBnE97AG9rCQZPecXPX0GznxF48TXtVWEIYzip5eyhU
         gMWLZNc+n7S/+hPAp+ekGffDymN1TMLyf7DxywmPTKWWEkiv0JeUsMFk2C3lVIsk+RVd
         lIT6VG7hvOCKuZylH4iefPBSFLb3cQAFl0p5r1tTOS5L/SBzeZLax37/GVgl4LNDL3yz
         6oRlfLHNgRgRIbU2w80BU4Ajb4Lu8+AZzWHeeO3UoRCoLU2pXs3Vwy56YFT4esTjTMoW
         sYzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b3VSvKp8fXTk4ug7ffkxMisEEs2oxQK6593xJQY9zGo=;
        b=MvmsckTaNsl9RnxGpxv8R2s31+iW+1ox8IT2RMMez0TDCm8XKBuASTg0gE3jMMlbUQ
         r3BWHdDejVNkbWUbIiNwNN3SGjrtyKsyxrC6uo/H8BPZWIWD6Rcj5xj13kpcLpAVQ3f0
         1Nm39ghP8ajQ34xJwIgI6s+0KjbRYAUVFkZIfeVXqS2+iYlp6XaH2uXTmqEudGD6VPFr
         Rahq5Kmsij2VAhOXLgb1MeRo+ctDvLBLK31oBDIwI0tBUfEJa/9sf09znNXzEgLt7+3h
         +Znn+4hxeCKDF+6pNmnLg6GRwPPWDKElKGA+VFDHkvZ+GW+WvehXrIK7ZLDWAIAEnsKH
         tD7g==
X-Gm-Message-State: AJIora8t0eu4uW/aetH++aZn2z5Lm543eLgc/zWHryBJCvf8qxfkuPiK
        PH6zXX/n0TjnJBq8JwDMgOU=
X-Google-Smtp-Source: AGRyM1s3dMFTJnj1CooXfK/OlqcUurVIDIX86DDLAnNGzOb3zqck4jrnK/IjG/S2kYm3DeCv+ldSYQ==
X-Received: by 2002:a17:907:6d07:b0:72f:18bf:505 with SMTP id sa7-20020a1709076d0700b0072f18bf0505mr7646941ejc.406.1658702031008;
        Sun, 24 Jul 2022 15:33:51 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id m5-20020a17090672c500b0072b56098fc6sm4616175ejl.127.2022.07.24.15.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 15:33:50 -0700 (PDT)
Date:   Mon, 25 Jul 2022 01:33:48 +0300
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
Subject: Re: [net-next PATCH v3 02/14] net: dsa: qca8k: make mib autocast
 feature optional
Message-ID: <20220724223348.tqh45ygbuyw7jp5s@skbuf>
References: <20220723141845.10570-1-ansuelsmth@gmail.com>
 <20220723141845.10570-1-ansuelsmth@gmail.com>
 <20220723141845.10570-3-ansuelsmth@gmail.com>
 <20220723141845.10570-3-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220723141845.10570-3-ansuelsmth@gmail.com>
 <20220723141845.10570-3-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 23, 2022 at 04:18:33PM +0200, Christian Marangi wrote:
> Some switch may not support mib autocast feature and require the legacy
> way of reading the regs directly.
> Make the mib autocast feature optional and permit to declare support for
> it using match_data struct in a dedicated qca8k_info_ops struct.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca/qca8k.c | 11 +++++++++--
>  drivers/net/dsa/qca/qca8k.h |  5 +++++
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca/qca8k.c b/drivers/net/dsa/qca/qca8k.c
> index 212b284f9f73..9820c5942d2a 100644
> --- a/drivers/net/dsa/qca/qca8k.c
> +++ b/drivers/net/dsa/qca/qca8k.c
> @@ -2104,8 +2104,8 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
>  	u32 hi = 0;
>  	int ret;
>  
> -	if (priv->mgmt_master &&
> -	    qca8k_get_ethtool_stats_eth(ds, port, data) > 0)
> +	if (priv->mgmt_master && priv->info->ops.autocast_mib &&
> +	    priv->info->ops.autocast_mib(ds, port, data) > 0)
>  		return;
>  
>  	for (i = 0; i < priv->info->mib_count; i++) {
> @@ -3248,20 +3248,27 @@ static int qca8k_resume(struct device *dev)
>  static SIMPLE_DEV_PM_OPS(qca8k_pm_ops,
>  			 qca8k_suspend, qca8k_resume);
>  
> +static const struct qca8k_info_ops qca8xxx_ops = {
> +	.autocast_mib = qca8k_get_ethtool_stats_eth,
> +};
> +
>  static const struct qca8k_match_data qca8327 = {
>  	.id = QCA8K_ID_QCA8327,
>  	.reduced_package = true,
>  	.mib_count = QCA8K_QCA832X_MIB_COUNT,
> +	.ops = qca8xxx_ops,
>  };
>  
>  static const struct qca8k_match_data qca8328 = {
>  	.id = QCA8K_ID_QCA8327,
>  	.mib_count = QCA8K_QCA832X_MIB_COUNT,
> +	.ops = qca8xxx_ops,
>  };
>  
>  static const struct qca8k_match_data qca833x = {
>  	.id = QCA8K_ID_QCA8337,
>  	.mib_count = QCA8K_QCA833X_MIB_COUNT,
> +	.ops = qca8xxx_ops,
>  };
>  
>  static const struct of_device_id qca8k_of_match[] = {
> diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
> index 0b990b46890a..7b4a698f092a 100644
> --- a/drivers/net/dsa/qca/qca8k.h
> +++ b/drivers/net/dsa/qca/qca8k.h
> @@ -324,10 +324,15 @@ enum qca8k_mid_cmd {
>  	QCA8K_MIB_CAST = 3,
>  };
>  
> +struct qca8k_info_ops {
> +	int (*autocast_mib)(struct dsa_switch *ds, int port, u64 *data);
> +};
> +
>  struct qca8k_match_data {
>  	u8 id;
>  	bool reduced_package;
>  	u8 mib_count;
> +	struct qca8k_info_ops ops;

This creates a copy of the structure for each of qca8327, qca8328, etc etc,
which in turn will consume 3 times more space than necessary when new
ops are added. Could you make this "const struct qca8k_ops *ops"?

>  };
>  
>  enum {
> -- 
> 2.36.1
> 

