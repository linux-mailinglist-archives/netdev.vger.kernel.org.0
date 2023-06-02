Return-Path: <netdev+bounces-7299-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D732B71F93A
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 06:19:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 727FF2819D6
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 04:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 818D1185A;
	Fri,  2 Jun 2023 04:18:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7302A1857
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 04:18:58 +0000 (UTC)
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1070CCE;
	Thu,  1 Jun 2023 21:18:55 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id AB1F35C019B;
	Fri,  2 Jun 2023 00:18:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 02 Jun 2023 00:18:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm2; t=1685679533; x=1685765933; bh=jw
	lnbKUtVtCIh0LKLo96FnXdjqMWzeAxtYjvKSwhWQo=; b=ZwpyeFM+DGdq2OR0/V
	cqMdsNGyAu6+hNBPD8h8MuIfRN64nOWO6LnBOkfOJob7l8sfMVT7wyLSX4BwVlir
	SwpAO0KNQ3Yutn/bkDNFiGtdHf6YSs8nwpYrVzUeI+/4VlF6mjG3qS53EQyacKAn
	Mnc6uphmEfDL/2CbpyRVxrblKDfY3vFx/y73FikdU8kSGakVg/XHZ4aD//R3o09I
	JEhZyrzFEDwL1p0o5oQrG+syqdsPn3+OWqmiJsBMORy0TScxXEIxm/TXnxbVHFUk
	NDrb5CJVYx5TyuW1yWNRsDxKa/GqS4IquRK00+zKs0gnG02g1PJnC1GtcutZ4lAQ
	rUuA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1685679533; x=1685765933; bh=jwlnbKUtVtCIh
	0LKLo96FnXdjqMWzeAxtYjvKSwhWQo=; b=PVZT7TD+KTPO3dO/SgzPQGma2BqdS
	GMpIHookHYnPoV4ZFhFxaFh+yAoFix8RUaMTf/z/RxUJU6in81Wvy6Vo1XSdY/Zr
	n6Es2pKGFRRYajk0m43YPkBeUHmIHzLZxic3KD4okgJypU//WH+1gcx5MDhrvtxv
	/5WSQPKjPsSMPyiWkHQDAm6Qc+AF9uZJg/2WcXZNe6PtxeOaGwwLrCFxjXBgb5Sm
	cmUppj02pO5ZMUR/pM3/s3UUS5mNTKbsP19Rh5tmAVE3uY+acEBi4hU5S5FuMpLB
	SsaeNRFrKURKghERhvYTg4t0xdvUD/0ZRpSvKJf4FBsNLMp9iq1HatPPg==
X-ME-Sender: <xms:rW15ZI3lJzfK7xniSagizJVrNlTgd4vier0Vc8l-uiX3kiaiZqFFdQ>
    <xme:rW15ZDGHK4DPb7J5VrPQSNlRFV7QpWBm7jmNOz9d2PcTaG0WtCkH_y-qOQILhYs_o
    r35fYP9McmLvE98pao>
X-ME-Received: <xmr:rW15ZA7uisTnZ8TIi6RRx4pnZmosrRkX3xTlo3GiIO9p28QA5-abTdmFYA-yp395PEBfRG2J4NKyrsocoHrUj4lGAesYmKDSUmU76YTjbVXJ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeelvddgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpehffgfhvfevufffjgfkgggtsehttd
    ertddtredtnecuhfhrohhmpefuthgvfhgrnhcutfhovghstghhuceoshhhrhesuggvvhhk
    vghrnhgvlhdrihhoqeenucggtffrrghtthgvrhhnpefhgfejveduudehvdduvefguddvff
    efgffhieeuudefudfhhfeijeefjeffheelvdenucffohhmrghinhepkhgvrhhnvghlrdho
    rhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsh
    hhrhesuggvvhhkvghrnhgvlhdrihho
X-ME-Proxy: <xmx:rW15ZB1c015oh7hvayr5ZZpZ6qLbp-hRIlbDqNXbvKiWBLzesGaFqQ>
    <xmx:rW15ZLEKwJGFi6yq0DylkeKxj-jr58bvz0Q8tVixFp3XDFdyI7Hsig>
    <xmx:rW15ZK8vcnIq5nKmgTs4DKoYZtVi3gWHFiSrUzI79OD0Fnvl4leD0w>
    <xmx:rW15ZMOiO1n9uiPfwXAx2OCfGWAc78YXYHnfG3gRC5_-4HbOxhq4qg>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 2 Jun 2023 00:18:52 -0400 (EDT)
References: <20230518211751.3492982-1-shr@devkernel.io>
 <20230518211751.3492982-2-shr@devkernel.io>
 <20230531103224.17a462cc@kernel.org>
 <qvqwleh41f8x.fsf@devbig1114.prn1.facebook.com>
 <20230531211537.2a8fda0f@kernel.org>
User-agent: mu4e 1.10.1; emacs 28.2.50
From: Stefan Roesch <shr@devkernel.io>
To: Jakub Kicinski <kuba@kernel.org>
Cc: io-uring@vger.kernel.org, kernel-team@fb.com, axboe@kernel.dk,
 ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, olivier@trillion01.com
Subject: Re: [PATCH v13 1/7] net: split off __napi_busy_poll from
 napi_busy_poll
Date: Thu, 01 Jun 2023 21:12:10 -0700
In-reply-to: <20230531211537.2a8fda0f@kernel.org>
Message-ID: <qvqwedmuv6mu.fsf@devbig1114.prn1.facebook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Jakub Kicinski <kuba@kernel.org> writes:

> On Wed, 31 May 2023 12:16:50 -0700 Stefan Roesch wrote:
>> > This will conflict with:
>> >
>> >     https://git.kernel.org/netdev/net-next/c/c857946a4e26
>> >
>> > :( Not sure what to do about it..
>> >
>> > Maybe we can merge a simpler version to unblock io-uring (just add
>> > need_resched() to your loop_end callback and you'll get the same
>> > behavior). Refactor in net-next in parallel. Then once trees converge
>> > do simple a cleanup and call the _rcu version?
>>
>> Jakub, I can certainly call need_resched() in the loop_end callback, but
>> isn't there a potential race? need_resched() in the loop_end callback
>> might not return true, but the need_resched() call in napi_busy_poll
>> does?
>
> need_resched() is best effort. It gets added to potentially long
> execution paths and loops. Extra single round thru the loop won't
> make a difference.

I might be missing something, however what can happen at a high-level is:

io_napi_blocking_busy_loop()
  rcu_read_lock()
  __io_napi_busy_do_busy_loop()
  rcu_read_unlock()

in __io_napi_do_busy_loop() we do

__io_napi_do_busy_loop()
  list_foreach_entry_rcu()
    napi_busy_loop()


and in napi_busy_loop()

napi_busy_loop()
  rcu_read_lock()
  __napi_busy_poll()
  loop_end()
  if (need_resched) {
    rcu_read_unlock()
    schedule()
  }


The problem with checking need_resched in loop_end is that need_resched
can be false in loop_end, however the check for need_resched in
napi_busy_loop succeeds. This means that we unlock the rcu read lock and
call schedule. However the code in io_napi_blocking_busy_loop still
believes we hold the read lock.

