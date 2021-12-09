Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9D846F705
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 23:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbhLIWpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 17:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233584AbhLIWpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 17:45:23 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AC0C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 14:41:49 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id y12so23757681eda.12
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 14:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WT84FX4dIfhjlv135pxiyiLGpkswAmwkh9G0Vf3xyFo=;
        b=ZpuUfmohx6QxHhqEoYZ+m9VEJ0zDOpklWlfc/yt7n4wezoURDmroblEAANADeU7/iZ
         KL2yRpRtQ2qDESBhfTRZyf9/pVnvTMPuiK0gEyF4J6E7EPUfK8k2jkTxNzZ+PHxTqaXi
         1JWQpNARi61BF4NrDdSNs406vs7afOcwHGUQfQ4nWV9q8HqHopiLcBY5pMvNutfUHot0
         LN5pYS+7Q5Fiz5C9/btKIedWyecX2ULq4TvrFiNisc2Qp5Nopb9Hwi9RJRVdry56NOrk
         cxg1eaM0N1GuL8UxmLBwfoxRGYfXvGkiGqEF/WNcMdTZr5gqgZY+utUPGk+mwYf2/tsN
         XiNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WT84FX4dIfhjlv135pxiyiLGpkswAmwkh9G0Vf3xyFo=;
        b=07JTMQdVk/tUjAvXUVbj/nG65ltS3+mhortSzIurppnERMUlBLJk+zBUJ+fTm+eS/2
         FrPjrKIet9aYJ6bi29TitDcf0NVvFCtsQgk42DRMlUpX+rRj1f7XU0g3dSJLoFrAfv8A
         TTH/zwXebqsAPi1B3sAXcYaJ30cNvJP8J+k5V2KKnLdTitbjRKDVNVWW316XuGcYd80n
         0BMK6l0ECj1k2jKB5cChSDBa7J3HcZaXrvmuQALoXo52mJ6rj2X5SGhZiOkEd8MB/Kgz
         iWdRZEXg7glJguU+QOA/m7KRonGXZekH3icH/qK4NFzqouqutGZE9Uus25Usi/Q2XVLW
         5SzA==
X-Gm-Message-State: AOAM531EKFn/JrgrmM2ooYkbGav/9Fpt8ir0d97pJ9tTwxPbSK2lvSDT
        Z0r/0EUh+C66/r6xdU+9lVvXfkZyPgc=
X-Google-Smtp-Source: ABdhPJzZXkePKmb2Y7IaIfIi0hjBKRijquewKMT0RwgW3+ULoWRUNmC1d5irvbULqL4Yi3SLyvVimg==
X-Received: by 2002:a17:906:1499:: with SMTP id x25mr18612255ejc.474.1639089708155;
        Thu, 09 Dec 2021 14:41:48 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id nd36sm571136ejc.17.2021.12.09.14.41.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 14:41:47 -0800 (PST)
Date:   Fri, 10 Dec 2021 00:41:46 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Add tx fwd offload PVT on
 intermediate devices
Message-ID: <20211209224146.gfldu66kqmkgcg54@skbuf>
References: <20211209222424.124791-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209222424.124791-1-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 11:24:24PM +0100, Tobias Waldekranz wrote:
> In a typical mv88e6xxx switch tree like this:
> 
>   CPU
>    |    .----.
> .--0--. | .--0--.
> | sw0 | | | sw1 |
> '-1-2-' | '-1-2-'
>     '---'
> 
> If sw1p{1,2} are added to a bridge that sw0p1 is not a part of, sw0
> still needs to add a crosschip PVT entry for the virtual DSA device
> assigned to represent the bridge.
> 
> Fixes: ce5df6894a57 ("net: dsa: mv88e6xxx: map virtual bridges with forwarding offload in the PVT")
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

This makes sense. Sorry, my Turris MOX has 3 cascaded switches but I
only test it using a single bridge that spans all of the ports.
So this is why in my case the DSA and CPU ports could receive packets
using the virtual bridge device, because mv88e6xxx_port_vlan() had been
called on them through the direct mv88e6xxx_port_bridge_join(), not
through mv88e6xxx_crosschip_bridge_join(). I guess you have a use case
where some leaf ports are in a bridge but some upstream ports aren't,
and this is how you caught this?

Thanks!

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

> 
> Though this is a bugfix, it still targets net-next as it depends on
> the recent work done by Vladimir here:
> 
> https://lore.kernel.org/netdev/20211206165758.1553882-1-vladimir.oltean@nxp.com/
> 
>  drivers/net/dsa/mv88e6xxx/chip.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 7fadbf987b23..85f5a35340d7 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -2522,6 +2522,7 @@ static int mv88e6xxx_crosschip_bridge_join(struct dsa_switch *ds,
>  
>  	mv88e6xxx_reg_lock(chip);
>  	err = mv88e6xxx_pvt_map(chip, sw_index, port);
> +	err = err ? : mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge.num);
>  	mv88e6xxx_reg_unlock(chip);
>  
>  	return err;
> @@ -2537,7 +2538,8 @@ static void mv88e6xxx_crosschip_bridge_leave(struct dsa_switch *ds,
>  		return;
>  
>  	mv88e6xxx_reg_lock(chip);
> -	if (mv88e6xxx_pvt_map(chip, sw_index, port))
> +	if (mv88e6xxx_pvt_map(chip, sw_index, port) ||
> +	    mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge.num))
>  		dev_err(ds->dev, "failed to remap cross-chip Port VLAN\n");
>  	mv88e6xxx_reg_unlock(chip);
>  }
> -- 
> 2.25.1
> 

