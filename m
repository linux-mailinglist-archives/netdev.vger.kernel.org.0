Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269604C2835
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 10:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbiBXJef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 04:34:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232820AbiBXJeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 04:34:11 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3257A27AFC7;
        Thu, 24 Feb 2022 01:33:33 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id g20so1939072edw.6;
        Thu, 24 Feb 2022 01:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UuE4IUBEXeSDOIOHLezAcma6002Sti3cDIJH3TmEi4s=;
        b=YaQRS3vI6xnJZa4zAo8N9be82ralWeiejXS7sRMdec4JIwPy4tuGjiE4m5YIT3H8J/
         WJs9ZrHZmAbe40aWe7FzrGWCV5FsOroDGhjV8iBUTY2BEv9rGTDwZRx8WNhzSUR9ygGv
         vNb9taC00KjlNAAs7fpGkYMNlF6WHXI6M4PGYCPEx8UnIfiT/ZgHRYM/dbIvDxy9uuUN
         6Rk09XELt/0wOcP4t9diejPAXGTozo8OyXZ8ILmg0fEN8BoyuQHVjEs63wheChIkjknz
         oaKFod7806V+4tkzMETdMVOUKpKRfstU4LyeNd4J17r9NMITLqJ2ICKREPVu3DL8vq0b
         Nudw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UuE4IUBEXeSDOIOHLezAcma6002Sti3cDIJH3TmEi4s=;
        b=OHZugTnsRSliKDb2Gu9iAGuxSfSU1jrdmQ+O2scTqqMRipFsiom+oZPqx5YL3DZTcn
         +uobcnbzMUS3lxbpE4DcRi9Sl8Cvr2c1La60E9fy4CTJ4wUpzGRKoP66Qkw/SWK4slK4
         JoCEkZ+lKosNSe6E+50ErXTu4AHLq8Bz1hhTVyh7hFWykx0Lc95yYpwGYquyK7bP9VUz
         tTDUY6uC04V1xqqCcCYRiBxUSPCiaTUgp3m+Mb+YWYW33rv6hezldgPoritmYDMTyV6J
         SRZiPRFf2rp0PKIv2fpMCrCbV0PHO1WqhXqxUnjhk9f8kTL0dxWUdHrG4b/tGF9Miox1
         6XSQ==
X-Gm-Message-State: AOAM531mf/m7CcQtPfS2BrUWre+WfSwFkk7D+BP+u9xt3GML2UFl3Sgs
        DTTbN50UEDC9a7TTSPHPPfU=
X-Google-Smtp-Source: ABdhPJxf7WCIQPHfu2rYiQKCcwDVng+EP1QbV5j1KabA/uWUZL5UZnqNLOyQ0fEHKwcGHb/IOEgnHw==
X-Received: by 2002:a50:9d89:0:b0:410:ff04:5a98 with SMTP id w9-20020a509d89000000b00410ff045a98mr1488492ede.404.1645695211533;
        Thu, 24 Feb 2022 01:33:31 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id z6sm1082068ejd.96.2022.02.24.01.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 01:33:31 -0800 (PST)
Date:   Thu, 24 Feb 2022 11:33:29 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 1/1] net: dsa: microchip: ksz9477: implement
 MTU configuration
Message-ID: <20220224093329.hssghouq7hmgxvwb@skbuf>
References: <20220223084055.2719969-1-o.rempel@pengutronix.de>
 <20220223233833.mjknw5ko7hpxj3go@skbuf>
 <20220224045936.GB4594@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224045936.GB4594@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 05:59:36AM +0100, Oleksij Rempel wrote:
> > Are you sure the unit of measurement is ok? My KSZ9477 documentation
> > says this about register 0x0308:
> > 
> > Maximum Frame Length (MTU)
> > Specifies the maximum transmission unit (MTU), which is the maximum
> > frame payload size. Frames which exceed this maximum are truncated. This
> > value can be set as high as 9000 (= 0x2328) if jumbo frame support is
> > required.
> > 
> > "frame payload" to me means what MTU should mean. And ETH_HLEN +
> > VLAN_HLEN + ETH_FCS_LEN isn't part of that meaning.
> 
> if I set this value to anything less then 1522, it breaks the NFS boot. Since
> my NFS server is configured with MTU 1500, i tried to guess how
> frame size is calculated on this chip.

Sad that Microchip engineers can't decide on whether the MTU register
holds the "Maximum Frame Length" or the "maximum frame payload size".
They said both to have themselves covered, you understand what you will,
of course both are not right :)

> > > +	/* Now we can configure default MTU value */
> > > +	ret = regmap_update_bits(dev->regmap[1], REG_SW_MTU__2, REG_SW_MTU_MASK,
> > > +				 VLAN_ETH_FRAME_LEN + ETH_FCS_LEN);
> > 
> > Why do you need this? Doesn't DSA call dsa_slave_create() ->
> > dsa_slave_change_mtu(ETH_DATA_LEN) on probe?
> 
> This was my initial assumption as well, but cadence macb driver provides
> buggy max MTU == -18. I hardcoded bigger MTU for now[1], but was not able to
> find proper way to fix it. To avoid this kinds of regressions I decided
> to keep some sane default configuration.
> 
> [1] - my workaround.
> commit 5f8385e9641a383478a65f96ccee8fd992201f68
> Author: Oleksij Rempel <linux@rempel-privat.de>
> Date:   Mon Feb 14 14:41:06 2022 +0100
> 
>     WIP: net: macb: fix max mtu size
>     
>     The gem_readl(bp, JML) will return 0, so we get max_mtu size of -18,
>     this is breaking MTU configuration for DSA
>     
>     Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index a363da928e8b..454d811991bb 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -4727,7 +4727,7 @@ static int macb_probe(struct platform_device *pdev)
>  	/* MTU range: 68 - 1500 or 10240 */
>  	dev->min_mtu = GEM_MTU_MIN_SIZE;
>  	if (bp->caps & MACB_CAPS_JUMBO)
> -		dev->max_mtu = gem_readl(bp, JML) - ETH_HLEN - ETH_FCS_LEN;
> +		dev->max_mtu = 10240 - ETH_HLEN - ETH_FCS_LEN;
>  	else
>  		dev->max_mtu = ETH_DATA_LEN;

Yes, but the macb driver can be a DSA master for any switch, not just
for ksz9477. Better to fix this differently.
