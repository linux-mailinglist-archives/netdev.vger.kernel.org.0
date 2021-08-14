Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B513EBFBC
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 04:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236552AbhHNCZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 22:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236466AbhHNCZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 22:25:52 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33848C061756
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 19:25:25 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id z2so12846741iln.0
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 19:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g+h4YdA10rVYLoy91RdRh05aT4UGlm+BaDf29HhFh7M=;
        b=JrmfQNjDCsooCATbytaYIpJCtaeY7BuUCMpzvndME5z1Xl8ifWHr0gP+uIKxvgGOt/
         eopFms6IIU7bYWzj3aJNfMR2EHMRPMzlWoL4v6sH3PYFZOARe2Bh2MLM4gTDzv1D7gKO
         2dk8N3fN6yfK3EAtY2WiDbmOIACaTVTJH1RsJW21b20bu+DLi1+ZmVGLkhY88WiLIrcE
         0UNQIGqXRaxchmodrll6oOMxqt2A65Tnw2lVLuW2xz+ilTW6LgOaE8EiMVgjqtIns1WK
         p6J9z7tHpQ0bP6+rRy4vrpMY8oI0ifCtZA568J7TESQQoax2miGv0bEZH5jYKGNokzYb
         1qHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g+h4YdA10rVYLoy91RdRh05aT4UGlm+BaDf29HhFh7M=;
        b=GajWhKv83CM6GoIjFdQhTqAGQd503PCSCWsLbzKj8uhLK0Y8BSPzfEfAXhNbt/d2PM
         jYWLpHhrysq2e4Tj6BYAHcAjnxAMKqwTQJZGuljaH78i1udbCxYZLzbDGSG+8KBNk6LC
         GHM+WhEXuaan1/2eOfcAon5ttfu1hPzpzwgu/qZafRQVPFwgfyuDkAb16emTLwyHjMyj
         EXIRrH3qaCo9mvb+Nu83T5mX88U9E4FZvyoITyNEgTTXnFxNe2iqo5iKWYNSmbHR+KDt
         KTBOctZVfOQXs8G7DKHcyl/tiQZUOqa6JZocWTwK+oefZUEme8OPATHbeU1iHYRS5XuA
         +rlw==
X-Gm-Message-State: AOAM5338Q9RIgrw1MQtsK4WyqAmYCC50+a+ePlxdaM66obgaAXcq9WCL
        g2Xz6sCzd9VWtwn0jSSUp88MKg==
X-Google-Smtp-Source: ABdhPJyiu8IqRevIYCzioaezJsh+oox9gmD3WFSm5hvZ+RUcbZO6D2Cf9Rw/0beInKmSEYDK2wCaog==
X-Received: by 2002:a05:6e02:1107:: with SMTP id u7mr3622311ilk.39.1628907924549;
        Fri, 13 Aug 2021 19:25:24 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id w10sm1921603ioc.55.2021.08.13.19.25.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 19:25:24 -0700 (PDT)
Subject: Re: [PATCH net-next 4/6] net: ipa: ensure hardware has power in
 ipa_start_xmit()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210812195035.2816276-1-elder@linaro.org>
 <20210812195035.2816276-5-elder@linaro.org>
 <20210813174655.1d13b524@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <3a9e82cc-c09e-62e8-4671-8f16d4f6a35b@linaro.org>
Date:   Fri, 13 Aug 2021 21:25:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210813174655.1d13b524@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/13/21 7:46 PM, Jakub Kicinski wrote:
> On Thu, 12 Aug 2021 14:50:33 -0500 Alex Elder wrote:
>> +	/* The hardware must be powered for us to transmit */
>> +	dev = &ipa->pdev->dev;
>> +	ret = pm_runtime_get(dev);
>> +	if (ret < 1) {
>> +		/* If a resume won't happen, just drop the packet */
>> +		if (ret < 0 && ret != -EINPROGRESS) {
>> +			pm_runtime_put_noidle(dev);
>> +			goto err_drop_skb;
>> +		}
> 
> This is racy, what if the pm work gets scheduled on another CPU and
> calls wake right here (i.e. before you call netif_stop_queue())?
> The queue may never get woken up?

I haven't been seeing this happen but I think you may be right.

I did think about this race, but I think I was relying on the
PM work queue to somehow avoid the problem.  I need to think
about this again after a good night's sleep.  I might need
to add an atomic flag or something.

					-Alex

>> +		/* No power (yet).  Stop the network stack from transmitting
>> +		 * until we're resumed; ipa_modem_resume() arranges for the
>> +		 * TX queue to be started again.
>> +		 */
>> +		netif_stop_queue(netdev);
>> +
>> +		(void)pm_runtime_put(dev);
>> +
>> +		return NETDEV_TX_BUSY;

