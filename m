Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A46305566
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbhA0IQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 03:16:41 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:45791 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232076AbhA0IMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 03:12:43 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id A8FF5AD6;
        Wed, 27 Jan 2021 02:58:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 27 Jan 2021 02:58:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=lmZYIcFXUJMP3jXu+G9fcuak+NA
        pShyGFGRLK/bh5AY=; b=dNfQaG4fYrA+eFdsaFxdKgJUoT6kO1TDTNqNK33//o8
        cy9un4wcyRZq6Ynhl+1KOZXRYWp0/5J9ln6aDccXF1IlWK3GqzYRS5ao+p5BjiZk
        M0SM7AheSTV2ISYST+gM1vOBNp8FZsnNKlNRPlfNqlGjyDWZBX0uOxCUNL5FOM4X
        WrUOZYBuIPvrOA9eT9wyC7IabGFalEEYBDnceMWJ4SlwlcNFS5kI+8CF2m0837dp
        lLEjMcXhsNX4XpRU4UcNwdP4mKY3bnecleVwu5KGbNJcawQfPk0fTmyGx5iEtACO
        jj8cko1tNe+hy17Rmm7S5hAn9ArMv2j1qCvAAs3gi2w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=lmZYIc
        FXUJMP3jXu+G9fcuak+NApShyGFGRLK/bh5AY=; b=qbIvQfER2tNOHA9JZpmPKv
        TVmFurT9Y/88pGG1W8JzQfzdJgIjml1TGM6m+nDZy3pXefxkFBl54afoN0jcviTJ
        BJGOF18qGKtn3fs6ZvsggXnTKAGb64SiW8LJ2joDP7Pe/ZpWYIKuHAQ/JrKudSAC
        upcGy8Jxtj48f99RFmM7WyyQUE5yVYa6MLj5G9VhoNsXKAzRao2e6guMMfwbaIZb
        I8PXffeGV18iSSzqvJgSzgOJc5UFJaw3pZBUVNK/R1v7ZAxeLa0Yas6/RkLwTV0K
        LhEKm7h+Ciz7FCa1eGnEU8GCEihbSnPgyxB8CLuvd9kinYjGOgriobvqI2PiDMpg
        ==
X-ME-Sender: <xms:PR0RYAwcCrSWBvtHKRxF2--VXpOFog06mT3NsUbwfnGHq0_Q80S8IA>
    <xme:PR0RYETVhkj97V7ME4zSe2QugoYSSaywy0gJjyh3rddFCd4jRcPQjwd-eKFBXKB5D
    M7GZMbbovphQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejgdduudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:PR0RYCU-FI8XDmcD9yY7PmgFtScE9Uge2AOaSHrApiTQl2PFgVk2WQ>
    <xmx:PR0RYOgfc8Ai9SyGS_tAGfgN7bUNOyV3VItLrTGQlPZQQyscupR03A>
    <xmx:PR0RYCDK0jW-N112wdvxJ3pXA-3V9ryC3L-1SO6fzBQiUZBjpE_ORQ>
    <xmx:Ph0RYF9keF0zfAKnn58WSgcDUO-clueMV87T4QEcBmKabtuz9PU_DQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1AEDA108005C;
        Wed, 27 Jan 2021 02:58:53 -0500 (EST)
Date:   Wed, 27 Jan 2021 08:58:50 +0100
From:   Greg KH <greg@kroah.com>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>
Subject: Re: [PATCH net-next 1/2] net: usb: qmi_wwan: add qmap id sysfs file
 for qmimux interfaces
Message-ID: <YBEdOlZIexe7niki@kroah.com>
References: <20210125152235.2942-1-dnlplm@gmail.com>
 <20210125152235.2942-2-dnlplm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125152235.2942-2-dnlplm@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 04:22:34PM +0100, Daniele Palmas wrote:
> Add qmimux interface sysfs file qmap/mux_id to show qmap id set
> during the interface creation, in order to provide a method for
> userspace to associate QMI control channels to network interfaces.
> 
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
> ---
>  drivers/net/usb/qmi_wwan.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 7ea113f51074..9b85e2ed4760 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -218,6 +218,31 @@ static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
>  	return 1;
>  }
>  
> +static ssize_t mux_id_show(struct device *d, struct device_attribute *attr, char *buf)
> +{
> +	struct net_device *dev = to_net_dev(d);
> +	struct qmimux_priv *priv;
> +	ssize_t count = 0;
> +
> +	priv = netdev_priv(dev);
> +	count += scnprintf(&buf[count], PAGE_SIZE - count,
> +			   "0x%02x\n", priv->mux_id);

Odd way to do this, please just use sysfs_emit().  It looks like you
cut/pasted this from some other more complex logic.

thanks,

greg k-h
