Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5762290CEF
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 22:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409181AbgJPUxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 16:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409148AbgJPUxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 16:53:42 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C403C061755;
        Fri, 16 Oct 2020 13:53:42 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o7so2134646pgv.6;
        Fri, 16 Oct 2020 13:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0efe4ZswmOvSV9QicwyqB6fv9os8T/DGdQrXJonnXfU=;
        b=Ia140vybnbMk8phKU5HmNtD4SH9QvW01QBJWsD42VQG/He9IU/Z/GCeuhEAU3fxKJe
         p9om8meCP2zPNgOXjCGO4IKUsxW4bk4S01ptydLJ9m9n5fvufxVIAI2DuHa+RXqXI8Fy
         vLOlAHbA8E6FFXkkWrhT3uU1NUboIG7n+Acik/ORasBZnFd19y+9ne7XBaxYRMN5uAMB
         KDdWJ+/5qmi3ABqkqRdLshmvJQuO1Ey6pn6+Ur3Ib37edjfZS0raMMUIxgW5PWataXnk
         0/T6gDtyRW69km7Jy8SfuqhSzqzK8+yCjF/8wSndOu/3RNevTVZeNf0IhgZxyVSI3vqC
         30Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=0efe4ZswmOvSV9QicwyqB6fv9os8T/DGdQrXJonnXfU=;
        b=BvH5XwWLjetqeHSk8W3Lr+0kfw33mRUspNiozWOldzKIrbKjFOIyFdi+ZbwpAKHrTg
         eUJIc7UA/QNNdn111Vo2eo2oF9yhlr3fYFkiGWOdMVv747ZuWS97TmiRRpv1mfd9UqHb
         pb/0G1gDjjVrMD3z2tyAw4F0KCIWkDnmU2dz6fbcPJZZ+MZ99ufI00OV0dtXM/5iwQYa
         TRhXLPQ7770x6uYGZpXh0PNG6QgnVOs7pfbnky7et5OTP+u+ILqWLQO8xxT0ubzxHZDs
         xTberFrFgWByTaLpLeEnx2bPc3wIll9J2pWMoiSlZpKjZDm2xdOla93BrGrauzFOFSY3
         bpEQ==
X-Gm-Message-State: AOAM5338Lk17KzKbtzmLcJXSXEUIDymBQwRgi6yvymh9a/c4frGoEWmn
        Qqhol/78jatSVxj4dJ2vNmc=
X-Google-Smtp-Source: ABdhPJycsKD8TliiRJKggZ9pz79tbD3yWTffp+g43TndWMTzi9kZMZURt2MMRpRSeq4spvWtZ8hMCA==
X-Received: by 2002:a63:1f19:: with SMTP id f25mr4755943pgf.232.1602881621736;
        Fri, 16 Oct 2020 13:53:41 -0700 (PDT)
Received: from google.com ([2620:15c:211:1:7220:84ff:fe09:5e58])
        by smtp.gmail.com with ESMTPSA id q13sm3893651pfg.3.2020.10.16.13.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 13:53:40 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Fri, 16 Oct 2020 13:53:36 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Mike Rapoport <rppt@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
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
        Sami Tolvanen <samitolvanen@google.com>,
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
        christophe.leroy@c-s.fr, Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [External] Re: [PATCH] mm: proc: add Sock to /proc/meminfo
Message-ID: <20201016205336.GE1976566@google.com>
References: <20201010103854.66746-1-songmuchun@bytedance.com>
 <CAM_iQpUQXctR8UBNRP6td9dWTA705tP5fWKj4yZe9gOPTn_8oQ@mail.gmail.com>
 <CAMZfGtUhVx_iYY3bJZRY5s1PG0N1mCsYGS9Oku8cTqPiMDze-g@mail.gmail.com>
 <CANn89iKprp7WYeZy4RRO5jHykprnSCcVBc7Tk14Ui_MA9OK7Fg@mail.gmail.com>
 <CAMZfGtXVKER_GM-wwqxrUshDzcEg9FkS3x_BaMTVyeqdYPGSkw@mail.gmail.com>
 <9262ea44-fc3a-0b30-54dd-526e16df85d1@gmail.com>
 <CAMZfGtVF6OjNuJFUExRMY1k-EaDS744=nKy6_a2cYdrJRncTgQ@mail.gmail.com>
 <20201013080906.GD4251@kernel.org>
 <8d1558e7-cd09-1f9e-edab-5f22c5bfc342@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d1558e7-cd09-1f9e-edab-5f22c5bfc342@suse.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 05:38:26PM +0200, Vlastimil Babka wrote:
> On 10/13/20 10:09 AM, Mike Rapoport wrote:
> > > We are not complaining about TCP using too much memory, but how do
> > > we know that TCP uses a lot of memory. When I firstly face this problem,
> > > I do not know who uses the 25GB memory and it is not shown in the /proc/meminfo.
> > > If we can know the amount memory of the socket buffer via /proc/meminfo, we
> > > may not need to spend a lot of time troubleshooting this problem. Not everyone
> > > knows that a lot of memory may be used here. But I believe many people
> > > should know /proc/meminfo to confirm memory users.
> > If I undestand correctly, the problem you are trying to solve is to
> > simplify troubleshooting of memory usage for people who may not be aware
> > that networking stack can be a large memory consumer.
> > 
> > For that a paragraph in 'man 5 proc' maybe a good start:
> 
> Yeah. Another major consumer that I've seen at some point was xfs buffers.

As well, there are other various type of memory consumers in embedded world,
depending on the features what they supprted, too. They often tempted to add
the memory consumption into /proc/meminfo or /proc/vmstat, too to get
memory visibility.

> And there might be others, and adding everything to /proc/meminfo is not
> feasible. I have once proposed adding a counter called "Unaccounted:" which
> would at least tell the user easily if a significant portion is occupied by
> memory not explained by the other meminfo counters, and look for trends
> (increase = potential memory leak?). For specific prominent consumers not
> covered by meminfo but that have some kind of internal counters, we could
> document where to look, such as /proc/net/sockstat or maybe create some
> /proc/ or /sys directory with file per consumer so that it's still easy to
> check, but without the overhead of global counters and bloated
> /proc/meminfo?

What have in my mind is to support simple general sysfs infra from MM for
driver/subysstems rather than creating each own memory stat. The API
could support flexible accounting like just global memory consumption and/or
consmption by key(e.g,. pid or each own special) for the detail.

So, they are all shown under /sys/kernel/mm/misc/ with detail as well as
/proc/meminfo with simple line for global.

Furthermore, I'd like to plug the infra into OOM message so once OOM occurs,
we could print each own hidden memory usage from driver side if the driver
believe they could be memory hogger. It would make easier to detect
such kinds of leak or hogging as well as better maintainace.
