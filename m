Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB79F196899
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 19:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgC1ShG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 14:37:06 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41967 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgC1ShF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 14:37:05 -0400
Received: by mail-qk1-f193.google.com with SMTP id q188so14624925qke.8
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 11:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GWFiIvmzPTVIeO2K+0KHEdguA+rtzJojGFxB3fK+bVc=;
        b=Foi0ctXJn70SeIKGLY+pCATWHzUwd/6sOZdw3BFgnw3rDea6q1W6gm2V+ImziUIjrq
         xPD9SLkWuoMszRzg68cjMIkZ2fgxl4CNC5NW0Wvd7vma/Phf1t6sNu7auv/buUQjSNF5
         S1Ie6UsC/zHUXsVOHhgTOjlQyAd0NdGpyeoGVf3syI0oHU7VpLisfp02tl2KVZwcap2d
         Urhq9gYu7Oc6u1IbnZ3/xoKPoCwfs8n+PB5+9fLGURTA1WOwV7gOLOu6WNKHibobjdJU
         L43rns/8/SrCo/0GD5KWiG2Ox8Tuqgke4cDXLlexhhR6OgeVHpKeCbP/XFU9lgOi5Ip/
         v6AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GWFiIvmzPTVIeO2K+0KHEdguA+rtzJojGFxB3fK+bVc=;
        b=r8jgCWNEfEFnwe0PyEJdVcg7te7Z7r3yVVW06wYo5ug9LG83zRM9zdVPrLT8Ru/sBL
         kcGnSmBsc4nvHKZ8SihZuStO7of2rZwMdxFoshznMqWTVqK9a7P3JO6bAOaoxrq9hq4A
         WsN3G3U7skYEzrLHJ4ZQNBaxJIiIkCosLVuPcW7GuZV/oboewletENWvT4RhYZccsvx0
         jJG0geLbENmNDZNDDXuA1woJ6Ge0WFWMWmK2shuiKpUEbCsRjLg6L1oNSfbIdH6F2xn0
         MCFO6DybPuowFs3GN3xF/5T3NFTSwqft+OzoP7ZgizSUL4njko1SzC7OAfO4RnEFTfuz
         a5KQ==
X-Gm-Message-State: ANhLgQ2Oyv6gK47KTcjf6NthQKY0tDjwd6TWFUfS+XLjWjPBgTYvX1fk
        tVUDFmNKzm88knEkHNDqpk7lJJ3s
X-Google-Smtp-Source: ADFU+vtukUKqVx+CN2hN638h5bHqaHECKjYF1PCgdiModrNGwoR5n7ldDYzaVHs7mA6aXbVpC96h4w==
X-Received: by 2002:a37:a612:: with SMTP id p18mr5145652qke.228.1585420623570;
        Sat, 28 Mar 2020 11:37:03 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id f19sm6580349qtq.78.2020.03.28.11.37.02
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Mar 2020 11:37:02 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id p196so6563945ybc.0
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 11:37:02 -0700 (PDT)
X-Received: by 2002:a25:af0e:: with SMTP id a14mr7452799ybh.53.1585420621552;
 Sat, 28 Mar 2020 11:37:01 -0700 (PDT)
MIME-Version: 1.0
References: <2786b9598d534abf1f3d11357fa9b5f5@sslemail.net>
 <CA+FuTSf5U_ndpmBisjqLMihx0q+wCrqndDAUT1vF3=1DXJnumw@mail.gmail.com>
 <25b83b5245104a30977b042a886aa674@inspur.com> <CAF=yD-LAWc0POejfaB_xRW97BoVdLd6s6kjATyjDFBoK1aP-9Q@mail.gmail.com>
 <31e6d4edec0146e08cb3603ad6c2be4c@inspur.com> <CA+FuTSfG2J-5pu4kieXHm7d4giv4qXmwXBBHtJf0EcB1=83UOw@mail.gmail.com>
 <de32975979434430b914de00916bee95@inspur.com>
In-Reply-To: <de32975979434430b914de00916bee95@inspur.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 28 Mar 2020 14:36:23 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe6vkWNq03zxP9Cbx4oj38sf1omeajh5fZRywouyADO6g@mail.gmail.com>
Message-ID: <CA+FuTSe6vkWNq03zxP9Cbx4oj38sf1omeajh5fZRywouyADO6g@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IFt2Z2VyLmtlcm5lbC5vcmfku6Plj5FdUmU6IFt2Z2VyLmtlcm5lbC5vcmfku6M=?=
        =?UTF-8?B?5Y+RXVJlOiBbUEFUQ0ggbmV0LW5leHRdIG5ldC8gcGFja2V0OiBmaXggVFBBQ0tFVF9WMyBwZXJmb3Jt?=
        =?UTF-8?B?YW5jZSBpc3N1ZSBpbiBjYXNlIG9mIFRTTw==?=
