Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C655253E45
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 08:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgH0G4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 02:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgH0G4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 02:56:44 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A90FC061264;
        Wed, 26 Aug 2020 23:56:43 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id d139so4985147qke.11;
        Wed, 26 Aug 2020 23:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Er7pC6f9+6BD8gyr18V3D1Q73tbNxSRhAqtmI2X6nOM=;
        b=OgcUHaNClZd1MpBt8rFyLzlXstxAAa1Z+jCH7sIZO2a3IlNY/xVHwS0aGv9DT0rKlU
         JidU1D7MJIGsUthNMqBINoEJwMVj89mi8MJZvJIpHsHIqDIA+/5gGzH/UIIyJt8A03TC
         lbXOXaRHS0X7EV9VBBXRZMPQ/iF1l8lAC8FkcELQdkO8SBBXhXgnRkGQqlQW8sipX+IG
         5a9cusVomBE0RJLtmcBRnJKnHzkO8EFsbOua5XVlK+UjVb8yknZKgIh1UDOQKyDfseHW
         TJOjGBEbOCty3JKm3h+NTFTzLfX8ClfmrmuQHKqp5tZuTSXorh+nr5K37La0NDQgyCSv
         haPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Er7pC6f9+6BD8gyr18V3D1Q73tbNxSRhAqtmI2X6nOM=;
        b=IULWFmLfQy1/FPgvtZE2qy2URjfJ+p3GFOoTxdaBDBF6Kz8spa5wFbJQ+N+LTTllIO
         j7s/mpF5iPVGGK4KDPPsi2jHoerzSa2LCVZUf7kFU1i3mMgRxtFixGKR1OSMoAsFko5D
         nuupLa1DOimzMJ7U819HAuSDc5eNX/IskAhor/0zwtOMspPi4s8osMI9rqiFrUFQegJO
         acWU1IBqhQ/c9A1yIr9PVqZPnEgFf0nD+CW8YASN9o1zMiKMYYole/NmBQgiz37k/mMX
         3QSNZne2/pfbtgCeCfz1faSU6r4xuqQ5AqNNVsgHogoKO1knHH/aihVTDEeXMShE7M8y
         zJug==
X-Gm-Message-State: AOAM533VbrAn485x4OQcyxgd1giNG/XOkBjco6Xly4Ah/c3TFguDn3iy
        L542eWNhayq5j6pMEmw7nebqQ2fsL8/9suWc72A=
X-Google-Smtp-Source: ABdhPJyQCl8Bfu3PWHi2CM66Yt+36l6Yois8pTCGVHF7JpLJw+3maHbONVuc1bdp/7DywNuMIzsBkrqC39EZVEpVKUo=
X-Received: by 2002:a37:b482:: with SMTP id d124mr16796862qkf.98.1598511402861;
 Wed, 26 Aug 2020 23:56:42 -0700 (PDT)
MIME-Version: 1.0
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200623134259.8197-1-mzhivich@akamai.com> <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
 <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
 <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
 <7fd86d97-6785-0b5f-1e95-92bc1da9df35@netrounds.com> <500b4843cb7c425ea5449fe199095edd5f7feb0c.camel@redhat.com>
 <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com> <CANE52Ki8rZGDPLZkxY--RPeEG+0=wFeyCD6KKkeG1WREUwramw@mail.gmail.com>
 <20200822032800.16296-1-hdanton@sina.com> <CACS=qqKhsu6waaXndO5tQL_gC9TztuUQpqQigJA2Ac0y12czMQ@mail.gmail.com>
 <20200825032312.11776-1-hdanton@sina.com> <CACS=qqK-5g-QM_vczjY+A=3fi3gChei4cAkKweZ4Sn2L537DQA@mail.gmail.com>
 <20200825162329.11292-1-hdanton@sina.com> <CACS=qqKgiwdCR_5+z-vkZ0X8DfzOPD7_ooJ_imeBnx+X1zw2qg@mail.gmail.com>
 <CACS=qqKptAQQGiMoCs1Zgs9S4ZppHhasy1AK4df2NxnCDR+vCw@mail.gmail.com> <5f46032e.1c69fb81.9880c.7a6cSMTPIN_ADDED_MISSING@mx.google.com>
