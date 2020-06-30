Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F352520EA96
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgF3BBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbgF3BBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 21:01:22 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915DBC061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 18:01:22 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id k6so16179042ili.6
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 18:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NaKJsSnkWrkKv86t4PQxxEiIe5XbiBA0vQt3uCPOwDc=;
        b=HgOCBOmOrGhqt1M4N1Q+WX9+t8c9E4C/qSXa3AZtl0D0yXas0XVNIf2vxfKsHlyf3j
         4A/NqlhxicnyvJCK0bueZ0RdIM8HGoQsikCDfm2TN6vItjMQfR84PRFvnYcq7hBH0H72
         ZKcbnL3NKwogAPiVcM31Rw8V5odLZOcZOqA4Jb86DaWilVShSCWGsWKJw5cTYlFi4sxR
         CwyJhsoeLTfJwAHGNZm7T8Xk8BrhL5QtriU55A19x4Wxr+DD1Vz2eKA1TH5ZKW9QCmRv
         ZsGhD7BBI0+gTBoQaYE0oSitDUWXgbtvhbVw1qfuyag0GvhIcQC9oBkq6ELNjj6GtAzz
         SAKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NaKJsSnkWrkKv86t4PQxxEiIe5XbiBA0vQt3uCPOwDc=;
        b=p1d0w1gJ0bz0TgW7x6ntBC26e16vifBqzylXq0tewuTSL1nZjrH7SJsag8qyfEhK9G
         itG9913ZPdDYDHA09yfxHvaWMm3wi5yxTTydIUachuDD5edJtlQa+STL0TGe766EPFbn
         knl0voeTAYaYnNsNRTdJvbVhMgr6F8AFjTy5AQjbDblnJnw3KU/r0S62oibvGXyDCcFo
         KvrGKVP7CslrfkdIsEMBjr7MvkGl0+0EE/xvpffFXAZsy5H8ZKRD7POtCVoLD+b1ONh9
         x+B7w99Mv9wkWURTcJcQpACdkPPtk6CUZVvMeJ1QGlv43XYH9RJFY0/q/Ep6C/AHRXEV
         b8eA==
X-Gm-Message-State: AOAM532UyAGJEjOSsJvwKVVNbpyJsiM+iYu5d21P8f3j3SfYD/eyb2u+
        f4aH/S+pb1hvXNV3sHwQE2EtvQ==
X-Google-Smtp-Source: ABdhPJxb2LLjuD2AwMZ4mlj1DzHPnDlxUnDhImUQBU2tCHGhwIHTkhfpN4MqogONmrw2HxmAF8vRMA==
X-Received: by 2002:a05:6e02:4ca:: with SMTP id f10mr201432ils.291.1593478881872;
        Mon, 29 Jun 2020 18:01:21 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id v5sm713008ios.54.2020.06.29.18.01.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 18:01:21 -0700 (PDT)
Subject: Re: [PATCH net-next 1/5] net: ipa: head-of-line block registers are
 RX only
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200629214919.1196017-1-elder@linaro.org>
 <20200629214919.1196017-2-elder@linaro.org>
 <20200629173517.40716282@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <7c438ee3-8ff0-0ee1-2a0a-fa458d982e11@linaro.org>
Date:   Mon, 29 Jun 2020 20:01:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200629173517.40716282@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/29/20 7:35 PM, Jakub Kicinski wrote:
> On Mon, 29 Jun 2020 16:49:15 -0500 Alex Elder wrote:
>> The INIT_HOL_BLOCK_EN and INIT_HOL_BLOCK_TIMER endpoint registers
>> are only valid for RX endpoints.
>>
>> Have ipa_endpoint_modem_hol_block_clear_all() skip writing these
>> registers for TX endpoints.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>  drivers/net/ipa/ipa_endpoint.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
>> index 9f50d0d11704..3f5a41fc1997 100644
>> --- a/drivers/net/ipa/ipa_endpoint.c
>> +++ b/drivers/net/ipa/ipa_endpoint.c
>> @@ -642,6 +642,8 @@ static int ipa_endpoint_init_hol_block_timer(struct ipa_endpoint *endpoint,
>>  	u32 offset;
>>  	u32 val;
>>  
>> +	/* assert(!endpoint->toward_ipa); */
>> +
>>  	/* XXX We'll fix this when the register definition is clear */
>>  	if (microseconds) {
>>  		struct device *dev = &ipa->pdev->dev;
>> @@ -671,6 +673,8 @@ ipa_endpoint_init_hol_block_enable(struct ipa_endpoint *endpoint, bool enable)
>>  	u32 offset;
>>  	u32 val;
>>  
>> +	/* assert(!endpoint->toward_ipa); */
> 
> What are these assert comments for? :S

They are place holders for when I can put in a proper assert
function.  For now I'm trying to avoid BUG_ON() calls, but
at some point soon I'll replace these comments with calls
to a macro that does BUG_ON() conditioned on a config option
(or something else if there's a better suggestion).

Even though it's commented, the assert() call does what
I want, which is to communicate to the reader a condition
assumed by the code, succinctly.

					-Alex
