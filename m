Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8B92908A1
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 17:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410331AbgJPPib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 11:38:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:34684 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408462AbgJPPia (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 11:38:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 71872ABE3;
        Fri, 16 Oct 2020 15:38:28 +0000 (UTC)
To:     Mike Rapoport <rppt@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
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
        linux-mm <linux-mm@kvack.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
References: <20201010103854.66746-1-songmuchun@bytedance.com>
 <CAM_iQpUQXctR8UBNRP6td9dWTA705tP5fWKj4yZe9gOPTn_8oQ@mail.gmail.com>
 <CAMZfGtUhVx_iYY3bJZRY5s1PG0N1mCsYGS9Oku8cTqPiMDze-g@mail.gmail.com>
 <CANn89iKprp7WYeZy4RRO5jHykprnSCcVBc7Tk14Ui_MA9OK7Fg@mail.gmail.com>
 <CAMZfGtXVKER_GM-wwqxrUshDzcEg9FkS3x_BaMTVyeqdYPGSkw@mail.gmail.com>
 <9262ea44-fc3a-0b30-54dd-526e16df85d1@gmail.com>
 <CAMZfGtVF6OjNuJFUExRMY1k-EaDS744=nKy6_a2cYdrJRncTgQ@mail.gmail.com>
 <20201013080906.GD4251@kernel.org>
From:   Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [External] Re: [PATCH] mm: proc: add Sock to /proc/meminfo
Message-ID: <8d1558e7-cd09-1f9e-edab-5f22c5bfc342@suse.cz>
Date:   Fri, 16 Oct 2020 17:38:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201013080906.GD4251@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/20 10:09 AM, Mike Rapoport wrote:
>> We are not complaining about TCP using too much memory, but how do
>> we know that TCP uses a lot of memory. When I firstly face this problem,
>> I do not know who uses the 25GB memory and it is not shown in the /proc/meminfo.
>> If we can know the amount memory of the socket buffer via /proc/meminfo, we
>> may not need to spend a lot of time troubleshooting this problem. Not everyone
>> knows that a lot of memory may be used here. But I believe many people
>> should know /proc/meminfo to confirm memory users.
> If I undestand correctly, the problem you are trying to solve is to
> simplify troubleshooting of memory usage for people who may not be aware
> that networking stack can be a large memory consumer.
> 
> For that a paragraph in 'man 5 proc' maybe a good start:

Yeah. Another major consumer that I've seen at some point was xfs buffers. And 
there might be others, and adding everything to /proc/meminfo is not feasible. I 
have once proposed adding a counter called "Unaccounted:" which would at least 
tell the user easily if a significant portion is occupied by memory not 
explained by the other meminfo counters, and look for trends (increase = 
potential memory leak?). For specific prominent consumers not covered by meminfo 
but that have some kind of internal counters, we could document where to look, 
such as /proc/net/sockstat or maybe create some /proc/ or /sys directory with 
file per consumer so that it's still easy to check, but without the overhead of 
global counters and bloated /proc/meminfo?

>  From ddbcf38576d1a2b0e36fe25a27350d566759b664 Mon Sep 17 00:00:00 2001
> From: Mike Rapoport<rppt@linux.ibm.com>
> Date: Tue, 13 Oct 2020 11:07:35 +0300
> Subject: [PATCH] proc.5: meminfo: add not anout network stack memory
>   consumption
> 
> Signed-off-by: Mike Rapoport<rppt@linux.ibm.com>
> ---
>   man5/proc.5 | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/man5/proc.5 b/man5/proc.5
> index ed309380b..8414676f1 100644
> --- a/man5/proc.5
> +++ b/man5/proc.5
> @@ -3478,6 +3478,14 @@ Except as noted below,
>   all of the fields have been present since at least Linux 2.6.0.
>   Some fields are displayed only if the kernel was configured
>   with various options; those dependencies are noted in the list.
> +.IP
> +Note that significant part of memory allocated by the network stack
> +is not accounted in the file.
> +The memory consumption of the network stack can be queried
> +using
> +.IR /proc/net/sockstat
> +or
> +.BR ss (8)
>   .RS
>   .TP
>   .IR MemTotal " %lu"
> -- 2.25.4

