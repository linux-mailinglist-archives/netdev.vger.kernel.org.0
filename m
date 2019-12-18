Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F372F124C5D
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbfLRQDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:03:19 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:44909 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727215AbfLRQDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:03:19 -0500
Received: by mail-yw1-f65.google.com with SMTP id t141so941014ywc.11
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 08:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QDDj2bPFlOtGlF3M9/vLbZ2kwUPQJ1HVK7IQbgej6OA=;
        b=MU5LH+b6bl31s9xppUdea3Q3gQk1pQsK65hMDxUVeSDlUUADyuc6HpfkvzIspKaa/r
         gOLoDAiJY4lQulWr+dPcM/unySJgEzPdlsU/9YHb4emiN86X8WUpoJOWTmV+5C8BrTPH
         +4i+/S7E44V6X9AJ47eQ62BhyEx8NZCPkgTyJQFJnWv9sYRw+q4rtmRXp3dnFC7SB4qK
         iFJ7gVV3HjnYIq3iPFxxrPfB83PfqegTsa5V7WimaFjFTZxYchwTK5HbR3BpVyv+nYJC
         TnlCSWA6q/Ntakp2+A3Ezg1pLrvyDaUmi4WxsbspDIRviqbYvG3qTSl55y72fyUTjhNy
         Ggyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QDDj2bPFlOtGlF3M9/vLbZ2kwUPQJ1HVK7IQbgej6OA=;
        b=tG4V2edaTRZXEWOGiO7fNUARfeJdr3itz8WpCTvgSY4NEeFq1ngUGoJDBIagOHG/bM
         OQIv7Wm+3woJ6Z6X2cq2BQgTGJbUktzHnhHfuazvb9MaVZZsZT1iOc1WbrwvvJgfgpvo
         TmO0zT+7QyrQeOO0l9s6Ea1nIeZVShtgsPp2jbux/sR1dtls86x6G3bSdbOTK/Fb3iby
         rLe4UIUWCN9i+hE69IzCNskntdtWfDtNx7HKvidu1HhAc4hzm0BcOuExnVQodlJhu8LU
         TlQTo3FoALZxFm1Za2anT185d6JDNBmS3t9loMI9PWTJIw3tgQsOHM68KEmnCzAzgucw
         ulnQ==
X-Gm-Message-State: APjAAAWki/4BKF2LTWUqKAwFG/1B72M4cGuf9Fmz+OP5Ikf5cGI72Vpm
        6dxojbgq5uahSsymE/Vx1rnxOM1o
X-Google-Smtp-Source: APXvYqxyPytqGvW66Pg/FSiPBnJVdaXNlpb3n+mbRBZL837lSnSoCTsGVGRxlAkaypPOQYOtHpCR2w==
X-Received: by 2002:a0d:d306:: with SMTP id v6mr2530423ywd.415.1576684997822;
        Wed, 18 Dec 2019 08:03:17 -0800 (PST)
Received: from mail-yw1-f43.google.com (mail-yw1-f43.google.com. [209.85.161.43])
        by smtp.gmail.com with ESMTPSA id y17sm1128814ywd.23.2019.12.18.08.03.16
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2019 08:03:17 -0800 (PST)
Received: by mail-yw1-f43.google.com with SMTP id i190so962975ywc.2
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 08:03:16 -0800 (PST)
X-Received: by 2002:a0d:cac3:: with SMTP id m186mr2526276ywd.275.1576684996215;
 Wed, 18 Dec 2019 08:03:16 -0800 (PST)
MIME-Version: 1.0
References: <20191218133458.14533-1-steffen.klassert@secunet.com> <20191218133458.14533-4-steffen.klassert@secunet.com>
In-Reply-To: <20191218133458.14533-4-steffen.klassert@secunet.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 18 Dec 2019 11:02:39 -0500
X-Gmail-Original-Message-ID: <CA+FuTScnux23Gj1WTEXHmZkiFG3RQsgmSz19TOWdWByM4Rd15Q@mail.gmail.com>
Message-ID: <CA+FuTScnux23Gj1WTEXHmZkiFG3RQsgmSz19TOWdWByM4Rd15Q@mail.gmail.com>
Subject: Re: [PATCH net-next 3/4] net: Support GRO/GSO fraglist chaining.
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 8:35 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> This patch adds the core functions to chain/unchain
> GSO skbs at the frag_list pointer. This also adds
> a new GSO type SKB_GSO_FRAGLIST and a is_flist
> flag to napi_gro_cb which indicates that this
> flow will be GROed by fraglist chaining.
>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

> +struct sk_buff *skb_segment_list(struct sk_buff *skb,
> +                                netdev_features_t features,
> +                                unsigned int offset)
> +{
> +       struct sk_buff *list_skb = skb_shinfo(skb)->frag_list;
> +       unsigned int tnl_hlen = skb_tnl_header_len(skb);
> +       unsigned int delta_truesize = 0;
> +       unsigned int delta_len = 0;
> +       struct sk_buff *tail = NULL;
> +       struct sk_buff *nskb;
> +
> +       skb_push(skb, -skb_network_offset(skb) + offset);
> +
> +       skb_shinfo(skb)->frag_list = NULL;
> +
> +       do {
> +               nskb = list_skb;
> +               list_skb = list_skb->next;
> +
> +               if (!tail)
> +                       skb->next = nskb;
> +               else
> +                       tail->next = nskb;
> +
> +               tail = nskb;
> +
> +               delta_len += nskb->len;
> +               delta_truesize += nskb->truesize;
> +
> +               skb_push(nskb, -skb_network_offset(nskb) + offset);
> +
> +               if (!secpath_exists(nskb))
> +                       __skb_ext_copy(nskb, skb);

Of all the possible extensions, why is this only relevant to secpath?

More in general, this function open codes a variety of skb fields that
carry over from skb to nskb. How did you select this subset of fields?

> +
> +               memcpy(nskb->cb, skb->cb, sizeof(skb->cb));
> +
> +               nskb->tstamp = skb->tstamp;
> +               nskb->dev = skb->dev;
> +               nskb->queue_mapping = skb->queue_mapping;
> +
> +               nskb->mac_len = skb->mac_len;
> +               nskb->mac_header = skb->mac_header;
> +               nskb->transport_header = skb->transport_header;
> +               nskb->network_header = skb->network_header;
> +               skb_dst_copy(nskb, skb);
> +
> +               skb_headers_offset_update(nskb, skb_headroom(nskb) - skb_headroom(skb));
> +               skb_copy_from_linear_data_offset(skb, -tnl_hlen,
> +                                                nskb->data - tnl_hlen,
> +                                                offset + tnl_hlen);
> +
> +               if (skb_needs_linearize(nskb, features) &&
> +                   __skb_linearize(nskb))
> +                       goto err_linearize;
> +
> +       } while (list_skb);
> +
> +       skb->truesize = skb->truesize - delta_truesize;
> +       skb->data_len = skb->data_len - delta_len;
> +       skb->len = skb->len - delta_len;
> +       skb->ip_summed = nskb->ip_summed;
> +       skb->csum_level = nskb->csum_level;

This changed from the previous version, where nskb inherited ip_summed
and csum_level from skb. Why is that?
