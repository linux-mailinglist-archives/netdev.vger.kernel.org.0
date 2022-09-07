Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB52C5B087F
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiIGPYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbiIGPY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:24:27 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6F7B943C
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:24:14 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 65so4743312pfx.0
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 08:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=6GKfy2itTLAb/HX+CKffmgjEVCOViRbWkbY4jQ+q5Xc=;
        b=AppK/giV7w7BC4o/JhV7o0GFErVFdjyLymzsng6FcWYvoaf+cs6vsQSnwiUPs37b+h
         7jhpIFRfikPhjRGlnVYHK4SxBXPFGrPRKE0ACFMNotLtD3zXOT+N7BIwkAwOVDG0Nb+F
         j2CsWlt2k7hO3ijLSrWZHWihHsDkbeZ4MdZqh6rl0zrEpMltCdd8fB2x+RIcBvcX3Y09
         qQAK+HoY8soOhwI4NgvWz5NxFiF+Da4K6wrDrBZuT1+U8sIcTSo4O6VWPBlELbfSjrfH
         QiTjkpdSq05sOh5NLtelxH09Zgb5ZvBxlqxWNvIiY6Oc7IlnjHgs6l44Z7vfhvt2larQ
         naAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=6GKfy2itTLAb/HX+CKffmgjEVCOViRbWkbY4jQ+q5Xc=;
        b=u6WElESQPwMx+rigqeF/F9h/Gx/3fSP8SbCgLa3ApLZ3yY7TixGexDBUAi65o2UsZU
         ulGCfEFfsLrvwagsYQzBCdt6E6UmkVK4O//OY1WC4QVmfk8/bNqAMUeLc42bH5QFwUoY
         CrpYoBHdzAovagNp49TNepy5Y/imzNDcAjq5SyV4JDPl1q56nbMEl9pT++xOIlhGlukj
         aC9BAxo8MkEWFheI4oYCGOKZxWdEy8ZHrbmhYQ2w0PvJcBxZ4UwcX+MCwu1Nwq5iot55
         vG3lq+sTNQ1tOpKGaZWn076hqPd1TdIP6pyePo2HqEM+uRdfnjGwWkot3TeD2sJaiuQl
         Htfw==
X-Gm-Message-State: ACgBeo0QzZu0zVsSPhF/o5DAE/gL/roOnGr/zOiwkBkOxxMTipl6/iiz
        uTl0vLWXpq0q9jXmaI3LKjBY2GhqpUSS/pTn8UjQIg==
X-Google-Smtp-Source: AA6agR7zBE3qZPxq6DguZkCD0VSnfJFCEjff9gI+gx8EBtvlQb3KJWE3KSM8Fhj5ocVgqpbA6o3zo5l9tff2gCt2cGg=
X-Received: by 2002:a05:6a00:8cc:b0:52c:7ab5:2ce7 with SMTP id
 s12-20020a056a0008cc00b0052c7ab52ce7mr4278490pfu.28.1662564245512; Wed, 07
 Sep 2022 08:24:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220816042405.2416972-1-m.chetan.kumar@intel.com>
 <CAHNKnsT1E1A25iNN143kRZ=R5cC=P6zDJ+RkXhKYZopG4i38yQ@mail.gmail.com>
 <8458896f-9207-e548-f485-6218201c9099@linux.intel.com> <CAHNKnsRY2cRS8LggQbpFaPGoOT_hSZSecT8QtKxW=D7Gq7Ug+A@mail.gmail.com>
In-Reply-To: <CAHNKnsRY2cRS8LggQbpFaPGoOT_hSZSecT8QtKxW=D7Gq7Ug+A@mail.gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 7 Sep 2022 17:23:28 +0200
Message-ID: <CAMZdPi_xNyt9JAihaRSPUgUy4h43oMxw-JjA_K3VVMmEuS55Og@mail.gmail.com>
Subject: Re: [PATCH net-next 4/5] net: wwan: t7xx: Enable devlink based fw
 flashing and coredump collection
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>,
        Mishra Soumya Prakash <soumya.prakash.mishra@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Sept 2022 at 01:25, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>
