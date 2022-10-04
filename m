Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41DF85F3A5E
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 02:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiJDAJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 20:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiJDAJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 20:09:45 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832202E2
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 17:09:44 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-1321a1e94b3so9064554fac.1
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 17:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=VHaX5CjLmUIPuSXN4EAQg4TAOvmE0NhuFNW4MZxyzrY=;
        b=Bzr1d1Wt17NH9/3RYvdzEsHPqxu32CDXYRt90BN5AxfH++uoe87KFLWvBIRE6gQTAf
         1fne81GOMsihD/7JuTAN16Nyjn498he0t12qxUSNPK+vYXjaPDuBR7YH0vO/3lxnQPI8
         i93xt2NOBZOiMqQeX16jbEEc2oKLJzDZCYcLJ118nl6gdMd1vtNtKVyYI+yBkayVlf+u
         C0pA0En66Uk0Xjy+XPIUlcuNB29CAY3prYEz+dljs0BECeMZvl/4lpciRsHL/Nt6KJcy
         lLzUF7geMRxojd687w9rCn489s6eRMF1/gNb69nZD613RWcGUKeQNmqOzFVVhvBA7Ggw
         k4hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=VHaX5CjLmUIPuSXN4EAQg4TAOvmE0NhuFNW4MZxyzrY=;
        b=MqYTGxHj0nN05yBosytyt9RYVtXKdscIQTt5tZp2JvdwXGbY+i0miZoUKgNNGsCnkH
         7Tj9OhtoPQerKxdjkGT8OB9yj4xRHyQiHdhI4eeQ7CpX95vaga0sYZwhMEvje2sYsOPz
         7I8dbpPZr2ft0tEiNWbVn/v4liSQPXM0XStghabwA9hrGOwdqjGsAXvv5RdM2+Yg8HMd
         y6DNoa6cl/uxIFfg23tqJ0zKYxmCXG1OQy/arg+3+J/YvFPPowFJaqXbd6JrsXbT+i68
         iAhI6lVr9okYb4qnd+F1ZXIQ3xOaAinE5PFXAu/5Xej7UPNIJ235CDVugz4/ZqsBKjzf
         X0KA==
X-Gm-Message-State: ACrzQf1/uFYWTzdwbYpIyz0c3Ygg9zGPGxrk0BqGNhHe3L4A5s4WETcS
        czj2343Gygkxb7ViFRhDJhI=
X-Google-Smtp-Source: AMsMyM4P+PX01CdfINCviwVKTx5o1XT5FJQMnKDPjp3ZsC5CmgsjYDF6gx45fgtIPrBEYqcfsh9R3A==
X-Received: by 2002:a05:6870:a18a:b0:131:7b25:8483 with SMTP id a10-20020a056870a18a00b001317b258483mr6541995oaf.100.1664842183694;
        Mon, 03 Oct 2022 17:09:43 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id q65-20020acac044000000b00342fc99c5cbsm2779865oif.54.2022.10.03.17.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 17:09:43 -0700 (PDT)
Date:   Mon, 3 Oct 2022 17:07:31 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>
Subject: Re: [PATCH 0/4] net: drop netif_attrmask_next*()
Message-ID: <Yzt5Q6G8v5xuYD7s@yury-laptop>
References: <20221002151702.3932770-1-yury.norov@gmail.com>
 <20221003095048.1a683ba7@kernel.org>
 <YzsluT4ET0zyjCtp@yury-laptop>
 <20221003162556.10a80858@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003162556.10a80858@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 03, 2022 at 04:25:56PM -0700, Jakub Kicinski wrote:
> On Mon, 3 Oct 2022 11:11:05 -0700 Yury Norov wrote:
> > On Mon, Oct 03, 2022 at 09:50:48AM -0700, Jakub Kicinski wrote:
> > > On Sun,  2 Oct 2022 08:16:58 -0700 Yury Norov wrote:  
> > > > netif_attrmask_next_and() generates warnings if CONFIG_DEBUG_PER_CPU_MAPS
> > > > is enabled.  
> > > 
> > > Could you describe the nature of the warning? Is it a false positive 
> > > or a legit warning?
> > > 
> > > If the former perhaps we should defer until after the next merge window.  
> > 
> > The problem is that netif_attrmask_next_and() is called with
> > n == nr_cpu_ids-1, which triggers cpu_max_bits_warn() after this:
> > 
> > https://lore.kernel.org/netdev/20220926103437.322f3c6c@kernel.org/
> 
> I see. Is that patch merged and on it's way?

This patch is already in pull request.

> Perhaps we can just revert it and try again after the merge window?

I don't understand this. To me it looks fairly normal - the check has
been fixed and merged (likely) in -rc1. After that we have 2 month to
spot, fix and test all issues discovered with correct cpumask_check().

I'm not insisting in moving this series in -rc1. Let's give it review
and careful testing, and merge in -rc2, 3 or whatever is appropriate.

Regarding cpumask_check() patch - I'd like to have it in -rc1 because
it will give people enough time to test their code...

Would it work?

Thanks,
Yury
