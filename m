Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAF064EA4A
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 12:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbiLPLYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 06:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiLPLYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 06:24:39 -0500
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E560C116F;
        Fri, 16 Dec 2022 03:24:38 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id A162832005D8;
        Fri, 16 Dec 2022 06:24:37 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Fri, 16 Dec 2022 06:24:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1671189877; x=1671276277; bh=64TMHd9mCM
        xlohGzvyOHHYDGzPMMW5ePInqTBtIjYdk=; b=VsF9DdcyJT9XCBQ/qNusAupwue
        44Rl2EOQGWItRfsBUCTBoaHn4g8Ra1HFz88POOmJTsD7A/9wjDwYq4Y4aU+ptnCc
        XXmUUQC9sAXHCbiVE7/NX+YlxjSxnR3CMf1yWd/3iHQHCDUA+97d822o4WHYRScF
        HxIRNc8JN4rbRymDbV7uJeEauYXXMm79JNB692DPPC46jWi2iCyg0EgmfG8Pxno/
        CYj7SH0CLMmOegEKnaECCtgc2NS4sy15JGqF5gtbM/RGMUBKsURT5nY7xpLvZ7Oq
        joxe8Rvdb5gyVdQkNJnNEoe0J2ptnN9Vy34eGuvgrPMzdobfAvKK19oYn0Rw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1671189877; x=1671276277; bh=64TMHd9mCMxlohGzvyOHHYDGzPMM
        W5ePInqTBtIjYdk=; b=K70/qCvoSdbAWKVRz2ukFfBC92/UqdnvlOLb3gMasrh+
        METHyE9dna6KBwcNfF55fEHALvWHR9sejwulAGXfm1r+wwKRs20DstEf8wXVEhPa
        IB5e6FBOiSue95W2sCNBCUJna5g2kp+ON+Q1N1NlFPgEyCWw6Y3HUPZpehKzB5ft
        aJhmNJmFvKoLJkY2rmRdljp7SxNFkfIBWWPVwCAXNlzBwHmtkcLPocRmjA5gZ+rM
        olF1Uu7vm2dSZOoUSqTO2uTMKywN4K9KWJHohNpV6eajO0NcSOtiDwqi2eAe5dY1
        W3eSfP5myBzrQ2zL2KASNEUNzPH14UvlsGvVjgnEHQ==
X-ME-Sender: <xms:c1WcY6KEwMVEF3zUUQCf-FaVuuiwzXRKhl7jfMG161usujl_oEWD3Q>
    <xme:c1WcYyIhcDOiDpQuqPWK6r-9upBqd-OCKvLAII0yYwt-gZC6QJZVRxsFzRxi4pCwY
    0BdvZK-xQHk545nfrA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeejgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedtkeet
    ffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    hnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:c1WcY6v_OqPTHlL7pP07WFByXlkUbKI8i1eoVBwm_Fk70om8xdaoyA>
    <xmx:c1WcY_bpWcKVOdxpqeUwaZbWabwKgR5-NEJG9cqJ2mUUUfyCIHWSRg>
    <xmx:c1WcYxZmh8cVSFyqfpOZGzUcFQhwFzXRhXR9eCMeFkoe2Hm5O23HWg>
    <xmx:dVWcYzl0NW3tLmuqJabNnWj2vwmN8w5d3V68oPAd-iXzPNOZ0KupRA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 8B6D8B60086; Fri, 16 Dec 2022 06:24:35 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1185-g841157300a-fm-20221208.002-g84115730
Mime-Version: 1.0
Message-Id: <e17c7340-8973-417a-a334-01e96e5bbe73@app.fastmail.com>
In-Reply-To: <Y5xEITNJkry8uy/h@salvia>
References: <20221215170324.2579685-1-arnd@kernel.org>
 <e1fea67-7425-f13d-e5bd-3d80d9a8afb8@ssi.bg> <Y5xEITNJkry8uy/h@salvia>
Date:   Fri, 16 Dec 2022 12:24:15 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        "Julian Anastasov" <ja@ssi.bg>
Cc:     "Arnd Bergmann" <arnd@kernel.org>,
        "Simon Horman" <horms@verge.net.au>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Jiri Wiesner" <jwiesner@suse.de>, Netdev <netdev@vger.kernel.org>,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ipvs: use div_s64 for signed division
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

On Fri, Dec 16, 2022, at 11:10, Pablo Neira Ayuso wrote:
> Hi Julian,
>
> On Thu, Dec 15, 2022 at 09:01:59PM +0200, Julian Anastasov wrote:
>> 
>> 	Hello,
>> 
>> On Thu, 15 Dec 2022, Arnd Bergmann wrote:
>> 
>> > From: Arnd Bergmann <arnd@arndb.de>
>> > 
>> > do_div() is only well-behaved for positive numbers, and now warns
>> > when the first argument is a an s64:
>> > 
>> > net/netfilter/ipvs/ip_vs_est.c: In function 'ip_vs_est_calc_limits':
>> > include/asm-generic/div64.h:222:35: error: comparison of distinct pointer types lacks a cast [-Werror]
>> >   222 |         (void)(((typeof((n)) *)0) == ((uint64_t *)0));  \
>> >       |                                   ^~
>> > net/netfilter/ipvs/ip_vs_est.c:694:17: note: in expansion of macro 'do_div'
>> >   694 |                 do_div(val, loops);
>> 
>> 	net-next already contains fix for this warning
>> and changes val to u64.
>
> Arnd's patch applies fine on top of net-next, maybe he is addressing
> something else?

No, it's the same bug. I had prepared my patch before the other fix
went in, and only one of the two is needed.

FWIW, I find my version slightly more readable, but Jakub's fix
is probably more efficient, because the unsigned 64-bit division
is better optimized on 32-bit, while div_s64() goes through an
extern function.

     Arnd
