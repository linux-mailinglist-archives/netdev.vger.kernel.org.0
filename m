Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F96447EF4E
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 15:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352840AbhLXOBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 09:01:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28086 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238151AbhLXOBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 09:01:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640354492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IN+CtEcaEinaxpMiViZCvrtQMokm+URmuzrnUgB2Q/M=;
        b=UqJGFU7s3cMaB3rQDBSk9RD0+z/PUqsRqqKYfiAfMdNsMYHXserBtpm8hgHrtdDEAXNBl3
        5KPDTDwBtqrebcVSKwy3H9TwVn/A9FDws7keI1mj3k+2RYG6BCHUR6QqXrei7NnNhGQFxT
        v2R5n0eDPkBFgKFRh5srEOlxR1Ii/qY=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-120-UAxojZCON2aDX0eSHd6lew-1; Fri, 24 Dec 2021 09:01:31 -0500
X-MC-Unique: UAxojZCON2aDX0eSHd6lew-1
Received: by mail-qv1-f71.google.com with SMTP id kl5-20020a056214518500b004112e88962cso6773963qvb.4
        for <netdev@vger.kernel.org>; Fri, 24 Dec 2021 06:01:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=IN+CtEcaEinaxpMiViZCvrtQMokm+URmuzrnUgB2Q/M=;
        b=ssoo7UpLUGOhGRyIELO8GDp30nN4G4b+EsR/vhPO1Zi8MD6R67rKZY/qJybCCttQpm
         9ci+SjXcwNsquVcIyLMHBFZT2yqyzRVVxUJj8ljPz5o7D0nWwp3WV+j4GX12kTCR5e7l
         d0DA9iZQk5SU9sOQz0MyAosQDY5Xh/taIxeonqxqRi35V6Upuk3mPk2mHrJci/NBe7zH
         L6MNKFb1D4NHpJHUE9Il0XZQrEvm/duYnjqyTk4zuAMJH35J4R+XSh41aeRe2xNK5nSD
         tMrHJxIUaw330rTbfp07+ttm0OKYBy/dqkKO+c4XKXLWXwe932+UINZSHdSxo6BDDXII
         C0Zg==
X-Gm-Message-State: AOAM533/XeG329XolRj5piTV9hgD9qqJpngpA0sxTSpStmkSX/0aJfim
        TSJrfC/0PuurvRcH1nF1+CIeoXVcWbg19Mj6c1KpL4u2LVgj1tKEfkzLcAdPMQCohwdE3Nb4db9
        dtsx1nE2A6i1fU4xz
X-Received: by 2002:a05:622a:587:: with SMTP id c7mr5701403qtb.354.1640354491029;
        Fri, 24 Dec 2021 06:01:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzgua9fDI5gqPyYFuhyR50QDvtW9otecaneV8fLd7WGIwVyWmxQ32LcVE2LOEYOmt43L8GEng==
X-Received: by 2002:a05:622a:587:: with SMTP id c7mr5701363qtb.354.1640354490682;
        Fri, 24 Dec 2021 06:01:30 -0800 (PST)
Received: from localhost.localdomain (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id t30sm6510844qkj.125.2021.12.24.06.01.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Dec 2021 06:01:30 -0800 (PST)
Subject: Re: [PATCH] mac80211: initialize variable have_higher_than_11mbit
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        nathan@kernel.org, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
References: <20211223162848.3243702-1-trix@redhat.com>
 <CAKwvOd=dLjMAim_FRNyWegzEjy0_1vF2xVW1hNPQ55=32qO4Wg@mail.gmail.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <b3ef8d23-7c77-7c83-0bc8-2054b7ac1d8b@redhat.com>
Date:   Fri, 24 Dec 2021 06:01:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAKwvOd=dLjMAim_FRNyWegzEjy0_1vF2xVW1hNPQ55=32qO4Wg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/23/21 12:30 PM, Nick Desaulniers wrote:
> On Thu, Dec 23, 2021 at 8:29 AM <trix@redhat.com> wrote:
>> From: Tom Rix <trix@redhat.com>
>>
>> Clang static analysis reports this warnings
>>
>> mlme.c:5332:7: warning: Branch condition evaluates to a
>>    garbage value
>>      have_higher_than_11mbit)
>>      ^~~~~~~~~~~~~~~~~~~~~~~
>>
>> have_higher_than_11mbit is only set to true some of the time in
>> ieee80211_get_rates() but is checked all of the time.  So
>> have_higher_than_11mbit needs to be initialized to false.
> LGTM. There's only one caller of ieee80211_get_rates() today; if there
> were others, they could make a similar mistake in the future. An
> alternate approach: ieee80211_get_rates() could unconditionally write
> false before the loop that could later write true. Then call sites
> don't need to worry about this conditional assignment. Perhaps that
> would be preferable? If not:

The have_higher_than_11mbit variable had previously be initialized to false.

The commit 5d6a1b069b7f moved the variable without initializing.

Tom

>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
>
>> Fixes: 5d6a1b069b7f ("mac80211: set basic rates earlier")
>> Signed-off-by: Tom Rix <trix@redhat.com>
>> ---
>>   net/mac80211/mlme.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
>> index 51f55c4ee3c6e..766cbbc9c3a72 100644
>> --- a/net/mac80211/mlme.c
>> +++ b/net/mac80211/mlme.c
>> @@ -5279,7 +5279,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
>>           */
>>          if (new_sta) {
>>                  u32 rates = 0, basic_rates = 0;
>> -               bool have_higher_than_11mbit;
>> +               bool have_higher_than_11mbit = false;
>>                  int min_rate = INT_MAX, min_rate_index = -1;
>>                  const struct cfg80211_bss_ies *ies;
>>                  int shift = ieee80211_vif_get_shift(&sdata->vif);
>> --
>> 2.26.3
>>
>

