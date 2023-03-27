Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209E56CAE50
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 21:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbjC0TNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 15:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232646AbjC0TNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 15:13:23 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13814488;
        Mon, 27 Mar 2023 12:12:47 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id v1so9889028wrv.1;
        Mon, 27 Mar 2023 12:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679944365;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HYVINSPcX570meD+tbiju4gbaHHy2aZVdws7rdRLV/U=;
        b=KK68TZUyb+HjYZ0CT1XzfVmxm49E3yfbXe3orrjtJTlDrkwsoLOl0N/qqEXfKQdiug
         9ObLgEKV80TmHgjR3TkTRtmyu0L2wdEYHfTCPt3ppDJDlmPpWI2zoArUty3g6GYcCcaA
         ve+hm8dWOolIdC/kqciF2FqMVRnImO1jO7UMqw3epBVc9vSJQncDg25FDtX3EokW8Ybs
         zYIpH3hyjBPw6L+lLPp7VZ55p9QsX910cv+BSoDT/Sn7ZpG3O7mCZ5iUoeZIHNTQDwnV
         gFwLhQp6tVnPpsCP1wPUznIJz+EyX5Qs6Iq/jYI/c1nRBxU8B6AZ4Z4Ph7CJt5mCu0r5
         uRiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679944365;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HYVINSPcX570meD+tbiju4gbaHHy2aZVdws7rdRLV/U=;
        b=EUIt0ku5UX63KvVShrde6WkGI/VpIfiUPl7m6wzGOa+FAtJDJ8jmypU62QtBH9i0/g
         XES94hfTS/PCFouqbmoirPqeuUrZY9TG5DIAJvC5YIhWmoVdDHQHsTj1fAy32Jh5gH1L
         MDRRBg7l3G+WVbWdeJeatPPfqYqLu6dnQWsvo+mWNBdHtLJft5I1cbAs4fRAbzLg3Hd4
         2N1cnaitaXd9CVY/9+DRbsKsbv/eMa2heNIdhoY1R3Rd3/NEzPyq4+S2FcneqjZZyb6J
         t6kwsvoAdfFPu5yqndYB2YR2Ml7j07y5V38kqT/knKsXTzDYGH08nRb6VBuQpql/hPvD
         q+hA==
X-Gm-Message-State: AAQBX9fRhxtMvPYLL33GtT3JfJDedykgxZ39gYglUwhUnswpYXTtCPCk
        BqlOJL6kvDp9jVNFftO618o=
X-Google-Smtp-Source: AKy350Y47ZUzytcAg65n77+zDkosW+9AMGn5S4UlJ/7NcuCee8SP+Hdo0fbynRibnYV+tUN/IEK8bw==
X-Received: by 2002:a5d:526a:0:b0:2d0:58f9:a6a with SMTP id l10-20020a5d526a000000b002d058f90a6amr10553468wrc.57.1679944365660;
        Mon, 27 Mar 2023 12:12:45 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id f6-20020a05600c154600b003ef7058ea02sm3295888wmg.29.2023.03.27.12.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 12:12:45 -0700 (PDT)
Date:   Mon, 27 Mar 2023 22:12:42 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     arinc9.unal@gmail.com
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net 4/7] net: dsa: mt7530: set both CPU port interfaces
 to PHY_INTERFACE_MODE_NA
Message-ID: <20230327191242.4qabzrn3vtx3l2a7@skbuf>
References: <20230326140818.246575-1-arinc.unal@arinc9.com>
 <20230326140818.246575-5-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230326140818.246575-5-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 05:08:15PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> Set interfaces of both CPU ports to PHY_INTERFACE_MODE_NA. Either phylink
> or mt7530_setup_port5() on mt7530_setup() will handle the rest.
> 
> This is already being done for port 6, do it for port 5 as well.
> 
> Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")

This is getting comical.. I think I'm putting too much energy in
trying to understand the hidden meaning of this patch set.

In include/linux/phy.h we have:

typedef enum {
	PHY_INTERFACE_MODE_NA,

In lack of other initializer, the first element of an enum gets the
value 0 in C.

Then, "priv" is allocated by this driver with devm_kzalloc(), which
means that its entire memory is zero-filled. So priv->p5_interface and
priv->p6_interface are already set to 0, or PHY_INTERFACE_MODE_NA.

There is no code path between the devm_kzalloc() and the position in
mt7530_setup() that would change the value of priv->p5_interface or
priv->p6_interface from their value of 0 (PHY_INTERFACE_MODE_NA).
For example, mt753x_phylink_mac_config() can only be called from
phylink, after dsa_port_phylink_create() was called. But
dsa_port_phylink_create() comes later than ds->ops->setup() - one comes
from dsa_tree_setup_ports(), and the other from dsa_tree_setup_switches().

The movement of the priv->p6_interface assignment with a few lines
earlier does not change anything relative to the other call sites which
assign different values to priv->p6_interface, so there isn't any
functional change there, either.

So this patch is putting 0 into a variable containing 0, and claiming,
through the presence of the Fixes: tag and the submission to the "net"
tree, that it is a bug fix which should be backported to "stable".

Can it be that you are abusing the meaning of a "bug fix", and that I'm
trying too hard to take this patch set seriously?

> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  drivers/net/dsa/mt7530.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 6d33c1050458..3deebdcfeedf 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2203,14 +2203,18 @@ mt7530_setup(struct dsa_switch *ds)
>  		mt7530_rmw(priv, MT7530_TRGMII_RD(i),
>  			   RD_TAP_MASK, RD_TAP(16));
>  
> +	/* Let phylink decide the interface later. If port 5 is used for phy
> +	 * muxing, its interface will be handled without involving phylink.
> +	 */
> +	priv->p5_interface = PHY_INTERFACE_MODE_NA;
> +	priv->p6_interface = PHY_INTERFACE_MODE_NA;
> +
>  	/* Enable port 6 */
>  	val = mt7530_read(priv, MT7530_MHWTRAP);
>  	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
>  	val |= MHWTRAP_MANUAL;
>  	mt7530_write(priv, MT7530_MHWTRAP, val);
>  
> -	priv->p6_interface = PHY_INTERFACE_MODE_NA;
> -
>  	/* Enable and reset MIB counters */
>  	mt7530_mib_reset(ds);
>  
> -- 
> 2.37.2
> 
