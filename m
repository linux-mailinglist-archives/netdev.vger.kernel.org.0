Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83FF01080C5
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 22:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfKWVQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 16:16:47 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34183 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfKWVQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 16:16:47 -0500
Received: by mail-pg1-f196.google.com with SMTP id z188so5158254pgb.1;
        Sat, 23 Nov 2019 13:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nBx2NoBcf+o5bPvfyMSkU/evbRdKXupwy+9ztGhN6xo=;
        b=SbEb6szM1tbsq0JhJ60IMVUXvBJjB2Lepe+ja6G8tYkl5Vggb9NWOt2XlZRr42xgn4
         f6VRNW5rfWZvc1v5OkQmMMbL96Hvkor/XzqVXxiVi15JO1QyTk9PvQ8KDPr4Lkdm3LFr
         tT+ZLmXz0TX89Grh3kvKGoXDZLVokUDPrGj5z2Rshk8TPH1A2PcmtXGyfdNfKlCT6t6R
         fDykBzC3VJfx5c04txCATkYrnsmJACBYyii6v69QQ64rPa1lUhnwg1V9khL7ixLhtzU5
         G5QNr3VHHKzhNVkyjgX4ZuGf1CZnjgD9jDXtxFFvziM0o3sCXZT8upy9yyabq8ye6ygN
         YPqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nBx2NoBcf+o5bPvfyMSkU/evbRdKXupwy+9ztGhN6xo=;
        b=VTtdhxsCE3VggaexsVJZTNPYnYj7EaevGy7UhFrRDFFojzpjqvCt769M8h0sJgyQrD
         zSNk0KB/j8UsRpQS5+Pm4zpwGx2YYAv6YAtaoPiKADm1P5m7/9Z+PWkfwlP6uRD77IWP
         mlFPDBV0DHcjPWFa2AFFwlsWrdWlo9azDl5vaywY89UdCIyhncvwM8uoDCj3wVCf85CU
         GDMCkDEd9LANnYkYQQvC9Cy3NMU6zXEsXTtP38sx2mBbGyWQDMoXkm8ucdzcSSanDkWX
         0jX2wJz2d/Puwpldu4E9uUx+IBxA+W0DnFpJPCnFr4fTLIG9IPXz7g1ygr0uAOzIDc4a
         wZtg==
X-Gm-Message-State: APjAAAWN6QgGgeLjzA5LKonsJZrbwV0Q36v3pcD3we5eW1vWUZpUMKFC
        UYnLZE1diot2dAxA0dq+xJM=
X-Google-Smtp-Source: APXvYqyI8Tdq+4LpO40+3hem3YrtEZvGa3xEo/QBH9V2GRpN2shVWGib+8JgiRpKhmNiLQTumpA73g==
X-Received: by 2002:a62:444:: with SMTP id 65mr6630811pfe.67.1574543806232;
        Sat, 23 Nov 2019 13:16:46 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::ce40])
        by smtp.gmail.com with ESMTPSA id k13sm2885059pgl.69.2019.11.23.13.16.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 13:16:45 -0800 (PST)
Date:   Sat, 23 Nov 2019 13:16:43 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next] bpf: fail mmap without CONFIG_MMU
Message-ID: <20191123211642.3hctmxb7ya3s3k3y@ast-mbp.dhcp.thefacebook.com>
References: <20191123205628.828920-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191123205628.828920-1-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 23, 2019 at 12:56:28PM -0800, Andrii Nakryiko wrote:
> mmap() support for BPF array depends on vmalloc_user_node_flags, which is
> available only on CONFIG_MMU configurations. Fail mmap-able allocations if no
> CONFIG_MMU is set.
> 
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  kernel/bpf/syscall.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index bb002f15b32a..242a06fbdf18 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -156,8 +156,12 @@ static void *__bpf_map_area_alloc(u64 size, int numa_node, bool mmapable)
>  	}
>  	if (mmapable) {
>  		BUG_ON(!PAGE_ALIGNED(size));
> +#ifndef CONFIG_MMU
> +		return NULL;
> +#else
>  		return vmalloc_user_node_flags(size, numa_node, GFP_KERNEL |
>  					       __GFP_RETRY_MAYFAIL | flags);
> +#endif

Typically such ifdef goes into .h. There are several examples of such
!CONFIG_MMU in vmalloc.h. May be move it there?

