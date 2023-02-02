Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EADD6688714
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbjBBSt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbjBBSt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:49:57 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C5AA268;
        Thu,  2 Feb 2023 10:49:48 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 381D7320034E;
        Thu,  2 Feb 2023 13:49:47 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 02 Feb 2023 13:49:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1675363786; x=1675450186; bh=vqguxRoXoA
        nM6smxJouV6abnqT8bbYKfck3FXy3iHCI=; b=hNPiEDFaRQuW0r1mvE4vzI3M+q
        Y5yldnsSSUkSQSsfA3Es6QeW6mVSXirLwClUtJpRfZhrCQgy6BTYGlX9EOHHDcUe
        uzjksdtlNrMhCOP/jKVsdoIcSgnaiPn3P3Qb2rV1NZhwIC/orZ52ilysbzXqBz77
        xMhV9st1Q2xPSLjxzu5E3GgK/XQwpHr/FQmOePgMBSd6NNqSwpw6nGOEWXbkq6rz
        1nbfY9X1ZptkjfO1MwDB+4Hhd972rQXJx8AQJU5W8YfoU7PMrAKx4e6gc8lqDf0b
        fnEkz71dKZnjrdbXQaXEAYHph1JXyi6ctz61hUrOCGMKcGhcqASFOwpuAriA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1675363786; x=1675450186; bh=vqguxRoXoAnM6smxJouV6abnqT8b
        bYKfck3FXy3iHCI=; b=jMrz1pKPhbCuC8xtd0oT9M6hnpjyFpvggOtIxVMhprNs
        EN3k9Y2MIoK/dHixIDRoumNNJ1pqLuTc706F1NitcSAo6njWMdrxChFfTgHDyDkS
        90IUSg20mtsRNvKEZyp/RJ9dtF3nbP/njLyum1RTL3Y9BHuyipT7zq5G5GREtmcB
        MbayBRNgxLcX1heL8irTjpRvzQEqReNc62ol9i8xDNZ5PSkznuoIBFpN3z+YfVBu
        DPZcHqEsrx0YGEs37aus1As+ecUYxBqm6XrQ3jT71hvMIpqDMpYJvHDjb799+qd0
        o8aHHj/1QnINPP2h96N1q+NGL10JUF5JAPPGXH5FqQ==
X-ME-Sender: <xms:ygXcY4E-OHQDyjb6jUxb3xiyrO8-CHM04cvHjjafG40l04P6vE7E-g>
    <xme:ygXcYxWf_MjEfIe_RGIh5_nLOIO_-qr03Z_F6o2GjL8BwnQXsUeIv1WfK9l9RPIbC
    g9fwylisxbkfBXtjVY>
X-ME-Received: <xmr:ygXcYyLyOF99q8br85WHzg9mTboLwU5pboxdvNCm-NhNwVETU0ksutD6tIYHoXtWyr3L3M2CD5dNwxoglC7lYR9bPMf3TrV-yx8nybLc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudefkedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpehffgfhvfevufffjgfkgggtsehttdertddtredtnecuhfhrohhmpefuthgv
    fhgrnhcutfhovghstghhuceoshhhrhesuggvvhhkvghrnhgvlhdrihhoqeenucggtffrrg
    htthgvrhhnpeevlefggffhheduiedtheejveehtdfhtedvhfeludetvdegieekgeeggfdu
    geeutdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hshhhrseguvghvkhgvrhhnvghlrdhioh
X-ME-Proxy: <xmx:ygXcY6EQBa1uqF71tGUVzDfGcWHnpHTjyhC8CTEH2uvKbO2fqMTc-Q>
    <xmx:ygXcY-V-yGbqYAIM-CHnHUs1jMUC71genuqXusNuAf4ta1IynJsduQ>
    <xmx:ygXcY9NhYvdtNyhjvPqkat0bNJCMCuayLq8_-4RmjOKGSesIh0CLdQ>
    <xmx:ygXcYwdwShA0zgUoyxb48kI5Zfn4zECNwxDfaA8XCY2O1NuZd2cdkQ>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 2 Feb 2023 13:49:45 -0500 (EST)
References: <20230201222254.744422-1-shr@devkernel.io>
 <20230201222254.744422-3-shr@devkernel.io>
 <Y9ryjXdUg2ii8P71@biznet-home.integral.gnuweeb.org>
User-agent: mu4e 1.6.11; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v6 2/3] io_uring: add api to set / get napi configuration.
Date:   Thu, 02 Feb 2023 10:47:17 -0800
In-reply-to: <Y9ryjXdUg2ii8P71@biznet-home.integral.gnuweeb.org>
Message-ID: <qvqwzg9vq4vr.fsf@dev0134.prn3.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Ammar Faizi <ammarfaizi2@gnuweeb.org> writes:

> On Wed, Feb 01, 2023 at 02:22:53PM -0800, Stefan Roesch wrote:
>> +static int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
>> +{
>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +	const struct io_uring_napi curr = {
>> +		.busy_poll_to = ctx->napi_busy_poll_to,
>> +	};
>> +
>> +	if (arg) {
>> +		if (copy_to_user(arg, &curr, sizeof(curr)))
>> +			return -EFAULT;
>> +	}
>> +
>> +	WRITE_ONCE(ctx->napi_busy_poll_to, 0);
>> +	return 0;
>> +#else
>> +	return -EINVAL;
>> +#endif
>> +}
>
> Just to follow the common pattern when a feature is not enabled the
> return value is -EOPNOTSUPP instead of -EINVAL. What do you think?
>

Sounds good, I'll return -EOPNOTSUPP when CONFIG_NET_RX_BUSY_POLL is not
enabled. I'll make the change for the register and the unregister
function.

>> +	case IORING_UNREGISTER_NAPI:
>> +		ret = -EINVAL;
>> +		if (!arg)
>> +			break;
>> +		ret = io_unregister_napi(ctx, arg);
>> +		break;
>
> This needs to be corrected. If the @arg var is NULL, you return -EINVAL.
> So io_unregister_napi() will always have @arg != NULL. This @arg check
> should go, allow the user to pass a NULL pointer to it.
>
> Our previous agreement on this API is to allow the user to pass a NULL
> pointer in case the user doesn't care about the old value.
>
> Also, having a liburing test case that verifies this behavior would be
> excellent.
>

I'll remove the check for the arg parameter. In addition I will output
the busy poll timeout and the prefer busy poll setting in the client
example program if one of the settings has been enabled.
