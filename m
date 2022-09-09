Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFC05B2E6F
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 08:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbiIIGF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 02:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiIIGFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 02:05:25 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B5D7F111
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 23:05:23 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id c10so632919ljj.2
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 23:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=LcEfTpWLWcqqsQqR/xOz6P9ozRzAV5pX8OhA+J6JY5U=;
        b=dHiaUaKLzHzHJgJ5MnlYLsyrv5oF1UbkcwJth3awqKMk8ZeRFI/+6gyN2puKTDesE/
         km2f3YXJloRk4pVg6baCliUG0wc2V1qkNhvn0RflhA9ehih/6EEK9T4ScMHEDNuPJUBV
         aUqvagg9vJWW3pAREBSQnEqPKgotqTJUG4CFpirng6bI2efhL5a4zTB5KXExEe1svr7M
         92Pl4e7Bsmk4IVBJaOHF96FBlRD8N0u4BoBgk3ycGGoWT325dXb0+Fqlwo+WuSjzX7BH
         W4gZtD1dthKTjhD8lMJvdp5O9Vn0xTLuYHMNfm4dCBTpC4HpGAfF60lSc5Mj65lnJede
         FjiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=LcEfTpWLWcqqsQqR/xOz6P9ozRzAV5pX8OhA+J6JY5U=;
        b=b2BqsS1FCN3Xg/7gIL7nZNjV+jMr7/lrPZ8N4rcbbf2IKMM7y7PN4b1ro20+FLxaFT
         ULvtRRoYFEf1T0U2b54x1DW/Q+d/B8+Gf+TAwFlEh6YOSaJSI+Gy2e2Vtc6STNep607w
         3MOe6LDQ5fvpcPXKJr982cA0HN5nyh28YCEH759F4lw5/hAu2aU2hJEseIEQKT+JEawX
         0TKSes6SEiWnU/C8IZLhQeC/o4WZB/4NteMuyu/t27UlscBmgo3xSIM6rmvPX+85PrW3
         YWIEpZsVww1fkhn8j3zsJ+bG1JbfyybNC1E6wLmb/hNe+qZ4+yo+YufV//OPm+vIKQuo
         BhQw==
X-Gm-Message-State: ACgBeo3GzDp7mAh+4AdqDp+bwfsZdsVARGJFroJkfbnD2grYWEBlSBnf
        e5HdU0k/G3f6+CwUymjaBao=
X-Google-Smtp-Source: AA6agR7o1va4yPhYSDwvdltNxmPr2hYC2kStoaa9s/IWArmNkhHZRTFy5osSe5BWqB6ui/YINYLmLw==
X-Received: by 2002:a2e:9098:0:b0:263:da35:4f59 with SMTP id l24-20020a2e9098000000b00263da354f59mr3298683ljg.100.1662703521809;
        Thu, 08 Sep 2022 23:05:21 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id x4-20020a056512078400b0048b309aeb09sm126709lfr.226.2022.09.08.23.05.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 23:05:21 -0700 (PDT)
Message-ID: <6abb67fe-7544-b8b6-f136-dd52e4a512a9@gmail.com>
Date:   Fri, 9 Sep 2022 08:05:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v7 4/6] net: dsa: mv88e6xxxx: Add RMU
 functionality.
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220908132109.3213080-1-mattias.forsblad@gmail.com>
 <20220908132109.3213080-5-mattias.forsblad@gmail.com>
 <YxqYjoZeGhYIZ29b@lunn.ch>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <YxqYjoZeGhYIZ29b@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-09 03:36, Andrew Lunn wrote:
>> +
>> +	dsa_switch_inband_complete(ds, NULL);
>> +}
>> +
>> +int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip)
>> +{
>> +	mutex_init(&chip->rmu.mutex);
>> +
>> +	/* Remember original ops for restore */
>> +	chip->rmu.smi_ops = chip->smi_ops;
>> +
>> +	/* Change rmu ops with our own pointer */
>> +	chip->rmu.rmu_ops = (struct mv88e6xxx_bus_ops *)chip->rmu.smi_ops;
> 
> Why do you need a cast? In general, casts are wrong, it suggests your
> types are wrong.
>

So we want want to have the original ops from chip->smi_ops as
we cannot know which ones they are (mv88e6xxx_smi_dual_direct_ops/
mv88e6xxx_smi_direct_ops/mv88e6xxx_smi_indirect_ops). This is to be
able to restore them when appropriate. They are declared const. 
But we want to replace get_rmon in our own version of ops
with mv88e6xxx_rmu_stats_get, hence that version cannot be const.

/Mattias
 
>> +	chip->rmu.rmu_ops->get_rmon = mv88e6xxx_rmu_stats_get;
>> +
>> +	if (chip->info->ops->rmu_disable)
>> +		return chip->info->ops->rmu_disable(chip);
> 
> Why is a setup function calling disable?
> 
>     Andrew

