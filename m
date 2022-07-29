Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F735585232
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237087AbiG2PRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiG2PRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:17:51 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC964D14E
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 08:17:50 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id bp15so9079215ejb.6
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 08:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=3ZwoFUY2YsxDSsQJ7C6bm9jR9h0XZ+8TuXl3qNy5TiM=;
        b=o9t9KtyOvy4ld0FBtzRsCW9s1vMoMCox7tNTxGdJi6V3eO+B46GIfJyZPyPCs9T43K
         5v5sHCD6Sa4ERCLVd6t9Infp75dDw2AxW2AmAJUFY+jLUnFQwFygX59efqvtIAV3z9tq
         th3INv7BywB4QVEO2RWBEcP2WuELM3cg/fRFurUUYfY7vYlDRA35LgBOWic0qGuHeJ5h
         JiWUe1BX2Y3vbSBLhCq0AhKhkp2DNrVA9O0T+TNqRxoUHFJDRhp65o0K0vq8zRkIkaJ5
         HkYky8SXPjIjBVQXgPOhg/P+JV1QKSnq48FUYZl7kuCH96pEoBf1GC3BnlFzi9FxU7pZ
         KSnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=3ZwoFUY2YsxDSsQJ7C6bm9jR9h0XZ+8TuXl3qNy5TiM=;
        b=awUfJvsduy7/9XcYmTdOkdTbgMlQCpuW+rpqOF5AUEuIxbH4XC4fHRY/ck2MdPG3LF
         lHDa1pfrCiSqB5dnKcJM8glspKk2+vIXOcCT6uBLl1yjMIOBNdL8NFWe1MyjqbmiBk4R
         Q39W1NOes8frmWTlK6DhEtrbP+mk1BoRjGlscW9tvUE2FZI1DOJis3WDfCkHhW7N7rhu
         9W3vW9hsDa7K8UJrjR5dhh8V1x35Q6FvKwItkqt0PgoRKs87wSZ69WFlGUAiijZjGdIX
         QfqQiGwUNGjVJ0Fp8LGSlD/PYwLV1ma6z4pm8gpCTyJ1iM7esJNx+3dZl6cOVlJHrTTb
         R8Ig==
X-Gm-Message-State: AJIora/SN2IuBb9Gjvuf++p+nZ3REriZ6SyAqUOqkfIdHWbBCkNGwHHg
        F1yF1rHCO9siO774Wn8n16weAYtZSJg=
X-Google-Smtp-Source: AGRyM1u7Rry+5VsQt9aaHa1748Y6N4XNFgeVstTDjUZ3hWwpi/+GKh3D0l8fRrRAFqmudxD3Ac7oww==
X-Received: by 2002:a17:907:9495:b0:72f:a158:7598 with SMTP id dm21-20020a170907949500b0072fa1587598mr3149118ejc.410.1659107868812;
        Fri, 29 Jul 2022 08:17:48 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id f27-20020a17090631db00b0072b342ad997sm1812683ejf.199.2022.07.29.08.17.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 08:17:48 -0700 (PDT)
Subject: Re: [PATCH net-next v2 12/14] sfc: set EF100 VF MAC address through
 representor
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     ecree@xilinx.com, davem@davemloft.net, pabeni@redhat.com,
        linux-net-drivers@amd.com, netdev@vger.kernel.org
References: <cover.1658943677.git.ecree.xilinx@gmail.com>
 <304963d62ed1fa5f75437d1f832830d7970f9919.1658943678.git.ecree.xilinx@gmail.com>
 <20220727201034.3a9d7c64@kernel.org>
 <67138e0a-9b89-c99a-6eb1-b5bdd316196f@gmail.com>
 <20220728092008.2117846e@kernel.org>
 <8bfec647-1516-c738-5977-059448e35619@gmail.com>
 <20220728113231.26fdfab0@kernel.org>
 <bfc03b98-53ce-077a-4627-6c8d51a29e08@gmail.com>
 <20220728122745.4cf0f860@kernel.org>
 <5a4d22f2-e315-b6f4-5fb5-31134960c430@gmail.com>
 <20220728184527.3f3dd520@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <f0f5e9c8-d811-3412-a298-628e7abf4ba9@gmail.com>
Date:   Fri, 29 Jul 2022 16:17:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220728184527.3f3dd520@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
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

On 29/07/2022 02:45, Jakub Kicinski wrote:
>> Devlink port function *would* be useful for administering functions
>>  that don't have a representor.  I just can't see any good reason
>>  why such things should ever exist.
> 
> The SmartNIC/DPU/IPU/isolated hv+IO CPU can expose storage functions
> to the peer. nVidia is working on extending the devlink rate limit API
> to cover such cases.

All the storage-on-SmartNIC setups I can imagine involve the storage
 function (e.g. a virtio-blk PF) being connected to the network switch,
 either to access remote network storage or to export the local storage
 over the network.  (I'm not quite sure why you'd bother combining
 storage and networking functionality onto a single device if they
 _weren't_ connected in this way.)
Which means that your storage function has a v-switch port, and thus
 should have a representor netdevice so you can e.g. use tc rules to
 define its access to the physical network.
Arguably any network rate limiting you then want to apply to that
 function's v-switch port should be in the form of a tc police action.
(Which is far more flexible than devlink rate, because you can have
 different policers for traffic matching different tc filters, e.g.
 separate rate limits for control and data traffic of the dFS.)

Idk, maybe I'm being crazy in assuming that hardware has sane design
 semantics.  But the obvious way to build a SmartNIC maps very cleanly
 onto representors, without any need for devlink port function, and I
 think it makes more sense to say that maybe some weird device might
 end up having representors to control some objects that don't have
 network access, than that everyone has to implement this whole
 parallel structure of devlink objects for things that already have
 representors.

-ed
