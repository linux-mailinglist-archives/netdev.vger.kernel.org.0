Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478292876BD
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730867AbgJHPJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730854AbgJHPJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:09:17 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B499C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 08:09:17 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id n18so7021658wrs.5
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 08:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oy+y4/BHmibXgcUqENbjlPsY7pAVTgfIL8xv2GwPysU=;
        b=jxQjWL7ZySeHB68avyotxL6RznZCGQvKA9147m/2AkTClG9J+u+8t3caLnAbMZ8ybV
         J1g/ZxOXe2Dr9QYnWJVJTQ/z17TPA5Mm0y048rJV7eCQm3Q1mV7Kj4Ij+tXwYy31WxGt
         +NM2POUpj0oLxmJH2j2hxl6pAcj90/GlCM7SGE0t+kdABx4LcagwPoONLUgPf0Eg34nm
         bzdTaJb/97SFEpiVgmyGhXy+DckrmIXV2phpO6yNKSMosH5iLauq0Jq2djt3iczhLiKf
         zW8PtrxceLQqzDS+o+zOocGuWL31irvznQB8l7s7qpa4DHIrFcT3GdO/ytQG9gD3Cd4v
         b27w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oy+y4/BHmibXgcUqENbjlPsY7pAVTgfIL8xv2GwPysU=;
        b=p4fi0U7DJcbs6j362vnHgTwl/Vi6ot22xYsPE7Q+ipdlm1PuYzQ6JOceDbUZtXjCCv
         aPRnpwp/O2ZLmJSFbPYb82hEabcKP3U9XElPzNy1mD1rZrvhTTRB8mUS2ZXLD5snC3BB
         Q/3LZwNGcVsDXQPJVR5y4f9Oh+emKXo5aCKK/1bSKd+4An8/MnAOJQ8j67UFQm58m69S
         kSV1v//Hk6Toc0X2r7OelJMl37MxtBzBEAPVPBKWPJbXrhTFB6UbkxAaOspFPsz9D/kL
         eSu+dwWPhS0B9Y7uWnxf1CYyGS8mndCYPMYKO7rzkFXza8qmt3Rkc/w9FC6W3bkgUky4
         0DfA==
X-Gm-Message-State: AOAM532o+zsFoTn3qZMor7EzrmhJzXdbGSxSSVrMABk4fmk5hlXyVBeG
        2xKKo85xfW1evvQUcJczsZA=
X-Google-Smtp-Source: ABdhPJwsZsEJXPouCu8dRG9PCpeKjpvr72KQb9TVkH+opcf5Mtrw4fFFv1ufO4udjt5x3IvrDfkFAA==
X-Received: by 2002:a5d:668b:: with SMTP id l11mr9565047wru.89.1602169756051;
        Thu, 08 Oct 2020 08:09:16 -0700 (PDT)
Received: from [192.168.8.147] ([37.165.121.66])
        by smtp.gmail.com with ESMTPSA id k5sm7351851wmb.19.2020.10.08.08.09.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 08:09:15 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/7] ethtool: trim policy tables
To:     Johannes Berg <johannes@sipsolutions.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, jiri@resnulli.us,
        andrew@lunn.ch, mkubecek@suse.cz
References: <20201005220739.2581920-1-kuba@kernel.org>
 <20201005220739.2581920-4-kuba@kernel.org>
 <7d89d3a5-884c-5aba-1248-55f9cbecbd89@gmail.com>
 <11e6b06a5d58fd1a9d108bc9c40b348311b024ba.camel@sipsolutions.net>
 <b81f33293406f7d0bcb45ab502c528442125997b.camel@sipsolutions.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c989c579-01b2-3527-bc57-3f88250ca011@gmail.com>
Date:   Thu, 8 Oct 2020 17:09:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <b81f33293406f7d0bcb45ab502c528442125997b.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/8/20 11:15 AM, Johannes Berg wrote:
> On Thu, 2020-10-08 at 11:13 +0200, Johannes Berg wrote:
> 
>>> This implies that all policy tables must be 'complete'.
> 
> Also, yes they had to be complete already, perhaps *except* for NLA_FLAG
> like this below use ...
> 
>>> So when later strset_parse_request() does :
>>>
>>> req_info->counts_only = tb[ETHTOOL_A_STRSET_COUNTS_ONLY];
>>>
>> Here was the fix
>> https://lore.kernel.org/netdev/20201007125348.a74389e18168.Ieab7a871e27b9698826e75dc9e825e4ddbc852b1@changeid/
> 
> Sorry, wrong link
> 
> https://lore.kernel.org/netdev/20201007125348.a0b250308599.Ie9b429e276d064f28ce12db01fffa430e5c770e0@changeid/
> 
> johannes
> 

SGTM, thanks !
