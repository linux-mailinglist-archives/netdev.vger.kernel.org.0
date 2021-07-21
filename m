Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6093D16A8
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 20:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhGUSJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 14:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbhGUSJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 14:09:25 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71057C061575;
        Wed, 21 Jul 2021 11:50:01 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id c17so1891358wmb.5;
        Wed, 21 Jul 2021 11:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vYb01ay7yAvyr0PcX6y2FB2sBUlWe5IbSuTyUYl0Un4=;
        b=MxQxgiI5oOvwG+qayndFX42qCbQID97lUa8wSqklhjGoarAuw19r17+yUewyjrhBtl
         esWUk1GNPgPYq71oV8gALyHxg5fDMZm2tpCIjuJxeWWRjFrLxNXjIHf8oyt2XiEynOs5
         z8+zUCAH8VrFqxIOxqx3CF3Z8JMc5jiziZoB4WN/kSo+AbVfuQTF6oEQjVSAsu6CbTZ2
         eaQdXOfvHMsN4M8hQaJjl07CWvxNHoIVSrNlkKjV8l4mjohEWq5/QPaMrq6utBXW+BDW
         +Jj+wKpfbD4D/YcFaZE1KhnbiZOcfpCunQd1yUlFb1VALmBWj4rmmsC2FO6n+uLHfTEf
         TTSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vYb01ay7yAvyr0PcX6y2FB2sBUlWe5IbSuTyUYl0Un4=;
        b=QOCVelYotEpuPTs84WvN9c7c16k/1Ms2L52cbYER80I21xahV07KpOSAyLYS4yVFdh
         +VrR541lWj3GJ7GvnfodK6jZk2Oe09tekUxYzcCxk/IHXECmV+6CS3BHklLDmnkl9/F8
         Uup1tOs2UFrF+eYqOF25MoDo4c+yUNJfiVAUj3NH0r1xiTEfmEATBVaNKJci1mLT+D1Q
         o7Dumi9gcJ+WXE5uqTFSH0+bv/3P9rmCu1W9YdMXSi8n2/aDFGeHgpzJgngumEOF1GqY
         gfh65JqqZ/1J40D9X2ANTCGWLKtSg8ikzvLOYcNz+ZBNt6KyUT6eFEPHL8nGKvaLijHa
         C5bw==
X-Gm-Message-State: AOAM533b+3f1kB2BpxRtPGu2mJMCddL6f6vC8R5pG+OcyCA7VrWmdVxe
        jGXW3EVm8M2awVufxltEbQTe7b+X89ONDyCbRDE=
X-Google-Smtp-Source: ABdhPJzL5QIyAHJOHzM1Hro8aRxi6GpLGTmfuXZ5uKRv3Y7iCqzdB291xa5oQQGFHJE0VVS0Lye6kG+WDeJW/J0g/uE=
X-Received: by 2002:a1c:988a:: with SMTP id a132mr5379424wme.175.1626893400008;
 Wed, 21 Jul 2021 11:50:00 -0700 (PDT)
MIME-Version: 1.0
References: <a0a956bbb2142d8de933d20a7a01e8ce66d048c0.1626883705.git.lucien.xin@gmail.com>
 <YPhqk1Sx5FKYyiK+@horizon.localdomain>
In-Reply-To: <YPhqk1Sx5FKYyiK+@horizon.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 21 Jul 2021 14:49:49 -0400
Message-ID: <CADvbK_ckYAVEuygZsnbWozfJKTV5Np+p_s8P=ZpErqu_j9S3Bg@mail.gmail.com>
Subject: Re: [PATCH net] sctp: do not update transport pathmtu if
 SPP_PMTUD_ENABLE is not set
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        Jacek Szafraniec <jacek.szafraniec@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 2:42 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Wed, Jul 21, 2021 at 12:08:25PM -0400, Xin Long wrote:
> > Currently, in sctp_packet_config(), sctp_transport_pmtu_check() is
> > called to update transport pathmtu with dst's mtu when dst's mtu
> > has been changed by non sctp stack like xfrm.
> >
> > However, this should only happen when SPP_PMTUD_ENABLE is set, no
> > matter where dst's mtu changed. This patch is to fix by checking
> > SPP_PMTUD_ENABLE flag before calling sctp_transport_pmtu_check().
> >
> > Thanks Jacek for reporting and looking into this issue.
> >
> > Fixes: 69fec325a643 ('Revert "sctp: remove sctp_transport_pmtu_check"')
> > Reported-by: Jacek Szafraniec <jacek.szafraniec@nokia.com>
> > Tested-by: Jacek Szafraniec <jacek.szafraniec@nokia.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/sctp/output.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/sctp/output.c b/net/sctp/output.c
> > index 9032ce60d50e..8d5708dd2a1f 100644
> > --- a/net/sctp/output.c
> > +++ b/net/sctp/output.c
> > @@ -104,8 +104,8 @@ void sctp_packet_config(struct sctp_packet *packet, __u32 vtag,
> >               if (asoc->param_flags & SPP_PMTUD_ENABLE)
> >                       sctp_assoc_sync_pmtu(asoc);
> >       } else if (!sctp_transport_pl_enabled(tp) &&
> > -                !sctp_transport_pmtu_check(tp)) {
> > -             if (asoc->param_flags & SPP_PMTUD_ENABLE)
> > +                asoc->param_flags & SPP_PMTUD_ENABLE)
>
> Lacks a '{' here at the end of the line.
ah, right, sorry, reposted.

>
> Other than that:
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>
> (please add it on the v2)
>
> > +             if (!sctp_transport_pmtu_check(tp))
> >                       sctp_assoc_sync_pmtu(asoc);
> >       }
> >
> > --
> > 2.27.0
> >
