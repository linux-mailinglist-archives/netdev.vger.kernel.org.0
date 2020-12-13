Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C09D2D8C0C
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 08:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389013AbgLMH5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 02:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388643AbgLMH5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 02:57:11 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F55C0613CF
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 23:56:31 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id a8so22306981lfb.3
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 23:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=udn4Qxro2r+4MlbZeU8OVezkiX5vJ/BKaBmT88MEn78=;
        b=iE5fyDKCLT1aWi3Okjbk9w11HJ3CSx9Ska/XQY5NYW+B0RxxjKVnGEO5R9v4r8Vav9
         mRlF5/pqldXvL/cILNtb0GTywj6+3LbbltXzyi/WtbEDF1XVzdMHKmO/o6xXMcrmfOWX
         vRfetMl/K8qBlswLkZE/d1giN42poAQxflR3prM379be1WD7E28MxQ4Nr+Z2YrqzgVMZ
         QKiBahLaEspRYRdvKjjEShiAjlZE2vzFNvhTUyV0PA95La6bZlmsrQz6ZivwPXonTV4B
         vIWkItZgYBsf4L9pkQd/D7pY530wsJF5MDW3HL3O9auo6ZA43QSRXS5xQ/TwNv79+h8G
         TlKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=udn4Qxro2r+4MlbZeU8OVezkiX5vJ/BKaBmT88MEn78=;
        b=oXmO3xz2g0QFeaa8H9wv4SczKAiob6Ac3IIagj3wWPsLHlDkegrz1h8kwd4EKjG7np
         8sroe4+cEOFa7R1t/3EBbe3IFT+DeZXIGanLG6n/BeXzNBLdKnRlaIjsAwI7MQ9ntQAW
         9iqyXOYv560UAK0Ce+/nbO2pzAqkQ85clJZCE6vUodCLV3OQPak5JrK5caZ1Sir8W8js
         ULUozUYfwJyEPOZeJcZ1yF/eBS/7AvvE6ZtESd5PihGzGIczj116fAj1furUu+uNxTG5
         R1nG0oVhonvp6qxUB/BD9BbULrCA7ahWtn5gozzJo9ZJXGdNXkd/GBAG5+AgXX+ZDQY3
         jXpg==
X-Gm-Message-State: AOAM530t6PYJHJAHbCjr2llV5Lza7YUfGX1Y7/U1aHJFl0u4by5qN0dQ
        Ulx7wwHJC8nvF3nv/axizreg9w==
X-Google-Smtp-Source: ABdhPJz4SrY/eatmjTI7tWktdF8g1mTaOsQUxMaepZ9xtoamt2aZ0EaqIA8we/SMnV/qVPgkhUFwwA==
X-Received: by 2002:a2e:5047:: with SMTP id v7mr8256748ljd.242.1607846189423;
        Sat, 12 Dec 2020 23:56:29 -0800 (PST)
Received: from [192.168.1.157] (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id b22sm1628018lfp.233.2020.12.12.23.56.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Dec 2020 23:56:29 -0800 (PST)
Subject: Re: [PATCH net-next v2] GTP: add support for flow based tunneling API
To:     Pravin B Shelar <pbshelar@fb.com>, netdev@vger.kernel.org,
        pablo@netfilter.org, laforge@gnumonks.org
Cc:     pravin.ovn@gmail.com
References: <20201212044017.55865-1-pbshelar@fb.com>
From:   Jonas Bonn <jonas@norrbonn.se>
Message-ID: <67f7c207-a537-dd22-acd8-dcce42755d1a@norrbonn.se>
Date:   Sun, 13 Dec 2020 08:56:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201212044017.55865-1-pbshelar@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pravin,

I've been thinking a bit about this and find it more and more 
interesting.  Could you post a bit of information about the ip-route 
changes you'll make in order to support GTP LWT encapsulation?  Could 
you provide an example command line?

I understand the advantages here of coupling to BPF and OVS.  How does 
storing the encapsulation parameters via ip-route compare to storing 
them as PDP contexts from the point of view of resource consumption? 
Are there are other advantages/disadvantages?

On 12/12/2020 05:40, Pravin B Shelar wrote:
> Following patch add support for flow based tunneling API
> to send and recv GTP tunnel packet over tunnel metadata API.
> This would allow this device integration with OVS or eBPF using
> flow based tunneling APIs.
> 
> Signed-off-by: Pravin B Shelar <pbshelar@fb.com>
> ---
> Fixed according to comments from Jonas Bonn
> ---
>   drivers/net/gtp.c                  | 514 ++++++++++++++++++++---------
>   include/uapi/linux/gtp.h           |  12 +
>   include/uapi/linux/if_link.h       |   1 +
>   include/uapi/linux/if_tunnel.h     |   1 +
>   tools/include/uapi/linux/if_link.h |   1 +
>   5 files changed, 382 insertions(+), 147 deletions(-)
> 
> diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
> index 4c04e271f184..0e212a70fe4b 100644
> --- a/drivers/net/gtp.c
> +++ b/drivers/net/gtp.c
> @@ -21,6 +21,7 @@
>   #include <linux/file.h>
>   #include <linux/gtp.h>
>   
> +#include <net/dst_metadata.h>
>   #include <net/net_namespace.h>
>   #include <net/protocol.h>
>   #include <net/ip.h>
> @@ -73,6 +74,9 @@ struct gtp_dev {
>   	unsigned int		hash_size;
>   	struct hlist_head	*tid_hash;
>   	struct hlist_head	*addr_hash;
> +	/* Used by flow based tunnel. */
> +	bool			collect_md;
> +	struct socket		*collect_md_sock;

I'm not convinced that you need to special-case LWT in this way.  It 
should be possible to just use the regular sk1u socket.  I know that the 
sk1u socket is created in userspace and might be set up to listen on the 
wrong address, but that's a user error if they try to use that device 
with LWT.  You could easily make the sk1u socket an optional parameter 
and create it (as you do in your patch) if it's not provided.  Then 
ip_tunnel_collect_metadata() would tell you whether to get the 
encapsulaton details from the tunnel itself or whether to look up a PDP 
context.  That should suffice, right?

/Jonas
