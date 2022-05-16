Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A20F527F4A
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 10:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241375AbiEPIJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 04:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235893AbiEPIJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 04:09:27 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81C033E3A
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 01:09:25 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id t6so19369311wra.4
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 01:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=vkNIrmhxeK1hzvWJRXN0UZ57PrfBEgcy2ohwdXaBcs0=;
        b=j6Vw7D+Rn0NFKJE2LpGwrySsudgQmYr4jsPwkBcojlEjBBNFxfBKkI3F8JpvHrFLCI
         XCOSVdeEWJ4Wdm5Ti5YJD5sWlk1HP3wZSn8GNTTr4uKsYjUYbptz/QzPZVbymT6OzHgG
         uGZGxpW2tw/21GcKPTK5EkrSKRiwAzzbSfVQK6ToFFqNz3mD6WLyxgWsAPHNQ9gSISLO
         0LNH0Ssg1fTNrgHxN3ufC3tNG4T+hXte6ydWysg6dxyO5GkV5zWDVvV/TGsJSQY0H5Kv
         +nOkSbU59bLoMp40pGTGXXhjwF3J9Ez4SQcYFTk+nj2yGPPIM2+FolWdfVVBKs1Tbrgx
         1DDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=vkNIrmhxeK1hzvWJRXN0UZ57PrfBEgcy2ohwdXaBcs0=;
        b=xa12p+PwURDUOTJSxIYDPlFBPxQSp3ikY9fgMGUVl1lWXzuGmYN0rfjlqy53anJAjo
         4elmUiyHyYC+K4+7kkjDkDBbnSceiw4MUiiuXFTQsXn7+6sfmGBvN5aQfDaVMsGUn1Iz
         OfdOVQD7Xmx4xy+Utu6TSh7CajJFTncwPAhOBRR4ZjccuM2KVtSEyWmotMhH6WT0CtlM
         KyTKTQFdN94oHJyBTk5YG+X5AR0sh1ZcG+R3GFH2WjaXwEHxPJoqLeLArb+gy1El91y7
         MN+PQy0/zbMjp4CC7vS4Fi8dCLJH2biFsPHn056iMWEPqszZnf/5iG71jo71ul+JmqCx
         o5+g==
X-Gm-Message-State: AOAM531L1LOv3+qZDNLRhBjRAJaaTd+WAk2wyPX4mL1W3IhaPojNZ4v+
        QopPvNCK8K8JCNTFcMyxF0JS/g==
X-Google-Smtp-Source: ABdhPJyv5dpYfGTlnfAPBYVpojWmhOWysUm3K0AbIDChkSZhVy0QDsYNSQfWr9wQZG4idtXL8H4HJQ==
X-Received: by 2002:adf:de8b:0:b0:20d:2cc:a001 with SMTP id w11-20020adfde8b000000b0020d02cca001mr6124360wrl.206.1652688564352;
        Mon, 16 May 2022 01:09:24 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:8404:51ca:b618:f6e9? ([2a01:e0a:b41:c160:8404:51ca:b618:f6e9])
        by smtp.gmail.com with ESMTPSA id d3-20020a1c7303000000b003942a244ee6sm9594673wmb.43.2022.05.16.01.09.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 01:09:23 -0700 (PDT)
Message-ID: <2580e9d1-ce94-c416-63fe-52ed50f0e445@6wind.com>
Date:   Mon, 16 May 2022 10:09:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec,v2] xfrm: fix "disable_policy" flag use when
 arriving from different devices
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au
Cc:     netdev@vger.kernel.org, Shmulik Ladkani <shmulik.ladkani@gmail.com>
References: <20220513203402.1290131-1-eyal.birger@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220513203402.1290131-1-eyal.birger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 13/05/2022 à 22:34, Eyal Birger a écrit :
> In IPv4 setting the "disable_policy" flag on a device means no policy
> should be enforced for traffic originating from the device. This was
> implemented by seting the DST_NOPOLICY flag in the dst based on the
> originating device.
> 
> However, dsts are cached in nexthops regardless of the originating
> devices, in which case, the DST_NOPOLICY flag value may be incorrect.
> 
> Consider the following setup:
> 
>                      +------------------------------+
>                      | ROUTER                       |
>   +-------------+    | +-----------------+          |
>   | ipsec src   |----|-|ipsec0           |          |
>   +-------------+    | |disable_policy=0 |   +----+ |
>                      | +-----------------+   |eth1|-|-----
>   +-------------+    | +-----------------+   +----+ |
>   | noipsec src |----|-|eth0             |          |
>   +-------------+    | |disable_policy=1 |          |
>                      | +-----------------+          |
>                      +------------------------------+
> 
> Where ROUTER has a default route towards eth1.
> 
> dst entries for traffic arriving from eth0 would have DST_NOPOLICY
> and would be cached and therefore can be reused by traffic originating
> from ipsec0, skipping policy check.
> 
> Fix by setting a IPSKB_NOPOLICY flag in IPCB and observing it instead
> of the DST in IN/FWD IPv4 policy checks.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
