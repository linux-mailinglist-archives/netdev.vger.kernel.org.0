Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F5969E313
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 16:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbjBUPIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 10:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233416AbjBUPHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 10:07:36 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A1D7286
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 07:07:33 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id ky4so6511623plb.3
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 07:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1676992053;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XJn2rWwb/GC4lgLtX60iCt13r+7kR2g2nyWM3DmoTsU=;
        b=bXEcR2jurSM4WvtTBT9vgSOkKH9XjN+Z7Wf7U0eQu4haoH9oZoYP4MVAwYmvkFP36l
         r0GkHIzT5n0nZ6NIHlLXtep0k1sN64l72IahWtalkAtF28bbIjYyZAwqNwTkWRnyM5FW
         78zgerKKRk2YPlh0XaXz3b92JHlg/TYdpG+7QzokX7W9Ca4YB/UC32zrzjBP7X2Iw2B9
         lzRwlMadqXOkgVbK6o3K40nrTTJoaw8Wv5LtF/hy6u6TMudswqEt47lyMpVfddJeDYl9
         gkutLa9/PBnd94YBYAFqAITbh/77f3l29QXEosHK0sshet2sIAqog88E1wO8J0jKXCR1
         kNag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676992053;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XJn2rWwb/GC4lgLtX60iCt13r+7kR2g2nyWM3DmoTsU=;
        b=XngjodU5JPyYclMC5wjVo/zt5PlC57eAvG0bfso/7Zse6/YaV50PW6/romwbnVxA/e
         PtZTxAiwc9Kt0uOYFu1Z0Yv9qdWDJXpKCV7DcumLB/MPeopOFb7+ThsGgLfXrLFb/1Lb
         OCGcqQVqfTjM6PujkC+kNOxizPo+EdGkQzT4HQVrnndJPgbQhgDTRkmtHfqtGmXX4dFK
         xRdww5LL2+8+nIDxQ4BeX44NLju0mhtPKo2SpanAd5nqQFyZv5LUqQ5GLCtkQl9OLcZp
         Zch7tta2RqbQbMVdYdKbTin3F48wQw5i64O/Yrw/jC6aQFbyk3cyjnuLrjlFYqhPdDoW
         U/5g==
X-Gm-Message-State: AO0yUKUN6KVNtWBgzr2NPkIKCSobaK5uwT3wGRAlqemM9byIVPQynBOX
        x4kR9ugUDZAljHX7Mrpv/HNi5Do4XbI=
X-Google-Smtp-Source: AK7set8n/dW3SR9TVa3UY7muwA24/g8LFEVbg9gGw1YPBg5vrVbgg7pz+EW0JMcvkUBl6dEHljw1SA==
X-Received: by 2002:a05:6a21:32a5:b0:bf:1769:3464 with SMTP id yt37-20020a056a2132a500b000bf17693464mr6893894pzb.3.1676992052721;
        Tue, 21 Feb 2023 07:07:32 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id m18-20020a6562d2000000b005026c125d47sm3862998pgv.21.2023.02.21.07.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 07:07:32 -0800 (PST)
Date:   Tue, 21 Feb 2023 07:07:29 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     yangbo.lu@nxp.com, mlichvar@redhat.com,
        gerhard@engleder-embedded.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        edumazet@google.com, Yalin Li <yalli@redhat.com>
Subject: Re: [PATCH net v2] ptp: vclock: use mutex to fix "sleep on atomic"
 bug
Message-ID: <Y/TeMdxgtnPaEIgg@hoboy.vegasvil.org>
References: <20230221130616.21837-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230221130616.21837-1-ihuguet@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 02:06:16PM +0100, Íñigo Huguet wrote:
> vclocks were using spinlocks to protect access to its timecounter and
> cyclecounter. Access to timecounter/cyclecounter is backed by the same
> driver callbacks that are used for non-virtual PHCs, but the usage of
> the spinlock imposes a new limitation that didn't exist previously: now
> they're called in atomic context so they mustn't sleep.
> 
> Some drivers like sfc or ice may sleep on these callbacks, causing
> errors like "BUG: scheduling while atomic: ptp5/25223/0x00000002"
> 
> Fix it replacing the vclock's spinlock by a mutex. It fix the mentioned
> bug and it doesn't introduce longer delays.

Acked-by: Richard Cochran <richardcochran@gmail.com>
