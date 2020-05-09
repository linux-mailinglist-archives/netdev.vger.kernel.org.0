Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69E21CC516
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 01:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgEIXGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 19:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgEIXGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 19:06:30 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C75AC061A0C;
        Sat,  9 May 2020 15:57:39 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id c64so5875461qkf.12;
        Sat, 09 May 2020 15:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rNy4JOtG+nCRfsj1WL1vWdLxzYPRX62nRZqLhv1rCGQ=;
        b=ZBrXz5ssxM8itMJvIuhpryRMrVoN3j3run4YUAz9kEkOoLcLITpSlYjkDQ7w9RSvP1
         HojOEGvaQDlHZxwbT5lZPfEogQgu8nZ9xiQG2LBJjr6pQw6jEdLZYdyThxAK7iKXAKQd
         h/ZPs7oYkGx6MLK5yVck7arft1mrtTZBmumNr8P/oEV1EECn43KBNnYn9M0Js1dGFp4/
         XCMz5qTkq1i2i4WFKcSfdsO9C55aV/5BpbJMQyj6IU0Bc0RLAujCsLkqDy6X9S3W2oQb
         AQ2oKK+CDVfbfZdfdssvS6OZ+Pbo0E5iwtFQcPKP978sryTITGs/XquTmjhclfNGtfNe
         WE+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=rNy4JOtG+nCRfsj1WL1vWdLxzYPRX62nRZqLhv1rCGQ=;
        b=Yy9wwTkrsCkCCdK/SEGFZ/9XCdJsUvNThzOpqsIJ6ynIrpGarSL3vIQgtrSUMb+Zp5
         keJBoj5cFqtncidKtiadBb26qhSZsJb6RVs1QH8Mf8ijaKeHaoq50uwIJ/oROmIdiCM2
         0RYDQ66udbpGIfO0vLsnFr0v7sPZ6BumbhXOdusm9Sbat2iLdpSZUK0XE1sSkgUgbE/F
         YDgCgSF+tz2+2RVAk7RMSFHLDaEsryrQQkNLLuMpmDPZ+rdBWpXCrV1U1WhAfJQH0iwH
         NgtQyqn5iteYJEdPktWBGvbAnf9xI45+zC4Hh5Hh1RgbqFwniCQUMrfE/mcPsy2eoIHh
         BsEw==
X-Gm-Message-State: AGi0PuZqBRYOtfM8JQaQbXDB6pXI2kF5mE0dAkLeFJ1dsS4jo+DVHaud
        9cwnaA02eZ596WiRCPE4k5s=
X-Google-Smtp-Source: APiQypK96R6cZFzspYhYnzWz/BZGD+Zb9bSRGqNWyFkoxqBq1jqbx9pi9qU+L0H/Z1HgKrBNlxxxRA==
X-Received: by 2002:a05:620a:1495:: with SMTP id w21mr9365964qkj.81.1589065058181;
        Sat, 09 May 2020 15:57:38 -0700 (PDT)
Received: from localhost ([199.96.181.106])
        by smtp.gmail.com with ESMTPSA id e26sm4537648qka.85.2020.05.09.15.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2020 15:57:37 -0700 (PDT)
Date:   Sat, 9 May 2020 18:57:36 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Zefan Li <lizefan@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        yangyingliang <yangyingliang@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        huawei.libin@huawei.com, guofan5@huawei.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] netprio_cgroup: Fix unlimited memory leak of v2
 cgroups
Message-ID: <20200509225736.GA16815@mtj.duckdns.org>
References: <939566f5-abe3-3526-d4ff-ec6bf8e8c138@huawei.com>
 <2fcd921d-8f42-9d33-951c-899d0bbdd92d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fcd921d-8f42-9d33-951c-899d0bbdd92d@huawei.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 11:32:10AM +0800, Zefan Li wrote:
> If systemd is configured to use hybrid mode which enables the use of
> both cgroup v1 and v2, systemd will create new cgroup on both the default
> root (v2) and netprio_cgroup hierarchy (v1) for a new session and attach
> task to the two cgroups. If the task does some network thing then the v2
> cgroup can never be freed after the session exited.
> 
> One of our machines ran into OOM due to this memory leak.
> 
> In the scenario described above when sk_alloc() is called cgroup_sk_alloc()
> thought it's in v2 mode, so it stores the cgroup pointer in sk->sk_cgrp_data
> and increments the cgroup refcnt, but then sock_update_netprioidx() thought
> it's in v1 mode, so it stores netprioidx value in sk->sk_cgrp_data, so the
> cgroup refcnt will never be freed.
> 
> Currently we do the mode switch when someone writes to the ifpriomap cgroup
> control file. The easiest fix is to also do the switch when a task is attached
> to a new cgroup.
> 
> Fixes: bd1060a1d671("sock, cgroup: add sock->sk_cgroup")
> Reported-by: Yang Yingliang <yangyingliang@huawei.com>
> Tested-by: Yang Yingliang <yangyingliang@huawei.com>
> Signed-off-by: Zefan Li <lizefan@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
