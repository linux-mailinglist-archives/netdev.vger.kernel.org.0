Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D4C4D4F2F
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 17:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242457AbiCJQXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 11:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244032AbiCJQWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 11:22:53 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781B1192E2E
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 08:20:29 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id e6so3709907lfc.1
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 08:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=k6OgL/z6xyQraQABSVfYgeydoW+8ffdkM6ASQFGYnFc=;
        b=6tWwYjJO7t29tf8hEjIH77l5ZvdGSdEOvjTLNGyXPWrBD1C0k76cIvbNNJzdJ47uWx
         rmoiAeGmtcWQUFGLe5G3z3D8GAztAkgpGvvRpgHxsAJ5lMmr4aY+m0ABiMMpUYYa+d/+
         w09XuoAaO0Vq4HiEqajEa1VHwEuHKPfdac1z13JphojTaZz5deh9+AjeJnLloWopPini
         QNL+ZK294p36Id1WJCXRfxLegWst6D90i/vyvUGDpV8ryklkLkeiuRcJlHSL8VFVtuWR
         JA5FaRL0z33xNgPvj7z/TQ2hSFXwSR2h6iXs7rVrzvlio+9nPdCkL2F8LbMwhckgnn/3
         1hsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=k6OgL/z6xyQraQABSVfYgeydoW+8ffdkM6ASQFGYnFc=;
        b=Zq66Lp7UJse/RHteW/9hRcOyWJbzbxI8YKSiwcliAJ3meXnoAiXl+XNdh64nW6i2JV
         6wTdblkIzOupF+5Pl906/PZEzFxXN1wU2i2CzDBMgk80gj9Mz0cg9sTmuvka094Y9R3K
         Y+letq+kiFl1ooHOuzob6pm5aCyPfddg5Wpc8waUecBKhjgfdQQH2KIlC272nvabdoOM
         I9dAabuXbYO/LH8mJ78Y4029ysSPyjQZdrA7XVZAVi6boIGReeja0VNMGeF55cJexLvG
         jhFMgzKHxSVatoPqWrm8pOTiLJYicB6gFxrwCpGufVgpBygdjsHrpMT6HBoZpJu+jCUR
         fCsQ==
X-Gm-Message-State: AOAM532ua6hLZG8uOO/G3Wx+M2SzFBnLNbbqedIVG3IOmu5B8l3nNFEr
        Sutk2I//Ynaq6ne/zLI7tYOSoQ==
X-Google-Smtp-Source: ABdhPJyrOU18INkvX9oTxj8d3WqnRuWU0PdDWOStGmpIR9Wc4Xy83lyyX897VBpMNDVNNQyi8SJR6Q==
X-Received: by 2002:a05:6512:3f17:b0:43d:8e7f:29f8 with SMTP id y23-20020a0565123f1700b0043d8e7f29f8mr3335181lfa.609.1646929223990;
        Thu, 10 Mar 2022 08:20:23 -0800 (PST)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id w15-20020a05651204cf00b004433bb6ec6bsm1045857lfq.282.2022.03.10.08.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 08:20:23 -0800 (PST)
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
In-Reply-To: <87h785n67k.fsf@waldekranz.com>
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301100321.951175-8-tobias@waldekranz.com>
 <20220303222055.7a5pr4la3wmuuekc@skbuf> <87mthymblh.fsf@waldekranz.com>
 <20220310103509.g35syl776kyh5j2n@skbuf> <87h785n67k.fsf@waldekranz.com>
