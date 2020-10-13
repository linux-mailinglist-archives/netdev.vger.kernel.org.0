Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5513D28D145
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 17:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389495AbgJMP3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 11:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389463AbgJMP3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 11:29:20 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087E0C0613D5
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 08:29:20 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gv6so37696pjb.4
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 08:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xmr9b2Ggp8vOLTZ40kBRiYw2atMdRLPI8Ee7OiUDyHc=;
        b=lyyUl7Z9ThTPlq9D2rp4fQb4kHeOa2+gyk1WzoDlJ81EPW4a1S7cHQBclhadcWkuts
         +pTnQ3BZKMze2oN803izG6UhpDN8TPayQltN5p0sSHSa3Q7nCT+5KEjjlqOjqputq3cc
         4ogahHM0g0MZkQrVz8qlPbLicoR/9tbhsyClHF7hnEIXQcCq7uSJUv6sqHyRTrUSFtQv
         BQmWSD9+Sr2Tj/3BgV3HG+/mxrzsOUcpmJyZhsAwfAMUHuCWlTKpgYgQNlx6jCKoLHTC
         GgKJH5amJfyNqn+3LnJT3B77eLhaVCn3vQhI6w1MfbWQSBHHuO6zwVOyO2t8ZT6AwxZ8
         Pizg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xmr9b2Ggp8vOLTZ40kBRiYw2atMdRLPI8Ee7OiUDyHc=;
        b=he0g0OFbfPfHGaJRdK1I+LM2HXluz1+dCy3rD9yMRVtzJbg+q0wYe+oeHRuGBN+3Qk
         WvX1lz7Oe/G5nlnJgCcf+RE7lvXwlGVa7est9/4Wkmj0L+kjikY4oxbDI8+ufF4xeBmE
         XvnVWF8VZzhKg1c0EJ0hRlH/Qhbftwq16QNiGoi3x40KqpcstMxnFQYIvpEewdWFXwVP
         Xxk9YZD8ITaXczLOLtmTfYPEItkEkAVD46WSpWVaUI9ALLT0OtWUwSpB1nOkBIrMOjuV
         j66b+BgKkq4i2RdmCRFM5kbq8EMXzlrGStUuuZb8sGiQokEOXh+H1FT5QhiiV0S2SX9k
         JHzA==
X-Gm-Message-State: AOAM530KFD0UMUI/5wn+IwIPVrvu9552lgeawA2q4XleEGE9rk1cp2sR
        FuZtmpkOhc3v4yHKTvNz0bbzsNi8twRhbJxB4X9bfA==
X-Google-Smtp-Source: ABdhPJza1dCd7KiemxFvOO8CGqWiAW2qXHNbFR3rDPenQOK0HTo9HZRimzAjnS7d53o9A0B4BtDP+1rwCnL2rU9nptk=
X-Received: by 2002:a17:902:7681:b029:d2:88b1:b130 with SMTP id
 m1-20020a1709027681b02900d288b1b130mr393135pll.20.1602602959313; Tue, 13 Oct
 2020 08:29:19 -0700 (PDT)
MIME-Version: 1.0
References: <20201010103854.66746-1-songmuchun@bytedance.com>
 <CAM_iQpUQXctR8UBNRP6td9dWTA705tP5fWKj4yZe9gOPTn_8oQ@mail.gmail.com>
 <CAMZfGtUhVx_iYY3bJZRY5s1PG0N1mCsYGS9Oku8cTqPiMDze-g@mail.gmail.com>
 <CANn89iKprp7WYeZy4RRO5jHykprnSCcVBc7Tk14Ui_MA9OK7Fg@mail.gmail.com>
 <CAMZfGtXVKER_GM-wwqxrUshDzcEg9FkS3x_BaMTVyeqdYPGSkw@mail.gmail.com>
 <9262ea44-fc3a-0b30-54dd-526e16df85d1@gmail.com> <CAMZfGtVF6OjNuJFUExRMY1k-EaDS744=nKy6_a2cYdrJRncTgQ@mail.gmail.com>
 <20201013080906.GD4251@kernel.org>
