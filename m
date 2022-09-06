Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10585AE830
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 14:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbiIFMcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 08:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240198AbiIFMb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 08:31:26 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BA7DEE1
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 05:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1kzfapkYvUtyD1GecYbbzqpC5O7ydKk+Lr+D5lNt2zw=; b=ZEPinqrqZoZn9SYZt2XYT8UdxZ
        PXyehOW+uBSuanNgikvH1ob80RALSgmHI+AY4RYBtoWObSbE+CuL1CYZkoouakn1oCkTGsZum7iS7
        a98B2iATsFaBzV6yCaPEbq7GPZFMQDYQDl4YvVooN4rKL3XZUHKo1emm6J4NPkPIZg2I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oVXhy-00FkRx-2c; Tue, 06 Sep 2022 14:29:38 +0200
Date:   Tue, 6 Sep 2022 14:29:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v4 1/6] net: dsa: mv88e6xxx: Add RMU enable for
 select switches.
Message-ID: <Yxc9MjVI+afjcNcp@lunn.ch>
References: <20220906063450.3698671-1-mattias.forsblad@gmail.com>
 <20220906063450.3698671-2-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906063450.3698671-2-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +int mv88e6085_g1_rmu_enable(struct mv88e6xxx_chip *chip, int upstream_port)
> +{
> +	int val = MV88E6352_G1_CTL2_RMU_MODE_DISABLED;
> +
> +	dev_dbg(chip->dev, "RMU: Enabling on port %d", upstream_port);
> +
> +	switch (upstream_port) {

>  
> +int mv88e6352_g1_rmu_enable(struct mv88e6xxx_chip *chip, int port)
> +{
> +	int val = MV88E6352_G1_CTL2_RMU_MODE_DISABLED;
> +	int upstream_port;
> +
> +	upstream_port = dsa_switch_upstream_port(chip->ds);
> +	dev_dbg(chip->dev, "RMU: Enabling on port %d", upstream_port);
> +	if (upstream_port < 0)
> +		return -EOPNOTSUPP;
> +
> +	switch (upstream_port) {

> +int mv88e6390_g1_rmu_enable(struct mv88e6xxx_chip *chip, int upstream_port)
> +{
> +	int val = MV88E6390_G1_CTL2_RMU_MODE_DISABLED;
> +
> +	dev_dbg(chip->dev, "RMU: Enabling on port %d", upstream_port);
> +
> +	switch (upstream_port) {


Why is 6352 different to 6085 and 6390? This is the sort of thing
which should be explained in the commit message. The commit message is
about the 'Why?' of the change. You could explain why there is this
difference, so a reviewer does not need to ask.

	    Andrew
