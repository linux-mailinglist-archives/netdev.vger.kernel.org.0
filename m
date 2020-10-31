Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFDFE2A1B1F
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 00:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgJaXIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 19:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgJaXIj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 19:08:39 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 122B02076D;
        Sat, 31 Oct 2020 23:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604185719;
        bh=n6RGMuw5YNmilZqWQGqyaoFrZav6Bw3QeR5XS8Ggbv4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ySLB1L7pIlJP9h6xORopwqQLcFtjZACXN13XqvWZXwXtp4pI7VgAbwIONyoA+ZfVM
         KG3MGzLUYbOZh68dXAHuvf8EdpKmrZthZhv7euijWZkjPJWlBaxnuf03TZt8ANziTV
         QhuhwHX6ARkzeulo91I1T6N7k3EuEVG+alE1Rn8s=
Date:   Sat, 31 Oct 2020 16:08:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net/usb/r8153_ecm: support ECM mode for
 RTL8153
Message-ID: <20201031160838.39586608@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1394712342-15778-388-Taiwan-albertk@realtek.com>
References: <1394712342-15778-387-Taiwan-albertk@realtek.com>
        <1394712342-15778-388-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 11:23:08 +0800 Hayes Wang wrote:
> Support ECM mode based on cdc_ether with relative mii functions,
> when CONFIG_USB_RTL8152 is not set, or the device is not supported
> by r8152 driver.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Can you describe the use case in more detail?

AFAICT r8152 defines a match for the exact same device.
Does it not mean that which driver is used will be somewhat random 
if both are built?

> +/* Define these values to match your device */
> +#define VENDOR_ID_REALTEK		0x0bda
> +#define VENDOR_ID_MICROSOFT		0x045e
> +#define VENDOR_ID_SAMSUNG		0x04e8
> +#define VENDOR_ID_LENOVO		0x17ef
> +#define VENDOR_ID_LINKSYS		0x13b1
> +#define VENDOR_ID_NVIDIA		0x0955
> +#define VENDOR_ID_TPLINK		0x2357

$ git grep 0x2357 | grep -i tplink
drivers/net/usb/cdc_ether.c:#define TPLINK_VENDOR_ID	0x2357
drivers/net/usb/r8152.c:#define VENDOR_ID_TPLINK		0x2357
drivers/usb/serial/option.c:#define TPLINK_VENDOR_ID			0x2357

$ git grep 0x17ef | grep -i lenovo
drivers/hid/hid-ids.h:#define USB_VENDOR_ID_LENOVO		0x17ef
drivers/hid/wacom.h:#define USB_VENDOR_ID_LENOVO	0x17ef
drivers/net/usb/cdc_ether.c:#define LENOVO_VENDOR_ID	0x17ef
drivers/net/usb/r8152.c:#define VENDOR_ID_LENOVO		0x17ef

Time to consolidate those vendor id defines perhaps?
