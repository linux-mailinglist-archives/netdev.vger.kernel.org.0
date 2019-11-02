Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF68BED081
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 21:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfKBUIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 16:08:55 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45067 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbfKBUIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 16:08:55 -0400
Received: by mail-pg1-f194.google.com with SMTP id r1so8588628pgj.12;
        Sat, 02 Nov 2019 13:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zXYT/ZeHsCXMOP8AZMsrYS79rL9tXXrExzyfPs19B/o=;
        b=h7IvU709Edudo+yyjBuJBbYljj67d8fFRjiKkFYe1tcSdWoViubaKuTLw+idC3ecKQ
         U7inLhioU6kn0mJS1MFqHAo0uEhpnJKWNzsEan+w3ifT5Rfr9mtUbGiQi3mMaDomeGYN
         4Oq/9QKx0GfHPem10oPvJxFidW5I4tgc37UAjU7LWTO905PBu2nMOHbHpLp9/3bvUtE0
         7iv3v61UB4O/Qvza8RecM8qZI6ILBqq7Er6rbCn5bSqUj/WJb0BXkg3OrMSQHQd+12X3
         Jk6RsEMXBLd8Uo4XpP4mBR18giZWRs+Vo+UbRR+LmjUEolb8IPPQWKW2MMkWDbjngF+y
         9dJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zXYT/ZeHsCXMOP8AZMsrYS79rL9tXXrExzyfPs19B/o=;
        b=C6p7dsT67PBDA+ivnHI7hvNt79Q8izfHKYXFBHtosXFvyV1BdO9RSGA/0wVGzVY/or
         mgzWFs/1EW2N7gfs4XJzJqsP+oQhbHa2wVEgrXvjk194U5F4liTOlkx0X7uZxzl+8M5n
         VP0FrDypThr9Yy8ZExG9rZ0gAPq+jutGtk//DZHMsWfB9U7KBeHRM4apmex8hiFjxgB3
         nazjD1y/4ERj8f5vo7kfmQUtakV7lnWzXmaMErBpZgC1ER4Vltq/KWjAxsajMHlIkf3w
         ZxV/uT2BaA4ZN+S+oa14SMVHgZ6Pw6dZznqRaOJPYy5t4kI5jmuBFjTv+a+EATrAat42
         yhIQ==
X-Gm-Message-State: APjAAAXGQFbcDD9BAE6VO9QKG1Tmq9+ibKN961iBCVZCnPe+I6RyZmQF
        NIvxOs1wpQnykV9E76gBHwo=
X-Google-Smtp-Source: APXvYqzky6bIyPy8AJunDvpI4UPDIRRI8D8sEIBrqhtW6ZSz22wzKSj8yzav+NjNlNycgOmTSubxtQ==
X-Received: by 2002:a65:4489:: with SMTP id l9mr2358594pgq.106.1572725334359;
        Sat, 02 Nov 2019 13:08:54 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::f3bc])
        by smtp.gmail.com with ESMTPSA id s69sm231025pgs.65.2019.11.02.13.08.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 02 Nov 2019 13:08:53 -0700 (PDT)
Date:   Sat, 2 Nov 2019 13:08:52 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        andrii.nakryiko@gmail.com, john.fastabend@gmail.com
Subject: Re: [PATCH bpf-next v3 0/8] Fix BPF probe memory helpers
Message-ID: <20191102200850.cyf3ql5ao43p7vmz@ast-mbp.dhcp.thefacebook.com>
References: <cover.1572649915.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1572649915.git.daniel@iogearbox.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 02, 2019 at 12:17:55AM +0100, Daniel Borkmann wrote:
> This set adds probe_read_{user,kernel}(), probe_read_str_{user,kernel}()
> helpers, fixes probe_write_user() helper and selftests. For details please
> see individual patches.
> 
> Thanks!
> 
> v2 -> v3:
>   - noticed two more things that are fixed in here:
>    - bpf uapi helper description used 'int size' for *_str helpers, now u32
>    - we need TASK_SIZE_MAX + guard page on x86-64 in patch 2 otherwise
>      we'll trigger the 00c42373d397 warn as well, so full range covered now

Applied and I wish I could say: "queued up for -stable".

The warning added by
commit 00c42373d397 ("x86-64: add warning for non-canonical user access address dereferences")
dumps the stack trace that looks like kernel panic.  It was reported numerous
times by scared users and crash detection tools. Until now bpf tracing
programs couldn't be fixed to avoid that warning. This patch set is a big step
forward solving user vs kernel access issue. User space tool 'bpftrace'
provisioned language feature 'kaddr' and 'uaddr' in anticipation of the
bpf_probe_read_user() helper.
Thank you Daniel for implementing this fix.
