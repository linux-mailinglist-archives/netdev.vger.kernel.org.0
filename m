Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96EF84D0603
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 19:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238950AbiCGSLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 13:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234219AbiCGSLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 13:11:34 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882F765803
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 10:10:39 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id g1so14784654pfv.1
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 10:10:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0wunyKMWVbqPRClvC3AsHGFPbbjduop+6JQPaVtJgME=;
        b=3Bq8J+Y8TQShDvZoE1wEhsmI+ZKr0L6KMIYcQd4bFy5xJOJ5oBCwl8/n0ssY98NGCj
         6DVtZC5mvvAjB6B99vOn47rDDtSB/yiZt3GYUimav1Vtub6Q4XueFTL+e78Fi1fbMJTA
         0sOLvysbO0fCdpn/UQATOnd6vp7tz0h7IBsS5lv+LmCeb0sjTQaWJ4NSNB64bpahvvZL
         JC43uKCgM1uGRridAlhovhRcqIGXnjhvqHljVmlkhAYXWyK0+WGdcHE4+8n4TXY8Bce1
         c9//SfsOWAQ3IgwtNLz2+5+3MQs+ufKWeowxfeizyeyTwvzQe0NTyF4nXKeBo2CTpjtb
         798A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0wunyKMWVbqPRClvC3AsHGFPbbjduop+6JQPaVtJgME=;
        b=syXzBvtdUTgBJZFSDovsAQtGi09nL0Sis0g/2b5CBe7khRnIlRemlzP9MBS9Ke24eq
         9U9UiOkWPfAjTLK63BjTK1uxKz4Whv+l/BPKnPO5fu4NQRHkiDzclAqrc8Pd4tlHRJ+K
         zoKkbU7S2sEhENP2JDONfB6wPv4ASN5D3rRlWtp9+wWCCoP/4dokPYqADaFef4fEdmY2
         pH42O8SylL8kYR519fbxq6poQaPo5CfQDeacBZAOdrI+m/tjyAq3lhcZgqaXryQipAcn
         M6H00Zx1gDjAeWkLfA0ss7bY5iXGUfI0nofNgW9hnrefNcQatBmrP/vAuLZoAkMI8w3x
         aNfQ==
X-Gm-Message-State: AOAM5325lUTd4roksqbq9VemeZYLTbCYxeSqzOvkRM3iwmLnXZ2efOaA
        VZsuZjr//kulA/UJYDpSHnFtxvegrz+IQA==
X-Google-Smtp-Source: ABdhPJzNOpg5s03/+cDDZcjP1hFdMT9R/cyN4NMdwW830ocQIC+xMad39qB82wvxuKhP+TMwgs5lnA==
X-Received: by 2002:aa7:82d0:0:b0:4f6:72c7:ff61 with SMTP id f16-20020aa782d0000000b004f672c7ff61mr13906511pfn.46.1646676638947;
        Mon, 07 Mar 2022 10:10:38 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id q2-20020a056a00084200b004f0fea7d3c8sm17090485pfk.26.2022.03.07.10.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 10:10:38 -0800 (PST)
Date:   Mon, 7 Mar 2022 10:10:35 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Dimitrios Bouras <dimitrios.bouras@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] eth: Transparently receive IP over LLC/SNAP
Message-ID: <20220307101035.7015201e@hermes.local>
In-Reply-To: <CAExTYs3tTuLqYByki0JtWheVp=r+r9Xo8F=RryxVq8O+4zJVpw@mail.gmail.com>
References: <462fa134-bc85-a629-b9c5-8c6ea08b751d@gmail.com>
        <4baebbcb95d84823a7f4ecbe18cbbc3c@AcuMS.aculab.com>
        <7e75125d-c222-46cf-50b3-c80978cbfff2@gmail.com>
        <20220307080834.35660682@hermes.local>
        <CAExTYs3tTuLqYByki0JtWheVp=r+r9Xo8F=RryxVq8O+4zJVpw@mail.gmail.com>
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

On Mon, 7 Mar 2022 09:45:52 -0800
Dimitrios Bouras <dimitrios.bouras@gmail.com> wrote:

