Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C70446912C
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 09:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238887AbhLFIKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 03:10:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238716AbhLFIKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 03:10:43 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA75C0613F8
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 00:07:14 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id u17so13281780wrt.3
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 00:07:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uyMgSFAcYTBzRZ9yQ8+SG70+xKbyUuIEf899sxoxrUY=;
        b=jQg8kGhxNhQAeGmizE5KnIzwMGFVAgPWRl2yiQcbZ3LLbH+cWD53yC1mXUxDj5PExp
         BWZ4lzauw+2g4C+yYIqzgcfvNOOJ0Y4+UFuAUdsBpkR2TvYSEwwLgu3hXmVweGGFru60
         9lJjhnSk3lwNN512rp/y1pNzbl5/mwxrT4mE3E012+KyFHR7O345YpPFhgnJueWJv2LN
         xkiNuHaSIWMHDZ8mSCoPQfksgfHG9M9br5cwvZ3HLniKLOdFC0kpcM6N09r1U8iJkre4
         Kw2h3SGaX9YSG/vkcd4c7UP3/ltTIWF/DNcdT9aeixHXfbwR630Jynp4y18qTKO+tqY+
         eDJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=uyMgSFAcYTBzRZ9yQ8+SG70+xKbyUuIEf899sxoxrUY=;
        b=l9UMuCp15Mudex3nBsL7TCaH+TZVYo2je5CwZEnv408ubfOAdYVky1vlbIafGBkGgo
         XwZlHezYaPegEs4pVb6fiOJtzh4k+o8bO+zVXI/7vcqCeX1XA7X6IHmCKLIHUxUZMt8E
         JknYdUtpFFPShEGXPW5PxJdohyV+FVNGpzgOF0jertI66CrIpxBnEHakiFHAjiRHb84w
         G1AUVWSjhVXRTBXfsbjBAw5TLmc+sTeGuuozCEOVQZu3l+wm5NtEdxI/RQcHCUhLOwpq
         M86HuDE7l7jw0+oElXDuq1ofzJ4MrI7BmPJwOT1FuAeybMM12LoEGkhPz3n16d4wJ0A8
         HH6g==
X-Gm-Message-State: AOAM532tRg2wGjH/6PuOmMP/7Zy6yfhusXj/129zyWXCEayCoqYBIcbx
        mrxE2zfL2n2GcG5SVFBtnTU8eg==
X-Google-Smtp-Source: ABdhPJz5rZ/vPeTMi3WNQHnf+jjysz/NuttXvntXi4C5NKJhbXDRNn9vNBC7Hi/oEqFNBEkZNav4Sg==
X-Received: by 2002:a05:6000:18a3:: with SMTP id b3mr41767515wri.343.1638778033336;
        Mon, 06 Dec 2021 00:07:13 -0800 (PST)
Received: from ?IPv6:2a01:e0a:b41:c160:4164:4f64:6e9c:dacc? ([2a01:e0a:b41:c160:4164:4f64:6e9c:dacc])
        by smtp.gmail.com with ESMTPSA id 138sm13008717wma.17.2021.12.06.00.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 00:07:12 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v4] rtnetlink: Support fine-grained netdevice
 bulk deletion
To:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, dsahern@gmail.com
References: <20211202174502.28903-1-lschlesinger@drivenets.com>
 <YayL/7d/hm3TYjtV@shredder> <20211205121059.btshgxt7s7hfnmtr@kgollan-pc>
 <YazDh1HkLBM4BiCW@shredder> <20211205150531.hy4rv7mtgau37xe2@kgollan-pc>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <8bbc2f92-df95-d1ca-1f5b-d86757baa018@6wind.com>
Date:   Mon, 6 Dec 2021 09:07:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211205150531.hy4rv7mtgau37xe2@kgollan-pc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 05/12/2021 à 16:05, Lahav Schlesinger a écrit :
[snip]
>> In your specific case, it is quite useless for the kernel to generate
>> 16k notifications when moving the netdevs to a group since the entire
>> reason they are moved to a group is so that they could be deleted in a
>> batch.
>>
>> I assume that there are other use cases where having the kernel suppress
>> notifications can be useful. Did you consider adding such a flag to the
>> request? I think such a mechanism is more generic/useful than an ad-hoc
>> API to delete a list of netdevs and should allow you to utilize the
>> existing group deletion mechanism.
> 
> I think having an API to suppress kernel notifications will be abused by
> userspace and introduce hard-to-debug bugs, e.g. some program will
> incorrectly set this flag when it shouldn't (on the premise that this
> flag will "make things faster") and inadvertently break other programs
> that depend on the notifications to function.
+1
