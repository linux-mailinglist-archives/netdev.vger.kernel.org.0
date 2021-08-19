Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9D03F1034
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 04:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235588AbhHSCHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 22:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235551AbhHSCHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 22:07:22 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2959C061764
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 19:06:46 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id y23so4365358pgi.7
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 19:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OrL4s0pfrrLzOp/BIo3qRcvOX3sNT0GNldJEqz5rsDw=;
        b=fuMVxwkgoSsXiHms6BPF1MiGm1oMsXyg/diivLVc9WjlsYNnzR3+pDhzo52WsEQbvR
         zhaqt27PqvJbIQuXAPdodbIQ33VwYFrhGPKAFqPEMVtNgcFGP5Gt7PVog7xz+qlaAfAX
         EWlBPYHdwh3Zy73YzPtbjIYpsIxU64a4ejhckP7w56RWL41LLwZ2sT8rNdeUhAn8MNHf
         8jhSUPLcBE1hQUhiyZGrn/PU3XF02gbPKqgQbSpySdHZcHYZMtgiCg4sZSdtjPlF+bb3
         TR8D5hKJ/86RRWLjQUit2RCIxiUDFyOwXs/rDVpxl+qCC1kYKPglwBAzY+fOw4Hfj+q3
         SD3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OrL4s0pfrrLzOp/BIo3qRcvOX3sNT0GNldJEqz5rsDw=;
        b=LBeMePA0tgw6Jk4dVqlzzrF7bUuDrJLNACOYNVQ7Kz/9kfwI0IVX8a+hLiueaK93sY
         02DL4cS2hQmGVZjiCjSlJ6Vz6gsZJYA09hIwmjc6W1su6kjtHnhThQvAJEELGaQEodM4
         UNaY7+Ke2u+0Pbn0PuMA9uzQSrRYbU4WCdWqfbPqFzgmcTQQkbwLCxIpv7hTPegHy3qK
         B97SAZhroa0928SbEpSfHI6bSwZrDKYBsmyo8lkz07he1aOEP3HgEuoFJt7v/PXq/5YP
         Va8UdfI1R+oFWlplRkRuZw+5Na4GVb1HB0hLt+Hk14+HJRDnBkVFvLmp57A9bpekKhFO
         XFEw==
X-Gm-Message-State: AOAM533FfZe23nmMsHSj3NhC2/fyn19t7dTh13B66z+Fi95zHPrPVk37
        DoJUmgFWINPT05n9bVpQvtnTzXKZQIMLyyIhsKJJSA==
X-Google-Smtp-Source: ABdhPJwiHXaMpxjpX1zn1MW0xhzAjYXjj3njAvksdlvRoV+Erau19+0l/ULyoFlBelm5iOBpJ4y+tQEfGuVqDZZ8y4I=
X-Received: by 2002:a63:154d:: with SMTP id 13mr4377452pgv.404.1629338806282;
 Wed, 18 Aug 2021 19:06:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210818022215.5979-1-fankaixi.li@bytedance.com> <401464ef-2238-ebe0-c661-714403083317@gmail.com>
In-Reply-To: <401464ef-2238-ebe0-c661-714403083317@gmail.com>
From:   =?UTF-8?B?6IyD5byA5Zac?= <fankaixi.li@bytedance.com>
Date:   Thu, 19 Aug 2021 10:06:35 +0800
Message-ID: <CAEEdnKEi1ZUMqUjGE7kKZmQLkB+pceo24OLQu9H8PA8J_fUk6Q@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] ovs: clear skb->tstamp in forwarding path
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        xiexiaohui <xiexiaohui.xxh@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> =E4=BA=8E2021=E5=B9=B48=E6=9C=8818=E6=
=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=885:32=E5=86=99=E9=81=93=EF=BC=9A
>
>
>
> On 8/18/21 4:22 AM, fankaixi.li@bytedance.com wrote:
> > From: kaixi.fan <fankaixi.li@bytedance.com>
> >
> > fq qdisc requires tstamp to be cleared in the forwarding path. Now ovs
> > doesn't clear skb->tstamp. We encountered a problem with linux
> > version 5.4.56 and ovs version 2.14.1, and packets failed to
> > dequeue from qdisc when fq qdisc was attached to ovs port.
> >
>
> Fixes: fb420d5d91c1 ("tcp/fq: move back to CLOCK_MONOTONIC")
>
> This is more precise than " version 5.4.56 and ovs version ..."
>
> Thanks.
>
> > Signed-off-by: kaixi.fan <fankaixi.li@bytedance.com>
> > Signed-off-by: xiexiaohui <xiexiaohui.xxh@bytedance.com>
> > Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  net/openvswitch/vport.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
> > index 88deb5b41429..cf2ce5812489 100644
> > --- a/net/openvswitch/vport.c
> > +++ b/net/openvswitch/vport.c
> > @@ -507,6 +507,7 @@ void ovs_vport_send(struct vport *vport, struct sk_=
buff *skb, u8 mac_proto)
> >       }
> >
> >       skb->dev =3D vport->dev;
> > +     skb->tstamp =3D 0;
> >       vport->ops->send(skb);
> >       return;
> >
> >

Hi Eric Dumazet,

Yes and many thanks.
