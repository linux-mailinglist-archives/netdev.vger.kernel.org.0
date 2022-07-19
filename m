Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03BAC579F48
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243375AbiGSNMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243370AbiGSNMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:12:07 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF69752445;
        Tue, 19 Jul 2022 05:29:35 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id n12so8510836wrc.8;
        Tue, 19 Jul 2022 05:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=BPGA8CVzq5tUbxFgoR8mOaYivOScxzcIsTIwb0n/HjQ=;
        b=NMiRRM4ygQScX6CHZNhNLIowqiO7p3Ujk/WGKHm0kxHmMppumn936uJ3xlCcD7OdU8
         WCNaoh+idQnQNvrRCSe+46CYEAvTnCDMLHqaQ+JBkNOKsVWFyFX14Tjmsi28c2ZeJJIw
         j8Nt22IQCu/K3nKSmEbFHs6UB2KAFVCDbRagp/4KmzpWDpluYlxGZgcoAtzqxfUoBW2O
         b7+AowTiYdriHXKuABNgodpuqfqwddaPPU6ynpCr//WedUN+C8RoOazpmcj/L5OoHmRb
         /ADSip0e6F2LXP+Eu4ScPlz4ADvcY5mRgnhHnu/rQYn9yQwH/OXLq7UvehzkghvYkgPt
         P9PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=BPGA8CVzq5tUbxFgoR8mOaYivOScxzcIsTIwb0n/HjQ=;
        b=7U1kE+bV9jP054dh0aYE6RwyQE9nfshNddSFOtcsju7sJJz23dlZBIzB0UNQ8On+a0
         8t4R9jX6CsxnyiuXFu9NXg3vcpnmEyZyK4siE6jsyFZtedheEdG4oNtwuubyGDLZ+QGc
         VlhGQeXdZv1EelgernDHS/yTG6R+Euj5x0C2egE6u6ioAvi+eypfDyo7B5Mmd0Lpb57V
         C9urnaukMvz6bl6r1QDfgztxMECc3SF27i6fy0gwndqvTAx2z9Pp/rXLptknazdDlgYO
         swRf1LoTwPJdbcnKHmplr2UmzWMuuB92W4NV/RQnoykuxHRv4dVjRmFJ3zmW/tVuIFWI
         YwGA==
X-Gm-Message-State: AJIora91arV3SuRXT3xtllekqCCEg7SPPljxSt8afqpmOxw71mKAgdyq
        Z9X766ajYfYbl+TOBMGBMrQ=
X-Google-Smtp-Source: AGRyM1suSHp0sJMoI1+9oy1P/fM/5Xe4wR6xj5TapIfLUdvodiA4VzWOTw7+k9S6OHTl1eRpbaQd/w==
X-Received: by 2002:a05:6000:144b:b0:21d:a57d:8000 with SMTP id v11-20020a056000144b00b0021da57d8000mr27103882wrx.204.1658233774143;
        Tue, 19 Jul 2022 05:29:34 -0700 (PDT)
Received: from Ansuel-xps. (93-34-208-75.ip51.fastwebnet.it. [93.34.208.75])
        by smtp.gmail.com with ESMTPSA id p6-20020adfe606000000b0021d73772c87sm1518498wrm.91.2022.07.19.05.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 05:29:33 -0700 (PDT)
Message-ID: <62d6a3ad.1c69fb81.8f261.32f5@mx.google.com>
X-Google-Original-Message-ID: <YtajqhJ1/C9Sc2IC@Ansuel-xps.>
Date:   Tue, 19 Jul 2022 14:29:30 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH v2 01/15] net: dsa: qca8k: make mib autocast
 feature optional
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-2-ansuelsmth@gmail.com>
 <20220719005726.8739-2-ansuelsmth@gmail.com>
 <20220719122636.rsfkejgampb5kcp2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719122636.rsfkejgampb5kcp2@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 03:26:36PM +0300, Vladimir Oltean wrote:
