Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107906BBC0E
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 19:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjCOS3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 14:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjCOS3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 14:29:10 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2576F2BED4;
        Wed, 15 Mar 2023 11:29:08 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id x1so1500947qtr.7;
        Wed, 15 Mar 2023 11:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678904947;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5kzsUfENqklMypk3rlgkphVzQ7vT68BMj3sk6qrsws8=;
        b=YD9ov6NYByOdc/DoNnoawPb5vi+rp+mpiCOr38jFVMmmzFgkQrf/RZdZyrVQxhVU0S
         nEzSS86G0GmQ1pJxYpNRrAp5kMhD7BORIzM3QpgpCZpGAj++7l/LBTcS7OOKIqaOnRii
         h1b/MU5B5Yv+CMqHQhxwAm12fbCIlOoQmVNX27QkUH4F+Zwovn5yWl8kEQ7odlOv+8fo
         DFw0f+W6DxhqTLcCnTjQsesvI21I/zzME41P/MJXPXk43LHpMpQ1CEJ0TAjqEEwU0xiA
         r5TWub55fVYhSKTUPdAtL01AnEQ96aCDpowwUsdi/FFhxd6xxAncmh/22RUNjaD4Soyi
         fvZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678904947;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5kzsUfENqklMypk3rlgkphVzQ7vT68BMj3sk6qrsws8=;
        b=7x+KSRDl/m2vD3JpujcZ4iNFPsIo9wS4rgIRGIwtpOZ2FC5EBvsKWV5P76josKIT7T
         zCiilf0hhO+0AdQ125qimU0PRZHZ2PKAyb3LwBNv4KJqqfrA8jvdzLvRlmYT+kyvfSE8
         SoaeLQFEvQfcbCPkRGQZX8g086ImUl9GDAZjtjnbcGiFbBNxfZtK2WKQEPdPaKzXqo25
         f+qTpwzqvCZ9fw5LRYHa1PLflsrOO6atcsqVudAl4cozhSwQV4tz8BCzH/A9bJh9g8fm
         cVLi2sBwxrUAVZRi981EQjRSMPwuaBVSxXy2Bq0MpZuTubfCjjg3Fz+Z0qHjnx1n0MX3
         yCIQ==
X-Gm-Message-State: AO0yUKUTiESV+7oqu6e9gN7WiGhrJkfsWnB1XNtwW6BNG0qX0eSclmRY
        lv0wT/Xk25NT3x2BdxFDLBw=
X-Google-Smtp-Source: AK7set8kiZVc0pCyC2w42NxdgsDntWFtwUrzV+DCpdLI1iFxWPgxNqbeQ5HzxJjLs/EOvFw3MhB5sg==
X-Received: by 2002:a05:622a:144e:b0:3bf:e415:5cc3 with SMTP id v14-20020a05622a144e00b003bfe4155cc3mr1261916qtx.58.1678904947200;
        Wed, 15 Mar 2023 11:29:07 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 17-20020ac85951000000b003b9a426d626sm4321789qtz.22.2023.03.15.11.29.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 11:29:06 -0700 (PDT)
Message-ID: <df32b84d-a39d-7dfe-c172-040ecf16f9c5@gmail.com>
Date:   Wed, 15 Mar 2023 11:29:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] net: dsa: b53: mmap: fix device tree support
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>
Cc:     jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230310121059.4498-1-noltari@gmail.com>
 <20230315000657.1ab9d9f4@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230315000657.1ab9d9f4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/23 00:06, Jakub Kicinski wrote:
> On Fri, 10 Mar 2023 13:10:59 +0100 Álvaro Fernández Rojas wrote:
>> diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
>> index e968322dfbf0..24ea2e19dfa6 100644
>> --- a/drivers/net/dsa/b53/b53_mmap.c
>> +++ b/drivers/net/dsa/b53/b53_mmap.c
>> @@ -263,7 +263,7 @@ static int b53_mmap_probe_of(struct platform_device *pdev,
>>   		if (of_property_read_u32(of_port, "reg", &reg))
>>   			continue;
>>   
>> -		if (reg < B53_CPU_PORT)
>> +		if (reg <= B53_CPU_PORT)
>>   			pdata->enabled_ports |= BIT(reg);
> 
> Should we switch to B53_N_PORTS instead?
> That's the bound used by the local "for each port" macro:
> 
> #define b53_for_each_port(dev, i) \
>          for (i = 0; i < B53_N_PORTS; i++) \
>                  if (dev->enabled_ports & BIT(i))

Yes, checking against B53_N_PORTS would be a better check.
-- 
Florian

