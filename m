Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E8F3383F7
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 03:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbhCLCsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 21:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbhCLCsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 21:48:25 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9310CC061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 18:48:25 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id h10so5910313edt.13
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 18:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ehiaeXpp+Zar1ad6NRlCTrQUXSShR06s+7m0an7WV5c=;
        b=YS/54lvlZ7wjQZlFAWpUSsyAsKHtfiNmeIT9EYVsg7sBMR+lDnK0bXVsqp7uCUuPde
         BV7IuVl3cAzLIdb/SS4k8IKNkX2ZTHtdcz4fxk5mxQGunBOmaeH9oabxqU0gFdtD23NH
         G3dcYAFjVi8uAXfPVx0UCe2ek0GGu36lRpqhVN7sf0JjuZSsH1ONzgCWHzRclGB4hIps
         EoE4doUyW5Xn8+QSYIG0qknoyJrDdhjqov8+BMxRQuTCLLIvi44AxA41yMyhukNLc2ke
         ef/jQnEuhVEz8bIndjvcBB8qRD+32wvXp4MSdqBHTWbw3ts6+TlrAByyLZ5oX+ReZ9gB
         dWlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ehiaeXpp+Zar1ad6NRlCTrQUXSShR06s+7m0an7WV5c=;
        b=O12beOjY5Dwm6U/GzulCXyw+ty4BpN+7RSt5xIMVipRXFewC0yTXIfCX+thQcZrqwn
         SGk+vdqv6jYVOY+Y8xqdhWZbVrZ/AMdJpY93dBmUgkMrebhkKlsjt3l7s1NfS89uUK7x
         owEa8OWaR2iZcZJUqX7wUaCNAfTlslqJz63L/L2R0mcMYkeFBs6JCSKyVQuodgpt3Dx5
         +GYutkfigxL5BuzjyiwKO+/RKrMYkNdww38TSfnz6GSqLIQcCHJtmTKZHdtIo0X+/Ntg
         BANpci1KSfHDKAtE0iMkVqk3DmFFhC1KxJvtEOdiiOMTW1ZFx8yKh529FhtIebAjlQ88
         +5VQ==
X-Gm-Message-State: AOAM532r9sOlWlhaou6ncHxNNCPoYyucUQ5xkR91HMieAtlMCPDKWBr1
        KrgfhnQD+flEq9A+IxBOMC984EG/VCg=
X-Google-Smtp-Source: ABdhPJxnTzIiWT1QCG8DowtfQP0UQhH67aqykY/7JGXdyHbPTaW6+IzB72aY38S4aAlwE5N/zyIHqA==
X-Received: by 2002:a05:6402:1c86:: with SMTP id cy6mr11463089edb.276.1615517303964;
        Thu, 11 Mar 2021 18:48:23 -0800 (PST)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id p3sm2062976ejd.7.2021.03.11.18.48.23
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 18:48:23 -0800 (PST)
Received: by mail-wr1-f41.google.com with SMTP id 61so934733wrm.12
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 18:48:23 -0800 (PST)
X-Received: by 2002:a5d:640b:: with SMTP id z11mr11266115wru.327.1615517302768;
 Thu, 11 Mar 2021 18:48:22 -0800 (PST)
MIME-Version: 1.0
References: <20210312004706.33046-1-ishaangandhi@gmail.com>
In-Reply-To: <20210312004706.33046-1-ishaangandhi@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 11 Mar 2021 21:47:45 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfcqotSBVtEWhbC8LdjDyOrsfuSv1QHt1Ga+s01phbmaA@mail.gmail.com>
Message-ID: <CA+FuTSfcqotSBVtEWhbC8LdjDyOrsfuSv1QHt1Ga+s01phbmaA@mail.gmail.com>
Subject: Re: [PATCH] icmp: support rfc 5837
To:     ishaangandhi <ishaangandhi@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 7:47 PM ishaangandhi <ishaangandhi@gmail.com> wrote:
>
> From: Ishaan Gandhi <ishaangandhi@gmail.com>
>
> This patch identifies the interface a packet arrived on when sending
> ICMP time exceeded, destination unreachable, and parameter problem
> messages, in accordance with RFC 5837.
>
> It was tested by pinging a machine with a ttl of 1, and observing the
> response in Wireshark.
>
> Signed-off-by: Ishaan Gandhi <ishaangandhi@gmail.com>

Such additional optional data (MAY in RFC 5837) should be optional and
off by default.

See also the security considerations in Sec 6. Those suggestions are
too fine grained to implement, but at the least a sysctl to
disable/enable the entire feature.


> +void icmp_identify_arrival_interface(struct sk_buff *skb, struct net *net, int room,
> +                                    struct icmphdr *icmph)
> +{
> +       unsigned int ext_len, if_index, orig_len, offset, extra_space_needed,
> +                    word_aligned_orig_len, mtu, name_len, name_subobj_len;
> +       struct interface_ipv4_addr_sub_obj ip_addr;
> +       struct icmp_extobj_hdr *iio_hdr;
> +       struct icmp_ext_hdr *ext_hdr;
> +       struct net_device *dev;
> +       void *subobj_offset;
> +       char *name, ctype;
> +
> +       skb_linearize(skb);
> +       if_index = inet_iif(skb);

skb->skb_iif is overwritten in __netif_receive_skb on each round, so
this will not necessarily point to the physical device on which the
packet arrived.

> +               name = dev->name;
> +               if (name) {
> +                       name_len = strlen(name);
> +                       name_subobj_len = min_t(unsigned int, name_len, ICMP_5837_MAX_NAME_LEN) + 1;

device name length is always <= IFNAMSIZ (incl terminating 0) <
ICMP_5837_MAX_NAME_LEN

> +                       name_subobj_len = (name_subobj_len + 3) & ~0x03;
> +                       ctype |= ICMP_5837_NAME_CTYPE;
> +                       ext_len += name_subobj_len;
> +               }
> +
> +               mtu = dev->mtu;
> +               if (mtu) {

always true

> +                       ctype |= ICMP_5837_MTU_CTYPE;
> +                       ext_len += 4;

sizeof(__be32)

>  /*
>   *     Send an ICMP message in response to a situation
>   *
> @@ -731,6 +864,10 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
>                 room = 576;
>         room -= sizeof(struct iphdr) + icmp_param.replyopts.opt.opt.optlen;
>         room -= sizeof(struct icmphdr);
> +       if (type == ICMP_DEST_UNREACH || type == ICMP_TIME_EXCEEDED ||
> +           type == ICMP_PARAMETERPROB) {
> +               icmp_identify_arrival_interface(skb_in, net, room, &icmp_param.data.icmph);
> +       }

If adding a feature for ICMP that is also valid for ICMPv6, please
introduce to both protocols in the same patch series. IPv6 is a first
class citizen.
