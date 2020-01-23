Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF2E146F67
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 18:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgAWRSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 12:18:10 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38293 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbgAWRSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 12:18:10 -0500
Received: by mail-pf1-f193.google.com with SMTP id x185so1837218pfc.5;
        Thu, 23 Jan 2020 09:18:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=J1JTF63Y6CzMxj8f1LiDzyUrvtnW4rRNEJCmiTqTTc0=;
        b=UDgwVBzZnhcvQaZx0mH//TdPlf3Gt4jyCzwd+rkzyX903/m4za7IhsqXAAQsQI3EBE
         THeC36+wxa5si4l/zbzlCngfI1/v/lXgk45ujsDWmJ3e9D2V+Y7mnHJ3YDEDWal64BF8
         Uk0folij7LXBqGQ//PcYaX7bVLorg82w9p5jXg4+xi7ykcDAH089kK/vBzB5oys/KdCY
         9Sp9iZByzaGLsfLlOROKHuM7lfcHaFzuh4SRY+O3hPYvE3IYjMfzoQkO5F6XMN7y4S8C
         CCZuAp6yS/bc3hM7Qq1oNI/aN2fn079sAhVOcRzOrIAeIYYW2Dp5tq8Mh8bdR8srVQr9
         NodQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=J1JTF63Y6CzMxj8f1LiDzyUrvtnW4rRNEJCmiTqTTc0=;
        b=cGkCIFwOaV+waL8H5SuUO08heyP+qU0y8lThtcwf0r+4ZRqIu7ePhNy/ruA1/Wvktf
         kCgf8MijngkIoKyhwqhMMWYWCtg5CPMgQ3893h0B3rHpJ5PFkO8ukxdrxVfhBwR+4vHz
         C8ipAi5ujxuvgYN9PwT+GQ0dvSVbH4esxIm3FMZ4/tw3m7n/cGcHKdom0ejcgH4jK6Nb
         kAQIt56GM3nK3DvmRZixlM2ZSEuQ2k6PBG1ehg+pmcB0DKu2CgXZYOj4dPM7e0rTMjIA
         X1GOY7OWmdWSkzwdPJLoXPhDOyDUXwqajDTCtGgxHw9HMs0j6vKPZuIUuRapuM90lmSa
         Oi5Q==
X-Gm-Message-State: APjAAAUHMbzcvjFL+lIWhNGAgxAhe960wASFY7Ni37pABPlqszwxEmcq
        b3zw7sRdL2jM4ZLi3m9e3Tc=
X-Google-Smtp-Source: APXvYqz7qTAcmw9UEgNAfy3malI6VgsOZj09ScBH7BYVJLdSqEWfjSTC8UICf4Yfm6wS7weR9FOztg==
X-Received: by 2002:a63:950c:: with SMTP id p12mr5161358pgd.85.1579799889566;
        Thu, 23 Jan 2020 09:18:09 -0800 (PST)
Received: from workstation-portable ([103.211.17.138])
        by smtp.gmail.com with ESMTPSA id j9sm3338554pfn.152.2020.01.23.09.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 09:18:09 -0800 (PST)
Date:   Thu, 23 Jan 2020 22:48:00 +0530
From:   Amol Grover <frextrite@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, brouer@redhat.com,
        toke@redhat.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH] bpf: devmap: Pass lockdep expression to RCU lists
Message-ID: <20200123171800.GC4484@workstation-portable>
References: <20200123120437.26506-1-frextrite@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123120437.26506-1-frextrite@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 05:34:38PM +0530, Amol Grover wrote:
> head is traversed using hlist_for_each_entry_rcu outside an
> RCU read-side critical section but under the protection
> of dtab->index_lock.
> 
> Hence, add corresponding lockdep expression to silence false-positive
> lockdep warnings, and harden RCU lists.
> 
Fixes: 6f9d451ab1a3 ("xdp: Add devmap_hash map type for looking up devices by hashed index")
> Signed-off-by: Amol Grover <frextrite@gmail.com>
> ---
>  kernel/bpf/devmap.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 3d3d61b5985b..b4b6b77f309c 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -293,7 +293,8 @@ struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key)
>  	struct hlist_head *head = dev_map_index_hash(dtab, key);
>  	struct bpf_dtab_netdev *dev;
>  
> -	hlist_for_each_entry_rcu(dev, head, index_hlist)
> +	hlist_for_each_entry_rcu(dev, head, index_hlist,
> +				 lockdep_is_held(&dtab->index_lock))
>  		if (dev->idx == key)
>  			return dev;
>  
> -- 
> 2.24.1
> 
