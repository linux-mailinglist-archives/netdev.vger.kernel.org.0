Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6A0FE7E9
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 18:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbfD2QjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 12:39:06 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37309 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728520AbfD2QjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 12:39:06 -0400
Received: by mail-pl1-f195.google.com with SMTP id z8so5337909pln.4;
        Mon, 29 Apr 2019 09:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jUEy/JfKfAv3JgfKqnjgpSSW50RrxOwyz2Nzl3lB0hI=;
        b=ZBrmWAnv9fcmRiGCYDyoIWph2fwLJdjyv3YUg3ROJj5npmjNa4zOXRIbfel92LFMr2
         ph/v/JxibDkDqzXqrljIPY6dsuZc7Zj7t9jeMEvFA7f+TI987shq0jl1rtJ7EDmJKIYR
         0NFJpU+cOC+21BCbdSHCuHsBC4y45lt1hQlXz1LQka//6Ibf2lehV0kTvpR8guw9ODS2
         6ENPmPFY1r8r3ZIAk15xDZQmiDdkbouwXKv9idgbUavUw5EG6JpBnEuqIFOActUDjbHA
         ZyhmpLlyrh+CXZ/DeifNnWhxsZ0tIM/4iWWsFsaX9ZGmTDwNAgMladqCUpnVeB5dVcpF
         FFcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jUEy/JfKfAv3JgfKqnjgpSSW50RrxOwyz2Nzl3lB0hI=;
        b=IBeUZr58ckRnMladsPbfxv0nZNiqnN6ILMjsZwjCaZ9HiK2m0/h0Ga7lchpi3555V9
         virRciygwcWXHC93aNG/pwkP8eYnoUCCBeuobZ7N4FDaKqm3PgMaMgxVDpar2/wEDfV0
         q7bciRZwe8WMtwy+Oub0YONGYAOz+0r5StEd9lg5nOS/XjWR/8o85wBDJZQGCqnSYPQK
         +dMMpiB6al+ohEF0wq8VI9xVv8G88TfTcx3nhD7Y9qD71zjWSsvR7ObNi2uvUcmHlSbj
         gvOQmdTIexyeDEPBejMI/DWj2ljepD9nKSBnGdVMR0QKduHY+CByDj7dbnEWChrCKVcq
         TcdQ==
X-Gm-Message-State: APjAAAU1G9sAOVtJH82wQz4nxnGhsHUyOzJplC9AM3Eq0F+I/h7qI47k
        0q8hAWp6t9U0oc5fDRjLLHyP89cUrEu26nZdrC0=
X-Google-Smtp-Source: APXvYqyMszo9xwsEj1TyrNFV1V5WbicK6+ycUoN8zZVsBE3oF5obZedR/jl686YkTKcc2RWGqce016AWd1HMH8DPC2U=
X-Received: by 2002:a17:902:9b83:: with SMTP id y3mr63071549plp.165.1556555945476;
 Mon, 29 Apr 2019 09:39:05 -0700 (PDT)
MIME-Version: 1.0
References: <71250616-36c1-0d96-8fac-4aaaae6a28d4@redhat.com>
 <20190428030539.17776-1-yuehaibing@huawei.com> <516ba6e4-359b-15d0-e169-d8cc1e989a4a@redhat.com>
 <2c823bbf-28c4-b43d-52d9-b0e0356f03ae@redhat.com> <6AADFAC011213A4C87B956458587ADB4021F7531@dggeml532-mbs.china.huawei.com>
 <b33ce1f9-3d65-2d05-648b-f5a6cfbd59ab@redhat.com> <CAM_iQpUfpruaFowbiTOY7aH4Ts-xcY4JACGLOT3CUjLqpg_zXw@mail.gmail.com>
 <528517144.24310809.1556504619719.JavaMail.zimbra@redhat.com>
In-Reply-To: <528517144.24310809.1556504619719.JavaMail.zimbra@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 29 Apr 2019 09:38:54 -0700
Message-ID: <CAM_iQpXNp4h-ZAf4S+OH_1kVE_qk_eb+r6=ZUsK1t2=3aQOOtw@mail.gmail.com>
Subject: Re: [PATCH] tun: Fix use-after-free in tun_net_xmit
To:     Jason Wang <jasowang@redhat.com>
Cc:     "weiyongjun (A)" <weiyongjun1@huawei.com>,
        yuehaibing <yuehaibing@huawei.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Li,Rongqing" <lirongqing@baidu.com>,
        nicolas dichtel <nicolas.dichtel@6wind.com>,
        Chas Williams <3chas3@gmail.com>, wangli39@baidu.com,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 28, 2019 at 7:23 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2019/4/29 =E4=B8=8A=E5=8D=881:59, Cong Wang wrote:
> > On Sun, Apr 28, 2019 at 12:51 AM Jason Wang <jasowang@redhat.com> wrote=
:
> >>> tun_net_xmit() doesn't have the chance to
> >>> access the change because it holding the rcu_read_lock().
> >>
> >>
> >> The problem is the following codes:
> >>
> >>
> >>          --tun->numqueues;
> >>
> >>          ...
> >>
> >>          synchronize_net();
> >>
> >> We need make sure the decrement of tun->numqueues be visible to reader=
s
> >> after synchronize_net(). And in tun_net_xmit():
> >
> > It doesn't matter at all. Readers are okay to read it even they still u=
se the
> > stale tun->numqueues, as long as the tfile is not freed readers can rea=
d
> > whatever they want...
>
> This is only true if we set SOCK_RCU_FREE, isn't it?


Sure, this is how RCU is supposed to work.

>
> >
> > The decrement of tun->numqueues is just how we unpublish the old
> > tfile, it is still valid for readers to read it _after_ unpublish, we o=
nly need
> > to worry about free, not about unpublish. This is the whole spirit of R=
CU.
> >
>
> The point is we don't convert tun->numqueues to RCU but use
> synchronize_net().

Why tun->numqueues needs RCU? It is an integer, and reading a stale
value is _perfectly_ fine.

If you actually meant to say tun->tfiles[] itself, no, it is a fixed-size a=
rray,
it doesn't shrink or grow, so we don't need RCU for it. This is also why
a stale tun->numqueues is fine, as long as it never goes out-of-bound.


>
> > You need to rethink about my SOCK_RCU_FREE patch.
>
> The code is wrote before SOCK_RCU_FREE is introduced and assume no
> de-reference from device after synchronize_net(). It doesn't harm to
> figure out the root cause which may give us more confidence to the fix
> (e.g like SOCK_RCU_FREE).

I believe SOCK_RCU_FREE is the fix for the root cause, not just a
cover-up.


>
> I don't object to fix with SOCK_RCU_FREE, but then we should remove
> the redundant synchronize_net(). But I still prefer to synchronize
> everything explicitly like (completely untested):

I agree that synchronize_net() can be removed. However I don't
understand your untested patch at all, it looks like to fix a completely
different problem rather than this use-after-free.

Thanks.
