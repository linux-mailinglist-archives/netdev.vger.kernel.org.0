Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F672BBCAC
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 04:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgKUDbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 22:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgKUDbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 22:31:12 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D944C0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 19:31:11 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id o8so3605491ioh.0
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 19:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S5oTLg78JQBWGWJuxlIEKrxaMSCrcYlXfYqW0izwtZE=;
        b=YJx/7mGxfgih7VuDfPueJ8xD24jp1nomS8yHDUKckgQf/tWK/KRmkGx0pTsu9X2J8q
         UeKzlHMX+52VjkblKl7liHneowPT2lCa1nBtQYllCKvBIisu6V+8naaSlhgFBTodnutt
         3sRjlEPW67hrsbm+Jq/bQkrFfBwDyaXBdJb0g145Th+wvZHaExoR+NSfYdZYOWQUoXTn
         xVWqkNBUXHNDKPzrLps4CpZ9DZxrPecjqF46Llx3OnwvG0s45FCYmn3PpA+eu64Y6rdk
         RRsZZiY8udTA8xlqKadcc/ZSSHES8PrGk/omJ6MdNzKOg+X/1CEk38xJZvnxIyebKqgy
         SzKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S5oTLg78JQBWGWJuxlIEKrxaMSCrcYlXfYqW0izwtZE=;
        b=hdaxpbe4Y275MUOKsA1sU86b1UmXrD11m2xSOaHROpBtMu8GsL5C7l8Jk5shnOm1OZ
         OXqKPsR5DDpS3bbiuaOrLSamw7JA6WKMPo3ybNX8VbPX+UB0PwQB7KY8SttNsYDgLClf
         1id9kMgEcCrZesmDrcoxQ5bglxXLTkKBQapw9xl2SoydN7wQZcvpIJWhg+AkQXyB9mQO
         nVOo+c9jCo2QBOomHKS4qR6NBdvyWZ/+tUXIxjb85kgIrWX8inBEFspQEUvSUl8z57vw
         5jaDFoLDnVnbc9vHCSLabpOnc4ZhKRdqbrr7eMq2TSNJkzYdPTPV52ZQ6B1MQByjtrjl
         bObg==
X-Gm-Message-State: AOAM530WcQ/lY+mOdqfDCCWu92gMPl5E1fsr8ZhJyGrNx/xbcq3bNNHB
        2GKF8hJsEGd5Epc+8LsX5PTReD0LBwo8xQ==
X-Google-Smtp-Source: ABdhPJwKGtfwDTa0z8IImutIH5wzsEwbU10FnSM3mAB+j17A+Du5XXzMvseGxio0O/YGmN/VdaWMAQ==
X-Received: by 2002:a6b:b50d:: with SMTP id e13mr26685621iof.168.1605929470694;
        Fri, 20 Nov 2020 19:31:10 -0800 (PST)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id u11sm2454107iol.51.2020.11.20.19.31.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 19:31:10 -0800 (PST)
Subject: Re: [PATCH net-next 4/6] net: ipa: support retries on generic GSI
 commands
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201119224929.23819-1-elder@linaro.org>
 <20201119224929.23819-5-elder@linaro.org>
 <20201120184923.404c30bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <88104bdd-f464-326a-264e-570a8e4a81c0@linaro.org>
Date:   Fri, 20 Nov 2020 21:31:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201120184923.404c30bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20/20 8:49 PM, Jakub Kicinski wrote:
> On Thu, 19 Nov 2020 16:49:27 -0600 Alex Elder wrote:
>> +	do
>> +		ret = gsi_generic_command(gsi, channel_id,
>> +					  GSI_GENERIC_HALT_CHANNEL);
>> +	while (ret == -EAGAIN && retries--);
> 
> This may well be the first time I've seen someone write a do while loop
> without the curly brackets!

I had them at one time, then saw I could get away
without them.  I don't have a preference but I see
you accepted it as-is.

I really appreciate your timely responses.

					-Alex
