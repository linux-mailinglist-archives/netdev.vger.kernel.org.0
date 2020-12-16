Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297E62DC2E7
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 16:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgLPPPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 10:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbgLPPPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 10:15:49 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B01C06179C
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 07:15:08 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id 23so49206998lfg.10
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 07:15:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=IAYc+jR31KeFFBH5HcfnftR8Uxwh5Ak0zm1aVdQSqts=;
        b=il+JTwQ6QgiNo6uKj13r5JzT2dIXkFFl/C5Poxtw9kg2Z4xaHgnx3NJkYK7xTKJ3yt
         G3PVwhL8s5T80JTnEeBy8L1awgVO+swYotPwR33NHds2EIwJ8LPO+bAL5d2a/CQk8bNz
         oeuZnToMHrsF4f4WL9kBj7ilIxknha0dypcVuBcQKV8XBrqYX73f/lREL9uEGmfWyCHg
         FpXu2/w8wyoh0G1REbMSmK3kK6YQq7mCJxrxq/qgQsCXyBmQUzLjpaTmP7II+2POk1OE
         0VC7AB8iFYjXSJIt6wxOhDODpWghjWDbKmuTYiT3zr1RpnmESJSdRQd+6Tg2FOzqbK8J
         76PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=IAYc+jR31KeFFBH5HcfnftR8Uxwh5Ak0zm1aVdQSqts=;
        b=F8StgJZ3fC23wwDI9/IEogRjxnNyLjcczhPCwqD96z5v97n3rbUzbYWRd1vmSfZ/CM
         SrIMoBSHXFxWrg8WjA6t6EOfD5isYazwl+qKIzl10DYcXa9kwZDs0UPo/9+rp7VHpGHK
         DsENJl08wOSecovmCjcDVtSu8UvL1efETTvkTbxhhhEV4VnozZgHlgOzfW/5OeqcAgMb
         rZh2F1Zl22gg73ahIlFU7s4xtJi20QhLTVrcINxuKGoIp1aOxdTEnllIiE+PgqS8/228
         O1NfTGK8NUhOJGmlYWl29pvOcsinvGdi00BWkOuxdsv9wFQCUOL3gmjxl6JRvCula7cE
         etiQ==
X-Gm-Message-State: AOAM530UqspAoEjed85IueDaR8I7ufKQHYpPRl49DdVRWg/zo+Ew7ii/
        klcbJGVOFXkbcUr4T4F07te8vU+YCoPJO/fh
X-Google-Smtp-Source: ABdhPJzgkMSCDdPgRWI2rEn5fSU7asUv7QMf8Az+hdtHtQ428r0P1HUGaMKdAPovtiqeWsCSYv5EXA==
X-Received: by 2002:a19:230d:: with SMTP id j13mr13788550lfj.378.1608131705151;
        Wed, 16 Dec 2020 07:15:05 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id q21sm257901lff.280.2020.12.16.07.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 07:15:03 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Ido Schimmel <idosch@idosch.org>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201214114237.GA2789489@shredder.lan>
