Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4AE554E85A
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 19:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbiFPRIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 13:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377915AbiFPRIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 13:08:35 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899CD3EA9B
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 10:08:33 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id a10so2113724ioe.9
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 10:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IGOKynygz2cMk87UjzPghJM9wU79tXlEQtgoCG1Ukp0=;
        b=VPbbJCljkwhPogXLRCv/8uXi25+8J2iRwPTLBQBGw/Myn7MQJEmN7I0QRZ/dziyCp8
         9uWVdqPzDMABnyu6SUMrVCUXRdmCiJzWMV+Vl4h77nWh4RaG8aMMBdLGWpQadiefpaa/
         x/sc3FlnC/A8ce9vVdu7ovtVRaB7jDDCTDzbT8afJ/iAcmRmitaDghXMYV2ToTN+OFfY
         9tDaYxUjUiDDe/eZWrizojh4P9V1nlbyHDXiIFhNzhKApyKrMmTx/UvEU+4z1mQLrrD+
         BsT2ORHm5YTeCJC6LFTePS7lAwtxagKhNJUbMebQERZYw+5AglizQsy894in74Wjb1dQ
         pGTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IGOKynygz2cMk87UjzPghJM9wU79tXlEQtgoCG1Ukp0=;
        b=A4WKCslW2uv4OWJEMtdfeuW87MCT7ce7oyJ/actFh69CaOirxCK+PyEkgj/F0EvKlU
         ncikJO+ozrAOtdfnWS2DQOUpmyc5BJkUc8E5k8+Z3g2EWuWZ1D0AWGUDDjyI2aE78Owo
         N43uUfDeEvq+gGKEK5w3ZpMNlGIHbZCg1rWKCub8nklWLpdWkDx8VfnuRCa0FleBRd6x
         a+rQVcBHJ/NJW0b8lZnFaXIn15iv8BeaXkb5hySmpO3qyhIwxzFvSfFaoSgLTQ4RkeGg
         nPa1V8JDDichZe+RflGv9M4vkv6T9vwklI+eNlOkEGzSc1qp6Uw8nyFBRwF9tCg7wrJH
         4ZqA==
X-Gm-Message-State: AJIora/VvoNzKDKYpHZdXi4T2fBTCqoTiDTMOtNGHdIQZI4kF9bC7oHq
        L1hzJc+JsXdd04XPEfkfY5m2CxtpJzozltDU9ie23d0m4fE=
X-Google-Smtp-Source: AGRyM1sewZqLIDzjCOXH16v3XzPVTL5fAhwtZxuZHyp0fv/fSywYc9E7MzRGCHrS6TFg2Z0THcl0Mmdo+nFP7UoAivM=
X-Received: by 2002:a05:6638:d86:b0:331:fb54:c3e3 with SMTP id
 l6-20020a0566380d8600b00331fb54c3e3mr3271644jaj.198.1655399312765; Thu, 16
 Jun 2022 10:08:32 -0700 (PDT)
MIME-Version: 1.0
References: <1655182915-12897-1-git-send-email-quic_subashab@quicinc.com>
 <1655182915-12897-2-git-send-email-quic_subashab@quicinc.com>
 <20220615173516.29c80c96@kernel.org> <CANP3RGfGcr25cjnrUOdaH1rG9S9uY8uS80USXeycDBhbsX9CZw@mail.gmail.com>
 <132e514e-bad8-9f73-8f08-1bd5ac8aecd4@quicinc.com> <CANP3RGdRD=U7OAwrcdp1XUXFcb5b1zTfoy1fxa8JZUcnxBdsKg@mail.gmail.com>
 <20220616094216.3bc9aef2@kernel.org>
In-Reply-To: <20220616094216.3bc9aef2@kernel.org>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Thu, 16 Jun 2022 10:08:20 -0700
Message-ID: <CANP3RGf=aQ9RqfDUQBb0EELT6z2o2Z5GZa6r+fXkaFsHN12FNA@mail.gmail.com>
Subject: Re: [PATCH net v2 1/2] ipv6: Honor route mtu if it is within limit of
 dev mtu
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Subash Abhinov Kasiviswanathan (KS)" <quic_subashab@quicinc.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Stefano Brivio <sbrivio@redhat.com>,
        Kaustubh Pandey <quic_kapandey@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 9:42 AM Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 16 Jun 2022 00:33:02 -0700 Maciej =C5=BBenczykowski wrote:
