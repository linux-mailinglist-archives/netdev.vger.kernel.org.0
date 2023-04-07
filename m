Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0196DA767
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 04:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240312AbjDGCG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 22:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240159AbjDGCGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 22:06:12 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037FCB447
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 19:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RG7pDXjUDD1CdAJZN6SfM/Mxy9wYw3wLy7lPu6mh644=; b=lLCshKQ3L1oiaLenXDp0HUeNVL
        8Kn5fNJu4C7q4prxXd5B4So8fFMSRhqOkUv9YDzcJfX93zunK72DXn0e49AvxcSBGzd/bC/0X2kIB
        o+60SzCJsh7FB7YDe3WKcSc+6Xf7LawI1Vb/YRGn2gLmNmE578+DNqQgVKGZRDniIC6g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pkbRt-009gWB-MQ; Fri, 07 Apr 2023 04:03:33 +0200
Date:   Fri, 7 Apr 2023 04:03:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next 2/6] net: txgbe: Implement I2C bus master driver
Message-ID: <9ae32ffd-8e56-4d90-9952-158a6319b1d7@lunn.ch>
References: <20230403064528.343866-1-jiawenwu@trustnetic.com>
 <20230403064528.343866-3-jiawenwu@trustnetic.com>
 <5071701f-bf69-4fa7-ad43-b780afd057a1@lunn.ch>
 <03fc01d9669f$cb8cb610$62a62230$@trustnetic.com>
 <3086ecbc-2884-4743-9953-96f2a225ddbb@lunn.ch>
 <000001d96855$55648460$002d8d20$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001d96855$55648460$002d8d20$@trustnetic.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> By consulting with hardware designers, our I2C licensed the IP of
> Synopsys.
> But I can't use the I2C_DESIGNWARE_CORE directly, because IRQ is not
> supported in our I2C.

When you repost this patch and Cc: the i2c list, please point this
out. Please also Cc: the Designware I2C maintainers. They might have
some ideas how the driver can be used in polled mode.

Ideally, you want to use the existing driver, since it has hardware
work around, optimisations, and probably less bugs because it is used
and tested a lot.

And it is not too unusual for interrupt support to be missing. The
ocores driver can be used without interrupts. And there is sometimes a
polled mode supported so you can for example use the I2C bus to talk
to the power controller to turn the power at the end of shutdown when
nearly everything has stop working.

	Andrew
