Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A375B4EFF
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 15:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiIKN1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 09:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiIKN1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 09:27:24 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7D9E033
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 06:27:23 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id e20so11220168wri.13
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 06:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=K5uRGIwkf1aq2HVsdCntI2XpGWBVBujegZe0/8iq0k0=;
        b=lOrGkzSRzO5COQKqGDHu1M/8WH+3g/ZPjroJMvQDGqyKiD+UBCmGHiyIpZ19fG6dUf
         AW3Mod1MO75kSdHZHgDi/uv2Yxd2IxeAFonFCosx/VjqYtrvjfUIA/4grNKKOkllyPBS
         1ykE/QASWtgH50ev54aDAsxsgA0s7hW/Uhmx2lMZZUcJstI0zhFpunIfWyMPIF18UXy8
         QFIFsm99DnW4Rh2jQRtPZK7HLES4U3bEQj4Au4GrU4/t6LD36CFpOQFxhSlqeWfwPLuW
         TvHLxofkh8LH4HTqjYiUGaWOM4d8jEpEn+m9E7wo0PBvH0ytHD3IQAS6cmo5qzbmG8WG
         wz8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=K5uRGIwkf1aq2HVsdCntI2XpGWBVBujegZe0/8iq0k0=;
        b=DtvMOBhSkEh1WnzOYhyznlXATNksurYW7J80CRqBBGVD0MtJC81wQrCETcCA6m7thu
         KZZ03NFIvF903gWm6nyfV49UIlBHIrK77zA0OjxsQ3TYjemz8sU12hsy+VpIzxBhfU1u
         vd7O6o6LmUyGtgG3LecKDMarIJADHmAFY6NfAJfihTryp34BIT3CRKKNe9/4AxQyThWU
         LjrjOo5hudtjyJwjVcp3hfXKMFvrw40FY9qogxH2CKf10WsnMq0lTL1mKS/gWPZbSQ6X
         +qwUTygRkRuj9eCV3EvCbCsWbeskRO9Ti7plWcQiIyJKymaslABb25J4fMR54DupYmIH
         A7ZA==
X-Gm-Message-State: ACgBeo2cnplDSq+Fo8gKeR6ILGn7aR9/qNFKyEKH5wcCQouJxV45xs4X
        8/cGV0nlU+lJBTgI1DSSI/KGe8coxDXwOtP/
X-Google-Smtp-Source: AA6agR4k/KhiFgfEYZSKCFMqwOwCv9Ou1Rbqc/kfvCgGlaWN/N1r/gGymX8eeXS6EMPejs5AKdk4bA==
X-Received: by 2002:adf:fb0e:0:b0:21a:34a2:5ca9 with SMTP id c14-20020adffb0e000000b0021a34a25ca9mr12918458wrr.472.1662902841778;
        Sun, 11 Sep 2022 06:27:21 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id f12-20020a05600c154c00b003a5f3f5883dsm7072707wmg.17.2022.09.11.06.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Sep 2022 06:27:19 -0700 (PDT)
Date:   Sun, 11 Sep 2022 16:27:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v8 2/6] net: dsa: Add convenience functions for
 frame handling
Message-ID: <20220911132716.ho2gvylo7ct53p2z@skbuf>
References: <20220909085138.3539952-1-mattias.forsblad@gmail.com>
 <20220909085138.3539952-1-mattias.forsblad@gmail.com>
 <20220909085138.3539952-3-mattias.forsblad@gmail.com>
 <20220909085138.3539952-3-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909085138.3539952-3-mattias.forsblad@gmail.com>
 <20220909085138.3539952-3-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 09, 2022 at 10:51:34AM +0200, Mattias Forsblad wrote:
> Add common control functions for drivers that need
> to send and wait for control frames.
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 

Please no new lines between tags.

> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
> ---
>  include/net/dsa.h | 14 ++++++++++++++
>  net/dsa/dsa.c     | 17 +++++++++++++++++
>  net/dsa/dsa2.c    |  2 ++
>  3 files changed, 33 insertions(+)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index f2ce12860546..0e8a7ef17490 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -495,6 +495,8 @@ struct dsa_switch {
>  	unsigned int		max_num_bridges;
>  
>  	unsigned int		num_ports;
> +
> +	struct completion	inband_done;
>  };
>  
>  static inline struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
> @@ -1390,6 +1392,18 @@ void dsa_tag_drivers_register(struct dsa_tag_driver *dsa_tag_driver_array[],
>  void dsa_tag_drivers_unregister(struct dsa_tag_driver *dsa_tag_driver_array[],
>  				unsigned int count);
>  
> +int dsa_switch_inband_tx(struct dsa_switch *ds, struct sk_buff *skb,
> +			 struct completion *completion, unsigned long timeout);
> +
> +static inline void dsa_switch_inband_complete(struct dsa_switch *ds, struct completion *completion)
> +{
> +	/* Custom completion? */
> +	if (completion)
> +		complete(completion);
> +	else
> +		complete(&ds->inband_done);

Could you please do the same thing here as what Paolo suggested:
	complete(completion ?: &ds->inband_done);

> +}
> +
>  #define dsa_tag_driver_module_drivers(__dsa_tag_drivers_array, __count)	\
>  static int __init dsa_tag_driver_module_init(void)			\
>  {									\
> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
> index be7b320cda76..ad870494d68b 100644
> --- a/net/dsa/dsa.c
> +++ b/net/dsa/dsa.c
> @@ -324,6 +324,23 @@ int dsa_switch_resume(struct dsa_switch *ds)
>  EXPORT_SYMBOL_GPL(dsa_switch_resume);
>  #endif
>  
> +int dsa_switch_inband_tx(struct dsa_switch *ds, struct sk_buff *skb,
> +			 struct completion *completion, unsigned long timeout)
> +{
> +	struct completion *com;
> +
> +	/* Custom completion? */
> +	com = completion ? : &ds->inband_done;
> +
> +	reinit_completion(com);
> +
> +	if (skb)
> +		dev_queue_xmit(skb);
> +
> +	return wait_for_completion_timeout(com, msecs_to_jiffies(timeout));
> +}
> +EXPORT_SYMBOL_GPL(dsa_switch_inband_tx);
> +
>  static struct packet_type dsa_pack_type __read_mostly = {
>  	.type	= cpu_to_be16(ETH_P_XDSA),
>  	.func	= dsa_switch_rcv,
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index ed56c7a554b8..a1b3ecfdffb8 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -1746,6 +1746,8 @@ static int dsa_switch_probe(struct dsa_switch *ds)
>  		dsa_tree_put(dst);
>  	}
>  
> +	init_completion(&ds->inband_done);
> +

This is actually done relatively late here (later than ds->ops->setup()
is called), considering that we could use Ethernet based management even
for general purpose register access. I would consider putting it right
at the beginning of dsa_switch_setup(), after the "if (ds->setup)" check.

>  	return err;
>  }
>  
> -- 
> 2.25.1
> 
