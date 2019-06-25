Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8CD5596B
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfFYUv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:51:58 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44470 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbfFYUv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:51:57 -0400
Received: by mail-pl1-f195.google.com with SMTP id t7so81474plr.11
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 13:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wCQSXu82F8swe3D8zKchpQAEcIuhNWcT3wFgqF0lcmg=;
        b=vvVvvYS1D6bTfm3V0SkI9Iu9XBsPCKVuGVYF9EfBh1rQy9pyK4a1HJ4ysUUvLfSNBw
         zKwKahmHkHm35dGwS+QgphBZ/2KH3/BNlw68snLuSNdacu7xoVstFldlfLTk6ZHguud7
         J3yXQs7Pev2UPaJuRlIDuXAF/ip3EuXT5ki9D7eg/tjoe3IVGO5+8I5W+jYGMi/I94lR
         1onEJgmyMkyn46GCKqGbAuSVxudNnTxrpDnmfatxojUQ5cOHR6uVw3UF+H6pGuXSoHAD
         Aqhgj1cD07x/mVk7q8ptYaLHqs+GvyEi/JeSXV/JAJTB3g2WBvVe/COeFTAVX6Dkb83G
         X26A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wCQSXu82F8swe3D8zKchpQAEcIuhNWcT3wFgqF0lcmg=;
        b=fKPeCUaxwsiYNkFud7PtTCedWNgjr17YZs/os103NhUTiIOQ0YahrrV5/7wAdVjSZQ
         xDNG51n9eMFZ+RSeUYRSD0UldqMMYF98TIUrIJQkRT6pADWlyGsznXp5nMzUofTENUKP
         NQoHKlWLogvFzYR5tuiMmFbQCt/GS2XZR55O3PwZHJm1Fa+fitX1VgXvLTi6HBJL0L8K
         tjmyFmlOo7DExWanbfn64Th5bUGHpxKSHOPhEdZfXpeThttAW/iMohJWzsSTRTZXzgHO
         IHE4aBgMc5kXho1U2XB+ApZH91HuHMH8hwIzRGwAP3cYTEp6kk0d8BdKMwQ6N24XnrLy
         6Hjw==
X-Gm-Message-State: APjAAAVGNy4huSojrgEHM00zJhYFisRHzxl24r137Vq4Refrg4yGGHVU
        PE4l2GylO6THvorHYMEn35xgSA==
X-Google-Smtp-Source: APXvYqxC/xbDefs4n8RaoUgrO9qzmlqNXunS97/ifDGMxA4uSeWxHh05FoEgboOrPn0EbHaW04nX5A==
X-Received: by 2002:a17:902:d695:: with SMTP id v21mr670784ply.342.1561495917181;
        Tue, 25 Jun 2019 13:51:57 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id b11sm12981846pfd.18.2019.06.25.13.51.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 13:51:56 -0700 (PDT)
Date:   Tue, 25 Jun 2019 13:51:55 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Song Liu <songliubraving@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 0/4] sys_bpf() access control via /dev/bpf
Message-ID: <20190625205155.GD10487@mini-arch>
References: <20190625182303.874270-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625182303.874270-1-songliubraving@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/25, Song Liu wrote:
> Currently, most access to sys_bpf() is limited to root. However, there are
> use cases that would benefit from non-privileged use of sys_bpf(), e.g.
> systemd.
> 
> This set introduces a new model to control the access to sys_bpf(). A
> special device, /dev/bpf, is introduced to manage access to sys_bpf().
> Users with access to open /dev/bpf will be able to access most of
> sys_bpf() features. The use can get access to sys_bpf() by opening /dev/bpf
> and use ioctl to get/put permission.
> 
> The permission to access sys_bpf() is marked by bit TASK_BPF_FLAG_PERMITTED
> in task_struct. During fork(), child will not inherit this bit.
2c: if we are going to have an fd, I'd vote for a proper fd based access
checks instead of a per-task flag, so we can do:
	ioctl(fd, BPF_MAP_CREATE, uattr, sizeof(uattr))

(and pass this fd around)

I do understand that it breaks current assumptions that libbpf has,
but maybe we can extend _xattr variants to accept optinal fd (and try
to fallback to sysctl if it's absent/not working)?

> libbpf APIs libbpf_[get|put]_bpf_permission() are added to help get and
> put the permission. bpftool is updated to use these APIs.
> 
> Song Liu (4):
>   bpf: unprivileged BPF access via /dev/bpf
>   bpf: sync tools/include/uapi/linux/bpf.h
>   libbpf: add libbpf_[get|put]_bpf_permission()
>   bpftool: use libbpf_[get|put]_bpf_permission()
> 
>  Documentation/ioctl/ioctl-number.txt |  1 +
>  include/linux/bpf.h                  | 12 +++++
>  include/linux/sched.h                |  8 ++++
>  include/uapi/linux/bpf.h             |  5 ++
>  kernel/bpf/arraymap.c                |  2 +-
>  kernel/bpf/cgroup.c                  |  2 +-
>  kernel/bpf/core.c                    |  4 +-
>  kernel/bpf/cpumap.c                  |  2 +-
>  kernel/bpf/devmap.c                  |  2 +-
>  kernel/bpf/hashtab.c                 |  4 +-
>  kernel/bpf/lpm_trie.c                |  2 +-
>  kernel/bpf/offload.c                 |  2 +-
>  kernel/bpf/queue_stack_maps.c        |  2 +-
>  kernel/bpf/reuseport_array.c         |  2 +-
>  kernel/bpf/stackmap.c                |  2 +-
>  kernel/bpf/syscall.c                 | 72 +++++++++++++++++++++-------
>  kernel/bpf/verifier.c                |  2 +-
>  kernel/bpf/xskmap.c                  |  2 +-
>  kernel/fork.c                        |  4 ++
>  net/core/filter.c                    |  6 +--
>  tools/bpf/bpftool/feature.c          |  2 +-
>  tools/bpf/bpftool/main.c             |  5 ++
>  tools/include/uapi/linux/bpf.h       |  5 ++
>  tools/lib/bpf/libbpf.c               | 54 +++++++++++++++++++++
>  tools/lib/bpf/libbpf.h               |  7 +++
>  tools/lib/bpf/libbpf.map             |  2 +
>  26 files changed, 178 insertions(+), 35 deletions(-)
> 
> --
> 2.17.1
