Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8634D063F
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 19:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244566AbiCGSUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 13:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233567AbiCGSUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 13:20:21 -0500
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0DD8090C
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 10:19:26 -0800 (PST)
Received: by mail-vk1-xa2b.google.com with SMTP id az23so3492654vkb.0
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 10:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=24714d3aBu2pKanmvcHCs8UDo7X0U33odNsdPBGKj88=;
        b=c82zJndtoKTbiudCzsKF7vCxuppEVdVJhiVzuvgKll4m5p07n5a6WBo2XwZSxDQsn9
         UbUN/haty6xtX1PiE8dbbAztPZbc5fwXjWwU5v9vd1WGzslVrd8JLXlFa3dR4rKlHEeo
         YmgUUjXGIZaUxMAnJR9yA1ABk84YOM+Oxv6qEpDhOAU6fVyRXyeDHoQwBKO3KfDQ//At
         w7T/yFqiu5MFKT01dLyAa8djLpu/NddrFPr6UIirtuB/W+t829HWaCvsCAtR+J1hVUnp
         rjAtDYMo3rLeNepe39bw1lCuy6eS2cAHMqmMf8q1n4uC3mUtMahjY3yE8PN1Bx1akDan
         Ro3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=24714d3aBu2pKanmvcHCs8UDo7X0U33odNsdPBGKj88=;
        b=yWovLnuxI8si7t/d8ULdsBdz/dsTYhOY0fFP3f6MZKa+SFFtxUqZ3CrCeE74XLg3n/
         ESnfJ+sfMc1yXpeizhCIF4b7BIharOC/E74WPxIap9BVOTM//6YxxqMrl9dUEvIp8wQ8
         ZIwzFGywVutcxYXU6j074jTnCl8tufpqpgnsKHMLxuyLEAGdDdDgdPRqhW2MXdOp7K5Q
         uvoLI5gtJDsQu5yXu7pq0jiTubqML2wa70doijPqtAFKW3nxfIbSrDh4tRBrVC1HfJ3A
         lADHeGEpq1FsPRd0pg8p/a0lNNFF851cUKqNa8GVH/O14ulCK6jpVQCtrBE9UvvhsChg
         b/fw==
X-Gm-Message-State: AOAM530123jUE9F38FR+ROLbNH4SbGLk5fI8lUzWgeJ91mkRXeI68UW9
        IXijM41TWjF2FcTcZr96WbVicDprw/ou9HqOKhc=
X-Google-Smtp-Source: ABdhPJwAd8y6iypKTT0ivrKz/pEDmCXIWRpVzApLtkMVUMcOkvIg3SHw4VAjGkQne+ViLX7ihtE+Ny0FlMkQwzkX9Pc=
X-Received: by 2002:a1f:5642:0:b0:337:2f57:25c with SMTP id
 k63-20020a1f5642000000b003372f57025cmr2764150vkb.37.1646677165612; Mon, 07
 Mar 2022 10:19:25 -0800 (PST)
MIME-Version: 1.0
References: <462fa134-bc85-a629-b9c5-8c6ea08b751d@gmail.com>
 <4baebbcb95d84823a7f4ecbe18cbbc3c@AcuMS.aculab.com> <7e75125d-c222-46cf-50b3-c80978cbfff2@gmail.com>
 <20220307080834.35660682@hermes.local> <CAExTYs3tTuLqYByki0JtWheVp=r+r9Xo8F=RryxVq8O+4zJVpw@mail.gmail.com>
 <20220307101035.7015201e@hermes.local>
