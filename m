Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D4D2AA673
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 16:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgKGPvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 10:51:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728249AbgKGPvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 10:51:40 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55ED9C0613CF;
        Sat,  7 Nov 2020 07:51:40 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id p8so3554985wrx.5;
        Sat, 07 Nov 2020 07:51:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KvBK0Zih16mzK4AobUs15REc+5m4WlziRv40UJSaSqc=;
        b=jb7cDXs2s5w2Iw6t5+UPxDrjvnN+NcIx1ZwZ4M9mA66j6ojaZUjyW77hxK+QuvNIbe
         e9ZaAbuSjo+w0ueN4wMzp78akO9zTcn5PC6NAG28eoAgecxNgCcX/d1vNOmYq4Ypsb8K
         Z28GoRjMf++mfQk156npgP+GBVIjeuWpp0beo1cTm6jQy3ZPd4y20wMy1Deuv95jslkO
         zLb/04zut9GVGe638OCefbF59685w8Yx0C9Q0KEweidGfenga8gRXVdwVUMpjjp9wO+B
         NDq1q8DCRVWYPa3IGEYc7hKb07RYWiRwT9fRHx01/3M1muiXIeEGbZ+db6i6Nv+JM67h
         GSZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KvBK0Zih16mzK4AobUs15REc+5m4WlziRv40UJSaSqc=;
        b=XxQX9K6QXAUu0ZqnqQVDDU7nLlQ7QQOsVSBd/TlUiUi5JUV5a9v+dkSZI59ZsQcSU6
         /6iSklfAanvLhad74Fq8Lwc8PRIi4n0zpJeudzuXr8Wh041+yDQRaGYTZqofwhAGTUix
         pc+O7qH8Uax72mjVmBeKPq4fSQE+qq9qrx8KF798cH3gH2G4k9EQoN2pSki9raaqPoLF
         i5KOJN1FAkwE3pzJMWaGcuG3sPXKBd3hC0a1JQ2Ko9x/mZtgF3d4l/T2tXRNhJ/53ExC
         UTIad2jUfXuSeipQIZmWT8PW69RUYulfvUdeKoJcIoyg3bhbPT/MzTJIweRL4xh8bwFp
         CJzw==
X-Gm-Message-State: AOAM530tFGlsU/6T7HLEPDdxNxQXg+hEgB2Xg8KbPEHa8lZwxEKn5ls/
        5WBqLl49sP1g5bbRwZ+GHNgdxAGx8NJysDByKDk=
X-Google-Smtp-Source: ABdhPJw3oGchHEjsKfjoCEmXFBQcUYMBVCnDjOEJDu7WrN/Nmdz63+4ebVijbOssXyjtE6+hdOfExVa2DkBsiIYuJSY=
X-Received: by 2002:adf:e44f:: with SMTP id t15mr6909603wrm.380.1604764299020;
 Sat, 07 Nov 2020 07:51:39 -0800 (PST)
MIME-Version: 1.0
References: <BYAPR18MB2679EC3507BD90B93B37A3F8C5EE0@BYAPR18MB2679.namprd18.prod.outlook.com>
 <1dd085b9f7013e9a28057f3080ee7b920bfbc9fc.camel@kernel.org>
 <CA+sq2Cc9-vvF8K_FASca5FGYyFc_53QWqyEtoHAx6xVCs41LiQ@mail.gmail.com> <f1266f7f732d5222b69b8c29ec1d8071f9f16b25.camel@kernel.org>
