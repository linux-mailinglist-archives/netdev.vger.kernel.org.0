Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A42E1C69D9
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 09:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgEFHNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 03:13:22 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55939 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726897AbgEFHNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 03:13:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588749199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DoCIDqCuiWoGHXnE50qM2xoXLIrmM3bQHiMLGkhcZ2o=;
        b=gaObHQlp+TeYSWG9Yo9PaG+1S3G8EUAs1p8ngUtKGsSw8o8lEWnWY0gDZz7xeigs+gXARB
        KQao+Sakwd5BLnd5+UJVCy8siQFGl5ZQYdhix8VBMd62z2qzCnQrOpEpIJCyBmKhV788cU
        wgNRnNOpujOLsG7/znKE3mce603Ae8A=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-HLJ_FwG_MvGdDEAznHPOQw-1; Wed, 06 May 2020 03:13:18 -0400
X-MC-Unique: HLJ_FwG_MvGdDEAznHPOQw-1
Received: by mail-qt1-f197.google.com with SMTP id v18so1285956qtq.22
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 00:13:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DoCIDqCuiWoGHXnE50qM2xoXLIrmM3bQHiMLGkhcZ2o=;
        b=e//WigWT3jDschi/CFAfuDpOQEH89yky9Tax2ELbHzfRToC5+ET8XX+8ZlCMpYsllW
         8ZyvBfnn1OO7XMD3WrN37L6pMTpNFXe02dN9auOlnOeS632WaoBhujKvL9Q+sS/ggC0d
         dwhC7/qEe9/VOpw8YEVNsr1JecCHrQGwMJnmEbeQd0a5JaTM5fcO0MhNDTSk7PMNn6IL
         0sJIgPDR5MwTLNBl64dfHqkLemgX0jvgmED8WqHv2sMobs4vUBXtVtYCd4SWNK9n153a
         iLjbsqlJlrO4o77523/0iL1znBlcz2sLjyIhAgqatpR3TEv+fpw343ZtUXaUUE35Qh9e
         XRjg==
X-Gm-Message-State: AGi0PuZEilK8ssbMYPVwz/x/Cx7TovpHj3wzbHTiYr42YtLnKFYB0S0x
        Z7AFApC2xA+5jJDYxtcShp6NM9CB/tBTd5eFV0xZ1Aup5OCFY/5DEWTTp2xzgMkpzUiJi5YnH8F
        l99OZlzZEGJYNe9oR+ECuag6VDcDQYOjl
X-Received: by 2002:a05:6214:1242:: with SMTP id q2mr6503367qvv.198.1588749196491;
        Wed, 06 May 2020 00:13:16 -0700 (PDT)
X-Google-Smtp-Source: APiQypKEbWxJJMg9xFDO1XjXY3rIXhjPS6TWqbI6djgDFo8c2hH5M4mqWN3Uc5hKHaslYKwpo74PZ0fFlIxHP58AJlA=
X-Received: by 2002:a05:6214:1242:: with SMTP id q2mr6503348qvv.198.1588749196212;
 Wed, 06 May 2020 00:13:16 -0700 (PDT)
MIME-Version: 1.0
References: <1588705481-18385-1-git-send-email-bhsharma@redhat.com>
 <1588705481-18385-2-git-send-email-bhsharma@redhat.com> <5ddc169b-f837-e478-43d9-4d6cf587aa05@marvell.com>
In-Reply-To: <5ddc169b-f837-e478-43d9-4d6cf587aa05@marvell.com>
From:   Bhupesh Sharma <bhsharma@redhat.com>
Date:   Wed, 6 May 2020 12:43:03 +0530
Message-ID: <CACi5LpNCHipB-bU52JcWBj6bPhW5ZqfG+J7QPq-m5-xf2mqdSQ@mail.gmail.com>
Subject: Re: [EXT] [PATCH 1/2] net: qed*: Reduce RX and TX default ring count
 when running inside kdump kernel
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org, Bhupesh SHARMA <bhupesh.linux@gmail.com>,
        kexec mailing list <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alok Prasad <palok@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Igor,

On Wed, May 6, 2020 at 12:21 PM Igor Russkikh <irusskikh@marvell.com> wrote:
>
>
>
> >  #include <linux/compiler.h>
> > +#include <linux/crash_dump.h>
> >  #include <linux/version.h>
> >  #include <linux/workqueue.h>
> >  #include <linux/netdevice.h>
> > @@ -574,13 +575,13 @@ int qede_add_tc_flower_fltr(struct qede_dev *edev,
> > __be16 proto,
> >  #define RX_RING_SIZE         ((u16)BIT(RX_RING_SIZE_POW))
> >  #define NUM_RX_BDS_MAX               (RX_RING_SIZE - 1)
> >  #define NUM_RX_BDS_MIN               128
> > -#define NUM_RX_BDS_DEF               ((u16)BIT(10) - 1)
> > +#define NUM_RX_BDS_DEF               ((is_kdump_kernel()) ? ((u16)BIT(6) - 1) :
> > ((u16)BIT(10) - 1))
> >
> >  #define TX_RING_SIZE_POW     13
> >  #define TX_RING_SIZE         ((u16)BIT(TX_RING_SIZE_POW))
> >  #define NUM_TX_BDS_MAX               (TX_RING_SIZE - 1)
> >  #define NUM_TX_BDS_MIN               128
> > -#define NUM_TX_BDS_DEF               NUM_TX_BDS_MAX
> > +#define NUM_TX_BDS_DEF               ((is_kdump_kernel()) ? ((u16)BIT(6) - 1) :
> > NUM_TX_BDS_MAX)
> >
>
> Hi Bhupesh,
>
> Thanks for looking into this. We are also analyzing how to reduce qed* memory
> usage even more.
>
> Patch is good, but may I suggest not to introduce conditional logic into the
> defines but instead just add two new defines like NUM_[RT]X_BDS_MIN and check
> for is_kdump_kernel() in the code explicitly?
>
> if (is_kdump_kernel()) {
>         edev->q_num_rx_buffers = NUM_RX_BDS_MIN;
>         edev->q_num_tx_buffers = NUM_TX_BDS_MIN;
> } else {
>         edev->q_num_rx_buffers = NUM_RX_BDS_DEF;
>         edev->q_num_tx_buffers = NUM_TX_BDS_DEF;
> }
>
> This may make configuration logic more explicit. If future we may want adding
> more specific configs under this `if`.

Thanks for the review comments.
The suggestions seem fine to me. I will incorporate them in v2.

Regards,
Bhupesh