In-Reply-To: <20220307101035.7015201e@hermes.local>
From:   Dimitrios Bouras <dimitrios.bouras@gmail.com>
Date:   Mon, 7 Mar 2022 10:19:14 -0800
Message-ID: <CAExTYs1HqbiC3yr=4Vgw3EYdTiw4ZtUekC_rBTQkUw6idDE0XA@mail.gmail.com>
Subject: Re: [PATCH 1/1] eth: Transparently receive IP over LLC/SNAP
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Laight <David.Laight@aculab.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URI_DOTEDU autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 7, 2022 at 10:10 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon, 7 Mar 2022 09:45:52 -0800
> Dimitrios Bouras <dimitrios.bouras@gmail.com> wrote:
>
> > On Mon, Mar 7, 2022 at 8:08 AM Stephen Hemminger
> > <stephen@networkplumber.org> wrote:
> > >
> > > On Sun, 6 Mar 2022 13:09:03 -0800
> > > Dimitrios Bouras <dimitrios.bouras@gmail.com> wrote:
> > >
> > > > On 2022-03-04 11:02 p.m., David Laight wrote:
> > > > > From: Dimitrios P. Bouras
> > > > >> Sent: 05 March 2022 00:33
> > > > >>
> > > > >> Practical use cases exist where being able to receive Ethernet packets
> > > > >> encapsulated in LLC SNAP is useful, while at the same time encapsulating
> > > > >> replies (transmitting back) in LLC SNAP is not required.
> > > > > I think you need to be more explicit.
> > > > > If received frames have the SNAP header I'd expect transmitted ones
> > > > > to need it as well.
> > > >
> > > > Hi David,
> > > >
> > > > Yes, in the general case, I agree. In the existing implementation of the
> > > > stack,however, (as far as I have researched) there is nothing available to
> > > > process IP over LLC/SNAP for Ethernet interfaces.
> > > >
> > > > In the thread I've quoted in my explanation Alan Cox says so explicitly:
> > > > https://lkml.iu.edu/hypermail/linux/kernel/1107.3/01249.html
> > > >
> > > > Maybe I should change the text to read:
> > > >
> > > >    Practical use cases exist where being able to receive IP packets
> > > >    encapsulated in LLC/SNAP over an Ethernet interface is useful, while
> > > >    at the same time encapsulating replies (transmitting back) in LLC/SNAP
> > > >    is not required.
> > > >
> > > > Would that be better? Maybe I should also change the following sentence:
> > > >
> > > >    Accordingly, this is not an attempt to add full-blown support for IP over
> > > >    LLC/SNAP for Ethernet devices, only a "hack" that "just works".
> > > >
> > > > >> Accordingly, this
> > > > >> is not an attempt to add full-blown support for IP over LLC SNAP, only a
> > > > >> "hack" that "just works" -- see Alan's comment on the the Linux-kernel
> > > > >> list on this subject ("Linux supports LLC/SNAP and various things over it
> > > > >> (IPX/Appletalk DDP etc) but not IP over it, as it's one of those standards
> > > > >> bodies driven bogosities which nobody ever actually deployed" --
> > > > >> http://lkml.iu.edu/hypermail/linux/kernel/1107.3/01249.html).
> > > > > IP over SNAP is needed for Token ring networks (esp. 16M ones) where the
> > > > > mtu is much larger than 1500 bytes.
> > > > >
> > > > > It is all too long ago though, I can't remember whether token ring
> > > > > tends to bit-reverse the MAC address (like FDDI does) which means you
> > > > > can't just bridge ARP packets.
> > > > > So you need a better bridge - and that can add/remove some SNAP headers.
> > > > I've read that some routers are able to do this but it is out of scope for my
> > > > simple patch. The goal is just to be able to receive LLC/SNAP-encapsulated
> > > > IP packets over an Ethernet interface.
> > > >
> > > > >
> > > > > ...
> > > > >
> > > > >     David
> > > > >
> > > > > -
> > > > > Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> > > > > Registration No: 1397386 (Wales)
> > > >
> > > > Additional feedback you may have is greatly appreciated.
> > > >
> > > > Many thanks,
> > > > Dimitri
> > > >
> > >
> > > The Linux device model is to create a layered net device. See vlan, vxlan, etc.
> > > It should be possible to do this with the existing 802 code in Linux, there
> > > is some in psnap.c but don't think there is a way to use this for IP.
> >
> > Hi Stephen,
> >
> > Thank you for taking the time to send feedback. Yes, that is the route
> > I took initially, looking at how to implement this through existing SNAP
> > protocol support. In the end, it was an awful lot of work for a very
> > simple requirement -- in  my mind, small is better.
> >
> > Are there drawbacks to my approach for this very special case that you
> > think are detrimental to the device model? As I understand, encapsulated
> > IP shouldn't be coming through the Ethernet interface. When I was coding
> > and testing this patch I felt it may be justified in the same way as the
> > "magic hack" for raw IPX a bit further down in eth_type_trans().
> >
> > Looking forward to your additional thoughts or guidance,
> > Dimitri
>
> The transparent model assumes everyone wants to let these type of packets in.
> And that everyone wants 802 and Ethernet to appear as one network.
> Most users don't

I fully agree but does this include encapsulated IP over 802.2
LLC/SNAP coming in through the Ethernet interface?

Unless I'm mistaken, this patch does nothing to impede LLC/SNAP
traffic from token-ring or FDDI interfaces.
