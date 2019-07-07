Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7F161764
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 22:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfGGUGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 16:06:25 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51541 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726605AbfGGUGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 16:06:25 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id EEDCB20CB3;
        Sun,  7 Jul 2019 16:06:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Sun, 07 Jul 2019 16:06:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bernat.ch; h=
        from:to:cc:subject:references:date:in-reply-to:message-id
        :mime-version:content-type:content-transfer-encoding; s=fm3; bh=
        8k5L7beQ7WIz5OvR2SvjMS5r1VVaibkay5tIVDWdbHg=; b=AgK/95McTWpJu1s/
        mMRVWuHj7MlPazvoD4b5YvfQD+Qr/aOYmQBqwPD7M4XQPX5f5RSxQINNP6U2sGSw
        EN2KXaRdJzCT2TsrBPSSNsK6iX3Z3pXyweQn1q7Osbs/6/TfLhVLFIk1fop7VRn5
        x8jdMeEC9BfvX/Z7UfCzriE4bjBoCu+cJ79ZSq2abIpUcFCB/6JntMJVvnmw9tVU
        omtE3bnyBT91opT3Y0sZXFcsOs0D5CLPnN+4rT54Uf6Lk/XpmM1CKub6ZfNZKr1y
        15hvSD22oUDGE3CfupFhbs9Zuas4B4fAyBufH0he3MxHH9j6Rf8VvGV9qTlstaj9
        LlsZtQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=8k5L7beQ7WIz5OvR2SvjMS5r1VVaibkay5tIVDWdb
        Hg=; b=NjmRKS38n3khfcJgeDfVz9Ee8DT3RW5i1NhfURUVHDcuBiL3RAquceBfH
        CLqzSLs7HJHBVLusULt7N4tMbOwxh6SN60ZY6TtqVQCjvl4gTdU8ubYAIuKnC73h
        W5bBu3SbbdyZssF5hdE3vTFoFKgWxZVzJDxtgEsUVyGgyh9dYLqot8TudyvmPJk3
        lUUrmwouluZHj5lFBGlJEqyrQjpGB5veP4R0275OREKZ+QNIoeAPwSyDWf8wfBKh
        bLXc2j0H6MJbk8hRfRFxrqGP9qfmYUdAAJC472DOn5mxG6lV+7DxlxMpGInkkeyL
        7n7t7YefrNuWQgrCul1gyqac13XMg==
X-ME-Sender: <xms:v1AiXZQq7kH4x5Zi-u2mW5WsbLf8gc9t-933ab54QxDCW22wMAsbkQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeekgddugeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufhfffgjkfgfgggtgfesthhqredttderjeenucfhrhhomhepgghinhgt
    vghnthcuuegvrhhnrghtuceovhhinhgtvghnthessggvrhhnrghtrdgthheqnecukfhppe
    ekkedruddvuddrieegrdeigeenucfrrghrrghmpehmrghilhhfrhhomhepvhhinhgtvghn
    thessggvrhhnrghtrdgthhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:v1AiXe3JF6Jn8OCPjnNYUN4WEEOgZSM1pa_va1KxOGbiFc5PCTpFhQ>
    <xmx:v1AiXaLddmnK144RQLFFWcNeNQ6DVRohkpWYjlBLcv3t3tQ4pDz5tg>
    <xmx:v1AiXf9GgIQ1zUuwfWunZNt1lJFtj4vFlrKHezJljju42i8gsmW7zA>
    <xmx:v1AiXfDqzS21sWlBkD4CYYX3Tnnnj-zVSt1Jf5oQkN4t7g-XA9koEw>
Received: from zoro.luffy.cx (4vh54-1-88-121-64-64.fbx.proxad.net [88.121.64.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 520E5380083;
        Sun,  7 Jul 2019 16:06:23 -0400 (EDT)
Received: by zoro.luffy.cx (Postfix, from userid 1000)
        id C0137F29; Sun,  7 Jul 2019 22:06:21 +0200 (CEST)
From:   Vincent Bernat <vincent@bernat.ch>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] ip: bond: add peer notification delay support
References: <20190707094141.1b98f3f4@hermes.lan>
        <20190707175115.3704-1-vincent@bernat.ch>
        <20190707114041.4f068bee@xps13.lan>
Date:   Sun, 07 Jul 2019 22:06:21 +0200
In-Reply-To: <20190707114041.4f068bee@xps13.lan> (Stephen Hemminger's message
        of "Sun, 7 Jul 2019 11:40:41 -0700")
Message-ID: <8736jhpq2q.fsf@bernat.ch>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 =E2=9D=A6  7 juillet 2019 11:40 -07, Stephen Hemminger <stephen@networkplu=
mber.org>:

> Looks good. I notice that all these flags don't show up in any man
> page.

Yes, "bond type" is not described at all in the manual page. I'll come
with a patch.
--=20
Your manuscript is both good and original, but the part that is good is not
original and the part that is original is not good.
		-- Samuel Johnson
