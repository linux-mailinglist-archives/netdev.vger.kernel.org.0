Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF3FE5F9AFB
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 10:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiJJI22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 04:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbiJJI2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 04:28:15 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413EB5FF75
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 01:28:10 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id r13so15856043wrj.11
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 01:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=SGQWT9KliF8grTqMWJU/9ecU/fAaL6lv1JumnPH4ZDE=;
        b=EFBnAyvBCKHRWw9on27a3ACrhFAPjISpOP7U6hqPMI3562VUp/vYicCfix/Ge5jF1c
         jZ6NSR+jFccfOsVyxUxTUSfohrMzDllYsdzB+KdjRLFntJbfwJiFch0jJs/XzEffCBNB
         ir1yLh2hFhwHBcjn0fnhOi0mhiBWZLvfcDXnDrxtLhl4rxVKiCFirqPflq3aCEV3vrTc
         JU5W2Kx0CWpFQxeCS0B0dEPRih7Tb4ChGzeAvDnURzrRJozH4FjF8fUrEiwnMmegYHoX
         VIy+q8QP0WiM/hyYieTEvv7KLRqgR8MvWCY2eJbBLJyYexNp+2H7UnBh+aWPO/Y0+Yll
         us0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SGQWT9KliF8grTqMWJU/9ecU/fAaL6lv1JumnPH4ZDE=;
        b=mBwtPQ6zdUGogDnvlAG5MD+I9PV+M5dEd3lNsh2I0fpaCXl8C19s+jEx02S+/G6CZ0
         g5+s2ii2Slg3tKyD9TvCciYS6vRD3iigrCv9VU6mzFFGMNUrhXfEzjN/S0gVZ14bX0DI
         uEn71PbY22IiMgL4HB0rTwk79QBOB8MHedEkDulWaFN/UgvCeJKUSOrpmLX20j9kMRnl
         mhOGTmmn7Fr/oBt2lob06M4HFpnrafXNZaC8xZZXGQhmmlLT48mei4aJ3cvj7kNDyP4b
         AJOcXUwY6DOO1e58yKocm6wrCuUSgUm+fmO1n0yAPyRQX7px4glJVJG9KdqxuLEAUQCD
         8MIg==
X-Gm-Message-State: ACrzQf3tfJrhG+5mw5eKynqGlS7vWoipLDQxZqsfqcOcius94oyHEHDI
        VPC3Neb+VZygyjzQLvlYF0hZ6g==
X-Google-Smtp-Source: AMsMyM58LcpC0a4Bv1ms/PABj5JZC4OLe+KFi3sPF7FBxpE6ERQyv6aNIup2HYqTKC8+on8FQXXKrw==
X-Received: by 2002:a5d:4385:0:b0:22e:34df:5511 with SMTP id i5-20020a5d4385000000b0022e34df5511mr10762123wrq.712.1665390488510;
        Mon, 10 Oct 2022 01:28:08 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:5d4:a7f7:8743:2a68? ([2a01:e0a:b41:c160:5d4:a7f7:8743:2a68])
        by smtp.gmail.com with ESMTPSA id j6-20020a05600c190600b003a601a1c2f7sm15920048wmq.19.2022.10.10.01.28.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Oct 2022 01:28:08 -0700 (PDT)
Message-ID: <1fc3c7b2-027b-374d-b77a-e5a01b70e73a@6wind.com>
Date:   Mon, 10 Oct 2022 10:28:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec,v2] xfrm: fix "disable_policy" on ipv4 early demux
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>, steffen.klassert@secunet.com
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, monil191989@gmail.com,
        stephen@networkplumber.org
References: <20221009191643.297623-1-eyal.birger@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20221009191643.297623-1-eyal.birger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 09/10/2022 à 21:16, Eyal Birger a écrit :
> The commit in the "Fixes" tag tried to avoid a case where policy check
> is ignored due to dst caching in next hops.
> 
> However, when the traffic is locally consumed, the dst may be cached
> in a local TCP or UDP socket as part of early demux. In this case the
> "disable_policy" flag is not checked as ip_route_input_noref() was only
> called before caching, and thus, packets after the initial packet in a
> flow will be dropped if not matching policies.
> 
> Fix by checking the "disable_policy" flag also when a valid dst is
> already available.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=216557
> Reported-by: Monil Patel <monil191989@gmail.com>
> Fixes: e6175a2ed1f1 ("xfrm: fix "disable_policy" flag use when arriving from different devices")
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> 

Is there the same problem with ipv6?
