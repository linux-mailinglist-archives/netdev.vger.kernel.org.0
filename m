Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2218A3C5D80
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 15:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234678AbhGLNnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 09:43:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52106 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231351AbhGLNnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 09:43:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626097231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7j3Zqroi+dqqNki2TrXDNIqb1hRewMOgWdvC95TlAw4=;
        b=NgwsX69LeFM1Ei4Rh9R1G5lKmYISI+w9BAEB89k2gnZI35NTUTYiXCvdcoQY2GUsP7j4KB
        d+eAZIi9vGl1FH8m+gtMFGcpBKQ+2/srRhCeux1AxxEO4JEHSFasoJpazYllm9LT/Ayo0M
        ATIt8o1d81NpvW3xY5PQ0jCMAGPLVvk=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-Q7Bq6Jm5N72FgHXj1JSujg-1; Mon, 12 Jul 2021 09:40:30 -0400
X-MC-Unique: Q7Bq6Jm5N72FgHXj1JSujg-1
Received: by mail-io1-f72.google.com with SMTP id v21-20020a5d90550000b0290439ea50822eso11858692ioq.9
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 06:40:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7j3Zqroi+dqqNki2TrXDNIqb1hRewMOgWdvC95TlAw4=;
        b=FL1JeX7TUAa2OXfalUiZ2xRE+tmb5IpBrNc2IQPZFhohb6lY3L67OdjeMylmmmpIOw
         5CD53jZlwIJEYaE9kq4eZlpBlDOg6iJE1d8E+WxM19Wh38MyA/NVurG3F0xYKSIe5k7/
         8lN5Rbt8Q/7kGOBJ/3An9jMP9VHfvsRLa2b3E5+sABMOOkL4df7NR7kMrAuPXFUfc+qJ
         3fsXC6rco+1ZAAgPXPSZTYk6UsCDhgv9gHhOfXMgMOutugZPLZgCRBeBkkR1qywfv8sv
         XcVyo1OJwfA4qSC1LD0eFzBWhUN9rgefGtetGMAOAyO+E8FRcSnc9SLlupOMScjAzGFN
         k7Ow==
X-Gm-Message-State: AOAM533AL+J3Icl49F48pP1eTNFPYjmLqXh0g0/aTAdpA0SStZk2KMY9
        HCkY10ZAKyXRfW/i3fST39/VdDD90q8Wv8gshLpwNRtCF+C14IByf+p+EnLY9ZM2rLMuFhOYjYp
        P7MTOLJAVvFG2sXOQY3oZ/EEGKuQ7uHfc
X-Received: by 2002:a92:260f:: with SMTP id n15mr8265675ile.143.1626097227979;
        Mon, 12 Jul 2021 06:40:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfc0W1sFidpJPASHwOsE17RqYxxjyIGxVFfkMTLr2WOqSSl55D5m6gqjbHqp2J7YG9zZkt8Cj5rerAbl/VfV0=
X-Received: by 2002:a92:260f:: with SMTP id n15mr8265657ile.143.1626097227727;
 Mon, 12 Jul 2021 06:40:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210707081642.95365-1-ihuguet@redhat.com> <0e6a7c74-96f6-686f-5cf5-cd30e6ca25f8@gmail.com>
 <CACT4oudw=usQQNO0dL=xhJw9TN+9V3o=TsKGvGh7extu+JWCqA@mail.gmail.com>
 <20210707130140.rgbbhvboozzvfoe3@gmail.com> <CACT4oud6R3tPFpGuiyNM9kjV5kXqzRcg8J_exv-2MaHWLPm-sA@mail.gmail.com>
 <b11886d2-d2de-35be-fab3-d1c65252a9a8@gmail.com> <4189ac6d-94c9-5818-ae9b-ef22dfbdeb27@redhat.com>
In-Reply-To: <4189ac6d-94c9-5818-ae9b-ef22dfbdeb27@redhat.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Mon, 12 Jul 2021 15:40:16 +0200
Message-ID: <CACT4ouf-0AVHvwyPMGN9q-C70Sjm-PFqBnAz7L4rJGKcsVeYXA@mail.gmail.com>
Subject: Re: [PATCH 1/3] sfc: revert "reduce the number of requested xdp ev queues"
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ivan@cloudflare.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, brouer@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 9, 2021 at 5:07 PM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
> > I think it's less about that and more about avoiding lock contention.
> > If two sources (XDP and the regular stack) are both trying to use a TXQ=
,
> >   and contending for a lock, it's possible that the resulting total
> >   throughput could be far less than either source alone would get if it
> >   had exclusive use of a queue.
> > There don't really seem to be any good answers to this; any CPU in the
> >   system can initiate an XDP_REDIRECT at any time and if they can't eac=
h
> >   get a queue to themselves then I don't see how the arbitration can be
> >   performant.  (There is the middle-ground possibility of TXQs shared b=
y
> >   multiple XDP CPUs but not shared with the regular stack, in which cas=
e
> >   if only a subset of CPUs are actually handling RX on the device(s) wi=
th
> >   an XDP_REDIRECTing program it may be possible to avoid contention if
> >   the core-to-XDP-TXQ mapping can be carefully configured.)
>
> Yes, I prefer the 'middle-ground' fallback you describe.  XDP gets it's
> own set of TXQ-queues, and when driver detect TXQ's are less than CPUs
> that can redirect packets it uses an ndo_xdp_xmit function that takes a
> (hashed) lock (happens per packet burst (max 16)).

That's a good idea, which in fact I had already considered, but I had
(almost) discarded because I still see there 2 problems:
1. If there are no free MSI-X vectors remaining at all,
XDP_TX/REDIRECT will still be disabled.
2. If the amount of free MSI-X vectors is little. Then, many CPUs will
be contending for very few queues/locks, not for normal traffic but
yes for XDP traffic. If someone wants to intensively use
XDP_TX/REDIRECT will get a very poor performance, with no option to
get a better tradeoff between normal and XDP traffic.

We have to consider that both scenarios are very feasible because this
problem appears on machines with a high number of CPUs. Even if
support for more channels and queues per channel is added, who knows
what crazy numbers for CPU cores we will be using in a few years? And
we also have to consider VFs, which usually have much less MSI-X
vectors available, and can be assigned to many different
configurations of virtual machines.

So I think that we still need a last resort fallback of sharing TXQs
with network stack:
1. If there are enough resources: 1 queue per CPU for XDP
2. If there are not enough resources, but still a fair amount: many
queues dedicated only to XDP, with (hashed) locking contention
3. If there are not free resources, or there are very few: TXQs shared
for network core and XDP

Of course, there is always the option of tweaking driver and hardware
parameters to, for example, increase the amount of resources
available. But if the user doesn't use it I think we should give them
a good enough tradeoff. If the user doesn't use XDP, it won't be
noticeable at all. If he/she intensively uses it and doesn't get the
desired performance, he/she will have to tweak parameters.

Jesper has tomorrow a workshop in netdevconf where they will speak
about this topic. Please let us know if you come up with any good new
idea.

Regards
--=20
=C3=8D=C3=B1igo Huguet

