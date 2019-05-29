Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E51272D52E
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 07:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbfE2FoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 01:44:04 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:55215 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbfE2FoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 01:44:04 -0400
Received: by mail-it1-f193.google.com with SMTP id h20so1677966itk.4
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 22:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oFeO2pNFJf6EPFlWoijieql2fbjpu9o1pB542sBv6t4=;
        b=r7DxD2DyBA3QiC9RkLpXhl5TUuSzjkp61yi8h43+YLpF4mNlHpBabDT2bnWW3PuhWK
         e9jBsxkjelu1GyabOILGciMXYuhEPENTXmNH4ZLsZLlqFeGRWV/AZGO53wT6G9+mrGwG
         OMUxdHOgoI4yXavXaXmevxW8zUM0OVss1soY/HaPdmkscm/pugCESlXDurNL4ayskKG8
         JIUAbQbotDQ4OJfL6UzFsYaI/R5ok+EvXIzKaJB8xShR8/oMa9eA1WCK5neNvVV1x7rJ
         YyDo3yO+BFxLxTWrMDsLAfSmIsPe8lpw4X7ChWZ14SdMZLCRCfwJ96eN1TLSp8WDD/Rn
         sgkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oFeO2pNFJf6EPFlWoijieql2fbjpu9o1pB542sBv6t4=;
        b=UFAJlzmZJaY4bNcs9UT4dpUd3OaJg2VWLzVMBpBqpiZR6gxr95r5dxxNnOq+U0eCvY
         +3iOS9ViNVvJqZNXobLnu5fNDZZz61cDZwpJeJ8z+ewpM49NMWgJPpdEX1c45vCGYYvU
         lzZGOKVpeMPmkjwpwwbysEuncOdl3B5MdvVz3raFX7mjeEVm3YrPLaJlI26Kkcj9e755
         fljJ2gvvKouFzvbKUZeCsPy1eGGs7rVFF7AzHODmuIS6ppq/WfvCsY9t5NpJnU4z3xO3
         vu59Dm6eYamnQ9RGXSr8xTnsP4NUVVXXUvnLC9JEOlIO6rOMVIosZyhm3RtVyFDFWFLv
         9oNw==
X-Gm-Message-State: APjAAAW5w5RrV0Z19DqP7TXRIYihBGoRpW3DNbbr5esv4Z81hP/ZM6xb
        4G1KdYcX7CdifhMdHg/VNBpVSED/WbreYRjk5LpC/A==
X-Google-Smtp-Source: APXvYqw6p+WQVwsOhANwhbLFi2EDxfjolFdtAxNXBya3SgGxbRITXdInr1qWzqUqa1YimKDPZ0ZrsFiLmFma9yB5Kuc=
X-Received: by 2002:a24:104a:: with SMTP id 71mr6065254ity.76.1559108643195;
 Tue, 28 May 2019 22:44:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190524160340.169521-12-edumazet@google.com> <20190528063403.ukfh37igryq4u2u6@gondor.apana.org.au>
 <CANn89i+NfFLHDthLC-=+vWV6fFSqddVqhnAWE_+mHRD9nQsNyw@mail.gmail.com> <20190529054026.fwcyhzt33dshma4h@gondor.apana.org.au>
In-Reply-To: <20190529054026.fwcyhzt33dshma4h@gondor.apana.org.au>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 29 May 2019 07:43:51 +0200
Message-ID: <CACT4Y+Y39u9VL+C27PVpfVZbNP_U8yFG35yLy6_KaxK2+Z9Gyw@mail.gmail.com>
Subject: Re: [PATCH] inet: frags: Remove unnecessary smp_store_release/READ_ONCE
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 7:40 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, May 28, 2019 at 06:31:00AM -0700, Eric Dumazet wrote:
> >
> > This smp_store_release() is a left over of the first version of the patch, where
> > there was no rcu grace period enforcement.
> >
> > I do not believe there is harm letting this, but if you disagree
> > please send a patch ;)
>
> I see now that it is actually relying on the barrier/locking
> semantics of call_rcu vs. rcu_read_lock.  So the smp_store_release
> and READ_ONCE are simply unnecessary and could be confusing to
> future readers.
>
> ---8<---
> The smp_store_release call in fqdir_exit cannot protect the setting
> of fqdir->dead as claimed because its memory barrier is only
> guaranteed to be one-way and the barrier precedes the setting of
> fqdir->dead.
>
> IOW it doesn't provide any barriers between fq->dir and the following
> hash table destruction.
>
> In fact, the code is safe anyway because call_rcu does provide both
> the memory barrier as well as a guarantee that when the destruction
> work starts executing all RCU readers will see the updated value for
> fqdir->dead.
>
> Therefore this patch removes the unnecessary smp_store_release call
> as well as the corresponding READ_ONCE on the read-side in order to
> not confuse future readers of this code.  Comments have been added
> in their places.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
> index 2b816f1ebbb4..35e9784fab4e 100644
> --- a/net/ipv4/inet_fragment.c
> +++ b/net/ipv4/inet_fragment.c
> @@ -193,10 +193,12 @@ void fqdir_exit(struct fqdir *fqdir)
>  {
>         fqdir->high_thresh = 0; /* prevent creation of new frags */
>
> -       /* paired with READ_ONCE() in inet_frag_kill() :
> -        * We want to prevent rhashtable_remove_fast() calls
> +       fqdir->dead = true;
> +
> +       /* call_rcu is supposed to provide memory barrier semantics,
> +        * separating the setting of fqdir->dead with the destruction
> +        * work.  This implicit barrier is paired with inet_frag_kill().
>          */
> -       smp_store_release(&fqdir->dead, true);
>
>         INIT_RCU_WORK(&fqdir->destroy_rwork, fqdir_rwork_fn);
>         queue_rcu_work(system_wq, &fqdir->destroy_rwork);
> @@ -214,10 +216,12 @@ void inet_frag_kill(struct inet_frag_queue *fq)
>
>                 fq->flags |= INET_FRAG_COMPLETE;
>                 rcu_read_lock();
> -               /* This READ_ONCE() is paired with smp_store_release()
> -                * in inet_frags_exit_net().
> +               /* The RCU read lock provides a memory barrier
> +                * guaranteeing that if fqdir->dead is false then
> +                * the hash table destruction will not start until
> +                * after we unlock.  Paired with inet_frags_exit_net().
>                  */
> -               if (!READ_ONCE(fqdir->dead)) {
> +               if (!fqdir->dead) {

If fqdir->dead read/write are concurrent, then this still needs to be
READ_ONCE/WRITE_ONCE. Ordering is orthogonal to atomicity.

>                         rhashtable_remove_fast(&fqdir->rhashtable, &fq->node,
>                                                fqdir->f->rhash_params);
>                         refcount_dec(&fq->refcnt);
