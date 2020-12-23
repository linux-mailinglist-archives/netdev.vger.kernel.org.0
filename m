Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94532E1CDD
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 14:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgLWNtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 08:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728251AbgLWNtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 08:49:53 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D15C0613D3
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 05:49:12 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id jx16so22879983ejb.10
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 05:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kDoBl5kU7Uu0Oj9/VHW59eqfYVVogbWtg6TAfuelOT4=;
        b=d/91sDdmpZPQFWzTl8F0ahMMmMRudzBe8ccDSqM9uQnMHNRW8ZAQ7/tbq6b0jOYUUd
         AUtnzZEz9up0A5OJdTS8ldALNVgz1ITWGsXgEWyEqIs34kSZulHfIaXTa/9YewhtoDMT
         tjn0JNgopMuVE87XZ1tSJorwZd97oFRBlNgmcEoovO5Z53USYJtxLnQ/p+F64zPlqabX
         CpBG+qxPjiaaSnP8MYYxGA4D01k5//CY3llLclOfm2Xd4IrOvB+/S7kVXV9bnxvEDM3M
         zcxjMbr/K/HbXOkk8fDj7+JU1EhrMRsO2HeKjJgo8PVtptYoo5W8vI8h2y8oXfpxwAT6
         a1Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kDoBl5kU7Uu0Oj9/VHW59eqfYVVogbWtg6TAfuelOT4=;
        b=HcgcifG7hr+x4Hn/utN0swO5LUJiRg+MoBV9CDpTuOq6W5i3xLOraO9HQ8eOiLayqe
         yOJ27tDk/ZJf9i4fz7qs/JFMOa/c9Avt3qE34QdWfCmw7+T9/x523d60PYvPlqWH0RMj
         fika13sBfdTQ4wHvMsPskgeF2dtSxWvvcf7fGnQ7HRxBPk6r1xOz8vHOvAwVjFCtq0dX
         3yC/La/pKZl3gfTbmeeiw9GrblbT8UznqDPlSviKz283sZj4YtJmlaW8tviaypqCGttu
         mnLqxh9fOBrjv++zcl10r1wguUfHYoydPs1e7nPWNyVedBNT1tqp2KmJshJrq5tP4Yrz
         czEw==
X-Gm-Message-State: AOAM533Std3HbxOvcfTAuZjme5ea6tefwDijQQJ6AjBemnYqBeAtnOvF
        zatQDIBUL3ElXg8pvG0beOrlrzauR87J4qLLYu0=
X-Google-Smtp-Source: ABdhPJy8nTS5vZDsnThh6gD/GDIH0m+tO/6dB07om3hIzXT4luOhuL7Pta9B/WxeohScHf4CL8NX/9sd2r5J9cIQx1s=
X-Received: by 2002:a17:906:aeda:: with SMTP id me26mr23844396ejb.11.1608731351205;
 Wed, 23 Dec 2020 05:49:11 -0800 (PST)
MIME-Version: 1.0
References: <cover.1608065644.git.wangyunjian@huawei.com> <6b4c5fff8705dc4b5b6a25a45c50f36349350c73.1608065644.git.wangyunjian@huawei.com>
 <CAF=yD-K6EM3zfZtEh=305P4Z6ehO6TzfQC4cxp5+gHYrxEtXSg@mail.gmail.com>
 <acebdc23-7627-e170-cdfb-b7656c05e5c5@redhat.com> <CAF=yD-KCs5x1oX-02aDM=5JyLP=BaA7_Jg7Wxt3=JmK8JBnyiA@mail.gmail.com>
 <2a309efb-0ea5-c40e-5564-b8900601da97@redhat.com> <34EFBCA9F01B0748BEB6B629CE643AE60DB8E046@DGGEMM533-MBX.china.huawei.com>
