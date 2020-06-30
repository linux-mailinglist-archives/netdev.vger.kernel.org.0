Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2857320EA9E
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgF3BDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgF3BD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 21:03:28 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412A1C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 18:03:28 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id c16so19230532ioi.9
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 18:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aUKINyRCcoVQnAAUj66cT/hdbbLTmUEKaTLIk1C+bzY=;
        b=WJHrQSYEfA4X5EFmtDe9jbFY9aZT+nTWxDMZmLz0AUJd15mGOahtGNLjk99YVgkTH9
         s7wnYkYxZHIC/XH1BgzLNVOwdfmGbH2dziAeeT4RMpwQLqTc3Pm9ynDKXP/ZKJKfzlEM
         8nzFjlzMGmqsQsv5gkLAnHGFSckgHoMIiB0lGhkafhJu7/cZaL+7HZ98ZvCsvjGv+YnQ
         rphuYOZuh7qKZEwcSy4Yvil11mSh5dYO+8UIXVVzTMfzv2Mt/hHf9GC8Dni3ISp8IGE+
         5QEzlxRacR+HWGiur2eobXSrbwsN2JQYEN8QhSaOjmRRK6GAxVFI5RbOKHYJP95dmc6o
         Lruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aUKINyRCcoVQnAAUj66cT/hdbbLTmUEKaTLIk1C+bzY=;
        b=t3MJ5MbRBd0mnbcVB5+XQuGjWkVkNrHZiN6RPOgcfdsDSWeSeqo1pCzLuMjG9KifXO
         3a0ls8hp6Scs9XGhjlLNnyI+UZPpDZCw0BJUh5MIdTae7R5gxQLJWDWMu0E68KZ6TeFb
         x6o751Tr5q89yGGcV6xLWUViVj3Oz+Rn715RzGiQ6AuEr2hDiXo/pgR9oBvAHI37Zyhl
         ssH04Ls2Rq7hFv0NXynNjVuegxdlxfv2QlJvMmAo5YxXrhUf7NDgrZFnAXUODG5jzLFr
         S0O1Nhy0/rTALkIPqVI+fKEEMJ5wJEYfDOjagrwYQ/lmZGhSb/k2at0DyXqlOnnMfpf7
         Q8aw==
X-Gm-Message-State: AOAM531IQkpr3extHZcg2ygCnuCp7nu6K1mw9nIwt5xjk6VJxHOJkJto
        XQYoL7h2LxoCjqoPjDnv+UJPZw==
X-Google-Smtp-Source: ABdhPJwentt0cKMDEsu9rT9oUSTBpWdmkqFUmo628dp6U8zA96yEiANErt1telr45qCiv8IDu94fBw==
X-Received: by 2002:a6b:661a:: with SMTP id a26mr19625657ioc.197.1593479007622;
        Mon, 29 Jun 2020 18:03:27 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id v13sm715255iox.12.2020.06.29.18.03.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 18:03:27 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] net: ipa: always report GSI state errors
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200629213738.1180618-1-elder@linaro.org>
 <20200629213738.1180618-2-elder@linaro.org>
 <20200629170912.39188c5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <6b5baacc-3ae0-e801-1db7-d40dae560094@linaro.org>
Date:   Mon, 29 Jun 2020 20:03:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200629170912.39188c5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/29/20 7:09 PM, Jakub Kicinski wrote:
> On Mon, 29 Jun 2020 16:37:36 -0500 Alex Elder wrote:
>> We check the state of an event ring or channel both before and after
>> any GSI command issued that will change that state.  In most--but
>> not all--cases, if the state is something different than expected we
>> report an error message.
>>
>> Add error messages where missing, so that all unexpected states
>> provide information about what went wrong.  Drop the parentheses
>> around the state value shown in all cases.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
> 
> nit:

Sorry about that.  I'll fix this and run checkpatch on v2.

Thanks for your quick review.
					-Alex

> CHECK: Alignment should match open parenthesis
> #105: FILE: drivers/net/ipa/gsi.c:1673:
> +		dev_warn(dev,
> +			"limiting to %u channels; hardware supports %u\n",
> 
> CHECK: Alignment should match open parenthesis
> #120: FILE: drivers/net/ipa/gsi.c:1685:
> +		dev_warn(dev,
> +			"limiting to %u event rings; hardware supports %u\n",
> 

