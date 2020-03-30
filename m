Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADBE8197E34
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 16:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbgC3ORJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 10:17:09 -0400
Received: from mail-qv1-f65.google.com ([209.85.219.65]:34549 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728009AbgC3ORI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 10:17:08 -0400
Received: by mail-qv1-f65.google.com with SMTP id s18so4520193qvn.1
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 07:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HF20H5Ft9VUtSZltaZr28gjJLU4M8cLmEKSyNu+5XAw=;
        b=fLt5lpjHOesmrrB7MetzL8IKOZrPutQdsYU2ovlJWZF3D1jfFmafpNwI4QJcdnxBHI
         eaYWPiVYRQuKBK526FH4pdmMmnUv4FtQlvM9scO7xVvY+mTmb0/NXTp7IEIfH4Y5bSGK
         KdnjrcoVWJnxdXggNIiuqhh+oeC3fK1Y+jNMfCtfXyFEIr2Km/bcRlNvZITblFeJ9GMF
         JhR+eaesBUSGUAYKJPOFcsUBVqdU88dsOdkVR4qqaKpNpr45F1ntVHNEveE9TAE3e5Ae
         CD5dBtlftjag7KbqkpONifCYsU21VVwQMvNk8UBMaszvwOEQDMqJor8PgkVqrN83ie5P
         aP7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HF20H5Ft9VUtSZltaZr28gjJLU4M8cLmEKSyNu+5XAw=;
        b=Nb1Euf20SYOeJ4HWgUPpuolBfy9h/s9sWPvwuDLBRjZ0VhFQs6TRvXK8R3s5gzJhoc
         Zneni2FKNqkMotr9XkP8zWFiakhyhHmazkiDfo7Oi9X0W7cY+aGmEoTl+ntFkkerN5Qr
         uzOJGi2JFzj1xQQzOYjMuomrhS89Vk3wZc3mkJOEiDXI3r52uDb3zCpbqeUEY04bIU0O
         dTFiMWdP4U29yY710U8qGPV78VLALKtSROX5j+hLvpvxcXM3JQcjOvTB2pzO5li3JOYm
         289ZCbn2H2cTJrvhrJWC8x8T4uG3e8aVewv4zdbHPZYtskErvj8O2ZwJgTF7qEGpjP6o
         IHvQ==
X-Gm-Message-State: ANhLgQ0hOLiDIv2MMilgM/R7DJrr5B4KE7hrjaH0WD+m1s5dWKviEMqg
        WFAyVjApmyHkXLuMgenckxqsbTlh
X-Google-Smtp-Source: ADFU+vtx8NuDHcMfu6dRIQrKtuUtFVGk9Aya87KW0d1mzpdJbf4TH+E8zoKAqVtRnAQ0v90lIrKrhA==
X-Received: by 2002:a0c:e644:: with SMTP id c4mr11685729qvn.170.1585577826392;
        Mon, 30 Mar 2020 07:17:06 -0700 (PDT)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com. [209.85.219.170])
        by smtp.gmail.com with ESMTPSA id u123sm10145136qkf.77.2020.03.30.07.17.05
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2020 07:17:05 -0700 (PDT)
Received: by mail-yb1-f170.google.com with SMTP id 11so9103616ybj.11
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 07:17:05 -0700 (PDT)
X-Received: by 2002:a25:814a:: with SMTP id j10mr20490223ybm.178.1585577824530;
 Mon, 30 Mar 2020 07:17:04 -0700 (PDT)
MIME-Version: 1.0
References: <2786b9598d534abf1f3d11357fa9b5f5@sslemail.net>
 <CA+FuTSf5U_ndpmBisjqLMihx0q+wCrqndDAUT1vF3=1DXJnumw@mail.gmail.com>
 <25b83b5245104a30977b042a886aa674@inspur.com> <CAF=yD-LAWc0POejfaB_xRW97BoVdLd6s6kjATyjDFBoK1aP-9Q@mail.gmail.com>
 <31e6d4edec0146e08cb3603ad6c2be4c@inspur.com> <CA+FuTSfG2J-5pu4kieXHm7d4giv4qXmwXBBHtJf0EcB1=83UOw@mail.gmail.com>
 <de32975979434430b914de00916bee95@inspur.com> <CA+FuTSe6vkWNq03zxP9Cbx4oj38sf1omeajh5fZRywouyADO6g@mail.gmail.com>
 <d81dbd7adfbe4bf3ba23649c5d3af59f@inspur.com> <CA+FuTScQfrHFdYYuwB6kWezPLCxs5dQH-hk7Vt9D4SQLzcbLXg@mail.gmail.com>
 <934640b05d7f46848ba2636fcc0b1e34@inspur.com>
In-Reply-To: <934640b05d7f46848ba2636fcc0b1e34@inspur.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 30 Mar 2020 10:16:26 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf5sUxoNTSurptYAq9UGVoDAxPRLHrKHmT0r-QBm=wRmw@mail.gmail.com>
Message-ID: <CA+FuTSf5sUxoNTSurptYAq9UGVoDAxPRLHrKHmT0r-QBm=wRmw@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IFt2Z2VyLmtlcm5lbC5vcmfku6Plj5FdUmU6IFt2Z2VyLmtlcm5lbC5vcmfku6M=?=
        =?UTF-8?B?5Y+RXVJlOiBbUEFUQ0ggbmV0LW5leHRdIG5ldC8gcGFja2V0OiBmaXggVFBBQ0tFVF9WMyBwZXJmb3Jt?=
        =?UTF-8?B?YW5jZSBpc3N1ZSBpbiBjYXNlIG9mIFRTTw==?=
