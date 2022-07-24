Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DAE57F791
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 01:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbiGXXAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 19:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbiGXXAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 19:00:39 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA58633E;
        Sun, 24 Jul 2022 16:00:38 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id l23so17571091ejr.5;
        Sun, 24 Jul 2022 16:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=Keh89xEWaqeLHnEQWillHoB7z/9qevNgDhvRUsNleVI=;
        b=EgkkkofnnCV1ik6b2VRTSA2xrsy6PBABK9Ilu8SNkcfKHuhP5/mHDTmvs8Yg1KoThQ
         DIaNy1tAzVyiTd+gQdqCdKxSA5JrCfpLB/Y7BYaaCErMTDij0xHI8BBeGvPP8H/y2cIo
         jSH590RrsS1Dq7x5Ao+USKawxeyJi9OAiUefMUyEyWnnbZU5h1kQ5gonn///VAvZOkRP
         CVZhQWcYFFWbbywod6mJYU7Ag3YttzIA8xtQVfZRvc2yKgI06mZwmGSVA0zsoQj30rLl
         /NxVdRmOUBTTZlVwCj5Bn1p8mU4Wi4yy3eKBrlRqNeRgefL+2N4vJ66jlTBjUMpasYEn
         MdNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=Keh89xEWaqeLHnEQWillHoB7z/9qevNgDhvRUsNleVI=;
        b=oeYARvTSazEzi3ly6SvGMbrx12Rqs00gYR6kDVrvCp1boKY26Y9BZDQfBCWXJUtvGO
         P1h8J2CKyVUmuadrFTw/y+Cj1iM9mfIaq/4iTIWY6HZX6IuSksh8yMysZbT6QH6rHpvv
         8DBVGfNcOh27nVQhDacfw8XLmlkwly6eEKBqpY98/9NBTOiXlswn8OQDve0Bueg2A/mb
         r+wh2bcOBtgw4gjGS4dimX3D00Jnr0f+KUXNzaFrEO90JnSA47aMv7ulG96ZCM9xR1RU
         VWvFO3nyvuBIcEfz4DqgsRqZ4OIiJH8hkA3ZgyR9T50L6cQodXtrRtp0/R5aSaEwPB0k
         hPbg==
X-Gm-Message-State: AJIora+yX1eDTajQNxqaxeVx52WbDxOePZNOY2jIEbflywSKwEjD8HeB
        cuGFUfMuQC1CrBPubsnZzWc=
X-Google-Smtp-Source: AGRyM1unvscgWF72a7GwFlwMoNkkzt8sAmc5b5ZfFzoP5SWFEAn2Uo/Hmu7tLrUA+qDLd1V48gND7A==
X-Received: by 2002:a17:906:6a14:b0:72b:64bd:ea2b with SMTP id qw20-20020a1709066a1400b0072b64bdea2bmr7622299ejc.680.1658703636255;
        Sun, 24 Jul 2022 16:00:36 -0700 (PDT)
Received: from Ansuel-xps. (93-42-69-122.ip85.fastwebnet.it. [93.42.69.122])
        by smtp.gmail.com with ESMTPSA id k7-20020aa7c047000000b0043a85d7d15esm6183928edo.12.2022.07.24.16.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 16:00:35 -0700 (PDT)
Message-ID: <62ddcf13.1c69fb81.9cb3a.d7a8@mx.google.com>
X-Google-Original-Message-ID: <Yt2rniVkrYhYhO3e@Ansuel-xps.>
Date:   Sun, 24 Jul 2022 22:29:18 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH v3 02/14] net: dsa: qca8k: make mib autocast
 feature optional
References: <20220723141845.10570-1-ansuelsmth@gmail.com>
 <20220723141845.10570-1-ansuelsmth@gmail.com>
 <20220723141845.10570-3-ansuelsmth@gmail.com>
 <20220723141845.10570-3-ansuelsmth@gmail.com>
 <20220724223348.tqh45ygbuyw7jp5s@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220724223348.tqh45ygbuyw7jp5s@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 01:33:48AM +0300, Vladimir Oltean wrote:
