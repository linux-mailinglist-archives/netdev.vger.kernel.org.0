Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C190228C48C
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 00:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388437AbgJLWMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 18:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387733AbgJLWMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 18:12:46 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C204C0613D0;
        Mon, 12 Oct 2020 15:12:46 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id q25so5245992ioh.4;
        Mon, 12 Oct 2020 15:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6GZ3bPMspww2V+Ym0Qh7X9pkgI/IU9Jbpf7mzdOQus0=;
        b=bfJwjbcd5PfSUcnm5iNF1BFJezZAWaVv8f4NLYg36c21R35nOTPcbZgGSeAP/BN0YC
         lArmVDHnZ5+zDU4S/jy3q0/lyq09lQDp6In3uxoRVf9QoEhNVCbeiBmEhgiAO4kHrK9B
         Hq7VkFhxWsNwnniQIXjcTgqlMxhRpcwPgURREjSvx7Dig8vrhb+HCgy+t8JOknv+TuVK
         SodLcbqfh2IHcOVQgsCI818lRf3F8KtPBlaBu5QgIDdgNJy8y66xgSpWB+1KJX5j86Gr
         jqyxILPzfhjLTUnkww//qeHeGNTskcutRLhjmBzZq5YXYW7gvwoYKQoL3WOILki0xJ0v
         VmPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6GZ3bPMspww2V+Ym0Qh7X9pkgI/IU9Jbpf7mzdOQus0=;
        b=LAWl3dS6KGY4QdfNZ+JGrTydQYU9V8QuMXAELKsevFmOdYougzU0vHagaYbZxEcB+7
         nrvSv8ie5BiBbHk4sFNRP8lEawyfg/KY10cYSqMNPesZW/EjZHiefW/l9I7TKq1hLezY
         BkogOo8vwLSMsFaTuvj/Ybm2yLb5itHsYoDb6srJ/mdupImwQcwrTCFft6qlyWbmoDKa
         l9FxuhxCcbYMUAb+/weuSG+P1o7aKvyBOEXNIydh7Hu0u+MmAiJUgrqsRSrt4t0WKJIJ
         Zp4UWt0j8r3rbLTduL8yRxYaFJUKMK4TUXsgbdYjA2DC8JQkYnYmmqYrQr4QS0QNYgfw
         oZBA==
X-Gm-Message-State: AOAM532KxC6+KgL2x97nJJ4KBASjNHIllyOIqWEzDHFBSskiD+GFJv+m
        +9xi/Q8KU4lbHc1/JlEUlyzCXVeTZ6hqKHE/emc=
X-Google-Smtp-Source: ABdhPJyFc4ostSbxsypN1wGndFqR3BXYLSDhPoPs1FLqkP0180PUNcs1Rg52RMqlZV96tqBaaMtbT66MdYmI0R8n1vU=
X-Received: by 2002:a05:6638:159:: with SMTP id y25mr21753172jao.131.1602540765537;
 Mon, 12 Oct 2020 15:12:45 -0700 (PDT)
MIME-Version: 1.0
References: <20201010103854.66746-1-songmuchun@bytedance.com>
 <CAM_iQpUQXctR8UBNRP6td9dWTA705tP5fWKj4yZe9gOPTn_8oQ@mail.gmail.com>
 <CAMZfGtUhVx_iYY3bJZRY5s1PG0N1mCsYGS9Oku8cTqPiMDze-g@mail.gmail.com>
 <CANn89iKprp7WYeZy4RRO5jHykprnSCcVBc7Tk14Ui_MA9OK7Fg@mail.gmail.com>
 <CAMZfGtXVKER_GM-wwqxrUshDzcEg9FkS3x_BaMTVyeqdYPGSkw@mail.gmail.com>
 <9262ea44-fc3a-0b30-54dd-526e16df85d1@gmail.com> <CAMZfGtVF6OjNuJFUExRMY1k-EaDS744=nKy6_a2cYdrJRncTgQ@mail.gmail.com>
In-Reply-To: <CAMZfGtVF6OjNuJFUExRMY1k-EaDS744=nKy6_a2cYdrJRncTgQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 12 Oct 2020 15:12:34 -0700
Message-ID: <CAM_iQpUgy7MDka8A44U=pLGDOwqn8YhXMp8rgs8LCJBHb5DXYA@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] mm: proc: add Sock to /proc/meminfo
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Greg KH <gregkh@linuxfoundation.org>, rafael@kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Shakeel Butt <shakeelb@google.com>,
        Will Deacon <will@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <guro@fb.com>, Neil Brown <neilb@suse.de>,
        rppt@kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Florian Westphal <fw@strlen.de>, gustavoars@kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>, dave@stgolabs.net,
        Michel Lespinasse <walken@google.com>,
        Jann Horn <jannh@google.com>, chenqiwu@xiaomi.com,
        christophe.leroy@c-s.fr, Minchan Kim <minchan@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 12, 2020 at 2:53 AM Muchun Song <songmuchun@bytedance.com> wrote:
> We are not complaining about TCP using too much memory, but how do
> we know that TCP uses a lot of memory. When I firstly face this problem,
> I do not know who uses the 25GB memory and it is not shown in the /proc/meminfo.
> If we can know the amount memory of the socket buffer via /proc/meminfo, we
> may not need to spend a lot of time troubleshooting this problem. Not everyone
> knows that a lot of memory may be used here. But I believe many people
> should know /proc/meminfo to confirm memory users.

Well, I'd bet networking people know `ss -m` better than /proc/meminfo,
generally speaking.

The practice here is that if you want some networking-specific counters,
add it to where networking people know better, that is, `ss -m` or /proc/net/...

Or maybe the problem you described is not specific to networking at all,
there must be some other places where pages are allocated but not charged.
If so, adding a general mm counter in /proc/meminfo makes sense, but
it won't be specific to networking.

Thanks.
