Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8AF444614
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 17:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbhKCQn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 12:43:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30112 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232883AbhKCQn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 12:43:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635957652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ObJtuoaapJJGEbJZc8cfzuq4RMDCflGvo4MQve1C3eA=;
        b=EUNzfB8BHYbhZihSRTkxX3kItb2C7k9wmmIjFgqaOkF5e+Fq2yyfOAfSAJLO7hLYgDmwTE
        OICmu5LvF03wLXOK3qKjG6oiM5qxonxhcBi6oretwNHkkK8R5ffCZ7Tyt6IdLfojuT8pYm
        c+amrbZYr9xRjYMf4/Hp64/RTjX8m8Y=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-tpWdD6EdPCyAg1rxRUqAQw-1; Wed, 03 Nov 2021 12:40:51 -0400
X-MC-Unique: tpWdD6EdPCyAg1rxRUqAQw-1
Received: by mail-yb1-f197.google.com with SMTP id g190-20020a25dbc7000000b005c21574c704so4655937ybf.13
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 09:40:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ObJtuoaapJJGEbJZc8cfzuq4RMDCflGvo4MQve1C3eA=;
        b=4mtqiOoOHQFcqE7clVV8DF7yJuXh3VqbaPCap6p3vzZLFFU1zwJ/VRnpdV94rqtpI4
         4933eGotAsPr4XT4aYCq8Dtlik+B8BzBfiWmZaxtb1mCBHTcHJH5nEy+GXcsJvZuxhHr
         Sf++/37a6ufZ+phr1j53bmxWj/hZH6cxkOdDGmRqKOXugt48JceuBEubxUPWrrfs11Xo
         3KqYoNoFvNrb7mqmu+zi6d1/kU7T+zjF7Os7QuScp1vl/GQgFtoLw95KK2a/fxGNc5Iz
         D8DKlsRpoHT1MOOFmRHfYUbvLIhHeNoM6hB5IYQyu/TSjdNiktd+wrxIz0CCjMgDfcf7
         4p4A==
X-Gm-Message-State: AOAM530almgX7FgnaBhK2ZOnejC3hT9QtA99EJ8/lbb8yJhbX/AUq987
        ajDIYQz0C1hi8mhSIA+gSABhUoUuAgE2MZ6S05R2uq6dvvBL6Y+x5AgHbVwEj9o13KvtQ+XmAQI
        RVMCBYocWs+jC8M2zKxx1UeUW+XFvSZl0
X-Received: by 2002:a25:6c83:: with SMTP id h125mr51636611ybc.467.1635957650584;
        Wed, 03 Nov 2021 09:40:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxWFhiDuICc6YKn86C716LVFuJk9yQi428rP55b3gzR5tefg9j8tQ0KZLT1Idz9mC3l4Sn/nNKYawYLLNlybU=
X-Received: by 2002:a25:6c83:: with SMTP id h125mr51636562ybc.467.1635957650236;
 Wed, 03 Nov 2021 09:40:50 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1635854268.git.lucien.xin@gmail.com> <cdca8eaca8a0ec5fe4aa58412a6096bb08c3c9bc.1635854268.git.lucien.xin@gmail.com>
In-Reply-To: <cdca8eaca8a0ec5fe4aa58412a6096bb08c3c9bc.1635854268.git.lucien.xin@gmail.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Wed, 3 Nov 2021 17:40:40 +0100
Message-ID: <CAFqZXNtJNnk+iwLnGq6mpdTKuWFmZ4W0PCTj4ira7G2HHPU1tA@mail.gmail.com>
Subject: Re: [PATCHv2 net 4/4] security: implement sctp_assoc_established hook
 in selinux
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        SElinux list <selinux@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        James Morris <jmorris@namei.org>,
        Paul Moore <paul@paul-moore.com>,
        Richard Haines <richard_c_haines@btinternet.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xin,

