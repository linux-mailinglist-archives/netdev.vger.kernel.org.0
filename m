Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6103747D6
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 20:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbhEESHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 14:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbhEESGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 14:06:54 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC8CC06138C
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 11:05:05 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id m12so4284030eja.2
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 11:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IPnNIGO5yG2+vXM/Dm7U8VB8CqjyrrjDLSmppWbDvL0=;
        b=JIqG28cLDacqUlTQcu8RSb2pvMEcg12h3u2mSQyi9L4wJ9yibeOoJ+ZCe7S+m1W5Mm
         /0M6CRtzavAh62amnP4rPRndTbn2kx9Q9xBDMrQsGdTqCmXHy9JWOTeahbCnuN5HgJcF
         e2K+ysS/ih3hPHNfNHCMkn5DovNKmqs+tYxhcVQ0Ip1lPByZz1N5eKp+bkHQFXZrXBuj
         28kHXolOsRMcoe9zgCgN5LgXxZV/PLSCy49d52N4O4uQHGA6o85d7qhE9s5/e5sXU3Mb
         tPOAr8eAn1JTeXzfmm7uO7eQTCwqTeC3U1OTmHak4FqhbCvu4QI2EuOQ4gLvGrFXC1tw
         S6tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IPnNIGO5yG2+vXM/Dm7U8VB8CqjyrrjDLSmppWbDvL0=;
        b=J9L9z42U9VjoZKopdCvB4AUVb9XCvoJqeyxEBxT65YVqQBm2EJhbc3BYqykjGuoJcs
         Ye5o+OXcCVu3j/+gAB9IIfqaw9/6SCQ0TgWZRpVakqavJcV9mYMAZ9in40JC83yzqW3m
         XfL5my9JwkJYFpsiBKBDhkAH5r+pnVu3iFtJM4BPpcwzUn/iMFgessk/He93g+QTVOlu
         KodEElzJvTv045xg2tTNIoGR0/hB/ND36iYwbgOERIX9r0WQNzP1lOdLdYYnQVBANG8P
         goiYxk7v89p58fxnR4Sg8t7Lph6D0dfv34wJBIe+jjLHVOYB7BxZ8T8y6iYMfUPE/0XV
         D3mA==
X-Gm-Message-State: AOAM5317MwfRpzsfkjPDLtn858qE1LWnSJT1ETiN608R9+jN/eLuvSFo
        3Eunu8qNdtP2gCFz2CLxAIglLF1hQ3JJ9OcuqaY=
X-Google-Smtp-Source: ABdhPJz+vhTrS2PnGcJnIGdCf3sJB862raYjZSdtW8PMS5CE829QfAHhOfskgsRRy6oZI6Aup4k0y5zSQCOP2/pgGU0=
X-Received: by 2002:a17:906:90b:: with SMTP id i11mr40159ejd.168.1620237903965;
 Wed, 05 May 2021 11:05:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210429190926.5086-1-smalin@marvell.com> <20210429190926.5086-26-smalin@marvell.com>
 <92c994a9-004e-55b0-b345-6c555953bab0@suse.de>
In-Reply-To: <92c994a9-004e-55b0-b345-6c555953bab0@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Wed, 5 May 2021 21:04:52 +0300
Message-ID: <CAKKgK4yq7ZGiad+ToQ9YstosA+3NYb8tcMKQ+iRxtbdVnUOU0Q@mail.gmail.com>
Subject: Re: [RFC PATCH v4 25/27] qedn: Add IO level fastpath functionality
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

On 5/2/21 2:54 PM, Hannes Reinecke wrote:
> On 4/29/21 9:09 PM, Shai Malin wrote:
> > This patch will present the IO level functionality of qedn
> > nvme-tcp-offload host mode. The qedn_task_ctx structure is containing
> > various params and state of the current IO, and is mapped 1x1 to the
> > fw_task_ctx which is a HW and FW IO context.
> > A qedn_task is mapped directly to its parent connection.
> > For every new IO a qedn_task structure will be assigned and they will b=
e
> > linked for the entire IO's life span.
> >
> > The patch will include 2 flows:
> >    1. Send new command to the FW:
> >        The flow is: nvme_tcp_ofld_queue_rq() which invokes qedn_send_re=
q()
> >        which invokes qedn_queue_request() which will:
> >       - Assign fw_task_ctx.
> >        - Prepare the Read/Write SG buffer.
> >        -  Initialize the HW and FW context.
> >        - Pass the IO to the FW.
> >
> >    2. Process the IO completion:
> >       The flow is: qedn_irq_handler() which invokes qedn_fw_cq_fp_handl=
er()
> >        which invokes qedn_io_work_cq() which will:
> >        - process the FW completion.
> >        - Return the fw_task_ctx to the task pool.
> >        - complete the nvme req.
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > ---
> >   drivers/nvme/hw/qedn/qedn.h      |   4 +
> >   drivers/nvme/hw/qedn/qedn_conn.c |   1 +
> >   drivers/nvme/hw/qedn/qedn_task.c | 269 ++++++++++++++++++++++++++++++=
-
> >   3 files changed, 272 insertions(+), 2 deletions(-)
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
