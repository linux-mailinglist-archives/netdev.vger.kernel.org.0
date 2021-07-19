Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253F53CF03E
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 01:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352389AbhGSXJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 19:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376744AbhGSWc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 18:32:58 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A138CC061797;
        Mon, 19 Jul 2021 16:11:52 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id b6so17530865iln.12;
        Mon, 19 Jul 2021 16:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=UInFx3lsKkpvv0erIEUaDzneQf280BDgbwg4LuWK5Zk=;
        b=lLB9Yldmy7KbqPY/COpnRBeMcw8tAx6dntzKr4rMQyki3XQqqliZfaxahyFe6FQYS+
         1pRh67/oyxfO64Wjq04bKaCky3pwuBE1xX5P6Iqd3EM52oCq+RYS7WNMBfH0zrno+IYt
         ee1xFS9333Hgfw4AbbzR4VPd8wrClUoIt4gblyxWuVBmFWF1XGrOvI7OM7cAX1D745lD
         pUkaYzStWyYbXbVNVkgZH7gUeUhLucp/iK8KZTP1wnrzRI5UMYBTcSeQAfCkypA3UGtV
         6F1yABRTN5GLbzZI1k1Gl7aFHTMk2o/y+j8f/98U3j4wjtHrJH9xD1OVQvzck+e07Ilu
         /WgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=UInFx3lsKkpvv0erIEUaDzneQf280BDgbwg4LuWK5Zk=;
        b=jfLCpXmrXhLOQOFLesHI0ah4Zur+9Xzn2YJMCIyWgltIvop0S+tVpx+ge1R/d3jpl9
         H+GoTzT+A0fMbps+8cczSJMr7OhnINFcJ/ZDTmnt20mUgfVkMChUbuAAStJKX7lpxi7z
         e/JkwCA49n0KXvCfIf4rzZSn7zk/lvevDkC8QKce6nMEnDTKM4L2MhUHQoxHBbkloDu5
         TAj4/2OmnXTwop8+HvPw6Quc05CfMVzekHrRIEPpknBMrxbVFq5KACo772BdoHnsCLpS
         cyGJ0MwZowlQyyBX3iXe4GuTwGG/4sEgKmv7tGfK0wvgmQwkTx0ERtGlaNjPnsehuY77
         flZg==
X-Gm-Message-State: AOAM532LkLhgIewbuhPjHgyLJJCO9esC9gUxZmkVxhkWrIv7SrJNMBwe
        qISffuGKfqE87d0E8e4ZPOE=
X-Google-Smtp-Source: ABdhPJxrqPifbHMteNN1GWXSaMfoXWJFNG8A9DR2VfDqX6Db+Mw2ZI+nLOb3+2gwOqSmvZDNizwNRg==
X-Received: by 2002:a05:6e02:c73:: with SMTP id f19mr18055464ilj.291.1626736312070;
        Mon, 19 Jul 2021 16:11:52 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id l5sm11245729ion.44.2021.07.19.16.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 16:11:51 -0700 (PDT)
Date:   Mon, 19 Jul 2021 16:11:43 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <60f606afc66a1_1e832208e7@john-XPS-13-9370.notmuch>
In-Reply-To: <20210719085134.43325-2-lmb@cloudflare.com>
References: <20210719085134.43325-1-lmb@cloudflare.com>
 <20210719085134.43325-2-lmb@cloudflare.com>
Subject: RE: [PATCH bpf v2 1/1] bpf: fix OOB read when printing XDP link
 fdinfo
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> We got the following UBSAN report on one of our testing machines:
> 
>     ================================================================================
>     UBSAN: array-index-out-of-bounds in kernel/bpf/syscall.c:2389:24
>     index 6 is out of range for type 'char *[6]'
>     CPU: 43 PID: 930921 Comm: systemd-coredum Tainted: G           O      5.10.48-cloudflare-kasan-2021.7.0 #1
>     Hardware name: <snip>
>     Call Trace:
>      dump_stack+0x7d/0xa3
>      ubsan_epilogue+0x5/0x40
>      __ubsan_handle_out_of_bounds.cold+0x43/0x48
>      ? seq_printf+0x17d/0x250
>      bpf_link_show_fdinfo+0x329/0x380
>      ? bpf_map_value_size+0xe0/0xe0
>      ? put_files_struct+0x20/0x2d0
>      ? __kasan_kmalloc.constprop.0+0xc2/0xd0
>      seq_show+0x3f7/0x540
>      seq_read_iter+0x3f8/0x1040
>      seq_read+0x329/0x500
>      ? seq_read_iter+0x1040/0x1040
>      ? __fsnotify_parent+0x80/0x820
>      ? __fsnotify_update_child_dentry_flags+0x380/0x380
>      vfs_read+0x123/0x460
>      ksys_read+0xed/0x1c0
>      ? __x64_sys_pwrite64+0x1f0/0x1f0
>      do_syscall_64+0x33/0x40
>      entry_SYSCALL_64_after_hwframe+0x44/0xa9
>     <snip>
>     ================================================================================
>     ================================================================================
>     UBSAN: object-size-mismatch in kernel/bpf/syscall.c:2384:2
> 
> From the report, we can infer that some array access in bpf_link_show_fdinfo at index 6
> is out of bounds. The obvious candidate is bpf_link_type_strs[BPF_LINK_TYPE_XDP] with
> BPF_LINK_TYPE_XDP == 6. It turns out that BPF_LINK_TYPE_XDP is missing from bpf_types.h
> and therefore doesn't have an entry in bpf_link_type_strs:
> 
>     pos:	0
>     flags:	02000000
>     mnt_id:	13
>     link_type:	(null)
>     link_id:	4
>     prog_tag:	bcf7977d3b93787c
>     prog_id:	4
>     ifindex:	1
> 
> Fixes: aa8d3a716b59 ("bpf, xdp: Add bpf_link-based XDP attachment API")
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  include/linux/bpf_types.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> index a9db1eae6796..ae3ac3a2018c 100644
> --- a/include/linux/bpf_types.h
> +++ b/include/linux/bpf_types.h
> @@ -134,4 +134,5 @@ BPF_LINK_TYPE(BPF_LINK_TYPE_CGROUP, cgroup)
>  BPF_LINK_TYPE(BPF_LINK_TYPE_ITER, iter)
>  #ifdef CONFIG_NET
>  BPF_LINK_TYPE(BPF_LINK_TYPE_NETNS, netns)
> +BPF_LINK_TYPE(BPF_LINK_TYPE_XDP, xdp)
>  #endif
> -- 
> 2.30.2
> 

Still lgtm.

Acked-by; John Fastabend <john.fastabend@gmail.com>
