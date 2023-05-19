Return-Path: <netdev+bounces-3798-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04756708E75
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 05:54:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB0331C211D3
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 03:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04FA9635;
	Fri, 19 May 2023 03:54:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8480633
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 03:54:11 +0000 (UTC)
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0C510DD
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 20:54:08 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id 4E90E5C01AE;
	Thu, 18 May 2023 23:54:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 18 May 2023 23:54:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm1; t=1684468447; x=1684554847; bh=um
	SjgA4XUoB88WswBJFEy3EA9InqSo7y9pwlJc8Cz04=; b=L14lKNKLrRTbzWwmJ/
	iYWKHyQ4VvJA0Cn5U8mcLPbygcr0ASqvUhzc2B/YAbMcJKx5Tw3P9f2b8QWZBdED
	48mJTVSJqpxd5SS32sdbaQcGUQtnPTVYNmj5V8cS6Fu20JbC1xmFrEFjlpYrgz3Z
	45o/O4CNI9lAcwUDPCYKpxx+qRY1qwPfxXnpl3J0l+3d+0vq3Aq4vEdsFlRACLGZ
	WhrT3XIctAS/5g1mGWNgOmQVNGEzeTO8NqEq5610Kj1uqrUBPAgHCmeZ0nGsY363
	62p4MaCc80y3C8SRwXmLJYZzVC7oLBgFWv1EK3OBMcDCF2h/CDETbLUYrcrNKk4X
	Jg3w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1684468447; x=1684554847; bh=umSjgA4XUoB88
	WswBJFEy3EA9InqSo7y9pwlJc8Cz04=; b=XzCqp2RKRojbMBhZYnkJbKkMhAWDJ
	wFubKH8+F9dTpc1/AmU1Ega4VQiwdg77yTBC+C3fA9wtovPTpJrvNLQmDJtrNgRF
	nRVljaOZ4hPEtjDfWAeFz0hfrwH8vxmYmDfD08/jNtBH8UfbFroUUSmoCyl1Cfc/
	D0wqgu1+80Vz7F/S7bY4z2R2LZn9Xi1IMr1q6yLK1nuEReleVxn4wMqP3DhXGd7U
	oK7KvPAfVDgLDc84TnR4zBKf9KfSmygLceEv6iKnZK9b/hjfqupSEl1kGU/zYIJk
	sp1IlrrihgiOC/6rukkf+TvfI1TWNyoZjmS5pNejPj6Sm8gwc4eZyjJpw==
X-ME-Sender: <xms:3_JmZOloJDGThTamR2s-k41EalnZBYpMV4qEVBOw6HVnTScxufURFQ>
    <xme:3_JmZF0dhK9WsSO-fiGDA0YfNboEvbxZWfdGAWyQVcPXGdE6_8MSUvYN0jkHxUo28
    blpu4X_yeHEbBlWFe0>
X-ME-Received: <xmr:3_JmZMpmvhw0I2pURc0SY6VvknfscNWGE8cd3JV8Z2XXohSciAlC7VEO95aEaJDGmC86EXnVMrs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeigedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdluddtmdenucfjughrpehffgfhvfevufffjgfkgggtsehttdertddt
    redtnecuhfhrohhmpegglhgrughimhhirhcupfhikhhishhhkhhinhcuoehvlhgrughimh
    hirhesnhhikhhishhhkhhinhdrphifqeenucggtffrrghtthgvrhhnpeeigfdvgeeiieel
    udehueeuueejieeiheegudevhffggeeguddvveduueehueefgeenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehvlhgrughimhhirhesnhhikhhi
    shhhkhhinhdrphif
X-ME-Proxy: <xmx:3_JmZCmshoCau9NK6Q3I1GRFF1TM71WB6CQNVV79pCZ0Ou_y1hIyAw>
    <xmx:3_JmZM3nEzgmB280f4gsJooZQKkb5I9Eba-qfSKIi2hAKn71-8bQ4g>
    <xmx:3_JmZJt8nrrUphZiBOYvKssDI683E-aT7DI65yEomscmRTFZuaJc7A>
    <xmx:3_JmZBvsCHSotkR0gldBvJU9LOU_KblOD7FJ6NYIB2D857CC4eh8GQ>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 May 2023 23:54:03 -0400 (EDT)
References: <20230518134601.17873-1-vladimir@nikishkin.pw>
 <20230518084908.7c0e14d4@hermes.local>
User-agent: mu4e 1.8.14; emacs 30.0.50
From: Vladimir Nikishkin <vladimir@nikishkin.pw>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
 gnault@redhat.com, razor@blackwall.org, idosch@nvidia.com,
 liuhangbin@gmail.com, eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v4] ip-link: add support for nolocalbypass
 in vxlan
Date: Fri, 19 May 2023 11:50:03 +0800
In-reply-to: <20230518084908.7c0e14d4@hermes.local>
Message-ID: <87cz2xt1rb.fsf@laptop.lockywolf.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Stephen Hemminger <stephen@networkplumber.org> writes:

> On Thu, 18 May 2023 21:46:01 +0800
> Vladimir Nikishkin <vladimir@nikishkin.pw> wrote:
>
>> +	if (tb[IFLA_VXLAN_LOCALBYPASS]) {
>> +		__u8 localbypass = rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]);
>> +
>> +		print_bool(PRINT_JSON, "localbypass", NULL, localbypass);
>> +		if (localbypass) {
>> +			print_string(PRINT_FP, NULL, "localbypass ", NULL);
>> +		} else {
>> +			print_string(PRINT_FP, NULL, "nolocalbypass ", NULL);
>> +		}
>> +	}
>
> You don't have to print anything if nolocalbypass.  Use presence as
> a boolean in JSON.
>
> I.e.
> 	if (tb[IFLA_VXLAN_LOCALBYPASS] &&
> 	   rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS])) {
> 		print_bool(PRINT_ANY, "localbypass", "localbypass", true);
> 	}
>
> That is what other options do.
> Follows the best practices for changes to existing programs: your
> new feature should look like all the others.

Sorry, I do not understand. I intended to do exactly that, and I copied
and adjusted for the option name the code currently used for the
"udpcsum" option. Which is exactly

		if (is_json_context()) {
			print_bool(PRINT_ANY, "udp_csum", NULL, udp_csum);
		} else {
			if (!udp_csum)
				fputs("no", f);
			fputs("udpcsum ", f);
		}
I just replaced that option name with [no]localbypass. Fairly
straightforward, prints noudpcsum or udpcsum. Later Andrea C

Then Andrea Claudi suggested that print_bool knows about the json
context itself, so the outer check is not needed, so I removed that.
But the "model option" I used (really the simplest one), does have
output both when set to true, and when set to false. I have neither an
opinion on this nor an understanding what is better for scripting. But I
do not understand the suggestion "do like the other options do", when
seemingly, other options do what I suggest in the first place.

-- 
Your sincerely,
Vladimir Nikishkin (MiEr, lockywolf)
(Laptop)
--
Fastmail.


