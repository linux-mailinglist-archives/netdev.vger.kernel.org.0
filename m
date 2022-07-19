Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D84578F54
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 02:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235375AbiGSAeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 20:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiGSAef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 20:34:35 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AB220BE3;
        Mon, 18 Jul 2022 17:34:34 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id v16so19329212wrd.13;
        Mon, 18 Jul 2022 17:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=gbsinNdr0BQFsd/T3zsH5QkmdpN5FSgV4d92E62lsYE=;
        b=PMLa7FCPacOopeM4wwqeeDm9keDMKML+ZEg992OuTfxmxZaQJkjQK1nrLMrOzqIcGt
         6/2IHogsD5kiIGMDBDatGydsYEtz2ysHv16iffR+xbiu9gxKq3zgCZMOW/usnK1Eqsu8
         LLLx5/F5i9Dz2UI/YOjWQux4Q7V0mWrz2hwGM7z00FSPK92VSbXMBS4TMlv+hvXwbnmU
         57tLrLbve5xNZEIz2Ug+xsUzhUGaJT+m82/j6gtIk2c1SdCP6pnZRdOjqvfa2rBctbKM
         AXTrIEqIQGOXrpWMDSOPTD2zrgE+8iNfpiA2XJPwWFqkZVQ375x66KGGdWeSkvvghUmz
         9Biw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=gbsinNdr0BQFsd/T3zsH5QkmdpN5FSgV4d92E62lsYE=;
        b=3qKTPPR1H56NyZsS7M0pB3gJ2P2qRkF5f5wQ+CN0Xv0KeoR+8KMoMqw3LYk8MZpJ66
         68VI893AD7iTGbDthRLmDojRrTOO9P5L/M7fSTSFJCyFQaWibpPNiWNPlYnefzgw4IZZ
         1nL1CDnCK4LFG6fNOpBW7DVdOB5Rczhy9s9QxAdP6vr3HfNoi7pK/ON2nJC9r4BEeEL/
         yPnuWSz63MDYhFybaVqv2oYfB6ziKu6L2363LXhz5Mg+OWHR4mrB5dYcJgp+Mq2Eapu1
         qoiWuE2AFG/nD7YL+nk1OLpLp4pUVb0WDrRNMtxxYaB1aoWMe+PU5Y2useXYuwsx6wdH
         5r8w==
X-Gm-Message-State: AJIora9WurSLeOTyFPHIE/yhj4TTmDUOsztKvI5Fs2cgUyYqYQ5OrN5o
        Ri3fT81Tv4+fOPiC9waQ76U=
X-Google-Smtp-Source: AGRyM1tuP6Dw75bTlbSyjXLWOqEdydFBH0Jw6r09udoZH39svq7cJGmfSweftFFPoi/Yx8NbLdoNIg==
X-Received: by 2002:a05:6000:1567:b0:21d:abc4:29f9 with SMTP id 7-20020a056000156700b0021dabc429f9mr24365844wrz.181.1658190872604;
        Mon, 18 Jul 2022 17:34:32 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id i15-20020a5d438f000000b0021d4d6355efsm11921090wrq.109.2022.07.18.17.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 17:34:32 -0700 (PDT)
Message-ID: <62d5fc18.1c69fb81.28c9a.a5c2@mx.google.com>
X-Google-Original-Message-ID: <YtX4EN8amBXzvtCz@Ansuel-xps.>
Date:   Tue, 19 Jul 2022 02:17:20 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 1/4] net: dsa: qca8k: drop
 qca8k_read/write/rmw for regmap variant
References: <62d5a291.1c69fb81.e8ebe.287f@mx.google.com>
 <20220718184017.o2ogalgjt6zwwhq3@skbuf>
 <62d5ad12.1c69fb81.2dfa5.a834@mx.google.com>
 <20220718193521.ap3fc7mzkpstw727@skbuf>
 <62d5b8f5.1c69fb81.ae62f.1177@mx.google.com>
 <20220718203042.j3ahonkf3jhw7rg3@skbuf>
 <62d5daa7.1c69fb81.111b1.97f2@mx.google.com>
 <20220718234358.27zv5ogeuvgmaud4@skbuf>
 <62d5f18e.1c69fb81.35e7.46fe@mx.google.com>
 <20220719001811.ty6brvavbrts6rk4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719001811.ty6brvavbrts6rk4@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 03:18:11AM +0300, Vladimir Oltean wrote:
