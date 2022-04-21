Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDFD50ABE2
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 01:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442113AbiDUXUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 19:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392628AbiDUXUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 19:20:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00ADA30F7C;
        Thu, 21 Apr 2022 16:17:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C05A6B82978;
        Thu, 21 Apr 2022 23:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D4DC385A7;
        Thu, 21 Apr 2022 23:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650583041;
        bh=7ZTWzXdUo5/Xd7sMk8LeC/OokYQbt6jUM/9BzNl6nzE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=RztVbP8GpwM+JTXX3VkA9TnF2nqs3mHWbjmq1xYgvV7mVOOuSqtIru9fsvUp3Q7TA
         joWQqv0XEJi5aD8/R091tZWrZCz/aUdIJN3aw/Vl64QSBk6LwtN3wgTeWbH6U1sX6T
         TMz6B95UNhhO9CxtqCx8eylAtXztmpTzfctD3bedwoeNj4mdH2LY5gj2DwOV9eDleX
         KEQlJQ3VWYZamtEZ0PCDH5SL12AfyvZGREelL5+6aMhbeuJ+Ph/F3aw7Qsk8pJx7IE
         rbg8ke58jGo7Zh6EzLU1YystwtWkkuuk8cLnqoWi3pUqi0tTSraFw5La+7x1g48PAJ
         UhO+B6nhYKBAQ==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 45F562D1E68; Fri, 22 Apr 2022 01:17:18 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Alexander Lobakin <alobakin@pm.me>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 bpf 00/11] bpf: random unpopular userspace fixes (32
 bit et al)
In-Reply-To: <20220421223201.322686-1-alobakin@pm.me>
References: <20220421003152.339542-1-alobakin@pm.me>
 <CAADnVQJJiBO5T3dvYaifhu3crmce7CH9b5ioc1u4=Y25SUxVRA@mail.gmail.com>
 <20220421223201.322686-1-alobakin@pm.me>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 22 Apr 2022 01:17:18 +0200
Message-ID: <871qxqgh6p.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Lobakin <alobakin@pm.me> writes:

> From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Date: Wed, 20 Apr 2022 17:40:34 -0700
>
>> On Wed, Apr 20, 2022 at 5:38 PM Alexander Lobakin <alobakin@pm.me> wrote:
>>
>> Again?
>>
>> -----BEGIN PGP MESSAGE-----
>> Version: ProtonMail
>>
>> wcFMA165ASBBe6s8AQ/8C9y4TqXgASA5xBT7UIf2GyTQRjKWcy/6kT1dkjkF
>> FldAOhehhgLYjLJzNAIkecOQfz/XNapW3GdrQDq11pq9Bzs1SJJekGXlHVIW
>>
>> Sorry I'm tossing the series out of patchwork.
>
> Oh sorry, I was hoping upgrading Bridge would help >_<
>
> Let me know if you're reading this particular message in your inbox
> finely. Toke guessed it precisely regarding the per-recipient lists
> -- Proton by default saves every address I've ever sent mails to to
> Contacts and then tries to fetch PGP public keys for each contact.
> Again, for some reason, for a couple addresses, including
> ast@kernel.org, it managed to fetch something, but that something
> was sorta broken. So at the end I've been having broken PGP for
> the address I've never manually set or ev
> en wanted PGP.
> If it's still messed, I'll contact support then. Sorry again for
> this.

Heh, yeah, now that I was in the direct Cc list, I got your message in
encrypted form as well. So, erm, I'm reading it "fine" now that I
figured out how to get my MUA to decrypt it. Probably not what you want
for patch submissions, though... :P

-Toke
