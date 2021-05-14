Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9C0380377
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 07:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhENFuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 01:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbhENFuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 01:50:17 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC60C061574
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 22:49:05 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 36-20020a9d0ba70000b02902e0a0a8fe36so19288263oth.8
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 22:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bE06xAXCXCRjHxZIVvCKZFVX3we62E4nDMf17dk25ts=;
        b=N1aj48wfBA8fNXog/TNxwKCt1hOpvt3nk6RJEDP4coWUX2s7+9OH6R3QaLITJoxTrE
         Zzn+EXzYJhzRVDLXDunJXDPWRAQOP7W0GEDCsedZbqtO5C8ePdg5FixKLFwOhXriy6VH
         0f/WGx3ISGrBqNorGa4/HjdG7FK6YohsZNy6G4jAB4l4uz+izg3LXc2SkhVwDmV+GEyP
         auhpYNKA4q4C2ZCYunWce4JTb6nEDPr5I00fsv+hvFpsdf9jKvsVG8IsDByybgV9u4Rg
         4i6eHzJJ/52mWwaB9g+oMNmDR8u/HM6RUnuhbWWsKM3J5FXGw7XOdMVskvjFiYXhYysj
         ordg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bE06xAXCXCRjHxZIVvCKZFVX3we62E4nDMf17dk25ts=;
        b=qv1z3W/9+FFZ77ULwb0cSMnuW1I3uDvyBytWO8iPwwEND/9CBsnG8UTiut0+9JP9en
         zjEU/r+5b7CPaXLxqlhBSozvI6+TmczRgMZa0X3R1k5EmPT0YRZ3D0+IVH4ii1HXDquU
         TbE/tIqQiJi6LTH8UlzeJaWxvZNkc014Zs6ih5Z+nHbFVdm1e6ZmJfQeX3KqYgvCtvdl
         aq4PFSci5H+LGC/Lzh8s3pWBA4/oSLAvJOCSxHs4ZzOhQaL4z3CUk0mE39785wkAOeQ9
         oYQ0AqamfXR+fs53QWm0AQ/lSxAvi8KQO2mguruN8nvxBooZ6SEmGllzf8n7xn32muKG
         tH/Q==
X-Gm-Message-State: AOAM5309n5KwfKbesVNnqaYJ9jn40TporxpthRz0cxv6LKtqc+nfXWhP
        1Ja/T9qJiZgMRt077uIOVscQw43FyIqsdioIPbUs7Q==
X-Google-Smtp-Source: ABdhPJw6ecjfX4cA6xRIgJtvrTL3DdNwOpNQUZA+OEyZgZIY3AZNDInnxNRJJQlEAM6xDNSsTsXPqu5Gd6ve8wDX7eM=
X-Received: by 2002:a9d:8ce:: with SMTP id 72mr39720820otf.220.1620971344860;
 Thu, 13 May 2021 22:49:04 -0700 (PDT)
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
 <CAOEp5Oe7FQQFbO7KDiyBPs1=ox+6rOimOwounTHBuVki2Y3DAg@mail.gmail.com> <CA+FuTSfr4gLwx0PaRCB1K=TUE_yawpnWx05U9yO0eQ1B+Pa+bg@mail.gmail.com>
In-Reply-To: <CA+FuTSfr4gLwx0PaRCB1K=TUE_yawpnWx05U9yO0eQ1B+Pa+bg@mail.gmail.com>
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
Date:   Fri, 14 May 2021 08:48:52 +0300
Message-ID: <CAOEp5OfqX9r8Ku576tUWPGijGp+CyDewwEqsQRRsZSuDeOsqFw@mail.gmail.com>
Subject: Re: [PATCH 4/4] tun: indicate support for USO feature
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>, Yan Vugenfirer <yan@daynix.com>,
        davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        mst <mst@redhat.com>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 11:43 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> > > > > > So the question is what to do now:
> > > > > > A)
> > > > > > Finalize patches for guest TX and respective QEMU patches
> > > > > > Prepare RFC patches for guest RX, get ack on them
> > > > > > Change the spec
> > > > > > Finalize patches for guest RX according to the spec
> > > > > >
> > > > > > B)
> > > > > > Reject the patches for guest TX
> > > > > > Prepare RFC patches for everything, get ack on them
> > > > > > Change the spec
> > > > > > Finalize patches for everything according to the spec
> > > > > >
> > > > > > I'm for A) of course :)
> > > > >
> > > > > I'm for B :)
> > > > >
> > > > > The reasons are:
> > > > >
> > > > > 1) keep the assumption of tun_set_offload() to simply the logic and
> > > > > compatibility
> > > > > 2) it's hard or tricky to touch guest TX path only (e.g the
> > > > > virtio_net_hdr_from_skb() is called in both RX and TX)
> > > >
> > > > I suspect there is _some_ misunderstanding here.
> > > > I did not touch virtio_net_hdr_from_skb at all.
> > > >
> > >
> > > Typo, actually I meant virtio_net_hdr_to_skb().
> > OK.
> > 2) tun_get_user() which is guest TX - this is covered
> > 3) tap_get_user() which is guest TX - this is covered
> > 4) {t}packet_send() which is userspace TX - this is OK, the userspace
> > does not have this feature, it will never use USO
>
> What do you mean exactly? I can certainly imagine packet socket users
> that could benefit from using udp gso.
I've just tried to understand whether we have a real functional
problem due to the fact that I define the USO feature only for guest
TX path.
This set of patches modifies virtio_net_hdr_to_skb and Jason's comment
was that this procedure is called in both guest TX and RX, there are 4
places where the virtio_net_hdr_to_skb is called, userspace TX is one
of them.
AFAIU userspace 'socket' and 'user' backends of qemu do not have any
offloads at all so they will never use USO also.
Sorry for misunderstanding if any.
>
> When adding support for a new GSO type in virtio_net_hdr, it ideally
> is supported by all users of that interface. Alternatively, if some
> users do not support the flag, a call that sets the flag has to
> (continue to) fail hard, so that we can enable it at a later time.
I agree of course. IMO this is what I've tried to do. I did not have
in the initial plan to make Linux virtio-net to use the USO at all but
this should not present any problem (if I'm not mistaken).
