Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A145327A70D
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 07:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgI1FqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 01:46:21 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:47157 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725290AbgI1FqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 01:46:21 -0400
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Sep 2020 01:46:20 EDT
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailforward.west.internal (Postfix) with ESMTP id A0544779;
        Mon, 28 Sep 2020 01:39:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute7.internal (MEProxy); Mon, 28 Sep 2020 01:39:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=2c+Qmjr9/O1r/GDbWbfvl1NrCXpbOipqyUQetkNvP
        7s=; b=Oiz6WH3LeF0W4pNbXUhCGuciTDsuav5tdOx7p7XF+VmaYcCq32H8L/i3a
        G5wd1Yad+Uq1Vm2IqYMfq2ZjGX/k8eppAgfFyDSg72M/oDMLcTabbIaZvF5p2Kc/
        fSRPYpd9UGQLuu9BcDSmbL++ApDY9sWpKxi/o6c5qyGSyT/reOVEJOHW4OpWGnoZ
        Ja6KJaMXfoW2gP1QCw6+TVYxJBLT+wQW4D2wSstZtey8HwK6JqHprUqjvRclMoRN
        DtOHDInqoO9LVuPYUWzn+jYP/uGumaPTV6910CvFK4RJUApArww3K+NYD+Xv8At9
        eFLL2hpaVUIZ5xGZqC8Aq09/9DiPw==
X-ME-Sender: <xms:A3dxX9EllZ3LXjOdyOzwRT2fN77lrjfz3UL8U8gwZ-1BHdAPimCeVQ>
    <xme:A3dxXyX8HHvI8mVgPn4BQt23qlOuHdU_EYuoIJjaDebukrxgCppDkjDsDot7hC2iz
    TnoV_jqSwjXTKZCHrg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehgdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffuohhfffgjkfgfgggtgfesthekredttderjeenucfhrhhomhepgghinhgt
    vghnthcuuegvrhhnrghtuceosggvrhhnrghtseguvggsihgrnhdrohhrgheqnecuggftrf
    grthhtvghrnhepvdevtddtueevfeeuheejtdfftefgffdvleejudeuheegteekvdffteev
    vdekjefhnecukfhppeekvddruddvgedrvddukedrgeehnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepsggvrhhnrghtseguvggsihgrnhdrohhr
    gh
X-ME-Proxy: <xmx:A3dxX_LxXPU1aSk-WTYfH8ryUzIUHmnrBuWnAVSHzm6xTh6AZfKYGg>
    <xmx:A3dxXzHc7SW4hmCtdcLDr7-Q7f9RrpJpTn3W5DY240YeNiOdLGRmHg>
    <xmx:A3dxXzWLipEwM_2wnOCM2j-RmUC8OxvGtZ4Nv1bPuYHKdEt5kU8WBw>
    <xmx:BXdxXwjqxZX657SIZ0KmcmPYw5qkAt1lMKAM8wYGUPagPsMbOc3nbWG9F3g>
Received: from guybrush.luffy.cx (lfbn-idf1-1-134-45.w82-124.abo.wanadoo.fr [82.124.218.45])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9B25A328005E;
        Mon, 28 Sep 2020 01:39:15 -0400 (EDT)
Received: by guybrush.luffy.cx (Postfix, from userid 1000)
        id 820EA1FE67; Mon, 28 Sep 2020 07:39:13 +0200 (CEST)
From:   Vincent Bernat <bernat@debian.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Baptiste Jonglez <baptiste@bitsofnetworks.org>,
        Alarig Le Lay <alarig@swordarmor.fr>, netdev@vger.kernel.org,
        jack@basilfillan.uk, Oliver <bird-o@sernet.de>
Subject: Re: IPv6 regression introduced by commit
 3b6761d18bc11f2af2a6fc494e9026d39593f22c
Organization: Debian
References: <20200305081747.tullbdlj66yf3w2w@mew.swordarmor.fr>
        <d8a0069a-b387-c470-8599-d892e4a35881@gmail.com>
        <20200927153552.GA471334@fedic> <20200927161031.GB471334@fedic>
        <66345b05-7864-ced2-7f3c-493260be39f7@gmail.com>
Date:   Mon, 28 Sep 2020 07:39:13 +0200
In-Reply-To: <66345b05-7864-ced2-7f3c-493260be39f7@gmail.com> (David Ahern's
        message of "Sun, 27 Sep 2020 20:38:28 -0700")
Message-ID: <87wo0e8npa.fsf@debian.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 ❦ 27 septembre 2020 20:38 -07, David Ahern:

> fib_rt_alloc is incremented by calls to ip6_dst_alloc. Each of your
> 9,999 pings is to a unique address and hence causes a dst to be
> allocated and the counter to be incremented. It is never decremented.
> That is standard operating procedure.

At some point, only PMTU exceptions would create a dst entry.
-- 
Program defensively.
            - The Elements of Programming Style (Kernighan & Plauger)
