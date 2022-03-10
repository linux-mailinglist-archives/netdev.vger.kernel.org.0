Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC6BC4D4E17
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 17:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240316AbiCJQGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 11:06:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240325AbiCJQGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 11:06:42 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE3E186BB0
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 08:05:39 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id q10so8375690ljc.7
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 08:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=a47/kfMIXmMimdkS0oL0JoxaVtTsUq4puZeDbeGUm9Y=;
        b=04IWU311iyNWvLh+4z6efV3IVimCg+0iXV/HO6uNNlDwrOjW8ZhyHR4SuudlVDuTum
         gqZVmZReaIp6IBpYdIONB8k97GEYu3RMgnjWcytVYtlZC+m5/D3tZZOk9RtPgWsgRTX9
         5S0ShUCrhTY36HShqYZB/KcEFIsfQcgRXYYrDkyXF+P7qHqVkEiTgiaw/eqJcRLMaxLz
         oYgakxqRrR/MCiS3Zt8tB2qNRm7bUSX94KJjWKWXyDSYUkgbhRDJp4aMpxmIiUWlH9n5
         ZtSV23o6uIaELOrquC+AVpftGUgiYGUIKp4YM4X6sEZVQ/gBkfUqwR+wNuQNrKL6gYrz
         JKVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=a47/kfMIXmMimdkS0oL0JoxaVtTsUq4puZeDbeGUm9Y=;
        b=DcwCRz8MQaD1DFq9Pv2bXBgCsZy//PvzpOFh53EmP5ESzjhOIIQQYyWnF6l3r1pLZc
         Z75heq9wTIirQE+eLJ258MbM2vqRJe+cvQT0glKKVGIx+LpxNC3BaavUthKljr9tVIrZ
         V3ccxSppoXV7IanNq2/6IZS1DSbyfFIR+U+11/HGNwuFOo6fR6zyFYUGYXoHQw3jqzge
         VQcEn9Kw9xrxaqovF05P8PKW0MqIO6Z07JUeoD07yfAv8Y53uRRvdQxkzSJSUFJic9ME
         8fq1FiAohj4FMp5P7ZXqMzV0RM/cSu/0/jG3RF1BztDvtfEAWqxl49XsA4dK7IGA9GAM
         eGVg==
X-Gm-Message-State: AOAM531+zGTqYyzAT8i7M+VXdvBdEa036pdsV+B3392WIvqV4akTUJJ4
        1cz9UD41LyPqOXKVIyprVmLWhA==
X-Google-Smtp-Source: ABdhPJzx3mtbb/gT8X71tN1JhdwgyQSxq7uztMR3ML5AdHZG7wEGIrsGIXSDxImZa1L96XG2jyoXbg==
X-Received: by 2002:a2e:b0cc:0:b0:235:dcdf:e6e9 with SMTP id g12-20020a2eb0cc000000b00235dcdfe6e9mr3635773ljl.88.1646928337313;
        Thu, 10 Mar 2022 08:05:37 -0800 (PST)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id bu20-20020a056512169400b0043eaf37af75sm1045976lfb.199.2022.03.10.08.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 08:05:36 -0800 (PST)
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
In-Reply-To: <20220310103509.g35syl776kyh5j2n@skbuf>
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301100321.951175-8-tobias@waldekranz.com>
 <20220303222055.7a5pr4la3wmuuekc@skbuf> <87mthymblh.fsf@waldekranz.com>
 <20220310103509.g35syl776kyh5j2n@skbuf>
Date:   Thu, 10 Mar 2022 17:05:35 +0100
Message-ID: <87h785n67k.fsf@waldekranz.com>
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

