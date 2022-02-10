Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D594B13E5
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244957AbiBJRJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 12:09:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237394AbiBJRJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:09:46 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A66E6A;
        Thu, 10 Feb 2022 09:09:46 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id m11so11969767edi.13;
        Thu, 10 Feb 2022 09:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6KO1EHZt76GuJ09+7lD/Q77CRRrPRaK9iQ8TqtMouCs=;
        b=oE0UWN3i1TkNvMqRFkDLcjavtpSFD1eDEkeFDT4QLUJRC9sc94G+UoYYpZ8WZBZN02
         9w1bjMoaj4w3ErLUogI86cN813NKNnm5zTxx2NDpe0IOpVftdwCZTA4tl+87sxtB5qg7
         9F7t+AgNZayB2UOsgR5c9UfnoeanY5vOoC4JxdeNeSP/w584iFgzZvjL3LxWRzwhvirY
         amdO9wYhDmTv8oXSBPehyhvPJF7ZMOMCb4DA4JIO5xSuGg7ccx8J57opZFRZ8RXBAr32
         6YwSFyhGYjdarzx8bEcsroRMCgBImWfhVRAvasNn6Bf7QHrmq3nrUfCLZjFpHDu1wZOC
         YrDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6KO1EHZt76GuJ09+7lD/Q77CRRrPRaK9iQ8TqtMouCs=;
        b=bHwIbdRyfrdJ4PEfcL9+LenSsjDGvSy34DWMruwhgwrHC8DK6YUNZcpEMRM0IDKK4I
         ZERdIdVuqxP3JD6se471g/DjYqpkEW/9XjC5mq7z/Qwd74I0sfcKjTugMP8xAlPJU1fn
         lfmTaZSzKsMd5bwIXHCkD8mZq9Hsbn2afjYrmsabYZs+0zJIRgk5JCvzWpvj+eWBAkzB
         gKDsFEoDeBm+H/+vhRTExnsqVO1Kn8hH+Efie0Y16gabeAN3HXEwoL7cGdx931lnOuY/
         qSl7in4Tk2D6v1htL8lKV9Br1vLdwBirXRCWTvPKb0BK11qLCJvkIpfJMnq4qIDRWCUI
         dviA==
X-Gm-Message-State: AOAM532c7XrfIvdFX16kcTWtYx+SBI+AplnAh32Xw7GUTMbcvi2HwyYD
        JRW0d2ZN8uwi2vNzzkvAlco=
X-Google-Smtp-Source: ABdhPJwbe+YniUx44ThriVsops7IHX9fxPYlLtd68unikrqu6n215gfZVJHNWsldYo+g+aBnZotxKA==
X-Received: by 2002:a05:6402:190f:: with SMTP id e15mr9479055edz.195.1644512985120;
        Thu, 10 Feb 2022 09:09:45 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id qx22sm6215632ejb.135.2022.02.10.09.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 09:09:44 -0800 (PST)
Date:   Thu, 10 Feb 2022 19:09:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/5] net: dsa: Add support for offloaded
 locked port flag
Message-ID: <20220210170943.tvmnru5byx5jbqkz@skbuf>
References: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
 <20220209130538.533699-4-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209130538.533699-4-schultz.hans+netdev@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Next time you send a patch version, if you're going to copy me on a
patch, can you please copy me on all of them? I have a problem with not
receiving emails in real time from netdev@vger.kernel.org, and
refreshing patchwork to see if anything has been said on the other
patches is pretty out of hand. I don't have enough information to
comment just on the DSA bits.

Thanks.

On Wed, Feb 09, 2022 at 02:05:35PM +0100, Hans Schultz wrote:
> Among the switchcores that support this feature is the Marvell
> mv88e6xxx family.
> 
> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
> ---
>  net/dsa/port.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index bd78192e0e47..01ed22ed74a1 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -176,7 +176,7 @@ static int dsa_port_inherit_brport_flags(struct dsa_port *dp,
>  					 struct netlink_ext_ack *extack)
>  {
>  	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
> -				   BR_BCAST_FLOOD;
> +				   BR_BCAST_FLOOD | BR_PORT_LOCKED;
>  	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
>  	int flag, err;
>  
> @@ -200,7 +200,7 @@ static void dsa_port_clear_brport_flags(struct dsa_port *dp)
>  {
>  	const unsigned long val = BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
>  	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
> -				   BR_BCAST_FLOOD;
> +				   BR_BCAST_FLOOD | BR_PORT_LOCKED;
>  	int flag, err;
>  
>  	for_each_set_bit(flag, &mask, 32) {
> -- 
> 2.30.2
> 
