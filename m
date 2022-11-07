Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81D3E61FC9B
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbiKGSDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233239AbiKGSCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:02:13 -0500
Received: from wnew4-smtp.messagingengine.com (wnew4-smtp.messagingengine.com [64.147.123.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C091B1E9;
        Mon,  7 Nov 2022 09:58:42 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id CF0BF2B0672B;
        Mon,  7 Nov 2022 12:58:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 07 Nov 2022 12:58:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1667843921; x=
        1667847521; bh=l7OdJojauXBVIGRhUsVLbzCK4d+6w8jn8tinc2cl4BY=; b=C
        kzjscNC4ibKvM53lSB6g2TS9liikukb2Q2+zXoEvFJjRSKgWYwj0/5AfYAxWnYsw
        /d3h3wq5fdjh1QszxjnykHuz9tgr2mGtvtbS9HOOcrsj4bnIOqu4l9dmbt5RYxvQ
        vZ+ZxJ0BnmccdkcqK+Ct67fv7FAl8JeOB6tSnQ4euIzpEcNdKYammGjWmGtBqUjC
        GFzbAIl5YfHp6GsiY1duHL453N0hUxLQtoObHO64YcFA9/TdcykRkq+ofbJGubjX
        2YdNoGF9IcGR152nfm/9nLThrN08uk4k6n6ino63kT2YTv7qo2S9Ikbx/C8llFx+
        a6Lg6G3QZxvkHR9IrVtew==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1667843921; x=
        1667847521; bh=l7OdJojauXBVIGRhUsVLbzCK4d+6w8jn8tinc2cl4BY=; b=K
        x6bwR229HuuGJU05QkxtFFUcu87bKV2st4tYK0f2FznFweNzi4H2jzF744A9DVWj
        f2IJDHz4UYKiedGIXLu8iW7h99XLhUCI27Em6NYnXHRy8SEqI6g9NCn1zHQYx8gU
        xx720gVDp1sETHo8QrW6wdK7Ixm2mRJGZ8we4aZuvbld7e8mHgzmqDuAksCwOBnv
        a689EhDVryzstTiYRyBn8nI7fLlgQtDI/M56J2Okz4B3w/JaaIRKxkwuNlltHVdJ
        06JAla7tsKSM43SUwFoJi4cMQ4mOvjnup0Fu7gX4qLSI29sNCpzGP6FdUQoLe7uV
        lulyE7soyYH3UW5Tenerw==
X-ME-Sender: <xms:UUdpY-mKHPSDjh50NBu3JVAPJrmCNYVB1x4bwmIVNAJkBESTsxNsEg>
    <xme:UUdpY12XtvmbCTape1R1zazj_XRnqsMoMUY4lRfUfoZ7-xX8eiNOCZzB9kK1a_HEH
    8Jhka1OxAwFgiAHLys>
X-ME-Received: <xmr:UUdpY8pY2IXGMoNZbqyqGzdSEZ-by3qDClaq27dg0-Kng6gpsEdK5Tqw7N3PZ32KNIfV0W-gFOT1FoLJJUVJD8kcfetT7FdIOg7-Hyfp>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvdekgddutdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfhgfhffvvefuffgjkfggtgfgsehtqhertddtreejnecuhfhrohhmpefuthgv
    fhgrnhcutfhovghstghhuceoshhhrhesuggvvhhkvghrnhgvlhdrihhoqeenucggtffrrg
    htthgvrhhnpeehleelhfeiieettddthefhteeiteefteehkedvtedtheefvdejtefhteev
    leffffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hshhhrseguvghvkhgvrhhnvghlrdhioh
X-ME-Proxy: <xmx:UUdpYym2_qeyMkaAIW4QZ5dxn91W48ca6AlN4_BhDCDYUuEwKr0szQ>
    <xmx:UUdpY80pLBe6o9YM32dV0kM9FZBmlLO1DMIt0dJOiPvEnd0a_K1Xmg>
    <xmx:UUdpY5uWPlt3LNCKincef8DHvc0D1aguGT-Dc3NWlsev1D8Ot4eP-w>
    <xmx:UUdpYw-fUeb4QY6eNDq4tJ9sdcRrEJmXk8rF8_Q2hveiH8c8Om3UubolCrE>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Nov 2022 12:58:40 -0500 (EST)
References: <20221103204017.670757-1-shr@devkernel.io>
 <20221103204017.670757-4-shr@devkernel.io>
 <e62ff9f6-0eea-be82-c357-1081a4d0d100@gnuweeb.org>
User-agent: mu4e 1.6.11; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: Re: [RFC PATCH v1 3/3] liburing: add test programs for napi busy poll
Date:   Mon, 07 Nov 2022 09:58:05 -0800
In-reply-to: <e62ff9f6-0eea-be82-c357-1081a4d0d100@gnuweeb.org>
Message-ID: <qvqwmt92abow.fsf@dev0134.prn3.facebook.com>
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


Ammar Faizi <ammarfaizi2@gnuweeb.org> writes:

> On 11/4/22 3:40 AM, Stefan Roesch wrote:
>> +void *encodeUserData(char type, int fd)
>> +{
>> +	return (void *)((uint32_t)fd | ((__u64)type << 56));
>> +}
> This breaks 32-bit build.
>
>   i686-linux-gnu-gcc -Werror -D_GNU_SOURCE -D__SANE_USERSPACE_TYPES__ -I.=
./src/include/ -include ../config-host.h -g -O3 -Wall -Wextra -Werror -Wno-=
unused-parameter -Wno-sign-compare -Wstringop-overflow=3D0 -Warray-bounds=
=3D0 -DLIBURING_BUILD_TEST -o napi-busy-poll-client.t napi-busy-poll-client=
.c helpers.o -L../src/ -luring -lpthread
>   napi-busy-poll-client.c: In function =E2=80=98encodeUserData=E2=80=99:
>   napi-busy-poll-client.c:119:16: error: cast to pointer from integer of =
different size [-Werror=3Dint-to-pointer-cast]
>     119 |         return (void *)((uint32_t)fd | ((__u64)type << 56));
>         |                ^
>   cc1: all warnings being treated as errors
>

Version 2 of the patch fixes the above problem.
