Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08D546C991
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 01:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238619AbhLHAyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 19:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234092AbhLHAyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 19:54:12 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D802C061574;
        Tue,  7 Dec 2021 16:50:41 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id x3-20020a05683000c300b0057a5318c517so1006191oto.13;
        Tue, 07 Dec 2021 16:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3tPnK3d3TA2CMj3BoxOzetsFBp/Dz0sQTXsIcpvPpG4=;
        b=EoMDhFxqY4OjSHEjcUpXF79Gmg+W2ps1jsbAJ6lrGPn6BSnk4RRqAwGcIk8cA0080z
         unvoUn9afVlLIIeKtYweAkWdcP38p+YBY0cW4IzMsiy3GmrVcx0ldH31FZ542yeR83ij
         xw9w1axnKJR4M826INMNQrjhNP8lLDMmYRyeQv2h19jLgtH6+g5A6BHuFJ8kXaT/LCfn
         ApD+XjnEEZSueuRnNMGU9r6tL9bOEnriHr9tQ4uvWLRen2BpOubxrqNAGvOuTLAEGMY9
         0IlyjSub8c2DzC1eWP92IS7mp6JZTTpPdYfu1j+XVtZiay/WKsna9P8L4EZzGroeLGVw
         DYhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3tPnK3d3TA2CMj3BoxOzetsFBp/Dz0sQTXsIcpvPpG4=;
        b=CtToTFT+sGOXbY5Ue9YifuhJ0KVcbb3zSDrnDFNuFEWte08Tq1/MaPLAdgIwlBqZII
         pcxhr0UB/VrBMV5OPhWa5h1tHEYaLcPr0BQ5vr/02PHKTpDHkdgDSdFAQEgD2+wB6dc6
         M3VBNY/rC18/DruISansKwVSlnW39M6PDXwVkG0Iki8wDFAANOdVTHIzsoh2QU0uFkaw
         fDoVJYX1qHpvBqzH83Rys/YvHHmJhrK/Ao2a9wHd2BZ26cTSOYEd7MN9ek/w/f5nWn+V
         DTRlxqDGjvyKz252os0KspaninqWTKJRqdBrC8CY7dcnOhi2qGd1b3d3FAFk5jdFJLeT
         IJ6Q==
X-Gm-Message-State: AOAM533fFgIWpVvEeJG/HxBiOhd4xcblqU/cYNQkRCYF3GXBrTJdP1aQ
        rldFb8kg3wjQ62AWZLm7eTk=
X-Google-Smtp-Source: ABdhPJxAns2SEfQ9R6eWDSIFjygsW5HwgR23q7PVAjq8bKHsYjGm21S82UGr+mqSmE9qoPjbt63VSQ==
X-Received: by 2002:a9d:734d:: with SMTP id l13mr38197062otk.292.1638924640606;
        Tue, 07 Dec 2021 16:50:40 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id x16sm241113otq.47.2021.12.07.16.50.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 16:50:40 -0800 (PST)
Message-ID: <a20d6c2f-f64f-b432-f214-c1f2b64fdf81@gmail.com>
Date:   Tue, 7 Dec 2021 17:50:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH] ipv6: fix NULL pointer dereference in ip6_output()
Content-Language: en-US
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ahmed Abdelsalam <ahabdels@gmail.com>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Stefano Salsano <stefano.salsano@uniroma2.it>
References: <20211206163447.991402-1-andrea.righi@canonical.com>
 <cfedb3e3-746a-d052-b3f1-09e4b20ad061@gmail.com>
 <20211208012102.844ec898c10339e99a69db5f@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211208012102.844ec898c10339e99a69db5f@uniroma2.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/21 5:21 PM, Andrea Mayer wrote:
> 
> When an IPv4 packet is received, the ip_rcv_core(...) sets the receiving
> interface index into the IPv4 socket control block (v5.16-rc4,
> net/ipv4/ip_input.c line 510):
>     IPCB(skb)->iif = skb->skb_iif;
> 
> If that IPv4 packet is meant to be encapsulated in an outer IPv6+SRH header,
> the seg6_do_srh_encap(...) performs the required encapsulation. 
> In this case, the seg6_do_srh_encap function clears the IPv6 socket control
> block (v5.16-rc4 net/ipv6/seg6_iptunnel.c line 163):
>     memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
> 
> The memset(...) was introduced in commit ef489749aae5 ("ipv6: sr: clear
> IP6CB(skb) on SRH ip4ip6 encapsulation") a long time ago (2019-01-29).
> 
> Since the IPv6 socket control block and the IPv4 socket control block share the
> same memory area (skb->cb), the receiving interface index info is lost
> (IP6CB(skb)->iif is set to zero).
> 
> As a side effect, that condition triggers a NULL pointer dereference if patch
> 0857d6f8c759 ("ipv6: When forwarding count rx stats on the orig netdev") is
> applied.
> 
> To fix that, I can send a patch where we set the IP6CB(skb)->iif to the
> index of the receiving interface, i.e.:
> 
> int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
>          [...]
>          ip6_flow_hdr(hdr, 0, flowlabel);
>          hdr->hop_limit = ip6_dst_hoplimit(skb_dst(skb));
> 
>          memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
> +        IP6CB(skb)->iif = skb->skb_iif;
>          [...]
> 
> What do you think?
> 

I like that approach over the need for a fall back in core ipv6 code.
Make sure the above analysis is in the commit message. Thanks for the
quick response,
