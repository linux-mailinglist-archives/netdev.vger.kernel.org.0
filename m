Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37518627107
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 17:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235350AbiKMQsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 11:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbiKMQsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 11:48:54 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB04BC8D;
        Sun, 13 Nov 2022 08:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=G3CZ56ybDleLJm2kN+uSFznFQhOcErtx2ALKqkrvU3M=; b=WSqKn1e5Iv6xaMAv8Fn/ulw9uh
        jqF3AfQnjxhTMlGTnTFpJTu1w+kATpqd4ZoTRkBEgxo9NO5ux+ysvTz38tp1XNOOmC0RWdLPnlYgH
        kpoOmvWKSJMYZ2H6f5xBM9gh/Hx4hv5nfBJUBON5vtAsjiLVBa7p++jC4S9/ZAx15Xmg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ouG9o-002FbT-DJ; Sun, 13 Nov 2022 17:48:32 +0100
Date:   Sun, 13 Nov 2022 17:48:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 0/3] can: etas_es58x: report firmware, bootloader and
 hardware version
Message-ID: <Y3Ef4K5lbilY3EQT@lunn.ch>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221113040108.68249-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221113040108.68249-1-mailhol.vincent@wanadoo.fr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 13, 2022 at 01:01:05PM +0900, Vincent Mailhol wrote:
> The goal of this series is to report the firmware version, the
> bootloader version and the hardware revision of ETAS ES58x
> devices.
> 
> These are already reported in the kernel log but this isn't best
> practise. Remove the kernel log and instead export all these in
> sysfs. In addition, the firmware version is also reported through
> ethtool.

Sorry to only comment on version 3, rather than version 1. I don't
normally look at CAN patches.

Have you considered using devlink?

https://www.kernel.org/doc/html/latest/networking/devlink/devlink-info.html

fw and asic.id would cover two of your properties. Maybe talk to Jiri
about the bootloader. It might make sense to add it is a new common
property, or to use a custom property.

devlink has the advantage of being a well defined, standardised API,
rather than just random, per device sys files.

There might also be other interesting features in devlink, once you
have basic support. Many Ethernet switch drivers use devlink regions
to dump all the registers, for example. Since there is a bootloader, i
assume the firmware is upgradeable? devlink supports that.

	  Andrew
