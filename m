Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F9A4D05FB
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 19:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240475AbiCGSIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 13:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237926AbiCGSIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 13:08:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD9EB7DE3A
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 10:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646676438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VqYAYyUIV4CAR5ZEo/D+TB557SwAcHK2g9WcizUKSZg=;
        b=MDeJpjrDYARYK/doH6qkbpeSBFLiW12NaKcSKPoggmEhQ+N98Akca1YYHWQDG4efcXhGyB
        Wi1IbcmpwIkqahwZ0wSChzR+C6usWp2Qem5ajRF5p3/cXOpi7meMYjhz92f4dgZ0DWC08Q
        5RT8v+AZ9vtWDgCxRSmlOuAG6lDgrq0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-Sq_C-mmkPqWhA7ssVktgPw-1; Mon, 07 Mar 2022 13:07:16 -0500
X-MC-Unique: Sq_C-mmkPqWhA7ssVktgPw-1
Received: by mail-ej1-f71.google.com with SMTP id go11-20020a1709070d8b00b006cf0d933739so7354259ejc.5
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 10:07:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VqYAYyUIV4CAR5ZEo/D+TB557SwAcHK2g9WcizUKSZg=;
        b=TVbtiFMic3mJMHZZtM9Qx3EPIJEzIyO/ljFjCXf+r1iDbIkbqY/F+6XMBzo3aW3/pi
         ZM9fjWm8HTUqISbhIzg9PrXgFgyUx6AEDA43aqqm0VV1loOx9P9BDwaPfFHLRgkmNCct
         qKQQxKhlfzHzjIM+mMjBteARq0F53x55g52b2jikVDplBAHJUaHjUvyisa39gDja+6py
         +48YfHeXQ958XNVSzP+lQsWgAZRcdZcnh+9HTBreL/dpMMgkshxYTw2PpU9k8DsIh6v8
         y4pau4IJUcZR6GuwFs+Vg0nRoJI4Rd7KukHwcK3aZZI1IjOZbRPkBdylbEQDZj0P4aCA
         Xshw==
X-Gm-Message-State: AOAM531KUsOp1XxdWzS09jaDw3uyHg6PjrHEKLpmu+/Kbc4ZdOgW2kYW
        DF7U8PGACTXqphIyCAFG8TEf3l3dXMOtoLMp59hCxD/xGa3HNaN0hrLp2QwtS1++nc7NnmPRNGe
        SXzIYVmyV1L4VvUdD
X-Received: by 2002:a17:907:2d9f:b0:6da:74aa:c1a6 with SMTP id gt31-20020a1709072d9f00b006da74aac1a6mr10178156ejc.683.1646676435063;
        Mon, 07 Mar 2022 10:07:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwBymkbUlzOdTxBXJYL3+6qC9n76qpCWjpHttME1fTvVi6wdcThtKntAsLFWRPYDWHI5bOedQ==
X-Received: by 2002:a17:907:2d9f:b0:6da:74aa:c1a6 with SMTP id gt31-20020a1709072d9f00b006da74aac1a6mr10178136ejc.683.1646676434745;
        Mon, 07 Mar 2022 10:07:14 -0800 (PST)
Received: from localhost (net-37-119-159-68.cust.vodafonedsl.it. [37.119.159.68])
        by smtp.gmail.com with ESMTPSA id lb10-20020a170907784a00b006db0aadcbd1sm2351268ejc.219.2022.03.07.10.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 10:07:14 -0800 (PST)
Date:   Mon, 7 Mar 2022 19:07:10 +0100
From:   Andrea Claudi <aclaudi@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com, markzhang@nvidia.com
Subject: Re: [PATCH iproute2 v2 1/2] lib/fs: fix memory leak in
 get_task_name()
Message-ID: <YiZJzokKojVtEH4S@tc2>
References: <cover.1646223467.git.aclaudi@redhat.com>
 <0731f9e5b5ce95ab2da44ac74aa1f79ead9413bf.1646223467.git.aclaudi@redhat.com>
 <YiEPeU8z5Y+qd3+l@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiEPeU8z5Y+qd3+l@unreal>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon,
Thanks for your review.

