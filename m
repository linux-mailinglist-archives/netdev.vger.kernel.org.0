Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04CA4B8CFA
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 16:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235788AbiBPP4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 10:56:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234139AbiBPP4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 10:56:22 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7A1295FE6
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 07:56:09 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id d27so4207546wrc.6
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 07:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=f0FWdbh77E3blQAMR3QcsMYv1c4coQIeJz0QwE8ibf8=;
        b=xSItK/gecaZKTVxhNJvqgdgETgIbztk46Y2DEaANR4HjhLGUVyCfIDJ5NW8LsbPF5B
         0tHIvQK8LgAP5uyD28dXdVVXdZugwFruUPgin/5+HwBapbDO+IU+roz2GLkMdV1dmYNZ
         5FE3d9J7kGc48mm/zL3tz34LFdt2FjQNLVms5qziebXK/EwUzof8jFwNZTT6hs1YhUzn
         488SeTv5cnqIY3JsXU3693ytctMDSXMilqh8RxgkbJMdYGHClxKZBYyaVADqeDnygYmB
         F36FqJHKkfRQjoHc9ZwVyp8YdCtxC/1Xg5EX6it7lHs2yb/d8YaWIU3dC3aAQjjW4P8+
         oWqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=f0FWdbh77E3blQAMR3QcsMYv1c4coQIeJz0QwE8ibf8=;
        b=UkMKERvrgCKztq4ptH+dYYEafzJ/8nPR0NkqR3vlfhrendYEa+z3GOHVBHpym+RenH
         IB0Di0m+eThgF+ijgNBqUQRPfrSsp/w6rbu4jBYeIMVO2heDMKWAOPDV8dpkgpjoqKg3
         KmuSRPtK/0i219FO2R1x26j7Nh0bw7RInSNY3UM7KdybO+7cYsz8s6BjYTtTwsK6gOt6
         ZvphmJhtBxGuh84/dszQPw7CaGx+r65p6ntXYLAERqbJvr4C8rOfhDXKVE+JgUhUIW+h
         jt4ZOzehvcRp8ULu568zw/wUM7yupKcX2yhynlvIqdlxPwJUV7xpUKIfXeU2+8ss7hVA
         DRTg==
X-Gm-Message-State: AOAM533N6qAxfos9H25L20SezqTcg0bBKEil4nFGTyT9g5Lk1G5HT5Pa
        n9AStciyLHueLOOie82pmRh5uA==
X-Google-Smtp-Source: ABdhPJyiohGWEwFqMdnuF3sd5sc2/SSrQk+HKpsVB+VzPtMuigUHX/DKxmI8CX5nEPvKqyXg09VKmQ==
X-Received: by 2002:adf:fd4b:0:b0:1e4:9a8a:2ef7 with SMTP id h11-20020adffd4b000000b001e49a8a2ef7mr2849248wrs.659.1645026967509;
        Wed, 16 Feb 2022 07:56:07 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id f16sm15551442wmg.28.2022.02.16.07.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 07:56:06 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 0/9] net: bridge: vlan: Multiple Spanning Trees
In-Reply-To: <d59ee33c-79f9-2622-cec2-987a35f4ec1e@nvidia.com>
References: <20220216132934.1775649-1-tobias@waldekranz.com>
 <d59ee33c-79f9-2622-cec2-987a35f4ec1e@nvidia.com>
Date:   Wed, 16 Feb 2022 16:56:04 +0100
Message-ID: <87mtiqajqj.fsf@waldekranz.com>
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

