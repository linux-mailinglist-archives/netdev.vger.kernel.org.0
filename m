Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFF2632C99
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiKUTFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiKUTFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:05:17 -0500
Received: from wnew1-smtp.messagingengine.com (wnew1-smtp.messagingengine.com [64.147.123.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224DE63164;
        Mon, 21 Nov 2022 11:05:17 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 325042B06861;
        Mon, 21 Nov 2022 14:05:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 21 Nov 2022 14:05:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1669057515; x=1669061115; bh=MDmNofgTyd
        /8UJfQtKp6/eKZa3jaDLLUvSfgZm02MsI=; b=U4ipgXYUivaC94aBfx6XqnWmWA
        z1DEstIN2TL3iTMRVb1PJbOBNfeqnWh7OFP5MRRwdvfDfk0FYiJ25i+JHVPnCEOS
        KD+he402psUwBnwD1PwwjyFrsMNYIrWoA9hL+WqN/7+HisOefgOL52AijzLwIuJw
        Eto2fsuee1hmP1n45UVnrhZ95bSHNHdJlHODAzBuxZt7PYReJsPwlHOjZABV07Cq
        CJrDO/6VB0clCFUa1Hex2Mq1x3uHuw2YewAxEWXppnA6Fy5e5kWgtdRmxKbCjhkB
        p8BQITIilJxj8b3WPqjwEoaalQV/YqQldI66wIzKetySxjKO0UZHz6/bnbOg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1669057515; x=1669061115; bh=MDmNofgTyd/8UJfQtKp6/eKZa3ja
        DLLUvSfgZm02MsI=; b=wlGV0HVpqhyc54HAb14+iQ//Ar4ooFcIpbKVLqGI3aQz
        Hij6tusG9eza/IcNmMRjV0qC8iDnoBOiQgbEd/rFU0aBHdQCzHeALJrNHMO2kvHb
        UBqRr4B7dCTN3+PmQGFrdOoYPIkURjch2zZNqOVs5bE0KXzOroG3P3U0u9wEieT4
        UkvhFLwBSZR0nEsBPjHEyotbqR0OcfzwQzlw4ATBPltHRUhy3MimjMChGlZZWOwE
        4129tGOrVyiZ2LBf2f493dS5BOLK3iHG3qcoSbnz3TcgAJxcnYHPno7Obcabj6JJ
        3HmeGSck0JRA2Kd2hIJpCXTaLrOjLTGIg7NFtCb0oQ==
X-ME-Sender: <xms:68t7Y8H7sOVM9xQ72rpcjeSoeFvxZFab5r3NzHO6kiXmWr7sWgX8rQ>
    <xme:68t7Y1WzbIqUwbvBA8k3cNY4AUijbkMdsVb5iPumJK2NL9YqmZuQWrixZ6tC7XUf_
    IjtiQFnEaygZQQThjg>
X-ME-Received: <xmr:68t7Y2IRI5lWrNIf4vHfWGCJBI412H1G04EUxhIxAPreK8XgVDB_yMx6JTZmD5CNVSZ9gG99T35H-FMLCB3M5yHaUX6Tkmau6oIcjlT_>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrheeigdduvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfhgfhffvvefuffgjkfggtgesthdtredttdertdenucfhrhhomhepufhtvghf
    rghnucftohgvshgthhcuoehshhhrseguvghvkhgvrhhnvghlrdhioheqnecuggftrfgrth
    htvghrnhepveelgffghfehudeitdehjeevhedthfetvdfhledutedvgeeikeeggefgudeg
    uedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsh
    hhrhesuggvvhhkvghrnhgvlhdrihho
X-ME-Proxy: <xmx:68t7Y-Hex_w2PjWzu7reUVSe7uPIXrSu7hfVYKa7BRo9_Bf4jHdV5w>
    <xmx:68t7YyXQBwXHmh6kWuf5p26xYs9tVKqDD7okplJmoAyIPRhMaz4nmA>
    <xmx:68t7YxN6V6KMaiHSfEYM3tp47Xxe4r2GUtuD8uTvhHO4_HICYyg6fg>
    <xmx:68t7Y0fqJ7qpL0DK6rPhDLccGdTENJT5ZOSsT2iOfCQuFOcTskW3yXJ6es8>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Nov 2022 14:05:14 -0500 (EST)
References: <20221119041149.152899-1-shr@devkernel.io>
 <20221119041149.152899-3-shr@devkernel.io>
 <24e5c8a3-faba-2e1a-eb9f-69bcbc2b28cd@gnuweeb.org>
User-agent: mu4e 1.6.11; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [RFC PATCH v4 2/4] liburing: add documentation for new napi
 busy polling
Date:   Mon, 21 Nov 2022 11:04:59 -0800
In-reply-to: <24e5c8a3-faba-2e1a-eb9f-69bcbc2b28cd@gnuweeb.org>
Message-ID: <qvqwfsec3z85.fsf@dev0134.prn3.facebook.com>
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
>> This adds two man pages for the two new functions:
>> - io_uring_register_nap
>
> Typo:
>
>    s/io_uring_register_nap/io_uring_register_napi/
>
>> +.SH RETURN VALUE
>> +On success
>> +.BR io_uring_register_napi_prefer_busy_poll (3)
>> +return 0. On failure they return
>> +.BR -errno .
>> +It also updates the napi structure with the current values.
>
> io_uring_register_napi_prefer_busy_poll() no longer exists in this version.
>
>> +.SH RETURN VALUE
>> +On success
>> +.BR io_uring_unregister_napi_busy_poll_timeout (3)
>> +return 0. On failure they return
>> +.BR -errno .
>> +It also updates the napi structure with the current values.
>
> io_uring_unregister_napi_busy_poll_timeout() no longer exists in this version.

Fixed in the next version.
