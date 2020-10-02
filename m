Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141F3281A6A
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 20:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388139AbgJBSFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 14:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBSFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 14:05:00 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6176C0613E2
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 11:05:00 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id e62so1027674vsc.10
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 11:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z8oT57QjyXZZ9y7td9vy4wNcedb44ceZQ7PhsHZieuE=;
        b=SvlX4EEX355dRtFUTXfZgfzLkskG7/cuhJsCvF9/ugjWKtukZTQGqDNo6OPCBM001+
         Hc9q91/NjeOBcW1XscPjxZAH4DeSeP4hdwmOZ2xNF4qX9SXEP6Fj7eEO52OfeUtyo8P4
         +b6xT6oFAnODDg6Uw8KtlABp2I9+yqaNDTAtk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z8oT57QjyXZZ9y7td9vy4wNcedb44ceZQ7PhsHZieuE=;
        b=DHhPjM1jUQMSFktNWg0J1W3LJCXXme71tXz6Mj/xHlXb6kYfw393SPSJtZq2dDdafV
         gVc2ahRDMxupWg+NSyd24qibimiIqCLiw5craqr/OtyUV43gaBTUFmUcm83w9mT6t+LP
         6Rny722ThuA0eYjPvsJBWw3NHVQcC0FeorWV9M6lYA+/dsxlTY+pKhtWiDQ30r6ZjeCY
         Iu48Y9DNde7GC6HMMQTrqQFW11h0tRnVyW9KYQ+HsfKjvWfb4rvGwiG+JudBWJRkUDG5
         SwOuCzdllHELVqzFv+tZJtZMkGDxK8OK0oZGxSfzHPk8p8Gmu9SrLff+kotBz7SxSHoc
         bBWg==
X-Gm-Message-State: AOAM533ZL7neaq/2xtaK8VOz/7hUe2Y3I03+L4KAcXrSag3us7RUnbL2
        OwDo/faeOk3+maw1ighh4u6myTZzqEmTLQ==
X-Google-Smtp-Source: ABdhPJwnWG6SXsJJH68asQDCZgTvNfqrRiunZHrV4uhmTCL2+ltqDg9TsQqYTRB3t/zdtrEh5g5xiQ==
X-Received: by 2002:a67:8d8a:: with SMTP id p132mr2122294vsd.16.1601661899261;
        Fri, 02 Oct 2020 11:04:59 -0700 (PDT)
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com. [209.85.221.180])
        by smtp.gmail.com with ESMTPSA id y13sm340865vsm.15.2020.10.02.11.04.58
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 11:04:58 -0700 (PDT)
Received: by mail-vk1-f180.google.com with SMTP id a16so467539vke.3
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 11:04:58 -0700 (PDT)
X-Received: by 2002:a1f:a905:: with SMTP id s5mr2121949vke.9.1601661898118;
 Fri, 02 Oct 2020 11:04:58 -0700 (PDT)
