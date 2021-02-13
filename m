Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22FD531A982
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbhBMBgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbhBMBgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 20:36:38 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036FBC061756
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 17:35:53 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id p15so888284ilq.8
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 17:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/9HhZQkzV+KZqkj+iEdlDqVQgohkQKjigRdK1YlBtVw=;
        b=fqdKjcedDWGoOQwcVhR9CbJssPJ2fAu3p7rUD6f3h/QV959EnjTNz7teYMlFjGWLA0
         u/d/jDEuqJNlm+zQe72odMrt9ZPBBjET0HwdsmQ5Sb4/u9aU6+vyfgdVZ7+mEEjsgbLw
         Ktr/PU3gza87hShLtC+97n3Kbmv0pfCsMpitQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/9HhZQkzV+KZqkj+iEdlDqVQgohkQKjigRdK1YlBtVw=;
        b=jzQOruH6b79ZcvXZsdx0K+2ps39IdiP5FVH7jv4Dt+RqSoXR3Z22PCeJUx4X2X6HUE
         NIQFwzJQLsA5Y+jB+sxkDvT8jGQ/+ZhYagFvfaDMm5gt6pIQaLwqOoo0XJ1BZ7vhaFY3
         i9PobDcO83EzsGiPQ9Uv47dxV2UIbU1Moe9GEPLbclnzebskhLzDPmelhbpfSVGQOC0K
         UOF280ZOC9igN7UxiXKjZv+fvpt/br3Iu52ebjTBAujiXA4HlonXfW0TAeS88pek/zgr
         fvlE9t8J3MPt1TD6j+2H47CVGvOuEiMMDXc6yJLTwVcTbkctEFZXv4w+rfyWx+G7DNhr
         gKEg==
X-Gm-Message-State: AOAM532xOcNaAbbMo+7kaaIyq5maLwD30cOmpJFugdt2tj7nnQYvcbom
        RVu8QJ8g7lpWaD7iD0CZcjsee9LUbm3syQ==
X-Google-Smtp-Source: ABdhPJzBHlrooN/Y+mM73//9QQM29O2OQLRFN9jzZhBIiWNE8rT/vRmRrEoWNVcNNP68cbwrNLrCvw==
X-Received: by 2002:a92:8e42:: with SMTP id k2mr4826560ilh.250.1613180152140;
        Fri, 12 Feb 2021 17:35:52 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id z18sm4662432ior.19.2021.02.12.17.35.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 17:35:51 -0800 (PST)
Subject: Re: [PATCH v3 net-next 4/5] net: ipa: introduce
 ipa_table_hash_support()
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Alex Elder <elder@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, elder@kernel.org,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210212143402.2691-1-elder@linaro.org>
 <20210212143402.2691-5-elder@linaro.org>
 <CAKgT0Ue7x9M9qyLffeXDLv0D3gnFzimAbd==5A_t0r3WpxMgcQ@mail.gmail.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <fdf0f89d-a5f3-7240-514d-b56194e8a438@ieee.org>
