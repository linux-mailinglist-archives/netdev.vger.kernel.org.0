Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7239B5226AB
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 00:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235162AbiEJWJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 18:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbiEJWJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 18:09:20 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FC928B683;
        Tue, 10 May 2022 15:09:19 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id n10so431824pjh.5;
        Tue, 10 May 2022 15:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K/YRl0EHG6/vXUptECv10Aauq/B8k7rs/JZcz3pAi9w=;
        b=CJvFFv58sImc2fcQ7NsltAoprTMkf9aZO2qc39iio4VUJ+QAhHceQxanfIuUeIi5Nm
         W24275MUyU6Z6K6+FBOiW62RkCq2sZC1HOJ/ffKJabKOHIBTVrPBRDzdofuuLXhcOfqg
         1lnstTBHmuonZVrjv3cX/EM733/CP+IwyYzrH1GcL2u0Wn0aXSxPYXiKakw4rB/NA3UH
         X+V1l4tH5u7VXfQ5syp8MZv8EF5IUZRjUdKpaoTP/mQXZAM2WISVdqSZW8Ly95fHSSwg
         LyqF6dVvC9WnSNLoa6nEfPa6DEwLmOVttivdoBEHQEcwqapkfLt6jxYRbhyTSZ1486Hy
         8h9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=K/YRl0EHG6/vXUptECv10Aauq/B8k7rs/JZcz3pAi9w=;
        b=aRKccE84fjQ3gkIAd40EsfZb9leIKLdolfqt0nttmuYZBkrkaWthaPPZYDE8NqaSUI
         Es0VF9WXIz0oirh8MIFpTeY1eZsh6/cylJjohBsLWwZoy4XXDRY3gI3jb6SqHtq/5DyC
         199lMT9zL2GS0cWvTwTwXdQPVOt0erxfx8tlPo4Fe4Vax0OjVBNS8X6r4+SCng1/5yMv
         nh+2eb4THbuPFdTaiFOw0BR1u64eHQd48lMNQv3CBSfZLTkqcr/r8p5Fj2hfx8EXnlPB
         t+d6kP6xwHwMTXAz8E+dMSTDHMDefavMLliIt67s2VhlCVGhh9QPUENlOMVxizCkp77P
         CVKA==
X-Gm-Message-State: AOAM5336l7n0N5gmo5P53faxqDr/VdmDVgMDeX4T0WhY+sbsilJXVhKP
        Xy6Z4YmOUAt1CaRFwhHzcxM=
X-Google-Smtp-Source: ABdhPJzg9Powi2q6BkbPLmucEileOTWi2Y1cLaSxHVfWM27OVcCt62KqeBUJx4MuXG6tiVzxEzL39A==
X-Received: by 2002:a17:90b:3812:b0:1dc:8502:2479 with SMTP id mq18-20020a17090b381200b001dc85022479mr1960594pjb.97.1652220558919;
        Tue, 10 May 2022 15:09:18 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::4:6c64])
        by smtp.gmail.com with ESMTPSA id 5-20020a170902e9c500b0015edc07dcf3sm134840plk.21.2022.05.10.15.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 15:09:18 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 10 May 2022 12:09:17 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        cgroups@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 1/9] bpf: introduce CGROUP_SUBSYS_RSTAT
 program type
Message-ID: <YnrijQK6l77qAo+z@slm.duckdns.org>
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-2-yosryahmed@google.com>
 <Ynqyh+K1tMyNCTUW@slm.duckdns.org>
 <CAJD7tkZVXJY3s2k8M4pcq+eJVD+aX=iMDiDKtdE=j0_q+UWQzA@mail.gmail.com>
 <YnrEDfZs1kuB1gu5@slm.duckdns.org>
 <CAJD7tkahC1e-_K0xJMu-xXwd8WNVzYDRgJFua9=JhNRq7b+G8A@mail.gmail.com>
 <YnrSrKFTBn3IyUfa@slm.duckdns.org>
 <CAJD7tkbeZPH9UJXtGeopPnTSVPYN-GzzM51SE_QNuLmiaVNpeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD7tkbeZPH9UJXtGeopPnTSVPYN-GzzM51SE_QNuLmiaVNpeA@mail.gmail.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, May 10, 2022 at 02:55:32PM -0700, Yosry Ahmed wrote:
> That's great to hear. I am all in for making the userspace interface
> simpler. I will rework this patch series so that the BPF programs just
> attach to "rstat" and send a V1.
> Any other concerns you have that you think I should address in V1?

Not that I can think of right now but my bpf side insight is really limited,
so it might be worthwhile to wait for some bpf folks to chime in?

Thanks.

-- 
tejun