> > On Wed, Jun 15, 2022 at 10:36 PM Subash Abhinov Kasiviswanathan (KS) <q=
uic_subashab@quicinc.com> wrote:
> > > >> CC maze, please add him if there is v3
> > > >>
> > > >> I feel like the problem is with the fact that link mtu resets prot=
ocol
> > > >> MTUs. Nothing we can do about that, so why not set link MTU to 9k =
(or
> > > >> whatever other quantification of infinity there is) so you don't h=
ave
> > > >> to touch it as you discover the MTU for v4 and v6?
> > >
> > > That's a good point.
> >
> > Because link mtu affects rx mtu which affects nic buffer allocations.
> > Somewhere in the vicinity of mtu 1500..2048 your packets stop fitting
> > in 2kB of memory and need 4kB (or more)
>
> I was afraid someone would point that out :) Luckily the values Subash
> mentioned were both under 2k, and hope fully the device can do scatter?
> =F0=9F=A4=9E=F0=9F=98=9F (Don't modems do LRO or some other form of aggre=
gation usually?)

You'd be amazed at how ...minimal... these (cellphone modem/wifi) devices a=
re.

I've long given up on expecting these devices to do fundamental things
like scatter gather, or transmit or receive checksum offload.

Sure *some* newer ones are better and can even do TSO or some form of
HWGRO, maybe even some limited multiqueue, but it's rare.

note: > ~3.5kB mtu also breaks (or at least used to???) xdp, because
of that requiring a single page.

Additionally, a severe lack of trust in cell/wifi firmware's ability
to withstand remote compromise (due to inability to audit the source
code), means sometimes the nics even lack DMA access to system ram,
and instead either rx, or both rx and tx are bounce buffered, either
by vritue of driver doing memcpy or some separate hw dma engine.

> > > >> My worry is that the tweaking of the route MTU update heuristic wi=
ll
> > > >> have no end.
> > > >>
> > > >> Stefano, does that makes sense or you think the change is good?
> > >
> > > The only concern is that current behavior causes the initial packets
> > > after interface MTU increase to get dropped as part of PMTUD if the I=
Pv6
> > > PMTU itself didn't increase. I am not sure if that was the intended
> > > behavior as part of the original change. Stefano, could you please co=
nfirm?
> > >
> > > > I vaguely recall that if you don't want device mtu changes to affec=
t
> > > > ipv6 route mtu, then you should set 'mtu lock' on the routes.
> > > > (this meaning of 'lock' for v6 is different than for ipv4, where
> > > > 'lock' means transmit IPv4/TCP with Don't Frag bit unset)
> > >
> > > I assume 'mtu lock' here refers to setting the PMTU on the IPv6 route=
s
> > > statically. The issue with that approach is that router advertisement=
s
> > > can no longer update PMTU once a static route is configured.
> >
> > yeah.   Hmm should RA generated routes use locked mtu too?
> > I think the only reason an RA generated route would have mtu informatio=
n
> > is for it to stick...
>
> If link MTU is lower than RA MTU do we do min() or ignore the RA MTU?

I think we simply ignore it - if link mtu is changed, we'll update the
routes on the next RA we receive (which will presumably have the mtu
information again).
Perhaps link mtu change should result in immediate RS to get an RA soon??

Behaviour for mtu > link mtu heavily depends on the driver.
For RX many drivers will fail to receive packets larger than link mtu
(rx buffer overrun), but often there's some wiggle room - this is due
to how rx buffers are allocated.
ie. 1500 mtu means can receive up to 1536 byte packets...

For tx it again depends on the driver, some reject packets > mtu,
others can actually send arbitrary sized packets (up to some limit
like 64KB or even higher), because tx allocation does not require any
statically sized buffers like receive does.

All this means that ultimately route MTU > link mtu is unlikely to
work no matter what we do - on at least some nics.

Anyway... lots of words to say ignore 'RA MTU > link/device mtu' seems
like the right call,
while if it is <=3D then set it as locked?
