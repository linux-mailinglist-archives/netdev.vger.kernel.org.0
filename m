Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E08B53329B
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 22:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241716AbiEXUt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 16:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241715AbiEXUtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 16:49:25 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9069A737A0
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 13:49:23 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id x12so3125135wrg.2
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 13:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wifirst.fr; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=me4YMzj83rpLhc8b4VKOh2DBAqbWAARQW/RYV5nHZ/w=;
        b=7zkFHnoaPDymn2fj4cWTWzA/VmPVDlQ2ywWF0dYzfSDAyn7wVRm2UX4FgRcDu2uVSF
         acU7mnBhxKnDtJBD+dCK74OdB7M8BRHVQMK80UbsdRtTZKAS4nYiywj3JvFPrdK8qY7M
         vlY0tzwNbN5b9SiytmwdRa2TiwdjXM6FEHN09unCuBmuG+wvpNqzLikccHXX9R2y07It
         Nz12tlHQEiL8lND8gRzw/mwiLLMybAZdtIq9DAMgnJ+i25ljMmi7oeZ8gKZdG9So93z4
         W/BPb56JAEhogB/0spDn+NINg4oxMau559fuSvbc+biS7ZtM6gEK6gXkRz38YM7OzD7l
         WuGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=me4YMzj83rpLhc8b4VKOh2DBAqbWAARQW/RYV5nHZ/w=;
        b=IMzh3EYCIdGr+7obKNQ2NA7vr8TUEpdrLhQX6Tdq4BPVvDiXb5LXDkNLz7fhL2GrTx
         a3cChQeNns47bCHZc5BvJxjztkpR0xsjUVtZqbhi0i6a3djNsFgyaPy51Iu5TmwgnIG2
         5USA4tPVMTk4xIRAqgEGmMKM+d9lgfs2iJWe/99TKsyJEOJRKdByd4TrVJcPfHohg7zA
         gP09rf3jHlVq3l63pArLo5q56QszCE3mGNB1b0evvDHHFn1TsDll6lSmNypnGKtvDto1
         2pz3kQWHam1lX8IaGzv8a7ADA1iEuheq2k0EZkfra4U18ye6vM9KxATzkH0cFd9G8Pyy
         8neQ==
X-Gm-Message-State: AOAM53386jmpbwGLQhuTDJxepBqPj+VR/PF6QUcOiHeR+UsghfaDjYLU
        mIgzo5Z8Gy+3WNyL1aAmbeTbF9ivE/Vfl+8l
X-Google-Smtp-Source: ABdhPJzGwwsQ7OrSdL5w//wArypkSIuOpB5EClEZOu0OzujEc2Z9i0fXOushwgwDzWM3UdePcjVjXg==
X-Received: by 2002:adf:d209:0:b0:20d:b29:87e5 with SMTP id j9-20020adfd209000000b0020d0b2987e5mr24191141wrh.110.1653425362065;
        Tue, 24 May 2022 13:49:22 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:993:6ec0:600b:7e72:20dd:d263? ([2a01:e0a:993:6ec0:600b:7e72:20dd:d263])
        by smtp.gmail.com with ESMTPSA id i12-20020a05600c354c00b003942a244ee6sm193415wmq.43.2022.05.24.13.49.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 May 2022 13:49:21 -0700 (PDT)
Message-ID: <af7b9565-ca70-0c36-4695-a0705825468d@wifirst.fr>
Date:   Tue, 24 May 2022 22:49:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 net-next] net: neigh: add netlink filtering based on
 LLADDR for dump
Content-Language: en-US
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20220509205646.20814-1-florent.fourcot@wifirst.fr>
 <b84e51fa-f410-956e-7304-7a49d297f254@kernel.org>
 <8653ac99-4c5a-b596-7109-7622c125088a@wifirst.fr>
In-Reply-To: <8653ac99-4c5a-b596-7109-7622c125088a@wifirst.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

This patch has been marked as rejected after your comment.
Could you perhaps have a second look on it? And on my response above? I 
still think that my patch is relevant and add a currently not available 
feature.

I can work on alternative approach if necessary. Since neighbour tables 
are sometimes huge, performance overhead of userspace filtering for a 
simple MAC address lookup is currently high. And GET does not provide 
same feature.

Best regards,

-- 
Florent Fourcot
