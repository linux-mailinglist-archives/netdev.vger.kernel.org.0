Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF8C63402D
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 16:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbiKVP3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 10:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiKVP3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 10:29:03 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA3C6204B
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 07:29:02 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id b21so13968708plc.9
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 07:29:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BWsgnK4bCpDB0AGVqu1iCJY+iEdGgMNXNw3iuBWpKl4=;
        b=N6MluBTM8SIc6fkevZ4t+ccu7hYeeTAmlk8FRw7dcD9ZYNCTgsxpTZszko8Bo19BUs
         ZdiJCJ7IhfZE0FMjWhzZEoOHIeB8zfbCBJIP4XUeJT7I+/Mk7IVeTKkH/UmLtR+mzHJv
         q3wJjBzRFi/GARJ1G0RyGi2OHP0W+hez4n4CVGHbtfdMdNbwaGMxJzk+uQo8Hb7WzXnr
         RWfdo4rTs/HhxDUu6tDLan38dWvK6tBrBe4jCV5r/HVS6+c9NDbf/d8pBS1vy3Ed8o7x
         CWfu/D/G3gJcr12lcTpTiMOc7IJ3ZHP+FM0TCJ1I08nHGKo62GHiXDGdsy3SCTzn4NBR
         1RNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BWsgnK4bCpDB0AGVqu1iCJY+iEdGgMNXNw3iuBWpKl4=;
        b=fNsJBbNYstKjkLKo8n03PLf9tIeGCmATkQbE9jjXO2xLMbfiNIg4xDIKubeFpHWMmX
         SmRK5AuT2hcI0wPxckhEX65D7wXHmf2yIpJ+tw17fo6A6o1iDfBJb3JcmQqWOkj0tb6y
         45c74Lp8smrvMQT57GnVla3+T4eKzIq44srmxe1tfgAfEvofKBFc7d34EcvsbTcXWsFS
         pmNw6M/uObUABxICwmg8bv3AYzHcQuOteFK2fSCibVc2FC/ma/m4/6r9DbE2dDdNCxWD
         BWx/vpccV3TSLYCoPWNUYERN1I1MDvPU8Mk/oVShxTnWYyYTXY+uuzjP6o2bCnRqMvlR
         zlHg==
X-Gm-Message-State: ANoB5plAEL0Q16n/wUw+bSCxZ3yIiM4gfAh5c4v/OvLFwPlXEb3zlKNK
        QoHUhHE+pMXhvVrbORzKPSL0wQ==
X-Google-Smtp-Source: AA0mqf7B1EtJOIh1AdECaEOUjkvP/y56NRXjQ7NLbasAhREBuuunEHbSNrXkp4b0Tqc0hez5awtz+w==
X-Received: by 2002:a17:90b:2544:b0:20a:f341:4ed9 with SMTP id nw4-20020a17090b254400b0020af3414ed9mr31723607pjb.11.1669130942296;
        Tue, 22 Nov 2022 07:29:02 -0800 (PST)
Received: from ?IPV6:2400:4050:c360:8200:8ae8:3c4:c0da:7419? ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id b8-20020aa78ec8000000b0056b8b17f914sm10736086pfr.216.2022.11.22.07.28.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 07:29:02 -0800 (PST)
Message-ID: <647a4053-bae0-6c06-3049-274d389c2bdd@daynix.com>
Date:   Wed, 23 Nov 2022 00:28:58 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [Intel-wired-lan] [PATCH] igbvf: Regard vf reset nack as success
Content-Language: en-US
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Yan Vugenfirer <yan@daynix.com>,
        intel-wired-lan@lists.osuosl.org, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20221122092707.30981-1-akihiko.odaki@daynix.com>
 <24fd3d18-0c09-8235-c88d-d7e151110ebe@molgen.mpg.de>
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <24fd3d18-0c09-8235-c88d-d7e151110ebe@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022/11/22 23:17, Paul Menzel wrote:
> Dear Akihiko,
> 
> 
> Thank you for your patch.
> 
> 
> Am 22.11.22 um 10:27 schrieb Akihiko Odaki:
>> vf reset nack actually represents the reset operation itself is
>> performed but no address is not assigned. Therefore, e1000_reset_hw_vf
> 
> Is … no … not assigned … intentional?
> 
>> should fill the "perm_addr" with the zero address and return success on
>> such an occassion. This prevents its callers in netdev.c from saying PF
> 
> occasion

I have just sent v2 with the message fixed.

> 
>> still resetting, and instead allows them to correctly report that no
>> address is assigned.
> 
> In what environment do you hit the problem?

I found this bug when I was developing a QEMU patch to emulate 82576.

Regards,
Akihiko Odaki

> 
> […]
> 
> 
> Kind regards,
> 
> Paul
