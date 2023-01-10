Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCE8663FAC
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 13:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238178AbjAJMDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 07:03:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238096AbjAJMC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 07:02:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A3458815;
        Tue, 10 Jan 2023 04:02:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F6A9615FC;
        Tue, 10 Jan 2023 12:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B720FC433EF;
        Tue, 10 Jan 2023 12:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673352177;
        bh=EdO98tQGWdd8FP7Cv/xRaOAbpnwXx0RZv8wSewtpx0U=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=eDX7n8NIKp3k4tBl5QI9uYztz6wSxIGZ5KxvhxsyTKW5U0kBh+02AdXqHfpYw28jf
         nc/C3+G8qOml6qV5OvP1M5Oyw/15pNRUA8jLOlu0aaoqiNX8DT5tgncs+JoicNIRpc
         lDEK1SH+ofJMsJ2f4RqV7PqVotTIk8B5nIAv+RLIsB0us4v6mgcCyraT3+f98n/u+l
         CfrFvwGxDzfEVYUbd0SHaNAkwPQ8vW6PTpgiHDDMzUGFQFriApcN0HaRJl6rcaF2Tg
         ZSjnbOKMYgiSafIyUt8xSocATIutNSXDP1Njrr1T5ufGY5Gkc2BPDgwNnvcWBfbETk
         cqXHkxON5IwCQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Martin Blumenstingl' <martin.blumenstingl@googlemail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "tehuang\@realtek.com" <tehuang@realtek.com>,
        "s.hauer\@pengutronix.de" <s.hauer@pengutronix.de>,
        "tony0620emma\@gmail.com" <tony0620emma@gmail.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
        <20221228133547.633797-2-martin.blumenstingl@googlemail.com>
        <92eb7dfa8b7d447e966a2751e174b642@realtek.com>
        <87da8c82dec749dc826b5a1b4c4238aa@AcuMS.aculab.com>
        <eee17e2f4e44a2f38021a839dc39fedc1c1a4141.camel@realtek.com>
        <a86893f11fe64930897473a38226a9a8@AcuMS.aculab.com>
        <5c0c77240e7ddfdffbd771ee7e50d36ef3af9c84.camel@realtek.com>
        <CAFBinCC+1jGJx1McnBY+kr3RTQ-UpxW6JYNpHzStUTredDuCug@mail.gmail.com>
        <ec6a0988f3f943128e0122d50959185a@AcuMS.aculab.com>
Date:   Tue, 10 Jan 2023 14:02:52 +0200
In-Reply-To: <ec6a0988f3f943128e0122d50959185a@AcuMS.aculab.com> (David
        Laight's message of "Wed, 4 Jan 2023 15:53:17 +0000")
Message-ID: <87r0w2fvgz.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Laight <David.Laight@ACULAB.COM> writes:

> From: Martin Blumenstingl
>> Sent: 04 January 2023 15:30
>> 
>> Hi Ping-Ke, Hi David,
>> 
>> On Sun, Jan 1, 2023 at 2:09 PM Ping-Ke Shih <pkshih@realtek.com> wrote:
>> [...]
>> > Yes, it should not use bit filed. Instead, use a __le16 for all fields, such as
>> I think this can be done in a separate patch.
>> My v2 of this patch has reduced these changes to a minimum, see [0]
>> 
>> [...]
>> > struct rtw8821ce_efuse {
>> >    ...
>> >    u8 data1;       // offset 0x100
>> >    __le16 data2;   // offset 0x101-0x102
>> >    ...
>> > } __packed;
>> >
>> > Without __packed, compiler could has pad between data1 and data2,
>> > and then get wrong result.
>> My understanding is that this is the reason why we need __packed.
>
> True, but does it really have to look like that?
> I can't find that version (I don't have a net_next tree).
> Possibly it should be 'u8 data2[2];'
>
> Most hardware definitions align everything.
>
> What you may want to do is add compile-time asserts for the
> sizes of the structures.
>
> Remember that if you have 16/32 bit fields in packed structures
> on some architectures the compile has to generate code that does
> byte loads and shifts.
>
> The 'misaligned' property is lost when you take the address - so
> you can easily generate a fault.
>
> Adding __packed to a struct is a sledgehammer you really shouldn't need.

Avoiding use of __packed is news to me, but is this really a safe rule?
Most of the wireless engineers are no compiler experts (myself included)
so I'm worried. For example, in ath10k and ath11k I try to use __packed
for all structs which are accessing hardware or firmware just to make
sure that the compiler is not changing anything.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
