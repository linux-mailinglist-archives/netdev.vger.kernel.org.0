Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EABCA1A3E9A
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 05:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgDJDKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 23:10:49 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43684 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbgDJDKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 23:10:48 -0400
Received: by mail-pf1-f196.google.com with SMTP id l1so488532pff.10;
        Thu, 09 Apr 2020 20:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SzsIRh2Ih0SubamthzDAukhFWqHrEwEyqn9glQHC50A=;
        b=tZs81gU0CTqjopHYAp+UbmmLkkCVU7lmJrZd/+m2ag2wMV8QeVcDXQ30UnUyehUz+W
         D25zQk1L5yWI3PpjPg5Ltd/qbCKqonDS33ZxSFWXONPTlpmKdE1cCVdxdulHbU9EScSz
         +IemD7iF5chbsXMqRHRDquUq9PkwaSZyAj+Qf32/VXapGVT1Ye+TrwVRExHfJHC/sIp7
         EC2NZ3uushqH0pMbuYQKTG26IDKd2Le29kbI43/r6ccU7QAZ+lwclaXPR9ubuyroEkRG
         2isb9YvVEqJXLBJ3ZL945eWZ0CU5tWHVdrKYQh5shnZ1UPPcUu6THo9fpgfluxUCmUFT
         NwpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SzsIRh2Ih0SubamthzDAukhFWqHrEwEyqn9glQHC50A=;
        b=MDvE6TObc4nxLLnLyFcwWs6S+ySx/Gws8HTad0POZ9FxhogCriKTOegImmluzLeH9j
         cimClFua3S7sKDq6W+ZuSs322UoSe7WSvzdPU/3/2/w1r9azBCqLnp8oXJvwLVdBRUl3
         nvZA6/KBb/pHmrxrGd39Au3rk7FBUPhUiV3tRB2z0xw/MjIi1b+viyE1yYfUGM9Gu6P0
         +EWc6HPr4eOQSO4WFPmVXWPpT/98Ft/FMv6WteBIU+dq7uDtYImAvnFVHdJkTG3rDtzT
         ul9FIVdX1RQNhXNnWdh0IHw536WG49dXZlODGjYiMJnouodwdj+fVC9Scqe6RoslUOV7
         b0IQ==
X-Gm-Message-State: AGi0Puber1dj6rdAr//KLxuYyrKSlFlz8XGmH0b8vLAi0MYuvmDOUm5S
        l9fYRucIoVGzWFQQKzs7er4=
X-Google-Smtp-Source: APiQypLKPQCs6FbPhQXJLu42je+iLWEh7x16G3QKvQOTNJr0T6ORbpK8X19+XmH6415WGeTPJoN3QQ==
X-Received: by 2002:a63:1154:: with SMTP id 20mr2490448pgr.114.1586488246364;
        Thu, 09 Apr 2020 20:10:46 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:f219])
        by smtp.gmail.com with ESMTPSA id i14sm454448pgh.47.2020.04.09.20.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 20:10:45 -0700 (PDT)
Date:   Thu, 9 Apr 2020 20:10:43 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
Subject: Re: [RFC PATCH bpf-next 11/16] bpf: implement query for target_proto
 and file dumper prog_id
Message-ID: <20200410031043.lza5p6rzi6vajy7h@ast-mbp.dhcp.thefacebook.com>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232533.2676305-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408232533.2676305-1-yhs@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 08, 2020 at 04:25:33PM -0700, Yonghong Song wrote:
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index a245f0df53c4..fc2157e319f1 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -113,6 +113,7 @@ enum bpf_cmd {
>  	BPF_MAP_DELETE_BATCH,
>  	BPF_LINK_CREATE,
>  	BPF_LINK_UPDATE,
> +	BPF_DUMP_QUERY,
>  };
>  
>  enum bpf_map_type {
> @@ -594,6 +595,18 @@ union bpf_attr {
>  		__u32		old_prog_fd;
>  	} link_update;
>  
> +	struct {
> +		__u32		query_fd;
> +		__u32		flags;
> +		union {
> +			struct {
> +				__aligned_u64	target_proto;
> +				__u32		proto_buf_len;
> +			};
> +			__u32			prog_id;
> +		};
> +	} dump_query;

I think it would be cleaner to use BPF_OBJ_GET_INFO_BY_FD instead of
introducing new command.
