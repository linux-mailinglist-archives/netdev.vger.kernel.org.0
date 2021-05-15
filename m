Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FB9381A80
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 20:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbhEOS1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 14:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234129AbhEOS13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 14:27:29 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A975C061573;
        Sat, 15 May 2021 11:26:14 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 36-20020a9d0ba70000b02902e0a0a8fe36so2117603oth.8;
        Sat, 15 May 2021 11:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S376awGs1PSN7XCaUV5tGMxtWL1fWe0t3DBP6gMiSSM=;
        b=c+qu5AJ5k+7+xLLuPujOU5pOAuZB6wwLaPwpD/Pm9c13mMEqbHjXrSxOJXEn4eKgAf
         iL25cFstqqcbRwex0hM3GDUOssFJiPmSq1kaUdKF2MzuchStdfKjHOY7ngzXj/glvOMF
         1OAx1/WNAJQc55jAQhOTR4CGVqcxxUtKA0dloKkKTfL3jBBcB/z/dHiaQ6kztXyy2iOM
         ArJA1BSc4EMJExy4L0ZhyT1Uj+WG445w5xE8Z6dW5GHPmkOz0ht5ZBkSdmwXWzZmaXqM
         lwyhwO4QGjERzbQLj4vCnDJ9UllzgpdxlkBLjRtazslmp8VFg67iWHW6V7dA+9Xbd7Nh
         dREg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S376awGs1PSN7XCaUV5tGMxtWL1fWe0t3DBP6gMiSSM=;
        b=kf1tr6Rals+jGr7vT1SYutksvJHFMHor+rXjaXctkzQcH/bwcoCrTH3qgef07uN7rv
         oU4cwt4bo0p20K7MPTGQFJi796ngQxQkURLzxqQOefCCQof7WdEWWFICa+OrzS3drtgX
         zGT81qZAYGvSaQ4nIwfrLuivzmxzNnOW3gL94g7nHsJo0TQNkFFch9Gr2+vionmHqFXs
         KCzjCl5loAc69HToGuis3UY1LbqY19DV0GzONUhi6x9ppgEl5/lOCpEC9I0QZR1WfDG2
         JwEhi9v1KfIkhBq5N2M+nTj/BAH/GIZM8doM6LvLr9qE0UJV3ayx3Gw2YW+qfX35Y+Sa
         +b2g==
X-Gm-Message-State: AOAM531MJKcLLVGCCk9IcSAM8nSbUAIOsRN22XRJW50qkJdaCZ0QzjLF
        ZxZQzc7TezvyIAdz4o/XJiM=
X-Google-Smtp-Source: ABdhPJz1qN1p48wRn3plrxq+LP/YT4GAA9vAAVZR6bFl/YFNklNUbPT1kYCYO8iXAYZMbaDC704pVw==
X-Received: by 2002:a9d:411c:: with SMTP id o28mr15518863ote.245.1621103174030;
        Sat, 15 May 2021 11:26:14 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id g11sm1866211oif.27.2021.05.15.11.26.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 May 2021 11:26:13 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3] lib/fs: fix issue when
 {name,open}_to_handle_at() is not implemented
To:     Petr Vorel <petr.vorel@gmail.com>
Cc:     Heiko Thiery <heiko.thiery@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephen@networkplumber.org,
        Dmitry Yakunin <zeil@yandex-team.ru>
References: <20210508064925.8045-1-heiko.thiery@gmail.com>
 <6ba0adf4-5177-c50a-e921-bee898e3fdb9@gmail.com>
 <CAEyMn7a4Z3U-fUvFLcWmPW3hf-x6LfcTi8BZrcDfhhFF0_9=ow@mail.gmail.com>
 <YJ5rJbdEc2OWemu+@pevik> <82c9159f-0644-40af-fb4c-cc8507456719@gmail.com>
 <YJ/+C+FVEIRnnJBq@pevik>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a20600f9-25e0-c2e4-079e-9aca1178e409@gmail.com>
Date:   Sat, 15 May 2021 12:26:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YJ/+C+FVEIRnnJBq@pevik>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/15/21 10:59 AM, Petr Vorel wrote:
> Hi David,
>> On 5/14/21 6:20 AM, Petr Vorel wrote:
> 
>>>>> This causes compile failures if anyone is reusing a tree. It would be
>>>>> good to require config.mk to be updated if configure is newer.
>>>> Do you mean the config.mk should have a dependency to configure in the
>>>> Makefile? Wouldn't that be better as a separate patch?
>>> I guess it should be a separate patch. I'm surprised it wasn't needed before.
> 
> 
> 
>> yes, it should be a separate patch, but it needs to precede this one.
> 
>> This worked for me last weekend; I'll send it when I get a chance.
> 
>> diff --git a/Makefile b/Makefile
>> index 19bd163e2e04..5bc11477ab7a 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -60,7 +60,7 @@ SUBDIRS=lib ip tc bridge misc netem genl tipc devlink
>> rdma dcb man vdpa
>>  LIBNETLINK=../lib/libutil.a ../lib/libnetlink.a
>>  LDLIBS += $(LIBNETLINK)
> 
>> -all: config.mk
>> +all: config
>>         @set -e; \
>>         for i in $(SUBDIRS); \
>>         do echo; echo $$i; $(MAKE) -C $$i; done
>> @@ -80,8 +80,10 @@ all: config.mk
>>         @echo "Make Arguments:"
>>         @echo " V=[0|1]             - set build verbosity level"
> 
>> -config.mk:
>> -       sh configure $(KERNEL_INCLUDE)
>> +config:
>> +       @if [ ! -f config.mk -o configure -nt config.mk ]; then \
>> +               sh configure $(KERNEL_INCLUDE); \
>> +       fi
> 
>>  install: all
>>         install -m 0755 -d $(DESTDIR)$(SBINDIR)
> 
> Thanks a lot, please send it.
> 
> I know this is only a fragment, but:
> Reviewed-by: Petr Vorel <petr.vorel@gmail.com>
> 
> -nt is supported by dash and busybox sh.
> 

That helps. My concern was all the sh variants.