To:     =?UTF-8?B?WWkgWWFuZyAo5p2o54eaKS3kupHmnI3liqHpm4blm6I=?= 
        <yangyi01@inspur.com>
Cc:     "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "yang_y_yi@163.com" <yang_y_yi@163.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "u9012063@gmail.com" <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 28, 2020 at 4:37 AM Yi Yang (=E6=9D=A8=E7=87=9A)-=E4=BA=91=E6=
=9C=8D=E5=8A=A1=E9=9B=86=E5=9B=A2 <yangyi01@inspur.com> wrote:
>
>
> -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> =E5=8F=91=E4=BB=B6=E4=BA=BA: Willem de Bruijn [mailto:willemdebruijn.kern=
el@gmail.com]
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2020=E5=B9=B43=E6=9C=8827=E6=97=A5 =
11:17
> =E6=94=B6=E4=BB=B6=E4=BA=BA: Yi Yang (=E6=9D=A8=E7=87=9A)-=E4=BA=91=E6=9C=
=8D=E5=8A=A1=E9=9B=86=E5=9B=A2 <yangyi01@inspur.com>
> =E6=8A=84=E9=80=81: willemdebruijn.kernel@gmail.com; yang_y_yi@163.com; n=
etdev@vger.kernel.org; u9012063@gmail.com
> =E4=B8=BB=E9=A2=98: Re: [vger.kernel.org=E4=BB=A3=E5=8F=91]Re: [vger.kern=
el.org=E4=BB=A3=E5=8F=91]Re: [PATCH net-next] net/ packet: fix TPACKET_V3 p=
erformance issue in case of TSO
>
> > On Wed, Mar 25, 2020 at 8:45 PM Yi Yang (=E6=9D=A8=E7=87=9A)-=E4=BA=91=
=E6=9C=8D=E5=8A=A1=E9=9B=86=E5=9B=A2 <yangyi01@inspur.com> wrote:
> > >
> > > By the way, even if we used hrtimer, it can't ensure so high performa=
nce improvement, the reason is every frame has different size, you can't kn=
ow how many microseconds one frame will be available, early timer firing wi=
ll be an unnecessary waste, late timer firing will reduce performance, so I=
 still think the way this patch used is best so far.
> > >
> >
> > The key differentiating feature of TPACKET_V3 is the use of blocks to e=
fficiently pack packets and amortize wake ups.
> >
> > If you want immediate notification for every packet, why not just use T=
PACKET_V2?
> >
> > For non-TSO packet, TPACKET_V3 is much better than TPACKET_V2, but for =
TSO packet, it is bad, we prefer to use TPACKET_V3 for better performance.
>
> At high rate, blocks are retired and userspace is notified as soon as a p=
acket arrives that does not fit and requires dispatching a new block. As su=
ch, max throughput is not timer dependent. The timer exists to bound notifi=
cation latency when packet arrival rate is slow.
>
> [Yi Yang] Per our iperf3 tcp test with TSO enabled, even if packet size i=
s about 64K and block size is also 64K + 4K (to accommodate tpacket_vX head=
er), we can't see high performance without this patch, I think some small p=
ackets before 64K big packets decide what performance it can reach, accordi=
ng to my trace, TCP packet size is increasing from less than 100 to 64K gra=
dually, so it looks like how long this period took decides what performance=
 it can reach. So yes, I don=E2=80=99t think hrtimer can help fix this issu=
e very efficiently. In addition, I also noticed packet size pattern is 1514=
, 64K, 64K, 64K, 64K, ..., 1514, 64K even if it reaches 64K packet size, ma=
ybe that 1514 packet has big impact on performance, I just guess.

Again, the main issue is that the timer does not matter at high rate.
The 3 Gbps you report corresponds to ~6000 TSO packets, or 167 usec
inter arrival time. The timer, whether 1 or 4 ms, should never be
needed.

There are too many unknown variables here. Besides block size, what is
tp_block_nr? What is the drop rate? Are you certain that you are not
causing drops by not reading fast enough? What happens when you
increase tp_block_size or tp_block_nr? It may be worthwhile to pin
iperf to one (set of) core(s) and the packet socket reader to another.
Let it busy spin and do minimal processing, just return blocks back to
the kernel.

If unsure about that, it may be interesting to instrument the kernel
and count how many block retire operations are from
prb_retire_rx_blk_timer_expired and how many from tpacket_rcv.

Note that do_vnet only changes whether a virtio_net_header is prefixed
to the data. Having that disabled (the common case) does not stop GSO
packets from arriving.
