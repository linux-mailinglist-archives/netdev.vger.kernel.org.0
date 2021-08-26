Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E310F3F8879
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 15:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242629AbhHZNO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 09:14:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43138 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242578AbhHZNOZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 09:14:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=e1rYrhfrtOiTIjo0IHzJZeE0Xa8Rxjj6cG2GX4KDlKE=; b=5fouSf2s/UWUhO7p7gJjRBCev7
        CspK1pigRIeS1r7r7NkYfrmv3RxavwdAbL+1A1n60EDKRIyhXd4N/UrwdIQUnR78gUY1YAHDHdDbF
        WeQCItrV60afDpulpm2byb8rLSw0nt0hhqKh4eFUlH9dmXDnIipYuzweoOk1GCIbCDCQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mJFC9-003x4d-6Y; Thu, 26 Aug 2021 15:13:25 +0200
Date:   Thu, 26 Aug 2021 15:13:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
Message-ID: <YSeTdb6DbHbBYabN@lunn.ch>
References: <20210826074526.825517-1-saravanak@google.com>
 <20210826074526.825517-2-saravanak@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826074526.825517-2-saravanak@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 12:45:24AM -0700, Saravana Kannan wrote:
> If a parent device is also a supplier to a child device, fw_devlink=on
> (correctly) delays the probe() of the child device until the probe() of
> the parent finishes successfully.
> 
> However, some drivers of such parent devices (where parent is also a
> supplier) incorrectly expect the child device to finish probing
> successfully as soon as they are added using device_add() and before the
> probe() of the parent device has completed successfully.

Please can you point at the code making this assumption. It sounds
like we are missing some EPROBE_DEFER handling in the driver, or maybe
the DSA framework.

     Andrew
