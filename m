Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEED64E266
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 21:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiLOUhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 15:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLOUhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 15:37:11 -0500
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139304A58D
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 12:37:10 -0800 (PST)
Received: by mail-vs1-xe2a.google.com with SMTP id q128so292688vsa.13
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 12:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XbLIsSB3dgqBgwoNc09sfFG6OJsgoRxnvFWyrHHQZqU=;
        b=c9Nb78oCpV/p+MBfA8FnPsQj9CMC094HBaLTo0ntmu0G73JVtV8u6mwaNjPCbFve5h
         L6LshCbm5hbgrEXyym8rIYxSGEzCWuQIQDSAGjAWYVzOnJd9DNWHcmEyUowO7Oq4JZTX
         ghof8LE4D1ez3ylUa4kiEjLxVypA5q/e+MXK/PKi0YjjE9zlTzGyg08WST5Lq847jrls
         FjpWSukNoeh939gembuhVWVQDP6rB81Tru/eT00j1YSYnZZCXbXYEiRPAfrFJrKduxHT
         gbsu85M4BYyrXSrNgevlcNAPVQUmOMs1Oy9dAAK41fnAX0xW9tPFgN/oE9FDmTpRCtD8
         QQ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XbLIsSB3dgqBgwoNc09sfFG6OJsgoRxnvFWyrHHQZqU=;
        b=YIvsH+SJQHsOr9b26r66Pr0Q0WeF1mOdUWsTdNP2xErHY5JYlQpLKQkCX/HRp/nEn2
         N2sbyKa8p7uvffAMRkMwd6y8P7dH+x6q5v7Gd4YweDilPqZ8E7nX7Mj/7RgfYTdvypKu
         kjg2yU30HC2lfMAx/7NECFgedWkWwnSpfkTrsto92ykNGAj8nK4IahTmURhBrYqRtJ4W
         UeUNGeydEdf+w5BGNeR/3EayVhK+qbrWwUO9iaYg5RrI13BlSOL2gXQANy//qjF4CbSP
         2vHS61qZXEczzRdSZieihFIdaihY5wkei0Gw8up9UE0GsqkQ2tGEmai96i0t5Q0KrMDu
         Cz3Q==
X-Gm-Message-State: ANoB5pnlMOhfSzl1xbkbhQvZy5w7TAkG8GNzcUDo+4n8fnrNJrwXvKtS
        xLxFrcYoIMC/SxKifzitP5lvVg192SFF5BIvsU+V5A==
X-Google-Smtp-Source: AA0mqf6wD6OR5yE6mzuBWbtVy3Ifu04HAug/G5d0E3OdzvIaHPfQKJgOSmhuPMwGVhOr1S3Zwqa9a9ykU6+8ArN+RnE=
X-Received: by 2002:a05:6102:5ee:b0:3b1:a1c:3cab with SMTP id
 w14-20020a05610205ee00b003b10a1c3cabmr19263442vsf.46.1671136629034; Thu, 15
 Dec 2022 12:37:09 -0800 (PST)
MIME-Version: 1.0
References: <20221213073801.361500-1-decot+git@google.com> <20221214204851.2102ba31@kernel.org>
 <CAF2d9jh_O0-uceNq=AP5rqPm9xcn=9y8bVxMD-2EiJ3bD_mZsQ@mail.gmail.com>
 <CAG88wWbZ3eXCFJBZ8mrfvddKiVihF-GfEOYAOmT_7VX_AeOoqQ@mail.gmail.com> <20221215110544.7e832e41@kernel.org>
In-Reply-To: <20221215110544.7e832e41@kernel.org>
From:   David Decotigny <ddecotig@google.com>
Date:   Thu, 15 Dec 2022 12:36:32 -0800
Message-ID: <CAG88wWYA72sij4iaWowLpawzM7tJdYdHCKQnE0bjndGO74vROw@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] net: neigh: persist proxy config across link flaps
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>, David Decotigny <decot+git@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "Denis V. Lunev" <den@openvz.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(answer below)

On Thu, Dec 15, 2022 at 11:05 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 14 Dec 2022 22:18:04 -0800 David Decotigny wrote:
> > I don't think this patch is changing that part of the behavior: we still
> > flush the cached nd entries when the link flaps. What we don't remove are
> > the pneigh_entry-es (ip neigh add proxy ...) attached to the device where
> > the link flaps: those are configured once and this patch ensures that they
> > survive the link flaps as long as the netdev stays admin-up. When
> > the netdev is brought admin-down, we keep the behavior we had before the
> > patch.
>
> Makes sense. This is not urgent, tho, right?

Not that kind of urgent.

FTR, in the v2 you suggested to use NUD_PERMANENT, I can try to see
how this would look like. Note that this will make the patch larger
and more intrusive, and with potentially a behavior change for whoever
uses the netlink API directly instead of the iproute2 implementation
for ip neigh X proxy things.

>
> David A, do you agree and should we treat this as a fix with
>
> Fixes: 859bd2ef1fc1 ("net: Evict neighbor entries on carrier down")

Thanks.

>
> added?
>
> Reminder: please bottom post on the list
