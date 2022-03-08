Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 987DF4D1F25
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 18:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349181AbiCHRbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 12:31:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349179AbiCHRbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 12:31:44 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524C2554A5
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 09:30:47 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v4so17839266pjh.2
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 09:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QJDEtkl6Etjpry2kRiWeCJ/RxHNh8OTbw+hm1Yc/tPY=;
        b=XL25vESE85Ypf1arVMxmOjLmRmeZ3qqe/jd+lSTD51nQsJ/r+V7PwG3btII8bWlJFu
         F6JgpipShQj8EB/X0pk1XNAOYnlSlSi/lae4qCfeP7pSn8B01QAc49qHPSWvRtSLw2ub
         PbfUsLH2FHikh8oeRjZnrrf0jmNoZ89eR4FLEjCXj0D/pSODd3t7Rh2FyLQNYTbOhRya
         c5oEKYREYTJK41zJrP+x/BZSSS0CHt88g+duG+OZGQj4P28zihlP9Off8VwXBGMKtOto
         89SBCI9oATvVN8wiPQ4oJiprvCfO7JgtEm8spSScLfXLwpURBzPn24BRkkNrVoCDIwLL
         O7Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QJDEtkl6Etjpry2kRiWeCJ/RxHNh8OTbw+hm1Yc/tPY=;
        b=ed5KmZpmy5xzt2nCnCm2AAcjtnXmlq2QI+7vxc7Gx9DZmaVkVtXL1RPebVnzfRUPj2
         K0A3YMfZMcjXVJ+GRbOKHvqoRA4T0v+2H4MdnOAHHFpzktp+l6MZACliUD0dufWgzfYP
         +YEQhXKOx+8edN/Qo1g9l5Isiz31ThUrxWIHFmk2OqZINuzdcaM/mNqkHIA/8i2KTXtu
         ira2R8pXI/xoplZ3JSi4CAK86gV2Tc7MfcHwxSOi/0dK/40DwrjLwYkaiQ7n1vzIgXWY
         BwCzo/MoPMdYSstsvxvujwDec8GfdMLQEG0ftciN0W2SZwS9PDxrpIbWY12ryll3MWPw
         CN2A==
X-Gm-Message-State: AOAM531bNiJEF7tw1CBjPaL6MAfipzBBrkoEkCRtsL3KzLL8fMzvqUoi
        sjLgqrpYQlP2+djidGVUGhSzUA==
X-Google-Smtp-Source: ABdhPJzRTgz2iKrDwQL0gWO49jWxbKmH8xAO5aRUP4rd5qgGeGS5/GqwrG8ATJba2zq3qb1LA2rL2w==
X-Received: by 2002:a17:90b:3b42:b0:1bf:b72:30e9 with SMTP id ot2-20020a17090b3b4200b001bf0b7230e9mr5808337pjb.135.1646760646811;
        Tue, 08 Mar 2022 09:30:46 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id o13-20020a17090a3d4d00b001bf7d65f1e2sm3440031pjf.3.2022.03.08.09.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 09:30:46 -0800 (PST)
Date:   Tue, 8 Mar 2022 09:30:43 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, markzhang@nvidia.com,
        leonro@nvidia.com
Subject: Re: [PATCH iproute2 v3 1/2] lib/fs: fix memory leak in
 get_task_name()
Message-ID: <20220308093043.7c1a131a@hermes.local>
In-Reply-To: <d35e7d5f30777c59930b95a59217b99ead86a9f2.1646750928.git.aclaudi@redhat.com>
References: <cover.1646750928.git.aclaudi@redhat.com>
        <d35e7d5f30777c59930b95a59217b99ead86a9f2.1646750928.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Mar 2022 18:04:56 +0100
Andrea Claudi <aclaudi@redhat.com> wrote:

> asprintf() allocates memory which is not freed on the error path of
> get_task_name(), thus potentially leading to memory leaks.
> %m specifier on fscanf allocates memory, too, which needs to be freed by
> the caller.
> 
> This reworks get_task_name() to avoid memory allocation.
> - Pass a buffer and its lenght to the function, similarly to what
>   get_command_name() does, thus avoiding to allocate memory for
>   the string to be returned;
> - Use snprintf() instead of asprintf();
> - Use fgets() instead of fscanf() to limit string lenght.

Spelling s/lenght/length/

> 
> Fixes: 81bfd01a4c9e ("lib: move get_task_name() from rdma")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  include/utils.h |  2 +-
>  ip/iptuntap.c   | 17 ++++++++++-------
>  lib/fs.c        | 23 +++++++++++++----------
>  rdma/res-cmid.c |  8 +++++---
>  rdma/res-cq.c   |  8 +++++---
>  rdma/res-ctx.c  |  7 ++++---
>  rdma/res-mr.c   |  7 ++++---
>  rdma/res-pd.c   |  8 +++++---
>  rdma/res-qp.c   |  7 ++++---
>  rdma/res-srq.c  |  7 ++++---
>  rdma/stat.c     |  5 ++++-
>  11 files changed, 59 insertions(+), 40 deletions(-)
> 
> diff --git a/include/utils.h b/include/utils.h
> index b6c468e9..b0e0967c 100644
> --- a/include/utils.h
> +++ b/include/utils.h
> @@ -307,7 +307,7 @@ char *find_cgroup2_mount(bool do_mount);
>  __u64 get_cgroup2_id(const char *path);
>  char *get_cgroup2_path(__u64 id, bool full);
>  int get_command_name(const char *pid, char *comm, size_t len);
> -char *get_task_name(pid_t pid);
> +int get_task_name(pid_t pid, char *name, size_t len);
>  
>  int get_rtnl_link_stats_rta(struct rtnl_link_stats64 *stats64,
>  			    struct rtattr *tb[]);
> diff --git a/ip/iptuntap.c b/ip/iptuntap.c
> index 385d2bd8..35c9bf5b 100644
> --- a/ip/iptuntap.c
> +++ b/ip/iptuntap.c
> @@ -321,14 +321,17 @@ static void show_processes(const char *name)
>  			} else if (err == 2 &&
>  				   !strcmp("iff", key) &&
>  				   !strcmp(name, value)) {
> -				char *pname = get_task_name(pid);
> -
> -				print_string(PRINT_ANY, "name",
> -					     "%s", pname ? : "<NULL>");
> +				SPRINT_BUF(pname);
> +
> +				if (get_task_name(pid, pname, sizeof(pname))) {
> +					print_string(PRINT_ANY, "name",
> +						     "%s", "<NULL>");
> +				} else {
> +					print_string(PRINT_ANY, "name",
> +						     "%s", pname);
> +				}
>

Don't need brackets here. I can fix that.
