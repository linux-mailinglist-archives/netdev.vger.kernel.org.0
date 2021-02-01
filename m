Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC69D30A94D
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 15:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbhBAODi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 09:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbhBAODg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 09:03:36 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC084C061756;
        Mon,  1 Feb 2021 06:02:56 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id kx7so10367975pjb.2;
        Mon, 01 Feb 2021 06:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uBdiP9H9SlNL4alzj1It88DmnB+e5Qmtpx4oL95Is3k=;
        b=SXoeBbQT5lJYINofg0/xkVOTIolowtnIDEP9fr2GtQ9A5duj3KLOXGPVbMddAjVfmH
         5ZmlZC48QLqZXb9NQ6SKrrvtRr41J+2L0X1BYERIQ0hM9h7J+VoYH+W04wq9wJlfxRxm
         T8MEeQP3KfzTdTgEBuwFrCdGVZHVTDVbdaFiiSzCQpfjN7pmFXFlHm3s4MVqiSm8Q1QP
         jCPt9JZNwH4Dx73Teh0uihHD+LhCQfVA2HkwWH9y5y4+ewkX/J1tAsMNugSHOaaTfGyP
         1gzTmkLRiK2YlmCvCOZD5vLvdhrt/iJNImrdLu3XJ9//FyGNrVEizVJOfx04oYH9T0l5
         iOhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uBdiP9H9SlNL4alzj1It88DmnB+e5Qmtpx4oL95Is3k=;
        b=QPBf/bUt4Crmq0AV05YsGXPSCg56teOv1IdrIaClV3Qvqi2gfEEUUb3/SmKpTPlivk
         dM22Y2PMl1CL60pwl+FhZrmudDdJ+WVX08OETQXZOaBdKODvh/8d4Y7pPDOUaFMT9Aag
         +JVFI2nopNpCaKYOv4dZdDTWNKy21UftWfSoXAbXvIVx+OR/AxLl48LhnmRS8Qqjg7q4
         POF+JHIo8j9xCkCP8zQ0INMlYu4RqTC4JuBadtw8blEDaJ2oMVaxPvvTLhJFqQMvoInE
         ymZ9tA/MLynfKmxFCUs38HzPQq8YErektfwxy6eczytmuQKx3FSUuaPpbBqYCwasEDzh
         a32g==
X-Gm-Message-State: AOAM5333JBNkeB6wNnXY47oTrdVhuXJ0a3DVq5tcZiyaGNceYvx+ccZu
        EwFFIbiRkFnEiwHH1qBU0sy5ROgUQi5YsLuUm/t7vFQdeeo=
X-Google-Smtp-Source: ABdhPJwQSB62FIthokjS5lj7pFf9ZNQ3B9jY138f68ls9gEsUmUUJlTFIcfvdqA0Im1k7/rEaR1nibA3RF7jmd7agK4=
X-Received: by 2002:a17:90a:ee8a:: with SMTP id i10mr3192755pjz.210.1612188176329;
 Mon, 01 Feb 2021 06:02:56 -0800 (PST)
MIME-Version: 1.0
References: <20210127090747.364951-1-xie.he.0141@gmail.com>
 <20210128114659.2d81a85f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EOSB-m--Ombr6wLMFq4mPy8UTpsBri2CPsaRTU-aks7Uw@mail.gmail.com>
 <3f67b285671aaa4b7903733455a730e1@dev.tdt.de> <20210129173650.7c0b7cda@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EPMtn5E-Y312vPQfH2AwDAi+j1OP4zzpg+AUKf46XE1Yw@mail.gmail.com>
 <20210130111618.335b6945@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EMQVaKFx7Wjj75F2xVBTCdpmho64wP0bfX6RhFnzNXAZA@mail.gmail.com>
 <36a6c0769c57cd6835d32cc0fb95bca6@dev.tdt.de> <CAJht_ENs1Rnf=2iX8M1ufF=StWHKTei3zuKv-xBtkhDsY-xBOA@mail.gmail.com>
 <1628f9442ccf18f9c08c98f122053fc0@dev.tdt.de>
In-Reply-To: <1628f9442ccf18f9c08c98f122053fc0@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 1 Feb 2021 06:02:44 -0800
Message-ID: <CAJht_EOs1HOcRRpVo_RZEQPECVPrKpu5vk0Pe-XmRe4htmEuOw@mail.gmail.com>
Subject: Re: [PATCH net] net: hdlc_x25: Use qdisc to queue outgoing LAPB frames
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 5:14 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> But control frames are currently sent past the lapb write_queue.
> So another queue would have to be created.
>
> And wouldn't it be better to have it in the hdlc_x25 driver, leaving
> LAPB unaffected?

Hmm.. Indeed. I agree.

I also think the queue needs to be the qdisc queue, so that it'll be
able to respond immediately to hardware drivers' netif_wake_queue
call.

Initially I was considering using the qdisc of the HDLC device to
queue the outgoing L2 frames again (after their corresponding L3
packets having already gone through the queue). But Jakub didn't like
the idea of queuing the same data twice. I also found that if an L3
packet was sent through the qdisc without being queued, and LAPB
didn't queue it either, then the emitted L2 frame must be queued in
the qdisc. This is both not optimal and causing problems when using
the "noqueue" qdisc.

Maybe the only way is to create a virtual device on top of the HDLC
device, using the virtual device to queue L3 packets and using the
actual HDLC device to queue L2 frames.
