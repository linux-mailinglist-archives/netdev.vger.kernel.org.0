Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251D76A3AF4
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 06:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjB0Fxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 00:53:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB0Fxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 00:53:52 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307471ABD1;
        Sun, 26 Feb 2023 21:53:51 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id n6so4194086plf.5;
        Sun, 26 Feb 2023 21:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677477230;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ODNLBG8M5X8mMUUDwFCZQTKOfTWqKb2FCLXCroiP7Hk=;
        b=M7BjLHi0Q54gFdJigkLrJvp/ksDnU5aMpR8ngrvSeuxkV59/BWcrKhm2fltejC0w38
         X2O3p0t+C2QxctLR/b56MVpbcRaeaFqCPcsPnKuJ7kIxvQ1H3DsHa9+bgRZMZZFvlyck
         6JqsdHIIZO9HTm2ba3mL2lLQptapX7Im+rsD4FOrcBB46/BALDkLnZaVb5g/b3xsTMuw
         nGg3ERhtqVNuG317KNU8VW71HDNsckO0ENsSqpew3N29UXZ6AnmP5at2vUDhKparTE6v
         Xv5ITw2SIKhb3ReTd4+d7K+BlPgDjOajCMAJH5ylKboigUzuEsGOOZqI3erRTCRhBARg
         5/uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677477230;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ODNLBG8M5X8mMUUDwFCZQTKOfTWqKb2FCLXCroiP7Hk=;
        b=s0Hgp9Gl/gaqmTNt8K9gBl7zZP91+C4TqmuKTAMq1pt+eWWlxEFsnLRN9q8d1v491I
         Z8PjQa4jjxWiQVH5yPH7WnlweMy9wOyBQqwZeLUxieq++N0DmkIiVYWhOdwyeU24R+Zq
         IT9FpBCJwga2TGQNkWAI163LsSq6AqeC2yaIIbPVcti9oaBD5M6QAfpzSjhQdr+hJoOa
         CcLd+2iW0AhDPKjoDz/yRE3pTaplws5Y12r0MNPHCPWgaPvnThcoBXLrzGASVZgBcIS8
         DH6MFUf6F9BSpaO6Dled0MF7FfvPvo15ovMh2VASmXW99tXyt/xXMmlyV0QlmlYgYqWL
         ngkg==
X-Gm-Message-State: AO0yUKWguVcI2pnPP0hFkoEHIg7SrCG5pPBU82Clm1NbX2EjvBXqgmh9
        HNJwHQjMWgFvQqVGEBcsHPo=
X-Google-Smtp-Source: AK7set9rAfIWeS0K/+8DXZ+q/KxJUaEq6RUmToxHaqhq8ew/Al1LJ6OT0W1DKrsbsmMinyZ9Ki5RSA==
X-Received: by 2002:a17:902:e80d:b0:19a:a2e7:64de with SMTP id u13-20020a170902e80d00b0019aa2e764demr25363407plg.0.1677477230686;
        Sun, 26 Feb 2023 21:53:50 -0800 (PST)
Received: from [127.0.0.1] ([103.152.220.17])
        by smtp.gmail.com with ESMTPSA id p7-20020a1709028a8700b00198ef93d556sm3617450plo.147.2023.02.26.21.53.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Feb 2023 21:53:50 -0800 (PST)
Message-ID: <9a4d11c7-390a-519f-ef04-d5de55b27f29@gmail.com>
Date:   Mon, 27 Feb 2023 13:53:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2] net: tls: fix possible info leak in
 tls_set_device_offload()
Content-Language: en-US
To:     Sabrina Dubroca <sd@queasysnail.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ilyal@mellanox.com,
        aviadye@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230224102839.26538-1-hbh25y@gmail.com>
 <20230224105729.5f420511@kernel.org> <Y/kcfM5jWrQhdYFR@hog>
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <Y/kcfM5jWrQhdYFR@hog>
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

On 25/2/2023 04:22, Sabrina Dubroca wrote:
> 2023-02-24, 10:57:29 -0800, Jakub Kicinski wrote:
>> On Fri, 24 Feb 2023 18:28:39 +0800 Hangyu Hua wrote:
>>> After tls_set_device_offload() fails, we enter tls_set_sw_offload(). But
>>> tls_set_sw_offload can't set cctx->iv and cctx->rec_seq to NULL if it fails
>>> before kmalloc cctx->iv. It is better to Set them to NULL to avoid any
>>> potential info leak.
>>
>> Please show clear chain of events which can lead to a use-after-free
>> or info leak. And if you can't please don't send the patch.
> 
> Sorry, I thought in this morning's discussion Hangyu had agreed to
> remove all mentions of possible info leak while sending v2, since we
> agreed [1] that this patch didn't fix any issue, just that it looked
> more consistent, as tls_set_sw_offload NULLs iv and rec_seq on
> failure. We can also drop the patch completely. Anyway since net-next
> is closed, I should have told Hangyu to wait for 2 weeks.
> 
> [1] https://lore.kernel.org/all/310391ea-7c71-395e-5dcb-b0a983e6fc93@gmail.com/
>

Oops. I will make a whole new patch without mentions of info leak in a 
few weeks. Please ignore this patch.
