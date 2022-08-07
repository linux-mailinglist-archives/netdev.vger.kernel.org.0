Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151EC58BA2D
	for <lists+netdev@lfdr.de>; Sun,  7 Aug 2022 10:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbiHGINV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 04:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiHGINT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 04:13:19 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4A7658E
        for <netdev@vger.kernel.org>; Sun,  7 Aug 2022 01:13:16 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id j1so7738419wrw.1
        for <netdev@vger.kernel.org>; Sun, 07 Aug 2022 01:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=tmFUfNh4QVWf7FV8JQO2RKCgPx5VNgT+zHlqt4Xmqxs=;
        b=Wy9WVbtviABX125m8AEBinwUx07M4uBXmvXD+wXutiO3gtwpCQioeNgkQ3lDr6f342
         nITZw3dJHsR7EdYAGCgAesjXNT84m5WxufiTfQ0xC6My9pOKaf8IsaYbJInwRW7CqnlS
         mOSJji/OrXOCzev7z6SzEJ5qnK8QQmXfLY0pXIiqwXz9vFLnThotT8pF7s6DcsORHjVx
         HoSiK0DSj484PoWtSAaUL8MzPv02m0lvI4Xi5grOgnTAisXGkc1zmSNBb+aDfsSOrGPj
         TXajyF/XR2x3OQzI8bOdOKeoTmBYfLeIeENBwwbjyEMD9ImCukIFSTNDJCxASFoAV7Bs
         onew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=tmFUfNh4QVWf7FV8JQO2RKCgPx5VNgT+zHlqt4Xmqxs=;
        b=0sdeaIEtGzXHDo2pL6aITsYCedsu5RKb+ptIGQOXuI4cQXNQN79qbMLXlA0WO+A2w8
         UYnUBwWvauStTZ7XGXCmBTM6BPKtkaWfFTVY7Sux9klInormqMQaivTCKXEhfDELqpuB
         lQhEvlZfxgRU9vi0N06Ywf9TSC3ytStKgoKW0zJbfIOEozCTQAUFVhgam6tcwQbZ7LEG
         56eyGvWcQAZaINTLbxB8LmmrMGUaun4dv6deuBfoeBwHuF+9lAMEfMZPHCEvcBKxtSJf
         MP/ErAZZKi+8F7lDlbaQqEphu4pZ6kvasDqHq6W6Awg/z3RbFsjknan0wP2gvDpoj+kO
         zfQA==
X-Gm-Message-State: ACgBeo23OcqVTRKDsYyzgY7NiVakkkf7mlITYj6C2hhl2hXKU9KFJ54W
        SswunkLB4JaAqJmn+R+cpY0=
X-Google-Smtp-Source: AA6agR7mS1bNs6ux+L0LbXROZxAak8T9QuNG+7DzwSbVO8l+pQOexVfDWYZeCtqrLgIWEZbpD4bkPw==
X-Received: by 2002:adf:fbc7:0:b0:220:6004:18ca with SMTP id d7-20020adffbc7000000b00220600418camr8301142wrs.632.1659859995566;
        Sun, 07 Aug 2022 01:13:15 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id x17-20020adfec11000000b0021ee0e233d9sm8363152wrn.96.2022.08.07.01.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Aug 2022 01:13:15 -0700 (PDT)
Message-ID: <69f24a98-bd59-a0b6-5ed2-332de03b2131@gmail.com>
Date:   Sun, 7 Aug 2022 11:13:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH main v2 2/3] macsec: add Extended Packet Number support
Content-Language: en-US
To:     Emeel Hakim <ehakim@nvidia.com>, David Ahern <dsahern@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
References: <20220802061813.24082-1-ehakim@nvidia.com>
 <20220802061813.24082-2-ehakim@nvidia.com> <Yuv4RXYlYE6LM2d5@hog>
 <5798fe5b-8424-c650-aac0-5293e1d907b4@kernel.org>
 <IA1PR12MB635329D8F3D33A42C5977D1EAB609@IA1PR12MB6353.namprd12.prod.outlook.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <IA1PR12MB635329D8F3D33A42C5977D1EAB609@IA1PR12MB6353.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/7/2022 10:01 AM, Emeel Hakim wrote:
> 
> 
>> -----Original Message-----
>> From: David Ahern <dsahern@kernel.org>
>> Sent: Thursday, 4 August 2022 21:37
>> To: Sabrina Dubroca <sd@queasysnail.net>; Emeel Hakim
>> <ehakim@nvidia.com>
>> Cc: netdev@vger.kernel.org; Raed Salem <raeds@nvidia.com>; Tariq Toukan
>> <tariqt@nvidia.com>
>> Subject: Re: [PATCH main v2 2/3] macsec: add Extended Packet Number
>> support
>>
>> External email: Use caution opening links or attachments
>>
>>
>> On 8/4/22 10:48 AM, Sabrina Dubroca wrote:
>>> Hi Emeel,
>>>
>>> 2022-08-02, 09:18:12 +0300, ehakim@nvidia.com wrote:
>>>> diff --git a/include/uapi/linux/if_macsec.h
>>>> b/include/uapi/linux/if_macsec.h index eee31cec..6edfea0a 100644
>>>> --- a/include/uapi/linux/if_macsec.h
>>>> +++ b/include/uapi/linux/if_macsec.h
>>>> @@ -22,6 +22,8 @@
>>>>
>>>>   #define MACSEC_KEYID_LEN 16
>>>>
>>>> +#define MACSEC_SALT_LEN 12
>>>
>>> That's not in the kernel's uapi file (probably was forgotten), I don't
>>> think we can just add it here.
>>>
>>
>> can't. uapi files are synched with kernel releases, so that change would
>> disappear on the next sync.
> 
> ACK,
> I can see that we have this define in the kernel
> (not in a uapi file but as part of include/net/macsec.h), if I want to use
> such a define what is the process here? do I need to move the define in
> the kernel to the uapi file?
> Also, in such a case Would those patches get accepted using such a define
> while the kernel change is not accepted yet?

Emeel,
Please complete the kernel changes and get them accepted first.
If a define exists in the kernel and needs to be exposed to the user, 
just move it to the uapi file and make sure it's still visible to all 
kernel usages.
