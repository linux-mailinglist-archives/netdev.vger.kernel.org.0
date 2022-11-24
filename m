Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36390637DDB
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 17:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiKXQ7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 11:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiKXQ67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 11:58:59 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B66A54749
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 08:58:59 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d20so1898236plr.10
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 08:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gRRCuc/w57eDGNXouZD3v2uxjgd+VSipK8INK2DTRLU=;
        b=oENLdFH9JRX1DYUUAOASx3eRG2fXDok0tjg6VWzbPlst9mPnq20AKFIU+JiKcGAb49
         PMdnqGMVfKuL43JyMfurwzLId7rI+wktJVhSfha0B3vuczIOZZ9agyMfNi5SK22jOp32
         hZr/wjfJqvoqw8Ep16y55gXOscIymZ9l0LQFVkZCGD+a8nCPIdntuZSRE6vkJCzFtwgd
         wzg4SHoTT1/9RovHJDfwVKF3fwZq78QALbv6QT0206seIYTLgPJMriVxzzn9ZY+Vuo23
         hIJJ+Z64lDboxnQ8G49XDaHhvSs3BhlGxRnf6maDBBU+S+FJcla+JV4mcie7R0eh4oDy
         a8rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gRRCuc/w57eDGNXouZD3v2uxjgd+VSipK8INK2DTRLU=;
        b=UaEq9vWj2lsXjXYg0Tfrjd1TazMngBogIwRcZ75qiC65zvBRT+mKmexdjmVCEvd8Fc
         0O5Nb+MWTjGKJciHzk6ogniRsa6mxffud2k8emxfgMH6bfvTgUNGglRSD7SdYbZjfeLf
         YtM2MkqM1QZmhPA5X8DQUM9q/H09yY3TWnZCFWrpZOrLeeYACbQPgsLvi/Ifra0yUrLc
         X+I4buaGmCt8LpuzMdjd0cvb7cnX1ZglmVrVlvTR9KYD20U1K9XIl5P61z0423qc23my
         BO7SsTPzMeeH7pBYwJD01BtqYCN5Z1bgF4JvaH0gxZbnYvMIiAOPQtcj2XemXlhcv4q9
         X7iQ==
X-Gm-Message-State: ANoB5pmI1DSe/FJeOpBEOO0F/n3mSlsnLSKdA+rnUngD2ESpLvsGHYFX
        aZaFZVpfMZa2uI5BmUsHrMAqy29K8UDrEqzeR6w=
X-Google-Smtp-Source: AA0mqf5Ppf7sc/Zw80L7kaQvUex6KZ4mU69fuZxRBpzTzj7+vqUsJeApbZIXPYpABV1D/82YvOPgSG8Q0bTgyu93yBg=
X-Received: by 2002:a17:902:f68a:b0:186:f256:91cd with SMTP id
 l10-20020a170902f68a00b00186f25691cdmr27045255plg.152.1669309138518; Thu, 24
 Nov 2022 08:58:58 -0800 (PST)
MIME-Version: 1.0
References: <CAOiHx==ddZr6mvvbzgoAwwhJW76qGNVOcNsTG-6m79Ch+=aA5Q@mail.gmail.com>
 <Y39me56NhhPYewYK@shredder> <CAOiHx=kRew115+43rkPioe=wWNg1TNx5u9F3+frNkOK1M9PySw@mail.gmail.com>
 <CAOiHx=n2O1m24ZbMRbfD1=PCs-yYajpjNWR1y1oBP8Rz-8wA5A@mail.gmail.com>
 <Y3+Evdg9ODFVM9/w@shredder> <CAOiHx=mi-M+dWj-Y1ZZJ_xSY_-n0=xy9u1Gmx3Yw=zJHeuiS+A@mail.gmail.com>
 <Y3+V9gu4NUQ7P0mL@shredder>
In-Reply-To: <Y3+V9gu4NUQ7P0mL@shredder>
From:   Jonas Gorski <jonas.gorski@gmail.com>
Date:   Thu, 24 Nov 2022 17:58:47 +0100
Message-ID: <CAOiHx=mKo_r-JTF0wtg3Aw+6-yvyorkm28GG1Dwp3viFg3x5NA@mail.gmail.com>
Subject: Re: RTM_DELROUTE not sent anymore when deleting (last) nexthop of
 routes in 6.1
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Nov 2022 at 17:04, Ido Schimmel <idosch@idosch.org> wrote:
>
> On Thu, Nov 24, 2022 at 04:20:49PM +0100, Jonas Gorski wrote:
> > We have an integration test using FRR that got broken by this, so I
> > can also easily test anything you throw at me (assuming CET working
> > hours).
>
> Please test the following fix [1]. Tested manually using [2]. With the
> fix or 61b91eb33a69 reverted the route is successfully deleted. Without
> the fix I get:
>
> RTNETLINK answers: No such process
> 198.51.100.0/24 nhid 1 via 192.0.2.2 dev dummy10
>
> If the fix is OK, I will submit it along with a selftest to make
> sure it does not regress in the future.
>
> Thanks
>
> [1]
> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> index f721c308248b..19a662003eef 100644
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -888,9 +888,11 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
>                 return 1;
>         }
>
> -       /* cannot match on nexthop object attributes */
> -       if (fi->nh)
> -               return 1;
> +       if (fi->nh) {
> +               if (cfg->fc_oif || cfg->fc_gw_family || cfg->fc_mp)
> +                       return 1;
> +               return 0;
> +       }
>
>         if (cfg->fc_oif || cfg->fc_gw_family) {
>                 struct fib_nh *nh;

I can confirm this fixes the issue. Reading the code, this is
basically like it was before the commit with an additional return 1
for (fi->nh && cfg->fc_mp).

Thanks for the quick fix! Here, have a

Tested-by: Jonas Gorski <jonas.gorski@gmail.com>

Regards
Jonas
