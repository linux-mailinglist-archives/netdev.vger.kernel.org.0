Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDEC711DD85
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 06:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731976AbfLMFQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 00:16:18 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40848 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfLMFQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 00:16:18 -0500
Received: by mail-lj1-f193.google.com with SMTP id s22so1202824ljs.7;
        Thu, 12 Dec 2019 21:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HtHQdkqH4Es+ZIp2yRzZr6MYlrLXYfg6ekbWUN18b2I=;
        b=dKY8h0JxXJUHhuimUVKzcifoLuMESUOhE3YvAPT8Ed5P2LVpjnb+wPesvekwYVMmWV
         lca2b8ADEDpVm1j+LeOZ85ut0u+mF5kg9HH373P6xW0ER/wgAMcP1nBoXykldHdkpNVs
         L/hVfZRvSsd/C+yFANp4lnHZM1DWlrg2m2xhgHcOfe+GtiGyCDmncFLAkta4uRtOoqXG
         j1zkrdQwjmMP7lcK7k5mrp/velI5fdsv+vni2NA24IwondxJkD3lDLHEehbXgR3V7Mac
         g5b/zU1kBwtJuhb4ANeK7drT7FZZGA2TT7LRDg0SmGbQTwL6sk2UVsfpFoz41tGrx2s4
         ZuqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HtHQdkqH4Es+ZIp2yRzZr6MYlrLXYfg6ekbWUN18b2I=;
        b=XG1RkbNZUskXWvRIOumOqPl9JKM5oxYE0+4AId96k324NYKcGe91iFfMXqBt/RXI8x
         TEILoWChx8/Pi54t18pl/t3xnuyNplJ8MmvEc8yQtQEhCLkTnwEtsN/fjn3s1njNGnS9
         hII8+rLUubFYg9DAobrMWr+qRdV3j1T8QUFW7Ff5bN7A0ffw80thvP8mboJlzfhdxklN
         SV8FW4ej4EYh1MEy5a7rmUcSPlIm6j7pSIWHOIhpd9fPMyQSMZTyf4JVx/JORyAfiBJ5
         IzGQYLzs0qEH3rVRVK6W23Btcd32nERzLLjRlpNLq4FEHzErEdyHkbCxx6FDC3sDttAA
         8rOA==
X-Gm-Message-State: APjAAAWixFd9mNKVNbLuo6SBsHm1DEPDtbv2FHg2R+mPIg8NLzsHOL6t
        /ga4y2Uh9Hkk6CsBkN5XIhKgn/S+yv+y2dzZoFtyWA==
X-Google-Smtp-Source: APXvYqyWRWJccgtT72Yhl/J/B/P0l3E36sc6NcKyV2MDZoPUaxbtjRI7VSdtxF23LHwJL/UQ7tlYfya4Xg4uhs7RWfk=
X-Received: by 2002:a2e:99cd:: with SMTP id l13mr8235977ljj.243.1576214175764;
 Thu, 12 Dec 2019 21:16:15 -0800 (PST)
MIME-Version: 1.0
References: <20191211223344.165549-1-brianvv@google.com>
In-Reply-To: <20191211223344.165549-1-brianvv@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 12 Dec 2019 21:16:04 -0800
Message-ID: <CAADnVQLh9Dz82YUMCR7P0sHed9W+bkcGXw098E3dwO5rHTmZ2g@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 00/11] add bpf batch ops to process more than
 1 elem
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Yonghong Song <yhs@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 2:34 PM Brian Vazquez <brianvv@google.com> wrote:
>
> This patch series introduce batch ops that can be added to bpf maps to
> lookup/lookup_and_delete/update/delete more than 1 element at the time,
> this is specially useful when syscall overhead is a problem and in case
> of hmap it will provide a reliable way of traversing them.
>
> The implementation inclues a generic approach that could potentially be
> used by any bpf map and adds it to arraymap, it also includes the specific
> implementation of hashmaps which are traversed using buckets instead
> of keys.
>
> The bpf syscall subcommands introduced are:
>
>   BPF_MAP_LOOKUP_BATCH
>   BPF_MAP_LOOKUP_AND_DELETE_BATCH
>   BPF_MAP_UPDATE_BATCH
>   BPF_MAP_DELETE_BATCH
>
> The UAPI attribute is:
>
>   struct { /* struct used by BPF_MAP_*_BATCH commands */
>          __aligned_u64   in_batch;       /* start batch,
>                                           * NULL to start from beginning
>                                           */
>          __aligned_u64   out_batch;      /* output: next start batch */
>          __aligned_u64   keys;
>          __aligned_u64   values;
>          __u32           count;          /* input/output:
>                                           * input: # of key/value
>                                           * elements
>                                           * output: # of filled elements
>                                           */
>          __u32           map_fd;
>          __u64           elem_flags;
>          __u64           flags;
>   } batch;
>
>
> in_batch and out_batch are only used for lookup and lookup_and_delete since
> those are the only two operations that attempt to traverse the map.
>
> update/delete batch ops should provide the keys/values that user wants
> to modify.
>
> Here are the previous discussions on the batch processing:
>  - https://lore.kernel.org/bpf/20190724165803.87470-1-brianvv@google.com/
>  - https://lore.kernel.org/bpf/20190829064502.2750303-1-yhs@fb.com/
>  - https://lore.kernel.org/bpf/20190906225434.3635421-1-yhs@fb.com/
>
> Changelog sinve v2:
>  - Add generic batch support for lpm_trie and test it (Yonghong Song)
>  - Use define MAP_LOOKUP_RETRIES for retries (John Fastabend)
>  - Return errors directly and remove labels (Yonghong Song)
>  - Insert new API functions into libbpf alphabetically (Yonghong Song)
>  - Change hlist_nulls_for_each_entry_rcu to
>    hlist_nulls_for_each_entry_safe in htab batch ops (Yonghong Song)

Yonghong,
please review.
