Return-Path: <netdev+bounces-8135-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B22C722DE0
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:49:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E06611C20CFF
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:49:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A85621085;
	Mon,  5 Jun 2023 17:49:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3A0DDC0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 17:49:10 +0000 (UTC)
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBE8D3;
	Mon,  5 Jun 2023 10:49:08 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id 07BCE5C048C;
	Mon,  5 Jun 2023 13:49:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 05 Jun 2023 13:49:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm2; t=1685987348; x=1686073748; bh=CR
	AvmTIH40O0REPmvDf766olnWstfls6qzUCF62M4b0=; b=ULGk+jR/jhbhp0Xwpq
	2rXJ7lQB/llAANUyPXQ01kkIaqBfloA63F+kUKNofxBN0mPLaXutE0hw8XTza+wQ
	6G8tjKNosnujuLZECft5OXoubA92qgPx17umJGgFIfIqOSLH9B6SmTUPCEeOq0dO
	LCzLuCAF2DCDCpdxSkMpGDGDKKcralqblLKnSUmhyw63D1S9VFSlmYVolMWMzBW6
	UJZf4L5fnuYDLA5vHQM2NAbWuH9tt+ksCbwp0zsJB1VOVLx9sl3vSIE9pwr9Iv5W
	EQ4fQyukgSx0U/K0FafWYsL1wyOzK5XuWBMDVNPZ4kRGDi4RVqVH/l549N06k2/v
	ZqUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1685987348; x=1686073748; bh=CRAvmTIH40O0R
	EPmvDf766olnWstfls6qzUCF62M4b0=; b=dnGzp5bUnxc4fBA/3iDVdz8fEWEIk
	jrMccqHHelZsa5GsLqgZPfF24JV8kv0+o9Yyt33C/eIxWBEIdMZKZa3JqFrbgk5D
	yypJrKIKAXycNbXVWfVVYWG3g3WoG2yZEQRwgnVxi8Avle0WEmLzK60B01dFzncy
	iyIiSgU1VbpDxXBYko2WO2zul9kQvMPRurLTFVA67qWhSWCPUroQtcRcFI0ECQgL
	rLwvatDhXagGyYVZOn7DfxW8sOxpVcOSkmLGJotdwp4Q2egKHDNdx5AFRAabWVl6
	tqZ6fzQhUOpwNHiw8Ok14v4WNe/fYBLshhPpIqLF2x9tlfvhnBHcJ7jyA==
X-ME-Sender: <xms:EyB-ZMA4t4zaCSxazvjy4DdFhCG-onf6qeroKuuoLfowMV_5xKzUJw>
    <xme:EyB-ZOjF9Z8tq043ZQzalXKsedNlanKHyfwmhbNdP7NrH2VaMaql17F9tIU13K7Xy
    0nDquTM-4nPC_aLRq4>
X-ME-Received: <xmr:EyB-ZPkLtIR6K6yK5PdwPNR-nBupNPoAx3wrGF-dNUmITjwZxgiAtt5StscJClttTRVrNmHZgBvptv4W1aJHnH3iXDqaViqxRmS6zJRcTqwO>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeelledguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfhgfhffvvefuffgjkfggtgesth
    dtredttdertdenucfhrhhomhepufhtvghfrghnucftohgvshgthhcuoehshhhrseguvghv
    khgvrhhnvghlrdhioheqnecuggftrfgrthhtvghrnhepveelgffghfehudeitdehjeevhe
    dthfetvdfhledutedvgeeikeeggefgudeguedtnecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomhepshhhrhesuggvvhhkvghrnhgvlhdrihho
X-ME-Proxy: <xmx:EyB-ZCw72n-lty64zmTkZnycByOMZN8pph9gYlGtwCsXjtNx7UOTfQ>
    <xmx:EyB-ZBR-6HF-6vDOKKnyoSI0Ig7WBHzDM6U2_qyP67-yGGsn5KAeXw>
    <xmx:EyB-ZNZCmnRvWYlluRdTjeozglLskB_KAbzk2P0Nx-No8_XCMg1NyA>
    <xmx:FCB-ZKKEEFTG9kFfazz5jgE8KmYEDvrRvfPI8wJhDWsvBT-k7LaI6g>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Jun 2023 13:49:06 -0400 (EDT)
References: <20230518211751.3492982-1-shr@devkernel.io>
 <20230518211751.3492982-2-shr@devkernel.io>
 <20230531102644.7f171d48@kernel.org>
User-agent: mu4e 1.10.1; emacs 28.2.50
From: Stefan Roesch <shr@devkernel.io>
To: Jakub Kicinski <kuba@kernel.org>
Cc: io-uring@vger.kernel.org, kernel-team@fb.com, axboe@kernel.dk,
 ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, olivier@trillion01.com
Subject: Re: [PATCH v13 1/7] net: split off __napi_busy_poll from
 napi_busy_poll
Date: Mon, 05 Jun 2023 10:47:40 -0700
In-reply-to: <20230531102644.7f171d48@kernel.org>
Message-ID: <qvqwedmpyf3i.fsf@devbig1114.prn1.facebook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 18 May 2023 14:17:45 -0700 Stefan Roesch wrote:
>>  	unsigned long start_time = loop_end ? busy_loop_current_time() : 0;
>> -	int (*napi_poll)(struct napi_struct *napi, int budget);
>> -	void *have_poll_lock = NULL;
>> -	struct napi_struct *napi;
>> +	struct napi_busy_poll_ctx ctx = {};
>>
>>  restart:
>
> Can you refactor this further? I think the only state that's kept
> across "restarts" is the start_time right? So this version is
> effectively a loop around what ends up being napi_busy_loop_rcu(), no?

I'm not sure I understand this correctly. Do you want the start time to
be a parameter of the function napi_busy_poll_rcu?

