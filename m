Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71CB0531DDD
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 23:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbiEWVgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 17:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbiEWVgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 17:36:19 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED201EEC8
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 14:36:17 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id b5so7174655plx.10
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 14:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cFyUjo7TXFGNA9Vlb9U6HZu558P2zH6nVOh7Dxt0LTM=;
        b=ShMK6JV6ksfybNkk+0YyVThN5JnG4yPToYC1vRO/yJirv9y4OIZg8zY8WEVYhbOiHu
         SfJCT6LK//7yeMr1Y6L5v45V3rNLbstrNubQV887Rsu0jkrfV95bExET/lChM79FWJN7
         uT7EBEGlkwMP+T8WKzxdFPcQMerXt8RPhT6NaiAmf1gfJ0n9UopRsXHQHMW0MASsXLLu
         5EHMKIvsirHpgBPW05dWtFJN0lXgflvkSFfOvAFZOndD32hFaK5dW6znojGAe7FZCReQ
         UmBmvVjuYiXG8w4KkZkv48SBy5M+YARnELXrwj51G4IR8uOffHUMvUNYT2PYA/ZsL/9b
         CXuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cFyUjo7TXFGNA9Vlb9U6HZu558P2zH6nVOh7Dxt0LTM=;
        b=k1JeOSLz5Bbb8Cg4NMawN+wFEEUkUmNAZ4nTLCj6CjQp3KXft4EV6HrjfdqVn3eUSu
         pl4jcNDFtr0ffzWcaCm1S4RNFyG1LKkVaDOwTP0702SfPM/gjTGTyKI61QwL20E/xJPW
         xkZNujjJSr+6/cveklUUcvzNMetUhA0dFYVxnMEPjdKosXnlxeK7ffIb2UTz/l1iZ08L
         ik4+o93QQCZuR3cP3+e8QCmiUiK2/Hrnr7C7+6DBj3MXlpKHHcIOjkDQhiDbt2OF60xL
         hjExsv6asiYTcEvJNz5ofBeJLS+xwVPUyXT9jJSJBhsR+KEc/O2csleokj0OpEH9PxjL
         rwgg==
X-Gm-Message-State: AOAM531jjP35Dt2HgZobgPU7jVndVVT7/0765FEB5qQxJZzlek/ba1hY
        UpWutJc/v+6rMNnrXwhAous4/w==
X-Google-Smtp-Source: ABdhPJz9TWHJO0uTnEH11z5LyTOZcm715iSh7ffMmuvVWfo02YVSLquj6JyD79gOjEaXQOwi2IzyrA==
X-Received: by 2002:a17:902:d48b:b0:161:c136:2c40 with SMTP id c11-20020a170902d48b00b00161c1362c40mr24766018plg.77.1653341776881;
        Mon, 23 May 2022 14:36:16 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id c78-20020a621c51000000b0050dc76281fdsm7654239pfc.215.2022.05.23.14.36.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 14:36:16 -0700 (PDT)
Message-ID: <7949d722-86e8-8122-e607-4b09944b76ae@linaro.org>
Date:   Mon, 23 May 2022 14:36:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v4] bpf: Fix KASAN use-after-free Read in
 compute_effective_progs
Content-Language: en-US
To:     andrii.nakryiko@gmail.com
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com
References: <CAEf4BzY-p13huoqo6N7LJRVVj8rcjPeP3Cp=KDX4N2x9BkC9Zw@mail.gmail.com>
 <20220517180420.87954-1-tadeusz.struk@linaro.org>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <20220517180420.87954-1-tadeusz.struk@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/22 11:04, Tadeusz Struk wrote:
