Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E902F558E
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 01:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729864AbhANA1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 19:27:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729846AbhANAY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 19:24:57 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9039DC0617B9;
        Wed, 13 Jan 2021 16:15:09 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id e18so5630840ejt.12;
        Wed, 13 Jan 2021 16:15:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XlWfjr8XMrkEAg8D23u8wLcqUf6of5HHp8CfoujNfI8=;
        b=Z41cYbE99xDN54+2s6ZYyjhGwHWi418jYGnUv/HQxpBDv7Ovi43p/TA/yWzgtDkLVY
         QpxlLib4Y9WAceiMPSXWvOmG1lDwQqVZDI5cfIRyzk4u4W9aEn62E1JvrffhLHZLNS8x
         FEIUePvBSQ4+poQVC2aS1QWBki1/W4FcFyhcEIN/8CAX8BOQ8YqFz+3Sh1FWdPHr6y9c
         ksOrq8v5fWOMtEyo+mmchvaHJ2DNEAPiaikGK307J7NarvwfsUNNRGWHn1kM40ub2P8t
         r2mxGoOu8HAEgU5mIEALhFk69uXBa4Ke4OqJPq92/ofFy0VoG2NqL76stxbyE2om4PVp
         qj7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XlWfjr8XMrkEAg8D23u8wLcqUf6of5HHp8CfoujNfI8=;
        b=nH2MHH7PCmORJrWHFzgjZclvNTDa3kasaTksNNpDbhV8XMzMZBrTf97XTGLCbPFwb5
         HndYsLc6ZiXZbb5QQAkUwhZuts77lkCsc/WHsYdIahJ3OZcE8xYPuKJlxlsCdTexR1DT
         ezTqsSPJMlpg70MIjYlHpUXZxb73TB4SqyuLV7yt3BrY3iZCAJvwDqGQD9SX8TlHM3II
         KKx+eh2583rwXTmYrDwaDCRmcbrNG6ImIVN0U5h4fwxTu9etxLgpMHYI7BeDKFzXOWXs
         5Wkcyqv5F9qTeamvAHqxUjZUrOMKKNB2OWqMWvNYh13+LtmAzJi/gyk+dmiU881KRgnO
         vJZQ==
X-Gm-Message-State: AOAM532St2vDIrJOS1n1vcbDOS2zwFh+qqhZ3aPGVZH7Y22FpKejBZeL
        3Mmy2m6DAewelg0WgdrPb0E=
X-Google-Smtp-Source: ABdhPJxBZf6yib3Y+jACYM3LMRD7RmY4xqYFTGOor14oiqnhdHiW3He4IM2l/uBu9zkYJSe3f7nxhw==
X-Received: by 2002:a17:906:440e:: with SMTP id x14mr3341806ejo.77.1610583308305;
        Wed, 13 Jan 2021 16:15:08 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id da9sm1457482edb.84.2021.01.13.16.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 16:15:07 -0800 (PST)
Date:   Thu, 14 Jan 2021 02:15:06 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
Cc:     netdev@vger.kernel.org, Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 4/6] net: dsa: ksz: do not change tagging on del
Message-ID: <20210114001506.d2hg6b6evju3iyl6@skbuf>
References: <cover.1610540603.git.gilles.doffe@savoirfairelinux.com>
 <c3effba30b2ae979a4b7990bbf6096ca26e3de7a.1610540603.git.gilles.doffe@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3effba30b2ae979a4b7990bbf6096ca26e3de7a.1610540603.git.gilles.doffe@savoirfairelinux.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 01:45:20PM +0100, Gilles DOFFE wrote:
> If a VLAN is removed, the tagging policy should not be changed as
> still active VLANs could be impacted.
> 
> Signed-off-by: Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
> ---
>  drivers/net/dsa/microchip/ksz8795.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index 193f03ef9160..b55fb2761993 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -880,7 +880,6 @@ static void ksz8795_port_vlan_add(struct dsa_switch *ds, int port,
>  static int ksz8795_port_vlan_del(struct dsa_switch *ds, int port,
>  				 const struct switchdev_obj_port_vlan *vlan)
>  {
> -	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
>  	struct ksz_device *dev = ds->priv;
>  	u16 data, vid, pvid, new_pvid = 0;
>  	u8 fid, member, valid;
> @@ -888,8 +887,6 @@ static int ksz8795_port_vlan_del(struct dsa_switch *ds, int port,
>  	ksz_pread16(dev, port, REG_PORT_CTRL_VID, &pvid);
>  	pvid = pvid & 0xFFF;
>  
> -	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
> -
>  	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
>  		ksz8795_r_vlan_table(dev, vid, &data);
>  		ksz8795_from_vlan(data, &fid, &member, &valid);
> -- 
> 2.25.1
> 

What do you mean the tagging policy "should not be changed". Nothing is
changed, the write to PORT_REMOVE_TAG is identical to the one done on
.port_vlan_add. If anything, the egress untagging policy is reinforced
on delete, not changed...

What's the actual problem (beside for the fact that the driver is
obviously a lot more broken than you can fix through patches to "net")?
