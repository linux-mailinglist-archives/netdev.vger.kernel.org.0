Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12D83186CBA
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 14:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731505AbgCPN6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 09:58:33 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:47797 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731392AbgCPN6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 09:58:33 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 6F4AF6F4;
        Mon, 16 Mar 2020 09:58:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Mon, 16 Mar 2020 09:58:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bernat.ch; h=
        from:to:cc:subject:references:date:in-reply-to:message-id
        :mime-version:content-type:content-transfer-encoding; s=fm2; bh=
        S78yM7ohneWcYcpY4lbXRCuhpKHCwQ0ksFDL8Ycinow=; b=jlEBia0RNFk5JGdI
        quSAag+Q8soI/cWjs/na+P8Y00w6aFZ/kbpY5080OZv3RkzCkWNQSFVilrVoYVa1
        MGDL84FeM7OSGdehUvRZCMG23IvpruHvVjZrTvmxUE83zZauUNLEREm501bmNDtf
        0Lk4iC0KIJBeYxzoUh3QvvwUC4IGOSwClwHtGFBXCpgV7SUJoW+8hhLqIJ4Xw0tB
        cZ8ujBr89wPX48IQwgnl4ew+wxpd9DIFhw5kIijyz9at+lmZ/gmCJGq85mP/+36t
        XLdMItFjOqKTECwEgYt1t8Tby1vufS3tSLZxjBc/3TB4FeZ4ZU2WYrFRzjWDeYC6
        xzRk4A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=S78yM7ohneWcYcpY4lbXRCuhpKHCwQ0ksFDL8Ycin
        ow=; b=TK9VzXEU/vBal8yD08eU0EqbLPmAmqj9Y5Vg9YW9yAPkN04ko791c8ae5
        PkWxwa97Jd/8//R2QNVeaEr+4aVKfLiPiduC9gHmrIapeoAoMEGKGJk2wsrfuLxV
        pvRG20XOLKxZZMAUI2wktduL8DjsR3busDCLDnN25YVzAIXWoQ/nE4OIRhHEJXsR
        9Yt5EtEe4BELIvvJj7rU7n0TY2ITijnHwBOxrWXPkhPTpuywVhj4IfGtFWbRpiao
        /pMC0/iENU0ureUPgU0dRkaclEjPGOSBJn8LWZf7ojL3r8afLShtJ31CEpBZ39C6
        yYczkJSLtTdx1igFZrNHI8RYCq6sg==
X-ME-Sender: <xms:BYZvXpwbu-wO6erabOKgOpZ_8xSv-ddamxqfTkqKWqQy4YYdCisVcQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeffedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufhfffgjkfgfgggtgfesthekredttderjeenucfhrhhomhepgghinhgt
    vghnthcuuegvrhhnrghtuceovhhinhgtvghnthessggvrhhnrghtrdgthheqnecukfhppe
    ekvddruddvgedrvddvfedrkeefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomhepvhhinhgtvghnthessggvrhhnrghtrdgthh
X-ME-Proxy: <xmx:BYZvXhBtE4uYGEPZ4HHrrEtUv9H2pwHhgzyhN0egK0bgjsXsA5FoZg>
    <xmx:BYZvXmZLY4AXcWRIQWdhfJfiI6aZAoMkiIChmJLDMTlIAz775g-ADA>
    <xmx:BYZvXpg_nuAW2khUJOtxkUAnZYM2JXTXC3wUDYJXzGMIBLpDvfL-yQ>
    <xmx:B4ZvXobnp9YFKoWEdy6FY3D5NrV0Zkd1aQbEzt8EnQyzN0bnMsYvrg>
Received: from neo.luffy.cx (lfbn-idf1-1-140-83.w82-124.abo.wanadoo.fr [82.124.223.83])
        by mail.messagingengine.com (Postfix) with ESMTPA id B30E73061DC5;
        Mon, 16 Mar 2020 09:58:29 -0400 (EDT)
Received: by neo.luffy.cx (Postfix, from userid 500)
        id 654E65ED; Mon, 16 Mar 2020 14:58:28 +0100 (CET)
From:   Vincent Bernat <vincent@bernat.ch>
To:     David Miller <davem@davemloft.net>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org, kuba@kernel.org,
        edumazet@google.com, kafai@fb.com
Subject: Re: [RFC PATCH net-next v1] net: core: enable SO_BINDTODEVICE for non-root users
References: <20200315155910.3262015-1-vincent@bernat.ch>
        <20200315.170231.388798443331914470.davem@davemloft.net>
        <a2d2b020-c2a7-5efa-497e-44eff651b9ce@gmail.com>
        <20200316.021314.2124785837023809696.davem@davemloft.net>
Date:   Mon, 16 Mar 2020 14:58:28 +0100
In-Reply-To: <20200316.021314.2124785837023809696.davem@davemloft.net> (David
        Miller's message of "Mon, 16 Mar 2020 02:13:14 -0700 (PDT)")
Message-ID: <m3eets9zaz.fsf@bernat.ch>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 ❦ 16 mars 2020 02:13 -07, David Miller:

>> As a reminder, there are currently 3 APIs to specify a preferred device
>> association which influences route lookups:
>> 
>> 1. SO_BINDTODEVICE - sets sk_bound_dev_if and is the strongest binding
>> (ie., can not be overridden),
>> 
>> 2. IP_UNICAST_IF / IPV6_UNICAST_IF - sets uc_index / ucast_oif and is
>> sticky for a socket, and
>> 
>> 3. IP_PKTINFO / IPV6_PKTINFO - which is per message.
>> 
>> The first, SO_BINDTODEVICE, requires root privileges. The last 2 do not
>> require root privileges but only apply to raw and UDP sockets making TCP
>> the outlier.
>> 
>> Further, a downside to the last 2 is that they work for sendmsg only;
>> there is no way to definitively match a response to the sending socket.
>> The key point is that UDP and raw have multiple non-root APIs to dictate
>> a preferred device for sending messages.
>> 
>> Vincent's patch simplifies things quite a bit - allowing consistency
>> across the protocols and directions - but without overriding any
>> administrator settings (e.g., inherited bindings via ebpf programs).
>
> Understood, but I still wonder if this mis-match of privilege
> requirements was by design or unintentional.
>
> Allowing arbitrary users to specify SO_BINDTODEVICE has broad and far
> reaching consequences, so at a minimum if we are going to remove the
> restriction we should at least discuss the implications.

Without VRF, it's hard to build a case where a process could "evade" its
setup using SO_BINDTODEVICE. It could be used to use alternative routing
table when ip rules are using interfaces (which is not uncommon), but I
think almost all such setups are using this to have some isolation in
routing (not for local processes), something that could be replaced by
VRF.

With VRF, removing the restriction allows a process to have more
possibilities than previously if it has not been restricted. This is my
use case: it is actually difficult to use VRF for anything else than
routing because local processes may want to receive connections in a VRF
and forward them to another one.

In summary, unless I am missing something, the main implication is when
using VRF. Without VRF, no real change.

An alternative would be to use a sysctl to decide the behaviour.
-- 
Man is the only animal that blushes -- or needs to.
		-- Mark Twain
