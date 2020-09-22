Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A17274247
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 14:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgIVMns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 08:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbgIVMnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 08:43:47 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35784C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 05:43:47 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id gx22so13598923ejb.5
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 05:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EZVYPQDM745h290MwDvoCECH4RGR18nCNuRmCWFdNCw=;
        b=u3lMp8TydI2QP6QNm/pAfrLJ7GK81BNOYZKPoUBMxHXf4Zv6JaWyqYjI6FQPcXhjzp
         1zO/CvtrgtTa4Fi3WVskIRg9vs7l9p0r8mVyusxvjIvYBobSb98S1lsxHtK9IV8Sz0n5
         D5Vu7pA2LMs/XlZnl0jLCRk7QR2nUmaVMGDC8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EZVYPQDM745h290MwDvoCECH4RGR18nCNuRmCWFdNCw=;
        b=W/Y73Hj+PtdH0d6kZh3V+sKluOx5MqYEkT/mK44gOiVlWlwY+hP7JPzJmL5WdSsIJ6
         D5KV6c0997F8vRDWoaLN0KUjCw0NM7OJk9nyZbPPCVKZu+H3MtPC0d5VAf/etvfwtire
         sxo0RLCTzacQVhzPdsXHkhrx3wnX5IT/xyb9t1jUEUKlLKfDGf0w36Gcojw8UkDgHbpu
         ckhFKQXdhnFSmO7wXhOHEXzNXabaZ+88UErmjk2/Jkhg/H7QPgYpOSEEvunmrunoDn2F
         87A2FFdylYMFmZG99v30pGPyp/JMb+ruiApj5/c3MH3kWYMZr/9GQN0sMigNhXURFUrd
         nMnQ==
X-Gm-Message-State: AOAM531kMVwNEC6BAvvqjEBNOlv//uJXSIyZhM53AeqXFb6ORGx67wFx
        4t9PwyHj8C2x0eXtsz8hc40lsQ==
X-Google-Smtp-Source: ABdhPJxeRbmQoeE/o8aQAa0StUUCmpBOrgC9ypGDnyDhtAgYjksvLFNIREqXBlQ7sDPdAz9jO4xmMA==
X-Received: by 2002:a17:907:408e:: with SMTP id nt22mr4584356ejb.169.1600778625780;
        Tue, 22 Sep 2020 05:43:45 -0700 (PDT)
Received: from localhost ([2620:10d:c093:400::5:e90b])
        by smtp.gmail.com with ESMTPSA id v17sm11272766ejj.55.2020.09.22.05.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 05:43:45 -0700 (PDT)
Date:   Tue, 22 Sep 2020 13:43:44 +0100
From:   Chris Down <chris@chrisdown.name>
To:     Chunxin Zang <zangchunxin@bytedance.com>
Cc:     Michal Hocko <mhocko@suse.com>, Yafang Shao <laoar.shao@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, lizefan@huawei.com,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kafai@fb.com,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        andriin@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org,
        Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org
Subject: Re: [External] Re: [PATCH] mm/memcontrol: Add the drop_cache
 interface for cgroup v2
Message-ID: <20200922124344.GA34296@chrisdown.name>
References: <20200921080255.15505-1-zangchunxin@bytedance.com>
 <20200921081200.GE12990@dhcp22.suse.cz>
 <CALOAHbDKvT58UFjxy770VDxO0VWABRYb7GVwgw+NiJp62mB06w@mail.gmail.com>
 <20200921110505.GH12990@dhcp22.suse.cz>
 <CAKRVAeN5U6S78jF1n8nCs5ioAdqvVn5f6GGTAnA93g_J0daOLw@mail.gmail.com>
 <20200922095136.GA9682@chrisdown.name>
 <CAKRVAePisoOg8QBz11gPqzEoUdwPiJ-9Z9MyFE2LHzR-r+PseQ@mail.gmail.com>
 <20200922104252.GB9682@chrisdown.name>
 <CAKRVAeOjST1vJsSXMgj91=tMf1MQTeNp_dz34z=DwL7Weh0bmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKRVAeOjST1vJsSXMgj91=tMf1MQTeNp_dz34z=DwL7Weh0bmg@mail.gmail.com>
User-Agent: Mutt/1.14.7 (2020-08-29)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chunxin Zang writes:
>Please forgive me for not being able to understand why setting
>memory.low for Type_A can solve the problem.
>In my scene, Type_A is the most important, so I will set 100G to memory.low.
>But 'memory.low' only takes effect passively when the kernel is
>reclaiming memory. It means that reclaim Type_B's memory only when
>Type_A  in alloc memory slow path. This will affect Type_A's
>performance.
>We want to reclaim Type_B's memory in advance when A is expected to be busy.

That's what kswapd reclaim is for, so this distinction is meaningless without 
measurements :-)
