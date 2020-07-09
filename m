Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A5321A470
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 18:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgGIQLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 12:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgGIQLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 12:11:41 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EA4C08C5CE;
        Thu,  9 Jul 2020 09:11:41 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id t6so446532ooh.4;
        Thu, 09 Jul 2020 09:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kZ7CRfTCDKAUDTKyzES9VQDLbhMjlfTZPr986Ha/X2I=;
        b=RoEAExbrT6iBRND+sKPjht/k1/UiGKztrND1xlnbqqjqV7QbnPf/RIQrdFl5mwzzYc
         yXsbBWQUZLAQXl4feucYvtUa6FL4k96qxAraZjOStVtikLNqCJSYrK1GL7W6JXUqLBFW
         UTey8zcqwA7tpkU6eBlfpKCT96poF+FP6q2qW6d6lifpDAtsFv78WfqgLQE8NN6hX5pp
         6DaH+rJJsGxl4slaOv0ogJyHzmxJdXBg2V6rFqo0KfR1U7YxOy3wvZdriXmXKgZI6z72
         qP3mI1MOj71dEbC1QMzhpHmFh5PZfQLtJX6whF9YfbLiefSzoFPMA6UZ603GKzL7OFmX
         +3ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kZ7CRfTCDKAUDTKyzES9VQDLbhMjlfTZPr986Ha/X2I=;
        b=Tp1AR+OyuTOJ+4sXrsU26BuAJEAVADuCKf+o7i4dnu7n1wmobfm9wJ06HmdRbypugy
         Tkw8SSLEolBcgTLQIqnMcEc7jtDIHn8JckhMXkJtc4qsYIPRGlALh1+HL/XQ0moEEhzk
         YKjgk/Bpo8A1+Rkaew27drhWoBmB7ZM3GKZLboej1EhweUy3pXDCq00iGZIo9JoNIUlf
         NNnVgc+sSDRmZxjwYQZaMnsNVrfjvGU9lEpzLTe5HKMiZ+6ydt5u/bsjkcZhVXmWZPr5
         +nSHfhEIfNRv1HVfDNnOqzKyHzGct3oNOHfDJwpc0otdYO510dTYVuRfhrZzB8KF0aWf
         1f9Q==
X-Gm-Message-State: AOAM533JyQ74IsXz+LnnbbrPi1degpfJQsNLM4m+x4XRI+9Ki+HtpteM
        3bh9MdLajMZOGDk/PjBvBeJNSzVke3cQ29PRtR4=
X-Google-Smtp-Source: ABdhPJy+Zoasu05w+D5LFbyQ0ByfCcuVPzeQDYmp6vgRe6+B7FtMejGsPyU2dqoqTrgd6vhSbQmb+ek6EblQYMw0P6A=
X-Received: by 2002:a4a:49cd:: with SMTP id z196mr54104165ooa.58.1594311101126;
 Thu, 09 Jul 2020 09:11:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200709001234.9719-1-casey@schaufler-ca.com> <20200709001234.9719-6-casey@schaufler-ca.com>
In-Reply-To: <20200709001234.9719-6-casey@schaufler-ca.com>
From:   Stephen Smalley <stephen.smalley.work@gmail.com>
Date:   Thu, 9 Jul 2020 12:11:30 -0400
Message-ID: <CAEjxPJ4EefLKKvMo=8ZWeA4gVioH=WQ=52rnMuW5TnyExmJsRg@mail.gmail.com>
Subject: Re: [PATCH v18 05/23] net: Prepare UDS for security module stacking
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        SElinux list <selinux@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        John Johansen <john.johansen@canonical.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 8, 2020 at 8:23 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
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
>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Cc: netdev@vger.kernel.org
> ---

> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 3385a7a0b231..d246aefcf4da 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -138,17 +138,23 @@ static struct hlist_head *unix_sockets_unbound(void *addr)
>  #ifdef CONFIG_SECURITY_NETWORK
>  static void unix_get_secdata(struct scm_cookie *scm, struct sk_buff *skb)
>  {
> -       UNIXCB(skb).secid = scm->secid;
> +       UNIXCB(skb).lsmdata = kmemdup(&scm->lsmblob, sizeof(scm->lsmblob),
> +                                     GFP_KERNEL);
>  }
>
>  static inline void unix_set_secdata(struct scm_cookie *scm, struct sk_buff *skb)
>  {
> -       scm->secid = UNIXCB(skb).secid;
> +       if (likely(UNIXCB(skb).lsmdata))
> +               scm->lsmblob = *(UNIXCB(skb).lsmdata);
> +       else
> +               lsmblob_init(&scm->lsmblob, 0);
>  }
>
>  static inline bool unix_secdata_eq(struct scm_cookie *scm, struct sk_buff *skb)
>  {
> -       return (scm->secid == UNIXCB(skb).secid);
> +       if (likely(UNIXCB(skb).lsmdata))
> +               return lsmblob_equal(&scm->lsmblob, UNIXCB(skb).lsmdata);
> +       return false;
>  }

I don't think that this provides sensible behavior to userspace.  On a
transient memory allocation failure, instead of returning an error to
the sender and letting them handle it, this will just proceed with
sending the message without its associated security information, and
potentially split messages on arbitrary boundaries because it cannot
tell whether the sender had the same security information.  I think
you instead need to change unix_get_secdata() to return an error on
allocation failure and propagate that up to the sender.  Not a fan of
this change in general both due to extra overhead on this code path
and potential for breakage on allocation failures.  I know it was
motivated by paul's observation that we won't be able to fit many more
secids into the cb but not sure we have to go there prematurely,
especially absent its usage by upstream AA (no unix_stream_connect
hook implementation upstream).  Also not sure how the whole bpf local
storage approach to supporting security modules (or at least bpf lsm)
might reduce need for expanding these structures?
