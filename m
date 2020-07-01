Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0410211514
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 23:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbgGAV04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 17:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbgGAV0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 17:26:55 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ECFBC08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 14:26:55 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id t11so9663075qvk.1
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 14:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oqXgEWRYfr8PyQKbFzO30c6DKlqOYjcDaNgRmiO8M6k=;
        b=ZotYLaaY6bOe2OvPV1GxlCJFeVdYF4kqzZzMxPKLrTbWGjKTc3nCKbdkD3F9SjjAdP
         314MwTNO2MdG4gNomvIJHqPOiJBexoTpVroOf86x29eL16iliDsjdnC/SwbXZu1kt2Xw
         nXxMqaceOcJJlps3bHhhZH2TqZpq5IEPRgr2LctX3Bf/uV28kyKw0vX8JbOxX9NbN1qL
         b5uI5qAVjLYpkhp5pdsnXxpyGvxsU0sxNS2vL6fEADNxy30cL1p3rGW4+9dLYNxcsmQH
         h61K1Gvbr6zCGi1z66zp1zOt2MpAsReYJANLY1ccHenmIA4dLWOLXs5EWDsYnzklst4S
         ZRAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oqXgEWRYfr8PyQKbFzO30c6DKlqOYjcDaNgRmiO8M6k=;
        b=IdBLfk8Ti0lgwzVNXHohdFaMrt+ZMVGHXKuQgKSUcQ78bFpJhK/VB0BW2C50sFHY/L
         Vb+ZDtWvafdtZ8ALyzQD7FsYOCqbpuWVU0Xn27BwcdV5+myJUTVGMQrDYe9dyv2z0sF3
         pt0bgXo9eAODFdIMuCSQaG/OS4b5Nb+vxdKGtTwwEATU0JqUWipTpL9qbLyx/KmcO+gn
         jNwQG0cHWrF/LM+E5Mc7LHy39wei6NoLM+5okFCSY6i1/FmKUOXqEbddFt3MRXIn4FQj
         Fr5PBcuxTST5BiIjXwK3Y5szXQcYaVbnftn+43von+SxF+ASLrRLsjknvBEg6Yarh2w0
         zFYw==
X-Gm-Message-State: AOAM530rLhoqp4yfF1Zyw1tQEcIMx8RMwvXJ4X1LBVVFrrZQG84rfsJ4
        +AFFvtf/jniQZ237y/QXsXu/xEiM
X-Google-Smtp-Source: ABdhPJzKL7YtxEHNm6D4p71MYKYuJD1wx/Q3IxnSfA1i8xJnft54BuBhWBiFD7nFWbAfMaRkTqvb1Q==
X-Received: by 2002:a0c:aa9b:: with SMTP id f27mr27578361qvb.9.1593638814030;
        Wed, 01 Jul 2020 14:26:54 -0700 (PDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id i57sm7704379qte.75.2020.07.01.14.26.53
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2020 14:26:53 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id y17so10581871ybm.12
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 14:26:52 -0700 (PDT)
X-Received: by 2002:a25:be02:: with SMTP id h2mr45767743ybk.315.1593638812347;
 Wed, 01 Jul 2020 14:26:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200701200006.2414835-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20200701200006.2414835-1-willemdebruijn.kernel@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 1 Jul 2020 17:26:15 -0400
X-Gmail-Original-Message-ID: <CA+FuTSerdsJAPSVnNC5DWZzoCHfCB6RO3ZSOxOLmesE5w4bytg@mail.gmail.com>
Message-ID: <CA+FuTSerdsJAPSVnNC5DWZzoCHfCB6RO3ZSOxOLmesE5w4bytg@mail.gmail.com>
Subject: Re: [PATCH net] ip: Fix SO_MARK in RST, ACK and ICMP packets
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 4:00 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> From: Willem de Bruijn <willemb@google.com>
>
> When no full socket is available, skbs are sent over a per-netns
> control socket. Its sk_mark is temporarily adjusted to match that
> of the real (request or timewait) socket or to reflect an incoming
> skb, so that the outgoing skb inherits this in __ip_make_skb.
>
> Introduction of the socket cookie mark field broke this. Now the
> skb is set through the cookie and cork:
>
> <caller>                # init sockc.mark from sk_mark or cmsg
> ip_append_data
>   ip_setup_cork         # convert sockc.mark to cork mark
> ip_push_pending_frames
>   ip_finish_skb
>     __ip_make_skb       # set skb->mark to cork mark
>
> But I missed these special control sockets. Update all callers of
> __ip(6)_make_skb that were originally missed.
>
> For IPv6, the same two icmp(v6) paths are affected. The third
> case is not, as commit 92e55f412cff ("tcp: don't annotate
> mark on control socket from tcp_v6_send_response()") replaced
> the ctl_sk->sk_mark with passing the mark field directly as a
> function argument. That commit predates the commit that
> introduced the bug.
>
> Fixes: c6af0c227a22 ("ip: support SO_MARK cmsg")
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> Reported-by: Martin KaFai Lau <kafai@fb.com>

I spotted another missing case, in ping_v6_sendmsg. Will have to send a v2.
