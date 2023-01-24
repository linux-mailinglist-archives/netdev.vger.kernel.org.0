Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D639867A416
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 21:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjAXUmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 15:42:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjAXUmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 15:42:36 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789EB4CE6B
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 12:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nJAt4cmvoc2E8mt+JMyXT9a/0LJRn7UxQz6VMh1Qwlk=; b=UT+gS42NtUjTS88VkCyWQSP5Nm
        FUSY2z3t88zYTSMmektowl0MapMWwUgGh5WB+kS2QcHhULLQ3TnIeU8FBhDfn1QWlwashl2mRmk+X
        dP4fCdKFhtQLjC7Pfu/l28RUGnTBeVDxPLEnPax9FWGRfaqtRR7N13uiGQ/2YYSSpvYw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pKQ7a-0033Bh-5c; Tue, 24 Jan 2023 21:42:22 +0100
Date:   Tue, 24 Jan 2023 21:42:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Keller Jacob E <jacob.e.keller@intel.com>
Subject: Re: PHY firmware update method
Message-ID: <Y9BCrtlXXGO5WOKN@lunn.ch>
References: <bf53b9b3660f992d53fe8d68ea29124a@walle.cc>
 <YzQ96z73MneBIfvZ@lunn.ch>
 <YzVDZ4qrBnANEUpm@nanopsycho>
 <YzWPXcf8kXrd73PC@lunn.ch>
 <20220929071209.77b9d6ce@kernel.org>
 <YzWxV/eqD2UF8GHt@lunn.ch>
 <Yzan3ZgAw3ImHfeK@nanopsycho>
 <Yzbi335GQGbGLL4k@lunn.ch>
 <ced75f7f596a146b58b87dd2d6bad210@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ced75f7f596a146b58b87dd2d6bad210@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So if you'd do this during the PHY probe, it might try to update the
> firmware on every boot and fail. Would that be acceptable?

Do you have a feeling how long that takes?

Also, is it possible to put the firmware into RAM and run it from
there, rather than put it into the EEPROM?

> How long could can a firmware update during probe run? Do we need
> to do it in the background with the PHY being offline. Sounds like
> not something we want.

One device being slow to probe will slow down the probe of that
bus. But probe of other busses should be unaffected. I _guess_ it
might have a global affect on EPROBE_DEFER, the next cycle could be
delayed?  Probably a question for GregKH, or reading the code.

If it going to be really slow, then i would suggest making use of
devlink and it being a user initiated operation.

	Andrew