In-Reply-To: <20201013080906.GD4251@kernel.org>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Tue, 13 Oct 2020 23:28:41 +0800
Message-ID: <CAMZfGtXX3xYjM49E3X1XByHmY-2B+B1VCXYArH+qeJ0Ci+RD4w@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] mm: proc: add Sock to /proc/meminfo
To:     Mike Rapoport <rppt@kernel.org>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 4:09 PM Mike Rapoport <rppt@kernel.org> wrote:
>
> On Mon, Oct 12, 2020 at 05:53:01PM +0800, Muchun Song wrote:
> > On Mon, Oct 12, 2020 at 5:24 PM Eric Dumazet <eric.dumazet@gmail.com> w=
rote:
> > >
> > > On 10/12/20 10:39 AM, Muchun Song wrote:
> > > > On Mon, Oct 12, 2020 at 3:42 PM Eric Dumazet <edumazet@google.com> =
wrote:
> > > >>
> > > >> On Mon, Oct 12, 2020 at 6:22 AM Muchun Song <songmuchun@bytedance.=
com> wrote:
> > > >>>
> > > >>> On Mon, Oct 12, 2020 at 2:39 AM Cong Wang <xiyou.wangcong@gmail.c=
om> wrote:
> > > >>>>
> > > >>>> On Sat, Oct 10, 2020 at 3:39 AM Muchun Song <songmuchun@bytedanc=
e.com> wrote:
> > > >>>>>
> > > >>>>> The amount of memory allocated to sockets buffer can become sig=
nificant.
> > > >>>>> However, we do not display the amount of memory consumed by soc=
kets
> > > >>>>> buffer. In this case, knowing where the memory is consumed by t=
he kernel
> > > >>>>
> > > >>>> We do it via `ss -m`. Is it not sufficient? And if not, why not =
adding it there
> > > >>>> rather than /proc/meminfo?
> > > >>>
> > > >>> If the system has little free memory, we can know where the memor=
y is via
> > > >>> /proc/meminfo. If a lot of memory is consumed by socket buffer, w=
e cannot
> > > >>> know it when the Sock is not shown in the /proc/meminfo. If the u=
naware user
> > > >>> can't think of the socket buffer, naturally they will not `ss -m`=
. The
> > > >>> end result
> > > >>> is that we still don=E2=80=99t know where the memory is consumed.=
 And we add the
