Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035382211E6
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgGOQD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:03:57 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:38807 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726660AbgGOQC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:02:58 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id F37EBBC0;
        Wed, 15 Jul 2020 12:02:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 15 Jul 2020 12:02:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=n
        MV+U3ZYC+YYO1JarfMEDenZhLZTIDP/xMrNIOtHFWg=; b=HUGlRXL/3MF5QUGPL
        CHzHV2++7oAa7NKrXur4jXx+w9nCLqS46If55ZLO4ChQ7j1fxh3KW5VLNEoTQS6Q
        yIwfLrYUkwOxVJij6AVNFgRgdf1VAmjy1cIOyQYVLxlZtc/NMr/tq4rJH6ptLfVc
        Bx9aq9lQ+MG/yKLuLcqR0D1kg9md9tYOxwEdpYUQ5wJIY2nBTReqKhRW09uM/Teb
        HGJ4YOuMHRTWkACvh0XEViZDjUBlNXtd23F8+gAKz70IoWqk+n8GwtPg5vm4asOR
        jyBKpgjPeTDR4exFDR+yer9Kv4HORhf3dq9Afx6O8nofuqDb+uTqIrOgKnVVu420
        vKJ0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=nMV+U3ZYC+YYO1JarfMEDenZhLZTIDP/xMrNIOtHF
        Wg=; b=dz8ncD4Bg8eSvAJlqerTs0hdtft5A6zXIjnnSjY/QwtI1yl9vUSXI8nBm
        xNaJtRc3fGJpbl7xW2mPIxsvLcVZJJfl/nU69TfAMCwka85tIqgLkclQL+BzSeJV
        5y9kXOPxNf3YxTPGs0FwD0wPxDr2NZ4KI0UsFg2/1DSCMUgn+yb/CNde7gykSk9l
        jZu3IH6uhSlz7kbPX9PANqrgK6GMG74iSMXOeUUcolHWynQTwo9CxvvJ8F8h2+9O
        VuDZznjoU+c+BCUfkvND2WhPsasYyLusvkWbjkO+Ww5t2Y25Rkd4fP3HVP4KHGIo
        SY7F3ofE87bdtOo7A7GGLf35nG7fQ==
X-ME-Sender: <xms:nigPX2P33MNz2HTgFMEFOhtVkzgjDnE5dj5LX2ADUvJ556wFnqtE9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedvgddutdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepvedtie
    elueetgeeggfeufefhvefgtdetgfetgfdtvdegjeehieduvddtkeffheffnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:nygPX09jkhyeu7LK-0CNo2yk2xO4EoxR3nzvEKEdI5yYOeA-XcuP5Q>
    <xmx:nygPX9SawbXvvd9dAENB19MudcAnlXScK4_EeRIiWy5hWSyC-xdSdA>
    <xmx:nygPX2vQ3Cwq-57BG2uP3gY3VS3HmT-bwfW4B6wHyGynT_48Mf826A>
    <xmx:oCgPXyFet536geiB7hqENG0gLYseongyghHPslqwvp1qxaFBA93DFg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 936043280059;
        Wed, 15 Jul 2020 12:02:38 -0400 (EDT)
Date:   Wed, 15 Jul 2020 18:02:33 +0200
From:   Greg KH <greg@kroah.com>
To:     =?iso-8859-1?Q?Wxcaf=E9?= <wxcafe@wxcafe.net>
Cc:     linux-usb@vger.kernel.org,
        Miguel =?iso-8859-1?Q?Rodr=EDguez_P=E9rez?= 
        <miguel@det.uvigo.gal>, oliver@neukum.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] cdc_ether: use dev->intf to get interface information
Message-ID: <20200715160233.GA761067@kroah.com>
References: <06493cccfe5d34f8052050e35073695ea0af6c0a.camel@wxcafe.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <06493cccfe5d34f8052050e35073695ea0af6c0a.camel@wxcafe.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 11:53:39AM -0400, Wxcafé wrote:
> >From 0d0f13077e02cf6b54f2a22eb2e5f7d97ac7ee97 Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Miguel Rodr=C3=ADguez P=C3=A9rez? <miguel@det.uvigo.gal>
> Date: Tue, 14 Jul 2020 18:02:10 -0400
> Subject: [PATCH 1/4] cdc_ether: use dev->intf to get interface information

That looks really odd in a changelog body :(

> 
> usbnet_cdc_update_filter was getting the interface number from the
> usb_interface struct in cdc_state->control. However, cdc_ncm does
> not initialize that structure in its bind function, but uses
> cdc_ncm_cts instead. Getting intf directly from struct usbnet solves
> the problem.
> 
> Signed-off-by: Miguel Rodríguez Pérez <miguel@det.uvigo.gal>
> Signed-off-by: Wxcafé <wxcafe@wxcafe.net>

As per the documentation, we need a "real name" for all signed-off-by.

Also, what has changed with this series from before?  Have you addressed
Oliver's objections?

thanks,

greg k-h
