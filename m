Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423D06E29B4
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 19:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjDNRvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 13:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjDNRvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 13:51:45 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DE576B3
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 10:51:44 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id dw2so27757684qvb.11
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 10:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681494704; x=1684086704;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Kxh41h9aGyDPX5W8rwzmVXVFf0CBypxIi4Q4CfiiyEU=;
        b=a4E1zXv9PVwOepVG2dtPjlVz++VlOpITmAelO18wtXaTg8GGSSMw8eJd1nLirzrUy3
         Xod9N50QBGJ8dM/scbx/dA8wwthP8eOmVqzw888bAJeICNcIEQxpckvjyaTKTVDnL4Hp
         iz81vf+NJ2k+7r4a5cpjBXbt6aL0OsXyEel6y6hqiKqlswQrdQecNhV8oDNcGnWkGQyO
         esZEhkTVRpkiWP3n6DaAAsnBoMb3VPWoojeJ6CncbbN1VqYNDxIPraYOygteDiM/B0IQ
         CKB/+PLl6m6tjYV5UplCItrrUn5pGTHPDwL648CWK6ov6VCnFNZnkVSLueGEbTsx/tUe
         Ngbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681494704; x=1684086704;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kxh41h9aGyDPX5W8rwzmVXVFf0CBypxIi4Q4CfiiyEU=;
        b=J14t6gHo5OqandLkVxTXHZmS63fOlyUnIWaVKEKBrQ1RgoJKTjsZcqaFtlU2AvZ8j8
         Ls9bONCari8ahr4Mpotx8JeyTtOHSUsPSkFCSR46GGKQa5797sLwGumPuDFhm3hulS7V
         kBCrStawMev//bwDHjg9hbg6ms29hBn8C2yJBN7VhW3UAk/BaI0gi1OzPal9Hs/ShiOf
         FxlZ4w1IMGYlJCx9HYVL+xo8oXOZI7R47oDvFHmdjGmSxLzRWMy6p3nke5ih8Jp0kDe4
         lxpzaHjaNMm4NuwPmsVK1w7UGrcOjO+0uznCCOKt9cj3biLdoNJqtTKWpUHGHqU3vj/q
         aASg==
X-Gm-Message-State: AAQBX9d6LYS6D42NUIss1LCZdbE/RCVmd7AWIy3jTjfqtyaIqJbfJ230
        LC5keASbFyQkTqF3usaANmI=
X-Google-Smtp-Source: AKy350YG622e4/d9CRdElXwdPxwh1C9z7kbgzVBbbacZYVk7xCucRVEXVzq0qAsUUPCT6fL9RAtw2Q==
X-Received: by 2002:ad4:4ea5:0:b0:5a3:2814:59e with SMTP id ed5-20020ad44ea5000000b005a32814059emr5583219qvb.4.1681494703997;
        Fri, 14 Apr 2023 10:51:43 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j10-20020a0ceb0a000000b005dd8b9345a3sm1263853qvp.59.2023.04.14.10.51.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 10:51:43 -0700 (PDT)
Message-ID: <51ab6699-8f0b-dbb6-21c1-ae22012bcbd1@gmail.com>
Date:   Fri, 14 Apr 2023 10:51:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 3/5] net: skbuff: move alloc_cpu into a potential
 hole
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
References: <20230414160105.172125-1-kuba@kernel.org>
 <20230414160105.172125-4-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230414160105.172125-4-kuba@kernel.org>
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
> alloc_cpu is currently between 4 byte fields, so it's almost
> guaranteed to create a 2B hole. It has a knock on effect of
> creating a 4B hole after @end (and @end and @tail being in
> different cachelines).
> 
> None of this matters hugely, but for kernel configs which
> don't enable all the features there may well be a 2B hole
> after the bitfield. Move alloc_cpu there.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

