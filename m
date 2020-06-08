Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8CDB1F1EF8
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 20:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbgFHS2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 14:28:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31704 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725797AbgFHS2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 14:28:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591640891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IbLr2J6FDHf0Fkmf4/ZOeM848ayQBTKmpRU4KI7JnKc=;
        b=YMgwyaXP2yjDxbmbVWRnVNJjL09JBFQur5ml6WPSDcc6H/fxGxvtOuxVRGjZKvN3errEE8
        h3pB/6DV2KxWofKS68DSNCBx6CS34BvSdzEqjwDd/dB5GznbviYb7jy9pUErF9yXT4JTHj
        GqmmG0I2WdXI9k4syV1CGLlCq5sEjV0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-GKsiprAMMdCOWbbIF9l-bQ-1; Mon, 08 Jun 2020 14:28:08 -0400
X-MC-Unique: GKsiprAMMdCOWbbIF9l-bQ-1
Received: by mail-ed1-f72.google.com with SMTP id f13so7218715edv.11
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 11:28:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=IbLr2J6FDHf0Fkmf4/ZOeM848ayQBTKmpRU4KI7JnKc=;
        b=ZdzgR+5K8Yd7nQPhYPBVCewLU/6AnvA8A79cBnh1vQlju0bLg4SbKeFxskKZZ9yODd
         Vw5G+P8GQKBQfYaK7OpC5OT0yByIWZDfEuPYmymiaTMzFK0pGOgzGZpW/SICkJivPCy+
         tB483s28E9hCK9666tEpRFUgtPRqkzmLxJto0KH77E1ESvSgeQ9Jm5WdvocodksPUDoI
         uWJDv0kpXyScvXxj4MfjiwgGVJDV2huXtDoqzhHWDyaJsZKsCxPa9A/xCFWRIMbqlOBF
         ZvArJwVDEsoaYBM2iAMGDG10B/bDH0mFE0aSJT6L4tjG0Awhem39imk4d1+AMHhvCCQZ
         sBrg==
X-Gm-Message-State: AOAM532fMSz1jkJSsscpmSsvxr4rieG8qxStXDYFf2QowmfcyHtPJkdy
        agsLZ/K3a3u+CRJiLKaVkaLcrRT6iinOzMFE4ztJ7foqXnNUyJsdXD7+qTu7J4ay7wz0v8QtkAg
        Bqaf0bHDDLcZgbpSy
X-Received: by 2002:a05:6402:1767:: with SMTP id da7mr23634384edb.90.1591640885721;
        Mon, 08 Jun 2020 11:28:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzL8znvYhy+UvZ9XzZqPbj1o2xyh3+gvCRPaBL+2jcvFUOCwjH3Co76DIvklu2g8VhC7SkgOw==
X-Received: by 2002:a05:6402:1767:: with SMTP id da7mr23634358edb.90.1591640885452;
        Mon, 08 Jun 2020 11:28:05 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id fw16sm11304172ejb.55.2020.06.08.11.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 11:28:04 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3285018200D; Mon,  8 Jun 2020 20:28:03 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@gmail.com>, bpf@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH bpf 1/3] bpf: syscall to start at file-descriptor 1
In-Reply-To: <159163507753.1967373.62249862728421448.stgit@firesoul>
References: <159163498340.1967373.5048584263152085317.stgit@firesoul> <159163507753.1967373.62249862728421448.stgit@firesoul>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 08 Jun 2020 20:28:03 +0200
Message-ID: <875zc1cszw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> This patch change BPF syscall to avoid returning file descriptor value zero.
>
> As mentioned in cover letter, it is very impractical when extending kABI
> that the file-descriptor value 'zero' is valid, as this requires new fields
> must be initialised as minus-1. First step is to change the kernel such that
> BPF-syscall simply doesn't return value zero as a FD number.
>
> This patch achieves this by similar code to anon_inode_getfd(), with the
> exception of getting unused FD starting from 1. The kernel already supports
> starting from a specific FD value, as this is used by f_dupfd(). It seems
> simpler to replicate part of anon_inode_getfd() code and use this start from
> offset feature, instead of using f_dupfd() handling afterwards.
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  fs/file.c            |    2 +-
>  include/linux/file.h |    1 +
>  kernel/bpf/syscall.c |   38 ++++++++++++++++++++++++++++++++------
>  3 files changed, 34 insertions(+), 7 deletions(-)
>
> diff --git a/fs/file.c b/fs/file.c
> index abb8b7081d7a..122185cb7707 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -535,7 +535,7 @@ int __alloc_fd(struct files_struct *files,
>  	return error;
>  }
>  
> -static int alloc_fd(unsigned start, unsigned flags)
> +int alloc_fd(unsigned start, unsigned flags)

