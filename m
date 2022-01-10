Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA96D489A73
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbiAJNq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbiAJNq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 08:46:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC882C06173F;
        Mon, 10 Jan 2022 05:46:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 397D9B81657;
        Mon, 10 Jan 2022 13:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0887BC36AE3;
        Mon, 10 Jan 2022 13:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641822413;
        bh=oq2ENPhcfVsV9txVSXFBcujEFmcA6SmT2Sowk/OZKJo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=FAvyCWn4JyvlnEiHTfcqGoiit/WTZe4LvsO0SW4KXu3bN+k+dF+tvzn+K0Ne/vYu3
         HIlZkRbctTuJXDXzU0aMwL2V8FPXA9abPbHJyRt1AYRBPkD3Rcx4OCuzv7Ft+3A+lf
         eixOoFI+hTS1XRvzRu5MCdO+RF2V1/JFFMtjR3GP/ltH8WsTltrhzr9LlGQYCmQV5w
         kWrJm3ct/ggpLXWoR41QxV763wf5lk87wfXujSox0A7mfcxCadj4eCm004tHdGEX7c
         t/9fplGMazuDNsuu6103Il8ofvMe4l2ndvmoetmQ2/dIl2tN0UaYSv6wBY0H+3o184
         GYLJRM9HFmlNg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Hector Martin <marcan@marcan.st>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: Re: [PATCH v2 00/35] brcmfmac: Support Apple T2 and M1 platforms
References: <20220104072658.69756-1-marcan@marcan.st>
        <87tuebvqw4.fsf@kernel.org>
        <5226bf9f-fb0f-5dc5-3b82-2125fc229526@marcan.st>
Date:   Mon, 10 Jan 2022 15:46:45 +0200
In-Reply-To: <5226bf9f-fb0f-5dc5-3b82-2125fc229526@marcan.st> (Hector Martin's
        message of "Mon, 10 Jan 2022 20:21:03 +0900")
Message-ID: <87fspvln3u.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hector Martin <marcan@marcan.st> writes:

> On 2022/01/10 19:14, Kalle Valo wrote:
>> Hector Martin <marcan@marcan.st> writes:
>> 
>>> Hi everyone,
>>>
>>> Happy new year! This 35-patch series adds proper support for the
>>> Broadcom FullMAC chips used on Apple T2 and M1 platforms:
>>>
>>> - BCM4355C1
>>> - BCM4364B2/B3
>>> - BCM4377B3
>>> - BCM4378B1
>>> - BCM4387C2
>> 
>> 35 patches is a lot to review. It would make things easier for reviewers
>> if you can split this into smaller patchsets, 10-12 patches per set is
>> what I usually recommend. More info in the wiki link below.
>
> The patches are already split into logical groupings, so I think there
> isn't much more to be gained by sending them separately. As I described
> in the cover letter:
>
> 01~09: Firmware selection stuff
> 10~14: Add support for BCM4378
> 15~20: Add BCM4355/4364/4377 on top
> 21~27: Add BCM4387 and its newer requirements
> 28~32: Misc fixes
> 33~35: TxCap & calibration support
>
> If you want to review the series piecemeal, feel free to stop at any of
> those boundaries; the series will still make sense and is useful at any
> of those stopping points.

Really, having smaller patchsets makes the patch flow so much smoother
for everyone. If you want to submit huge patchsets then go ahead, but
that will automatically drop the patches to the bottom of my queue.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
