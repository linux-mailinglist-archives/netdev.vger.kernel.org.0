Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9438F3BF9E8
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 14:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhGHMRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 08:17:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24248 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229795AbhGHMRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 08:17:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625746465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I55zh2XXZG4Wh8FdZlPVvOlalnJqCExFPnbC3bw2voU=;
        b=gCVKbwkFuXcZSDFBztb01rBSN1REjjsuGxaY81Op7Z1dGYrx8CYJnlqn8LUo+Tz5n7rNtj
        T6Qhg6yY5w5wJtrPuSRvm5I6i6AhnPg85Dz8vMqYoXdXObPQHwfKwyHRPl8qN5TBXYBcCo
        SG6qeug/PXMrchqNNhSsjxyEgqH47NI=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-FCh7NyBVM4Ck-ouEcB2Zyg-1; Thu, 08 Jul 2021 08:14:24 -0400
X-MC-Unique: FCh7NyBVM4Ck-ouEcB2Zyg-1
Received: by mail-il1-f199.google.com with SMTP id g16-20020a92c7d00000b02901fedf02bce4so3456154ilk.15
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 05:14:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=I55zh2XXZG4Wh8FdZlPVvOlalnJqCExFPnbC3bw2voU=;
        b=H4krfl+/o+xRRbyCzbAI+ezUVkj5hzjx+/Iu1/4Os5BJAW6vijyaj7tm5URWCSiUKh
         J0/RytlIEhtTznlEpf8fhJhy3ERAxlSDnGnP1Hrlk6lMAwA73agL4L+y+lKdmN0l8kHa
         UUc1B27Udx3AgLQTbM6R++svEnPk30T8VtrXFuzxpTeZi3CI3cx3RhmHAsv9urzqpOfu
         7vn0gIpV4PcLG8J06dR4qbVK3QXIbOvHegaalUBGfgSpcg597yJ07OyLZiuq9hMxony+
         wBitjpXx0UhUw6ys9uoobr2LG+wpW9Ye8OzPH8abfzjG0e0cImtCea0j+YwzCvBawmVf
         KbHA==
X-Gm-Message-State: AOAM533L5yBVCv/ORVPw5fZWP31VJ+g2PE5+vVkgLl5MQXAJL59ZJwJV
        tJmtBiLzK7IRdW8bKtS4GN8Gv7dDDZqD5WQzIWqUjJxffi/fbfNMIsXXCT81ixyet1ltX6xuR2R
        ReB5uY2KBLOx255fS3M44FlTzxqeitllU
X-Received: by 2002:a05:6638:372c:: with SMTP id k44mr26426568jav.94.1625746464045;
        Thu, 08 Jul 2021 05:14:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2Ybl/++F5bCkFRwxr1Df16nASMIT1l9l7RKaCM5kiK/gmVXr2wTAan2c6EykGJnA7ffNMJC1G/s1frAEY8uU=
X-Received: by 2002:a05:6638:372c:: with SMTP id k44mr26426536jav.94.1625746463835;
 Thu, 08 Jul 2021 05:14:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210707081642.95365-1-ihuguet@redhat.com> <0e6a7c74-96f6-686f-5cf5-cd30e6ca25f8@gmail.com>
 <CACT4oudw=usQQNO0dL=xhJw9TN+9V3o=TsKGvGh7extu+JWCqA@mail.gmail.com> <20210707130140.rgbbhvboozzvfoe3@gmail.com>
In-Reply-To: <20210707130140.rgbbhvboozzvfoe3@gmail.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Thu, 8 Jul 2021 14:14:13 +0200
Message-ID: <CACT4oud6R3tPFpGuiyNM9kjV5kXqzRcg8J_exv-2MaHWLPm-sA@mail.gmail.com>
Subject: Re: [PATCH 1/3] sfc: revert "reduce the number of requested xdp ev queues"
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ivan@cloudflare.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 3:01 PM Martin Habets <habetsm.xilinx@gmail.com> wro=
te:
> > Another question I have, thinking about the long term solution: would
> > it be a problem to use the standard TX queues for XDP_TX/REDIRECT? At
> > least in the case that we're hitting the resources limits, I think
> > that they could be enqueued to these queues. I think that just taking
> > netif_tx_lock would avoid race conditions, or a per-queue lock.
>
> We considered this but did not want normal traffic to get delayed for
> XDP traffic. The perceived performance drop on a normal queue would
> be tricky to diagnose, and the only way to prevent it would be to
> disable XDP on the interface all together. There is no way to do the
> latter per interface, and we felt the "solution" of disabling XDP
> was not a good way forward.
> Off course our design of this was all done several years ago.

In my opinion, there is no reason to make that distinction between
normal traffic and XDP traffic. XDP traffic redirected with XDP_TX or
XDP_REDIRECT is traffic that the user has chosen to redirect that way,
but pushing the work down in the stack. Without XDP, this traffic had
gone up the stack to userspace, or at least to the firewall, and then
redirected, passed again to the network stack and added to normal TX
queues.

If the user wants to prevent XDP from mixing with normal traffic, just
not attaching an XDP program to the interface, or not using
XDP_TX/REDIRECT in it would be enough. Probably I don't understand
what you want to say here.

Anyway, if you think that keeping XDP TX queues separated is the way
to go, it's OK, but my proposal is to share the normal TX queues at
least in the cases where dedicated queues cannot be allocated. As you
say, the performance drop would be tricky to measure, if there's any,
but in any case, even separating the queues, they're competing for
resources of CPU, PCI bandwidth, network bandwidth...

The fact is that the situation right now is this one:
- Many times (or almost always with modern servers' processors)
XDP_TX/REDIRECT doesn't work at all
- The only workaround is reducing the number of normal channels to let
free resources for XDP, but this is a much higher performance drop for
normal traffic than sharing queues with XDP, IMHO.

Increasing the maximum number of channels and queues, or even making
them virtually unlimited, would be very good, I think, because people
who knows how to configure the hardware would take advantage of it,
but there will always be situations of getting short of resources:
- Who knows how many cores we will be using 5 forward from now?
- VFs normally have less resources available: 8 MSI-X vectors by default

With some time, I can try to prepare some patches with these changes,
if you agree.

Regards
--=20
=C3=8D=C3=B1igo Huguet

