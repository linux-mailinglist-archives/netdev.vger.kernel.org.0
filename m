Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62EF3DF324
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhHCQtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbhHCQtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:49:08 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6191CC061757;
        Tue,  3 Aug 2021 09:48:56 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id nd39so37353223ejc.5;
        Tue, 03 Aug 2021 09:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q30axrIyLL4BtFH1Mw+B/tDX/rCRSYfrJS59KMTeQ8s=;
        b=P7ct2B3v9t670PAGVpPO8Vk2qSv93bkzFCcLJaKXej/CeItell69wsIeju8Or8U/tT
         5//UKVTPUZh1byle4XyGqUKjco57sU6QWNLEAJC/zv5UB5Q00yutrwJmC8Nw3BimXKcU
         gTWOcct1UB10v6AXN3G+y+zbA52vdVBQYMOzrA7sFlW9H0E4PnZm77awNvVe+Ffd8lu2
         UvH+Y9GcWzEVMowdhktusQGuZ0PYArCpv2fhAF5h8N722/55Hteuiu3llXvJq52lkvWN
         NrUB9UAnYH2T2xxqV9ZBfQtDJuc8aORfkcv57aPQlEGkFHFFlIxhZ6d8V53xmpkSSj66
         ZrbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q30axrIyLL4BtFH1Mw+B/tDX/rCRSYfrJS59KMTeQ8s=;
        b=VNjazQKqd6PhNaBAYZ9LDfGqg4DnyVIzz9vrrE1eZqnTF8uSZW5OD3yt/LILc09l3D
         lTa1v0H6qBeFUHtx24FV44gIk2me+9vtrwlpuOur3x0CfKhcTIaf+hv98+ScpFZkDRje
         Ux++xZUm+tYVkUtWr/QHsMvKNfu1Vjk/Aij0az+Af47mqaFP5kypk4XP7OXbFbrPZXwj
         GwAnuDgonRRppTQtWP3pE+Yweo6xqPuBjR7nkfXkoEiwmxlSPtYf/an91Uk2mDiMUhnd
         d4sh7t1kQ+aZly/kzE4Kv/xgAio6nEtv+2WFti7VErIPiCUk5QWLVtbcP8+Hmcp0qDUz
         6R7g==
X-Gm-Message-State: AOAM530pXmrjSlYKELMR0rAOmj71tbZRy1jwwsOwNEo4fiDccqsRH8zh
        tWDFshZNcgQASBEjqyJC4cI=
X-Google-Smtp-Source: ABdhPJx6UDh2RjFJRugCCFz3BvCoMW8PtfK9zUqGIuey6Y56nN6TTzWv83y+3gtmWv0ZDkl5sQ5KPw==
X-Received: by 2002:a17:906:2990:: with SMTP id x16mr21246522eje.554.1628009334973;
        Tue, 03 Aug 2021 09:48:54 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id c14sm6448976ejb.78.2021.08.03.09.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:48:54 -0700 (PDT)
Date:   Tue, 3 Aug 2021 19:48:53 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Woudstra <ericwouds@gmail.com>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: Re: [PATCH net-next v2 2/4] net: dsa: mt7530: use independent VLAN
 learning on VLAN-unaware bridges
Message-ID: <20210803164853.gxw4zfxmmgs2kgry@skbuf>
References: <20210803160405.3025624-1-dqfext@gmail.com>
 <20210803160405.3025624-3-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803160405.3025624-3-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 12:04:02AM +0800, DENG Qingfang wrote:
> Consider the following bridge configuration, where bond0 is not
> offloaded:
> 
>          +-- br0 --+
>         / /   |     \
>        / /    |      \
>       /  |    |     bond0
>      /   |    |     /   \
>    swp0 swp1 swp2 swp3 swp4
>      .        .       .
>      .        .       .
>      A        B       C
> 
> Ideally, when the switch receives a packet from swp3 or swp4, it should
> forward the packet to the CPU, according to the port matrix and unknown
> unicast flood settings.
> 
> But packet loss will happen if the destination address is at one of the
> offloaded ports (swp0~2). For example, when client C sends a packet to
> A, the FDB lookup will indicate that it should be forwarded to swp0, but
> the port matrix of swp3 and swp4 is configured to only allow the CPU to
> be its destination, so it is dropped.
> 
> However, this issue does not happen if the bridge is VLAN-aware. That is
> because VLAN-aware bridges use independent VLAN learning, i.e. use VID
> for FDB lookup, on offloaded ports. As swp3 and swp4 are not offloaded,
> shared VLAN learning with default filter ID of 0 is used instead. So the
> lookup for A with filter ID 0 never hits and the packet can be forwarded
> to the CPU.
> 
> In the current code, only two combinations were used to toggle user
> ports' VLAN awareness: one is PCR.PORT_VLAN set to port matrix mode with
> PVC.VLAN_ATTR set to transparent port, the other is PCR.PORT_VLAN set to
> security mode with PVC.VLAN_ATTR set to user port.
> 
> It turns out that only PVC.VLAN_ATTR contributes to VLAN awareness, and
> port matrix mode just skips the VLAN table lookup. The reference manual
> is somehow misleading when describing PORT_VLAN modes. It states that
> PORT_MEM (VLAN port member) is used for destination if the VLAN table
> lookup hits, but actually **PORT_MEM & PORT_MATRIX** (bitwise AND of
> VLAN port member and port matrix) is used instead, which means we can
> have two or more separate VLAN-aware bridges with the same PVID and
> traffic won't leak between them.
> 
> Therefore, to solve this, enable independent VLAN learning with PVID 0
> on VLAN-unaware bridges, by setting their PCR.PORT_VLAN to fallback
> mode, while leaving standalone ports in port matrix mode. The CPU port
> is always set to fallback mode to serve those bridges.
> 
> During testing, it is found that FDB lookup with filter ID of 0 will
> also hit entries with VID 0 even with independent VLAN learning. To
> avoid that, install all VLANs with filter ID of 1.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
> v1 -> v2: use FID enum instead of hardcoding.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

> @@ -1629,11 +1651,12 @@ mt7530_port_vlan_del(struct dsa_switch *ds, int port,
>  	/* PVID is being restored to the default whenever the PVID port
>  	 * is being removed from the VLAN.
>  	 */
> -	if (pvid == vlan->vid)
> -		pvid = G0_PORT_VID_DEF;
> +	if (priv->ports[port].pvid == vlan->vid) {
> +		priv->ports[port].pvid = G0_PORT_VID_DEF;
> +		mt7530_rmw(priv, MT7530_PPBV1_P(port), G0_PORT_VID_MASK,
> +			   G0_PORT_VID_DEF);
> +	}

After this patch set gets merged, can you also please take a look at the
following:

Documentation/networking/switchdev.rst says:

When the bridge has VLAN filtering enabled and a PVID is not configured on the
ingress port, untagged and 802.1p tagged packets must be dropped. When the bridge
has VLAN filtering enabled and a PVID exists on the ingress port, untagged and
priority-tagged packets must be accepted and forwarded according to the
bridge's port membership of the PVID VLAN. When the bridge has VLAN filtering
disabled, the presence/lack of a PVID should not influence the packet
forwarding decision.

I'm not sure if this happens or not with mt7530, since the driver
attempts to change the pvid back to 0. You are not changing this
behavior in this series, so no reason to deal with it as part of it.

>  
> -	mt7530_rmw(priv, MT7530_PPBV1_P(port), G0_PORT_VID_MASK, pvid);
> -	priv->ports[port].pvid = pvid;
>  
>  	mutex_unlock(&priv->reg_mutex);
>  
