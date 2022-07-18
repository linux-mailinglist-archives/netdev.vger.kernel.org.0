Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF44057888F
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235840AbiGRRhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233840AbiGRRhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:37:17 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44EE2CDCF;
        Mon, 18 Jul 2022 10:37:16 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id h17so18175347wrx.0;
        Mon, 18 Jul 2022 10:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=89LueDwYl0duroy1Gw7gsJ7/wgtNv0BCBZcurmst9Rs=;
        b=nstMczfYmps6GHFiwCc34QUx+IHcM3RFiwIIDPN7SCzMIJ4ql4MyHLJzMkNNZePttw
         2nchbwCukjVKZfD2HCZDiIETV2okItHYOnaha5NdeNtpd8YLNu3RlU1+bREtjMlnN5Jn
         AZTuk8uLReaQW9dzbj2jj2apWawHOoYoJ590fT32IvMyBGQS8xNUlNZCPK4WlyWvCMqB
         V39qyNEjLXqeUQqmYPYHkQsRzD6LpuxefVAlOY0W0KYfUCuio0oQ8At3AkzhOcUdA+UL
         uQ+ZOvmbUYHfzOnFaIesKc53snVY66ewNg89vH6s99ZgSkaHmEY1pHS966LFRlYi3zzM
         bSBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=89LueDwYl0duroy1Gw7gsJ7/wgtNv0BCBZcurmst9Rs=;
        b=MfqjRVwjy1uWWhncnhTlotPov8eBoa46kTYHlJOjj0n3DGtmhFPGxUsGDi8yf4Togm
         W8XHbLEUzoqaVDuuiRC9n32khBq34XwWFgTuoWnklFOsVYNuQ0nbas9RfpcP7I6/bT9g
         Q5syNfG3BVlBzl9+T8580sWL167gJnGbhPvogZ4TMoy89xPs9/7SFOYiNuXHDlhgY/Zd
         NZAVODBaHu5A8b+OkIXCSdb99MyQBgJCBkHe3MV2uZiNBcLCgM8jHElT59l9UmMA+Lf+
         u+aF2d5ol3hm9IQ+NYjRk5JrOyX0BpfzKENsKvn4w1nBAQaOf/ziYyIpmyxZWuwVIChJ
         2/MA==
X-Gm-Message-State: AJIora8ZhrOc6ec/xB9VYGLISOs2hPUoNfIZJ40htgCvbisLU2DHwBg5
        0ymdNJvzAv5g4UWcoIpIORk=
X-Google-Smtp-Source: AGRyM1skMY2wGb3PBAwfdnqbo/q3VlXuNrcn04ToILXbm5N5Up/cCGi13MX96gl7AZ3wo3C63bDOHg==
X-Received: by 2002:a5d:6d8a:0:b0:21d:a6f3:f458 with SMTP id l10-20020a5d6d8a000000b0021da6f3f458mr24063615wrs.574.1658165835162;
        Mon, 18 Jul 2022 10:37:15 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id m21-20020a05600c4f5500b0039c5ab7167dsm19587623wmq.48.2022.07.18.10.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 10:37:14 -0700 (PDT)
Message-ID: <62d59a4a.1c69fb81.c7f5e.b841@mx.google.com>
X-Google-Original-Message-ID: <YtWWR/QTELutW20+@Ansuel-xps.>
Date:   Mon, 18 Jul 2022 19:20:07 +0200
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
Subject: Re: [net-next RFC PATCH 3/4] net: dsa: qca8k: rework mib autocast
 handling
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
 <20220716174958.22542-1-ansuelsmth@gmail.com>
 <20220716174958.22542-4-ansuelsmth@gmail.com>
 <20220716174958.22542-4-ansuelsmth@gmail.com>
 <20220718172712.xlrcnel6njflmhli@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718172712.xlrcnel6njflmhli@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 08:27:12PM +0300, Vladimir Oltean wrote:
> On Sat, Jul 16, 2022 at 07:49:57PM +0200, Christian Marangi wrote:
> > In preparation for code split, move the autocast mib function used to
> > receive mib data from eth packet in priv struct and use that in
> > get_ethtool_stats instead of referencing the function directly. This is
> > needed as the get_ethtool_stats function will be moved to a common file.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> 
> Can this change be deferred until there actually appears a second
> implementation of (*autocast_mib)?
>

Mhhh it would be problematic since I would like to move the ethtools
stats function to common code and keep the autocast_mib handler in the
qca8k specific code.

An alternative would be to keep the entire ethtool stats function in
qca8k specific code but it needs to be moved anyway.

This change is required as probably ipq4019 mmio will be faster to
access mib data than using the autocast way.

Tell me how to proceed. Think to skip this we have to leave ethtool
stats function in qca8k specific code and move it later?

> > diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
> > index 22ece14e06dc..a306638a7100 100644
> > --- a/drivers/net/dsa/qca/qca8k.h
> > +++ b/drivers/net/dsa/qca/qca8k.h
> > @@ -403,6 +403,7 @@ struct qca8k_priv {
> >  	struct qca8k_mdio_cache mdio_cache;
> >  	struct qca8k_pcs pcs_port_0;
> >  	struct qca8k_pcs pcs_port_6;
> > +	int (*autocast_mib)(struct dsa_switch *ds, int port, u64 *data);
> 
> Typically we hold function pointers in separate read-only structures rather
> than in the stateful private structure of the driver, see struct sja1105_info,
> struct felix_info, struct mv88e6xxx_info and mv88e6xxx_ops, struct b53_io_ops,
> etc etc.
> 

Oh ok it's just match data. We should already have something like that
in qca8k but I wasn't aware of the _info suffix. If we decide to keep
this, can i allign the match struct we use in qca8k to the new pattern
and add the function pointer there?

> >  };
> >  
> >  struct qca8k_mib_desc {
> > -- 
> > 2.36.1
> > 
> 

-- 
	Ansuel
