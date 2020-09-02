Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9A425AB10
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 14:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgIBMX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 08:23:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37928 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726674AbgIBMXV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 08:23:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kDRn2-00Ct5h-Cb; Wed, 02 Sep 2020 14:23:00 +0200
Date:   Wed, 2 Sep 2020 14:23:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alex Elder <elder@linaro.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: COMPILE_TEST
Message-ID: <20200902122300.GA3071395@lunn.ch>
References: <d615e441-dcee-52a8-376b-f1b83eef0789@linaro.org>
 <20200901214852.GA3050651@lunn.ch>
 <20200901171738.23af6c63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <18f4418f-0ca0-bd5d-10fc-998b4689f9e5@infradead.org>
 <1743f479-68c8-5f27-8d35-e17d5c96b60a@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1743f479-68c8-5f27-8d35-e17d5c96b60a@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > It would be good to know which other CONFIG symbols and header files
> > are known to work (or expected to work) like this.
> > 
> > Having these stubs allows us to always either omit e.g.
> > 	depends on GPIOLIB
> 
> The above could only be done if the dependency is simply for
> linkage and not functionality.  Maybe that makes sense in
> some cases but it seems like a mistake.

It depends on the subsystem. debugfs is totally optional and you
should not be able to tell if it is enabled or not from what its API
returns.

Most subsystems stubs will return -EOPNOTSUPP. If the driver does
every get probed, it is then likely to fail in a controlled manor.

As the name implies COMPILE_TEST is all about build tested, and less
about boot testing. There might be some test farms which actually boot
kernels compiled with COMPILE_TEST, but that in itself should not be a
problem. Drivers only get probed if there is some indication the
hardware actually exists, PCI enumeration, USB enumeration, device
tree, etc.

      Andrew
