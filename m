Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707E2591477
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 18:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238161AbiHLQ6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 12:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237768AbiHLQ6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 12:58:19 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A031B0B2E
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 09:58:18 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id j11so1023100qvt.10
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 09:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=cw1FIacqOtFV2GdU5gap1p7lXRAdRFXGh5oAxf5ngYk=;
        b=MlZ9wOjLLxNnnT78vQVIOmJbiDM3ioz5FN51O0tWF+hrrKRhrZJZt1BLpPZuYAyZ/9
         eJEKBE3HhzQ9bZ7hRQiwIUq92Pn8r5ugMYHEyUQBdmJ5G8c9eJd5CyTZ7metlELwk7HH
         b3AefBmuEQSs8xkwF3HMHwWook/bqwiy+lgZi+ZKwir6BPDEOguljONIOJBoADzMBn/t
         DUpfaYpD2TyW9NRAdQcRKvap+Xtstc8lVt69jqfA8wvApj7nVhYr9Cvu11UAT1/m7Mph
         awPQlxrJ4oi9CbvzmNmrjouTyVEhiuyPJ8ItCjNDArMcS3NEENppJPp2M2bWIAOld18z
         qC6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=cw1FIacqOtFV2GdU5gap1p7lXRAdRFXGh5oAxf5ngYk=;
        b=sLRhGMiC+0DeqXYMpQQkC2hhSEVXkE1RLkl/vDt+tCJF3xNqwsuWprzW70Q+/qDopn
         fUwSaer95F4xY8iBsPYr20W0yPaF2m2pXeDxV+SxLQeOTAddUimiwAOuqnuKl76UNkDc
         ChkXp96JlweRVDOVBf2PMb8ZhzdU9MEmMbzc9vq46+yFCBhbRSE5tVPKFUSXhe17MkK8
         tHMKT0X8jK122cS3jsR/j+Gvkn1bkuxxoJXYmEHe7DuRZSPuihPXwZTTHMXjANqXtgnO
         oafqxiymQSIU7+xowzbnuCm1tDgdW7p+1oUnkCdHN/Q7A5ayOaOIkKkYRFaWL/Tc3rNN
         oYwA==
X-Gm-Message-State: ACgBeo0AVmagj3eNUHeeqZT5Q4OeQD9Z6PBZLjm8MpCTekYcrLr9wX/u
        EEcSwRI9URWFbxA2IyQPff8=
X-Google-Smtp-Source: AA6agR5mjCjxxPlUoBkWY0YgrdNaWvjIUG2FvbAC5FgKFjiRBdOIOWmJyAjhFYoGQaoWjNnTXIGXSQ==
X-Received: by 2002:a05:6214:27ee:b0:476:67f1:3fdc with SMTP id jt14-20020a05621427ee00b0047667f13fdcmr4187383qvb.119.1660323497060;
        Fri, 12 Aug 2022 09:58:17 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b5-20020a05622a020500b0034308283775sm2187400qtx.21.2022.08.12.09.58.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 09:58:16 -0700 (PDT)
Message-ID: <83755aa0-2d6d-bf53-9f62-1dd7320b025e@gmail.com>
Date:   Fri, 12 Aug 2022 09:58:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] net: moxa: inherit DMA masks to make dma_map_single()
 work
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Guobin Huang <huangguobin4@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220812154820.2225457-1-saproj@gmail.com>
 <YvZ8NwzGV/9QDInR@lunn.ch>
 <CABikg9wm=8rbBFP0vaVHpGBJfXOi4k0bvwK7F+agMXEPfFn2RQ@mail.gmail.com>
 <YvaCE0lqfOi+tE5X@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YvaCE0lqfOi+tE5X@lunn.ch>
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

On 8/12/22 09:38, Andrew Lunn wrote:
> On Fri, Aug 12, 2022 at 07:35:43PM +0300, Sergei Antonov wrote:
>> On Fri, 12 Aug 2022 at 19:13, Andrew Lunn <andrew@lunn.ch> wrote:
>>>> +     /* Inherit the DMA masks from the platform device */
>>>> +     ndev->dev.dma_mask = p_dev->dma_mask;
>>>> +     ndev->dev.coherent_dma_mask = p_dev->coherent_dma_mask;
>>>
>>> There is only one other ethernet driver which does this. What you see
>>> much more often is:
>>>
>>> alacritech/slicoss.c:   paddr = dma_map_single(&sdev->pdev->dev, skb->data, maplen,
>>> neterion/s2io.c:                                dma_map_single(&sp->pdev->dev, ba->ba_1,
>>> dlink/dl2k.c:                       cpu_to_le64(dma_map_single(&np->pdev->dev, skb->data,
>>> micrel/ksz884x.c:               dma_buf->dma = dma_map_single(&hw_priv->pdev->dev, skb->data,
>>
>> Also works. Do you recommend to create a v2 of the patch?
> 
> Yes please. It makes things easier to maintain if every driver does
> the same thing.

Yes this is a common pattern to store a device reference pointing to 
&pdev->dev into your network device private structure fetched via 
netdev_priv().

Alternatively, we could sort of try to settle on a common pattern where 
we utilize &dev->parent->dev thanks to having called SET_NETDEV_DEV(), 
that might be more universal?
-- 
Florian
