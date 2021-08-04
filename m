Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC59D3E01E7
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238369AbhHDN1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238126AbhHDN1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 09:27:05 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22A8C061799
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 06:26:42 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id 188so647304ioa.8
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 06:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dYdEg3FEjnNJNThyUvC517fEe1eHnKogxE9Vzfv1UIY=;
        b=pyuZLS/FOfE/HBGll+dPoZ1LtOgBykNvSiMNx5Kqhp/Ypy+svNMfDD4IVaPagLGLoM
         L4MXI00DzGsGUTi/nnu23RMlKv8X7QhmSMuEJd9dTbLVyLWHuMGhbM4Qhm/aMxyeeUOq
         nUmTi63s/xOtwLZZN465P50BtDaubNZgKKGjf4wPW0E2x5c5OQrJ+TXEIMxeYWw+cKny
         idm9y51ARmYxC58XFBZOk1Km6GxfVy02QHpI3wWp+eLFOrvciJzlQEHsYDWGqXQ306SC
         3aD++ejy5rJMQyjyg1daDJhKE0rJYoa5ZDskmj+BuZ2HLfzTcE58/6fW+mRVS0Vw7YV7
         kPHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dYdEg3FEjnNJNThyUvC517fEe1eHnKogxE9Vzfv1UIY=;
        b=sq3cFPtz9V1+YI0GCIkC1yB8iApHuZcce6sHqqAABl7uPesEkpFm4dIy41PHHBUVa2
         T9NQ3UaaBHPBCE89CKfxbpml4UeDyRCTu6OaKihDOAG0S7plwdy0YOZ37V6CJLx3yRwL
         U5RrSvkzfRSx7T6tBNbjMc3P5LDr0jXSzPFeM0Y3MXPEoEqWwTMyOwni46eqS2p8mbc/
         lgNJH1sXs+rONoWLcFK740nE5Z9fQHeWXwzEcJ5pbOXU+DyFniDU7pg/m8RWfuWE8yIf
         GqBaAbZYffB5G6JnKwGwErrZioI+nOr1xEt9U8Vb/mpuZVAxUdSHzqBmwuDqiQHBIuqN
         AFsw==
X-Gm-Message-State: AOAM532CsqwAqbjBOYzrHEwU+RqYRZX6SA6FD6aA4nDXMi4pGtW80Mbd
        CZ3+HhbSCFZJu/CxTlpW4eYJxRhaqqk42HXnxKQ=
X-Google-Smtp-Source: ABdhPJwHCkpNkLRfonCftH7xrpR5xKYOfBuU7tCEvKhzz4cL8l/tVlCLekEnJrlwYG79KY2VRUDXt2bCOoRTN5pbiAM=
X-Received: by 2002:a6b:e602:: with SMTP id g2mr286609ioh.50.1628083602175;
 Wed, 04 Aug 2021 06:26:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210722110325.371-1-borisp@nvidia.com> <20210722110325.371-5-borisp@nvidia.com>
 <20210723060631.GA32369@lst.de>
In-Reply-To: <20210723060631.GA32369@lst.de>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Wed, 4 Aug 2021 16:26:31 +0300
Message-ID: <CAJ3xEMjFOPFfU4ibFJPYdYUSh0nFkRwfW1cdAV2BMvg1aaP_eg@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 04/36] net/tls: expose get_netdev_for_sock
To:     Christoph Hellwig <hch@lst.de>, Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>, axboe@fb.com,
        Keith Busch <kbusch@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Shai Malin <smalin@marvell.com>, boris.pismenny@gmail.com,
        linux-nvme@lists.infradead.org,
        Linux Netdev List <netdev@vger.kernel.org>,
        benishay@nvidia.com, Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>, David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 9:09 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Thu, Jul 22, 2021 at 02:02:53PM +0300, Boris Pismenny wrote:
> > From: Boris Pismenny <borisp@mellanox.com>
> >
> > get_netdev_for_sock is a utility that is used to obtain
> > the net_device structure from a connected socket.
> >
> > Later patches will use this for nvme-tcp DDP and DDP DDGST offloads.
> >
> > Signed-off-by: Boris Pismenny <borisp@mellanox.com>
> > Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
>
> I don't think this should be an inline.  Please move it to net/core/dev.c,
> andd add an EXPORT_SYMBOL_GPL and a kerneldoc comment.

Jakub,

What's your preference here?

Or.
