Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2524D5E06
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 10:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243845AbiCKJCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 04:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240897AbiCKJCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 04:02:13 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F173D1BB70E
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 01:01:08 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id g17so13921919lfh.2
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 01:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=W3zfuD5dHgrDuKUno5kyEdgPfGowqMZSjsoGskY52Po=;
        b=P2znEwK8yU15naBA2c8ZVJCAP9IWe2bqBJa0ZO7Di3nEpK941berc1fWxU2/6hMNCN
         XkdV2rtDEF7D/pSBJ3KJqZq0OO0mgiWH4xcLt59PRu8A8+oR2XVHYdF1pUZ4gmKMKY0i
         iQ/+LHyiof6llqvjnrGLMkE/pYWEAHSjwDGNL7XC/EHt9BiC6RDbdA81UkuJKx4+KkrE
         sFlD4y3+mgxx89kAKBl0e8rd8LfxaApGN3xbztLXlF8exMiIeVXiqjUeE4em7BqDEBA2
         yfd5YmQ7q8lAQqp/FU5XLd9WOVA1kMHMJzDeVjIOn1axEwmV4n/3jcrAdfEM9R1rL5gh
         ljNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=W3zfuD5dHgrDuKUno5kyEdgPfGowqMZSjsoGskY52Po=;
        b=VN3+R3VyjGRuyn/yUYT7gCpiIPVnhy1YnIqHb7JHC3jKT+6gHPER5cV0tY32wfbQYK
         RdXMPclr/thnS+cHBSv5ZxZdB16aMjB+k2oydv+/StwhrO1jPK18FuygnLMxTPtz5cIQ
         zctH7/vDl4fqOk1lt7vH4pY7Y+wDWeJD6+ROEOGwvtM0iNt1HbTqLdW7/EYZ11StEJ/m
         qJ74NINFjY4fiUyzEf6tvks7RblyQnnpdr4gO3imHnwD3jMCx97kr4sC8GK9OdCGrbT7
         Ctz+QfwgveB9z6n+FM+n8U7YG/NGzg7ZL0vAStZ4jN0c5+rTh8B598sDlKbXylj08Qfo
         EDkg==
X-Gm-Message-State: AOAM531QTqnV4R3pl1AdUmEas620RKbpcFOHP2zPC5I2IJrGgxSUnKZn
        /E5cG6yl4ciImF90TJN6M4wEkQ==
X-Google-Smtp-Source: ABdhPJwx01X9odav3MPZuw3GNyb7UI52+doEIUsUOpjQsej0esLxDASHJVS8cckwz1Xs6p3Yeo0h7Q==
X-Received: by 2002:a05:6512:1c5:b0:448:2f4b:22ae with SMTP id f5-20020a05651201c500b004482f4b22aemr5413813lfp.379.1646989267084;
        Fri, 11 Mar 2022 01:01:07 -0800 (PST)