In-Reply-To: <34EFBCA9F01B0748BEB6B629CE643AE60DB8E046@DGGEMM533-MBX.china.huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 23 Dec 2020 08:48:34 -0500
Message-ID: <CAF=yD-Kt0uk=xyCmdfRzddV5LdTebXnAfoEYVX3bzM=L2B2VDQ@mail.gmail.com>
Subject: Re: [PATCH net v2 2/2] vhost_net: fix high cpu load when sendmsg fails
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 8:21 AM wangyunjian <wangyunjian@huawei.com> wrote:
>
> > -----Original Message-----
> > From: Jason Wang [mailto:jasowang@redhat.com]
> > Sent: Wednesday, December 23, 2020 10:54 AM
> > To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > Cc: wangyunjian <wangyunjian@huawei.com>; Network Development
> > <netdev@vger.kernel.org>; Michael S. Tsirkin <mst@redhat.com>;
> > virtualization@lists.linux-foundation.org; Lilijun (Jerry)
> > <jerry.lilijun@huawei.com>; chenchanghu <chenchanghu@huawei.com>;
> > xudingke <xudingke@huawei.com>; huangbin (J)
> > <brian.huangbin@huawei.com>
> > Subject: Re: [PATCH net v2 2/2] vhost_net: fix high cpu load when sendm=
sg fails
> >
> >
> > On 2020/12/22 =E4=B8=8B=E5=8D=8810:24, Willem de Bruijn wrote:
> > > On Mon, Dec 21, 2020 at 11:41 PM Jason Wang <jasowang@redhat.com>
> > wrote:
> > >>
> > >> On 2020/12/22 =E4=B8=8A=E5=8D=887:07, Willem de Bruijn wrote:
> > >>> On Wed, Dec 16, 2020 at 3:20 AM wangyunjian<wangyunjian@huawei.com>
> > wrote:
> > >>>> From: Yunjian Wang<wangyunjian@huawei.com>
> > >>>>
> > >>>> Currently we break the loop and wake up the vhost_worker when
> > >>>> sendmsg fails. When the worker wakes up again, we'll meet the same
> > >>>> error.
> > >>> The patch is based on the assumption that such error cases always
> > >>> return EAGAIN. Can it not also be ENOMEM, such as from tun_build_sk=
b?
> > >>>
> > >>>> This will cause high CPU load. To fix this issue, we can skip this
> > >>>> description by ignoring the error. When we exceeds sndbuf, the
> > >>>> return value of sendmsg is -EAGAIN. In the case we don't skip the
> > >>>> description and don't drop packet.
> > >>> the -> that
> > >>>
> > >>> here and above: description -> descriptor
> > >>>
> > >>> Perhaps slightly revise to more explicitly state that
> > >>>
> > >>> 1. in the case of persistent failure (i.e., bad packet), the driver
> > >>> drops the packet 2. in the case of transient failure (e.g,. memory
> > >>> pressure) the driver schedules the worker to try again later
> > >>
> > >> If we want to go with this way, we need a better time to wakeup the
> > >> worker. Otherwise it just produces more stress on the cpu that is
> > >> what this patch tries to avoid.
> > > Perhaps I misunderstood the purpose of the patch: is it to drop
> > > everything, regardless of transient or persistent failure, until the
> > > ring runs out of descriptors?
> >
> >
> > My understanding is that the main motivation is to avoid high cpu utili=
zation
> > when sendmsg() fail due to guest reason (e.g bad packet).
> >
>
> My main motivation is to avoid the tx queue stuck.
>
> Should I describe it like this:
> Currently the driver don't drop a packet which can't be send by tun
> (e.g bad packet). In this case, the driver will always process the
> same packet lead to the tx queue stuck.
>
> To fix this issue:
> 1. in the case of persistent failure (e.g bad packet), the driver can ski=
p
> this descriptior by ignoring the error.
> 2. in the case of transient failure (e.g -EAGAIN and -ENOMEM), the driver
> schedules the worker to try again.

That sounds good to me, thanks.

> Thanks
>
> >
> > >
> > > I can understand both a blocking and drop strategy during memory
> > > pressure. But partial drop strategy until exceeding ring capacity
> > > seems like a peculiar hybrid?
> >
> >
> > Yes. So I wonder if we want to be do better when we are in the memory
> > pressure. E.g can we let socket wake up us instead of rescheduling the
> > workers here? At least in this case we know some memory might be freed?

I don't know whether a blocking or drop strategy is the better choice.
Either way, it probably deserves to be handled separately.
