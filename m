Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB83214D7D
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 17:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgGEPLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 11:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbgGEPLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 11:11:37 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7345AC08C5E0
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 08:11:37 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id f12so13549873eja.9
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 08:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vZkOfNBWPs7bSewT5QvZ/73eArXitjKQiDUtUx4ui7w=;
        b=L8DyrA0FLE21V4MOXZEjSGpZnIuqb4iC2aC2i3zp2BV3QD6oiLwzWVfGLwJsWs/SOD
         Sf5rpTmNcJgS8YldfcsmIP8HfyjH4BsY6Jn5ZDLuok718ODpoFT8bmPKULLcUmmSEbzx
         J9HWauCfjA3JCH/kkVA4ZT+4ryqnt2NPcNUg6rNJx34Ady51AFAkeTDiZxpt6meH3EC6
         BsLAJTMRKf/FsA2GvzxJsZtuhBpn2i7W3f/K/hQ5AJ9Ts4Yz0N0I7mmo1jeeChNNpGRC
         z8C/cArs+coRfiecZM6QzF+BpNouh/evZZmWofGu7IGfI/63enV9ePGzW1++1v3xZ9Ub
         zGrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vZkOfNBWPs7bSewT5QvZ/73eArXitjKQiDUtUx4ui7w=;
        b=RrvRw8pICF70uYnn4iwn7Z9BY+DCX6+khNwS8rmPMExtv/NWtDQsPyJ3wVqOfo2Dac
         JvrHh7EH7JNMPLjevYlnpida3olJ9rh3NZoKRzwPy3MhjykWeWaRv7iMrXyCVMfhcAB0
         dXq/lxYqclowHZhh1T3zwmqAupS5+vT+OhLrRrGWHsLuSqhnbE5efH22kPsbii/0sMhT
         xeJRRS0yIJjGgmO4/pZm7RfdIGUVmYvNgQOdjMVnZrx4eZ3M2nY5242cIHpjl0r2WgWC
         xTcmQmr/eXlw1gOTnZ6nrY9bBEWlmlLS6/pLNjNRWnYkvUxmFNl85QCb7oheGkh5IVtd
         oMAA==
X-Gm-Message-State: AOAM530vTGOVcTswXb80SZcG9aGKzTqtNz4ojmbuP1nE0ZxgxEsqV3rj
        DbQkMzAOAsoCW7GtHT6D6rfcbBTgjgg4zn2qoBEC
X-Google-Smtp-Source: ABdhPJwpCSiC6DSoxZdi2hDJdv8okJ+1ja6aScs+thXxUI3Z3zq+l9Mz0Zb046AzwGN/qGJDIKP+LuHU9EesRKGoRdQ=
X-Received: by 2002:a17:906:456:: with SMTP id e22mr34336791eja.178.1593961896028;
 Sun, 05 Jul 2020 08:11:36 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593198710.git.rgb@redhat.com> <e9c1216a361c38ebc9cb4089922c259e2cfd5013.1593198710.git.rgb@redhat.com>
In-Reply-To: <e9c1216a361c38ebc9cb4089922c259e2cfd5013.1593198710.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sun, 5 Jul 2020 11:11:24 -0400
Message-ID: <CAHC9VhSRRN+Qq5dNx6Q5cG_TrXgbBMR0PNUYvf+Haf2na5wCfg@mail.gmail.com>
Subject: Re: [PATCH ghak90 V9 10/13] audit: add support for containerid to
 network namespaces
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, Ondrej Mosnacek <omosnace@redhat.com>,
        dhowells@redhat.com, simo@redhat.com,
        Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 27, 2020 at 9:23 AM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> This also adds support to qualify NETFILTER_PKT records.
