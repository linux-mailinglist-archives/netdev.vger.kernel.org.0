Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5A5457580
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 18:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236555AbhKSReX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 12:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236280AbhKSReX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 12:34:23 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A841C061574
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 09:31:21 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id p18so9182654wmq.5
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 09:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9y++1AkXe59892cMl9K31FuzngOwlxJmAcaPwbnI/U8=;
        b=W64vokzom93TL30K5QYY0TbzFXQeTn4OeTMJQAtYWuOVRTQD87s9zXN3b0fdAOr1Z5
         g9u68OJCmJwPcWP+xsCsO6p/8RNRmf1wM9w0yqoYQl1kkiMsIPT8CkmqT2+xtB3TSU5m
         UrxNr22cJhJweMRdcNe8hM6gSRFuNvB2MSkYj/zjiG6HuN0WG8GyaeLvOF2z6JdfX1O+
         16OQ5GkHHABrnAhJr8dJdGeC1BE5KR+FnnHX/xTiggztbI33oshhhD6PUvt/X8UNsUmg
         uSREdtdiAdNol1Dh8ItKNKXnT1HZ3zQ9uRvjqDB/HrD/FSv1eWBZCWGKatkpI3M/Dkx5
         lNEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=9y++1AkXe59892cMl9K31FuzngOwlxJmAcaPwbnI/U8=;
        b=xHL4e68ItB4hjgxqOg59EMdvYrlkB9tqCphMoH4g4SyrUBhBiagLG9yWVhb2XEDqzv
         syR8e5MTr4yspkFQEKjLePSHCUD3UBbjE1TYDqEmB3e5N0FcPykLEB4ImKuULZC15GGt
         3pG/4X1jdfdHk3yq4hFD5yHorKbHG4I78Vfk1Dbul+JO1S5Ifns9XSrq53y5ucLl+9lO
         u9hlassrwywrYUqcoCiwfFP1+qJK5fFsZ5livk9JndxOKydk+i/bFeMoSvKdgpJ5XcB7
         fVEN2C9dBgQUKjSKg0/6oOj7d4ncOmNceijFnDVC0z6Q2susrTkoAA5/fm1SdLp9VdUV
         /bjw==
X-Gm-Message-State: AOAM532+1PitwZjyewJXlPLfkGHKYFjFUyQXESIrHZJgA/y9F2J3eK+Z
        xRulGWk/euz8Zodg8JEP8DitbOzx39dwRQ==
X-Google-Smtp-Source: ABdhPJzhBmg4sd+qCN9D9fDp8l154zziEqeKMTm0BEOB4OwB8VC577qVqhQPF165zFJwQUqndu2uPw==
X-Received: by 2002:a05:600c:2297:: with SMTP id 23mr1569477wmf.73.1637343079647;
        Fri, 19 Nov 2021 09:31:19 -0800 (PST)
Received: from ?IPv6:2a01:e0a:b41:c160:28cf:7e86:cefd:55f9? ([2a01:e0a:b41:c160:28cf:7e86:cefd:55f9])
        by smtp.gmail.com with ESMTPSA id l22sm247214wmp.34.2021.11.19.09.31.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 09:31:19 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next] xfrm: rework default policy structure
To:     Leon Romanovsky <leon@kernel.org>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        antony.antony@secunet.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
References: <20211118142937.5425-1-nicolas.dichtel@6wind.com>
 <YZak297hPRh3Etun@unreal> <e724c80c-8b4f-4399-e716-1866d992a4f2@6wind.com>
 <YZfFnZIUsZnX1bu+@unreal>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <81eadf5e-7d2b-b7f8-513f-2212272f5897@6wind.com>
Date:   Fri, 19 Nov 2021 18:31:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YZfFnZIUsZnX1bu+@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 19/11/2021 à 16:41, Leon Romanovsky a écrit :
[snip]
>> What about:
>>
>> static inline bool __xfrm_check_nopolicy(struct net *net, struct sk_buff *skb,
>>                                          int dir)
>> {
>>         if (!net->xfrm.policy_count[dir] && !secpath_exists(skb))
>>                 return net->xfrm.policy_default[dir] == XFRM_USERPOLICY_ACCEPT;
>>
>>         return false;
>> }
> 
> It is much better, just extra "!" is not in place.
Ok, I will send a v2 with that.

> if (!net->xfrm.policy_count[dir] ... -> if (net->xfrm.policy_count[dir] ...
Hmm, are you sure?
If "there is no policy configured" and "there is no secpath"
  then "return the default policy"

The original statement is:
       if (xfrm_default_allow(net, dir))
               return (!net->xfrm.policy_count[dir] && !secpath_exists(skb)) ||
                      (skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY)) ||
                      __xfrm_policy_check(sk, ndir, skb, family);

Thank you,
Nicolas
