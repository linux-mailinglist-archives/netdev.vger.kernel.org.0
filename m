Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DB93328A1
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 15:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhCIOao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 09:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbhCIOaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 09:30:15 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79ED9C06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 06:30:15 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id l12so20552628edt.3
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 06:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qXQaz6o4atEJRYBV31RTFfL6gXZMWZsubP8sDmVgbZQ=;
        b=au56fHLLqSDZ32svP/xUg7xLMNSde2/I3pHgvCvdQj4Hg4vCaCD6OmBVREF29YOaNk
         vJjCUz/23fLp5igggCvoWzZdbDJKzB3HCWTEMeQSF+dQw56rXDiY7UROn9tanPEwm/4O
         aVWGqQXGLpsfaXVuJj8POuaglPiq43KbYP3+rzOIm2NztRnr92M8Z2gQnuodZb9iy66p
         ylSyGZcZgRAHM72qPOKI9D+x9UcxbWivnI4svzrZraIVaEbebcQOjcD59L3w+NIq7FVS
         eboqFRffwc7ovjPZ0xWW6ogtUiYUwM95YkLDrK4TJyeot+r2cLyCDd5GegD5FEvUVfsk
         mUMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qXQaz6o4atEJRYBV31RTFfL6gXZMWZsubP8sDmVgbZQ=;
        b=C9ckaLInWC6mG/4JMUqKcatw5rz29AzmAdBU/YYP53j+nO8TXMMhh+8zIposGyr1Fd
         d+nxrPtksFiZP7cSzozFzvLpnGp3+iHqPMrRjGTiHa+fMlZ0yCSd+DrN51XpQpR/jQM9
         79NWzyboWtolGhyM/iJ57bhFEm9QAhiquM3kEZxzrQ/r2HP5fqievAbsUQ0eLZWt5YsN
         /X/TUXjAalTXI2P1HsB1QKc/NOpBeCE9kkwxt02xzpMJKQ9MGIPpRraEkK4nY+m3VRe1
         Cx7WXKWi/OUU9P9Cjvo4AGM0fUr84R275Y0dOwRE+slMY5IiTOcpp41AnlpFj2OUR81n
         Pg6w==
X-Gm-Message-State: AOAM5330+5jMGzsuKcph7T8X8j36p7oRheb1X08wTQSvr5j4RE0k/b/K
        /nGh6qSzQ47cxocNWUMqgnmlfk4gYVc=
X-Google-Smtp-Source: ABdhPJyFBNw4Vp9TPExYaYedqu8toZuWHDbh1Mo31dcVONE2VQziYbvL4CGDAc/8SvK33Q2LKJqxdQ==
X-Received: by 2002:aa7:da14:: with SMTP id r20mr4347025eds.181.1615300211735;
        Tue, 09 Mar 2021 06:30:11 -0800 (PST)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com. [209.85.221.50])
        by smtp.gmail.com with ESMTPSA id h24sm9203181edt.25.2021.03.09.06.30.11
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 06:30:11 -0800 (PST)
Received: by mail-wr1-f50.google.com with SMTP id j2so15993546wrx.9
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 06:30:11 -0800 (PST)
X-Received: by 2002:a5d:6cab:: with SMTP id a11mr28646938wra.419.1615300210948;
 Tue, 09 Mar 2021 06:30:10 -0800 (PST)
MIME-Version: 1.0
References: <cover.1615288658.git.bnemeth@redhat.com> <9b79f43d2dfec8b2cb8e896b5591e7b1c3cc1f6c.1615288658.git.bnemeth@redhat.com>
In-Reply-To: <9b79f43d2dfec8b2cb8e896b5591e7b1c3cc1f6c.1615288658.git.bnemeth@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 9 Mar 2021 09:29:31 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfd=47GLDui1mmg_+OgG+OYf80XYKqMEvKUhbzJFM=dQw@mail.gmail.com>
Message-ID: <CA+FuTSfd=47GLDui1mmg_+OgG+OYf80XYKqMEvKUhbzJFM=dQw@mail.gmail.com>
Subject: Re: [PATCH net v3 2/2] net: avoid infinite loop in mpls_gso_segment
 when mpls_hlen == 0
To:     Balazs Nemeth <bnemeth@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 9, 2021 at 6:32 AM Balazs Nemeth <bnemeth@redhat.com> wrote:
>
> A packet with skb_inner_network_header(skb) == skb_network_header(skb)
> and ETH_P_MPLS_UC will prevent mpls_gso_segment from pulling any headers
> from the packet. Subsequently, the call to skb_mac_gso_segment will
> again call mpls_gso_segment with the same packet leading to an infinite
> loop. In addition, ensure that the header length is a multiple of four,
> which should hold irrespective of the number of stacked labels.
>
> Signed-off-by: Balazs Nemeth <bnemeth@redhat.com>

Acked-by: Willem de Bruijn <willemb@google.com>

The compiler will convert that modulo into a cheap & (ETH_HLEN - 1)
test for this constant.
