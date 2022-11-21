Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 550FF632C6D
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 19:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiKUS4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 13:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiKUS4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 13:56:18 -0500
Received: from wnew1-smtp.messagingengine.com (wnew1-smtp.messagingengine.com [64.147.123.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E8059FD1;
        Mon, 21 Nov 2022 10:56:17 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id B691B2B067A3;
        Mon, 21 Nov 2022 13:56:16 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 21 Nov 2022 13:56:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1669056976; x=
        1669060576; bh=YoN05QllSVrQN8AyvV30I2FiL3NjbAn7K1Lnt3fEf4w=; b=H
        KpAzy2SA+H5kJMLyjq27etx3MUWxKKH1X4Rn96z9UI2hMfHdafyw0Ob09XqZZPag
        FJTbD4QB5FzBf/L+s9lpB4s8FvZ4dAliRu8pJ45AQbjZx3KljuVkY33gxuTp9nLN
        49N9IjR+vZYMgLa2uDskUC94YgO1nq3VxjcherB8fb0wpFsl+Ha16nGh5TBaJWd8
        j6lHfmhcGr4LXe36twLP0yh6pWQC7vWhHj4AEFxF/ANLYgTvJXyUj/BhiY/S7uAA
        mwrO0llOqJhqx9W5dcgSuD/wsINUxqNUDzwdXexpNcq6fsuEj/2HHfAWyMMYbpxp
        jujRQUqNRRrOrONqHWbfg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1669056976; x=
        1669060576; bh=YoN05QllSVrQN8AyvV30I2FiL3NjbAn7K1Lnt3fEf4w=; b=c
        igh3x7x6gc4BhLKLk/CR/DBO4T9mvVLqXWe8MKmPOtDeK++6Uo3VdCtAg0FrYh/c
        WfVKOFFvZKUBUUHYp42KJI0MvylpFwqkqBuGK0ICW9uAo/cCg9msrZSoEl6G24Lk
        FGqVOxmYTg+UxY01dUyKITiaauF8NvHL3zPDemnA6QetABW7QTaSade2ua6aTEMX
        TxsmrkwMsL0Gq/fS2xoVN5Xlr0KAMC5Itroa7nIj4++ogJDD3Td6u1pV+1suRGIb
        glBoYdkj67tvzTRwwMo72kYZMoFCSSo1E5VvhsUHTtM+rtbsdCOExDalwWfOF3iN
        hxtt+2B2rPDUNBAp6+mOw==
X-ME-Sender: <xms:0Ml7Yxa9yyUqPF5B-9cg76jk1e2fNGKfw7bXmxvLvTrucP0adgvT_w>
    <xme:0Ml7Y4Zi389lhwLeB5jdVPyFN3fsipHH_mGbA3Hg8v0der_hOwwEaa1guh2NQb6a8
    bO3Zb-gwpyyU-hvH2Y>
X-ME-Received: <xmr:0Ml7Yz-viTPjdzQf0NIArlBf1wpoCSuQaumhzRG6k3HYQ2miuNF0zVF65XqZxc8-h06j1e843BZk5KW_XPLwwDIJW4ZYAF1nXlRGTsw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrheeigdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfhgfhffvvefuffgjkfggtgfgsehtqhertddtreejnecuhfhrohhmpefuthgv
    fhgrnhcutfhovghstghhuceoshhhrhesuggvvhhkvghrnhgvlhdrihhoqeenucggtffrrg
    htthgvrhhnpeehleelhfeiieettddthefhteeiteefteehkedvtedtheefvdejtefhteev
    leffffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hshhhrseguvghvkhgvrhhnvghlrdhioh
X-ME-Proxy: <xmx:0Ml7Y_qjCRqVnTDVS2feAgGYkxZg9zOHkOZ2k0xzhpm0eoT2TpYdfQ>
    <xmx:0Ml7Y8oxKfKZ5OUIPcasAtSMN4PGMDbi-klOBiqyfsZ7fxSt3-gTvQ>
    <xmx:0Ml7Y1RLZLGGVI5fKpEXJMPAEIF13B4h8lfpsGIycBEgb5Cxxv6cNA>
    <xmx:0Ml7Y1kqiLHheze5VTrHFCJaCOyh_4pak97Uorzo_Xv94_KE8FCBj5ACdfc>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Nov 2022 13:56:15 -0500 (EST)
References: <20221121172953.4030697-1-shr@devkernel.io>
 <20221121172953.4030697-3-shr@devkernel.io>
 <529345e2-5e13-0549-0f6b-be8fe091b8ff@kernel.dk>
User-agent: mu4e 1.6.11; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     kernel-team@fb.com, olivier@trillion01.com, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, kuba@kernel.org
Subject: Re: [RFC PATCH v4 2/3] io_uring: add api to set / get napi
 configuration.
Date:   Mon, 21 Nov 2022 10:55:43 -0800
In-reply-to: <529345e2-5e13-0549-0f6b-be8fe091b8ff@kernel.dk>
Message-ID: <qvqw1qpw5e7l.fsf@dev0134.prn3.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLACK autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jens Axboe <axboe@kernel.dk> writes:

> On 11/21/22 10:29=E2=80=AFAM, Stefan Roesch wrote:
>> This adds an api to register the busy poll timeout from liburing. To be
>> able to use this functionality, the corresponding liburing patch is need=
ed.
>>
>> Signed-off-by: Stefan Roesch <shr@devkernel.io>
>> ---
>>  include/linux/io_uring_types.h |  2 +-
>>  include/uapi/linux/io_uring.h  | 11 +++++++
>>  io_uring/io_uring.c            | 54 ++++++++++++++++++++++++++++++++++
>>  3 files changed, 66 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_typ=
es.h
>> index 23993b5d3186..67b861305d97 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -274,8 +274,8 @@ struct io_ring_ctx {
>>  	struct list_head	napi_list;	/* track busy poll napi_id */
>>  	spinlock_t		napi_lock;	/* napi_list lock */
>>
>> -	unsigned int		napi_busy_poll_to; /* napi busy poll default timeout */
>>  	bool			napi_prefer_busy_poll;
>> +	unsigned int		napi_busy_poll_to;
>>  #endif
>
> Why is this being moved? Seems unrelated, and it actually creates another
> hole rather than filling one as it did before.

That was not intended. The next version of the patch will restore the
previous order.