To:     =?UTF-8?B?WWkgWWFuZyAo5p2o54eaKS3kupHmnI3liqHpm4blm6I=?= 
        <yangyi01@inspur.com>
Cc:     "yang_y_yi@163.com" <yang_y_yi@163.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "u9012063@gmail.com" <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 2:35 AM Yi Yang (=E6=9D=A8=E7=87=9A)-=E4=BA=91=E6=
=9C=8D=E5=8A=A1=E9=9B=86=E5=9B=A2 <yangyi01@inspur.com> wrote:
>
> -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> =E5=8F=91=E4=BB=B6=E4=BA=BA: Willem de Bruijn [mailto:willemdebruijn.kern=
el@gmail.com]
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2020=E5=B9=B43=E6=9C=8830=E6=97=A5 =
9:52
> =E6=94=B6=E4=BB=B6=E4=BA=BA: Yi Yang (=E6=9D=A8=E7=87=9A)-=E4=BA=91=E6=9C=
=8D=E5=8A=A1=E9=9B=86=E5=9B=A2 <yangyi01@inspur.com>
> =E6=8A=84=E9=80=81: willemdebruijn.kernel@gmail.com; yang_y_yi@163.com; n=
etdev@vger.kernel.org; u9012063@gmail.com
> =E4=B8=BB=E9=A2=98: Re: [vger.kernel.org=E4=BB=A3=E5=8F=91]Re: [vger.kern=
el.org=E4=BB=A3=E5=8F=91]Re: [PATCH net-next] net/ packet: fix TPACKET_V3 p=
erformance issue in case of TSO
>
> > iperf3 test result
> > -----------------------
> > [yangyi@localhost ovs-master]$ sudo ../run-iperf3.sh
> > iperf3: no process found
> > Connecting to host 10.15.1.3, port 5201 [  4] local 10.15.1.2 port
> > 44976 connected to 10.15.1.3 port 5201
> > [ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
> > [  4]   0.00-10.00  sec  19.6 GBytes  16.8 Gbits/sec  106586    307 KBy=
tes
> > [  4]  10.00-20.00  sec  19.5 GBytes  16.7 Gbits/sec  104625    215 KBy=
tes
> > [  4]  20.00-30.00  sec  20.0 GBytes  17.2 Gbits/sec  106962    301 KBy=
tes
>
> Thanks for the detailed info.
>
> So there is more going on there than a simple network tap. veth, which ca=
lls netif_rx and thus schedules delivery with a napi after a softirq (twice=
), tpacket for recv + send + ovs processing. And this is a single flow, so =
more sensitive to batching, drops and interrupt moderation than a workload =
of many flows.
>
> If anything, I would expect the ACKs on the return path to be the more li=
kely cause for concern, as they are even less likely to fill a block before=
 the timer. The return path is a separate packet socket?
>
> With initial small window size, I guess it might be possible for the enti=
re window to be in transit. And as no follow-up data will arrive, this wait=
s for the timeout. But at 3Gbps that is no longer the case.
> Again, the timeout is intrinsic to TPACKET_V3. If that is unacceptable, t=
hen TPACKET_V2 is a more logical choice. Here also in relation to timely AC=
K responses.
>
> Other users of TPACKET_V3 may be using fewer blocks of larger size. A cha=
nge to retire blocks after 1 gso packet will negatively affect their worklo=
ads. At the very least this should be an optional feature, similar to how I=
 suggested converting to micro seconds.
>
> [Yi Yang] My iperf3 test is TCP socket, return path is same socket as for=
ward path. BTW this patch will retire current block only if vnet header is =
in packets, I don't know what else use cases will use vnet header except ou=
r user scenario. In addition, I also have more conditions to limit this, bu=
t it impacts on performance. I'll try if V2 can fix our issue, this will be=
 only one way to fix our issue if not.
>

Thanks. Also interesting might be a short packet trace of packet
arrival on the bond device ports, taken at the steady state of 3 Gbps.
To observe when inter-arrival time exceeds the 167 usec mean. Also
informative would be to learn whether when retiring a block using your
patch, that block also holds one or more ACK packets along with the
GSO packet. As their delay might be the true source of throttling the sende=
r.

I think we need to understand the underlying problem better to
implement a robust fix that works for a variety of configurations, and
does not causing accidental regressions. The current patch works for
your setup, but I'm afraid that it might paper over the real issue.

It is a peculiar aspect of TPACKET_V3 that blocks are retired not when
a packet is written that fills them, but when the next packet arrives
and cannot find room. Again, at sustained rate that delay should be
immaterial. But it might be okay to measure remaining space after
write and decide to retire if below some watermark. I would prefer
that watermark to be a ratio of block size rather than whether the
packet is gso or not.
