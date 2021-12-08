Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFE746CE78
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 08:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236272AbhLHHrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 02:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbhLHHrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 02:47:41 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E98C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 23:44:09 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id t18so2426048wrg.11
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 23:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jPmDFgfOqPwd3O8DAmAOI8ZrCYRkJbAVcPPzPlyA62c=;
        b=Pz7Fj5iDNqiFRi5lVMMOGgvDpyD24yydURRId1qw5+2pybSiBXjD+/NPx1mjRcIW6A
         uOWiSlwt95+GwtTTVM7NJJFQo6PhHHES9HA/iR6B4c2L954v8IxMsoM9ul+KrE0xZqPr
         9GisLD2voNMa363IuaLx5Gp3iiiZamu8gPARYP6cXx0FgONVcftMx7KktWuc+zgAYmf0
         ioJRZJ5ZzKoIwX9wFMU3HGWZ+U+h5s1YG/KLO3HMPUvRKPPPBYxK/b+qBdqcoBqvhP5o
         ctyEHsZLuQz+ROBWUzRx6lbhOtWSONk9BsZ74s3xH2JSr8IfQY/4BWEdZrBz5QBX6qqE
         3Mvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=jPmDFgfOqPwd3O8DAmAOI8ZrCYRkJbAVcPPzPlyA62c=;
        b=0zhRGJq+MDmaIvsN1n+JA82RV/N3K0spLrLuOtOwPorYve5Y0aCrMXH12vWtDtiB9W
         rOoY56Nz1Tr2+mVNtRY45/yDCdhYsa+ucC6ypr/WFTgUFBdq7FaSiKHlZ+hnCtMZvTi5
         5ywyxPA+5TKMuSIa9jN5i3r8GxtUgoIK1r5eGmWr6B+hO3EzTM0R7MD1+qkCtM77V0/k
         AYCBT9Sc2nRAiZw2dLwrHlf8Do5Xc3Hifc5n4MPhVJGGkCPug948wplI82FU6X4MGxyZ
         lxRGHI9EzDD1f0XKQI1ey+g92uyO1gqpv+fJkdDoQEWUEJZGBE3FN0SjC+C7M+1bjOyT
         aCrA==
X-Gm-Message-State: AOAM531Sjh+MKf59nV1octi5jWHfib6QBUp7EcVj09jqaE0sEb2Lgdxr
        si67ZzFVodSY7ZO1Ww3uINwAYA==
X-Google-Smtp-Source: ABdhPJzpui5U3KZ0N1HblTgb/jCsoGu7DYjdJNtuqiAhOdHKoB43GciTCF38i8ldHHgwBOgtsZZBgQ==
X-Received: by 2002:adf:b34f:: with SMTP id k15mr59880773wrd.125.1638949448360;
        Tue, 07 Dec 2021 23:44:08 -0800 (PST)
Received: from ?IPv6:2a01:e0a:b41:c160:f40f:c5d1:958:e84f? ([2a01:e0a:b41:c160:f40f:c5d1:958:e84f])
        by smtp.gmail.com with ESMTPSA id u23sm2093080wru.21.2021.12.07.23.44.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 23:44:07 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v5] rtnetlink: Support fine-grained netdevice
 bulk deletion
To:     Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, dsahern@gmail.com,
        nikolay@nvidia.com
References: <20211205093658.37107-1-lschlesinger@drivenets.com>
 <84166fe9-37f1-2c99-2caf-c68dcc5a370c@6wind.com>
 <20211207124858.3tpsojcamyxldjb4@kgollan-pc>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <3ab0e65d-5628-567f-cf17-5a717e8ad7f8@6wind.com>
Date:   Wed, 8 Dec 2021 08:44:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211207124858.3tpsojcamyxldjb4@kgollan-pc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 07/12/2021 à 13:48, Lahav Schlesinger a écrit :
> On Mon, Dec 06, 2021 at 09:25:17AM +0100, Nicolas Dichtel wrote:
>> CAUTION: External E-Mail - Use caution with links and attachments
>>
>>
>> Le 05/12/2021 à 10:36, Lahav Schlesinger a écrit :
>> Some comments below, but please, keep the people who replied to previous
>> versions of this patch in cc.
>>
>> [snip]
>>
>>> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
>>> index eebd3894fe89..68fcde9c0c5e 100644
>>> --- a/include/uapi/linux/if_link.h
>>> +++ b/include/uapi/linux/if_link.h
>>> @@ -348,6 +348,7 @@ enum {
>>>       IFLA_PARENT_DEV_NAME,
>>>       IFLA_PARENT_DEV_BUS_NAME,
>>>
>>> +     IFLA_IFINDEX,
>> nit: maybe the previous blank line sit better after this new attribute (and
>> before __IFLA_MAX)?
> 
> Due to the comment above the previous 2 attributes, I think that by
> removing this empty line it can be accidentally thought as if the new
> attribute is part of this "block".
> As for adding a new line before __IFLA_MAX, I wanted to preserve the
> appearance we had before the IFLA_PARENT_DEV_xxx attributes where added,
> where there was no empty line before __IFLA_MAX.
Good point.

> 
> I don't mind either way though, whatever looks better to you.
Ok, forget my comment.


Regards,
Nicolas
