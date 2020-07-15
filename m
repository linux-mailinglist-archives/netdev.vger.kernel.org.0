Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744712205F8
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 09:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729168AbgGOHPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 03:15:51 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60043 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728883AbgGOHPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 03:15:50 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id BCA5B5C017C;
        Wed, 15 Jul 2020 03:15:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Jul 2020 03:15:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=I
        dzXeh2RWKYdW8XCq4OrPX8o7m+00s9GheuDMfhvZ/Y=; b=hnDjX/GBxPowfNxSZ
        pW2w1tj0ZzZkUqqCNe6rMhlcUDZKbGw144OHNVMrkl3Kbu5z3jMp0nLbKk0hv/5l
        97VDOhWleqfPiqZpPnWWXSRGo1mF9mk8XSY+5Jm2D6wNP78scp8Ljqef8IBgBRRV
        VCB0alxM033faF9FP5845sPkHKnBOmlBwQHUojLf6I2Z2oQyIeNNFzdogVAvfDih
        HViCZxbKCPzbZOC079jCbQP4z1BYO79RkKSriIOxzYcW07RN5aNOq0glIIUfMaxC
        7y6+J+ruNZg5nPQ8B/RMwIZ5oerrPDGALDShCNmpWIPnU5IYqgnrHgHOSAi406pl
        hiNOg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=IdzXeh2RWKYdW8XCq4OrPX8o7m+00s9GheuDMfhvZ
        /Y=; b=OpwC+p0a2XX4L+2ZPQYf9alSwv5o6HabIMO9tk9u6HqUCKgCcz22Iia9v
        0DQ6PAvkc0UBYspkd72kD8nanLcVO/UDLOWz6dPXwByrX+Rq3Ke3kZwvBourJfb0
        epRU2k7Pm7R3E4Giszqa6eP2MojlvnhMNSmguDYgBfdnZA8l5WBfAKFxbDWDVQpu
        nongQ6VuclqWYow4uTMklgG7JKegvOvqs155Zoeyvv7mVbWLiC/tbZLZosUKOtvv
        Ez69y0qKrncpffWna2XmsHpxm1Max1XAZ1oI6jm0vVGmWQ4rY+HptP2o85M06im8
        CePdtqdCzdtRj8GP0ZvmcZwTOPJig==
X-ME-Sender: <xms:JK0OXz2Q8Alts9rqL07C3OVOSIsBC2_oFHRLcIzbuBcmmyUVxf1Nyw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedugdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepvedtie
    elueetgeeggfeufefhvefgtdetgfetgfdtvdegjeehieduvddtkeffheffnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:JK0OXyFUNoMeYT-Wy49o8df9IjvquJ-nT5uSNbOj2zkB9vbmI9wb0g>
    <xmx:JK0OXz7Qg9HKPpbbDT80p4cFDXclNuwm05Z9Q4fKI-s6-MWQljaZxw>
    <xmx:JK0OX43KQqR4-9BgYz1vaIT7NWBdirPpuMvJ01KtLH6jV3DtbNmD2w>
    <xmx:JK0OX4O6IZ0zZubZUbk4k49SxlX1o1UShUafmQYQjt63tUTaP62wpw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C9C0F30600A6;
        Wed, 15 Jul 2020 03:15:47 -0400 (EDT)
Date:   Wed, 15 Jul 2020 09:15:43 +0200
From:   Greg KH <greg@kroah.com>
To:     =?iso-8859-1?Q?Wxcaf=E9?= <wxcafe@wxcafe.net>
Cc:     linux-usb@vger.kernel.org,
        Miguel =?iso-8859-1?Q?Rodr=EDguez_P=E9rez?= 
        <miguel@det.uvigo.gal>, oliver@neukum.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/4] cdc_ether: use dev->intf to get interface information
Message-ID: <20200715071543.GA2305231@kroah.com>
References: <0202c34b1b335d8d8fcdd5406f5e8178b4c198ec.camel@wxcafe.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0202c34b1b335d8d8fcdd5406f5e8178b4c198ec.camel@wxcafe.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 09:25:13PM -0400, Wxcafé wrote:
> This makes the function available to other drivers, like cdn_ncm.
> 
> Signed-off-by: Miguel Rodríguez Pérez <miguel@det.uvigo.gal>

The subject line does not match the patch :(

Also, when sending on patches from others, you too have to sign off on
it.

And, set the proper From: line in the body of the email, like the
documentation says to do, otherwise you loose the original authorship
information.

thanks,

greg k-h
