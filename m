Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D990653D3CC
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 01:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349621AbiFCXO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 19:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349615AbiFCXOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 19:14:53 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2294A326D0;
        Fri,  3 Jun 2022 16:14:52 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-edeb6c3642so12501852fac.3;
        Fri, 03 Jun 2022 16:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4y3hVeIT1//FJGx9xMPZWboIV7eMOH+OdV7qAjzNTtw=;
        b=UjAZcRHCsfWm2XT5uUm9DLCk2KUjCNS2LQVyfL06cxueiXW7FAUSmDVL9hqQ3pSdyw
         3PLwIaWfxsDdngVY19wGEiqPuxFPcw/JX8sBcKElRopR7Oj+rJGqXYpgLzCrzrJqnNAs
         u2ihpTO4qgzsJfPAXoC1dl9DPqLnjMfnrz6ey+TXV1BTtAzflWlRHE9/LyrngCgWaHYo
         jHFs1yfv/47Jl7TSITVyOMKosGRuLLpSJklQUOVHjRr5/Q2AD4A7XKDT03hoB9MH3szx
         kxjrnRJziiDgldN0kI0GWl2waesoEEpnKD5gFUhR1BjvbzE2wOslWdxh5TtWr/oxHNnE
         p9Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4y3hVeIT1//FJGx9xMPZWboIV7eMOH+OdV7qAjzNTtw=;
        b=i58h2C6OIimYK9W91G/OQANnuLASfijZOwCxXoLFYEIWJeRwwFUM/mjRsSnLcTp7u/
         OqsRAZurOJoqCj4D28kORg7gyDUAql6U575WAGGhWQy899cP9y4KMX5rdIf9I6s4Hbzo
         ftVQtcJIA+DegBvR/l18eTCvudl9HjSBjp9ds9j5aKl+5gv3Dkh9Ujxlb6zhayEtwT3J
         MKj4zdNAZULIfIxoB79kFjZKRhPQbQpI/YHsxzy0Id9KsikfXU/oGptyATWZktYf8gyt
         GdF8CADKB68Xkijh57AK9BcOENSH+LDQxJYCNCQRgA0y0bO0Equ+3uBoWbJDYEH2JzqN
         vsfg==
X-Gm-Message-State: AOAM532RdDa6FKTN/KtdbUkvmxy7hiEXtFos6muSys16CZ+e6JeSWehf
        BBbWIQLbBhn7TmFpO0eR4AVFjCu0NCk=
X-Google-Smtp-Source: ABdhPJwYUVz22zejEpRjKRayPFVn/7n9UNU3y9TnQgnbPwOwMYfIpkx+Y0LtlMFVUjgMZizGIsN6Zw==
X-Received: by 2002:a05:6870:8193:b0:f5:d85f:8bf5 with SMTP id k19-20020a056870819300b000f5d85f8bf5mr11603176oae.206.1654298092059;
        Fri, 03 Jun 2022 16:14:52 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:2a2c:4a89:4392:d8ce])
        by smtp.gmail.com with ESMTPSA id a30-20020a544e1e000000b00324f24e623fsm4544370oiy.3.2022.06.03.16.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 16:14:51 -0700 (PDT)
Date:   Fri, 3 Jun 2022 16:14:50 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [RFC Patch v5 4/5] net_sched: introduce eBPF based Qdisc
Message-ID: <YpqV6hOYSWIudwOj@pop-os.localdomain>
References: <20220602041028.95124-1-xiyou.wangcong@gmail.com>
 <20220602041028.95124-5-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602041028.95124-5-xiyou.wangcong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 01, 2022 at 09:10:27PM -0700, Cong Wang wrote:
> Because eBPF maps are not directly visible to this Qdisc, so we have to
> rely on user-space dumping to retrieve the stats, which is not
> implemented yet as I don't find a right API to do this.
> 

I think an iterator for skb map could do this job, so I just implemented
it here:
https://github.com/congwang/linux/commit/aed8536a94836bf6df69a379c43b03e50bf4f813
which will be in the next update.

Thanks.
