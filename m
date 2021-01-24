Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13F1301CB2
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 15:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbhAXO2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 09:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbhAXO2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 09:28:30 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55375C061573
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 06:27:50 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id v67so14120808lfa.0
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 06:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a8olPCXeRNua+xeUk/3CtMK+Tojt9SCDz62urHJB6Qg=;
        b=mKNMMY3/Qs12n4PGkGTfVoZbQ1JXryLpkqbhw3k530QWue5SIzOWqtufusckcoCUrM
         spZmtNQ7vipKB/FHU9a2Pd7Ou1C5JZbNzJjxbPh2GP1h2D6MWdJBSKfZqACPBkmx68Sr
         SBqQMeIVBYV15hvSqK1gL8VI2KIYy56HyacA5gl3dexA9IlOMO4y8VRtiGu8oyEH1kKC
         kAN0cgseWsTrwL7BcHcf2qZtCjjZaexHeeNfwZIpKURzEs7grV33/pG1mzZTHmsUgLY/
         hdXax/IEBkPmvxwU++50365EPnUwD2oiDw2OIoguyhM+zMCwNYP0Gq/x2moI99hkx6u+
         88ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a8olPCXeRNua+xeUk/3CtMK+Tojt9SCDz62urHJB6Qg=;
        b=Tz3PwN+/dhxOFeX8UMBg6G8Q7Gj89YI4CHuNQQGOWKDnlbDVvmq992PZRHfLVv+3Lg
         5pOIThK2b2dzBbOFSjBJpl/LWl2FNWj2kZdI+U9CouuPfqezDTN2myAj4WWNOcJNDlzb
         9IQbWFmS2+BNK/TcdX3VFFaWdMaOJE9UmYhghSAX42rsqPhBkYg+Nb/+WoF+UfvRFSpL
         0FHXXXvihod1YXehmctI5tn0WxNQEx4WCY+mks0MIN9sy8T2RFXUTzUrP5itUHD05GYk
         ir38Z+YUm9+TgH5kXE/4Vy9HUU938lBl8RhjfaRYMQQBeQ8A8ue5JDXqbhjWN7QfSm6/
         t1Jg==
X-Gm-Message-State: AOAM530Gba57n8uh+6d9lLaZm3EJrL3yKUmErqOe3k5AWJm6YdaYTnHW
        S1ze9Oa8VJUlw3Fb5a2WJyZLpQ==
X-Google-Smtp-Source: ABdhPJylHd8B8t8YxAk2KXVdYjfhA8Q15oJrshnOTr45OkMOTZqGAN0R3NGm+GbfNiCLKjdC+v6GWg==
X-Received: by 2002:ac2:4846:: with SMTP id 6mr118557lfy.653.1611498468891;
        Sun, 24 Jan 2021 06:27:48 -0800 (PST)
Received: from [192.168.1.157] (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id k8sm728509lfg.41.2021.01.24.06.27.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jan 2021 06:27:48 -0800 (PST)
Subject: Re: [RFC PATCH 14/16] gtp: add support for flow based tunneling
To:     laforge@gnumonks.org, netdev@vger.kernel.org, pbshelar@fb.com,
        kuba@kernel.org
Cc:     pablo@netfilter.org
References: <20210123195916.2765481-1-jonas@norrbonn.se>
 <20210123195916.2765481-15-jonas@norrbonn.se>
From:   Jonas Bonn <jonas@norrbonn.se>
Message-ID: <a9246112-fd2d-1042-4eb7-12a3096c6923@norrbonn.se>
Date:   Sun, 24 Jan 2021 15:27:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210123195916.2765481-15-jonas@norrbonn.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pravin,

A couple more comments around the GTP_METADATA bits:

On 23/01/2021 20:59, Jonas Bonn wrote:
> From: Pravin B Shelar <pbshelar@fb.com>
> 
> This patch adds support for flow based tunneling, allowing to send and
> receive GTP tunneled packets via the (lightweight) tunnel metadata
> mechanism.  This would allow integration with OVS and eBPF using flow
> based tunneling APIs.
> 
> The mechanism used here is to get the required GTP tunnel parameters
> from the tunnel metadata instead of looking up a pre-configured PDP
> context.  The tunnel metadata contains the necessary information for
> creating the GTP header.
> 
> Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
> ---
>   drivers/net/gtp.c                  | 160 +++++++++++++++++++++++++----
>   include/uapi/linux/gtp.h           |  12 +++
>   include/uapi/linux/if_tunnel.h     |   1 +
>   tools/include/uapi/linux/if_link.h |   1 +
>   4 files changed, 156 insertions(+), 18 deletions(-)
> 

<...>

>   
> +static int gtp_set_tun_dst(struct pdp_ctx *pctx, struct sk_buff *skb,
> +			   unsigned int hdrlen)
> +{
> +	struct metadata_dst *tun_dst;
> +	struct gtp1_header *gtp1;
> +	int opts_len = 0;
> +	__be64 tid;
> +
> +	gtp1 = (struct gtp1_header *)(skb->data + sizeof(struct udphdr));
> +
> +	tid = key32_to_tunnel_id(gtp1->tid);
> +
> +	if (unlikely(gtp1->flags & GTP1_F_MASK))
> +		opts_len = sizeof(struct gtpu_metadata);

So if there are GTP flags sets, you're saying that this no longer a 
T-PDU but something else.  That's wrong... the flags indicate the 
presence of extensions to the GTP header itself.

> +
> +	tun_dst = udp_tun_rx_dst(skb,
> +			pctx->sk->sk_family, TUNNEL_KEY, tid, opts_len);
> +	if (!tun_dst) {
> +		netdev_dbg(pctx->dev, "Failed to allocate tun_dst");
> +		goto err;
> +	}
> +
> +	netdev_dbg(pctx->dev, "attaching metadata_dst to skb, gtp ver %d hdrlen %d\n",
> +		   pctx->gtp_version, hdrlen);
> +	if (unlikely(opts_len)) {
> +		struct gtpu_metadata *opts;
> +
> +		opts = ip_tunnel_info_opts(&tun_dst->u.tun_info);
> +		opts->ver = GTP_METADATA_V1;
> +		opts->flags = gtp1->flags;
> +		opts->type = gtp1->type;
> +		netdev_dbg(pctx->dev, "recved control pkt: flag %x type: %d\n",
> +			   opts->flags, opts->type);
> +		tun_dst->u.tun_info.key.tun_flags |= TUNNEL_GTPU_OPT;
> +		tun_dst->u.tun_info.options_len = opts_len;
> +		skb->protocol = htons(0xffff);         /* Unknown */

It might be relevant to set protocol to unknown for 'end markers' (i.e. 
gtp1->type == 0xfe), but not for everything that happens to have flag 
bits set.  'flags' and 'type' are independent of each other and need to 
handled as such.

/Jonas