> On Tue, Jul 19, 2022 at 02:57:11AM +0200, Christian Marangi wrote:
> > Some switch may not support mib autocast feature and require the legacy
> > way of reading the regs directly.
> > Make the mib autocast feature optional and permit to declare support for
> > it using match_data struct.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> >  drivers/net/dsa/qca/qca8k.c | 11 +++++++----
> >  drivers/net/dsa/qca/qca8k.h |  1 +
> >  2 files changed, 8 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/qca/qca8k.c b/drivers/net/dsa/qca/qca8k.c
> > index 1cbb05b0323f..a57c53ce2f0c 100644
> > --- a/drivers/net/dsa/qca/qca8k.c
> > +++ b/drivers/net/dsa/qca/qca8k.c
> > @@ -2112,12 +2112,12 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
> >  	u32 hi = 0;
> >  	int ret;
> >  
> > -	if (priv->mgmt_master &&
> > -	    qca8k_get_ethtool_stats_eth(ds, port, data) > 0)
> > -		return;
> > -
> >  	match_data = of_device_get_match_data(priv->dev);
> 
> I didn't notice at the time that you already call of_device_get_match_data()
> at driver runtime, but please be aware that it is a relatively expensive
> operation (takes raw spinlocks, iterates etc), or at least much more
> expensive than it needs to be. What other drivers do is cache the result
> of this function once in priv->info and just use priv->info, since it
> won't change during the lifetime of the driver.
>

Ok makes sense. Can I make a patch drop the use of
of_device_get_match_data and then apply this on top?

(we use of_device_get_match_data also in other functions)

> >  
> > +	if (priv->mgmt_master && match_data->autocast_mib &&
> > +	    match_data->autocast_mib(ds, port, data) > 0)
> > +		return;
> > +
> >  	for (i = 0; i < match_data->mib_count; i++) {
> >  		mib = &ar8327_mib[i];
> >  		reg = QCA8K_PORT_MIB_COUNTER(port) + mib->offset;
> > @@ -3260,16 +3260,19 @@ static const struct qca8k_match_data qca8327 = {
> >  	.id = QCA8K_ID_QCA8327,
> >  	.reduced_package = true,
> >  	.mib_count = QCA8K_QCA832X_MIB_COUNT,
> > +	.autocast_mib = qca8k_get_ethtool_stats_eth,
> 
> I thought you were going to create a dedicated sub-structure for
> function pointers?
> 

Sorry... totally forgot this as I was very busy with giving good series.
Will handle this in the next version.

(will be also useful later for the single dsa_switch_ops transition if
we want to put all of them there)

> >  };
> >  
> >  static const struct qca8k_match_data qca8328 = {
> >  	.id = QCA8K_ID_QCA8327,
> >  	.mib_count = QCA8K_QCA832X_MIB_COUNT,
> > +	.autocast_mib = qca8k_get_ethtool_stats_eth,
> >  };
> >  
> >  static const struct qca8k_match_data qca833x = {
> >  	.id = QCA8K_ID_QCA8337,
> >  	.mib_count = QCA8K_QCA833X_MIB_COUNT,
> > +	.autocast_mib = qca8k_get_ethtool_stats_eth,
> >  };
> >  
> >  static const struct of_device_id qca8k_of_match[] = {
> > diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
> > index ec58d0e80a70..c3df0a56cda4 100644
> > --- a/drivers/net/dsa/qca/qca8k.h
> > +++ b/drivers/net/dsa/qca/qca8k.h
> > @@ -328,6 +328,7 @@ struct qca8k_match_data {
> >  	u8 id;
> >  	bool reduced_package;
> >  	u8 mib_count;
> > +	int (*autocast_mib)(struct dsa_switch *ds, int port, u64 *data);
> >  };
> >  
> >  enum {
> > -- 
> > 2.36.1
> > 
> 

-- 
	Ansuel
