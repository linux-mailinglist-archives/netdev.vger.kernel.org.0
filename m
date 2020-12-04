Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2EB32CE572
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 03:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgLDB7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 20:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgLDB7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 20:59:21 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35950C061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 17:58:41 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id r9so2164601pjl.5
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 17:58:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+88kzlBTMqbHj8wYB8+OFE1Az9Z7qwY+oLBHrzInL9g=;
        b=rovub2LE60QdbTzvyQNqHJ1GOr59HJsdAdQWGxGv/73hqYPLvc2D1QzVyuTVpoPgWC
         KIFQnsunRzPp00ssaKs+U0ryEk1cq6JwPAJX83LBA/MiI9W5JVYazSLQjlYkg/FSXlxK
         TswLO8Dmx0qMSObNSjD8DMChjRVI0VgpA67cxEUEY4EUeMfvK8XZuSzwBVJ47ST6kquZ
         5Gyx/mq+QJNbvfUHjY/I6SkvhkTs/6zKQcfJNVlwRVPDMMTx7FcgEEs0C5y+Lzv8pZvV
         h09IdSrohiJXjkOI+ITDZLBkPHNZvbF2pPSIRYf3TKNZg6bDsDjebOMw9YsZHQv8tYEk
         AXWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+88kzlBTMqbHj8wYB8+OFE1Az9Z7qwY+oLBHrzInL9g=;
        b=MCimfTdHdxtM4GmGYMej4SZ/HuOJVkYJm6bS720+AQoUGmBe5KDSZarU8rpiHfjtig
         g6K2etadkQywQ5piISljbAl/oBIrKao3pFcRjRyVAaDu87SdzjIu1VHp2NKIyAkevgka
         6wmOE/86qiHEkORh+a3dTAGvNcIiQa/toZIqdv0p6xNj9/O9+n/UcH0tTEBF9GReIKNq
         xVJ55P/VzDBtJJpm42DZGpQYGW15HIfupNgkmGyxqDBewJZUAzT9hU4DTb/LvXLf/KVf
         rQ5ZxGhMA4HJ35LlTC14Tk3Gi+LnF4l0njE/30lcGauskgfZBnH7mPy7fw9TXvRvWBya
         fWsA==
X-Gm-Message-State: AOAM531X58cyeL1k3vJFqVJ9lXn0uhgvFDCt3E1U2j7oZvZLvLvQXtjq
        fwxlmH7jNtJLRiV2uL1gMC8=
X-Google-Smtp-Source: ABdhPJzvkYovi6pnkNzLsZ5dBQBW+E5v8SxinLG5LEs5XY5mTcHgm0JeDIHACOQ6W/gwm+u0oPFbkg==
X-Received: by 2002:a17:90a:e64a:: with SMTP id ep10mr1830498pjb.60.1607047120818;
        Thu, 03 Dec 2020 17:58:40 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:2ca])
        by smtp.gmail.com with ESMTPSA id r68sm2918904pfr.113.2020.12.03.17.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 17:58:40 -0800 (PST)
Date:   Thu, 3 Dec 2020 17:58:38 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        yhs@fb.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next] bpf: increment and use correct thread iterator
Message-ID: <20201204015838.inkhwq7nbn2nehsz@ast-mbp>
References: <20201203215907.975053-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203215907.975053-1-jonathan.lemon@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 01:59:07PM -0800, Jonathan Lemon wrote:
> From: Jonathan Lemon <bsd@fb.com>
> 
> If unable to obtain the file structure for the current task,
> proceed to the next task number after the one returned from
> task_seq_get_next(), instead of the next task number from the
> original iterator.
> 
> Use thread_group_leader() instead of comparing tgid vs pid, which
> might may be racy.
> 
> Only obtain the task reference count at the end of the RCU section
> instead of repeatedly obtaining/releasing it when iterathing though
> a thread group.
> 
> This patch fixes a recurring RCU stall seen from task_file_seq_next().
> 
> Fixes: a650da2ee52a ("bpf: Add task and task/file iterator targets")
> Fixes: 67b6b863e6ab ("bpf: Avoid iterating duplicated files for task_file iterator")

There are no such sha-s in bpf-next tree. Pls fix.
