Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5451A29A55F
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 08:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436750AbgJ0HRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 03:17:47 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:41503 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436609AbgJ0HRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 03:17:46 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id A8FA7C75;
        Tue, 27 Oct 2020 03:17:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 27 Oct 2020 03:17:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bernat.ch; h=
        from:to:cc:subject:references:date:in-reply-to:message-id
        :mime-version:content-type:content-transfer-encoding; s=fm1; bh=
        wGIbbS7r8/VVCcX7kCb3aZJRinzEzbwFqUjq4FrFGr0=; b=QYjyypW+hlxVIHsT
        r2mKQhnoj+vG6Uad/Eb9grqcWJkDrfGBjFvGHdYn+skktZbZ3wgA/4evPUicUDPs
        aU6K+I1MbQV0DJCG7WeeCxJMGofr3dsY11evj/cgMQoV7hSNkj80t0M9hvzvU8Fc
        BgopnM+vdyJuwvLVDJiNV/z5NUgV7Vcx97aMjnijArimCh0yhU1jlmy7//ivFQ2T
        PPPZ2iQpNYbifHlNX3ruAAuwe7TBj06dHmWTbHoxCgmpldi+Xb6i5nswRtLuqe6D
        Ja/XUIf6bo+dipc+Tywuh0nzRt77qik4IVjfBc7a08DwTiGknWEt+Nnr3d3buhMf
        Zv9sRw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=wGIbbS7r8/VVCcX7kCb3aZJRinzEzbwFqUjq4FrFG
        r0=; b=eWBvMyn+C3IvzgnvX9accmNO4HFfDSVSb5dM9BVNsE/qOQW6DCfM+nD+C
        ceKWhanXYN9eJTn0AixPniT7DRtA5IdmExMoK7CrYA8F69uviiQhuGYcWy/yb0eV
        vr5dZIF1XEMDUfzkulZWqYelnkKf677P/YzgCxH5pOyshuj9YBYJoJrH64ilxll7
        rRFmYDpWBfKzMAUvuoMVQGONwyMb2AHbBaH86fXhSyYkNueAY8diiBB+RJktbqKN
        r7igRK4tWkcqzGO20ExEPfU4NfrRy9CRr/uEeW9GA1twzGNfgoPx/lB2pwCbsljL
        4cOq/5ZiJQ9yPpXu94q7V0g2bbkqw==
X-ME-Sender: <xms:l8mXX6l2p5q7pv9JtXXqW0_wn6i4Q9M-u1ISfWgxbuIujqjZfH6ssg>
    <xme:l8mXXx14q4dkT51cdNCzG6kLMq2D-csX6cDObeprnvDCp9Rsadx-JLRJ1x3koUN2B
    C0GwevZ1fpM0inFpN8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkeekgddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufhfffgjkfgfgggtgfesthekredttderjeenucfhrhhomhepgghinhgt
    vghnthcuuegvrhhnrghtuceovhhinhgtvghnthessggvrhhnrghtrdgthheqnecuggftrf
    grthhtvghrnhepudeuveeggedtveduudejgfeiffeiveduiedvjedvudefleetgfefvdfh
    kedtieejnecukfhppeeluddrudejuddrvdegfedrudeinecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepvhhinhgtvghnthessggvrhhnrghtrdgt
    hh
X-ME-Proxy: <xmx:l8mXX4qKCKqx4n7t7HgVEndDk_GC2TH6JFd0eK53nOuvgyR99N5f8A>
    <xmx:l8mXX-lkNroxXs8q9oMFVeVNh5uwARRG81z7IcPiZC9UgNlgrMRa7w>
    <xmx:l8mXX40R4nikMFqEiVkQm235p_ZTTpROakMNezaBTINQa6EoAb71sg>
    <xmx:mMmXX1_EszHaVYQKzIrqXZ-iuHIC6oR3L1lY-MVJmzwdFN2zcKHGKA>
Received: from guybrush.luffy.cx (91-171-243-16.subs.proxad.net [91.171.243.16])
        by mail.messagingengine.com (Postfix) with ESMTPA id 616743280065;
        Tue, 27 Oct 2020 03:17:43 -0400 (EDT)
Received: by guybrush.luffy.cx (Postfix, from userid 1000)
        id C2B411FE71; Tue, 27 Oct 2020 08:17:41 +0100 (CET)
From:   Vincent Bernat <vincent@bernat.ch>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Laurent Fasnacht <fasnacht@protonmail.ch>
Subject: Re: [PATCH net-next v2] net: core: enable SO_BINDTODEVICE for
 non-root users
References: <20200331132009.1306283-1-vincent@bernat.ch>
        <20200402.174735.1088204254915987225.davem@davemloft.net>
        <m37drhs1jn.fsf@bernat.ch>
        <ac5341e0-2ed7-2cfb-ec96-5e063fca9598@gmail.com>
Date:   Tue, 27 Oct 2020 08:17:41 +0100
In-Reply-To: <ac5341e0-2ed7-2cfb-ec96-5e063fca9598@gmail.com> (David Ahern's
        message of "Fri, 23 Oct 2020 08:40:31 -0600")
Message-ID: <87tuugkui2.fsf@bernat.ch>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 ❦ 23 octobre 2020 08:40 -06, David Ahern:

>> I am wondering if we should revert the patch for 5.10 while we can,
>> waiting for a better solution (and breaking people relying on the new
>> behavior in 5.9).
>> 
>> Then, I can propose a patch with a sysctl to avoid breaking existing
>> setups.
>> 
>
> I have not walked the details, but it seems like a security policy can
> be installed to get the previous behavior.

libtorrent is using SO_BINDTODEVICE for some reason (code is quite old,
so not git history). Previously, the call was unsuccesful and the error
was logged and ignored. Now, it succeeds and circumvent the routing
policy. Using Netfiler does not help as libtorrent won't act on dropped
packets as the socket is already configured on the wrong interface.
kprobe is unable to modify a syscall and seccomp cannot be applied
globally. LSM are usually distro specific. What kind of security policy
do you have in mind?

Thanks.
-- 
Don't over-comment.
            - The Elements of Programming Style (Kernighan & Plauger)
