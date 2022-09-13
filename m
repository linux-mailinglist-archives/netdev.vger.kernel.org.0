Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61AE65B6E7B
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 15:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbiIMNgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 09:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbiIMNgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 09:36:08 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA335756D;
        Tue, 13 Sep 2022 06:36:03 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 642A73200970;
        Tue, 13 Sep 2022 09:36:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 13 Sep 2022 09:36:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        mendozajonas.com; h=cc:cc:content-transfer-encoding:content-type
        :date:date:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to;
         s=fm1; t=1663076161; x=1663162561; bh=vzmZrlkHVtjeQn3abrVkqwXk0
        KmGWfY5VV/JgXRRvwg=; b=Pp56YvG51SfqJDwsGEBeqMqh1abGYWmLEX2DlX9KO
        3aNocjuVTHKXfgPYTR9kyCvN4WW1tPYR7ZaKryizlpLFaKCeo6f6yKYDWTmabo9C
        3U6yBibyQr7/HjvfzIJIFzQwLsETd/bOkPoJt8zBuD9AnRK59/NV5KIc6G+m7vzJ
        HKEH35Sr8/+CNjm2U0JIQNqDJv4TdFh5hNnDqOQ4fQiJVhT1IHtiBcU5c7O1B2UX
        0u2y3eZ/turgo0nJTxuYMsXrcT0bRl14uO0uXLKYSNlSGkDm6cxp89BaLVOFLB46
        0judMWj4QYSUJjcpZm65w+hTvG6JQG3WXOF48CKjEK9cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1663076161; x=
        1663162561; bh=vzmZrlkHVtjeQn3abrVkqwXk0KmGWfY5VV/JgXRRvwg=; b=O
        CUxH1Trj83doNkxwJqvUzsBeOGw+E8+s/lhgrkD5abMEAJxZ0Z4CJFUadGwc6fVd
        xysmN2vXL9lbQ3eBU82GzteGrL6TtZzLyM0aLA+pWk5osYP/EaK4B2NgJHEMtzx7
        xrr/dxmgRZyI/b4EVNt7zlXSRZwae+ojsQ3/TpoZ0vclWS2kmVweQVu5MKVWuwki
        9UZkorDk+cE4YWIglbpLX2JA363e3bzNh3jkzhQyjMNkU/9gA2WyzCzwdVYl6R5W
        vopIK3mrGn4RRPVn1b/PssMykV2tDSxyG81yylQ2SNrZBbyrvC/FgoBxNj0aFpor
        bbNjXvUwVJDxtVBjsbzUQ==
X-ME-Sender: <xms:QYcgY_mFaV69a75Wa-nVBeECxoVw8QugkKxVYURI3R9-4tcOzqzVtw>
    <xme:QYcgYy3dzbgryeKhBqVCj9nHCJqq1BXzB3QNjleB9X6bbCAKj9Fge5zVozawmzSca
    gwVtRosIC4lt20VHA>
X-ME-Received: <xmr:QYcgY1ryOYe340pnkS6Ehu8FNJ9P1XphUyvzdD3hoyqNuK4s3OPaOniJ-O713gY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedugedgieekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevufgfjghfkfggtgfgsehtqhhmtddtreejnecuhfhrohhmpefurghm
    ucfovghnughoiigrqdflohhnrghsuceoshgrmhesmhgvnhguohiirghjohhnrghsrdgtoh
    hmqeenucggtffrrghtthgvrhhnpeehudevffeuieefffehteekfeekledvhfehteejgeeg
    gedthfdvkeetleevhfelkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehsrghmsehmvghnughoiigrjhhonhgrshdrtghomh
X-ME-Proxy: <xmx:QYcgY3l4RF_SIBsvB2BRvDvytnHxZI_UucK6D2jA1aqUEJKhwyc4uA>
    <xmx:QYcgY93FM06nfRIOlCNrNqBrDFqSXOPwFq1VI965HuVK34W7LNVWIw>
    <xmx:QYcgY2tpcl7hcL8rH5BMD235zPvPNgiMeiRQSDmGQlDan87_xtjtZA>
    <xmx:QYcgY3pbGIyxoh2i_GroednbvhWhIBvmaZwWTUJ0C8KEVDaMLGkNFA>
Feedback-ID: iab794258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 13 Sep 2022 09:36:01 -0400 (EDT)
Date:   Tue, 13 Sep 2022 14:35:59 +0100
From:   Sam Mendoza-Jonas <sam@mendozajonas.com>
To:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>,
        Paul Fertser <fercerpav@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        openbmc@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ncsi: Add Intel OS2BMC OEM command
User-Agent: K-9 Mail for Android
In-Reply-To: <36c12486-57d4-c11d-474f-f26a7de8e59a@linux.intel.com>
References: <20220909025716.2610386-1-jiaqing.zhao@linux.intel.com> <YxrWPfErV7tKRjyQ@home.paul.comp> <8eabb29b-7302-d0a2-5949-d7aa6bc59809@linux.intel.com> <Yxrun9LRcFv2QntR@home.paul.comp> <36c12486-57d4-c11d-474f-f26a7de8e59a@linux.intel.com>
Message-ID: <F7F5AD32-901B-440A-8B1D-30C4283F18CD@mendozajonas.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On September 13, 2022 3:12:06 AM GMT+01:00, Jiaqing Zhao <jiaqing=2Ezhao@li=
nux=2Eintel=2Ecom> wrote:
>
>
>On 2022-09-09 15:43, Paul Fertser wrote:
>> Hello,
>>=20
>> On Fri, Sep 09, 2022 at 03:34:53PM +0800, Jiaqing Zhao wrote:
>>>> Can you please outline some particular use cases for this feature?
>>>>
>>> It enables access between host and BMC when BMC shares the network con=
nection
>>> with host using NCSI, like accessing BMC via HTTP or SSH from host=2E=
=20
>>=20
>> Why having a compile time kernel option here more appropriate than
>> just running something like "/usr/bin/ncsi-netlink --package 0
>> --channel 0 --index 3 --oem-payload 00000157200001" (this example uses
>> another OEM command) on BMC userspace startup?
>>=20
>
>Using ncsi-netlink is one way, but the package and channel id is undeterm=
ined
>as it is selected at runtime=2E Calling the netlink command on a nonexist=
ent
>package/channel may lead to kernel panic=2E

If so, that would be a bug :)

>
>Why I prefer the kernel option is that it applies the config to all ncsi
>devices by default when setting up them=2E This reduces the effort and ke=
eps
>compatibility=2E Lots of things in current ncsi kernel driver can be done=
 via
>commands from userspace, but I think it is not a good idea to have a driv=
er
>resides on both kernel and userspace=2E

BMCs are of course in their own world and there's already some examples of=
 the config option, but how would a system owner be able to disable this wi=
thout reflashing the BMC?

