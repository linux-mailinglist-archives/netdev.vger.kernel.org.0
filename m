Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB8922BD5B
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 07:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgGXFMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 01:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgGXFMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 01:12:02 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B8EC0619D3;
        Thu, 23 Jul 2020 22:12:02 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id mn17so4606048pjb.4;
        Thu, 23 Jul 2020 22:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=53iCg0K8sIicCs0Rtdo5gg3EGRpc3SDPj593SVXw0tU=;
        b=JI7g0y2ohQ2BVxLmA6Twv+EQJ4y1gEEZ2pn8FxaBgc3uYj9tWIebKxmpv57LPdL/Sj
         w1HWSJ5bmElOrqkN5lALaGQXVeX5N//wX+jHXeNPS2c1SG9z+1etb+wgAEqGU2Lf8jyZ
         8fm8195JtJ+wrQ6ftdJMOwk8evEu5M7ClwQgxLi0+tSQi327rGV/TBkvXoLv6VwdYRyr
         rqlBSX7aCobkR8eZYlp8x9ZIbnxeVSe8a9iz93isWvOljhbamBhmqM/UBzZRenSqr5i8
         s3psUFIqFE+0vTYKVfKL2RqIsjtHps3p/6p+jR4X5RtEw5P+kmL8ZWe+XS2LQeuXBKt3
         HN3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=53iCg0K8sIicCs0Rtdo5gg3EGRpc3SDPj593SVXw0tU=;
        b=pg/ze2/7JRg2USqRE3SpIfT+svfkqzaDUaWkH1ixAJvYLhPOJQz3WkCNwW7MNaP73g
         O5ABeRP64B/03LJ2MAeD6iuZ4AV/1WK3N/Nkce6inEJWrLnGf4O8P6OUKO2Jf2d9AM9T
         noQYcD+sNuhi1FweuII99a4/A1xUq/NYpv/AVOrckoNynPxQg2R0PV/TDVdYw3GoKJYW
         vfdWs5IIN70L5pps+Q9c37UfiG0UIGkqV1lvN87dRqjnvwBoRvyUCcC/VftI2HWMy2oo
         XVfyozT96zyHyrzLoMiRdX6qoqXlROYwdmVuKwxusv3wvvgZtKUfA9HVVeyfbk2a5gWZ
         dB3w==
X-Gm-Message-State: AOAM5303qHnnBP9diHRj9ac+oLFldKrNfEf05AK7NAc5OVt6/kaq6ZxN
        A8hY80OVZ7TknVqGZe9EOAX3qcNn
X-Google-Smtp-Source: ABdhPJzfctU7l4JJfp4ReWyfN3A/OEwPZzXJHv18364102+hnpVLSz6YdNAZmBtmknR8nCYP/STQEQ==
X-Received: by 2002:a17:90a:9285:: with SMTP id n5mr3400061pjo.27.1595567522354;
        Thu, 23 Jul 2020 22:12:02 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:dfa8])
        by smtp.gmail.com with ESMTPSA id o14sm4621512pjj.42.2020.07.23.22.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 22:12:01 -0700 (PDT)
Date:   Thu, 23 Jul 2020 22:11:59 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v4 00/13] bpf: implement bpf iterator for map
 elements
Message-ID: <20200724051159.xyuunt2xbskgxpsg@ast-mbp.dhcp.thefacebook.com>
References: <20200723184108.589857-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723184108.589857-1-yhs@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 11:41:08AM -0700, Yonghong Song wrote:
> Bpf iterator has been implemented for task, task_file,
> bpf_map, ipv6_route, netlink, tcp and udp so far.
> 
> For map elements, there are two ways to traverse all elements from
> user space:
>   1. using BPF_MAP_GET_NEXT_KEY bpf subcommand to get elements
>      one by one.
>   2. using BPF_MAP_LOOKUP_BATCH bpf subcommand to get a batch of
>      elements.
> Both these approaches need to copy data from kernel to user space
> in order to do inspection.
> 
> This patch implements bpf iterator for map elements.
> User can have a bpf program in kernel to run with each map element,
> do checking, filtering, aggregation, modifying values etc.
> without copying data to user space.
> 
> Patch #1 and #2 are refactoring. Patch #3 implements readonly/readwrite
> buffer support in verifier. Patches #4 - #7 implements map element
> support for hash, percpu hash, lru hash lru percpu hash, array,
> percpu array and sock local storage maps. Patches #8 - #9 are libbpf
> and bpftool support. Patches #10 - #13 are selftests for implemented
> map element iterators.
> 
> Changelogs:
>   v3 -> v4:
>     . fix a kasan failure triggered by a failed bpf_iter link_create,
>       not just free_link but need cleanup_link. (Alexei)

Applied, Thanks
