Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8AE4B2916
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 16:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351379AbiBKP3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 10:29:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235355AbiBKP3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 10:29:06 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AD61A1
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 07:29:04 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id k25so23683917ejp.5
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 07:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zx0kDESUyN/aBgLfQ1POtV22ofASCvKpXtut85b48FE=;
        b=S4puAcEb8Cd8YtIYXBgWo//FF0+nyNm3pizaZve0zN2KaxV/EIthMLkDYA/mmHssWW
         Fm4VWh//yVnNg6ObYmKG5cWLKNG3P4KMNCuDMtT5EpjoR60+guFSgnkvZMFgbYG2MbRa
         jNg8VUlXXHV+obySZsDZ7W6KtLFxM0o1pF9FjmiPIDLarsHHxWrlIxkv9ni0R+ewsOXH
         8TJ73nNvo78Eb0x2wwy6r/6Z7xqnpRcDwBA38KjaNMWIr+oey+LKBL/i7wqBJrUilhjQ
         jGujLWjzXpvN0L1enLAYHD3pkeDbEI0zjHVQprgHfvv4yMtAE+I/wLd6+86OUtia5N1T
         TxTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zx0kDESUyN/aBgLfQ1POtV22ofASCvKpXtut85b48FE=;
        b=atObATeefXvD7+pphf9Hb5RiC15ygTI+5rnVzEX9MxoydxX/uctM0Fd5iNciEpPnQ+
         9c2tDS47YKZUfMkRx0ZcpvqTbWO0Ts466ihUW26rHD1Q3Han1UuK41FAZhGxlGgNCm1m
         1iNjpejGmBEQZYZei4X3uq0Xym6nzYFyc6RvQiYdMi15puWo8Z44o6yDMQcOtHRDQV8V
         Iq1LOAK/rKUVrgUAAjr3J/bayhDBgoXbcu7TS2qQtmryV8iJ0sop58v1GiXIDuVbGTOV
         1e/6w/jbS5u3/evrpRc2wL/FJaGOr0qy0Jw1S+4/10lrbZ/zO56lPELPYwzc6UxicSiI
         JYMw==
X-Gm-Message-State: AOAM533MHQubIXWY0QVpPz57Iiw0ILYQDjIE6qrSFYef+SEvBCEwF7K+
        /XQc68bEjGv6hXXkCUe6W8poZoHt+xU=
X-Google-Smtp-Source: ABdhPJzNgjnwKSoCEwa7LZaszDG5fN3GYCHh4M9E74mKwnjGxH+bNvdsvRGLMNhZ2Jo9RpRW37AwPQ==
X-Received: by 2002:a17:907:3ea9:: with SMTP id hs41mr1887202ejc.727.1644593343182;
        Fri, 11 Feb 2022 07:29:03 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id i24sm4913454edt.86.2022.02.11.07.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 07:29:02 -0800 (PST)
Date:   Fri, 11 Feb 2022 17:29:01 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: Re: [RFC PATCH net-next 1/2] net: dsa: allow setting port-based QoS
 priority using tc matchall skbedit
Message-ID: <20220211152901.inmg5klgb6pryms7@skbuf>
References: <20210113154139.1803705-1-olteanv@gmail.com>
 <20210113154139.1803705-2-olteanv@gmail.com>
 <X/+FKCRgkqOtoWbo@lunn.ch>
 <20210114001759.atz5vehkdrire6p7@skbuf>
 <X/+YQlEkeNYXditV@lunn.ch>
 <CA+h21hoYOZZYhoD+QgDvm-Pe11EH5LgLtzRrYPQux_8a7AeHGw@mail.gmail.com>
 <87h795dbnm.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h795dbnm.fsf@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Petr,

