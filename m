Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9542B20EAB6
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgF3BKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgF3BKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 21:10:00 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C07EC061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 18:10:00 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t27so11257679ill.9
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 18:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FUjeWh/gnv7SsSmyLjAY3l5nUPUBHNsyTtmhdqkaD88=;
        b=ke2ZIOIWH+veJU83MCRtimartTjxTMMQ7ssNfBQTBE0nYNCs34C2CGZBIQ5oYiTIuM
         1NPZJTPyefZhNA2BwCNjVIHOQ0bnqy3XaYx+HPU0HUotSFcx4C+QT9i2gIdC045w78KZ
         Y+IuxZUWzznlaa5qTO6WYtQBws082Pajjk1GozsCl1RQqq2Pl5gRzL7edHo6hxDF6TAN
         4+SUQs5KrBMWbu4KxiaLzKyqXKD+A0jeMYCS6V3nulKsHAENNVDk+oRhTXGTSSQE17kH
         kgDWkEfDkHYzlMQoEgV0IFTuKXRbC48oq9b2uHEcH/9wH/2wMUGCaUh/HJhfdhmBuR32
         gmMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FUjeWh/gnv7SsSmyLjAY3l5nUPUBHNsyTtmhdqkaD88=;
        b=TuIv4Ck1/NP/YwiFkrA8eMBET2IuP6FllY3r8Kjh9WuGPkpmm38Po16fSAegwGiGZc
         deNYMDonIIcDw4rYtwGMwillyvpIgIDfGNighuxuPAGNbuSH343pWSPn0m024JpOaBl3
         x5Cv6AGU/xAwtf3TZxV12z7daofsJJb0ciuAA9LmPV1HQxtXSZ5o1Zc09jqes5sjdNxb
         aPprA7QTVvpRZr76sBoEbhfZdQRwlU0jAGMPRLi9q/7bckCjuMqcu3UmwSvLJ05iQezt
         zCcvj/JJWziu7Uwj0Mhvn8Xla0jwZ08pDV9/0QK5dDIQhlpGQYK7Rswkr1Mo+NX25cI+
         N6hw==
X-Gm-Message-State: AOAM532VOZ53KDrfRSo4Ua/wzMHgDJIyrJ0gc+haSMgMgOBSD5TAbl3Q
        4gUlG7dT6Bsmx3PB9te3Rb1ihQ==
X-Google-Smtp-Source: ABdhPJwwJng843waUYdG70JKRjW/vvvCqyWW4BPiJUqCaqyW31WOH015fo5edjCQjfhloVEZLR7iUg==
X-Received: by 2002:a92:9914:: with SMTP id p20mr238232ili.273.1593479399781;
        Mon, 29 Jun 2020 18:09:59 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id z9sm838964ilb.41.2020.06.29.18.09.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 18:09:59 -0700 (PDT)
Subject: Re: [PATCH net-next 1/5] net: ipa: head-of-line block registers are
 RX only
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200629214919.1196017-2-elder@linaro.org>
 <20200629173517.40716282@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7c438ee3-8ff0-0ee1-2a0a-fa458d982e11@linaro.org>
 <20200629.180305.1550276438848153234.davem@davemloft.net>
From:   Alex Elder <elder@linaro.org>
Message-ID: <825816f3-5797-bbcf-571b-c6a7a6821397@linaro.org>
Date:   Mon, 29 Jun 2020 20:09:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200629.180305.1550276438848153234.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/29/20 8:03 PM, David Miller wrote:
> Never BUG_ON() unless you absolutely cannot continue executing kernel
> without corrupting memory or similar.

Yes, that's basically why I don't use it.  But the reason I was
considering it conditional on a config option is that Qualcomm
has a crash analysis tool that expects a BUG() call to stop the
system so its instant state can be captured.  I don't use this
tool, and I might be mistaken about what's required.

What I would *really* like to do is have a way to gracefully
shut down just the IPA driver when an unexpected condition occurs,
so I can stop everything without crashing the system.  But doing
that in a way that works in all cases is Hard.

Do you have any suggestions?

					-Alex
