Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297562934D3
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 08:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404004AbgJTGUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 02:20:53 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:47233 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403993AbgJTGUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 02:20:48 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 48765C38;
        Tue, 20 Oct 2020 02:20:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 20 Oct 2020 02:20:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bernat.ch; h=
        from:to:cc:subject:references:date:in-reply-to:message-id
        :mime-version:content-type:content-transfer-encoding; s=fm1; bh=
        wjjec6ic/gl/14+2+vUByl2Px4ePo0YT/nvkiquon6o=; b=yp404x6vPJiZuBic
        xX95qp0HoWBq4KFlB69ZC/zC/tWJjv6n1mq9XvRa10d3bRBC2wIXLTBLFyZXfCt6
        3cnwMN9/QIhiczn4q3WebORYAVdfYmc2JqHolMI9dV1y5ZC8NK/5cbm/hRKAHHAw
        1ySfzg6j4njhUuDs2sNc149OkqskrATG4tFFa8INwrhh/ZvhFxEE6Nf4uQCgjyA6
        Zxh52jgpUdR+IWX1kEwbou2dobd0NNYPXTMO3skpwOsA7ZK9zIDg7QtyWLwFCv3d
        skGzAjWqmV48HwXol/7jrfTf4psKqOma0MDGdm+/SFxuJetSvIe3KnkVAt/oIxd8
        suOtEw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=wjjec6ic/gl/14+2+vUByl2Px4ePo0YT/nvkiquon
        6o=; b=h1HNZbEFSbhaZo/jAmA42R6EXo0vnynrdFMUPFynQeq9i0EK2vJVZcXjh
        HZGl5ajjHR2yzSfxGo/UR4C5o5FRK5EB2MicC+KAIzLm6dWB80Qaw/VRzA16NPLQ
        yjqUnhguIZ5qnwPUxU08f8lv/u1ogOfG/9WKK/5KGx9iZ1NXptk+tK1RnEQzkYGB
        mygZCKl8Iwx8AtVXOTcO6vX9m+xmZw2Ss8Zc5aFR/heJZyoG/TKJlzkxVCJ1oAni
        Dh97jf4mMIFzM3VIxL2ItqSDXZrSwRrM163KLKV1ft/zDosJbphOcVtCYP8fhmYK
        TulNMFwwqeB9/uaaDuTuQ+3GuCAsw==
X-ME-Sender: <xms:vIGOX7pztR3hDy5fxRosZKGBHtUDEqVF9CIdaVeyKTIKPO8hr941uw>
    <xme:vIGOX1p-qe9kd4y3swmTgvtdgHjBfW6QGdWoBrhS-rf7X9nwBkHRm_uayRqjx4p0j
    s2xpch7XYi7k51GXlk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrjedvgddufeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufhfffgjkfgfgggtgfesthekredttderjeenucfhrhhomhepgghinhgt
    vghnthcuuegvrhhnrghtuceovhhinhgtvghnthessggvrhhnrghtrdgthheqnecuggftrf
    grthhtvghrnhepudeuveeggedtveduudejgfeiffeiveduiedvjedvudefleetgfefvdfh
    kedtieejnecukfhppeekvddruddvgedrvddukedrgeehnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepvhhinhgtvghnthessggvrhhnrghtrdgt
    hh
X-ME-Proxy: <xmx:vIGOX4MACNF-e-DulcGfwu_tktiOndbCT2aLmYA4nzW9A5dlZ8426A>
    <xmx:vIGOX-5VhYhRf00MJf7zq5_jDBG3y9PVuoiTqWEbNhRoAwVVzf-pMg>
    <xmx:vIGOX64upcNlbmq4UXohnTf1_QaZT-q-Rhz1Yu2f1dKPlUMf59aYew>
    <xmx:vYGOX6EjOl5-awq0fxEzhQCsohCMOAGfeI_hPvLqJuADzbzRazZHSQ>
Received: from neo.luffy.cx (lfbn-idf1-1-134-45.w82-124.abo.wanadoo.fr [82.124.218.45])
        by mail.messagingengine.com (Postfix) with ESMTPA id 82EF73064684;
        Tue, 20 Oct 2020 02:20:44 -0400 (EDT)
Received: by neo.luffy.cx (Postfix, from userid 500)
        id 576C1931; Tue, 20 Oct 2020 08:20:43 +0200 (CEST)
From:   Vincent Bernat <vincent@bernat.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH net-next v1] net: evaluate
 net.conf.ipvX.all.ignore_routes_with_linkdown
References: <20201017125011.2655391-1-vincent@bernat.ch>
        <20201019175326.0e06b89d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Tue, 20 Oct 2020 08:20:43 +0200
In-Reply-To: <20201019175326.0e06b89d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Mon, 19 Oct 2020 17:53:26 -0700")
Message-ID: <m34kmp8ll0.fsf@bernat.ch>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 ❦ 19 octobre 2020 17:53 -07, Jakub Kicinski:

> I'm not hearing any objections, but I have two questions:
>  - do you intend to merge it for 5.10 or 5.11? Because it has a fixes
>    tag, yet it's marked for net-next. If we put it in 5.10 it may get
>    pulled into stable immediately, knowing how things work lately.

I have never been super-familiar with net/net-next. I am always using
net-next and let people sort it out.

>  - we have other sysctls that use IN_DEV_CONF_GET(), e.g.
> "proxy_arp_pvlan" should those also be converted?

I can check them and do that.
-- 
Use library functions.
            - The Elements of Programming Style (Kernighan & Plauger)
