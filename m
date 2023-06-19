Return-Path: <netdev+bounces-11994-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9477735A20
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:55:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02962280E4B
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:55:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74B8B11C8F;
	Mon, 19 Jun 2023 14:55:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6429D7477
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 14:55:50 +0000 (UTC)
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA674C1;
	Mon, 19 Jun 2023 07:55:48 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.nyi.internal (Postfix) with ESMTP id 5A9C55C0309;
	Mon, 19 Jun 2023 10:55:48 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Mon, 19 Jun 2023 10:55:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm1; t=1687186548; x=1687272948; bh=h/
	FMBET8Xaxpjw3bixtAd1vmrL7NQ478gCBTrLfRJ4Y=; b=cvTPB6NGU1O3VED7yc
	IMdFBHs6VjuoW1SxIhb/sBEvHJzfHAf90cSLZIHRN8VxAfThEhVKyJzZ8TE+dopj
	M+qRK/EdxB96cB1cw2iTKM0iS0lKcpFuDbqVTkTBGeaHguMLiCIOeikSs83gLGaK
	IU66LEEerwY7d7SdZ9hcXclTZB46ZQnhylRAG8vn/IWk9ou7cvOPyNAgh1cLTkLA
	Kmi7PgDl0x7+qvHs4JRJLkL9ySnGQSOhsGrXe5OdMyNA02aJ0d1Sw94JwogQAwBi
	jU2zo67YYMNPCzdsLyMkZluqf9bnAKzVuAvJubCV+6ClOemjUaA9J9KD4ZOrYzuh
	BseQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm2; t=1687186548; x=1687272948; bh=h/FMBET8Xaxpj
	w3bixtAd1vmrL7NQ478gCBTrLfRJ4Y=; b=MerLevCufwjdx8NK1dD4kVUCgpcgI
	S+YwxBQlhrBlnFal9OqwM8Cs/V0HPDr50ySy+cpfMyxuRJEg/dlq5AJwfzEGl/H4
	jcIXj5lc9SJR9jHaIbr6v1Ty/vOthisocYkc3U4HHFEZQNTRdPDjVfJefNYTMV7L
	TxBB78lNOd1yF7G1peTq0XsgJjZZtLv+BcV0vDZ2sBI+XvBJPuCvidT51IacQJUP
	PH1/cXOYTvjKcpoNVXUvrjYQPWn058F99bK3xVbf/7EZxMHckOvXqLNX9Qzc+nbk
	oeoaIGaF8GzgcElrXhB2TfRdBNZidCtfegNaWCTNwfiIrV5Zy9TyRfh2Q==
X-ME-Sender: <xms:dGyQZDikJedD5WA9taNBq8iKwXiFhPUpvPKAqmSEGuOdWUBzqPsmAA>
    <xme:dGyQZABYJ3imQgZzdGTAd5Bdfjxnxxc_bV2AuUbc8dI0EyPndJI3picUdr63GNfVL
    yH-AXQ77ZVeEwpw1Q4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeefvddgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepgeetiefhjedvhfeffffhvddvvdffgfetvdetiefghefhheduffeljeeuuddv
    lefgnecuffhomhgrihhnpehprghsthgvsghinhdrtghomhenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:dGyQZDHQMJlqfAyTh3DYhay56F1LsDlCVMmX48i5fz3sDYN_CLtKag>
    <xmx:dGyQZAQX5MQL-3kfeVQGmxa5EQrHnXxtAccLCAcZqFb4CjyMhx28Zw>
    <xmx:dGyQZAwpv61AKyxrBmS1tQQKJZDB7eT6MBPYS_uFXeH--xAOieFkig>
    <xmx:dGyQZDziFqMVjlV9c7wu7W3p8bp-KT_syrEGMN0wTODyQgBHMrloFQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 2F7ACB60086; Mon, 19 Jun 2023 10:55:48 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-496-g8c46984af0-fm-20230615.001-g8c46984a
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <7047eaa9-30b6-47bd-a878-7508449c9e20@app.fastmail.com>
In-Reply-To: <7c448f02-4031-0a90-97e2-0cc663b0cff9@gmail.com>
References: <20230619091215.2731541-1-arnd@kernel.org>
 <20230619091215.2731541-3-arnd@kernel.org>
 <7c448f02-4031-0a90-97e2-0cc663b0cff9@gmail.com>
Date: Mon, 19 Jun 2023 16:55:27 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Edward Cree" <ecree.xilinx@gmail.com>, "Arnd Bergmann" <arnd@kernel.org>,
 "Martin Habets" <habetsm.xilinx@gmail.com>,
 "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>
Cc: Netdev <netdev@vger.kernel.org>, linux-net-drivers@amd.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sfc: selftest: fix struct packing
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023, at 12:25, Edward Cree wrote:
> On 19/06/2023 10:12, Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>> 
>> Three of the sfc drivers define a packed loopback_payload structure with an
>> ethernet header followed by an IP header. However, the kernel definition
>> of iphdr specifies that this is 4-byte aligned, causing a W=1 warning:
>> 
>> net/ethernet/sfc/siena/selftest.c:46:15: error: field ip within 'struct efx_loopback_payload' is less aligned than 'struct iphdr' and is usually due to 'struct efx_loopback_payload' being packed, which can lead to unaligned accesses [-Werror,-Wunaligned-access]
>>         struct iphdr ip;
>> 
>> As the iphdr packing is not easily changed without breaking other code,
>> change the three structures to use a local definition instead.
>> 
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Duplicating the definition isn't the prettiest thing in the world; it'd
>  do for a quick fix if needed but I assume W=1 warnings aren't blocking
>  anyone, so maybe defer this one for now and I'll follow up soon with a
>  rewrite that fixes this more cleanly?  My idea is to drop the __packed
>  from the containing struct, make efx_begin_loopback() copy the layers
>  separately, and efx_loopback_rx_packet() similarly do something less
>  direct than casting the packet data to the struct.
>
> But I don't insist on it; if you want this fix in immediately then I'm
>  okay with that too.

It's not urgent, if you can come up with a nicer solution, that is
probably better than applying my patch now. I have a patch [1] that
addresses -Wunaligned-access for all x86 and arm randconfig builds,
and this currently affects 23 drivers. Most of the changes don't
have changelog texts yet, and some need a more detailed analysis to
come up with a correct patch. I'd probably aim for linux-6.6 or
later to get them all done, at which point we could move the warning
from W=1 to the default set.

     Arnd

[1] https://pastebin.com/g6D9NTS4

