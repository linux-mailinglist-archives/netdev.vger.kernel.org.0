Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D131CB612
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 19:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgEHRcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 13:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbgEHRcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 13:32:53 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62700C061A0C;
        Fri,  8 May 2020 10:32:53 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id h26so1926535qtu.8;
        Fri, 08 May 2020 10:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8u1vbu5bJ69YihL8GWipXODDQVOvMStlxTqzIrRkPUQ=;
        b=CevGhA3drB9rx9GAhf7Jd40EnNtr3XglCd18jTPTpJsgn56s0Q9ZugmY0aQqMnSGTH
         7aagHQfF3X78TVXApqMaxjd66mhtOXvmL/4HYUWJW/adXA8e8n5GfPBPmQNAL19OfDE5
         LKmSVl8km7PxkynymVQEPV4lk577a7G6pryLd8OTLGPtsbCEaAV29/jnVDoGOchK+oXF
         ADZkHhl+hkYYLZCeFVTd3IXBBgi7Vcs9qr0dwPmfQ9/ULwOPvDSa/PgxDmkfuyvSzJ6H
         sC+yukRWl+pPdTIl3k+mflFAJ1SndgezVfhRdzQGFW2qCsOZjs94dn27Zb6+yY1dofoM
         xFPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8u1vbu5bJ69YihL8GWipXODDQVOvMStlxTqzIrRkPUQ=;
        b=RN422PLdjE8go6AuR72FJuTgiBzmtnpYBWzaGZYP3BNaZGF4ofuRufgeE4QXVRyFXS
         wT6Uqp4sZb8OzRfgzSlVEHpCPSzJHK4+SX0n2pLrZTG7qjNKk0W3Rvri0CJYSilJXc/H
         4kL8nlGnSVgj6O0wEhLFBWL3sMvvQtsNBfHfbyLPqFUpfCXSsojm9Bi/u2vKBWbxJyUZ
         5Rbzwv+mK39nx495fsByG58gzAwTOXGSK9UwSEBZJuJ1VYo5iWkDVYK3k/kBBMfEoXM6
         eR17In0P35gkRK9xxc8aYddKHScusjFhJYNdGmUDIIBnISNwRrS1TqFdXqG+HzTdAwDP
         E0kA==
X-Gm-Message-State: AGi0PuZ/W84N46cblyjD6WQwXcQ/wTq7XnqgYu3XaKJNd1Qcr0JiEJ15
        xLZnwcQyn9sZVQX4X0JqcqDx0CoSRnww8Z3Mk1kJPgN0
X-Google-Smtp-Source: APiQypI1ltj7u5Bq7am8qePoEo4cQ/trbraNCdyogcK0LAAg4BY0jq2I7/GsLnM1GzSePjDroYbXz+4CAgFA1/GrFDU=
X-Received: by 2002:ac8:51d3:: with SMTP id d19mr4033765qtn.141.1588959172426;
 Fri, 08 May 2020 10:32:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200508153634.249933-1-hch@lst.de> <20200508153634.249933-5-hch@lst.de>
In-Reply-To: <20200508153634.249933-5-hch@lst.de>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 10:32:41 -0700
Message-ID: <CAEf4BzZ-gE87RVLPHGBfoNhHB+H7AnPbb7UUE7EGq8T5p_en_w@mail.gmail.com>
Subject: Re: [PATCH 04/12] bpf: use __anon_inode_getfd
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-integrity@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 8:39 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Use __anon_inode_getfd instead of opencoding the logic using
> get_unused_fd_flags + anon_inode_getfile.  Also switch the
> bpf_link_new_file calling conventions to match __anon_inode_getfd.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/bpf.h  |  2 +-
>  kernel/bpf/cgroup.c  |  6 +++---
>  kernel/bpf/syscall.c | 31 +++++++++----------------------
>  3 files changed, 13 insertions(+), 26 deletions(-)
>

[...]

> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 64783da342020..cb2364e17423c 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2307,23 +2307,10 @@ int bpf_link_new_fd(struct bpf_link *link)
>   * complicated and expensive operations and should be delayed until all the fd
>   * reservation and anon_inode creation succeeds.
>   */

The comment above explains the reason why we do want to split getting
fd, getting file, and installing fd later. I'd like to keep it this
way. Also, this code was refactored in bpf-next by [0] (it still uses
get_unused_fd_flag + anon_inode_getfile + fd_install, by design).

  [0] https://patchwork.ozlabs.org/project/netdev/patch/20200429001614.1544-3-andriin@fb.com/

> -struct file *bpf_link_new_file(struct bpf_link *link, int *reserved_fd)
> +int bpf_link_new_file(struct bpf_link *link, struct file **file)
>  {
> -       struct file *file;
> -       int fd;
> -
> -       fd = get_unused_fd_flags(O_CLOEXEC);
> -       if (fd < 0)
> -               return ERR_PTR(fd);
> -
> -       file = anon_inode_getfile("bpf_link", &bpf_link_fops, link, O_CLOEXEC);
> -       if (IS_ERR(file)) {
> -               put_unused_fd(fd);
> -               return file;
> -       }
> -
> -       *reserved_fd = fd;
> -       return file;
> +       return __anon_inode_getfd("bpf_link", &bpf_link_fops, link, O_CLOEXEC,
> +                       file);
>  }
>

[...]
