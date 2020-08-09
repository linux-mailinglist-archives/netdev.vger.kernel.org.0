Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D22E240017
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 23:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgHIVKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 17:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgHIVKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 17:10:11 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6878C061756
        for <netdev@vger.kernel.org>; Sun,  9 Aug 2020 14:10:11 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id d4so3926433pjx.5
        for <netdev@vger.kernel.org>; Sun, 09 Aug 2020 14:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=nCUZ929T/It9QuF42wsQ04SPT1YBEn2ydcir6rS/Mrw=;
        b=eMK3GCzY8nTnRASmgBSGfytFFgXUUiWGNmwp7pvzoqDPllJ+sCie+7YI+lnn0tAjLf
         44CIMf0vLzLsOAcyinVm8PLl5pxJ2m19JBal4v7PPMGBwf+cA5j5H18hnmSOa3UB6zmR
         2uOwLEMx8cP1XSFNzFyGXC6rJxy2IZgNdByPGANtQDYHv7BqDm2RBF0YFmcXOCnfSnLR
         zwCkVHJEap1JIU6Ld4Zimm6g5tHw7ro3WaqG6HX1BO1VtNLSMSN82TP7pMjygFnJRABQ
         01nPaiRjujtIpCI+A0im8NLU2RxYWJpdoVMyIZ8kmhTnxWVAP30y+Lyle7uPJWbZZ81g
         bzOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=nCUZ929T/It9QuF42wsQ04SPT1YBEn2ydcir6rS/Mrw=;
        b=rcqPKXZWTv3LA1rqJDgx7+nEt1Y4L+6huRrSDuPmK/L4njd8eNApoc6XyT99QOURDY
         WrkvCuGekW7G4DcKOCgjdYD0XQfUbyPpJg4ThizLgJIo8iX2RS85Y4m/q+fawY1N2Yzp
         D+yx+awiLgipJ+u7jevSt2pPN5r+0PVjHrE3tzbxUjmP2CcBDU0JQK8zEJoaAN3SLAyh
         mWJdJH4OaI8PyNz7KC8rUz9/T0493ajNWcITjr7JGz3hO0yGXjwOZudgSl9RUSwnz2as
         ZureaPw89xThCuRYao4AAt/CW1jkqJS3bEf4IpkRmiDyb8LJoxJVkpwBZKk89fRGjN+O
         xyog==
X-Gm-Message-State: AOAM531fmfbtuq/PxYTqkfpAFdg3nFSdpY1SUW3KWsLsFtlbkLrnYFAR
        QTFDO/yNtezaJm3gUJNom2JCKlDFHJQ=
X-Google-Smtp-Source: ABdhPJxZh3HUI9U3oGQr4xNdIDixAZZkUsnTC1vgOIHCND961hTp0tOlapQm9A4EP5zGqZEc/8elEg==
X-Received: by 2002:a17:902:a412:: with SMTP id p18mr20946498plq.3.1597007410574;
        Sun, 09 Aug 2020 14:10:10 -0700 (PDT)
Received: from ?IPv6:2001:569:7bc3:ce00:a4b2:4936:f0f6:3eff? (node-1w7jr9qsv51tb41p80xpg7667.ipv6.telus.net. [2001:569:7bc3:ce00:a4b2:4936:f0f6:3eff])
        by smtp.gmail.com with ESMTPSA id r186sm11441196pfr.162.2020.08.09.14.10.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2020 14:10:09 -0700 (PDT)
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
From:   Marc Plumb <lkml.mplumb@gmail.com>
To:     Willy Tarreau <w@1wt.eu>, George Spelvin <lkml@sdf.org>
Cc:     netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, tytso@mit.edu,
        stephen@networkplumber.org, fw@strlen.de
References: <20200808152628.GA27941@SDF.ORG> <20200809065744.GA17668@SDF.ORG>
 <20200809093805.GA7928@1wt.eu>
 <fdbc7d7d-cba2-ef94-9bde-b3ccae0cfaac@gmail.com>
Message-ID: <f7070a63-a028-a754-6aeb-2f9328d2e00e@gmail.com>
Date:   Sun, 9 Aug 2020 14:10:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <fdbc7d7d-cba2-ef94-9bde-b3ccae0cfaac@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Reseending since I accidentally sent it as HTML which the netdev 
mailing list doesn't like)

On 2020-08-09 2:05 p.m., Marc Plumb wrote:
>
> Willy,
>
>
> On 2020-08-07 3:19 p.m., Willy Tarreau wrote:
>>> If I can figure the state out once,
>> Yes but how do you take that as granted ? This state doesn't appear
>> without its noise counterpart, so taking as a prerequisite that you may
>> guess one separately obviously indicates that you then just have to
>> deduce the other, but the point of mixing precisely is that we do not
>> expose individual parts.
>
>
> On 2020-08-09 2:38 a.m., Willy Tarreau wrote:
>> However it keeps the problem that the whole sequence is entirely
>> determined at the moment of reseeding, so if one were to be able to
>> access the state, e.g. using l1tf/spectre/meltdown/whatever, then
>> this state could be used to predict the whole ongoing sequence for
>> the next minute. What some view as a security feature, others will
>> see as a backdoor :-/  That's why I really like the noise approach.
>> Even just the below would significantly harm that capability because
>> that state alone isn't sufficient anymore to pre-compute all future
>> values:
>
>
> So two days ago I was unreasonable for assuming an attacker to could 
> recover the entire state, now you're assuming the same thing? As I 
> said before, if an attacker can recover the complete state, then 
> slowly adding noise doesn't help significantly since an attacker can 
> brute force the noise added (even if a perfect CPRNG is used).
>
> However, I think I'm starting to see your underlying assumptions. 
> You're thinking that raw noise data are the only truly unpredictable 
> thing so you think that adding it is a defense against attacks like 
> foreshadow/spectre/meltdown. You aren't entirely wrong -- if there was 
> a fast noise source then it might be a good option. Just if the noise 
> source is slow, you're just causing far more damage to a far more 
> critical crytpto function to get very little benefit.
>
> If you want to add noise to the network PRNG, then you can't put the 
> same noise into the dev/random CPRNG at all, in any way. I've tried 
> explaining the crypto reasons for this, and George has added to that, 
> so let me try a different approach: It breaks FIPS 140-2 for all of 
> Linux. While FIPS certification isn't a key driver, it is a 
> consideration for the crypt modules. FIPS references NIST.SP.800-90B 
> (which is specifically about Recommendation for the Entropy Sources 
> Used for Random Bit Generation) which has a requirement that the noise 
> source not pass any data used for crypto operations to anything 
> outside of the defined security boundary. If you want to feed a noise 
> measurement into the network PRNG, then you can't feed it into the 
> /dev/random pool also. You have to decide where the different 
> measurements are going to go and keep them completely seperate.
>
> I'm not intimately familiar with the standards so I spoke with someone 
> who does FIPS 140-x certification and was told "I don't think the 
> standards even considered the idea that someone might pass data from a 
> conditioning pool to other functions. It completely violates the 
> security boundary concept so is just prohibited ... that type of 
> change would absolutely be a problem."
>
>
> Marc
>
