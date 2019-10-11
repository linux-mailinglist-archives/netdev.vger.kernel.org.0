Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE9E7D3651
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbfJKAkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:40:05 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34451 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727637AbfJKAkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 20:40:04 -0400
Received: by mail-lf1-f68.google.com with SMTP id r22so5746273lfm.1
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 17:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QkzZR9OEPJLaUXXIdfh6gF0s61TBZnR/lxZWV3PihuE=;
        b=UTddWIBiR1GAGxR+mVYGM2xyl/RvsIwM/NAHHgw54XYygmhj3i5UVV2I4PEAPeMN6C
         gUnZcpxsnn/VIoSqeuT29NvcCnTBtQZZYIzezV5nhl7h4g7PLvfzBM9JLlGRzxCT3t2Z
         V27bVV3SutbKjSG6fE1eHwplxGQDRN6z39JCyjIWMYGA/+VseS+1Fy34mOJ9AHdVA5AH
         3C1Tm5Nh052pq5kI5hNpRdfIZf13CWV/RwRTcOz8sqXffvjbRwBESlTXGOtLlGBMADel
         MFiIkKsyURq0OHNdEEPAgujRar/g74XGku51ImEHY3XnH6J7Re0MG9K7AQuvm1WQxIJG
         lrQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QkzZR9OEPJLaUXXIdfh6gF0s61TBZnR/lxZWV3PihuE=;
        b=s2JcGOzg2hjrDsupAYlTE62if/KeAjPBC+CF4uoiV4o5bfg1r3v4PQeXeiA3Ekz9/D
         4oUZCFScbO6l8yr7C9yKvlsMFpJfnseVTK5DIs1yx4nP8dVI8bzwY25oQpjFb03xZ8k8
         j2uZHhYTxEEFD0hWnL6uwFE5/KL7X7Jy7VKIxeA4dF4JXwIwuGKXhejiVDeHpiynUjUb
         EjtxpbbZFPjINQqXkz0LrDLGJjpymCaKXEFy6F4458C3trbbdXHGVcvcY5arIJik6XSG
         hb+vWpKQ9TnS1e8teQUmNHBGgtgSxqbWQ86i3aomFbU5NArplna116bT9kZA2wzaz3Ue
         GIYg==
X-Gm-Message-State: APjAAAUZE2WzkoeStURoTY8UE8J+jXdAzUDjLuwdeYEpIIKSJT+Z9TnI
        4aKfyU2/WZwF1P4XmWqAFhGyP9FRNJJRIefutGgZ
X-Google-Smtp-Source: APXvYqy/DOSZitDBR7TqyrESxgPgD+yFqEzNoecNTAToFNbWp+w16SQ8prdItu7++b4q9m+f88vJY4RLR7eP7fAj9Y0=
X-Received: by 2002:a19:c7cf:: with SMTP id x198mr7323383lff.158.1570754401856;
 Thu, 10 Oct 2019 17:40:01 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1568834524.git.rgb@redhat.com> <18f14bfbffc30c53c2b1dd06694b69ef286f3b72.1568834524.git.rgb@redhat.com>
In-Reply-To: <18f14bfbffc30c53c2b1dd06694b69ef286f3b72.1568834524.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 10 Oct 2019 20:39:50 -0400
Message-ID: <CAHC9VhQNWP-UhnXRoDWQDcWAOB6KkW3S0uhbJ_Z+9zGNteVwRw@mail.gmail.com>
Subject: Re: [PATCH ghak90 V7 13/21] audit: NETFILTER_PKT: record each
 container ID associated with a netNS
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 9:26 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Add audit container identifier auxiliary record(s) to NETFILTER_PKT
> event standalone records.  Iterate through all potential audit container
> identifiers associated with a network namespace.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
>  include/linux/audit.h    |  5 +++++
>  kernel/audit.c           | 39 +++++++++++++++++++++++++++++++++++++++
>  net/netfilter/nft_log.c  | 11 +++++++++--
>  net/netfilter/xt_AUDIT.c | 11 +++++++++--
>  4 files changed, 62 insertions(+), 4 deletions(-)

This should be squashed together with patch 12/21; neither patch makes
sense by themselves.

> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 73e3ab38e3e0..dcd92f964120 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -241,6 +241,8 @@ static inline u64 audit_get_contid(struct task_struct *tsk)
>  extern void audit_netns_contid_del(struct net *net, u64 contid);
>  extern void audit_switch_task_namespaces(struct nsproxy *ns,
>                                          struct task_struct *p);
> +extern void audit_log_netns_contid_list(struct net *net,
> +                                       struct audit_context *context);
>
>  extern u32 audit_enabled;
>
> @@ -328,6 +330,9 @@ static inline void audit_netns_contid_del(struct net *net, u64 contid)
>  static inline void audit_switch_task_namespaces(struct nsproxy *ns,
>                                                 struct task_struct *p)
>  { }
> +static inline void audit_log_netns_contid_list(struct net *net,
> +                                              struct audit_context *context)
> +{ }
>
>  #define audit_enabled AUDIT_OFF
>
> diff --git a/kernel/audit.c b/kernel/audit.c
> index e0c27bc39925..9ce7a1ec7a92 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -450,6 +450,45 @@ void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
>                 audit_netns_contid_add(new->net_ns, contid);
>  }
>
> +/**
> + * audit_log_netns_contid_list - List contids for the given network namespace
> + * @net: the network namespace of interest
> + * @context: the audit context to use
> + *
> + * Description:
> + * Issues a CONTAINER_ID record with a CSV list of contids associated
> + * with a network namespace to accompany a NETFILTER_PKT record.
> + */
> +void audit_log_netns_contid_list(struct net *net, struct audit_context *context)
> +{
> +       struct audit_buffer *ab = NULL;
> +       struct audit_contid *cont;
> +       struct audit_net *aunet;
> +
> +       /* Generate AUDIT_CONTAINER_ID record with container ID CSV list */
> +       rcu_read_lock();
> +       aunet = net_generic(net, audit_net_id);
> +       if (!aunet)
> +               goto out;
> +       list_for_each_entry_rcu(cont, &aunet->contid_list, list) {
> +               if (!ab) {
> +                       ab = audit_log_start(context, GFP_ATOMIC,
> +                                            AUDIT_CONTAINER_ID);
> +                       if (!ab) {
> +                               audit_log_lost("out of memory in audit_log_netns_contid_list");
> +                               goto out;
> +                       }
> +                       audit_log_format(ab, "contid=");
> +               } else
> +                       audit_log_format(ab, ",");
> +               audit_log_format(ab, "%llu", cont->id);
> +       }
> +       audit_log_end(ab);
> +out:
> +       rcu_read_unlock();
> +}
> +EXPORT_SYMBOL(audit_log_netns_contid_list);
> +
>  void audit_panic(const char *message)
>  {
>         switch (audit_failure) {
> diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
> index fe4831f2258f..98d1e7e1a83c 100644
> --- a/net/netfilter/nft_log.c
> +++ b/net/netfilter/nft_log.c
> @@ -66,13 +66,16 @@ static void nft_log_eval_audit(const struct nft_pktinfo *pkt)
>         struct sk_buff *skb = pkt->skb;
>         struct audit_buffer *ab;
>         int fam = -1;
> +       struct audit_context *context;
> +       struct net *net;
>
>         if (!audit_enabled)
>                 return;
>
> -       ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
> +       context = audit_alloc_local(GFP_ATOMIC);
> +       ab = audit_log_start(context, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
>         if (!ab)
> -               return;
> +               goto errout;
>
>         audit_log_format(ab, "mark=%#x", skb->mark);
>
> @@ -99,6 +102,10 @@ static void nft_log_eval_audit(const struct nft_pktinfo *pkt)
>                 audit_log_format(ab, " saddr=? daddr=? proto=-1");
>
>         audit_log_end(ab);
> +       net = xt_net(&pkt->xt);
> +       audit_log_netns_contid_list(net, context);
> +errout:
> +       audit_free_context(context);
>  }
>
>  static void nft_log_eval(const struct nft_expr *expr,
> diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
> index 9cdc16b0d0d8..ecf868a1abde 100644
> --- a/net/netfilter/xt_AUDIT.c
> +++ b/net/netfilter/xt_AUDIT.c
> @@ -68,10 +68,13 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
>  {
>         struct audit_buffer *ab;
>         int fam = -1;
> +       struct audit_context *context;
> +       struct net *net;
>
>         if (audit_enabled == AUDIT_OFF)
> -               goto errout;
> -       ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
> +               goto out;
> +       context = audit_alloc_local(GFP_ATOMIC);
> +       ab = audit_log_start(context, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
>         if (ab == NULL)
>                 goto errout;
>
> @@ -101,7 +104,11 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
>
>         audit_log_end(ab);
>
> +       net = xt_net(par);
> +       audit_log_netns_contid_list(net, context);
>  errout:
> +       audit_free_context(context);
> +out:
>         return XT_CONTINUE;
>  }
>

--
paul moore
www.paul-moore.com
