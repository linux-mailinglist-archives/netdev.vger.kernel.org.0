Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619412A9E8C
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 21:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgKFUZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 15:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728237AbgKFUZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 15:25:23 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E6AC0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 12:25:23 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id o11so2771946ioo.11
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 12:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7NR9QiFYySIFJLA+EZpoPTRYNeDJVq7JXlgdpLtMXnU=;
        b=PZpLW9oOwf0TH3dF9AzGNxTrXH+UsGKrMwaplXTdrneZ/++/vIa26AUYxDtiRdmYH4
         R+ImlNHH6nbpHoXjXfkfjhS1f0cfgdezo0SVSYnIg6FPgxxjaWS9Xrvln4XgeCR2ma0J
         UouFKSc9WmIuG1Q9xk9IAum4z+FchbMChP0aWhxBJBloVGz6EmLPuP+Rry7/oqgsY35P
         lQvLwDDtZCtGzNdNxhYRlfSlT2/0RqDbUqLNAMewUMC98fmCezxrWAfaz+Trupt7+7lf
         f7QP/PCPlShfgl2fVy/loBeNdYlznuU3rAYru1fCqG36od/aLJgZHNV7fOxjggGm9kOC
         SoTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7NR9QiFYySIFJLA+EZpoPTRYNeDJVq7JXlgdpLtMXnU=;
        b=NLGbs9rPFobAyEKUZsL6UQn9DRRcn1vxxTMZR7SO15RdQsvMqSaWuq32Cd24Tumz9Y
         H40rzoFBG2J/jC2/xLnD8+jDaTH52x1nzI9LXOe7rNkxLOfH5AZ169ONdnwwiCF7C0mj
         Yw+OosxRfREw0jwcwkIsaBOvx5q3bGfpDKDYsHdc0+AocZlarbwNSIr3vP6aUlFw+CKR
         CxDPjCgq6GMhhUI3q4mc7TYCQZqAsCcjevDA12qQ5ySop5vdXOr8fIhf843o5SabfpIQ
         lmLqr+scPwGnG+l4LbxOpJS7SOLNMPdqJlkxwQmkBBpWACh8owNXqIihhwkt9sPbHNHS
         dscQ==
X-Gm-Message-State: AOAM532o2mIEgM6tPmTnazmdVwuQZqxqgPn0TBHZ18HtuX7l8iEbjcmJ
        cSoM+9MPZwPlQ7jaSwOuNCQ=
X-Google-Smtp-Source: ABdhPJwKXVuegbwOM87rQuy4dMDoWWMH+amREGfNpS2tP9TCqeFdQmhx+X3i3eOhk4tceLLYCP7U6A==
X-Received: by 2002:a05:6602:1682:: with SMTP id s2mr2816435iow.174.1604694322277;
        Fri, 06 Nov 2020 12:25:22 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:59f:e9df:76ab:8876])
        by smtp.googlemail.com with ESMTPSA id v88sm1621014ila.71.2020.11.06.12.25.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 12:25:21 -0800 (PST)
Subject: Re: [PATCH iproute2-next] tc: implement support for action terse dump
To:     Vlad Buslov <vlad@buslov.dev>, Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        davem@davemloft.net, kuba@kernel.org, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
References: <20201031201644.247605-1-vlad@buslov.dev>
 <20201031202522.247924-1-vlad@buslov.dev>
 <ddd99541-204c-1b29-266f-2d7f4489d403@gmail.com> <87wnz25vir.fsf@buslov.dev>
 <178bdf87-8513-625f-1b2e-79ad435bcdf3@mojatatu.com>
 <87y2je9tya.fsf@buslov.dev>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0599db33-3821-dc78-95da-4814fbbb877a@gmail.com>
Date:   Fri, 6 Nov 2020 13:25:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <87y2je9tya.fsf@buslov.dev>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/6/20 12:16 PM, Vlad Buslov wrote:
>>>
>>
>> Its unfortunate that the TCA_ prefix ended being used for both filters
>> and actions. Since we only have a couple of flags maybe it is not too
>> late to have a prefix TCAA_ ? For existing flags something like a
>> #define TCAA_FLAG_LARGE_DUMP_ON TCA_FLAG_LARGE_DUMP_ON
>> in the uapi header will help. Of course that would be a separate
>> patch which will require conversion code in both the kernel and user
>> space.
> 
> I can send a followup patch, assuming David is satisfied with proposed
> change.
> 

fine with me.

