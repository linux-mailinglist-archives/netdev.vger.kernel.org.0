Return-Path: <netdev+bounces-8134-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 458EA722DD6
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:46:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01F83281390
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:46:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 738681F95A;
	Mon,  5 Jun 2023 17:46:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6611CAD2E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 17:46:16 +0000 (UTC)
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9679D3;
	Mon,  5 Jun 2023 10:46:14 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.nyi.internal (Postfix) with ESMTP id 31C145C07D0;
	Mon,  5 Jun 2023 13:46:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 05 Jun 2023 13:46:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm2; t=1685987174; x=1686073574; bh=0D
	eKljtqv6lqaJdIHmqFM3etKOU9LUCfxv5ALEd/s4s=; b=HjUEBHZPVLNdZ8CkrB
	Jc3kuKIseG7jpdvOLiPhw7qvBppuiVhXr2vnACBmfP/oCIs2mfTPFylcw1bocsBh
	FyKkONAH+Qv5DWkB8pw2ceNfpd/WDp+2TEq90sIR11p5Cf+ja0cKvHyckJpdliJx
	LC17HHarEgOR6Fu2WWsPStT2Xr4Daj9bFFljSz84Hug+1c41jsdVtkpI0sgoPgwb
	v23/ty5h4OuTjVzo/C+qDvcNh7wiOYOyxBRB+X++/hVYtofBTuxKxoE0pJqpPl6+
	vvkKupSlR2PUvSMUuhktXSAeOhZRfs9FJZCocidvnReM4U0W5xELkbbnCHRJTpeX
	lnHQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1685987174; x=1686073574; bh=0DeKljtqv6lqa
	JdIHmqFM3etKOU9LUCfxv5ALEd/s4s=; b=xb0FGfJfb+echf8hVRXo3sgzmIYiZ
	DK23FfWTuh9q9eDdVwzCyyf2IOKLYIKGIFpqy+VIwP7yofyOOFoq6c5gFyV9D46N
	wAptctg8hDM5610bsIJPfgu241TRZ0B22DY/JoB/XMCqCZSkeoz41RDqTW/UOu1n
	d+Z4hWmecc6A3ouBTe+H/FrzOgFwvl7Ky4t8aLqS+/cvAfIik+9ZEbn0IELhXCU/
	EDU4dTM61pTHLsyh5kGCk5a/Xk7cS3wVwOwDcVPW/aSCYePAjir0MwK8fxYMR/BC
	/NzRb5XuoGopJjR41gOIOyuiJ4813+mtYw18Xt/hvtmb7BwBRCRa4OG1A==
X-ME-Sender: <xms:ZR9-ZGPmTd6N3E4XmzwPnV-WTSC14wYR84t9uOg4ikCREYnPU5q9bA>
    <xme:ZR9-ZE8mYim1-yCqYtyO413Ux-XWQADFVjo3e0_xBNP_5hCip3-LsQg2kABxGUqPf
    XDZHlyfIa3HA1R_xys>
X-ME-Received: <xmr:ZR9-ZNShaZdHQKVEDaYu3dVRZQP_pKDgS50_1fqcJo_lwX72HHP9PWNUVT0JhNU6anau4eAH6yzBIch-DIx_0wYi49qKQ6rixwMi-b1G32Hj>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeelledguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfhgfhffvvefuffgjkfggtgesth
    dtredttdertdenucfhrhhomhepufhtvghfrghnucftohgvshgthhcuoehshhhrseguvghv
    khgvrhhnvghlrdhioheqnecuggftrfgrthhtvghrnhepveelgffghfehudeitdehjeevhe
    dthfetvdfhledutedvgeeikeeggefgudeguedtnecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomhepshhhrhesuggvvhhkvghrnhgvlhdrihho
X-ME-Proxy: <xmx:ZR9-ZGvLsav1kzaKYGMYepvr7DjAN0WKeCP5AchMrIUIdSxcJU-cuA>
    <xmx:ZR9-ZOeCXWTGYIMtN6OSQClsHFrrETjDh6rLC6TVbk2L0wbz4OpbkA>
    <xmx:ZR9-ZK3iRj9-_1AqiQsVe4l9euiCzgtN8fd1uvknvFI_pjNx_K1KqA>
    <xmx:Zh9-ZLFQTjPiwU1VTBDpkHM8Qk5F8fJmyrgYEjenrD_HbTzlmYPZMw>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Jun 2023 13:46:12 -0400 (EDT)
References: <20230518211751.3492982-1-shr@devkernel.io>
 <20230518211751.3492982-3-shr@devkernel.io>
 <20230531102915.0afc570b@kernel.org>
User-agent: mu4e 1.10.1; emacs 28.2.50
From: Stefan Roesch <shr@devkernel.io>
To: Jakub Kicinski <kuba@kernel.org>
Cc: io-uring@vger.kernel.org, kernel-team@fb.com, axboe@kernel.dk,
 ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, olivier@trillion01.com
Subject: Re: [PATCH v13 2/7] net: introduce napi_busy_loop_rcu()
Date: Mon, 05 Jun 2023 10:45:55 -0700
In-reply-to: <20230531102915.0afc570b@kernel.org>
Message-ID: <qvqwilc1yf8e.fsf@devbig1114.prn1.facebook.com>
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

> On Thu, 18 May 2023 14:17:46 -0700 Stefan Roesch wrote:
>> + * napi_busy_loop_rcu() - busy poll (caller holds rcu read lock)
>> + * @napi_id         : napi id
>> + * @loop_end        : function to check for loop end
>> + * @loop_end_arg    : argument for loop end function
>> + * @prefer_busy_poll: prefer busy poll
>> + * @budget          : budget for busy poll
>> + *
>> + * Warning: caller must hold rcu read lock.
>
> I think it's worth noting that until the non-RCU version this one may
> exit without calling need_resched(). Otherwise the entire kdoc can go
> IMO, it adds no value. It just restates the arguments and the RCU-iness
> is obviously implied by the suffix.

I fixed the comment.