On Thu, Mar 10, 2022 at 12:35, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Thu, Mar 10, 2022 at 09:54:34AM +0100, Tobias Waldekranz wrote:
>> >> +	if (!dsa_port_can_configure_learning(dp) || dp->learning) {
>> >> +		switch (state->state) {
>> >> +		case BR_STATE_DISABLED:
>> >> +		case BR_STATE_BLOCKING:
>> >> +		case BR_STATE_LISTENING:
>> >> +			/* Ideally we would only fast age entries
>> >> +			 * belonging to VLANs controlled by this
>> >> +			 * MST.
>> >> +			 */
>> >> +			dsa_port_fast_age(dp);
>> >
>> > Does mv88e6xxx support this? If it does, you might just as well
>> > introduce another variant of ds->ops->port_fast_age() for an msti.
>> 
>> You can limit ATU operations to a particular FID. So the way I see it we
>> could either have:
>> 
>> int (*port_vlan_fast_age)(struct dsa_switch *ds, int port, u16 vid)
>> 
>> + Maybe more generic. You could imagine there being a way to trigger
>>   this operation from userspace for example.
>> - We would have to keep the VLAN<->MSTI mapping in the DSA layer in
>>   order to be able to do the fan-out in dsa_port_set_mst_state.
>> 
>> or:
>> 
>> int (*port_msti_fast_age)(struct dsa_switch *ds, int port, u16 msti)
>> 
>> + Let's the mapping be an internal affair in the driver.
>> - Perhaps, less generically useful.
>> 
>> Which one do you prefer? Or is there a hidden third option? :)
>
> Yes, I was thinking of "port_msti_fast_age". I don't see a cheap way of
> keeping VLAN to MSTI associations in the DSA layer. Only if we could
> retrieve this mapping from the bridge layer - maybe with something
> analogous to br_vlan_get_info(), but br_mst_get_info(), and this gets
> passed a VLAN_N_VID sized bitmap, which the bridge populates with ones
> and zeroes.

That can easily be done. Given that, should we go for port_vlan_fast_age
instead? port_msti_fast_age feels like an awkward interface, since I
don't think there is any hardware out there that can actually perform
that operation without internally fanning it out over all affected VIDs
(or FIDs in the case of mv88e6xxx).

> The reason why I asked for this is because I'm not sure of the
> implications of flushing the entire FDB of the port for a single MSTP
> state change. It would trigger temporary useless flooding in other MSTIs
> at the very least. There isn't any backwards compatibility concern to
> speak of, so we can at least try from the beginning to limit the
> flushing to the required VLANs.

Aside from the performance implications of flows being temporarily
flooded I don't think there are any.

I suppose if you've disabled flooding of unknown unicast on that port,
you would loose the flow until you see some return traffic (or when one
side gives up and ARPs). While somewhat esoteric, it would be nice to
handle this case if the hardware supports it.

> What I didn't think about, and will be a problem, is
> dsa_port_notify_bridge_fdb_flush() - we don't know the vid to flush.
> The easy way out here would be to export dsa_port_notify_bridge_fdb_flush(),
> add a "vid" argument to it, and let drivers call it. Thoughts?

To me, this seems to be another argument in favor of
port_vlan_fast_age. That way you would know the VIDs being flushed at
the DSA layer, and driver writers needn't concern themselves with having
to remember to generate the proper notifications back to the bridge.

> Alternatively, if you think that cross-flushing FDBs of multiple MSTIs
> isn't a real problem, I suppose we could keep the "port_fast_age" method.

What about falling back to it if the driver doesn't support per-VLAN
flushing? Flushing all entries will work in most cases, at the cost of
some temporary flooding. Seems more useful than refusing the offload
completely.

>> > And since it is new code, you could require that drivers _do_ support
>> > configuring learning before they could support MSTP. After all, we don't
>> > want to keep legacy mechanisms in place forever.
>> 
>> By "configuring learning", do you mean this new fast-age-per-vid/msti,
>> or being able to enable/disable learning per port? If it's the latter,
>> I'm not sure I understand how those two are related.
>
> The code from dsa_port_set_state() which you've copied:
>
> 	if (!dsa_port_can_configure_learning(dp) ||
> 	    (do_fast_age && dp->learning)) {
>
> has this explanation:
>
> 1. DSA keeps standalone ports in the FORWARDING state.
> 2. DSA also disables address learning on standalone ports, where this is
>    possible (dsa_port_can_configure_learning(dp) == true).
> 3. When a port joins a bridge, it leaves its FORWARDING state from
>    standalone mode and inherits the bridge port's BLOCKING state
> 4. dsa_port_set_state() treats a port transition from FORWARDING to
>    BLOCKING as a transition requiring an FDB flush
> 5. due to (2), the FDB flush at stage (4) is in fact not needed, because
>    the FDB of that port should already be empty. Flushing the FDB may be
>    a costly operation for some drivers, so it is avoided if possible.
>
> So this is why the "dsa_port_can_configure_learning()" check is there -
> for compatibility with drivers that can't configure learning => they
> keep learning enabled also in standalone mode => they need an FDB flush
> when a standalone port joins a bridge.
>
> What I'm saying is: for drivers that offload MSTP, let's force them to
> get the basics right first (have configurable learning), rather than go
> forward forever with a backwards compatibility mode.

Makes sense, I'll just move it up to the initial capability check.
