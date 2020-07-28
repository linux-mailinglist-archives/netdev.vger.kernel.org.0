Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B05C23146D
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 23:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729193AbgG1VIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 17:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728728AbgG1VIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 17:08:36 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF793C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 14:08:35 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id e13so20172504qkg.5
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 14:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U0xJfgQUT3WA3VgdkWdn2POTwkhqhCsGyh+jGq9k3Ts=;
        b=Zzy+EQK9XmSwSsolKdAs5A/B119C1m+RXxb8BfHinMi8HLioNy2H6yVyTdjLGmnYBc
         6XZaFfST7k+51wKh4I3Dp2w6wdN+vFs8Lqq/W3PWHppF/n71vesLG4bOfyE8gBnBuPOS
         eURqzyedzxjt5QM38g7aailBOXsrheijTFzWnhXjzMEc6giZtKhNRh17wyqycDmZ8wzc
         OMlrGIkG0c0diUPIqYM6HO2mkb50YdXHXwDkcsS2Z3rDzm5kPyRYDdaKXtJbYQVvfqZM
         tDYR0fbejt3uHkD8Vax7Pw5VCoZ9+BQwzjLhC1JtVkQAQyDCzaPpBoSL4XcL6M08uDUZ
         9r1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U0xJfgQUT3WA3VgdkWdn2POTwkhqhCsGyh+jGq9k3Ts=;
        b=gGCwKBY6pi1+3XxK5RZX7zMAq4zPgNyk+4xIkab7zhFgK7fQ7TCO0zDO0KYuWNO0D7
         FcifNF1RzgciCJXLQdk0UaenMwa7PKobcDX6z5aA10xUxzzRybXiszptK6Fpk0eVw/RM
         ofoPsDc+XzlgDSYzPPphWeb2uYFkXocM40Yb2+FS5OT3EhsjizrbNmyErnSQQgU6EjDS
         TxmzyebpMs4BLmfKi3TpuNHqMjcSW6YRvr4YSRaZybywCGiZHKJWzGf/pVeEarT5AtsY
         62gImmBq85IyukST7VycAkZTdcMTqxuMiv3qqHqkZuB462Kp8ddbDFB6FQdQ332jOtU5
         DvmA==
X-Gm-Message-State: AOAM53072OR0EPi2oi25MPoaGmrwPErRTfbh898guu6Q8ZlpBGT5EHLv
        fKCUadS6jE4P4rz/azkb0xI=
X-Google-Smtp-Source: ABdhPJyDVKvHpo93APTIX2TVZgbTEEJma/vuuNuYyzXJt8LWtH/BF1VBW3HB7OLHzh4VgSbTTlaNwA==
X-Received: by 2002:a05:620a:65d:: with SMTP id a29mr17614129qka.167.1595970515111;
        Tue, 28 Jul 2020 14:08:35 -0700 (PDT)
Received: from ?IPv6:2601:284:8202:10b0:c842:646d:48fc:f7aa? ([2601:284:8202:10b0:c842:646d:48fc:f7aa])
        by smtp.googlemail.com with ESMTPSA id x137sm22680746qkb.47.2020.07.28.14.08.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2020 14:08:34 -0700 (PDT)
Subject: Re: [PATCH iproute2-next master v2] bridge: fdb show: fix fdb entry
 state output (+ add json support)
To:     Julien Fortin <julien@cumulusnetworks.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@cumulusnetworks.com>
References: <20200727162009.7618-1-julien@cumulusnetworks.com>
 <20200727093027.467da3a7@hermes.lan>
 <CAM_1_KxDbSqaUWr4apTs4ydizTiohm7_L=B=0mZxeMX=nNEwzA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2d7775f8-e500-f68a-3c2b-be574515f80b@gmail.com>
Date:   Tue, 28 Jul 2020 15:08:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM_1_KxDbSqaUWr4apTs4ydizTiohm7_L=B=0mZxeMX=nNEwzA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/20 5:25 PM, Julien Fortin wrote:
> On Mon, Jul 27, 2020 at 6:30 PM Stephen Hemminger
> <stephen@networkplumber.org> wrote:
>>
>> On Mon, 27 Jul 2020 18:20:09 +0200
>> Julien Fortin <julien@cumulusnetworks.com> wrote:
>>
>>> diff --git a/bridge/fdb.c b/bridge/fdb.c
>>> index d1f8afbe..765f4e51 100644
>>> --- a/bridge/fdb.c
>>> +++ b/bridge/fdb.c
>>> @@ -62,7 +62,10 @@ static const char *state_n2a(unsigned int s)
>>>       if (s & NUD_REACHABLE)
>>>               return "";
>>>
>>> -     sprintf(buf, "state=%#x", s);
>>> +     if (is_json_context())
>>> +             sprintf(buf, "%#x", s);
>>> +     else
>>> +             sprintf(buf, "state %#x", s)
>>
>> Please keep the "state=%#x" for the non JSON case.
>> No need to change output format.
> 
> My v1 patch (see below) kept the "state=" but you asked me to remove
> it and re-submit.
> 
> diff --git a/bridge/fdb.c b/bridge/fdb.c
> index d2247e80..198c51d1 100644
> --- a/bridge/fdb.c
> +++ b/bridge/fdb.c
> @@ -62,7 +62,10 @@ static const char *state_n2a(unsigned int s)
>         if (s & NUD_REACHABLE)
>                 return "";
> 
> -       sprintf(buf, "state=%#x", s);
> +       if (is_json_context())
> +               sprintf(buf, "%#x", s);
> +       else
> +               sprintf(buf, "state=%#x", s);
>         return buf;
>  }
> 

the v1 patch looks correct to me. Resubmit, but this should go to main
branch since it is a bug fix.
