Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEBF5A8214
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 17:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbiHaPqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 11:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbiHaPpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 11:45:46 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0E9C2E8B
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 08:44:26 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id bu22so18475511wrb.3
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 08:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile-fr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=Q7NDdXUuhJCGTR6sd4zBlY6bNAnOrqb1GQdfMNLV44w=;
        b=ExqNisLvakC0FUfaFZAVLhMn5ntmkn7sxo9yFrzhLkSxeHhHVKwUk9pwRuPA1doLYb
         5vNR+kBRgiLSrr9JMiPUs3y4lKy/q8hv6iYQfEKUxh+OEe7Qr9hiI7xytLRJdPegKOfj
         BHuCn36wKKBltb1zTgY412R48itmo8L9u8pu/x7z2XMhpefX436INv9JBitR2AKZur4U
         /lL+8ozrpjL+XZDiusGax2kQu1Pja3NNdSdL1IQLRm7YnppW2UBerun0pKMJdXQh6iWt
         uoTY4VmE7MfQHZQgQLmXYwU4VOEfD7qRZ3xBGUCcvIafo2Fy2R2D+Kb3V4gVknORNlhw
         RSaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Q7NDdXUuhJCGTR6sd4zBlY6bNAnOrqb1GQdfMNLV44w=;
        b=wds2ZmrpKzcUU1ZXecJeV/ef8gShYR9MeM245X6dk22INVDPGmSwj0XIxrM7+Yw+bq
         HON74Naqn6BO73kjA8BUkfvsPMqoIzF3MgIH4Ikp9av0UW7aUQXnXctajAhnVv/QWm+B
         5sXJmFuY2X0arOIs7+JBsmfnsMJuTTkjMKvHT3D0kdJTcvoLYe2vFcA1bHAbZeCYLZqb
         OLTvrhlblC628y42mbtkSQSevUb1z9VUqCC2w80z8d26ySptcGJkark611Uua3ILWu99
         GsSQa3znt0m9+4eklU4XoRayc5OUjlC7ZEdef2yDIjLiFqYHkzdSV9PqcZhz2njqodTj
         u+rQ==
X-Gm-Message-State: ACgBeo1jfQSInDPCFUkzhAnq/1uJPhHhQSk9yPud4G8iwwFtYooDuPrg
        RMBLvo//dRSyvouCGjH3FlUeeFzgrrEowg==
X-Google-Smtp-Source: AA6agR5YnmsLWT5HkRYfCmnl+AkSdNAVLpMGdCVDu0QgYVbdHSTmZmeW26cy5e/ypi0pt+IRiKfRFQ==
X-Received: by 2002:a05:6000:1ac7:b0:225:1cb4:d443 with SMTP id i7-20020a0560001ac700b002251cb4d443mr11652035wry.501.1661960609190;
        Wed, 31 Aug 2022 08:43:29 -0700 (PDT)
Received: from ?IPV6:2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f? (2a01cb058f8a18001c97b8d1b477d53f.ipv6.abo.wanadoo.fr. [2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f])
        by smtp.gmail.com with ESMTPSA id k25-20020adfd239000000b0021e43b4edf0sm12191938wrh.20.2022.08.31.08.43.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Aug 2022 08:43:28 -0700 (PDT)
Message-ID: <e7ba61d7-de75-3cfe-ee92-3f234dd36289@smile.fr>
Date:   Wed, 31 Aug 2022 17:43:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2 1/2] net: dsa: microchip: add KSZ9896 switch support
Content-Language: fr
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        Romain Naour <romain.naour@skf.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
References: <20220830075900.3401750-1-romain.naour@smile.fr>
 <20220831153804.mqkbw2ln6n67m6jf@skbuf>
From:   Romain Naour <romain.naour@smile.fr>
In-Reply-To: <20220831153804.mqkbw2ln6n67m6jf@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Le 31/08/2022 à 17:38, Vladimir Oltean a écrit :
> Hi Romain,
> 
> On Tue, Aug 30, 2022 at 09:58:59AM +0200, Romain Naour wrote:
>> It seems that the KSZ9896 support has been sent to the kernel netdev
>> mailing list a while ago but no further patch was sent after the
>> initial review:
>> https://www.spinics.net/lists/netdev/msg554771.html
>>
>> The initial testing with the ksz9896 was done on a 5.10 kernel
>> but due to recent changes in dsa microchip driver it was required
>> to rework this initial version for 6.0-rc2 kernel.
>>
>> v2: remove duplicated SoB line
> 
> To be clear, was the patch also tested on net-next, or only formatted there?

The patch was runtime tested on a 6.0-rc2 kernel and a second time on a 6.0-rc3
kernel but not on net-next.

Is it ok with rc releases or do I need to test on net-next too?

Best regards,
Romain
