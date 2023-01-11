Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB1B6664B2
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 21:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbjAKURl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 15:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbjAKURd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 15:17:33 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8728F13CE7
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 12:17:32 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id i17-20020a05600c355100b003d99434b1cfso13589853wmq.1
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 12:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xn1JhdSheqZ40ZZK1vqBwjDLJI4Yk4Kd28zIDssNoNs=;
        b=oOHmPrxKHVYMxKA2/VQYF01bKKtKo4Ci3VPbAxm+q8nbYHZ3FMHayZum+6syDdUJ5b
         Sc37kIf2RXY979WskvImCFNotiyP2dVqqMfBAQJ6pS/jcGmRJ8tOz+/wVTO9eJqq2R/f
         es4Ut0BnSOEuiMMU9hGMDXSMQAlO2v/+ZqbheGlB6vo1Uq3CkMLDTQ561BxW4Pgox/pB
         IDZd1MQTp0ZAgjMheAQGmaNBNocMbR9OkleCpTssH5fIVPC5QZ6efJ7OWwxFfFLPVI6d
         13jn4ws7qiNoAtlpmJwPkJ7NvC5MGBJ5WzCS48YFNNPEby3YIavTE3Mu0Yp7/QkL5BNz
         EThg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xn1JhdSheqZ40ZZK1vqBwjDLJI4Yk4Kd28zIDssNoNs=;
        b=4VuWgu8Qnn7KN8YmLhDW2LyuEpVtoLlXNJTbeAIToUzuSISfuapfc7SFuEemEUzVQY
         teYnG5d6RsvdJ/m8lxWXx4S68B/zR3e61tasJiFksPysMpiiF/ooY7S4vEi3woz+jL1i
         FYsqqCO0BHPrxxkYGdjntyan0yWCYfOkykrhC4l7jvZhJHD7F9JG45RJ6WQt7dSC9PrE
         FDw6K1rW6FsZY/owjaJ08Cdb0mhvdgCruN5V0ovtxOmCUu+Q5ail2+lJ688qEdYRMrqK
         EOGmkQKpelE08LqWkrJLzxezJ0vkQtVZAu06tknq6OE3LDOqYISv1AGSPkbgKaHXOiXE
         DH8A==
X-Gm-Message-State: AFqh2krI96k4Hteo/AUvYVtyBu9k8mWgQxn9hHFjd8D78ogv5stQvC1X
        iG+Gjry9vSwpHZExY7v7hX4=
X-Google-Smtp-Source: AMrXdXuj120eBZst7BRNcwibtmn8S0YZKjPQOpsc2y9XCB6ImB6VRzTnHqt5YpW6eIez7a2+jrhzOw==
X-Received: by 2002:a05:600c:21d9:b0:3d0:8d48:2993 with SMTP id x25-20020a05600c21d900b003d08d482993mr52324031wmj.36.1673468250956;
        Wed, 11 Jan 2023 12:17:30 -0800 (PST)
Received: from ?IPV6:2a01:c22:76e4:3a00:509b:51f2:b41a:a9cd? (dynamic-2a01-0c22-76e4-3a00-509b-51f2-b41a-a9cd.c22.pool.telefonica.de. [2a01:c22:76e4:3a00:509b:51f2:b41a:a9cd])
        by smtp.googlemail.com with ESMTPSA id d8-20020a05600c34c800b003c5571c27a1sm23432843wmq.32.2023.01.11.12.17.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 12:17:30 -0800 (PST)
Message-ID: <fc80b42a-e488-e8a2-9669-d33a5150ac9b@gmail.com>
Date:   Wed, 11 Jan 2023 21:17:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <92369a92-dc32-4529-0509-11459ba0e391@gmail.com>
 <a709b727f117fbcad7bdd5abccfaa891775dbc65.camel@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next resubmit v2] r8169: disable ASPM in case of tx
 timeout
In-Reply-To: <a709b727f117fbcad7bdd5abccfaa891775dbc65.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.01.2023 17:16, Alexander H Duyck wrote:
> On Tue, 2023-01-10 at 23:03 +0100, Heiner Kallweit wrote:
>> There are still single reports of systems where ASPM incompatibilities
>> cause tx timeouts. It's not clear whom to blame, so let's disable
>> ASPM in case of a tx timeout.
>>
>> v2:
>> - add one-time warning for informing the user
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
>>From past experience I have seen ASPM issues cause the device to
> disappear from the bus after failing to come out of L1. If that occurs
> this won't be able to recover after the timeout without resetting the
> bus itself. As such it may be necessary to disable the link states
> prior to using the device rather than waiting until after the error.
> That can be addressed in a follow-on patch if this doesn't resolve the
> issue.
> 

Interesting, reports about disappearing devices I haven't seen yet.
Symptoms I've seen differ, based on combination of more or less faulty
NIC chipset version, BIOS bugs, PCIe mainboard chipset.
Typically users experienced missed rx packets, tx timeouts or NIC lockups.
Disabling ASPM resulted in complaints of notebook users about reduced
system runtime on battery.
Meanwhile we found a good balance and reports about ASPM issues
became quite rare.
Just L1.2 still causes issues under load even with newer chipset versions,
therefore L1.2 is disabled per default.

> As for the code it looks fine to me.
> 
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

