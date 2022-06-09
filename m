Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D45A254412B
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 03:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbiFIBnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 21:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236225AbiFIBnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 21:43:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 40D40108D
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 18:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654738987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1dvEi1xXo82CL7hwtSfF7Z30+HGNf2y1cik0vi+hWTw=;
        b=IVnKhi4Bm3gMyp4mS9jp0JLWYnFV1XjUE5YlFBriU3RIsJlVq906UudKurdzqdOhB4sHlW
        tQFpbPnLqr/CbIQp7P6P+7a2eLH4AjN08AATqABnBCWpPi0OMkjZU/OKOhszL2gKOBXcr7
        ZsQ6wEG9P+w4tyQXrMm7ThfdMsP4mVQ=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-6YqwRKOaMY-s37TvwW4Wkg-1; Wed, 08 Jun 2022 21:43:06 -0400
X-MC-Unique: 6YqwRKOaMY-s37TvwW4Wkg-1
Received: by mail-qk1-f199.google.com with SMTP id bm2-20020a05620a198200b006a5dac37fa2so18019975qkb.16
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 18:43:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1dvEi1xXo82CL7hwtSfF7Z30+HGNf2y1cik0vi+hWTw=;
        b=PChkmBHjOyNQXxD8KIPCzRmJMG+C/uei8HrTt8bHo4PtYE/o3i+e6IX9htvcR7kPfv
         2jv255DrNoV2GjSVGF2taRO5Svf3UWBdbU8mSCO+nJClofAbwpFknWMQlxq6BEPV2YIB
         xdcIPy9WHiBgl0b1II2l+bxrr1ZDylKuPAZ7D9bVaXEoIy3gaE1+b5x+sRZYIpCYe0hO
         6IxqX8bQiWPfMcVcuilvxxHR6TY2H6nnC+8kHdJe8qw0tx4L7MH6G0faJLhvL1znoX42
         vy9uP5E2mAVyjZSF2MotEnXoQIUz9xPubOMO2eBQ2Kr1vKEMBY8P+9gofP4W2gRDfqW/
         0c5g==
X-Gm-Message-State: AOAM532aSeAb9seKovvfV+n8poVThrMQVpW7OH2np0sdjHjZcaxfgtD2
        F2Rj2i+wthEq70J0rNygy3bQj+pGyGbFazcoB2bRtSv0kEhqxfN0URo/WJxq5bVRjDBAXZdnz0O
        4sMFl6038IVGxR4UAspBwG6yP15KIawMU
X-Received: by 2002:ac8:5dd2:0:b0:304:ea09:4688 with SMTP id e18-20020ac85dd2000000b00304ea094688mr17683601qtx.526.1654738985748;
        Wed, 08 Jun 2022 18:43:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyu+Ct2PcI1RwIxz+4L8eSdpM/nuxsCc+vTtqj/b/dNfmwtu+Jp9cosfwtX+uByaPfsrqONsZCqjjCP5nuNGZo=
X-Received: by 2002:ac8:5dd2:0:b0:304:ea09:4688 with SMTP id
 e18-20020ac85dd2000000b00304ea094688mr17683586qtx.526.1654738985473; Wed, 08
 Jun 2022 18:43:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220603182143.692576-1-miquel.raynal@bootlin.com>
 <20220603182143.692576-2-miquel.raynal@bootlin.com> <CAK-6q+hAZMqsN=S9uWAm4rTN+uZwz7_L42=emPHz7+MvfW6ZpQ@mail.gmail.com>
 <20220606174319.0924f80d@xps-13> <CAK-6q+itswJrmy-AhZ5DpnHH0UsfAeTPQTmX8WfG8=PteumVLg@mail.gmail.com>
 <20220607181608.609429cb@xps-13>
