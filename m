Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F60201F86
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 03:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731517AbgFTBqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 21:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731506AbgFTBqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 21:46:18 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C673AC0613EE
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 18:46:16 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id a6so815726wmm.0
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 18:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ko+VujLUWbzJ7NWaZ7oUZgBjXDF0cE6d6Vn+/QjIizw=;
        b=hRfTAJAx0WS4t6gfz1US62xDp+BxkluGX5MirFMKdcAXseKPd3SWSi5cIotLxKj/SV
         pxxGWzrQAX3eYfkhK1zf5O4zk0hxhEe0gSVdBC4Rc1lJghqyRybxHxkSeFQ/UTR9vZKa
         G1C88NjjQsgfQ2pWD5bBxMxVXGG66Trmk17wKyMNYEMBoD1wR1b5eKAdutzYSkC8uWUH
         vOq7pHu8x+RBuuXKOKu5suGvqY03sYpc/UqdKeWGv5xw7f3tN881m/lEEz9e2P1Er5PJ
         Nx7+wxCcK7zV+BI7HHJF0rIJgGb/z943X60fAogP6STaKSxTf+wAy3zDvw1bv4inHjKy
         SAKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ko+VujLUWbzJ7NWaZ7oUZgBjXDF0cE6d6Vn+/QjIizw=;
        b=AM8BgghJUM/XbG6VuZHoO51/x5enQAcTKFwMs/yxI2mnXlK3QUm+zMMrZaRVtUnztM
         vkhN8/aTLHa8hsZYqCatI7+8e6/4z8WircCnBgiHCQT4M/5O1HotJC5mUfM9rPlkN+/z
         7cESZaVeg6hmWugcnvx8BI6sQFLwCwCW49VrUmmUAhdEwoasjcgRs1yLBtQ6P82Iurv4
         alC1neigED4nut1oyOidO8ijvf/9tew2GesQCuq5iAOwGrggFE8mYKpxbNjnkg/N+QVB
         QIs1MBYBdxc7SGAPIUGwFKN8CAu6ukdHe1Pkvq2tqF3E2MdCLj6INb2R6in6VK8XQ4is
         ysCw==
X-Gm-Message-State: AOAM533ZxYrA9LieE202lV8w1szS40pI/SJU3s9tDe1pm9lwQ1nZ/Rpd
        xKt6XGrxhNS1VD7yGe8EVJ+Zkw==
X-Google-Smtp-Source: ABdhPJwXUGhjppbE6zvMZV+L6jdPqmJ9aaEYYtvdF9pNo60N3hwLrbdSExWhtbWMAnPQ7hSGFpo34A==
X-Received: by 2002:a1c:a74b:: with SMTP id q72mr6350090wme.122.1592617575345;
        Fri, 19 Jun 2020 18:46:15 -0700 (PDT)
Received: from [192.168.1.10] ([194.53.184.63])
        by smtp.gmail.com with ESMTPSA id z6sm8855895wrh.79.2020.06.19.18.46.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 18:46:14 -0700 (PDT)
Subject: Re: [PATCH v3 bpf-next 8/9] tools/bpftool: show info for processes
 holding BPF map/prog/link/btf FDs
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Hao Luo <haoluo@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Song Liu <songliubraving@fb.com>
References: <20200619231703.738941-1-andriin@fb.com>
 <20200619231703.738941-9-andriin@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <72692317-ee96-1b4d-3f93-c0b148baa7ec@isovalent.com>
Date:   Sat, 20 Jun 2020 02:46:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200619231703.738941-9-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-06-19 16:17 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> Add bpf_iter-based way to find all the processes that hold open FDs against
> BPF object (map, prog, link, btf). bpftool always attempts to discover this,
> but will silently give up if kernel doesn't yet support bpf_iter BPF programs.
> Process name and PID are emitted for each process (task group).
> 
> Sample output for each of 4 BPF objects:
> 
> $ sudo ./bpftool prog show
> 2694: cgroup_device  tag 8c42dee26e8cd4c2  gpl
>         loaded_at 2020-06-16T15:34:32-0700  uid 0
>         xlated 648B  jited 409B  memlock 4096B
>         pids systemd(1)
> 2907: cgroup_skb  name egress  tag 9ad187367cf2b9e8  gpl
>         loaded_at 2020-06-16T18:06:54-0700  uid 0
>         xlated 48B  jited 59B  memlock 4096B  map_ids 2436
>         btf_id 1202
>         pids test_progs(2238417), test_progs(2238445)
> 
> $ sudo ./bpftool map show
> 2436: array  name test_cgr.bss  flags 0x400
>         key 4B  value 8B  max_entries 1  memlock 8192B
>         btf_id 1202
>         pids test_progs(2238417), test_progs(2238445)
> 2445: array  name pid_iter.rodata  flags 0x480
>         key 4B  value 4B  max_entries 1  memlock 8192B
>         btf_id 1214  frozen
>         pids bpftool(2239612)
> 
> $ sudo ./bpftool link show
> 61: cgroup  prog 2908
>         cgroup_id 375301  attach_type egress
>         pids test_progs(2238417), test_progs(2238445)
> 62: cgroup  prog 2908
>         cgroup_id 375344  attach_type egress
>         pids test_progs(2238417), test_progs(2238445)
> 
> $ sudo ./bpftool btf show
> 1202: size 1527B  prog_ids 2908,2907  map_ids 2436
>         pids test_progs(2238417), test_progs(2238445)
> 1242: size 34684B
>         pids bpftool(2258892)
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Reviewed-by: Quentin Monnet <quentin@isovalent.com>