> On Mon, Mar 7, 2022 at 8:08 AM Stephen Hemminger
> <stephen@networkplumber.org> wrote:
> >
> > On Sun, 6 Mar 2022 13:09:03 -0800
> > Dimitrios Bouras <dimitrios.bouras@gmail.com> wrote:
> >  
> > > On 2022-03-04 11:02 p.m., David Laight wrote:  
> > > > From: Dimitrios P. Bouras  
> > > >> Sent: 05 March 2022 00:33
> > > >>
> > > >> Practical use cases exist where being able to receive Ethernet packets
> > > >> encapsulated in LLC SNAP is useful, while at the same time encapsulating
> > > >> replies (transmitting back) in LLC SNAP is not required.  
> > > > I think you need to be more explicit.
> > > > If received frames have the SNAP header I'd expect transmitted ones
> > > > to need it as well.  
> > >
> > > Hi David,
> > >
> > > Yes, in the general case, I agree. In the existing implementation of the
> > > stack,however, (as far as I have researched) there is nothing available to
> > > process IP over LLC/SNAP for Ethernet interfaces.
> > >
> > > In the thread I've quoted in my explanation Alan Cox says so explicitly:
> > > https://lkml.iu.edu/hypermail/linux/kernel/1107.3/01249.html
> > >
> > > Maybe I should change the text to read:
> > >
> > >    Practical use cases exist where being able to receive IP packets
> > >    encapsulated in LLC/SNAP over an Ethernet interface is useful, while
> > >    at the same time encapsulating replies (transmitting back) in LLC/SNAP
> > >    is not required.
> > >
> > > Would that be better? Maybe I should also change the following sentence:
> > >
> > >    Accordingly, this is not an attempt to add full-blown support for IP over
> > >    LLC/SNAP for Ethernet devices, only a "hack" that "just works".
> > >  
> > > >> Accordingly, this
> > > >> is not an attempt to add full-blown support for IP over LLC SNAP, only a
> > > >> "hack" that "just works" -- see Alan's comment on the the Linux-kernel
> > > >> list on this subject ("Linux supports LLC/SNAP and various things over it
> > > >> (IPX/Appletalk DDP etc) but not IP over it, as it's one of those standards
> > > >> bodies driven bogosities which nobody ever actually deployed" --
> > > >> http://lkml.iu.edu/hypermail/linux/kernel/1107.3/01249.html).  
> > > > IP over SNAP is needed for Token ring networks (esp. 16M ones) where the
> > > > mtu is much larger than 1500 bytes.
> > > >
> > > > It is all too long ago though, I can't remember whether token ring
> > > > tends to bit-reverse the MAC address (like FDDI does) which means you
> > > > can't just bridge ARP packets.
> > > > So you need a better bridge - and that can add/remove some SNAP headers.  
> > > I've read that some routers are able to do this but it is out of scope for my
> > > simple patch. The goal is just to be able to receive LLC/SNAP-encapsulated
> > > IP packets over an Ethernet interface.
> > >  
> > > >
> > > > ...
> > > >
> > > >     David
> > > >
> > > > -
> > > > Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> > > > Registration No: 1397386 (Wales)  
> > >
> > > Additional feedback you may have is greatly appreciated.
> > >
> > > Many thanks,
> > > Dimitri
> > >  
> >
> > The Linux device model is to create a layered net device. See vlan, vxlan, etc.
> > It should be possible to do this with the existing 802 code in Linux, there
> > is some in psnap.c but don't think there is a way to use this for IP.  
> 
> Hi Stephen,
> 
> Thank you for taking the time to send feedback. Yes, that is the route
> I took initially, looking at how to implement this through existing SNAP
> protocol support. In the end, it was an awful lot of work for a very
> simple requirement -- in  my mind, small is better.
> 
> Are there drawbacks to my approach for this very special case that you
> think are detrimental to the device model? As I understand, encapsulated
> IP shouldn't be coming through the Ethernet interface. When I was coding
> and testing this patch I felt it may be justified in the same way as the
> "magic hack" for raw IPX a bit further down in eth_type_trans().
> 
> Looking forward to your additional thoughts or guidance,
> Dimitri

The transparent model assumes everyone wants to let these type of packets in.
And that everyone wants 802 and Ethernet to appear as one network.
Most users don't
