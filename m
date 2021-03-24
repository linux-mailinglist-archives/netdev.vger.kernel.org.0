Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F71347F60
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 18:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbhCXRc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 13:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236526AbhCXRc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 13:32:27 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCA9C061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 10:32:26 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id k8so22349140iop.12
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 10:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zeGxdoozRI3Y6UwZ+UBzEWnMVvqKz57Te6EyRVg55yY=;
        b=AwIkyZmZjcF9oEsnirN0aDUquX/CSlQk07U5WwmrS7XiK+KUmc1ydH/I0uRUNOkRcD
         woZhsEfjer1kX0ynDa+f7OQH4yssAOcmFTmNVzBn+3XO1qfuzaqV1i6p03gcrhmXIzij
         5MRmp5A1WGwS4oS7rDiZ9TNiMatcAwu4jElHzM51MCaElJm5bRuQV8pJGTt7UeIN2kOO
         KMUQIPdpOtNHGow36AkczKTrnQG7FcT0vYdk2oHxVZo/u1uJO882lksswai1vNosPfdG
         2NPO01WYqrKGKYndab0bJwnckPYky6X5p9AX+YYFV7LOMe0A4YJoWsgpFomHlNW4qVn6
         gP2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zeGxdoozRI3Y6UwZ+UBzEWnMVvqKz57Te6EyRVg55yY=;
        b=GsjRllUaX5uKjGnDjh+S6m8kJf4BtmTSxEqpiZckUfIFt/BLMEjrJ3wrRjpx6azh/l
         6dq0wbpJxXoOGNqUVczy1tPwtUZRGYLSGDUUTOnyNlJ18xJmW/Ki5CRzN+JIJc3rGUvq
         kt1udEn7HMKoJU5wPY65XnqXBoT0gb956LgRqL1rfKmq/N4hHh3mgPBP19AkFz91qRr9
         dMT3siUjzpnbOj0WDsknccYVavb2tNrTLIfVboDpXeG3Z4M/eSFb71eBV1sUgRxs/y1R
         nRgyPAigyCGQe/vjwWi6D0ygTFUaeHIT2+Zq0lZ0CCmlEWaU06KD1QfSgsD6FXnfRIia
         TzZg==
X-Gm-Message-State: AOAM533vHqMcSFT+R4GKXsPoEIJsArKODVXYpshD0EEx5bb0pMBs1PmO
        WrK+3RntM9c2FrP9ZFs6XHksew==
X-Google-Smtp-Source: ABdhPJz6mOp2tAwdDlI24zn4aAyzy4IwbezmjFYb9QQMRzZZWCKkOWj89KeW3AUMerI7sTjjTiPcUQ==
X-Received: by 2002:a02:c8d4:: with SMTP id q20mr3850465jao.90.1616607146398;
        Wed, 24 Mar 2021 10:32:26 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id k4sm1367957ion.29.2021.03.24.10.32.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 10:32:26 -0700 (PDT)
Subject: Re: [PATCH net-next] net: ipa: avoid 64-bit modulus
To:     David Laight <David.Laight@ACULAB.COM>,
        'Alex Elder' <elder@ieee.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Cc:     "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        "evgreen@chromium.org" <evgreen@chromium.org>,
        "cpratapa@codeaurora.org" <cpratapa@codeaurora.org>,
        "subashab@codeaurora.org" <subashab@codeaurora.org>,
        "elder@kernel.org" <elder@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210323010505.2149882-1-elder@linaro.org>
 <f77f12f117934e9d9e3b284ed37e87a7@AcuMS.aculab.com>
 <fea8c425-2af0-0526-4ad7-73c523253e08@ieee.org>
 <aa5a91defcca4a4cb8e2317e26385010@AcuMS.aculab.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <47c870aa-44e5-b88e-61ad-5f3b75350273@linaro.org>
Date:   Wed, 24 Mar 2021 12:32:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <aa5a91defcca4a4cb8e2317e26385010@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/21 12:12 PM, David Laight wrote:
> I think 'count' is also required to be a power of 2.
> so you could have checked 'addr & (size - 1)'.

It is required to be, and that is checked elsewhere
(in gsi_channel_data_valid()).  And yes, size would
therefore be a power-of-2, and so your clever test
would be a simple test.

I'll take that into account when I implement the
fix.  Thanks for the suggestion.

					-Alex
