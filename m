Return-Path: <netdev+bounces-6902-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D00F0718A00
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 21:18:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BC46281542
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 19:18:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC60A1B8E9;
	Wed, 31 May 2023 19:18:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0EE805
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 19:18:49 +0000 (UTC)
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F956136;
	Wed, 31 May 2023 12:18:47 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.west.internal (Postfix) with ESMTP id 720523200488;
	Wed, 31 May 2023 15:18:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 31 May 2023 15:18:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm2; t=1685560724; x=1685647124; bh=xq
	8RBedQ3sB9Mo7GT+EN0dCesgPG9Vj9tJJoe1zny1M=; b=jh1xX9pfANE0yprjLp
	srqy1gT3wr5+d3aHfrMtNPGTYcznlT6YpnWn/T98iH28pstLVRXohapRxmqr2zQC
	drqD4UOcrLHSzoS/c8Lnqs8aXOPmEUtS5ZQDL4Z9HaTzl/orvXHy62UHdVCn/Nnp
	LFOyW/jRnjnwpmFUpisI54AvWoc37ssYhroFnL1QDTFQgpEyQ7mQrzWLBF7oux1y
	u1Vn6fKdYHEfcQ/plK/CDx/FqLOSLgZ62BjSo4H+5OWr86B3WDLz9x5fr6bFqHJb
	jbM2eSYXWBSc/RJdlyRB3iLpoJOhQRjwQPHgQUiBdUAR5gmI+EeLHqtxGGTIKQ/G
	6EWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1685560724; x=1685647124; bh=xq8RBedQ3sB9M
	o7GT+EN0dCesgPG9Vj9tJJoe1zny1M=; b=S8cPPK+jpvT50eFsxGvJHTlZ4w2y4
	xMk+3qLKeJZ97VjNLxXIIqxiVkt6jMAb6o6nb01ZuA2onXly+Mz1KAuOwFqK5oRX
	OaJ5mRrQ2MIE+tGycvUXorya30aTch9PpUlSOnzr9QV2MDtGhu5A0pmTHrD6LieB
	PQZCQq02G11ofL9+31AUTnh/DDM5zB6AeCGUVh0xhCNkRDzHY3jeNQD3M8pIU5T0
	lXoDd2n0uuuIT00CDBd7webh1ZYFXwU6zp20gR9pLhFKmzLciT5xvUVAnR9mqpXQ
	zoSffHvA43W6Ioz+qVXCgtUIJ64g6I4ccsZDPCW6kITbHbc6wZX2P1cpA==
X-ME-Sender: <xms:k513ZLgkuKU0dkiSY95VneVKYY4PqcOk1G8ZuZDYiIU_GgowpMM9oA>
    <xme:k513ZIAO-7HVzKOM0L6qGdWFELd1ebnMGJ-pO1DatVAVbMrGxQ7kqURdq7yk4Do1n
    gYinalwuiqIe8kJg0g>
X-ME-Received: <xmr:k513ZLGETKyA5DLs3Zv9eLuY8v2ENz3G8_xFO2I2eo-Um38q5DOhqb9bt8GiKUIzCJf6ZVwbDZyXHBKGIFfk4lCA0zU7-jlCfDHiqDOZMMcn>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeekledgudefhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfhgfhffvvefuffgjkfggtgesth
    dtredttdertdenucfhrhhomhepufhtvghfrghnucftohgvshgthhcuoehshhhrseguvghv
    khgvrhhnvghlrdhioheqnecuggftrfgrthhtvghrnhephffgjeevudduhedvudevgfduvd
    fffefghfeiuedufeduhffhieejfeejffehledvnecuffhomhgrihhnpehkvghrnhgvlhdr
    ohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hshhhrseguvghvkhgvrhhnvghlrdhioh
X-ME-Proxy: <xmx:k513ZITx2jGfQBnoKfqtrqTmVHYJGe8Et5ujGK-yePLmI9rTgs5i0g>
    <xmx:k513ZIwxKUlkk7FBNvpyDKnVICU5X55QrHLnWTTW8M-B-EFRSEgsjg>
    <xmx:k513ZO58BL92IT8Ww5Qf5s8sURqVYnyOaGTS-CUn0JZE9HUFrgEEiA>
    <xmx:lJ13ZHrrmh3PcA_FwN3bD9GI8Y2RSIBoalztSGx6AheQ8b0l54s0ig>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 31 May 2023 15:18:42 -0400 (EDT)
References: <20230518211751.3492982-1-shr@devkernel.io>
 <20230518211751.3492982-2-shr@devkernel.io>
 <20230531103224.17a462cc@kernel.org>
User-agent: mu4e 1.10.1; emacs 28.2.50
From: Stefan Roesch <shr@devkernel.io>
To: Jakub Kicinski <kuba@kernel.org>
Cc: io-uring@vger.kernel.org, kernel-team@fb.com, axboe@kernel.dk,
 ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, olivier@trillion01.com
Subject: Re: [PATCH v13 1/7] net: split off __napi_busy_poll from
 napi_busy_poll
Date: Wed, 31 May 2023 12:16:50 -0700
In-reply-to: <20230531103224.17a462cc@kernel.org>
Message-ID: <qvqwleh41f8x.fsf@devbig1114.prn1.facebook.com>
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


Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 18 May 2023 14:17:45 -0700 Stefan Roesch wrote:
>> -	napi = napi_by_id(napi_id);
>> -	if (!napi)
>> +	ctx.napi = napi_by_id(napi_id);
>> +	if (!ctx.napi)
>>  		goto out;
>>
>>  	preempt_disable();
>
> This will conflict with:
>
>     https://git.kernel.org/netdev/net-next/c/c857946a4e26
>
> :( Not sure what to do about it..
>
> Maybe we can merge a simpler version to unblock io-uring (just add
> need_resched() to your loop_end callback and you'll get the same
> behavior). Refactor in net-next in parallel. Then once trees converge
> do simple a cleanup and call the _rcu version?

Jakub, I can certainly call need_resched() in the loop_end callback, but
isn't there a potential race? need_resched() in the loop_end callback
might not return true, but the need_resched() call in napi_busy_poll
does?