> On Sat, Sep 3, 2022 at 11:32 AM Kumar, M Chetan
> <m.chetan.kumar@linux.intel.com> wrote:
> > On 8/30/2022 7:51 AM, Sergey Ryazanov wrote:
> >> On Tue, Aug 16, 2022 at 7:12 AM <m.chetan.kumar@intel.com> wrote:
> >>> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> >>>
> >>> This patch brings-in support for t7xx wwan device firmware flashing &
> >>> coredump collection using devlink.
> >>>
> >>> Driver Registers with Devlink framework.
> >>> Implements devlink ops flash_update callback that programs modem firmware.
> >>> Creates region & snapshot required for device coredump log collection.
> >>> On early detection of wwan device in fastboot mode driver sets up CLDMA0 HW
> >>> tx/rx queues for raw data transfer then registers with devlink framework.
> >>> Upon receiving firmware image & partition details driver sends fastboot
> >>> commands for flashing the firmware.
> >>>
> >>> In this flow the fastboot command & response gets exchanged between driver
> >>> and device. Once firmware flashing is success completion status is reported
> >>> to user space application.
> >>>
> >>> Below is the devlink command usage for firmware flashing
> >>>
> >>> $devlink dev flash pci/$BDF file ABC.img component ABC
> >>>
> >>> Note: ABC.img is the firmware to be programmed to "ABC" partition.
> >>>
> >>> In case of coredump collection when wwan device encounters an exception
> >>> it reboots & stays in fastboot mode for coredump collection by host driver.
> >>> On detecting exception state driver collects the core dump, creates the
> >>> devlink region & reports an event to user space application for dump
> >>> collection. The user space application invokes devlink region read command
> >>> for dump collection.
> >>>
> >>> Below are the devlink commands used for coredump collection.
> >>>
> >>> devlink region new pci/$BDF/mr_dump
> >>> devlink region read pci/$BDF/mr_dump snapshot $ID address $ADD length $LEN
> >>> devlink region del pci/$BDF/mr_dump snapshot $ID
> >>>
> >>> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> >>> Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
> >>> Signed-off-by: Mishra Soumya Prakash <soumya.prakash.mishra@intel.com>
> >>
> >> [skipped]
> >>
> >>> diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
> >>> index 9c222809371b..00e143c8d568 100644
> >>> --- a/drivers/net/wwan/t7xx/t7xx_state_monitor.c
> >>> +++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
> >>
> >> [skipped]
> >>
> >>> @@ -239,8 +252,16 @@ static void t7xx_lk_stage_event_handling(struct t7xx_fsm_ctl *ctl, unsigned int
> >>>                          return;
> >>>                  }
> >>>
> >>> +               if (lk_event == LK_EVENT_CREATE_PD_PORT)
> >>> +                       port->dl->mode = T7XX_FB_DUMP_MODE;
> >>> +               else
> >>> +                       port->dl->mode = T7XX_FB_DL_MODE;
> >>>                  port->port_conf->ops->enable_chl(port);
> >>>                  t7xx_cldma_start(md_ctrl);
> >>> +               if (lk_event == LK_EVENT_CREATE_PD_PORT)
> >>> +                       t7xx_uevent_send(dev, T7XX_UEVENT_MODEM_FASTBOOT_DUMP_MODE);
> >>> +               else
> >>> +                       t7xx_uevent_send(dev, T7XX_UEVENT_MODEM_FASTBOOT_DL_MODE);
> >>>                  break;
> >>>
> >>>          case LK_EVENT_RESET:
> >>
> >> [skipped]
> >>
> >>> @@ -318,6 +349,7 @@ static void fsm_routine_ready(struct t7xx_fsm_ctl *ctl)
> >>>
> >>>          ctl->curr_state = FSM_STATE_READY;
> >>>          t7xx_fsm_broadcast_ready_state(ctl);
> >>> +       t7xx_uevent_send(&md->t7xx_dev->pdev->dev, T7XX_UEVENT_MODEM_READY);
> >>>          t7xx_md_event_notify(md, FSM_READY);
> >>>   }
> >>
> >> These UEVENT things look at least unrelated to the patch. If the
> >> deriver is really need it, please factor out it into a separate patch
> >> with a comment describing why userspace wants to see these events.
> >>
> >> On the other hand, this looks like a custom tracing implementation. It
> >> might be better to use simple debug messages instead or even the
> >> tracing API, which is much more powerful than any uevent.
> >
> > Driver is reporting modem status (up, down, exception, etc) via uevent.
> > The wwan user space services use these states for taking some action.
> > So we have choose uevent for reporting modem status to user space.
> >
> > Is it ok we retain this logic ? I will drop it from this patch and send
> > it as a separate patch for review.
>
> Usually some subsystem generates common events for served devices. And
> it is quite unusual for drivers to generate custom uevents. I found
> only a few examples of such drivers.
>
> I am not against the uevent usage, I just doubt that some userspace
> software could benefit from custom driver uevents. If this case is
> special, then please send these uevent changes as a separate patch
> with a comment describing why userspace wants to see them.

Yes, would be good to avoid new custom uevents if possible. I'm not
familiar with devlink but in the case of firmware flashing I assume
the device state is fully managed internally by the driver, and the
command terminates with success (or not), so we don't really need to
report async events. For firmware state, maybe having a 'state' sysfs
prop would be a good start (as for remoteproc), with generic state
names like "running", "crashed"...

BTW, don't remember if we already mention/address this, but isn't the
device coredump framework more appropriate for such dump?

Regards,
Loic
