Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3DAD584469
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 18:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbiG1QwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 12:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbiG1QwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 12:52:01 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEFC70E53;
        Thu, 28 Jul 2022 09:52:00 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id y15so2269833plp.10;
        Thu, 28 Jul 2022 09:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=fUVrK6g6lEQcJgvUhuFR+4LVGwptL3CDZhDO7VRmNOg=;
        b=TOhl89jKQ+CkKM87tj1vWT5uQe8ni61gDVjTKzKPd+UpFyilcZ9zwRWS+IPM5TGXaU
         u4OZN8NerzC0JJFwL/LMrixY61CQxOavVDHVnFiRXhWoqiKIS84crWtf2ADSbsopoDx9
         CqQVo0FPvxJzSOYl/kChHOYJRiYCXURZQu8o9ZpkYt7W9Jc0yqedeTqfNgiIUSdvNoKH
         2xPMnNg3Z1+5kPRZ2bfAL3VxeSVJUXCxZbwDO0jc3uxzGND46zHX0Q20Wi38L9P+V6EH
         CfgH6pPNiN77F64BMbn4ufnL8wVhgVcbTodO/fXy6GyeF4xIHvXyxZkVykVSklWTTq82
         5KGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=fUVrK6g6lEQcJgvUhuFR+4LVGwptL3CDZhDO7VRmNOg=;
        b=MLoXuuj5D/rYPDff1wjOE18+tMr8vUPZu5hlC4sOn+wceMfVQcxwtUPGEUA5yLBAux
         DeACz+xo+zValXWeNDSwdcV9EpPNe+9b0esL5fs72YZ900WMa2iuYbywCt6Mo7xtiduR
         U+ZJUOcfOqtPCkuYmD3s076I1lnRNgmlvnCKK9wDU3Lk6rLYO6gY8o4IU9PlUzMv6+dB
         X+OfYW1ttV4S4T9IYFLmv0aXt9Y6zkukISR3lOeCgxDcESRx7udywd5uESxAHpGT3Ecb
         yUtmMNECoejh/P2GLFS8nHox07dRg1lf9mb+kp2lcrDutgoy4LDXvec+wlaGp1gq0Cd9
         Qx4w==
X-Gm-Message-State: AJIora9Y6iL3/sTPi7700+45CrUaud5WwAoZWb3uacFcvwu2lLOicUFm
        xUPvYqX0PXrQDgFn+gFp5E8=
X-Google-Smtp-Source: AGRyM1slV7f42a9r0z9ic0zdKmN0qYm12B5tomXz+oZofoxBS+pi5Tzha7NWrt/S4nWycAi7IgtjjA==
X-Received: by 2002:a17:902:e84e:b0:16b:f773:4692 with SMTP id t14-20020a170902e84e00b0016bf7734692mr27142961plg.19.1659027119804;
        Thu, 28 Jul 2022 09:51:59 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id m13-20020a170902f64d00b0016bf2a4598asm1478509plg.229.2022.07.28.09.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 09:51:59 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 28 Jul 2022 06:51:57 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Hao Luo <haoluo@google.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH bpf-next v5 6/8] cgroup: bpf: enable bpf programs to
 integrate with rstat
Message-ID: <YuK+rbZXg7CYjLhE@slm.duckdns.org>
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-7-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722174829.3422466-7-yosryahmed@google.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 05:48:27PM +0000, Yosry Ahmed wrote:
> Enable bpf programs to make use of rstat to collect cgroup hierarchical
> stats efficiently:
> - Add cgroup_rstat_updated() kfunc, for bpf progs that collect stats.
> - Add cgroup_rstat_flush() sleepable kfunc, for bpf progs that read stats.
> - Add an empty bpf_rstat_flush() hook that is called during rstat
>   flushing, for bpf progs that flush stats to attach to. Attaching a bpf
>   prog to this hook effectively registers it as a flush callback.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
