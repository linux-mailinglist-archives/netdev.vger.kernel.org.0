Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5311F4896CB
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 11:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244310AbiAJKzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 05:55:38 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:40373 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244301AbiAJKze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 05:55:34 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id A4AFE580281;
        Mon, 10 Jan 2022 05:55:32 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 10 Jan 2022 05:55:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=OqShqIUs+3FHMVc1BTZJhCPGjO4
        emvYhGgaArHNO3jI=; b=qGpv90o7HWfxerTc3ktwFYeKuDstDor8dfjKtWm4Pgh
        HXkLnZ1drc61bGrQmTdAnM9nLmMmpSrl7juJ7XDUHOvHvBz4LNCxZHDdvZTYAaDx
        uIwpF037c5zJ8njlaerYGIxe1Vl6e8GyfjNKH9ZVVIExwflnYyznI0+a57w154oM
        9RMubDFsVQ1m5QplS5VPQOVaQ+w8avHQEhEV6WpeWOnDgx/DWHBGRxaJAcFeenNS
        3rcp6anhmUMTxoK2skBXvKUSlyXbZUwJCBoypxyGSUcHhvs04/gmoyLc3aaF18qG
        eDGSzpga5vBWrnN3RyBVz2hc1qkMoDS44zU1eR0gQIA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=OqShqI
        Us+3FHMVc1BTZJhCPGjO4emvYhGgaArHNO3jI=; b=dbqje9nuQXOfBLdJC7BQht
        qG19LEJ+hB8/ipgL3YwJtPWqvAQSM4FK+EipvtwIdayogKKn/mea7eBQfy1ujnLy
        5DWNvUumPvNBcciHfxAg8tzHgqVD9DzanyHJE2bx0q82vEXF4qoUInETYBEzVGhs
        Fb5FkAkFiXATFAjfr8ctat3Qex2L5aYNjPbCFd3H7IXaRW6SeDDvyYX8dYQ3rPcr
        Iw8p2wO3boEM2pFHRKjnHw74zwRtJ4QsmyNjAdnw7BWd45suJ9nHkTmu9V7ABDQg
        /1LDTxb/M8KtVCRxmZQJCYTtkwUJaQIMcCieYecScMCnw7E5wjiZEnIB7XtgB9fA
        ==
X-ME-Sender: <xms:pBDcYbIWomDhgr7oDJwgdaRbzDDu_nNJyOsiZcaS6YfSRpXrkzkFaA>
    <xme:pBDcYfKxdVUqN4cU1aJRRW3CKwqcoRS4NTYPR2JOQ6tocRfO8Xq9Jl_aeH31FYHyR
    MXGFuGZtToAlQ>
X-ME-Received: <xmr:pBDcYTuIdP-UmrgXleaUIpQ2mJNvVsoTfD-4DzLdOlRjaMVPgWRAa8MQCa6ohTcYOCYrLuWIP7y63twaLjSjirHm999fHBbj>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrudehtddgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necuggftrfgrthhtvghrnhepveeuheejgfffgfeivddukedvkedtleelleeghfeljeeiue
    eggeevueduudekvdetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:pBDcYUZvSnxwDH9vfAoMJO4a_tdnYhENuNcsKJeHHWCOcFxtkfa41w>
    <xmx:pBDcYSYJdlD8owXJjWrzytvoyg9LQmcY9fOmqRpour9keQg_T311hA>
    <xmx:pBDcYYClaDI-ffyqcJ4D6hVs4gA3XoabbIPLi2czhsU3GIpHefXIMA>
    <xmx:pBDcYUZiZMUUpAWfVCy-SRniASOGL_StBv8rBE4joIQK9Ze_1sPtUQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 10 Jan 2022 05:55:31 -0500 (EST)
Date:   Mon, 10 Jan 2022 11:55:28 +0100
From:   Greg KH <greg@kroah.com>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, chi.minghao@zte.com.cn,
        andrew@lunn.ch, grundler@chromium.org, oneukum@suse.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] drivers/net/usb: remove redundant status variable
Message-ID: <YdwQoMV2Ay5eibyN@kroah.com>
References: <20220110104402.646793-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110104402.646793-1-chi.minghao@zte.com.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 10:44:02AM +0000, cgel.zte@gmail.com wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Return value from sierra_net_send_cmd() directly instead
> of taking this in another redundant variable.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
> ---
>  drivers/net/usb/sierra_net.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
> index bb4cbe8fc846..818ff8a24098 100644
> --- a/drivers/net/usb/sierra_net.c
> +++ b/drivers/net/usb/sierra_net.c
> @@ -334,15 +334,12 @@ static int sierra_net_send_cmd(struct usbnet *dev,
>  
>  static int sierra_net_send_sync(struct usbnet *dev)
>  {
> -	int  status;
>  	struct sierra_net_data *priv = sierra_net_get_private(dev);
>  
>  	dev_dbg(&dev->udev->dev, "%s", __func__);

No need for this line anymore, and then, this whole function can be
removed as it would only be 1 line, right?

thanks,

greg k-h
