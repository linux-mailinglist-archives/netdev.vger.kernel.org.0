Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFEA95A3098
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 22:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344975AbiHZUkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 16:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344979AbiHZUke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 16:40:34 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C3FDABAE
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 13:40:32 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id g19so2633537pfb.0
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 13:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=6fiwnq1oAq0KiCuhfOdmhVlT/7/RP6UNM5leUYlPA7E=;
        b=OcpR5WTgkGpSIdSaqdCXAwVFzNVeAckXRGdse9kU+eo4mS/TNRW5AOfJ0Ejwk8bv1f
         YFyAvIKU22S3mVC4aTwLJk0fJIxGv9NQy2WuCOnMvrGdtrhZMFSM18yx9bZAFNOgS/G3
         dVXLnXrI4z4KoxuECUEtx3NMRspG/ZxQlQnvnLbsPiUpRF8jT2NLXZvZGBZXqqlfQwYS
         85foqE+G6q25Wlp3TsGMHew2NCkSSTsfZPd2sZ6uRVQMGE5ai4UtFWcrtrh7hMvKtCT9
         FV6VTMFENHb+BQ8oud+qTbNiSHvkRYxqVpRDCBCPNc2g6vPQEqrqtRqOblNOhXuhxVwO
         5nNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=6fiwnq1oAq0KiCuhfOdmhVlT/7/RP6UNM5leUYlPA7E=;
        b=G/ZbmgE/kbyEURJ3hmF15IhcuS/OyR0/MZXNIAJJrGn5SCUcmaN2Z10/+6dc9Rnwdj
         DwYKTjrl+leZkJ4lPPs5KuuJWd512gXErVmTIDSUtFWWjw7NTarvX4grWOlvmEQgCC1Q
         24JdY29TzLCWMc37X2sM4kMxX8sRi0n6ed26/UNlPkaeNuO3yw36cEGyD96AOPREQEWS
         CiFt++nhNnJEXheNooZAXjDccTBAh8WYQLpPQ4bzf9m/KlUcHr2I0g7x5AasbNBeiRIE
         hB+n2NEHNjwKjo5R6DTluK/Ud376HWUItonyQOoDsRw6apLCiauoRiV91CYTufgKJHSM
         Xe6g==
X-Gm-Message-State: ACgBeo00sgXZTloIv8ANfOe3mSIAPEOo5itMD/Ra5AavotEoK28Tfnbi
        +ElckSh8PWb/BL1FD2WmNw1nkspdvA9VQyoxTH4gHV1PO9UjwA==
X-Google-Smtp-Source: AA6agR4fnkMtguAYTzm3szr9QdMffQQ0VMAqIH84HS/WZUaTqPPOV3bxZIOc3ncqetj67u2xp0tKuSy3P1tHOp/A9hQ=
X-Received: by 2002:a63:1043:0:b0:429:fd41:b7cb with SMTP id
 3-20020a631043000000b00429fd41b7cbmr4495625pgq.442.1661546432119; Fri, 26 Aug
 2022 13:40:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220824222601.1916776-1-kafai@fb.com> <20220824222614.1918332-1-kafai@fb.com>
 <CAKH8qBtT332XrJ3aEw=o_9K+g6LYHbdhPG7s8R1uuNbKBso0+Q@mail.gmail.com> <20220826191543.dtrrhcga5ynuyrw2@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220826191543.dtrrhcga5ynuyrw2@kafai-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 26 Aug 2022 13:40:21 -0700
