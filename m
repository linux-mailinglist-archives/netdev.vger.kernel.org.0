Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609D3261FF1
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731835AbgIHUIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730323AbgIHPTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 11:19:52 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D02C0619C7;
        Tue,  8 Sep 2020 08:12:17 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id x23so7740174wmi.3;
        Tue, 08 Sep 2020 08:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mFqUHNa2HKeprNbMY5P0sIdymvWv+BxfsBb5YUnjXv4=;
        b=T3SnR/rgkfKF8JRAYgqSzsQ2FSthg6eGluOCQVeSHEiQ44Xda5SBVdTFR1NvwXL4lv
         wehgyPzjlWSKmA053McW3e0tOPnEpl6hTmWcAcvCbGudI8btTji2qL5R2hr/ah8r0ZJT
         cof21kjiZ9VvBC9FBcVlFX8QZUVNcMEjvqzyWMxRAQJxNLTAmVo7TVuYHCDZD2luoyNs
         z14G8RUSn1iQe9g5op1FC9j6bO7gliaKUZXWavKUx9Ix7vgnRIt2hRlJdO0wM/Hs7iM2
         uvL0GTB9aaJIbC8SsX/J+IdUk6nc73oV4yW8m4XchE5B43OVaoGUWsamylTDEyFAlpLK
         WK6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mFqUHNa2HKeprNbMY5P0sIdymvWv+BxfsBb5YUnjXv4=;
        b=X5t+yT83KeWTvdaYL6rLVmVuD5UpeV6PriTQKIiJNerCK5mhQc1pdd1rd38xAXgH2N
         Pe1482okCKHwsLTecCtTsctg5SZ2fIKSCSsn8mnwnfYGkL4r93IcLN1Lbk7OxwZfAsn/
         p95YLbiHMAlUAMI66UyHaRg/al1upcAWeD9QOmONPs7DEm4W4Bmb6vq64ObQOW0Y0+9b
         23L8Dku5ZeZXVwXdg41OEK/K9jBoZExjX9HNhO8B0Ft8cfqwlTp8nxlkG+iZ/sni+XPL
         UoinbELSMRCtjIzvYWwmbXLSTfMfOqevXjrTdYh40Ssw58CtXeTuA7C9sl4tSPdx0/7T
         aW9Q==
X-Gm-Message-State: AOAM532HCPOgjlEdWrDge8FW2N5xzCWTm2DXnruM1/BZCACcEc32d6qw
        mzphsvZADbi6FPZIlAypVCk=
X-Google-Smtp-Source: ABdhPJz8C3DbOYdaaFlhkfHPQYMbaGPmVa8FfTBshBFyULdVGQlp6upXGBrSYh3C9rLfzINlYBclrw==
X-Received: by 2002:a7b:cf30:: with SMTP id m16mr54831wmg.0.1599577936612;
        Tue, 08 Sep 2020 08:12:16 -0700 (PDT)
Received: from [192.168.8.147] ([37.171.26.134])
        by smtp.gmail.com with ESMTPSA id p9sm31578930wma.42.2020.09.08.08.12.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 08:12:16 -0700 (PDT)
Subject: Re: [PATCH bpf-next 4/4] ixgbe, xsk: use XSK_NAPI_WEIGHT as NAPI poll
 budget
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     magnus.karlsson@intel.com, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org
References: <20200907150217.30888-1-bjorn.topel@gmail.com>
 <20200907150217.30888-5-bjorn.topel@gmail.com>
 <6bbf1793-d2be-b724-eec4-65546d4cbc9c@gmail.com>
 <c5dac6d2-e2aa-05a4-2606-7db0687dd12b@intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b17dcc6e-cb48-9c90-f233-a178b23f9004@gmail.com>
Date:   Tue, 8 Sep 2020 17:12:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <c5dac6d2-e2aa-05a4-2606-7db0687dd12b@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/8/20 1:49 PM, Björn Töpel wrote:
> On 2020-09-08 11:45, Eric Dumazet wrote:
>>
>>
>> On 9/7/20 5:02 PM, Björn Töpel wrote:
>>> From: Björn Töpel <bjorn.topel@intel.com>
>>>
>>> Start using XSK_NAPI_WEIGHT as NAPI poll budget for the AF_XDP Rx
>>> zero-copy path.
>>>
>>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
>>> ---
>>>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>>> index 3771857cf887..f32c1ba0d237 100644
>>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>>> @@ -239,7 +239,7 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
>>>       bool failure = false;
>>>       struct sk_buff *skb;
>>>   -    while (likely(total_rx_packets < budget)) {
>>> +    while (likely(total_rx_packets < XSK_NAPI_WEIGHT)) {
>>>           union ixgbe_adv_rx_desc *rx_desc;
>>>           struct ixgbe_rx_buffer *bi;
>>>           unsigned int size
>>
>> This is a violation of NAPI API. IXGBE is already diverging a bit from best practices.
>>
> 
> Thanks for having a look, Eric! By diverging from best practices, do
> you mean that multiple queues share one NAPI context, and the budget
> is split over the queues (say, 4 queues, 64/4 per queue), or that Tx
> simply ignores the budget? Or both?

For instance, having ixgbe_poll() doing :

return min(work_done, budget - 1);

is quite interesting. It could hide bugs like :

I got a budget of 4, and processed 9999 packets because my maths have a bug,
but make sure to pretend we processed 3 packets...


> 
>> There are reasons we want to control the budget from callers,
>> if you want bigger budget just increase it instead of using your own ?
>>
>> I would rather use a generic patch.
>>
> 
> Hmm, so a configurable NAPI budget for, say, the AF_XDP enabled
> queues/NAPIs? Am I reading that correct? (Note that this is *only* for
> the AF_XDP enabled queues.)
> 
> I'll try to rework this to something more palatable.
> 
> 
> Thanks,
> Björn
> 
>
