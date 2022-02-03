Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5B44A89F2
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352820AbiBCR0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236093AbiBCR0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:26:05 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9707C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 09:26:05 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id t17so3132678qto.1
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 09:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=qZbh3uNUV8DCQT1FIy7d2DeYWRLYrx0tShTZ54sx8yE=;
        b=Uw6s7i1RSfrGmSjcc46ZdqLxbHUo2Au9LMnItoP8vLngVrPUfKUQLOhiTTmVkUYFyQ
         Otp7p+3RHu1MiaaZ7R+9MUdfzLN8pu0hAP1bOepm69uCqI1KAhsc1vCGIlSHfphpO2rD
         Q92Lv5TG2XX0I8Ea6p4zz/CXCnvrUbHyUU+H+QKI4F4tcg3L/G/mc8o8WSQmFBMWAMD5
         lTqS9V4a4eeEZV+olfU7UIlMy30YYWC1JZ4Ax3p9nFWGtsK1by/4RaI3zEyw+OpKkUVR
         MXKsLIeOz0aaFoZn1VIUoJ2/KdC+IaS//AaCQO8bb87U7Z7z+Mu0h25sIQl6R+pUMTSi
         n+RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=qZbh3uNUV8DCQT1FIy7d2DeYWRLYrx0tShTZ54sx8yE=;
        b=hV+4iGm++rtQmJrdvgC5CW4wa8/CVbCSUoEdzHKAQPzT5GsFSKy33bqGYrmvqeYaVf
         GlnCrOFMAH/eGSnuGerEBxSlsBiELNUCmlGMW5Bg2Ekbf6Tr1titcLCWV4DZozjXam0h
         fK7vlqyjZXgfV+EExDbh0ChPQ6P+BEfTOrVbMdEvASt4n4JkZGAAdfCIQraQ0jr19D13
         ZjibuBMdbseS+mL7xsNUmkS2LRaIyz+GaOBypttDZPc132n6xx9ofNjHH9g0xqZjeodr
         BQ3TbzD+3WJFg9nAtGDU/wJZx80Gxow0BGGvic8SeDP+DGnTJVilm2eHJMbUmlsvpl52
         OkPg==
X-Gm-Message-State: AOAM532gsI5EPWzs6OvZyQS+fvV2UPKrVkGhNpRWgaewN4hRtiJhSxkE
        oQ7sQrrWlVG/qbK6+cyfR9o=
X-Google-Smtp-Source: ABdhPJzu2u94QkZjOpWjWBMCAT7I095zGpmRM4KtmgJiLmpQluQM3UJjMMJSXLoOCtBM+eyrqzXAtA==
X-Received: by 2002:ac8:58cf:: with SMTP id u15mr27687588qta.499.1643909164665;
        Thu, 03 Feb 2022 09:26:04 -0800 (PST)
Received: from ?IPv6:2001:470:b:9c3:82ee:73ff:fe41:9a02? ([2001:470:b:9c3:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id n7sm10536153qta.78.2022.02.03.09.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 09:26:04 -0800 (PST)
Message-ID: <ee1fedeb33cd989379b72faac0fd6a366966f032.camel@gmail.com>
Subject: Re: [PATCH net-next 09/15] net: increase MAX_SKB_FRAGS
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>
Date:   Thu, 03 Feb 2022 09:26:02 -0800
In-Reply-To: <20220203015140.3022854-10-eric.dumazet@gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
         <20220203015140.3022854-10-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-02-02 at 17:51 -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Currently, MAX_SKB_FRAGS value is 17.
> 
> For standard tcp sendmsg() traffic, no big deal because tcp_sendmsg()
> attempts order-3 allocations, stuffing 32768 bytes per frag.
> 
> But with zero copy, we use order-0 pages.
> 
> For BIG TCP to show its full potential, we increase MAX_SKB_FRAGS
> to be able to fit 45 segments per skb.
> 
> This is also needed for BIG TCP rx zerocopy, as zerocopy currently
> does not support skbs with frag list.
> 
> We have used this MAX_SKB_FRAGS value for years at Google before
> we deployed 4K MTU, with no adverse effect.
> Back then, goal was to be able to receive full size (64KB) GRO
> packets without the frag_list overhead.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

So a big issue I see with this patch is the potential queueing issues
it may introduce on Tx queues. I suspect it will cause a number of
performance regressions and deadlocks as it will change the Tx queueing
behavior for many NICs.

As I recall many of the Intel drivers are using MAX_SKB_FRAGS as one of
the ingredients for DESC_NEEDED in order to determine if the Tx queue
needs to stop. With this change the value for igb for instance is
jumping from 21 to 49, and the wake threshold is twice that, 98. As
such the minimum Tx descriptor threshold for the driver would need to
be updated beyond 80 otherwise it is likely to deadlock the first time
it has to pause.

