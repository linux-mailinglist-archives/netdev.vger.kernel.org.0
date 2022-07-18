Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6BBF578913
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbiGRR7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiGRR7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:59:02 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E2AB7DE;
        Mon, 18 Jul 2022 10:59:00 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id os14so22742558ejb.4;
        Mon, 18 Jul 2022 10:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PTUE6dPKJYpB0lIem9CgvnQjj1kWO1P/fBbaOZRFCNc=;
        b=jke5/KTGYgxoYaV2XbRW9fG/eoflgbdPwuxy2l62jzuBVJecMjRjtFrZ1b+3iQQJA8
         7G9O4SB5v8F5DLPmnRjCHlY01ncBcswucuhop0jWpAPzYDt/9eH58W26TApv8tz8QMiE
         08x+hBDd3ywzpfY93rGph0diYu8cjZgnr/OH89Mxd+IZAYA/yFov7P1uwNZIzSFDS9DL
         HVrOCo6IMbGRF3Jrn3APEZgB0YllBYc+RnpRGEyNufsXCu4bWbltXqSuXCovvXZItPbO
         2Xl29APnWx7l+1FaKhNPk7BJgjRXb2xjnRgh0mlvKVI+8WYiKlmja0sCLnw/D0Q5Iz3c
         xUjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PTUE6dPKJYpB0lIem9CgvnQjj1kWO1P/fBbaOZRFCNc=;
        b=Oc9qQsPz178sJ98MGGqEQjQ7JwV1dgHnv91wgpkbBecvfKWPTXuFc5iUvNrKVb+he+
         Qn13GuDxuptcRy07T+xY9Ls3DQkV1uTRyjDXZAJ2SPn6ZF4f/aIv4ukeptTbeG5Ag9PP
         Gb1iGvCxXgwg5BPWeeKmNziTroHdOPCIe7qnlBCbYtmbq4JnBFWDNriXbNgdZExdajbN
         TAP+hpFNWH4a1BJhhweRG1Iox4W0ori576NdDrmt+iiWsNmztaaBvYyDnW8yWNpsFewg
         VhKr7kK5wPcrOlaHv6LJLiEJ7p8YvtfzqGNd6u9GGD0q6aQ3WrHYdj0Q/8+streRAj0n
         VlvQ==
X-Gm-Message-State: AJIora/ArRkm2unEozHTGZic6mTpVUITCb5nFQrvWHJE8DyIJaiQGn6W
        kfgv5TfNvbbzWMt6PRmJelBe7Pnjw7M=
X-Google-Smtp-Source: AGRyM1u+XG7N7wELcFCz/sw/hovktBv1DP9JENehO+JEM0uCyedbdQcbX/HUcz6o7P1ZpmgRnY8D+Q==
X-Received: by 2002:a17:907:6d2a:b0:72f:228b:c972 with SMTP id sa42-20020a1709076d2a00b0072f228bc972mr8257595ejc.638.1658167139493;
        Mon, 18 Jul 2022 10:58:59 -0700 (PDT)
Received: from skbuf ([188.25.231.190])
        by smtp.gmail.com with ESMTPSA id b10-20020a1709063caa00b0072ee79bb8ebsm5161327ejh.126.2022.07.18.10.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 10:58:58 -0700 (PDT)
Date:   Mon, 18 Jul 2022 20:58:56 +0300
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
Subject: Re: [net-next RFC PATCH 3/4] net: dsa: qca8k: rework mib autocast
 handling
Message-ID: <20220718175856.24jllmtsviypu4dg@skbuf>
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
 <20220716174958.22542-1-ansuelsmth@gmail.com>
 <20220716174958.22542-4-ansuelsmth@gmail.com>
 <20220716174958.22542-4-ansuelsmth@gmail.com>
 <20220718172712.xlrcnel6njflmhli@skbuf>
 <62d59a4a.1c69fb81.c7f5e.b841@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62d59a4a.1c69fb81.c7f5e.b841@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 07:20:07PM +0200, Christian Marangi wrote:
> On Mon, Jul 18, 2022 at 08:27:12PM +0300, Vladimir Oltean wrote:
> > On Sat, Jul 16, 2022 at 07:49:57PM +0200, Christian Marangi wrote:
> > > In preparation for code split, move the autocast mib function used to
> > > receive mib data from eth packet in priv struct and use that in
> > > get_ethtool_stats instead of referencing the function directly. This is
> > > needed as the get_ethtool_stats function will be moved to a common file.
> > > 
> > > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > > ---
> > 
> > Can this change be deferred until there actually appears a second
> > implementation of (*autocast_mib)?
> >
> 
> Mhhh it would be problematic since I would like to move the ethtools
> stats function to common code and keep the autocast_mib handler in the
> qca8k specific code.
> 
> An alternative would be to keep the entire ethtool stats function in
> qca8k specific code but it needs to be moved anyway.
> 
> This change is required as probably ipq4019 mmio will be faster to
> access mib data than using the autocast way.
> 
> Tell me how to proceed. Think to skip this we have to leave ethtool
> stats function in qca8k specific code and move it later?

Sorry, I think I initially misread the patch. So ipq4019 is not going to
have an implementation of (*autocast_mib) at all? In that case I don't
have an objection to make it a function pointer now, but you need to
state exactly that in the commit message: make MIB autocast optional in
qca8k_get_ethtool_stats(), because we'll need to support an MMIO-based
switch in the future where we won't need to implement this function.

> > > diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
> > > index 22ece14e06dc..a306638a7100 100644
> > > --- a/drivers/net/dsa/qca/qca8k.h
> > > +++ b/drivers/net/dsa/qca/qca8k.h
> > > @@ -403,6 +403,7 @@ struct qca8k_priv {
> > >  	struct qca8k_mdio_cache mdio_cache;
> > >  	struct qca8k_pcs pcs_port_0;
> > >  	struct qca8k_pcs pcs_port_6;
> > > +	int (*autocast_mib)(struct dsa_switch *ds, int port, u64 *data);
> > 
> > Typically we hold function pointers in separate read-only structures rather
> > than in the stateful private structure of the driver, see struct sja1105_info,
> > struct felix_info, struct mv88e6xxx_info and mv88e6xxx_ops, struct b53_io_ops,
> > etc etc.
> > 
> 
> Oh ok it's just match data. We should already have something like that
> in qca8k but I wasn't aware of the _info suffix. If we decide to keep
> this, can i allign the match struct we use in qca8k to the new pattern
> and add the function pointer there?

I think struct qca8k_match_data could serve that purpose, and have a
sub-structure called qca8k_ops for function pointers, yes.
