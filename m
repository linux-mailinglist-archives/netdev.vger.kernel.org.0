Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F2C3E1FE8
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 02:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242898AbhHFASJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 20:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242860AbhHFAR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 20:17:59 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE6AC061799;
        Thu,  5 Aug 2021 17:17:43 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id cf5so10829233edb.2;
        Thu, 05 Aug 2021 17:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zw/0qEnKJrmNekra6VcoVeV33INMsYbzX2fsWAAHgGc=;
        b=KlKFIEbLFH7X8P9jgl3li1QFlvN3OTz+loXJhEfDS6OcXaR/faZOvCa7SdV2lWai5s
         jhWXxY2rv0HYfDUihsP+IzOJ6DYjelhcZ8wB2gK3lJBRU4noIp8VHDD2O6BlB+G9s3v4
         qxTBT98CzPXXtf4if/wI+bG4n18DPDbnvPjgdA04H/M6HXsxiyeKKu5kmg4S7vxwfe4p
         XByfaD3VeBu1Wss2TShZv/A43XPnDtToTLtZM+PW7JJXJGFk3d2dyFSheLzYZhRbeFSY
         wZJEN1Tl0t9b3+1ujBUWCMNtlCYpeCFBwzeRQRW2TqLW6vn+OIH0MqhumcggjaYukjHi
         a8+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zw/0qEnKJrmNekra6VcoVeV33INMsYbzX2fsWAAHgGc=;
        b=eJfqFb7iNQTdED6KUacCyHv857QIyGVssx7cFX2oYHm39sN5UuJzBn81det6ZyFYqi
         30jBOm7PELo46iVjDAIAdwCMgcRFqcHvjYbmjDh4vHIdsGBvVAwdl2I9V2IJA70lkL8r
         SjgKL67c4OFW84e8LhitcW7zhUhBEIGq2X8vixlrqQ+XfZ8J2s6bAXw5OBoe2TMqh0Gp
         gqLYM78fBPZ2Xts9msnr8hrQtqdiDD4ByM7gN3Q7PboHH4D63bJ2bd+P9Zihoq+Fvrq+
         8LOstjf9bghCBJkto5VpfXTYrLK6OgnI7EbdaR5JqtLDONpypjUfauO/Tzy1vm5/61bl
         eRdA==
X-Gm-Message-State: AOAM530RpdHnglBR34it2LzEd5sg1QBLPkoKgS3M2eBcOLFKmQ+pS3Wu
        LBPj7h7BukwvF/KABoNuZv4=
X-Google-Smtp-Source: ABdhPJzenKyokR+gZ0WU8XytpuArPL0RxMpzWsLhxPo7r/W/yBlFxbQrxQG+FLxFcI+fG5hbhHWSqA==
X-Received: by 2002:aa7:d899:: with SMTP id u25mr9821469edq.151.1628209062424;
        Thu, 05 Aug 2021 17:17:42 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id o25sm2186250ejh.109.2021.08.05.17.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 17:17:41 -0700 (PDT)
Date:   Fri, 6 Aug 2021 03:17:40 +0300
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
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mt7530: drop untagged frames on
 VLAN-aware ports without PVID
Message-ID: <20210806001740.cayorz3vlfrvk75l@skbuf>
References: <20210805172315.362165-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805172315.362165-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 06, 2021 at 01:23:14AM +0800, DENG Qingfang wrote:
> @@ -1624,11 +1631,26 @@ mt7530_port_vlan_add(struct dsa_switch *ds, int port,
>  	if (pvid) {
>  		priv->ports[port].pvid = vlan->vid;
>  
> +		/* Accept all frames if PVID is set */
> +		mt7530_rmw(priv, MT7530_PVC_P(port), ACC_FRM_MASK,
> +			   MT7530_VLAN_ACC_ALL);
> +
>  		/* Only configure PVID if VLAN filtering is enabled */
>  		if (dsa_port_is_vlan_filtering(dsa_to_port(ds, port)))
>  			mt7530_rmw(priv, MT7530_PPBV1_P(port),
>  				   G0_PORT_VID_MASK,
>  				   G0_PORT_VID(vlan->vid));
> +	} else if (priv->ports[port].pvid == vlan->vid) {
> +		/* This VLAN is overwritten without PVID, so unset it */
> +		priv->ports[port].pvid = G0_PORT_VID_DEF;
> +
> +		/* Only accept tagged frames if the port is VLAN-aware */
> +		if (dsa_port_is_vlan_filtering(dsa_to_port(ds, port)))
> +			mt7530_rmw(priv, MT7530_PVC_P(port), ACC_FRM_MASK,
> +				   MT7530_VLAN_ACC_TAGGED);
> +
> +		mt7530_rmw(priv, MT7530_PPBV1_P(port), G0_PORT_VID_MASK,
> +			   G0_PORT_VID_DEF);
>  	}
>  
>  	mutex_unlock(&priv->reg_mutex);

Good catch with this condition, sja1105 and ocelot are buggy in this
regard, it seems, probably others too. Need to fix them. Although
honestly I would probably rather spend the time patching the bridge
already to not accept duplicate VLAN entries from user space, just with
different flags, it's just too complex to handle the overwrites everywhere...
Plus, bridge accepting duplicate VLANs means we cannot refcount them on
DSA and CPU ports at the cross-chip level, which in turn means we can
never delete them from those ports.

Anyhow, enough rambling.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
