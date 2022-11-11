Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 016746264CD
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 23:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbiKKWy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 17:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbiKKWyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 17:54:24 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74EA759FFC
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 14:54:23 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id cg5so3517356qtb.12
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 14:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F1LpcUVxrtUpj8oNUUt1IQAJQIMLQQO8SW3eR5k2PkI=;
        b=LaK/LNCeUYIjq6n11X0X5eXRvOxtAMvXd4MRPlAO18WSFpJHp5WVTHVbbxSs3dL5Sk
         GbV8hoVvr+VYm79efz6rAoRhi3IoHrKbYNm5NDXX5QqqNcmN5ChN5NvFdXWcfDKvc+rN
         JEBAuC2S1tscQQm4M+/FZX/NmPrHNgthtgaicTFGgZrMsE5BOwlmvY3ZnO0Nndb+b9r3
         5VNfoLG74y+CA+afUxDqFBSa4vBagsJUYcHokAr3P5+qKzDW0qB++XZAjFa0mbB+iULN
         AunFb09NewsADXZD6T/2HWDVoFDp/jRRQvSB5QYGlzoYmMRZ7w1pCyVIipbTMZoSw7N5
         KYcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F1LpcUVxrtUpj8oNUUt1IQAJQIMLQQO8SW3eR5k2PkI=;
        b=KVdN+qsd+JR2cfTWpwYMgYTU8aZvW1XYQBf0+wO7KHR86R0/anauiyZav1oPZjnm3g
         AbA4OxiAaTs1gTtt/d8PeW3xNzeCjqe9MjdnUKeZK8d/F+qOEKEiiCqmhYCLX+K/BZOU
         Kv+LFJuAVm1kk2f0zFVJdyddv6mVntjWUCUVHwyx7Rdk4bJrFcu+JcqWmT4DVR1gHxDZ
         YtfvE8p32xhEG6TH2T/aiie+9+i6vz9jJrs4CeLiveAIl4iAma8iTW4syxCrdQqLJceM
         LRvnAbL4qyzwX3uvSZ2oQzwMO7UG3YZc0ZVWe3RQ9bMNIWRy+pS7NhrI/hEBsU5D2iy+
         UKyA==
X-Gm-Message-State: ANoB5plReXK8R2HMl4GyZfMHPiGo4pHsrIDZ4ghA4YA0yTkrrlhG18aG
        H06eec4RtzR74t2JGYWN6Hs=
X-Google-Smtp-Source: AA0mqf75hAkLqe0Ab9g46efE2M1MhdZcg9aFncOjIpFeua4rPSgBpLVNdw7YPdav1wdKgi3kq9KRlQ==
X-Received: by 2002:ac8:570d:0:b0:39c:d841:9b6f with SMTP id 13-20020ac8570d000000b0039cd8419b6fmr3357809qtw.640.1668207262511;
        Fri, 11 Nov 2022 14:54:22 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g26-20020ac8469a000000b003a5416da03csm1888936qto.96.2022.11.11.14.54.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Nov 2022 14:54:21 -0800 (PST)
Message-ID: <bcb368ce-6a16-ac9d-f2fa-b86b0d4c8ca4@gmail.com>
Date:   Fri, 11 Nov 2022 14:54:18 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RFC PATCH net-next 0/3] Autoload DSA tagging driver when
 dynamically changing protocol
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiko Thiery <heiko.thiery@gmail.com>
References: <20221027210830.3577793-1-vladimir.oltean@nxp.com>
 <2bad372ce42a06254c7767fd658d2a66@walle.cc>
 <20221028092840.bprd37sn6nxwvzww@skbuf> <Y17rEVzO2w1RslrV@lunn.ch>
 <20221111225341.2supj4ejtfohignw@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221111225341.2supj4ejtfohignw@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/22 14:53, Vladimir Oltean wrote:
> On Sun, Oct 30, 2022 at 10:22:25PM +0100, Andrew Lunn wrote:
>> On Fri, Oct 28, 2022 at 09:28:41AM +0000, Vladimir Oltean wrote:
>>> On Fri, Oct 28, 2022 at 11:17:40AM +0200, Michael Walle wrote:
>>>> Presuming that backwards compatibility is not an issue, maybe:
>>>> dsa_tag-id-20
>>
>> I don't think they are meant to be human readable.
>>
>> I do however wounder if they should be dsa_tag:ocelot-8021q,
>> dsa_tag:20 ?
> 
> dsa_tag:20 or dsa_tag:id-20?

The latter IMHO would be more explicit.
-- 
Florian

