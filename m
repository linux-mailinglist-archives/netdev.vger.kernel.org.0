Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 059484B778E
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243846AbiBOUgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 15:36:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236290AbiBOUgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 15:36:20 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08ACBD64EC;
        Tue, 15 Feb 2022 12:36:10 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id qx21so7030967ejb.13;
        Tue, 15 Feb 2022 12:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N0DHLSPQl8zI7G40r/ZcPYc+4W/tKflgPU1jA6HvfIc=;
        b=KKJHMrSSkOg25V8ZeJgryqkHVRPpt/1Rr9Cafb5XrBkcrvf+Q41mrhjSTuJjz+MsPU
         DoQutkpZfJQJzLP3ZaS1/kOe1qG9n7W0y5ms8wNThYX9LCWhpVkgYB6gXnTaHqKGyka6
         VD0cCT/dj3UWziL1TBfJdP2H78tLdJM/73izsHbDP5PjP/Gf5rwnjj22jJcohDAN6wA6
         eqnlMIZXJxg+yZ6VTsHOxP8Oz5DBqTRUil7lxlRlXeyaAagE0e3lGkwiTBBedXk1hVZj
         4sPxyt9wUvWTk24LGze5mml2SSFYmIASkDUIEoTeLUJGJWKxHGJmfs6d/nq64HiuyTNt
         lD4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N0DHLSPQl8zI7G40r/ZcPYc+4W/tKflgPU1jA6HvfIc=;
        b=mLikE8gYUST7vBQNg5IewvdfSqiX3EiZD9eYr+LeB7+Uj6c0HilBPZf6oT4Yi04D6q
         DIrHr6WcTo8gEm+0ElWExswPJfQIHw24Tcwq1eaAi4MgzbCeCo0R7PIk3brP3//drnOh
         SXIphBHfzPYDZ+tseL5He5KCNNiALL5Y61XjaiFHKfgXhfJ3WQzA61K5YoEaIzApABx8
         9a3nxdUc6Xgvy8u6OyFuMsb34V5JzzXWlk0WHVd8PV5M02hwkJcEvUF7huLLQmY7PfSe
         6zup6IHRedKvkuUNex6cCiQp/lukHaJ38rL5BoGZonzKTqO6lIPucnioWaUS0oOqlMtZ
         j3aQ==
X-Gm-Message-State: AOAM532cRPfYx1eysZRiV8KzOlnb55otokLUGb1RJJLNod119Re7fUQR
        /RpKk1eWiYRUjxxZCsvevB4=
X-Google-Smtp-Source: ABdhPJw64zNAA4j+o6tuDYq8zbZspNeWsSqFPGMqWxToxbsoBbn4CXAL5jYeytWCuOaJi+rWtpx1DQ==
X-Received: by 2002:a17:907:6d27:: with SMTP id sa39mr704255ejc.350.1644957368379;
        Tue, 15 Feb 2022 12:36:08 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id ec52sm392847edb.92.2022.02.15.12.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 12:36:07 -0800 (PST)
Date:   Tue, 15 Feb 2022 22:36:06 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mans Rullgard <mans@mansr.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Juergen Borleis <jbe@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: lan9303: handle hwaccel VLAN tags
Message-ID: <20220215203606.5hipm6p7b34ja3ed@skbuf>
References: <20220215145913.10694-1-mans@mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215145913.10694-1-mans@mansr.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 02:59:13PM +0000, Mans Rullgard wrote:
> Check for a hwaccel VLAN tag on rx and use it if present.  Otherwise,
> use __skb_vlan_pop() like the other tag parsers do.  This fixes the case
> where the VLAN tag has already been consumed by the master.
> 
> Signed-off-by: Mans Rullgard <mans@mansr.com>
> ---
>  net/dsa/tag_lan9303.c | 21 +++++++--------------
>  1 file changed, 7 insertions(+), 14 deletions(-)
> 
> diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
> index cb548188f813..7fe180941ac4 100644
> --- a/net/dsa/tag_lan9303.c
> +++ b/net/dsa/tag_lan9303.c
> @@ -77,7 +77,6 @@ static struct sk_buff *lan9303_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev)
>  {
> -	__be16 *lan9303_tag;
>  	u16 lan9303_tag1;
>  	unsigned int source_port;
>  
> @@ -87,14 +86,15 @@ static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev)
>  		return NULL;
>  	}
>  
> -	lan9303_tag = dsa_etype_header_pos_rx(skb);
> -
> -	if (lan9303_tag[0] != htons(ETH_P_8021Q)) {
> -		dev_warn_ratelimited(&dev->dev, "Dropping packet due to invalid VLAN marker\n");
> -		return NULL;
> +	skb_push_rcsum(skb, ETH_HLEN);
> +	if (skb_vlan_tag_present(skb)) {
> +		lan9303_tag1 = skb_vlan_tag_get(skb);
> +		__vlan_hwaccel_clear_tag(skb);
> +	} else {
> +		__skb_vlan_pop(skb, &lan9303_tag1);

Sorry for the bad example, there is no reason to call skb_push_rcsum()
and skb_pull_rcsum() if we go through the skb_vlan_tag_present() code
path, just the "else" branch.

>  	}
> +	skb_pull_rcsum(skb, ETH_HLEN);
>  
> -	lan9303_tag1 = ntohs(lan9303_tag[1]);
>  	source_port = lan9303_tag1 & 0x3;
>  
>  	skb->dev = dsa_master_find_slave(dev, 0, source_port);
> @@ -103,13 +103,6 @@ static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev)
>  		return NULL;
>  	}
>  
> -	/* remove the special VLAN tag between the MAC addresses
> -	 * and the current ethertype field.
> -	 */
> -	skb_pull_rcsum(skb, 2 + 2);
> -
> -	dsa_strip_etype_header(skb, LAN9303_TAG_LEN);
> -
>  	if (!(lan9303_tag1 & LAN9303_TAG_RX_TRAPPED_TO_CPU))
>  		dsa_default_offload_fwd_mark(skb);
>  
> -- 
> 2.35.1
> 
