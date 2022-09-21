Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597A95BF5F0
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 07:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiIUFfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 01:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiIUFfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 01:35:16 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8385A8B1
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 22:35:15 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id z25so7430745lfr.2
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 22:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=pEq+YTtLxFQd4HdOX4QDj3o2PfSDHlNlDrwzhWyfCP8=;
        b=BmAwJCZ4EGdmlHmvoQzPE0sCt8vbhbK8C5+8abFWn/81B2QGxWmHE2eCVsOto20Xtk
         Kgm7AKA4zPGbOaIoieeJ9Dj4XUSfDijaTAlZaZTsEZU6SQcGQAGiKNWP+YweZGA46rT2
         3LFEK6WnNkKzo8V4BpMgKOAIuQJM1Z5TblJEqqjdiRrpYfvl5w0ddmJKUqtP4dIt3YEN
         Tv2I0leDWSx9FA8uahXomuODRLxFKMz9ZyUZlw/WOoOF1Nz13xE8PtDGr74b2HtI/LTH
         BxwEM5bNjR1l7QLzIZJu79n8dCKOdv3/Jn+V3z47cc3DiMZ6JuZFOILklWoIcyUtdSD8
         Bpqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=pEq+YTtLxFQd4HdOX4QDj3o2PfSDHlNlDrwzhWyfCP8=;
        b=I+dEis1RO6NhWuA6zozFwNvM0jerq5YI9Pj1usZoWr2zKNLJbmtgCj0k9NHLSsYFst
         aCASUsDSO1ZMAF2nUKrwg/SF1jDtra+mhpc3xlSUuaBS+6kOWo4w1dWoJMXLsuO9QLvL
         aqW+SmarHa0rT6BF6yRi8dhL/gRKwrjCy+dVRNuT2U70dMNXwLsNUc432XtsIHUkFUQd
         tk8ZjoNpaMXCe53LlKJYrhEklf3bnZLfJyHE5VO/fQahq8/zNBp2o73XAVCabpIn82D6
         rHVdueuM9mg9srsavGTa4zm+TDHekdm7sLJphaTXWE40149DSb0znef+OXrb/MdaLIvt
         y90g==
X-Gm-Message-State: ACrzQf0HGUa0YMEhMYEXPwE6cE1cxOSFV0IdlvSjpoe9+MT49rdjeYXG
        R2bvxBPuf+t5632j+jCELfU=
X-Google-Smtp-Source: AMsMyM4n0/gskts7FX9NkQEKfBi7uH2euOn00SfONAbZM3Bb0tUcMesbllCFutjsBnDyc29cJl7phA==
X-Received: by 2002:a05:6512:2254:b0:498:f454:ec9a with SMTP id i20-20020a056512225400b00498f454ec9amr9707318lfu.58.1663738513730;
        Tue, 20 Sep 2022 22:35:13 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id f8-20020a193808000000b0049473593f2csm273368lfa.182.2022.09.20.22.35.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 22:35:13 -0700 (PDT)
Message-ID: <5d50db8c-5504-f776-521b-eaae4d900e90@gmail.com>
Date:   Wed, 21 Sep 2022 07:35:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v14 5/7] net: dsa: mv88e6xxx: rmu: Add
 functionality to get RMON
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-6-mattias.forsblad@gmail.com>
 <20220919110847.744712-6-mattias.forsblad@gmail.com>
 <20220919224924.yt7nzmr722a62rnl@skbuf>
 <aad1bfa6-e401-2301-2da2-f7d4f9f2798c@gmail.com>
 <20220920131053.24kwiy4hxdovlkxo@skbuf> <Yyoqx1+AqMlAqRMx@lunn.ch>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <Yyoqx1+AqMlAqRMx@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-20 23:04, Andrew Lunn wrote:
> On Tue, Sep 20, 2022 at 04:10:53PM +0300, Vladimir Oltean wrote:
>> On Tue, Sep 20, 2022 at 02:26:22PM +0200, Mattias Forsblad wrote:
>>> This whole shebang was a suggestion from Andrew. I had a solution with
>>> mv88e6xxx_rmu_available in mv88e6xxx_get_ethtool_stats which he wasn't fond of.
>>> The mv88e6xxx_bus_ops is declared const and how am I to change the get_rmon
>>> member? I'm not really sure on how to solve this in a better way?
>>> Suggestions any? Maybe I've misunderstood his suggestion.
>>
>> Can you point me to the beginning of that exact suggestion? I've removed
>> everything older than v10 from my inbox, since the flow of patches was
>> preventing me from seeing other emails.
> 
> What i want to do is avoid code like:
> 
>      if (have_rmu())
>      	foo()
>      else
> 	bar()
> 
> There is nothing common in the MDIO MIB code and the RMU MIB code,
> just the table of statistics. When we get to dumping the ATU, i also
> expect there will be little in common between the MDIO and the RMU
> functions.
> 
> Doing MIB via RMU is a big gain, but i would also like normal register
> read and write to go via RMU, probably with some level of
> combining. Multiple writes can be combined into one RMU operation
> ending with a read. That should give us an mv88e6xxx_bus_ops which
> does RMU, and we can swap the bootstrap MDIO bus_ops for the RMU
> bus_ops.
> 
> But how do we mix RMU MIB and ATU dumps into this? My idea was to make
> them additional members of mv88e6xxx_bus_ops. The MDIO bus_ops
> structures would end up call the mv88e6xxx_ops method for MIB or
> ATU. The rmu bus_ops and directly call an RMU function to do it.
> 
> What is messy at the moment is that we don't have register read/write
> via RMU, so we have some horrible hybrid. We should probably just
> implement simple read and write, without combining, so we can skip
> this hybrid.
> 
> I am assuming here that RMU is reliable. The QCA8K driver currently
> falls back to MDIO if its inband function is attempted but fails.  I
> want to stress this part, lots of data packets and see if the RMU
> frames get dropped, or delayed too much causing failures. If we do see
> failures, is a couple of retires enough? Or do we need to fallback to
> MDIO which should always work? If we do need to fallback, this
> structure is not going to work too well.
> 
> 	  Andrew

I understand want you want but I can see a lot of risks and pitfalls with moving
ordinary read and writes to RMU, which I wanted to avoid by first doing
RMON dump and then dump ATU and at a later stage with a better architecture
for write/read combining doing that, instead of forcing through read/writes
with all associated testing it would require. Can we please do this in
steps?

/Mattias
