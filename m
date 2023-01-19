Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5C967436E
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 21:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbjASUT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 15:19:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjASUT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 15:19:57 -0500
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C2E9DC84
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 12:19:55 -0800 (PST)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-1442977d77dso3910650fac.6
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 12:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PXm2AbNmH230OQm6I2pKgkrvE24EEIT+q8c5LDIh0a8=;
        b=jCEZlsbrjdltoAQcDpL/spkV9FoM3Yv6nVc0QMZZ6Wj+28NgZOS/TE0dt4mihmXM/Q
         cR6rru+COth2PEy5HJUq6t56ygdYMC+dh8LCbeynJfjGJ22RDEL4HIm7lDv6AaPZDV+7
         CtvLI8sU9zyZGitlw1Z60YdeRfmutt+iBjIuZRIFX3PnQkCTnTYNe4Y0me8Gqu+svVLO
         fpBdxB8o7Nc33O7Sh5zp2TYrRJ8WA0A2cl9YfI+dfGCnHc6zzT3EXtdo9HZlc6n2DFBw
         qjbEpRaTqJqBT77xVr42rXeC/US10Xz0AU6ueoFAI7hEFIcQZlpb02ZfS66m1icUHUBV
         ovdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PXm2AbNmH230OQm6I2pKgkrvE24EEIT+q8c5LDIh0a8=;
        b=DZOlFjc7uuMlX5uUXQ4swzcPi9zOSmDEsXmfF2ZaAmr6y3zH/0eZnOrL5AJJKMb84d
         +XD/IXYOBDItyFclmJ1qHPHty7vSOXYcohHFMVlDLtn3Iom0OguXrHz7e+Y8ahbFhhnJ
         f/tTsK3v+P/d4LAXZRFnu90zCQ79X2+DZglM3xHys4EucYLFYLDETOMekF0v4/kYGaek
         oyLtEPILwUPr2VfV0aU4Duow7AHZGsnpqOvci/NkTE/Q6JNyVzQpGU4cev3eMSg2+8/K
         T8owAoWrKmLnXfoyCqx+olmHzmQed8nRN5WoyJuY0dljkcpehSgemRLAn7YIhsCW/VLs
         YXVg==
X-Gm-Message-State: AFqh2kqabd/wnC8TCv85c/B0jPT3TrfFGRxyiLKRhwHzG5v9sHvwCtGt
        OkFsq+cK93x1JD9VcN8lasE=
X-Google-Smtp-Source: AMrXdXsWloG8nkZ+kabdzZIyd0ppo4fNdlSj2DAOrxFw3jJ78Y7o4jy7hw90oa/iG8S+O/LdHUQ3UA==
X-Received: by 2002:a05:6870:c906:b0:15e:f1d6:3d8 with SMTP id hj6-20020a056870c90600b0015ef1d603d8mr6449301oab.14.1674159594678;
        Thu, 19 Jan 2023 12:19:54 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:3a02:bbf0:9a75:78ad])
        by smtp.gmail.com with ESMTPSA id r10-20020a05687032ca00b0014ff15936casm20752224oac.40.2023.01.19.12.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 12:19:54 -0800 (PST)
Date:   Thu, 19 Jan 2023 12:19:53 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        jhs@mojatatu.com, jiri@resnulli.us, john.hurley@netronome.com
Subject: Re: [PATCH net] net: sched: gred: prevent races when adding offloads
 to stats
Message-ID: <Y8ml6VQ2L+YQqGmB@pop-os.localdomain>
References: <20230113044137.1383067-1-kuba@kernel.org>
 <Y8Ni7XYRj5/feifn@pop-os.localdomain>
 <7e0d5d6891697d24f9f9509fb8626ea9129b5eb2.camel@redhat.com>
 <20230117111019.50c47ea1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117111019.50c47ea1@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 11:10:19AM -0800, Jakub Kicinski wrote:
> On Tue, 17 Jan 2023 10:00:56 +0100 Paolo Abeni wrote:
> > On Sat, 2023-01-14 at 18:20 -0800, Cong Wang wrote:
> > > On Thu, Jan 12, 2023 at 08:41:37PM -0800, Jakub Kicinski wrote:  
> > > > Naresh reports seeing a warning that gred is calling
> > > > u64_stats_update_begin() with preemption enabled.
> > > > Arnd points out it's coming from _bstats_update().  
> > > 
> > > The stack trace looks confusing to me without further decoding.
> > > 
> > > Are you sure we use sch->qstats/bstats in __dev_queue_xmit() there
> > > not any netdev stats? It may be a false positive one as they may end up
> > > with the same lockdep class.  
> 
> I didn't repro this myself, TBH, but there is u64_stats_update_begin() 
> inside _bstats_update(). Pretty sure it will trigger the warning that
> preemption is not disabled on non-SMP systems.
> 
> > I'm unsure I read you comment correctly. Please note that the
> > referenced message includes several splats. The first one - arguably
> > the most relevant - points to the lack of locking in the gred control
> > path.
> 
> Yup, I'm not really sure if we're fixing the right splat for the bug.
> But I am fairly confident we should be holding a lock while writing
> bstats from the dump path, enqueue/dequeue may run concurrently.

Explain htb_dump_class_stats()? :) I see two _bstats_update() calls but
I don't see any tree lock there.

Thanks.
