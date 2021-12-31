Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30304821E4
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 04:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241049AbhLaDnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 22:43:33 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:39119 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231222AbhLaDnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 22:43:32 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 0F4643201C39
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 22:43:31 -0500 (EST)
Received: from imap48 ([10.202.2.98])
  by compute5.internal (MEProxy); Thu, 30 Dec 2021 22:43:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        chrishellberg.com; h=mime-version:message-id:date:from:to
        :subject:content-type; s=fm2; bh=UqwOZK8spKwIX2d8icR50vxhuPLTVRs
        HKjBRk+hognE=; b=sdteuxu4U/r/jcczHbiCEVKiI69Odh8NoEq+9cM1q1jwEJM
        DXPBRpZsLSJjJIKWKvZ8fxt6ku3bsH8k9y0gwW5F7rBN+DNYMB/ZYNzt2+v0D0Z/
        BTKVDWcrXU5bx1Q3+BkmqtCzZa9PKv62gv/Ex8gBjwFu8lraeN528PEU9BM6zx45
        86QmqnU5WUgk881ZGB/uz320EO+Jb2rUV1opYoC8VhlbkS42E0c1RzqG9ngLXQYx
        Zs7BKsGwHMl44bGbeQ1QCk2eL8gXqIkr9OPYFY9osjz02DGet3OI7N1CHaqbjWo2
        Lye+0n7vosFPBJM0a1TSRaVAy3CXq0OVCkiNKtA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; bh=UqwOZK8spKwIX2d8icR50vxhuPLTV
        RsHKjBRk+hognE=; b=QpJLAyjXxTHDnnW9Tut3PnlilXuzt8LML5u2wokK+81PV
        jeHsccqPSuBT2dCAqNkWq9IommcV2UdsgUI92FNRrHR8ZAAylUQ/ar6fqFhkM898
        lY9/h7bCleydQ8Rsbo6beK21TnWe5dZWSjHc01X9/rBr1sizMjnjfsDEymMhjz7/
        Oey7nxgPrVSxP6gaETEWBfhkDnLSX5Kns7sM/PhaTIRbhgQxffj86zWx2JhTzTpS
        h911ojD9NIZtBJRDdM650maYK2CE40Gzwgedd3ZJIjQlKmu7v295m8Wtl8Rw/C9B
        4ZUTG9q/KKRSnjeNfXX3CMgUcNU0dFXziBxTVIb3w==
X-ME-Sender: <xms:Y3zOYaS2GFfo7Z9HoUoyf04l5TCTqSmfhnZfZCJLW6Ccc1Q9x4GH8Q>
    <xme:Y3zOYfw3wyh1v2C1gGaaxIS7UJE5sMB3mEWvZ8VFDZustd6xLweDNUftHEqkfwICE
    SHXq7RK6TH3J3f3Vw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddvgedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefofgggkfffhffvufgtsehttdertd
    erredtnecuhfhrohhmpedfvehhrhhishcujfgvlhhlsggvrhhgfdcuoegthhhrihhssegt
    hhhrihhshhgvlhhlsggvrhhgrdgtohhmqeenucggtffrrghtthgvrhhnpeehfeejfffhue
    evlefgvdejueetheeuveejveffgedttdehkeejueetveeijeegjeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegthhhrihhssegthhhrihhshh
    gvlhhlsggvrhhgrdgtohhm
X-ME-Proxy: <xmx:Y3zOYX2WG9vmB05RNMsG6OiPQEKVNreO86pMgUxkPbtKn34kevap1A>
    <xmx:Y3zOYWDNEnqg1CxE2jTsgeZPfNoTKhLjNjfWRnYcLzjIfhjmyPH5VA>
    <xmx:Y3zOYTh2Sa_PB4mgmCX9Q_U1KyGLYcUmqfKGyWjSDd2btyZ2WXhIUQ>
    <xmx:Y3zOYevRo2EeysHA4pyV21mpTTB8LZYJ75I2TC7nlXjkMZwMtBNjVA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 59B3D21E006E; Thu, 30 Dec 2021 22:43:31 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4525-g8883000b21-fm-20211221.001-g8883000b
Mime-Version: 1.0
Message-Id: <629c7820-2080-4e63-a3d3-b3dcffb2f6c8@www.fastmail.com>
Date:   Thu, 30 Dec 2021 22:44:50 -0500
From:   "Chris Hellberg" <chris@chrishellberg.com>
To:     netdev@vger.kernel.org
Subject: IPV6 MTU
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

If we set an up or link-down interface MTU below MIN_IPV6_MTU, all traces of IPv6 dissappear from the interface stack (no sysctl variables or /proc/sys/net/ipv6/<if> exist). Restoring the MTU re-activates IPv6 again. For ease of user debugging when such a state exists (i.e. IPv6 would be active on this interface but-for MTU), is there any interest for an interface flag that could hint at this condition? Or some other kind of persistent indicator somewhere else appropriate?

If yes to the latter instead of an interface flag, would a sysctl be the best best place?

Thanks,

Chris
