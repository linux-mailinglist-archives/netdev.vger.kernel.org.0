Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D377D297053
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 15:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S464582AbgJWNWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 09:22:40 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36553 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439273AbgJWNWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 09:22:39 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 949CB5C017C;
        Fri, 23 Oct 2020 09:22:38 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 23 Oct 2020 09:22:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bernat.ch; h=
        from:to:cc:subject:references:date:in-reply-to:message-id
        :mime-version:content-type:content-transfer-encoding; s=fm1; bh=
        MGk7O0lzZXLldInFb/fhg44cUCyDne/PWofmN5A2z+g=; b=YPGHG9kZUixCvmmY
        WZcXpPoFQsukF+/nOJdiI9STOTFC3XL9UvbTJp94UlWeGIfqinpbvaDyO7peKstX
        wft8bA7PSuGz8Al7x7SZPvBzgvSlus+Z2RdrmRnUOAloxAEBwfMd/cHqvsscXlOs
        wgcKnbYI+Ua6B1HO1ooimilQNCbFsqU+655aAsvoD7CrBANLGZZBUsJzXrIt71xj
        nQiM1cndrfUxIy1C96hH6Ud3DbJKPqOaf3SgWpVdRp5D5Cd4aYQ09/K/0GoXq/Y9
        PbJg4fRiR4Q1XJ/G4sFk9vBmRFJOT6rpgks/+MPY8b1yFQyfdWkbdN4fhEf6wyuM
        J+IhXQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=MGk7O0lzZXLldInFb/fhg44cUCyDne/PWofmN5A2z
        +g=; b=mSXtSKDFmN+x+in6n3r37vZihW9kJBofGEkNJFf17OdR7IkVrks52Y+US
        3tKC4PiVqPdVumAX+2Sp1jSxIp9EOadpfZ5xv+kyDib4hKD7ijXmOkixoCjCNCu3
        4DXXYCOX1W/CTcveDh2YZrtxfcgd1D9VqnR9gDwzmvesuObvt3mhQWCJZ3bx9hMS
        3sBxIoL1OGwZV0LBQ7gDLL+4OMGYrK7RCQ/Om9o9kmi+lP0wG2dmJDTLYE4KUfJl
        jotBXUHsOLzz3swc9Dd7FaDVfhDUTobc/UTnm3HDOSoeDKFm99IFyTenkdYsslAu
        TJ3JezmQkFuaqx5f3WLxl4a0mdgmg==
X-ME-Sender: <xms:HdmSX0AQ-sRkvFIDwxfTviMEovLTYDTkcovYSC6CQ9wk8I4Pl_xNxg>
    <xme:HdmSX2iHCEzM7EwUnSo3FWUxLp3-K9n-c3GyFqHyz2m2SHpYjtdYDA0neRA4Mvl4O
    GYR6ai-wTkSKhcLoZg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkedtgdeifecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufhffjgfkfgggtgfgsehtkeertddtreejnecuhfhrohhmpeggihhntggv
    nhhtuceuvghrnhgrthcuoehvihhntggvnhhtsegsvghrnhgrthdrtghhqeenucggtffrrg
    htthgvrhhnpeduueevgeegtdevuddujefgieffieevudeivdejvddufeeltefgfedvhfek
    tdeijeenucfkphepkedvrdduvdegrddvudekrdegheenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehvihhntggvnhhtsegsvghrnhgrthdrtghh
X-ME-Proxy: <xmx:HdmSX3lviQQEwHZW34PKgt6OdZ_If6xGUTtbPmmoYHPgHGFQVb92Rw>
    <xmx:HdmSX6yYGl-IeKOkBJU_XYbUeWQepDcotnE-23ywuTsB2kU8aL9Zcw>
    <xmx:HdmSX5RNUYbJI8jMlxtL2zoEhMqRZQjYGJpwGWatv7BKk3sAthuJQw>
    <xmx:HtmSX4KNc8ealzpYSAvovAnziGEeyg03bUy4ClrwNO1vf0LYh3pK_A>
Received: from neo.luffy.cx (lfbn-idf1-1-134-45.w82-124.abo.wanadoo.fr [82.124.218.45])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3D77A3064674;
        Fri, 23 Oct 2020 09:22:37 -0400 (EDT)
Received: by neo.luffy.cx (Postfix, from userid 500)
        id 3F35F505; Fri, 23 Oct 2020 12:02:20 +0200 (CEST)
From:   Vincent Bernat <vincent@bernat.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Laurent Fasnacht <fasnacht@protonmail.ch>
Subject: Re: [PATCH net-next v2] net: core: enable SO_BINDTODEVICE for
 non-root users
References: <20200331132009.1306283-1-vincent@bernat.ch>
        <20200402.174735.1088204254915987225.davem@davemloft.net>
Date:   Fri, 23 Oct 2020 12:02:20 +0200
In-Reply-To: <20200402.174735.1088204254915987225.davem@davemloft.net> (David
        Miller's message of "Thu, 02 Apr 2020 17:47:35 -0700 (PDT)")
Message-ID: <m37drhs1jn.fsf@bernat.ch>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 ❦  2 avril 2020 17:47 -07, David Miller:

>> Currently, SO_BINDTODEVICE requires CAP_NET_RAW. This change allows a
>> non-root user to bind a socket to an interface if it is not already
>> bound.
>  ...
>
> Ok I'm convinced now, thanks for your patience.

I've got some user feedback about this patch. I didn't think the patch
would allow to circumvent routing policies on most common setups, but
VPN may setup a default route with a lower metric and an application may
(on purpose or by accident) use SO_BINDTODEVICE to circumvent the lower
metric route:

default via 10.81.0.1 dev tun0 proto static metric 50
default via 192.168.122.1 dev enp1s0 proto dhcp metric 100

I am wondering if we should revert the patch for 5.10 while we can,
waiting for a better solution (and breaking people relying on the new
behavior in 5.9).

Then, I can propose a patch with a sysctl to avoid breaking existing
setups.
-- 
I must have a prodigious quantity of mind; it takes me as much as a
week sometimes to make it up.
		-- Mark Twain, "The Innocents Abroad"
