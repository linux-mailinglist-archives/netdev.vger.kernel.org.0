Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4743B4B818E
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 08:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiBPH3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 02:29:23 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiBPH3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 02:29:20 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2488F9A9A3;
        Tue, 15 Feb 2022 23:29:08 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 072313201E09;
        Wed, 16 Feb 2022 02:29:05 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 16 Feb 2022 02:29:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=KjXBnBkFmTnMa5KT8
        A0kk6cT1M4Q1T5pu9mdxwSU6xQ=; b=kPgI2gXXWLd3gWz4GQmL2bk9ObAE4/1A8
        W5P+kBGgOOFmTYATO5WW1oXMJmso6eQ8syTSG53dTBxWsCGBQ9CBuiXSupf6HVNN
        GcJ0mZgsWctJCp7txozvDRncCsvitdvbsIkeztZXyyOJRly4ckHlqSlodNsAmPX7
        6vwFvX5BpS3bRLTf8OJjJA76Bht8q+Y4hQC+Jya8UzKHUL0u6cndI3Kh6KLZUEtQ
        Kv0OAEQEzG6HzEoYU1iN0qH/YKWKcd7gJY0/5ZmVvGhVZVvjqn3b9HqJb0n3huTY
        ZTbTIlf+Ka3aAEWEv8Mx59cQtIdtxysq0Y20+vGOgL6xavvteHSUA==
X-ME-Sender: <xms:wacMYpjZ9LMcmE8gNIS8_bueQmtsWtnrkkkM77ScY5Lek1ZMAxeiEA>
    <xme:wacMYuBR1UrrSd1jl5D7TsPsgOpzlWqdpcuCt_SEIOabj0zO7DnRMhJmhgjmWKrSY
    B94w2SSkclpl58>
X-ME-Received: <xmr:wacMYpF0Qza7PJKX4tN5KAkARGCpYNo08o-QfqUS6nWs-Otu8biIgnCFS3Bkt4SzbmuGYlnS_FLp5bJxf_hEUqCh4zs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrjeehgddutdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:wacMYuRTAi6iyezzGuu7wPNGnt1jp4SZ8BXiHH_sbegyv6pUzjZTvg>
    <xmx:wacMYmxU0PicsuQs8KsCRbDrqVYT5HTWIKrch33AFgQIroYAiHgC0A>
    <xmx:wacMYk6WAxlEGQxDD0E0CxSwRVH_82zvSm8mq-gVZCWOeljSOWXKwA>
    <xmx:wacMYtq_EuYmdFNxtYsXtPoc6z9lPkJH3Jd5HdXQtDnDMtOAO-H2Vw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Feb 2022 02:29:04 -0500 (EST)
Date:   Wed, 16 Feb 2022 09:29:00 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     "wanghai (M)" <wanghai38@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, edumazet@google.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] net: ipv4: The sent udp broadcast message may be converted
 to an arp request message
Message-ID: <YgynvByk/juhr+8G@shredder>
References: <55a04a8f-56f3-f73c-2aea-2195923f09d1@huawei.com>
 <YgIhGhh75mR5uLaS@shredder>
 <f8272cf6-333a-c02a-73bf-35989f709e29@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8272cf6-333a-c02a-73bf-35989f709e29@huawei.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 11:19:01AM +0800, wanghai (M) wrote:
> can you push this patch to the linux.git tree please?

Yes. Will post the patch and a test later this week.

BTW, since it's not fixing a regression (scenario never worked AFAICT) I
will target it at net-next.
