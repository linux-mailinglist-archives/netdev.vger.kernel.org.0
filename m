Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B4C206B59
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 06:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388555AbgFXEoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 00:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgFXEoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 00:44:18 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C266C061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 21:44:18 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id i27so1042333ljb.12
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 21:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZLQ7017My3pP7AduzUI0V4aLKmwYBZCjaH2TFcP0/Vk=;
        b=XlcdY/hGfTUwIS0J/6xnd303Y7M/13BXjycceY0Nv9IyhgS1IJofZ5gYrqDfulDzOP
         ZRTTqSaZmjJwBL/RCRFUwwYl5IKBD3RM63x8d5DeWu7vCK92jzyiRG1YHHbCLClPPi5i
         mmKfxrnHv/zAhKH6XgQuZ6vXQQn6KtTKK5bSo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZLQ7017My3pP7AduzUI0V4aLKmwYBZCjaH2TFcP0/Vk=;
        b=PJy8pfXA3Jobh11tcH475ROymueFFecryhLpNNd5dSaDtoLYX3t6nFRKB0ZmlpLOnP
         izRWh/ZwHsvsZV+AwFymld8YTzD0Wct3eA4koirEj/lxsESc7prDtPXLhvMIMIPVAZ8L
         gcB8+ymXUNkw7bMcpXZsuLWNSOBj1zMugzQzjb63W21XtBQgTu7OZYUDSoOFLD2deqgn
         wFhOJYvpkNFdNn/NrZiQ1W2bf7LBe1WAZULbP+M9noADWr0fLorC+962DwgBD/nNLbnV
         bKmsn5XWR6XosOLQhU7F/+xyrhKpTr01LkmpzrFynhrBG5eFycr/LNN0jxtS5bzDoJZI
         8OZg==
X-Gm-Message-State: AOAM530Ps9PR+vQ39q9YS3YNve/IgmybfFF5mkU8aFhzjrZHBXXAAQk6
        B10UIIx9JQY3ikZgN1x+gDO2C9t1ne7QCmiIQCgDl1ORWNm4hw==
X-Google-Smtp-Source: ABdhPJyiPaSVdm5FqJbRnQ145Qe4X6Yfj8NpfywApYUsNmrUysH8xtwikFLYCYrdmKDGLBDKlqe0oiplPeyHPbnMzxo=
X-Received: by 2002:a2e:b6cd:: with SMTP id m13mr13416082ljo.391.1592973856449;
 Tue, 23 Jun 2020 21:44:16 -0700 (PDT)
MIME-Version: 1.0
References: <1592911969-10611-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200623205607.zgbkgczf64neea7h@lion.mk-sys.cz>
In-Reply-To: <20200623205607.zgbkgczf64neea7h@lion.mk-sys.cz>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Wed, 24 Jun 2020 10:14:05 +0530
Message-ID: <CAACQVJrY+VxAR_z-EHGjWxAGbpK2PJkWeMrsaSQGPVh4-gco9g@mail.gmail.com>
Subject: Re: [RFC net-next] devlink: Add reset subcommand.
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 2:26 AM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Tue, Jun 23, 2020 at 05:02:49PM +0530, Vasundhara Volam wrote:
> > Advanced NICs support live reset of some of the hardware
> > components, that resets the device immediately with all the
> > host drivers loaded.
> >
> > Add devlink reset subcommand to support live and deferred modes
> > of reset. It allows to reset the hardware components of the
> > entire device and supports the following fields:
> >
> > component:
> > ----------
> > 1. MGMT : Management processor.
> > 2. IRA : Interrupt requester.
> > 3. DMA : DMA engine.
> > 4. FILTER : Filtering/flow direction.
> > 5. OFFLOAD : Protocol offload.
> > 6. MAC : Media access controller.
> > 7. PHY : Transceiver/PHY.
> > 8. RAM : RAM shared between multiple components.
> > 9. ROCE : RoCE management processor.
> > 10. AP : Application processor.
> > 11. All : All possible components.
> >
> > Drivers are allowed to reset only a subset of requested components.
> >
> > width:
> > ------
> > 1. single - Single function.
> > 2. multi  - Multiple functions.
> >
> > mode:
> > -----
> > 1. deferred - Reset will happen after unloading all the host drivers
> >               on the device. This is be default reset type, if user
> >               does not specify the type.
> > 2. live - Reset will happen immediately with all host drivers loaded
> >           in real time. If the live reset is not supported, driver
> >           will return the error.
> >
> > This patch is a proposal in continuation to discussion to the
> > following thread:
> >
> > "[PATCH v3 net-next 0/6] bnxt_en: Add 'enable_live_dev_reset' and 'allow_live_dev_reset' generic devlink params."
> >
> > and here is the URL to the patch series:
> >
> > https://patchwork.ozlabs.org/project/netdev/list/?series=180426&state=*
> >
> > If the proposal looks good, I will re-send the whole patchset
> > including devlink changes and driver usage.
> >
> > Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> > Reviewed-by: Michael Chan <michael.chan@broadcom.com>
>
> IIUC this is an extension (or rather replacement) of the ETHTOOL_RESET
> ethtool subcommand. If this is the case, it would be probably better to
> implement the driver backend only once and let ethtool_reset() use the
> devlink handlers (future versions of ethtool utility could then use
> devlink interface directly).
Yes.
>
> For this purpose, I would suggest to switch the flags for AP and ROCE in
> enum devlink_reset_component:
Sure, I will do it. Thank you.

Thanks,
Vasundhara
>
> > +enum devlink_reset_component {
> > +     DEVLINK_RESET_COMP_MGMT         = (1 << 0),
> > +     DEVLINK_RESET_COMP_IRQ          = (1 << 1),
> > +     DEVLINK_RESET_COMP_DMA          = (1 << 2),
> > +     DEVLINK_RESET_COMP_FILTER       = (1 << 3),
> > +     DEVLINK_RESET_COMP_OFFLOAD      = (1 << 4),
> > +     DEVLINK_RESET_COMP_MAC          = (1 << 5),
> > +     DEVLINK_RESET_COMP_PHY          = (1 << 6),
> > +     DEVLINK_RESET_COMP_RAM          = (1 << 7),
> > +     DEVLINK_RESET_COMP_ROCE         = (1 << 8),
> > +     DEVLINK_RESET_COMP_AP           = (1 << 9),
> > +     DEVLINK_RESET_COMP_ALL          = 0xffffffff,
> > +};
>
> to make the flags match corresponding ETH_RESET_* flags.
>
> Michal
