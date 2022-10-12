Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43AEF5FCCCA
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 23:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiJLVIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 17:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiJLVIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 17:08:38 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3826FFF235
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 14:08:37 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 3so150768pfw.4
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 14:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ElcaSENspuIb37PaJ/21GDQ25/AhVWBhVbKNRiODFrQ=;
        b=WEgYRK/z3m7R1JqytKy9BGr9thItSeAJ7zTILkmSgySy0YQrWkbb4ns03wZAfUmdmn
         SqLvPyYakO/OFHMbJnkHAvUue+weI0KY/XztgdU304e/EZ44QVacHz+xOYCKWrUSkCcg
         VaHgZ3PvNEuP2B1QWGno9sFAVYmgSyZxv1WP5fOvr1t9xpP0vvmkYs6ZKx0b3vEraVQl
         clwTA6t+VRZlIj85P10AGd+Q4AZK0UEiws/vT+Gzi8srEUIqgoVKw6JkL7BWMjXcUsRR
         mEiFR5ckwTxaR14O3iC8TLtvxlPtxoDxk0pPyAl9qL6y2s8Pb561wyxzEp4GTb5qT/rW
         kNCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ElcaSENspuIb37PaJ/21GDQ25/AhVWBhVbKNRiODFrQ=;
        b=loDbgnJUalP7pp48uW+LCU1eo2pIJtQnEwgM08VEzw0rTHQ1x0TciOuVQMJvV2PdTd
         SXY5BVU6HXjeJ+ai2IuLnPPgB8u+whTER7NG6yY/6BmONrW0hXqlAHvHDOIKrva/29es
         9Ke7Nq5MFljMMq320R7MCzleDlIZUVjWyWDo23GKoZSDC84b2bNgrvog42Xjw6eeDC+V
         aXDGFbiVsvaJ226JxNbhOpm+Wax1bkUl41/ousXbO+9FB5nMURZFmKweH7QNDTbTS3T+
         Y4auS8pBWxgC4iEWM/YwzChTT3CM3awAgzQTXfIfhjcjVZDuvGwomSO5uWfGaTbQwUa3
         q76Q==
X-Gm-Message-State: ACrzQf0YGI1G2b47Hxm3p7OvnSLQVoVdG/Wfh2Ktj+Nqc2ZM3A2nJFsa
        u+BdA12HqT+UkLoQI32Nd6c=
X-Google-Smtp-Source: AMsMyM5cQG2y8Ida/4bsFC13D1pF2+tWEhB0UvvkzhevwP5cdJM3ymLzcZ/u6xuuUr359vbQS7RZcg==
X-Received: by 2002:a65:6753:0:b0:438:e83a:bebc with SMTP id c19-20020a656753000000b00438e83abebcmr26959563pgu.602.1665608916736;
        Wed, 12 Oct 2022 14:08:36 -0700 (PDT)
Received: from ?IPV6:2620:15c:2c1:200:9517:7fc4:6b3f:85b4? ([2620:15c:2c1:200:9517:7fc4:6b3f:85b4])
        by smtp.gmail.com with ESMTPSA id g2-20020aa79f02000000b0053ae018a91esm298969pfr.173.2022.10.12.14.08.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Oct 2022 14:08:36 -0700 (PDT)
Message-ID: <ee967071-abbe-c0e3-db96-6963d1b886b2@gmail.com>
Date:   Wed, 12 Oct 2022 14:08:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: RFH, where did I go wrong?
Content-Language: en-US
To:     Thorsten Glaser <t.glaser@tarent.de>
Cc:     Dave Taht <dave.taht@gmail.com>, netdev@vger.kernel.org
References: <42776059-242c-cf49-c3ed-31e311b91f1c@tarent.de>
 <CAA93jw5J5XzhKb_L0C5uw1e3yz_4ithUnWO6nAmeeAEn7jyYiQ@mail.gmail.com>
 <1a1214b6-fc29-1e11-ec21-682684188513@tarent.de>
 <CAA93jw6ReJPD=5oQ8mvcDCMNV8px8pB4UBjq=PDJvfE=kwxCRg@mail.gmail.com>
 <d4103bc1-d0bb-5c66-10f5-2dae2cdb653d@tarent.de>
 <8051fcd-4b5-7b32-887e-7df7a779be1b@tarent.de>
 <3660fc5b-5cb3-61ee-a10c-0f541282eba4@gmail.com>
 <d6645cac-3dd3-432-3ae1-178347761b6e@tarent.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <d6645cac-3dd3-432-3ae1-178347761b6e@tarent.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/12/22 14:05, Thorsten Glaser wrote:
> On Wed, 12 Oct 2022, Eric Dumazet wrote:
>
>> I guess RTNL is not held at this point.
> OIC, so it’s held for .init and .reset but not the other methods.
> I wish this were documented…


RTNL being a mutex it only can be acquired in process context.

qdisc fast path (queue/dequeue) can be called from (soft)irq context, so 
RTNL is out of reach.


>
> Looking good so far. Thank you very much!
>
> bye,
> //mirabilos
