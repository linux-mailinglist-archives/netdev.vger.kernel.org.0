Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC1D3318E0
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 21:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhCHUu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 15:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbhCHUue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 15:50:34 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FF9C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 12:50:34 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id t1so16784249eds.7
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 12:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j3FeyL6HI67Gc+Um+RtwPaslm9FPsxGL6vzC3YK4dXU=;
        b=JqdHh6LLGLh+UEvRFVjP41xvLrfQRu1rRAB+iTqQrnnKZ9rXWuWOrgmMeoxrRBsm3r
         FOzymNrjQHECaaL6Iaamb5Z2eNdjiiFPiDLVN70gukiD4Plm8znHk+hIRKTsX4tRXdQR
         M9CvHJIr/QmT6LkaydC0K8Eu20qKZ30FuvNjGgosM0NFJAP7CXqzMEQORHweXvWwyGgG
         uBvu3LxtayRUFvT/kbyfDJLR5AP5ff1Vw4z6AprINrX5YzUl4r5HQ3sM/jRdWg8MMams
         3xBjTQHprFV3xAEufVN1ucHqi8V8BTceyIa/ZrfE245u4xHjUIOXIoXmtdKu/YkAOl/c
         7TYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j3FeyL6HI67Gc+Um+RtwPaslm9FPsxGL6vzC3YK4dXU=;
        b=cSs7I+gmOA6M9G2d5fUVOrLt0Bfc9n41G2q461hDxX+KkBKMvzEcQUrkloKm+bymfe
         w84qrwLAn2KOSM55RW8lqEYPWZ4oEEpFqOZJwAp1dGUF47RAsr37gfUUU1ZXcfl2rJm8
         eg937XXUxmFtGS8X2eNtDV06vzgWYMrOC32Ts7/Ws6P1iubFd9EtuZn91iUrtMxsEKWO
         dT0J8h0fWxzEuPiRF1metMAD3MRUsFaAIhsIjwVFeLWNDz4O2o9CyCQwrz7wnIh0Hfhm
         FLuZ2ub+FlXsYlOX8Dtzeyk/Fh/cCdPl5QiGjr/sJVtrtc18sBmRDb6Tb644/ZleRZNj
         QRxA==
X-Gm-Message-State: AOAM531z6lPxez6BGFsSnpH8nj9ozFWY6xna1gIt8K47RI26GJeSoi9K
        H1+PnQfqbpsDQvEVASTgwAU=
X-Google-Smtp-Source: ABdhPJzOGUNsspYraoSqhAj0J1Mr1mVCBX3+NmMgECPT0gefyfNAT5ZTmq/1wu8KqEBtEeSlrC8mqQ==
X-Received: by 2002:aa7:c907:: with SMTP id b7mr441952edt.37.1615236632780;
        Mon, 08 Mar 2021 12:50:32 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id k18sm3294381ejo.91.2021.03.08.12.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 12:50:32 -0800 (PST)
Date:   Mon, 8 Mar 2021 22:50:31 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: dsa: Accept software VLANs for stacked
 interfaces
Message-ID: <20210308205031.irr6wpjp7isvu466@skbuf>
References: <20210308150405.3694678-1-tobias@waldekranz.com>
 <20210308150405.3694678-2-tobias@waldekranz.com>
 <20210308154446.ceqp56bh65bsarlt@skbuf>
 <20210308170027.jdehraoyntgqkjo4@skbuf>
 <87pn09pg9a.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pn09pg9a.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 08, 2021 at 09:00:49PM +0100, Tobias Waldekranz wrote:
> Alright, we do not want to lie to the stack, got it...

[...]

> ...hang on, are we OK with lying or not? Yes, I guess?

I'm not too happy about it. The problem in my mind, really, is that if
we disable 'rx-vlan-filter' and we gain an 8021q upper in the meantime,
we'll lose the .ndo_vlan_rx_add_vid call for it. This is worse in my
opinion than saying you're going to drop unknown VLANs but not actually
doing it.

> > It's a lot easier that way, otherwise you will end up having to replay
> > them somehow.
> 
> I think vlan_for_each should be enough to perform the replay when
> toggling VLAN filtering on a port?

Yes, good point about vlan_for_each, I didn't notice that, since almost
nobody uses it, and absolutely nobody uses it for replaying VLANs in the
RX filter, but it looks like it might be able to do the trick.

> More importantly, there are other sequences that we do not guard against
> today:
> 
> - Adding VID to a bridge port that is used on an 1Q upper of another
>   bridged port.
> 
>     .100  br0
>        \  / \
>        lan0 lan1
> 
>     $ ip link add dev br0 type bridge vlan_filtering 1
>     $ ip link add dev lan0.100 link lan0 type vlan id 100
>     $ ip link set dev lan0 master br0
>     $ ip link set dev lan1 master br0
>     $ bridge vlan add dev lan1 vid 100 # This should fail
> 
>     After this sequence, the switch will forward VID 100 tagged frames
>     between lan0 and lan1.

Yes, this is not caught today. Should be trivially fixed by iterating
over all dp->bridge_dev lowers in dsa_slave_vlan_add, when calling
dsa_slave_vlan_check_for_8021q_uppers, not just for the specified port.

> - Briding two ports that both have 1Q uppers using the same VID.
> 
>     .100  br0  .100
>        \  / \  /
>        lan0 lan1
> 
>     $ ip link add dev br0 type bridge vlan_filtering 1
>     $ ip link add dev lan0.100 link lan0 type vlan id 100
>     $ ip link add dev lan1.100 link lan1 type vlan id 100
>     $ ip link set dev lan0 master br0
>     $ ip link set dev lan1 master br0 # This should fail
> 
>     This is also allowed by DSA today, and produces the same switch
>     config as the previous sequence.

Correct, this is also not caught.
In this case it looks like there isn't even an attempt to validate the
VLAN configuration of the ports already in the bridge. We would probably
have to hook into dsa_port_bridge_join, iterate through all the VLAN
uppers of the new port, then for each VLAN upper we should construct a
fake struct switchdev_obj_port_vlan and call dsa_slave_vlan_check_for_8021q_uppers
again for all lowers of the bridge which we're about to join that are
DSA ports. Patches welcome!

> So in summary:
> 
> - Try to design some generic VLAN validation that can be used when:
>   - Adding VLANs to standalone ports.
>   - Adding VLANs to bridged ports.
>   - Toggling VLAN filtering on ports.

What do you mean 'generic'?

> - Remove 1/2.
> - Rework 2/2 to:
>   - `return 0` when adding a VLAN to a non-bridged port, not -EOPNOTSUPP.

Still in mv88e6xxx you mean? Well, if mv88e6xxx is still not going to
install the VLAN to hardware, why would it lie to DSA and return 0?

>   - Lazy load/unload VIDs from VLAN uppers when toggling filtering on a
>     port using vlan_for_each or similar.

How do you plan to do it exactly? Hook into dsa_port_vlan_filtering and:
if vlan_filtering == false, then do vlan_for_each(..., dsa_slave_vlan_rx_kill_vid)
if vlan_filtering == true, then do vlan_for_each(..., dsa_slave_vlan_rx_add_vid)?
Basically when VLAN filtering is disabled, the VTU will only contain the
bridge VLANs and none of the 8021q VLANs?

If we make this happen, then my patches for runtime toggling
'rx-vlan-filter' should also be needed.

> Does that sound reasonable?
> 
> Are we still in net territory or is this more suited for net-next?

It'll be a lot of patches, but the base logic is there already, so I
think we could still target 'net'.
