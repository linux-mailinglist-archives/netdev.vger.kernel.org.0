Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231B3532E9D
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 18:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239575AbiEXQIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 12:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239666AbiEXQIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 12:08:20 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB6CBD6;
        Tue, 24 May 2022 09:08:12 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id m11so10003501ljc.1;
        Tue, 24 May 2022 09:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=FYyqUIqX7o7uukxhOxpvy5c6jwFhAW9JG5e+iqj0ZAA=;
        b=c40RMye4tt3qCM6W7eagyel05d9f+ezi9QjwhaQUCVPrgeXySiIl9CgyIOCULFxZRD
         R6hBjevW71JnRlce8PS7Z25IqHWEruI0bmo1pEwvrEZrFMyulwV9euVsIFwx1faYR3pt
         IZOpC8zioCI8T2SnZoD3ZoSTFvlbhGEjtZ8ulllzeUUNb91lhIKU8erEgOQ+3jnIWFjx
         fiv+sihOx6bLRkA5OmLH/IMQpg6fnANudZqfBYeJtNmLbZiq+VIKRXePkKm+JBYSWSOK
         2et3ghTg4DPaTlWwem54LXEFrT27VZvUKSFjYc7yQesvH60Ljkbai0rT9V3qfElTv5FM
         XxeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=FYyqUIqX7o7uukxhOxpvy5c6jwFhAW9JG5e+iqj0ZAA=;
        b=fFGpvSob2xcXVnLC9jvqexFMthek74/3VmPF/AXq42UaRhTwelMCDUMT3eIDohSXe/
         vZy/2nTnS+Mdu4AUzuCRTPHDjB3TuQw9qmEWd+8odbb46+OQVRetuukrEBXE4TExq7o5
         S7GK8qYZbCvcfrClB0EjfxNaQHDlJ1ubMLtc53XGNWwreNiMvnS2wbG96FjF5tdJRlae
         To5s6VhNrWPEBqLaYwR/2E53czKdOtUm7OfN98ez5CA67gT/y4W7/FHGIA/FZPYGcZX+
         n0ptf5XhRdyOBHw1Dm4wd93tkIbIKSvKDtwoqx9JbAzkaSwprsKUPM9P/D2g4tQfuKCM
         1FAA==
X-Gm-Message-State: AOAM531cIENo4uEnzBK0CUrV0mIBqsUhqv6IzMclKj0RarjuiUHpNfPX
        xRnGBQV9hqrnbSiTBcPRM2dwYVKM8SndtA==
X-Google-Smtp-Source: ABdhPJxuLzq1hI6bqY13WMLFP01JX+UfPxh11e02lJOpXFmfpfy/IHhgLs7X1xQVsl3eRy/uyOdaIA==
X-Received: by 2002:a05:651c:1a14:b0:253:ed7b:c22 with SMTP id by20-20020a05651c1a1400b00253ed7b0c22mr5665926ljb.84.1653408490226;
        Tue, 24 May 2022 09:08:10 -0700 (PDT)
Received: from wse-c0127 (2-104-116-184-cable.dk.customer.tdc.net. [2.104.116.184])
        by smtp.gmail.com with ESMTPSA id u26-20020ac248ba000000b0047255d21188sm2597000lfg.183.2022.05.24.09.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 09:08:09 -0700 (PDT)
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
Date:   Tue, 24 May 2022 18:08:08 +0200
Message-ID: <8635gyvrpz.fsf@gmail.com>
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

I could check if f->dst is NULL, but in general this should be able to
work on a per port basis, so do you have an idea of how to keep a per
port counter of added locked fdb entries?

Best,
Hans
