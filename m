Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9206C5FA98C
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 03:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiJKBB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 21:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiJKBB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 21:01:58 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5765178BEC
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 18:01:55 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id a5-20020a17090aa50500b002008eeb040eso255779pjq.1
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 18:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9efgnpCBqQ94aKo4PX1vfjYsrZbrUlJTy/MBW6JjYBI=;
        b=UwLHas2m0fD2dAKMu4EnJHBJYBdYBdTEkc6VAGnBmEcDlxTaD6HTczds63GDHT0OMH
         jIz7kYtQdELB/uBqdL3t9Zde/lDV8S/LuxTm8vmuXQIccARVjHSsHayIL5rMRHu7AuWM
         vEGXs58zNPb0LMJvmB957EFyHznlq9TPtwHag=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9efgnpCBqQ94aKo4PX1vfjYsrZbrUlJTy/MBW6JjYBI=;
        b=XZsPcmzdhon/ki2OTTr3XdCPjRMoZ5Sd71/9MGoYKK8M2VgPDRaiMiCyx0W5w6+j0O
         X+qQkLpe6uoP5Fp1jO1CyzoqWd9ARJFH7xVF9g+KVfDxJxmVjuSN407nxXfXkZNoQN9n
         luuvOzwtYWc8McO2/2iQiYGFf2+jqy/TQEnT7RbpIWt0wqeRyLGLLfJy0RdfIdY6Qyck
         iSFRBRg/iv6Ippq5+RK9sfsKtajQHJFw0c5bpYjzJE1vKbkoaqnFMFY+mMpH88wZgB5V
         /v13Cxadw6gx2ID0aDrYIVKq2WF5caJYqzHdxXeR2oB42RX+hEAqeyjRlvY8j9be9HK/
         Y2lg==
X-Gm-Message-State: ACrzQf1p2pbAdSzbUaa3m/2VO/NMMkxRbKiDmLRiR79jQP483B+pXKmR
        KKhmZ13FKnGz9rfh2DJQ5mBH7w==
X-Google-Smtp-Source: AMsMyM500jA2QkUaLemFTmEJzCYYD6riDVdpYG3DI79i+1NOvfNgxn/14POdyBSr/N2NxRb9Dcv33g==
X-Received: by 2002:a17:90a:ba90:b0:20d:3434:7f56 with SMTP id t16-20020a17090aba9000b0020d34347f56mr10821291pjr.105.1665450114867;
        Mon, 10 Oct 2022 18:01:54 -0700 (PDT)
Received: from fastly.com (c-24-6-151-244.hsd1.ca.comcast.net. [24.6.151.244])
        by smtp.gmail.com with ESMTPSA id s17-20020a170902c65100b0017cbd70d4cbsm7226506pls.230.2022.10.10.18.01.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Oct 2022 18:01:54 -0700 (PDT)
Date:   Mon, 10 Oct 2022 18:01:52 -0700
From:   Joe Damato <jdamato@fastly.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com
Subject: Re: [net-next PATCH] net: core: Add napi_complete_done tracepoint
Message-ID: <20221011010151.GA97503@fastly.com>
References: <1665426094-88160-1-git-send-email-jdamato@fastly.com>
 <20221010175824.28c61c50@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010175824.28c61c50@kernel.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 05:58:24PM -0700, Jakub Kicinski wrote:
> On Mon, 10 Oct 2022 11:21:34 -0700 Joe Damato wrote:
> > Add a tracepoint to help debug napi_complete_done. Users who set
> > defer_hard_irqs and the GRO timer can use this tracepoint to better
> > understand what impact these options have when their NIC driver calls
> > napi_complete_done.
> > 
> > perf trace can be used to enable the tracepoint and the output can be
> > examined to determine which settings should be adjusted.
> 
> Are you familiar with bpftrace, and it's ability to attach to kfunc 
> and kretfunc? We mostly add tracepoints to static functions which get
> inlined these days.

Fair enough; I'll avoid sending patches like that in the future. It's been
helpful for me, but point taken. Sorry for the noise.
