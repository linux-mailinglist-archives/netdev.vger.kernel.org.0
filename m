Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434151D7F88
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 19:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgERRCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 13:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbgERRCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 13:02:34 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE617C061A0C;
        Mon, 18 May 2020 10:02:34 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id y85so4811198oie.11;
        Mon, 18 May 2020 10:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9exVgl+yKCZr1tkPCgpnPxs0p9K6C95pMaN9BrP8zH8=;
        b=BSDO4CJwBIRAoYw0Kd+SjN6/cVpxRcv/XdaSSDOCZHBnxRBPQyXi2yaHVWwTtlD7ds
         smhxpOG+e9WsPsg482J7fTQQN3BfG8IC748W+85mhSFMr+eX8u8/mm0iYczp9b8wmIXH
         qQzrqXbS2OxudNtmGAIA6PrqrGGalecjvFJV2jNlRM9DNvWo64zL69O6lgIG4e8poJ5+
         BpiVtXV8gM/NBx2h99cm6Jc020sLwVHap5Eg/IuHJ/I+WpzSzuvONP5ICVDcrKQ77nRV
         ZACbI8LjrLOv4lMR1DOjUjqyZ2Gw5eKmbG+cSylrxuwytuHJH8n8vIGGZH+M2xhy0bRR
         25aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9exVgl+yKCZr1tkPCgpnPxs0p9K6C95pMaN9BrP8zH8=;
        b=hnsJJ1f+1a/HWK+C76QzjE7/GZ3qcTn0S4HsSudCbSJ8CO80ph62qg+hf7ZVDv99Vw
         yzhwiTqMZA7gfknjswLWmHtU/gjKR7dx2Nu7+tCbVZi4lRN5Lv55h8xKeUjZVT6BS/y6
         Rqpb7RMWK4Wpw7CJaOPyOku7vLttnyTGAwk4JYYQrR5sE5HzcJu9rU32/8SvRhLVSvMr
         KDcTgUUVHi3dduqBO9N9vLMwAv59ZlcThqiTMFRuUt78OU4+tetEOEpbP6+PVRqcO+pY
         t2InDkyWbhq/ff6v1Wq7eA4e9bG3hwEPUVAi+D2dAaBHx4tRLQ55LgX5rPgiGMWc/T/g
         MAqw==
X-Gm-Message-State: AOAM5322eMqquCazagvQ9jKv2DfaEDa3YtJRN0zSC7aalxe58CLjjRDn
        LnriwqUzNTYnE6ZhG6KIIls0WxNPkXVQezR+W8M=
X-Google-Smtp-Source: ABdhPJwfjTtgqyziB52cLco6fOXcRdE8uujfq2i2bN5yyuccJjmBue8kz3CSue987iYNnfKfdoVQsTaIMPrkzfidln0=
X-Received: by 2002:aca:a948:: with SMTP id s69mr256645oie.140.1589821354147;
 Mon, 18 May 2020 10:02:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200514221142.11857-1-casey@schaufler-ca.com> <20200514221142.11857-6-casey@schaufler-ca.com>
In-Reply-To: <20200514221142.11857-6-casey@schaufler-ca.com>
From:   Stephen Smalley <stephen.smalley.work@gmail.com>
Date:   Mon, 18 May 2020 13:02:23 -0400
Message-ID: <CAEjxPJ4TExFpm0KJSodLSEG0J+YNYBE4KdKyd=1g-Qs-qgPHpA@mail.gmail.com>
Subject: Re: [PATCH v17 05/23] net: Prepare UDS for security module stacking
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     casey.schaufler@intel.com, James Morris <jmorris@namei.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        SElinux list <selinux@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        John Johansen <john.johansen@canonical.com>,
        penguin-kernel@i-love.sakura.ne.jp,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>, linux-audit@redhat.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 7:25 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>
> Change the data used in UDS SO_PEERSEC processing from a
> secid to a more general struct lsmblob. Update the
> security_socket_getpeersec_dgram() interface to use the
> lsmblob. There is a small amount of scaffolding code
> that will come out when the security_secid_to_secctx()
> code is brought in line with the lsmblob.
>
> The secid field of the unix_skb_parms structure has been
> replaced with a pointer to an lsmblob structure, and the
> lsmblob is allocated as needed. This is similar to how the
> list of passed files is managed. While an lsmblob structure
> will fit in the available space today, there is no guarantee
> that the addition of other data to the unix_skb_parms or
> support for additional security modules wouldn't exceed what
> is available.

I preferred the previous approach (in v15 and earlier) but I see that
this was suggested by Paul.  Lifecycle management of lsmdata seems
rather tenuous. I guess the real question is what does netdev prefer.
Regardless, you need to check for memory allocation failure below if
this approach stands.

> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> cc: netdev@vger.kernel.org
> ---

> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 3385a7a0b231..a5c1a029095d 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -138,17 +138,18 @@ static struct hlist_head *unix_sockets_unbound(void *addr)
>  #ifdef CONFIG_SECURITY_NETWORK
>  static void unix_get_secdata(struct scm_cookie *scm, struct sk_buff *skb)
>  {
> -       UNIXCB(skb).secid = scm->secid;
> +       UNIXCB(skb).lsmdata = kmemdup(&scm->lsmblob, sizeof(scm->lsmblob),
> +                                     GFP_KERNEL);
>  }

Somewhere you need to check for and handle kmemdup() failure here.

>
>  static inline void unix_set_secdata(struct scm_cookie *scm, struct sk_buff *skb)
>  {
> -       scm->secid = UNIXCB(skb).secid;
> +       scm->lsmblob = *(UNIXCB(skb).lsmdata);
>  }

Lest we have a bad day here.

>
>  static inline bool unix_secdata_eq(struct scm_cookie *scm, struct sk_buff *skb)
>  {
> -       return (scm->secid == UNIXCB(skb).secid);
> +       return lsmblob_equal(&scm->lsmblob, UNIXCB(skb).lsmdata);
>  }

Or here.

> diff --git a/net/unix/scm.c b/net/unix/scm.c
> index 8c40f2b32392..3094323935a4 100644
> --- a/net/unix/scm.c
> +++ b/net/unix/scm.c
> @@ -142,6 +142,12 @@ void unix_destruct_scm(struct sk_buff *skb)
>         scm.pid  = UNIXCB(skb).pid;
>         if (UNIXCB(skb).fp)
>                 unix_detach_fds(&scm, skb);
> +#ifdef CONFIG_SECURITY_NETWORK
> +       if (UNIXCB(skb).lsmdata) {
> +               kfree(UNIXCB(skb).lsmdata);
> +               UNIXCB(skb).lsmdata = NULL;
> +       }
> +#endif

Does this suffice to ensure that lsmdata is always freed?  Seems
weakly connected to the allocation.
