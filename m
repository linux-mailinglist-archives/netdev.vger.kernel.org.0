Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDB82B0CA1
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 19:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgKLS3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 13:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgKLS3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 13:29:18 -0500
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27E6C0613D1;
        Thu, 12 Nov 2020 10:29:17 -0800 (PST)
Received: by mail-qv1-xf42.google.com with SMTP id e5so3259317qvs.1;
        Thu, 12 Nov 2020 10:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ekWyk5unUG/8qQyT7FheQDPWXEXzVN/qvTOESL1HDOM=;
        b=csUVOeAHUGCCUxWdZ66CNCGO6rXAPrPc0JP0DL8z9OUJUXxRllR9LhNSEBKMq+YIvZ
         YoYvQ/R1N9E74ptmQYYOKB3aLFTUgzMUjjymz9RQhQqLhL/G6rgNvIU8DDuR3iv+O0Pv
         G2iMtk6V7cg5p4u5gjCnVqVQhLdbFXcUQDzA+tOHZot79/lqnsNe4Vr5NN95GFXpyaAn
         wZt1sMiq7hMZtysSD0XsgS/AiPbqsHPwNT9nvFmlhP6w8q2NzO4AE6T9xuQxm63XYz7s
         yKXDaRhV85Gd621bqaU+jpgx8HAi+eA87H2O8QxT0Uu6ZM3wQWln6JDMV61M3L+ArITQ
         eb9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ekWyk5unUG/8qQyT7FheQDPWXEXzVN/qvTOESL1HDOM=;
        b=QtaPkmFb9bKve6lXYGLm8OX0DG7e9uGlyetd5yIB5zSLOcfwyYCdDooneAZ2Xb3Epo
         WxplLUhmU8pHjro6pULLBndwMiihoi7NVsi9ewFkY54JvRtr05bLRbLnKw/F7p6vjde1
         +6amUqSxfvhCAHO6sEiz5cRbTq6KYCQRzYL5swTzgVIJXgO4JFELAWLX3nM/GX1K44WD
         eAlCL9OLwk9W7IGVZF6Iid12Pp6CEFnG+s5YGYEWac6CslTSjYxo+FnKCt88FRSQDxQ4
         QC7Q4AI+T9cTLyYZQxl1+XhQAvfFuEw8YqMoDPQ9ytkyXSp96j0yL5Dnp24AGAmBb2NK
         JbnA==
X-Gm-Message-State: AOAM5326N/C0oi6a6b8f9CsNOjr003MO4Q9VyzqnRkG/gA1qzeRvTaCk
        8uyx1FtsHNgLBQg3ng6wIPieItV0G7JlFX2p4Ig=
X-Google-Smtp-Source: ABdhPJx1xTZp5I7Yh0efgzslxiGk2NZI6iBcygmuHGG9CP3X416xRVvwR14UB8t+u35xfuztkd5NG9YU/uLtChHF1Qg=
X-Received: by 2002:a05:6214:32f:: with SMTP id j15mr737002qvu.35.1605205757123;
 Thu, 12 Nov 2020 10:29:17 -0800 (PST)
MIME-Version: 1.0
References: <20200909091302.20992-1-dnlplm@gmail.com> <CAKfDRXhDFk7x7b35G5w4XytcL29cw=U8tVpvFJmbsWezVUsTtQ@mail.gmail.com>
In-Reply-To: <CAKfDRXhDFk7x7b35G5w4XytcL29cw=U8tVpvFJmbsWezVUsTtQ@mail.gmail.com>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Thu, 12 Nov 2020 19:28:56 +0100
Message-ID: <CAGRyCJHqQpOgkbh=DvEL=7LJr0z65L6Oq9-sK7DJBtxu0_=_Ww@mail.gmail.com>
Subject: Re: [PATCH net-next 1/1] net: usb: qmi_wwan: add default rx_urb_size
To:     Kristian Evensen <kristian.evensen@gmail.com>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Paul Gildea <paul.gildea@gmail.com>,
        Carl Yin <carl.yin@quectel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kristian,

Il giorno mer 4 nov 2020 alle ore 18:01 Kristian Evensen
<kristian.evensen@gmail.com> ha scritto:
>
> Hi,
>
> On Wed, Sep 9, 2020 at 11:14 AM Daniele Palmas <dnlplm@gmail.com> wrote:
> >
> > Add default rx_urb_size to support QMAP download data aggregation
> > without needing additional setup steps in userspace.
> >
> > The value chosen is the current highest one seen in available modems.
> >
> > The patch has the side-effect of fixing a babble issue in raw-ip mode
> > reported by multiple users.
> >
> > Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
> > ---
> > Resending with mailing lists added: sorry for the noise.
> >
> > Hi Bj=C3=B8rn and all,
> >
> > this patch tries to address the issue reported in the following threads
> >
> > https://www.spinics.net/lists/netdev/msg635944.html
> > https://www.spinics.net/lists/linux-usb/msg198846.html
> > https://www.spinics.net/lists/linux-usb/msg198025.html
> >
> > so I'm adding the people involved, maybe you can give it a try to
> > double check if this is good for you.
> >
> > On my side, I performed tests with different QC chipsets without
> > experiencing problems.
> >
> > Thanks,
> > Daniele
>
> First of all, I am very sorry for not providing any feedback earlier.
> I applied your patch and have been running it on my devices more or
> less since it was submitted. My devices are equipped with different
> generations of modems (cat. 4, cat. 6, cat. 12, 5G NSA), and I haven't
> noticed any problems and the babble-issue is gone.

thanks for testing. Still thinking it could be better to differentiate
between raw-ip and qmap, but not yet able to find the time to perform
some tests on my own.

> Over the last
> couple of days I also finally had a chance to experiment with QMAP,
> using an SDX55-based modem (i..e,32KB datagram support). Increasing
> the datagram size to 32KB gives a nice performance boost over for
> example 16KB. When measuring using iperf3 (on the same device), the
> throughput goes from around 210 Mbit/s and to 230 Mbit/s. The CPU was
> more or less saturated during all of my experiments, so the main
> performance gain was from the increased aggregated datagram size.
>
> As a side question, and perhaps this should be a separate thread, does
> anyone have any suggestion on how to improve QMI performance further?
> The device that I used for my iperf3-tests is mt7621-based, and using
> for example an Ethernet dongle I am able to reach somere between 400
> and 500 Mbit/s over USB. The Ethernet dongle is able to make use of
> for example scatter-gather, but I would still expect at least a bit
> more using QMI.

Is the dongle driver based on usbnet? Besides the aggregated datagram
size, did you also try different datagram max numbers?

> I tried to replace the alloc()/put() in the
> qmimux_rx_fixup() function with clone() and then doing push()/pull(),
> but this resulted in a decrease in performance. I have probably
> overlooked something, but I think at least my use of the functions was
> correct. The packets looked correct when adding some debug output,
> error counters did not increase, etc., etc. The mobile network is not
> the bottleneck, on my phone I reliably get around 400 Mbit/s.
>

Sorry, I'm not expert enough to give you any good hint.

The only advice I can give you is to check if other drivers are
performing better, e.g. did you try the MBIM composition? not sure it
will make much difference, since it's based on usbnet, but could be
worth trying.

Regards,
Daniele

> BR,
> Kristian
