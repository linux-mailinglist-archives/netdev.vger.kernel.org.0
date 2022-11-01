Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B2C614519
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 08:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiKAHgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 03:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKAHgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 03:36:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCD2387;
        Tue,  1 Nov 2022 00:36:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77748B81BEC;
        Tue,  1 Nov 2022 07:36:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B90C433D6;
        Tue,  1 Nov 2022 07:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667288176;
        bh=fmjVprX/yVT+hTtirqtZpN4JtdPtp3Z5c1IFu/BGPj4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=M5y6Q/0nObWxmxtiBz2xRJRQLyqzRrZNLNkX0Fz6A1CcY9dAQGuN+4sgi7zVnJ9u1
         x9s7qWJtaKJzIeNrsfmYYppmd8dAen2rKfa/08o80gjTAKUsq4jwXDHQc3RJmBOmFx
         iVKiL5UiwzmMjivQxmcgYnrv4jdSjj2ZdJmKZhHZUGMbOGsWN8pxQW/Fbz5h4c2VF7
         qnIZZyK3F6mVCAmuR7nNlu3W/Zil5v5Qfbg+ZtYBwQH7+sqcqDqQVQCeq4p9xx8ZbV
         +4Fl5nMRzMJOoYY/AvUznZtGwl6hCibKgmXxSQmjcPJ7SFw06QI6J1GAXgIKsq7ibq
         YTRieg5E4F3aQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     Colin Ian King <colin.i.king@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors\@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: rtl8192ee: remove static variable stop_report_cnt
In-Reply-To: <8c501b46825a4579a88ff16f53e9bcc4@realtek.com> (Ping-Ke Shih's
        message of "Tue, 1 Nov 2022 06:41:00 +0000")
References: <20221031155637.871164-1-colin.i.king@gmail.com>
        <8c501b46825a4579a88ff16f53e9bcc4@realtek.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Tue, 01 Nov 2022 09:36:08 +0200
Message-ID: <87fsf3gm8n.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> writes:

>> -----Original Message-----
>> From: Ping-Ke Shih
>> Sent: Tuesday, November 1, 2022 8:22 AM
>> To: 'Colin Ian King' <colin.i.king@gmail.com>; Kalle Valo
>> <kvalo@kernel.org>; David S . Miller
>> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
>> Kicinski <kuba@kernel.org>; Paolo Abeni
>> <pabeni@redhat.com>; linux-wireless@vger.kernel.org; netdev@vger.kernel.org
>> Cc: kernel-janitors@vger.kernel.org; linux-kernel@vger.kernel.org
>> Subject: RE: [PATCH] rtlwifi: rtl8192ee: remove static variable stop_report_cnt
>> 
>> 
>> > -----Original Message-----
>> > From: Colin Ian King <colin.i.king@gmail.com>
>> > Sent: Monday, October 31, 2022 11:57 PM
>> > To: Ping-Ke Shih <pkshih@realtek.com>; Kalle Valo
>> > <kvalo@kernel.org>; David S . Miller
>> > <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
>> > Kicinski <kuba@kernel.org>; Paolo Abeni
>> > <pabeni@redhat.com>; linux-wireless@vger.kernel.org; netdev@vger.kernel.org
>> > Cc: kernel-janitors@vger.kernel.org; linux-kernel@vger.kernel.org
>> > Subject: [PATCH] rtlwifi: rtl8192ee: remove static variable stop_report_cnt
>
> Subject prefix should be "wifi: rtlwifi: ..."
>
> I'm not sure if Kalle can help this, or you can send v2 to add prefix.

Yeah, I can fix that during commit.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
