Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7452F304B25
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 22:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbhAZEum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbhAYJZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 04:25:24 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46881C06174A
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 00:12:50 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id m22so16394613lfg.5
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 00:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bsE93UFl5PtYy3HJ5hlNHKN4+yoGAKw1M08tLJ7E8iw=;
        b=FWQ70IPS+h3119nHmkdh1omOnMMVP4uaHsMixzA44wwWJgdTGNQjNKL5XxSzOpWB0K
         /aeQWAJq/CLSK1kcI+RyAbaLrUSYXVBJ1QbbkvZ6ZGfvYcL41WuVisKmZRGaBUetO07E
         A+TuKZ6H8KAOJR7n2swXmwopjMeP3OFkUdMV8sOCu882yxUVg+vN+hLIxp9xs1F8PByJ
         K1DZqMgSZMkVNYJzckoIADwBPWEL0zNTbI3tlACc9oIBzY8uawUq/s1InQPNJkQ5IKqb
         PINjrMykxGR0ByqYuVjdM7qArV8s9lBR9Sg5qcKrJ5P6aGmEEgfCKQmfqByofZCndHaf
         +mrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bsE93UFl5PtYy3HJ5hlNHKN4+yoGAKw1M08tLJ7E8iw=;
        b=ZSx/wMYnexlv0PsbS+JfX3jpsBiUGZ3Ze1XD2gAu3h1TxHUFYKTcZthOJjVmWIUOlY
         1o74xA+s3iX/uH1mgl1ht+Y82Q399hPBWkrdUbvv5kM5z4RSBI/3h8uzaTPhN7XVqvcL
         jSonBj++tpf6/bpawxgxmoE2SQWvhoK/XomXGE/soCQ/2fNVylb5GZ3t7rFi48B6joTd
         wIi05NbyTQ0ZUi3iFwcYNaUMjL1OF9TBSCF6dHH3ZboH2zEau10DJUssGVHS2rxjx0uo
         af/oT+q+9crVW5dlzS0cyXp+78YTB5L5xS/BJbYN1i6wiEHazhgDCV5kbI/xIRKZW6be
         HXiQ==
X-Gm-Message-State: AOAM530cdqaU5NkUevBAGolOeehH3KiBLmL10Us6xFKmU95vO832qMmo
        ZtRl9Vntrh86jClQSNT32rmuG1FHR67oYQ==
X-Google-Smtp-Source: ABdhPJx9jFUcrzWp1XrKBje5PxySzncfE/yP3qXa45qlh2WFfDbq7joRJUoX0u2zyJPKeGvmNEmP3A==
X-Received: by 2002:ac2:57c2:: with SMTP id k2mr281144lfo.105.1611562368824;
        Mon, 25 Jan 2021 00:12:48 -0800 (PST)
Received: from [192.168.1.157] (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id z141sm1749215lfc.118.2021.01.25.00.12.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 00:12:48 -0800 (PST)
Subject: Re: [RFC PATCH 14/16] gtp: add support for flow based tunneling
To:     laforge@gnumonks.org, netdev@vger.kernel.org, pbshelar@fb.com,
        kuba@kernel.org
Cc:     pablo@netfilter.org
References: <20210123195916.2765481-1-jonas@norrbonn.se>
 <20210123195916.2765481-15-jonas@norrbonn.se>
From:   Jonas Bonn <jonas@norrbonn.se>
Message-ID: <0f60fd78-3f0a-c27d-6fcc-1355d40c5d1c@norrbonn.se>
Date:   Mon, 25 Jan 2021 09:12:47 +0100
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

I'm going to submit a new series without the GTP_METADATA bits.  I think 
the whole "collect metadata" approach is fine, but the way GTP header 
information is passed through the tunnel via metadata needs a bit more 
thought.  See below...

On 23/01/2021 20:59, Jonas Bonn wrote:
> From: Pravin B Shelar <pbshelar@fb.com>
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

This decides that GTP metadata is required if any of the S, E, and PN 
bits are set in the header.  However:

i) even when any of those bits are set, none of the extra headers are 
actually added to the metadata so it's somewhat pointless to even bother 
reporting that they're set

ii) the more interesting case is that you might want to report reception 
of an end marker through the tunnel; that however, is signalled by way 
of the GTP header type and not via the flags; but, see below...


> +
> +	tun_dst = udp_tun_rx_dst(skb,
> +			pctx->sk->sk_family, TUNNEL_KEY, tid, opts_len);
> +	if (!tun_dst) {
> +		netdev_dbg(pctx->dev, "Failed to allocate tun_dst");
> +		goto err;
> +	}

The problem, as I see it, is that end marker messages don't actually 
contain an inner packet, so you won't be able to set up a destination 
for them.  The above fails and you never hit the metadata path below.

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
> +	}

Assuming that you do hit this code and are able to set the 'type' field 
in the metadata, who is going to be the recipient.  After you pull the 
GTP headers, the SKB is presumably zero-length...

/Jonas
