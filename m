Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F314D54CE
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 23:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344538AbiCJWsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 17:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344453AbiCJWrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 17:47:52 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8282B190B74
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:46:49 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id e6so5403416lfc.1
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=kNGw6kwfJ9oR81XHWCviYz3UmAwtDikl6Vryp12s7L4=;
        b=mm0bhIpm22ir/MobtaQvP5TVOKaZQVMD3quuZEhneXZwcgksahQDr4PLmFTeh+HarY
         hGAL0SOBgl1HiJt7x2fWvqh+5lvk6DvIpTSzb+BXxrG0oNIA5Y3Opo6Ap3hWLEdEK1kL
         nhpN1sfwkzVG8wh3daExMd8rMC1Jy9e14CvVnllQ9uoABFj2ZXpwq8nV3Tns4JaYIuGb
         SU5dAkIbM54+fJzCd0XIWHJbTJxGlo1l/FtdkNJkTg+FS/ycnIk1T1ncbQu0D22fGLc8
         GUZh8SUyx8hi6Sr7GmOXxhmRJUtjqaW2n/NRikFtGlUUua38qhY6H2yOJKb2VxL0eoEs
         cvrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=kNGw6kwfJ9oR81XHWCviYz3UmAwtDikl6Vryp12s7L4=;
        b=esaHtld45ecvrj7ZplHkzp3e61nk6ZUKYJ3Y4cssNvnVazZNUE4ZkJvixfweW4w7Yy
         qaiMNSlDUP2gPVstBdMFlATfZ9BnXbYaO2fjNal8cQc9v9clelN7SU50qjkCxdc0jlN4
         gPTYRp9fLsvTjld+yEQTw/D0sHzHriy9lRewRPeAYeEeuc0h/PEuK5zi8GvAiy+mCRdl
         Sg0rauwOadnH42MRiSQQ6FgU1WFpAwMlGde/ZQRy1hKYmtMUwL23719R9SB0iG5dzn5M
         Xoxn1PtBAjcmBF3OVrS7XuPAFuhdG7C0PZd3ODqI6Eu2o0jmbAA1f8umSrDOEEXfToT0
         2ieg==
X-Gm-Message-State: AOAM532DMcbnCfLC/PeE2E+qNv8mZKcvzlWt8JLIOa3LH9R5qBdA3ATS
        IRf9PQbMuOZU+9YRQgXR/HZvyA==
X-Google-Smtp-Source: ABdhPJw8Vf6nao2GEYEsqaqv3EJ8N1s6Rot81x92k1xK4twMASCbzunZyEJJnVMHf6kHrWgKTwiBQg==
X-Received: by 2002:a05:6512:ad6:b0:448:60f9:ae31 with SMTP id n22-20020a0565120ad600b0044860f9ae31mr3654206lfu.51.1646952407661;
        Thu, 10 Mar 2022 14:46:47 -0800 (PST)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id n13-20020a056512388d00b00443d9064160sm1214493lft.125.2022.03.10.14.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 14:46:47 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v2 net-next 07/10] net: dsa: Pass MST state changes to
 driver
In-Reply-To: <20220310161857.33owtynhm3pdyxiy@skbuf>
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301100321.951175-8-tobias@waldekranz.com>
 <20220303222055.7a5pr4la3wmuuekc@skbuf> <87mthymblh.fsf@waldekranz.com>
 <20220310103509.g35syl776kyh5j2n@skbuf> <87h785n67k.fsf@waldekranz.com>
 <20220310161857.33owtynhm3pdyxiy@skbuf>