Message-ID: <CAKH8qBsieDiRYXs805RmkbrcVTmmrekc=3Ctp8yBWWT5rp=3vg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 02/17] bpf: net: Change sk_getsockopt() to take
 the sockptr_t argument
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 12:15 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Aug 25, 2022 at 11:07:36AM -0700, Stanislav Fomichev wrote:
> > On Wed, Aug 24, 2022 at 3:29 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > This patch changes sk_getsockopt() to take the sockptr_t argument
> > > such that it can be used by bpf_getsockopt(SOL_SOCKET) in a
> > > latter patch.
> > >
> > > security_socket_getpeersec_stream() is not changed.  It stays
> > > with the __user ptr (optval.user and optlen.user) to avoid changes
> > > to other security hooks.  bpf_getsockopt(SOL_SOCKET) also does not
> > > support SO_PEERSEC.
> > >
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> > >  include/linux/filter.h  |  3 +--
> > >  include/linux/sockptr.h |  5 +++++
> > >  net/core/filter.c       |  5 ++---
> > >  net/core/sock.c         | 43 +++++++++++++++++++++++------------------
> > >  4 files changed, 32 insertions(+), 24 deletions(-)
> > >
> > > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > > index a5f21dc3c432..527ae1d64e27 100644
> > > --- a/include/linux/filter.h
> > > +++ b/include/linux/filter.h
> > > @@ -900,8 +900,7 @@ int sk_reuseport_attach_filter(struct sock_fprog *fprog, struct sock *sk);
> > >  int sk_reuseport_attach_bpf(u32 ufd, struct sock *sk);
> > >  void sk_reuseport_prog_free(struct bpf_prog *prog);
> > >  int sk_detach_filter(struct sock *sk);
> > > -int sk_get_filter(struct sock *sk, struct sock_filter __user *filter,
> > > -                 unsigned int len);
> > > +int sk_get_filter(struct sock *sk, sockptr_t optval, unsigned int len);
> > >
> > >  bool sk_filter_charge(struct sock *sk, struct sk_filter *fp);
> > >  void sk_filter_uncharge(struct sock *sk, struct sk_filter *fp);
> > > diff --git a/include/linux/sockptr.h b/include/linux/sockptr.h
> > > index d45902fb4cad..bae5e2369b4f 100644
> > > --- a/include/linux/sockptr.h
> > > +++ b/include/linux/sockptr.h
> > > @@ -64,6 +64,11 @@ static inline int copy_to_sockptr_offset(sockptr_t dst, size_t offset,
> > >         return 0;
> > >  }
> > >
> > > +static inline int copy_to_sockptr(sockptr_t dst, const void *src, size_t size)
> > > +{
> > > +       return copy_to_sockptr_offset(dst, 0, src, size);
> > > +}
> > > +
> > >  static inline void *memdup_sockptr(sockptr_t src, size_t len)
> > >  {
> > >         void *p = kmalloc_track_caller(len, GFP_USER | __GFP_NOWARN);
> > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > index 63e25d8ce501..0f6f86b9e487 100644
> > > --- a/net/core/filter.c
> > > +++ b/net/core/filter.c
> > > @@ -10712,8 +10712,7 @@ int sk_detach_filter(struct sock *sk)
> > >  }
> > >  EXPORT_SYMBOL_GPL(sk_detach_filter);
> > >
> > > -int sk_get_filter(struct sock *sk, struct sock_filter __user *ubuf,
> > > -                 unsigned int len)
> > > +int sk_get_filter(struct sock *sk, sockptr_t optval, unsigned int len)
> > >  {
> > >         struct sock_fprog_kern *fprog;
> > >         struct sk_filter *filter;
> > > @@ -10744,7 +10743,7 @@ int sk_get_filter(struct sock *sk, struct sock_filter __user *ubuf,
> > >                 goto out;
> > >
> > >         ret = -EFAULT;
> > > -       if (copy_to_user(ubuf, fprog->filter, bpf_classic_proglen(fprog)))
> > > +       if (copy_to_sockptr(optval, fprog->filter, bpf_classic_proglen(fprog)))
> > >                 goto out;
> > >
> > >         /* Instead of bytes, the API requests to return the number
> > > diff --git a/net/core/sock.c b/net/core/sock.c
> > > index 21bc4bf6b485..7fa30fd4b37f 100644
> > > --- a/net/core/sock.c
> > > +++ b/net/core/sock.c
> > > @@ -712,8 +712,8 @@ static int sock_setbindtodevice(struct sock *sk, sockptr_t optval, int optlen)
> > >         return ret;
> > >  }
> > >
> > > -static int sock_getbindtodevice(struct sock *sk, char __user *optval,
> > > -                               int __user *optlen, int len)
> > > +static int sock_getbindtodevice(struct sock *sk, sockptr_t optval,
> > > +                               sockptr_t optlen, int len)
> > >  {
> > >         int ret = -ENOPROTOOPT;
> > >  #ifdef CONFIG_NETDEVICES
> > > @@ -737,12 +737,12 @@ static int sock_getbindtodevice(struct sock *sk, char __user *optval,
> > >         len = strlen(devname) + 1;
> > >
> > >         ret = -EFAULT;
> > > -       if (copy_to_user(optval, devname, len))
> > > +       if (copy_to_sockptr(optval, devname, len))
> > >                 goto out;
> > >
> > >  zero:
> > >         ret = -EFAULT;
> > > -       if (put_user(len, optlen))
> > > +       if (copy_to_sockptr(optlen, &len, sizeof(int)))
> > >                 goto out;
> > >
> > >         ret = 0;
> > > @@ -1568,20 +1568,23 @@ static void cred_to_ucred(struct pid *pid, const struct cred *cred,
> > >         }
> > >  }
> > >
> > > -static int groups_to_user(gid_t __user *dst, const struct group_info *src)
> > > +static int groups_to_user(sockptr_t dst, const struct group_info *src)
> > >  {
> > >         struct user_namespace *user_ns = current_user_ns();
> > >         int i;
> > >
> > > -       for (i = 0; i < src->ngroups; i++)
> > > -               if (put_user(from_kgid_munged(user_ns, src->gid[i]), dst + i))
> > > +       for (i = 0; i < src->ngroups; i++) {
> > > +               gid_t gid = from_kgid_munged(user_ns, src->gid[i]);
> > > +
> > > +               if (copy_to_sockptr_offset(dst, i * sizeof(gid), &gid, sizeof(gid)))
> > >                         return -EFAULT;
> > > +       }
> > >
> > >         return 0;
> > >  }
> > >
> > >  static int sk_getsockopt(struct sock *sk, int level, int optname,
> > > -                        char __user *optval, int __user *optlen)
> > > +                        sockptr_t optval, sockptr_t optlen)
> > >  {
> > >         struct socket *sock = sk->sk_socket;
> > >
> > > @@ -1600,7 +1603,7 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
> > >         int lv = sizeof(int);
> > >         int len;
> > >
> > > -       if (get_user(len, optlen))
> > > +       if (copy_from_sockptr(&len, optlen, sizeof(int)))
> >
> > Do we want to be consistent wrt to sizeof?
> >
> > copy_from_sockptr(&len, optlen, sizeof(int))
> > vs
> > copy_from_sockptr(&len, optlen, sizeof(optlen))
> optlen type is sockptr_t now. sizeof(optlen) won't work.
>
> so either
>
> copy_from_sockptr(&len, optlen, sizeof(len))
> or
> copy_from_sockptr(&len, optlen, sizeof(int))
>
> I went with the latter 'sizeof(int)' for consistency because the
> name is not always 'len' but optlen is always in 'int'.
>
> >
> > Alternatively, should we have put_sockptr/get_sockopt with a semantics
> > similar to put_user/get_user to remove all this ambiguity?
> The type is lost in sockptr.{kernel,user} which is 'void *'.  {get,put}_user()
> depends on it.  The very early sockptr_t introduction also changes
> get_user() to copy_from_sockptr() for integer value.
>
> One option could be to make {get,put}_sockopt(x, sockptr) to use x to decide the
> type.  Not sure how that may look like.  I can give it a try.

I was thinking:
#define get_sockopt(x, ptr) copy_from_sockptr(&x, ptr, sizeof(x))

I was also slightly preferring the following:
copy_from_sockptr(&len, optlen, sizeof(len))

But now I'm not sure. I guess with that call, we really want
sizeof(len) == sizeof(actual pointer of optlen data).
So maybe the way you do it, with explicit sizeof(int), communicates it better.

Let's keep your version for now, because I'm not sure whatever I'm
suggesting actually makes it better..

> >
> > >                 return -EFAULT;
> > >         if (len < 0)
> > >                 return -EINVAL;
> > > @@ -1735,7 +1738,7 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
> > >                 cred_to_ucred(sk->sk_peer_pid, sk->sk_peer_cred, &peercred);
> > >                 spin_unlock(&sk->sk_peer_lock);
> > >
> > > -               if (copy_to_user(optval, &peercred, len))
> > > +               if (copy_to_sockptr(optval, &peercred, len))
> > >                         return -EFAULT;
> > >                 goto lenout;
> > >         }
> > > @@ -1753,11 +1756,11 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
> > >                 if (len < n * sizeof(gid_t)) {
> > >                         len = n * sizeof(gid_t);
> > >                         put_cred(cred);
> > > -                       return put_user(len, optlen) ? -EFAULT : -ERANGE;
> > > +                       return copy_to_sockptr(optlen, &len, sizeof(int)) ? -EFAULT : -ERANGE;
> > >                 }
> > >                 len = n * sizeof(gid_t);
> > >
> > > -               ret = groups_to_user((gid_t __user *)optval, cred->group_info);
> > > +               ret = groups_to_user(optval, cred->group_info);
> > >                 put_cred(cred);
> > >                 if (ret)
> > >                         return ret;
> > > @@ -1773,7 +1776,7 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
> > >                         return -ENOTCONN;
> > >                 if (lv < len)
> > >                         return -EINVAL;
> > > -               if (copy_to_user(optval, address, len))
> > > +               if (copy_to_sockptr(optval, address, len))
> > >                         return -EFAULT;
> > >                 goto lenout;
> > >         }
> > > @@ -1790,7 +1793,7 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
> > >                 break;
> > >
> > >         case SO_PEERSEC:
> > > -               return security_socket_getpeersec_stream(sock, optval, optlen, len);
> > > +               return security_socket_getpeersec_stream(sock, optval.user, optlen.user, len);
> >
> > I'm assuming there should be something to prevent this being called
> > from BPF? (haven't read all the patches yet)
> Not sure if any of the hooks may block.

I wasn't clear with my question. I found the answer later on, need to
develop a habit of not pressing 'send' before I read the whole series
:-)
You do the checks in sol_socket_sockopt to ignore that SO_PEERSEC from bpf.

> > Do we want to be a bit more defensive with 'if (!optval.user) return
> > -EFAULT' or something similar?
> Checking 'optval.is_kernel || optlen.is_kernel'?
> Yep.  Make sense.  It may be better to do the check inside
> security_socket_getpeersec_stream(sock, optval, optlen, ...).
>
> >
> >
> > >         case SO_MARK:
> > >                 v.val = sk->sk_mark;
> > > @@ -1822,7 +1825,7 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
> > >                 return sock_getbindtodevice(sk, optval, optlen, len);
> > >
> > >         case SO_GET_FILTER:
> > > -               len = sk_get_filter(sk, (struct sock_filter __user *)optval, len);
> > > +               len = sk_get_filter(sk, optval, len);
> > >                 if (len < 0)
> > >                         return len;
> > >
> > > @@ -1870,7 +1873,7 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
> > >                 sk_get_meminfo(sk, meminfo);
> > >
> > >                 len = min_t(unsigned int, len, sizeof(meminfo));
> > > -               if (copy_to_user(optval, &meminfo, len))
> > > +               if (copy_to_sockptr(optval, &meminfo, len))
> > >                         return -EFAULT;
> > >
> > >                 goto lenout;
> > > @@ -1939,10 +1942,10 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
> > >
> > >         if (len > lv)
> > >                 len = lv;
> > > -       if (copy_to_user(optval, &v, len))
> > > +       if (copy_to_sockptr(optval, &v, len))
> > >                 return -EFAULT;
> > >  lenout:
> > > -       if (put_user(len, optlen))
> > > +       if (copy_to_sockptr(optlen, &len, sizeof(int)))
> > >                 return -EFAULT;
> > >         return 0;
> > >  }
> > > @@ -1950,7 +1953,9 @@ static int sk_getsockopt(struct sock *sk, int level, int optname,
> > >  int sock_getsockopt(struct socket *sock, int level, int optname,
> > >                     char __user *optval, int __user *optlen)
> > >  {
> > > -       return sk_getsockopt(sock->sk, level, optname, optval, optlen);
> > > +       return sk_getsockopt(sock->sk, level, optname,
> > > +                            USER_SOCKPTR(optval),
> > > +                            USER_SOCKPTR(optlen));
> > >  }
> > >
> > >  /*
> > > --
> > > 2.30.2
> > >
