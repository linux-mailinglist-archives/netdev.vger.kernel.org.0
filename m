Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910664C2871
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 10:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbiBXJrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 04:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbiBXJra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 04:47:30 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F80A52E4C;
        Thu, 24 Feb 2022 01:47:01 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id bg10so3099156ejb.4;
        Thu, 24 Feb 2022 01:47:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+QyRz/0YHASCjbzaoQ9t/VGtOBDL/Yb3XK4lLKqH4A4=;
        b=k1AI6it51N5rcwFjQsvIctaHLWJAeMKUtIAubchXYr3XY8UdUVIOxjY4eUaTRIt/fb
         GOuhodyJRF6IACPrp/oAMo816qLr7kvt0+WR0ougieZer4RxcmwiN3Y7UgEBJujsnSNC
         MFLfARyZBGWJSWtVBJ3AHtdWYG56ORHI1AvfnJ6ymUf5Z4LsF9wp2KtZVKBCcak1HETv
         0vbsDnI8hZ/3iy8cT4Fx/icH8dRlUvN9wbFyEcqLIGHSO5JlerQA0qRMoDEK3hDChiKj
         Nq3idfyhpfJDUqObbp30geULwDVLnf7wK/AvUsJNT5AmLAehYiGrghQ/WQCN/gpLcyrF
         2rYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+QyRz/0YHASCjbzaoQ9t/VGtOBDL/Yb3XK4lLKqH4A4=;
        b=U+MnWKk6fkJIT/VCCuqpU2JalGBZ2QMi2I7irs/mCUaWGlupGOiOBJ/X9dnF74gqn9
         npg4Eb9t6iGc/xyvOOwGJcbjS3xD55+RsdGan2xqJOsa0U5kHgYFW6+47OgBOPV4lsw8
         1aW7xdEMHAA47hViE6y9FoWhuFUYSwmKZ0lCKFgENE/Xyt7Yw3yKpTMN+n7SEZKH6T4t
         vqQxyos18ICQwZavDVifnZp4H6bO48nSt5HBHzMeNULwtOJ+6ENCSFK70YSbaer8d1cu
         womb407ZrOSznIGXhhdrSODztVYMpHQcHUINZ3HADa/FxUuhDCH+lwWIAk04EsFkvJ7j
         vH6A==
X-Gm-Message-State: AOAM533GVNqA0BgHEpFZuc+bXMyCrAaAfL7D1fdcI/4F0tOkGp4EIWcQ
        OsanCyhv581KLZuc0nMUrWA=
X-Google-Smtp-Source: ABdhPJw9rNyC/53YHqMQ0l9eywkfYEvIpQBJAstlhykmF/D7dFLNMblgj5vr+Z5qu0h9rDqQtLge5w==
X-Received: by 2002:a17:906:8493:b0:6ce:710:3739 with SMTP id m19-20020a170906849300b006ce07103739mr1536358ejx.409.1645696019478;
        Thu, 24 Feb 2022 01:46:59 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id e9sm1022257edy.53.2022.02.24.01.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 01:46:59 -0800 (PST)
Date:   Thu, 24 Feb 2022 11:46:57 +0200
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
Message-ID: <20220224094657.jzhvi67ryhuipor4@skbuf>
References: <20220223084055.2719969-1-o.rempel@pengutronix.de>
 <20220223233833.mjknw5ko7hpxj3go@skbuf>
 <20220224045936.GB4594@pengutronix.de>
 <20220224093329.hssghouq7hmgxvwb@skbuf>
 <20220224093827.GC4594@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224093827.GC4594@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 10:38:27AM +0100, Oleksij Rempel wrote:
> > > > > +	/* Now we can configure default MTU value */
> > > > > +	ret = regmap_update_bits(dev->regmap[1], REG_SW_MTU__2, REG_SW_MTU_MASK,
> > > > > +				 VLAN_ETH_FRAME_LEN + ETH_FCS_LEN);
> > > > 
> > > > Why do you need this? Doesn't DSA call dsa_slave_create() ->
> > > > dsa_slave_change_mtu(ETH_DATA_LEN) on probe?
> > > 
> > > This was my initial assumption as well, but cadence macb driver provides
> > > buggy max MTU == -18. I hardcoded bigger MTU for now[1], but was not able to
> > > find proper way to fix it. To avoid this kinds of regressions I decided
> > > to keep some sane default configuration.
> > > 
> > > [1] - my workaround.
> > > commit 5f8385e9641a383478a65f96ccee8fd992201f68
> > > Author: Oleksij Rempel <linux@rempel-privat.de>
> > > Date:   Mon Feb 14 14:41:06 2022 +0100
> > > 
> > >     WIP: net: macb: fix max mtu size
> > >     
> > >     The gem_readl(bp, JML) will return 0, so we get max_mtu size of -18,
> > >     this is breaking MTU configuration for DSA
> > >     
> > >     Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > > 
> > > diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> > > index a363da928e8b..454d811991bb 100644
> > > --- a/drivers/net/ethernet/cadence/macb_main.c
> > > +++ b/drivers/net/ethernet/cadence/macb_main.c
> > > @@ -4727,7 +4727,7 @@ static int macb_probe(struct platform_device *pdev)
> > >  	/* MTU range: 68 - 1500 or 10240 */
> > >  	dev->min_mtu = GEM_MTU_MIN_SIZE;
> > >  	if (bp->caps & MACB_CAPS_JUMBO)
> > > -		dev->max_mtu = gem_readl(bp, JML) - ETH_HLEN - ETH_FCS_LEN;
> > > +		dev->max_mtu = 10240 - ETH_HLEN - ETH_FCS_LEN;
> > >  	else
> > >  		dev->max_mtu = ETH_DATA_LEN;
> > 
> > Yes, but the macb driver can be a DSA master for any switch, not just
> > for ksz9477. Better to fix this differently.
> 
> Yes, it should be fixed. I just need some time to understand the proper
> way to do so. For now, let's proceed with the ksz patch. Should I send
> new version with some changes?

So where is it failing exactly? Here I guess, because mtu_limit will be
negative?

	mtu_limit = min_t(int, master->max_mtu, dev->max_mtu);
	old_master_mtu = master->mtu;
	new_master_mtu = largest_mtu + dsa_tag_protocol_overhead(cpu_dp->tag_ops);
	if (new_master_mtu > mtu_limit)
		return -ERANGE;

I don't think we can work around it in DSA, it's garbage in, garbage out.

In principle, I don't have such a big issue with writing the MTU
register as part of the switch initialization, especially if it's global
and not per port. But tell me something else. You pre-program the MTU
with VLAN_ETH_FRAME_LEN + ETH_FCS_LEN, but in the MTU change procedure,
you also add KSZ9477_INGRESS_TAG_LEN (2) to that. Is that needed at all?
I expect that if it's needed, it's needed in both places. Can you
sustain an iperf3 tcp session over a VLAN upper of a ksz9477 port?
I suspect that the missing VLAN_HLEN is masking a lack of KSZ9477_INGRESS_TAG_LEN.
