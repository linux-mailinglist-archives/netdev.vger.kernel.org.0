Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 053033B48A9
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 20:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhFYSQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 14:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhFYSQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 14:16:31 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75286C061574
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 11:14:08 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id ot9so15443041ejb.8
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 11:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xxh0Induztb2rUtSsmgRJ/cNAZJ6K6sJwuLV2z/d4Cg=;
        b=tk0yFNTyWUBWnrsnNxVxPgNxjzS6xJsRUCujez9uRTRKN8/+qQykdRYuYsE0QyKAdA
         7hK/cLYHSOJmgEhUjt9SGoSo3LJu+YXy8p/UwnSntuSlmeBFjbmcNc4kjooRYboSGxWF
         SCCC0n5alKEWQHoFGWGAb4ValTqVjWJ8LS/ZtBFzYL2zC38VaUTLYOCPf2+i3IbhoEdt
         WRifY9LgBsCA7GTUw/Mrq9ir0sDEspEYHd8e05a4jNE40PYrYo0381k9wmaCbcElcOyn
         t5hXu/5+4D0NwcEvE8GZ+InnpGAojz9/W/cxU/wdWZQT6HG0uf/rJSZvoYnbyBbVHkQA
         3dJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xxh0Induztb2rUtSsmgRJ/cNAZJ6K6sJwuLV2z/d4Cg=;
        b=grH8p1oLKpCrZHNlUet7FJmNoyvyEg05VMyYF//XenXROnxv6QoetrHdFKWDunRtSO
         ZWgmkQVSZUwnxSsTp5ccv3j8SBKSMJYXG5FG/4ROeUE0kVYEesXceK6sgHCx27xqoMk7
         zDh/PIef0Bh2MbrjzlOjPh+Qis38MggK7eUez2WlK5TRBiGPgOkwqITU40njLMStIohA
         VsojOfyUNeKTwtLL24Vh4KSd0wmlzb/E8q5a66P59Q/qewVRCvwIyny8Kltshkmpwu1g
         W2eUROL/FNiP2l8N4Bpev+LWWVwlnnoxXE6+oz/xWG1dY7wnPBDrUy5Fhjgm86yrrNF3
         fn2g==
X-Gm-Message-State: AOAM533p34ksPuQcP3F8zLsFyoRx4u3umt3JLku2dgup2gSZOyvQl4bE
        NdCbSFX04R5AtK4o8q5p+jwopeySGCu6yQ==
X-Google-Smtp-Source: ABdhPJy9YBOU3VP6YRTjZMs0+p6UYVduZKimXHfVeDGWmAq+glQGwmf2aGRQiz2TP9BmGls+kDLoTA==
X-Received: by 2002:a17:906:30d0:: with SMTP id b16mr12384906ejb.495.1624644847095;
        Fri, 25 Jun 2021 11:14:07 -0700 (PDT)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com. [209.85.128.41])
        by smtp.gmail.com with ESMTPSA id j22sm3258984ejt.11.2021.06.25.11.14.06
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 11:14:06 -0700 (PDT)
Received: by mail-wm1-f41.google.com with SMTP id k30-20020a05600c1c9eb02901d4d33c5ca0so965391wms.3
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 11:14:06 -0700 (PDT)
X-Received: by 2002:a05:600c:4e93:: with SMTP id f19mr6522674wmq.169.1624644845535;
 Fri, 25 Jun 2021 11:14:05 -0700 (PDT)
MIME-Version: 1.0
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org> <20210624123005.1301761-1-dwmw2@infradead.org>
In-Reply-To: <20210624123005.1301761-1-dwmw2@infradead.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 25 Jun 2021 14:13:28 -0400
X-Gmail-Original-Message-ID: <CA+FuTSecOyH_k-jmLm_Ux4V9w0LOfWfVf6kuKfhOPU5DyD-wCw@mail.gmail.com>
Message-ID: <CA+FuTSecOyH_k-jmLm_Ux4V9w0LOfWfVf6kuKfhOPU5DyD-wCw@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] net: add header len parameter to tun_get_socket(), tap_get_socket()
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 8:30 AM David Woodhouse <dwmw2@infradead.org> wrote:
>
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> The vhost-net driver was making wild assumptions about the header length

If respinning, please more concretely describe which configuration is
currently broken.

IFF_NO_PI + IFF_VNET_HDR, if I understand correctly. But I got that
from the discussion, not the commit message.

> of the underlying tun/tap socket. Then it was discarding packets if
> the number of bytes it got from sock_recvmsg() didn't precisely match
> its guess.
>
> Fix it to get the correct information along with the socket itself.
> As a side-effect, this means that tun_get_socket() won't work if the
> tun file isn't actually connected to a device, since there's no 'tun'
> yet in that case to get the information from.
>
> On the receive side, where the tun device generates the virtio_net_hdr
> but VIRITO_NET_F_MSG_RXBUF was negotiated and vhost-net needs to fill

Nit: VIRTIO_NET_F_MSG_RXBUF

> in the 'num_buffers' field on top of the existing virtio_net_hdr, fix
> that to use 'sock_hlen - 2' as the location, which means that it goes

Please use sizeof(hdr.num_buffers) instead of a raw constant 2, to
self document the code.

Should this be an independent one-line fix?
