Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEEB6632C74
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 19:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbiKUS5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 13:57:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbiKUS5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 13:57:05 -0500
Received: from wnew1-smtp.messagingengine.com (wnew1-smtp.messagingengine.com [64.147.123.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7C4C72EA;
        Mon, 21 Nov 2022 10:57:04 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 4C3DC2B0683B;
        Mon, 21 Nov 2022 13:57:03 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 21 Nov 2022 13:57:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1669057022; x=1669060622; bh=4U+2CfZtTr
        w4vMOFIzkSYGvH1dTr+pAfh9aTANkQNAQ=; b=c0obsyoF1hZ2ztKkmAGgVfQNjp
        lhQEbD4T75V1bkfTqcziOjeTfy+bYVf+Op9PI3TqBdMNne+Y8AOH/l/D3HLjEhat
        /DIvrbbQ4QOf3HSAv1lyWE6Nl0iVLRHWm45gResyVdm8P0B6HTsN0IvlYPPRsAm8
        8iVcmOO+Czjoy+ls1sBVcaU0omVsve3ks7bYAgT1g9vwoOWvxgESC2ETTGxY7o5D
        gX6htbswFrTgAfysDz7h2FhsFgLogZZfKHmfPzTqZkOAT3KkiVA3yvhDNT7crT+B
        7VvKLxktib3PqEOwZnFrwCiHZPTQIEImIS8kPGqm+7OR1Hrb03AGQOQuwVqw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1669057022; x=1669060622; bh=4U+2CfZtTrw4vMOFIzkSYGvH1dTr
        +pAfh9aTANkQNAQ=; b=ZkBsYK2DzzJCyRgglwdhDUbtC3AOXaXt9Gq+83BKxCq5
        mcw2LClCbH6bK3LZiWSJjJIFr+AS3lmQUptyW61xPPBhIydDhRxG2sINCFSEljrT
        dGzhhI8BlcASQZ7aSqV1KbqBtDCCZGUo5R7t/N1rT3lT5I2b2njOlOnd9L/Y/bUT
        dEbADZEL6d6NWAhWTfavSVXK2Fbdrzx8hkl9bZlAryXycwXt9egoLN1Q7QbTNp37
        uKlAA/q2o1DUHqCeF1HC7KpGVEAdmldd5kyzCuatHLbJoLYyguLt8BIXOjj2Jck7
        od/YXjvIxcxu+x2gNcqhVGnGC0B+Oq5PrEmm9NC2CQ==
X-ME-Sender: <xms:_sl7Y6S0yxD_ilSCBeErDaBhIJfgb-aWB5fKauCzvtlnRN01P3-kgg>
    <xme:_sl7Y_xdLTJM-QwoQRAkDsaQfOpH5gnYKHWbhc9Z9VhCp6Ws-Ihg2Z_R5LZ-QbpFw
    _CtucHrrcjGAmCTT08>
X-ME-Received: <xmr:_sl7Y33EcUMBt3ewHaUjshmM8G4djtrQJiuZ06Os6K15yoPLBvdTt7V-37YgkvIoGzUvZZ0sMg0p1BVRLdMXj_dw9TlyHdwtZlYFqoB6>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrheeigdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfhgfhffvvefuffgjkfggtgesthdtredttdertdenucfhrhhomhepufhtvghf
    rghnucftohgvshgthhcuoehshhhrseguvghvkhgvrhhnvghlrdhioheqnecuggftrfgrth
    htvghrnhepveelgffghfehudeitdehjeevhedthfetvdfhledutedvgeeikeeggefgudeg
    uedtnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepsh
    hhrhesuggvvhhkvghrnhgvlhdrihho
X-ME-Proxy: <xmx:_sl7Y2BjGLxXwZdOFt7t201bXsYg5EsaoY8c_15Ouh46OOjPT-K6kw>
    <xmx:_sl7YzhUbhivYfS1Hwhxg2JUjK9_XoC04Ls078T-M1reclcmIZCcFQ>
    <xmx:_sl7YyrIKjvumZhAa-KlesfydwrLa4szzYtK8f757jHL0Fc_1LGSYQ>
    <xmx:_sl7Y5Z2AIjj6-44D5dPfC6ivqnyy1O-q_I59YIePBXE-2gh_lKJpryj49M>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Nov 2022 13:57:01 -0500 (EST)
References: <20221121172953.4030697-1-shr@devkernel.io>
 <20221121172953.4030697-3-shr@devkernel.io>
 <2dde9961-b820-c301-6eb7-c5a26309c019@gnuweeb.org>
User-agent: mu4e 1.6.11; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [RFC PATCH v4 2/3] io_uring: add api to set / get napi
 configuration.
Date:   Mon, 21 Nov 2022 10:56:39 -0800
In-reply-to: <2dde9961-b820-c301-6eb7-c5a26309c019@gnuweeb.org>
Message-ID: <qvqwwn7o3zlv.fsf@dev0134.prn3.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLACK autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Ammar Faizi <ammarfaizi2@gnuweeb.org> writes:

> On 11/22/22 12:29 AM, Stefan Roesch wrote:
>> +static int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
>> +{
>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +	const struct io_uring_napi curr = {
>> +		.busy_poll_to = ctx->napi_busy_poll_to,
>> +	};
>> +	struct io_uring_napi *napi;
>> +
>> +	napi = memdup_user(arg, sizeof(*napi));
>> +	if (IS_ERR(napi))
>> +		return PTR_ERR(napi);
>> +
>> +	WRITE_ONCE(ctx->napi_busy_poll_to, napi->busy_poll_to);
>> +
>> +	kfree(napi);
>> +
>> +	if (copy_to_user(arg, &curr, sizeof(curr)))
>> +		return -EFAULT;
>> +
>> +	return 0;
>
> Considering:
>
>    1) `struct io_uring_napi` is 16 bytes in size.
>
>    2) The lifetime of `struct io_uring_napi *napi;` is brief.
>
> There is no need to use memdup_user() and kfree(). You can place it
> on the stack and use copy_from_user() instead.

The next version of the patch will use copy_from_user.
