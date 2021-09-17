Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D78640FF15
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 20:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344187AbhIQSTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 14:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbhIQSTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 14:19:37 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FAFC061574;
        Fri, 17 Sep 2021 11:18:14 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id q23so7865077pfs.9;
        Fri, 17 Sep 2021 11:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hhjMxnkT2tEdZCVspZbIWpzonbsMYeKf1d2r8KDUExA=;
        b=S5LE1VlqH3TCrkq/EKd8BTCJnMaboUJPbpRSMDekPBpfLTkLsjh5RV46XHdPQ5/z+K
         GrGlW5qTlCzRuPEu8krOj/CnE8bghNc3b2kjaCjvc8aWV/iwjfs9VX88UYnxY+ByS3jN
         TSCnXB28zN4nPqrjcwoeoAsbqYpJGrYxMi5j3DWu4146YmN2N+wmhFJzUDfkkT8vkUDe
         aE991G5+zUMhTdTMPqfyWlhOjpvsLgcgcYBvswVFY4PsrEG/+fGzXVmztQzeQXfE4Gtf
         xi5Pqj9Z6fVHd/lgBey7NH7NKQzfpHPwRiNGHW2m891Ov6zihGB3Q/yh+VNmW4wcxvqA
         j1RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hhjMxnkT2tEdZCVspZbIWpzonbsMYeKf1d2r8KDUExA=;
        b=qR7IMsrn8rsu4c+sJdTkeZxg+qTqt52EqqFdPvhXq8dUOmOxJwuMFg14U5sHhFyG5H
         L1Z3ibaOWDdJdicGJcF4tHAAhOn5vAvZLuzxj6Fg/JldfDVv3jbm6TlRlpWYXUYlGR9B
         yNJca/B+K0YCQ5WjnXZI4h/AS+xpJ0n3zZdEaFY5++DbeQ6+g0o+qyLNGRcwtbFt64jZ
         e7pdDM7Rw/OKDE7qAle/VnqfEOqaKFdAHWHOxm/QB1bT8tjuYwFJmtzpcZRhRnCjpiK8
         Ld2JUHIj2dLIcFemPgr+ch1N5o4HM9pSeEeRYTT7QPEz6j3Y9FJEsqQGmcSV1/FV30Da
         mkHg==
X-Gm-Message-State: AOAM533ccW6rW9GXaIMmYsAxKKIiO3LLcvQUJTUUMkB7xdYTzk+ws/Mv
        XFUlHoY3hV0B7q18tERb9+84aaSxc3bY7u7vgqektYTl
X-Google-Smtp-Source: ABdhPJxzvlGOwI/RIGfPAAfVohtspnYpG9S8m5//Mn9xzkrL8ufGTIpb/hiZMq4vkL0EAibFnPC4t+LNqSlIQA2tC2o=
X-Received: by 2002:a62:b515:0:b0:438:42ab:2742 with SMTP id
 y21-20020a62b515000000b0043842ab2742mr12358826pfe.77.1631902694201; Fri, 17
 Sep 2021 11:18:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210913231108.19762-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210913231108.19762-1-xiyou.wangcong@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 17 Sep 2021 11:18:03 -0700
Message-ID: <CAADnVQJFbCmzoFM8GGHyLWULSmX75=67Tu0EnTOOoVfH4gE+HA@mail.gmail.com>
Subject: Re: [RFC Patch net-next v2] net_sched: introduce eBPF based Qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 6:27 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> ---
> v2: Rebase on latest net-next
>     Make the code more complete (but still incomplete)

What is the point of v2 when feedback on the first RFC was ignored?
