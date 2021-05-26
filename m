Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A169392150
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 22:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbhEZUQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 16:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233236AbhEZUQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 16:16:56 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D4EC061574;
        Wed, 26 May 2021 13:15:21 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id e10so2235798ybb.7;
        Wed, 26 May 2021 13:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mEHTP+ON/HEaPzPmfXVTVliKoWahqgkl8b5vxeCCk4M=;
        b=pkwh6jKsINTyYUzU2MfiyXJBnj7XYRmKYA65MM7zFmMAh5SrQa0h7oDudd2TWzflB8
         t7y0WB3xicV+on0M5bwaTpokF//b9U4KtIZynEWJymm4EY5KiOrp/RQDDfEBnA35Cex8
         FCYXq9zlJN0Nmgv2UAsbtU/qgOV4LRMY7H1uy5dAu4je9DSgqQnESxR+88HMrU63JbXn
         jb0hD4HMplBgXQy1+vMcq8mvzqMqnuVPt5Al32cFFd7aMXUEMb9EW1x6tae3tnWI/0Ko
         l9Pi3U1EPbXPURYWq7LyuehbeeFH52fn3+WbRFVDXEKgr152Mv8NgP2PGOFdML+NhsKw
         AFOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mEHTP+ON/HEaPzPmfXVTVliKoWahqgkl8b5vxeCCk4M=;
        b=ERNyC74F5oqVh/832dtost3vbuAc+b9qiH8TqP1rs9QMpMgxmV3dLhlOLJuqCus2RW
         CA9oWXpO/TP6FApqOZ1qJzrXWLTlY4r4yWHTg+O3gi6sVWaLcVkft3LbPVdLyPAH6Ph3
         TocleTLrf1OJBwWfOLspWiLfjVnb6STY3EzpskXzC8RiZ7nRqTBnPBum7RfPUjhXPFak
         ZomdKXdgdhWOtYoVwSeG2rVqMoGeirUtAix/u/M5A6wl3rUiUjwa/3VG1bpIFaTu5MHq
         ES7wstKNw+mlppf8yyNWKwPNyJWC9W6RIX0qnOA4KxKJDVeAfPggsFod5Q1KtLvpkPcZ
         Nj3Q==
X-Gm-Message-State: AOAM53058XQEI9yyFf2xEJJY4K3Gj6NckrniCsKtSZm5SNcraL8zqTRc
        7iZz/PJIIBKJvTyZL9goVtt9VNZJkQHcStUO034=
X-Google-Smtp-Source: ABdhPJz95juvpvxx7Uty29KFbGtMC3IYrD7o7WhnZpW10UEMp9K5+v9oCqFSEJ873/eNMCPj5LYiAF33ydDfkAlMwHA=
X-Received: by 2002:a5b:3c2:: with SMTP id t2mr51207293ybp.39.1622060120595;
 Wed, 26 May 2021 13:15:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210525203314.14681-1-pgwipeout@gmail.com> <20210526122732.5e655b9a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210526122732.5e655b9a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Wed, 26 May 2021 16:15:08 -0400
Message-ID: <CAMdYzYqq0v2hPfmhwfS1MZE5D8x5S7CpeCPR_UDCOKepm6uu6g@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] fixes for yt8511 phy driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Nathan Chancellor <nathan@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 3:27 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 25 May 2021 16:33:12 -0400 Peter Geis wrote:
> > The Intel clang bot caught a few uninitialized variables in the new
> > Motorcomm driver. While investigating the issue, it was found that the
> > driver would have unintended effects when used in an unsupported mode.
> >
> > Fixed the uninitialized ret variable and abort loading the driver in
> > unsupported modes.
> >
> > Thank you to the Intel clang bot for catching these.
>
> Fixes tag need work, the hashes don't match the ones in net-next.

It seems when I asked git for the hash for that patch, it grabbed my
original patch which was against linux-next.
Apologies for the confusion.
