Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96351E6E64
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436856AbgE1WJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436803AbgE1WJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 18:09:39 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDC5C08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:09:39 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id dh1so130841qvb.13
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KJKb/M34Z+Aa55czRmNarkEg1Uq6lvf2FAHq7smEFXA=;
        b=d5InZUlebErwoEtoF1U40IOhzJlE+lpKjvb0nnizfR5hIGLLFUEbffhjBi93/jlkZV
         PY1Lxz6kSaCQlLvMp4lRrDI5hDJBTsQWq8VSnKtdpUXqclYk3pOuAVACIYsuv7jClnE2
         xC3W5mDT1VDu631oHBuQjAF2eVbLbF+YzpkeYy5ASp5BqoPA13pc5JtQaE0o4XiP84ya
         n+IT/Jly7a2fJGPA/6yTu7csC3rYiEAJR/LFfGWqaOfLQ3WpXrvOPfradAXrOG2luijN
         RInZ22uVXvc0Ed25kMf9Z+V8CpnrrM8KmnSl9iqBHoZRn+BqSefL2geGOWECPdtxP2O4
         vPkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KJKb/M34Z+Aa55czRmNarkEg1Uq6lvf2FAHq7smEFXA=;
        b=rG15WhSetbpM+IeeVY6w1wGNRX1Uvk656oAyh1WmNtTlyo+QCtajXp11B1US8IL30E
         SnL7FkTh0RzV1fX/50w54TK2kYFpWXGPvegCPAf8vLIv9iGnypSbPRQ2FwVb7ShxeJDe
         qkK+KcsOBPWv8hwoEgImoD3g3ClpSgQsma/itRbTqknXmlzSkN2IbIJ4otB0z92lcmBI
         uPnOTVEvIZoh527jYNY48YA8G6okyfOWTEanF/6RYzW45qKIAG0ExhAXRYPzRdyG27sz
         s6V27m1jo6FETE6Gwnw8HRMDoxes+qp/APpXq/vSz3tN8CdDreBeqU2/jviFFKB5yaXE
         BXQw==
X-Gm-Message-State: AOAM530z6QFu/E8dsoKRsTpwzzgbEXuL+0orNxR9AsKwqCjhcTE6VPKt
        fHOHuCU1JUZBzs+Oshg8vnfV4PCp
X-Google-Smtp-Source: ABdhPJxV0IiuyzO5XTnCMpKLe83R/oBzUnRJWzvG7bOaiRyswgmyFrF5cVJSkEQHzi6uSsafSk6uNA==
X-Received: by 2002:a0c:ee25:: with SMTP id l5mr5270586qvs.5.1590703778218;
        Thu, 28 May 2020 15:09:38 -0700 (PDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id u13sm5802911qtv.72.2020.05.28.15.09.37
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 15:09:37 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id r23so134333ybd.10
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:09:37 -0700 (PDT)
X-Received: by 2002:a25:aa2a:: with SMTP id s39mr8608564ybi.492.1590703776735;
 Thu, 28 May 2020 15:09:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200528215747.45306-1-edumazet@google.com>
In-Reply-To: <20200528215747.45306-1-edumazet@google.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 28 May 2020 18:08:59 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfrOwrN0N2OF8ykOMqX+N=p_+ib4R1nyTZ0R-Bw40mr-A@mail.gmail.com>
Message-ID: <CA+FuTSfrOwrN0N2OF8ykOMqX+N=p_+ib4R1nyTZ0R-Bw40mr-A@mail.gmail.com>
Subject: Re: [PATCH net] net: be more gentle about silly gso requests coming
 from user
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 5:57 PM Eric Dumazet <edumazet@google.com> wrote:
>
> Recent change in virtio_net_hdr_to_skb() broke some packetdrill tests.
>
> When --mss=XXX option is set, packetdrill always provide gso_type & gso_size
> for its inbound packets, regardless of packet size.
>
>         if (packet->tcp && packet->mss) {
>                 if (packet->ipv4)
>                         gso.gso_type = VIRTIO_NET_HDR_GSO_TCPV4;
>                 else
>                         gso.gso_type = VIRTIO_NET_HDR_GSO_TCPV6;
>                 gso.gso_size = packet->mss;
>         }
>
> Since many other programs could do the same, relax virtio_net_hdr_to_skb()
> to no longer return an error, but instead ignore gso settings.
>
> This keeps Willem intent to make sure no malicious packet could
> reach gso stack.
>
> Note that TCP stack has a special logic in tcp_set_skb_tso_segs()
> to clear gso_size for small packets.
>
> Fixes: 6dd912f82680 ("net: check untrusted gso_size at kernel entry")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Willem de Bruijn <willemb@google.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Thanks a lot for fixing this immediately, Eric.
