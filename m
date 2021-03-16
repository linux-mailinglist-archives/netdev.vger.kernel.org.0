Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC3833DC14
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 19:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239683AbhCPSF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 14:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbhCPSDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 14:03:52 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BF9C06174A;
        Tue, 16 Mar 2021 11:03:51 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id 81so38154331iou.11;
        Tue, 16 Mar 2021 11:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CafEaY8564FXEYcCceAauk7BwBP9On3BTyx0/8WTv5s=;
        b=nkiECfBcjbDkFCe0f2FFi1QQ7HqzKuS9ztWFfqjpN9mWjLhQFpLWW9oQxvBx8k1Z9w
         FLJNr8D9OJ13SKaITpQFVdnjQ9eKJy4MJfWE/NL6Q2nw9ZZJqM2ocf//9/PlFZbRc4lI
         95Rt0HoZAXiWBZP1ZJktx22gWTh/t85dQE1gJTFMDMCt9yd7AH9Hp3109xtkLGRZhKx5
         GRpX5UNx5nVfbT8JWPP+p9ewkvDh0fXhC4NUKEAGsYotCkoePwkM4iaAFXD97THiC0Tp
         MPHUJlUpOE56fs6o3vz0bFby1wsyO8JHenqp3i/oDq60JJn/OGkjhvLeMDsHc6NtBT6T
         KUVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CafEaY8564FXEYcCceAauk7BwBP9On3BTyx0/8WTv5s=;
        b=cvZwgW+vecM8owZst8bDE04JgCWaoAzcf4C+tcW2ORYF00IV/LWpm+HlrUYKke0sD7
         TmtsoEkLeWpHebwZH0q/YPO8Rmu8DyubahPEipQYBxhXQ7Jv9Hy4CElUnXVJNSvNRCNK
         3edtp4KapTZwpJPvCgftGRTFTEHGxKUtUx6yikwsN61HjAbeAhPk2mJgwQ3YiSoEWton
         i2j85/Ey0jo9U2FOMMuY7iu50q/jtrilpLnAws8WKLWwIlr20QVbqa9MdQyT18CUgUFT
         RFzqik9ARlaAbof2D9cHguQd87iYR76dxgLPSuu1Q1mnXtVvZhgwwSJO9J0CFxqrvZNl
         +TiQ==
X-Gm-Message-State: AOAM533ZmB2y+zFoSYkK0EZxsYC+62Mnhw0g2Cj3jZ5txQ8MI0mqxuyv
        t8EZfgxHr8wMRPtgNwcR3PoThBxssfQeewtFoos=
X-Google-Smtp-Source: ABdhPJxi1FvF+fi+k58yo4fMN7krMCCEGP0T6HQW4wj2wykGCp6iFI7yrCvkeZ0/50PIIQEfkzu8YgDKz4WOWzwaMuc=
X-Received: by 2002:a02:94cb:: with SMTP id x69mr15581624jah.8.1615917831173;
 Tue, 16 Mar 2021 11:03:51 -0700 (PDT)
MIME-Version: 1.0
References: <1615886833-71688-1-git-send-email-hkelam@marvell.com>
 <1615886833-71688-4-git-send-email-hkelam@marvell.com> <20210316100432.666d9bd5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210316100432.666d9bd5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Tue, 16 Mar 2021 23:33:40 +0530
Message-ID: <CALHRZupARnUK5PgRjv9-TmFd9mNUg0Ms55zZEC2VuDcaEBZYLQ@mail.gmail.com>
Subject: Re: [net PATCH 3/9] octeontx2-af: Do not allocate memory for devlink private
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hariprasad Kelam <hkelam@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        lcherian@marvell.com, Geetha sowjanya <gakula@marvell.com>,
        jerinj@marvell.com, Subbaraya Sundeep <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,


On Tue, Mar 16, 2021 at 10:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 16 Mar 2021 14:57:07 +0530 Hariprasad Kelam wrote:
> > From: Subbaraya Sundeep <sbhatta@marvell.com>
> >
> > Memory for driver private structure rvu_devlink is
> > also allocated during devlink_alloc. Hence use
> > the allocated memory by devlink_alloc and access it
> > by devlink_priv call.
> >
> > Fixes: fae06da4("octeontx2-af: Add devlink suppoort to af driver")
> > Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> > Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
>
> Does it fix any bug? Looks like a coding improvement.

Without this we cannot fetch our private struct 'rvu_devlink'  from any
of the functions in devlink_ops which may get added in future.

Thanks,
Sundeep
