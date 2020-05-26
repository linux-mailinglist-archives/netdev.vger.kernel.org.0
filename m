Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3F91E21D0
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 14:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730078AbgEZM1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 08:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbgEZM1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 08:27:16 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED246C03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 05:27:15 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id fb16so9313367qvb.5
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 05:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5bjnTbxSymDBodMQJw+v0RTaXDOExpuPQyJbhorVKU4=;
        b=SZ2OcLjwMnYMYIBP8p4GRPfKXMjtcrvr+j3A0T+qDw3dCVSw05paeZCeXFIdTfxMIU
         0c9hbc7Y8BM6g3RJNl4G6djm44ltWY+8N+h+E3UMzYaEsLkLrZ0ARmN0ccQV+6M4r3wl
         eicoMQcbU5PzpVAf7nm8ihw1H7IL4LL7yn1xOAp/curRptisSQ9tACJDtUUp4+QjIozG
         oW8XNpgU5/kLDmgYdtWMeVLxQnghtFx0BQwjuILVbhoVHHZ4IPGFAbwKAuRRQpT9iNfq
         RbNg/6IHf0RhusKAR5eVzSlidkq4ck9yGF8zBYgRUHsUqiwrONdHQHS1O4BDGWGKdF5X
         L6KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5bjnTbxSymDBodMQJw+v0RTaXDOExpuPQyJbhorVKU4=;
        b=C6VYI+qrqRaRiignFybmaxz5G48r1tcA1PBr6a/BgtXhuZ7kt74gYbXd6WMN9tZFxZ
         sV94p32E8m8DSPm79wkBcziGa1sXWnrcx2GnBr/5GYwZuJZQeqMxLxl0ZHl+9DMA154W
         PbFcUSoVBnlUMp4xG2g+SZzcvVCvC85CaOyATKEjx9z5kgWJXsFR1dlW3BHaCBMlnuis
         K2LMlEVEOkyqZqQYD2bDcj1PVCelSjsHFJ0pPjM8+SKmacYJcIo37DjKYDgIGMsjYmRx
         2GmfpWLNRbyv/eAMTJL3v4usThHGDQzFb/uycCD2Ung2RmLLdZkRLmNI2uNvd9/EAMMC
         t0Ng==
X-Gm-Message-State: AOAM530IMRmERjTd2Nj3QBaIEKX5DJNTnaI7d3HSgbwfwL0wwME9KJlC
        cK63u3G0z9yNxHhr2NmHYC0WkUAjmKo2kw==
X-Google-Smtp-Source: ABdhPJyfWTURvuJnAjCrXqljlJx7seJ3yRiirfvFRctG57kza947P3Q4eDennjGyq5Dz++N2GKPGeQ==
X-Received: by 2002:ad4:4a8b:: with SMTP id h11mr20329603qvx.232.1590496035006;
        Tue, 26 May 2020 05:27:15 -0700 (PDT)
Received: from [10.42.0.108] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id h13sm17842260qti.32.2020.05.26.05.27.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 05:27:14 -0700 (PDT)
Subject: Re: [PATCH iproute2 v3 0/2] bpf: memory access fixes
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, asmadeus@codewreck.org
References: <20200423175857.20180-1-jhs@emojatatu.com>
 <125e68f2-2868-34c1-7c13-f3fcdf844835@mojatatu.com>
 <1d1e025b-346b-d5f7-6c44-da5a64f31a2c@mojatatu.com>
 <e192690f-ad1a-14c1-8052-e1a3fc0a1b8f@iogearbox.net>
 <f18653bd-f9a2-8a87-49a5-f682038a8477@mojatatu.com>
 <CAPpH65zTiy-9WxoK=JzUj2eR8pNu8Mf4xqMmmHtjVVfwTSgydA@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <8559907b-7a39-b719-f8bd-c7851e669372@mojatatu.com>
Date:   Tue, 26 May 2020 08:27:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAPpH65zTiy-9WxoK=JzUj2eR8pNu8Mf4xqMmmHtjVVfwTSgydA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-25 4:53 a.m., Andrea Claudi wrote:


> 
> Reverting c0325b06382c will for sure fix the segfault identified by
> Jamal and get rid of the problems highlighted by Daniel and others.
> To fix the s[n]printf truncation warning we can simply check for its
> return value. From the snprintf man page:
> 
> "a return value of size or more means that the output was truncated."
> (caveat: until glibc 2.0.6 ret value for truncation is -1)
> 
> Jamal: if this works for you, I can submit an alternative to this
> patch series doing what I proposed above. What do you think?
> 

I am ok with that approach.

cheers,
jamal
