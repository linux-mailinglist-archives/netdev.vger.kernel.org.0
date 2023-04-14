Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8EF76E29B1
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 19:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjDNRvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 13:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjDNRvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 13:51:00 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C9083ED
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 10:50:47 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id e9so14038045qvv.2
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 10:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681494646; x=1684086646;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EueI5cVrnnNHzjUxI2/nKt92AcnkY2Q9sN+H97PB6FM=;
        b=N3wrUNuss7kgbxajQ4/8OQw6xzvi0NvKB0w+AvcD0OncR0P52uXj0niuWY5fismBzn
         kgDg+DhsdraQuz9q1gJGF+GP38I9AvYJ8BARPA8Bpy4ZlxrnEWj4H6sUIX5oXG06Qhjt
         EBPQQwmmrLJHUTvdz8elp13sE3GVtWnDVDAlNbPgVQ0Q/HJW5AJHW6KLgyOzoGKqiuen
         5qb//KpS2iZZ2MH4BvvRY2vRtlPMZnmZhKb/wHJxKktq78w5V/utsw5loCC4cVOtTYa9
         n0717ZZLr6EnC12LF/8s24OR0Egd3ALmVT7ha+Dj9nrHzDQDCmh/007sv+B7bp+5pC/X
         xTGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681494646; x=1684086646;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EueI5cVrnnNHzjUxI2/nKt92AcnkY2Q9sN+H97PB6FM=;
        b=gQnRzL5yWw1BDs4gvd0eYJ14KqYTvMcbfE+Aji05lhtq9xyyTIy4OfQv/A4iEdEr8W
         KXAf+EfV1qmusETCFsnuh3/gR/0EOMbXD5vZ9QEUkPXGNoVrFtIbAxxxQRDyYrrJKPnO
         mz7KceFBL5u27d2sAnRAoAUBTCKlFQq8UOBK49v+0gLanwthvpwExiighjKMY1aBRxee
         ZRbZ5wxl6Eh9SCK9SieEu3iaDQIUbU4xYjTxa1YCWGJdLHRVPmWqFTEXD5jId4LzFtmr
         4OvInMeC87TP6mDaIa5BTQL576k8xUkudXY0olgX+B+aCvrn3j2x9rpFsPD3bfkIPEle
         n6Dw==
X-Gm-Message-State: AAQBX9dE1d5D7+VPOpo0QVL+nHzVOl1UO13TKXw0ArV5n0NOWOdBO9/+
        nOWdgy8233Ooo/XYHXwWbp0=
X-Google-Smtp-Source: AKy350bvigGai0JhFM432IfTgNQvYWRUA7EecWTq97oJjkLbmkwOYlfv9x081KxBHXH2NHiLi0lMIQ==
X-Received: by 2002:a05:6214:2245:b0:5a6:1571:1eb with SMTP id c5-20020a056214224500b005a6157101ebmr5789628qvc.27.1681494646016;
        Fri, 14 Apr 2023 10:50:46 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r19-20020a37a813000000b0074876c013f9sm1372495qke.123.2023.04.14.10.50.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 10:50:45 -0700 (PDT)
Message-ID: <aa53d1b2-4df7-6c42-a827-933f419a971d@gmail.com>
Date:   Fri, 14 Apr 2023 10:50:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 4/5] net: skbuff: push nf_trace down the bitfield
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        pablo@netfilter.org, fw@strlen.de
References: <20230414160105.172125-1-kuba@kernel.org>
 <20230414160105.172125-5-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230414160105.172125-5-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/23 09:01, Jakub Kicinski wrote:
> nf_trace is a debug feature, AFAIU, and yet it sits oddly
> high in the sk_buff bitfield. Move it down, pushing up
> dst_pending_confirm and inner_protocol_type.
> 
> Next change will make nf_trace optional (under Kconfig)
> and all optional fields should be placed after 2b fields
> to avoid 2b fields straddling bytes.
> 
> dst_pending_confirm is L3, so it makes sense next to ignore_df.
> inner_protocol_type goes up just to keep the balance.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

