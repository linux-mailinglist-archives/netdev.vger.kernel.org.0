Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28DDA578F27
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 02:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235217AbiGSASS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 20:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiGSASR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 20:18:17 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C182BF56;
        Mon, 18 Jul 2022 17:18:16 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id bp15so24301046ejb.6;
        Mon, 18 Jul 2022 17:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7wbjDW9qhN211DoHCjW8yGSpRzREgM/R9nYIiJn/FsM=;
        b=mZZitFhSMMmqyh866dnpxnUmF/mus6EOJem5bpoE0BsObDvSt7C7yqxOdCCQ+Keza1
         UtUr7/jkc90Zs8/8OeRlUFCw5Ce4TdRTjIUKcOBFmgJ5Nl8Nolrk7zBV0MZmLmtaC60N
         eXzmMuqT2PiskuCxsGm4liWB6OyhcwRDcVPfGTPSlEOAE6j0pzFkF99iPs+DgXkAwY0M
         pSbWxynKDZrfVBJfxb+mfeD0GqEFVGiRoutbRYVWWqtvw8T7b12Rm+PUqsPkb31Ljmad
         ylByzxkEKwUz7eMb0E7aqnCN3x2EwFU7Y25XqZ/90ripKxVyZCycCPkM82nW58y0HKNx
         vdQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7wbjDW9qhN211DoHCjW8yGSpRzREgM/R9nYIiJn/FsM=;
        b=wBt6Ru0vxK3CnhWj9KKlOxea0dqop41C/QQ9S3EZcAh+8xb+gjwnKvVoYxBKiQvhpA
         bee6wvWFDfpxiLlnA1G/1n038ObFMcdY8K06K263YiGUkwQ4Ko4iY9dwa46PPPqjt5Hu
         tAjHnHxq4/AarmpfLpxewOsq0ntru32Ie9K+II1G7j/XICTPs3OW97rC9J9DgfIsaP11
         /48R6gxTnpa4fMwpMc9axGW6zlmrB//jun20HQIkdT50oG8cKSxXSEqyy06IrcGASJSh
         4Ra/ZrLtLoFMgHk68XqnBlabqQd9oKhFzTk0rRHul6mWo48DldxaARXUYSGD0G2+lv1J
         zmqA==
X-Gm-Message-State: AJIora+eSSeqqPcK3guxll6qdrwnR2747CcS9v/DhM7Je78OnYuUEHYG
        /BlgcIcEAsVc8DVWANEFiBo=
X-Google-Smtp-Source: AGRyM1u/7N/RLMPII2J0uj7ZItWRCD7x6EafB4X9nRSjf15ylcs/uch2OCTAMWEw6Siwx+rs35ZRxw==
X-Received: by 2002:a17:906:685:b0:6fa:8e17:e9b5 with SMTP id u5-20020a170906068500b006fa8e17e9b5mr26667610ejb.522.1658189894536;
        Mon, 18 Jul 2022 17:18:14 -0700 (PDT)
Received: from skbuf ([188.25.231.190])
        by smtp.gmail.com with ESMTPSA id ez7-20020a056402450700b0043a87e6196esm9418650edb.6.2022.07.18.17.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 17:18:13 -0700 (PDT)
Date:   Tue, 19 Jul 2022 03:18:11 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
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
Message-ID: <20220719001811.ty6brvavbrts6rk4@skbuf>
References: <20220718180452.ysqaxzguqc3urgov@skbuf>
 <62d5a291.1c69fb81.e8ebe.287f@mx.google.com>
 <20220718184017.o2ogalgjt6zwwhq3@skbuf>
 <62d5ad12.1c69fb81.2dfa5.a834@mx.google.com>
 <20220718193521.ap3fc7mzkpstw727@skbuf>
 <62d5b8f5.1c69fb81.ae62f.1177@mx.google.com>
 <20220718203042.j3ahonkf3jhw7rg3@skbuf>
 <62d5daa7.1c69fb81.111b1.97f2@mx.google.com>
 <20220718234358.27zv5ogeuvgmaud4@skbuf>
 <62d5f18e.1c69fb81.35e7.46fe@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62d5f18e.1c69fb81.35e7.46fe@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 01:32:26AM +0200, Christian Marangi wrote:
