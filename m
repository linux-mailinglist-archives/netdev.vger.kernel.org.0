Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0544F9F98
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 00:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbiDHWck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 18:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239968AbiDHWci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 18:32:38 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AEDB97BA4;
        Fri,  8 Apr 2022 15:30:32 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id c24-20020a9d6c98000000b005e6b7c0a8a8so3592304otr.2;
        Fri, 08 Apr 2022 15:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4D8qTUklAEU1Yxn4e8QNJnRlkiWhCNSeqaSpIz0yIKI=;
        b=FjPOPNJuMxe8hDrsRq0RYn6XWBkbA7x1DAwE29B4iAkPQ7Ap5Y31P14H9Zzm3wlvuQ
         cofMjGZ+by66sYbnN4TAWvBzZ/5zDrhTaMaZ/wAGdAzeJxByVOLb9I+zfA9QQZrZjOay
         HKvHNG+kEq9q5pRSYECjWl1lm3VQM6wx7IQlOesm6tlRopn0Sq8UFPNnEkFZ0QmZufnS
         X/CIRFynxF1yTWIAQWtY45Mc4TJiAV7ivm3brqapMIC3pSV4TwPH1jidLfs6KEXgCxf7
         ae6GoRSMqURzaMBWP4Ga83gbkek4+YqsFGjaYfeI7K6qEi0K4882hTfl8yXLYJCD42qi
         A4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4D8qTUklAEU1Yxn4e8QNJnRlkiWhCNSeqaSpIz0yIKI=;
        b=tQWVg8CfeoiClrdYkIij4Mqn3dPYQCbNpZFHis8sSqMSTFJB5wS9zSpWvdiEocf+lC
         y48fw8ssQSJ4A3w8aT/qD1idEtKV3oA7rGsw+c/ptldxQmNIMFJWtOJN9zWwPgvJulFF
         mv3t8ZLSzTjC8ky6w0KDiLKI/+Ur/wUqFCojws+hdO6pt+v//syaI3Z/9V8x7EmvSp4A
         OzlIBuOMYL9YKscfeL2NZEWsKWNlrXlwYjTjiyF69sdL6utIYMbHPZk9mwpebfCNiV+D
         gU3IskuFRf9GVDVHbgHhLqG9+CMTRuCOxXmfDmtYlgh6/TzCA6eRDWxqiZYKJKKUkh1m
         ct0w==
X-Gm-Message-State: AOAM530kUaSStYJ/bRsE+28OIZz5hnA2DdWyS6xCPmf+62b1w3dhioQT
        rOOYB5HsbYGjBgZYKzdjEQQ=
X-Google-Smtp-Source: ABdhPJxTIWAwbq4xtUFZlmEeBWKWQTOzRcWZVjrAhnTudh/qJIPOpGFfRQWSxch3z2IYVypAAV0JlQ==
X-Received: by 2002:a9d:69c4:0:b0:5b2:3abb:612a with SMTP id v4-20020a9d69c4000000b005b23abb612amr7433425oto.319.1649457031506;
        Fri, 08 Apr 2022 15:30:31 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i67-20020acaea46000000b002efa121b127sm9092586oih.46.2022.04.08.15.30.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 15:30:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <4d47bc62-89be-048d-5295-a35c3c748995@roeck-us.net>
Date:   Fri, 8 Apr 2022 15:30:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH] iwlwifi: iwl-dbg: Use del_timer_sync() before freeing
Content-Language: en-US
To:     "Coelho, Luciano" <luciano.coelho@intel.com>,
        "Greenman, Gregory" <gregory.greenman@intel.com>
Cc:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20220406153410.1899768-1-linux@roeck-us.net>
 <5b361192-6fd4-e84d-d6fc-e552a473c23e@roeck-us.net>
 <f233cb842303e121338e2d881eec88762068d324.camel@intel.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <f233cb842303e121338e2d881eec88762068d324.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luca,

On 4/7/22 22:20, Coelho, Luciano wrote:
> On Thu, 2022-04-07 at 12:50 -0700, Guenter Roeck wrote:
>> Hi,
>>
>> On 4/6/22 08:34, Guenter Roeck wrote:
>>> In Chrome OS, a large number of crashes is observed due to corrupted timer
>>> lists. Steven Rostedt pointed out that this usually happens when a timer
>>> is freed while still active, and that the problem is often triggered
>>> by code calling del_timer() instead of del_timer_sync() just before
>>> freeing.
>>>
>>> Steven also identified the iwlwifi driver as one of the possible culprits
>>> since it does exactly that.
>>>
>>> Reported-by: Steven Rostedt <rostedt@goodmis.org>
>>> Cc: Steven Rostedt <rostedt@goodmis.org>
>>> Cc: Shahar S Matityahu <shahar.s.matityahu@intel.com>
>>> Cc: Johannes Berg <johannes.berg@intel.com>
>>> Fixes: 60e8abd9d3e91 ("iwlwifi: dbg_ini: add periodic trigger new API support")
>>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>>> ---
>>> RFC:
>>>       Maybe there was a reason to use del_timer() instead of del_timer_sync().
>>>       Also, I am not sure if the change is sufficient since I don't see any
>>>       obvious locking that would prevent timers from being added and then
>>>       modified in iwl_dbg_tlv_set_periodic_trigs() while being removed in
>>>       iwl_dbg_tlv_del_timers().
>>>
>>
>> I prepared a new version of this patch, introducing a mutex to protect changes
>> to periodic_trig_list. I'd like to get some feedback before sending it out,
>> though, so I'll wait until next week before sending it.
>>
>> If you have any feedback/thoughts/comments, please let me know.
> 
> Hi Guenter,
> 
> Thanks for your proposal!
> 
> I recently moved from the Intel WiFi team to the Graphics team, so I'm
> adding Gregory, who has taken over my duties, to the discussion.
> 
> I don't recall any specific reasons for using del_timer() instead of
> del_timer_sync() here.  So your patch does look correct to me.
> 

Thanks a lot for the feedback. I spent some time trying to determine
if a mutex to protect the periodic timer list is needed, but concluded
that it is not necessary because the code adding the timer list and
the code removing it are never executed in parallel. Of course,
I may be missing something, so I'd be happy to be corrected.

Thanks,
Guenter
