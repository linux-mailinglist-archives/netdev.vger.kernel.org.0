Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 609E84DA8D9
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 04:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242428AbiCPDYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 23:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236454AbiCPDYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 23:24:03 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F60A1FC;
        Tue, 15 Mar 2022 20:22:50 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id l18so1018466ioj.2;
        Tue, 15 Mar 2022 20:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=izJh8Kl3e5da/p7SCFgdwAX2gNzkPuf9fV6dL2rM3ec=;
        b=ZcI6cD2JDarphhBLLRTLlJN7HHjzbH80qrA5mwLdixTE8fWZfN6mt3H1GUbA5MoL9G
         Den/NIFD/2PTfaagAIFeWjPcV91YF02ngjeW6Oyt65+6JAXVP6B4YomGAYbK4E4PMqN/
         IRUTI3yyZC/dTbfnpQucn8jIZcQbhcm9Fo1VkivAuv4m+SPR7mkJMUoK6hq4x0gubHIo
         GZX9gsfnc6yobRn7pwFB6G/263xUBcHHV4GCXUfOjAKYsQHYdTmTRhQZKgGzC/GMoRFu
         UOUBlO+QLsSmFlHgCoCWFsId5XjaRQl3wZvpCdQnh3LrYTCjQGGzvKT8P/XRsd3p1MEc
         ICMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=izJh8Kl3e5da/p7SCFgdwAX2gNzkPuf9fV6dL2rM3ec=;
        b=kb+MS6S7/sspDarsdk1oniqr32Vefsu+0lliQ5YlmjwFjfMf+8/TBv0WtdIabDu5uY
         RkUsjiEEvmwU7n2viELuuJB5KVlSiMezvC6GdA2QXsc9x7/szST0pkktfSAHIrBm+D5O
         7k41g6gr+ge+z4acRsm1IabxlYsgHllOVEJWsGPWJW9A2f33YA1SKGcmq/+Ox1se0JYU
         pmQG99yHyKgnThSUhmDwYplFuG7SLLZbd2ZvRJ8+WWlcGD11yPvaLVyFCLXg/dQTE/rt
         0o/3FBV/+/MvTb6xNe8WxnZ0TRnI2sFyTy2OJAJ+YbZjgAeRbuY8o7W3CFbAGT50qjHA
         f4xQ==
X-Gm-Message-State: AOAM531uBhF8QnUtZlMP4YRh0iVZ6XpqQYkSSyk2aya86b+oJaO+os7I
        Nx22Qj3EjcCU9XPWjaxHIMyAbVogfFYKvg==
X-Google-Smtp-Source: ABdhPJzxbp8+tJrN1hrfoUkR1AqyuKJz2SxsmWLpTkH/AqQE1HhtqEs2ZbYfqfyk9TS9sp18axo+WQ==
X-Received: by 2002:a02:85e2:0:b0:317:2edb:46cb with SMTP id d89-20020a0285e2000000b003172edb46cbmr24045228jai.118.1647400969376;
        Tue, 15 Mar 2022 20:22:49 -0700 (PDT)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id a6-20020a92c546000000b002c7a44bf1a5sm513156ilj.48.2022.03.15.20.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 20:22:48 -0700 (PDT)
Date:   Tue, 15 Mar 2022 20:22:42 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, toke@redhat.com,
        pabeni@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Message-ID: <62315802def7f_94df20826@john.notmuch>
In-Reply-To: <54f9fd3bb65d190daf2c0bbae2f852ff16cfbaa0.1646989407.git.lorenzo@kernel.org>
References: <cover.1646989407.git.lorenzo@kernel.org>
 <54f9fd3bb65d190daf2c0bbae2f852ff16cfbaa0.1646989407.git.lorenzo@kernel.org>
Subject: RE: [PATCH v5 bpf-next 1/3] net: veth: account total xdp_frame len
 running ndo_xdp_xmit
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Even if this is a theoretical issue since it is not possible to perform
> XDP_REDIRECT on a non-linear xdp_frame, veth driver does not account
> paged area in ndo_xdp_xmit function pointer.
> Introduce xdp_get_frame_len utility routine to get the xdp_frame full
> length and account total frame size running XDP_REDIRECT of a
> non-linear xdp frame into a veth device.
> 
> Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
