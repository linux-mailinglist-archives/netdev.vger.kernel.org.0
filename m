Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8FB45835F1
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 02:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbiG1AQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 20:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbiG1AQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 20:16:54 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31C23CBC4;
        Wed, 27 Jul 2022 17:16:52 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id c12so339113ede.3;
        Wed, 27 Jul 2022 17:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C6RAE1a1Bc4ObLkmdDcK9tLiJStgQZc6LUI7DcYpSNM=;
        b=l1/LFpzB21Z1SAE7oukq7+vJKeb5oGRGuAMKUWx3wPJaogzfJdBqTkGIC6LU667ZZK
         lvCk90yP5qUg65hpD02UCexeQyZdVZGmQfRObEbw/xjIhM41hQAHvbgDQCuF/oxzlPxJ
         KQPzgeQUDGhMB6tNsRaJDmoPcCkW7dPCcbY+ggvsLH8fHSwS2HqQL3ETZHD4Ud2vPYs8
         gOe5KVbDy06+Vv39sZ2rCGt9IXh2ZEwpV3Lroj765xKuqNmlLKY1E2Fh/yF8vrAc5VRk
         p7nDOdTpqRlNH2dIgyOyu1ZDCfpGu6+W3MhM9qnshxLE9o2AwDSJaOiRDGEVT4toHwZ9
         6L0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C6RAE1a1Bc4ObLkmdDcK9tLiJStgQZc6LUI7DcYpSNM=;
        b=LMyl6BIJ3SM1ohdkEcRTrYA4I2uenPLnSEFKh9oA+rLJRlyIWiyLeqIyesJzxKw5nj
         xFiYmSgF5RCH4HIfMv0VVR6nOlKoXrO+qSm3MSK5Tfn1RFq6AEXUGTZ8CG6o0q7Dm8mL
         /d1fdJH4c2PPtYMJDg0MnqhN6ewzsM007POfDS6+23EvEiVTLcA0+5OQib3UjfH+1woh
         DM1DEvyTnL7wmpoBl8Ev/tpxFKr4/6Xk5eZLkzfo6E9LTR4Kg36ctj9yEbYQKnTt+7cv
         /VHMQQ0ZMyq0JdC4zKa211TptdGRGRgXFcNsb754qhjin28/daAOTlssMlesdOqkrx+4
         /vvQ==
X-Gm-Message-State: AJIora8xnRgPEzjM1FMgrFw4Py4BJUAKtdi+TFwRfEpIrFEnQzD3IXhK
        dgclgKBpuDxlmpv2SuZ/f1M=
X-Google-Smtp-Source: AGRyM1u811vwQ4RWBp6/UEDzF/f3z2zSd6LhqTusd7PIxevVUPqyI9m6F+I6IIyFCknECu1j5XzVbw==
X-Received: by 2002:a50:fe89:0:b0:43b:22af:4c8b with SMTP id d9-20020a50fe89000000b0043b22af4c8bmr25979904edt.296.1658967411399;
        Wed, 27 Jul 2022 17:16:51 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id i12-20020a170906a28c00b00722e771007fsm8263423ejz.37.2022.07.27.17.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 17:16:50 -0700 (PDT)
Date:   Thu, 28 Jul 2022 03:16:48 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Souptick Joarder <jrdr.linux@gmail.com>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] net: dsa: microchip: remove of_match_ptr() from
 ksz9477_dt_ids
Message-ID: <20220728001648.cwfcmcg75lpqip5v@skbuf>
References: <20220727025255.61232-1-jrdr.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727025255.61232-1-jrdr.linux@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 08:22:55AM +0530, Souptick Joarder wrote:
> From: "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>
>
> >> drivers/net/dsa/microchip/ksz9477_i2c.c:89:34:
> warning: 'ksz9477_dt_ids' defined but not used [-Wunused-const-variable=]
>       89 | static const struct of_device_id ksz9477_dt_ids[] = {
>          |                                  ^~~~~~~~~~~~~~
>
> Removed of_match_ptr() from ksz9477_dt_ids.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Souptick Joarder (HPE) <jrdr.linux@gmail.com>
> ---

I have to say, this is a major fail for what of_match_ptr() intended to do.

commit 3a1e362e3f3cd571b3974b8d44b8e358ec7a098c
Author: Ben Dooks <ben-linux@fluff.org>
Date:   Wed Aug 3 10:11:42 2011 +0100

    OF: Add of_match_ptr() macro

    Add a macro of_match_ptr() that allows the .of_match_table
    entry in the driver structures to be assigned without having
    an #ifdef xxx NULL for the case that OF is not enabled

    Signed-off-by: Ben Dooks <ben-linux@fluff.org>
    Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Should we also depend on CONFIG_OF?

>  drivers/net/dsa/microchip/ksz9477_i2c.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
> index 99966514d444..c967a03a22c6 100644
> --- a/drivers/net/dsa/microchip/ksz9477_i2c.c
> +++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
> @@ -118,7 +118,7 @@ MODULE_DEVICE_TABLE(of, ksz9477_dt_ids);
>  static struct i2c_driver ksz9477_i2c_driver = {
>  	.driver = {
>  		.name	= "ksz9477-switch",
> -		.of_match_table = of_match_ptr(ksz9477_dt_ids),
> +		.of_match_table = ksz9477_dt_ids,
>  	},
>  	.probe	= ksz9477_i2c_probe,
>  	.remove	= ksz9477_i2c_remove,
> --
> 2.25.1
>
