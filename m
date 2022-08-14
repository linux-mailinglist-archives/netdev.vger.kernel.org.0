Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D977C591F17
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 10:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiHNI0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 04:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiHNI0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 04:26:16 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E1A19C13;
        Sun, 14 Aug 2022 01:26:15 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id h13so5767724wrf.6;
        Sun, 14 Aug 2022 01:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=8C6NdC7vDFUklz8V0b/HTOja7uETHtxfMvHU8lCgrC8=;
        b=FFSOWKiLN0UD3vlcQ1qRFmV1fkBpS7ca2zDIV+hSUQ9khbnRdX/jzNgXfU8kYvOdHY
         eRAd0zhXIG5H/DuGIjoNajX/hOMhUJJqPQcRGnTkVJ2xzNA6ZmeTWdvyeo8r1Qbh4/BK
         AGjLFFykuwCrutME9IzXJZKeDsVPkLnCiR0gGWKltT2rRZ8BInNQ9xGGGNdE1dl66Pn4
         X7V0yk8/3Zt5aPfdquRfECkJV7pPPHPUwm3BIgU1slvoXR881hUDJ1nigAg9rJ15oMwt
         I53TJv/8E7xMYwhjLFl7eEbqFMQbGq0RBuwkv812iTzbLrLiQv2YAaUHHwj4GkMvLVMC
         XErw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=8C6NdC7vDFUklz8V0b/HTOja7uETHtxfMvHU8lCgrC8=;
        b=vdc4P0bKbRdruQM6jPsRABHlWwbpRxMt/dNSw7o4/Q/SOfII+jHL4gStrZZb6Y1bP2
         R6tScjoT+zd9ISTINS1AyApU+8/Tl9P0TyX+AgzmLP/YCyIXuNopEdOWsvaXw+jngHqP
         URyrbCaOKXNy3OzdZ/+ZMqyTiTksEzZxq4BTywubWjuSqQ4UfzyCYDFQTxHPA4p3jmd7
         xf6Lp3UZSnM300HG2vMtnUb/1ZipvKgGO1P4bz47+3Vn7qJSKXGL9mc+wgE8gBkIwF0p
         HFriGwiFdm627HnEjinchDAIDz0UQlO4eEMOzLMeWSDP5sZfyPFQKeGBfw0iwQMyKlqG
         JdwA==
X-Gm-Message-State: ACgBeo1nfJaf0+exzlyoBzEglYW6kyFljREwG1N+ieOufhHJQuAS7XXJ
        ZO6WXPXZmFvlXfy4cFJKE20=
X-Google-Smtp-Source: AA6agR5U32ycvNj77gtRxAg6hRG01zLs5SBr59nAVVbiaa9SG+/Cnxvtq0tjHU+SBHrL08T/8Kjf8Q==
X-Received: by 2002:a5d:5889:0:b0:222:d006:c75b with SMTP id n9-20020a5d5889000000b00222d006c75bmr5815476wrf.495.1660465574416;
        Sun, 14 Aug 2022 01:26:14 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id az15-20020adfe18f000000b0021dd08ad8d7sm4044292wrb.46.2022.08.14.01.26.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Aug 2022 01:26:14 -0700 (PDT)
Message-ID: <e4e957dc-5ec3-c7ba-2dd2-5cd32fe8092a@gmail.com>
Date:   Sun, 14 Aug 2022 11:26:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 1/2] sched/topology: Introduce sched_numa_hop_mask()
Content-Language: en-US
To:     Valentin Schneider <vschneid@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
References: <xhsmhtu6kbckc.mognet@vschneid.remote.csb>
 <20220810105119.2684079-1-vschneid@redhat.com>
 <db20e6fe-4368-15ec-65c5-ead28fc7981b@gmail.com>
 <03aaf512-3ac5-fdfe-da2d-3fecd24591e2@gmail.com>
 <xhsmhmtcac0up.mognet@vschneid.remote.csb>
 <6a2dae6d-cbac-84ba-8852-dadd183fb77d@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <6a2dae6d-cbac-84ba-8852-dadd183fb77d@gmail.com>
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


>> If you don't have major gripes with it, I'll shape that into a proper
>> series and will let you handle the mlx5/enic bits.
>>

Sure I can take the drivers/networking parts. In order to submit the API 
and its usage combined in a one patchset, I can send you these parts 
privately and you combine it into your submitted series, or the other 
way-around if you want me to do the submission.
Both work for me.
I will do it once we converge with the API.

Important note: I'll be out-of-office, with very limited access to 
email, until Sep 1st. I doubt I can progress much before then.
