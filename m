Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15838A5CDF
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 22:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbfIBUGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 16:06:40 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:48373 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727188AbfIBUGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 16:06:39 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 1320362E;
        Mon,  2 Sep 2019 16:06:38 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 02 Sep 2019 16:06:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=FAvLTBXJMFp5nXcvx3Bo9G6BMhn
        oFVSkwgAThvpzQ0E=; b=PuLFFvJjjydqsD5PPNNZ/EcQZjy+LhTeYQefaKT8Qp9
        ZJAj6L5Q0pWL4b+GcJ9bRp6JlDflgcd5CkdnvC1VIqsy+RciDYu4Qw4DNr9wOJCT
        9N7f+Ng+yKQz0lmoAhfrpmIBn5ALb4ULIba8Uh6SceejMi8UsKqN3G+5Bfr4ttQp
        4dcXulj4ML9ZHPiUPCa3F7AZ8wi/69c2H3dP+mAhgjKtTiuJ0BhYCDjwMmxw3Gi2
        1M/O5G6DodkOt6hbEeSWjPTk42lIjmnmcfaFJpV+U6CMBv9Iv+7UXOJ3vMDYgDJU
        U8n7Tg2uzYaUMABUToOmZlzRSxAmJcDvIzmCAeXrSng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=FAvLTB
        XJMFp5nXcvx3Bo9G6BMhnoFVSkwgAThvpzQ0E=; b=fSM/lWN9/3VELwVFPVJ+4+
        1dNc2eE/MONH7bQIu9vMRBceWDnizYiaWFw7MxTApeEqMxDRAvuejedQZXCDvdQf
        YcyTyrl231eIc8ksNVntlyokmcp9AplYkaouSnPE67enZCVclVtJamWzBWNsKyCe
        LMxA0ZvGqdHYYZMlvo/Rxx2BFgNGIIqJ1W7VRr1H8UBb0BplWeaSBVmOBCF/p9rR
        GkXLybx2cyWjtZ73VKN+b54Zh8hKgGWkd1BPndKw/6DMb4faImPh9+w8thd0uXXB
        3ak04VjeonTWMqxK3rmgEJkUyKeWvUFUDOkQhC9Pfg0H/DO1G/BxbgbqZjcMH5ag
        ==
X-ME-Sender: <xms:TXZtXXhBJm3zcYNoJEFv2vrb5bCNo_IehKJ90wRZYc42iuKe1nd-aA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejtddgudeghecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:TXZtXf9uAIxB67ewV0loxu7hjkDYEpHTKSgix7j8J6B_Zno3VS-Eqg>
    <xmx:TXZtXdP43TexLhjYdeypHMTmntaNRVRyBm08QRRSLOuRbvlO54lCjw>
    <xmx:TXZtXapcOrZ2PIdbElxYG3fXAAG0KYWdvRevkc5Prbp77Tb5cPxktA>
    <xmx:TXZtXY2szrMMwnkilSWtjDljCPNpRJHXLc2FYwd6pGBbZ6ge_427Qw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 196D0D6005F;
        Mon,  2 Sep 2019 16:06:37 -0400 (EDT)
Date:   Mon, 2 Sep 2019 22:06:35 +0200
From:   Greg KH <greg@kroah.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>, Hui Peng <benquike@gmail.com>,
        security@kernel.org, Mathias Payer <mathias.payer@nebelwelt.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix a double free bug in rsi_91x_deinit
Message-ID: <20190902200635.GA29465@kroah.com>
References: <20190819220230.10597-1-benquike@gmail.com>
 <20190831181852.GA22160@roeck-us.net>
 <87k1asqw87.fsf@kamboji.qca.qualcomm.com>
 <385361d3-048e-9b3f-c749-aa5861e397e7@roeck-us.net>
 <20190902184722.GC5697@kroah.com>
 <804fb4dc-23e5-3442-c64e-9857d61d6b6c@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804fb4dc-23e5-3442-c64e-9857d61d6b6c@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 02, 2019 at 12:32:37PM -0700, Guenter Roeck wrote:
> On 9/2/19 11:47 AM, Greg KH wrote:
> > On Sun, Sep 01, 2019 at 07:08:29AM -0700, Guenter Roeck wrote:
> > > On 9/1/19 1:03 AM, Kalle Valo wrote:
> > > > Guenter Roeck <linux@roeck-us.net> writes:
> > > > 
> > > > > On Mon, Aug 19, 2019 at 06:02:29PM -0400, Hui Peng wrote:
> > > > > > `dev` (struct rsi_91x_usbdev *) field of adapter
> > > > > > (struct rsi_91x_usbdev *) is allocated  and initialized in
> > > > > > `rsi_init_usb_interface`. If any error is detected in information
> > > > > > read from the device side,  `rsi_init_usb_interface` will be
> > > > > > freed. However, in the higher level error handling code in
> > > > > > `rsi_probe`, if error is detected, `rsi_91x_deinit` is called
> > > > > > again, in which `dev` will be freed again, resulting double free.
> > > > > > 
> > > > > > This patch fixes the double free by removing the free operation on
> > > > > > `dev` in `rsi_init_usb_interface`, because `rsi_91x_deinit` is also
> > > > > > used in `rsi_disconnect`, in that code path, the `dev` field is not
> > > > > >    (and thus needs to be) freed.
> > > > > > 
> > > > > > This bug was found in v4.19, but is also present in the latest version
> > > > > > of kernel.
> > > > > > 
> > > > > > Reported-by: Hui Peng <benquike@gmail.com>
> > > > > > Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
> > > > > > Signed-off-by: Hui Peng <benquike@gmail.com>
> > > > > 
> > > > > FWIW:
> > > > > 
> > > > > Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> > > > > 
> > > > > This patch is listed as fix for CVE-2019-15504, which has a CVSS 2.0 score
> > > > > of 10.0 (high) and CVSS 3.0 score of 9.8 (critical).
> > > > 
> > > > A double free in error path is considered as a critical CVE issue? I'm
> > > > very curious, why is that?
> > > > 
> > > 
> > > You'd have to ask the people assigning CVSS scores. However, if the memory
> > > was reallocated, that reallocated memory (which is still in use) is freed.
> > > Then all kinds of bad things can happen.
> > 
> > Yes, but moving from "bad things _can_ happen" to "bad things happen" in
> > an instance like this will be a tough task.  It also requires physical
> > access to the machine.
> > 
> 
> Is this correct even with usbip enabled ?

Who has usbip enabled anywhere?  :)

I don't know if usbip can trigger this type of thing, maybe someone
needs to test that...

thanks,

greg k-h
