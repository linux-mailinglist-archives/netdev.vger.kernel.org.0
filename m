Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F6C5A7124
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 00:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbiH3Wwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 18:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiH3Wwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 18:52:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A8D76952;
        Tue, 30 Aug 2022 15:52:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85F34615CE;
        Tue, 30 Aug 2022 22:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBEE4C433C1;
        Tue, 30 Aug 2022 22:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661899962;
        bh=7YJfVish+HMo8CE/dymFlMhBZLFJKrCcsEVRRAtj9OQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DBcIeeOpAN6U+G1upsNezDiLDtf9ggrZeDKSGl5MKp0TygDiDEtoIE1o2tCpUwrur
         W3lV5w8ZedZYBTICowt3ERTeC3pUiVEuhOYNscWYe6tVADRX8gx5SlaPPbsGj0uCRs
         meCMa1mtAa8G5j7kyoul9QoTobDcWp+INZVcXJbbj0lE3lLIeqvfDOCW1pa8MtlqKt
         BbPbuWPmsYTkfvnTTro66jDaAfm79C4qkJt1FYWVZ+/vtcPw0oLd0MsxR7CW7AIDbJ
         s4lx99s+deK94GWPM8p6+Tsl7IOVCF7kA66kf29VZwiesVhBTt7VrzQmsJgaX3khux
         +JHDZEkizSZXQ==
Date:   Tue, 30 Aug 2022 15:52:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        kernel test robot <lkp@intel.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v4 5/7] ethtool: add interface to interact with
 Ethernet Power Equipment
Message-ID: <20220830155240.48079637@kernel.org>
In-Reply-To: <20220828063021.3963761-6-o.rempel@pengutronix.de>
References: <20220828063021.3963761-1-o.rempel@pengutronix.de>
        <20220828063021.3963761-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 28 Aug 2022 08:30:19 +0200 Oleksij Rempel wrote:
> Add interface to support Power Sourcing Equipment. At current step it
> provides generic way to address all variants of PSE devices as defined
> in IEEE 802.3-2018 but support only objects specified for IEEE 802.3-2018 104.4
> PoDL Power Sourcing Equipment (PSE).
> 
> Currently supported and mandatory objects are:
> IEEE 802.3-2018 30.15.1.1.3 aPoDLPSEPowerDetectionStatus
> IEEE 802.3-2018 30.15.1.1.2 aPoDLPSEAdminState
> IEEE 802.3-2018 30.15.1.2.1 acPoDLPSEAdminControl

warning here:

drivers/net/pse-pd/pse_core.c:304: warning: Function parameter or member 'status' not described in 'pse_ethtool_get_status'
