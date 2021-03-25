Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40070349509
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 16:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhCYPMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 11:12:08 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39917 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229524AbhCYPL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 11:11:58 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 95FE15C00F8;
        Thu, 25 Mar 2021 11:11:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 25 Mar 2021 11:11:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=m+TI7fDtbMIQ2ZxuOSUCfSosKVq
        BDKs4AB5sOk9PJHA=; b=btgCKPlDhMRjiKADJniFtQ1r16V73Oxu1K46DypnEfu
        xFovDcyXM+Akxhhl0zDE1a1U0OUu+xBjq/bzguNuFFWTn2LvUHTfuonnREmq66O4
        NROUC9NHy9v3kk99qHrYQbmj9lDYWipQTmA/uIr60mA6QIHdYPtWREw7h2c1DAic
        4yo7O1c7xWkUXnXopxA7ke0j2gOSRy49GMEfmQsg3RqLTYNiWYNlbKIhs5ie57qH
        AavNM4DMsFkpJ4R6Xf/OzI3UR9+IeG6HdUAjr5zWVFu4LwdWpWgs4MgGZlQjpDi2
        hwqueOYa+8RJjN3Y5YZTtOEwCpE8H4Uq6e0PWsNKl7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=m+TI7f
        DtbMIQ2ZxuOSUCfSosKVqBDKs4AB5sOk9PJHA=; b=esiyhBWOIbKD6f/rCpwOqf
        cPzBPo5sGy4tztOT9atbNkhdwFy51z9zycztXLVXkmOP+tGmVHq/6e6o0WBojP1i
        w1h+/LQBqbzVq9hX5OvT1pIGEe31q5wapmEMyAVeCcOqnGrYzu2ayFEPRL/IZCYp
        rIJssJcmdXcO4sUbcAu9jCu0LDRw2S0iGo2EydIKhfkoXQopsgcCfzGmJfwEn2he
        /2zAbRyhEc/LrEAKCqWazveAkpVcy5XyP7kAL6khXq07vFVbCwx3Q4u/ewdRVIfC
        //CLvrnkw/fU/eYI6O4gWlyqCfebTGS/YM7p9zdir6YLDyErqOP6mL7ONNitnIug
        ==
X-ME-Sender: <xms:O6hcYMrYKs7pBw9avRSUb_AjegUEaO8vlKP28n_D8fvEkgPk_cw7jw>
    <xme:O6hcYCrmMZX7AMbe87Oy5ui3M9XU7b3OZnO11JdL-gCzQNWCme06Hbe0h8EdVVGMv
    PmGxjMcDvUJGQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehtddgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:PKhcYBMUIe2USobE9cLS6QcOM5HIQpyjtaqvd1Hl7TwwpV6MXROzMA>
    <xmx:PKhcYD4Khu-5f_7RTYc6mToQbsWmzqnJz0KInF9V-BEw9pTQ0ibJgQ>
    <xmx:PKhcYL7Usdpw6SxFdCcT39CgflXrt7hfswlxXJSktGvrmt7ZCWp7CQ>
    <xmx:PahcYBTHIYjXboTvyOjzIxd207GaSoBjgQFYILXerhbTBXwGM-bbDA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8FAB51080057;
        Thu, 25 Mar 2021 11:11:55 -0400 (EDT)
Date:   Thu, 25 Mar 2021 16:11:53 +0100
From:   Greg KH <greg@kroah.com>
To:     'Qiheng Lin <linqiheng@huawei.com>
Cc:     Petko Manolov <petkan@nucleusys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH net-next] net: usb: pegasus: Remove duplicated include
 from pegasus.c
Message-ID: <YFyoOX/BULRzvrrI@kroah.com>
References: <20210325145652.13469-1-linqiheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325145652.13469-1-linqiheng@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 10:56:52PM +0800, 'Qiheng Lin wrote:
> From: Qiheng Lin <linqiheng@huawei.com>
> 
> Remove duplicated include.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
> ---
>  drivers/net/usb/pegasus.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
> index 9a907182569c..e0ee5c096396 100644
> --- a/drivers/net/usb/pegasus.c
> +++ b/drivers/net/usb/pegasus.c
> @@ -65,7 +65,6 @@ static struct usb_eth_dev usb_dev_id[] = {
>  	{.name = pn, .vendor = vid, .device = pid, .private = flags},
>  #define PEGASUS_DEV_CLASS(pn, vid, pid, dclass, flags) \
>  	PEGASUS_DEV(pn, vid, pid, flags)
> -#include "pegasus.h"
>  #undef	PEGASUS_DEV
>  #undef	PEGASUS_DEV_CLASS
>  	{NULL, 0, 0, 0},
> @@ -84,7 +83,6 @@ static struct usb_device_id pegasus_ids[] = {
>  #define PEGASUS_DEV_CLASS(pn, vid, pid, dclass, flags) \
>  	{.match_flags = (USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_DEV_CLASS), \
>  	.idVendor = vid, .idProduct = pid, .bDeviceClass = dclass},
> -#include "pegasus.h"
>  #undef	PEGASUS_DEV
>  #undef	PEGASUS_DEV_CLASS
>  	{},
> 

Did you build and test this code now with this change?

I think you broke this driver badly now :(

Please think about _why_ the code would have been written this way in
the first place, it is a bit odd, right?

netdev maintainers, consider this a NAK.

thanks,

greg k-h
