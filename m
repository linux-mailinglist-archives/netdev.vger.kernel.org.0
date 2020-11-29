Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DEB2C7B08
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 20:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgK2TtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 14:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728293AbgK2TtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 14:49:17 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBAFC0613D2
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 11:48:37 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id n14so4891608iom.10
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 11:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=newoldbits-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FPVmvGLETfFsJB2bxLaRoGgeBKaIWmMhRnqAH6ezMAc=;
        b=H+T+i92IFdlJiKZBjnc4EM0zlsqe8bUe9HBv0tElLLwVg/TixUCrOCqiZGPHy/f8Qa
         ur7FJ8LqAtNkxNvmoim6tc3RQrODIIorOEHs7Md9TRWDwgz76dMq32nQ84ShOMpVxwl+
         +qbe9zwLzZdhsa66wd+Ec2CmMdFzgFvgD1CRk2ZUEwVvVrqdiJG2KIAw+DdPRmqoGE7N
         240BGnIQB3yi2yqgHXjSA2lZ0tIl2MRx4h04IWVMRBSu7DFKKGc/mGp6FtS28012hAzq
         R0KV14l+CjJeY+YO8bHo4AGtPlK4dxVlMrk4zE8VPO025rOjPZZfgt2Q32swi/4w1mAj
         O60Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FPVmvGLETfFsJB2bxLaRoGgeBKaIWmMhRnqAH6ezMAc=;
        b=nL7TunOhp1EvRXIc4UT7rEXjBrmKxbZPD8qGvIQSvjYtWDMVdxSDdQ2xjDyv4YQ2PT
         w5v2pSsLOVXNk+7B+IZ3ovT+gBAc/BzUvgo+A98ncdtkwQHWt0nQ76eV2aIn+Fvuzhx2
         9grXnvSWmdWap4jb2rEZlmZv1OlzBNrO4cKqB2SMl20Zyjc+WudieU6CqhiaIRIeRcQK
         lC04tSGa0gD9BYb3H3mP6ri2ib3dqMKihVcIX/zb+NbaONG8G1OW/CfpkW41zy9UqsI7
         F9S8wKXE4I7F6pkfWUoOvAIQBxs5THvLwilSYdPTdlxH/xw0FbSdDzicqeVzEy7ixZC5
         72Vw==
X-Gm-Message-State: AOAM531efyfnyrMO90XEBtuFN4GKM56InXDc7GHIj1kBz6Jktp1E2czv
        wUCeJfP0jVGuVhNa3Qoc3/zuzsQ0CxecTZ/FuQB4+Q==
X-Google-Smtp-Source: ABdhPJwI0NK/RFeSd2j+i/hflp834uzdZeBqDSHIW4OBRgMwCQW8k+riyNfPCLUY0BIaZdnasBWX60am7kA/gyeblXo=
X-Received: by 2002:a5d:9042:: with SMTP id v2mr12402234ioq.98.1606679316572;
 Sun, 29 Nov 2020 11:48:36 -0800 (PST)
MIME-Version: 1.0
References: <20201129102400.157786-1-jean.pihet@newoldbits.com>
 <20201129165627.GA2234159@lunn.ch> <CAORVsuUez9qteuuqkGpQbU5yXjAFxcpRXGaXnKwqm-hKSKF6NQ@mail.gmail.com>
 <20201129193822.GP2234159@lunn.ch>
In-Reply-To: <20201129193822.GP2234159@lunn.ch>
From:   Jean Pihet <jean.pihet@newoldbits.com>
Date:   Sun, 29 Nov 2020 20:48:25 +0100
Message-ID: <CAORVsuWKtdF8O9vXonamWEr0WcdoZiaeFhjP06Z8NV_wv3A=KQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: dsa: ksz: pad frame to 64 bytes for transmission
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Ryan Barnett <ryan.barnett@rockwellcollins.com>,
        Conrad Ratschan <conrad.ratschan@rockwellcollins.com>,
        Hugo Cornelis <hugo.cornelis@essensium.com>,
        Arnout Vandecappelle <arnout.vandecappelle@essensium.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew,

On Sun, Nov 29, 2020 at 8:38 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sun, Nov 29, 2020 at 08:34:27PM +0100, Jean Pihet wrote:
> > Hi Andrew,
> >
> > On Sun, Nov 29, 2020 at 5:56 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > On Sun, Nov 29, 2020 at 11:23:59AM +0100, Jean Pihet wrote:
> > > > Some ethernet controllers (e.g. TI CPSW) pad the frames to a minimum
> > > > of 64 bytes before the FCS is appended. This causes an issue with the
> > > > KSZ tail tag which could not be the last byte before the FCS.
> > > > Solve this by padding the frame to 64 bytes minus the tail tag size,
> > > > before the tail tag is added and the frame is passed for transmission.
> > >
> > > Hi Jean
> > >
> > > what tree is this based on? Have you seen
> > The patches are based on the latest mainline v5.10-rc5. Is this the
> > recommended version to submit new patches?
>
> No, that is old. Please take a read of:
>
> https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html

Ok got it, thx!

Found the commit 88fda8ee and its parent [1] with the following
comment, which seems to indicate that my patch is not needed anymore.
Can you confirm?

/* For tail taggers, we need to pad short frames ourselves, to ensure
+ * that the tail tag does not fail at its role of being at the end of
+ * the packet, once the master interface pads the frame. Account for
+ * that pad length here, and pad later.
...

[1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=a3b0b6479700a5b0af2c631cb2ec0fb7a0d978f2

Thx,
Jean

>
>         Andrew
