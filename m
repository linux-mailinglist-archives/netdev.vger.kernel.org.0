Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D215D1B0634
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 12:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgDTKGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 06:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725773AbgDTKGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 06:06:34 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51099C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 03:06:34 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id b11so11349407wrs.6
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 03:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hvW9xer+VVvfzxUG9nPInmSbV4LdhnP0VMu3PgRtOW0=;
        b=1rWyZMrbhmFBOKbOg/fi/btKkg8zg7nwlM3WsgjgMx64BppV9eEmIYMtc/3Fe7Gp0T
         NfmCIYNssmhoQ5J1h11p8SBY32XQBkXlEvtTwAEDMJ2UgeNs+unrpJsZ/wssJ6WJEB5D
         rqnAgN+jfGPt+ASF+XjYWcrO3RWnEOaC/Lm8S1vechxF6ugsqIzX44CF4dBEAwlcu6db
         xLbbv9HLCvz/F6r3zd5n8nb2rIXbEJos/AjnUyh6X41+RzWSDtPdHJKzuYh5Rgj8sMJi
         HnyWvmwHJ02kPeqc44vV2B8BBq448qZKNWwTgSZrcsu43iO8DRb63QPxFDygQcwHNKa9
         w06Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hvW9xer+VVvfzxUG9nPInmSbV4LdhnP0VMu3PgRtOW0=;
        b=Oir3EoPDXnv80SRiVi4VcvoS4GFrRb0Nu5N9RPt0auNhIzdEFbEjLIWWrEKRvigMg2
         EmfB+GT3ExFI0heFDd3hz1DrEe9GQxwXERw5uBAeIPDgfuev19hLoNLg/LbWYhyUMpoN
         +5Qe47Q1GQ0tl3waZuVJOd0+QgjOaAwT5/RQ0G+nWG4+btx4bdmgl668CYT4NDrpwkL9
         hMSiHLhOen80SxjGNl+fae2dtoUWzDcCnxeLpXiPri9l7i3naAlJuM4UylGkMuh9kPrY
         BakZ4M3o1QgUVSywDTNgzEc8ocdaTBzQCdrP+RBmzA9MHs8L8kzgk7jP1a4Utje7IbUX
         FkFw==
X-Gm-Message-State: AGi0Pub+HZQIca5QaTXUgDbJXyCjvaWqkQLqtk5M7eucn6KJpG0WVolG
        3EblHnxHpfY9kBneDH5epov2rZkm0YA=
X-Google-Smtp-Source: APiQypJX+H8fZ8pOxhDoBkLyIDFZu90vD7GJABmNKvrSkIV7hhlmFEVump5mfiPV1oK41YqD/jLFYg==
X-Received: by 2002:adf:82a6:: with SMTP id 35mr17198771wrc.378.1587377192206;
        Mon, 20 Apr 2020 03:06:32 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b85sm723467wmb.21.2020.04.20.03.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 03:06:31 -0700 (PDT)
Date:   Mon, 20 Apr 2020 12:06:30 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, Po Liu <po.liu@nxp.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: mscc: ocelot: deal with problematic
 MAC_ETYPE VCAP IS2 rules
Message-ID: <20200420100630.GC6581@nanopsycho.orion>
References: <20200417190308.32598-1-olteanv@gmail.com>
 <20200419073307.uhm3w2jhsczpchvi@ws.localdomain>
 <20200419083032.GA3479405@splinter>
 <CA+h21hrqjXGUERKUXCWiciP7ZGnjhTeq=+ocMyP5msrKZ3pGSw@mail.gmail.com>
 <20200419135143.GA3487966@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200419135143.GA3487966@splinter>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Apr 19, 2020 at 03:51:43PM CEST, idosch@idosch.org wrote:
