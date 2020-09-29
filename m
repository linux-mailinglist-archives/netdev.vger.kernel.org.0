Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2134827B8D8
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 02:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgI2AWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 20:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgI2AWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 20:22:33 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48957C061755;
        Mon, 28 Sep 2020 17:22:32 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x22so2769424pfo.12;
        Mon, 28 Sep 2020 17:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=7LTDco49vmsu1vhrhFrIN7sKCOuF++In9rJZLhZDYew=;
        b=JvvMcGn0LmwB8yQ/VEeRIdEDyOJOcR2CUlDFIiQk0bZq3zZL6AGJ7WBII+lII/M4YX
         Yb8RdvN9FGbKITNMO0xbw6b+Xiu1KuFI1lj/s4TKk4aannzG1suQxxTk5WyRh58K2zpT
         pHeQ9xp6o4+Q3tq+39FHvt3nZm+8IM1SCXJhlbypZv6+HLtKaplxtCIKP4lo2RlvWWLE
         F6HqJlTmaaI6V69yLGKo/rbHGT1CdKdTbLDmP7eg+ztisvyJgW/JXPgzMijbcOXjnjhJ
         7E3P97/RHMhCjQHDJRo4vh3kFIWgeCZ7Ghv4dO62DBlmsBjTjAaUlTnywiAsAOBZC+Nu
         t+Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=7LTDco49vmsu1vhrhFrIN7sKCOuF++In9rJZLhZDYew=;
        b=giRsLnYVmr+Mi4g9APs6OhfdaS54tmjJenJzqbtEZSm1znf1QLifziMPWq8ZM2HMox
         Kxjgj/dUtAiqKwG2ylE60C5aThjgSL6+YYItVP5MWqaMth339nPITT1P8AmrtsNlW7pL
         pDaUkO/g4cmkrt0NxJ/yfLi5GXom2H1d7S1KXB4doM6BCEnIPrO86mCgVcFtdXb8zb9D
         ZYfx9JKRZ9xc9BizdLOzJjrBB41OlDvBYhANshoF1pBnBAj+ZT5O9tE+T27lRXWPzcd3
         5d0i2eT/VM218ktzs5bvTuruid+48Ji4X8JNHzi5+6YL3qK9LdaDjLPb2t1Y4YyPeP3X
         wn5Q==
X-Gm-Message-State: AOAM530E002MZY8ugxDdv4djo8G7Xu7nAp2QRKwX8UmcWJhW5I3B2fqS
        iVSdGq+A8BgXWc0eWZqzpCI=
X-Google-Smtp-Source: ABdhPJzc1LJ79OJPe5snIk8P59nSI9vZ7x6ukUdzDNjjVByZvsYJuEmh7LQHBlywr6Y98nXkEOs9zg==
X-Received: by 2002:a63:6306:: with SMTP id x6mr1248832pgb.161.1601338951782;
        Mon, 28 Sep 2020 17:22:31 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8e77])
        by smtp.gmail.com with ESMTPSA id y7sm2404549pgk.73.2020.09.28.17.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 17:22:30 -0700 (PDT)
Date:   Mon, 28 Sep 2020 17:22:28 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v9 11/11] selftests: Remove fmod_ret from
 test_overhead
Message-ID: <20200929002228.5c72zt7vrdv3ognx@ast-mbp.dhcp.thefacebook.com>
References: <160106909952.27725.8383447127582216829.stgit@toke.dk>
 <160106911110.27725.7635772141267776622.stgit@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <160106911110.27725.7635772141267776622.stgit@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 11:25:11PM +0200, Toke Høiland-Jørgensen wrote:
> diff --git a/tools/testing/selftests/bpf/progs/test_overhead.c b/tools/testing/selftests/bpf/progs/test_overhead.c
> index 42403d088abc..abb7344b531f 100644
> --- a/tools/testing/selftests/bpf/progs/test_overhead.c
> +++ b/tools/testing/selftests/bpf/progs/test_overhead.c
> @@ -39,10 +39,4 @@ int BPF_PROG(prog5, struct task_struct *tsk, const char *buf, bool exec)
>  	return 0;
>  }
>  
> -SEC("fmod_ret/__set_task_comm")
> -int BPF_PROG(prog6, struct task_struct *tsk, const char *buf, bool exec)
> -{
> -	return !tsk;
> -}

I've applied patches 1,2,3,11. Thanks
