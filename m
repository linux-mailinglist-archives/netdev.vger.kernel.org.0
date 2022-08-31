Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44A85A88FB
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 00:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbiHaWZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 18:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbiHaWZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 18:25:13 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601FB1A38A
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 15:25:06 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id e20so19977360wri.13
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 15:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile-fr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=7msZ9KrOQUATSY6jSpmS2k4YBwGYja9aEK4iqR2AAj4=;
        b=6pcbMiQ8oonJRFZJ4V5w7b2Oo1DMiW/5JIjhfeWyv/fnbK/MhCCmSgR8SuTGPyEers
         p129jAvSmVBkaJ9XhbD16Bai6aBrvtCEvwjlqPm5YsrlvW2qzhC494a7xG4WSI4nibqX
         MILwWQb3Ua15M1EgJl0gV5lz6iHBLNzsA1JWdXjW+Ur4ry0Fb9TsTKAgj1kmc+N447YS
         YsGndh4ULzrrRMDHE0kFXNk8P2L/Tmnko332mu+2Mwkdci35ugVXLGThgBer8q7uB9I0
         SQUCY0Xi/CerAxGZDJ7s/HfEj4y9Md7VjMSwEzrBjhfWNIyOzDP9p6t7DCn2xgVLVGFE
         PPuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=7msZ9KrOQUATSY6jSpmS2k4YBwGYja9aEK4iqR2AAj4=;
        b=lUN2AoyfKaokzp4NJw4Y80FD5bDDGivjcnP72Usfoc8ERB6dO8Ce0Py13DuSq5ZcLf
         OquNgvYoy/nmePeV6f6GAml86WJtcx80r5N8VFy+hyna7I0qdEq132pVHgBB4H3njA28
         QJk1COoIq3HeN8Xt2gvtc2yfbfk5e8utgbP+3sENmBzjqrare0bTpYpHxEAk7oH3Ulhn
         /EqjqVZTDwciD3lMVas5wAkcfLOJArtDpTQKQvQbCM/FmA/AglTwSRSSBKph/ShLPcJ2
         4V8J3uxTjN5MPi/6vGzAbIZza4RvOvp/ET6XlQglcQNnXNK0x0rn5R3VT/WCKnQOXOu3
         BvVA==
X-Gm-Message-State: ACgBeo10pvKAnpD98629A37Bn1XJJws33XZl4t8Fn7vw/OJnKyGLm9bV
        AppkWwdKIeLfViGwIOtNnWe7FQ==
X-Google-Smtp-Source: AA6agR6HLAimVDmYcB9Dkk3LrRos0i3+93b8OLrd2Tn8AR5yH2ut+dJyF35K8J2MtIJwQJUqW/wiPA==
X-Received: by 2002:a5d:6da9:0:b0:225:59e2:ee40 with SMTP id u9-20020a5d6da9000000b0022559e2ee40mr12621788wrs.540.1661984705313;
        Wed, 31 Aug 2022 15:25:05 -0700 (PDT)
Received: from ?IPV6:2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f? (2a01cb058f8a18001c97b8d1b477d53f.ipv6.abo.wanadoo.fr. [2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f])
        by smtp.gmail.com with ESMTPSA id az25-20020a05600c601900b003a5537bb2besm3553150wmb.25.2022.08.31.15.25.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Aug 2022 15:25:04 -0700 (PDT)
Message-ID: <e72786ef-68ec-52c5-f5a8-6a5e131db2ca@smile.fr>
Date:   Thu, 1 Sep 2022 00:25:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2 1/2] net: dsa: microchip: add KSZ9896 switch support
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        Romain Naour <romain.naour@skf.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
References: <20220830075900.3401750-1-romain.naour@smile.fr>
 <20220831153804.mqkbw2ln6n67m6jf@skbuf>
 <e7ba61d7-de75-3cfe-ee92-3f234dd36289@smile.fr>
 <20220831155103.2v7lfzierdji3p3e@skbuf>
From:   Romain Naour <romain.naour@smile.fr>
In-Reply-To: <20220831155103.2v7lfzierdji3p3e@skbuf>
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

Le 31/08/2022 à 17:51, Vladimir Oltean a écrit :
> On Wed, Aug 31, 2022 at 05:43:27PM +0200, Romain Naour wrote:
>> The patch was runtime tested on a 6.0-rc2 kernel and a second time on a 6.0-rc3
>> kernel but not on net-next.
>>
>> Is it ok with rc releases or do I need to test on net-next too?
> 
> The kernel development process is that you normally test a patch on the
> git tree on which it is to be eventually applied.
> 
> The net-next.git tree is periodically (weekly) merged with the 6.0
> release candidates where bug fixes land, but it contains newly developed
> material intended for the 6.1 release candidates (hence the "next" name).

The gap between the kernel 6.0 and the kernel vendor (5.10) used initially is
huge. Initially the 6.0 kernel didn't boot at all on the custom board I'm using
with the KSZ9896. The 6.0-rc2 kernel seemed bleeding-edge enough for upstream.

> 
> If you keep formatting development patches against the plain 6.0 release
> candidates, you may eventually run into a conflict with some other new
> development, and you may never even know.

Actually there was no conflict until the merge of the series "net: dsa:
microchip: add error handling and register access validation"

At least I need to add the .gbit_capable entry in ksz_switch_chips[].

I'm not sure about the new register validation for KSZ9896.

Best regards,
Romain
