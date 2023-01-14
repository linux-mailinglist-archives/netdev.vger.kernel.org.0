Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885CD66A888
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 03:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjANCHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 21:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbjANCHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 21:07:44 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863AF8B52D
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 18:07:43 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id j15so15121185qtv.4
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 18:07:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FVi1lVjOSRmrDqtkC67AuhpqMLG76mIfCfLHycDaLW0=;
        b=fFlNk5VMU/zcmGeJCUb28YNmRdT74Q0PpSgPIfWWM2BJ6499AOsS4sWenrcNTQgbmT
         Lbq/wcD8Ao4UIyZO/U40xbR8znKrRGqRSRwHaNC+6k1CQdsTs6Wd0nwJrZqKgbfLL3fg
         ABIGgaqjhXil36iQ83VTIHO50khW0YoCRi/MO6z8mLyZRgHG6n7u5I0TvnVzbfA2c8FF
         JYCThOvAAdBKZOfqMzbHkJRtXnlI0LxPVwlbUxH1WNH778cBax1ZOtILRW++1OrAbC+3
         7Whakm5N7+pwx4qdz01pOuzovf8lpKV2pyykH+y1C629yPcaPjclMjHWuMEIvVHnw/Hy
         yRDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FVi1lVjOSRmrDqtkC67AuhpqMLG76mIfCfLHycDaLW0=;
        b=SwZqiOIatD+fgF5cuOYumMw9C5Vg+94NljbsZEgQeKJNU5Nskx+mLKGE8AD1hwDHhJ
         KqVoCOXo8S7CpHhCX3/7Amx2ojhY68dvv1aXiRjXD4I8lbHt2KSbE7J59ETIJDpBIZy/
         ageXz/gHmWpnAoGmUC1cCOUJHPpdXV+sCcwTwEUMgklBai30FetUWG90hqqQ+PINNDVl
         D425cPoxLGJ1Eo7xhzRYPwn/pJ8e/XpVcecX5OGWG1IOe/9KfHX3XsguIqOEV+f0HZ8t
         LUIFiCDY4tt+fHIMUZytWZxzWeILo8YRPVlVu4QKNNLQ0QX535t3EdUBF8oQe4rgkGCm
         oKMg==
X-Gm-Message-State: AFqh2kpVjm2JvCVH8n16CQk+wXfi2wYqy32URam964juMAain9kWwIJu
        iPfBBAr058R6mi7JkkTd5+k=
X-Google-Smtp-Source: AMrXdXsnyvGoz1opayYREAgz9iQxWAeHNyB1pAYYhfVZvty1BwujK1lFcjXLm1lyK5Udi6mpf01Uug==
X-Received: by 2002:ac8:1281:0:b0:3a7:ee3d:21b3 with SMTP id y1-20020ac81281000000b003a7ee3d21b3mr25642123qti.0.1673662062580;
        Fri, 13 Jan 2023 18:07:42 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id fv13-20020a05622a4a0d00b003ae189c7454sm7492875qtb.91.2023.01.13.18.07.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 18:07:41 -0800 (PST)
Message-ID: <8896d253-913a-01aa-1b6a-f72aebf715f0@gmail.com>
Date:   Fri, 13 Jan 2023 18:07:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH ethtool 1/3] misc: Fix build with kernel headers < v4.11
Content-Language: en-US
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Markus Mayer <mmayer@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <20230113233148.235543-1-f.fainelli@gmail.com>
 <20230113233148.235543-2-f.fainelli@gmail.com>
 <20230113235738.wyaf3rg63olkwixw@lion.mk-sys.cz>
 <ad1e1ce2-edf0-cde8-4279-59efc585ea7d@gmail.com>
In-Reply-To: <ad1e1ce2-edf0-cde8-4279-59efc585ea7d@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/13/2023 4:11 PM, Florian Fainelli wrote:
> 
> 
> On 1/13/2023 3:57 PM, Michal Kubecek wrote:
>> On Fri, Jan 13, 2023 at 03:31:46PM -0800, Florian Fainelli wrote:
>>> Not all toolchain kernel headers may contain upstream commit
>>> 2618be7dccf8739b89e1906b64bd8d551af351e6 ("uapi: fix linux/if.h
>>> userspace compilation errors") which is included in v4.11 and onwards.
>>> Err on the side of caution by including sys/socket.h ahead of including
>>> linux/if.h.
>>>
>>> Fixes: 1fa60003a8b8 ("misc: header includes cleanup")
>>> Reported-by: Markus Mayer <mmayer@broadcom.com>
>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>> ---
>>>   internal.h | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/internal.h b/internal.h
>>> index b80f77afa4c0..f7aaaf5229f4 100644
>>> --- a/internal.h
>>> +++ b/internal.h
>>> @@ -21,6 +21,7 @@
>>>   #include <unistd.h>
>>>   #include <endian.h>
>>>   #include <sys/ioctl.h>
>>> +#include <sys/socket.h>
>>>   #include <linux/if.h>
>>>   #include "json_writer.h"
>>
>> No objection but I wonder if it wouldn't make sense to add linux/if.h to
>> the header copies in uapi/ instead as then we could also drop the
>> fallback definition of ALTIFNAMSIZ and perhaps more similar hacks.
> 
> Humm, I wondered about that but it seems like opening a possible can of 
> worms as the history of include/uapi/linux/if.h changed across multiple 
> versions. As long as it does compile, why not :)

Just to be clear, I will give that one a shot and let you know how it 
goes, if it works fine, then it will be in v2.
-- 
Florian
