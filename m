Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A126F107668
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 18:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfKVRZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 12:25:35 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:35251 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKVRZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 12:25:35 -0500
Received: by mail-pj1-f66.google.com with SMTP id s8so3312484pji.2;
        Fri, 22 Nov 2019 09:25:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=UaL62kWewKJMZ0i1SVqxDkLUi869qgCOxt0DnZYcMGg=;
        b=EjVD0toRMvRNtvFyeoK8dxq0ijoA3W52VPDr9yvCLjryYQmqdCdpvWZv4yu+c5alPo
         taH/G7simG5Ck9s4DUh5QI4uIyllt7SWfMgRqkUTgBzDP8UgDObfkjACaJzEahzCsrnE
         HH5lwxUo05Df8hm+eZDiVDV9DPmQ+MIw57lGU2mbJ/8wO4U/2mUdQQuXpNYmsCuWrrQO
         o8F4yRFu1M99HPaOpK1JJ+Fh5w6/tuXRkewn+SEphUKrqPT8CCnLua0p6Fz9k8WTi6WO
         VaKk4YQtTWCAFysam+7d9QN5xdKfvoM6jVScPVqgKuEssfkI/9viVhQkqNXjOjRpJpAe
         3L5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=UaL62kWewKJMZ0i1SVqxDkLUi869qgCOxt0DnZYcMGg=;
        b=fcwJXYIAY2V4ujjadRkigJ+CTknoODOd/8CpK5VJZ8DfSZzgnsEJgQEOfs9LxbTwAi
         5DrfNCPIXWsaNIKfNeV1hcCn5KBXY02HG9s7tLXIdoNDJDhBuwC1tsBZIFe71/OicMuN
         wgJ6HykYvRJcaWREPT1zeOzOe757IowZ8DixZ2IFy82630a3MEfSqtzciKtZeHi9jyvk
         /q5OxsrEQI7gUg9ouQSRP0jl6cv4GvpXw1vR3EAV/K+ebxfgGS5lSILbzEQwQn8NMc8L
         VYIeewPHl1+YO0T33zOKKXSHzgV1k1Qh1O/Sc977X8mheATGmFDkC7K0mVtMEsaciuyZ
         hx0w==
X-Gm-Message-State: APjAAAWlaKMueFm9D3Skuzh92vvsYmng+fb5EZtaUQt2lBkVHqLU9Z3t
        WLcjxrLNj2Gnt4d7Fyu4Mls=
X-Google-Smtp-Source: APXvYqzpZ8cfQ+HrlvcOp5Gu3CXqChZ4cPowljvEGtxYcNfVJsco2Nj5syob5DmURTrA3rqXiea+9w==
X-Received: by 2002:a17:90a:a63:: with SMTP id o90mr20175839pjo.81.1574443533903;
        Fri, 22 Nov 2019 09:25:33 -0800 (PST)
Received: from localhost (198-0-60-179-static.hfc.comcastbusiness.net. [198.0.60.179])
        by smtp.gmail.com with ESMTPSA id x190sm8140281pfc.89.2019.11.22.09.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 09:25:33 -0800 (PST)
Date:   Fri, 22 Nov 2019 09:25:32 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Yonghong Song <yhs@fb.com>, Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Brian Vazquez <brianvv@google.com>
Message-ID: <5dd81a0ca016a_690a2ae784a225c459@john-XPS-13-9370.notmuch>
In-Reply-To: <20191119193036.92831-3-brianvv@google.com>
References: <20191119193036.92831-1-brianvv@google.com>
 <20191119193036.92831-3-brianvv@google.com>
Subject: RE: [PATCH v2 bpf-next 2/9] bpf: add generic support for lookup and
 lookup_and_delete batch ops
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Brian Vazquez wrote:
> This commit introduces generic support for the bpf_map_lookup_batch and
> bpf_map_lookup_and_delete_batch ops. This implementation can be used by
> almost all the bpf maps since its core implementation is relying on the
> existing map_get_next_key, map_lookup_elem and map_delete_elem
> functions. The bpf syscall subcommands introduced are:
> 
>   BPF_MAP_LOOKUP_BATCH
>   BPF_MAP_LOOKUP_AND_DELETE_BATCH
> 
> The UAPI attribute is:
> 
>   struct { /* struct used by BPF_MAP_*_BATCH commands */
>          __aligned_u64   in_batch;       /* start batch,
>                                           * NULL to start from beginning
>                                           */
>          __aligned_u64   out_batch;      /* output: next start batch */
>          __aligned_u64   keys;
>          __aligned_u64   values;
>          __u32           count;          /* input/output:
>                                           * input: # of key/value
>                                           * elements
>                                           * output: # of filled elements
>                                           */
>          __u32           map_fd;
>          __u64           elem_flags;
>          __u64           flags;
>   } batch;
> 
> in_batch/out_batch are opaque values use to communicate between
> user/kernel space, in_batch/out_batch must be of key_size length.
> 
> To start iterating from the beginning in_batch must be null,
> count is the # of key/value elements to retrieve. Note that the 'keys'
> buffer must be a buffer of key_size * count size and the 'values' buffer
> must be value_size * count, where value_size must be aligned to 8 bytes
> by userspace if it's dealing with percpu maps. 'count' will contain the
> number of keys/values successfully retrieved. Note that 'count' is an
> input/output variable and it can contain a lower value after a call.
> 
> If there's no more entries to retrieve, ENOENT will be returned. If error
> is ENOENT, count might be > 0 in case it copied some values but there were
> no more entries to retrieve.
> 
> Note that if the return code is an error and not -EFAULT,
> count indicates the number of elements successfully processed.
> 
> Suggested-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Brian Vazquez <brianvv@google.com>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h      |  11 +++
>  include/uapi/linux/bpf.h |  19 +++++
>  kernel/bpf/syscall.c     | 176 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 206 insertions(+)
> 

