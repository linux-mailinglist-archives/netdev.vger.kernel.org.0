Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0965B6EB17C
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 20:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbjDUSVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 14:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbjDUSU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 14:20:59 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218A6E5C;
        Fri, 21 Apr 2023 11:20:59 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-63b7096e2e4so2223917b3a.2;
        Fri, 21 Apr 2023 11:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682101258; x=1684693258;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gYjAZVUAZkx+hJ9DMfGgeXPjn1yZPg0cuZSv04E2x7I=;
        b=opVL+FyOwnx0VvvEOKDUyxKFCbbWvhICTk0wswSaWXjYPZ9X+mnJ6rIcs3NSJM/pDO
         OBjfmfsur+3NCjqO5wOmFR7kFDt98teMTtUNydGqavih1WpIwf85M5ewrUqkbDZ+aQVu
         wZviAhfTqLr+BxhECJC3dVaZO2wWqA1DoaYCM4QL/8oN9/sf1hWAyYjTgSrG1YP/tWGK
         FmJFfy1/vWSR5ldvwLtEkJ7yu0tecbXXfol7sz0DnBU1INB4DyQ6PAxY6MDJ98CLFlac
         TQ+xxpRQK9auts/BaCZjzNUDtOHIrK2UTFIwW+UZahIx5D4Fu0/16Ozmg/BNZQljyCJk
         6WnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682101258; x=1684693258;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gYjAZVUAZkx+hJ9DMfGgeXPjn1yZPg0cuZSv04E2x7I=;
        b=OTIEFQNa0+Y/GSIT+mkKIIRBCAwSLqw09Kovkqj9yWGlriWyAuYAtuduxcMD9kO7fT
         6u0sb95JDwNTOYfZNjF9EQYF87ffTX28LeRuyjsQuom389i3HPFHvsqB6x5Fk/0qEpsa
         SbEN2AQTFY20QDcXb8jH7iYY91Qi4XHHTAYg5CIAiW3HouLe0SB79im/nOB71E2+c1Fp
         OUL1KVXBoaHzAJ3ApwBYamx351us58X2I6su3lcXydBkcrdMa24lTR4LWwvG8Z8UiZKf
         OZ+ixm44WAIrNRBjN+DAPlYFA6vfGEzcIfTuK2L82puA6HEDVHVlfWkQevM71SxJEZBa
         ZTcA==
X-Gm-Message-State: AAQBX9eLbAF1e6rUVsuVHPVMXQQpTf8JUN9gZkfcKaggxsWvYdMJzZc/
        Trj3SVeXGM6FTwjfcdvDvDQ=
X-Google-Smtp-Source: AKy350brB+XC6kH0bv26owrFYJrDFQJiNVzOdTqBi5aNRCmztfTSlv8r6qmfOC7KiXa9XrGSovJ3Jg==
X-Received: by 2002:a05:6a00:10c9:b0:63b:8b47:453c with SMTP id d9-20020a056a0010c900b0063b8b47453cmr7515216pfu.1.1682101258369;
        Fri, 21 Apr 2023 11:20:58 -0700 (PDT)
Received: from dhcp-172-26-102-232.dhcp.thefacebook.com ([2620:10d:c090:400::5:ef5e])
        by smtp.gmail.com with ESMTPSA id c194-20020a624ecb000000b0062dba4e4706sm3221520pfb.191.2023.04.21.11.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 11:20:57 -0700 (PDT)
Date:   Fri, 21 Apr 2023 11:20:54 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Feng zhou <zhoufeng.zf@bytedance.com>
Cc:     martin.lau@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mykolal@fb.com, shuah@kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, yangzhenze@bytedance.com,
        wangdongdong.6@bytedance.com
Subject: Re: [PATCH bpf-next v2 1/2] bpf: Add bpf_task_under_cgroup() kfunc
Message-ID: <20230421182054.fisbe6dowoif3eta@dhcp-172-26-102-232.dhcp.thefacebook.com>
References: <20230421090403.15515-1-zhoufeng.zf@bytedance.com>
 <20230421090403.15515-2-zhoufeng.zf@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421090403.15515-2-zhoufeng.zf@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 05:04:02PM +0800, Feng zhou wrote:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> Add a kfunc that's similar to the bpf_current_task_under_cgroup.
> The difference is that it is a designated task.
> 
> When hook sched related functions, sometimes it is necessary to
> specify a task instead of the current task.
> 
> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
> ---
>  kernel/bpf/helpers.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 00e5fb0682ac..88e3247b5c44 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -2142,6 +2142,24 @@ __bpf_kfunc struct cgroup *bpf_cgroup_from_id(u64 cgid)
>  		return NULL;
>  	return cgrp;
>  }
> +
> +/**
> + * bpf_task_under_cgroup - Check whether the task is a given subset of the
> + * cgroup2 hierarchy. The cgroup2 to test is assigned by cgrp.

That doesn't read right.

> + * @cgrp: assigned cgrp.
> + * @task: assigned task.

This is also wrong.
Please copy paste from task_under_cgroup_hierarchy.

> + */
> +__bpf_kfunc int bpf_task_under_cgroup(struct cgroup *cgrp,
> +				      struct task_struct *task)

return type needs to be 'long'. 'int' might have issues.
Also the args should be task, cgrp to match task_under_cgroup_hierarchy.

> +{
> +	if (unlikely(!cgrp))
> +		return -EAGAIN;
> +
> +	if (unlikely(!task))
> +		return -ENOENT;

Please do
if (unlikely(!cgrp || !task))
        return -EINVAL;

> +
> +	return task_under_cgroup_hierarchy(task, cgrp);
> +}
>  #endif /* CONFIG_CGROUPS */
>  
>  /**
> @@ -2341,6 +2359,7 @@ BTF_ID_FLAGS(func, bpf_cgroup_acquire, KF_ACQUIRE | KF_RCU | KF_RET_NULL)
>  BTF_ID_FLAGS(func, bpf_cgroup_release, KF_RELEASE)
>  BTF_ID_FLAGS(func, bpf_cgroup_ancestor, KF_ACQUIRE | KF_RCU | KF_RET_NULL)
>  BTF_ID_FLAGS(func, bpf_cgroup_from_id, KF_ACQUIRE | KF_RET_NULL)
> +BTF_ID_FLAGS(func, bpf_task_under_cgroup, KF_RCU)
>  #endif
>  BTF_ID_FLAGS(func, bpf_task_from_pid, KF_ACQUIRE | KF_RET_NULL)
>  BTF_SET8_END(generic_btf_ids)
> -- 
> 2.20.1
> 
