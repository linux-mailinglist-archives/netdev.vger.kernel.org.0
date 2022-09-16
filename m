Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1878B5BAE45
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 15:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbiIPNgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 09:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbiIPNgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 09:36:01 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8256AC24E
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 06:35:59 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id d2so516000wrq.2
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 06:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date;
        bh=XW8+qpRBCJneueDUd4dskNmG0LQUz+/N8HMr+mJE/Sk=;
        b=QJ8FPCg72M5vWK6VXJ3SK5XuBumpeBX6o2B1dXOxYOrm2d6MPmZFy/Qx15GXEwlZKv
         97ouEMWjzj4pwUOT63zhKIPGbnnlTpw8mwvptzj59vC+iz+Ke+VBaYVdehDedFBjpYYb
         AThwlhuDQ/MOgNuRnwohYmtrnRtpMLrWSrOhkFXRWfFoaH2MsJDjxC2YEKaZhdD88vms
         6TN2mfpzurmT2PcQAoWWIL5GXRDOGOwRm0c9M4qsldOpAdGumhZqB9FwnXcrNCLy7k4v
         mKmIEdTdSQZ5EVpY8yDlp00Qt0QIEvzVRAmFY9rOTgY3P9+rOvV+n2rTGJhAxmGU3SdK
         7Ysg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=XW8+qpRBCJneueDUd4dskNmG0LQUz+/N8HMr+mJE/Sk=;
        b=XXFyX9OmgdWcUinlJXlCORnvq39LGRbLpM1VhepNebZpiD76OznEMC/6iQHrLM50Cc
         w72Lte/PAKZ6CpeiRSxJiOTneH7Q2BjrG8jiKKybSGc9h0AKSgxt8z1S5fdCkme7RzBr
         f8qBotZoEOg86JAhrUTikplABATmfkGqUnCywwMhgEE9i12jSHWodSvvdJ1FxmWwnbfn
         HWO/P1IPtt4rR85mZ/t2+AhH6AlZartXIrf8sZFuMosNHUFe2Tm3frk0nMiq8MM14/na
         L2p/8a4PU07HLj8g7CdLAPMy2CAm6JerMsOplRrW9vxo6gke41KDHRtKgme643x5nJBj
         LNqg==
X-Gm-Message-State: ACrzQf1L7ANfg5kMQ37ZOe+mVc9RFlxr+i06y7MzbF5vWJ9+4NQoH6oc
        5hECXXvoc7UJp54IhGdfwoA=
X-Google-Smtp-Source: AMsMyM5hqTRqzT8JdEIfs8V0GgUI8sEyuxhzY8+5aFanqIoF8ygV0TASAbffcUPnqrFdb9qZFya3ow==
X-Received: by 2002:a5d:4a41:0:b0:228:48c6:7386 with SMTP id v1-20020a5d4a41000000b0022848c67386mr2905588wrs.649.1663335358005;
        Fri, 16 Sep 2022 06:35:58 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.gmail.com with ESMTPSA id ci10-20020a5d5d8a000000b0021e6c52c921sm6253083wrb.54.2022.09.16.06.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 06:35:57 -0700 (PDT)
Message-ID: <63247bbd.5d0a0220.2e1d3.e804@mx.google.com>
X-Google-Original-Message-ID: <YyQSbqrSunKfz0+A@Ansuel-xps.>
Date:   Fri, 16 Sep 2022 08:06:38 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk
Subject: Re: [PATCH net-next v13 2/6] net: dsa: Add convenience functions for
 frame handling
References: <20220916121817.4061532-1-mattias.forsblad@gmail.com>
 <20220916121817.4061532-3-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916121817.4061532-3-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 02:18:13PM +0200, Mattias Forsblad wrote:
> Add common control functions for drivers that need
> to send and wait for control frames.
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
> ---
>  include/net/dsa.h | 11 +++++++++++
>  net/dsa/dsa.c     | 17 +++++++++++++++++
>  net/dsa/dsa2.c    |  2 ++
>  3 files changed, 30 insertions(+)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index f2ce12860546..08f3fff5f4df 100644
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
> @@ -1390,6 +1392,15 @@ void dsa_tag_drivers_register(struct dsa_tag_driver *dsa_tag_driver_array[],
>  void dsa_tag_drivers_unregister(struct dsa_tag_driver *dsa_tag_driver_array[],
>  				unsigned int count);
>  
> +int dsa_switch_inband_tx(struct dsa_switch *ds, struct sk_buff *skb,
> +			 struct completion *completion, unsigned long timeout);
> +
> +static inline void dsa_switch_inband_complete(struct dsa_switch *ds, struct completion *completion)
> +{
> +	/* Custom completion? */
> +	complete(completion ?: &ds->inband_done);

Missing handling for custom completion!

Should be 

complete(completion ? completion : &ds->inband_done);

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

Missing handling for custom completion!

Should be

com = completion ? completion : &ds->inband_done;

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
> index ed56c7a554b8..a048a6200789 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -874,6 +874,8 @@ static int dsa_switch_setup(struct dsa_switch *ds)
>  	if (ds->setup)
>  		return 0;
>  
> +	init_completion(&ds->inband_done);
> +
>  	/* Initialize ds->phys_mii_mask before registering the slave MDIO bus
>  	 * driver and before ops->setup() has run, since the switch drivers and
>  	 * the slave MDIO bus driver rely on these values for probing PHY
> -- 
> 2.25.1
> 

-- 
	Ansuel
