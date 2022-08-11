Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD92F590857
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 23:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbiHKVu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 17:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233840AbiHKVu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 17:50:28 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7273CC43;
        Thu, 11 Aug 2022 14:50:25 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id DAE5532009E6;
        Thu, 11 Aug 2022 17:50:21 -0400 (EDT)
Received: from imap42 ([10.202.2.92])
  by compute2.internal (MEProxy); Thu, 11 Aug 2022 17:50:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1660254621; x=1660341021; bh=I/keUvi7Am
        GbWU/V5AvwZOlORkyxExBC2HWeHMx4odc=; b=R8wmLyt7ZCB91Dl7x+r1r2/P31
        cB13juyNvSpj8A9w2WPneEKRmphKUnf0QLZGEXpUvmpGI3980wVvkmQhdaM/OZLj
        g+qGo71BdyTmWx60t1aaNs++33VehETc6REzXdId8mBVX+32xy6zhPDLCqU7pUVt
        kqSuuI7tE44FvUDD8n64rEoMEyRAmN7h6n2Z1V19TCwKH0Gt9Wxy5mxiDCqT3Zx4
        iKkKMeMKmk/EdRAyuFJVNVBcIBTgpQVJ8nw0N3p01ued5LZXgOO8opWl4ldu+hYD
        ZMBVzTeEX8fe8aEeN5P8+HlHzFSEM9bpB16y6b4VdGT26+GyU0YIVI5relPg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1660254621; x=1660341021; bh=I/keUvi7AmGbWU/V5AvwZOlORkyx
        ExBC2HWeHMx4odc=; b=aDzqGYg1F8m6Rk1xKA3+QhqrUA5mPG1BNqMs42ILWEAe
        XBnQeOwQA5foLTg2tRu/KjJBSGYTAOCkjDf29Q4rg5vmn1upTGRP2pyY2m1XuQqe
        UhhQIphisRJaPV0bShX4FrDvG42YLrM57XTN0MXUxm1QRQ1s0UaE86wcjwH7eVqG
        60PPAnxzpepBOYyD5hsWamCSxs5XvYIgScPRmgB7E0Q7KVKQkOwyaNLGbnOuY4GT
        fOg6t8mN4QnwsCZbFYY4KWm7LGofR4ng2o82If0wO09bGXfePTRY2qSqtjEIWtoi
        Q0inyOvpc7f7Bqi9Suy3lN2Sq34nFZl5EddNO+oO0Q==
X-ME-Sender: <xms:nHn1YgbCjjF2uJMtNuy-fFIi78-yHR5zb9yaK1HxZgrkF-96YuYRVQ>
    <xme:nHn1YrYcmLWO1786HIIOt26XR7qxppFqMDSjawuc-C9DpuL2xG4zXTFILpot679oJ
    DYQq9RCqdjcLMQYeg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeghedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdlfeehmdenucfjughrpefofgggkfgjfhffhffvvefutgesthdtredt
    reertdenucfhrhhomhepfdffrghnihgvlhcuighufdcuoegugihusegugihuuhhurdighi
    iiqeenucggtffrrghtthgvrhhnpedtudehudfhveduieeikeejudeljeffuddtieffieel
    jedtudehhfekheehuedvkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:nHn1Yq8VuD7zqNaXnNb2onxytvCRniO4PaAqu5RpNZQKyqeZdfJ7Ow>
    <xmx:nHn1YqrhExwBfeDXeK_mVcD3PEQ5fUe7_4h6c86IVUTrzF-GasZK-g>
    <xmx:nHn1YrqVMYJGcxKI6as3Hk5cM0QHQOdXxodLvsvFgrIxgGKS-HSH_g>
    <xmx:nXn1YvfH4wdiAeGgXhPiQIYbixE7QCmLWQQjb0xEJIbzJIZJCvv7Ww>
Feedback-ID: i6a694271:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 73EC5BC0075; Thu, 11 Aug 2022 17:50:20 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-811-gb808317eab-fm-20220801.001-gb808317e
Mime-Version: 1.0
Message-Id: <8bd57a25-4034-4fa8-a22d-66298cb1a667@www.fastmail.com>
In-Reply-To: <CAP01T74aWUW-iyPCV_VfASO6YqfAZmnkYQMN2B4L8ngMMgnAcw@mail.gmail.com>
References: <cover.1660173222.git.dxu@dxuuu.xyz>
 <CAP01T74aWUW-iyPCV_VfASO6YqfAZmnkYQMN2B4L8ngMMgnAcw@mail.gmail.com>
Date:   Thu, 11 Aug 2022 15:50:00 -0600
From:   "Daniel Xu" <dxu@dxuuu.xyz>
To:     "Kumar Kartikeya Dwivedi" <memxor@gmail.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
        "toke@redhat.com" <toke@redhat.com>
Subject: Re: [PATCH bpf-next v3 0/3] Add more bpf_*_ct_lookup() selftests
Content-Type: text/plain
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kumar,

On Wed, Aug 10, 2022, at 6:25 PM, Kumar Kartikeya Dwivedi wrote:
> On Thu, 11 Aug 2022 at 01:16, Daniel Xu <dxu@dxuuu.xyz> wrote:
>>
>> This patchset adds more bpf_*_ct_lookup() selftests. The goal is to test
>> interaction with netfilter subsystem as well as reading from `struct
>> nf_conn`. The first is important when migrating legacy systems towards
>> bpf. The latter is important in general to take full advantage of
>> connection tracking.
>>
>
> Thank you for contributing these tests. Feel free to add:
> Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>
> People often look at selftests for usage examples these days, so it's
> great to have coverage + examples for more use cases.

I also want this interaction to still work when I start using it later :).

>
>> I'll follow this patchset up with support for writing to `struct nf_conn`.
>>
>
> Please also cc netfilter-devel, netdev, Pablo, and Florian when you send it.
>

Ack.

> I think we can directly enable stores to ct->mark, since that is what
> ctnetlink is doing too, so adding another helper for this would be
> unnecessary overhead.

Ack.

[...]

Thanks,
Danel