On Fri, Feb 11, 2022 at 08:52:20AM +0100, Petr Machata wrote:
> 
> Vladimir Oltean <olteanv@gmail.com> writes:
> 
> > Hi Andrew,
> >
> > On Thu, 14 Jan 2021 at 03:03, Andrew Lunn <andrew@lunn.ch> wrote:
> >> On Thu, Jan 14, 2021 at 02:17:59AM +0200, Vladimir Oltean wrote:
> >> > On Thu, Jan 14, 2021 at 12:41:28AM +0100, Andrew Lunn wrote:
> >> > > On Wed, Jan 13, 2021 at 05:41:38PM +0200, Vladimir Oltean wrote:
> >> > > > + int     (*port_priority_set)(struct dsa_switch *ds, int port,
> >> > > > +                              struct dsa_mall_skbedit_tc_entry *skbedit);
> >> > >
> >> > > The fact we can turn this on/off suggests there should be a way to
> >> > > disable this in the hardware, when the matchall is removed. I don't
> >> > > see any such remove support in this patch.
> >> >
> >> > I don't understand this comment, sorry. When the matchall filter
> >> > containing the skbedit action gets removed, DSA calls the driver's
> >> > .port_priority_set callback again, this time with a priority of 0.
> >> > There's nothing to "remove" about a port priority. I made an assumption
> >> > (which I still consider perfectly reasonable) that no port-based
> >> > prioritization means that all traffic gets classified to traffic class 0.
> >>
> >> That does not work for mv88e6xxx. Its default setup, if i remember
> >> correctly, is it looks at the TOS bits to determine priority
> >> classes. So in its default state, it is using all the available
> >> traffic classes.  It can also be configured to look at the VLAN
> >> priority, or the TCAM can set the priority class, or there is a per
> >> port default priority, which is what you are describing here. There
> >> are bits to select which of these happen on ingress, on a per port
> >> basis.
> >>
> >> So setting the port priority to 0 means setting the priority of
> >> zero. It does not mean go back to the default prioritisation scheme.
> >>
> >> I guess any switch which has a range of options for prioritisation
> >> selection will have a similar problem. It defaults to something,
> >> probably something a bit smarter than everything goes to traffic class
> >> 0.
> >>
> >>       Andrew
> >
> > I was going through my old patches, and re-reading this conversation,
> > it appears one of us is misunderstanding something.
> >
> > I looked at some Marvell datasheet and it has a similar QoS
> > classification pipeline to Vitesse switches. There is a port-based
> > default priority which can be overridden by IP DSCP, VLAN PCP, or
> > advanced QoS classification (TCAM).
> >
> > The proposal I had was to configure the default port priority using tc
> > matchall skbedit priority. Advanced QoS classification would then be
> > expressed as tc-flower filters with a higher precedence than the
> > matchall (basically the "catchall"). PCP and DSCP, I don't know if
> > that can be expressed cleanly using tc. I think there's something in
> > the dcb ops, but I haven't studied that too deeply.
> 
> In 802.1Q-2014, port-default priority is handled as APP entries matching
> on EtherType of 0. (See Table D-9.) Those are "default priority. For use
> when priority is not otherwise specified".
> 
> So DCB ops just handle these as APP entries. Dunno what DSA does. In
> mlxsw, we call dcb_ieee_getapp_default_prio_mask() when the DCP set_app
> hook fires to find the relevant entries and get the priority bitmask.

Thanks, these are great pointers. Last time I looked at DCB ops, the dcb
iproute program didn't exist, one had to use some LLDP tool IIRC, and it
was a bit cumbersome and I dismissed it without even looking at all the
details, I didn't notice that the port-default priority corresponds to a
selector of 1 and a protocol of 0.

The point is that I'm not bent on using tc-matchall for port-based
default priority, it's just that I wasn't aware of a better way.
But I'll look into adding support for DCB ops for my DSA driver, sounds
like a much, much better fit.

> Now I don't understand DSA at all, but given a chip with fancy defaults,
> for the DCB interface in particular, it would make sense to me to have
> two ops. As long as there are default-prio entries, a "set default
> priority" op would get invoked with the highest configured default
> priority. When the last entry disappears, an "unset" op would be called.

I don't understand this comment, sorry. I don't know what's a "chip with
fancy defaults".

> Not sure what DSA does with ACLs, but it's not clear to me how TC-based
> prioritization rules coexist with full blown ACLs. I suppose the prio
> stuff could live on chain 0 and all actions would be skbedit prio pipe
> goto chain 1 or something. And goto chain 0 is forbidden, because chain
> 0 is special. Or maybe the prioritization stuff lives on a root qdisc
> (but no, we need it for ingress packets...) One way or another it looks
> hairy to dissect and offload accurately IMHO.

There's nothing to understand about the DSA core at all, it has no
saying in how prioritization or TC rules are configured, that is left
down to the hardware driver.

To make sure we use the same terminology, when you say "how TC-based
prioritization rules coexist with full blown ACLs", you mean
trap/drop/redirect by ACLs, right?

So the ocelot driver has a programmable, fixed pipeline of multiple
ingress stages (VCAP IS1 for VLAN editing and advanced QoS classification)
and egress stages (VCAP ES0 for egress VLAN rewriting). We model the
entire TCAM subsystem using one chain per TCAM lookup, and force gotos
from the current stage to the next. See
tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh for the
intended usage model.

Now, that's all for advanced QoS classification, not for port-based
default, VLAN PCP and IP DSCP. My line of thinking is that we could do
the latter via dcb-app, and leave the former where it is (skbedit with
tc-flower), and they'd coexist just fine, right?
