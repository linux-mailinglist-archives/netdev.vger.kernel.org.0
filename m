Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A22D359ED14
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 22:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbiHWUGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 16:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbiHWUGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 16:06:18 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE5B80521
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 12:23:37 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id k9so18181679wri.0
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 12:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=EjIVVDKgfAQnTIDHdcgii05+dfZdL98r/ZOX4AyAXIQ=;
        b=Bz6hrSMnZUAIEh8kyYJEhdmt9Abs8gtuk6WWV8UVViegyv1yBUIRpF+7JkuuhUfSI/
         rmS6vJa2Sh+JAmIRmoH2m/UI0OmFPOuHhbHTwbwIV4wZwlddIgisZ4THhp2q01sywyIH
         Hh0WeSm6TgtlGKLOqRbq4jIfwsyhC1MFztTMd3KUIlQOxf5bwGijguJbniSrr9ZTF0B+
         66CgYodLOH8qEBXRZirm0Hc97k3H8IrR7Mt0tyDnVDsE5HDMXShvl0HUBYXjNrHYJaDL
         fhY4/ai44IFYTsD4NDAuGfTbxDMuUShNs+r8QC5pvwGmTb9Znd1vK2oyh8wPiyra3RLQ
         u18g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=EjIVVDKgfAQnTIDHdcgii05+dfZdL98r/ZOX4AyAXIQ=;
        b=Zo9hc0a1zpq7vRAEtRoG7ZF5orKUBD/wGJMNGu0CCLfn7OY5nK/yqrv+mp0y1HIK0S
         ivzuhiSmGZ9lTwVjnMOEkGeCMAZDsuUyeEzhEXHRpQBb2tNRgZ4ZwCq/XorCCMC7+ZMB
         C4lTXxqTzaDppCGyKbqn6CKNLd4hvlRxluMzbeYI4oF1n9KeiBScgdhm7b/hhoKednME
         wazxvrtmNrA8ezduFlLfbUrEZJ7kvVGRiZqPJ8qqysgeExUx/itlehGN/sKMbGypPN4H
         rb/WxC/UtfsVgMKD/RsmU5D6QurwoXHRKdTE2/oG5QiUnSBvTyCKaLBWV9bUOsAA2IwK
         rgUA==
X-Gm-Message-State: ACgBeo2Z40pvujfFy7tklJ2yZoLLip792oZnejXG7Y2acX3PyF4+Srxt
        EA2EbSf2NMqjYlYfJeEk/UDhNg==
X-Google-Smtp-Source: AA6agR6/zSRB/lRtSV4HO66inoRV2cHAdiu/d9FBXR4z4ZRCcp2Kgm9u1+FdHSX6aoT8nsyvrq2tzw==
X-Received: by 2002:a5d:64ee:0:b0:225:6ad3:34df with SMTP id g14-20020a5d64ee000000b002256ad334dfmr1949606wri.313.1661282615706;
        Tue, 23 Aug 2022 12:23:35 -0700 (PDT)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id h3-20020a05600c2ca300b003a5ea1cc63csm22779453wmc.39.2022.08.23.12.23.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 12:23:34 -0700 (PDT)
Message-ID: <59313d4e-6934-77dd-f3a1-6c4d76f3c7d1@arista.com>
Date:   Tue, 23 Aug 2022 20:23:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 6/6] net/ipv6: sr: Switch to using crypto_pool
Content-Language: en-US
To:     liulongfang <liulongfang@huawei.com>, linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20220726201600.1715505-1-dima@arista.com>
 <20220726201600.1715505-7-dima@arista.com>
 <22bbcbf7-c51b-4933-af3d-feed77ffd352@huawei.com>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <22bbcbf7-c51b-4933-af3d-feed77ffd352@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/8/22 04:40, liulongfang wrote:
> On 2022/7/27 4:16, Dmitry Safonov Wrote:
>> The conversion to use crypto_pool has the following upsides:
>> - now SR uses asynchronous API which may potentially free CPU cycles and
>>   improve performance for of CPU crypto algorithm providers;
>
> Is there any specific test data for this performance improvement?
> How much has the memory increased?
> How much has the performance improved?

I have no test data for this.
The idea behind this improvement is the same as behind crypto ahash: if
your CPU can benefit by offloading work to hw hash accelerator and there
is a driver that provides crypto backend, you may certainly win some
performance. The number depends on platform/driver in use.

>> - hash descriptors now don't have to be allocated on boot, but only at
>>   the moment SR starts using HMAC and until the last HMAC secret is
>>   deleted;
>> - potentially reuse ahash_request(s) for different users
>> - allocate only one per-CPU scratch buffer rather than a new one for
>>   each user
>> - have a common API for net/ users that need ahash on RX/TX fast path

[..]

Thanks,
          Dmitry
