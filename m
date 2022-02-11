Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B061E4B2DDB
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 20:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347278AbiBKTgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 14:36:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235772AbiBKTgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 14:36:31 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E179FCF2
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 11:36:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=20gbKtqCAnZ2WEN0ViaHyajOe18mV5M0URgbDSjlFtM=; b=rF4f3nWOKwfgRNS2lwIfF3Kp73
        n/MqZ0Jt3+m6zTZmV+tkjjVfOA0zwFdKYhKzkmfi96rXSbQx9/ejbJKEE0FUTeleucFgfpZognfhv
        bemjXsRwUHVb8GiRZMTZ+Np0ewizb4khPLeLA+oJ+urZVzJwen2E2NMcJVl/I+LsEEZo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nIbiU-005Vrk-Fk; Fri, 11 Feb 2022 20:36:26 +0100
Date:   Fri, 11 Feb 2022 20:36:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: rtl8365mb: read phy regs
 from memory when MDIO
Message-ID: <Yga6ukIalICeD8KK@lunn.ch>
References: <20220209202508.4419-1-luizluca@gmail.com>
 <87leyjhfkx.fsf@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87leyjhfkx.fsf@bang-olufsen.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I am not sure I agree with your description here. It is more likely that
> there is just a bug in the driver, rather than some problem with
> indirect PHY register access "when the switch is under stress". Please
> see my reply to your earlier thread.

I tend to agree. Reading PHY registers happens quite often due to
polling every second, so if there is a problem, this is where you see
it. But how do you know the same issue does not appear somewhere else
in the driver?

Maybe add code to dump the ATU, poll it frequently, and see if any
entries change unexpectedly?

	Andrew
