Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC5C6449B8
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235606AbiLFQuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235615AbiLFQtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:49:43 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743C9DEF
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:49:38 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id cm20so14999706pjb.1
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 08:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gpiccoli-net.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YspoIO0dTyxu2iJ/S2fKZPl285lH09dp2Aw4TfkW1sQ=;
        b=3dL7ueS25tiDDMLvGamp1zbVMMl1Wc9quoyqRtptbU4hrHAYQUko8z1i8omRa4ge34
         tiT28lla94FkWX3tfA7SXBil+K2hYX98/89PG1RMujRNZBYm0pxTVEk8Ok8TiBXeHt1+
         t9/nFfG78DZ7lHUEFo5CotRMcrp9pZa+VL50LyNepdODnYjc10rWubIILECTjNXmrN1G
         zxwKaDTIRkNJZPWQgyhltYkc55RnKbHvrP+086mAhUSrJLLHApoCakeaKaTEqHg5LprK
         x8tqNamhyDEF1cGPCT8vqW6ZFXPtq8bzEzDRS11E0EKqdnNCM18TEDvxxwHGGd5TCxrl
         2wew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YspoIO0dTyxu2iJ/S2fKZPl285lH09dp2Aw4TfkW1sQ=;
        b=jziPstymEe+q7aQZX84NtII0Pqk/UGqPkinjRHyXcnbVJv4+4SBrv8twej6W6DQ8Q/
         DF6nWrp+qaywdYy5RiwZHhI9izjkvG8AV7nmVOKg9EuRkrMdgjs00xCgggoHy68ecmY6
         aquRvYssDth63sWWZAYSGhHgrx1Ttkrx+/euVT9gwbkh+R12rZnM4aKSixOcY2cfJloD
         QtcEduhOP97susafPnqn0G3SxKE4dGik9U75eb5MSHl2Vl7N4odFsMG+PiUx7jlWFOCN
         M2g/ZCW32xRsPCLniswpE4ugbZUyigkhYicgygutjAREHdyVNuLPqxBjU9O0V3oUEPKK
         Rugw==
X-Gm-Message-State: ANoB5pnX+XoeckcFUsftUxgOpsJTTS1ygy0XGesw+ypZ0HIJownSmakJ
        MlK152Szfa8yUIkATNIa2Y6OMl5iCoKzQvj6qc3dVhtWlHo/kl7rdcRE+Q==
X-Google-Smtp-Source: AA0mqf6WUU1v+zgm2UECQY6wM9E0Gdzth5ojODjDRmgoaamR6+BzRSMtsrKq7NbIXZDFXpKckUsHJVGEjPUf50OK3y4=
X-Received: by 2002:a17:903:120c:b0:188:fc5f:84f3 with SMTP id
 l12-20020a170903120c00b00188fc5f84f3mr82286592plh.2.1670345378014; Tue, 06
 Dec 2022 08:49:38 -0800 (PST)
MIME-Version: 1.0
References: <20221001143131.6ondbff4r7ygokf2@pengutronix.de> <20221003093606.75a78f22@kernel.org>
In-Reply-To: <20221003093606.75a78f22@kernel.org>
From:   "Guilherme G. Piccoli" <kernel@gpiccoli.net>
Date:   Tue, 6 Dec 2022 13:49:01 -0300
Message-ID: <CALJn8nN-5DZZkwrJurtT2NOUXGdEQa-aQt+MHvsii2oC_w5+FA@mail.gmail.com>
Subject: Re: Strangeness in ehea network driver's shutdown
To:     Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Douglas Miller <dougmill@linux.ibm.com>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, kernel@pengutronix.de,
        gpiccoli@igalia.com, cascardo@canonical.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 3, 2022 at 1:36 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 1 Oct 2022 16:31:31 +0200 Uwe Kleine-K=C3=B6nig wrote:
> > Hello,
> >
> > while doing some cleanup I stumbled over a problem in the ehea network
> > driver.
> >
> > In the driver's probe function (ehea_probe_adapter() via
> > ehea_register_memory_hooks()) a reboot notifier is registered. When thi=
s
> > notifier is triggered (ehea_reboot_notifier()) it unregisters the
> > driver. I'm unsure what is the order of the actions triggered by that.
> > Maybe the driver is unregistered twice if there are two bound devices?
> > Or the reboot notifier is called under a lock and unregistering the
> > driver (and so the devices) tries to unregister the notifier that is
> > currently locked and so results in a deadlock? Maybe Greg or Rafael can
> > tell about the details here?
> >
> > Whatever the effect is, it's strange. It makes me wonder why it's
> > necessary to free all the resources of the driver on reboot?! I don't
> > know anything about the specifics of the affected machines, but I guess
> > doing just the necessary stuff on reboot would be easier to understand,
> > quicker to execute and doesn't have such strange side effects.
> >
> > With my lack of knowledge about the machine, the best I can do is repor=
t
> > my findings. So don't expect a patch or testing from my side.
>
> Last meaningful commit to this driver FWIW:
>
> commit 29ab5a3b94c87382da06db88e96119911d557293
> Author: Guilherme G. Piccoli <kernel@gpiccoli.net>
> Date:   Thu Nov 3 08:16:20 2016 -0200
>
> Also that's the last time we heard from Douglas AFAICT..

Hey folks, thanks for CCing me.

I've worked a bit with ehea some time ago, will need to dig up a bit
to understand things again.
But I'm cc'ing Cascardo - which have(/had?) a more deep knowledge on
that - in the hopes he can discuss the issue without requiring that
much study heh

Cheers,


Guilherme
