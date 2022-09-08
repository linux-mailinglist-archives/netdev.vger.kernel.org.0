Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66BA95B1B7B
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 13:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiIHLcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 07:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiIHLcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 07:32:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5793CEB31
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 04:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662636733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gkJqLIEodaigCyDyu25qqM08BkWZq831iBlo9xS/2rU=;
        b=SIDwodXmytZIYMSzNcBHV01mtuY0178TktxwiqPVIc6YyCHHv4CXn2tD6lFIDtaMIeIT0+
        cPxvDGLqzG9FM5SCzS1hYQXSXqaFIoOPmziOKwSrTAttwrd0FcIPoyGyyaaWS0KVaktxNt
        xbJix86zS1W1v/hLeXCZWOsawgxq9gg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-657-Frd59t5ONtCSwVc7jY6-Ig-1; Thu, 08 Sep 2022 07:32:12 -0400
X-MC-Unique: Frd59t5ONtCSwVc7jY6-Ig-1
Received: by mail-qv1-f70.google.com with SMTP id y7-20020ad45307000000b004ac7fd46495so595587qvr.23
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 04:32:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=gkJqLIEodaigCyDyu25qqM08BkWZq831iBlo9xS/2rU=;
        b=65Rj2TgFQILtcGQ7dNzyuk3T382s13ndR7CLi4oU87iH5f6hQOhFNI2qHx3OEqtgnu
         HLRR7vrwP4/k4wQZ+WKH7Vp/BryTqldRSHohqdrdjp+dVf8VPT1efNBSnN9Ig9NMkIZ3
         5vMqDswX1/d6ZxNrrW319UT+CCqbC5xI8lZ8fQAXYZCxYzl2RbGuedZ5nTkaDNqckbBh
         POFEbJ7aAOCG7ZW5fEhKoBzbrzwA7QlVX/VDM9triEP7rkur4o3tHSCPqPNtN96qUeJV
         xz8Mj8sJPBMzozHn88c3YcnmPYcwpv4zdFhQFO2zzi7W+HF2cJJq6FtcCwmUIFnwNNDp
         D0Kg==
X-Gm-Message-State: ACgBeo3JvTZSZDzFYeB8ipbpPmxwupYbKzsXCrm45UEXic1+nCfaSVDk
        HYVtIXjzdzpcLzGaV+/1rjDO7h840oVfePR4gsPYqcFO/20em0aw+r+HufkT0Qyn2hdWaUVKN7P
        +SMxiOPbJTprU2CbP
X-Received: by 2002:a05:622a:1ba0:b0:343:f90e:f90c with SMTP id bp32-20020a05622a1ba000b00343f90ef90cmr7631575qtb.184.1662636732128;
        Thu, 08 Sep 2022 04:32:12 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7KwyO4DPYlmtZuNDkOE4HnlW2p/NDAxYgqGD/kryPelOfqqk73z0RnOhdubSwvyXaDILa0+g==
X-Received: by 2002:a05:622a:1ba0:b0:343:f90e:f90c with SMTP id bp32-20020a05622a1ba000b00343f90ef90cmr7631551qtb.184.1662636731878;
        Thu, 08 Sep 2022 04:32:11 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-119-112.dyn.eolo.it. [146.241.119.112])
        by smtp.gmail.com with ESMTPSA id 192-20020a3708c9000000b006b60d5a7205sm16002987qki.51.2022.09.08.04.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 04:32:11 -0700 (PDT)
Message-ID: <6567eac7c42fe05b9091e9c8e99b519207111f25.camel@redhat.com>
Subject: Re: [PATCH net-next v4 2/6] net: dsa: Add convenience functions for
 frame handling
From:   Paolo Abeni <pabeni@redhat.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Thu, 08 Sep 2022 13:32:08 +0200
In-Reply-To: <20220906063450.3698671-3-mattias.forsblad@gmail.com>
References: <20220906063450.3698671-1-mattias.forsblad@gmail.com>
         <20220906063450.3698671-3-mattias.forsblad@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-09-06 at 08:34 +0200, Mattias Forsblad wrote:
> Add common control functions for drivers that need
> to send and wait for control frames.
> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
> ---
>  include/net/dsa.h | 13 +++++++++++++
>  net/dsa/dsa.c     | 28 ++++++++++++++++++++++++++++
>  net/dsa/dsa2.c    |  2 ++
>  3 files changed, 43 insertions(+)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index f2ce12860546..70a358641235 100644
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
> @@ -1390,6 +1392,17 @@ void dsa_tag_drivers_register(struct dsa_tag_driver *dsa_tag_driver_array[],
>  void dsa_tag_drivers_unregister(struct dsa_tag_driver *dsa_tag_driver_array[],
>  				unsigned int count);
>  
> +int dsa_switch_inband_tx(struct dsa_switch *ds, struct sk_buff *skb,
> +			 struct completion *completion, unsigned long timeout);
> +static inline void dsa_switch_inband_complete(struct dsa_switch *ds, struct completion *completion)
> +{
> +	/* Custom completion? */
> +	if (completion)
> +		complete(completion);
> +	else
> +		complete(&ds->inband_done);
> +}
> +
>  #define dsa_tag_driver_module_drivers(__dsa_tag_drivers_array, __count)	\
>  static int __init dsa_tag_driver_module_init(void)			\
>  {									\
> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
> index be7b320cda76..2d7add779b6f 100644
> --- a/net/dsa/dsa.c
> +++ b/net/dsa/dsa.c
> @@ -324,6 +324,34 @@ int dsa_switch_resume(struct dsa_switch *ds)
>  EXPORT_SYMBOL_GPL(dsa_switch_resume);
>  #endif
>  
> +int dsa_switch_inband_tx(struct dsa_switch *ds, struct sk_buff *skb,
> +			 struct completion *completion, unsigned long timeout)
> +{
> +	int ret;
> +	struct completion *com;
> +
> +	/* Custom completion? */
> +	if (completion)
> +		com = completion;
> +	else
> +		com = &ds->inband_done;

Since a new version is need, you can as well do:

	com = completion ? : &ds->inband_done;

Thanks!

Paolo

