Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C69B66A763
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 01:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjANAL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 19:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjANAL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 19:11:27 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1C88CBF9
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 16:11:26 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id z9-20020a17090a468900b00226b6e7aeeaso25974051pjf.1
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 16:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CgtcUKZ2/vUQ/+ob7Fjkp4c27whm3sNcY2UdtGm5o1w=;
        b=AcpqYHDIoRRfKxSPb2NIUDjO5R23PN+JITewKDlXcCQi1c2kVp1M9kuVd1HD+TLm5G
         OgcyYnysJYrKHi6RPtY19ariBcDhfAm1rVKXxzgC7MtTxRgDANnZO1v5nN/YrDqbTCp5
         jvZqt8e7suQDV4gTR9EixIcx+Yvm+q+9xHRWPbyHVOxRQmS4m5a/FtuaQu0jzaveTjQy
         UxtO+c5mM9tyQ2Fgt/scG48V/rQvYjlY5qTw3gI7XUzPKSDnKufsSCd5P/li1L652NJN
         WGSWZ8L2GMq5dbsCQE5y2H+U06huFv6Kh11D4LOtJmLFbfOT21VABvw9lG78lSzxOD8i
         uotg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CgtcUKZ2/vUQ/+ob7Fjkp4c27whm3sNcY2UdtGm5o1w=;
        b=oFOitrofMJM0tEngVDaef2aVH8AAtjtEdG1ryBqiDZ9yn9IJPHThtWsumDL3tkW0Si
         7G+PgYIRMR1T0OUU37G4/KMbeo7rox8AMCS68cjGEOdF8rTxLGeIH6GsZNf7R6uG6i+8
         RY6LpfEVzF2AVqfV0orNt4JFUZrzQ0GaXnzT2N3m1WTNVQYiYXpQiCf7AxG7O+U23ri5
         hSAJ5HBhYp8G6aG93hQGWeOqT7ULuuqJfcV0wIE42jqPAgz07Ef27LGB0e5r2VXhgInN
         htcGtREnIPmu1cZwZ5Bpv4ZARDbTW0mKI1zehFQfikaLKTo4/I+/EqNR1W7bpKG/Zj3x
         hbVw==
X-Gm-Message-State: AFqh2kqwXJ3OvNuSzxUTe4b1WlCHaWgqUJDGJPjpHxNtZBJTINBiiDS7
        DH0InF2gIE9zCNIzrCVGngM=
X-Google-Smtp-Source: AMrXdXsSLVmWGO5FrFvxQqX+rSgsKHUoWGG4HzmcImJZCGMCQgq645ydZhM3Op21FRHQcTEr3xQZNA==
X-Received: by 2002:a17:902:bc86:b0:192:721d:6f0a with SMTP id bb6-20020a170902bc8600b00192721d6f0amr61619082plb.60.1673655085541;
        Fri, 13 Jan 2023 16:11:25 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id e6-20020a17090301c600b00192dda430ddsm14677349plh.123.2023.01.13.16.11.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 16:11:24 -0800 (PST)
Message-ID: <ad1e1ce2-edf0-cde8-4279-59efc585ea7d@gmail.com>
Date:   Fri, 13 Jan 2023 16:11:23 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH ethtool 1/3] misc: Fix build with kernel headers < v4.11
Content-Language: en-US
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Markus Mayer <mmayer@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <20230113233148.235543-1-f.fainelli@gmail.com>
 <20230113233148.235543-2-f.fainelli@gmail.com>
 <20230113235738.wyaf3rg63olkwixw@lion.mk-sys.cz>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230113235738.wyaf3rg63olkwixw@lion.mk-sys.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/13/2023 3:57 PM, Michal Kubecek wrote:
> On Fri, Jan 13, 2023 at 03:31:46PM -0800, Florian Fainelli wrote:
>> Not all toolchain kernel headers may contain upstream commit
>> 2618be7dccf8739b89e1906b64bd8d551af351e6 ("uapi: fix linux/if.h
>> userspace compilation errors") which is included in v4.11 and onwards.
>> Err on the side of caution by including sys/socket.h ahead of including
>> linux/if.h.
>>
>> Fixes: 1fa60003a8b8 ("misc: header includes cleanup")
>> Reported-by: Markus Mayer <mmayer@broadcom.com>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>   internal.h | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/internal.h b/internal.h
>> index b80f77afa4c0..f7aaaf5229f4 100644
>> --- a/internal.h
>> +++ b/internal.h
>> @@ -21,6 +21,7 @@
>>   #include <unistd.h>
>>   #include <endian.h>
>>   #include <sys/ioctl.h>
>> +#include <sys/socket.h>
>>   #include <linux/if.h>
>>   
>>   #include "json_writer.h"
> 
> No objection but I wonder if it wouldn't make sense to add linux/if.h to
> the header copies in uapi/ instead as then we could also drop the
> fallback definition of ALTIFNAMSIZ and perhaps more similar hacks.

Humm, I wondered about that but it seems like opening a possible can of 
worms as the history of include/uapi/linux/if.h changed across multiple 
versions. As long as it does compile, why not :)
-- 
Florian
