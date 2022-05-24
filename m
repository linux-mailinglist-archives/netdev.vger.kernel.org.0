Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79BBA532ED4
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 18:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239369AbiEXQVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 12:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233239AbiEXQVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 12:21:08 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82976BFB;
        Tue, 24 May 2022 09:21:05 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id p22so31637051lfo.10;
        Tue, 24 May 2022 09:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=2/bDGPYXufJFzkVnBY8mqDgAglNZetlk8WJ7Djt/e2E=;
        b=e6JB8CI6WFSU+Q/ABVHaxlfYhBRAsmmbmkIDuhn1m6DKPOXKF37gjB/m9GdsVi49dc
         JNf43jPT5zw03LMoVZ8t3fuV30/a2V5p20h02AkSpplyqHBCbbU0BEhybKuk9LvBIU0v
         yF5u5B3igHgLN7iRG8ZQrDAszFgPNI/I5CRCOoGPWgb0Tr5z/PCYQqsyZhaq45tfM2ue
         TR82sVYgQfPiZLzURg9Q0Ng/5eocdGR5EPE8FxukEwr6LoxzCf3TXITUf9yHbYMLAfmG
         vt/o3bafEdXjgzQsP4rsUwQGadPuBcmEHO5dtLS97SrWhTOdZeC4FS/jt5IR6+lcfUJ1
         OuKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=2/bDGPYXufJFzkVnBY8mqDgAglNZetlk8WJ7Djt/e2E=;
        b=Esfw8PkOJy8PWA2w3nW58LKuNx19lVLSmgduJqZ5dkFeDnKyxtHufoWqMq3hyhH2iM
         mlKY4hhya99RkIOU59HY9EG0tB94FSg8XxXGYg4nzEbdE4s4qWdqgJh6IwM7tVghTOYX
         Tx8zGzeOXVjkL2K14r9LI5U/Hq7r0srO39Dc2tbaAI+fCVM5ac3kasco8O4MRHZsKMGV
         Snd0pADdwiiSxjWIU1tmRTB1x6hWQDgSeEkrsCWckmYzzdtW5Sr2Whfp9dLWmG3+JUKq
         jQLBdsQc33EPrJlOotS9YaWMBLfJraK8FlT65HdCncSt5MMErX5cbNAQM3DCyEG6YyFQ
         yhww==
X-Gm-Message-State: AOAM5318skmTGNPL93OcE5nw/vmEENrhf37/yPxIvjw9mnrNnd56lCWc
        2NzZQ0fX5OO+PxY5Os2K0foT3oeOJl7gdA==
X-Google-Smtp-Source: ABdhPJzIQuFRRQuyC1EsDbZ10YZKs55feovmJnYJ1MTbAEC+b0Jjw4TR7inmyaHD1E/9Z28qwFMM0w==
X-Received: by 2002:a05:6512:1510:b0:445:cbc3:a51f with SMTP id bq16-20020a056512151000b00445cbc3a51fmr20695039lfb.116.1653409263918;
        Tue, 24 May 2022 09:21:03 -0700 (PDT)
Received: from wse-c0127 (2-104-116-184-cable.dk.customer.tdc.net. [2.104.116.184])
        by smtp.gmail.com with ESMTPSA id a26-20020a19f81a000000b0047255d21116sm2611832lff.69.2022.05.24.09.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 09:21:03 -0700 (PDT)
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
In-Reply-To: <01e6e35c-f5c9-9776-1263-058f84014ed9@blackwall.org>
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-2-schultz.hans+netdev@gmail.com>
 <01e6e35c-f5c9-9776-1263-058f84014ed9@blackwall.org>
Date:   Tue, 24 May 2022 18:21:02 +0200
Message-ID: <86zgj6oqa9.fsf@gmail.com>
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

>
> Hi Hans,
> So this approach has a fundamental problem, f->dst is changed without any synchronization
> you cannot rely on it and thus you cannot account for these entries properly. We must be very
> careful if we try to add any new synchronization not to affect performance as well.
> More below...
>
>> @@ -319,6 +326,9 @@ static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
>>  	if (test_bit(BR_FDB_STATIC, &f->flags))
>>  		fdb_del_hw_addr(br, f->key.addr.addr);
>>  
>> +	if (test_bit(BR_FDB_ENTRY_LOCKED, &f->flags) && !test_bit(BR_FDB_OFFLOADED, &f->flags))
>> +		atomic_dec(&f->dst->locked_entry_cnt);
>
> Sorry but you cannot do this for multiple reasons:
>  - f->dst can be NULL
>  - f->dst changes without any synchronization
>  - there is no synchronization between fdb's flags and its ->dst
>
> Cheers,
>  Nik

Hi Nik,

if a port is decoupled from the bridge, the locked entries would of
course be invalid, so maybe if adding and removing a port is accounted
for wrt locked entries and the count of locked entries, would that not
work?

Best,
Hans