Date:   Thu, 10 Mar 2022 17:20:22 +0100
Message-ID: <87ee39n5ix.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 17:05, Tobias Waldekranz <tobias@waldekranz.com> wrote:
> On Thu, Mar 10, 2022 at 12:35, Vladimir Oltean <olteanv@gmail.com> wrote:
>> On Thu, Mar 10, 2022 at 09:54:34AM +0100, Tobias Waldekranz wrote:
>>> >> +	if (!dsa_port_can_configure_learning(dp) || dp->learning) {
>>> >> +		switch (state->state) {
>>> >> +		case BR_STATE_DISABLED:
>>> >> +		case BR_STATE_BLOCKING:
>>> >> +		case BR_STATE_LISTENING:
>>> >> +			/* Ideally we would only fast age entries
>>> >> +			 * belonging to VLANs controlled by this
>>> >> +			 * MST.
>>> >> +			 */
>>> >> +			dsa_port_fast_age(dp);
>>> >
>>> > Does mv88e6xxx support this? If it does, you might just as well
>>> > introduce another variant of ds->ops->port_fast_age() for an msti.
>>> 
>>> You can limit ATU operations to a particular FID. So the way I see it we
>>> could either have:
>>> 
>>> int (*port_vlan_fast_age)(struct dsa_switch *ds, int port, u16 vid)
>>> 
>>> + Maybe more generic. You could imagine there being a way to trigger
>>>   this operation from userspace for example.
>>> - We would have to keep the VLAN<->MSTI mapping in the DSA layer in
>>>   order to be able to do the fan-out in dsa_port_set_mst_state.
>>> 
>>> or:
>>> 
>>> int (*port_msti_fast_age)(struct dsa_switch *ds, int port, u16 msti)
>>> 
>>> + Let's the mapping be an internal affair in the driver.
>>> - Perhaps, less generically useful.
>>> 
>>> Which one do you prefer? Or is there a hidden third option? :)
>>
>> Yes, I was thinking of "port_msti_fast_age". I don't see a cheap way of
>> keeping VLAN to MSTI associations in the DSA layer. Only if we could
>> retrieve this mapping from the bridge layer - maybe with something
>> analogous to br_vlan_get_info(), but br_mst_get_info(), and this gets
>> passed a VLAN_N_VID sized bitmap, which the bridge populates with ones
>> and zeroes.
>
> That can easily be done. Given that, should we go for port_vlan_fast_age
> instead? port_msti_fast_age feels like an awkward interface, since I
> don't think there is any hardware out there that can actually perform
> that operation without internally fanning it out over all affected VIDs
> (or FIDs in the case of mv88e6xxx).
>
>> The reason why I asked for this is because I'm not sure of the
>> implications of flushing the entire FDB of the port for a single MSTP
>> state change. It would trigger temporary useless flooding in other MSTIs
>> at the very least. There isn't any backwards compatibility concern to
>> speak of, so we can at least try from the beginning to limit the
>> flushing to the required VLANs.
>
> Aside from the performance implications of flows being temporarily
> flooded I don't think there are any.
>
> I suppose if you've disabled flooding of unknown unicast on that port,
> you would loose the flow until you see some return traffic (or when one
> side gives up and ARPs). While somewhat esoteric, it would be nice to
> handle this case if the hardware supports it.
>
>> What I didn't think about, and will be a problem, is
>> dsa_port_notify_bridge_fdb_flush() - we don't know the vid to flush.
>> The easy way out here would be to export dsa_port_notify_bridge_fdb_flush(),
>> add a "vid" argument to it, and let drivers call it. Thoughts?
>
> To me, this seems to be another argument in favor of
> port_vlan_fast_age. That way you would know the VIDs being flushed at
> the DSA layer, and driver writers needn't concern themselves with having
> to remember to generate the proper notifications back to the bridge.
>
>> Alternatively, if you think that cross-flushing FDBs of multiple MSTIs
>> isn't a real problem, I suppose we could keep the "port_fast_age" method.
>
> What about falling back to it if the driver doesn't support per-VLAN
> flushing? Flushing all entries will work in most cases, at the cost of
> some temporary flooding. Seems more useful than refusing the offload
> completely.

Actually now that I think about it, maybe it is more reasonable to risk
having stale entries in the VLANs where the topology changed, rather
than nuking flows in unrelated VLANs.

>>> > And since it is new code, you could require that drivers _do_ support
>>> > configuring learning before they could support MSTP. After all, we don't
>>> > want to keep legacy mechanisms in place forever.
>>> 
>>> By "configuring learning", do you mean this new fast-age-per-vid/msti,
>>> or being able to enable/disable learning per port? If it's the latter,
>>> I'm not sure I understand how those two are related.
>>
>> The code from dsa_port_set_state() which you've copied:
>>
>> 	if (!dsa_port_can_configure_learning(dp) ||
>> 	    (do_fast_age && dp->learning)) {
>>
>> has this explanation:
>>
>> 1. DSA keeps standalone ports in the FORWARDING state.
>> 2. DSA also disables address learning on standalone ports, where this is
>>    possible (dsa_port_can_configure_learning(dp) == true).
>> 3. When a port joins a bridge, it leaves its FORWARDING state from
>>    standalone mode and inherits the bridge port's BLOCKING state
>> 4. dsa_port_set_state() treats a port transition from FORWARDING to
>>    BLOCKING as a transition requiring an FDB flush
>> 5. due to (2), the FDB flush at stage (4) is in fact not needed, because
>>    the FDB of that port should already be empty. Flushing the FDB may be
>>    a costly operation for some drivers, so it is avoided if possible.
>>
>> So this is why the "dsa_port_can_configure_learning()" check is there -
>> for compatibility with drivers that can't configure learning => they
>> keep learning enabled also in standalone mode => they need an FDB flush
>> when a standalone port joins a bridge.
>>
>> What I'm saying is: for drivers that offload MSTP, let's force them to
>> get the basics right first (have configurable learning), rather than go
>> forward forever with a backwards compatibility mode.
>
> Makes sense, I'll just move it up to the initial capability check.