In-Reply-To: <f1266f7f732d5222b69b8c29ec1d8071f9f16b25.camel@kernel.org>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Sat, 7 Nov 2020 21:21:27 +0530
Message-ID: <CA+sq2CfBMqgt+yzbx41d7BJyQJfnGWP6VtgQzRABuAFum+nB2w@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 3/3] octeontx2-af: Add devlink health
 reporters for NIX
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     George Cherian <gcherian@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 7, 2020 at 2:28 AM Saeed Mahameed <saeed@kernel.org> wrote:
>
> On Fri, 2020-11-06 at 00:59 +0530, Sunil Kovvuri wrote:
> > > > > > Output:
> > > > > >  # ./devlink health
> > > > > >  pci/0002:01:00.0:
> > > > > >    reporter npa
> > > > > >      state healthy error 0 recover 0
> > > > > >    reporter nix
> > > > > >      state healthy error 0 recover 0
> > > > > >  # ./devlink  health dump show pci/0002:01:00.0 reporter nix
> > > > > >   NIX_AF_GENERAL:
> > > > > >          Memory Fault on NIX_AQ_INST_S read: 0
> > > > > >          Memory Fault on NIX_AQ_RES_S write: 0
> > > > > >          AQ Doorbell error: 0
> > > > > >          Rx on unmapped PF_FUNC: 0
> > > > > >          Rx multicast replication error: 0
> > > > > >          Memory fault on NIX_RX_MCE_S read: 0
> > > > > >          Memory fault on multicast WQE read: 0
> > > > > >          Memory fault on mirror WQE read: 0
> > > > > >          Memory fault on mirror pkt write: 0
> > > > > >          Memory fault on multicast pkt write: 0
> > > > > >    NIX_AF_RAS:
> > > > > >          Poisoned data on NIX_AQ_INST_S read: 0
> > > > > >          Poisoned data on NIX_AQ_RES_S write: 0
> > > > > >          Poisoned data on HW context read: 0
> > > > > >          Poisoned data on packet read from mirror buffer: 0
> > > > > >          Poisoned data on packet read from mcast buffer: 0
> > > > > >          Poisoned data on WQE read from mirror buffer: 0
> > > > > >          Poisoned data on WQE read from multicast buffer: 0
> > > > > >          Poisoned data on NIX_RX_MCE_S read: 0
> > > > > >    NIX_AF_RVU:
> > > > > >          Unmap Slot Error: 0
> > > > > >
> > > > >
> > > > > Now i am a little bit skeptic here, devlink health reporter
> > > > > infrastructure was
> > > > > never meant to deal with dump op only, the main purpose is to
> > > > > diagnose/dump and recover.
> > > > >
> > > > > especially in your use case where you only report counters, i
> > > > > don't
> > > > > believe
> > > > > devlink health dump is a proper interface for this.
> > > > These are not counters. These are error interrupts raised by HW
> > > > blocks.
> > > > The count is provided to understand on how frequently the errors
> > > > are
> > > > seen.
> > > > Error recovery for some of the blocks happen internally. That is
> > > > the
> > > > reason,
> > > > Currently only dump op is added.
> > >
> > > So you are counting these events in driver, sounds like a counter
> > > to
> > > me, i really think this shouldn't belong to devlink, unless you
> > > really
> > > utilize devlink health ops for actual reporting and recovery.
> > >
> > > what's wrong with just dumping these counters to ethtool ?
> >
> > This driver is a administrative driver which handles all the
> > resources
> > in the system and doesn't do any IO.
> > NIX and NPA are key co-processor blocks which this driver handles.
> > With NIX and NPA, there are pieces
> > which gets attached to a PCI device to make it a networking device.
> > We
> > have netdev drivers registered to this
> > networking device. Some more information about the drivers is
> > available at
> > https://www.kernel.org/doc/html/latest/networking/device_drivers/ethernet/marvell/octeontx2.html
> >
> > So we don't have a netdev here to report these co-processor block
> > level errors over ethtool.
> >
>
> but AF driver can't be standalone to operate your hw, it must have a
> PF/VF with netdev interface to do io, so even if your model is modular,
> a common user of this driver will always see a netdev.
>

That's right, user will always see a netdev, but
The co-processor blocks are like this
- Each co-processor has two parts, AF unit and LF units (local function)
- Each of the co-processor can have multiple LFs, incase of NIX
co-processor, each of the LF provides RQ, SQ, CQs etc.
- So the AF driver handles the co-processor's AF unit and upon
receiving requests from PF/VF attaches the LFs to them, so that they
can do network IO.
- Within co-processor, AF unit specific errors (global) are reported
to AF driver and LF specific errors are reported to netdev driver.
- There can be 10s of netdev driver instances in the system, so these
AF unit global errors cannot be routed and shown in one of the
netdev's ethtool.

Thanks,
Sunil.
