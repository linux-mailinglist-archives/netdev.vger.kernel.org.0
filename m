Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C94C58DBA
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfF0WM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:12:58 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40826 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbfF0WM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 18:12:58 -0400
Received: by mail-pf1-f196.google.com with SMTP id p184so1897229pfp.7;
        Thu, 27 Jun 2019 15:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=omKdG1SEf1DlswzrHROnkb/YaLBu8whubVZpGxqr6l8=;
        b=IfwkWs04CvjvZHz2zqXh1HunR5OwmQp6SP1biIwYAvvU+WinKartoOziqTpmGokGj6
         28ppdte+/P9oCjEab5YlLHDA073Ghwt/gAT2t7WbhlfLwpcGHU3pIMSuD3UC5mtsA5ee
         y4G/3ZjGbvlCE6g90CC4JG4WuFgGxZ9XU0ux+XS+L1hn13MeRmq6/S2D9afvxk68tEZM
         KS6k5IX08ZR/Jd6VeCbspPdxGF6n1I12sIOpU1fnaWhlzTPnFydiZu8ORpz1UrVxotTn
         dQbw/YrYu1YB2jWB8zrlP+t5l63r4o4lB+EQC0FoZtOnpOg/cPVVhtPFkHWp/bfRvpLz
         6U/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=omKdG1SEf1DlswzrHROnkb/YaLBu8whubVZpGxqr6l8=;
        b=iYp5g6CV/Wxk/0LZYHyPf0QffqdpAh1DMGEXkL+kawy7BCriVZoEeuHtOZ0ZNtII1X
         uh+PSP4zKlX5qmldjytiIz7nGhHGj10aa+RsOZ8l5nRP9VLJd0CL3a4Dh3XXKWvNRfsa
         seGInBQTXp+LD438J0UkWWcQXJ1yIWTW9D2AInQnmgf4quuehsapk0YZQmbQGmgm5CBc
         ftFNOnpdrauZMXuhN2RMknm3hkoacSOQJK6TU8Tx0Ws/KYwJkOTsiyKfzRbWu4782kEm
         twBhvwP14gkjpza0jSwM70yeNzHCjNav0APnaUrSpN6HEul3kTVH7uasnjEs/wRzy6Rn
         zjbQ==
X-Gm-Message-State: APjAAAWR1F1YbInTm0HUWAZiNflop7T6pdx12YOLHrM3g4Bd1TZYz+1N
        NZoiUixMSLDkMlIeDRBiBlQ=
X-Google-Smtp-Source: APXvYqyGeZbkJiS0Dsn3QGHZ6jseIPkfjoJpd43nvrWs2aQ0x2IU3Bw2MKPpGVg19IoUoJ2+3kiGMA==
X-Received: by 2002:a63:2020:: with SMTP id g32mr5946476pgg.90.1561673577422;
        Thu, 27 Jun 2019 15:12:57 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:305a])
        by smtp.gmail.com with ESMTPSA id t4sm127832pgj.20.2019.06.27.15.12.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 15:12:56 -0700 (PDT)
Date:   Thu, 27 Jun 2019 15:12:54 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next v2 2/6] bpf: add BPF_MAP_DUMP command to
 access more than one entry per call
Message-ID: <20190627221253.fjsa2lzog2zs5nyz@ast-mbp.dhcp.thefacebook.com>
References: <20190627202417.33370-1-brianvv@google.com>
 <20190627202417.33370-3-brianvv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627202417.33370-3-brianvv@google.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 01:24:13PM -0700, Brian Vazquez wrote:
> This introduces a new command to retrieve a variable number of entries
> from a bpf map wrapping the existing bpf methods:
> map_get_next_key and map_lookup_elem
> 
> Note that map_dump doesn't guarantee that reading the entire table is
> consistent since this function is always racing with kernel and user code
> but the same behaviour is found when the entire table is walked using
> the current interfaces: map_get_next_key + map_lookup_elem.
> It is also important to note that when a locked map is provided it is
> consistent only for 1 entry at the time, meaning that the buf returned
> might or might not be consistent.

Please explain the api behavior and corner cases in the commit log
or in code comments.

Would it make sense to return last key back into prev_key,
so that next map_dump command doesn't need to copy it from the
buffer?

