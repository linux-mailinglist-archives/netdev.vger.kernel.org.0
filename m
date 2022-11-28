Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD24E63B2EE
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbiK1UXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233180AbiK1UXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:23:00 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FE01181F;
        Mon, 28 Nov 2022 12:22:56 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 896095C0121;
        Mon, 28 Nov 2022 15:22:53 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 28 Nov 2022 15:22:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1669666973; x=1669753373; bh=5odtQpxcpL
        RpIAgNgVmpr3RoZXhTyrR8tVbx14N+8PU=; b=r6+ws4x/8zq2djKuDUXM5q4so1
        aEFNQZ/nzaswcg0swUyZT6DRqMYW5weYZ0lvAB+ydTXXlkJncGbZpO9gBgw4Ixx5
        UxGxaOEOtH8amu0ml8oVihpibVdzDNFgF6yQE49co7h07GcoC9gkK1E1js5jGHyl
        MPwiIS/OCAsC8DXjZnek6KzM7/WSe3ghUmgAwgW3qiaiUi2RcCRbbgWkjel5LJZj
        MmYCWEyeLQSQpSM++xK/Taw3CPsmZtCEUs8KQep64EkRrQAa+v//V8a2e567VOrm
        RgQFS3XB5L5m9MfVzuGADJyCUIxyEXrInX96k/JIZE2tDbBVfUZMj8hBu0Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1669666973; x=1669753373; bh=5odtQpxcpLRpIAgNgVmpr3RoZXhT
        yrR8tVbx14N+8PU=; b=qcykueiSHiIG8n+OWglwiHoTk2YV1fOCMiO45vI1j49g
        G4zCnIwDWdhTQK4tfFhUyB8ulTlILDL+ISTJFRQpjgtMVSUpx56DCL25BxjsQDvs
        4zkTYc/tuC0p3lB9cPSph+NgYL2JX6jH0rBq6aP1d8bOjoMsNDGGEH7ekM9BApEp
        b3WB+iwyyMMov4QeCIVOw9yt/Jz56ob9mdhuQtqVDxsENhxJgsYA9IASW5Pqewyt
        9YIcN1UzlAwe/ys534hH9Gg5HxenL4bLJ6GsaylscotnhsbsPZFms24aHX2f2vU2
        Re+gWot1wj/DSPsFpXBFSMb5VG+G4ujpHpb9cuX25g==
X-ME-Sender: <xms:nRiFY02kIez_ftXexQpZHsuIWQx-UEJn28q7_c-G65RdbheCmHKaiQ>
    <xme:nRiFY_E-4kjO4BOoeZDcy-2x2HMTodG5OS2O-OlL5H7CTdkBM2HpAuRkK0_M4hSwM
    -ZFHQA1Kekuu-khCmM>
X-ME-Received: <xmr:nRiFY86qbUg3iwR39QiO6KvjqyzMhJx_jt9NbugpzJUxENH8GOa_orVXdD5JYgjciOat-ygqK2W9E1NoN1BSy-KTPRxPnW1j_b6vP39H>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrjedvgddufeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfhgfhffvvefuffgjkfggtgesthdtredttdertdenucfhrhhomhepufhtvghf
    rghnucftohgvshgthhcuoehshhhrseguvghvkhgvrhhnvghlrdhioheqnecuggftrfgrth
    htvghrnhepveelgffghfehudeitdehjeevhedthfetvdfhledutedvgeeikeeggefgudeg
    uedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsh
    hhrhesuggvvhhkvghrnhgvlhdrihho
X-ME-Proxy: <xmx:nRiFY9058ry0cZ9zJWp9wrYht6KSc4FtZXlCJSirk9Qx23Kqv7qAsw>
    <xmx:nRiFY3H1Hk3_P5Z8xKuyfoI-AjNPKS8U71BdN5lIBgCblHfvfuFBBA>
    <xmx:nRiFY2-jxGn6ccpn7G3t1AuEvnK9sfNALbSevDKI8pkzeA2M6g-P5A>
    <xmx:nRiFY4MUUPM9imqXUIY5v_UEqF-KgNCw1-jImNe_ENdyVfhcSVyrAw>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Nov 2022 15:22:52 -0500 (EST)
References: <20221121191437.996297-1-shr@devkernel.io>
 <20221121191437.996297-3-shr@devkernel.io>
 <6ab47920-7e13-cd67-76c8-2d4ca8a31fd5@gnuweeb.org>
User-agent: mu4e 1.6.11; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: Re: [PATCH v5 2/3] io_uring: add api to set / get napi configuration.
Date:   Mon, 28 Nov 2022 12:22:19 -0800
In-reply-to: <6ab47920-7e13-cd67-76c8-2d4ca8a31fd5@gnuweeb.org>
Message-ID: <qvqwedtmzv55.fsf@dev0134.prn3.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,URIBL_BLACK
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Ammar Faizi <ammarfaizi2@gnuweeb.org> writes:

> On 11/22/22 2:14 AM, Stefan Roesch wrote:
>> +static int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
>> +{
>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +	const struct io_uring_napi curr = {
>> +		.busy_poll_to = ctx->napi_busy_poll_to,
>> +	};
>> +
>> +	if (copy_to_user(arg, &curr, sizeof(curr)))
>> +		return -EFAULT;
>> +
>> +	WRITE_ONCE(ctx->napi_busy_poll_to, 0);
>> +	return 0;
>> +#else
>> +	return -EINVAL;
>> +#endif
>> +}
>> +
> I suggest allowing users to pass a NULL as the arg in case they
> don't want to care about the old values.
>
> Something like:
>
>    io_uring_unregister_napi(ring, NULL);
>
> What do you think?

Sounds good, i can make that change in the next version.