In-Reply-To: <5f46032e.1c69fb81.9880c.7a6cSMTPIN_ADDED_MISSING@mx.google.com>
From:   Kehuan Feng <kehuan.feng@gmail.com>
Date:   Thu, 27 Aug 2020 14:56:31 +0800
Message-ID: <CACS=qq+Yw734DWhETNAULyBZiy_zyjuzzOL-NO30AB7fd2vUOQ@mail.gmail.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Hillf Danton <hdanton@sina.com>
Cc:     Jike Song <albcamus@gmail.com>, Josh Hunt <johunt@akamai.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hillf,

> Let=E2=80=99s see if TCQ_F_NOLOC is making fq_codel different in your tes=
ting.

I assume you meant disabling NOLOCK for pfifo_fast.

Here is the modification,

--- ./net/sched/sch_generic.c.orig      2020-08-24 22:02:04.589830751 +0800
+++ ./net/sched/sch_generic.c   2020-08-27 10:17:10.148977195 +0800
@@ -792,7 +792,7 @@
        .dump           =3D       pfifo_fast_dump,
        .change_tx_queue_len =3D  pfifo_fast_change_tx_queue_len,
        .owner          =3D       THIS_MODULE,
-       .static_flags   =3D       TCQ_F_NOLOCK | TCQ_F_CPUSTATS,
+       .static_flags   =3D       TCQ_F_CPUSTATS,

The issue never happen again with it for over 3 hours stressing. And I
restarted the test for two times. No any surprising. Quite stable...


Hillf Danton <hdanton@sina.com> =E4=BA=8E2020=E5=B9=B48=E6=9C=8826=E6=97=A5=
=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=882:37=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi Feng,
>
>
>
> On Wed, 26 Aug 2020 11:12:38 +0800 Fengkehuan Feng wrote:
>
> >Hi Hillf,
> >
> >I just gave more tries on the patch, and it seems not that good as what =
I told in last email.
>
> >I could see more packets getting stuck now...
>
> We have more to learn here:P
>
> >
> >Let me explain what I am facing in detail in case we are not aligning to=
 fix the same problem.
> >
> >Our application is in deep learning scenario and it's based on NVIDIA NC=
CL to do
>
> >collective communication intra-node or inter-node (to be more specific, =
it's data
>
> > all-reduce on two servers witch 8 GPU nodes each).
> >NCCL can support data transmission through TCP/RDMA/GDR. In normal, it t=
akes
>
> > about 1000 us for TCP or less for RDMA/GDR to transmit 512KB packet, bu=
t
>
> > sometimes it tooks hundreds of millisecond or several seconds to get co=
mpleted.
> >
>
> >When we change the default qdisc from pfifo_fast to fq_codel, the issue =
never
>
> > happen, so we suspect it's something wrong within the networking stack =
(but
>
> > it's a bit strange that RDMA or GDR has the same problem)
>
> Let=E2=80=99s see if TCQ_F_NOLOC is making fq_codel different in your tes=
ting.
>
>
>
> --- a/net/sched/sch_generic.c
>
> +++ b/net/sched/sch_generic.c
>
> @@ -791,7 +791,7 @@ struct Qdisc_ops pfifo_fast_ops __read_m
>
>       .dump           =3D    pfifo_fast_dump,
>
>       .change_tx_queue_len =3D  pfifo_fast_change_tx_queue_len,
>
>       .owner          =3D    THIS_MODULE,
>
> -     .static_flags   =3D    TCQ_F_NOLOCK | TCQ_F_CPUSTATS,
>
> +    .static_flags   =3D    TCQ_F_CPUSTATS,
>
> };
>
> EXPORT_SYMBOL(pfifo_fast_ops);
>
> --
>
>
>
> >
> >Here is the log print from our test application,
> >
> >size: 512KB, use_time: 1118us, speed: 0.436745GB/s
> >size: 512KB, use_time: 912us, speed: 0.535396GB/s
> >size: 512KB, use_time: 1023us, speed: 0.477303GB/s
> >size: 512KB, use_time: 919us, speed: 0.531318GB/s
> >size: 512KB, use_time: 1129us, speed: 0.432490GB/s
> >size: 512KB, use_time: 2098748us, speed: 0.000233GB/s
> >size: 512KB, use_time: 1018us, speed: 0.479648GB/s
> >size: 512KB, use_time: 1120us, speed: 0.435965GB/s
> >size: 512KB, use_time: 1071us, speed: 0.455912GB/
>
>
>
>
>
> JFYI I failed to find this message at lore.kernel.org perhaps
>
> because of pure text mail.
>
>
>
> Thanks
>
> Hillf
