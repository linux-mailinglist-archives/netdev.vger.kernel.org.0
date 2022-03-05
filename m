Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D264F4CE39B
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 09:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiCEIfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 03:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiCEIfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 03:35:41 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8E115C660;
        Sat,  5 Mar 2022 00:34:50 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id p17so9731533plo.9;
        Sat, 05 Mar 2022 00:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=bKoGjMpVki5+pEboRYBURTgHG86d4vDBENvylWQqmc4=;
        b=VffkC3CAaW5Tu/D9jSeUDcsfdU3OI4TYEVI/SonbCvOrh0nMJdm8ZNCW3pH7NXOKJL
         vUG6iDypntoGFqWzhemd0+EMjPQv1OT/aNFMc/1jcZiWvhKwVSoh9mO+jMG7Mj21aLPV
         kyvqd4QFRD2Er2j1iYex9Z/j/GfwlSAzDw3TQtb0ooxF/zFY186hiamwpEIVAzoN9pKY
         p2U091UsH2aA0qm0kR4zFfO6jGuk0qsHBcdhLN+b2FTeUm/RJiGdYSfeHNaobNbsHSI9
         otznM9yiTupQb90VKA8ymC1sbO3LfNyH6fPdx5UkMSV7xrFsF5JbRTREPNKABek2haoB
         W5rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=bKoGjMpVki5+pEboRYBURTgHG86d4vDBENvylWQqmc4=;
        b=Q1qz6rDXnYilPTZQ/rMagY/jjfdI2Xx4jB/PuV5rn2eXzdmzkr0RAG5NLUeSbRyhOs
         STOWL7OJ4SRGVB5JK/EhbI1NpDxPU6rb4gijzOC+NRXqjU1Bd/ah+QctOxzW8xWWC+0J
         6m8iG5d3zo3z0MxES1OK2K3TI2ry3+8C4LSPcJnH/fHRDNSg4mSR1k4K3gKhMA0BsgCO
         AUscch1xFn4VROiB/JH1iAyiMNXm/ffOcgaUgCTJY6QkYyWEdpgQqgHNkq6PqO0vJH9m
         JI+Y1pWGLaKEjBQFpvN2y8gwYhz7pjkV/L8ctB6ifgkgGB3YGskyZ58ZSV+1FXdGZVl7
         /DAg==
X-Gm-Message-State: AOAM532vHnJewXD8cgNKgVVmClke+HvzYz7KqcOVoTEMXgV8AGCAiq4/
        dQBAHTICuPxTfrKi8g2PES+d1jZ1+QE=
X-Google-Smtp-Source: ABdhPJwGL5uQN87rWwwBhYsunuw0Lg0IW+j9fHGqx+cHwpOfMqcnwlHDO0guw3+uhxL9PBMkEEqbVA==
X-Received: by 2002:a17:902:da85:b0:151:8d9e:e31b with SMTP id j5-20020a170902da8500b001518d9ee31bmr2372204plx.166.1646469289720;
        Sat, 05 Mar 2022 00:34:49 -0800 (PST)
Received: from [192.168.1.103] ([166.111.139.99])
        by smtp.gmail.com with ESMTPSA id z129-20020a626587000000b004f6b398faabsm4936236pfb.139.2022.03.05.00.34.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Mar 2022 00:34:49 -0800 (PST)
Subject: Re: [PATCH] isdn: hfcpci: check the return value of dma_set_mask() in
 setup_hw()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     isdn@linux-pingi.de, davem@davemloft.net, zou_wei@huawei.com,
        zheyuma97@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220303025710.1201-1-baijiaju1990@gmail.com>
 <20220303211557.16458976@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <1650c170-3223-d74f-23ac-a05440765ad0@gmail.com>
Date:   Sat, 5 Mar 2022 16:34:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20220303211557.16458976@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/3/4 13:15, Jakub Kicinski wrote:
> On Wed,  2 Mar 2022 18:57:10 -0800 Jia-Ju Bai wrote:
>> The function dma_set_mask() in setup_hw() can fail, so its return value
>> should be checked.
>>
>> Fixes: e85da794f658 ("mISDN: switch from 'pci_' to 'dma_' API")
> The change under Fixes only switched the helper the driver uses,
> it did not introduce the problem. The Fixes tag should point to
> the earliest commit where the problem is present.

Hi Jakub,

Thanks for the advice.
I will send a V2 patch.


Best wishes,
Jia-Ju Bai
