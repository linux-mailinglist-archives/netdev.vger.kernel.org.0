Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473104D03B4
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 17:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239868AbiCGQJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 11:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbiCGQJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 11:09:32 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC54F2A705
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 08:08:37 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id s42so1644941pfg.0
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 08:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7Uz9XDqC3wlZnM1xsb7Ov/0PI5nnW2F3q+cD6y0nUOs=;
        b=TQSu8TTzQbf3TR91H78/HwJSroo/CCAMLRrnUXI7RGQlgYjlb27Pq0y4jJqHkdPXKt
         sLu/P/IkYC2DdSTjj2jUANuLcbTWl1CL7eqg8nLbrVhc1SzuFOa/RRKq91665Vdwq1hZ
         hofl3PvHwLno6aMaHdwS42Be6CncvpGBYBe2KSOxcRHCyJ+2AcEUiaoRay4umX0Kyvex
         uUm3XEcWDGa8I9/MsgOp0w+xGh4MuXrWqI+8swktQdFkuGPLu35YAMpuqukolC5vswwc
         Q/0UHwGonDT8obQk69wQ5TBeOkqmT5UU0wMaTQPeQc8IYgTBcCSCcnHWptdfI25VvIE5
         URUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7Uz9XDqC3wlZnM1xsb7Ov/0PI5nnW2F3q+cD6y0nUOs=;
        b=fXzPzso0AcodBWObLcrZA8bdhfijNViXUqAWtCvUPX5ukuGwx2BoE6r3sdEdeX6YGS
         YysuXYoQU6EgHR4kcKVlo385FW7Xa0bUouUcZL5tm3c82+EcHTcjP4/Ai9y4QqCY38Fa
         eX36bpAhI97KodefskaKlqHuXKm9RUxsCT/vkUKbAPgYpiXweCTjbee5Ck7b68p33f9G
         V/XHLDPBuHK7kPxFF09BnYenO6z91pxAODgCDMCOL179pf7s7nxh26SZpAyafxicZPSR
         S23vz/6SfPoanz1qthvLF6uScbM8HdqCq9XEv2ceM9XKe3Q9I+tjJS0yAIKzv10gYiiL
         K+0Q==
X-Gm-Message-State: AOAM531h1pWRecNS+SJH0U/COFLVs3ZtgQSpp8P/w8YarDkqLYjF1yVF
        wght5j1c2NEqHwYh4MOSBvXEEQ==
X-Google-Smtp-Source: ABdhPJxvWVzrf8JmeGrjLMRh9YyicRb+c+trzp3uyc9C+hNTewRnWSsmcXC6fzQpCdbbUNWAikFy1w==
X-Received: by 2002:a05:6a00:1912:b0:4f6:bf89:e157 with SMTP id y18-20020a056a00191200b004f6bf89e157mr13218473pfi.20.1646669317263;
        Mon, 07 Mar 2022 08:08:37 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id e21-20020a635455000000b00372badd9063sm12287155pgm.11.2022.03.07.08.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 08:08:36 -0800 (PST)
Date:   Mon, 7 Mar 2022 08:08:34 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Dimitrios Bouras <dimitrios.bouras@gmail.com>
Cc:     David Laight <David.Laight@ACULAB.COM>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] eth: Transparently receive IP over LLC/SNAP
Message-ID: <20220307080834.35660682@hermes.local>
In-Reply-To: <7e75125d-c222-46cf-50b3-c80978cbfff2@gmail.com>
References: <462fa134-bc85-a629-b9c5-8c6ea08b751d@gmail.com>
        <4baebbcb95d84823a7f4ecbe18cbbc3c@AcuMS.aculab.com>
        <7e75125d-c222-46cf-50b3-c80978cbfff2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URI_DOTEDU autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 6 Mar 2022 13:09:03 -0800
Dimitrios Bouras <dimitrios.bouras@gmail.com> wrote:

> On 2022-03-04 11:02 p.m., David Laight wrote:
> > From: Dimitrios P. Bouras  
> >> Sent: 05 March 2022 00:33
> >>
> >> Practical use cases exist where being able to receive Ethernet packets
> >> encapsulated in LLC SNAP is useful, while at the same time encapsulating
> >> replies (transmitting back) in LLC SNAP is not required.  
> > I think you need to be more explicit.
> > If received frames have the SNAP header I'd expect transmitted ones
> > to need it as well.  
> 
> Hi David,
> 
> Yes, in the general case, I agree. In the existing implementation of the
> stack,however, (as far as I have researched) there is nothing available to
> process IP over LLC/SNAP for Ethernet interfaces.
> 
> In the thread I've quoted in my explanation Alan Cox says so explicitly:
> https://lkml.iu.edu/hypermail/linux/kernel/1107.3/01249.html
> 
> Maybe I should change the text to read:
> 
>    Practical use cases exist where being able to receive IP packets
>    encapsulated in LLC/SNAP over an Ethernet interface is useful, while
>    at the same time encapsulating replies (transmitting back) in LLC/SNAP
>    is not required.
> 
> Would that be better? Maybe I should also change the following sentence:
> 
>    Accordingly, this is not an attempt to add full-blown support for IP over
>    LLC/SNAP for Ethernet devices, only a "hack" that "just works".
> 
> >> Accordingly, this
> >> is not an attempt to add full-blown support for IP over LLC SNAP, only a
> >> "hack" that "just works" -- see Alan's comment on the the Linux-kernel
> >> list on this subject ("Linux supports LLC/SNAP and various things over it
> >> (IPX/Appletalk DDP etc) but not IP over it, as it's one of those standards
> >> bodies driven bogosities which nobody ever actually deployed" --
> >> http://lkml.iu.edu/hypermail/linux/kernel/1107.3/01249.html).  
> > IP over SNAP is needed for Token ring networks (esp. 16M ones) where the
> > mtu is much larger than 1500 bytes.
> >
> > It is all too long ago though, I can't remember whether token ring
> > tends to bit-reverse the MAC address (like FDDI does) which means you
> > can't just bridge ARP packets.
> > So you need a better bridge - and that can add/remove some SNAP headers.  
> I've read that some routers are able to do this but it is out of scope for my
> simple patch. The goal is just to be able to receive LLC/SNAP-encapsulated
> IP packets over an Ethernet interface.
> 
> >
> > ...
> >
> > 	David
> >
> > -
> > Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> > Registration No: 1397386 (Wales)  
> 
> Additional feedback you may have is greatly appreciated.
> 
> Many thanks,
> Dimitri
> 

The Linux device model is to create a layered net device. See vlan, vxlan, etc.
It should be possible to do this with the existing 802 code in Linux, there
is some in psnap.c but don't think there is a way to use this for IP.
