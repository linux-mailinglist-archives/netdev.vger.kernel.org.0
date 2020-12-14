Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C66B2D915D
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 01:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436459AbgLNANi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 19:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731679AbgLNANP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 19:13:15 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0E9C0613CF
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 16:12:34 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id j22so2171829eja.13
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 16:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tc8dqravZW9oaiOtjJlocEUuojnhomLFhz7EWb5qIZA=;
        b=B2M+kq1hw8Em+GzMCe5oPih4wspRHKIEEVnkE7yNDFlmG9qyG5STWzS42GW+xnRhno
         RRWnw0buY3O/k8ZnuJ882DnIv8C2alBSHWoCOYH35PQkaTteQTmo3uVfbQ9MlWfLWSTp
         JATP/dJq8YQ2BOzotbnP4GeqmoKBzFHkkeCf4fwMy+GieidZpvcwohhsEhx9JRpxU/wa
         aZ32YuotPkdrPiPr9jd8W04NbMoF3F/lbizsH8z7dGYflzmWtrbKczj78fjiugyjSFza
         TSCWqs6SJbaLbrAIosJDAQTSQMXs+jMXu4aDTtLpFFr19JgCjZD7Tn9qx8m9qSJ5AKy8
         qT9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tc8dqravZW9oaiOtjJlocEUuojnhomLFhz7EWb5qIZA=;
        b=jNNL1pnGDMERcalkDQz3Q9xKQS4YLoN9OqSjyZ+0miRTjh6XwkdokzkzY3gRh617FS
         tZAkEthduKWW3uEs7xJfAacGN2NPkkxRwgExXFMPvQblfdawHnGsq4u7skL6qnjnPBJr
         2fFrWL7GpCn88ckeHlo3Mjpp5msPWvf9dCNKmFBiXtOBWQxgCuPmQBq1K6F1NtXjpBbe
         mjjgS5nrneHOT5BywYBGXQ4hzRJsm+I0cYSQrpUORjm1yJenJn1BhMRPEZCBXlD3LakC
         JIsW7kdcaQVzCAGjOgFIj2lfusH5qkhoF545iOIsvhIjEjH4qygGu2pJptAmp/JhT3uj
         SdRA==
X-Gm-Message-State: AOAM532UnAHFJH1mkvMLIdijXl9APAP15FYYjKVPkxiyGlV1Y7ybm8sz
        j3LJOZlgr2WjkrHcj3qSKGQ=
X-Google-Smtp-Source: ABdhPJzUxsTReV0K8HmezIzK9KnM0BwTo3ECevNTv7fzzmjIBekvAsqCvbO4jUdcH2wbJVhHSW27+Q==
X-Received: by 2002:a17:906:fb9b:: with SMTP id lr27mr20838948ejb.175.1607904753102;
        Sun, 13 Dec 2020 16:12:33 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id r7sm14044570edv.39.2020.12.13.16.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 16:12:32 -0800 (PST)
Date:   Mon, 14 Dec 2020 02:12:31 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201214001231.nswz23hqjkf227rf@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
 <20201208112350.kuvlaxqto37igczk@skbuf>
 <87a6uk5apb.fsf@waldekranz.com>
 <20201212142622.diijil65gjkxde4n@skbuf>
 <878sa1h0bg.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878sa1h0bg.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 10:18:27PM +0100, Tobias Waldekranz wrote:
> On Sat, Dec 12, 2020 at 16:26, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Fri, Dec 11, 2020 at 09:50:24PM +0100, Tobias Waldekranz wrote:
> >> 2. The issue Vladimir mentioned above. This is also a straight forward
> >>    fix, I have patch for tag_dsa, making sure that offload_fwd_mark is
> >>    never set for ports in standalone mode.
> >>
> >>    I am not sure if I should solve it like that or if we should just
> >>    clear the mark in dsa_switch_rcv if the dp does not have a
> >>    bridge_dev. I know both Vladimir and I were leaning towards each
> >>    tagger solving it internally. But looking at the code, I get the
> >>    feeling that all taggers will end up copying the same block of code
> >>    anyway. What do you think?
> >> As for this series, my intention is to make sure that (A) works as
> >> intended, leaving (B) for another day. Does that seem reasonable?
> >>
> >> NOTE: In the offloaded case, (B) will of course also be supported.
> >
> > Yeah, ok, one can already tell that the way I've tested this setup was
> > by commenting out skb->offload_fwd_mark = 1 altogether. It seems ok to
> > postpone this a bit.
> >
> > For what it's worth, in the giant "RX filtering for DSA switches" fiasco
> > https://patchwork.ozlabs.org/project/netdev/patch/20200521211036.668624-11-olteanv@gmail.com/
> > we seemed to reach the conclusion that it would be ok to add a new NDO
> > answering the question "can this interface do forwarding in hardware
> > towards this other interface". We can probably start with the question
> > being asked for L2 forwarding only.
>
> Very interesting, though I did not completely understand the VXLAN
> scenario laid out in that thread. I understand that OFM can not be 0,
> because you might have successfully forwarded to some destinations. But
> setting it to 1 does not smell right either. OFM=1 means "this has
> already been forwarded according to your current configuration" which is
> not completely true in this case. This is something in the middle, more
> like skb->offload_fwd_mark = its_complicated;

Very pertinent question. Given your observation that nbp_switchdev_mark_set()
calls dev_get_port_parent_id() with recurse=true, this means that a vxlan
upper should have the same parent ID as the real interface. At least the
theory coincides with the little practice I applied to my setup where
felix does not support vxlan offload:

I printed the p->offload_fwd_mark assigned by nbp_switchdev_mark_set:
ip link add br0 type bridge
ip link set swp1 master br0
[   15.887217] mscc_felix 0000:00:00.5 swp1: offload_fwd_mark 1
ip link add vxlan10 type vxlan id 10 group 224.10.10.10 dstport 4789 ttl 10 dev swp0
ip link set vxlan10 master br0
[  102.734390] vxlan10: offload_fwd_mark 1

So a clearer explanation needs to be found for how Ido's exception
traffic due to missing neighbor in the vxlan underlay gets re-forwarded
by the software bridge to the software vxlan interface. It cannot be due
to a mismatch of bridge port offload_fwd_mark values unless there is
some different logic applied for Mellanox hardware that I am not seeing.
So after all, it must be due to skb->offload_fwd_mark being unset?

To be honest, I almost expect that the Mellanox switches are "all or
nothing" in terms of forwarding. So if the vxlan interface (which is
only one of the bridge ports) could not deliver the packet, it would
seem cleaner to me that none of the other interfaces deliver the packet
either. Then the driver picks up this exception packet on the original
ingress interface, and the software bridge + software vxlan do the job.
And this means that skb->offload_fwd_mark = it_isnt_complicated.

But this is clearly at odds with what Ido said, that "swp0 and vxlan0 do
not have the same parent ID", and which was the center of his entire
argument. It's my fault really, I should have checked. Let's hope that
Ido can explain again.

> Anyway, so we are essentially talking about replacing the question "do
> you share a parent with this netdev?" with "do you share the same
> hardware bridging domain as this netdev?" when choosing the port's OFM
> in a bridge, correct? If so, great, that would also solve the software
> LAG case. This would also get us one step closer to selectively
> disabling bridge offloading on a switchdev port.

Well, I cannot answer this until I fully understand the other issue
above - basically how is it that Mellanox switches do software
forwarding for exception traffic today.

Ido, for background, here's the relevant portion of the thread. We're
talking about software fallback for a bridge-over-bonding-over-DSA
scenario:
https://lore.kernel.org/netdev/87a6uk5apb.fsf@waldekranz.com/