In-Reply-To: <20220607181608.609429cb@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Wed, 8 Jun 2022 21:42:54 -0400
Message-ID: <CAK-6q+gf2_aVt4m7z77aLH+Rkc_sRTEjoykk5Dn+04wbu5n7Xg@mail.gmail.com>
Subject: Re: [PATCH wpan-next 1/6] net: ieee802154: Drop coordinator interface type
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Jun 7, 2022 at 12:16 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alex,
>
> aahringo@redhat.com wrote on Mon, 6 Jun 2022 23:04:06 -0400:
>
> > Hi,
> >
> > On Mon, Jun 6, 2022 at 11:43 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > Hi Alexander,
> > >
> > > aahringo@redhat.com wrote on Fri, 3 Jun 2022 22:01:38 -0400:
> > >
> > > > Hi,
> > > >
> > > > On Fri, Jun 3, 2022 at 2:34 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > >
> > > > > The current enum is wrong. A device can either be an RFD, an RFD-RX, an
> > > > > RFD-TX or an FFD. If it is an FFD, it can also be a coordinator. While
> > > > > defining a node type might make sense from a strict software point of
> > > > > view, opposing node and coordinator seems meaningless in the ieee
> > > > > 802.15.4 world. As this enumeration is not used anywhere, let's just
> > > > > drop it. We will in a second time add a new "node type" enumeration
> > > > > which apply only to nodes, and does differentiates the type of devices
> > > > > mentioned above.
> > > > >
> > > >
> > > > First you cannot say if this is not used anywhere else.
> > >
> > > Mmmh, that's tricky, I really don't see how that might be a
> > > problem because there is literally nowhere in the kernel that uses this
> > > type, besides ieee802154_setup_sdata() which would just BUG() if this
> > > type was to be used. So I assumed it was safe to be removed.
> > >
> >
> > this header is somehow half uapi where we copy it into some other
> > software e.g. wpan-tools as you noticed.
> >
> > > > Second I have
> > > > a different opinion here that you cannot just "switch" the role from
> > > > RFD, FFD, whatever.
> > >
> > > I agree with this, and that's why I don't understand this enum.
> > >
> > > A device can either be a NODE (an active device) or a MONITOR (a
> > > passive device) at a time. We can certainly switch from one to
> > > another at run time.
> > >
> > > A NODE can be either an RFD or an FFD. That is a static property which
> > > cannot change.
> > >
> > > However being a coordinator is just an additional property of a NODE
> > > which is of type FFD, and this can change over time.
> > >
> > > So I don't get what having a coordinator interface would bring. What
> > > was the idea behind its introduction then?
> > >
> >
> > There exists arguments which I have in my mind right now:
> >
> > 1. frame parsing/address filter (which is somehow missing in your patches)
> >
> > The parsing of frames is different from other types (just as monitor
> > interfaces). You will notice that setting up the address filter will
> > require a parameter if coordinator or not.
>
> I think this is something that I completely missed until now, can you
> point me to where/how this is expected to be done? I don't see anything
> wpan specific filtering implementation. What is expected on this area
> and is there code that I missed already?
>

https://elixir.bootlin.com/linux/v5.19-rc1/source/net/mac802154/rx.c#L284

> > Changing the address
> > filterung during runtime of an interface is somehow _not_ supported.
> > The reason is that the datasheets tell you to first set up an address
> > filter and then switch into receiving mode. Changing the address
> > filter during receive mode (start()/stop()) is not a specified
> > behaviour. Due to bus communication it also cannot be done atomically.
> > This might be avoidable but is a pain to synchronize if you really
> > depend on hw address filtering which we might do in future. It should
> > end in a different receiving path e.g. node_rx/monitor_rx.
>
> Got it.
>

I had some thoughts about this as well when going to promiscuous mode
while in "receiving mode"... this is "normally" not supported...

> >
> > 2. HardMAC transceivers
> >
> > The add_interface() callback will be directly forwarded to the driver
> > and the driver will during the lifetime of this interface act as a
> > coordinator and not a mixed mode which can be disabled and enabled
> > anytime. I am not even sure if this can ever be handled in such a way
> > from hardmac transceivers, it might depend on the transceiver
> > interface but we should assume some strict "static" handling. Static
> > handling means here that the transceiver is unable to switch from
> > coordinator and vice versa after some initialization state.
>
> Okay. I just completely missed the "interface add" command. So your
> advice is to treat the "PAN coordinator" property as a static property
> for a given interface, which seems reasonable.
>
> For now I will assume the same treatment when adding the interface is
> required compared to a NODE, but if something comes to your mind,
> please let me know.
>
> By the way, is there a mechanism limiting the number of interfaces on a
> device? Should we prevent the introduction of a coordinator iface if
> there is a node iface active?
>

such a mechanism already exists, look at the code when trying to ifup
an interface in mac802154. You cannot simply have a monitor and node
up at the same time. Hardware could have multiple address filters and
run multiple mac stack instances on one phy, which is in my opinion
not different than macvlan and in wireless running multiple access
points on the same phy.

> > 3. coordinator (any $TYPE specific) userspace software
> >
> > May the main argument. Some coordinator specific user space daemon
> > does specific type handling (e.g. hostapd) maybe because some library
> > is required. It is a pain to deal with changing roles during the
> > lifetime of an interface and synchronize user space software with it.
> > We should keep in mind that some of those handlings will maybe be
> > moved to user space instead of doing it in the kernel. I am fine with
> > the solution now, but keep in mind to offer such a possibility.
> >
> > I think the above arguments are probably the same why wireless is
> > doing something similar and I would avoid running into issues or it's
> > really difficult to handle because you need to solve other Linux net
> > architecture handling at first.
>
> Yep.
>
> > > > You are mixing things here with "role in the network" and what the
> > > > transceiver capability (RFD, FFD) is, which are two different things.
> > >
> > > I don't think I am, however maybe our vision differ on what an
> > > interface should be.
> > >
> > > > You should use those defines and the user needs to create a new
> > > > interface type and probably have a different extended address to act
> > > > as a coordinator.
> > >
> > > Can't we just simply switch from coordinator to !coordinator (that's
> > > what I currently implemented)? Why would we need the user to create a
> > > new interface type *and* to provide a new address?
> > >
> > > Note that these are real questions that I am asking myself. I'm fine
> > > adapting my implementation, as long as I get the main idea.
> > >
> >
> > See above.
>
> That's okay for me. I will adapt my implementation to use the interface
> thing. In the mean time additional details about what a coordinator
> interface should do differently (above question) is welcome because
> this is not something I am really comfortable with.
>

I think we need to figure this out...

- Alex

