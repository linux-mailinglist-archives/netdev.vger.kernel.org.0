Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBE33051E2
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 06:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbhA0FTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 00:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbhA0FKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 00:10:25 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D2AC06174A;
        Tue, 26 Jan 2021 21:09:45 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id e9so391299plh.3;
        Tue, 26 Jan 2021 21:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RmgqS7WyjiiRJi9z89KhXde85FYcLyN/Zij0A6xH6Vg=;
        b=RnKa9K+3TRouGov1X7r8uImWnhCFlAivPGcaKhDgCwaW+BlBYVStKd9X2c+ERdkCqs
         DiNwcROLJFNuIruXq4aredzwhJEi/BK9aj9OAhe6veI7SNgaZIZNEQ1y7X4x8cPyHy7T
         gz7nlEbdjXWfKHoRY7QNvcRyBf3mVH98dVF0VZpmlVl02W75rF5JOgy7upQkDB7+R4qd
         zUsrceiyKSUv/U0vWD/9JABS9rUe31D/KC/uuxiclIrBkDyv+3Hd4VK5lOzi7cllAWul
         zC7aR11dEAU8YkrSeP7ml4XWuETVDBjyx9KQuZ8m83GGCr7BlqSEY3rOdvSA6f1tilq7
         Tf/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RmgqS7WyjiiRJi9z89KhXde85FYcLyN/Zij0A6xH6Vg=;
        b=oTvBDzOzRbQoNglVh+dhoB+9+Nmsut+3ArGgvDD8j62d7G/aYxZ3RbwxoPvBL9UEuT
         Ecs3Xri1GHhANUQ4KyndczwP3RK3U3HmDsX0zQDOyT4CtCDsSdoJPCKILxNXzstT/qdl
         v4U4J647tfpBEETXYBI2bX4Rl5HxOxDBNbg/TeXMtuqZHUaE+i8ml9ndbS7Sw6Sy4qVn
         Sv5Sep3qAVcpeH0sLK5pqkCUCgsdIt4uty4va5lvrrs7EpUlP355JS1E3Uo3iiiaG+Qy
         8P771bUoGX3ETwEe/Q263X5tGBiirS9i6UZu+/aXdqs2gixjvYuMpcmoQyoJ12olTUVz
         TwrQ==
X-Gm-Message-State: AOAM531BuWanll6E80sv+4MhO1uI2ZJJY5DQdeqbxxjOfVR6/XS+/KHJ
        A6emeGANbIdV5dm2ko+3hio=
X-Google-Smtp-Source: ABdhPJz04w59ZhpuFPQyD2C3hPv7JH0+LDqS9Kp6T3W3gIrrQ023rry8zfPBH2RwQVWwj2TsOAfQBw==
X-Received: by 2002:a17:90b:4c8e:: with SMTP id my14mr3637771pjb.30.1611724185071;
        Tue, 26 Jan 2021 21:09:45 -0800 (PST)
Received: from ubuntu ([1.53.255.147])
        by smtp.gmail.com with ESMTPSA id t129sm746515pfc.16.2021.01.26.21.09.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Jan 2021 21:09:44 -0800 (PST)
Date:   Wed, 27 Jan 2021 12:09:37 +0700
From:   Bui Quang Minh <minhquangbui99@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, hawk@kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        kpsingh@kernel.org, Jakub Sitnicki <jakub@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bpf: Fix integer overflow in argument calculation for
 bpf_map_area_alloc
Message-ID: <20210127050937.GA5418@ubuntu>
References: <20210126082606.3183-1-minhquangbui99@gmail.com>
 <CACAyw99bEYWJCSGqfLiJ9Jp5YE1ZsZSiJxb4RFUTwbofipf0dA@mail.gmail.com>
 <20210127042341.GA4948@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127042341.GA4948@ubuntu>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 11:23:41AM +0700, Bui Quang Minh wrote:
> > * Seems like there are quite a few similar calls scattered around
> > (cpumap, etc.). Did you audit these as well?
> 
> I spotted another bug after re-auditting. In hashtab, there ares 2 places using
> the same calls
> 
> 	static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
> 	{
> 		/* ... snip ... */
> 		if (htab->n_buckets == 0 ||
> 		    htab->n_buckets > U32_MAX / sizeof(struct bucket))
> 			goto free_htab;
> 
> 		htab->buckets = bpf_map_area_alloc(htab->n_buckets *
> 						   sizeof(struct bucket),
> 						   htab->map.numa_node);
> 	}
> 
> This is safe because of the above check.
> 
> 	static int prealloc_init(struct bpf_htab *htab)
> 	{
> 		u32 num_entries = htab->map.max_entries;
> 		htab->elems = bpf_map_area_alloc(htab->elem_size * num_entries,
> 						 htab->map.numa_node);
> 	}
> 
> This is not safe since there is no limit check in elem_size.

So sorry but I rechecked and saw this bug in hashtab has been fixed with commit
e1868b9e36d0ca

Thank you,
Quang Minh.
