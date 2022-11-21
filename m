Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B8E632C6A
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 19:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiKUSzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 13:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiKUSzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 13:55:35 -0500
Received: from wnew1-smtp.messagingengine.com (wnew1-smtp.messagingengine.com [64.147.123.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C516859FFE;
        Mon, 21 Nov 2022 10:55:34 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id C81772B06839;
        Mon, 21 Nov 2022 13:55:31 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 21 Nov 2022 13:55:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1669056931; x=1669060531; bh=gbDYpRgXS/
        PrcuHRn0a0spyU+256g08Jc7t1RMRjpMY=; b=mEKAq8maOOvvCGWF7PHAqUE842
        n2sLV8kkeJPorytfzX8gzcSs/abpW6R46ncY6G3VknRTMV60EayaBmoMVeE1TH3V
        d6+qZZGBAQD2bhZkMpAWKnOOEIn+b8Scju9s9+mJU5cksF/7K+6rYq0eb4fTfrFB
        iVcZz3gVA6lQyZ8ZzGww5Hz5W7UbBTsEoi1rkvd+paGKtEVhHA+JnKABbhnFzJ+3
        mBA/UaIKQY6HcmmzYkOJMmbtmUTm+ew8hOdQUlwfkGML5T3QcSlsCk2X0gO8cdWf
        7WidvyhWqioxbfNrpzFbnYZ2mUCb85aQ82Vm+kunUP0VfcnC+6cKizMTWLnQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1669056931; x=1669060531; bh=gbDYpRgXS/PrcuHRn0a0spyU+256
        g08Jc7t1RMRjpMY=; b=TY/qDe5214oCum7xfL4dwa3yHtj9pnFDeVI+EwdQMN9M
        D467oeNrkRY9+6DW936vAj/FsvbH1h7FIubkx0amwiIEpJCq/Tr21+y8xD6D7MNJ
        gYH+nlYU7LqQfgRuXwwaB+sna4X0kM6FwPUvdn4GUMVxPYX0PnVGPBb/mroMJH7S
        QPi/tQauCCEKjoSwo1p5xs8SxVUHaOuwnv5KW00/wGR3kRxIhXHUv22gm/I6bb3P
        whDgQxnG/zxrMRUXZN/PWEbSIwnnzbPIEjqCyvTtMKMRxxID+w5L8Bq5ITUGyI3n
        D+dMOJCPLkpBM4EdWq4HAoJOLRVaK8vNhkMROlFjYg==
X-ME-Sender: <xms:o8l7Y-M1JgDiLtw2iWQQ8aTl18GI99BCynz_OfGUBjPMkG2pCjTiQw>
    <xme:o8l7Y8__6DPxrr_7QOO63EVEGmFKfI3IHQ4PcKOWucd4Tk6x98aE0tqf8m5d4GVjp
    KxxXG_V9HVy1WnNloY>
X-ME-Received: <xmr:o8l7Y1Q9PbztpqZiHcYfEZFhFpLlBBaoL4vkdp5DoN1S5_fBFtL0fchbqeYsKQSWSBU8IFFgO9osiYVy0g_XV-J6_M5LihkA2tG2xYGNbw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrheeigdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfhgfhffvvefuffgjkfggtgesthdtredttdertdenucfhrhhomhepufhtvghf
    rghnucftohgvshgthhcuoehshhhrseguvghvkhgvrhhnvghlrdhioheqnecuggftrfgrth
    htvghrnhepveelgffghfehudeitdehjeevhedthfetvdfhledutedvgeeikeeggefgudeg
    uedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsh
    hhrhesuggvvhhkvghrnhgvlhdrihho
X-ME-Proxy: <xmx:o8l7Y-sAgNEm8BMcaY-n623AT0QOBY5QA_9ojRUe_t1Ji72vbfb8pQ>
    <xmx:o8l7Y2dKOxNyknBSm36TNx-LxfauDExUKjxHobRCW68qv9OCOhUUrw>
    <xmx:o8l7Yy3U8d6FfjFAN9iitg9h5b5gMhoh2L0JF79oPgBpMVaf8LLf4A>
    <xmx:o8l7Y15s72sxIhLUkxuKdRip5e8RZiQrHlUh5yWxwtqQMmxe-18I5I1qQg8>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Nov 2022 13:55:30 -0500 (EST)
References: <20221121172953.4030697-1-shr@devkernel.io>
 <20221121172953.4030697-3-shr@devkernel.io>
 <33473b5b-5d56-a6cd-b95e-726d778502c9@kernel.dk>
User-agent: mu4e 1.6.11; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     kernel-team@fb.com, olivier@trillion01.com, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, kuba@kernel.org
Subject: Re: [RFC PATCH v4 2/3] io_uring: add api to set / get napi
 configuration.
Date:   Mon, 21 Nov 2022 10:55:06 -0800
In-reply-to: <33473b5b-5d56-a6cd-b95e-726d778502c9@kernel.dk>
Message-ID: <qvqw5yf85e91.fsf@dev0134.prn3.facebook.com>
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


Jens Axboe <axboe@kernel.dk> writes:

> On 11/21/22 10:29?AM, Stefan Roesch wrote:
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 4f432694cbed..cf0e7cc8ad2e 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -4122,6 +4122,48 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
>>  	return ret;
>>  }
>>
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
>> +#else
>> +	return -EINVAL;
>> +#endif
>> +}
>
> This should return -EINVAL if any of the padding or reserved fields are
> non-zero. If you don't do that, then it's not expendable in the future.

The next version will have that change.
