Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749DE511399
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 10:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359467AbiD0Ilf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 04:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359466AbiD0Ilf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 04:41:35 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E9E66AEE
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 01:38:24 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id p10so1833740lfa.12
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 01:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=M1Xjb5oe8WunhOiNjZ5BTVNv/ZK2WliSqjdMinCgT9Y=;
        b=Y7m2SsIzYUPNy5WJ1w8AzKOJ14qud5jvfNM/u9V0RDMGXjthbbPtx/WuuEsgAai3+H
         bY3e4iPVCIWxk82By3tfKBIlio7xz2TVOZ92xqQuVczfXK1H6M8dSibYNmo3JMOhGUXk
         rxZkSqevjxBXqVC5CCjIyJw9sJQ7ec5rwkJScNYQxspnpjjDbLL8JMtx8yIGYOPoZrZi
         /QVxHAAMLC5FSdQk4tkcUJs1jdIpInNREpTB1559sNYtNK0Mv1OdRQSDgCuJTBCBcUwU
         lmhXm9aBp95TQzm3VF8nD2yoAiTkZjbAX8DOd2oxyefl7gDkv735FYymJBGPaRxZbbDz
         HEfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=M1Xjb5oe8WunhOiNjZ5BTVNv/ZK2WliSqjdMinCgT9Y=;
        b=ShPaGw+43UcctvV8gL+wBRd+9owmjUCBEHQFLDO7Us4JAR5jJPUJA07gcIZgB71AtR
         dlE3MT40qIGQMusKEV5zEJQqFadaiL+hFTYNM/Ko3kDPE7IIh3l2t1UtpLD92wPJy+TL
         0tsakXOfKgdmiUpOKOaSFHMi21/wl76UCxONK5+pzInTdOh6S5QVj16D1h5t0fvp9kWF
         4q++cXDm2BR6igoMBa5sDd8mdW2AqX20AFd/nQEBDNunfT7qb3XSONiuW39rdgiq0VtJ
         SwPmecgRXno4dtrAttOjHjbct4IEmVJQK/yITibdr+oIoEY0Tgpux/WiGo4JfXEnE7MK
         FpOQ==
X-Gm-Message-State: AOAM532U46SoZWwOVz7b2bjsgEm1TQbmOpQpsLRuLEvzqNry+E60v2Nr
        LKSsVazRpgeQUbSFxjUwpA0=
X-Google-Smtp-Source: ABdhPJxlUK+AXRAL6aE8z+yc5BLsuyznu1auKE/FspeGq9e/aC1V0ugKFpv515hsnFcMiVkekuIi6A==
X-Received: by 2002:a05:6512:370a:b0:472:5a8:5859 with SMTP id z10-20020a056512370a00b0047205a85859mr10888666lfr.363.1651048702273;
        Wed, 27 Apr 2022 01:38:22 -0700 (PDT)
Received: from wse-c0127 (2-104-116-184-cable.dk.customer.tdc.net. [2.104.116.184])
        by smtp.gmail.com with ESMTPSA id q3-20020a19f203000000b0044aef0e60d5sm1990975lfh.210.2022.04.27.01.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 01:38:21 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Hans Schultz <schultz.hans@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH v2 net-next 07/10] net: dsa: request drivers to perform
 FDB isolation
In-Reply-To: <20220426231755.7yhvabefzbyiaj4o@skbuf>
References: <20220225092225.594851-1-vladimir.oltean@nxp.com>
 <20220225092225.594851-8-vladimir.oltean@nxp.com>
 <867d7bga78.fsf@gmail.com> <YmgaX4On/2j3lJf/@lunn.ch>
 <20220426231755.7yhvabefzbyiaj4o@skbuf>
Date:   Wed, 27 Apr 2022 10:38:18 +0200
Message-ID: <86ilquapl1.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On tis, apr 26, 2022 at 23:17, Vladimir Oltean <vladimir.oltean@nxp.com> wr=
ote:
> On Tue, Apr 26, 2022 at 06:14:23PM +0200, Andrew Lunn wrote:
>> > > @@ -941,23 +965,29 @@ struct dsa_switch_ops {
>> > >  	 * Forwarding database
>> > >  	 */
>> > >  	int	(*port_fdb_add)(struct dsa_switch *ds, int port,
>> > > -				const unsigned char *addr, u16 vid);
>> > > +				const unsigned char *addr, u16 vid,
>> > > +				struct dsa_db db);
>> >=20
>> > Hi! Wouldn't it be better to have a struct that has all the functions
>> > parameters in one instead of adding further parameters to these
>> > functions?
>> >=20
>> > I am asking because I am also needing to add a parameter to
>> > port_fdb_add(), and it would be more future oriented to have a single
>> > function parameter as a struct, so that it is easier to add parameters
>> > to these functions without hav=C3=ADng to change the prototype of the
>> > function every time.
>>=20
>> Hi Hans
>>=20
>> Please trim the text to only what is relevant when replying. It is
>> easy to miss comments when having to Page Down, Page Down, Page down,
>> to find comments.
>>=20
>>    Andrew
>
> Agreed, had to scroll too much.
>
> Hans, what extra argument do you want to add to port_fdb_add?
> A static/dynamic, I suppose, similar to what exists in port_fdb_dump?

