Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A03CB147073
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 19:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbgAWSGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 13:06:45 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43218 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728792AbgAWSGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 13:06:45 -0500
Received: by mail-ed1-f67.google.com with SMTP id dc19so4229216edb.10
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 10:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xq8C26s5Ag4YSRkwj/3ernklbuaULWr84qk69yHOon0=;
        b=CLKp+Csbefgi5XyeDQuwzjewbW9HMGXtvurOxVeLnW2UoUF08n3BBE2HKGXJ5oMn83
         ojk6mw5rwIKdrpaUbsU80JCcyanHGKrkhbK1056J2L04wlvlYVr5c1oHT83Xqnu9tYvY
         LEwq+GGWlSMZkn0gLmOlRz3EKYXbVhOeIGpMao0fqbZOTMMW/qDn0BprAV7u4qVsPOuI
         IVlN2iS+vZQdZ+tKb3XCMdh+hjTd0AGr2/tRomOYb4gGw060n3xEkuAodHN5eGbfj1Tf
         RxdKqQ5fstr0Fh+mDmARYlc74PkAVnXfEuEhyRCQKJdadyLDrRAiptA6KuOTlf2hdBsE
         LZ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xq8C26s5Ag4YSRkwj/3ernklbuaULWr84qk69yHOon0=;
        b=mYr+Rnp+V8/bNY17UwBPthdNqFhHlkgV0nueKjfNo8+JA58Dc+/1t1C33XHDsN/PEQ
         /NFiXGhhsi+4i7tKH1IQEf60xqN9rLPABqkGgADmXDqJhesQbw5lvD05zqRSZuez2NLh
         A0706qjyHHcv7qvbWNCXqCQgJJmFtNVkf70aQRnuQs7Xrr0zVElXueMKa9Rl1M1Hs5Q3
         0ZvO2WJSI/fTMH7z76Qc9wXnOv08jjts5yBmTUeJaDgDITOU1bOp3A2Ypa+AZZud+gNQ
         aRnuM+3+G3XCOZU98/hpduGYp8LBfrtPo4z5UDT4qgR7CShyEL2+L46THAkKEyBC90Mj
         qU1g==
X-Gm-Message-State: APjAAAXeaFux89fh5LxjvR3f92WABaYtNyX399BPKE+7RxcSdqCH6Vr8
        uMTBBh+0FuoVXdOFcK0OYTDHkq62gcjkHzzlXOyWVw==
X-Google-Smtp-Source: APXvYqzjv6a9zpzXpsBg8xzaDyguAXma8w+XOvk37x11FBMKaaEMHF9L6MyHuAJUK4IWOuAUToXe3lbp3DM6Gx+dDKo=
X-Received: by 2002:a05:6402:6d2:: with SMTP id n18mr8208132edy.100.1579802803010;
 Thu, 23 Jan 2020 10:06:43 -0800 (PST)
MIME-Version: 1.0
References: <20200122203253.20652-1-lrizzo@google.com> <875zh2bis0.fsf@toke.dk>
 <953c8fee-91f0-85e7-6c7b-b9a2f8df5aa6@iogearbox.net> <87blqui1zu.fsf@toke.dk>
 <CAMOZA0Kmf1=ULJnbBUVKKjUyzqj2JKfp5ub769SNav5=B7VA5Q@mail.gmail.com> <875zh2hx20.fsf@toke.dk>
In-Reply-To: <875zh2hx20.fsf@toke.dk>
From:   Luigi Rizzo <lrizzo@google.com>
Date:   Thu, 23 Jan 2020 10:06:32 -0800
Message-ID: <CAMOZA0JSZ2iDBk4NOUyNLVE_KmRzYHyEBmQWF+etnpcp=fe0kQ@mail.gmail.com>
Subject: Re: [PATCH] net-xdp: netdev attribute to control xdpgeneric skb linearization
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sameehj@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 10:01 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Luigi Rizzo <lrizzo@google.com> writes:
>
> > On Thu, Jan 23, 2020 at 8:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Daniel Borkmann <daniel@iogearbox.net> writes:
> >>
> >> > On 1/23/20 10:53 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> >> Luigi Rizzo <lrizzo@google.com> writes:
> >> >>
> >> >>> Add a netdevice flag to control skb linearization in generic xdp m=
ode.
> >> >>> Among the various mechanism to control the flag, the sysfs
> >> >>> interface seems sufficiently simple and self-contained.
> >> >>> The attribute can be modified through
> >> >>>     /sys/class/net/<DEVICE>/xdp_linearize
> >> >>> The default is 1 (on)
> >> >
> >> > Needs documentation in Documentation/ABI/testing/sysfs-class-net.
> >> >
> >> >> Erm, won't turning off linearization break the XDP program's abilit=
y to
> >> >> do direct packet access?
> >> >
> >> > Yes, in the worst case you only have eth header pulled into linear
> >> > section. :/
> >>
> >> In which case an eBPF program could read/write out of bounds since the
> >> verifier only verifies checks against xdp->data_end. Right?
> >
> > Why out of bounds? Without linearization we construct xdp_buff as follo=
ws:
> >
> > mac_len =3D skb->data - skb_mac_header(skb);
> > hlen =3D skb_headlen(skb) + mac_len;
> > xdp->data =3D skb->data - mac_len;
> > xdp->data_end =3D xdp->data + hlen;
> > xdp->data_hard_start =3D skb->data - skb_headroom(skb);
> >
> > so we shouldn't go out of bounds.
>
> Hmm, right, as long as it's guaranteed that the bit up to hlen is
> already linear; is it? :)

honest question: that would be skb->len - skb->data_len, isn't that
the linear part by definition ?

cheers
luigi
>
> -Toke
>
