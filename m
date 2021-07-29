Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD5E3D9DD0
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 08:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbhG2GrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 02:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbhG2GrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 02:47:23 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F973C061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 23:47:20 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id y4so4784903ilp.0
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 23:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eao//OsP6cSr6GKd8L7vo+eJ14NpICiKg2DYYKkeyGY=;
        b=YM+lxX2iK/At5v+fSELdaUWzHdInnJ5z+rczTJVW2CWlcNuU1ZV/8MGqc+Xsy8fOBf
         BWUVzyzoidByT5q49kJOwjMsHvSH8WFO9wUspDFvznQ2PsvcFgCkf1RDSaeFTwC2z4VU
         +rYFYvfZjeY49EUDzpBL6i7g4Lne+Ubql8s6Voed0ooRvwK/i4Xx7OxqGrBO5fveJjfm
         K7o+85RwT6FOTCkf5vUl2KfK38ADJcMG6mFSAB+fI2Y4BNPOtMqkelWsBcRj75hsyN82
         BlnaaRmwwCIFlUUw9NUzT6eo8V9J4GP++E6/Wyn6hxi6fU47oJHCPjCThHc26jh5bRaQ
         KAAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eao//OsP6cSr6GKd8L7vo+eJ14NpICiKg2DYYKkeyGY=;
        b=gLsE64Wf0sW/YCxtrBI0iNsUdnbjilglUXaj9/awCPp5rrGgs9obFH9VufmVBp9u8t
         JwCPqFY3UvztRBwyD8P/89/YEEjMcN5uF849yM1H+8Xds+7ZxNa9a3FI1EtYOFzUk+gE
         IM44nCZ/jGsEx4RSiObn03VJvX9H3ahQMLsvyCBL3TLB9DoLQsfvUUj3OolPF0JPxoYl
         g+VA9zGNZmByxluS7wwocjDb8QupkRZvNrlD7T0IX9C6hV22JAdbasBz42agjCvVACeV
         h+gBXbdUbh/vhXsLlFrH8JcmE0jLmBpu7O+2tfvhvQ2GmBd8Il8bqwRP0+L9K9V3n9lk
         CPvA==
X-Gm-Message-State: AOAM533zNy2ouLcvBUEf6wJsPYRV7bInm6MAXgU98aGFrmvIqxJI2sGW
        FOa1evQ5gjCBUAnGHzZF3xuY+yvBh80Tkd+nmrPW2w==
X-Google-Smtp-Source: ABdhPJyqZyzu4Y3EVzk9nBehU7aUQd6Z1swoutv1tb4BKQZh2SMDR7OUdYIJrMje2q98r5i6Wf9Gu6JOPR2Zp+2a4ZI=
X-Received: by 2002:a92:9412:: with SMTP id c18mr1848147ili.38.1627541239754;
 Wed, 28 Jul 2021 23:47:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210726194603.14671-1-gerhard@engleder-embedded.com>
 <20210726194603.14671-6-gerhard@engleder-embedded.com> <CAL_JsqJC19OsTCa6T98m8bOJ3Z4jUbaVO13MwZFK78XPSpoWBg@mail.gmail.com>
 <CANr-f5yW4sob_fgxhEafHME71QML8K-+Ka5AzNm5p3A0Ktv02Q@mail.gmail.com>
 <CAL_JsqK9OvwicCbckvpk4CMWbhcP8yDBXAW_7CmLzR__-fJf0Q@mail.gmail.com>
 <CANr-f5zWdFAYAteE7tX5qTvT4XMZ+kxaHy03=BnRxFbQLt3pUg@mail.gmail.com>
 <43958f2b-6756-056a-b2fa-cb8f6d84f603@xilinx.com> <CANr-f5xu=xHn7CGve3=Msd8CEcoDujQzSYSNQ2Zbh7NOvyXFYA@mail.gmail.com>
 <839bdf26-6aef-7e05-94b9-78c0d2061bf9@xilinx.com> <CANr-f5xJbTYa-jPzVMPcAV2Un+POBn24gd+604rzPt36RkRcDQ@mail.gmail.com>
 <d763d777-f258-7390-a85a-6cae098102eb@xilinx.com>
In-Reply-To: <d763d777-f258-7390-a85a-6cae098102eb@xilinx.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Thu, 29 Jul 2021 08:47:08 +0200
Message-ID: <CANr-f5yuZ0t782fX_6w3ksKXVdObGWxFHA9Lg+tUQwrXkUh2ng@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] arm64: dts: zynqmp: Add ZCU104 based TSN endpoint
To:     Michal Simek <michal.simek@xilinx.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 7:22 AM Michal Simek <michal.simek@xilinx.com> wrot=
e:
> On 7/28/21 10:51 PM, Gerhard Engleder wrote:
> > On Wed, Jul 28, 2021 at 12:59 PM Michal Simek <michal.simek@xilinx.com>=
 wrote:
> >>>> In past we said that we won't be accepting any FPGA description in
> >>>> u-boot/linux projects. I don't think anything has changed from that =
time
> >>>> and I don't want to end up in situation that we will have a lot of
> >>>> configurations which none else can try and use.
> >> You have to share to customers bitstream. Likely also boot.bin with
> >> PS/PL configuration and other files in it. That's why it will be quite
> >> simple to also share them full DT or DT overlay just for your IP in th=
e
> >> same image.
> >
> > That's possible of course.
> >
> >> Till now I didn't hear any strong argument why this should be accepted=
.
> >
> > I want to try a new argument:
> >
> > For new bindings a schema is used. The goal is to ensure that the bindi=
ng
> > schema and the driver fit together. The validation chain is the followi=
ng:
> > 1) The binding schema is used to validate the device tree.
> > 2) The device tree is used to "validate" the driver by booting.
> >
> > So the kernel tree needs to contain a device tree which uses the bindin=
g
> > to build up the complete validation chain. The validation of the driver=
 against
> > the binding is not possible without a device tree. The only option woul=
d be
> > to compare driver and binding manually, which is error prone.
> >
> > If device trees with FPGA descriptions are not allowed in the kernel tr=
ee, then
> > the kernel tree will never contain complete validation chains f=C3=BCr =
FPGA based
> > IPs. The validation of bindings for FPGA based IPs has to rely on devic=
e trees
> > which are maintained out of tree. It is possible/likely that schema
> > validation is
> > not done out of tree. As a result it is more likely that binding and
> > driver do not
> > fit together for FPGA based IPs. In the end the quality of the support =
for FPGA
> > based IPs would suffer.
> >
> > I suggest allowing a single device tree with FPGA descriptions for a bi=
nding
> > of FPGA based IPs. This will build up the complete validation chain in =
the
> > kernel tree and ensures that binding and driver fit together. This sing=
le device
> > tree would form the reference platform for the FPGA based IP.
>
> This is good theory but the only person who can do this validation is
> you or your customer who is interested in TSN. I am doing this for quite
> a long time and even people are giving me commitments that they will
> support the whole custom board but they stop to do at some point and
> then silently disappear. Then it is up to me to deal with this and I
> really don't want to do it.
> When your driver is merged you should start to do regression testing
> against linux-next, rc versions. When you convince me that you are
> regularly doing this for 2 years or so we can restart this discussion.
>
> Till that time you can simply keep rebasing one patch with your DT on
> the top which is quite easy to do and you get all
> functionality/advantages you are asking about above.

Ok, I give up.

Gerhard