On Tue, Nov 2, 2021 at 1:03 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> Different from selinux_inet_conn_established(), it also gives the
> secid to asoc->peer_secid in selinux_sctp_assoc_established(),
> as one UDP-type socket may have more than one asocs.
>
> Note that peer_secid in asoc will save the peer secid for this
> asoc connection, and peer_sid in sksec will just keep the peer
> secid for the latest connection. So the right use should be do
> peeloff for UDP-type socket if there will be multiple asocs in
> one socket, so that the peeloff socket has the right label for
> its asoc.
>
> v1->v2:
>   - call selinux_inet_conn_established() to reduce some code
>     duplication in selinux_sctp_assoc_established(), as Ondrej
>     suggested.
>   - when doing peeloff, it calls sock_create() where it actually
>     gets secid for socket from socket_sockcreate_sid(). So reuse
>     SECSID_WILD to ensure the peeloff socket keeps using that
>     secid after calling selinux_sctp_sk_clone() for client side.

Interesting... I find strange that SCTP creates the peeloff socket
using sock_create() rather than allocating it directly via
sock_alloc() like the other callers of sctp_copy_sock() (which calls
security_sctp_sk_clone()) do. Wouldn't it make more sense to avoid the
sock_create() call and just rely on the security_sctp_sk_clone()
semantic to set up the labels? Would anything break if
sctp_do_peeloff() switched to plain sock_alloc()?

I'd rather we avoid this SECSID_WILD hack to support the weird
created-but-also-cloned socket hybrid and just make the peeloff socket
behave the same as an accept()-ed socket (i.e. no
security_socket_[post_]create() hook calls, just
security_sctp_sk_clone()).

>
> Fixes: 72e89f50084c ("security: Add support for SCTP security hooks")
> Reported-by: Prashanth Prahlad <pprahlad@redhat.com>
> Reviewed-by: Richard Haines <richard_c_haines@btinternet.com>
> Tested-by: Richard Haines <richard_c_haines@btinternet.com>

You made non-trivial changes since the last revision in this patch, so
you should have also dropped the Reviewed-by and Tested-by here. Now
David has merged the patches probably under the impression that they
have been reviewed/approved from the SELinux side, which isn't
completely true.

> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  security/selinux/hooks.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index a9977a2ae8ac..341cd5dccbf5 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -5519,7 +5519,8 @@ static void selinux_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk
>         if (!selinux_policycap_extsockclass())
>                 return selinux_sk_clone_security(sk, newsk);
>
> -       newsksec->sid = asoc->secid;
> +       if (asoc->secid != SECSID_WILD)
> +               newsksec->sid = asoc->secid;
>         newsksec->peer_sid = asoc->peer_secid;
>         newsksec->sclass = sksec->sclass;
>         selinux_netlbl_sctp_sk_clone(sk, newsk);
> @@ -5575,6 +5576,16 @@ static void selinux_inet_conn_established(struct sock *sk, struct sk_buff *skb)
>         selinux_skb_peerlbl_sid(skb, family, &sksec->peer_sid);
>  }
>
> +static void selinux_sctp_assoc_established(struct sctp_association *asoc,
> +                                          struct sk_buff *skb)
> +{
> +       struct sk_security_struct *sksec = asoc->base.sk->sk_security;
> +
> +       selinux_inet_conn_established(asoc->base.sk, skb);
> +       asoc->peer_secid = sksec->peer_sid;
> +       asoc->secid = SECSID_WILD;
> +}
> +
>  static int selinux_secmark_relabel_packet(u32 sid)
>  {
>         const struct task_security_struct *__tsec;
> @@ -7290,6 +7301,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
>         LSM_HOOK_INIT(sctp_assoc_request, selinux_sctp_assoc_request),
>         LSM_HOOK_INIT(sctp_sk_clone, selinux_sctp_sk_clone),
>         LSM_HOOK_INIT(sctp_bind_connect, selinux_sctp_bind_connect),
> +       LSM_HOOK_INIT(sctp_assoc_established, selinux_sctp_assoc_established),
>         LSM_HOOK_INIT(inet_conn_request, selinux_inet_conn_request),
>         LSM_HOOK_INIT(inet_csk_clone, selinux_inet_csk_clone),
>         LSM_HOOK_INIT(inet_conn_established, selinux_inet_conn_established),
> --
> 2.27.0
>

--
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

