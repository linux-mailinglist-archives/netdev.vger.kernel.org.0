Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE1ED198A2D
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 04:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbgCaCyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 22:54:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45860 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729567AbgCaCyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 22:54:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1214A15D15827;
        Mon, 30 Mar 2020 19:54:02 -0700 (PDT)
Date:   Mon, 30 Mar 2020 19:54:00 -0700 (PDT)
Message-Id: <20200330.195400.784625163425445502.davem@davemloft.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: pull-request: bpf-next 2020-03-30
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200331012815.3258314-1-ast@kernel.org>
References: <20200331012815.3258314-1-ast@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 19:54:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>
Date: Mon, 30 Mar 2020 18:28:15 -0700

> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 73 non-merge commits during the last 14 day(s) which contain
> a total of 107 files changed, 6086 insertions(+), 1728 deletions(-).
> 
> The main changes are:
 ...
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Pulled, there was a minor merge conflict in the cgroup changes, which I
resolved like this:

@@@ -305,10 -418,9 +421,9 @@@ int __cgroup_bpf_attach(struct cgroup *
        u32 saved_flags = (flags & (BPF_F_ALLOW_OVERRIDE | BPF_F_ALLOW_MULTI));
        struct list_head *progs = &cgrp->bpf.progs[type];
        struct bpf_prog *old_prog = NULL;
 -      struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE],
 -              *old_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {NULL};
 +      struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
 +      struct bpf_cgroup_storage *old_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
-       struct bpf_prog_list *pl, *replace_pl = NULL;
-       enum bpf_cgroup_storage_type stype;
+       struct bpf_prog_list *pl;
