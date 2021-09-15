Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F275740C31C
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 11:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237347AbhIOJ5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 05:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237143AbhIOJ5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 05:57:13 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35862C061574
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 02:55:54 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id u18so1168555wrg.5
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 02:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c1sf0/1mcZTWdyxEXP2zz618As7EK+qJFKluW925BgI=;
        b=A3foMSx3XrHQNmRKuzUCoZrgid1HDF9jcSGE3IWS3wqFYx1a24tnVDcJOJy9Daagcu
         fAE3Ozm6xLnpsXdKBIZslpcdaH1Z+0wtPI/Jba6FiFmYRtmwPxK2siawgqW3o3q/ip7j
         WQd619UYNwRHw+Hehyi+e2wjzlGV8+XeySk+wUhwSjQpT9iTUz0faHqKNtJAFol63oCc
         EqceHRtxLlA6GCN/kEefeLoxZc7DnEYuqheiQEK3/azyuC2NQwKYgjANLC4q2Bn97H49
         ifMLTQmQvSc2vxi5jmaTz55+aO33QNJakYN914juYcV9hx9yQSEpMg+A1NHl588jllgM
         v0xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=c1sf0/1mcZTWdyxEXP2zz618As7EK+qJFKluW925BgI=;
        b=DhVkDwqKIDXvLstJyw/2aPDxgN/FWbCpkAyQ9jmmOgC5sRgDTwVlJFZn7t//7u3/1A
         7f4TO7bbVWHMVCAE5GeRzF9s8icP/06kqUAH6mzFPOJOYBJGvWLImyWHA2zFRlt2/+DS
         2NnrUpTfUj7t227r0f3nWIPrWeoHB7OVyWBB/qqZoYWTTJ1bvbk1A9w8Ut7UoSnB3inr
         YxQAI2iX/Cw099zUC+Pu47xbRItnCh4Hnbkfh6AwRNppbLMnYIUfTCoR6u6gvwFxngXM
         fEM2bhjBnDc2mRDEJ+4DGJR6nBCqv+9y+cSvFbXLc2DVA4jQ8xxeTT5MkvL7ELVBLfAc
         wwrQ==
X-Gm-Message-State: AOAM532Om8VcvUikTZEoStTx2f93mIZzenmMFo+gzwYQo+t8K4Ihin+H
        D4yZIIN7DyGiBiU9ydLXTbtjOwHhWjbxzQ==
X-Google-Smtp-Source: ABdhPJzH/LvPhBmYM2TkbJwFEkFgBtb3/I99axmMdI8CREeNItY+1FBAp0wLAVyhdaPUCZUFH1VTlQ==
X-Received: by 2002:a05:6000:14d:: with SMTP id r13mr4045590wrx.420.1631699752768;
        Wed, 15 Sep 2021 02:55:52 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:1d48:66d0:d1aa:66a? ([2a01:e0a:410:bb00:1d48:66d0:d1aa:66a])
        by smtp.gmail.com with ESMTPSA id b204sm2473739wmb.3.2021.09.15.02.55.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 02:55:52 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec v3 0/2] xfrm: fix uapi for the default policy
To:     antony.antony@secunet.com
Cc:     steffen.klassert@secunet.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
References: <20210908072341.5647-1-nicolas.dichtel@6wind.com>
 <20210914144635.6850-1-nicolas.dichtel@6wind.com>
 <20210915091908.GA11749@moon.secunet.de>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <4fc337e7-a4c9-7691-cd1b-b1f3494b2ba8@6wind.com>
Date:   Wed, 15 Sep 2021 11:55:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210915091908.GA11749@moon.secunet.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 15/09/2021 à 11:19, Antony Antony a écrit :
> Hi Nicolas,
> 
> On Tue, Sep 14, 2021 at 16:46:32 +0200, Nicolas Dichtel wrote:
>> This feature has just been merged after the last release, thus it's still
>> time to fix the uapi.
>> As stated in the thread, the uapi is based on some magic values (from the
>> userland POV).
> 
> I like your proposal to make uapi 3 different variables, instead of flags.
> 
> This fix leave kernel internal representation as a flags in
> struct netns_xfrm
> 	u8 policy_default;
> 
> I have a concern. If your patch is applied, the uapi and xfrm internal representations would be inconsistant. I think they should be the same in this case.
I agree.

> It would easier to follow the code path.
> On the other hand we should apply this uapi change ASAP, in 5.15 release cycle, to avoid ABI change.
I also agree.

> 
> Could you also change xfrm policy_default to three variables?
Yes, I propose to send a follow up on ipsec-next once this series is applied.
The internal representation could be changed later, I prefer to keep this change
minimal for the ipsec tree.


Thank you,
Nicolas
