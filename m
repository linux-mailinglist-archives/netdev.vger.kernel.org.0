Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B462C3747C9
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 20:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236021AbhEESFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 14:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235973AbhEESEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 14:04:38 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38782C07E5EC
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 10:57:17 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id m12so4248461eja.2
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 10:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=u0YpP7QeR9+FnAljEpVJZP0A3y21RR6mHXedMhNEnys=;
        b=VdaxIr9H2+ajJi2/lkXI0jPbK0sFMw3lEU31US1cxU1bWTxiK6MOlSSf/dprOWg0q6
         LLUwhf7NNhQrMbi5k65kNZrcI/fcTIf9V3BFFAItIdUct5nj1lX0P2Q3mHPuwK6QIdZb
         zRogIgv/g2K+3bjIf+U4Q8Ml2+sbQVZzONULXot9Uv3ePfWWBP530BVTg4DadnrmasyN
         cHqCSuXcPmDmm+tdnjHUn6Xm9vO+Bfnk0ZVG2kpynbjLVqpSGMtmVo/mlU0v5IXiJvEl
         goWbX+r7Eyk9Lcyj0gfLi//R2ISZyRdPWdrFhPbqMuzKr9n/9poHLTDR8BVHcC1aUlyf
         Swwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=u0YpP7QeR9+FnAljEpVJZP0A3y21RR6mHXedMhNEnys=;
        b=cFFvl5fllszc2ByQ415EfIMHw21i7v5Yr7YlCdBNu4H4EJzEbEshOf5O6Okb6uTX42
         DOmBPS0bkGfVk1AcD+R2GpJWn9RjHmSn/K6iwUWfipJ1Xa7yVrVYQbEjBl/npk/YJB3U
         sQ0Ag1rTlnFAmNLs1n/vLPvov9mTRqsSe7u9cwytX6cCl0v3jma/LhkdDvrMAlfJbkZ8
         Bz7ydbGBThqfe2xTO1xvy6/K47tNPw+r8L2jz+v5GB831TOf1d5LhY7JLlIeCdjylj+N
         us7z/E6rYnDO9Y4gOBegjAx3wFlfoEdkAg8GOKsEr4R4xzmQ4RhIHmb+7l95EXy6TmlD
         xgoA==
X-Gm-Message-State: AOAM533fhOTEv63bK+wJ8oE1qyRq1T6UEGV+uxq7yRMJj8Tr1RcmvlIE
        Pij+TnsScwZDPODRudP/IeGnlwFK/IF00+NsqNRv41+gg+M=
X-Google-Smtp-Source: ABdhPJy+O5YhiubXIK80B+MVZSdv7DgM5ErTWAfnBxEsVUtpy5pGSgdsj3EMNbGb26vuNX6Y/FhdGnpUUarI0YTItNU=
X-Received: by 2002:a17:906:80cd:: with SMTP id a13mr20487675ejx.109.1620237435969;
 Wed, 05 May 2021 10:57:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210429190926.5086-1-smalin@marvell.com> <20210429190926.5086-22-smalin@marvell.com>
 <cbefe381-7d00-8535-a4d7-1ac36c7aaffc@suse.de>
In-Reply-To: <cbefe381-7d00-8535-a4d7-1ac36c7aaffc@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Wed, 5 May 2021 20:57:05 +0300
Message-ID: <CAKKgK4xetXxri0__kh-zmw3gMTiF0egr=RdNc2EcR4HN7aCLkg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 21/27] qedn: Add support of configuring HW filter block
To:     Hannes Reinecke <hare@suse.de>
Cc:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/21 2:38 PM, Hannes Reinecke wrote:
> On 4/29/21 9:09 PM, Shai Malin wrote:
> > From: Prabhakar Kushwaha <pkushwaha@marvell.com>
> >
> > HW filter can be configured to filter TCP packets based on either
> > source or target TCP port. QEDN leverage this feature to route
> > NVMeTCP traffic.
> >
> > This patch configures HW filter block based on source port for all
> > receiving packets to deliver correct QEDN PF.
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > ---
> >   drivers/nvme/hw/qedn/qedn.h      |  15 +++++
> >   drivers/nvme/hw/qedn/qedn_main.c | 108 ++++++++++++++++++++++++++++++=
-
> >   2 files changed, 122 insertions(+), 1 deletion(-)
> >
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Thanks.

>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Kernel Storage Architect
> hare@suse.de                              +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=
=B6rffer
