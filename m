Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B2E61FC77
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbiKGSA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbiKGSAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:00:42 -0500
Received: from wnew4-smtp.messagingengine.com (wnew4-smtp.messagingengine.com [64.147.123.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF2F2B1AE;
        Mon,  7 Nov 2022 09:56:47 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id EC4D62B06711;
        Mon,  7 Nov 2022 12:56:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 07 Nov 2022 12:56:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1667843805; x=1667847405; bh=uJTMFSO7Rn
        dUzMkc5k/d8/k1KIa2sBi8OKRir3Kk4O8=; b=o+O5fqKPUDCZzlLlGo1DlQsmDA
        Zq0idUOre1mputj+3lcmI7SFCFfeXRdF/bCfaWj4nh79nnn5jxF+2xTeY4sBTfet
        5AUue+qxi47qec36Bw+Crl3EqbE82IINUT1uUwuaW/eqMpd5+aTv3AEbl0Ia604o
        y2r2XfdMbvNl1iPBRTUa6Akn7zutNDUg8iN4w3ixvr6EgGeYpr5tSQROS9CoofPb
        mLwxsLESpOTL3dg6cAY49E5bQ1nLsNq5xo61UbRhIJazCYMrvSqL6i2q+HtWyBnB
        CiQf4Gl8DjfAZ2QpmN6YWXeYsRcf86FLGyYAQsFZpoQ4aqSzR8KAVjcqPnXQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1667843805; x=1667847405; bh=uJTMFSO7RndUzMkc5k/d8/k1KIa2
        sBi8OKRir3Kk4O8=; b=gra2ueGJ8Wlt7yQdh9OdSxyaDl5XFI69x2PGuGMiiEWE
        xpQkMClddyPxlgeUgfeI08/pKlYXq/FcxUNM0++MRCJxn3MyS4/2rBT/x+wtHYfj
        7vFHz0gqUlgKrrLiloSbMV7876wClnt5PSXpSJ2d2qqgqgfGHeGeBZ0Up2A1987n
        V5JD8Pa96mD1uWYFwu6cVEUGx4HlLQOfRkuZ4S5quPkVZiqCx+tAb6whoMMSWTJS
        Jqi0ITTeU8QPaDd0tS9At7KUHq8QuSi03hz+Auv9S/Rt1iVkPZSllGjQevBZz8SM
        dWimmE2bCQJUby7DxRJjhf0osO6e2KYepaRBeX5lZQ==
X-ME-Sender: <xms:3UZpY2rx10EXTijjLDxDyhVyUzbnphCKiu2ptNhfKfQ2otDZw-Grug>
    <xme:3UZpY0oihc1ry13yjwtXlOGgLK1hHot4eFdAlnY4hECYtCfgHc47CGLcSx959Q_LC
    hUYMfa3RzeYM_Dz810>
X-ME-Received: <xmr:3UZpY7NtFt4Ad4oluNWxwC7lW45X1a4_-mio-E_tXLWFPzj5DBnO8pOpGf8fZ4FSPs9LE5Wh5yzUKoSw5-H5fz-3q9pnLzoFTYOVhyc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvdekgddutdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfhgfhffvvefuffgjkfggtgesthdtredttdertdenucfhrhhomhepufhtvghf
    rghnucftohgvshgthhcuoehshhhrseguvghvkhgvrhhnvghlrdhioheqnecuggftrfgrth
    htvghrnhepieejteelueejueffudffkefhvdettdejffefheevieejjefhtdefffegjedv
    heefnecuffhomhgrihhnpehgihhthhhusgdrtghomhenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehshhhrseguvghvkhgvrhhnvghlrdhioh
X-ME-Proxy: <xmx:3UZpY17zAlbw7gwzNslvJvQL_mwsLoOw4kN5B3T9iqGV0RTOFZ6C5A>
    <xmx:3UZpY17X02DXHKXm5xqB88QSQ9cUKorw__7WjVnTWWg_zqpm3z6kvQ>
    <xmx:3UZpY1jDPx3RYNKvnxwKlU6b-jx6kVcds-cNmgS10l7NrFy0lodAow>
    <xmx:3UZpYzRmdKLe4ZZqHPvFmYzS4VsBQ8FA819FIpz0ZMymH4s0abrGB7oM_-c>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Nov 2022 12:56:44 -0500 (EST)
References: <20221103204017.670757-1-shr@devkernel.io>
 <20221103204017.670757-2-shr@devkernel.io>
 <c8387cab-c969-79cb-7e7f-3c8f0b4e7a9c@gnuweeb.org>
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
Date:   Mon, 07 Nov 2022 09:56:08 -0800
In-reply-to: <c8387cab-c969-79cb-7e7f-3c8f0b4e7a9c@gnuweeb.org>
Message-ID: <qvqwv8nqabs4.fsf@dev0134.prn3.facebook.com>
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
>
> Also, please update the CHANGELOG file if you add a new feature.
> Create a new entry for liburing-2.4 release.
>
In version 2 of the patch, the CHANGELOG file has been updated.

> Ref: https://github.com/axboe/liburing/discussions/696#discussioncomment-3962770