Date:   Fri, 12 Feb 2021 19:35:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAKgT0Ue7x9M9qyLffeXDLv0D3gnFzimAbd==5A_t0r3WpxMgcQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/12/21 7:05 PM, Alexander Duyck wrote:
> On Fri, Feb 12, 2021 at 6:40 AM Alex Elder <elder@linaro.org> wrote:
>>
>> Introduce a new function to abstract the knowledge of whether hashed
>> routing and filter tables are supported for a given IPA instance.
>>
>> IPA v4.2 is the only one that doesn't support hashed tables (now
>> and for the foreseeable future), but the name of the helper function
>> is better for explaining what's going on.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>> v2: - Update copyrights.
>>
>>   drivers/net/ipa/ipa_cmd.c   |  2 +-
>>   drivers/net/ipa/ipa_table.c | 16 +++++++++-------
>>   drivers/net/ipa/ipa_table.h |  8 +++++++-
>>   3 files changed, 17 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
>> index fd8bf6468d313..35e35852c25c5 100644
>> --- a/drivers/net/ipa/ipa_cmd.c
>> +++ b/drivers/net/ipa/ipa_cmd.c
>> @@ -268,7 +268,7 @@ static bool ipa_cmd_register_write_valid(struct ipa *ipa)
>>          /* If hashed tables are supported, ensure the hash flush register
>>           * offset will fit in a register write IPA immediate command.
>>           */
>> -       if (ipa->version != IPA_VERSION_4_2) {
>> +       if (ipa_table_hash_support(ipa)) {
>>                  offset = ipa_reg_filt_rout_hash_flush_offset(ipa->version);
>>                  name = "filter/route hash flush";
>>                  if (!ipa_cmd_register_write_offset_valid(ipa, name, offset))
>> diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
>> index 32e2d3e052d55..baaab3dd0e63c 100644
>> --- a/drivers/net/ipa/ipa_table.c
>> +++ b/drivers/net/ipa/ipa_table.c
>> @@ -1,7 +1,7 @@
>>   // SPDX-License-Identifier: GPL-2.0
>>
>>   /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
>> - * Copyright (C) 2018-2020 Linaro Ltd.
>> + * Copyright (C) 2018-2021 Linaro Ltd.
>>    */
>>
>>   #include <linux/types.h>
>> @@ -239,6 +239,11 @@ static void ipa_table_validate_build(void)
>>
>>   #endif /* !IPA_VALIDATE */
>>
>> +bool ipa_table_hash_support(struct ipa *ipa)
>> +{
>> +       return ipa->version != IPA_VERSION_4_2;
>> +}
>> +
> 
> Since this is only a single comparison it might make more sense to
> make this a static inline and place it in ipa.h. Otherwise you are
> just bloating the code up to jump to such a small function.

Static inline will duplicate the function everywhere also,
"bloating" it in another way (but it's a fairly trivial
amount of code either way).

Nevertheless I agree with your sentiment.  It's moot now
because the series was just accepted, but I'll keep it
in mind.

Thanks for your input.

					-Alex

>>   /* Zero entry count means no table, so just return a 0 address */
>>   static dma_addr_t ipa_table_addr(struct ipa *ipa, bool filter_mask, u16 count)
>>   {
>> @@ -412,8 +417,7 @@ int ipa_table_hash_flush(struct ipa *ipa)
>>          struct gsi_trans *trans;
>>          u32 val;
>>
>> -       /* IPA version 4.2 does not support hashed tables */
>> -       if (ipa->version == IPA_VERSION_4_2)
>> +       if (!ipa_table_hash_support(ipa))
>>                  return 0;
>>
>>          trans = ipa_cmd_trans_alloc(ipa, 1);
>> @@ -531,8 +535,7 @@ static void ipa_filter_config(struct ipa *ipa, bool modem)
>>          enum gsi_ee_id ee_id = modem ? GSI_EE_MODEM : GSI_EE_AP;
>>          u32 ep_mask = ipa->filter_map;
>>
>> -       /* IPA version 4.2 has no hashed route tables */
>> -       if (ipa->version == IPA_VERSION_4_2)
>> +       if (!ipa_table_hash_support(ipa))
>>                  return;
>>
>>          while (ep_mask) {
>> @@ -582,8 +585,7 @@ static void ipa_route_config(struct ipa *ipa, bool modem)
>>   {
>>          u32 route_id;
>>
>> -       /* IPA version 4.2 has no hashed route tables */
>> -       if (ipa->version == IPA_VERSION_4_2)
>> +       if (!ipa_table_hash_support(ipa))
>>                  return;
>>
>>          for (route_id = 0; route_id < IPA_ROUTE_COUNT_MAX; route_id++)
>> diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
>> index 78038d14fcea9..1a68d20f19d6a 100644
>> --- a/drivers/net/ipa/ipa_table.h
>> +++ b/drivers/net/ipa/ipa_table.h
>> @@ -1,7 +1,7 @@
>>   /* SPDX-License-Identifier: GPL-2.0 */
>>
>>   /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
>> - * Copyright (C) 2019-2020 Linaro Ltd.
>> + * Copyright (C) 2019-2021 Linaro Ltd.
>>    */
>>   #ifndef _IPA_TABLE_H_
>>   #define _IPA_TABLE_H_
>> @@ -51,6 +51,12 @@ static inline bool ipa_filter_map_valid(struct ipa *ipa, u32 filter_mask)
>>
>>   #endif /* !IPA_VALIDATE */
>>
>> +/**
>> + * ipa_table_hash_support() - Return true if hashed tables are supported
>> + * @ipa:       IPA pointer
>> + */
>> +bool ipa_table_hash_support(struct ipa *ipa);
>> +
>>   /**
>>    * ipa_table_reset() - Reset filter and route tables entries to "none"
>>    * @ipa:       IPA pointer
> 
> Just define the function here and make it a static inline.
> 

