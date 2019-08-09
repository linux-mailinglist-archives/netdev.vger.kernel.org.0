Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0624487594
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 11:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406159AbfHIJSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 05:18:20 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42639 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406007AbfHIJSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 05:18:20 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 734D92205E;
        Fri,  9 Aug 2019 05:18:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 09 Aug 2019 05:18:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=7mMXW9cnAZ1j+T1wlyyUtiNi5ou
        7J3bcd1b/yM9O7ds=; b=nSbxfpektxuFALpWBYSRtTDj1pyWsalG65H7JS1zRYh
        r0HUvUkUkzryzlpbC8XS9M2ayFF48sJ4UIHasAprkC8V+FzwXZIrPZ7I2D8sCZkE
        MYp8yy88eEDKdWwqRW+YpJQNuIrQXmKXwsdHZLbWojo9JJShLNY0+Vnjv1FwyN0H
        QEDLHwHqgFG+GAR1qym6vWAcB/bJAAFtNtE2StQJ39PyhBL1eDIkXAaeGJJJBpHJ
        Ts/rOcxzMifIF6W4Vs5TVQcD70K3hw9VDKr5bxCwAC8PA5yOKKxF0J4rXCuaqN09
        wRqIr1FSv2pe+KX2W8BVGufsr8i6vOBjEub//ryjorw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=7mMXW9
        cnAZ1j+T1wlyyUtiNi5ou7J3bcd1b/yM9O7ds=; b=lK5KXLCVY8IcTt7jNKmGnj
        ilB2CIBhwQp7lzj+8rR3MODedC0mUcD2UDNyidI+pJboepM7Br8bHfvVtPrAW+g8
        NvUK6kYygyJpulyDR9ZmocKXIZxL9AYxqVze4L5/nXyMd5hG4YjX6W6VmICB6ILO
        KUxfwxs1z3WLg8j+GRyaxSjpmmcFIwKjphcn0KWrladq2wg08HefHJU5vjR3eJZl
        r5nogb8uGfWdOJeHZIN0mGfpMKveCkiyhuzBVef4QGr5kHqrRbOHtN/UxqH29Ctb
        UGAzOAzsYerRkArFODgsQ6VIbW6xB9r1M9tuyC50OiXSNZb5RVfbINyYw869iLUw
        ==
X-ME-Sender: <xms:WjpNXd9ly854zdpEVvHwLSS9Qeba0OWU5naGVlYUCxmhEMTEo90nfw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddujedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:WjpNXRLeGzF8b-07DVGTMuSriOq1RBBpOuRcLD--SRuslAq_YQjDbg>
    <xmx:WjpNXcG-JNvnLKbRe0gi3_-1KrSz290QG9wRQjh3h7Gfq4bfcU3p-w>
    <xmx:WjpNXVwRnb0sDTBTxW5KGV_DWR_y--B5FII6Mr4gZaImdYoeI0hsgQ>
    <xmx:WzpNXYLVlMdHOeQWzElgwBvuGzqK_kFTZ0vohSmwFHz4LWysY-jm1w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 43A408005A;
        Fri,  9 Aug 2019 05:18:18 -0400 (EDT)
Date:   Fri, 9 Aug 2019 10:53:26 +0200
From:   Greg KH <greg@kroah.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Poirier <bpoirier@suse.com>
Subject: Re: linux-next: manual merge of the usb tree with the net-next tree
Message-ID: <20190809085326.GA21320@kroah.com>
References: <20190809151940.06c2e7a5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809151940.06c2e7a5@canb.auug.org.au>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 09, 2019 at 03:19:40PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the usb tree got conflicts in:
> 
>   drivers/staging/Kconfig
>   drivers/staging/Makefile
> 
> between commit:
> 
>   955315b0dc8c ("qlge: Move drivers/net/ethernet/qlogic/qlge/ to drivers/staging/qlge/")
> 
> from the net-next tree and commit:
> 
>   71ed79b0e4be ("USB: Move wusbcore and UWB to staging as it is obsolete")
> 
> from the usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
> 
> -- 
> Cheers,
> Stephen Rothwell
> 
> diff --cc drivers/staging/Kconfig
> index 0b8a614be11e,cf419d9c942d..000000000000
> --- a/drivers/staging/Kconfig
> +++ b/drivers/staging/Kconfig
> @@@ -120,6 -120,7 +120,9 @@@ source "drivers/staging/kpc2000/Kconfig
>   
>   source "drivers/staging/isdn/Kconfig"
>   
>  +source "drivers/staging/qlge/Kconfig"
>  +
> + source "drivers/staging/wusbcore/Kconfig"
> + source "drivers/staging/uwb/Kconfig"
> + 
>   endif # STAGING
> diff --cc drivers/staging/Makefile
> index 741152511a10,38179bc842a8..000000000000
> --- a/drivers/staging/Makefile
> +++ b/drivers/staging/Makefile
> @@@ -50,4 -50,5 +50,6 @@@ obj-$(CONFIG_EROFS_FS)		+= erofs
>   obj-$(CONFIG_FIELDBUS_DEV)     += fieldbus/
>   obj-$(CONFIG_KPC2000)		+= kpc2000/
>   obj-$(CONFIG_ISDN_CAPI)		+= isdn/
>  +obj-$(CONFIG_QLGE)		+= qlge/
> + obj-$(CONFIG_UWB)		+= uwb/
> + obj-$(CONFIG_USB_WUSB)		+= wusbcore/


Merge looks good to me, thanks!

greg k-h
