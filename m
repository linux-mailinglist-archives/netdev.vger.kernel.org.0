Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750025BE59E
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 14:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiITMWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 08:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiITMWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 08:22:51 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3A874CDC
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 05:22:50 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id f20so3553176edf.6
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 05:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Y5LAXXzXFv4RyahpvK+R3PHT3WOgII02Ou55JA0/yUM=;
        b=CfwD+Nj/Xok0vXtyofmRM937ETe1lyUjOx7M5ptKoTWan7yzN4Xk+MvI2a2r/DR6jw
         QhrpOLrAZDljgAHdLoccioS2iGRNtOMx1KSn84jduXJy7LQf9QK/B6Vfu6yDOsj06AKJ
         wfNC03orZYBma1pOxi2szOU+R3cm6wmIzpjfQO6VbLkkFqxqH/c1h84Ry7rSLo7h+A34
         PaMskF6L7tse7fLPMRsbzolvNyILfcZ3tTJgrYf9dOBfhhFh2ica5qQP8AJWjiFLolV8
         15TK3Uw/z5glMjsP1nyNknU7kakuDmvF0ZjoVVZ6j4qm5PSiXt/3OqLtcGpJNBiw0Z/E
         2bVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Y5LAXXzXFv4RyahpvK+R3PHT3WOgII02Ou55JA0/yUM=;
        b=qH2YHyHq4bVGZIOHFuO9w8GQdP5e4lgo8b66ErzZ+mLM2HdpsNlZ+hU6n5J12Ww6W3
         /ljI9VJ6KiNuB4tUE6NeDnkZUgnMu0S2OoTamZPYfVkYej0dRKYa+aAcxISkh0XVzWgz
         cC0jeJInCBANvNYcQ1obh4mb6M4juJWq00IR7os+z+KyBqf8/Jty4ZpwwpK+fxvPpvN6
         7OJXwsUXTPCebsrMyEiVzt2Z94oHj7J1FPaEfQphTWh0eP6nEAe8cHsyWhaCrP6AuHBk
         vriEREhsiXgwheAX3sxvzkf4O649ZmJQXaijZdYHrLSSVUqql4QzSalj7Jzs003vSpRG
         L34w==
X-Gm-Message-State: ACrzQf1iM4CDSV50tUkuiaYWEAC09uEH5loSGFlzO8RQVSRJTWia1vie
        TJtav6XTMMSSIzwEicpkQCM=
X-Google-Smtp-Source: AMsMyM51DYuFbJEPW/fIsli8W/gouC7+5tyL0MVw9GzHjHYhg4urBL3ZI4l1x8y+rixpZ3MAxRwlDg==
X-Received: by 2002:a05:6402:2694:b0:450:d537:f6d6 with SMTP id w20-20020a056402269400b00450d537f6d6mr20259133edd.344.1663676569239;
        Tue, 20 Sep 2022 05:22:49 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id v17-20020a170906293100b0076fa6d9d891sm766536ejd.46.2022.09.20.05.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 05:22:48 -0700 (PDT)
Date:   Tue, 20 Sep 2022 15:22:46 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
Subject: Re: [PATCH net-next v14 4/7] net: dsa: mv88e6xxxx: Add RMU
 functionality.
Message-ID: <20220920122246.4v2rlqmm6ciembfc@skbuf>
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-5-mattias.forsblad@gmail.com>
 <20220919110847.744712-5-mattias.forsblad@gmail.com>
 <20220919223933.2hh4hhci3pj33lrj@skbuf>
 <2be57208-61fe-95f6-f70a-b3a86f5024a1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2be57208-61fe-95f6-f70a-b3a86f5024a1@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 01:53:36PM +0200, Mattias Forsblad wrote:
