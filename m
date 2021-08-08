Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3893E3D3D
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 01:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbhHHXwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 19:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhHHXwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 19:52:23 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C021C061760;
        Sun,  8 Aug 2021 16:52:04 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id bo19so2609503edb.9;
        Sun, 08 Aug 2021 16:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g+mMde5qqc4uqYbMYLo0oM6z7/xWv3oSIgHXhyEzI18=;
        b=HG3IPM1H6BKAhnp9qibICBx63Uwux2bThByqPA/ojs6WFDEThJtqm+A82+7yz1knMT
         n1Bh794jpjjyeqMlOQnMCLfj30tuJ/stefGVB0HV/aUH6h7cDeX6rMxvINcrzQbuPtsC
         VQmmlya7O7WdPHTSyxJfCrGVsqXA4dDSLohHO3GMItkSVYCnf9mRP/vtUgLTWovcRdJR
         wvT+Zx2QM8Do9ZqGZ8HTR3KtOqiORh4WN666q1ADedsufn0R3RFd1G6PqbilDRgBFtR4
         PLoOvUxOzGFGziNHgfvwn0A6gpeCtoyc3MFQsD1lF+xk6W137aSByQWIGlCRXNKRUfqa
         BwOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g+mMde5qqc4uqYbMYLo0oM6z7/xWv3oSIgHXhyEzI18=;
        b=FVm3WEyKn88ZgM2/1JY3CjJpLPEtK/c4OnBGEaLsgc1sAO620QWx6rM1psENKqkmQa
         u6MWglypeEg9JJt8HHwM4R8sfZQO6hVQ/egWnrdELQUhMGgaljdRIuZU+Ff1yM1UHpPS
         WtIB+iO6HS205IAn/bFEdTn9yjgyuv5Nxxo0TUffkHDwOxqcLffCEl6fl8hEM8af2FXH
         ogkC93TJNLi9rWvMPRVrwgJKt3xcQsokxHlBvbwFAHT2QT6fZJV2ryssFMsqHjuQKVR3
         SmGXZqft10IEIlhuAUKX5mM0eSjO10QvUDlZ4gq2C2E1Z+yzPb/ADh5GrLdXwhK+7qm9
         sqsQ==
X-Gm-Message-State: AOAM533YCtXNoytZ8C2YsLBXiD/fiYI44HA2MNmrABQxiIh751Tu4xjp
        ZhD7wO9qqqbQamM/SvHyNsQ=
X-Google-Smtp-Source: ABdhPJylExpK6vSu0VFC4Y40mLv8hd5y8/R6uN6ZHtpGeCgyB23L+D+b0vxQY52+4Tz75Gunuig9xg==
X-Received: by 2002:a05:6402:31a4:: with SMTP id dj4mr26352070edb.350.1628466722891;
        Sun, 08 Aug 2021 16:52:02 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id v12sm1572958ejq.36.2021.08.08.16.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 16:52:02 -0700 (PDT)
Date:   Mon, 9 Aug 2021 02:52:01 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Eric Woudstra <ericwouds@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt7530 fix mt7530_fdb_write vid missing ivl bit
Message-ID: <20210808235201.wvw6mjzyvcpumxgk@skbuf>
References: <20210716152213.4213-1-ericwouds@gmail.com>
 <20210808170024.228363-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210808170024.228363-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 01:00:24AM +0800, DENG Qingfang wrote:
> On Fri, Jul 16, 2021 at 05:22:11PM +0200, ericwouds@gmail.com wrote:
> > From: Eric Woudstra <37153012+ericwoud@users.noreply.github.com>
> >
> > According to reference guides mt7530 (mt7620) and mt7531:
> >
> > NOTE: When IVL is reset, MAC[47:0] and FID[2:0] will be used to
> > read/write the address table. When IVL is set, MAC[47:0] and CVID[11:0]
> > will be used to read/write the address table.
> >
> > Since the function only fills in CVID and no FID, we need to set the
> > IVL bit. The existing code does not set it.
> >
> > This is a fix for the issue I dropped here earlier:
> >
> > http://lists.infradead.org/pipermail/linux-mediatek/2021-June/025697.html
> >
> > With this patch, it is now possible to delete the 'self' fdb entry
> > manually. However, wifi roaming still has the same issue, the entry
> > does not get deleted automatically. Wifi roaming also needs a fix
> > somewhere else to function correctly in combination with vlan.
>
> Sorry to bump this up, but I think I identified the issue:
>
> Consider a VLAN-aware bridge br0, with two ports set to different PVIDs:
>
> > bridge vlan
> > port         vlan-id
> > swp0         1 PVID Egress Untagged
> > swp1         2 PVID Egress Untagged
>
> When the bridge core sends a packet to swp1, the packet will be sent to
> the CPU port of the switch as untagged because swp1 is set as "Egress
> Untagged". However if the switch uses independent VLAN learning, the CPU
> port PVID will be used to update the FDB.

Sadly the Banana Pi MT7531 reference manual I have does not appear to
cover the DSA tagging header, so I am not actually clear what
MTK_HDR_XMIT_SA_DIS does when not set. Does it default to the CPU port's
value from the PSC register?

If it does, then I expect that your patch 0b69c54c74bc ("net: dsa:
mt7530: enable assisted learning on CPU port") fixes the issue Eric was
seeing, which in turn was caused by your other patch 5e5502e012b8 ("net:
dsa: mt7530: fix roaming from DSA user ports").

> As we don't change its PVID
> (not reasonable to change it anyway), hardware learning may not update
> the correct FDB.
>
> A possible solution is always send packets as tagged when serving a
> VLAN-aware bridge.

So as usual, VLANs put the "hard" in "hardware learning on the CPU port".
I would say "a possible solution is to not attempt to learn from
CPU-injected frames unless they are sent using the tx_fwd_offload
framework"....

>
> mv88e6xxx has been using hardware learning on CPU port since commit
> d82f8ab0d874 ("net: dsa: tag_dsa: offload the bridge forwarding process"),
> does it have the same issue?

...which ensures that bridge data plane packets are always sent to the
CPU port as VLAN-tagged:

br_handle_vlan:

	/* If the skb will be sent using forwarding offload, the assumption is
	 * that the switchdev will inject the packet into hardware together
	 * with the bridge VLAN, so that it can be forwarded according to that
	 * VLAN. The switchdev should deal with popping the VLAN header in
	 * hardware on each egress port as appropriate. So only strip the VLAN
	 * header if forwarding offload is not being used.
	 */
	if (v->flags & BRIDGE_VLAN_INFO_UNTAGGED &&
	    !br_switchdev_frame_uses_tx_fwd_offload(skb))
		__vlan_hwaccel_clear_tag(skb);

Seriously, I expect that a packet injected through the CPU port will,
under normal circumstances, not default not look up the FDB, not update
the FDB, etc etc.

As long as you let the frame analyzer look in depth at the packet you do
need to ensure that it has a valid VLAN ID. Otherwise it is an actual
forwarding correctness issue and not just a "learn in wrong VLAN" issue:

https://patchwork.kernel.org/project/netdevbpf/patch/20210426170411.1789186-6-tobias@waldekranz.com/
