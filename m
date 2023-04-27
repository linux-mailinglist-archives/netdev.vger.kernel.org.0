Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD9A6F0A6C
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 19:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244235AbjD0RBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 13:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244226AbjD0RBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 13:01:12 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CBA1710;
        Thu, 27 Apr 2023 10:01:11 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-2f7a7f9667bso5531982f8f.1;
        Thu, 27 Apr 2023 10:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682614870; x=1685206870;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=74EPGNwikeuann9xM5Apbvxi0i4zuR5wbNUm9rP3II8=;
        b=nqQLPJrKEW0nciyyLpopZssw1HoaO7EOomcRMYq/Qjr/lgkhZbBZUEkGQNK66IFV2t
         jpj93puwT1lPuDhXYUeBnN5tQbwj6CglIe7Lr3dHvepWE/La7gV/guhND/SKO9rtvz24
         I0yRr4Per9RKJUxSJkRSQ/u2dTAeoe7LypcFTQw5LMsuEogIP6b4XOyrKLkBQ++09Zt4
         tWtYSwmuI6iJXNHhRIb40pirgKuSuHazqE1zJh/ZW7Z4eKF3p8OXDe9HegWE1sfdbl3p
         jmbYAOGXanDpE2Qy0b2zpDWw+bnlxEJ3dcaahgGVUt/N31RxayKMorOnutXcdbS8m7wk
         xuAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682614870; x=1685206870;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=74EPGNwikeuann9xM5Apbvxi0i4zuR5wbNUm9rP3II8=;
        b=NmKwMVFVzyna7goVSe26IUOghFoqKGalLyuPtJXqVlf330qQ+TdkIt093MZyGeekOZ
         Wg+95/umP0TTu7HNalU/jqw1P0DcgTEIcmZmxBP+Dp+DbazS/MaaV5uO05D/ZL37N2Sa
         VPfNaL2mDwEb6U2CjcIf0gqqdX60Svq2OXN98xbRpi1Q+a753xAb34ei1CIS7uJYMV+0
         TIqXZ2NInJMMSe9t7fbu9QMgw9B3ll1Ae84QWrI6u6CwDig1MNKcp1u2zLKuKzIXdmqI
         jrn3boC0oJ+BE/qssqNU0gQ87engmV4lSYiWuE/QhluhevU3N9UJxN1oLiiojV8CkMaa
         b7iA==
X-Gm-Message-State: AC+VfDx/B9oD38wnG8aPp1JuT87lFFAkgY44ceeXr3P3CVLk3DySBjV6
        s3gQ+JmMVCaqaLn749JEqCA=
X-Google-Smtp-Source: ACHHUZ4hD+mxWMOl/dm6vqMfSaBhJE7SKYE4zLHQW06Qy2X2x9n/s3iv0+Sc3zRPabMK6093lHSrEA==
X-Received: by 2002:a5d:6a8f:0:b0:2fb:2a43:4aa1 with SMTP id s15-20020a5d6a8f000000b002fb2a434aa1mr1797409wru.42.1682614869620;
        Thu, 27 Apr 2023 10:01:09 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.55])
        by smtp.gmail.com with ESMTPSA id a18-20020a056000101200b002e61e002943sm19011813wrx.116.2023.04.27.10.01.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 10:01:09 -0700 (PDT)
Message-ID: <3854af21-822d-75f4-0e74-e1998143d59f@gmail.com>
Date:   Thu, 27 Apr 2023 20:01:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] wifi: rtl8xxxu: fix authentication timeout due to
 incorrect RCR value
To:     Yun Lu <luyun_611@163.com>, Jes.Sorensen@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230427020512.1221062-1-luyun_611@163.com>
Content-Language: en-US
From:   Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20230427020512.1221062-1-luyun_611@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/04/2023 05:05, Yun Lu wrote:
> From: Yun Lu <luyun@kylinos.cn>
> 
> When using rtl8192cu with rtl8xxxu driver to connect wifi, there is a
> probability of failure, which shows "authentication with ... timed out".
> Through debugging, it was found that the RCR register has been inexplicably
> modified to an incorrect value, resulting in the nic not being able to
> receive authenticated frames.
> 
> To fix this problem, add regrcr in rtl8xxxu_priv struct, and store
> the RCR value every time the register is writen, and use it the next
> time the register need to be modified.
> 

Can this bug be reproduced easily? Is it always the same bits which
are mysteriously cleared from REG_RCR?
