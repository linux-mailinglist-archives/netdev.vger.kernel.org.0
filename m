Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D0F4DA020
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 17:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242578AbiCOQfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 12:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232897AbiCOQfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 12:35:05 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C267340C7;
        Tue, 15 Mar 2022 09:33:53 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id bi12so42738044ejb.3;
        Tue, 15 Mar 2022 09:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AWRbE0SqFuV4wqzStVfSF+dwgpeyvmT951OzMpXt1TM=;
        b=GOxJ4n+XZnHOfmX6RhO0J0yhAZB3qFAqYS0ZkPj3UhB7tV95b9G5aJkNP9II9UeXsc
         TjtS9FFQ7sJTO+DjyEwOA7VCcrRExK10UaGSOmo2UcHwbmVRv8KXwN5yPauEx2B6iEaS
         SzgtTyAP4OpMsRy11YqQHQrPGfHzJg3K3AT9/ttb+KYo6Deu7rGHSl9fY9hWxfSY1umu
         GDRuIjVG81XQd6M54gm2aPcvAWgghVgwWake3ZxRvBm2JiNPt+AX8BjM/jgM6Ujgiuvl
         v1PXZ5SK0nWZVRs9orxXyBqf3qiQPCO7+fqjguw548b7vDXA94yqJ/ruUVb1ZmSBcDZf
         7piA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AWRbE0SqFuV4wqzStVfSF+dwgpeyvmT951OzMpXt1TM=;
        b=COSPyJZebozlFstVQqCWmklma4efGb4371u+50btzhi9c/+j4XAtuOWvUTJ8WZVBl0
         VWdD/zVUMwajg9v5G3tuywxjIN9tRPLuJYi+w/sPPPdtZBQl9l+O+xz9GXlfWTNGBqWm
         n9qtGuRaBDwoP3M8UrTLk+gvZ/fFFN2FzHonfDhF89ixFBXfpMdyiLI8M+plvWNi5Prk
         xMgkZhOtVWKL3fjZaxozFLCG1HLSKXAyWkpPTSycYwubB8hNswSMRSfRSYa2RhfdZ3gL
         wnUfQN+KtoQTJDcRm6331JaWsI5riVgwC52zDTS8eTgF0maw2xkC3Tm6tTO6vm5osLAE
         u79g==
X-Gm-Message-State: AOAM533AmBZmBcG3kToraSTaTyAomTZ8neh/sWBH2Y1GDeubmoktj2tP
        O/o5U/1K4W/ln7RfmqBdEY3n/q/0Utw=
X-Google-Smtp-Source: ABdhPJyxZ5Dj5nbD1iYsZlkTxc6XF5i/Wr9GefE4CWGt955QvEBj/tXmYZleja4Sh7ujs868a2K2Zw==
X-Received: by 2002:a17:906:c1d6:b0:6d6:e0a3:bbc7 with SMTP id bw22-20020a170906c1d600b006d6e0a3bbc7mr23293709ejb.484.1647362031906;
        Tue, 15 Mar 2022 09:33:51 -0700 (PDT)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id y12-20020a056402358c00b00418d7f02d63sm284290edc.53.2022.03.15.09.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 09:33:51 -0700 (PDT)
Date:   Tue, 15 Mar 2022 18:33:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH v4 net-next 09/15] net: dsa: Never offload FDB entries on
 standalone ports
Message-ID: <20220315163349.k2rmfdzrd3jvzbor@skbuf>
References: <20220315002543.190587-1-tobias@waldekranz.com>
 <20220315002543.190587-10-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315002543.190587-10-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 01:25:37AM +0100, Tobias Waldekranz wrote:
> If a port joins a bridge that it can't offload, it will fallback to
> standalone mode and software bridging. In this case, we never want to
> offload any FDB entries to hardware either.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

When you resend, please send this patch separately, unless something
breaks really ugly with your MST series in place.

>  net/dsa/slave.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index a61a7c54af20..647adee97f7f 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -2624,6 +2624,9 @@ static int dsa_slave_fdb_event(struct net_device *dev,
>  	if (ctx && ctx != dp)
>  		return 0;
>  
> +	if (!dp->bridge)
> +		return 0;
> +
>  	if (switchdev_fdb_is_dynamically_learned(fdb_info)) {
>  		if (dsa_port_offloads_bridge_port(dp, orig_dev))
>  			return 0;
> -- 
> 2.25.1
> 
