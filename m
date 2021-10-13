Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCA342C6C3
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 18:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237416AbhJMQxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 12:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236555AbhJMQxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 12:53:33 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14E8C061570;
        Wed, 13 Oct 2021 09:51:29 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id y67so418013iof.10;
        Wed, 13 Oct 2021 09:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=70zdYyl9Xzfz3pq/nJGHexC15HbjNcoMFg7MVDEZPI4=;
        b=Kkz9ea9diD9qVR+7m3uTTybHvYoDv+HFjZRdAujqM9siuG8QrwplOpwadwxHqt5AB2
         ESWhlsQOrFhT/JYD8eFW28LUq49Ox/B1Po6J7vjrv5+BOEZV+N9KvPFuDS6c4CnYcNSZ
         mczTWXIuFKCvXY2ydp07tWLxye5V25gPUMKRFtTu9SKbMEUzfdXoH50KTVYbw1pmZ/n6
         a961c5fmxkkAaYPjyoPhPEyHrtmnW6PzNkhNjUdzbFh5GiXvWDxmWxIpF45M5AXxPqo2
         /jOHXmJUb7oBHOgpDODe7eMr9SaB+pmdzHmqvELvVQu0AYWWjYEuAST/e0ujAsmJkQiW
         HOwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=70zdYyl9Xzfz3pq/nJGHexC15HbjNcoMFg7MVDEZPI4=;
        b=pr+DgD5njoiVKCxerABkYIu5zDeMh2uLHNhvHxGP8NPiAyrrkRQzGr0Y1169Ha6cvp
         n/Zo9eugvROJ3wDId7JVVu6bas+g7fLCcsSx7fQ4mYogHAw/KHjkTrGZSOTteFC4xljg
         pBvD17sCg60uQAI1OwK0PvUasNGPFkGkJ1pwGr4Fn39j/JxTLwANNRzwjphdpNmp+oN3
         wD24Jilh70jD1SzCB2i6/Rsmla6MS15vMIbvC4WCEHgsyjgqR8YOXwNlu8YEwR1+Cstl
         zfcLhbh41ksp7JriDTS+o6GJuxnw+bK+lxNQ2NhgunFXK/9AOji1I5AShwHktVfxU9Iv
         jX8g==
X-Gm-Message-State: AOAM531+Waqrrl5fOZ1CkRee//i9FxMbfz/eIuCO4Eos+yQlSFvr4HAF
        RDGpEOb+JQXv1Fj42V44bikG5IH/7ceg0A==
X-Google-Smtp-Source: ABdhPJxd9gUkmwDSPs1TdpOni47shwZcvsC2YFTfmBmW9JdMG8lFZ1/CEe+mvxr34Hk/vFTFSq28XQ==
X-Received: by 2002:a02:708a:: with SMTP id f132mr372627jac.72.1634143889359;
        Wed, 13 Oct 2021 09:51:29 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id 2sm69101iob.13.2021.10.13.09.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 09:51:28 -0700 (PDT)
Date:   Wed, 13 Oct 2021 09:51:20 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Message-ID: <61670e88c86ee_4d1c0208a3@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpXqCQ1BPwqokr6djGmGEHF5BXQDQEPygq16FHDJwxk=uA@mail.gmail.com>
References: <20211008204604.38014-1-xiyou.wangcong@gmail.com>
 <616517b9b7336_2215c208b2@john-XPS-13-9370.notmuch>
 <CAM_iQpXqCQ1BPwqokr6djGmGEHF5BXQDQEPygq16FHDJwxk=uA@mail.gmail.com>
Subject: Re: [Patch bpf] udp: validate checksum in udp_read_sock()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Mon, Oct 11, 2021 at 10:06 PM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > It turns out the skb's in sock receive queue could have
> > > bad checksums, as both ->poll() and ->recvmsg() validate
> > > checksums. We have to do the same for ->read_sock() path
> > > too before they are redirected in sockmap.
> > >
> > > Fixes: d7f571188ecf ("udp: Implement ->read_sock() for sockmap")
> > > Reported-by: Daniel Borkmann <daniel@iogearbox.net>
> > > Reported-by: John Fastabend <john.fastabend@gmail.com>
> > > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > ---
> > >  net/ipv4/udp.c | 11 +++++++++++
> > >  1 file changed, 11 insertions(+)
> > >
> > > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > > index 8536b2a7210b..0ae8ab5e05b4 100644
> > > --- a/net/ipv4/udp.c
> > > +++ b/net/ipv4/udp.c
> > > @@ -1808,6 +1808,17 @@ int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
> > >               skb = skb_recv_udp(sk, 0, 1, &err);
> > >               if (!skb)
> > >                       return err;
> > > +
> > > +             if (udp_lib_checksum_complete(skb)) {
> > > +                     __UDP_INC_STATS(sock_net(sk), UDP_MIB_CSUMERRORS,
> > > +                                     IS_UDPLITE(sk));
> > > +                     __UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS,
> > > +                                     IS_UDPLITE(sk));
> > > +                     atomic_inc(&sk->sk_drops);
> > > +                     kfree_skb(skb);
> >
> > We could use sock_drop() here? Otherwise looks good thanks.
> 
> sock_drop() is in include/linux/skmsg.h, I think we need to move it
> to sock.h before using it here in net/ipv4/udp.c, right?

Yes it would be necessary. Lets not do it here otherwise backports
will be ugly.

Acked-by: John Fastabend <john.fastabend@gmail.com>

> 
> And there are other similar patterns which can be replaced with
> sock_drop(), so we can do the replacement for all in a separate
> patch.
> 
> Thanks.
