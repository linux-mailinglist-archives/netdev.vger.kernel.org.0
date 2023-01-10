Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB41663FF4
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 13:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235593AbjAJMKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 07:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233234AbjAJMJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 07:09:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AECB574D2;
        Tue, 10 Jan 2023 04:06:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8EB66164B;
        Tue, 10 Jan 2023 12:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7945EC433D2;
        Tue, 10 Jan 2023 12:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673352393;
        bh=PCr+ItjIWLngLBbPeZX8+8sOTCxq64Car1y5b7ocqJo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ex3+RbONy69XfJ/gWQa9P4jo52DVDkaa8gpKx1Z6cCi154ZWH70Z/S8qyOiSTLyws
         jUA8EfLi8i/5DlXTEKTHJD0RnrnbjOckKbVvX7z4Gy4Hj3YVJc8sdfUR85aqLtwdBx
         cjitLi+bMeNJkTZfULvB4NJN0asd237ipZfb0+bmfTT7OW3edIQHJLPw3Ov+A+fAB9
         Qye6ALjNM5DY0pZ9Ngj6kD+j6HYMvtta5eNycfttculbBgNc1mKYPP0HLA8qy2/Y8J
         zkjrGH9UIxZMNNgSMDiGP/Sa3vM6LjHH5Vd4QYXQlmRHkvSNrD58jLcCHChDNNyRTv
         eaajaWF7GDZUg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "tony0620emma\@gmail.com" <tony0620emma@gmail.com>,
        "tehuang\@realtek.com" <tehuang@realtek.com>,
        "s.hauer\@pengutronix.de" <s.hauer@pengutronix.de>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] rtw88: Four fixes found while working on SDIO support
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
        <84e2f2289e964834b1eaf60d4f9f5255@realtek.com>
        <CAFBinCAvSYgnamMCEBGg5+vt6Uvz+AKapJ+dSfSPBbmtERYsBw@mail.gmail.com>
Date:   Tue, 10 Jan 2023 14:06:26 +0200
In-Reply-To: <CAFBinCAvSYgnamMCEBGg5+vt6Uvz+AKapJ+dSfSPBbmtERYsBw@mail.gmail.com>
        (Martin Blumenstingl's message of "Thu, 29 Dec 2022 11:40:38 +0100")
Message-ID: <87mt6qfvb1.fsf@kernel.org>
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

Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:

> Hi Ping-Ke,
>
> On Thu, Dec 29, 2022 at 10:26 AM Ping-Ke Shih <pkshih@realtek.com> wrote:
> [...]
>> > Martin Blumenstingl (4):
>> >   rtw88: Add packed attribute to the eFuse structs
>>
>> I think this patch depends on another patchset or oppositely.
>> Please point that out for reviewers.
>
> There are no dependencies for this smaller individual series other
> than Linux 6.2-rc1 (as this has USB support). I made sure to not
> include any of the SDIO changes in this series.
> The idea is that it can be applied individually and make it either
> into 6.2-rc2 (or newer) or -next (6.3).

BTW wireless-next or wireless-testing are the preferred baselines for
wireless patches. Of course you can use other trees if you really want,
but please try to make sure they apply to wireless-next. Conflicts are
always extra churn I would prefer to avoid.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