>
> Audit events could happen in a network namespace outside of a task
> context due to packets received from the net that trigger an auditing
> rule prior to being associated with a running task.  The network
> namespace could be in use by multiple containers by association to the
> tasks in that network namespace.  We still want a way to attribute
> these events to any potential containers.  Keep a list per network
> namespace to track these audit container identifiiers.
>
> Add/increment the audit container identifier on:
> - initial setting of the audit container identifier via /proc
> - clone/fork call that inherits an audit container identifier
> - unshare call that inherits an audit container identifier
> - setns call that inherits an audit container identifier
> Delete/decrement the audit container identifier on:
> - an inherited audit container identifier dropped when child set
> - process exit
> - unshare call that drops a net namespace
> - setns call that drops a net namespace
>
> Add audit container identifier auxiliary record(s) to NETFILTER_PKT
> event standalone records.  Iterate through all potential audit container
> identifiers associated with a network namespace.
>
> Please see the github audit kernel issue for contid net support:
>   https://github.com/linux-audit/audit-kernel/issues/92
> Please see the github audit testsuiite issue for the test case:
>   https://github.com/linux-audit/audit-testsuite/issues/64
> Please see the github audit wiki for the feature overview:
>   https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
>  include/linux/audit.h    |  20 ++++++
>  kernel/audit.c           | 156 ++++++++++++++++++++++++++++++++++++++++++++++-
>  kernel/nsproxy.c         |   4 ++
>  net/netfilter/nft_log.c  |  11 +++-
>  net/netfilter/xt_AUDIT.c |  11 +++-
>  5 files changed, 195 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index c4a755ae0d61..304fbb7c3c5b 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -128,6 +128,13 @@ struct audit_task_info {
>
>  extern struct audit_task_info init_struct_audit;
>
> +struct audit_contobj_netns {
> +       struct list_head        list;
> +       struct audit_contobj    *obj;
> +       int                     count;

This seems like it might be a good candidate for refcount_t, yes?

> +       struct rcu_head         rcu;
> +};

...

> diff --git a/kernel/audit.c b/kernel/audit.c
> index 997c34178ee8..a862721dfd9b 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -437,6 +452,136 @@ static struct sock *audit_get_sk(const struct net *net)
>         return aunet->sk;
>  }
>
> +void audit_netns_contid_add(struct net *net, struct audit_contobj *cont)
> +{
> +       struct audit_net *aunet;
> +       struct list_head *contobj_list;
> +       struct audit_contobj_netns *contns;
> +
> +       if (!net)
> +               return;
> +       if (!cont)
> +               return;
> +       aunet = net_generic(net, audit_net_id);
> +       if (!aunet)
> +               return;
> +       contobj_list = &aunet->contobj_list;
> +       rcu_read_lock();
> +       spin_lock(&aunet->contobj_list_lock);
> +       list_for_each_entry_rcu(contns, contobj_list, list)
> +               if (contns->obj == cont) {
> +                       contns->count++;
> +                       goto out;
> +               }
> +       contns = kmalloc(sizeof(*contns), GFP_ATOMIC);
> +       if (contns) {
> +               INIT_LIST_HEAD(&contns->list);
> +               contns->obj = cont;
> +               contns->count = 1;
> +               list_add_rcu(&contns->list, contobj_list);
> +       }
> +out:
> +       spin_unlock(&aunet->contobj_list_lock);
> +       rcu_read_unlock();
> +}
> +
> +void audit_netns_contid_del(struct net *net, struct audit_contobj *cont)
> +{
> +       struct audit_net *aunet;
> +       struct list_head *contobj_list;
> +       struct audit_contobj_netns *contns = NULL;
> +
> +       if (!net)
> +               return;
> +       if (!cont)
> +               return;
> +       aunet = net_generic(net, audit_net_id);
> +       if (!aunet)
> +               return;
> +       contobj_list = &aunet->contobj_list;
> +       rcu_read_lock();
> +       spin_lock(&aunet->contobj_list_lock);
> +       list_for_each_entry_rcu(contns, contobj_list, list)
> +               if (contns->obj == cont) {
> +                       contns->count--;
> +                       if (contns->count < 1) {

One could simplify this with "(--countns->count) < 1", although if it
is changed to a refcount_t (which seems like a smart thing), the
normal decrement/test would be the best choice.


> +                               list_del_rcu(&contns->list);
> +                               kfree_rcu(contns, rcu);
> +                       }
> +                       break;
> +               }
> +       spin_unlock(&aunet->contobj_list_lock);
> +       rcu_read_unlock();
> +}

--
paul moore
www.paul-moore.com
