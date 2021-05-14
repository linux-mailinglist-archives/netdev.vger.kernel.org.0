Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F17380480
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 09:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbhENHkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 03:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbhENHkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 03:40:03 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2304C061574
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 00:38:52 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id v13-20020a4aa40d0000b02902052145a469so4545914ool.3
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 00:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vLowYfteA+ucPyvyyoQpMI476zm+fyQH6C5ncpnpK5E=;
        b=AYk72NwD5Q3AzJdlfMcjSDolwuKh6xqP/rjNsmWzcoa/+Qu5YhHpWqZo1aUKAzLIv0
         ICAA1RY7CZXcksq2+uGo33ifQlK7+xMSrYLMazMUNMsBfX/lKtdas+bRz0jNb8NJSDjR
         NszP6uDYsaA4OsOtdXYMYItno9bQxuGnNdlaY4K9yoBDPoYnHUUzkrQUnANC4uwhD9xn
         Tb9CSvNHZ0Hs1fSInn+yUEx1YeWrQJ/OQ9zz7buXzDn/+t/nNzZO/qEIdRKrWO8gfsoJ
         lyWu0gHWooSM67NF0PPyyM34fCoPed4R6XIAotCAvTfb060LzBT7cnKRqqzFw9QwiVFb
         qe3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vLowYfteA+ucPyvyyoQpMI476zm+fyQH6C5ncpnpK5E=;
        b=TKX2r1DAipaNjTw6od+mprrCqY/Ss6bXqIfrJqGYwstjVDgbKZeoys8FCRvSoryLO2
         hk89jd8hVIrzU8T2BUyy/9WmFciRGNWj4bQ90L9EH2cyhn6VEKu1xcvu94y+hWwAjkSP
         bzoILavlbCCenVYDWKDrZ0NttSUUWunCc+eFOSnQWCp+jk5NtsoIACqzxWnyzfFTvkvL
         RuFlWxrEbD5t3NOT6u5xfSVkagXnR1pp7RqA0YpChxLJm6QpmhRxzJLjCltdpgJpMPcW
         Nu5Ws3JbYQ2s9H7AJ84Liy0nqvJUwWAiPr/rHuB8AKaiO0P3rqToarIWNleHk03ggNS9
         I1tA==
X-Gm-Message-State: AOAM532Y+EDANMpq8wGm18YSn13J77+CaivdCTQRocGHj1ny1ArnsAWc
        q8dsR8+Bzz2lXYLNuTQU6gdknV86ngKnBIiuhFCP2g==
X-Google-Smtp-Source: ABdhPJwS1fSKvV1YIb9Gu98m+Ob1K+gDnK+Fe1TYbqTQc1uLfyMToTcidxd+FUgOrDr3q3AMCSBbn2CU9cbW97R66N8=
X-Received: by 2002:a05:6820:100a:: with SMTP id v10mr31723524oor.55.1620977932134;
 Fri, 14 May 2021 00:38:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210511044253.469034-1-yuri.benditovich@daynix.com>
 <20210511044253.469034-5-yuri.benditovich@daynix.com> <eb8c4984-f0cc-74ee-537f-fc60deaaaa73@redhat.com>
 <CAOEp5OdrCDPx4ijLcEOm=Wxma6hc=nyqw4Xm6bggBxvgtR0tbg@mail.gmail.com>
 <89759261-3a72-df6c-7a81-b7a48abfad44@redhat.com> <CAOEp5Ocm9Q69Fv=oeyCs01F9J4nCTPiOPpw9_BRZ0WnF+LtEFQ@mail.gmail.com>
 <CACGkMEsZBCzV+d_eLj1aYT+pkS5m1QAy7q8rUkNsdV0C8aL8tQ@mail.gmail.com>
 <CAOEp5OeSankfA6urXLW_fquSMrZ+WYXDtKNacort1UwR=WgxqA@mail.gmail.com>
 <CACGkMEt3bZrdqbWtWjSkXvv5v8iCHiN8hkD3T602RZnb6nPd9A@mail.gmail.com>
 <CAOEp5Odw=eaQWZCXr+U8PipPtO1Avjw-t3gEdKyvNYxuNa5TfQ@mail.gmail.com>
 <CACGkMEuqXaJxGqC+CLoq7k4XDu+W3E3Kk3WvG-D6tnn2K4ZPNA@mail.gmail.com>
 <CAOEp5OfB62SQzxMj_GkVD4EM=Z+xf43TPoTZwMbPPa3BsX2ooA@mail.gmail.com>
 <CACGkMEu4NdyMoFKbyUGG1aGX+K=ShMZuVuMKYPauEBYz5pxYzA@mail.gmail.com>
 <CA+FuTScV+AJ+O3shOMLjUcy+PjBE8uWqCNt0FXWnq9L3gzrvaw@mail.gmail.com> <CACGkMEuUF1vDNWbL9dRr1ZM4vFTLwc3j9uB-66451U1NvQ+2EA@mail.gmail.com>
In-Reply-To: <CACGkMEuUF1vDNWbL9dRr1ZM4vFTLwc3j9uB-66451U1NvQ+2EA@mail.gmail.com>
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
Date:   Fri, 14 May 2021 10:38:39 +0300
Message-ID: <CAOEp5OcozfSWszTm9VArOAH+wm2Fo8tH1QJDsLPZD8ieBLtg-g@mail.gmail.com>
Subject: Re: [PATCH 4/4] tun: indicate support for USO feature
To:     Jason Wang <jasowang@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Yan Vugenfirer <yan@daynix.com>, davem <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mst <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 10:16 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Fri, May 14, 2021 at 4:35 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > > > But surprisingly when TUN receives TUN_F_UFO it does not propagate it
> > > > anywhere, there is no corresponding NETIF flag.
> > >
> > > (It looks like I drop the community and other ccs accidentally, adding
> > > them back and sorry)
> > >
> > > Actually, there is one, NETIF_F_GSO_UDP.
> > >
> > > Kernel used to have NETIF_F_UFO, but it was removed due to bugs and
> > > the lack of real hardware support. Then we found it breaks uABI, so
> > > Willem tries to make it appear for userspace again, and then it was
> > > renamed to NETIF_F_GSO_UDP.
> > >
> > > But I think it's a bug that we don't proporate TUN_F_UFO to NETIF
> > > flag, this is a must for the driver that doesn't support
> > > VIRTIO_NET_F_GUEST_UFO. I just try to disable all offloads and
> > > mrg_rxbuf, then netperf UDP_STREAM from host to guest gives me bad
> > > length packet in the guest.
> > >
> > > Willem, I think we probably need to fix this.
> >
> > We had to add back support for the kernel to accept UFO packets from
> > userspace over tuntap.
> >
> > The kernel does not generate such packets, so a guest should never be
> > concerned of receiving UFO packets.
>
> That's my feeling as well.
>
> But when I:
>
> 1) turn off all guest gso feature and mrg rx buffers, in this case
> virtio-net will only allocate 1500 bytes for each packet
> 2) doing netperf (UDP_STREAM) from local host to guest, I see packet
> were truncated in the guest

Is it possible that the virtio-net does not disable UFO offload?
IMO it sets NETIF_F_LRO too bravely.
>
> >
> > Perhaps i'm misunderstanding the problem here.
> >
>
> I will re-check and get back to you.
> (probably need a while since I will not be online for the next week).
>
> Thanks
>
