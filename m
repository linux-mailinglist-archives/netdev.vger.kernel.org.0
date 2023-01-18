Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D596722D7
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 17:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjARQUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 11:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjARQUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 11:20:22 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD711E1F2
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:16:40 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-4d13cb4bbffso354552547b3.3
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7BG3WpipDzeUpe2qY7UvUp347AVHDDvG/KdaPs3N/Kk=;
        b=dHfXo/8dMfvOEV2nvFi8X/q0/RnTR+FCMijvNNhxnbQdy5Cdf0YEcRlonoRGno4JwD
         WUlNVydmfRj3E8kFKTm4N0CwPJQflJM3b+ZfkFcDcbDol3SFicwcjxc2lWXNfkZ259Tp
         8w9QoyiE471Jr3cfXcioCUBEP7YisSDH1ex/cwfd8Zp3e3a+WuANEr3ZiJmuz9D7ZMOe
         Z3stdRMPREuwT6KGVLEb1RTBNxdlWSdsuYbzR5z4TfH+R0EvqupoNHIECooiHlULYu3K
         CI1p8dIDK5iUo20P7nvHWL00E8bWbE9FQlpZc/CPBuYp3fGxiCGDqesN0A5XT3jwDFTQ
         TEuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7BG3WpipDzeUpe2qY7UvUp347AVHDDvG/KdaPs3N/Kk=;
        b=qWwnJNYN7e4U35tnU8d+J/QPaaemAiZE4sI6iZp2qkJB3ZwWlGD3118f2FRDUm2U85
         RizuDQa59uW5W8wxIOmiaOMEqNVJVzLFEAh76/2S+75Rg1sq76RAB05MLifvrCDVgdWy
         jpe4NFy4gSjycoqko6RztvBnj5XRPSx1Xi172b4/hywl/DzktTPPoO64r9o7MN87Fcd9
         g1teGzJf7hy9vRb/KW2bBcRt9xEVIylC195m3Pio4+yCCX+n+c1EjM3eGMxAXKP+ke/C
         04zGMUiefcVYLfQboeSU2kcV1VaJasq3bHJct6QnsBOQy0iFpif3j5rb+HcuS0NwQGD8
         z3Pw==
X-Gm-Message-State: AFqh2kpUSjisRWkd/dHzn7G3p80B3skebp4TTnlEKh4zkXfU+hRhXa2t
        /RQ7iYH9nO060BfeW4yacOnAmQ1wtWzJIBvcOiQ=
X-Google-Smtp-Source: AMrXdXtrg7o+19XdjbnPtmZQW1WbNAEDx7z2T5Enfk3MwPuEsUvVE7fNKvPjvXFr6vPL7BRmknmxuqYqNRdYHC9yexY=
X-Received: by 2002:a81:c12:0:b0:4da:6eb4:cc5 with SMTP id 18-20020a810c12000000b004da6eb40cc5mr876765ywm.171.1674058599270;
 Wed, 18 Jan 2023 08:16:39 -0800 (PST)
MIME-Version: 1.0
References: <63e09531fc47963d2e4eff376653d3db21b97058.1673980932.git.lucien.xin@gmail.com>
 <09ce6f16-dc14-1936-ebeb-d3077c6c5b70@gmail.com>
In-Reply-To: <09ce6f16-dc14-1936-ebeb-d3077c6c5b70@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 18 Jan 2023 11:15:18 -0500
Message-ID: <CADvbK_dU04m8VZDEAeCZx4xNTr3J8Jj=NXpcSvoMuOuefC6AoQ@mail.gmail.com>
Subject: Re: [PATCH net] Revert "net: team: use IFF_NO_ADDRCONF flag to
 prevent ipv6 addrconf"
To:     David Ahern <dsahern@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>
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

On Tue, Jan 17, 2023 at 9:36 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 1/17/23 11:42 AM, Xin Long wrote:
> > This reverts commit 0aa64df30b382fc71d4fb1827d528e0eb3eff854.
> >
> > Currently IFF_NO_ADDRCONF is used to prevent all ipv6 addrconf for the
> > slave ports of team, bonding and failover devices and it means no ipv6
> > packets can be sent out through these slave ports. However, for team
> > device, "nsna_ping" link_watch requires ipv6 addrconf. Otherwise, the
> > link will be marked failure. This patch removes the IFF_NO_ADDRCONF
> > flag set for team port, and we will fix the original issue in another
> > patch, as Jakub suggested.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  drivers/net/team/team.c | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
> > index fcd43d62d86b..d10606f257c4 100644
> > --- a/drivers/net/team/team.c
> > +++ b/drivers/net/team/team.c
> > @@ -1044,7 +1044,6 @@ static int team_port_enter(struct team *team, struct team_port *port)
> >                       goto err_port_enter;
> >               }
> >       }
> > -     port->dev->priv_flags |= IFF_NO_ADDRCONF;
> >
> >       return 0;
> >
> > @@ -1058,7 +1057,6 @@ static void team_port_leave(struct team *team, struct team_port *port)
> >  {
> >       if (team->ops.port_leave)
> >               team->ops.port_leave(team, port);
> > -     port->dev->priv_flags &= ~IFF_NO_ADDRCONF;
> >       dev_put(team->dev);
> >  }
> >
>
> What about the other patches in that set - failover device and bonding?
This only exists in Team, as nsna_ping link watch in userspace libteam
requires IPv6 addrconf to send NS packets, see rawv6_sendmsg():

        dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
        if (IS_ERR(dst)) {
                err = PTR_ERR(dst);
                goto out;
        }

It will break here.

For bonding, nothing actually was changed as before, it's just using
a new flag IFF_NO_ADDRCONF instead of IFF_SLAVE. and the
late added nsna_ping link watch (trying to sync with libteam) is in
kernel space, and doesn't require dst on the slave dev, see:

  bond_ns_send_all() -> bond_ns_send().

For failover device, it checks the link when net_failover_start_xmit()
directly by:

    netif_running(dev) && netif_carrier_ok(dev)

I don't think a "link watch" in userspace exists, not to mention a nsna_ping.

Thanks.