On Thu, Mar 03, 2022 at 08:56:57PM +0200, Leon Romanovsky wrote:
> On Wed, Mar 02, 2022 at 01:28:47PM +0100, Andrea Claudi wrote:
> > asprintf() allocates memory which is not freed on the error path of
> > get_task_name(), thus potentially leading to memory leaks.
> 
> Not really, memory is released when the application exits, which is the
> case here.
>

That's certainly true. However this is still a leak in the time frame
between get_task_name function call and the application exit. For
example:

$ ip -d -b - << EOF
tuntap show
monitor
EOF

calls get_task_name one or more time (once for each tun interface), and
leaks memory indefinitely, if ip is not interrupted in some way.

Of course this is a corner case, and the leaks should anyway be small.
However I cannot see this as a good reason not to fix it.

> > 
> > Rework get_task_name() and avoid asprintf() usage and memory allocation,
> > returning the task string to the caller using an additional char*
> > parameter.
> > 
> > Fixes: 81bfd01a4c9e ("lib: move get_task_name() from rdma")
> 
> As I was told before, in netdev Fixes means that it is a bug that
> affects users. This is not the case here.

Thanks for letting me know. I usually rely a lot on Fixes: as iproute2
package maintainer, but I'll change my habits if this is the common
understanding. Stephen, David, WDYT?

