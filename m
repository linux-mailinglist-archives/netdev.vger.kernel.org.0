Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47EAA252B6E
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 12:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbgHZKb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 06:31:26 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:42583 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728132AbgHZKbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 06:31:25 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 7E1F613CD;
        Wed, 26 Aug 2020 06:31:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 26 Aug 2020 06:31:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=fzXSyiJ0yKCBJMfU7qZRijHqxRF
        7SJCllidhSQjnX5g=; b=E/wM8YPIqDoyZ08hyoegYIw3IUZ0c6QqL4Sl9Xi2wlz
        N27VHRU4fhgB9zOi3Hn1L8LqlZEYCs87t5+z2UO+oQp0LJOJ5q78PkR0tdXFy8Ps
        TavZK6NFaXD45tQFyx/3NVYhbprrxvENGDv1Attna2ErKpdeh4EVvSVGNMpW5C2t
        s6spSI2cES63rDiJB0PvyTyYI5c1KVJTTAfgV4ZcsvBnBjCYysJVsU5bnk8E5CLw
        DAugbXE0VcZ8IVra+hhjeXAtIlO310DqlfC47pc8/hf/Ttaedj56QfpAQHLOYQVZ
        PGtdjhM/TAlFjb7XhrS2gpaH2RZAhq5WHdxpC9s00rw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=fzXSyi
        J0yKCBJMfU7qZRijHqxRF7SJCllidhSQjnX5g=; b=lLgG5ZukFOcF5MdVRQwiAw
        M9WcC3EibCmLVWp6OqEu4Lko5c7zO4aw5o3TGGwDC0sHOUkU4jZcNZQnpbau7M5x
        zrCoZ9MstIvOP6hIcAOLAeegkcQud3L8OM3RoOw3W4YfE8q9vZeQQR7k1fv2CwxL
        3Lumv3qtW2Zawa4+BZixAzvgWNFfnlaejGaJGProPMCCw71gA1dBrWUWhhs2Mk/y
        JJR8VfhR8buGK2zt22wgz2OcHHwA546khHtOq/0E+bgLJhLhU1n/uOVhYHw0smEO
        BogZSxEQDhGjvLAgEO2KSlgvEArc78teARcUaoGjdTqyN+78sEPvUXeeJii+lTXA
        ==
X-ME-Sender: <xms:-jlGX3Kw_cCOte_5xtvllTm93NP5vkNRInBmgMrJYqUvpHWoVO4ysw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddvvddgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necuggftrfgrthhtvghrnhepveeuheejgfffgfeivddukedvkedtleelleeghfeljeeiue
    eggeevueduudekvdetnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:-jlGX7KomOU1GGlI_F32hsge41oVLQju52fSHA1LuLOM7skkQ_JoYw>
    <xmx:-jlGX_sXCMFmmjF7iupGYo14IRhBt5cGAYjzbM77GSwWagqj5UfGZg>
    <xmx:-jlGXwYkRYCMZpMmmzXQIlXU-qdT9WNpBA2KhxhR9Rki8UMTOZ0r7g>
    <xmx:-zlGX-F1nciJtAUSJjD4D7JE3Al6e6ilsgRp0GAbM8SenD9v49lquQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1AF2F30600A9;
        Wed, 26 Aug 2020 06:31:22 -0400 (EDT)
Date:   Wed, 26 Aug 2020 12:31:37 +0200
From:   Greg KH <greg@kroah.com>
To:     xiangxia.m.yue@gmail.com
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jknoos@google.com
Subject: Re: [PATCH net backport 5.6.14-5.8.3 v1] net: openvswitch: introduce
 common code for flushing flows
Message-ID: <20200826103137.GC3356257@kroah.com>
References: <20200825052532.15301-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825052532.15301-1-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 01:25:32PM +0800, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> [ Upstream commit 77b981c82c1df7c7ad32a046f17f007450b46954 ]

That is not what this commit is :(

Please fix up and resend with the correct commit.

thanks,

greg k-h
