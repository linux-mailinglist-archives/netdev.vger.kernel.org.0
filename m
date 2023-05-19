Return-Path: <netdev+bounces-4035-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1EB270A33A
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 01:17:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B7871C211CD
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 23:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62E4B5683;
	Fri, 19 May 2023 23:17:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B18567E
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 23:17:30 +0000 (UTC)
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293C31B0;
	Fri, 19 May 2023 16:17:29 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.west.internal (Postfix) with ESMTP id 2CB9F3200928;
	Fri, 19 May 2023 19:17:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 19 May 2023 19:17:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm2; t=1684538247; x=1684624647; bh=Ly
	gemaea07HZtQv77fs87uw14qURDTNYWC8SdvMTfdo=; b=a+WV6lWCsY4UtbLskq
	Oy+k5fNs4pVedKTSeiluLYYvMit4RBAUNVKtqznQ7fBRbXdaDLkJm5IUlSXbVZzA
	7S8OdvfJhP+trQuaHnwwz4XoCehvuqWtze/ZHZPQXzr7jaf//XccIjW127II4pty
	jX0hu9nekdgqFX9FSC1Q/3+glfsECugQGnbw6CHvvc4Jpg1DTfDqWfmzGEEHikGr
	kv2M+0dF9292LCc55Me9AD9M7sHi3sMV3dtKYpnLTP1lPLOg30Y435fICmyYBedh
	bNvHrtNZ9owEIQ58Et8r1HO/2aNfo5e6BbnSOH/g0xQTiJV6yZFUrgD5I8kw6RrD
	7afg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1684538247; x=1684624647; bh=Lygemaea07HZt
	Qv77fs87uw14qURDTNYWC8SdvMTfdo=; b=IB8k+VWI7kdCPtguSl29Vw2uwSCpT
	5TIEnm4c5kj2+DdruiQTDONflqTafy+B4ml1YBRBc816URF/OLh+qlGJLg2e/yFy
	WP4DkijhZa7OkyT/TNpecN30KeIXDq3l9mLTf5nJ2mvF0kWZ/M7mVTkT0qn79KQX
	RB8GM1hs3jSIQL63plluDm1DSkkIq22vOvv7A2+lC3AWd6grDojjSeZ8Nw2PV462
	GwtB0GzMqTYx5u4nbO+auW8FGszPf2PrHBeC4yHzH8mzirzCjiBu/PNsPknw32VT
	m+RL3A1IamcZ0Ob8nmJ4wZngOoEKVsK4a8tcrp5VCu85isjYx40XVmEvA==
X-ME-Sender: <xms:hwNoZBa6df4fWeyfSbcuiwbyWQYfCF5Bsi_1VR9ZVh7CevmNznjEoA>
    <xme:hwNoZIYbjgWBPH_H95MlE9b1L5TEr2ko2Ik26rRKQPWrCaLDWydrKFy_tUCzGT8Q1
    U1zygt5Cp-wHbvtNU0>
X-ME-Received: <xmr:hwNoZD90JJUpSxJ5ZqxVlaz574tUNQ81ajq01Bae6SS05B38GcHEvRzX2vnSiigBVutMsiMp6_vCrHywkmaWzcLce16OL3pHW0E1VNiWQ7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeiiedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfhgfhffvvefuffgjkfggtgesthdtredttdertdenucfhrhhomhepufhtvghf
    rghnucftohgvshgthhcuoehshhhrseguvghvkhgvrhhnvghlrdhioheqnecuggftrfgrth
    htvghrnhepveelgffghfehudeitdehjeevhedthfetvdfhledutedvgeeikeeggefgudeg
    uedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsh
    hhrhesuggvvhhkvghrnhgvlhdrihho
X-ME-Proxy: <xmx:hwNoZPqE7VGQjW2ycS_dAj65G0u5nrVmJM6_dfBznKcDGr80ZhCyEw>
    <xmx:hwNoZMr-VeaqBN6xVdxZu5awCTppFTIYpHsds6_HYT6uVHLn0l6T7Q>
    <xmx:hwNoZFSUpeRSrLJnVvijY4-aIN_HR13lil2K9btglYZxlMEdfyb5eA>
    <xmx:hwNoZNfQvcT_mhA7AbhprmO21v0i94dwPkYiFgnwvWX9AzrVEiFsOg>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 May 2023 19:17:26 -0400 (EDT)
References: <20230518211751.3492982-1-shr@devkernel.io>
 <20230518211751.3492982-5-shr@devkernel.io>
 <ZGdHGXOfbPd+i1qh@corigine.com>
User-agent: mu4e 1.10.1; emacs 28.2.50
From: Stefan Roesch <shr@devkernel.io>
To: Simon Horman <simon.horman@corigine.com>
Cc: io-uring@vger.kernel.org, kernel-team@fb.com, axboe@kernel.dk,
 ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, kuba@kernel.org,
 olivier@trillion01.com
Subject: Re: [PATCH v13 4/7] io-uring: add napi busy poll support
Date: Fri, 19 May 2023 16:17:11 -0700
In-reply-to: <ZGdHGXOfbPd+i1qh@corigine.com>
Message-ID: <qvqwmt1zx662.fsf@devbig1114.prn1.facebook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Simon Horman <simon.horman@corigine.com> writes:

> On Thu, May 18, 2023 at 02:17:48PM -0700, Stefan Roesch wrote:
>> This adds the napi busy polling support in io_uring.c. It adds a new
>> napi_list to the io_ring_ctx structure. This list contains the list of
>> napi_id's that are currently enabled for busy polling. The list is
>> synchronized by the new napi_lock spin lock. The current default napi
>> busy polling time is stored in napi_busy_poll_to. If napi busy polling
>> is not enabled, the value is 0.
>>
>> In addition there is also a hash table. The hash table store the napi
>> id ond the pointer to the above list nodes. The hash table is used to
>
> nit: is 'ond' correct here?
>
>> speed up the lookup to the list elements. The hash table is synchronized
>> with rcu.
>>
>> The NAPI_TIMEOUT is stored as a timeout to make sure that the time a
>> napi entry is stored in the napi list is limited.
>>
>> The busy poll timeout is also stored as part of the io_wait_queue. This
>> is necessary as for sq polling the poll interval needs to be adjusted
>> and the napi callback allows only to pass in one value.
>>
>> This has been tested with two simple programs from the liburing library
>> repository: the napi client and the napi server program. The client
>> sends a request, which has a timestamp in its payload and the server
>> replies with the same payload. The client calculates the roundtrip time
>
> nit: checkpatch.pl --codespell says:
>
>
> :636: WARNING: 'calcualte' may be misspelled - perhaps 'calculate'?
> and stores it to calcualte the results.
>                  ^^^^^^^^^
>
> ...

Fixed in the next version.

