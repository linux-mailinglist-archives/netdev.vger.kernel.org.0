Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4C2522423
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 20:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348966AbiEJSeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 14:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245346AbiEJSeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 14:34:01 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE3458E79;
        Tue, 10 May 2022 11:34:00 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id s14so17513043plk.8;
        Tue, 10 May 2022 11:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Cc7nynWlTk1v/xeUbUkmBnrl/rco57CYRTC5cF6QRvc=;
        b=ogrxbrE8ZkyEP865XaKeZApT2CTGltGBi0Vn3SjMIm99uiYupCY8gK/f1B3ohxg9x1
         JSJgV/L6tSEGJim3zIdU7dop2a7pHqN08UOaW4+urgBuwgVH8xuJ9SfwdKsCz+rD8b1a
         HfJExzyJErTjM0LmDUoXxY13aDo0oRdzb9zPwfRB6u9NX/CEOLQeg22MV9dpngtqYiH9
         wsKy9Jn2XX4AMtMPpvLQrnpbxyF/D0bypA6cbvkrPGTQ1V01yE19gGiuGerv4FlW0Qrz
         ikmq22DzzUaj8R81SQ2yUAfmuNd5Ht+Q9DHOqiEPtmRIOaKUk9FvCNFpZu17NDO4e4Bg
         HcYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Cc7nynWlTk1v/xeUbUkmBnrl/rco57CYRTC5cF6QRvc=;
        b=ByiRnv8/hz/YEGX6Mq28zO6SwkMND36ODIUZEWhhaT780hWnT5nszDYtmPWgLY1Sw4
         LMnd81UPcX8Y915w9T7zscypvKoQla/VkOCmDM0T7ZZG7FDoorGOaaHxp0NXWWTkH3gq
         eAO6Dw4U/SaxXYe1Hydyda3bybEE9KukbJosJfi/1TY/1Ou/MAPJyNbes3UZbbRdka41
         4r8KW896NNdKHN+jiatnzB83HPtQkmmaA6c+wOSGZ9Y9k5ZnRtkag/trZdbMMuDEqKCA
         WnYhquD+DuWdGw4F+IZXMSHV3SdQk/4M1mqFq9W/3Z8+gkUOv24I3Y0Vuzb4oVKjdXdW
         Et9Q==
X-Gm-Message-State: AOAM532F/EMoHq0w08IJfwzoNd1uQXNQNdLfxF7qWGUPucQ66Unb2MCF
        L+U1xyDwOMk2mHH5vQAdPwk=
X-Google-Smtp-Source: ABdhPJwp4Z3szAvMOkABhiTNw7zYEvOFOCAJrTCspf9qrS1tibYC4dx9SsLljh55ERZHr9s9l/a1Yg==
X-Received: by 2002:a17:90a:694d:b0:1dc:e471:1a71 with SMTP id j13-20020a17090a694d00b001dce4711a71mr1237367pjm.65.1652207639849;
        Tue, 10 May 2022 11:33:59 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::4:6c64])
        by smtp.gmail.com with ESMTPSA id o19-20020a17090a421300b001d9738fdf2asm2141992pjg.37.2022.05.10.11.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 11:33:59 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 10 May 2022 08:33:58 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 6/9] cgroup: add v1 support to
 cgroup_get_from_id()
Message-ID: <YnqwFuhncWiR3rjq@slm.duckdns.org>
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-7-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510001807.4132027-7-yosryahmed@google.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 12:18:04AM +0000, Yosry Ahmed wrote:
> The current implementation of cgroup_get_from_id() only searches the
> default hierarchy for the given id. Make it compatible with cgroup v1 by
> looking through all the roots instead.
> 
> cgrp_dfl_root should be the first element in the list so there shouldn't
> be a performance impact for cgroup v2 users (in the case of a valid id).
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>  kernel/cgroup/cgroup.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index af703cfcb9d2..12700cd21973 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -5970,10 +5970,16 @@ void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen)
>   */
>  struct cgroup *cgroup_get_from_id(u64 id)
>  {
> -	struct kernfs_node *kn;
> +	struct kernfs_node *kn = NULL;
>  	struct cgroup *cgrp = NULL;
> +	struct cgroup_root *root;
> +
> +	for_each_root(root) {
> +		kn = kernfs_find_and_get_node_by_id(root->kf_root, id);
> +		if (kn)
> +			break;
> +	}

I can't see how this can work. You're smashing together separate namespaces
and the same IDs can exist across multiple of these hierarchies. You'd need
a bigger surgery to make this work for cgroup1 which would prolly involve
complications around 32bit ino's and file handle support too, which I'm not
likely to ack, so please give it up on adding these things to cgroup1.

Nacked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