> > > >>> Sock to the /proc/meminfo just like the memcg does('sock' item in=
 the cgroup
> > > >>> v2 memory.stat). So I think that adding to /proc/meminfo is suffi=
cient.
> > > >>>
> > > >>>>
> > > >>>>>  static inline void __skb_frag_unref(skb_frag_t *frag)
> > > >>>>>  {
> > > >>>>> -       put_page(skb_frag_page(frag));
> > > >>>>> +       struct page *page =3D skb_frag_page(frag);
> > > >>>>> +
> > > >>>>> +       if (put_page_testzero(page)) {
> > > >>>>> +               dec_sock_node_page_state(page);
> > > >>>>> +               __put_page(page);
> > > >>>>> +       }
> > > >>>>>  }
> > > >>>>
> > > >>>> You mix socket page frag with skb frag at least, not sure this i=
s exactly
> > > >>>> what you want, because clearly skb page frags are frequently use=
d
> > > >>>> by network drivers rather than sockets.
> > > >>>>
> > > >>>> Also, which one matches this dec_sock_node_page_state()? Clearly
> > > >>>> not skb_fill_page_desc() or __skb_frag_ref().
> > > >>>
> > > >>> Yeah, we call inc_sock_node_page_state() in the skb_page_frag_ref=
ill().
> > > >>> So if someone gets the page returned by skb_page_frag_refill(), i=
t must
> > > >>> put the page via __skb_frag_unref()/skb_frag_unref(). We use PG_p=
rivate
> > > >>> to indicate that we need to dec the node page state when the refc=
ount of
> > > >>> page reaches zero.
> > > >>>
> > > >>
> > > >> Pages can be transferred from pipe to socket, socket to pipe (spli=
ce()
> > > >> and zerocopy friends...)
> > > >>
> > > >>  If you want to track TCP memory allocations, you always can look =
at
> > > >> /proc/net/sockstat,
> > > >> without adding yet another expensive memory accounting.
> > > >
> > > > The 'mem' item in the /proc/net/sockstat does not represent real
> > > > memory usage. This is just the total amount of charged memory.
> > > >
> > > > For example, if a task sends a 10-byte message, it only charges one
> > > > page to memcg. But the system may allocate 8 pages. Therefore, it
> > > > does not truly reflect the memory allocated by the above memory
> > > > allocation path. We can see the difference via the following messag=
e.
> > > >
> > > > cat /proc/net/sockstat
> > > >   sockets: used 698
> > > >   TCP: inuse 70 orphan 0 tw 617 alloc 134 mem 13
> > > >   UDP: inuse 90 mem 4
> > > >   UDPLITE: inuse 0
> > > >   RAW: inuse 1
> > > >   FRAG: inuse 0 memory 0
> > > >
> > > > cat /proc/meminfo | grep Sock
> > > >   Sock:              13664 kB
> > > >
> > > > The /proc/net/sockstat only shows us that there are 17*4 kB TCP
> > > > memory allocations. But apply this patch, we can see that we truly
> > > > allocate 13664 kB(May be greater than this value because of per-cpu
> > > > stat cache). Of course the load of the example here is not high. In
> > > > some high load cases, I believe the difference here will be even
> > > > greater.
> > > >
> > >
> > > This is great, but you have not addressed my feedback.
> > >
> > > TCP memory allocations are bounded by /proc/sys/net/ipv4/tcp_mem
> > >
> > > Fact that the memory is forward allocated or not is a detail.
> > >
> > > If you think we must pre-allocate memory, instead of forward allocati=
ons,
> > > your patch does not address this. Adding one line per consumer in /pr=
oc/meminfo looks
> > > wrong to me.
> >
> > I think that the consumer which consumes a lot of memory should be adde=
d
> > to the /proc/meminfo. This can help us know the user of large memory.
> >
> > >
> > > If you do not want 9.37 % of physical memory being possibly used by T=
CP,
> > > just change /proc/sys/net/ipv4/tcp_mem accordingly ?
> >
> > We are not complaining about TCP using too much memory, but how do
> > we know that TCP uses a lot of memory. When I firstly face this problem=
,
> > I do not know who uses the 25GB memory and it is not shown in the /proc=
/meminfo.
> > If we can know the amount memory of the socket buffer via /proc/meminfo=
, we
> > may not need to spend a lot of time troubleshooting this problem. Not e=
veryone
> > knows that a lot of memory may be used here. But I believe many people
> > should know /proc/meminfo to confirm memory users.
>
> If I undestand correctly, the problem you are trying to solve is to
> simplify troubleshooting of memory usage for people who may not be aware
> that networking stack can be a large memory consumer.

Yeah, you are right. Although the information provided by /proc/net/socksta=
t
is not accurate, it can also provide some valuable information. I think tha=
t it
might be better if we can add a total amount socket buffer to /proc/meminfo=
.
The amount socket buffer statistics can be from /proc/net/sockstat directly=
.

Thanks.

>
> For that a paragraph in 'man 5 proc' maybe a good start:
>
> From ddbcf38576d1a2b0e36fe25a27350d566759b664 Mon Sep 17 00:00:00 2001
> From: Mike Rapoport <rppt@linux.ibm.com>
> Date: Tue, 13 Oct 2020 11:07:35 +0300
> Subject: [PATCH] proc.5: meminfo: add not anout network stack memory
>  consumption
>
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> ---
>  man5/proc.5 | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/man5/proc.5 b/man5/proc.5
> index ed309380b..8414676f1 100644
> --- a/man5/proc.5
> +++ b/man5/proc.5
> @@ -3478,6 +3478,14 @@ Except as noted below,
>  all of the fields have been present since at least Linux 2.6.0.
>  Some fields are displayed only if the kernel was configured
>  with various options; those dependencies are noted in the list.
> +.IP
> +Note that significant part of memory allocated by the network stack
> +is not accounted in the file.
> +The memory consumption of the network stack can be queried
> +using
> +.IR /proc/net/sockstat
> +or
> +.BR ss (8)
>  .RS
>  .TP
>  .IR MemTotal " %lu"
> --
> 2.25.4
>
>


--=20
Yours,
Muchun
