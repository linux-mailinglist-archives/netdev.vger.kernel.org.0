Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7231361FC64
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 18:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbiKGR6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 12:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbiKGR62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 12:58:28 -0500
Received: from wnew4-smtp.messagingengine.com (wnew4-smtp.messagingengine.com [64.147.123.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBD924BC1;
        Mon,  7 Nov 2022 09:55:39 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id 748B02B06720;
        Mon,  7 Nov 2022 12:55:36 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 07 Nov 2022 12:55:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1667843736; x=1667847336; bh=t6apQupa5E
        xKvVKMnSCvI2cCQitFW+bB9izCYo5tbVw=; b=I8h0fN/gwwqU6lMYJj3bsLxl3p
        l6iORqWSoUrIGOKqpSDP9q9nDISCp8Rt6XmzXYRhbUC3CLbqvPWakXi+cngNrAsh
        e1vNnvBLpP4j2HKOrAJdAvX1rdNYGqSQC3hUl3DINJ1E84OjpgXCX6cppyeH/VTI
        xTa+3wybk49fM+hEnd6+4JW4QmEtAz4glviIox7GOX7iuBNxjrExRy+B3g4xHDq+
        PMfzyrSToHeMMSwwDzGvAruwR05TUxBq8v4Bxr2VEd25+3+ewOsXA+uq/Os9LR1S
        hmxQ6r9P+Uu0T5PoixQ6DGil+0Ud5xrVzacsDY7o/8txJYlvQDm/1j4Y6qUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1667843736; x=1667847336; bh=t6apQupa5ExKvVKMnSCvI2cCQitF
        W+bB9izCYo5tbVw=; b=hDZHFXgt/ovNv0xiFt7SSNrETEcaoMnbKQoIDMO0+cQr
        4hu3WElp9gCo9OxUxhgieZ3MgeUQiDSM9UpFMqqHEDvRpKQw/FPZ3cjILHsOAXB7
        QVZIWzyVNMbTODf701kDyrFnSZ5L/iCEVg3/gucDvgdVJeP7inNoe3epUM5rX1Km
        hYRuMKEVxN35i/2CrJGRB5RqGc2GM4MmESiJdmxPZT15PonWW64vnOeRRPgDib9a
        VEPA5ZsdOxGCOtyOdsYXoMKp8ZcIJ5C2xzYrKtrtr+OovOtY/rVQUnnLHQDL74aZ
        8koBMyY68thCqsLYK49mCeNLJIedz12Hg96OYWrRnA==
X-ME-Sender: <xms:l0ZpY3UmTf8OrWog6cHzmjRXWKZkadu_t9nOP0uAhBOeCQxDNf1wIQ>
    <xme:l0ZpY_mZODY6QTs9sWupgwvHH7h6mvrJXHSL9V4TVz1xYT1h74I_TqeceDuusn5Ux
    iqbnU1BbApiJTgPQR4>
X-ME-Received: <xmr:l0ZpYzadW8eAlps5Bwbyobq2rUjmMpZx_B-ID7shjIiCXmlHC1GKMvDgRVFQvPwRfeE6IqNdL82QXe5ZMutaYwlFzkFlhzRCiippdhWT>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvdekgddutdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfhgfhffvvefuffgjkfggtgesthdtredttdertdenucfhrhhomhepufhtvghf
    rghnucftohgvshgthhcuoehshhhrseguvghvkhgvrhhnvghlrdhioheqnecuggftrfgrth
    htvghrnhepveelgffghfehudeitdehjeevhedthfetvdfhledutedvgeeikeeggefgudeg
    uedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsh
    hhrhesuggvvhhkvghrnhgvlhdrihho
X-ME-Proxy: <xmx:l0ZpYyXg6zeztZA9ghKYBDpD3d8wCHcglDzMN9BxMFIpj7HYwRFf9w>
    <xmx:l0ZpYxlyL6-hwetHgfAboGSDX6cqOhAPcahAS9ywj010J2Nov84B2Q>
    <xmx:l0ZpY_emqJU-EWzy2eKngh7X8WNbKlPI1EzzAF5wyuZtdGQKWZ66xA>
    <xmx:l0ZpY0to83OZA-vw3S3PyTYnXEjmi914ezW49_OktLIwE84L0RrLsABg-7E>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Nov 2022 12:55:34 -0500 (EST)
References: <20221103204017.670757-1-shr@devkernel.io>
 <20221103204017.670757-2-shr@devkernel.io>
 <478e464b-0dbf-82fb-ce86-8a796019584b@gnuweeb.org>
User-agent: mu4e 1.6.11; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: Re: [RFC PATCH v1 1/3] liburing: add api to set napi busy poll timeout
Date:   Mon, 07 Nov 2022 09:54:48 -0800
In-reply-to: <478e464b-0dbf-82fb-ce86-8a796019584b@gnuweeb.org>
Message-ID: <qvqwzgd2abu8.fsf@dev0134.prn3.facebook.com>
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

> On 11/4/22 3:40 AM, Stefan Roesch wrote:
>> This adds the two functions to register and unregister the napi busy
>> poll timeout:
>> - io_uring_register_busy_poll_timeout
>> - io_uring_unregister_busy_poll_timeout
>> Signed-off-by: Stefan Roesch <shr@devkernel.io>
>> ---
>>   src/include/liburing.h          |  3 +++
>>   src/include/liburing/io_uring.h |  4 ++++
>>   src/register.c                  | 12 ++++++++++++
>>   3 files changed, 19 insertions(+)
>> diff --git a/src/include/liburing.h b/src/include/liburing.h
>> index 12a703f..ef2510e 100644
>> --- a/src/include/liburing.h
>> +++ b/src/include/liburing.h
>> @@ -235,6 +235,9 @@ int io_uring_register_sync_cancel(struct io_uring *ring,
>>   int io_uring_register_file_alloc_range(struct io_uring *ring,
>>   					unsigned off, unsigned len);
>>   +int io_uring_register_busy_poll_timeout(struct io_uring *ring, unsigned int
>> to);
>> +int io_uring_unregister_busy_poll_timeout(struct io_uring *ring);
>> +
>
> If you export a non inline function, you should also update the liburing.map
> file.

In version 2 of the patch, the file liburing.map is updated.
