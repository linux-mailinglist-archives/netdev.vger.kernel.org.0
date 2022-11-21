Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3D8A632C7B
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 19:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiKUS7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 13:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiKUS7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 13:59:03 -0500
Received: from wnew1-smtp.messagingengine.com (wnew1-smtp.messagingengine.com [64.147.123.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A7BCFBB1;
        Mon, 21 Nov 2022 10:59:02 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id C021D2B06846;
        Mon, 21 Nov 2022 13:59:01 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 21 Nov 2022 13:59:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1669057141; x=1669060741; bh=aYKy/dWFpy
        EcPoInA9iPPi4kQ5Fezf2eiVvaR1Q7RH8=; b=rCqLFx5jHrHDVCUf2MGyaBQMWk
        yhiTUubU9lJuAsvRKkXhBZn8Yad6tqx2qo81TSvX/0NPSLH6d9eh3JI/NQaGT7TD
        g21CibRcjdf+e8rcNEfHDYkO1kzkCSSQwfDzQHoGr+3/i98kxLjDhY0TTMc8ZrWK
        cwX1dgaBr3DrJ55+IH5Ky8+9ITneW3FPO2YfK5fZc3j9J1k+jL7NW6R+XO3BoPON
        j9g9dzYOhjT1GlLuY3hig/f9a32dpzSrDEltjU0cYWMe7/Ys4EPHD7/lLMg8QV7b
        r7miNcnh4zUerYcPKHn8+i3/K7XbUSXFomfScO6wWVQoLJpiAoXrk64ZfevA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1669057141; x=1669060741; bh=aYKy/dWFpyEcPoInA9iPPi4kQ5Fe
        zf2eiVvaR1Q7RH8=; b=bJL6sk+Ia6Y8ZUAw+o5TZFar1Q/B+WH/sf8x+6wMPPle
        L7mHgPsqVIUol8jt28AQypcQE0PU6DDLZyRRDTvE0+DbwB4hUp+aB2AkBLFLP4Mn
        iMzb1mbdb1yKO6HSROu91P3Zz6cZwA0QAzqV/X5KM7RaaOtGiSWzSEkrXclUhnpG
        vTOMsyLJJuw9b9jB7tu5fb0qVQsBs3bO+dPoXnQSR5CBMzyM9+u1Eo3BhED93NE9
        cbmKES9m9T0LFZopf5/46odvgz2DYSpA2ahw6OcPSPjtqWg7xXtnP2gqIRSnYiOq
        q4HTGvy8oDJNEY1lybNGSTLq8iQt/6AufQ9iO0T+3Q==
X-ME-Sender: <xms:dcp7Y_M-bZkMAJEYQ6_3goT9bBvRg_s4dNTcwaox6zx4U-pSZefPOg>
    <xme:dcp7Y587DIQhHPAz6kiByo3Qp0IzQM_uk_3kb5R8ZnDZ8ajdLEMmel5xWGuEbbkaD
    6vFU_i9lav3S1ulDLs>
X-ME-Received: <xmr:dcp7Y-SUugaTmws5CgG0AdwXsHZfmZQt1chHTDBUrcKJt1ThV0YM29VVLwYHazk2GAbMyI78kx0UNsFmreH7owGm0gpcQlbI2IS8an_czQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrheeigdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfhgfhffvvefuffgjkfggtgesthdtredttdertdenucfhrhhomhepufhtvghf
    rghnucftohgvshgthhcuoehshhhrseguvghvkhgvrhhnvghlrdhioheqnecuggftrfgrth
    htvghrnhepveelgffghfehudeitdehjeevhedthfetvdfhledutedvgeeikeeggefgudeg
    uedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsh
    hhrhesuggvvhhkvghrnhgvlhdrihho
X-ME-Proxy: <xmx:dcp7YzupSb7r6_y0VHKA8Gz5zL1AhgpaKn50VtxFmUZMVaitJh1d6Q>
    <xmx:dcp7Y3fUD5xjrP4U0KVzeNwtCD4mF6ORiGkw20-f7nrrFUFt0VjRxg>
    <xmx:dcp7Y_38OjzfaQ2KWRFwaGnmszD-swLIpWnFnTGsV_MCdVjOPfd2-w>
    <xmx:dcp7Y4HFGCxktdNot6TF4OZtH2nhrzPmBm6c76tWVwjFgkZi0g4SP0D3Zhc>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Nov 2022 13:59:00 -0500 (EST)
References: <20221119041149.152899-1-shr@devkernel.io>
 <20221119041149.152899-2-shr@devkernel.io>
 <c5ac425d-48e2-0a6d-3f56-c6154d3ac81f@gnuweeb.org>
User-agent: mu4e 1.6.11; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [RFC PATCH v4 1/4] liburing: add api to set napi busy poll
 settings
Date:   Mon, 21 Nov 2022 10:58:45 -0800
In-reply-to: <c5ac425d-48e2-0a6d-3f56-c6154d3ac81f@gnuweeb.org>
Message-ID: <qvqwsfic3zik.fsf@dev0134.prn3.facebook.com>
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
>> +
>> +int io_uring_register_napi(struct io_uring *ring, struct io_uring_napi *napi)
>> +{
>> +	return __sys_io_uring_register(ring->ring_fd,
>> +				IORING_REGISTER_NAPI, napi, 0);
>> +}
>> +
>> +int io_uring_unregister_napi(struct io_uring *ring, struct io_uring_napi *napi)
>> +{
>> +	return __sys_io_uring_register(ring->ring_fd,
>> +				IORING_REGISTER_NAPI, napi, 0);
>> +}
>
> The latter should be IORING_UNREGISTER_NAPI instead of IORING_REGISTER_NAPI?
> Or did I miss something?

Thats correct.