> Syzbot found a Use After Free bug in compute_effective_progs().
> The reproducer creates a number of BPF links, and causes a fault
> injected alloc to fail, while calling bpf_link_detach on them.
> Link detach triggers the link to be freed by bpf_link_free(),
> which calls __cgroup_bpf_detach() and update_effective_progs().
> If the memory allocation in this function fails, the function restores
> the pointer to the bpf_cgroup_link on the cgroup list, but the memory
> gets freed just after it returns. After this, every subsequent call to
> update_effective_progs() causes this already deallocated pointer to be
> dereferenced in prog_list_length(), and triggers KASAN UAF error.
> 
> To fix this issue don't preserve the pointer to the prog or link in the
> list, but remove it and replace it with a dummy prog without shrinking
> the table. The subsequent call to __cgroup_bpf_detach() or
> __cgroup_bpf_detach() will correct it.
> 
> Cc: "Alexei Starovoitov" <ast@kernel.org>
> Cc: "Daniel Borkmann" <daniel@iogearbox.net>
> Cc: "Andrii Nakryiko" <andrii@kernel.org>
> Cc: "Martin KaFai Lau" <kafai@fb.com>
> Cc: "Song Liu" <songliubraving@fb.com>
> Cc: "Yonghong Song" <yhs@fb.com>
> Cc: "John Fastabend" <john.fastabend@gmail.com>
> Cc: "KP Singh" <kpsingh@kernel.org>
> Cc: <netdev@vger.kernel.org>
> Cc: <bpf@vger.kernel.org>
> Cc: <stable@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> Link: https://syzkaller.appspot.com/bug?id=8ebf179a95c2a2670f7cf1ba62429ec044369db4
> Fixes: af6eea57437a ("bpf: Implement bpf_link-based cgroup BPF program attachment")
> Reported-by: <syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> ---
> v2: Add a fall back path that removes a prog from the effective progs
>      table in case detach fails to allocate memory in compute_effective_progs().
> 
> v3: Implement the fallback in a separate function purge_effective_progs
> 
> v4: Changed purge_effective_progs() to manipulate the array in a similar way
>      how replace_effective_prog() does it.
> ---
>   kernel/bpf/cgroup.c | 68 +++++++++++++++++++++++++++++++++++++++------
>   1 file changed, 60 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 128028efda64..6f1a6160c99e 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -681,6 +681,60 @@ static struct bpf_prog_list *find_detach_entry(struct list_head *progs,
>   	return ERR_PTR(-ENOENT);
>   }
>   
> +/**
> + * purge_effective_progs() - After compute_effective_progs fails to alloc new
> + *                           cgrp->bpf.inactive table we can recover by
> + *                           recomputing the array in place.
> + *
> + * @cgrp: The cgroup which descendants to travers
> + * @prog: A program to detach or NULL
> + * @link: A link to detach or NULL
> + * @atype: Type of detach operation
> + */
> +static void purge_effective_progs(struct cgroup *cgrp, struct bpf_prog *prog,
> +				  struct bpf_cgroup_link *link,
> +				  enum cgroup_bpf_attach_type atype)
> +{
> +	struct cgroup_subsys_state *css;
> +	struct bpf_prog_array *progs;
> +	struct bpf_prog_list *pl;
> +	struct list_head *head;
> +	struct cgroup *cg;
> +	int pos;
> +
> +	/* recompute effective prog array in place */
> +	css_for_each_descendant_pre(css, &cgrp->self) {
> +		struct cgroup *desc = container_of(css, struct cgroup, self);
> +
> +		if (percpu_ref_is_zero(&desc->bpf.refcnt))
> +			continue;
> +
> +		/* find position of link or prog in effective progs array */
> +		for (pos = 0, cg = desc; cg; cg = cgroup_parent(cg)) {
> +			if (pos && !(cg->bpf.flags[atype] & BPF_F_ALLOW_MULTI))
> +				continue;
> +
> +			head = &cg->bpf.progs[atype];
> +			list_for_each_entry(pl, head, node) {
> +				if (!prog_list_prog(pl))
> +					continue;
> +				if (pl->prog == prog && pl->link == link)
> +					goto found;
> +				pos++;
> +			}
> +		}
> +found:
> +		BUG_ON(!cg);
> +		progs = rcu_dereference_protected(
> +				desc->bpf.effective[atype],
> +				lockdep_is_held(&cgroup_mutex));
> +
> +		/* Remove the program from the array */
> +		WARN_ONCE(bpf_prog_array_delete_safe_at(progs, pos),
> +			  "Failed to purge a prog from array at index %d", pos);
> +	}
> +}
> +
>   /**
>    * __cgroup_bpf_detach() - Detach the program or link from a cgroup, and
>    *                         propagate the change to descendants
> @@ -723,8 +777,12 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>   	pl->link = NULL;
>   
>   	err = update_effective_progs(cgrp, atype);
> -	if (err)
> -		goto cleanup;
> +	if (err) {
> +		/* If update affective array failed replace the prog with a dummy prog*/
> +		pl->prog = old_prog;
> +		pl->link = link;
> +		purge_effective_progs(cgrp, old_prog, link, atype);
> +	}
>   
>   	/* now can actually delete it from this cgroup list */
>   	list_del(&pl->node);
> @@ -736,12 +794,6 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>   		bpf_prog_put(old_prog);
>   	static_branch_dec(&cgroup_bpf_enabled_key[atype]);
>   	return 0;
> -
> -cleanup:
> -	/* restore back prog or link */
> -	pl->prog = old_prog;
> -	pl->link = link;
> -	return err;
>   }
>   
>   static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,

Hi Andrii,
Do you have any more feedback? Does it look better to you now?
-- 
Thanks,
Tadeusz