> On Sat, Jul 23, 2022 at 04:18:33PM +0200, Christian Marangi wrote:
> > Some switch may not support mib autocast feature and require the legacy
> > way of reading the regs directly.
> > Make the mib autocast feature optional and permit to declare support for
> > it using match_data struct in a dedicated qca8k_info_ops struct.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> >  drivers/net/dsa/qca/qca8k.c | 11 +++++++++--
> >  drivers/net/dsa/qca/qca8k.h |  5 +++++
> >  2 files changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/qca/qca8k.c b/drivers/net/dsa/qca/qca8k.c
> > index 212b284f9f73..9820c5942d2a 100644
> > --- a/drivers/net/dsa/qca/qca8k.c
> > +++ b/drivers/net/dsa/qca/qca8k.c
> > @@ -2104,8 +2104,8 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
> >  	u32 hi = 0;
> >  	int ret;
> >  
> > -	if (priv->mgmt_master &&
> > -	    qca8k_get_ethtool_stats_eth(ds, port, data) > 0)
> > +	if (priv->mgmt_master && priv->info->ops.autocast_mib &&
> > +	    priv->info->ops.autocast_mib(ds, port, data) > 0)
> >  		return;
> >  
> >  	for (i = 0; i < priv->info->mib_count; i++) {
> > @@ -3248,20 +3248,27 @@ static int qca8k_resume(struct device *dev)
> >  static SIMPLE_DEV_PM_OPS(qca8k_pm_ops,
> >  			 qca8k_suspend, qca8k_resume);
> >  
> > +static const struct qca8k_info_ops qca8xxx_ops = {
> > +	.autocast_mib = qca8k_get_ethtool_stats_eth,
> > +};
> > +
> >  static const struct qca8k_match_data qca8327 = {
> >  	.id = QCA8K_ID_QCA8327,
> >  	.reduced_package = true,
> >  	.mib_count = QCA8K_QCA832X_MIB_COUNT,
> > +	.ops = qca8xxx_ops,
> >  };
> >  
> >  static const struct qca8k_match_data qca8328 = {
> >  	.id = QCA8K_ID_QCA8327,
> >  	.mib_count = QCA8K_QCA832X_MIB_COUNT,
> > +	.ops = qca8xxx_ops,
> >  };
> >  
> >  static const struct qca8k_match_data qca833x = {
> >  	.id = QCA8K_ID_QCA8337,
> >  	.mib_count = QCA8K_QCA833X_MIB_COUNT,
> > +	.ops = qca8xxx_ops,
> >  };
> >  
> >  static const struct of_device_id qca8k_of_match[] = {
> > diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
> > index 0b990b46890a..7b4a698f092a 100644
> > --- a/drivers/net/dsa/qca/qca8k.h
> > +++ b/drivers/net/dsa/qca/qca8k.h
> > @@ -324,10 +324,15 @@ enum qca8k_mid_cmd {
> >  	QCA8K_MIB_CAST = 3,
> >  };
> >  
> > +struct qca8k_info_ops {
> > +	int (*autocast_mib)(struct dsa_switch *ds, int port, u64 *data);
> > +};
> > +
> >  struct qca8k_match_data {
> >  	u8 id;
> >  	bool reduced_package;
> >  	u8 mib_count;
> > +	struct qca8k_info_ops ops;
> 
> This creates a copy of the structure for each of qca8327, qca8328, etc etc,
> which in turn will consume 3 times more space than necessary when new
> ops are added. Could you make this "const struct qca8k_ops *ops"?
> 

I already done this change in v4 as it was causing compilation error for
kernel test bot.

> >  };
> >  
> >  enum {
> > -- 
> > 2.36.1
> > 
> 

-- 
	Ansuel
