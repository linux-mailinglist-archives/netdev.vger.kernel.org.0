Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7020B5E56DA
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 01:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiIUXyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 19:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiIUXyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 19:54:49 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A39714D1F;
        Wed, 21 Sep 2022 16:54:46 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id a80so7585721pfa.4;
        Wed, 21 Sep 2022 16:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=0QKLHzjgFC8G3roJi1ZzbgK4edYCAMV4o0XzcHxrPS0=;
        b=VX7n6GKJQLkFZ4661oR94fC3SQeGQH631f47a3ulfxCsmstnUzavDqlHJaoq8SOeqq
         Bfdn+56En29hfy5g+ByJxlDamT0DeDf1u+e9gQUYt7DEAXff/bF2UoEcnYNphbw04z2W
         2wdWQcH7oPaHr2JJAlrLCezXgd/SBAK1nR/9FrBBDuHs0f1XiLuSRDfDKamddS81KX0C
         dPQpEHErk5Ps1+GyZ4wfOdbNHma7qb4zH5XPHTeeM46SuNg+kyG0G0mDMWAU1nHUiSLs
         kTi+dSbm7w1WLWnm8wCHyXutwOujOHt1Qw61mQn3Mp+mLe3Z45CE8XtIKAhXepz8YJBF
         j1/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=0QKLHzjgFC8G3roJi1ZzbgK4edYCAMV4o0XzcHxrPS0=;
        b=SmDYMHJRqRm+Ir3V5Rj5SesKjoFMHZWIzze9u95DgkCwvDMreeKFn8vnP0gSW4h2kC
         QJIQoWdxHFyIS620SfA/03CSBzHZtvZ3pkrDVZFOU5c8K3hJ6rU5x+Ork+h5Jrv3eAB+
         Ft9t2JkVJkA8V1ru44n4ETKKrRygXBK1w1xntYqUIsczoNhNne6C+H+OMckJSYBXM6Jr
         /T1JlPj/K1bqxdRCHHJ2SiDhlBnict1dtWIR8UA9pKd0uHKGUov5IwWoSmoARUGs8Ryv
         5cp83cZ96W5U/ISRkoQoIbKBXZQpnsx0llRxje+uPXF6vYAFFmq9VKEMg8KHtuLGPcvr
         /tVg==
X-Gm-Message-State: ACrzQf1uD10wM0Pir/HNYbnQUQZtjNj7ND21mMTY3Ed2dTijyRr2oxSM
        FMAcCRwyDCK+eF5h3mbKrNc=
X-Google-Smtp-Source: AMsMyM60RIhZdWRdmOqpVvZGcXuYIDUweg512rwzoRK9zNVCrGgDs/Qxu89H+gVgaXdi8R3SGqznEg==
X-Received: by 2002:a63:117:0:b0:43a:348b:603c with SMTP id 23-20020a630117000000b0043a348b603cmr633185pgb.378.1663804485852;
        Wed, 21 Sep 2022 16:54:45 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::5:f5ba])
        by smtp.gmail.com with ESMTPSA id a67-20020a624d46000000b005465ffaa89dsm2741869pfb.184.2022.09.21.16.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 16:54:45 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 21 Sep 2022 13:54:43 -1000
From:   Tejun Heo <tj@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Sherry Yang <sherry.yang@oracle.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Jack Vogel <jack.vogel@oracle.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: 10% regression in qperf tcp latency after introducing commit
 "4a61bf7f9b18 random: defer fast pool mixing to worker"
Message-ID: <YyukQ/oU/jkp0OXA@slm.duckdns.org>
References: <B1BC4DB8-8F40-4975-B8E7-9ED9BFF1D50E@oracle.com>
 <CAHmME9rUn0b5FKNFYkxyrn5cLiuW_nOxUZi3mRpPaBkUo9JWEQ@mail.gmail.com>
 <04044E39-B150-4147-A090-3D942AF643DF@oracle.com>
 <CAHmME9oKcqceoFpKkooCp5wriLLptpN=+WrrG0KcDWjBahM0bQ@mail.gmail.com>
 <BD03BFF6-C369-4D34-A38B-49653F1CBC53@oracle.com>
 <YyuREcGAXV9828w5@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyuREcGAXV9828w5@zx2c4.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, Sep 22, 2022 at 12:32:49AM +0200, Jason A. Donenfeld wrote:
> What are our options? Investigate queue_work_on() bottlenecks? Move back
> to the original pattern, but use raw spinlocks? Some thing else?

I doubt it's queue_work_on() itself if it's called at very high frequency as
the duplicate calls would just fail to claim the PENDING bit and return but
if it's being called at a high frequency, it'd be waking up a kthread over
and over again, which can get pretty expensive. Maybe that ends competing
with softirqd which is handling net rx or sth?

So, yeah, I'd try something which doesn't always involve scheduling and a
context switch whether that's softirq, tasklet, or irq work. I probably am
mistaken but I thought RT kernel pushes irq handling to threads so that
these things can be handled sanely. Is this some special case?

Thanks.

-- 
tejun