Missing an EXPORT_SYMBOL() to go with this.

>  {
>  	return __alloc_fd(current->files, start, rlimit(RLIMIT_NOFILE), flags);
>  }
> diff --git a/include/linux/file.h b/include/linux/file.h
> index 122f80084a3e..927fb6c2582d 100644
> --- a/include/linux/file.h
> +++ b/include/linux/file.h
> @@ -85,6 +85,7 @@ extern int f_dupfd(unsigned int from, struct file *file, unsigned flags);
>  extern int replace_fd(unsigned fd, struct file *file, unsigned flags);
>  extern void set_close_on_exec(unsigned int fd, int flag);
>  extern bool get_close_on_exec(unsigned int fd);
> +extern int alloc_fd(unsigned start, unsigned flags);
>  extern int __get_unused_fd_flags(unsigned flags, unsigned long nofile);
>  extern int get_unused_fd_flags(unsigned flags);
>  extern void put_unused_fd(unsigned int fd);
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 4d530b1d5683..6eba236aacd1 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -688,6 +688,32 @@ const struct file_operations bpf_map_fops = {
>  	.poll		= bpf_map_poll,
>  };
>  
> +/* Code is similar to anon_inode_getfd(), except starts at FD 1 */
> +int bpf_anon_inode_getfd(const char *name, const struct file_operations *fops,
> +			 void *priv, int flags)
> +{

I think it's a little sad that we have to essentially re-implement
anon_inode_getfd(). I guess an alternative could be to add an extra
parameter to the existing function, either with a different name and a
wrapper function, or just change all the callers (by my count there are
only 13 call sites outside of BPF). Not sure if that is better, though?

> +	int error, fd;
> +	struct file *file;
> +
> +	error = alloc_fd(1, flags);
> +	if (error < 0)
> +		return error;
> +	fd = error;
> +
> +	file = anon_inode_getfile(name, fops, priv, flags);
> +	if (IS_ERR(file)) {
> +		error = PTR_ERR(file);
> +		goto err_put_unused_fd;
> +	}
> +	fd_install(fd, file);
> +
> +	return fd;
> +
> +err_put_unused_fd:
> +	put_unused_fd(fd);
> +	return error;
> +}
> +
>  int bpf_map_new_fd(struct bpf_map *map, int flags)
>  {
>  	int ret;
> @@ -696,8 +722,8 @@ int bpf_map_new_fd(struct bpf_map *map, int flags)
>  	if (ret < 0)
>  		return ret;
>  
> -	return anon_inode_getfd("bpf-map", &bpf_map_fops, map,
> -				flags | O_CLOEXEC);
> +	return bpf_anon_inode_getfd("bpf-map", &bpf_map_fops, map,
> +				    flags | O_CLOEXEC);
>  }
>  
>  int bpf_get_file_flag(int flags)
> @@ -1840,8 +1866,8 @@ int bpf_prog_new_fd(struct bpf_prog *prog)
>  	if (ret < 0)
>  		return ret;
>  
> -	return anon_inode_getfd("bpf-prog", &bpf_prog_fops, prog,
> -				O_RDWR | O_CLOEXEC);
> +	return bpf_anon_inode_getfd("bpf-prog", &bpf_prog_fops, prog,
> +				    O_RDWR | O_CLOEXEC);
>  }
>  
>  static struct bpf_prog *____bpf_prog_get(struct fd f)
> @@ -2471,7 +2497,7 @@ int bpf_link_settle(struct bpf_link_primer *primer)
>  
>  int bpf_link_new_fd(struct bpf_link *link)
>  {
> -	return anon_inode_getfd("bpf-link", &bpf_link_fops, link, O_CLOEXEC);
> +	return bpf_anon_inode_getfd("bpf-link", &bpf_link_fops, link, O_CLOEXEC);
>  }
>  
>  struct bpf_link *bpf_link_get_from_fd(u32 ufd)
> @@ -4024,7 +4050,7 @@ static int bpf_enable_runtime_stats(void)
>  		return -EBUSY;
>  	}
>  
> -	fd = anon_inode_getfd("bpf-stats", &bpf_stats_fops, NULL, O_CLOEXEC);
> +	fd = bpf_anon_inode_getfd("bpf-stats", &bpf_stats_fops, NULL, O_CLOEXEC);
>  	if (fd >= 0)
>  		static_key_slow_inc(&bpf_stats_enabled_key.key);
>  

I guess you should also fix __btf_new_fd() in btf.c?

