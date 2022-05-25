Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBDD53388F
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 10:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbiEYIem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 04:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234809AbiEYIej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 04:34:39 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E0910FC7;
        Wed, 25 May 2022 01:34:31 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id c19so21767052lfv.5;
        Wed, 25 May 2022 01:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=5L0FJw8nrreK+iWXw2F3MaAOrCQpmilHML/7HPSt5+4=;
        b=azwYnsS6jJEQvSuK4hoXH6WieSqwBE2dO+Bdu6YXtPBvcuUmTfpC2qwzKvfRSAGzKe
         AywA5P/AgCEHA+hSDE09wNNIxJeazza54hvRtKsM0KHE9XkEoUECPoherZUTjO/quYLX
         Ia/SRkqrRtnoKqZUnvfJDwwtnDjK4AWeTkS5oTNe/kttqS2+ML3Ah3K8aCLre0PQ/WsB
         FLtIyd+3n8Ag8VLjPa5MMsnq6nMbmdQGOMUy8F5fLL1tf6aShTHh97UcbwtSsm4BnOQ0
         kr5CBdH2eljtkZpg56jZHdcWO1mU1QK+FEeFMv1xX9ebJkDih3+MTRBgbslM8CaHJyNz
         Ic+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=5L0FJw8nrreK+iWXw2F3MaAOrCQpmilHML/7HPSt5+4=;
        b=1CSK69JoRM5hvyRnxfsxL3lPVhZfrKJP87byRvPy7CRydgS8xKuoJbWXXAL159HtuI
         Dx/y8R0NnyzvxJSKegwdzT7wPBP3eL/BV71HFDYshWjbtOCpwSuaZnXRlHkkYnRzHHTJ
         ZN2oHSqq5qlnJrD/BNMOn+xY9KRglPYLuaaET47OjQ7vhzX8TBabO7PooyrnVi1XqtrR
         38RmrcuOD391hhDcwlz3yAXRVTLlfXHXBwQkpRbXt6Zg75bmI2x0RsxSs4HDj3k9g2Pa
         7+MjkOjCTxyJEH9u4tQU/j9cNmM/CH4Vui4OpIDYTkiesVywfFXCWYDvLB8SQ8u+CGpz
         uKZw==
X-Gm-Message-State: AOAM5331Xo+YFIOeLlBkow/c++O9p6Pf4t27ZvGy8AlHpDh68iHSb2MI
        RDrvip6RsHSqBJ+rMfo746WuWZvRGWRDQA==
X-Google-Smtp-Source: ABdhPJxic4FhRXu/llodR7HOqkXULwkms1mxQ9iH9XF+99sL0VI5R5WVn65/uHa0tDznw59r1oiRnQ==
X-Received: by 2002:ac2:548e:0:b0:477:c2fa:b18e with SMTP id t14-20020ac2548e000000b00477c2fab18emr21744727lfk.269.1653467669317;
        Wed, 25 May 2022 01:34:29 -0700 (PDT)
Received: from wse-c0127 (2-104-116-184-cable.dk.customer.tdc.net. [2.104.116.184])
        by smtp.gmail.com with ESMTPSA id i22-20020a2e8096000000b00250664c906asm2972324ljg.133.2022.05.25.01.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 01:34:28 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
In-Reply-To: <b78fb006-04c4-5a25-7ba5-94428cc9591a@blackwall.org>
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-2-schultz.hans+netdev@gmail.com>
 <01e6e35c-f5c9-9776-1263-058f84014ed9@blackwall.org>
 <86zgj6oqa9.fsf@gmail.com>
 <b78fb006-04c4-5a25-7ba5-94428cc9591a@blackwall.org>
Date:   Wed, 25 May 2022 10:34:27 +0200
Message-ID: <86fskyggdo.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On ons, maj 25, 2022 at 11:06, Nikolay Aleksandrov <razor@blackwall.org> wrote:
> On 24/05/2022 19:21, Hans Schultz wrote:
>>>
>>> Hi Hans,
>>> So this approach has a fundamental problem, f->dst is changed without any synchronization
>>> you cannot rely on it and thus you cannot account for these entries properly. We must be very
>>> careful if we try to add any new synchronization not to affect performance as well.
>>> More below...
>>>
>>>> @@ -319,6 +326,9 @@ static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
>>>>  	if (test_bit(BR_FDB_STATIC, &f->flags))
>>>>  		fdb_del_hw_addr(br, f->key.addr.addr);
>>>>  
>>>> +	if (test_bit(BR_FDB_ENTRY_LOCKED, &f->flags) && !test_bit(BR_FDB_OFFLOADED, &f->flags))
>>>> +		atomic_dec(&f->dst->locked_entry_cnt);
>>>
>>> Sorry but you cannot do this for multiple reasons:
>>>  - f->dst can be NULL
>>>  - f->dst changes without any synchronization
>>>  - there is no synchronization between fdb's flags and its ->dst
>>>
>>> Cheers,
>>>  Nik
>> 
>> Hi Nik,
>> 
>> if a port is decoupled from the bridge, the locked entries would of
>> course be invalid, so maybe if adding and removing a port is accounted
>> for wrt locked entries and the count of locked entries, would that not
>> work?
>> 
>> Best,
>> Hans
>
> Hi Hans,
> Unfortunately you need the correct amount of locked entries per-port if you want
> to limit their number per-port, instead of globally. So you need a
> consistent

Hi Nik,
the used dst is a port structure, so it is per-port and not globally.

Best,
Hans

> fdb view with all its attributes when changing its dst in this case, which would
> require new locking because you have multiple dependent struct fields and it will
> kill roaming/learning scalability. I don't think this use case is worth the complexity it
> will bring, so I'd suggest an alternative - you can monitor the number of locked entries
> per-port from a user-space agent and disable port learning or some similar solution that
> doesn't require any complex kernel changes. Is the limit a requirement to add the feature?
>
> I have an idea how to do it and to minimize the performance hit if it really is needed
> but it'll add a lot of complexity which I'd like to avoid if possible.
>
> Cheers,
>  Nik
