Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F80928A96B
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 20:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727155AbgJKSjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 14:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgJKSjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 14:39:14 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8EF5C0613CE;
        Sun, 11 Oct 2020 11:39:14 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id n6so15408703ioc.12;
        Sun, 11 Oct 2020 11:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ihDBvmS0ut4DSKeE1V92ZLXhV60yzQeKm7MqEH3UbkE=;
        b=omOg9nngjeH2F9Dbb/TM0VIWCX3UYpHtX8QXXKU6Wi49Z7HBxoh8JJj0LrEs6V21k+
         IDFr+Xql22OeBgc7PX013oOTHyG9DTA2sG9CSgHvHnB9jsA58+YS0h7p91sSzydfrlN9
         1RZg0onwhTMveQ1nYGOEpbpcfcowZoubULaRr9Q2fJ4t7bFGKDA9nAFjNnsyvFl151K9
         q9wsmMGQoFNeUcKJ37tVf5HEUTY1JmYRc29u+gu6eT7BvYCiSBC12GxBgiIvtnSF8sOr
         JxSb58k1ZrKUUBSJmZDLdEWidS8VzAeUftUUbacInWRnlXcz3yxhcwzbam9z9Ks1E/rG
         M+rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ihDBvmS0ut4DSKeE1V92ZLXhV60yzQeKm7MqEH3UbkE=;
        b=D+EAFSUk3J51UIdkkq3UkZPSDDTjY2/IblHALbwE+PiISRa6LtRA6TKuQcnYmqN3TB
         05zhewBOJwNwjhem1D+aRIXNdsr2grfkRKC5Yi7/QsOB3PUg/oZE2B6y35zP1uj2Sh+s
         F//Vrp92fQNh/zmfusPsyuUF9cshQDfD/n+mgSiT0Pi0gJgheIiqIRIATWqU8MvrXi5i
         cNABOR9Ze5leObSH9HyR7+lj1uUKFJnSlWlEnhh3meVOCdKdjPVhZQ4eu3PplH9hLdmZ
         cQwCiHNrUB/AzADULoZy+2JVdp5ELKG/6tx43k7jrNdU/3YotoE1AOR4f+Se3ZyOggW6
         mFJA==
X-Gm-Message-State: AOAM531Pal6LIqdUgYuKzZYOfmNFagpifflmi284He1d1RxHTQJW+Ruu
        VT+OcdW8cAEEa44EcVDxd6M7lIiBvXGszslyzg8=
X-Google-Smtp-Source: ABdhPJxTF0j2v/9fJi8BunRtQlxMSiClZGK5c3sE9XRmWV7VBvPIX40VOP59eN5kOLWvuAg4icWlgLsDpVCM1/QHaos=
X-Received: by 2002:a02:94cd:: with SMTP id x71mr16450243jah.124.1602441553813;
 Sun, 11 Oct 2020 11:39:13 -0700 (PDT)
MIME-Version: 1.0
References: <20201010103854.66746-1-songmuchun@bytedance.com>
In-Reply-To: <20201010103854.66746-1-songmuchun@bytedance.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 11 Oct 2020 11:39:02 -0700
Message-ID: <CAM_iQpUQXctR8UBNRP6td9dWTA705tP5fWKj4yZe9gOPTn_8oQ@mail.gmail.com>
Subject: Re: [PATCH] mm: proc: add Sock to /proc/meminfo
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, rafael@kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, shakeelb@google.com,
        will@kernel.org, Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <guro@fb.com>, Neil Brown <neilb@suse.de>,
        rppt@kernel.org, samitolvanen@google.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Florian Westphal <fw@strlen.de>, gustavoars@kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>, decui@microsoft.com,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>, dave@stgolabs.net,
        walken@google.com, Jann Horn <jannh@google.com>,
        chenqiwu@xiaomi.com, christophe.leroy@c-s.fr,
        Minchan Kim <minchan@kernel.org>,
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

On Sat, Oct 10, 2020 at 3:39 AM Muchun Song <songmuchun@bytedance.com> wrote:
>
> The amount of memory allocated to sockets buffer can become significant.
> However, we do not display the amount of memory consumed by sockets
> buffer. In this case, knowing where the memory is consumed by the kernel

We do it via `ss -m`. Is it not sufficient? And if not, why not adding it there
rather than /proc/meminfo?

>  static inline void __skb_frag_unref(skb_frag_t *frag)
>  {
> -       put_page(skb_frag_page(frag));
> +       struct page *page = skb_frag_page(frag);
> +
> +       if (put_page_testzero(page)) {
> +               dec_sock_node_page_state(page);
> +               __put_page(page);
> +       }
>  }

You mix socket page frag with skb frag at least, not sure this is exactly
what you want, because clearly skb page frags are frequently used
by network drivers rather than sockets.

Also, which one matches this dec_sock_node_page_state()? Clearly
not skb_fill_page_desc() or __skb_frag_ref().

Thanks.
