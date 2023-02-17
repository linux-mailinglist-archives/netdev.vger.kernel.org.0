Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D66469B0B1
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 17:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbjBQQVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 11:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjBQQUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 11:20:51 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5A960A43;
        Fri, 17 Feb 2023 08:20:08 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 3946A5C00E9;
        Fri, 17 Feb 2023 11:20:01 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Fri, 17 Feb 2023 11:20:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1676650801; x=1676737201; bh=4rbb7vEE/R
        3JXmFGZxqlcG2ZijkFCJI4RWbZOmkiigs=; b=fnBoElB7LI92pCoKZwppYoU0AC
        r1H0xrCFlN7yY7LKNcx5uo452af9Mbd12JnmfG9upGI3uKMC9uq7olHO/1wb8oLc
        tstXcEA7pTW9npqapp3nV+21P6UeJY5VqtpE3nRTkplzBrh4EqpIq0/MLC/sLwrf
        3D8dLPSpSqmQQnLEXOy151WthK3xLUu+x0Uk0QBL5lFxsr+30aCrPcfzOoQPJtsa
        nEztcKFxNLZlWOaABdCy8lrMw2HwiE2a3V3vlwLRlzVZ0pcb6P6E0ZDHezHgvy5X
        lhY61LSUuV5tizIqF2HEjjBUXMPP4p948AoFa8Gr1sUP4fiYhMakQa6yW/TQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1676650801; x=1676737201; bh=4rbb7vEE/R3JXmFGZxqlcG2ZijkF
        CJI4RWbZOmkiigs=; b=WsFh5Wa007lomCyjBsX+0kOfOG+vgNYLBaQwyvsyyVYE
        WWo+ET4+pxblN60jtUEiayBIQtlTuOYtwIVBAIRhHk3xF9ew60/8PSjulAffTEoo
        Jrrgo+BakAGDWDtGhKwxkT7E2i5uIQnnXAZ6wjcaxnMSyCefu+ms+r7XK5axudAU
        14Augl1O5QsViNpF85x0Q/ugfqy9d7Pu1XSFF6b7Eu5+DG9tB3Fs0m2SZVUffwtK
        4MjrnFVM7pH9xOCVUSHIy9lzS4Y06jAxTklyX73qLmmnJKzEaUOxIGzDyz0fLdok
        pZQzP+lQ4IeGsIXrsUIv4BHXQvrfTQQ7np96a2XFNA==
X-ME-Sender: <xms:MKnvY94rZFelDAbtdO0M9swmrSVyJfVsLwhjtS0H7aloknWTzHJj6Q>
    <xme:MKnvY649rnFcK4D--DZcaIUrPbdy2n6n7i6u2J1EzaJUq6sToulToEYImPPpzHfRz
    AHFzcWeYE5OzllEWyU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeiledgkeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:MKnvY0fvYqpIEOX8Am9SYfRU9R6UwbI3sMIwK5Im_enFgaYMjq6W3Q>
    <xmx:MKnvY2IXcduQ1BRdkcZGv1vwyZ_XngBBPgIL3VNcqLU52E7a-V8jvQ>
    <xmx:MKnvYxLFxNAtgM1b3FX0MGtw63eYwNZy9YtW2mY8XWi8TIm-dfEGSw>
    <xmx:ManvY6XUYg-Ug-SOSgJTZsJqmedVKM2-pay0gQNLcFmTZnFHl3CAcQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id A29BFB60089; Fri, 17 Feb 2023 11:20:00 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-156-g081acc5ed5-fm-20230206.001-g081acc5e
Mime-Version: 1.0
Message-Id: <9e066063-a2e7-494a-9784-2fc37ef77094@app.fastmail.com>
In-Reply-To: <f38d6b22-f846-5637-d58b-2d8862bc6840@gmail.com>
References: <20230217095650.2305559-1-arnd@kernel.org>
 <f38d6b22-f846-5637-d58b-2d8862bc6840@gmail.com>
Date:   Fri, 17 Feb 2023 17:19:26 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Edward Cree" <ecree.xilinx@gmail.com>,
        "Arnd Bergmann" <arnd@kernel.org>,
        "Martin Habets" <habetsm.xilinx@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Cc:     "Jonathan Cooper" <jonathan.s.cooper@amd.com>,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        "Leon Romanovsky" <leon@kernel.org>
Subject: Re: [PATCH] sfc: use IS_ENABLED() checks for CONFIG_SFC_SRIOV
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023, at 17:13, Edward Cree wrote:
> On 17/02/2023 09:56, Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>> 
>> One local variable has become unused after a recent change:
>> 
>> drivers/net/ethernet/sfc/ef100_nic.c: In function 'ef100_probe_netdev_pf':
>> drivers/net/ethernet/sfc/ef100_nic.c:1155:21: error: unused variable 'net_dev' [-Werror=unused-variable]
>>   struct net_device *net_dev = efx->net_dev;
>>                      ^~~~~~~
>> 
>> The variable is still used in an #ifdef. Replace the #ifdef with
>> an if(IS_ENABLED()) check that lets the compiler see where it is
>> used, rather than adding another #ifdef.
>
> So we've had Leon telling us[1] to use __maybe_unused, and you're
>  saying to use IS_ENABLED() instead.  Which is right?
> (And does it make any difference to build time?  I'm assuming the
>  compiler is smart enough that this change doesn't affect text
>  size...?)
> -ed

Both are correct, but I prefer the IS_ENABLED() change because it
improves build coverage. The resulting object code should be the
same, as the dead-code-elimination in gcc takes care of removing
it the same way.

If you use the __maybe_uninitialized annotation, you still need
an extra fix to initialize the ef100_probe_netdev_pf() return
code.

      Arnd
