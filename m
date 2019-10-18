Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC75DD556
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 01:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733023AbfJRX2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 19:28:13 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36284 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbfJRX2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 19:28:13 -0400
Received: by mail-qk1-f196.google.com with SMTP id y189so6903551qkc.3
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 16:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Fkyt4lvbEBonQ9ACgGiZZ2ir8udVVX1YxbpF7GoVfw=;
        b=ev0NF6ream7jb1GQmPNPts5EEDPw249WExrCHFALJ5EYdYQ8wDJZkG9XC18f24Qcpj
         gFet0/+HedXTAhRnl9KbcJrlZnVB/lPNeyrUNl62igfenWIN8fQTd6Ydq3/c1oQfuwx/
         8FwRixeRLu/sdFkbNIqGka/Mn2HepcaZcEZ2nv90b9+aDkgLt196/1zdP8imnlXq1TFu
         NPUMeYid9sPTQJUySITMDGKnt9v3hIjmGw/Ms2FvmEQpW8kyGndLXV9OnMY4E6PweWCG
         8a9NcCQfeJlFB4m1OaUjuphygbY1gpj6zWU1h9QOBLjlaYGUQcRsC01XDuAkx6u882qx
         /xBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Fkyt4lvbEBonQ9ACgGiZZ2ir8udVVX1YxbpF7GoVfw=;
        b=Gtqr0ARb5kij6d3jHTRYFSvIMZrlNIfBbNlchCcTgJAtzel6P3hM6l/DNQGwKKVXKp
         2VDOnzI54VciB1iEbO9wHRPIoW+Bjnt4sHc/T+bkUYqusULyqJ+4UbI53xCVypUmxgGm
         kHWz4U/NKGI9KwjaNkgQMw7npfsdb6VDqFwSoMpUwO9LX6QBHXARcp079Lu8VvFSJ5j8
         GrGlEbOgae+x+kafxemAgkFfiEKvKwfyE3OqiFtCI0c6pGcJhhiKAlWc96MaYmjW1vQb
         qw3YiDHRJZbxuzGMZPtlZQ6XAQrOSx2BHtSd0Wxi+KKq44BllCu5KMwv80zGJ6p1eP6d
         He3g==
X-Gm-Message-State: APjAAAU6hKaLn1eO//QDs9wcMq76P1u5ttNUC5QuG+LAk9P6BW0d4TDB
        o4pdeX5pyCHpPU/Kut4XQxmrxRgAzELB2NxUpVE=
X-Google-Smtp-Source: APXvYqzHMrAsg4qKalsEXuwwDHwhkvpgHg0ROx5cB7jirwGVLG5KV8V+IP4o7G8Jk7gbnt8O3uMSPiCu3zKGecdY7XU=
X-Received: by 2002:a05:620a:6da:: with SMTP id 26mr11898545qky.184.1571441290384;
 Fri, 18 Oct 2019 16:28:10 -0700 (PDT)
MIME-Version: 1.0
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com> <1571135440-24313-8-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1571135440-24313-8-git-send-email-xiangxia.m.yue@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 18 Oct 2019 16:27:34 -0700
Message-ID: <CALDO+SbLyHzi2UB1RLxhUHkNjQeCk-BannPMevvUd6u=KKNT6g@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next v4 07/10] net: openvswitch: add likely
 in flow_lookup
To:     xiangxia.m.yue@gmail.com
Cc:     Greg Rose <gvrose8192@gmail.com>, pravin shelar <pshelar@ovn.org>,
        "<dev@openvswitch.org>" <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 5:55 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> The most case *index < ma->max, and flow-mask is not NULL.
> We add un/likely for performance.
>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Tested-by: Greg Rose <gvrose8192@gmail.com>
> ---
LGTM
Acked-by: William Tu <u9012063@gmail.com>


>  net/openvswitch/flow_table.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> index 3e3d345..5df5182 100644
> --- a/net/openvswitch/flow_table.c
> +++ b/net/openvswitch/flow_table.c
> @@ -518,7 +518,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
>         struct sw_flow_mask *mask;
>         int i;
>
> -       if (*index < ma->max) {
> +       if (likely(*index < ma->max)) {
>                 mask = rcu_dereference_ovsl(ma->masks[*index]);
>                 if (mask) {
>                         flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
> @@ -533,7 +533,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
>                         continue;
>
>                 mask = rcu_dereference_ovsl(ma->masks[i]);
> -               if (!mask)
> +               if (unlikely(!mask))
>                         break;
>
>                 flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
> --
> 1.8.3.1
>
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
