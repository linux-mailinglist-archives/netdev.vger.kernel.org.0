Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19AFF28F1FE
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 14:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbgJOMXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 08:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727413AbgJOMXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 08:23:20 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C35C061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 05:23:19 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t12so3829365ilh.3
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 05:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8ECLzK1MShg+WzauW23GBytK0weD/HZl1fgYJKzg8JA=;
        b=D2XmQh4LfMHe4QWWsEdbCefTA8oTwCRE6+yxfIHYUETrJzJCekD29ze1O2N8G61Ltp
         6d4rQiQpSYyAn9NgtnXG2//7lBOf73/HGVNF7ALSRalCp5rXoGobYc1xnqey9fUMDX9Y
         6T88S7QfTsQfmubeFXziu6h3q/e6E5C2u+SkX4mqfJS+qyO4TbGfE1/fABh2i+/Bmbsn
         +K4czm8H26wFvqN5HYp5iPLeLivtgK/e7AwlghgA7xNbvpZgxkGUSWnpOWOPldrmhbjE
         3/GxpGxkz32ATv/rHUkpJnoU6uNbWFkKwGDfSyRGEYwNxffcxNtX0q6MwFWtDcU0BuiY
         lZAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8ECLzK1MShg+WzauW23GBytK0weD/HZl1fgYJKzg8JA=;
        b=RW3vmyF02zzjbfzWvO+0DhKQ67AehMeRTjI6hRYYC6RmzyGgSmaPF50LAXlLYXJPNg
         FZWFtja5X7tfkQeJzPzXD2TBG6iIHxT79Q967amoI4ltoGfJHVaHAWURQN4CIl7sPCZx
         QURCaZ7pPACRGaDrdDo7d7IeFlLIuxBSMCts2TidUmfycjFnZwBHC1SUffUS/E2D8rpT
         30nDQTybEdIwKbGdHvKqSAQEqzRzr69btKJdyNbdjtmkDuZVR4cAAdwT1Can+9nC4h2l
         d3q6ntoyOhNhNYFCp1gLJ/UoIfykGNQwPdmmkwG85Fq5gbL1Ffcg7Y7A7Gl/qTXuKuPt
         DnHw==
X-Gm-Message-State: AOAM531AxTdVNobgurmEGd9PZaphaOQVIUEhi6q2LHfUakS6EFS0SfAo
        wAodpe4B2/wSuIWPZBoZi9sAheKN2lpAwK27T02q9ov1M8IwXg==
X-Google-Smtp-Source: ABdhPJwbcTdGFZY1OyfD3amu18Z6PaEOhuQyRw1ulN8kf2I/5zGN7DAx3CQk1JG4o3orOlDneLaH/sn2OejmnFqhIxM=
X-Received: by 2002:a92:8e51:: with SMTP id k17mr2807573ilh.270.1602764598692;
 Thu, 15 Oct 2020 05:23:18 -0700 (PDT)
MIME-Version: 1.0
References: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
 <1602584792-22274-7-git-send-email-sundeep.lkml@gmail.com> <20201014194804.1e3b57ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201014194804.1e3b57ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Thu, 15 Oct 2020 17:53:07 +0530
Message-ID: <CALHRZupwJOZssMhE6Q_0VSCZ06WB2Sgo_BMpf2n=o7MALe+V6g@mail.gmail.com>
Subject: Re: [net-next PATCH 06/10] octeontx2-af: Add NIX1 interfaces to NPC
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        rsaladi2@marvell.com, Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Thu, Oct 15, 2020 at 8:18 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 13 Oct 2020 15:56:28 +0530 sundeep.lkml@gmail.com wrote:
> > -static const struct npc_mcam_kex npc_mkex_default = {
> > +static struct npc_mcam_kex npc_mkex_default = {
> >       .mkex_sign = MKEX_SIGN,
> >       .name = "default",
> >       .kpu_version = NPC_KPU_PROFILE_VER,
>
> Why is this no longer constant? Are you modifying global data based
> on the HW discovered in the system?

Yes. Due to an errata present on earlier silicons
npc_mkex_default.keyx_cfg[NIX_INTF_TX]
and npc_mkex_default.keyx_cfg[NIX_INTF_RX] needs to be identical.

Thanks,
Sundeep