> 
> > Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> > ---
> >  include/utils.h |  2 +-
> >  ip/iptuntap.c   | 17 ++++++++++-------
> >  lib/fs.c        | 20 ++++++++++----------
> >  rdma/res-cmid.c |  8 +++++---
> >  rdma/res-cq.c   |  8 +++++---
> >  rdma/res-ctx.c  |  7 ++++---
> >  rdma/res-mr.c   |  7 ++++---
> >  rdma/res-pd.c   |  8 +++++---
> >  rdma/res-qp.c   |  7 ++++---
> >  rdma/res-srq.c  |  7 ++++---
> >  rdma/stat.c     |  5 ++++-
> >  11 files changed, 56 insertions(+), 40 deletions(-)
> 
> Honestly, I don't see any need in both patches.
> 
> Thanks
> 
> > 
> > diff --git a/include/utils.h b/include/utils.h
> > index b6c468e9..81294488 100644
> > --- a/include/utils.h
> > +++ b/include/utils.h
> > @@ -307,7 +307,7 @@ char *find_cgroup2_mount(bool do_mount);
> >  __u64 get_cgroup2_id(const char *path);
> >  char *get_cgroup2_path(__u64 id, bool full);
> >  int get_command_name(const char *pid, char *comm, size_t len);
> > -char *get_task_name(pid_t pid);
> > +int get_task_name(pid_t pid, char *name);
> >  
> >  int get_rtnl_link_stats_rta(struct rtnl_link_stats64 *stats64,
> >  			    struct rtattr *tb[]);
> > diff --git a/ip/iptuntap.c b/ip/iptuntap.c
> > index 385d2bd8..2ae6b1a1 100644
> > --- a/ip/iptuntap.c
> > +++ b/ip/iptuntap.c
> > @@ -321,14 +321,17 @@ static void show_processes(const char *name)
> >  			} else if (err == 2 &&
> >  				   !strcmp("iff", key) &&
> >  				   !strcmp(name, value)) {
> > -				char *pname = get_task_name(pid);
> > -
> > -				print_string(PRINT_ANY, "name",
> > -					     "%s", pname ? : "<NULL>");
> > +				SPRINT_BUF(pname);
> > +
> > +				if (get_task_name(pid, pname)) {
> > +					print_string(PRINT_ANY, "name",
> > +						     "%s", "<NULL>");
> > +				} else {
> > +					print_string(PRINT_ANY, "name",
> > +						     "%s", pname);
> > +				}
> >  
> > -				print_uint(PRINT_ANY, "pid",
> > -					   "(%d)", pid);
> > -				free(pname);
> > +				print_uint(PRINT_ANY, "pid", "(%d)", pid);
> >  			}
> >  
> >  			free(key);
> > diff --git a/lib/fs.c b/lib/fs.c
> > index f6f5f8a0..03df0f6a 100644
> > --- a/lib/fs.c
> > +++ b/lib/fs.c
> > @@ -342,25 +342,25 @@ int get_command_name(const char *pid, char *comm, size_t len)
> >  	return 0;
> >  }
> >  
> > -char *get_task_name(pid_t pid)
> > +int get_task_name(pid_t pid, char *name)
> >  {
> > -	char *comm;
> > +	char path[PATH_MAX];
> >  	FILE *f;
> >  
> >  	if (!pid)
> > -		return NULL;
> > +		return -1;
> >  
> > -	if (asprintf(&comm, "/proc/%d/comm", pid) < 0)
> > -		return NULL;
> > +	if (snprintf(path, sizeof(path), "/proc/%d/comm", pid) >= sizeof(path))
> > +		return -1;
> >  
> > -	f = fopen(comm, "r");
> > +	f = fopen(path, "r");
> >  	if (!f)
> > -		return NULL;
> > +		return -1;
> >  
> > -	if (fscanf(f, "%ms\n", &comm) != 1)
> > -		comm = NULL;
> > +	if (fscanf(f, "%s\n", name) != 1)
> > +		return -1;
> >  
> >  	fclose(f);
> >  
> > -	return comm;
> > +	return 0;
> >  }
> > diff --git a/rdma/res-cmid.c b/rdma/res-cmid.c
> > index bfaa47b5..3475349d 100644
> > --- a/rdma/res-cmid.c
> > +++ b/rdma/res-cmid.c
> > @@ -159,8 +159,11 @@ static int res_cm_id_line(struct rd *rd, const char *name, int idx,
> >  		goto out;
> >  
> >  	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
> > +		SPRINT_BUF(b);
> > +
> >  		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
> > -		comm = get_task_name(pid);
> > +		if (!get_task_name(pid, b))
> > +			comm = b;
> >  	}
> >  
> >  	if (rd_is_filtered_attr(rd, "pid", pid,
> > @@ -199,8 +202,7 @@ static int res_cm_id_line(struct rd *rd, const char *name, int idx,
> >  	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
> >  	newline(rd);
> >  
> > -out:	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
> > -		free(comm);
> > +out:
> >  	return MNL_CB_OK;
> >  }
> >  
> > diff --git a/rdma/res-cq.c b/rdma/res-cq.c
> > index 9e7c4f51..5ed455ea 100644
> > --- a/rdma/res-cq.c
> > +++ b/rdma/res-cq.c
> > @@ -84,8 +84,11 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
> >  		goto out;
> >  
> >  	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
> > +		SPRINT_BUF(b);
> > +
> >  		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
> > -		comm = get_task_name(pid);
> > +		if (!get_task_name(pid, b))
> > +			comm = b;
> >  	}
> >  
> >  	if (rd_is_filtered_attr(rd, "pid", pid,
> > @@ -123,8 +126,7 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
> >  	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
> >  	newline(rd);
> >  
> > -out:	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
> > -		free(comm);
> > +out:
> >  	return MNL_CB_OK;
> >  }
> >  
> > diff --git a/rdma/res-ctx.c b/rdma/res-ctx.c
> > index 30afe97a..fbd52dd5 100644
> > --- a/rdma/res-ctx.c
> > +++ b/rdma/res-ctx.c
> > @@ -18,8 +18,11 @@ static int res_ctx_line(struct rd *rd, const char *name, int idx,
> >  		return MNL_CB_ERROR;
> >  
> >  	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
> > +		SPRINT_BUF(b);
> > +
> >  		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
> > -		comm = get_task_name(pid);
> > +		if (!get_task_name(pid, b))
> > +			comm = b;
> >  	}
> >  
> >  	if (rd_is_filtered_attr(rd, "pid", pid,
> > @@ -48,8 +51,6 @@ static int res_ctx_line(struct rd *rd, const char *name, int idx,
> >  	newline(rd);
> >  
> >  out:
> > -	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
> > -		free(comm);
> >  	return MNL_CB_OK;
> >  }
> >  
> > diff --git a/rdma/res-mr.c b/rdma/res-mr.c
> > index 1bf73f3a..6a59d9e4 100644
> > --- a/rdma/res-mr.c
> > +++ b/rdma/res-mr.c
> > @@ -47,8 +47,11 @@ static int res_mr_line(struct rd *rd, const char *name, int idx,
> >  		goto out;
> >  
> >  	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
> > +		SPRINT_BUF(b);
> > +
> >  		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
> > -		comm = get_task_name(pid);
> > +		if (!get_task_name(pid, b))
> > +			comm = b;
> >  	}
> >  
> >  	if (rd_is_filtered_attr(rd, "pid", pid,
> > @@ -87,8 +90,6 @@ static int res_mr_line(struct rd *rd, const char *name, int idx,
> >  	newline(rd);
> >  
> >  out:
> > -	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
> > -		free(comm);
> >  	return MNL_CB_OK;
> >  }
> >  
> > diff --git a/rdma/res-pd.c b/rdma/res-pd.c
> > index df538010..a51bb634 100644
> > --- a/rdma/res-pd.c
> > +++ b/rdma/res-pd.c
> > @@ -34,8 +34,11 @@ static int res_pd_line(struct rd *rd, const char *name, int idx,
> >  			nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY]);
> >  
> >  	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
> > +		SPRINT_BUF(b);
> > +
> >  		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
> > -		comm = get_task_name(pid);
> > +		if (!get_task_name(pid, b))
> > +			comm = b;
> >  	}
> >  
> >  	if (rd_is_filtered_attr(rd, "pid", pid,
> > @@ -76,8 +79,7 @@ static int res_pd_line(struct rd *rd, const char *name, int idx,
> >  	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
> >  	newline(rd);
> >  
> > -out:	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
> > -		free(comm);
> > +out:
> >  	return MNL_CB_OK;
> >  }
> >  
> > diff --git a/rdma/res-qp.c b/rdma/res-qp.c
> > index a38be399..575e0529 100644
> > --- a/rdma/res-qp.c
> > +++ b/rdma/res-qp.c
> > @@ -146,8 +146,11 @@ static int res_qp_line(struct rd *rd, const char *name, int idx,
> >  		goto out;
> >  
> >  	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
> > +		SPRINT_BUF(b);
> > +
> >  		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
> > -		comm = get_task_name(pid);
> > +		if (!get_task_name(pid, b))
> > +			comm = b;
> >  	}
> >  
> >  	if (rd_is_filtered_attr(rd, "pid", pid,
> > @@ -179,8 +182,6 @@ static int res_qp_line(struct rd *rd, const char *name, int idx,
> >  	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
> >  	newline(rd);
> >  out:
> > -	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
> > -		free(comm);
> >  	return MNL_CB_OK;
> >  }
> >  
> > diff --git a/rdma/res-srq.c b/rdma/res-srq.c
> > index 3038c352..945109fc 100644
> > --- a/rdma/res-srq.c
> > +++ b/rdma/res-srq.c
> > @@ -174,8 +174,11 @@ static int res_srq_line(struct rd *rd, const char *name, int idx,
> >  		return MNL_CB_ERROR;
> >  
> >  	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
> > +		SPRINT_BUF(b);
> > +
> >  		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
> > -		comm = get_task_name(pid);
> > +		if (!get_task_name(pid, b))
> > +			comm = b;
> >  	}
> >  	if (rd_is_filtered_attr(rd, "pid", pid,
> >  				nla_line[RDMA_NLDEV_ATTR_RES_PID]))
> > @@ -228,8 +231,6 @@ static int res_srq_line(struct rd *rd, const char *name, int idx,
> >  	newline(rd);
> >  
> >  out:
> > -	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
> > -		free(comm);
> >  	return MNL_CB_OK;
> >  }
> >  
> > diff --git a/rdma/stat.c b/rdma/stat.c
> > index adfcd34a..a63b70a4 100644
> > --- a/rdma/stat.c
> > +++ b/rdma/stat.c
> > @@ -248,8 +248,11 @@ static int res_counter_line(struct rd *rd, const char *name, int index,
> >  		return MNL_CB_OK;
> >  
> >  	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
> > +		SPRINT_BUF(b);
> > +
> >  		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
> > -		comm = get_task_name(pid);
> > +		if (!get_task_name(pid, b))
> > +			comm = b;
> >  	}
> >  	if (rd_is_filtered_attr(rd, "pid", pid,
> >  				nla_line[RDMA_NLDEV_ATTR_RES_PID]))
> > -- 
> > 2.35.1
> > 
> 

