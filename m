Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93721331A3F
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 23:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhCHWdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 17:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhCHWdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 17:33:01 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D18C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 14:33:00 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id 2so18173895ljr.5
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 14:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Fi7RLRcupdj8PdwgXQiut7b9EIkHlG4/PE5u+VRyiqc=;
        b=Kf2uOCp2gS6RH1AWuOgPGW/8lAiplMOkBoy2PiRuMB0P8VWffcINoSzqGnQwwDMNcU
         8R2eT5lxEWL6UVTJ+RZ6DIODDhGbq040ukGu2wJUh7ixogN/j/xFR42c6taNT/HUj9OG
         bCu7usWDTfpY2hVkOzzkq5Vz25bIbvj+qSUPS1mYmcjjaEYTmYiVd6jxJ4MfbUCZcD6X
         kPKDIL1iysJoUu4bKBRAAY007aUcRpAo8u/JN8OrZus20lbR+ilsmFjzKN/DyhFnV0iy
         h68Z/aqDfXW/HqiWBgHa/6Pe5e/hgTMiMj26CcmFK6uxgfb0IRe3l3DfZPUck8PcUJ0M
         uJlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Fi7RLRcupdj8PdwgXQiut7b9EIkHlG4/PE5u+VRyiqc=;
        b=RK/okLdx0zIVJbpmqKK48P1YdY0XLIgRoS3KUM5DVrnfkbHph81TYSID4yaPgp/Fjy
         Qfe4itaT8eyMMfhDBZRpqABKQEgf+X9SGDpMQvpaybU4x5jnYCLWCOO2GkKvT3IjPLnc
         dfEioO8z7iw37zia0SZCyyQ/Eh5wopbLcXYk7k1EFpI+ogglJj36ht0BpPzI24ac94PX
         m1BjsdyrCFjjX6FUMCsFcByl5bqiMWgT2XttbegXmKHMFzNalQ7QhX4vq/e52LjsEIsm
         WnuzabaBMueMa8b9C/10s8/pG+3YiI0nZuZr/fPD+dGgf3ozqeNf9P1SwYjqsku2TJCG
         qGHQ==
X-Gm-Message-State: AOAM533nmPtd8UkFBHY56mrjORS7evNJcKAw/pqw38qZvReuriiLJS/e
        nNThUNWPLcpEaOa+P97A3XJi6pSiWX9jbQ==
X-Google-Smtp-Source: ABdhPJw0xVvw5wWvG5uVVN04RN7b3cuNunqvcDGeTvodFCAdVJP4R0lAys9/NVW126BGd5M46CDkTg==
X-Received: by 2002:a2e:96cd:: with SMTP id d13mr15391028ljj.213.1615242778418;
        Mon, 08 Mar 2021 14:32:58 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id t13sm1659278ljk.47.2021.03.08.14.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 14:32:58 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: dsa: Accept software VLANs for stacked interfaces