> On 2022-09-20 00:39, Vladimir Oltean wrote:
> >> +void mv88e6xxx_master_state_change(struct dsa_switch *ds, const struct net_device *master,
> >> +				   bool operational)
> >> +{
> >> +	if (operational && chip->info->ops->rmu_enable) {
> > 
> > This all needs to be rewritten. Like here, if the master is operational
> > but the chip->info->ops->rmu_enable method is not populated, you call
> > mv88e6xxx_disable_rmu(). Why?
> 
> So what should we do in this case?

Nothing, obviously.

> If the master is operational but we cannot enable rmu (bc no funcptr),
> we cannot use RMU -> disable RMU.

Again, the RMU should start as disabled. Then why
would you call mv88e6xxx_disable_rmu() a million times as the master
goes up and down, if the switch doesn't support chip->info->ops->rmu_enable()?

In fact, the RMU _is_ disabled, since mv88e6xxx_rmu_setup() has:

int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip)
{
	mutex_init(&chip->rmu.mutex);

	/* Remember original ops for restore */
	chip->rmu.smi_ops = chip->smi_ops;
	chip->rmu.ds_ops = chip->ds->ops;

	/* Change rmu ops with our own pointer */
	chip->rmu.smi_rmu_ops = (struct mv88e6xxx_bus_ops *)chip->rmu.smi_ops;
	chip->rmu.smi_rmu_ops->get_rmon = mv88e6xxx_rmu_stats_get;

	/* Also change get stats strings for our own */
	chip->rmu.ds_rmu_ops = (struct dsa_switch_ops *)chip->ds->ops;
	chip->rmu.ds_rmu_ops->get_sset_count = mv88e6xxx_stats_get_sset_count_rmu;
	chip->rmu.ds_rmu_ops->get_strings = mv88e6xxx_stats_get_strings_rmu;

	/* Start disabled, we'll enable RMU in master_state_change */
	if (chip->info->ops->rmu_disable)
		return chip->info->ops->rmu_disable(chip);

	return 0;
}

But mv88e6xxx_disable_rmu() has:

static void mv88e6xxx_disable_rmu(struct mv88e6xxx_chip *chip)
{
	chip->smi_ops = chip->rmu.smi_ops;
	chip->ds->ops = chip->rmu.ds_rmu_ops;
	chip->rmu.master_netdev = NULL;

	if (chip->info->ops->rmu_disable)
		chip->info->ops->rmu_disable(chip);
}

Notice in mv88e6xxx_disable_rmu() how:

- all calls to chip->info->ops->rmu_disable() are redundant when
  chip->info->ops->rmu_enable() isn't available.

- the mumbo jumbo pointer logic with chip->smi_ops and chip->ds->ops is
  buggy but at the same time not in the obvious way. What is obvious is
  that you surely don't mean to assign "chip->ds->ops = chip->rmu.ds_rmu_ops;",
  but rather "chip->ds->ops = chip->rmu.ds_ops;". But this does not
  truly matter.

This is because juggling the chip->ds->ops pointer itself is not how you
make mv88e6xxx_get_ethtool_stats() call MDIO or Ethernet-based ops. This
is because in reality in your implementation, ds_rmu_ops and ds_ops (and
same goes for smi_ops and smi_rmu_ops) point to the same data structure.
And when you do this:

	/* Change rmu ops with our own pointer */
	chip->rmu.smi_rmu_ops = (struct mv88e6xxx_bus_ops *)chip->rmu.smi_ops;
	chip->rmu.smi_rmu_ops->get_rmon = mv88e6xxx_rmu_stats_get;

you change the get_rmon() operation of _both_ smi_rmu_ops and smi_ops,
because you dereference two pointers which have the same value.

Therefore, when you attempt to collect ethtool stats, you dereference
"our own" RMU based pointer, regardless of whether RMU is available or
not:

static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
					uint64_t *data)
{
	struct mv88e6xxx_chip *chip = ds->priv;

	chip->smi_ops->get_rmon(chip, port, data);
}

This will proceed to access stuff that isn't available, such as the
master netdev, and crash the kernel.