> Suggested-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Brian Vazquez <brianvv@google.com>
> ---
>  include/uapi/linux/bpf.h |   9 ++++
>  kernel/bpf/syscall.c     | 108 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 117 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index b077507efa3f3..1d753958874df 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -106,6 +106,7 @@ enum bpf_cmd {
>  	BPF_TASK_FD_QUERY,
>  	BPF_MAP_LOOKUP_AND_DELETE_ELEM,
>  	BPF_MAP_FREEZE,
> +	BPF_MAP_DUMP,
>  };
>  
>  enum bpf_map_type {
> @@ -385,6 +386,14 @@ union bpf_attr {
>  		__u64		flags;
>  	};
>  
> +	struct { /* struct used by BPF_MAP_DUMP command */
> +		__u32		map_fd;
> +		__aligned_u64	prev_key;
> +		__aligned_u64	buf;
> +		__aligned_u64	buf_len; /* input/output: len of buf */
> +		__u64		flags;
> +	} dump;
> +
>  	struct { /* anonymous struct used by BPF_PROG_LOAD command */
>  		__u32		prog_type;	/* one of enum bpf_prog_type */
>  		__u32		insn_cnt;
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index a1823a50f9be0..7653346b5cfd1 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1097,6 +1097,111 @@ static int map_get_next_key(union bpf_attr *attr)
>  	return err;
>  }
>  
> +/* last field in 'union bpf_attr' used by this command */
> +#define BPF_MAP_DUMP_LAST_FIELD dump.buf_len
> +
> +static int map_dump(union bpf_attr *attr)
> +{
> +	void __user *ukey = u64_to_user_ptr(attr->dump.prev_key);
> +	void __user *ubuf = u64_to_user_ptr(attr->dump.buf);
> +	u32 __user *ubuf_len = u64_to_user_ptr(attr->dump.buf_len);
> +	int ufd = attr->dump.map_fd;
> +	struct bpf_map *map;
> +	void *buf, *prev_key, *key, *value;
> +	u32 value_size, elem_size, buf_len, cp_len;
> +	struct fd f;
> +	int err;
> +
> +	if (CHECK_ATTR(BPF_MAP_DUMP))
> +		return -EINVAL;
> +
> +	attr->flags = 0;
> +	if (attr->dump.flags & ~BPF_F_LOCK)
> +		return -EINVAL;
> +
> +	f = fdget(ufd);
> +	map = __bpf_map_get(f);
> +	if (IS_ERR(map))
> +		return PTR_ERR(map);
> +	if (!(map_get_sys_perms(map, f) & FMODE_CAN_READ)) {
> +		err = -EPERM;
> +		goto err_put;
> +	}
> +
> +	if ((attr->dump.flags & BPF_F_LOCK) &&
> +	    !map_value_has_spin_lock(map)) {
> +		err = -EINVAL;
> +		goto err_put;
> +	}
> +
> +	if (map->map_type == BPF_MAP_TYPE_QUEUE ||
> +	    map->map_type == BPF_MAP_TYPE_STACK) {
> +		err = -ENOTSUPP;
> +		goto err_put;
> +	}
> +
> +	value_size = bpf_map_value_size(map);
> +
> +	err = get_user(buf_len, ubuf_len);
> +	if (err)
> +		goto err_put;
> +
> +	elem_size = map->key_size + value_size;
> +	if (buf_len < elem_size) {
> +		err = -EINVAL;
> +		goto err_put;
> +	}
> +
> +	if (ukey) {
> +		prev_key = __bpf_copy_key(ukey, map->key_size);
> +		if (IS_ERR(prev_key)) {
> +			err = PTR_ERR(prev_key);
> +			goto err_put;
> +		}
> +	} else {
> +		prev_key = NULL;
> +	}
> +
> +	err = -ENOMEM;
> +	buf = kmalloc(elem_size, GFP_USER | __GFP_NOWARN);
> +	if (!buf)
> +		goto err_put;
> +
> +	key = buf;
> +	value = key + map->key_size;
> +	for (cp_len = 0;  cp_len + elem_size <= buf_len ; cp_len += elem_size) {

checkpatch.pl please.

> +next:
> +		if (signal_pending(current)) {
> +			err = -EINTR;
> +			break;
> +		}
> +
> +		rcu_read_lock();
> +		err = map->ops->map_get_next_key(map, prev_key, key);
> +		rcu_read_unlock();
> +
> +		if (err)
> +			break;

should probably be only for ENOENT case?
and other errors should be returned to user ?

> +
> +		if (bpf_map_copy_value(map, key, value, attr->dump.flags))
> +			goto next;

only for ENOENT as well?
and instead of goto use continue and move cp_len+= to the end after prev_key=key?

> +
> +		if (copy_to_user(ubuf + cp_len, buf, elem_size))
> +			break;

return error to user?

> +
> +		prev_key = key;
> +	}
> +
> +	if (cp_len)
> +		err = 0;

this will mask any above errors if there was at least one element copied.

> +	if (copy_to_user(ubuf_len, &cp_len, sizeof(cp_len)))
> +		err = -EFAULT;
> +	kfree(buf);
> +err_put:
> +	fdput(f);
> +	return err;
> +}
> +
>  #define BPF_MAP_LOOKUP_AND_DELETE_ELEM_LAST_FIELD value
>  
>  static int map_lookup_and_delete_elem(union bpf_attr *attr)
> @@ -2891,6 +2996,9 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
>  	case BPF_MAP_LOOKUP_AND_DELETE_ELEM:
>  		err = map_lookup_and_delete_elem(&attr);
>  		break;
> +	case BPF_MAP_DUMP:
> +		err = map_dump(&attr);
> +		break;
>  	default:
>  		err = -EINVAL;
>  		break;
> -- 
> 2.22.0.410.gd8fdbe21b5-goog
> 
