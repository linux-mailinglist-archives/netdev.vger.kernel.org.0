Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F786439100
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 10:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbhJYITm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 04:19:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49033 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231721AbhJYITl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 04:19:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635149839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0PbCh/f6v5Mr3XWPFNcAw3uOEmvsmdFvbrT4W31P5CY=;
        b=YyJRevs85dRsfq3SnT2LkHG1BjXjTe4G8YhLqX8Uokqbs4TZ8aB3OPghIFGuLbSveq+N7E
        aI8YLDO2VR6rbkUEjBxlG1MbYpOZnNwUBVyrVU+Ug1QEkJWR82SfIKGrDO4MsdrT/rH954
        b89QMqU5D6PPt2GQxQJsxOfxfiq1jVs=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562--r3kPZ0JMl2TwbbVc8L4Cw-1; Mon, 25 Oct 2021 04:17:18 -0400
X-MC-Unique: -r3kPZ0JMl2TwbbVc8L4Cw-1
Received: by mail-yb1-f200.google.com with SMTP id t92-20020a25aae5000000b005c1494b029aso10976772ybi.6
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 01:17:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0PbCh/f6v5Mr3XWPFNcAw3uOEmvsmdFvbrT4W31P5CY=;
        b=hEPec6fNZXdNWZP511fvAqZCX537xEIULyUplJ+yMGxVCB7w/G7i3GAXWHAXuDk9R4
         bdNgirdSpTfBdDoFLfxq1TCI8Mqxxi+lEBjUDFj0k477aE3IGQu9bbotwnXCnKqjWsw9
         0mGyJ/fwYcDDg1adQF+NQPsWpAfa+jfsnISMdXa/93rt9jKz2IjH5vdTEo+dF8ajrO7B
         KpTeCCS7Z+zvICRP68LEm23uSTlKJ2n7b/7UFl7P/2basEooT5vw9ymUeYXrhX6NKcRI
         VxlxtpwP7hbcKiV7OpnJVbTrM7Ma4huAc38M6ARGODNdWJ8719nA58KMeTnfYxVgpANB
         6JTg==
X-Gm-Message-State: AOAM5308xaOhsyoVFXLZAcMlKmzAlE8LrQndl7jDN5hZGsP4HvtEAp34
        0v5h+jwB2CxjnWw1t/ruyKiohnMqwwQ4XSWzGvBFebsqZNePs5g7d29/j9rbC3rXwRR0AMYnWhJ
        yx4hKpbUipeUS5lclWfH5RjpLE/gf/JLn
X-Received: by 2002:a25:3308:: with SMTP id z8mr15949243ybz.384.1635149837723;
        Mon, 25 Oct 2021 01:17:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyV6iwnX5my7u3trMgr4p8Ip5qSrgjNdNPT0BaDlNaTLHrvB6lD00jifJC29Lyq4YyGXdT52OSopw/4yM3UVSk=
X-Received: by 2002:a25:3308:: with SMTP id z8mr15949223ybz.384.1635149837497;
 Mon, 25 Oct 2021 01:17:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1634884487.git.lucien.xin@gmail.com> <53026dedd66beeaf18a4570437c4e6c9e760bb90.1634884487.git.lucien.xin@gmail.com>
In-Reply-To: <53026dedd66beeaf18a4570437c4e6c9e760bb90.1634884487.git.lucien.xin@gmail.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Mon, 25 Oct 2021 10:17:06 +0200
Message-ID: <CAFqZXNs89yGcoXumNwavLRQpYutfnLY-SM2qrHbvpjJxVtiniw@mail.gmail.com>
Subject: Re: [PATCH net 4/4] security: implement sctp_assoc_established hook
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

On Fri, Oct 22, 2021 at 8:36 AM Xin Long <lucien.xin@gmail.com> wrote:
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

Hm... this sounds like something we should also try to fix (if
possible). In access control we can't trust userspace to do the right
thing - receiving from multiple peers on one SOCK_SEQPACKET socket
shouldn't cause checking against the wrong peer_sid. But that can be
addressed separately. (And maybe it's even already accounted for
somehow - I didn't yet look at the code closely.)

>
> Fixes: 72e89f50084c ("security: Add support for SCTP security hooks")
> Reported-by: Prashanth Prahlad <pprahlad@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  security/selinux/hooks.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index f025fc00421b..793fdcbc68bd 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -5525,6 +5525,21 @@ static void selinux_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk
>         selinux_netlbl_sctp_sk_clone(sk, newsk);
>  }
>
> +static void selinux_sctp_assoc_established(struct sctp_association *asoc,
> +                                          struct sk_buff *skb)
> +{
> +       struct sk_security_struct *sksec = asoc->base.sk->sk_security;
> +       u16 family = asoc->base.sk->sk_family;
> +
> +       /* handle mapped IPv4 packets arriving via IPv6 sockets */
> +       if (family == PF_INET6 && skb->protocol == htons(ETH_P_IP))
> +               family = PF_INET;
> +
> +       selinux_skb_peerlbl_sid(skb, family, &sksec->peer_sid);

You could replace the above with
`selinux_inet_conn_established(asoc->base.sk, skb);` to reduce code
duplication.

> +       asoc->secid = sksec->sid;
> +       asoc->peer_secid = sksec->peer_sid;
> +}
> +
>  static int selinux_inet_conn_request(const struct sock *sk, struct sk_buff *skb,
>                                      struct request_sock *req)
>  {
> @@ -7290,6 +7305,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
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