Received: from wkz-x280 (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id x33-20020a0565123fa100b00443d3cffd89sm1482182lfa.210.2022.03.11.01.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 01:01:06 -0800 (PST)
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
In-Reply-To: <20220311002235.ws5ag6p4t4j7di4k@skbuf>
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301100321.951175-8-tobias@waldekranz.com>
 <20220303222055.7a5pr4la3wmuuekc@skbuf> <87mthymblh.fsf@waldekranz.com>
 <20220310103509.g35syl776kyh5j2n@skbuf> <87h785n67k.fsf@waldekranz.com>
 <20220310161857.33owtynhm3pdyxiy@skbuf> <87bkydmnmy.fsf@waldekranz.com>
 <20220310230828.fvx24zhoyue5mkb7@skbuf> <878rthmk91.fsf@waldekranz.com>
 <20220311002235.ws5ag6p4t4j7di4k@skbuf>
Date:   Fri, 11 Mar 2022 10:01:05 +0100
Message-ID: <875yokn9ri.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 02:22, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Fri, Mar 11, 2022 at 12:59:54AM +0100, Tobias Waldekranz wrote:
>> On Fri, Mar 11, 2022 at 01:08, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > On Thu, Mar 10, 2022 at 11:46:45PM +0100, Tobias Waldekranz wrote:
>> >> On Thu, Mar 10, 2022 at 18:18, Vladimir Oltean <olteanv@gmail.com> wr=
ote:
>> >> > On Thu, Mar 10, 2022 at 05:05:35PM +0100, Tobias Waldekranz wrote:
>> >> >> On Thu, Mar 10, 2022 at 12:35, Vladimir Oltean <olteanv@gmail.com>=
 wrote:
>> >> >> > On Thu, Mar 10, 2022 at 09:54:34AM +0100, Tobias Waldekranz wrot=
e:
>> >> >> >> >> +	if (!dsa_port_can_configure_learning(dp) || dp->learning) {
>> >> >> >> >> +		switch (state->state) {
>> >> >> >> >> +		case BR_STATE_DISABLED:
>> >> >> >> >> +		case BR_STATE_BLOCKING:
>> >> >> >> >> +		case BR_STATE_LISTENING:
>> >> >> >> >> +			/* Ideally we would only fast age entries
>> >> >> >> >> +			 * belonging to VLANs controlled by this
>> >> >> >> >> +			 * MST.
>> >> >> >> >> +			 */
>> >> >> >> >> +			dsa_port_fast_age(dp);
>> >> >> >> >
>> >> >> >> > Does mv88e6xxx support this? If it does, you might just as we=
ll
>> >> >> >> > introduce another variant of ds->ops->port_fast_age() for an =
msti.
>> >> >> >>=20
>> >> >> >> You can limit ATU operations to a particular FID. So the way I =
see it we
>> >> >> >> could either have:
>> >> >> >>=20
>> >> >> >> int (*port_vlan_fast_age)(struct dsa_switch *ds, int port, u16 =
vid)
>> >> >> >>=20
>> >> >> >> + Maybe more generic. You could imagine there being a way to tr=
igger
>> >> >> >>   this operation from userspace for example.
>> >> >> >> - We would have to keep the VLAN<->MSTI mapping in the DSA laye=
r in
>> >> >> >>   order to be able to do the fan-out in dsa_port_set_mst_state.
>> >> >> >>=20
>> >> >> >> or:
>> >> >> >>=20
>> >> >> >> int (*port_msti_fast_age)(struct dsa_switch *ds, int port, u16 =
msti)
>> >> >> >>=20
>> >> >> >> + Let's the mapping be an internal affair in the driver.
>> >> >> >> - Perhaps, less generically useful.
>> >> >> >>=20
>> >> >> >> Which one do you prefer? Or is there a hidden third option? :)
>> >> >> >
>> >> >> > Yes, I was thinking of "port_msti_fast_age". I don't see a cheap=
 way of
>> >> >> > keeping VLAN to MSTI associations in the DSA layer. Only if we c=
ould
>> >> >> > retrieve this mapping from the bridge layer - maybe with somethi=
ng
>> >> >> > analogous to br_vlan_get_info(), but br_mst_get_info(), and this=
 gets
>> >> >> > passed a VLAN_N_VID sized bitmap, which the bridge populates wit=
h ones
>> >> >> > and zeroes.
>> >> >>=20
>> >> >> That can easily be done. Given that, should we go for port_vlan_fa=
st_age
>> >> >> instead? port_msti_fast_age feels like an awkward interface, since=
 I
>> >> >> don't think there is any hardware out there that can actually perf=
orm
>> >> >> that operation without internally fanning it out over all affected=
 VIDs
>> >> >> (or FIDs in the case of mv88e6xxx).
>> >> >
>> >> > Yup, yup. My previous email was all over the place with regard to t=
he
>> >> > available options, because I wrote it in multiple phases so it wasn=
't
>> >> > chronologically ordered top-to-bottom. But port_vlan_fast_age() mak=
es
>> >> > the most sense if you can implement br_mst_get_info(). Same goes for
>> >> > dsa_port_notify_bridge_fdb_flush().
>> >> >
>> >> >> > The reason why I asked for this is because I'm not sure of the
>> >> >> > implications of flushing the entire FDB of the port for a single=
 MSTP
>> >> >> > state change. It would trigger temporary useless flooding in oth=
er MSTIs
>> >> >> > at the very least. There isn't any backwards compatibility conce=
rn to
>> >> >> > speak of, so we can at least try from the beginning to limit the
>> >> >> > flushing to the required VLANs.
>> >> >>=20
>> >> >> Aside from the performance implications of flows being temporarily
>> >> >> flooded I don't think there are any.
>> >> >>=20
>> >> >> I suppose if you've disabled flooding of unknown unicast on that p=
ort,
>> >> >> you would loose the flow until you see some return traffic (or whe=
n one
>> >> >> side gives up and ARPs). While somewhat esoteric, it would be nice=
 to
>> >> >> handle this case if the hardware supports it.
>> >> >
>> >> > If by "handle this case" you mean "flush only the affected VLANs", =
then
>> >> > yes, I fully agree.
>> >> >
>> >> >> > What I didn't think about, and will be a problem, is
>> >> >> > dsa_port_notify_bridge_fdb_flush() - we don't know the vid to fl=
ush.
>> >> >> > The easy way out here would be to export dsa_port_notify_bridge_=
fdb_flush(),
>> >> >> > add a "vid" argument to it, and let drivers call it. Thoughts?
>> >> >>=20
>> >> >> To me, this seems to be another argument in favor of
>> >> >> port_vlan_fast_age. That way you would know the VIDs being flushed=
 at
>> >> >> the DSA layer, and driver writers needn't concern themselves with =
having
>> >> >> to remember to generate the proper notifications back to the bridg=
e.
>> >> >
>> >> > See above.
>> >> >
>> >> >> > Alternatively, if you think that cross-flushing FDBs of multiple=
 MSTIs
>> >> >> > isn't a real problem, I suppose we could keep the "port_fast_age=
" method.
>> >> >>=20
>> >> >> What about falling back to it if the driver doesn't support per-VL=
AN
>> >> >> flushing? Flushing all entries will work in most cases, at the cos=
t of
>> >> >> some temporary flooding. Seems more useful than refusing the offlo=
ad
>> >> >> completely.
>> >> >
>> >> > So here's what I don't understand. Do you expect a driver other than
>> >> > mv88e6xxx to do something remotely reasonable under a bridge with M=
STP
>> >> > enabled? The idea being to handle gracefully the case where a port =
is
>> >> > BLOCKING in an MSTI but FORWARDING in another. Because if not, let's
>> >> > just outright not offload that kind of bridge, and only concern
>> >> > ourselves with what MST-capable drivers can do.
>> >>=20
>> >> I think you're right. I was trying to make it easier for other driver
>> >> writers, but it will just be more confusing and error prone.
>> >>=20
>> >> Alright, so v3 will have something like this:
>> >>=20
>> >> bool dsa_port_can_offload_mst(struct dsa_port *dp)
>> >> {
>> >> 	return ds->ops->vlan_msti_set &&
>> >> 		ds->ops->port_mst_state_set &&
>> >> 		ds->ops->port_vlan_fast_age &&
>> >> 		dsa_port_can_configure_learning(dp);
>> >> }
>> >>=20
>> >> If this returns false, we have two options:
>> >>=20
>> >> 1. Return -EOPNOTSUPP, which the bridge will be unable to discriminate
>> >>    from a non-switchdev port saying "I have no idea what you're talki=
ng
>> >>    about". I.e. the bridge will happily apply the config, but the
>> >>    hardware won't match. I don't like this, but it lines up with most
>> >>    other stuff.
>> >>=20
>> >> 2. Return a hard error, e.g. -EINVAL/-ENOSYS. This will keep the brid=
ge
>> >>    in sync with the hardware and also gives some feedback to the
>> >>    user. This seems like the better approach to me, but it is a new k=
ind
>> >>    of paradigm.
>> >>=20
>> >> What do you think?
>> >
>> > Wait, what? It matters a lot where you place the call to
>> > dsa_port_can_offload_mst(), too. You don't have to propagate a hard
>> > error code, either, at least if you make dsa_port_bridge_join() return
>> > -EOPNOTSUPP prior to calling switchdev_bridge_port_offload(), no?
>> > DSA transforms this error code into 0, and dsa_port_offloads_bridge*()
>> > starts returning false, which makes us ignore all MSTP related switchd=
ev
>> > notifiers.
>>=20
>> Right. So we also need:
>>=20
>> 1. A br_mst_enabled() that we can call from dsa_port_bridge_join to
>>    validate the initial state.
>>=20
>> 2. A switchdev attr event sent out when enabling/disabling MST on the
>>    bridge, so that we can NAK the change.
>
> So far, so good. This, to me, is analogous to the way in which a hypothet=
ical
> VLAN-unaware switchdev driver wouldn't deny VLAN additions or removals,
> but it would only accept a VLAN-unaware bridge, and refuse to transition
> into a VLAN-aware one. So even though we wouldn't deny the bridge from
> keeping state that would have effect when VLAN awareness is on, we
> would just deny the bridge from making that state active. Same with MSTP
> awareness in my view - don't deny MSTI migrations, per-MSTI port state
> changes etc, just the ability to turn on MSTP awareness.
>
> In practice I have only seen things done the other way around - the
> dpaa2-switch driver refuses VLAN-unaware bridges, so it doesn't need to
> handle ignoring VLAN switchdev notifiers - a slightly simpler task.
> Also, the concept of unoffloaded uppers seems to be pretty unique to DSA
> so far, among switchdev drivers.
>
>> > The important part will be to make sure that MSTP is enabled for this
>> > bridge from the get-go (that being the only case in which we can offlo=
ad
>> > an MSTP aware bridge), and refusing to offload dynamic changes to its
>> > MSTP state. I didn't re-check now, but I think I remember there being
>>=20
>> Hang on though. Won't that mean that this sequence...
>>=20
>> ip link add dev br0 type bridge \
>>     vlan_filtering 1 vlan_default_pvid 0 mst_enable 1
>> ip link set dev swp1 master br0
>>=20
>> ...will work, but offloading will be disabled on swp0; whereas this
>> sequence...
>>=20
>> ip link add dev br0 type bridge \
>>     vlan_filtering 1 vlan_default_pvid 0
>> ip link set dev swp1 master br0
>> ip link set dev br0 type bridge mst_enable 1
>>=20
>> ...will fail on the final command? Even though they are logically
>> equivalent? But maybe that's just the way the cookie crumbles.
>
> Well, they could be made equivalent for academic purposes, if you're
> prepared to dynamically unoffload a bridge port from the MST awareness
> notifier, be my guest, I never tried it... I suppose we could try it, in
> theory it's just a call to dsa_port_pre_bridge_leave() +
> dsa_port_bridge_leave() after all. But it's effort to be spent in work
> and testing, and I'm not sure whether anyone will see the benefit or use
> case. During initial bridge join, at least it's an established code
> path, the drivers which don't implement ds->ops->port_bridge_join() have
> exercised it. Alvin =C5=A0ipraga has fixed a few bugs related to rtl8365mb
> and this after some recent rework, it should work just fine now.

I completely agree. Just wanted to make sure that I had understood it
correctly. Thanks.

>> > limitations even in the software bridge related to dynamic MSTP mode
>> > changes anyway - there had to not be any port VLANs, which IIUC means
>> > that you actually need to _delete_ the port PVIDs which are automatica=
lly
>> > created before you could change the MSTP mode.
>>=20
>> There are some ergonomic issues there, yes. I might look at it again and
>> see if there is some reasonable way of allowing the mode to be changed
>> even when VLANs are present.
>>=20
>> > This is the model, what's wrong with it? I said "don't offload the
>> > bridge", not "don't offload specific MSTP operations".
>>=20
>> Nothing is wrong, I just couldn't see the whole picture.
>>=20
>> This is the way.
