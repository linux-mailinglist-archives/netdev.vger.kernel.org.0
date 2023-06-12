Return-Path: <netdev+bounces-10146-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6A0372C8BB
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:38:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B27C2811D6
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F4BE18C20;
	Mon, 12 Jun 2023 14:38:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85887525E;
	Mon, 12 Jun 2023 14:38:17 +0000 (UTC)
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301D8CD;
	Mon, 12 Jun 2023 07:38:16 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.nyi.internal (Postfix) with ESMTP id 8A2DC5C0116;
	Mon, 12 Jun 2023 10:38:15 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Mon, 12 Jun 2023 10:38:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm1; t=1686580695; x=1686667095; bh=ZL
	tbf+vkYKNwbdqr4ijTHLZjINUGdnp8fp3QuAY9ODo=; b=k4ZWeOyVjN5AfscYB9
	Yz1mj4b49D9gMZwziq6qpkFlWVWLR+EKhBmAUIS0WzgvxGANmi+CCyxsJf6nmyyA
	cnCHsOg/fDvRNYnF9zwp7E7HDk7dDcOZrheQHwYjq1sb7zVc225lLTC604U3Jr2F
	mdpFZfyh4Bbe5gtlDcWa4dDQXhe80hwG3be4coPD2XHgbg9nqDWoMO5pR8KIKQ0f
	HnCVV8HD2NHb2DKPUQlHSdAc8uek6NQsvMWF470Z2EQngZmk5+3xUsydcr4LwWoD
	J6yj7TntqrfqXcza7U2redn4vyPX8RpCq8dyyFu0TVorP2Jrk0mUqcF0RqQxEK7x
	LM+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm2; t=1686580695; x=1686667095; bh=ZLtbf+vkYKNwb
	dqr4ijTHLZjINUGdnp8fp3QuAY9ODo=; b=g8BdJH2bXvlnCZYt6VW4QrbIsuFQ9
	og0difewC1j1os/5sq0KVExEbXrOVKizJ15akK4c0rdc8bMamhTR1pz7hDjuSTPX
	G175lQBA8P70pM8gQWNadhNGs526wB4nboj89+vUW5jc2xEOicqcbNGGq68hXJQV
	3nnaeBD42fGsgNJASmBj5udAbqnd2RyDsk3JfnCxvGypTAJGOD3drVjuICdtXtd3
	B1qXFDbTlvV+EBi0qTsX40Jkl6h2YiICJg5/PQNK9kJ0ymlVN9eRREWjZ1lOFeXq
	tjeKjSZy3EzS6wdQW6WpNXW0qDDjUwJF+SrKybnZiuIlOX9UC+cRbqRdg==
X-ME-Sender: <xms:1y2HZDWDAhBG8gTDDPxuNiSpvbyAxLRPAL-2cEA3Ls33Z2Nnr0kvdg>
    <xme:1y2HZLmXxUUmSP2MiJG2bI2w__QLkh5ESyCKjq0ivtUjmYNjrdS8nX7cUk6SukreC
    g_senb_pqrbqP_KmyA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeduhedgjeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:1y2HZPYnXn8RBJ9NZarTzXwvFx9gTIHXE17Eo0bog66PczrwbWNR7w>
    <xmx:1y2HZOVzqUJJWPRLhgB57v08nAP0ZIfyy3ezMlQc_7YWpQTHm6chPg>
    <xmx:1y2HZNnapUm6j95AJOVobbGi-dDuWUWVYlw-3dWqL-U7Q8s3G304Cg>
    <xmx:1y2HZNEtrrhUUZLhzYvpo4MnM-i0sEieG0Ns2ajPXdJx2SQzqHIZbw>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 224EBB60086; Mon, 12 Jun 2023 10:38:15 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-492-g08e3be04ba-fm-20230607.003-g08e3be04
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <3b5bc8f7-6d6d-48a1-9536-4a50110fabe6@app.fastmail.com>
In-Reply-To: <f0329c00-8d5a-ba89-c793-608f85cf70b3@kernel.org>
References: <20230612124024.520720-1-arnd@kernel.org>
 <20230612124024.520720-3-arnd@kernel.org>
 <f0329c00-8d5a-ba89-c793-608f85cf70b3@kernel.org>
Date: Mon, 12 Jun 2023 16:37:54 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Roger Quadros" <rogerq@kernel.org>, "Arnd Bergmann" <arnd@kernel.org>,
 "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>
Cc: "Grygorii Strashko" <grygorii.strashko@ti.com>,
 Linux-OMAP <linux-omap@vger.kernel.org>,
 "Vignesh Raghavendra" <vigneshr@ti.com>, "Nishanth Menon" <nm@ti.com>,
 "Tero Kristo" <kristo@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>,
 "Mao Wenan" <maowenan@huawei.com>, "Andrew Lunn" <andrew@lunn.ch>,
 Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
 "Alexei Starovoitov" <ast@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>,
 "Jesper Dangaard Brouer" <hawk@kernel.org>,
 "John Fastabend" <john.fastabend@gmail.com>,
 "Simon Horman" <simon.horman@corigine.com>,
 "Vladimir Oltean" <vladimir.oltean@nxp.com>, bpf@vger.kernel.org
Subject: Re: [PATCH 3/3] net: ethernet: ti-cpsw: fix linking built-in code to modules
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023, at 16:27, Roger Quadros wrote:
> On 12/06/2023 15:40, Arnd Bergmann wrote:

> cpsw_priv.o and cpsw_ethtool.o (included in ti-cpsw-priv.o) are not 
> required by ti-am65-cpsw-nuss.
> It only needs cpsw_sl.o

Ok, I see. I'll split that out into yet another module then, and
give it another day of randconfig tests.

     Arnd

