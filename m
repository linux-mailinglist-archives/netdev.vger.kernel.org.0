Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9379C522F0D
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 11:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235467AbiEKJNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236742AbiEKJNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:13:14 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E819852ED
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:13:11 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id q18so1267583pln.12
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=caUdEXgEVSs0kuMmNBlg8+o07OgsFwK73z/jdG/sSCw=;
        b=GVUhA0VQq48r7t+9HqUSitkWIadgQr9wvzK2elcHTuWN5edcIU4Trwg4P6r3dVoJYC
         Q5fqOhY+dqZHlWgocJjv0TXr3nRAK3bb58+QhzPw71xFqPQmQ8n+N8Mt9xqbGH/zegmh
         LJ1cmRfbhjv9VtfFtNh24bA6WN4TKBW/9ytUE7M/H1zS4nWWJIB+o5xcKzP99MbAfbQA
         2aIb41ZOHlcuzb6vdYSBnItWez8vf8BhI+XUmIumbC1vpbsuqcJsxCZqwhlRmy1nd+RN
         KHCtFnQuG7QQeZRNeWaTgMoEB5ah5gwnTDsR+XoATzPQLewVOnLAXTXB+Hctlj5DcO3s
         WN2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=caUdEXgEVSs0kuMmNBlg8+o07OgsFwK73z/jdG/sSCw=;
        b=c5gbEvheZ8HcRhixgtOnPV0XxtW3Qf29435dOEbjt2zmfcMncwt6UsWNAHWrHX7VcC
         cUHOBofWYAInXhuX5Ipq3F8UO5cuEUrPCESyPW3bV4vlFDvZznbofmfQdrMvw52XMTAu
         2rt1tZidL74qT3XnABuwy7ww5yXR4niH/AIU7+ZiZSD1RO7xgO8edi0O+xhdsl0BCK8T
         vQOMZXOyggb1IHZ90DazbiAp/nXxam/ZeKPU6nnJczlg6OwOVw/FvsAR6J4ZjJrX6jC/
         VrkPUBTa2c1IFsUX5GPoLxCtO5y4ijEVGox4B7fglTedSmJHJ49eSV6nGFJzP2CitsbV
         tzIA==
X-Gm-Message-State: AOAM531TZilCt5IHpE3MIqy5sgkDWoatv6DgNNL57E+nAnK/fX18mb9C
        xR16T2+g7sc9x6MmDHN3e1o=
X-Google-Smtp-Source: ABdhPJwmMs6CDdH2rOsFTP1PxEzN66o6t6oq61/hdcP4tRcEBlIpsFDcBpfsgDKXnU5wySkQG17XBQ==
X-Received: by 2002:a17:90b:4a90:b0:1dc:aec3:c04 with SMTP id lp16-20020a17090b4a9000b001dcaec30c04mr4280065pjb.118.1652260390756;
        Wed, 11 May 2022 02:13:10 -0700 (PDT)
Received: from [192.168.42.10] ([23.91.97.158])
        by smtp.gmail.com with ESMTPSA id x185-20020a6386c2000000b003c14af5063dsm1184476pgd.85.2022.05.11.02.13.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 May 2022 02:13:10 -0700 (PDT)
Message-ID: <d42df7fa-0eb1-bf89-6e8f-f4fc5ff138b2@gmail.com>
Date:   Wed, 11 May 2022 17:13:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [Intel-wired-lan] [PATCH] igb: Convert a series of if statements
 to switch case
Content-Language: en-US
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        netdev@vger.kernel.org, Linkui Xiao <xiaolinkui@kylinos.cn>,
        edumazet@google.com, intel-wired-lan@lists.osuosl.org,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
References: <20220510025755.19047-1-xiaolinkui@kylinos.cn>
 <6b16f60d-0f76-f876-0881-de09ecbbbc89@molgen.mpg.de>
From:   Linkui Xiao <xiaolinkui@gmail.com>
In-Reply-To: <6b16f60d-0f76-f876-0881-de09ecbbbc89@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Paul:

Thank you for your reply and suggestions, I will send the V2 version soon.

On 5/11/22 14:32, Paul Menzel wrote:
> Dear Linkui,
>
>
> Thank you for your patch.
>
> Am 10.05.22 um 04:57 schrieb xiaolinkui:
>> From: Linkui Xiao<xiaolinkui@kylinos.cn>
>
> Please add a space before the <.
>
>> Convert a series of if statements that handle different events to
>> a switch case statement to simplify the code.
>
> (Nit: Please use 75 characters per line.)
>
>> Signed-off-by: Linkui Xiao<xiaolinkui@kylinos.cn>
>> ---
>>   drivers/net/ethernet/intel/igb/igb_main.c | 12 ++++++++----
>>   1 file changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c 
>> b/drivers/net/ethernet/intel/igb/igb_main.c
>> index 34b33b21e0dc..4ce0718eeff6 100644
>> --- a/drivers/net/ethernet/intel/igb/igb_main.c
>> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
>> @@ -4588,13 +4588,17 @@ static inline void 
>> igb_set_vf_vlan_strip(struct igb_adapter *adapter,
>>       struct e1000_hw *hw = &adapter->hw;
>>       u32 val, reg;
>>   -    if (hw->mac.type < e1000_82576)
>> +    switch (hw->mac.type) {
>> +    case e1000_undefined:
>> +    case e1000_82575:
>>           return;
>> -
>> -    if (hw->mac.type == e1000_i350)
>> +    case e1000_i350:
>>           reg = E1000_DVMOLR(vfn);
>> -    else
>> +        break;
>> +    default:
>>           reg = E1000_VMOLR(vfn);
>> +        break;
>> +    }
>>         val = rd32(reg);
>>       if (enable)
>
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
>
>
> Kind regards,
>
> Paul
