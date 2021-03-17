Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6C633F9DA
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 21:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbhCQURK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 16:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbhCQUQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 16:16:40 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C46AC061762
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 13:16:39 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id t18so357386ejc.13
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 13:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QEOloMvNgoHGwfPYaOtLBZt1tGk9z+wArHjNJYI6x+w=;
        b=UlaIdchIMdvi/d1HMbomidYmolKkRGGG72Ut18zENfsjoTbv1aDeRsouser7JUEzqI
         9lCfZ7qjup3e1vRK9Xu4o1tkavKruWXdMzBIVvgZal+Sm/7RZ+YYYUzbnmauXGdHEywk
         I19g8U3fx1gLO92it6EU+oyJESyO6EXh+KbyjkioJePZ9Kqq/wWEi8iEyX6Igae83hqB
         HZtVJ4mDbZNtS8YUXFkoIdVC8+WhOuUJ6SBduQUGWkIOoA49zXdj4peBD3woqzUj/UbP
         Mspw7LEf+mD+R+O1Nox5CYoU5VBRR5beWYwRY4Mbzdpf8B7qKfNpkuVfYZlEL43hYOrp
         u6gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QEOloMvNgoHGwfPYaOtLBZt1tGk9z+wArHjNJYI6x+w=;
        b=HgQUfG2kyOdq0662PQkdHbNcc1MCGIF5DEUUdewhpo3PwYs4e8aMN9U6GL/4RXLJuJ
         PFbviwfP9Rbl133UTXsGJW003fOWgTT3RrpnvukHHPVblAq8g1j4EeEfTXuxWTj3eWTS
         fGpsqDgotL3nurDmBZNddr7Zxo1SfeTnRfVkfgJnftixJhLb1IuPoUQoeUyxTkOqa9FN
         X0AyQys03aZXOwMJDzNX1jSX5/VaqFK7Tc0tAGVLatFFsdd7uccTgyzrGYTqHIhUm6io
         +aZS6tmcyvh4w6UsV+bSH03vtEkrux/h5WDx6+wQkJcMWyGXmLmLuq+TADq3p8oXOg/A
         j4QA==
X-Gm-Message-State: AOAM531uP3CkmiVpUkM8D4k7PHwY0fjIb3CizvIZLfL0aFjYgfpz3bxS
        xMm/CbDgbW8zRv2D02DmAwdMYh6LocSeQbIo2lu+
X-Google-Smtp-Source: ABdhPJwZ5eSoUqpbSZ2mwR7prPozBZU8LbvUD8YDCFfZ7b2tNkNEe3pbPcW7reGnL8Oxx4SZD9jMOJn1Hk6ZwhQ9R2s=
X-Received: by 2002:a17:906:3ac3:: with SMTP id z3mr37990797ejd.106.1616012197980;
 Wed, 17 Mar 2021 13:16:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210317154448.1034471-1-dbrazdil@google.com>
In-Reply-To: <20210317154448.1034471-1-dbrazdil@google.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 17 Mar 2021 16:16:27 -0400
Message-ID: <CAHC9VhT_+i9V9N7NAdCCUgO5xBZpffvVPeh=jK8weZr3WzZ4Bw@mail.gmail.com>
Subject: Re: [PATCH] selinux: vsock: Set SID for socket returned by accept()
To:     David Brazdil <dbrazdil@google.com>
Cc:     selinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>,
        Kees Cook <keescook@chromium.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Alistair Delva <adelva@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 11:44 AM David Brazdil <dbrazdil@google.com> wrote:
>
> For AF_VSOCK, accept() currently returns sockets that are unlabelled.
> Other socket families derive the child's SID from the SID of the parent
> and the SID of the incoming packet. This is typically done as the
> connected socket is placed in the queue that accept() removes from.
>
> Implement an LSM hook 'vsock_sk_clone' that takes the parent (server)
> and child (connection) struct socks, and assigns the parent SID to the
> child. There is no packet SID in this case.
>
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
> This is my first patch in this part of the kernel so please comment if I
> missed anything, specifically whether there is a packet SID that should
> be mixed into the child SID.
>
> Tested on Android.
>
>  include/linux/lsm_hook_defs.h |  1 +
>  include/linux/lsm_hooks.h     |  7 +++++++
>  include/linux/security.h      |  5 +++++
>  net/vmw_vsock/af_vsock.c      |  1 +
>  security/security.c           |  5 +++++
>  security/selinux/hooks.c      | 10 ++++++++++
>  6 files changed, 29 insertions(+)

Additional comments below, but I think it would be a good idea for you
to test your patches on a more traditional Linux distribution as well
as Android.

> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index 5546710d8ac1..a9bf3b90cb2f 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -755,6 +755,7 @@ static struct sock *__vsock_create(struct net *net,
>                 vsk->buffer_size = psk->buffer_size;
>                 vsk->buffer_min_size = psk->buffer_min_size;
>                 vsk->buffer_max_size = psk->buffer_max_size;
> +               security_vsock_sk_clone(parent, sk);

Did you try calling the existing security_sk_clone() hook here?  I
would be curious to hear why it doesn't work in this case.

Feel free to educate me on AF_VSOCK, it's entirely possible I'm
misunderstanding something here :)

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index ddd097790d47..7b92d6f2e0fd 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -5616,6 +5616,15 @@ static int selinux_tun_dev_open(void *security)
>         return 0;
>  }
>
> +static void selinux_socket_vsock_sk_clone(struct sock *sock, struct sock *newsk)
> +{
> +       struct sk_security_struct *sksec_sock = sock->sk_security;
> +       struct sk_security_struct *sksec_new = newsk->sk_security;
> +
> +       /* Always returns 0 when packet SID is SECSID_NULL. */
> +       WARN_ON_ONCE(selinux_conn_sid(sksec_sock->sid, SECSID_NULL, &sksec_new->sid));
> +}

If you are using selinux_conn_sid() with the second argument always
SECSID_NULL it probably isn't the best choice; it ends up doing a
simple "sksec_new->sid = sksec_sock->sid" ... which gets us back to
this function looking like a reimplementation of
selinux_sk_clone_security(), minus the peer_sid and sclass
initializations (which should be important things to have).

I strongly suggest you try making use of the existing
security_sk_clone() hook in the vsock code, it seems like a better way
to solve this problem.

-- 
paul moore
www.paul-moore.com
