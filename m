Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B70A482041
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 21:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242085AbhL3UWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 15:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240706AbhL3UWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 15:22:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E597C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 12:22:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66065B81D0E
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 20:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1DD5C36AE7;
        Thu, 30 Dec 2021 20:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640895749;
        bh=h3aoCQXp9xEPsDTddsIB9oIvYNZzdWIBGd76LIl7oCc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ir67muUMPsRu+eKkBE8oRSkHj/IaSQ697SAD3m7NEZSsijMWEbkDRC2bGnog793OZ
         Way8/1bfNLa2OENtSV6bn83JkURB3HOZMynZd1RRzEIoPPghJC8RiyOqf9XEU4Bsd5
         xXdjyA/Q8l8x6SWmvIdknaqwx1L5SrS/2a0xm84M8Nsx1N3K4wykT69zRNBAWzUUuQ
         hpLmIu4lUc3isz8Mt47DS3OFI/tCLZzWthWlzw2JiHiVALZ6n5Qhv6JMTHgz2G3vmr
         QMp4DUmMDDvzabm/t0KiJASYFGahTzWJPQcXxU6UkQtGsx2xfETwzyLdGG1tW+sA8z
         10yZIyetoFE3w==
Date:   Thu, 30 Dec 2021 12:22:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/8] net/funeth: ethtool operations
Message-ID: <20211230122227.6ca6bfb7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <Yc30mG7tPQIT2HZK@lunn.ch>
References: <20211230163909.160269-1-dmichail@fungible.com>
        <20211230163909.160269-5-dmichail@fungible.com>
        <Yc30mG7tPQIT2HZK@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Dec 2021 19:04:08 +0100 Andrew Lunn wrote:
> > +static void fun_get_drvinfo(struct net_device *netdev,
> > +			    struct ethtool_drvinfo *info)
> > +{
> > +	const struct funeth_priv *fp = netdev_priv(netdev);
> > +
> > +	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
> > +	strcpy(info->fw_version, "N/A");  
> 
> Don't set it, if you have nothing useful to put in it.

Also, if user has no way of reading the firmware version how do they
know when to update the FW in the flash? FW flashing seems pointless
without knowing the current FW version.
