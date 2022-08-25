Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793795A15AA
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 17:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242725AbiHYPZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 11:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241644AbiHYPZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 11:25:01 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB3365836;
        Thu, 25 Aug 2022 08:25:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9BEC533F2A;
        Thu, 25 Aug 2022 15:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661441098; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZxGr3EJuIrdktJcj6rqi0sQ+aGd1Ypmw1/Whqwd5Z6M=;
        b=KlyxheLvPhb35mhUe6o65ZtCuyxtUnup4XT0WXWnOhRRyiBYHQNoMyxbDAQKpldAvy8HTI
        VTUhgQqvcD6Xnx7r4TA10dDXC1rc04BurgKLEmEkeqF1BRhyqTrTw/9cetePdYDkBvHtVf
        AyLXvkT0Y1HGv5E1NcG8RV2ARcHqJTY=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D7F1A13A8E;
        Thu, 25 Aug 2022 15:24:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NkQ7M0mUB2NCZQAAMHmgww
        (envelope-from <mkoutny@suse.com>); Thu, 25 Aug 2022 15:24:57 +0000
Date:   Thu, 25 Aug 2022 17:24:55 +0200
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Hao Luo <haoluo@google.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH bpf-next v9 1/5] bpf: Introduce cgroup iter
Message-ID: <20220825152455.GA29058@blackbody.suse.cz>
References: <20220824030031.1013441-1-haoluo@google.com>
 <20220824030031.1013441-2-haoluo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220824030031.1013441-2-haoluo@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On Tue, Aug 23, 2022 at 08:00:27PM -0700, Hao Luo <haoluo@google.com> wrote:
> +static int bpf_iter_attach_cgroup(struct bpf_prog *prog,
> +				  union bpf_iter_link_info *linfo,
> +				  struct bpf_iter_aux_info *aux)
> +{
> +	int fd = linfo->cgroup.cgroup_fd;
> +	u64 id = linfo->cgroup.cgroup_id;
> +	int order = linfo->cgroup.order;
> +	struct cgroup *cgrp;
> +
> +	if (order != BPF_ITER_DESCENDANTS_PRE &&
> +	    order != BPF_ITER_DESCENDANTS_POST &&
> +	    order != BPF_ITER_ANCESTORS_UP &&
> +	    order != BPF_ITER_SELF_ONLY)
> +		return -EINVAL;
> +
> +	if (fd && id)
> +		return -EINVAL;
> +
> +	if (fd)
> +		cgrp = cgroup_get_from_fd(fd);
> +	else if (id)
> +		cgrp = cgroup_get_from_id(id);
> +	else /* walk the entire hierarchy by default. */
> +		cgrp = cgroup_get_from_path("/");
> +
> +	if (IS_ERR(cgrp))
> +		return PTR_ERR(cgrp);

This section caught my eye.

Perhaps the simpler way for the default hierachy fallback would be

		cgrp = &cgrp_dfl_root.cgrp;
		cgroup_get(cgroup)

But maybe it's not what is the intention if cgroup NS should be taken
into account and cgroup_get_from_path() is buggy in this regard.

Would it make sense to prepend the patch below to your series?

Also, that makes me think about iter initialization with ID. In contrast
with FD passing (that's subject to some permissions and NS checks), the
retrieval via ID is not equipped with that, ids are not unguessable and
I'd consider cgroup IDs an implementation detail.

So, is the ID initialization that much useful? (I have no idea about
permissions model of BPF here, so it might be just fine but still it'd
be good to take cgroup NS into account. Likely for BPF_ITER_ANCESTORS_UP
too.)

HTH,
Michal

----8<----
From 1098e60e89d4d901b7eef04e531f2c889309a91b Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Date: Thu, 25 Aug 2022 15:19:04 +0200
Subject: [PATCH] cgroup: Honor caller's cgroup NS when resolving path
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

cgroup_get_from_path() is not widely used function. Its callers presume
the path is resolved under cgroup namespace. (There is one caller
currently and resolving in init NS won't make harm (netfilter). However,
future users may be subject to different effects when resolving
globally.)
Since, there's currently no use for the global resolution, modify the
existing function to take cgroup NS into account.

Fixes: a79a908fd2b0 ("cgroup: introduce cgroup namespaces")
Signed-off-by: Michal Koutný <mkoutny@suse.com>
---
 kernel/cgroup/cgroup.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index ffaccd6373f1..9280f4b41d8b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6603,8 +6603,12 @@ struct cgroup *cgroup_get_from_path(const char *path)
 {
 	struct kernfs_node *kn;
 	struct cgroup *cgrp = ERR_PTR(-ENOENT);
+	struct cgroup *root_cgrp;
 
-	kn = kernfs_walk_and_get(cgrp_dfl_root.cgrp.kn, path);
+	spin_lock_irq(&css_set_lock);
+	root_cgrp = current_cgns_cgroup_from_root(&cgrp_dfl_root);
+	kn = kernfs_walk_and_get(root_cgrp->kn, path);
+	spin_unlock_irq(&css_set_lock);
 	if (!kn)
 		goto out;
 

base-commit: 3cc40a443a04d52b0c95255dce264068b01e9bfe
-- 
2.37.0