Couple additional comments if we are getting a new rev anyways 

[...]

> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index cc714c9d5b4cc..d0d3d0e0eaca4 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1127,6 +1127,124 @@ static int map_get_next_key(union bpf_attr *attr)
>  	return err;
>  }
>  
> +static int __generic_map_lookup_batch(struct bpf_map *map,
> +				      const union bpf_attr *attr,
> +				      union bpf_attr __user *uattr,
> +				      bool do_delete)
> +{
> +	void __user *ubatch = u64_to_user_ptr(attr->batch.in_batch);
> +	void __user *uobatch = u64_to_user_ptr(attr->batch.out_batch);
> +	void __user *values = u64_to_user_ptr(attr->batch.values);
> +	void __user *keys = u64_to_user_ptr(attr->batch.keys);
> +	void *buf, *prev_key, *key, *value;
> +	u32 value_size, cp, max_count;
> +	bool first_key = false;
> +	int err, retry = 3;
                 ^^^^^^^^^^
define magic value maybe MAP_LOOKUP_RETRIES
> +
> +	if (attr->batch.elem_flags & ~BPF_F_LOCK)
> +		return -EINVAL;
> +	}

[...]

> +
> +	value_size = bpf_map_value_size(map);
> +
> +	max_count = attr->batch.count;
> +	if (!max_count)
> +		return 0;
> +
> +	err = -ENOMEM;
> +	buf = kmalloc(map->key_size + value_size, GFP_USER | __GFP_NOWARN);

Should we also set __GFP_NORETRY or __GFP_RETRY_MAYFAIL perhaps?

> +	if (!buf)
> +		goto err_put;
> +
> +	err = -EFAULT;
> +	first_key = false;
> +	if (ubatch && copy_from_user(buf, ubatch, map->key_size))
> +		goto free_buf;
> +	key = buf;
> +	value = key + map->key_size;
> +	if (!ubatch) {
> +		prev_key = NULL;
> +		first_key = true;
> +	}
> +
> +

nit: extra newline not needed

> +	for (cp = 0; cp < max_count; cp++) {
> +		if (cp || first_key) {
> +			rcu_read_lock();
> +			err = map->ops->map_get_next_key(map, prev_key, key);
> +			rcu_read_unlock();
> +			if (err)
> +				break;
> +		}
> +		err = bpf_map_copy_value(map, key, value,
> +					 attr->batch.elem_flags, do_delete);
> +
> +		if (err == -ENOENT) {
> +			if (retry) {
> +				retry--;
> +				continue;
> +			}
> +			err = -EINTR;
> +			break;
> +		}
> +
> +		if (err)
> +			goto free_buf;
> +
> +		if (copy_to_user(keys + cp * map->key_size, key,
> +				 map->key_size)) {
> +			err = -EFAULT;
> +			goto free_buf;
> +		}
> +		if (copy_to_user(values + cp * value_size, value, value_size)) {
> +			err = -EFAULT;
> +			goto free_buf;

You could do the same here as in the retry==0 above case, break and report
back up to user cp values?

> +		}
> +
> +		prev_key = key;
> +		retry = 3;
                ^^^^^^^^^
same nit as above, use define so we can tune this if needed.

> +	}
> +	if (!err) {
> +		rcu_read_lock();
> +		err = map->ops->map_get_next_key(map, prev_key, key);
> +		rcu_read_unlock();
> +	}
> +
> +	if ((copy_to_user(&uattr->batch.count, &cp, sizeof(cp)) ||
> +		    (copy_to_user(uobatch, key, map->key_size))))
> +		err = -EFAULT;
> +
> +free_buf:
> +	kfree(buf);
> +err_put:
> +	return err;
> +}
