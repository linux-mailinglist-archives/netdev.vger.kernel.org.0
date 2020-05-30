Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F6C1E9341
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 21:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbgE3THi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 15:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE3THi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 15:07:38 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E33CC03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 12:07:38 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id r16so2674306qvm.6
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 12:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xQjfxSp6tQlm3qoeA0rhy8uozOA1bZokgmqLzMiimis=;
        b=SBADHleRvqoJsJAQrpioK/quSZCLzc6jiPs+Zexe/OOYxiUP+7ssdo3NmL0HzJ0KbM
         kTAwnl9GsIr67XEjfKbtw0tA1S6qZFck7NhR/6l/3G8qo1UrHx6xbq6BLUbESbeZ5Ri0
         4nwdNK+ujxCDfXLUG7p3C1ndutVw1LKLyKNi4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xQjfxSp6tQlm3qoeA0rhy8uozOA1bZokgmqLzMiimis=;
        b=FQQjVQq5eQU20a0ibOoevpcCZhtTKAzEWlqXkNwPbnFc0JDihopsfuYVZPy4jgCytI
         kq5ADeSESX64rG09PfxcMRk3/Ow/cWHQGIM/hJjaCGTPopQ0yxjxRliaQAEO5IwdmIeO
         p+W6x6hySIojLTwTQU6M2g1d9Q29bvmq9golpq2WNnKfxYh17WFxBq2tJrQ5Fuxs+C2r
         DXTh6EX1b2pgXhbKj43AnbOeJ2f1MCbttYdAj0O1JH2xLDscKPc2n+l4c0egg0rSca6g
         RBE/ftCoPbNvylzvzJOrEvGC/u/DBu2DyuG2GJVeOCrHSSZqNLpMGsxHrRmHYJ1C+xO8
         U8+g==
X-Gm-Message-State: AOAM5337b6Ng9tBAoFE2xJu4eSYX448jJfZQs/w3+hlAxnJjvaEoJ8OP
        keykAb+MwV6hC7TZB/73+PLSzwdiehqcs760w5Ubeg==
X-Google-Smtp-Source: ABdhPJxKTyW904rA722cLVaAv7aQH6dd+4fLoz9RBZYaPz2yA40J3Pjui5XLzEwwVXfAFNbNzjfziYY8Fxr5+LvgbkQ=
X-Received: by 2002:a05:6214:12ec:: with SMTP id w12mr1517845qvv.107.1590865657280;
 Sat, 30 May 2020 12:07:37 -0700 (PDT)
MIME-Version: 1.0
References: <1590729156-35543-1-git-send-email-roopa@cumulusnetworks.com> <20200530133430.GA1623322@splinter>
In-Reply-To: <20200530133430.GA1623322@splinter>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Sat, 30 May 2020 12:07:32 -0700
Message-ID: <CAJieiUg8wu5QA6dBdN4C45BseWixT+AGdrUrmkVCOE_YwGf+dA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] vxlan fdb nexthop misc fixes
To:     Ido Schimmel <idosch@idosch.org>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 30, 2020 at 6:34 AM Ido Schimmel <idosch@idosch.org> wrote:
>
> On Thu, May 28, 2020 at 10:12:34PM -0700, Roopa Prabhu wrote:
> > From: Roopa Prabhu <roopa@cumulusnetworks.com>
>
> Hi Roopa,
>
> I noticed that sparse complains about the following problem in
> the original submission (not handled by current set):
>
> drivers/net/vxlan.c:884:41: warning: dereference of noderef expression
>
> Seems to be fixed by:
>
> diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
> index 39bc10a7fd2e..ea7af03e0957 100644
> --- a/drivers/net/vxlan.c
> +++ b/drivers/net/vxlan.c
> @@ -881,13 +881,13 @@ static int vxlan_fdb_nh_update(struct vxlan_dev *vxlan, struct vxlan_fdb *fdb,
>                         goto err_inval;
>                 }
>
> -               if (!nh->is_group || !nh->nh_grp->mpath) {
> +               nhg = rtnl_dereference(nh->nh_grp);
> +               if (!nh->is_group || !nhg->mpath) {
>                         NL_SET_ERR_MSG(extack, "Nexthop is not a multipath group");
>                         goto err_inval;
>                 }
>
>                 /* check nexthop group family */
> -               nhg = rtnl_dereference(nh->nh_grp);
>                 switch (vxlan->default_dst.remote_ip.sa.sa_family) {
>                 case AF_INET:
>                         if (!nhg->has_v4) {
>
> Assuming it's correct, can you please fold it into v2?
>

Thanks Ido. This makes sense. I will add it to v2.