> On Tue, Jul 19, 2022 at 01:32:26AM +0200, Christian Marangi wrote:
> > If the ops is not supported should I return -ENOSUPP?
> > Example some ops won't be supported like the get_phy_flags or
> > connect_tag_protocol for example.
> 
> That's a slight disadvantage of this approach, that DSA sometimes checks
> for the presence of a certain function pointer as an indication of
> whether a feature is supported or not. However that doesn't work in all
> cases, and then, it is actually necessary to call and see if it returns
> -EOPNOTSUPP or not. For example, commit 1054457006d4 ("net: phy:
> phylink: fix DSA mac_select_pcs() introduction") had to do just that
> in phylink because of DSA.
> 
> However, you need to check how each specific DSA operation is handled.
> For example, the no-op implementation of get_phy_flags is to return 0
> (meaning "no special flags, thank you"). The no-op implementation for
> connect_tag_protocol is to return success (0) for the tagging protocol
> you support, and -EOPNOTSUPP for everything else. Here -EOPNOTSUPP isn't
> a special code, it is an actual hard error that denies a certain tag
> protocol from attaching.
> 
> The advantage is that your driver-private ops don't have to map 1:1 with
> the dsa_switch_ops, so there is more potential for code reuse than if
> you had to reimplement an entire (*setup) function for example. You can
> have ops for small things like regmap creation, things like that.
> 
> > Anyway the series is ready, I was just pushing it... At the end it's 23
> > patch big... (I know you will hate me but at least it's reviewable)
> 
> Please optimize the patches for a reviewer with average intelligence and
> the attention span of a fish. 23 patches sounds like the series would
> fail on the attention span count.
> 
> > My solution currently was this...
> > 
> > 	ops = devm_kzalloc(&mdiodev->dev, sizeof(*ops), GFP_KERNEL);
> > 	if (!ops)
> > 		return -ENOMEM;
> > 
> > 	/* Copy common ops */
> > 	memcpy(ops, &qca8k_switch_ops, sizeof(*ops));
> > 
> > 	/* Setup specific ops */
> > 	ops->get_tag_protocol = qca8k_get_tag_protocol;
> 
> Answered above.
> 
> > 	ops->setup = qca8k_setup;
> 
> Separate sub-operation, although this is a sub-optimal short-term
> solution that kind of undermines the approach with a single
> dsa_switch_ops in the long run.
> 
> > 	ops->phylink_get_caps = qca8k_phylink_get_caps;
> 
> Not sure what's going to be common and what's going to be different, but
> you can take other drivers as an example, some parts will be common and
> some hidden behind priv->info->mac_port_get_caps().
> 
> static void mt753x_phylink_get_caps(struct dsa_switch *ds, int port,
> 				    struct phylink_config *config)
> {
> 	struct mt7530_priv *priv = ds->priv;
> 
> 	/* This switch only supports full-duplex at 1Gbps */
> 	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
> 				   MAC_10 | MAC_100 | MAC_1000FD;
> 
> 	/* This driver does not make use of the speed, duplex, pause or the
> 	 * advertisement in its mac_config, so it is safe to mark this driver
> 	 * as non-legacy.
> 	 */
> 	config->legacy_pre_march2020 = false;
> 
> 	priv->info->mac_port_get_caps(ds, port, config);
> }
> 
> > 	ops->phylink_mac_select_pcs = qca8k_phylink_mac_select_pcs;
> > 	ops->phylink_mac_config = qca8k_phylink_mac_config;
> > 	ops->phylink_mac_link_down = qca8k_phylink_mac_link_down;
> > 	ops->phylink_mac_link_up = qca8k_phylink_mac_link_up;
> 
> Hard to comment for these phylink ops how to organize the switch
> differences in the best way, since I don't actually know what those
> differences are. Again, other drivers may be useful.
> 
> > 	ops->get_phy_flags = qca8k_get_phy_flags;
> > 	ops->master_state_change = qca8k_master_change;
> > 	ops->connect_tag_protocol = qca8k_connect_tag_protocol;
> > 
> > 	/* Assign the final ops */
> > 	priv->ds->ops = ops;
> > 
> > Will wait your response on how to hanle ops that are not supported.
> > (I assume dsa checks if an ops is declared and not if it does return
> > ENOSUPP, so this is my concern your example)
> 
> Maybe it's best to think this conversion through and not rush a patch set.
> I don't want you to blindly follow my advice to have a single dsa_switch_ops,
> then half-ass it. This kind of thing needs to be done with care and
> forethought.

Wonder if a good idea would be leave things as is for now and work of a
single dsa_switch_ops on another series.

With "leave things as is" I mean that function will get migrated to
qca8k-common.c and exposed with the header file.

And the dsa_switch_ops is defined in qca8k specific code.

The warn about the 23 patch was scary so considering this series is
already a bit big and I can squash only a few patch, putting extra logic
to correctly handle each would make this even bigger.

Think the right thing to do is handling the changes for single
dsa_switch_ops to a separate series and at the same time also get some
info on ipq4019 and what can be generalized.

What do you think?

-- 
	Ansuel
