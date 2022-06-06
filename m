Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752B453E927
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237079AbiFFMcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 08:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237064AbiFFMcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 08:32:14 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB78E2716;
        Mon,  6 Jun 2022 05:32:12 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 626331F8C0;
        Mon,  6 Jun 2022 12:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654518731; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QmnQvelulN9ISJl++c1aKnCaY5Y/JjxqU7vIBDvzm3w=;
        b=MwHhGVS1WO72E8CSbOvvz7pMIKubeYL4Ju+e8htY06tSlEPcNG9Ywrq92+6BEYUlqG3M1C
        68EmP9B6vOmAU4fTcCbXDh8q1bnGbCeY9LnC3kV2HxIYSs5qB5XmUqeb8zI7AvhBKgnH4z
        /P+WXycLAm7EQ5lm1ROAwJhKcDHvrNs=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D0C9D139F5;
        Mon,  6 Jun 2022 12:32:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YWykMcrznWIcPQAAMHmgww
        (envelope-from <mkoutny@suse.com>); Mon, 06 Jun 2022 12:32:10 +0000
Date:   Mon, 6 Jun 2022 14:32:09 +0200
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 0/5] bpf: rstat: cgroup hierarchical stats
Message-ID: <20220606123209.GE6928@blackbody.suse.cz>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220603162247.GC16134@blackbody.suse.cz>
 <CAJD7tkbp9Tw4oGtxsnHQB+5VZHMFa4J0qvJGRyj3VuuQ4UPF=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD7tkbp9Tw4oGtxsnHQB+5VZHMFa4J0qvJGRyj3VuuQ4UPF=g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 03, 2022 at 12:47:19PM -0700, Yosry Ahmed <yosryahmed@google.com> wrote:
> In short, think of these bpf maps as equivalents to "struct
> memcg_vmstats" and "struct memcg_vmstats_percpu" in the memory
> controller. They are just containers to store the stats in, they do
> not have any subgraph structure and they have no use beyond storing
> percpu and total stats.

Thanks for the explanation.

> I run small microbenchmarks that are not worth posting, they compared
> the latency of bpf stats collection vs. in-kernel code that adds stats
> to struct memcg_vmstats[_percpu] and flushes them accordingly, the
> difference was marginal.

OK, that's a reasonable comparison.

> The main reason for this is to provide data in a similar fashion to
> cgroupfs, in text file per-cgroup. I will include this clearly in the
> next cover message.

Thanks, it'd be great to have that use-case captured there.

> AFAIK loading bpf programs requires a privileged user, so someone has
> to approve such a program. Am I missing something?

A sysctl unprivileged_bpf_disabled somehow stuck in my head. But as I
wrote, this adds a way how to call cgroup_rstat_updated() directly, it's
not reserved for privilged users anyhow.

> bpf_iter_run_prog() is used to run bpf iterator programs, and it grabs
> rcu read lock before doing so. So AFAICT we are good on that front.

Thanks for the clarification.


Michal