Date:   Thu, 10 Mar 2022 23:46:45 +0100
Message-ID: <87bkydmnmy.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 18:18, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Thu, Mar 10, 2022 at 05:05:35PM +0100, Tobias Waldekranz wrote:
>> On Thu, Mar 10, 2022 at 12:35, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > On Thu, Mar 10, 2022 at 09:54:34AM +0100, Tobias Waldekranz wrote:
>> >> >> +	if (!dsa_port_can_configure_learning(dp) || dp->learning) {
>> >> >> +		switch (state->state) {
>> >> >> +		case BR_STATE_DISABLED:
>> >> >> +		case BR_STATE_BLOCKING:
>> >> >> +		case BR_STATE_LISTENING:
>> >> >> +			/* Ideally we would only fast age entries
>> >> >> +			 * belonging to VLANs controlled by this
>> >> >> +			 * MST.
>> >> >> +			 */
>> >> >> +			dsa_port_fast_age(dp);
>> >> >
>> >> > Does mv88e6xxx support this? If it does, you might just as well
>> >> > introduce another variant of ds->ops->port_fast_age() for an msti.
>> >> 
>> >> You can limit ATU operations to a particular FID. So the way I see it we
>> >> could either have:
>> >> 
>> >> int (*port_vlan_fast_age)(struct dsa_switch *ds, int port, u16 vid)
>> >> 
>> >> + Maybe more generic. You could imagine there being a way to trigger
>> >>   this operation from userspace for example.
>> >> - We would have to keep the VLAN<->MSTI mapping in the DSA layer in
>> >>   order to be able to do the fan-out in dsa_port_set_mst_state.
>> >> 
>> >> or:
>> >> 
>> >> int (*port_msti_fast_age)(struct dsa_switch *ds, int port, u16 msti)
>> >> 
>> >> + Let's the mapping be an internal affair in the driver.
>> >> - Perhaps, less generically useful.
>> >> 
>> >> Which one do you prefer? Or is there a hidden third option? :)
>> >
>> > Yes, I was thinking of "port_msti_fast_age". I don't see a cheap way of
>> > keeping VLAN to MSTI associations in the DSA layer. Only if we could
>> > retrieve this mapping from the bridge layer - maybe with something
>> > analogous to br_vlan_get_info(), but br_mst_get_info(), and this gets
>> > passed a VLAN_N_VID sized bitmap, which the bridge populates with ones
>> > and zeroes.
>> 
>> That can easily be done. Given that, should we go for port_vlan_fast_age
>> instead? port_msti_fast_age feels like an awkward interface, since I
>> don't think there is any hardware out there that can actually perform
>> that operation without internally fanning it out over all affected VIDs
>> (or FIDs in the case of mv88e6xxx).
>
> Yup, yup. My previous email was all over the place with regard to the
> available options, because I wrote it in multiple phases so it wasn't
> chronologically ordered top-to-bottom. But port_vlan_fast_age() makes
> the most sense if you can implement br_mst_get_info(). Same goes for
> dsa_port_notify_bridge_fdb_flush().
>
>> > The reason why I asked for this is because I'm not sure of the
>> > implications of flushing the entire FDB of the port for a single MSTP
>> > state change. It would trigger temporary useless flooding in other MSTIs
>> > at the very least. There isn't any backwards compatibility concern to
>> > speak of, so we can at least try from the beginning to limit the
>> > flushing to the required VLANs.
>> 
>> Aside from the performance implications of flows being temporarily
>> flooded I don't think there are any.
>> 
>> I suppose if you've disabled flooding of unknown unicast on that port,
>> you would loose the flow until you see some return traffic (or when one
>> side gives up and ARPs). While somewhat esoteric, it would be nice to
>> handle this case if the hardware supports it.
>
> If by "handle this case" you mean "flush only the affected VLANs", then
> yes, I fully agree.
>
>> > What I didn't think about, and will be a problem, is
>> > dsa_port_notify_bridge_fdb_flush() - we don't know the vid to flush.
>> > The easy way out here would be to export dsa_port_notify_bridge_fdb_flush(),
>> > add a "vid" argument to it, and let drivers call it. Thoughts?
>> 
>> To me, this seems to be another argument in favor of
>> port_vlan_fast_age. That way you would know the VIDs being flushed at
>> the DSA layer, and driver writers needn't concern themselves with having
>> to remember to generate the proper notifications back to the bridge.
>
> See above.
>
>> > Alternatively, if you think that cross-flushing FDBs of multiple MSTIs
>> > isn't a real problem, I suppose we could keep the "port_fast_age" method.
>> 
>> What about falling back to it if the driver doesn't support per-VLAN
>> flushing? Flushing all entries will work in most cases, at the cost of
>> some temporary flooding. Seems more useful than refusing the offload
>> completely.
>
> So here's what I don't understand. Do you expect a driver other than
> mv88e6xxx to do something remotely reasonable under a bridge with MSTP
> enabled? The idea being to handle gracefully the case where a port is
> BLOCKING in an MSTI but FORWARDING in another. Because if not, let's
> just outright not offload that kind of bridge, and only concern
> ourselves with what MST-capable drivers can do.

I think you're right. I was trying to make it easier for other driver
writers, but it will just be more confusing and error prone.

Alright, so v3 will have something like this:

bool dsa_port_can_offload_mst(struct dsa_port *dp)
{
	return ds->ops->vlan_msti_set &&
		ds->ops->port_mst_state_set &&
		ds->ops->port_vlan_fast_age &&
		dsa_port_can_configure_learning(dp);
}

If this returns false, we have two options:

1. Return -EOPNOTSUPP, which the bridge will be unable to discriminate
   from a non-switchdev port saying "I have no idea what you're talking
   about". I.e. the bridge will happily apply the config, but the
   hardware won't match. I don't like this, but it lines up with most
   other stuff.

2. Return a hard error, e.g. -EINVAL/-ENOSYS. This will keep the bridge
   in sync with the hardware and also gives some feedback to the
   user. This seems like the better approach to me, but it is a new kind
   of paradigm.

What do you think?

> I'm shadowing you with a prototype (and untested so far) MSTP
> implementation for the ocelot/felix drivers, and those switches can
> flush the MAC table per VLAN too. So I don't see an immediate need to
> have a fallback implementation if you'll also provide it for mv88e6xxx.
> Let's treat that only if the need arises.

Cool. Agreed, v3 will implement .port_vlan_fast_age for mv88e6xxx.
