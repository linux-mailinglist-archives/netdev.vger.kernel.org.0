Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C06CE165EA
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 16:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfEGOlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 10:41:46 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41284 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbfEGOlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 10:41:46 -0400
Received: by mail-pl1-f196.google.com with SMTP id d9so8298832pls.8
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 07:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Y7BvcI6D3fv3rayirClb1DrTYmT5uCAioNQpNqo79Jg=;
        b=WAqyTpTSkgXHoDH5FTLDeslOgDk7v3MThnab0jNbKZJ7l7Gvz+0fm4a/gFLq/Q6ymp
         hsAH21Eb20c08ShgkA1H39Ct95Wnz4R2IIm8MoLx8h8IgyiVekrCq7OGsHlDmFUmUppE
         Sjty1TCOQ+Q5pYgLv+8rykn0iBS4JwxcEA/pfkyq4TJgiQNX0G/Bru208/iqyXxfb8eO
         KS1ptOJW2HfAK+vDwsyIBhrVgr81MhrVreZO38qKhXXO/qNOGvPqxEBP5/xcVzix9C/2
         NzMZzojs/kzM2ZyBerD8FxDKP20rCseu0vxv4UyAmZPpqTTfYOG+mXoGrT3khge29wLI
         CW0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Y7BvcI6D3fv3rayirClb1DrTYmT5uCAioNQpNqo79Jg=;
        b=LgrwQFKEk9lzgzVVmvrwElvC/qr4gtE6KdXPRvP2XDpXgOhxdiH4rwrf59arKi/HlN
         SBrpbCtU8bvaXcbveetoFOCwrhyCJPycw88L3jnda8aNfbx0tdb9yVBTUJeI8DvmutJx
         VtgAlXMtpUa+mKgbhURUWyysNyu2xz1aHUwr713auq5HYWD2I2mQ0ZTz2CU9yYktH3DM
         j1UYYog9Oc19zpWNKKHHl1PbPXBpuXd+o1VwRc7W08Kj+YvpiIlnEUa9HuvazbMTx2Y7
         vx7PirSFEMo8KgljcV/AJdRblFeGbCNLI5KokaXIoeVy5K4DVoouaBfFKPrQmc5Jzp8x
         Pi8Q==
X-Gm-Message-State: APjAAAUuQ1mY4Fd28uQ4owk5LpB9v04VBUnW5VzBbhHmKOp+zzPOmVEK
        zkQMgYXtAlcL9ICFph9V+4qMWYqE29w+KRO+7Gg=
X-Google-Smtp-Source: APXvYqxOhz6jH7f4hNl20TPmiHLXl/UcuMAsuvasvRyeWsUDjQfO47M4k5S//XQ7y581IxcjaxdBy/wllyiSwrAsRNQ=
X-Received: by 2002:a17:902:108a:: with SMTP id c10mr33761375pla.48.1557240105795;
 Tue, 07 May 2019 07:41:45 -0700 (PDT)
MIME-Version: 1.0
References: <1557201816-19945-1-git-send-email-jasowang@redhat.com>
 <CAM_iQpURdiJv9GqkEyk=MPokacvtJVfHUpBb3=6EWA0e1yiTZQ@mail.gmail.com> <a1ef0c0d-d67c-8888-91e6-2819e8c45489@redhat.com>
In-Reply-To: <a1ef0c0d-d67c-8888-91e6-2819e8c45489@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 7 May 2019 07:41:32 -0700
Message-ID: <CAM_iQpVGdduQGdkBn2a+8=VTuZcoTxBdve6+uDHACcDrdtL=Og@mail.gmail.com>
Subject: Re: [PATCH net V2] tuntap: synchronize through tfiles array instead
 of tun->numqueues
To:     Jason Wang <jasowang@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 6, 2019 at 11:19 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2019/5/7 =E4=B8=8B=E5=8D=8812:54, Cong Wang wrote:
> > On Mon, May 6, 2019 at 9:03 PM Jason Wang <jasowang@redhat.com> wrote:
> >> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> >> index e9ca1c0..32a0b23 100644
> >> --- a/drivers/net/tun.c
> >> +++ b/drivers/net/tun.c
> >> @@ -700,6 +700,8 @@ static void __tun_detach(struct tun_file *tfile, b=
ool clean)
> >>                                     tun->tfiles[tun->numqueues - 1]);
> >>                  ntfile =3D rtnl_dereference(tun->tfiles[index]);
> >>                  ntfile->queue_index =3D index;
> >> +               rcu_assign_pointer(tun->tfiles[tun->numqueues - 1],
> >> +                                  NULL);
> >>
> > How does this work? Existing readers could still read this
> > tun->tfiles[tun->numqueues - 1] before you NULL it. And,
> > _if_ the following sock_put() is the one frees it, you still miss
> > a RCU grace period.
> >
> >                  if (clean) {
> >                          RCU_INIT_POINTER(tfile->tun, NULL);
> >                          sock_put(&tfile->sk);
> >
> >
> > Thanks.
>
>
> My understanding is the socket will never be freed for this sock_put().
> We just drop an extra reference count we held when the socket was
> attached to the netdevice (there's a sock_hold() in tun_attach()). The
> real free should happen at another sock_put() in the end of this function=
.

So you are saying readers will never read this sock after free, then
what are you fixing with this patch? Nothing, right?

As I said, reading a stale tun->numqueues is fine, you just keep
believing it is a problem.
