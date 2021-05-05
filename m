Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B213747C8
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 20:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235664AbhEESFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 14:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235959AbhEESEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 14:04:36 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606BFC04683D
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 10:56:27 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id j28so3054616edy.9
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 10:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dw5oszPW++Sy7Iq3KetI2v59gEspNAktX2qHuxKmvCo=;
        b=Gadf7t3S4l+R8WRsOdhZH/rOtmwnwOkDPTopPTDMOzow1DzdSHkw/OklZRo66USa0g
         s6UZ7ZNMIj/GEF/XpUxGhjOe08RVnq6M+sAwccYpNwYyM2EzhJstDbCQA6ouIIy2A/C9
         ZzWjkEUxh6TyOvyNBH/5R+3XLbpXIdG75bfXVW45QIDHE0boDH4LV1GG8kezuAc1jx6f
         k4PF9cvbEuc+YEZCyBmysIu6wjNNP3JgQV0XrVFNu70PRZBnFAOL9JvCNLsEtOolixi7
         a9siJt8HlD64scoNNdyHPyFT2y5L+Q7IXDxHk9x0CCicFQqU3wiU/Tk0cO7rvzFMFfZ3
         RUEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dw5oszPW++Sy7Iq3KetI2v59gEspNAktX2qHuxKmvCo=;
        b=nz9l566YBjWtDQA6nwUyVB/LPwBHWzbQJJ/hlc+1DgsfaVKc8CeryAmRzslfISGPvH
         +wuGZUHdJ96XeHyueaRq/MpPFK9c7XKdUHE4+EnEyn7g1Sd5qRg4o0Ww5rLsCn2eGeO0
         qPVJyuDDtfl8cMPau7w5PG4M07U4C6CJYQJppo8wBiDH1HXBI9i6DBwO71G4EMSOjnpQ
         cdaWkKeBRbyHQMehXSukgGAlqS4v4/UTB+7X4pQDGujDX+1hFq7IUYL/zvGfxsKOqtPZ
         Ax8NLfd42mUkgy00OZW8Klrz/jDRsguedq7fncVzyKcPNlkvfTPvZEq4HLIDYEPuSjzi
         liHA==
X-Gm-Message-State: AOAM532RAyYYJgpyEBXb2qQHCgQao3mN9ENU0yPl4dSCHz64A+69Z21I
        pyiApobe0wBlFTpAc5VEZdBBAR9bl8bocn+p+F4aXXq2c8U=
X-Google-Smtp-Source: ABdhPJxnvp0iQN6IR05j7JN2kdKcICuPGWt+Y2elC826cZbJYMbpeDHwdFzOUvfh2f/5X3m1/KUGU3do77nuL+C8fRM=
X-Received: by 2002:a05:6402:138f:: with SMTP id b15mr252945edv.121.1620237386105;
 Wed, 05 May 2021 10:56:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210429190926.5086-1-smalin@marvell.com> <20210429190926.5086-21-smalin@marvell.com>
 <95009c8e-330f-fd99-781c-cb2b80263ba2@suse.de>
In-Reply-To: <95009c8e-330f-fd99-781c-cb2b80263ba2@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Wed, 5 May 2021 20:56:15 +0300
Message-ID: <CAKKgK4yBC022_7hmiaQXkKWq1DS1tFJd8dYOVN5w9mRQVfGYVQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 20/27] qedn: Add connection-level slowpath functionality
To:     Hannes Reinecke <hare@suse.de>
Cc:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/21 2:37 PM, Hannes Reinecke wrote:
> On 4/29/21 9:09 PM, Shai Malin wrote:
> > From: Prabhakar Kushwaha <pkushwaha@marvell.com>
> >
> > This patch will present the connection (queue) level slowpath
> > implementation relevant for create_queue flow.
> >
> > The internal implementation:
> > - Add per controller slowpath workqeueue via pre_setup_ctrl
> >
> > - qedn_main.c:
> >    Includes qedn's implementation of the create_queue op.
> >
> > - qedn_conn.c will include main slowpath connection level functions,
> >    including:
> >      1. Per-queue resources allocation.
> >      2. Creating a new connection.
> >      3. Offloading the connection to the FW for TCP handshake.
> >      4. Destroy of a connection.
> >      5. Support of delete and free controller.
> >      6. TCP port management via qed_fetch_tcp_port, qed_return_tcp_port
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > ---
> >   drivers/nvme/hw/qedn/Makefile    |   5 +-
> >   drivers/nvme/hw/qedn/qedn.h      | 173 ++++++++++-
> >   drivers/nvme/hw/qedn/qedn_conn.c | 508 ++++++++++++++++++++++++++++++=
+
> >   drivers/nvme/hw/qedn/qedn_main.c | 208 ++++++++++++-
> >   4 files changed, 883 insertions(+), 11 deletions(-)
> >   create mode 100644 drivers/nvme/hw/qedn/qedn_conn.c
> >
>
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
