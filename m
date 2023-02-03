Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7276A68A6CA
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 00:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbjBCXKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 18:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbjBCXKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 18:10:11 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938068C437;
        Fri,  3 Feb 2023 15:10:10 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id p26so19369502ejx.13;
        Fri, 03 Feb 2023 15:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9OouKbLDWQqmop907BS575/R2sD898lnwgblJacByKU=;
        b=Cq5cVPtLFv8y3hChlGCN5UvG9u9BOEYIL4X7DV9WVuNL/UI5u+qrBanjHrEIObyS3Z
         85FIRfm2lRHagAEdPeb/AXeVM0vRzRs/ATUmSr7o5BQd+XK3WRP59HlGtaWeWGj37L9p
         +9FYCD5NiKsYs4T3UtsX+OteFCiWIjxlmSV8xYc8/tIVgxn/SBCqpLcWoDyc4sK4TAQM
         Su/YHnkQvE8cf4geN0PP4Yoo6CHplrIlKvaEfvk7NJuEiM157RTB6gr4H5YOlV6yME+q
         IYVIRXYkAYAkgNVeqVlnkD8ho3hVhX4DWVIiJM5WiD6coTYFrWhPuCdP+4sjXX0/Z2ke
         IlYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9OouKbLDWQqmop907BS575/R2sD898lnwgblJacByKU=;
        b=5YEv75pst+inOLWfMfRKHRQYFLCbLSyFAml5rHHpC2W1rqPFZJXxk8RIj9susHtsIo
         Zt0fFTCvwbMsZkUUdGKmmQJHCH9urzz/F8N3C4X3Ue0T2fS2eQNaBp7vCJjz9NFK259a
         LJFwfYL2+cKYT+tF4d2DKh5zbU9wCecVT5QZeCVEnKTAIGql8qa2LSIr299ZLLFzdQgp
         3FnoKNeTheADfvI7DskRP6TOKhTZYPtBQ7jWx2LmGMiqI1MxGomPoscC2D1Y6tbjRkHe
         uD7yV9u/Dw7m3IRsjwVKwOcicS7d6UI3lAHBj76Jw/J/E/Zk16lLhTlv3qAkXeLQEu50
         wmjg==
X-Gm-Message-State: AO0yUKVnPU81EQmdRZ1ry5DOsfIzPZfhPHHXbuaXQ7ufQ8uYLFBXEOmp
        iM5CF+g+7qwDaFlcdsld3k8=
X-Google-Smtp-Source: AK7set9u5GWpKEvmzN8Dl4fLrIQu2117Lcl0nFCE/ka978phWcBRpMIVUNgcheEsiYjiOrPwzkQrFA==
X-Received: by 2002:a17:907:9917:b0:88d:6de1:96bf with SMTP id ka23-20020a170907991700b0088d6de196bfmr13144697ejc.12.1675465808932;
        Fri, 03 Feb 2023 15:10:08 -0800 (PST)
Received: from skbuf ([188.26.57.116])
        by smtp.gmail.com with ESMTPSA id v9-20020a1709064e8900b0088e7fe75736sm2020606eju.1.2023.02.03.15.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 15:10:08 -0800 (PST)
Date:   Sat, 4 Feb 2023 01:10:06 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk
Subject: Re: [RFC PATCH net-next 01/11] net: dsa: microchip: lan937x: add
 cascade tailtag
Message-ID: <20230203231006.jcaib7me6xbos6vl@skbuf>
References: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
 <20230202125930.271740-2-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202125930.271740-2-rakesh.sankaranarayanan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 06:29:20PM +0530, Rakesh Sankaranarayanan wrote:
