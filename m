Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264B5441ED0
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbhKAQw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbhKAQw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:52:59 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0379C061714;
        Mon,  1 Nov 2021 09:50:25 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id y1so11914866plk.10;
        Mon, 01 Nov 2021 09:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1lQPvAS9D0YptMbqbx4CESL2hczonDYMGmutZeU63Qs=;
        b=Eu2gvCSrbOfvqQrgUNJpA4aXVLITzo0Rr5s2KHm4lkO4g+GGoqlRJzULM6xhsZVatz
         /Ytrzcvgy0GStGdUWlFk2Dwqpmh5BeztdMWD3Min37Qb4AvvzT1Nx2GAqaFZYhfubv4u
         GJzMqLVblF+R1GsAgMoj8pCPSE/Y+mVLDpNicX7YilRhxzm7+p5AzbjZvSge/1T8zUy/
         /JCxUj30QQeKvTc+VanMVi7ZLme1zOy061siPLUb+FrOJWo2gbyUiuBZl6yUIJvXU8y5
         +kPewJ1v5DxcEKS8vPINbiOyJb9+BrVNTs71KtbSmjb525fEdrSBOSkwAeQIDFtjx7gV
         hzgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=1lQPvAS9D0YptMbqbx4CESL2hczonDYMGmutZeU63Qs=;
        b=uLoFDvkmltRaK2uxcbst81yZWtkTl0FMe4/LqPPR0+tEaVIguL7z1Sl2LLyuROQ+QD
         pseiPCfS5xsDTxt9C5ctoEZxblNLlMEGzmGmDhnTUhU9faP8fWxddHiQPk12Mejgn3EB
         d1kZcT0TDbzS9f9whR6Xph9/QSXis0r0B34gyohW3nu+Nvsd2PGTQ1acV3R/PVqR+YUk
         mNroNWOe/SZpF1DZKfIlUVTE6FX+160jIgaEB95q2sKde00TUQ5bgCkESEzb9gHEBHbn
         VzU0ScT505oqGVq+AFEg8eFU9dHnoRu5a/J3CRmfNK1UCLEzpFYxPEoKz739ppS2e1KH
         kufA==
X-Gm-Message-State: AOAM532Y3Cu6P7o9w3FNuQdTjXlSmWCLZh2hGUdA0iJPpjkw7QoeOBgE
        rcjDWbSrZdDbitwYQPcTDRQ=
X-Google-Smtp-Source: ABdhPJzOFIXwyz1spdxhYekeL/kTuOGhGHIxyu0jnfLkamhe22EuvazRViEA5ERRi3n99SzkXCPjfg==
X-Received: by 2002:a17:902:7c94:b0:13b:8d10:cc4f with SMTP id y20-20020a1709027c9400b0013b8d10cc4fmr26227558pll.54.1635785425347;
        Mon, 01 Nov 2021 09:50:25 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id v16sm16532953pfu.208.2021.11.01.09.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:50:24 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Mon, 1 Nov 2021 06:50:23 -1000
From:   Tejun Heo <tj@kernel.org>
To:     He Fengqing <hefengqing@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org
Subject: Re: [PATCH] cgroup: bpf: Move wrapper for __cgroup_bpf_*() to
 kernel/bpf/cgroup.c
Message-ID: <YYAaz469VgwskHAq@slm.duckdns.org>
References: <20211029023906.245294-1-hefengqing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211029023906.245294-1-hefengqing@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 02:39:06AM +0000, He Fengqing wrote:
> In commit 324bda9e6c5a("bpf: multi program support for cgroup+bpf")
> cgroup_bpf_*() called from kernel/bpf/syscall.c, but now they are only
> used in kernel/bpf/cgroup.c, so move these function to
> kernel/bpf/cgroup.c, like cgroup_bpf_replace().
> 
> Signed-off-by: He Fengqing <hefengqing@huawei.com>

Applied to cgroup/for-5.16.

Thanks.

-- 
tejun