>On Sun, Apr 19, 2020 at 03:47:01PM +0300, Vladimir Oltean wrote:
>> Hi Ido, Allan,
>> 
>> On Sun, 19 Apr 2020 at 11:30, Ido Schimmel <idosch@idosch.org> wrote:
>> >
>> > On Sun, Apr 19, 2020 at 09:33:07AM +0200, Allan W. Nielsen wrote:
>> > > Hi,
>> > >
>> > > Sorry I did not manage to provide feedback before it was merged (I will
>> > > need to consult some of my colleagues Monday before I can provide the
>> > > foll feedback).
>> > >
>> > > There are many good things in this patch, but it is not only good.
>> > >
>> > > The problem is that these TCAMs/VCAPs are insanely complicated and it is
>> > > really hard to make them fit nicely into the existing tc frame-work
>> > > (being hard does not mean that we should not try).
>> > >
>> > > In this patch, you try to automatic figure out who the user want the
>> > > TCAM to be configured. It works for 1 use-case but it breaks others.
>> > >
>> > > Before this patch you could do a:
>> > >     tc filter add dev swp0 ingress protocol ipv4 \
>> > >             flower skip_sw src_ip 10.0.0.1 action drop
>> > >     tc filter add dev swp0 ingress \
>> > >             flower skip_sw src_mac 96:18:82:00:04:01 action drop
>> > >
>> > > But the second rule would not apply to the ICMP over IPv4 over Ethernet
>> > > packet, it would however apply to non-IP packets.
>> > >
>> > > With this patch it not possible. Your use-case is more common, but the
>> > > other one is not unrealistic.
>> > >
>> > > My concern with this, is that I do not think it is possible to automatic
>> > > detect how these TCAMs needs to be configured by only looking at the
>> > > rules installed by the user. Trying to do this automatic, also makes the
>> > > TCAM logic even harder to understand for the user.
>> > >
>> > > I would prefer that we by default uses some conservative default
>> > > settings which are easy to understand, and then expose some expert
>> > > settings in the sysfs, which can be used to achieve different
>> > > behavioral.
>> > >
>> > > Maybe forcing MAC_ETYPE matches is the most conservative and easiest to
>> > > understand default.
>> > >
>> > > But I do seem to recall that there is a way to allow matching on both
>> > > SMAC and SIP (your original motivation). This may be a better default
>> > > (despite that it consumes more TCAM resources). I will follow up and
>> > > check if this is possible.
>> > >
>> > > Vladimir (and anyone else whom interested): would you be interested in
>> > > spending some time discussion the more high-level architectures and
>> > > use-cases on how to best integrate this TCAM architecture into the Linux
>> > > kernel. Not sure on the outlook for the various conferences, but we
>> > > could arrange some online session to discuss this.
>> >
>> > Not sure I completely understand the difficulties you are facing, but it
>> > sounds similar to a problem we had in mlxsw. You might want to look into
>> > "chain templates" [1] in order to restrict the keys that can be used
>> > simultaneously.
>> >
>> > I don't mind participating in an online discussion if you think it can
>> > help.
>> >
>> > [1] https://github.com/Mellanox/mlxsw/wiki/ACLs#chain-templates
>> 
>> I think it is worth giving a bit of context on what motivated me to
>> add this patch. Luckily I believe I can summarize it in a paragraph
>> below.
>> 
>> I am trying to understand practical ways in which IEEE 802.1CB can be
>> used - an active redundancy mechanism similar to HSR/PRP which relies
>> on sending sequence-numbered frame duplicates and eliminating those
>> duplicates at the destination (as opposed to passive redundancy
>> mechanisms such as RSTP, MRP etc which rely on BLOCKING port states to
>> stop L2 forwarding loops from killing the network). So since 802.1CB
>> needs a network where none of the port states can be put to BLOCKING
>> (as that would break the forwarding of some of the replicated
>> streams), I need a way to limit the impact of L2 loops. Currently I am
>> using, rather successfully, an idea borrowed from HSR called
>> "self-address filtering". It says that received packets can be dropped
>> if their source MAC address matches the device's MAC address. This
>> feature is useful for ensuring that packets never traverse a ring
>> network more than once.
>> To implement this idea, I use an offloaded tc-flower rule matching on
>> src_mac with an action of "drop".
>> 
>> To my surprise, such a src_mac rule does not do what's written on the
>> box with the Ocelot switch flow classification engine called VCAP IS2.
>> That is, packets having that src_mac would only get dropped if their
>> protocol is not ARP, SNAP, IPv4, IPv6 and maybe others. Clearly such a
>> rule is less than useful for the purpose we want it to.
>> I did raise this concern here, and the suggestion that I got is to
>> implement something like this patch, aka enable a port setting which
>> forces matches on MAC_ETYPE keys only, regardless of higher-layer
>> protocol information:
>> https://lkml.org/lkml/2020/2/24/489
>> So the default (pre-patch) behavior is for IP (and other) matches to
>> be sane, at the expense of MAC matches being insane.
>> Whereas the current behavior is for MAC matches to be sane, at the
>> expense of IP matches becoming impossible as long as MAC rules are
>> also present.
>> In this context, Allan's complaint seems to be that the MAC matches
>> were "good enough" for them, even if not all MAC address matches were
>> caught, at least it did not prevent them from installing IP matching
>> rules on the same port.
>> 
>> I may not have completely understood Ido's suggestion to use
>> FLOW_CLS_TMPLT_CREATE (I might lack the imagination of how it can be
>> put to practical use to solve the clash here), but I do believe that
>> it is only a way for the driver to eliminate the guesswork out of the
>> user's intention.
>
>I was under the impression that you can't mix different keys (e.g.,
>src_mac + src_ip), but now I understand that you can't mix different
>keys in case of specific key *values*. This will work correctly:
>
>$ tc filter add dev swp0 ingress proto ip \
>	flower src_ip 192.0.2.1 action drop
>$ tc filter add dev swp0 ingress proto 0x88f7 \
>	flower src_mac 00:11:22:33:44:55 action drop
>
>This will not work correctly:
>
>$ tc filter add dev swp0 ingress proto ip \
>	flower src_ip 192.0.2.1 action drop
>$ tc filter add dev swp0 ingress proto all \
>	flower src_mac 00:11:22:33:44:55 action drop

If this screnario is not supported by the driver, it is always free to
return -EOPNOTSUPP.


>
>Correct? If so, I don't think the templates can help you. They are about
>forcing only specific keys, regardless of value.
>
>> In this case, my personal opinion is that the intention is absolutely
>> clear: a classifier with src_mac should match on all frames having
>> that src_mac (if that is not commonly agreed here, a good rule of
>> thumb is to compare with what a non-offloaded tc filter rule does).
>
>I agree.
>
>> Whereas the "non-problematic" MAC matches that the VCAP IS2 _is_ able
>> to still perform [ without calling ocelot_match_all_as_mac_etype ]
>> should be expressed in terms of a more specific classification key to
>> tc, such as:
>
>Yes.
>
>> 
>> tc filter add dev swp0 ingress *protocol 0x88f7* flower src_mac
>> 96:18:82:00:04:01 action drop
>> 
>> In the above case, because "protocol" is not ipv4, ipv6, arp, snap,
>> then these rules can happily live together without ever needing to
>> call ocelot_match_all_as_mac_etype. If we agree on this solution, I
>> can send a patch that refines the ocelot_ace_is_problematic_mac_etype
>> function.
>
>I think it makes sense. You are basically being explicit about the
>hardware limitations and denying configurations that cannot always work.
>Previous approach was to allow configurations that sometimes work.
