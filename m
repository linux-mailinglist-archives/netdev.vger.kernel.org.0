Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29B53A7813
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 09:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhFOHkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 03:40:37 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:34671 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229488AbhFOHkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 03:40:37 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 44FD658076A;
        Tue, 15 Jun 2021 03:38:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 15 Jun 2021 03:38:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=ric6YdDEXdz8WBuoGrKfe35LOR5
        WAM61KVVhVs/q73k=; b=LFaeHKxx6ml2cAopsamh5pbpK0US75LJ+BJKi5ap7QA
        YYlQ153qPfMiUvbtaxzZlu0/yEk4okApSse1Rdds+tomHdvTfC+o2PnvZeGaL1M+
        l5TayE3DxkYWYkKs+3bRECcLu1lrWNO7rxSoWTvJtjo0dq+A4vKP4Y+PJLIfY4bu
        5o9LqSh+ndG5Zt1h/h9gUwZ7veC28aEhhIUTYq1rKiS79vcUEA/S06p2dt9ZD0fW
        q9HhP5oZjwGdZJFyVdU3oLUupj1ls3t9ytRYd+HZTlY9rupWwnc9Bu7Jzu647Jxb
        6W84bWbNqRcdSflvZlPPigsanCFvFxp7XkEq2t40+xA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ric6Yd
        DEXdz8WBuoGrKfe35LOR5WAM61KVVhVs/q73k=; b=WieSnIROYYNJLnYd7mBMLs
        DWiU3p0oYKe35vJ30B0Z257ggz7AyApT/+I3CZEdblancA8UZ8ILHlbyvT7ueWsV
        QXw58fGfTLk/mVf3wZ71VtreKoofpaSdQjomzci2Tj1fnb6+a5+5RKS3l3GYaaWG
        NbDdxIa7N7jfyf5jhhfp1oLguH0B0HejZ5KYw48t2AEgL+UlMl1YG9uRzjDqxeu7
        Pl/u+mSrd0HZmb8SJXeHfB71mX3CssZuweSW6XDpO8icgUYCF/0NfTUPPUdEXfhw
        n2xoGGzu3denuEcIVfeKt5NfNmMeEJXpbJvQyoFdkiF0DVXGzan7r75BCTd5YNXQ
        ==
X-ME-Sender: <xms:91jIYDX_nrKU4NS1bPeSvVbL9vmM50Oi_OUUn2Gaf96TtWZJZC9OsQ>
    <xme:91jIYLljzmn8Yt5JV0W2wrICpmZ57TjukvrFR4zzB9GoeNUHllQ6w-NoFxQptP_rv
    n4ifVX1ektvMQ>
X-ME-Received: <xmr:91jIYPYDZc4e0Eekczk0RLySWfn-apSAzIu5fRK76aXUUoNDhYx4_q3RWGbx221yj_MPRsIP1cPDPr9HDty6zhsuKX6LllPe>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedviedguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhm
    qeenucggtffrrghtthgvrhhnpeevueehjefgfffgiedvudekvdektdelleelgefhleejie
    eugeegveeuuddukedvteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:91jIYOUfPeLbHvRxkQFglnVWgZEM9-Rd8RDLINs5lffBxbL_2lapPw>
    <xmx:91jIYNkWDng012_RcE8LH3KdwaMkb83u2jiLLDSM7B2U4vW-kX1h5A>
    <xmx:91jIYLdMeYVCwFJHQHCxOUdvdAhZpFTivOwhGuCugUFweyfo0oG9KQ>
    <xmx:-FjIYC8Emc1txAz24Nl9LBYnzr3wT4fVgj-o8bmBj_cW03CNg2EJyw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Jun 2021 03:38:31 -0400 (EDT)
Date:   Tue, 15 Jun 2021 09:38:28 +0200
From:   Greg KH <greg@kroah.com>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     steve.glendinning@shawell.net, davem@davemloft.net,
        kuba@kernel.org, paskripkin@gmail.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: fix possible use-after-free in smsc75xx_bind
Message-ID: <YMhY9NHf1itQyup7@kroah.com>
References: <20210614153712.2172662-1-mudongliangabcd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614153712.2172662-1-mudongliangabcd@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 11:37:12PM +0800, Dongliang Mu wrote:
> The commit 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
> fails to clean up the work scheduled in smsc75xx_reset->
> smsc75xx_set_multicast, which leads to use-after-free if the work is
> scheduled to start after the deallocation. In addition, this patch also
> removes one dangling pointer - dev->data[0].
> 
> This patch calls cancel_work_sync to cancel the schedule work and set
> the dangling pointer to NULL.
> 
> Fixes: 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>  drivers/net/usb/smsc75xx.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
> index b286993da67c..f81740fcc8d5 100644
> --- a/drivers/net/usb/smsc75xx.c
> +++ b/drivers/net/usb/smsc75xx.c
> @@ -1504,7 +1504,10 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
>  	return 0;
>  
>  err:
> +	cancel_work_sync(&pdata->set_multicast);
>  	kfree(pdata);
> +	pdata = NULL;

Why do you have to set pdata to NULL afterward?

thanks,

greg k-h
