Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA3A331A71
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 23:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhCHWwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 17:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbhCHWwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 17:52:31 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866E6C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 14:52:30 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id jt13so23740205ejb.0
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 14:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5CltjBO/xz89rtUvA8o1WE5PVal2cLc/Xi1+HKHT31c=;
        b=OaRFpVy3rYtyJq0nXB43361SNRVEyKBO+hgWDsfAtXQU+KN+yUY/kC4VV/yEFuNaSo
         oMjWE8G6HN/FNPw8xcKR2XB4vQ34xnP5giHYFj4HxuUJ5LZ61uTvxMFSn9n07WeQeehw
         QO+STX69tBOeKbrVVnYH/Vzeu/Fa7f0WeK/JuV4LAgy1pgbHs0oUjkYXhnOD9v4cibfJ
         oEI+pbIA5sQZTz1dHQTkmeOHklzUvdCTKR6aeltUZ1wfeDMsrgxwsOiXr6XJgxomsIks
         YnYi2iOGDcYnqnWlVhUG9b5VkpTaK1gS4oxyAM7thfrhSPgFDBUtn+doX+h0C3pRmiEb
         KUTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5CltjBO/xz89rtUvA8o1WE5PVal2cLc/Xi1+HKHT31c=;
        b=P/0oki6/j3fIcuQLsFcVfibGiod9P7BDvmx91N+w8VSxkP/HQ9zfaL34MMFPZmAfVn
         N6PER6Q3tEBwtbI6pXkGriJWUMasQTX48t/y6MHMUtLHvWhK1Pi6LFwJk+FJ/NbFdwuE
         +YzmuCMyI3EUpVoSLwafxVl4PA9CvI6URjREi49cdKhn2BAweOx96RahH8F753kb0qZs
         pv7Q8N3vwUnxTOoZEAWU3QLJ7Wvt/WmheTWItfO3HyNp80iJVT9huvESiUw0gb/LdgLb
         9pGoc2SdUI125+NLsc36UK0w9qHPBcI6pm8EDFhfRheeoVMBp/RYXtY7LGl4hXu7UDiV
         5DBA==
X-Gm-Message-State: AOAM532xz/QjRV8zynkMx5qwxzIv7ynh4l9MyBYBeipf6gj/53sHcQl9
        ZRqaMzzH5AX/LTzGS8yP8Qfr535g1wM=
X-Google-Smtp-Source: ABdhPJyEQ8NcWqyEWAb6GG3Zajoc1Ip+iAso3TGrk6asczQEVnO+SGsXuNDLiWoacEAFtauj3vCnFA==
X-Received: by 2002:a17:906:11d1:: with SMTP id o17mr17143466eja.517.1615243949176;
        Mon, 08 Mar 2021 14:52:29 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id cx15sm8028550edb.54.2021.03.08.14.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 14:52:28 -0800 (PST)
Date:   Tue, 9 Mar 2021 00:52:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: dsa: Accept software VLANs for stacked
 interfaces
Message-ID: <20210308225227.wz54sgozq7q4dwz6@skbuf>
References: <20210308150405.3694678-1-tobias@waldekranz.com>
 <20210308150405.3694678-2-tobias@waldekranz.com>
 <20210308154446.ceqp56bh65bsarlt@skbuf>
 <20210308170027.jdehraoyntgqkjo4@skbuf>
 <87pn09pg9a.fsf@waldekranz.com>
 <20210308205031.irr6wpjp7isvu466@skbuf>
 <87mtvdp97q.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mtvdp97q.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 08, 2021 at 11:32:57PM +0100, Tobias Waldekranz wrote:
> I get the sense that one reason that the mentioned cases are not caught
> by the existing validation logic, is that checks are scattered in
> multiple places (primarily dsa_slave_check_8021q_upper and
> dsa_port_can_apply_vlan_filtering).
>
> Ideally we should have a single function that answers the question
> "given the current VLAN config, is it OK to make this one modification?"
>
> This is all still very hand-waivy though, it might not be possible.

Nope, they are not caught because they are odd corner cases that we
haven't encountered in real life usage.

> >> - Remove 1/2.
> >> - Rework 2/2 to:
> >>   - `return 0` when adding a VLAN to a non-bridged port, not -EOPNOTSUPP.
> >
> > Still in mv88e6xxx you mean? Well, if mv88e6xxx is still not going to
> > install the VLAN to hardware, why would it lie to DSA and return 0?
>
> Because we want the core to add the `struct vlan_vid_info` to our port's
> vlan list so that we can lazy load it if/when needed. But maybe your
> dynamic rx-vlan-filter patch will render that unnecessary?

Does struct mv88e6xxx_port have a VLAN list that I'm not aware of (a la
struct sja1105_private :: bridge_vlans)? If it doesn't, I was going to
send some patches to the DSA core anyway which manage the VLAN RX
filtering of the user interfaces dynamically.

> >>   - Lazy load/unload VIDs from VLAN uppers when toggling filtering on a
> >>     port using vlan_for_each or similar.
> >
> > How do you plan to do it exactly? Hook into dsa_port_vlan_filtering and:
> > if vlan_filtering == false, then do vlan_for_each(..., dsa_slave_vlan_rx_kill_vid)
> > if vlan_filtering == true, then do vlan_for_each(..., dsa_slave_vlan_rx_add_vid)?
>
> I was just going to hook in to mv88e6xxx_port_vlan_filtering, call
> vlan_for_each and generate an mv88e6xxx-internal call to add the
> VIDs to the port and the CPU port. This does rely on rx-vlan-filter
> always being enabled as the VLAN will be setup on all DSA ports at that
> point, just not on any user ports.

:D
Could you wait for a few hours and see what I'm cooking up first? There
is nothing there that is specific to mv88e6xxx, it is a problem we
should solve generally. The only issue with mv88e6xxx is that it has a
pet peeve to not offload VLANs in standalone mode, while others don't
care so much.

> > Basically when VLAN filtering is disabled, the VTU will only contain the
> > bridge VLANs and none of the 8021q VLANs?
>
> Yes, the switch won't be able to use the 1Q VLANs for anything useful
> anyway.
>
> > If we make this happen, then my patches for runtime toggling
> > 'rx-vlan-filter' should also be needed.
>
> I am fine with that, but I think that means that we need to solve the
> replay at the DSA layer in order to setup DSA ports correctly.

Yup, testing them right now.
