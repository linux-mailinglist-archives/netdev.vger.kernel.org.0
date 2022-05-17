Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5F4529725
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 04:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235100AbiEQCIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 22:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiEQCIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 22:08:46 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743C244A0C;
        Mon, 16 May 2022 19:08:45 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id m12so16119933plb.4;
        Mon, 16 May 2022 19:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EhSJRAeClIxsH0n9sFab63mgbLc++zW1P8KwkkDOW2c=;
        b=TyMBoeYxS5mFRDLo8Oqj9XZaCSAOh9T7N8WhHeJjjYmS+6pnKVHlvu84MWs1TsRPip
         VvubkItsCpn7YWwlPtPkWHs8WHI0UEhjulAhirwEZSuJP6tIFq/FSm5jiVxxr9XVT7zu
         sm0/2HJwRdtB6VIhHhINbgQXtEq4tI//dA4LG3MXuDJMmx05BAoRrX3uWhNKp7WKfr4d
         3JytCUziPR25LtgqezGXEyxdO/mca2I8ZjQ0huht40T4ryXHrHEgW3NRy44jIimGW74Q
         eKby9VSV7wUBO317XM2yhQZCBcE+WuHTeQElAzIvhXBNAyMthtgjz+HNyUtf57q5Kpwl
         dBAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EhSJRAeClIxsH0n9sFab63mgbLc++zW1P8KwkkDOW2c=;
        b=7hfERhYro72eRAwsl+XPWxGLVmiK1IifUZzqVIKbnGKGKnedZPwpa+bp/5xoDqtkQA
         K4WflhTB5qapAwSdbIV8COrYtnPMzlcJYj0Qb3c3+M5MCJDgCof+aP99PzpISyNmUV5z
         VTfcrJ4OjFYUMXRcXIlYalXNVlgWI65gHs7xw0HlyPKEtZetPdDmzVV0Yt3kqVLmvBZC
         G36kmHjN+9GnEp/weBQ13Cz0Y1qrSP+0hS2f2uHmr1/pRRLbnI4SnvVCY68CV0H7o+Br
         DVSLhdaQnCKgrZnfghkP3AMpCYsA5xQOS1kK1narcO2gUJpUgZXknS0keVcdirZMbJbR
         KdGA==
X-Gm-Message-State: AOAM531nzDpbRtSB2fXAPBKFcPx7rSqmXWAn0zJU0k5WINyQSI32MKgW
        ft5OvibXMHWQ3yjmGQny4ds=
X-Google-Smtp-Source: ABdhPJyrc+oFv/EwBb85McDxLMi6hEHL2xbFFvBBRH5ktEgydFh2ArPos/rB5Sj0wlK9orlbf4ocyw==
X-Received: by 2002:a17:902:7798:b0:158:ee95:f45b with SMTP id o24-20020a170902779800b00158ee95f45bmr19992724pll.97.1652753324903;
        Mon, 16 May 2022 19:08:44 -0700 (PDT)
Received: from MBP-98dd607d3435.dhcp.thefacebook.com ([2620:10d:c090:400::4:3651])
        by smtp.gmail.com with ESMTPSA id n9-20020a17090a928900b001d92e2e5694sm378289pjo.1.2022.05.16.19.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 19:08:44 -0700 (PDT)
Date:   Mon, 16 May 2022 19:08:40 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next v2 2/7] cgroup: bpf: flush bpf stats on
 rstat flush
Message-ID: <20220517020840.vyfp5cit66fs2k2o@MBP-98dd607d3435.dhcp.thefacebook.com>
References: <20220515023504.1823463-1-yosryahmed@google.com>
 <20220515023504.1823463-3-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220515023504.1823463-3-yosryahmed@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 15, 2022 at 02:34:59AM +0000, Yosry Ahmed wrote:
> +
> +void bpf_rstat_flush(struct cgroup *cgrp, int cpu)
> +{
> +	struct bpf_rstat_flusher *flusher;
> +	struct bpf_rstat_flush_ctx ctx = {
> +		.cgrp = cgrp,
> +		.parent = cgroup_parent(cgrp),
> +		.cpu = cpu,
> +	};
> +
> +	rcu_read_lock();
> +	migrate_disable();
> +	spin_lock(&bpf_rstat_flushers_lock);
> +
> +	list_for_each_entry(flusher, &bpf_rstat_flushers, list)
> +		(void) bpf_prog_run(flusher->prog, &ctx);
> +
> +	spin_unlock(&bpf_rstat_flushers_lock);
> +	migrate_enable();
> +	rcu_read_unlock();
> +}
> diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
> index 24b5c2ab5598..0285d496e807 100644
> --- a/kernel/cgroup/rstat.c
> +++ b/kernel/cgroup/rstat.c
> @@ -2,6 +2,7 @@
>  #include "cgroup-internal.h"
>  
>  #include <linux/sched/cputime.h>
> +#include <linux/bpf-rstat.h>
>  
>  static DEFINE_SPINLOCK(cgroup_rstat_lock);
>  static DEFINE_PER_CPU(raw_spinlock_t, cgroup_rstat_cpu_lock);
> @@ -168,6 +169,7 @@ static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool may_sleep)
>  			struct cgroup_subsys_state *css;
>  
>  			cgroup_base_stat_flush(pos, cpu);
> +			bpf_rstat_flush(pos, cpu);

Please use the following approach instead:

__weak noinline void bpf_rstat_flush(struct cgroup *cgrp, struct cgroup *parent, int cpu)
{
}

and change above line to:
  bpf_rstat_flush(pos, cgroup_parent(pos), cpu);

Then tracing bpf fentry progs will be able to attach to bpf_rstat_flush.
Pretty much the patches 1, 2, 3 are not necessary.
In patch 4 add bpf_cgroup_rstat_updated/flush as two kfuncs instead of stable helpers.

This way patches 1,2,3,4 will become 2 trivial patches and we will be
able to extend the interface between cgroup rstat and bpf whenever we need
without worrying about uapi stability.

We had similar discusison with HID subsystem that plans to use bpf in HID
with the same approach.
See this patch set:
https://lore.kernel.org/bpf/20220421140740.459558-2-benjamin.tissoires@redhat.com/
You'd need patch 1 from it to enable kfuncs for tracing.

Your patch 5 is needed as-is.
Yonghong,
please review it.
Different approach for patch 1-4 won't affect patch 5.
Patches 6 and 7 look good.

With this approach that patch 7 will mostly stay as-is. Instead of:
+SEC("rstat/flush")
+int vmscan_flush(struct bpf_rstat_flush_ctx *ctx)
+{
+       struct vmscan_percpu *pcpu_stat;
+       struct vmscan *total_stat, *parent_stat;
+       struct cgroup *cgrp = ctx->cgrp, *parent = ctx->parent;

it will become

SEC("fentry/bpf_rstat_flush")
int BPF_PROG(vmscan_flush, struct cgroup *cgrp, struct cgroup *parent, int cpu)