MIME-Version: 1.0
References: <20201002170526.15450-1-manivannan.sadhasivam@linaro.org>
In-Reply-To: <20201002170526.15450-1-manivannan.sadhasivam@linaro.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Fri, 2 Oct 2020 11:04:46 -0700
X-Gmail-Original-Message-ID: <CAD=FV=W0E2_2PXHedyiTeXbK323gDiSSJyx9n6CMX5D9oR7CNg@mail.gmail.com>
Message-ID: <CAD=FV=W0E2_2PXHedyiTeXbK323gDiSSJyx9n6CMX5D9oR7CNg@mail.gmail.com>
Subject: Re: [PATCH v2] net: qrtr: ns: Fix the incorrect usage of rcu_read_lock()
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alex Elder <elder@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Oct 2, 2020 at 10:06 AM Manivannan Sadhasivam
<manivannan.sadhasivam@linaro.org> wrote:
>
> The rcu_read_lock() is not supposed to lock the kernel_sendmsg() API
> since it has the lock_sock() in qrtr_sendmsg() which will sleep. Hence,
> fix it by excluding the locking for kernel_sendmsg().
>
> While at it, let's also use radix_tree_deref_retry() to confirm the
> validity of the pointer returned by radix_tree_deref_slot() and use
> radix_tree_iter_resume() to resume iterating the tree properly before
> releasing the lock as suggested by Doug.
>
> Fixes: a7809ff90ce6 ("net: qrtr: ns: Protect radix_tree_deref_slot() using rcu read locks")
> Reported-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Alex Elder <elder@linaro.org>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>
> Changes in v2:
>
> * Used radix_tree_deref_retry() and radix_tree_iter_resume() as
> suggested by Doug.
>
>  net/qrtr/ns.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 57 insertions(+), 6 deletions(-)
>
> diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
> index 934999b56d60..dadbe2885be2 100644
> --- a/net/qrtr/ns.c
> +++ b/net/qrtr/ns.c
> @@ -203,15 +203,24 @@ static int announce_servers(struct sockaddr_qrtr *sq)
>         /* Announce the list of servers registered in this node */
>         radix_tree_for_each_slot(slot, &node->servers, &iter, 0) {
>                 srv = radix_tree_deref_slot(slot);
> +               if (!srv)
> +                       continue;
> +               if (radix_tree_deref_retry(srv)) {
> +                       slot = radix_tree_iter_retry(&iter);
> +                       continue;
> +               }
> +               slot = radix_tree_iter_resume(slot, &iter);
> +               rcu_read_unlock();
>
>                 ret = service_announce_new(sq, srv);
>                 if (ret < 0) {
>                         pr_err("failed to announce new service\n");
> -                       goto err_out;
> +                       return ret;
>                 }
> +
> +               rcu_read_lock();
>         }
>
> -err_out:
>         rcu_read_unlock();
>
>         return ret;

nit: you can go back to "return 0" and get rid of the init of "ret =
0" at the beginning of the function.  The need to "return ret" and
init to 0 was introduced by your previous change because of the "goto
err_out" which you no longer have.

...this is true for all your functions, I believe.


> @@ -571,16 +605,33 @@ static int ctrl_cmd_new_lookup(struct sockaddr_qrtr *from,
>         rcu_read_lock();
>         radix_tree_for_each_slot(node_slot, &nodes, &node_iter, 0) {
>                 node = radix_tree_deref_slot(node_slot);
> +               if (!node)
> +                       continue;
> +               if (radix_tree_deref_retry(node)) {
> +                       node_slot = radix_tree_iter_retry(&node_iter);
> +                       continue;
> +               }
> +               node_slot = radix_tree_iter_resume(node_slot, &node_iter);
>
>                 radix_tree_for_each_slot(srv_slot, &node->servers,
>                                          &srv_iter, 0) {
>                         struct qrtr_server *srv;
>
>                         srv = radix_tree_deref_slot(srv_slot);
> +                       if (!srv)
> +                               continue;
> +                       if (radix_tree_deref_retry(srv)) {
> +                               srv_slot = radix_tree_iter_retry(&srv_iter);
> +                               continue;
> +                       }
> +                       srv_slot = radix_tree_iter_resume(srv_slot, &srv_iter);
> +
>                         if (!server_match(srv, &filter))
>                                 continue;
>

nit: move the "srv_slot = radix_tree_iter_resume(srv_slot,
&srv_iter);" line here (after the !server_match() test) so you only
call it if you're doing the unlock?


I'm not too worried about the nits, though it'd be nice to fix them.
Thus, I'll add:

Reviewed-by: Douglas Anderson <dianders@chromium.org>

...though I'll remind you that I'm a self-professed clueless person
about RCU and radix trees).

I haven't stress tested anything, but at least I no longer get any
warnings at bootup and my WiFi and modem still probe, so I guess:

Tested-by: Douglas Anderson <dianders@chromium.org>
