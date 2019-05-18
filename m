Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10EEB224E3
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 22:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbfERUf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 16:35:59 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38138 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727620AbfERUf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 16:35:59 -0400
Received: by mail-qk1-f194.google.com with SMTP id a64so6577097qkg.5
        for <netdev@vger.kernel.org>; Sat, 18 May 2019 13:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yuWJnN6IqtbUlKM+g7UJwNgME+NodJ1o9mwiUSpKExw=;
        b=dZCElmDDPg4Hd4zTpGh/cKlmIWvj412JJnWeBPWrDS7LKiwAGThYkCyaP4FcXGNXOf
         uDI4H8UNAAPJNCaNq1XyDC1mFajYnVwr3cCsIPdz8ffwp+YMC9GLi2Q47yUcdEUu5Dde
         zPKLQPWfUbZ21Tp2SkiQFpvCTA0TaewbRXUj80IY2xk/QICNlpIHIR9TX5rDNHluhBwv
         uyz9Y4rpv32i0Koh1eK5wa+N0PN6B0XIQffvJowvz7QkDQ9bUoI5G5Tuy83tndcWFtSg
         pwe5jP2HR3S66K6X+VtoqfF/bQGBLCE3YnsMkasQqci8gQVc4yPmM7jo3UkXfPjB010e
         hlVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yuWJnN6IqtbUlKM+g7UJwNgME+NodJ1o9mwiUSpKExw=;
        b=pcSnxAEF90nOISLbz6MSSH6kDAgLVtHnM4ii+eWQZcub29Jsx2phiZ+1qV+jV2yLrZ
         tSJLHpPOi/I6BZgyEZodPisg7zxObYG8Sxs9hjBKjY4kXEcQDqtT3PrI8WiPc1JHajX2
         FD6sQO2ekD+/zxCo7dJgJIdElmdye6J4z88968UxN+b8EyoGkqCoU4glcory4OPZ3NFh
         Fn+6qTbedYFd6/aXNvGuND8BMTYb5r6oaIl6e8WaUXnA52Kw9dygBFfvG91Ihf3rcsyC
         In+EtlUOaN4gDRYFFGtGbS1T8IYZXKJiyVRtQYqaf1XbnUwdlOgM8gefM+Qdat8GXy5Q
         CgKg==
X-Gm-Message-State: APjAAAXddxzDhlhHjs7RzT5Ixjcd9qsQCfU0sMCemCA0BhBl088ROKSP
        Ub3j5P0bcJS9sr417SCKLw6mAwnKq5c=
X-Google-Smtp-Source: APXvYqwmoomr93ImuyZY5ogTehv/yWI1htVbjdwZ4ZfCT3U1wsHjiKXDY+8nBuEhQ2T7Xp4MWQIzlw==
X-Received: by 2002:a37:f50f:: with SMTP id l15mr23796046qkk.343.1558211758138;
        Sat, 18 May 2019 13:35:58 -0700 (PDT)
Received: from [192.168.0.124] (24-212-162-241.cable.teksavvy.com. [24.212.162.241])
        by smtp.googlemail.com with ESMTPSA id f21sm5518291qkl.72.2019.05.18.13.35.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 May 2019 13:35:57 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 2/3] flow_offload: restore ability to
 collect separate stats per action
To:     Edward Cree <ecree@solarflare.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <88b3c1de-b11c-ee9b-e251-43e1ac47592a@solarflare.com>
 <b4a13b86-ae18-0801-249a-2831ec08c44c@solarflare.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <49016cd0-c1c3-2bd7-d807-2b2039e12fa3@mojatatu.com>
Date:   Sat, 18 May 2019 16:35:56 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <b4a13b86-ae18-0801-249a-2831ec08c44c@solarflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-15 3:42 p.m., Edward Cree wrote:
> In the TC_CLSFLOWER_STATS callback from fl_hw_update_stats(), pass an
>   array of struct flow_stats_entry, one for each action in the flow rule.
> Current drivers (which do not collect per-action stats, but rather per-
>   rule) call flow_stats_update() in a loop with the same values for all
>   actions; this is roughly what they did before 3b1903ef97c0, except that
>   there is not a helper function (like tcf_exts_stats_update()) that does
>   it for them, because we don't want to encourage future drivers to do
>   the same thing (and there isn't a need for a preempt_disable() like in
>   tcf_exts_stats_update()).
> 
> Also do the same in mall_stats_hw_filter()'s TC_CLSMATCHALL_STATS
>   callback, since it also uses tcf_exts_stats_update().
> 
> Signed-off-by: Edward Cree <ecree@solarflare.com>

Looks good to me.
Your patch doesnt have U32. IIRC, I have seen stats on ixgbe with the
u32 classifier last time i mucked around with it
(maybe Pablo's changes removed it?).

cheers,
jamal

