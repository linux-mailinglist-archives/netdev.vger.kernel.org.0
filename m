Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55C633835D
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 03:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhCLB4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 20:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhCLB43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 20:56:29 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D2FC061574;
        Thu, 11 Mar 2021 17:56:29 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id gb6so4390050pjb.0;
        Thu, 11 Mar 2021 17:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e6mF591+8uO6o2bcvBAUMVU5agtkiOkE5dzbKAt4K40=;
        b=XEUm26SbHiDxoDJspliIFg/AsgAKGc0iV0sVV6EDV8ORRcV7kfGoJXIYRgpDIM2/uv
         Mp1Kbn2qjThDAtCZ5+QOebp4YoYLxUnzhyQySiz29+WQ7mDwTTECJ+9PkLq3ZOzTsaMW
         K7i7FixhKs/IHKmPsk+Jximm9uRZX+KcH2OeBs34Y9zo5vehRcteGOdV4Ish5CMdI/go
         FfQy3c1d602nRE+SYV64dI0XM3nSxSYT+FCIYn5gmJCppBqeWd0vXR+oNd59ymqyPO1G
         awYAX9T+fXEgKvrQZGI7uAWcbGC8vsDR1MKLljoDyb63rDJKe+UX3+o7XYz6UckPvFsZ
         aKaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e6mF591+8uO6o2bcvBAUMVU5agtkiOkE5dzbKAt4K40=;
        b=hNmAbaZ5VVrbRs9xa5uidPd/3rM4ORyaClpv4j+YuCmPFqn/ACGFd/55ZwvgLelDNL
         Tu7FCkp2FCLVCg+03fZkgCOddEMQhbM6l/Sd5zyw51UUCrSPzPDkNHQN/gdokPzSo8V3
         pBvd2tfVbKvTEL/ruirV651oGA9WJ29mpCwYRu10sFm7p6h2WsfbSw6tLax+iUabdKpz
         W2O2RKFs4O3UAhHKgfNNIVPnB1gFpT9SkTgGkFxQ8WWn/oiY8gSKU/6kiRM7MkD41iEM
         sQ2T+F1qNRr49oQDxFDlt5XdWlZyoNPzJfiiBXUuDZb5j4/Vq0xxS9SootXg+EDFhBMj
         ci4Q==
X-Gm-Message-State: AOAM532qe32KDbweqPl5WgDHYPJI24H83Cn2ER8ITtG/mlBcA739Anzm
        PQsgfnZ4v0G/qRGDWBzspOdQohQ1/wc=
X-Google-Smtp-Source: ABdhPJxrriVwLjwbVq7NoC4m/kyrpNxYR1d/iztsnf2yqVh/z6J2geOFwiYOlYe9bMkQBZ3R8o6+YA==
X-Received: by 2002:a17:90b:903:: with SMTP id bo3mr12036273pjb.198.1615514188783;
        Thu, 11 Mar 2021 17:56:28 -0800 (PST)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mr5sm326691pjb.53.2021.03.11.17.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 17:56:28 -0800 (PST)
Date:   Fri, 12 Mar 2021 09:56:17 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yi-Hung Wei <yihung.wei@gmail.com>,
        David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>
Subject: Re: [PATCH net] selftests/bpf: set gopt opt_class to 0 if get tunnel
 opt failed
Message-ID: <20210312015617.GZ2900@Leo-laptop-t470s>
References: <20210309032214.2112438-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309032214.2112438-1-liuhangbin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

May I ask what's the status of this patch? From patchwork[1] the state is
accepted. But I can't find the fix on net or net-next.

[1] https://patchwork.kernel.org/project/netdevbpf/patch/20210309032214.2112438-1-liuhangbin@gmail.com/

Thanks
Hangbin
On Tue, Mar 09, 2021 at 11:22:14AM +0800, Hangbin Liu wrote:
> When fixing the bpf test_tunnel.sh genve failure. I only fixed
> the IPv4 part but forgot the IPv6 issue. Similar with the IPv4
> fixes 557c223b643a ("selftests/bpf: No need to drop the packet when
> there is no geneve opt"), when there is no tunnel option and
> bpf_skb_get_tunnel_opt() returns error, there is no need to drop the
> packets and break all geneve rx traffic. Just set opt_class to 0 and
> keep returning TC_ACT_OK at the end.
> 
> Fixes: 933a741e3b82 ("selftests/bpf: bpf tunnel test.")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/testing/selftests/bpf/progs/test_tunnel_kern.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
> index 9afe947cfae9..ba6eadfec565 100644
> --- a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
> +++ b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
> @@ -508,10 +508,8 @@ int _ip6geneve_get_tunnel(struct __sk_buff *skb)
>  	}
>  
>  	ret = bpf_skb_get_tunnel_opt(skb, &gopt, sizeof(gopt));
> -	if (ret < 0) {
> -		ERROR(ret);
> -		return TC_ACT_SHOT;
> -	}
> +	if (ret < 0)
> +		gopt.opt_class = 0;
>  
>  	bpf_trace_printk(fmt, sizeof(fmt),
>  			key.tunnel_id, key.remote_ipv4, gopt.opt_class);
> -- 
> 2.26.2
> 
