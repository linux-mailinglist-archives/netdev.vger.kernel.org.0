Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 377DC2AFA15
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 21:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgKKUza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 15:55:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgKKUz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 15:55:28 -0500
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443BCC0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 12:55:27 -0800 (PST)
Received: by mail-vs1-xe41.google.com with SMTP id z123so1998426vsb.0
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 12:55:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d6wXQms3X2jDTGkCw8WsYRVzU1kvWpMHgYkx09XvOSo=;
        b=t+grscLb20Tx0eHT7Z0/3k9KRGG3yAc0IuHJ5S/pi0ek59meKkGY0CtxIplTBbl11j
         oTSxcbEMlEMkj8W7RMJlTS1d4xPkr1a9fJ0aFfgLvj6eONeTK+BAqezy+ExOkbkaSFzz
         25gAAZ2u1RLDBe9B4QZXGhEYkSSCOeUc7BJkODARM3xlgpQ9PPXQCewu0QQltVG2UlA3
         hiXI4alqL1PNC3XL+Mdn1mA6QhEf2vUaKUaZKqM29U31JUVzowAbMa0xAARMQGraosCI
         4BfQtavFo6mDftIYj2i2ouxw3RpRrZIH2N0LuBt/ad/yK0c6L409r2KUGMroCHWjHZ1X
         YA4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d6wXQms3X2jDTGkCw8WsYRVzU1kvWpMHgYkx09XvOSo=;
        b=JbMCXpL+1s0H04gahIxUidv3ArzE7byFI1pWPhMHDufLg4DAocFZFZAXT9tqYwZrBl
         5QtK91I+CEI0F7Pz4fEfIi5m0Olj4Y5zc+uUstrwmDAGhqUduHz8M3LK6Ys8btzRNHtR
         TFuNM6Yv9tp9vEroJgI+2uAHe4jmQEabYQT5tgF0frQp7ulrn3O49nPwJDg0/nENfcgJ
         /is0Gb+VYSr14+25KhCIVRNFUJ/bdLBRETUYFnidghDjec20u9mJa+S08sTUzwb2iyc+
         jA+kxMwgQ0cQiE20yBzaAcQ6o4wL2/6S5YQCdiX31BPmBUzJq2xGcpqrNVp9JHLi7+Tg
         N8IQ==
X-Gm-Message-State: AOAM532Boam3LFM5gzAYCOEYKsgk69vn4oCK9UivGlJ7Q9qcfyHjM/Gq
        2oygVTheLnYSKvsUlvrMx9xSVZrhspY=
X-Google-Smtp-Source: ABdhPJwkBWeRiClsMV3tGeJc6TuAnjRvCCfDgnMDX54ct5DLq3NgiZg8Nh6au5hv7PazjawoGoVzQQ==
X-Received: by 2002:a67:d03:: with SMTP id 3mr18187806vsn.41.1605128125292;
        Wed, 11 Nov 2020 12:55:25 -0800 (PST)
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com. [209.85.217.49])
        by smtp.gmail.com with ESMTPSA id 11sm386236vkz.42.2020.11.11.12.55.24
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 12:55:24 -0800 (PST)
Received: by mail-vs1-f49.google.com with SMTP id u7so1963108vsq.11
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 12:55:24 -0800 (PST)
X-Received: by 2002:a67:ce0e:: with SMTP id s14mr16942916vsl.13.1605128123561;
 Wed, 11 Nov 2020 12:55:23 -0800 (PST)
MIME-Version: 1.0
References: <sc7E1N6fUafwmUSYAu3TKgH39kfjNK5WuUi0wng54@cp4-web-030.plabs.ch>
In-Reply-To: <sc7E1N6fUafwmUSYAu3TKgH39kfjNK5WuUi0wng54@cp4-web-030.plabs.ch>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 11 Nov 2020 15:54:45 -0500
X-Gmail-Original-Message-ID: <CA+FuTSc3Xk9U51f1PCLVAmu-+Wfs8i2+gb8K2igcV5fUq_b40A@mail.gmail.com>
Message-ID: <CA+FuTSc3Xk9U51f1PCLVAmu-+Wfs8i2+gb8K2igcV5fUq_b40A@mail.gmail.com>
Subject: Re: [PATCH v5 net 2/2] net: udp: fix IP header access and skb lookup
 on Fast/frag0 UDP GRO
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 3:45 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> udp{4,6}_lib_lookup_skb() use ip{,v6}_hdr() to get IP header of the
> packet. While it's probably OK for non-frag0 paths, this helpers
> will also point to junk on Fast/frag0 GRO when all headers are
> located in frags. As a result, sk/skb lookup may fail or give wrong
> results. To support both GRO modes, skb_gro_network_header() might
> be used. To not modify original functions, add private versions of
> udp{4,6}_lib_lookup_skb() only to perform correct sk lookups on GRO.
>
> Present since the introduction of "application-level" UDP GRO
> in 4.7-rc1.
>
> Misc: replace totally unneeded ternaries with plain ifs.
>
> Fixes: a6024562ffd7 ("udp: Add GRO functions to UDP socket")
> Suggested-by: Willem de Bruijn <willemb@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Acked-by: Willem de Bruijn <willemb@google.com>