In-Reply-To: <20210308205031.irr6wpjp7isvu466@skbuf>
References: <20210308150405.3694678-1-tobias@waldekranz.com> <20210308150405.3694678-2-tobias@waldekranz.com> <20210308154446.ceqp56bh65bsarlt@skbuf> <20210308170027.jdehraoyntgqkjo4@skbuf> <87pn09pg9a.fsf@waldekranz.com> <20210308205031.irr6wpjp7isvu466@skbuf>
Date:   Mon, 08 Mar 2021 23:32:57 +0100
Message-ID: <87mtvdp97q.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 08, 2021 at 22:50, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Mar 08, 2021 at 09:00:49PM +0100, Tobias Waldekranz wrote:
>> Alright, we do not want to lie to the stack, got it...
>
> [...]
>
>> ...hang on, are we OK with lying or not? Yes, I guess?
>
> I'm not too happy about it. The problem in my mind, really, is that if
> we disable 'rx-vlan-filter' and we gain an 8021q upper in the meantime,
> we'll lose the .ndo_vlan_rx_add_vid call for it. This is worse in my
> opinion than saying you're going to drop unknown VLANs but not actually
> doing it.
>
>> > It's a lot easier that way, otherwise you will end up having to replay
>> > them somehow.
>> 
>> I think vlan_for_each should be enough to perform the replay when
>> toggling VLAN filtering on a port?
>
> Yes, good point about vlan_for_each, I didn't notice that, since almost
> nobody uses it, and absolutely nobody uses it for replaying VLANs in the
> RX filter, but it looks like it might be able to do the trick.
>
>> More importantly, there are other sequences that we do not guard against
>> today:
>> 
>> - Adding VID to a bridge port that is used on an 1Q upper of another
>>   bridged port.
>> 
>>     .100  br0
>>        \  / \
>>        lan0 lan1
>> 
>>     $ ip link add dev br0 type bridge vlan_filtering 1
>>     $ ip link add dev lan0.100 link lan0 type vlan id 100
>>     $ ip link set dev lan0 master br0
>>     $ ip link set dev lan1 master br0
>>     $ bridge vlan add dev lan1 vid 100 # This should fail
>> 
>>     After this sequence, the switch will forward VID 100 tagged frames
>>     between lan0 and lan1.
>
> Yes, this is not caught today. Should be trivially fixed by iterating
> over all dp->bridge_dev lowers in dsa_slave_vlan_add, when calling
> dsa_slave_vlan_check_for_8021q_uppers, not just for the specified port.
>
>> - Briding two ports that both have 1Q uppers using the same VID.
>> 
>>     .100  br0  .100
>>        \  / \  /
>>        lan0 lan1
>> 
>>     $ ip link add dev br0 type bridge vlan_filtering 1
>>     $ ip link add dev lan0.100 link lan0 type vlan id 100
>>     $ ip link add dev lan1.100 link lan1 type vlan id 100
>>     $ ip link set dev lan0 master br0
>>     $ ip link set dev lan1 master br0 # This should fail
>> 
>>     This is also allowed by DSA today, and produces the same switch
>>     config as the previous sequence.
>
> Correct, this is also not caught.
> In this case it looks like there isn't even an attempt to validate the
> VLAN configuration of the ports already in the bridge. We would probably
> have to hook into dsa_port_bridge_join, iterate through all the VLAN
> uppers of the new port, then for each VLAN upper we should construct a
> fake struct switchdev_obj_port_vlan and call dsa_slave_vlan_check_for_8021q_uppers
> again for all lowers of the bridge which we're about to join that are
> DSA ports. Patches welcome!
>
>> So in summary:
>> 
>> - Try to design some generic VLAN validation that can be used when:
>>   - Adding VLANs to standalone ports.
>>   - Adding VLANs to bridged ports.
>>   - Toggling VLAN filtering on ports.
>
> What do you mean 'generic'?

I get the sense that one reason that the mentioned cases are not caught
by the existing validation logic, is that checks are scattered in
multiple places (primarily dsa_slave_check_8021q_upper and
dsa_port_can_apply_vlan_filtering).

Ideally we should have a single function that answers the question
"given the current VLAN config, is it OK to make this one modification?"

This is all still very hand-waivy though, it might not be possible.

>> - Remove 1/2.
>> - Rework 2/2 to:
>>   - `return 0` when adding a VLAN to a non-bridged port, not -EOPNOTSUPP.
>
> Still in mv88e6xxx you mean? Well, if mv88e6xxx is still not going to
> install the VLAN to hardware, why would it lie to DSA and return 0?

Because we want the core to add the `struct vlan_vid_info` to our port's
vlan list so that we can lazy load it if/when needed. But maybe your
dynamic rx-vlan-filter patch will render that unnecessary?

>>   - Lazy load/unload VIDs from VLAN uppers when toggling filtering on a
>>     port using vlan_for_each or similar.
>
> How do you plan to do it exactly? Hook into dsa_port_vlan_filtering and:
> if vlan_filtering == false, then do vlan_for_each(..., dsa_slave_vlan_rx_kill_vid)
> if vlan_filtering == true, then do vlan_for_each(..., dsa_slave_vlan_rx_add_vid)?

I was just going to hook in to mv88e6xxx_port_vlan_filtering, call
vlan_for_each and generate an mv88e6xxx-internal call to add the
VIDs to the port and the CPU port. This does rely on rx-vlan-filter
always being enabled as the VLAN will be setup on all DSA ports at that
point, just not on any user ports.

> Basically when VLAN filtering is disabled, the VTU will only contain the
> bridge VLANs and none of the 8021q VLANs?

Yes, the switch won't be able to use the 1Q VLANs for anything useful
anyway.

> If we make this happen, then my patches for runtime toggling
> 'rx-vlan-filter' should also be needed.

I am fine with that, but I think that means that we need to solve the
replay at the DSA layer in order to setup DSA ports correctly.

>> Does that sound reasonable?
>> 
>> Are we still in net territory or is this more suited for net-next?
>
> It'll be a lot of patches, but the base logic is there already, so I
> think we could still target 'net'.
