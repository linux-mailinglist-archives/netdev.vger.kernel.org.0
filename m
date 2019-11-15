Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88796FE681
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 21:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfKOUnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 15:43:02 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40272 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726991AbfKOUnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 15:43:02 -0500
Received: by mail-lf1-f66.google.com with SMTP id j26so8972048lfh.7
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 12:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=t1kmXn3DyN+oFbpE0GUcOMwvt7CaLBdPQtzGMkEvuuo=;
        b=L4BOM+ma7vZ+5IMmlzYDyPuXeIG8inY6qKkKLmdIa6fwTU1Oox/CRwFDH6cEUwPHvn
         gUhmjArFefBw2iBF0sXANS3OtgQ9ldypJP+hiBYPfEslHky01GluebRRvCmT64ajDOd9
         W1SQkD+Mryy7+KtbKHkBoaLJRcO/GVJZX6ez7FQKD7XRFxdq3Z/lXV7wrAku7l6OZaQQ
         t9qIEEnzXTQaz63YQainhYftsVm15y8xLJ0dwDHCsSN4Z9HZj6cr8Dz7xV9D7Ks+KU23
         aY3lg9rfRbycQaoDe2H0h6YeiLJ03jXx/1FdYNhWl3uD39HDxc0e/B8NNRvF3UMHlI/1
         x06w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=t1kmXn3DyN+oFbpE0GUcOMwvt7CaLBdPQtzGMkEvuuo=;
        b=f6ACs/rmBjaY8IsqLReAkc3smtNXt4F6XgKaoejhERHs7+XnesBPGVNi3IMMKd1B6+
         PcvznLbYqvVIqjEW6d0qbmz4GrpjCFey1fDgK7/3B8ANgUsfgnJkak9X8J0OznZKCFXV
         C2Mdr+qJtAZ8Myl+QCCOkOZeoCN5t6fvFUcRgUTBTYcY7xODBDf7ELq90y/+mDDti3/5
         S23VcN3/bk0pDAVYJ/Vtn83LJw4pMjr0gNTDvxwcd0/BGh5SWkxz1XWBXxXeQduT4blw
         ObUd/Y6WD5TgcboWJPl77pTIns3jdo41PHavzJ5i5c1D9JPKzuWV7Q+f3uk7UlDGblYx
         rzHg==
X-Gm-Message-State: APjAAAXi+QTk86KHj5yImcTJBumPU7PTZEDqKHiI83UcXSzmA1Z0YJPD
        GLfePOtXMsdTQHLBZCW80FZFHw==
X-Google-Smtp-Source: APXvYqxfIcKVLtbBh2FpSLw2e7hTrC36NJile3EdMyK78ZMtjgyZxfmfvXXqKdVHw+zm2Tv0rY9Dfw==
X-Received: by 2002:a19:cb4a:: with SMTP id b71mr12475061lfg.90.1573850579868;
        Fri, 15 Nov 2019 12:42:59 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 30sm4539202ljw.29.2019.11.15.12.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 12:42:59 -0800 (PST)
Date:   Fri, 15 Nov 2019 12:42:49 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH v4 bpf-next 2/4] bpf: add mmap() support for
 BPF_MAP_TYPE_ARRAY
Message-ID: <20191115124249.0ad3496d@cakuba.netronome.com>
In-Reply-To: <CAEf4Bzat=GDcZWWpGkPWYBJvpKA=PvhhP0QZrEcOOkQz3WvnaA@mail.gmail.com>
References: <20191115040225.2147245-1-andriin@fb.com>
        <20191115040225.2147245-3-andriin@fb.com>
        <20191115044518.sqh3y3bwtjfp5zex@ast-mbp.dhcp.thefacebook.com>
        <CAEf4BzbE+1s_4=jpWEgNj+T0HyMXt1yjiRncq4sB3vfx6A3Sxw@mail.gmail.com>
        <20191115050824.76gmttbxd32jnnhb@ast-mbp.dhcp.thefacebook.com>
        <CAEf4BzbsJSEgnW14F7Xt+E911NC_ZqEUeLg0pxrUbaoj1Zzkyg@mail.gmail.com>
        <CAEf4Bzat=GDcZWWpGkPWYBJvpKA=PvhhP0QZrEcOOkQz3WvnaA@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Nov 2019 08:36:56 -0800, Andrii Nakryiko wrote:
> Alternatively we can use spinlock. I don't think it's too ugly, tbh. See below.
> 
> From 0da495b911adad495857f1c0fc3596f1d06a705f Mon Sep 17 00:00:00 2001
> From: Andrii Nakryiko <andriin@fb.com>
> Date: Fri, 15 Nov 2019 08:32:43 -0800
> Subject: [PATCH bpf-next] bpf: switch freeze locking to use spin_lock and save
>  space
> 
> Switch to spin_lock in favor of mutex. Due to mmap-ing itself happening not
> under spinlock, there needs to be an extra "correction" step for writecnt, if
> mapping fails.

FWIW I was pondering that too, and thought your initial design was
nicer, the transient errors sometimes become a major PITA.
