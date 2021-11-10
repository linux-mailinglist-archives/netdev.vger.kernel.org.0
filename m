Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB0544CB89
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 23:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbhKJWF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 17:05:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233509AbhKJWF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 17:05:28 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D691EC061766;
        Wed, 10 Nov 2021 14:02:40 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id np3so2663586pjb.4;
        Wed, 10 Nov 2021 14:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pLtMD5YfNqZol7MFNr0Vu3H/2bOzYreoma/+lSepIwE=;
        b=AIjljorY44KXKRb7eU0HGgsjVZauxcHqvcQGt4lPZPb0t2k9TYsFhrcisl6lYy4LfV
         5vHzWBea0QBjveSKYflV7+855OVSHYav0h12kt1DJoSuUS9OJj++GSPBcBtXOJFaXWxL
         pu+N0WzkyMd9Jwpwp7JAdYlFZHqFpEhvMhYcWWZ9pLMe15O1kHhqBz4d6Q5OXrQkwa/g
         naXA+oRlhVYc0LFeYSe+FyBs6gGfERl5mM7cgV5R17CsCRkGGBNGmBCAnbQ2b6lWMnCu
         9irfRYwjjs6zOBDkXTzjNqCzMcwfYGvhm3tIiDU+xSDeXi2FvW5Nvw6MYpsPXL7y0eiy
         LZlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pLtMD5YfNqZol7MFNr0Vu3H/2bOzYreoma/+lSepIwE=;
        b=C9H13ZopWeCA3nfQsLCZbPf3ps/X0tDVus6sN4iLn8YALQpdJWvm/6ZeLKQYt+928e
         uUJacVJJJJg2fq1iFoDnimfYhHxelOsr9A3xXsZnswisiXmUamoCdC8w5MSM/8MhMgI7
         3czuqQcR0PSIHpNCX/BZoXZkXVg7P1xatuXz0kTJL2Trv5W3nqw0sRvfvQ/ONMADtXKk
         d21ceGlhiM6XLes/G7ytju6p+iNoWWAFPndgpaUPLK9l4Icc0T0fwBwT9cP6JvM4kJXS
         zWXKsCW8Z+phPfCntrI4/ljQwO56yU0qLPz4eupSClX9vaXPx7gjtVpHYiDOQHQmS7Um
         UyUg==
X-Gm-Message-State: AOAM531KBsPc5Bz5bl6FZcQV3cndVB7ehdoIE5N5C93HllsEpc9waXPj
        K5YTP+cxLXA7XhbOiHCN6h6LRgXMbjBpQ0ryOzE=
X-Google-Smtp-Source: ABdhPJwl9gw6QB3nNd66kzBxQgBw/I49JMur7S2PFyeLV4+wHLuzEJ7w9epVRXK8vFSsnzH2QsBzZMJye6akbLZgXgA=
X-Received: by 2002:a17:903:2306:b0:141:e52e:457d with SMTP id
 d6-20020a170903230600b00141e52e457dmr2684477plh.3.1636581760426; Wed, 10 Nov
 2021 14:02:40 -0800 (PST)
MIME-Version: 1.0
References: <20211110174442.619398-1-songliubraving@fb.com>
In-Reply-To: <20211110174442.619398-1-songliubraving@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 10 Nov 2021 14:02:29 -0800
Message-ID: <CAADnVQK5nHGnC_9+m0q__AdhSxuHtE5Uh98epw2JEdjOCP343Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: extend BTF_ID_LIST_GLOBAL with parameter
 for number of IDs
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        syzbot+e0d81ec552a21d9071aa@syzkaller.appspotmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 9:47 AM Song Liu <songliubraving@fb.com> wrote:
>
> -#ifdef CONFIG_DEBUG_INFO_BTF
> -BTF_ID_LIST_GLOBAL(btf_sock_ids)
> +BTF_ID_LIST_GLOBAL(btf_sock_ids, MAX_BTF_SOCK_TYPE)
>  #define BTF_SOCK_TYPE(name, type) BTF_ID(struct, type)
>  BTF_SOCK_TYPE_xxx
>  #undef BTF_SOCK_TYPE
> -#else
> -u32 btf_sock_ids[MAX_BTF_SOCK_TYPE];
> -#endif

If we're trying to future proof it I think it would be better
to combine it with MAX_BTF_SOCK_TYPE and BTF_SOCK_TYPE_xxx macro.
(or have another macro that is tracing specific).
That will help avoid cryptic btf_task_struct_ids[0|1|2]
references in the code.
