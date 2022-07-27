Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33074582A02
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 17:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234024AbiG0Pwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 11:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbiG0Pwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 11:52:32 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A7349B7C;
        Wed, 27 Jul 2022 08:52:31 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id i13so12828466edj.11;
        Wed, 27 Jul 2022 08:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sCiIbne8ijwxYERRgWmKwN6VqmxC0psTKJdz1VQXbvI=;
        b=CPyK0OvuJ25Cp/X56lhMJFw/HcqGnRwWjTnIEipGqnnhjaMCyRed/L43d82BCzlDOy
         PP0dL0w6z0N6064je/4MjYzHVvrzOaZOpMAbOBSEaT5/LkZpKg05Z4wmcIrBU0N5XqZc
         OvaqNnS+O/THezH2K3YV3+pdd6vNJ8RKo4W+nta/N/khWX3C/vEsQwrGkXmnSol1/8Qj
         qeZa6hyP/zvcsnc/DSKgYe7Xd0cjIaP3rVnsnIM7K1xBahOGIb2mZvKvaszEgJI/OTT0
         AEvZ23vcC/narjoLqyNJqQT3nLwpMs/mlbVhzW2D01rxQHZiljyUKNN7tELenJoWjGEN
         pKjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sCiIbne8ijwxYERRgWmKwN6VqmxC0psTKJdz1VQXbvI=;
        b=eytcIG1bDzCt0n+43QHGiYKIovsfFMTh9AZHVOedsR1RFrT8f58iw70IX0kxu+O3v1
         at/HjoJ5Qtxg9Q3HbWNJ3LEcRZjKE8MuuzcRLvV2+SE3CWcYgnO+flW17P706injSZTj
         FGuUxwgWsMUFB7DRqmGqKZU6G8vJE/41KhD9IL2Y2pQhkjL+WhgEPCvNqPGq9WAC1hqe
         ulBnrEjCkrDuTo0MGvqbPsHPSjg1Atg1pLtTZo2z773skWsylF1640fg5TpYfy2HjRGd
         3W01rEvSxKoPcdBFHA6e4ksdz8EDSBxn/86wqvwH2tTH1Uq++8+KVE0b1Lv36ulPXBWg
         0whQ==
X-Gm-Message-State: AJIora8bsUk6aj4bLCQsYcU/msJ1KyQsjT5SUz189BxAlq/iqitOicZi
        H5j0ZzZ+VySfuUkfnhnj5e0=
X-Google-Smtp-Source: AGRyM1vO98nO6kDOdEHUpaoV1DgveBsqp+R6esVhO9kfIWL8XEmB3Qxg/xn0FPdBMHzrRB4QH5ScWQ==
X-Received: by 2002:a05:6402:f12:b0:43c:a70d:ee6 with SMTP id i18-20020a0564020f1200b0043ca70d0ee6mr4771269eda.316.1658937149598;
        Wed, 27 Jul 2022 08:52:29 -0700 (PDT)
Received: from ?IPV6:2a04:241e:502:a09c:994d:5eac:a62d:7a76? ([2a04:241e:502:a09c:994d:5eac:a62d:7a76])
        by smtp.gmail.com with ESMTPSA id 18-20020a170906201200b0072fe6408526sm2914413ejo.9.2022.07.27.08.52.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jul 2022 08:52:29 -0700 (PDT)
Message-ID: <5b88eea6-1d84-8c16-36f4-358053e247f2@gmail.com>
Date:   Wed, 27 Jul 2022 18:52:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 0/6] net/crypto: Introduce crypto_pool
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20220726201600.1715505-1-dima@arista.com>
 <YuCEN7LKcVLL0zBn@gondor.apana.org.au>
From:   Leonard Crestez <cdleonard@gmail.com>
In-Reply-To: <YuCEN7LKcVLL0zBn@gondor.apana.org.au>
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

On 7/27/22 03:17, Herbert Xu wrote:
> On Tue, Jul 26, 2022 at 09:15:54PM +0100, Dmitry Safonov wrote:
>> Add crypto_pool - an API for allocating per-CPU array of crypto requests
>> on slow-path (in sleep'able context) and to use them on a fast-path,
>> which is RX/TX for net/ users (or in any other bh-disabled users).
>> The design is based on the current implementations of md5sig_pool.
>>
>> Previously, I've suggested to add such API on TCP-AO patch submission [1],
>> where Herbert kindly suggested to help with introducing new crypto API.
> 
> What I was suggesting is modifying the actual ahash interface so
> that the tfm can be shared between different key users by moving
> the key into the request object.

The fact that setkey is implemented at the crypto_ahash instead of the 
ahash_request level is baked into all algorithm implementations 
(including many hardware-specific ones). Changing this seems extremely 
difficult.

Supporting setkey at the tfm level could be achieved by making it an 
optional capability on a per-algorithm basis, then something like 
crypto_pool could detect this scenario and avoid allocating a per-cpu 
tfm. This would also require a crypto_pool_setkey wrapper.

As it stands right now multiple crypto-api users needs to duplicate 
logic for allocating a percpu array of transforms so adding this "pool" 
API is an useful step forward.

As far as I remember the requirement for a per-cpu scratch buffer is 
based on weird architectures having limitations on what kind of memory 
can be passed to crypto api so this will have to remain.

--
Regards,
Leonard
