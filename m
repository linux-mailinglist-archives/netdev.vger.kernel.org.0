Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA242700BA
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 17:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgIRPQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 11:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgIRPQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 11:16:22 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC6AC0613CE;
        Fri, 18 Sep 2020 08:16:22 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id o8so5709297otl.4;
        Fri, 18 Sep 2020 08:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kLfqMwgPxviTzNCiwQl8f388aWSkJwZkS8ADVy7dSHA=;
        b=JUhhZrZ8ClAAGd4XR9TYn3kl/E7WKRAwfI5OL5AB/xSd3qggi2Tx27qujGGp47pJNO
         Y2+vyerJMTgn9GpsnKfM1H+v9gXMPZVKwJ9Eh3KbFUUQImqbOSPh+z1sW2z+oYyzoYnG
         lIZbygew9TBDbcncSvh3y4kpJjwII826lLVM6m/RWEg2+hJTVwBdoZFjmd+ZF08hj6nY
         F59enM4UY0fK1fixlTXWAYe6kNl8DC4WRQm44AHMzSqTzPMvvSGDIwSnWhQLfG58gVYu
         bOhLTkDMbJpLsKiu9jIFzWId41Xa5neLcRYvr+HEQqaNpe1UMrc8joue1Ph/vOKpO7fM
         ZTrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kLfqMwgPxviTzNCiwQl8f388aWSkJwZkS8ADVy7dSHA=;
        b=C6gHWo29lV/0dvT6i5u6MBnBaP1+JaDDMQu1LxIXbKbwVJsgN1+j6qZ/8Hu4JiRZ2x
         98s5H61MEErTUwLTSN6TlMJ4RyG6mpyRn7JRztkoSL3OaF0IiiAAn5Jkip+1PEt38lwF
         6WRD5Vz2hNH4ujFg9Ju4mrd7/R37q11Fu5snFE29xWPzFIgqIx3h43EvzGhdapUxIUbS
         i/q83gqcCq5mCSO1CVidP7kvIS4pzeVmXnJmGuFXs0AmpiMmTIRPBVvnPkL72JBFA+Q7
         mvZd/lFXSBf5NRTECcPoUzPrA2/Fd9fE5BJPoKtXJ0lDdZ5YW1L32h45mNndMhPOW11P
         KfcQ==
X-Gm-Message-State: AOAM531KS8IQ3oO9rCDtQmKK9fZiE6MHp2CokPL6VioduAQ5s7cPkhXQ
        vM/6GTu9J8/sMm1LxaEAh8ID5GUKF2dXGVf+E98=
X-Google-Smtp-Source: ABdhPJzIHVCx5ItuGXNYWjAqHaYDyGl3qOYyF76FM45pj9dR+/uMrVm7kdKmNkPtMV8waUFn2jt3z0XslCBsp72ymsA=
X-Received: by 2002:a9d:6d95:: with SMTP id x21mr24174886otp.339.1600442181803;
 Fri, 18 Sep 2020 08:16:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200918121621.GQ8409@ziepe.ca> <CAFCwf12YBaka2w2cnTxyX9L=heMnaM6QN1_oJ7h7DxHDmy2Xng@mail.gmail.com>
 <20200918125014.GR8409@ziepe.ca> <CAFCwf12oK4RXYhgzXiN_YvXvjoW1Fwx1xBzR3Y5E4RLvzn_vhA@mail.gmail.com>
 <20200918132645.GS8409@ziepe.ca> <CAFCwf109t5=GuNvqTqLUCiYbjLC6o2xVoLY5C-SBqbN66f6wxg@mail.gmail.com>
 <20200918135915.GT8409@ziepe.ca> <CAFCwf13rJgb4=as7yW-2ZHvSnUd2NK1GP0UKKjyMfkB3vsnE5w@mail.gmail.com>
 <20200918141909.GU8409@ziepe.ca> <CAFCwf121_UNivhfPfO6uFoHbF+2Odeb1c3+482bOXeOZUsEnug@mail.gmail.com>
 <20200918150735.GV8409@ziepe.ca>
In-Reply-To: <20200918150735.GV8409@ziepe.ca>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Fri, 18 Sep 2020 18:15:52 +0300
Message-ID: <CAFCwf13y1VVy90zAoBPC-Gfj6mwMVbefh3fxKDVneuscp4esqA@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, izur@habana.ai,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 6:07 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Fri, Sep 18, 2020 at 05:45:21PM +0300, Oded Gabbay wrote:
>
> > Any access by the device's engines to the host memory is done via our
> > device's MMU. Our MMU supports multiple ASIDs - Address Space IDs. The
> > kernel driver is assigned ASID 0, while the user is assigned ASID 1.
> > We can support up to 1024 ASIDs, but because we limit the user to have
> > a single application, we only use ASID 0 and 1.
>
> If the QP/WQ/etc is HW bound to an ASID then that binding is called a
> PD and the ASID is acting in the PD role.
>
> If the ASID is translating from on the wire IOVA to DMA PA, then it is
> acting in the MR role as well.
>
> Bundling those two things together is not as flexible as standards
> based RDMA, but it is not as far away as you are making things out to
> be.
>
> Jason

But Jason, why do I need to use RDMA definitions in my common code ?
RDMA is such a small part of our ASIC. We also have an ASIC called
GOYA for inference, which is handled by the same driver, but doesn't
have RDMA ports at all. Why would I need to use RDMA definitions for
that ?

I'm sorry, but you won't be able to convince me here that I need to
"enslave" my entire code to RDMA, just because my ASIC "also" has some
RDMA ports.
On the same weight, the GPU people tried and failed to say that my
device is a GPU. And I think the reasoning that we applied back then,
and Greg and Olof agreed with it, applies here as well.

I want to play along, but it has to be something that won't make my
entire device's driver into an RDMA driver. And it has to be something
that doesn't hurt performance.
All other things can and will be changed according to your inputs.

Thanks,
Oded

Oded
