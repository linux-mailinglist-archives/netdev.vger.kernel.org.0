Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51F1CA2634
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfH2SkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:40:01 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41977 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727935AbfH2SkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 14:40:01 -0400
Received: by mail-ed1-f67.google.com with SMTP id w5so5110572edl.8
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 11:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=NwKudhIxtj7Zray+wZNixIal8r/E1MBsJakZSiC7ZTc=;
        b=v/NaBC5Xt8P+CLQ4BZkAsyYKMQXFOmakGD4Bga2JMs7xxedO5kn79mbMsulgFgtSWw
         ezKGOEUHSoREk7zGi9W0OmZ37O1PMWJhKZd7/p5dPV7taV70BZMNVzYOQYC7i5XulYqt
         0qQbs0bvT5QLUkC+vqzYY7KWGBPSBRrYUsBdw7ZlSjTtqsTAQ9qnfHvhtm+MgRbUq9sB
         m+GdO3IsCk33bQK/n3ziFY86/JWTz6AtKUse9d5LnxTJaSD5VE2ADtp8tafKtFb/4PD8
         i3dh5uNCwoI+vGb7nY8TxYf8dwW0FfCyRT7ZcwMTFSm8zz7ZRPmb2WbcVf7ediEQkmpC
         PNyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=NwKudhIxtj7Zray+wZNixIal8r/E1MBsJakZSiC7ZTc=;
        b=qeVU6Z7zEXBANb+eoi7+XZBYNooghHQEFWeqtqonz+dKUrAlmrEtFtx21sc4zkIM9s
         qF3FdEkCTAyRqkSq6YJhD0itdiLnseXezMaC4LzCYA6tJI6V2qpjJKHIdzbQYefT9f86
         lovBdgkBMEF35zN8CkBlqfMC87k6FgE2XHUyaEjlQZtnHBYU1Cs82My9/yKaMz8MC6+0
         sZ62J9hYSB9RPQexombn32j577f/qbf08WuRlrnG++e4Y36KRIW5rFATPcrjikWOs1sO
         qd0parf8XCFsy0zDqrkQe6QE66S+U2V4qHCjZzqN640Pk29LvxAuZ71gtlS/Q7zhCcoQ
         Kmlg==
X-Gm-Message-State: APjAAAUKPzKZk3X340Tj5bowK1Oh4AlWKmvpxbYhnN8zKPZczcmMZXt4
        w1uNAnxzhIH8bK6ZOY01qMbxLw==
X-Google-Smtp-Source: APXvYqyL5xnRLCKRu6cFiByK3nr4mrPT573BNbnKOgFvQNv6xlZvF+QAOVykOPyprcT8089s/fwBiQ==
X-Received: by 2002:a17:906:938a:: with SMTP id l10mr9716391ejx.232.1567103998665;
        Thu, 29 Aug 2019 11:39:58 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g20sm576484edp.92.2019.08.29.11.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 11:39:58 -0700 (PDT)
