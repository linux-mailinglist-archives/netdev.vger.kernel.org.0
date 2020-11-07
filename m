Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F03B2AA5C3
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 15:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgKGOJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 09:09:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbgKGOJH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 09:09:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1D20206ED;
        Sat,  7 Nov 2020 14:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604758145;
        bh=AUgdj6qEYGv+IS22xMj9tBmorA9YrVTkTbR5qGCgL7w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eDkkfQkcwyt9QE7MW2OwvKeDamswGdj01mvYcfwUm441YfYyIRedM3ldVfLT7IMBl
         ciuyBks10dmVvMXMMCtS2gP8oklY2D5thp3jMrEAIf5rtxI6Xcs9o9soa1/b7u2rBA
         Xi+EJvN0a4PUa437e1lzqKMpsJCHkKTWhpI7ZYpg=
Date:   Sat, 7 Nov 2020 15:09:01 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com,
        linux-kernel@vger.kernel.org, rafael@kernel.org, jeyu@kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH v2 bpf-next 4/5] bpf: load and verify kernel module BTFs
Message-ID: <20201107140901.GA28983@kroah.com>
References: <20201106230228.2202-1-andrii@kernel.org>
 <20201106230228.2202-5-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106230228.2202-5-andrii@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 06, 2020 at 03:02:27PM -0800, Andrii Nakryiko wrote:
> Add kernel module listener that will load/validate and unload module BTF.
> Module BTFs gets ID generated for them, which makes it possible to iterate
> them with existing BTF iteration API. They are given their respective module's
> names, which will get reported through GET_OBJ_INFO API. They are also marked
> as in-kernel BTFs for tooling to distinguish them from user-provided BTFs.
> 
> Also, similarly to vmlinux BTF, kernel module BTFs are exposed through
> sysfs as /sys/kernel/btf/<module-name>. This is convenient for user-space
> tools to inspect module BTF contents and dump their types with existing tools:
> 
> [vmuser@archvm bpf]$ ls -la /sys/kernel/btf
> total 0
> drwxr-xr-x  2 root root       0 Nov  4 19:46 .
> drwxr-xr-x 13 root root       0 Nov  4 19:46 ..
> 
> ...
> 
> -r--r--r--  1 root root     888 Nov  4 19:46 irqbypass
> -r--r--r--  1 root root  100225 Nov  4 19:46 kvm
> -r--r--r--  1 root root   35401 Nov  4 19:46 kvm_intel
> -r--r--r--  1 root root     120 Nov  4 19:46 pcspkr
> -r--r--r--  1 root root     399 Nov  4 19:46 serio_raw
> -r--r--r--  1 root root 4094095 Nov  4 19:46 vmlinux
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  Documentation/ABI/testing/sysfs-kernel-btf |   8 +
>  include/linux/bpf.h                        |   2 +
>  include/linux/module.h                     |   4 +
>  kernel/bpf/btf.c                           | 194 +++++++++++++++++++++
>  kernel/bpf/sysfs_btf.c                     |   2 +-
>  kernel/module.c                            |  32 ++++
>  6 files changed, 241 insertions(+), 1 deletion(-)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
