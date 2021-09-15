Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007FF40CA37
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 18:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhIOQfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 12:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhIOQfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 12:35:15 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CA0C061574;
        Wed, 15 Sep 2021 09:33:56 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id k23so2565451pji.0;
        Wed, 15 Sep 2021 09:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gsStG1sKSvkBjku+METZsN+9/Au7A/rdRxl9FnC/IiY=;
        b=ea51/qqc727nuQy5bmxT1i9ZQljRuwNiYGuSIfXtrkH9xal0mYYwSEutUmCl5Ck2UJ
         9Xe+AVkvmjE5bb6aueB5no5HKcui4pSDz7kGmTtS6OZJvifPd8VjFRyiqRM8hHCRlGRb
         JdV0hFCqiepxRHnBiLXR0KeFzOqsSqQXk0MwG2/KMq7zT54oH1UHYfO8HiSIVqfE2qBA
         Lx1MDzNV4wb6RKF3MRWWGnJtvUIzaRw4MbZ833HESHZudNsy17meT9IuDFHW9yQ0fzqj
         NNSpKLCSr9XbEHJw1bdtjGxALd6QY0zE/dCNgJtFQdJV/IYMhmR1bfBefltrjlsKlYjF
         w0vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gsStG1sKSvkBjku+METZsN+9/Au7A/rdRxl9FnC/IiY=;
        b=rMw9SQZgbjVHYRzGnCZO4gV9bxjjxDWACMqDSKjUbFdQw1v8843312Im9s7ZofFhf/
         5oNKKEUiEzGW9J1aNLxT9bkvH+weMu02CWZUcsgrE8r13NuZhLTVPjjycDEGOnSskBMV
         nai9hEuvxxEXUUFOYBGB2q81N5t+BdvZxxgDgcTs9bBOriCQ9lv/0DrR1XYU6GqluRK8
         97FWZOBbDmlzn8zW43l/umMa5XBeUWn3VwO6m7iHfcDj1HgpQTx/YQtLlzt3rJ7BGwc3
         znJhsAoAMkp7zsOEYDPdRAff8HUZmLWoDbAUd0vXmdsODTHgTDDEyBs5UvWPhOWSKArR
         +03w==
X-Gm-Message-State: AOAM530DYoIZSLDZSoSeXFaE0EK9MyzVMJwhWY8Mgk9E0WUJfSQ6JQf5
        dV4b/1fNSrv7S+lzG8Q9f80=
X-Google-Smtp-Source: ABdhPJw1xP3K8oECc/hOIBq9r8qH77Ggxt4KxGWem7cGR8Y0uK15DshxF3dUW1A2ih6tvRlVeblPVw==
X-Received: by 2002:a17:90b:4f49:: with SMTP id pj9mr9473257pjb.188.1631723635426;
        Wed, 15 Sep 2021 09:33:55 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:7b03])
        by smtp.gmail.com with ESMTPSA id 21sm405233pfh.103.2021.09.15.09.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 09:33:55 -0700 (PDT)
Date:   Wed, 15 Sep 2021 09:33:53 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 06/10] bpf: Bump MAX_BPF_STACK size to 768
 bytes
Message-ID: <20210915163353.ysltf6edghj75koq@ast-mbp.dhcp.thefacebook.com>
References: <20210915050943.679062-1-memxor@gmail.com>
 <20210915050943.679062-7-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915050943.679062-7-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 10:39:39AM +0530, Kumar Kartikeya Dwivedi wrote:
> Increase the maximum stack size accessible to BPF program to 768 bytes.
> This is done so that gen_loader can use 94 additional fds for kfunc BTFs
> that it passes in to fd_array from the remaining space available for the
> loader_stack struct to expand.
> 
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  include/linux/filter.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 4a93c12543ee..b214189ece62 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -82,8 +82,8 @@ struct ctl_table_header;
>   */
>  #define BPF_SYM_ELF_TYPE	't'
>  
> -/* BPF program can access up to 512 bytes of stack space. */
> -#define MAX_BPF_STACK	512
> +/* BPF program can access up to 768 bytes of stack space. */
> +#define MAX_BPF_STACK	768

Yikes.
I guess you meant as RFC, right? You didn't really propose
to increase prog stack size just for that, right?

In the later patch:
+/* MAX_BPF_STACK is 768 bytes, so (64 + 32 + 94 (MAX_KFUNC_DESCS) + 2) * 4 */
 #define MAX_USED_MAPS 64
 #define MAX_USED_PROGS 32

@@ -31,6 +33,8 @@ struct loader_stack {
        __u32 btf_fd;
        __u32 map_fd[MAX_USED_MAPS];
        __u32 prog_fd[MAX_USED_PROGS];
+       /* Update insn->off store when reordering kfunc_btf_fd */
+       __u32 kfunc_btf_fd[MAX_KFUNC_DESCS];
        __u32 inner_map_fd;
};

There are few other ways to do that.
For example:
A: rename map_fd[] into fds[] and store both map and btf FDs in there.
B: move map and btf FDs into data instead of stack.