Date:   Thu, 29 Aug 2019 11:39:32 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@fb.com>
Cc:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 00/13] bpf: adding map batch processing support
Message-ID: <20190829113932.5c058194@cakuba.netronome.com>
In-Reply-To: <20190829064502.2750303-1-yhs@fb.com>
References: <20190829064502.2750303-1-yhs@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Aug 2019 23:45:02 -0700, Yonghong Song wrote:
> Brian Vazquez has proposed BPF_MAP_DUMP command to look up more than one
> map entries per syscall.
>   https://lore.kernel.org/bpf/CABCgpaU3xxX6CMMxD+1knApivtc2jLBHysDXw-0E9bQEL0qC3A@mail.gmail.com/T/#t
> 
> During discussion, we found more use cases can be supported in a similar
> map operation batching framework. For example, batched map lookup and delete,
> which can be really helpful for bcc.
>   https://github.com/iovisor/bcc/blob/master/tools/tcptop.py#L233-L243
>   https://github.com/iovisor/bcc/blob/master/tools/slabratetop.py#L129-L138
>     
> Also, in bcc, we have API to delete all entries in a map.
>   https://github.com/iovisor/bcc/blob/master/src/cc/api/BPFTable.h#L257-L264
> 
> For map update, batched operations also useful as sometimes applications need
> to populate initial maps with more than one entry. For example, the below
> example is from kernel/samples/bpf/xdp_redirect_cpu_user.c:
>   https://github.com/torvalds/linux/blob/master/samples/bpf/xdp_redirect_cpu_user.c#L543-L550
> 
> This patch addresses all the above use cases. To make uapi stable, it also
> covers other potential use cases. Four bpf syscall subcommands are introduced:
>     BPF_MAP_LOOKUP_BATCH
>     BPF_MAP_LOOKUP_AND_DELETE_BATCH
>     BPF_MAP_UPDATE_BATCH
>     BPF_MAP_DELETE_BATCH
> 
> In userspace, application can iterate through the whole map one batch
> as a time, e.g., bpf_map_lookup_batch() in the below:
>     p_key = NULL;
>     p_next_key = &key;
>     while (true) {
>        err = bpf_map_lookup_batch(fd, p_key, &p_next_key, keys, values,
>                                   &batch_size, elem_flags, flags);
>        if (err) ...
>        if (p_next_key) break; // done
>        if (!p_key) p_key = p_next_key;
>     }
> Please look at individual patches for details of new syscall subcommands
> and examples of user codes.
> 
> The testing is also done in a qemu VM environment:
>       measure_lookup: max_entries 1000000, batch 10, time 342ms
>       measure_lookup: max_entries 1000000, batch 1000, time 295ms
>       measure_lookup: max_entries 1000000, batch 1000000, time 270ms
>       measure_lookup: max_entries 1000000, no batching, time 1346ms
>       measure_lookup_delete: max_entries 1000000, batch 10, time 433ms
>       measure_lookup_delete: max_entries 1000000, batch 1000, time 363ms
>       measure_lookup_delete: max_entries 1000000, batch 1000000, time 357ms
>       measure_lookup_delete: max_entries 1000000, not batch, time 1894ms
>       measure_delete: max_entries 1000000, batch, time 220ms
>       measure_delete: max_entries 1000000, not batch, time 1289ms
> For a 1M entry hash table, batch size of 10 can reduce cpu time
> by 70%. Please see patch "tools/bpf: measure map batching perf"
> for details of test codes.

Hi Yonghong!

great to see this, we have been looking at implementing some way to
speed up map walks as well.

The direction we were looking in, after previous discussions [1],
however, was to provide a BPF program which can run the logic entirely
within the kernel.

We have a rough PoC on the FW side (we can offload the program which
walks the map, which is pretty neat), but the kernel verifier side
hasn't really progressed. It will soon.

The rough idea is that the user space provides two programs, "filter"
and "dumper":

	bpftool map exec id XYZ filter pinned /some/prog \
				dumper pinned /some/other_prog

Both programs get this context:

struct map_op_ctx {
	u64 key;
	u64 value;
}

We need a per-map implementation of the exec side, but roughly maps
would do:

	LIST_HEAD(deleted);

	for entry in map {
		struct map_op_ctx {
			.key	= entry->key,
			.value	= entry->value,
		};

		act = BPF_PROG_RUN(filter, &map_op_ctx);
		if (act & ~ACT_BITS)
			return -EINVAL;

		if (act & DELETE) {
			map_unlink(entry);
			list_add(entry, &deleted);
		}
		if (act & STOP)
			break;
	}

	synchronize_rcu();

	for entry in deleted {
		struct map_op_ctx {
			.key	= entry->key,
			.value	= entry->value,
		};
		
		BPF_PROG_RUN(dumper, &map_op_ctx);
		map_free(entry);
	}

The filter program can't perform any map operations other than lookup,
otherwise we won't be able to guarantee that we'll walk the entire map
(if the filter program deletes some entries in a unfortunate order).

If user space just wants a pure dump it can simply load a program which
dumps the entries into a perf ring.

I'm bringing this up because that mechanism should cover what is
achieved with this patch set and much more. 

In particular for networking workloads where old flows have to be
pruned from the map periodically it's far more efficient to communicate
to user space only the flows which timed out (the delete batching from
this set won't help at all).

With a 2M entry map and this patch set we still won't be able to prune
once a second on one core.

[1]
https://lore.kernel.org/netdev/20190813130921.10704-4-quentin.monnet@netronome.com/
