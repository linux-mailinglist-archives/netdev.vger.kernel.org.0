Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74D525F2711
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 01:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiJBXJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 19:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbiJBXIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 19:08:32 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C563F1C5;
        Sun,  2 Oct 2022 16:03:44 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id s206so8362217pgs.3;
        Sun, 02 Oct 2022 16:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date;
        bh=n1ZKaRc7L1J2HOhRbYn9RSi5qC1K6qbvvzoJx4l1wPI=;
        b=NQrtagJuL/eU9k+3dIZTrXanbh7ZCwRBOsXt30plUPXwV9cnJ5aUSC/Z/7kSPGjNPB
         w06BVt6WuYLmgiepoGqsH4FUQvhXQOJ1hM0pn5zytkEM25lS2pveUfUPwRrJSRqr3R3c
         VYL053MeF4TwZ7V3h1ekY+e122fqkv2WnxFMb1C8qyGpAEfjkxTOtvmrCyQmp8M8BjrE
         IZQh/6AGpIbaGxSdA5GIdlD6P+9QARM9ZKt3JKmWJ/uD45XbMqBBsnI30ziAtN1K78Gq
         LtIWqfiuX2oRgIAZpxj+hZXFjvsK2/YgrFjpiTW9OCoEVOpL5xer2dx4Vh9J4ZOnbLHc
         IVmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date;
        bh=n1ZKaRc7L1J2HOhRbYn9RSi5qC1K6qbvvzoJx4l1wPI=;
        b=nYdSl1woxhZTc2cDFhFO4JvYPrO2zRhQdGVQ5a5cu+Vc4p6oyySakA7y4z3SgLRrTE
         SXcGiQXnqpIMAakafTYoQhB5xfs8yR2BeQ6eBOH0aMAlhv9dB3fOqT9RPbF4kTp1DNKE
         h9dvJU9Ufz1IdYXZ4KH5YchEcpCoTBRowWJo7KFow7nK5O1P7w9QSPJPlqiuV8Z4/zyZ
         ihyEOm6bM0U6qOHvV+Qk4vMTaAiOV9hh533E0OqoH/l+WMuxywuLqMbLKz5c2u3+k3Pw
         Ik1k7msJlL4JyWOoSoow1whlzO1l0cjqcopybSoNlU3lpg0Vqn4fueJWCkItFaNq8t2w
         TV6A==
X-Gm-Message-State: ACrzQf181/sugW454P0XLvzpCxYYcUhwfx6JZ6rw64QGjOmFu0yBQqco
        TL8GCz/8ZqOGIuF++0zm9JA=
X-Google-Smtp-Source: AMsMyM4/g+UHH4GSV1/seyANUGimsPVf59o9/jOSn/Qy82po5YDBirhhImKDBvffmo1Iyrliw2/BQA==
X-Received: by 2002:a05:6a00:1503:b0:540:e2c7:2387 with SMTP id q3-20020a056a00150300b00540e2c72387mr19857714pfu.48.1664751774537;
        Sun, 02 Oct 2022 16:02:54 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s17-20020aa78bd1000000b0056160437e88sm1117103pfd.20.2022.10.02.16.02.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Oct 2022 16:02:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <035bb415-283f-e540-7c85-ae21103158de@roeck-us.net>
Date:   Sun, 2 Oct 2022 16:02:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next] net: drop the weight argument from
 netif_napi_add
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, kvalo@kernel.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org
References: <20220927132753.750069-1-kuba@kernel.org>
 <20221002172427.GA3027039@roeck-us.net> <20221002105938.684fec1f@kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20221002105938.684fec1f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/22 10:59, Jakub Kicinski wrote:
> On Sun, 2 Oct 2022 10:24:27 -0700 Guenter Roeck wrote:
>> On Tue, Sep 27, 2022 at 06:27:53AM -0700, Jakub Kicinski wrote:
>>> We tell driver developers to always pass NAPI_POLL_WEIGHT
>>> as the weight to netif_napi_add(). This may be confusing
>>> to newcomers, drop the weight argument, those who really
>>> need to tweak the weight can use netif_napi_add_weight().
>>>
>>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>>
>> That seems to have missed some (or at least one) file(s).
>>
>> Building mips:cavium_octeon_defconfig ... failed
>> --------------
>> Error log:
>> drivers/net/ethernet/cavium/octeon/octeon_mgmt.c: In function 'octeon_mgmt_probe':
>> drivers/net/ethernet/cavium/octeon/octeon_mgmt.c:1399:9: error: too many arguments to function 'netif_napi_add'
>>   1399 |         netif_napi_add(netdev, &p->napi, octeon_mgmt_napi_poll,
>>        |         ^~~~~~~~~~~~~~
>> In file included from include/linux/etherdevice.h:21,
>>                   from drivers/net/ethernet/cavium/octeon/octeon_mgmt.c:11:
>> include/linux/netdevice.h:2562:1: note: declared here
>>   2562 | netif_napi_add(struct net_device *dev, struct napi_struct *napi,
> 
> Fix sent, sorry. I don't see any more problems grepping again now..

I think that was the only one. The following coccinelle script helps.

Guenter

---
virtual report

@s@
expression a, b, c, d;
position p;
@@

   netif_napi_add@p(a, b, c, d);

@script:python depends on report@
p << s.p;
@@
print "Bad netif_napi_add() call at %s:%s" % (p[0].file, p[0].line)
