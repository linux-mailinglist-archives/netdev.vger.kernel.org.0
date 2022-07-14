Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA315752C1
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 18:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239220AbiGNQ2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 12:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233688AbiGNQ2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 12:28:41 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85655F29
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 09:28:35 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id o3-20020a17090a744300b001ef8f7f3dddso3603357pjk.3
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 09:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=WYbGh48un9AsIbVyrvYJn0ODPJPSLB9qYL5nlTid08w=;
        b=q2SLsevhn0RzGWM4JwfTEgj+Ype3JnUBOe64Kqm/z3sALVZdH5u04XbCfZNO+USH00
         P2xv0ryvzEPxTDbzCZq6N4/4ihYKgMMYyVOfbPFg6UZSDk4JaUjU7DFKrHAbfCkNiq30
         SDXGL2yuorGvBUea4CudXpXzxya5aGZ9tADMsxxCAEAnCZkR/7oBDxb20skDWmL0kDC/
         /EhPaXgmDMS4KwOFlFpyUR6ZMFVwUDjlTOi+q4/y8tbtGRfupadl0oacn41aXoPuhNGD
         3SzS3//1IMm3z6u11ssCkyM6NkBUpDz3qkvOFlH4g4wQv7t2Cj6zt2uciV3PE6seBdAX
         SDVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=WYbGh48un9AsIbVyrvYJn0ODPJPSLB9qYL5nlTid08w=;
        b=8Lx9G/uzW/2y5sOkbONP9AieRHNx7z2amde9B+gKYU7qhrd0u4PSd+oB34Zk5Ma4ta
         epdYOgTi1WgGXs6iWz6HXfM+MSdE6Ji2XFuRAm72ScUfLTX1mxe6rKIB38S6YZA4Eiaf
         eZcbR77ZW6eov/LbkE+YEmatkczYydog6HLjbBgZA3J/wmVAybH5HpdZ7qMDG2ODC54Z
         7EbxlClcr82ixDTX3FIXa+Y/r7VJqpLB2r9G79P2Gi0gndeWunNRJDAnsckKEuT96voH
         rpz2qxkhoDEQmMJAUPrAaGxhiO0WrrNitoh+5W8Hk9epf/MxzY5w43R7tzkRUdVNRBSV
         gLMA==
X-Gm-Message-State: AJIora8N9toVWTvQxhvaVnBXmiECqsXZAWm5s1w+W4YJluRpHnRfPlwS
        cttMg4Xp2rmkzh1pThOvYRUwew==
X-Google-Smtp-Source: AGRyM1ubhoTGIiAyjg1qXMnGlz1ZyvxEM4H8k7cKt0r3+RK2EY4Jb7jbNcPQwtwjhCKEOUGImNVTSw==
X-Received: by 2002:a17:90b:33ce:b0:1ef:e5f4:f8e2 with SMTP id lk14-20020a17090b33ce00b001efe5f4f8e2mr17614649pjb.70.1657816114803;
        Thu, 14 Jul 2022 09:28:34 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x10-20020a170902ec8a00b0016bde5edfb1sm1699060plg.171.2022.07.14.09.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 09:28:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     dylany@fb.com, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net, io-uring@vger.kernel.org,
        asml.silence@gmail.com
Cc:     Kernel-team@fb.com, netdev@vger.kernel.org
In-Reply-To: <20220714110258.1336200-1-dylany@fb.com>
References: <20220714110258.1336200-1-dylany@fb.com>
Subject: Re: [PATCH v3 for-next 0/3] io_uring: multishot recvmsg
Message-Id: <165781611347.622601.1646953722110423236.b4-ty@kernel.dk>
Date:   Thu, 14 Jul 2022 10:28:33 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jul 2022 04:02:55 -0700, Dylan Yudaken wrote:
> This series adds multishot support to recvmsg in io_uring.
> 
> The idea is that you submit a single multishot recvmsg and then receive
> completions as and when data arrives. For recvmsg each completion also has
> control data, and this is necessarily included in the same buffer as the
> payload.
> 
> [...]

Applied, thanks!

[1/3] net: copy from user before calling __copy_msghdr
      commit: 03a3f428042c7752afa5dc5ffe3cf0b8f0e2acbf
[2/3] net: copy from user before calling __get_compat_msghdr
      commit: 1a3e4e94a1b95edb37cf0f66d7dfb32beb61df7f
[3/3] io_uring: support multishot in recvmsg
      commit: a8b38c4ce7240d869c820d457bcd51e452149510

Best regards,
-- 
Jens Axboe