> If the ops is not supported should I return -ENOSUPP?
> Example some ops won't be supported like the get_phy_flags or
> connect_tag_protocol for example.

That's a slight disadvantage of this approach, that DSA sometimes checks
for the presence of a certain function pointer as an indication of
whether a feature is supported or not. However that doesn't work in all
cases, and then, it is actually necessary to call and see if it returns
-EOPNOTSUPP or not. For example, commit 1054457006d4 ("net: phy:
phylink: fix DSA mac_select_pcs() introduction") had to do just that
in phylink because of DSA.

However, you need to check how each specific DSA operation is handled.
For example, the no-op implementation of get_phy_flags is to return 0
(meaning "no special flags, thank you"). The no-op implementation for
connect_tag_protocol is to return success (0) for the tagging protocol
you support, and -EOPNOTSUPP for everything else. Here -EOPNOTSUPP isn't
a special code, it is an actual hard error that denies a certain tag
protocol from attaching.

The advantage is that your driver-private ops don't have to map 1:1 with
the dsa_switch_ops, so there is more potential for code reuse than if
you had to reimplement an entire (*setup) function for example. You can
have ops for small things like regmap creation, things like that.

> Anyway the series is ready, I was just pushing it... At the end it's 23
> patch big... (I know you will hate me but at least it's reviewable)

Please optimize the patches for a reviewer with average intelligence and
the attention span of a fish. 23 patches sounds like the series would
fail on the attention span count.

> My solution currently was this...
> 
> 	ops = devm_kzalloc(&mdiodev->dev, sizeof(*ops), GFP_KERNEL);
> 	if (!ops)
> 		return -ENOMEM;
> 
> 	/* Copy common ops */
> 	memcpy(ops, &qca8k_switch_ops, sizeof(*ops));
> 
> 	/* Setup specific ops */
> 	ops->get_tag_protocol = qca8k_get_tag_protocol;

Answered above.

> 	ops->setup = qca8k_setup;

Separate sub-operation, although this is a sub-optimal short-term
solution that kind of undermines the approach with a single
dsa_switch_ops in the long run.

> 	ops->phylink_get_caps = qca8k_phylink_get_caps;

Not sure what's going to be common and what's going to be different, but
you can take other drivers as an example, some parts will be common and
some hidden behind priv->info->mac_port_get_caps().

static void mt753x_phylink_get_caps(struct dsa_switch *ds, int port,
				    struct phylink_config *config)
{
	struct mt7530_priv *priv = ds->priv;

	/* This switch only supports full-duplex at 1Gbps */
	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
				   MAC_10 | MAC_100 | MAC_1000FD;

	/* This driver does not make use of the speed, duplex, pause or the
	 * advertisement in its mac_config, so it is safe to mark this driver
	 * as non-legacy.
	 */
	config->legacy_pre_march2020 = false;

	priv->info->mac_port_get_caps(ds, port, config);
}

> 	ops->phylink_mac_select_pcs = qca8k_phylink_mac_select_pcs;
> 	ops->phylink_mac_config = qca8k_phylink_mac_config;
> 	ops->phylink_mac_link_down = qca8k_phylink_mac_link_down;
> 	ops->phylink_mac_link_up = qca8k_phylink_mac_link_up;

Hard to comment for these phylink ops how to organize the switch
differences in the best way, since I don't actually know what those
differences are. Again, other drivers may be useful.

> 	ops->get_phy_flags = qca8k_get_phy_flags;
> 	ops->master_state_change = qca8k_master_change;
> 	ops->connect_tag_protocol = qca8k_connect_tag_protocol;
> 
> 	/* Assign the final ops */
> 	priv->ds->ops = ops;
> 
> Will wait your response on how to hanle ops that are not supported.
> (I assume dsa checks if an ops is declared and not if it does return
> ENOSUPP, so this is my concern your example)

Maybe it's best to think this conversion through and not rush a patch set.
I don't want you to blindly follow my advice to have a single dsa_switch_ops,
then half-ass it. This kind of thing needs to be done with care and
forethought.