On Wed, Feb 16, 2022 at 17:28, Nikolay Aleksandrov <nikolay@nvidia.com> wrote:
> On 16/02/2022 15:29, Tobias Waldekranz wrote:
>> The bridge has had per-VLAN STP support for a while now, since:
>> 
>> https://lore.kernel.org/netdev/20200124114022.10883-1-nikolay@cumulusnetworks.com/
>> 
>> The current implementation has some problems:
>> 
>> - The mapping from VLAN to STP state is fixed as 1:1, i.e. each VLAN
>>   is managed independently. This is awkward from an MSTP (802.1Q-2018,
>>   Clause 13.5) point of view, where the model is that multiple VLANs
>>   are grouped into MST instances.
>> 
>>   Because of the way that the standard is written, presumably, this is
>>   also reflected in hardware implementations. It is not uncommon for a
>>   switch to support the full 4k range of VIDs, but that the pool of
>>   MST instances is much smaller. Some examples:
>> 
>>   Marvell LinkStreet (mv88e6xxx): 4k VLANs, but only 64 MSTIs
>>   Marvell Prestera: 4k VLANs, but only 128 MSTIs
>>   Microchip SparX-5i: 4k VLANs, but only 128 MSTIs
>> 
>> - By default, the feature is enabled, and there is no way to disable
>>   it. This makes it hard to add offloading in a backwards compatible
>>   way, since any underlying switchdevs have no way to refuse the
>>   function if the hardware does not support it
>> 
>> - The port-global STP state has precedence over per-VLAN states. In
>>   MSTP, as far as I understand it, all VLANs will use the common
>>   spanning tree (CST) by default - through traffic engineering you can
>>   then optimize your network to group subsets of VLANs to use
>>   different trees (MSTI). To my understanding, the way this is
>>   typically managed in silicon is roughly:
>> 
>>   Incoming packet:
>>   .----.----.--------------.----.-------------
>>   | DA | SA | 802.1Q VID=X | ET | Payload ...
>>   '----'----'--------------'----'-------------
>>                         |
>>                         '->|\     .----------------------------.
>>                            | +--> | VID | Members | ... | MSTI |
>>                    PVID -->|/     |-----|---------|-----|------|
>>                                   |   1 | 0001001 | ... |    0 |
>>                                   |   2 | 0001010 | ... |   10 |
>>                                   |   3 | 0001100 | ... |   10 |
>>                                   '----------------------------'
>>                                                              |
>>                                .-----------------------------'
>>                                |  .------------------------.
>>                                '->| MSTI | Fwding | Lrning |
>>                                   |------|--------|--------|
>>                                   |    0 | 111110 | 111110 |
>>                                   |   10 | 110111 | 110111 |
>>                                   '------------------------'
>> 
>>   What this is trying to show is that the STP state (whether MSTP is
>>   used, or ye olde STP) is always accessed via the VLAN table. If STP
>>   is running, all MSTI pointers in that table will reference the same
>>   index in the STP stable - if MSTP is running, some VLANs may point
>>   to other trees (like in this example).
>> 
>>   The fact that in the Linux bridge, the global state (think: index 0
>>   in most hardware implementations) is supposed to override the
>>   per-VLAN state, is very awkward to offload. In effect, this means
>>   that when the global state changes to blocking, drivers will have to
>>   iterate over all MSTIs in use, and alter them all to match. This
>>   also means that you have to cache whether the hardware state is
>>   currently tracking the global state or the per-VLAN state. In the
>>   first case, you also have to cache the per-VLAN state so that you
>>   can restore it if the global state transitions back to forwarding.
>> 
>> This series adds support for an arbitrary M:N mapping of VIDs to
>> MSTIs, proposing one solution to the first issue. An example of an
>> offload implementation for mv88e6xxx is also provided. Offloading is
>> done on a best-effort basis, i.e. notifications of the relevant events
>> are generated, but there is no way for the user to see whether the
>> per-VLAN state has been offloaded or not. There is also no handling of
>> the relationship between the port-global state the the per-VLAN ditto.
>> 
>> If I was king of net/bridge/*, I would make the following additional
>> changes:
>> 
>> - By default, when a VLAN is created, assign it to MSTID 0, which
>>   would mean that no per-VLAN state is used and that packets belonging
>>   to this VLAN should be filtered according to the port-global state.
>> 
>>   This way, when a VLAN is configured to use a separate tree (setting
>>   a non-zero MSTID), an underlying switchdev could oppose it if it is
>>   not supported.
>> 
>>   Obviously, this adds an extra step for existing users of per-VLAN
>>   STP states and would thus not be backwards compatible. Maybe this
>>   means that that is impossible to do, maybe not.
>> 
>> - Swap the precedence of the port-global and the per-VLAN state,
>>   i.e. the port-global state only applies to packets belonging to
>>   VLANs that does not make use of a per-VLAN state (MSTID != 0).
>> 
>>   This would make the offloading much more natural, as you avoid all
>>   of the caching stuff described above.
>> 
>>   Again, this changes the behavior of the kernel so it is not
>>   backwards compatible. I suspect that this is less of an issue
>>   though, since my guess is that very few people rely on the old
>>   behavior.
>> 
>> Thoughts?
>> 
>
> Interesting! Would adding a new (e.g. vlan_mst_enable) option which changes the behaviour
> as described help? It can require that there are no vlans present to change 
> similar to the per-port vlan stats option.

Great idea, I did not know that that's how vlan stats worked. I will
definitely look into it, thanks!

> Also based on that option you can alter
> how the state checks are performed. For example, you can skip the initial port state
> check, then in br_vlan_allowed_ingress() you can use the port state if vlan filtering
> is disabled and mst enabled and you can avoid checking it altogether if filter && mst
> are enabled then always use the vlan mst state. Similar changes would have to happen
> for the egress path. Since we are talking about multiple tests the new MST logic can
> be hidden behind a static key for both br_handle_frame() and later stages.

Makes sense.

So should we keep the current per-VLAN state as-is then?  And bolt the
MST on to the side? I.e. should `struct net_bridge_vlan` both have `u8
state` for the current implementation _and_ a `struct br_vlan_mst *`
that is populated for VLANs tied to a non-zero MSTI?

> This set needs to read a new cache line to fetch mst ptr for all packets in the vlan fast-path,
> that is definitely undesirable. Please either cache that state in the vlan and update it when
> something changes, or think of some way which avoids that cache line in fast-path.
> Alternative would be to make that cache line dependent on the new option, so it's needed
> only when mst feature is enabled.

If we go with the approach I suggested above, then the current `u8
state` on `struct net_bridge_vlan` could be that cache, right?

With the current implementation, it is set directly - in the new MST
mode all grouped VLANs would have their states updated when updating the
MSTI's state.
