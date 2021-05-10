Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A930737B680
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 09:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhELHDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 03:03:24 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:50991 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbhELHDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 03:03:20 -0400
Received: by mail-pj1-f47.google.com with SMTP id t11so221460pjm.0;
        Wed, 12 May 2021 00:02:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gSnUBg5Kc1XHlv+8fvendFUvDmf5kAUkzWLVWnbVLKM=;
        b=Tjm0C+M+51nMV09BuRkR9bYrXiGsMMRqPi4n7C56YB3wNNr9RJ9uFCfqcNIlE/NFCk
         AJDbQD7UlDXDn3lmPqsGWxbqqll08p1qVKfroichx+/FflRucn/NPeoMqvr7kcsHFMC2
         FA4GP3n/5pChQcvV3ukrOZQfRuDJRfPiGPJQfyeIE+GNF5zgP+l4yWUuF3EjYsO8BvIt
         vPgwmYJ8eIDy0g3dMdMOb0uQXC9HAhqdU4iwyEqmZQCKrsHH/c1FERkaGcKSQegK1ZTp
         N53MN+KgoxVFBWiV1u6YdEP7TCRzTeSTwsqrMGJV6hEk+1y9gy19yYrGlfrBgK9/rTME
         DMvQ==
X-Gm-Message-State: AOAM530mtESmDRZ/gjMIxjTdThsBOSNFS0oVEua7zrOPG9595M1oLRCR
        IHUcBd2o/B1lSDleqoffawc=
X-Google-Smtp-Source: ABdhPJz2/s0P8B9U26WFOp0dGlPdk2cSJ9KBcRhVSITPD/VfI865XbGT8rqQV9eQBKW8zgZqZY41Lg==
X-Received: by 2002:a17:903:2403:b029:ee:eaf1:848d with SMTP id e3-20020a1709032403b02900eeeaf1848dmr33541409plo.63.1620802932222;
        Wed, 12 May 2021 00:02:12 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id v17sm15176699pfi.188.2021.05.12.00.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 00:02:04 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 340874240D; Mon, 10 May 2021 18:59:48 +0000 (UTC)
Date:   Mon, 10 May 2021 18:59:48 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     keescook@chromium.org, yzaikin@google.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v2] sysctl: Remove redundant assignment to first
Message-ID: <20210510185948.GW4332@42.do-not-panic.com>
References: <1620469990-22182-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1620469990-22182-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 06:33:10PM +0800, Jiapeng Chong wrote:
> Variable first is set to '0', but this value is never read as it is
> not used later on, hence it is a redundant assignment and can be
> removed.
> 
> Clean up the following clang-analyzer warning:
> 
> kernel/sysctl.c:1562:4: warning: Value stored to 'first' is never read
> [clang-analyzer-deadcode.DeadStores].
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

To re-iterate, this does not fix anything, it is just a clean up.

Acked-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis

> ---
> Changes in v2:
>   -For the follow advice: https://lore.kernel.org/patchwork/patch/1422497/
> 
>  kernel/sysctl.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 14edf84..23de0d9 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1474,7 +1474,6 @@ int proc_do_large_bitmap(struct ctl_table *table, int write,
>  			 void *buffer, size_t *lenp, loff_t *ppos)
>  {
>  	int err = 0;
> -	bool first = 1;
>  	size_t left = *lenp;
>  	unsigned long bitmap_len = table->maxlen;
>  	unsigned long *bitmap = *(unsigned long **) table->data;
> @@ -1559,12 +1558,12 @@ int proc_do_large_bitmap(struct ctl_table *table, int write,
>  			}
>  
>  			bitmap_set(tmp_bitmap, val_a, val_b - val_a + 1);
> -			first = 0;
>  			proc_skip_char(&p, &left, '\n');
>  		}
>  		left += skipped;
>  	} else {
>  		unsigned long bit_a, bit_b = 0;
> +		bool first = 1;
>  
>  		while (left) {
>  			bit_a = find_next_bit(bitmap, bitmap_len, bit_b);
> -- 
> 1.8.3.1
> 
