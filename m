Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A9B1D7D0B
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 17:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgERPiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 11:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgERPiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 11:38:24 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC432C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 08:38:24 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id 190so10543025qki.1
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 08:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cJlmuygKDYxqbMCP1bPAEqfjwErBtbMYsl/zPNlDzGM=;
        b=RdK5fnELL/l/paVt+j/wPiV5dPTj2AZF8fvKWDB5dT6I0bEAAiTgQyiY7/VqFdpbG+
         CXtwlr2I28HD+cWcwuLXnWpO+YquXxVmegOe/kpmDXGRjRKjeLY5LCgiaP6nlmZWobRA
         bLweRE9cK0tKdFng3n9BubpHNYyKOFwwJd5Y+vob2OcTs2c1OhTjwakK8oDKDalObHT9
         dxi/Ue8PAbWyJozDs7+K7ZImZ8vWO9jG4skpMkyZ+x/dD8fQGssJ9+dAXtK8ogkU32ev
         RzsbhVY86Sxo+DmqPtnE2JKrYdEEiTJWEJEsKsPlKkWkaznzRJYuJ+z0a6QIMvpEO0mL
         jn3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cJlmuygKDYxqbMCP1bPAEqfjwErBtbMYsl/zPNlDzGM=;
        b=DGriMM/3rEbxe7durUXTzMy6ME2fjX6ZHfrT++DG5HgjTaEbm5+rTylU1OOrc1pFUp
         3hWcRhJ2OGfDvmp2e55S+uqJWFDGDBFHMyqze7gYdZtRa9vGt7P2WtuT1hwQ37So0EH1
         iKfP0P8BZ5nCjcOAZznN/o2MdsBM5VBCHKFjTppolxVLIRsa61WPYGcDY3L6c6Yp2wA9
         2zajIvzv4wiezk/MiMlc21uRKJjkrJZ4OmPLeLtsn8QYEEazz1BdvyWZ0TTRsMYOMYPi
         GEoajF5m7bxLTh8SB1VGF0IL3OZHj+RdKP0vem/8YfCGcq1TwzJuTrReghvRqrT6wseB
         s1qA==
X-Gm-Message-State: AOAM532iqf8kBoUA8Nav5BaMZh8keUmwaJrgSCT8E9Z+EJP4ZOBonzsu
        ++ngK3luitVIYzt6UGFxKyI=
X-Google-Smtp-Source: ABdhPJzkdI7/dr7vX9qasrd0cWO1dSs+SFHjr0qFjSDoI/JY4T1Vu5Oy9+x6A8R7hF4fDXKZm0HRlQ==
X-Received: by 2002:a37:a749:: with SMTP id q70mr16120545qke.68.1589816303948;
        Mon, 18 May 2020 08:38:23 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:40b2:61fc:4e6d:6e7b? ([2601:282:803:7700:40b2:61fc:4e6d:6e7b])
        by smtp.googlemail.com with ESMTPSA id 88sm9708036qth.9.2020.05.18.08.38.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 08:38:23 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 1/1] tc: report time an action was first
 used
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Roman Mashak <mrv@mojatatu.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        kernel@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
References: <1589722125-21710-1-git-send-email-mrv@mojatatu.com>
 <1a7ed71e-a169-a583-8e8b-f700d3413a08@mojatatu.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e62b0766-3764-3cab-256c-1b5a0ca75d66@gmail.com>
Date:   Mon, 18 May 2020 09:38:22 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1a7ed71e-a169-a583-8e8b-f700d3413a08@mojatatu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/20 7:10 AM, Jamal Hadi Salim wrote:
> On 2020-05-17 9:28 a.m., Roman Mashak wrote:
>> Have print_tm() dump firstuse value along with install, lastuse
>> and expires.
>>
>> Signed-off-by: Roman Mashak <mrv@mojatatu.com>
>> ---
>>   tc/tc_util.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/tc/tc_util.c b/tc/tc_util.c
>> index 12f865cc71bf..f6aa2ed552a9 100644
>> --- a/tc/tc_util.c
>> +++ b/tc/tc_util.c
>> @@ -760,6 +760,11 @@ void print_tm(FILE *f, const struct tcf_t *tm)
>>           print_uint(PRINT_FP, NULL, " used %u sec",
>>                  (unsigned int)(tm->lastuse/hz));
>>       }
>> +    if (tm->firstuse != 0) {
>> +        print_uint(PRINT_JSON, "first_used", NULL, tm->firstuse);
>> +        print_uint(PRINT_FP, NULL, " firstused %u sec",
>> +               (unsigned int)(tm->firstuse/hz));
>> +    }
> 
> Maybe an else as well to print something like "firstused NEVER"
> or alternatively just print 0 (to be backward compatible on old
> kernels it will never be zero).
> 

existing times do not, so shouldn't this be consistent?