References: <20201202091356.24075-1-tobias@waldekranz.com> <20201202091356.24075-3-tobias@waldekranz.com> <20201208112350.kuvlaxqto37igczk@skbuf> <87a6uk5apb.fsf@waldekranz.com> <20201212142622.diijil65gjkxde4n@skbuf> <878sa1h0bg.fsf@waldekranz.com> <20201214001231.nswz23hqjkf227rf@skbuf> <20201214114237.GA2789489@shredder.lan>
Date:   Wed, 16 Dec 2020 16:15:03 +0100
Message-ID: <87y2hxbx54.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 13:42, Ido Schimmel <idosch@idosch.org> wrote:
> On Mon, Dec 14, 2020 at 02:12:31AM +0200, Vladimir Oltean wrote:
>> On Sun, Dec 13, 2020 at 10:18:27PM +0100, Tobias Waldekranz wrote:
>> > On Sat, Dec 12, 2020 at 16:26, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > > On Fri, Dec 11, 2020 at 09:50:24PM +0100, Tobias Waldekranz wrote:
>> > >> 2. The issue Vladimir mentioned above. This is also a straight forward
>> > >>    fix, I have patch for tag_dsa, making sure that offload_fwd_mark is
>> > >>    never set for ports in standalone mode.
>> > >>
>> > >>    I am not sure if I should solve it like that or if we should just
>> > >>    clear the mark in dsa_switch_rcv if the dp does not have a
>> > >>    bridge_dev. I know both Vladimir and I were leaning towards each
>> > >>    tagger solving it internally. But looking at the code, I get the
>> > >>    feeling that all taggers will end up copying the same block of code
>> > >>    anyway. What do you think?
>> > >> As for this series, my intention is to make sure that (A) works as
>> > >> intended, leaving (B) for another day. Does that seem reasonable?
>> > >>
>> > >> NOTE: In the offloaded case, (B) will of course also be supported.
>> > >
>> > > Yeah, ok, one can already tell that the way I've tested this setup was
>> > > by commenting out skb->offload_fwd_mark = 1 altogether. It seems ok to
>> > > postpone this a bit.
>> > >
>> > > For what it's worth, in the giant "RX filtering for DSA switches" fiasco
>> > > https://patchwork.ozlabs.org/project/netdev/patch/20200521211036.668624-11-olteanv@gmail.com/
>> > > we seemed to reach the conclusion that it would be ok to add a new NDO
>> > > answering the question "can this interface do forwarding in hardware
>> > > towards this other interface". We can probably start with the question
>> > > being asked for L2 forwarding only.
>> >
>> > Very interesting, though I did not completely understand the VXLAN
>> > scenario laid out in that thread. I understand that OFM can not be 0,
>> > because you might have successfully forwarded to some destinations. But
>> > setting it to 1 does not smell right either. OFM=1 means "this has
>> > already been forwarded according to your current configuration" which is
>> > not completely true in this case. This is something in the middle, more
>> > like skb->offload_fwd_mark = its_complicated;
>> 
>> Very pertinent question. Given your observation that nbp_switchdev_mark_set()
>> calls dev_get_port_parent_id() with recurse=true, this means that a vxlan
>> upper should have the same parent ID as the real interface. At least the
>> theory coincides with the little practice I applied to my setup where
>> felix does not support vxlan offload:
>> 
>> I printed the p->offload_fwd_mark assigned by nbp_switchdev_mark_set:
>> ip link add br0 type bridge
>> ip link set swp1 master br0
>> [   15.887217] mscc_felix 0000:00:00.5 swp1: offload_fwd_mark 1
>> ip link add vxlan10 type vxlan id 10 group 224.10.10.10 dstport 4789 ttl 10 dev swp0
>> ip link set vxlan10 master br0
>> [  102.734390] vxlan10: offload_fwd_mark 1
>> 
>> So a clearer explanation needs to be found for how Ido's exception
>> traffic due to missing neighbor in the vxlan underlay gets re-forwarded
>> by the software bridge to the software vxlan interface. It cannot be due
>> to a mismatch of bridge port offload_fwd_mark values unless there is
>> some different logic applied for Mellanox hardware that I am not seeing.
>> So after all, it must be due to skb->offload_fwd_mark being unset?
>> 
>> To be honest, I almost expect that the Mellanox switches are "all or
>> nothing" in terms of forwarding. So if the vxlan interface (which is
>> only one of the bridge ports) could not deliver the packet, it would
>> seem cleaner to me that none of the other interfaces deliver the packet
>> either. Then the driver picks up this exception packet on the original
>> ingress interface, and the software bridge + software vxlan do the job.
>> And this means that skb->offload_fwd_mark = it_isnt_complicated.
>> 
>> But this is clearly at odds with what Ido said, that "swp0 and vxlan0 do
>> not have the same parent ID", and which was the center of his entire
>> argument. It's my fault really, I should have checked. Let's hope that
>> Ido can explain again.
>
> Problem is here:
>
> ip link add vxlan10 type vxlan id 10 group 224.10.10.10 dstport 4789 ttl 10 dev swp0
>
> We don't configure VXLAN with a bound device. In fact, we forbid it:
> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c#L46
> https://elixir.bootlin.com/linux/latest/source/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh#L182
>
> Even if we were to support a bound device, it is unlikely to be a switch
> port, but some dummy interface that we would enslave to a VRF in which
> we would like the underlay lookup to be performed. We use this with GRE
> tunnels:
> https://github.com/Mellanox/mlxsw/wiki/L3-Tunneling#general-gre-configuration
>
> Currently, underlay lookup always happens in the default VRF.
>
> VXLAN recently got support for this as well. See this series:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=79dfab43a976b76713c40222987c48e32510ebc1

How do you handle multiple VXLAN interfaces?  I.e. in this setup:

         br0
   .--' .' '. '----.
  /    /     \      \
swp0 swp1  vxlan0 vxlan1

Say that both VXLANs are offloaded, the nexthop of vxlan0 is in the
hardware ARP cache, but vxlan1's is not.

If a broadcast is received on swp0, hardware will forward to swp1 and
vxlan0, then trap the original frame to the CPU with offload_fwd_mark=1.

What prevents duplicates from being sent out through vxlan0 in that
case?

>> 
>> > Anyway, so we are essentially talking about replacing the question "do
>> > you share a parent with this netdev?" with "do you share the same
>> > hardware bridging domain as this netdev?" when choosing the port's OFM
>> > in a bridge, correct? If so, great, that would also solve the software
>> > LAG case. This would also get us one step closer to selectively
>> > disabling bridge offloading on a switchdev port.
>> 
>> Well, I cannot answer this until I fully understand the other issue
>> above - basically how is it that Mellanox switches do software
>> forwarding for exception traffic today.
>> 
>> Ido, for background, here's the relevant portion of the thread. We're
>> talking about software fallback for a bridge-over-bonding-over-DSA
>> scenario:
>> https://lore.kernel.org/netdev/87a6uk5apb.fsf@waldekranz.com/
