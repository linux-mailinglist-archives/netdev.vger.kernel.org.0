Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C895D66A766
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 01:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbjANAMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 19:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbjANAMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 19:12:48 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3797D1CF
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 16:12:47 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id v23so20104555plo.1
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 16:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h+wuFIogdRNmOhV3/uucr1qV5lysOspbgejki0Cx1DE=;
        b=aUlw8BKDe3SEOL07UjbzEUzyZXKtSIToARRUbmAOCkcP16arXy2zAQvtL+0vNEq9+N
         F7Fh2MT/fKnBLLNh97HNu9H7V6nd1Y212oryuXBlomZB/JQgWmhoB0xB2oIxnpPCzyYx
         cInk1DannkJdSW3SEGZL6CtdTuYQxTt2ua7agx92WK6z8pa1g8V+HAWQLc74uvHm9SlU
         6UNkSG1T46rZEflLXl8XxZAqzyd2vPIqmS5V7JGt8HffjXllnMhwHbSgx1AxTsDB68vf
         Hc7wbKQobSaLGagM/JJqze40TYzA4gqGIAAU1VZB2rMhJc4CLL67VaJx62bUsLFK6FAY
         UX8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h+wuFIogdRNmOhV3/uucr1qV5lysOspbgejki0Cx1DE=;
        b=EQwWu1yCSAHiPE5Uyc8wMDoF6SP7UM87rU/R2+eiJOn636VoxmFK2gEID0uh4Eupv3
         wkG9uyVbAtCpndn0q34nGRxvttV5eNLAqb5k4y6TePQGO6w4NxfywfasNSI8DyA/Z6BL
         /mupJhRZ0ev6BX20AMPKRuHEaR3kjkhTSObMkSO+mXb/kKu7dyJlRC4V91i+V516FASe
         aKDjIAglqyMHs608GPDad2LOmgNqCgz8hffFaUN+DgZT39mNnfcN89Gj4rNhqnaK61cp
         +eVVG2+hvmVyE93doQAFLO+A9sTf6xp1YScxSwje3hMjwPLpAstG3fLttBfPzj2a3ydE
         nhVw==
X-Gm-Message-State: AFqh2koEVK/9j2nbK16qCehNwkJPKT4t4i4ZW8xGM/mvdnZfO1l+XRtR
        32pz+pyz/2ILgy3nZ49cSTA=
X-Google-Smtp-Source: AMrXdXuFai9XLuYypGYv/lkEf5TFgrvNT4SJTF8BHIvFQOYqGtbJndmp1JAfooP0gHuTIkLbySRS9g==
X-Received: by 2002:a17:902:8484:b0:192:d631:be14 with SMTP id c4-20020a170902848400b00192d631be14mr37692659plo.13.1673655167143;
        Fri, 13 Jan 2023 16:12:47 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id w13-20020a170902ca0d00b001930b189b32sm1808631pld.189.2023.01.13.16.12.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 16:12:46 -0800 (PST)
Message-ID: <4074be6b-8e3e-9cd3-93ee-b958388a2e5c@gmail.com>
Date:   Fri, 13 Jan 2023 16:12:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH ethtool 2/3] netlink: Fix maybe uninitialized 'meters'
 variable
Content-Language: en-US
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Markus Mayer <mmayer@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <20230113233148.235543-1-f.fainelli@gmail.com>
 <20230113233148.235543-3-f.fainelli@gmail.com>
 <20230114000920.izp4tzfcn4cbciec@lion.mk-sys.cz>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230114000920.izp4tzfcn4cbciec@lion.mk-sys.cz>
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



On 1/13/2023 4:09 PM, Michal Kubecek wrote:
> On Fri, Jan 13, 2023 at 03:31:47PM -0800, Florian Fainelli wrote:
>> GCC12 warns that 'meters' may be uninitialized, initialize it
>> accordingly.
>>
>> Fixes: 9561db9b76f4 ("Add cable test TDR support")
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>   netlink/parser.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/netlink/parser.c b/netlink/parser.c
>> index f982f229a040..6f863610a490 100644
>> --- a/netlink/parser.c
>> +++ b/netlink/parser.c
>> @@ -237,7 +237,7 @@ int nl_parse_direct_m2cm(struct nl_context *nlctx, uint16_t type,
>>   			 struct nl_msg_buff *msgbuff, void *dest)
>>   {
>>   	const char *arg = *nlctx->argp;
>> -	float meters;
>> +	float meters = 0.0;
>>   	uint32_t cm;
>>   	int ret;
>>   
> 
> No problem here either but it's quite surprising as I check build with
> gcc versions 7 and 11-13 (10-12 until recently) for each new commit and
> I never saw this warning. As the warning is actually incorrect (either
> parse_float() returns an error and we bail out or it assigns a value to
> meters), it may be a gcc issue that was fixed in a later version. But
> initializing the variable does no harm so let's do it.

Yes that might be the case, this was seen with GCC 11.3 as well. I 
definitively did use a GCC12 pre-release at some point, too.
-- 
Florian
