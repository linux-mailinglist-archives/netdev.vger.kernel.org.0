Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835B44390C5
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 10:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhJYIEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 04:04:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52106 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229534AbhJYIEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 04:04:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635148912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3/55QYc9SmLAH1YqdAjq//4PlmEqSr7pH2lLIRYOw0U=;
        b=Xpr47Bo3cU9YgGoSaaTfPYv0r4I0mjffch1Gff91xuVAtUFu38Chb/BHuPJwGCd5ETG3yv
        TkORHzjz11Tn6mj4V/Qbvbx4TF/8EULbiTVYpb69gw4AHO8FvMAVUt5udnNcjnnN+FXWYg
        N7vimuMavCz3zTOC8YvQSvtfCprjNEM=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-WfSaFXmOPpa_rDfri_RuVA-1; Mon, 25 Oct 2021 04:01:51 -0400
X-MC-Unique: WfSaFXmOPpa_rDfri_RuVA-1
Received: by mail-yb1-f198.google.com with SMTP id r67-20020a252b46000000b005bea12c4befso16041828ybr.19
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 01:01:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3/55QYc9SmLAH1YqdAjq//4PlmEqSr7pH2lLIRYOw0U=;
        b=DCUXjmUieb61X++G+fK/6YJcAIDDeyFm1Y8ZRlkdE5tYfrNB4KuwH5/VMjAKVW2cI+
         1s/91AoKayS3SP8KljDMtKMx9KDAhYTYFvDCRuTZsl/H/0bnKp1PRJybMOih9g2jKVxw
         9masQ+9k2PIF/Re2kxEtMooPJ/z6t6qknxUyozUE/4sEDo0Uhtbw2dinqGWrMqvOiDuB
         RRz8914CfS7C50Xy+fTZh+Hnv5g5vytv3Zr2AAwUxJhQgzejcnhm4K9vx9ImTws7HYtA
         5xSjjgSleLh1l+iAkiA6ILoTNhdZtd12Jh9h0IETJVabgqicJBEOrOl8rGOKPIkajHS6
         TD0A==
X-Gm-Message-State: AOAM532ndyxH34N9q4OKYx/dDSJdW/PSkU+auvle7DOLgHSBAlrQ+Inx
        bxv3Su2ROeJnS0E06TmPLXQGYhITT8bHZ/m+/G7rCFAkDBacQ3m/XLS0sNhSja5tngFIoyzSBVu
        IdBO7Snzc/UiWS/eNa5UU5QxHIg7JDBym
X-Received: by 2002:a25:7310:: with SMTP id o16mr9223862ybc.513.1635148910299;
        Mon, 25 Oct 2021 01:01:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpnriUf5NaXg+lWb6WoAbqacH/1ek8P0At+48BPb04YWL4EBno1p6M6bdb1k7pIqCQeFnJMfBV9vt7+VYoPmk=
X-Received: by 2002:a25:7310:: with SMTP id o16mr9223852ybc.513.1635148910138;
 Mon, 25 Oct 2021 01:01:50 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1634884487.git.lucien.xin@gmail.com> <71602ec3cff6bf67d47fef520f64cb6bccba928c.1634884487.git.lucien.xin@gmail.com>
In-Reply-To: <71602ec3cff6bf67d47fef520f64cb6bccba928c.1634884487.git.lucien.xin@gmail.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Mon, 25 Oct 2021 10:01:39 +0200
Message-ID: <CAFqZXNvsXW7-4iD+ErKWX9c9YJ42WJHwcjQJMupVO+tbyeod1g@mail.gmail.com>
Subject: Re: [PATCH net 3/4] security: add sctp_assoc_established hook
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
>
> security_sctp_assoc_established() is added to replace
> security_inet_conn_established() called in
> sctp_sf_do_5_1E_ca(), so that asoc can be accessed in security
> subsystem and save the peer secid to asoc->peer_secid.
>
> Fixes: 72e89f50084c ("security: Add support for SCTP security hooks")
> Reported-by: Prashanth Prahlad <pprahlad@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  Documentation/security/SCTP.rst | 22 ++++++++++------------
>  include/linux/lsm_hook_defs.h   |  2 ++
>  include/linux/lsm_hooks.h       |  5 +++++
>  include/linux/security.h        |  8 ++++++++
>  net/sctp/sm_statefuns.c         |  2 +-
>  security/security.c             |  7 +++++++
>  6 files changed, 33 insertions(+), 13 deletions(-)
[...]
> diff --git a/include/linux/security.h b/include/linux/security.h
> index a16407444871..11cdddf9685c 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1423,6 +1423,8 @@ int security_sctp_bind_connect(struct sock *sk, int optname,
>                                struct sockaddr *address, int addrlen);
>  void security_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk,
>                             struct sock *newsk);
> +void security_sctp_assoc_established(struct sctp_association *asoc,
> +                                    struct sk_buff *skb);
>
>  #else  /* CONFIG_SECURITY_NETWORK */
>  static inline int security_unix_stream_connect(struct sock *sock,
> @@ -1642,6 +1644,12 @@ static inline void security_sctp_sk_clone(struct sctp_association *asoc,
>                                           struct sock *newsk)
>  {
>  }
> +
> +static inline void security_sctp_assoc_established(struct sctp_association *asoc,
> +                                                  struct sk_buff *skb)
> +{
> +       return 0;

It has now been pointed out by the kernel robot as well, but you are
returning a value from a function with return type void here.

> +}
>  #endif /* CONFIG_SECURITY_NETWORK */
>
>  #ifdef CONFIG_SECURITY_INFINIBAND
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index b818532c3fc2..5fabaa54b77d 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -946,7 +946,7 @@ enum sctp_disposition sctp_sf_do_5_1E_ca(struct net *net,
>         sctp_add_cmd_sf(commands, SCTP_CMD_INIT_COUNTER_RESET, SCTP_NULL());
>
>         /* Set peer label for connection. */
> -       security_inet_conn_established(ep->base.sk, chunk->skb);
> +       security_sctp_assoc_established((struct sctp_association *)asoc, chunk->skb);
>
>         /* RFC 2960 5.1 Normal Establishment of an Association
>          *
> diff --git a/security/security.c b/security/security.c
> index b0f1c007aa3b..4b2b4b5beb27 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -2387,6 +2387,13 @@ void security_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk,
>  }
>  EXPORT_SYMBOL(security_sctp_sk_clone);
>
> +void security_sctp_assoc_established(struct sctp_association *asoc,
> +                                    struct sk_buff *skb)
> +{
> +       call_void_hook(sctp_assoc_established, asoc, skb);
> +}
> +EXPORT_SYMBOL(security_sctp_assoc_established);
> +
>  #endif /* CONFIG_SECURITY_NETWORK */
>
>  #ifdef CONFIG_SECURITY_INFINIBAND
> --
> 2.27.0
>

--
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

