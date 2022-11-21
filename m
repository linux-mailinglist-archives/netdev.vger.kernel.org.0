Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD058632C90
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbiKUTCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbiKUTCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:02:46 -0500
Received: from wnew1-smtp.messagingengine.com (wnew1-smtp.messagingengine.com [64.147.123.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED930655A;
        Mon, 21 Nov 2022 11:02:42 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 8372D2B066F8;
        Mon, 21 Nov 2022 14:02:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 21 Nov 2022 14:02:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1669057358; x=1669060958; bh=XifaYgP4cg
        6klUWe6s0Y+A6Kru7YxNsJCO7wsdxTXL8=; b=Ts93nwe0nyFN00UuaoW8YELbHm
        MKNad5fSyaFoKWcseZkz/rZQnypRJJeg69Tq2BFQYsVGe+/s97gt+oH/GkAeJJP1
        rtG/S8tYAih2+RPGOqrZqO0+8SVxYxrMOysFbolTdqzxRPnjplXzHnSKRtkdQ7PU
        84gPpTObd/UYdOoFFT8bL2hv3emsx+tp0DjTgM6cgoSdzrQa3SH56WDlcAFA/6UY
        yUjqnn5oWTLCxrUIa9hghOIgQOZJNxyqTnnqOdn89nz1246mEpVzMtrv4/WKdYDy
        Z1CaCaUEzcpgnEegvG9jxCcyVdbSMMiYqWreoQa8rcyVza0DUvUrKuze6N3Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1669057358; x=1669060958; bh=XifaYgP4cg6klUWe6s0Y+A6Kru7Y
        xNsJCO7wsdxTXL8=; b=huBGJuiDLdOG9euwoA6OaMob3pzS6IcaJ30l0Qz5iAqu
        e4kJplLagE+kuc/EoOomqgSqE8Aaye3JslxsPhBwdoKnXR8Ay9cWUm1GwYxCBE4G
        kd70Ogi/kOWgHO8QpNJ+Ib2aZXnlsyTG8H6s9n3hvr6yEf1/J3NSUzFbBYBgGyr8
        tfvu00ghgFtjd5C9O7rZwzCyOBTHcjP3R9c1Ru99IGMBszhVNo81TshYlia98GGp
        N+pFGMIA8R2jgnl30hrf5REEmyGZGU+zbF8tRqESuM5fsASrUu5Tqry1hYGl5Rgw
        wj42RqdObOK2Mc9yRuz3roU0+x81VBhj8+MXSM5Fag==
X-ME-Sender: <xms:Tct7YwkfzvGVvhGpMjy7aO4T3go6EtBLQujWhD32LXgYLGIyN8C82g>
    <xme:Tct7Y_1o59Zpr9FsJwv6kVW0opaD5N5I2bp92scUj7BADMwi7p8u9PHZqLwSrd0Ti
    -ZtKpPJ-qzQABfLrEc>
X-ME-Received: <xmr:Tct7Y-pZd49KRTpOElFjOkB78K1kQGWfidRQbdHaIEFzBmF2xN9zk4LaQgSGS6pbwjOhRJAaGoz5QRsIRNYw3ZmjhrhRrj6YOpvqhvc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrheeigdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfhgfhffvvefuffgjkfggtgesthdtredttdertdenucfhrhhomhepufhtvghf
    rghnucftohgvshgthhcuoehshhhrseguvghvkhgvrhhnvghlrdhioheqnecuggftrfgrth
    htvghrnhepveelgffghfehudeitdehjeevhedthfetvdfhledutedvgeeikeeggefgudeg
    uedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsh
    hhrhesuggvvhhkvghrnhgvlhdrihho
X-ME-Proxy: <xmx:Tct7Y8nwNGUsx1SGyAC0uPr-Q3NwlOXV-ChOJVCpCy3KrOeOqzlSLw>
    <xmx:Tct7Y-3fbisSIFocSoZiFWu5WkVBh-H1COZWYK_4OxaEP-79uTMsjQ>
    <xmx:Tct7YzvixpDR9t4fP1E4oK9JE0TJrFkMEYDFDATfFty10zXXFNdfwQ>
    <xmx:Tst7Y6_XVABnRbt_cI0sbf8jXyMv4qQAMTxo-hCAt0w1GC8yRAkX6GlWcjI>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Nov 2022 14:02:37 -0500 (EST)
References: <20221119041149.152899-1-shr@devkernel.io>
 <20221119041149.152899-4-shr@devkernel.io>
 <b1ad8fb5-fe95-f344-f691-dae6c5114810@gnuweeb.org>
User-agent: mu4e 1.6.11; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [RFC PATCH v4 3/4] liburing: add example programs for napi busy
 poll
Date:   Mon, 21 Nov 2022 11:02:25 -0800
In-reply-to: <b1ad8fb5-fe95-f344-f691-dae6c5114810@gnuweeb.org>
Message-ID: <qvqwk03o3zcj.fsf@dev0134.prn3.facebook.com>
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

> On 11/19/22 11:11 AM, Stefan Roesch wrote:
>> +void recordRTT(struct ctx *ctx)
>> +{
>> +    struct timespec startTs = ctx->ts;
>> +
>> +    // Send next ping.
>> +    sendPing(ctx);
>> +
>> +    // Store round-trip time.
>> +    ctx->rtt[ctx->rtt_index] = diffTimespec(&ctx->ts, &startTs);
>> +    ctx->rtt_index++;
>> +}
>
> Use tabs for indentation, not spaces.

Fixed in next version.
