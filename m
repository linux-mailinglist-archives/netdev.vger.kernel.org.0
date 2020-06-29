Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA5B20D8E9
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388004AbgF2Tmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387976AbgF2Tmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:42:43 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C262DC02F025
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 07:57:14 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id t25so13795250lji.12
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 07:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ke6z+ezZUAbIeFOGCZ2yWWQxshBl6sFvu9VvMiwWBUI=;
        b=Zp2FqH29DSB4J/8cNA+rWGGrpSiaJAR14kvUwDaemale4CQKsrUnFMmn7xuteL+kbO
         jho3Z2IF9nsibRzocUfkiKS+AT49YXiFxmY2MntY8MGEQd4cSWJgm4OrF8w755ARhleF
         8O3e2zNfxqfp0ra4pUn5E+euWGm08zy0vJKxA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ke6z+ezZUAbIeFOGCZ2yWWQxshBl6sFvu9VvMiwWBUI=;
        b=lbZa2P1fpirKNNgC0e2LQjDA0v3ko+P6Ghsm7zqlB2If6XmOz49Lcw9N/bR1pKp+rJ
         wQCzf5nS5HTzOt8H7BOd3hXnLt58Yyc/N1HVLuu5s+Lz6GyCMy6ANW8KkQB2ah68CASc
         xsNuDEVQU8PrFmDZvQC66xCGGBXOcgFs5jJF7ZKK6vJRkh7m8Z5ZNGUvx685SHIWpwMT
         tD9Za33QQEjkRP1ayNbC84lZX5twLr/lpKCUmgnzpOOufKWC/Q9zNC0fPkQdAWYcwRel
         0HzE2KqYR/ySaD/ZISjCiSLkANSnmX9dkAT2p5GcXxpBfbQ0g1mWPGHSVtn9nkK+m7hx
         E04g==
X-Gm-Message-State: AOAM533FWRzDE8aEaF5iRiM/4mpGTRkjWhKw/MwJAMRtZNRsVpga5lKX
        v6ejSWE0cXxQi/jC3WI8nui3yS0x3Bh7T/xgGbiANQ==
X-Google-Smtp-Source: ABdhPJysb3M7CIw8FNGUGmkevwIgkeXdxio3cNWiWF7lKs8cXhiJHcmn6ClF23rrWtEYSRFaCvvATypmbgBeEU/0/Ns=
X-Received: by 2002:a2e:9bc4:: with SMTP id w4mr6199346ljj.391.1593442633088;
 Mon, 29 Jun 2020 07:57:13 -0700 (PDT)
MIME-Version: 1.0
References: <1592911969-10611-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200629135134.GA2227@nanopsycho.orion>
In-Reply-To: <20200629135134.GA2227@nanopsycho.orion>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Mon, 29 Jun 2020 20:27:01 +0530
Message-ID: <CAACQVJpezjQTojJMYgzyXUi312Ua8zmMKJJvZfTPO70j01T2AQ@mail.gmail.com>
Subject: Re: [RFC net-next] devlink: Add reset subcommand.
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>, ayal@mellanox.com,
        parav@mellanox.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 7:21 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Tue, Jun 23, 2020 at 01:32:49PM CEST, vasundhara-v.volam@broadcom.com wrote:
> >Advanced NICs support live reset of some of the hardware
> >components, that resets the device immediately with all the
> >host drivers loaded.
> >
> >Add devlink reset subcommand to support live and deferred modes
> >of reset. It allows to reset the hardware components of the
> >entire device and supports the following fields:
> >
> >component:
> >----------
> >1. MGMT : Management processor.
> >2. IRA : Interrupt requester.
> >3. DMA : DMA engine.
> >4. FILTER : Filtering/flow direction.
> >5. OFFLOAD : Protocol offload.
> >6. MAC : Media access controller.
> >7. PHY : Transceiver/PHY.
>
> Hmm. I think that you are mixing things which are per-ASIC and per-port.
> It is confusing.
Thank you for reviewing the patch.

Initially I plan to add only MGMT, ROCE, AP and ALL. But for
completeness I carried ethtool reset types. You are right, some
components are per-port. I will remove from FILTER to PHY components.
Thank you.
>
> Why do you need this kind of reset granularity? I mean, if something
> goes wrong in fw/hw, the health reporter should report it and recover
> it. This looks like you try to add another interface for the same set of
> problem...
No, this interface is purely for per-ASIC component reset and user initiated..
>
>
> >8. RAM : RAM shared between multiple components.
> >9. ROCE : RoCE management processor.
> >10. AP : Application processor.
> >11. All : All possible components.
> >
> >Drivers are allowed to reset only a subset of requested components.
> >
> >width:
> >------
> >1. single - Single function.
> >2. multi  - Multiple functions.
Also, I just realised that instead of single host and multi hosts, I
mentioned single function and multiple functions. I will fix it in the
next version.

Thanks,
Vasundhara
> >
> >mode:
> >-----
> >1. deferred - Reset will happen after unloading all the host drivers
> >              on the device. This is be default reset type, if user
> >              does not specify the type.
> >2. live - Reset will happen immediately with all host drivers loaded
> >          in real time. If the live reset is not supported, driver
> >          will return the error.
> >
> >This patch is a proposal in continuation to discussion to the
> >following thread:
> >
> >"[PATCH v3 net-next 0/6] bnxt_en: Add 'enable_live_dev_reset' and 'allow_live_dev_reset' generic devlink params."
> >
> >and here is the URL to the patch series:
> >
> >https://patchwork.ozlabs.org/project/netdev/list/?series=180426&state=*
> >
> >If the proposal looks good, I will re-send the whole patchset
> >including devlink changes and driver usage.
> >
>
> [...]
