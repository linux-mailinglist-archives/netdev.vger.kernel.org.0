Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1CBD11DB3F
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 01:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731350AbfLMAr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 19:47:56 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:36655 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731026AbfLMArz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 19:47:55 -0500
Received: by mail-pj1-f68.google.com with SMTP id n96so415198pjc.3
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 16:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=/srjZamlK0XdjV6gngN9qkrUYf2VoDzqjSrtkd9BtCk=;
        b=Hd7QYr/mTZh0/hcO2hIy2NNQ6aTo0senYGetU0aVA2edRh0EoaVE8dvBwhsQX3LUxg
         eTL01a27R4AZPIqd4vHNOmfYZspqoXR45WYQV7+K23+e1n7nWJdsEAkZbW0qRg+Df9Ln
         MMZ02BL3tYhJEM5vMKXEf9Y2Ma15dBp4vU20aqqegH8wGBWSylGht2PV300Kbt4TIM9w
         9DWLDT4c7dajGovIvKK0Cl7vQgGjaOg91xXW46IMfj4k3GUOKkMFC/GojSNX/16jlkiG
         luTsMknn4d2jHRUDZxfjkCLMuwG5gN08bQh9r/YMaTXxYwWTyLdqpZ/Tan6A+WAvwbLH
         FnEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/srjZamlK0XdjV6gngN9qkrUYf2VoDzqjSrtkd9BtCk=;
        b=bzs74ARQ0NDECI3p/YiM0AO05ONiTNO0XvRAQkwEgcm81h09DtiQtxCGokb+sVo/KH
         h7FzxRuD77lqHrKRIEdWxr+oGMtNWCVE9Hj7FJSFQYyK0NX8Y7erRj7aU/D2EcTcmsTD
         5WjcTod1svFQ8mfocLKtFVJbKn8iILV2LaDJv7qC2c1S0At1iF2H1Dka440dyT5R2IMd
         1XtJ66MLi3gaFmK/CFn4Q6clJ+vG88PscqBjg89dZYHSMbPgQj6ceZjzKpypVx+Z++ra
         mNDMHqxhFuAtvbg0PXfkYSHzLedv5VELP9Z1FYvWiW6Ujm2qGdJCO17hZsBe/1J9MjRQ
         jRSw==
X-Gm-Message-State: APjAAAWL4qmbm2LHlSbVXXOsXqUnWjVJ1wNUjcHryN8GGL7WPCwrA3cD
        U5TfCO6RooB8n/Mpx2hyfmbFMA==
X-Google-Smtp-Source: APXvYqxKyxm/ZSddvXwXmsGN7FXwGfLCZBI+f/+8WTd2PIyNqjhsYMAk9qeohsAbPZ7iTAWZuKqlbQ==
X-Received: by 2002:a17:90a:fa95:: with SMTP id cu21mr13643010pjb.129.1576198074840;
        Thu, 12 Dec 2019 16:47:54 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i127sm8688757pfc.55.2019.12.12.16.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 16:47:54 -0800 (PST)
Date:   Thu, 12 Dec 2019 16:47:49 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Lorenzo Colitti <lorenzo@google.com>
Cc:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <zenczykowski@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux SCTP <linux-sctp@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: [PATCH v2] net: introduce ip_local_unbindable_ports sysctl
Message-ID: <20191212164749.4e4c8a4c@cakuba.netronome.com>
In-Reply-To: <CAKD1Yr05=sRDTefSP6bmb-VvvDLe9=xUtAF0q3+rn8=U9UjPcA@mail.gmail.com>
References: <CAHo-OowKQPQj9UhjCND5SmTOergBXMHtEctJA_T0SKLO5yebSg@mail.gmail.com>
        <20191209224530.156283-1-zenczykowski@gmail.com>
        <20191209154216.7e19e0c0@cakuba.netronome.com>
        <CANP3RGe8zqa2V-PBjvACAJa2Hrd8z7BXUkks0KCrAtyeDjbsYw@mail.gmail.com>
        <20191209161835.7c455fc0@cakuba.netronome.com>
        <CAHo-OowHek4i9Pzxn96u8U5sTH8keQmi-yMCY-OBS7CE74OGNQ@mail.gmail.com>
        <20191210093111.7f1ad05d@cakuba.netronome.com>
        <CAKD1Yr05=sRDTefSP6bmb-VvvDLe9=xUtAF0q3+rn8=U9UjPcA@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 09:16:03 +0900, Lorenzo Colitti wrote:
> On Wed, Dec 11, 2019 at 2:31 AM Jakub Kicinski wrote:
> > I don't consider users of non-vanilla kernels to necessarily be a
> > reason to merge patches upstream, no. They carry literally millions
> > of lines of patches out of tree, let them carry this patch, too.
> > If I can't boot a vanilla kernel on those devices, and clearly there is
> > no intent by the device manufacturers for me to ever will, why would I
> > care?  
> 
> That's *not* the intent.
> https://arstechnica.com/gadgets/2019/11/google-outlines-plans-for-mainline-linux-kernel-support-in-android/
> 
> > > The reason Android runs non-vanilla kernels is *because* patches like
> > > this - that make Linux work in the real world - are missing from
> > > vanilla Linux  
> 
> That's exactly the point here. Saying, "Android will never use
> mainline, so why should mainline take their patches" is a
> self-fulfilling prophecy. Obviously, if mainline never takes Android
> patches, then yes, Android will never be able to use mainline. We do
> have an Android tree we can take this patch into. But we don't want to
> take it without at least attempting to get it into mainline first.
> 
> The use case here is pretty simple. There are many CPUs in a mobile
> phone. The baseband processor ("modem") implements much of the
> functionality required by cellular networks, so if you want cellular
> voice or data, it needs to be able to talk to the network. For many
> reasons (architectural, power conservation, security), the modem needs
> to be able to talk directly to the cellular network. This includes,
> for example, SIP/RTP media streams that go directly to the audio
> hardware, IKE traffic that is sent directly by the modem because only
> the modem has the keys, etc. Normally this happens directly on the
> cellular interface and Linux/Android is unaware of it. But, when using
> wifi calling (which is an IPsec tunnel over wifi to an endpoint inside
> the cellular network), the device only has one IPv4 address, and the
> baseband processor and the application processor (the CPU that runs
> Linux/Android) have to share it. This means that some ports have to be
> reserved so that the baseband processor can depend on using them. NAT
> cannot be used because the 3GPP standards require protocols that are
> not very NAT-friendly, and because the modem needs to be able to
> accept unsolicited inbound traffic.
> 
> Other than "commit message doesn't have a use case", are there
> technical concerns with this patch?

Maybe a minor question or two, but the main complaint is the commit
message.

How are the ports which get reserved communicated between the baseband
and the AP? Is this part of the standard? Is the driver that talks to
the base band in the user space and it knows which ports to reserve
statically? Or does the modem dynamically request ports to
reserve/inform the host of ports in use?

Should the sysfs interface make sure there are not existing sockets
using requested ports which would stop working? If we may need it one
day better add it now..