> cascade tailtag contains 3 bytes of information, it includes
> additional bytes for accomodating port number in second switch.
> Destination port bitmap on first switch is at bit position 7:0 and
> of second switch is at bit position 15:8, add new tailtag xmit and
> rcv functions for cascade with proper formatting. Add new tag protocol
> for cascading and link with new xmit and rcv functions.
> 
> Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
> ---
>  include/net/dsa.h |  2 ++
>  net/dsa/tag_ksz.c | 80 ++++++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 77 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index a15f17a38eca..55651ad29193 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -390,6 +399,7 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893, KSZ9893_NAME);
>   *	  (eg, 0x00=port1, 0x02=port3, 0x07=port8)
>   */
>  #define LAN937X_EGRESS_TAG_LEN		2
> +#define LAN937X_CASCADE_TAG_LEN		3
>  
>  #define LAN937X_TAIL_TAG_BLOCKING_OVERRIDE	BIT(11)
>  #define LAN937X_TAIL_TAG_LOOKUP			BIT(12)
> @@ -442,11 +452,71 @@ static const struct dsa_device_ops lan937x_netdev_ops = {
>  DSA_TAG_DRIVER(lan937x_netdev_ops);
>  MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_LAN937X, LAN937X_NAME);
>  
> +/* For xmit, 3/7 bytes are added before FCS.
> + * ---------------------------------------------------------------------------
> + * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|ts(4bytes)|tag0(1byte)|tag1(1byte)|
> + * tag2(1byte)|FCS(4bytes)
> + * ---------------------------------------------------------------------------
> + * ts   : time stamp (Present only if PTP is enabled in the Hardware)
> + * tag0 : represents tag override, lookup and valid
> + * tag1 : each bit represents destination port map through switch 2
> + *	  (eg, 0x01=port1, 0x02=port2, 0x80=port8)
> + * tag2 : each bit represents destination port map through switch 1
> + *	  (eg, 0x01=port1, 0x02=port2, 0x80=port8)
> + *
> + * For rcv, 1/5 bytes is added before FCS.

Plural is only used for more than 5 bytes?
"5 bytes is added" vs "7 bytes are added"

> + * ---------------------------------------------------------------------------
> + * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|ts(4bytes)|tag0(1byte)|FCS(4bytes)
> + * ---------------------------------------------------------------------------
> + * ts   : time stamp (Present only if bit 7 of tag0 is set)
> + * tag0 : zero-based value represents port
> + *	  (eg, 0x00=port1, 0x02=port3, 0x07=port8)
> + */
> +static struct sk_buff *lan937x_cascade_xmit(struct sk_buff *skb,
> +					    struct net_device *dev)
> +{
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	const struct ethhdr *hdr = eth_hdr(skb);
> +	__be32 *tag;
> +	u32 val;
> +
> +	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
> +		return NULL;
> +
> +	tag = skb_put(skb, LAN937X_CASCADE_TAG_LEN);
> +
> +	val |= BIT((dp->index + (8 * dp->ds->index)));

This only works because cascade port is port 0, right?

> +
> +	if (is_link_local_ether_addr(hdr->h_dest))
> +		val |= (LAN937X_TAIL_TAG_BLOCKING_OVERRIDE << 8);
> +
> +	val |= (LAN937X_TAIL_TAG_VALID << 8);
> +
> +	put_unaligned_be24(val, tag);
> +
> +	return skb;
> +}
> +
> +static const struct dsa_device_ops lan937x_cascade_netdev_ops = {
> +	.name   = LAN937X_CASCADE_NAME,
> +	.proto  = DSA_TAG_PROTO_LAN937X_CASCADE,
> +	.xmit   = lan937x_cascade_xmit,
> +	.rcv    = ksz9477_rcv,
> +	.connect = ksz_connect,
> +	.disconnect = ksz_disconnect,
> +	.needed_tailroom = LAN937X_CASCADE_TAG_LEN,
> +};

Nope, no new lan937x_cascade tagging protocol.

If you read Documentation/networking/dsa/dsa.rst, it says:

| From the perspective of the network stack, all switches within the same DSA
| switch tree use the same tagging protocol.

Unless you are prepared to remove this assumption from the DSA framework,
you need to fold the cascade tag handling into the regular lan937x
tagging protocol (and declare the larger needed_tailroom to cover the
tail tag case).

You can look at dp->ds->index when figuring out the length of the tail
tag that should be inserted.

There's a lot of consolidation that could (and should) be done first
between lan937x_xmit() and ksz9477_xmit(), prior to adding the support
for cascade tagging.

> +
> +DSA_TAG_DRIVER(lan937x_cascade_netdev_ops);
> +MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_LAN937x_CASCADE,
> +			    LAN937X_CASCADE_NAME);
> +
>  static struct dsa_tag_driver *dsa_tag_driver_array[] = {
>  	&DSA_TAG_DRIVER_NAME(ksz8795_netdev_ops),
>  	&DSA_TAG_DRIVER_NAME(ksz9477_netdev_ops),
>  	&DSA_TAG_DRIVER_NAME(ksz9893_netdev_ops),
>  	&DSA_TAG_DRIVER_NAME(lan937x_netdev_ops),
> +	&DSA_TAG_DRIVER_NAME(lan937x_cascade_netdev_ops),
>  };
>  
>  module_dsa_tag_drivers(dsa_tag_driver_array);
> -- 
> 2.34.1
> 