Yes, a static/dynamic bool, or could be called a flag field.

>
> But we surely wouldn't pass _all_ parameters of port_fdb_add through
> some giant struct args_of_port_fdb_add, would we?  Not ds, port, db,
> just what is naturally grouped together as an FDB entry: addr, vid,
> maybe your new static/dynamic thing.
>
> If we group the addr and vid in port_fdb_add into a structure that
> represents an FDB entry, what do we do about those in port_fdb_del?
> Group those as well, maybe for consistency?

I think the 'old' interface that several other functions use should have
one struct... e.g. port, addr and vid. But somehow it would be good to
have something more dynamic. There could be two layer of structs, but
generally i think that for these op functions now in relation to fdb
should only have structs as parameters in a logical way that is
expandable and thus future oriented.

Something else to consider is what do switchcore drivers that don't use
'include/net/dsa.h' do and why?

>
> Same question for port_fdb_dump and its dsa_fdb_dump_cb_t: would you
> change it for uniformity, or would you keep it the way it is to reduce
> the churn? I mean it's a perfectly viable candidate for argument
> grouping, but your stated goal _is_ to reduce churn.

I think port_fdb_dump() is maybe the last one that I would change, but
all those functions where you have added the struct dsa_db would be=20
candidates.

>
> But if we add the static/dynamic boolean to this structure, does it make
> sense on deletion? And if it doesn't, why have we changed the prototype
> of port_fdb_del to include it?
>

True a static/dynamic boolean doesn't make much sense on deletion, only
if it came in because it is part of a generic struct.

> Restated: do we want to treat the "static/dynamic" info as a property of
> an FDB entry (i.e. a member of the structure), or as the way in which a
> certain FDB entry can be added to hardware (case in which it is relevant
> only to _add and to _dump)?  After all, an FDB entry for {addr, vid}
> learned statically, and another FDB entry for the same {addr, vid} but
> learned dynamically, are fundamentally the same object.
>

I cannot answer for the workings of all switchcores, but for my sake I
use a debug tool to show the age of a dynamic entry in the ATU, so I
don't think that it has much relevance outside of that.

> And if we don't go with a big struct args_of_port_fdb_add (which would
> be silly if we did), who guarantees that the argument list of port_fdb_add
> won't grow in the future anyway? Like in the example I just gave above,
> where "static/dynamic" doesn't fully appear to group naturally with
> "addr" and "vid", and would probably still be a separate boolean,
> rendering the whole point moot.
>
> And even grouping only those last 2 together is maybe debatable due to
> practical reasons - where do we declare this small structure? We have a
> struct switchdev_notifier_fdb_info with some more stuff that we
> deliberately do not want to expose, and {addr, vid} are all that remain.
>
> Although maybe there are benefits to having a small {addr, vid} structure
> defined somewhere publicly, too, and referenced consistently by driver
> code. Like for example to avoid bad patterns from proliferating.
> Currently we have "const unsigned char *addr, u16 vid", so on a 64 bit
> machine, this is a pointer plus an unsigned short, 10 bytes, padded up
> by the compiler, maybe to 16. But the Ethernet addresses are 6 bytes,
> those are shorter than the pointer itself, so on a 64-bit machine,
> having "unsigned char addr[ETH_ALEN], u16 vid" makes a lot more space,
> saves some real memory.

I see that there is definitions for 64bit mac addresses out there, which
might also be needed to be supported at some point?

>
> Anyway, I'm side tracking. If you want to make changes, propose a
> patch, but come up with a more real argument than "reducing churn"
> (while effectively producing churn).

Unfortunately I don't have the time to make such a patch suggestion for
some time to come as I also have other patch sets coming up, and I
should study a bit what your patch set with the dsa_db is about also, so
maybe I must just add the bool to port_fdb_add() for now.

>
> To give you a counter example, phylink_mac_config() used to have the
> opposite problem, the arguments were all neatly packed into a struct
> phylink_link_state, but as the kerneldocs from include/linux/phylink.h
> put it, not all members of that structure were guaranteed to contain
> valid values. So there were bugs due to people not realizing this, and
> consequently, phylink_mac_link_up() took the opposite approach, of
> explicitly passing all known parameters of the resolved link state as
> individual arguments. Now there are 10 arguments to that function, but
> somehow at least this appears to have worked better, in the sense that
> there isn't an explanatory note saying what's valid and what isn't.

Yes, I can see the danger of it, but something like phylink is also
different as it is more hardware related, which has a slower development
cycle than feature/protocol stuff.
