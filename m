Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73870233A93
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 23:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730853AbgG3VYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 17:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730839AbgG3VYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 17:24:04 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D2FC061574;
        Thu, 30 Jul 2020 14:24:04 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mt12so5345599pjb.4;
        Thu, 30 Jul 2020 14:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RllND8YDg12FzfwSN0tsP8pt28DA/wEoBERAP+zFZiw=;
        b=SO1AnQl8I0T30BXdo92lJvvwqMjo9tgmV0pphM8yDe07Z3iPXDUZcdqbet2fGExc+e
         MZtSJg0EKirhtmtWFE01g7n7dAPplDW2Yz0mqPB1XuTrvalEOvqyzN1fR/J42c5+CB8t
         0QqiQsZYSN6nkZjWQqCY3dhHa98w1HjX/YVqAHuYFCaowZIhQXxeq/toyZ+4dKsT7/TB
         GEGxDBTCivWdBl1jHSyqLlz37IKAWEKogtFm5I144f2rpryDKUwtxM26CiwCpAORAVli
         gUxscE09mJku0dgN16unr8XIysMcWeYS/oy9rIonOUndFrmYZBcsAUu6nmoy0Vtt9MhM
         5TKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=RllND8YDg12FzfwSN0tsP8pt28DA/wEoBERAP+zFZiw=;
        b=T4b/Ofqfn72KKYLqkFRBd+eUulJ85Lgkc4jCU4Hw+BFrv27Q4iBs8zPGQpX5WZGBnH
         r76nOD9968NuNZPLgS1nOgzUVK1SoE1sFFLCtm/XLrO+NFtRMTElddP/d/Io3kLPPN9Q
         gFPGEMtKeL1PGk0qYJf+t7r6PjVtYB4SPMd/6v2lVTLKwuU4cBDevKLlO5jQlFw1pAFZ
         DZjzIYHmR7S2c5eu21iWjO2wL3Gm3LuOHTZ5ezWJPxg5t3oE7YIcFYaQg1k+4ldkVmUv
         wlL4NJx35PnsfK7dHIFOS8+BetrIXoDYCgDkOWsKcOLP7EkV48A49KUr3NOg4teOUVda
         gpYg==
X-Gm-Message-State: AOAM531suTH9DHiE94/mAsX3iIArlxCx5ajHeN10mVi1PnTHpT5UNS9t
        j1EO5nS1oNeCzn8ZpImpzEjLAAUK
X-Google-Smtp-Source: ABdhPJyzzrYOrjkcrGe/8hClf2gAK0TQQLMZTtKFeZEU5xdMRbIG9kb0+QDulq8Q0nuYjR9RZwmL/w==
X-Received: by 2002:a17:902:7e01:: with SMTP id b1mr1009449plm.310.1596144243556;
        Thu, 30 Jul 2020 14:24:03 -0700 (PDT)
Received: from [10.67.50.75] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t20sm6467525pjg.21.2020.07.30.14.23.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 14:24:02 -0700 (PDT)
Subject: Re: [PATCH net] tcp: Export tcp_write_queue_purge()
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200730210728.2051-1-f.fainelli@gmail.com>
 <CANn89iJETzud8PK7eTj=rXMSCjBtnmcSq1y0qF7EVK8b5M_vXA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <2347a342-f0b0-903c-ebb6-6e95eb664864@gmail.com>
Date:   Thu, 30 Jul 2020 14:23:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CANn89iJETzud8PK7eTj=rXMSCjBtnmcSq1y0qF7EVK8b5M_vXA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/30/20 2:16 PM, Eric Dumazet wrote:
> On Thu, Jul 30, 2020 at 2:07 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>> After tcp_write_queue_purge() got uninlined with commit ac3f09ba3e49
>> ("tcp: uninline tcp_write_queue_purge()"), it became no longer possible
>> to reference this symbol from kernel modules.
>>
>> Fixes: ac3f09ba3e49 ("tcp: uninline tcp_write_queue_purge()")
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  net/ipv4/tcp.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>> index 6f0caf9a866d..ea9d296a8380 100644
>> --- a/net/ipv4/tcp.c
>> +++ b/net/ipv4/tcp.c
>> @@ -2626,6 +2626,7 @@ void tcp_write_queue_purge(struct sock *sk)
>>         tcp_sk(sk)->packets_out = 0;
>>         inet_csk(sk)->icsk_backoff = 0;
>>  }
>> +EXPORT_SYMBOL(tcp_write_queue_purge);
>>
>>  int tcp_disconnect(struct sock *sk, int flags)
>>  {
>> --
>> 2.17.1
>>
> 
> Hmmm.... which module would need this exactly ?

None in tree unfortunately, and I doubt it would be published one day.
For consistency one could argue that given it used to be accessible, and
other symbols within net/ipv4/tcp.c are also exported, so this should
one be. Not going to hold that line of argumentation more than in this
email, if you object to it, that would be completely fine with me.

> 
> How come it took 3 years to discover this issue ?

We just upgraded our downstream kernel from 4.9 to 5.4 and this is why
it took so long.
-- 
Florian
