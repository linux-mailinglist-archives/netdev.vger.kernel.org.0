Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFEA25EC42
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 05:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgIFDLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 23:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728423AbgIFDLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 23:11:35 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A53C061575
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 20:11:34 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id p9so13460645ejf.6
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 20:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SybKxt5r4DpvJrcMyqAvCQLDougVZq4LzKHHKUMsChQ=;
        b=ykReTnxBXkJsWZZN0PHYU3YOHbOnWIm0kjaI7+WAIAr1lrM94tp+tB0exoUy676xU2
         YKwk5Ae/lyF0lu+6+en61/Mo/0wuZNyVsiq7X0EeD0JAHQmEdKIX3ZlIHKzXlwQ8ijE/
         e5uPvT2aOUt3ZdzDDvK+/Si4RmFcxDiSi34Pyrrt+zBBphdUqsNWnJD778wLYFbQPYsQ
         u0w5gkBYuhNlKlps6SlKT4ejErFd0NbDjLZipVA+6AsQds4qmOgrvH+JeKcw0Ttkgdxi
         kJMyHfxnbuKoK/PKSoCM3IbCTRJ9ddqBnzLNWAsvyAyNw9UNdOidjbGAEk4IZilIU/j4
         jiUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SybKxt5r4DpvJrcMyqAvCQLDougVZq4LzKHHKUMsChQ=;
        b=W7qN9MuIfwwpT8y5F6o/TlS0fmZpoB/0KNce0tNamA2fhBuLahem6emZuog4O+d/iP
         B+2CpY/zdN1VFxyAUTCwKFz6oAvrhgsgOg+Z1J31RCTsZFzG4nl1I0wWsd5fQMLvs5iQ
         QCzpsjRa1F5XXedRxVvfaXpOCBxT1IC0QzjlWOeqabeI4uM5N57yj3A1hen5RT9dQBmF
         1ffRnTpu52SB2lXxYYIT71klkxAf8926IPFaX5SyoAzBN9jPmpV4BYjakD28UsN/IyQZ
         HmjXds3pDf6kSR+EnqaZCVjJAGBArfN+fqUSDFrXZ3dzwgZAbZGnu430TR5pdzXU3Mim
         w6kg==
X-Gm-Message-State: AOAM531llulFH/XR1zUAWnOFcqFgedl1dAYsKf1E7OcthkcbWHCwlCU+
        EfttgwHHFtzBmOOSb7wC+c8AjYasePVPLzzOARVm
X-Google-Smtp-Source: ABdhPJz5gSoHhhwkKtx1ywEnb64j++4ZT6agTN648mykHqeVYLGtzaHe4GRGCTjL1A1eMy+wXx/j7tG+2Bw+w4rGAXU=
X-Received: by 2002:a17:906:a415:: with SMTP id l21mr13979834ejz.431.1599361892319;
 Sat, 05 Sep 2020 20:11:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200826145247.10029-1-casey@schaufler-ca.com> <20200826145247.10029-18-casey@schaufler-ca.com>
In-Reply-To: <20200826145247.10029-18-casey@schaufler-ca.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sat, 5 Sep 2020 23:11:21 -0400
Message-ID: <CAHC9VhQEvw2jKekJeC+-eXVNii4gTS7vxqDHqWVgQL2vFCJqXA@mail.gmail.com>
Subject: Re: [PATCH v20 17/23] LSM: security_secid_to_secctx in netlink netfilter
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     casey.schaufler@intel.com, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, keescook@chromium.org,
        john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
        Stephen Smalley <sds@tycho.nsa.gov>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 11:20 AM Casey Schaufler <casey@schaufler-ca.com> wrote:
>
> Change netlink netfilter interfaces to use lsmcontext
> pointers, and remove scaffolding.
>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: John Johansen <john.johansen@canonical.com>
> Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> cc: netdev@vger.kernel.org
> ---
>  net/netfilter/nfnetlink_queue.c | 31 ++++++++++++-------------------
>  1 file changed, 12 insertions(+), 19 deletions(-)

...

> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index d3f8e808c5d3..c830401f7792 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -401,8 +399,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>         enum ip_conntrack_info ctinfo;
>         struct nfnl_ct_hook *nfnl_ct;
>         bool csum_verify;
> -       struct lsmcontext scaff; /* scaffolding */
> -       char *secdata = NULL;
> +       struct lsmcontext context = { };
>         u32 seclen = 0;
>
>         size = nlmsg_total_size(sizeof(struct nfgenmsg))
> @@ -469,7 +466,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>         }
>
>         if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
> -               seclen = nfqnl_get_sk_secctx(entskb, &secdata);
> +               seclen = nfqnl_get_sk_secctx(entskb, &context);
>                 if (seclen)
>                         size += nla_total_size(seclen);
>         }

I think we can get rid of the local "seclen" variable, right?  We can
embed the nfqnl_get_sk_secctx() in the conditional and then simply
reference "context.len" everywhere else, yes?  For example:

  if (nfqnl_get_sk_secctx(..., &context))
    size += nla_total_size(context.len);

-- 
paul moore
www.paul-moore.com
