Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA5469F894
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 17:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbjBVQEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 11:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbjBVQEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 11:04:36 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A1228239;
        Wed, 22 Feb 2023 08:04:34 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 6526C135F;
        Wed, 22 Feb 2023 17:04:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1677081872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=76cayo67pkFFi6LVhhUURSP7LY1mRkgVwE+22TlVNoc=;
        b=ttXS8wafzDu8V+5fzC7+Az594CUyxcEzX4m8kZ6D410KvyI54TeNQjCegmo7TE5yrclgaB
        PLdYD6b+Lh3dXID6AiYSeBTZfL+c0/T0SbIuIPASYDqfppc8uh2o5kg/1vS00B+CQ2xP42
        BBmnewINRM4ij3u0rKjccFhPbAEvxbaHMAwAEs49gZcNEaVwbVVdLpbgnLqs4aWo03wb7/
        zvhQBtmcL9RxxO9C+b/pISvxs+Y0n22D4OppSt+zfMvHlhuQSWxdMBSSjnE9ylhdPfqIkM
        cNMxoxwcdlb2Ou0TGfFBsWaPMXD8+nexRrWcjhzlYfm7goKJfhK0fjhnptDnyg==
From:   Michael Walle <michael@walle.cc>
To:     tharvey@gateworks.com
Cc:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        hauke@hauke-m.de, hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        martin.blumenstingl@googlemail.com, ms@dev.tdt.de,
        netdev@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next v6] net: phy: intel-xway: Add RGMII internal delay configuration
Date:   Wed, 22 Feb 2023 17:04:25 +0100
Message-Id: <20230222160425.4040683-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAJ+vNU3_8Gk8Mj_uCudMz0=MdN3B9T9pUOvYtP7H_B0fnTfZmg@mail.gmail.com>
References: <CAJ+vNU3_8Gk8Mj_uCudMz0=MdN3B9T9pUOvYtP7H_B0fnTfZmg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tim, Hi Martin,

> I've got some boards with the GPY111 phy on them and I'm finding that
> modifying XWAY_MDIO_MIICTRL to change the skew has no effect unless I
> do a soft reset (BCMR_RESET) first. I don't see anything in the
> datasheet which specifies this to be the case so I'm interested it
> what you have found. Are you sure adjusting the skews like this
> without a soft (or hard pin based) reset actually works?

I do have the same PHY and I'm puzzled with the delay settings. Do
you have an EEPROM attached to the PHY? According to my datasheet,
that seems to make a difference. Apparently, only if there is an
EEPROM, you can change the value (the value is then also written to
the EEPROM according the datasheet).
If you don't have one, the values will get overwritten by the
external strappings on a soft reset. Therefore, it seems they cannot
be set. (FWIW there is also a sticky bit, but that doesn't seem to
help in this case).

-michael
