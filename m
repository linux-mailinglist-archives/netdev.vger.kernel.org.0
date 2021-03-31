Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62FA35038D
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 17:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235605AbhCaPgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 11:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbhCaPgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 11:36:09 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A82C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 08:36:09 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id z15so20391046oic.8
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 08:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PKb2Dw3L+9aiLFno0YG9DA0LN177DlC0BI+f8x134yU=;
        b=pZ4JNxaGjWg46DzsfYCbMxCNoAEIlWOaCvCf21PImzq2RXYgya/wEGB6qSK5dEbT3o
         3Y7Y4oDosT9exhuhyF9ktHEshD0bCfbnR71TAJ9YU+Z87KJrmbfnzi1feXypXb5cAFb1
         Q3GDzSPOs2kwqR1CHe6J+9yuX+dUkFrwOe1KYGP5sWXm7cGCGueS6dHG62DL8JhwSu7X
         wz99algf2Vw8828g3rpVZF2Uo3Swmc/cZiMIVpNz4n9WxIg6+YuWTg9xv2/r7Z23demR
         IFuMfl5kJOKlLzTzRvADAVfrLDFzMfSbmlDRXi6U/gn7XdWB10g7LJGilzLmEWDuv314
         rC6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PKb2Dw3L+9aiLFno0YG9DA0LN177DlC0BI+f8x134yU=;
        b=tpkpkIq9MchA3VRyOKBiaHqK8kM2hsrn4vWFGf8/tYv1wz6lksqmFD0mrd1ZZpO1y8
         EgMY334FJY1gs814o0qnOJ1EEnt7Lbs3vUsGUGt4VSiq6+aa3RdNBT3yHRSNF9bWNSJF
         LTAe9iQBJIC1tA3Stelg0FScUuuPreFi/UPMY9oxg50E/syKVnfW62hmDoLvqDYXhKU8
         QQWUmEaLA/n8xERuWLA2QrSLeLq3ewfkKhQusIvnWHxs6s1+1tLu3a7yRyx4N4cTN/LY
         5V9ATjyQKce7PPqGDUDBS9zwUH9rQKY6Qnz9E7yJpAyd4hLcB5kH6IZa2gJPS/zIHpKb
         jDqA==
X-Gm-Message-State: AOAM5320vRgPEvfn8m0ydobhZXCMYE2geKyY7UCHIRlehjdA8wC0JJQA
        D0Z6j5jaVk9aFwSV/yzoXayWZTxw6gc=
X-Google-Smtp-Source: ABdhPJyPsdJfXH9loMlzTfhgAjsqxJcRu882qfdWS/yupI+w0UvMt6ypf6bjm36hhYLiG24ZwW9lMg==
X-Received: by 2002:aca:ed95:: with SMTP id l143mr2786764oih.110.1617204968252;
        Wed, 31 Mar 2021 08:36:08 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id k24sm489546oic.51.2021.03.31.08.36.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 08:36:07 -0700 (PDT)
Subject: Re: [PATCH] ip-nexthop: support flush by id
To:     Ido Schimmel <idosch@idosch.org>,
        Chunmei Xu <xuchunmei@linux.alibaba.com>
Cc:     netdev@vger.kernel.org
References: <20210331022234.52977-1-xuchunmei@linux.alibaba.com>
 <YGRi0oimvPC/FSRT@shredder.lan>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d2f565b8-f501-2abb-2067-8971ab683bd6@gmail.com>
Date:   Wed, 31 Mar 2021 09:36:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YGRi0oimvPC/FSRT@shredder.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/21 5:53 AM, Ido Schimmel wrote:
>> @@ -124,6 +125,9 @@ static int flush_nexthop(struct nlmsghdr *nlh, void *arg)
>>  	if (tb[NHA_ID])
>>  		id = rta_getattr_u32(tb[NHA_ID]);
>>  
>> +	if (filter.id && filter.id != id)
>> +		return 0;
>> +
>>  	if (id && !delete_nexthop(id))
>>  		filter.flushed++;
>>  
>> @@ -491,7 +495,10 @@ static int ipnh_list_flush(int argc, char **argv, int action)
>>  			NEXT_ARG();
>>  			if (get_unsigned(&id, *argv, 0))
>>  				invarg("invalid id value", *argv);
>> -			return ipnh_get_id(id);
>> +			if (action == IPNH_FLUSH)
>> +				filter.id = id;
>> +			else
>> +				return ipnh_get_id(id);
> 
> I think it's quite weird to ask for a dump of all nexthops only to
> delete a specific one. How about this:

+1

> 
> ```
> diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
> index 0263307c49df..09a3076231aa 100644
> --- a/ip/ipnexthop.c
> +++ b/ip/ipnexthop.c
> @@ -765,8 +765,16 @@ static int ipnh_list_flush(int argc, char **argv, int action)
>                         if (!filter.master)
>                                 invarg("VRF does not exist\n", *argv);
>                 } else if (!strcmp(*argv, "id")) {
> -                       NEXT_ARG();
> -                       return ipnh_get_id(ipnh_parse_id(*argv));
> +                       /* When 'id' is specified with 'flush' / 'list' we do
> +                        * not need to perform a dump.
> +                        */
> +                       if (action == IPNH_LIST) {
> +                               NEXT_ARG();
> +                               return ipnh_get_id(ipnh_parse_id(*argv));
> +                       } else {
> +                               return ipnh_modify(RTM_DELNEXTHOP, 0, argc,
> +                                                  argv);
> +                       }

since delete just needs the id, you could refactor ipnh_modify and
create a ipnh_delete_id.
