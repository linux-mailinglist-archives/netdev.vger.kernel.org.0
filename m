Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BAB4706E7
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244367AbhLJR0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbhLJR0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 12:26:24 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36371C061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:22:49 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id 131so22849382ybc.7
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nrvuOKzSARNrNuIABttSSEgTHX3QWGpNnQR6mPCmlBk=;
        b=c3vRAhwXvbujw6WW/HXq3raIqD85PinSdO0kntNEjABE7ovRdw/+dPnh4Zq86EVEGw
         XEa80WTMJz8SdPtdTsea0uDQWImK1t50OA5psfcSA39/x2eireK1cELIZmuiyQeEYSHT
         iLDjGlIWvHlO0ueJwP+edodEwdHb+DBzXuRI1vlRyCGgaGwThTnF6QTfFk8yiLH7496i
         sX4QpHk4fiTRaRYYCmQLHhbfz0QuX4yMdFTdOwwj9ieEg8SzrNbhdI8E4BU9+XuST0Eg
         hj6v7uW1N802MIeTzId7hX9VQKBdcoJNBCDmLXOyG89IgmOrpCbTME8Dz/bySGBF/I/w
         7Atg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nrvuOKzSARNrNuIABttSSEgTHX3QWGpNnQR6mPCmlBk=;
        b=Z2cAbKpdJbernf0NyVLJ8Wq5oMNE8VMC2WUwczzAZXWjVqu32oxrNrTvPMrQhfokXz
         5KQEaT/wuTBSpQB3KlsLJ5dDsyFlWumbiOfpUHGDv5caZFPmPeyZ656VQ7KoKRMGYtrO
         PtHgYQOsOUuHS+cY0uw8Mz59OC6BZPb68e4U+wu0yODt5AnEOET84tSxKRvGpYekF8F1
         ohFZMlqKOTyw/RXHBU5tltkKjOPV8F4RU5EbtQUB+b9xuRbhUiWzsrhsZiB2i+bsJJX0
         /NPnMs1ULn2NQcvg2eD7VDJYqizgJrBClvW/mxS8e36+2KuNMZFb/7U71YP7+TDS3ooO
         huCA==
X-Gm-Message-State: AOAM532HB1ExWWOB/Gv60cAlgyI7paL82TEfQv4j+aCQukxnrJ8bOtlX
        KvvIFK2jq00luIYZAgrxr70YGs9wjUANdl/KL/E=
X-Google-Smtp-Source: ABdhPJzV1eqWC5ikNwgLmYp+LE7VOZSSS2nc7HJvs/rJ2dd9hGIxibwtPnGkH4GVFWnOI0bX0dJRmMT3F29+hVqjS+w=
X-Received: by 2002:a25:a262:: with SMTP id b89mr15665328ybi.434.1639156966972;
 Fri, 10 Dec 2021 09:22:46 -0800 (PST)
MIME-Version: 1.0
References: <0bfebd4e5f317cbf301750d5dd5cc706d4385d7f.1639064087.git.antony.antony@secunet.com>
In-Reply-To: <0bfebd4e5f317cbf301750d5dd5cc706d4385d7f.1639064087.git.antony.antony@secunet.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Fri, 10 Dec 2021 19:22:35 +0200
Message-ID: <CAHsH6GstRxgMJsPNh5Jg_ow9fZBULMsCPKc0Y01pNTOD0Pc+4g@mail.gmail.com>
Subject: Re: [PATCH 1/2] xfrm: interface with if_id 0 should return error
To:     antony.antony@secunet.com
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 9, 2021 at 5:36 PM Antony Antony <antony.antony@secunet.com> wrote:
>
> xfrm interface if_id = 0 would cause xfrm policy lookup errors since
> commit 9f8550e4bd9d ("xfrm: fix disable_xfrm sysctl when used on xfrm interfaces")
>
> Now fail to create an xfrm interface when if_id = 0
>
> With this commit:
>  ip link add ipsec0  type xfrm dev lo  if_id 0
>  Error: if_id must be non zero.
>
> Signed-off-by: Antony Antony <antony.antony@secunet.com>
> ---
>  net/xfrm/xfrm_interface.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
> index 41de46b5ffa9..57448fc519fc 100644
> --- a/net/xfrm/xfrm_interface.c
> +++ b/net/xfrm/xfrm_interface.c
> @@ -637,11 +637,16 @@ static int xfrmi_newlink(struct net *src_net, struct net_device *dev,
>                         struct netlink_ext_ack *extack)
>  {
>         struct net *net = dev_net(dev);
> -       struct xfrm_if_parms p;
> +       struct xfrm_if_parms p = {};
>         struct xfrm_if *xi;
>         int err;
>
>         xfrmi_netlink_parms(data, &p);
> +       if (!p.if_id) {
> +               NL_SET_ERR_MSG(extack, "if_id must be non zero");
> +               return -EINVAL;
> +       }
> +
>         xi = xfrmi_locate(net, &p);
>         if (xi)
>                 return -EEXIST;
> @@ -666,7 +671,12 @@ static int xfrmi_changelink(struct net_device *dev, struct nlattr *tb[],
>  {
>         struct xfrm_if *xi = netdev_priv(dev);
>         struct net *net = xi->net;
> -       struct xfrm_if_parms p;
> +       struct xfrm_if_parms p = {};
> +
> +       if (!p.if_id) {
> +               NL_SET_ERR_MSG(extack, "if_id must be non zero");
> +               return -EINVAL;
> +       }
>
>         xfrmi_netlink_parms(data, &p);
>         xi = xfrmi_locate(net, &p);

Looks good. Maybe this needs a "Fixes:" tag?

Reviewed-by: Eyal Birger <eyal.birger@gmail.com>

Thanks,
Eyal.

> --
> 2.30.2
>
