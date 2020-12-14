Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6642D94D5
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 10:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439590AbgLNJRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 04:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729478AbgLNJRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 04:17:36 -0500
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B672C0613CF;
        Mon, 14 Dec 2020 01:16:56 -0800 (PST)
Received: by mail-qt1-x844.google.com with SMTP id c14so11400462qtn.0;
        Mon, 14 Dec 2020 01:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T6srFUPhGMEYv25NnXpMUM6iBufFuKd/vtRKGzk+i5g=;
        b=ZwVSGxCq8fvkgDL94jTt3KNBTC0+gtQA4d3asnr02hVS5DrXAaOxasRrw6tb/LeF1o
         SvTejIMyvW7HJmpBkqyRegusAxSZml64Dq4p0TFgnChDxsbSlHcu9WfB7tuqwHbYELUH
         nxL7puPwEm/6SXYdFJeJvq7cqHgvj0pDAX5NhIfRyH6PtUjHMgQ9KTillMMu+xFiHyai
         euZ4WH3/vW8yFFD+7tmqXnNJ7ZSv+Zs513MAZVgM6FoXVCD5sAQoJANoz8IzPq2kjWF9
         A/oOQ3D5eFM7Gb7/CMYZZdilWvqgIvheRrdHhlhYdxAgdTds7mcaY28y/qrhfMOegk4E
         Fp1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T6srFUPhGMEYv25NnXpMUM6iBufFuKd/vtRKGzk+i5g=;
        b=GOFtOx+fiqzVYxy1zj6pqKpJNDEcdfKzE81fba9zkdXx1FeeCgkqQF1fLW/xPzYaOR
         qflBGqKOu3eKMSLNdbamvm54N4I7mqQvQIkZkbRpkqO8uHYiB/lgmj7wWMW7+0DiDlcD
         7sZpmeVRwr2hJ1ZKLbdxuFnpJG6MBWUVB/Lyh1DXneck+LfNitoPiMKGPd5VEp2ePOgu
         ZXufJ3V73vrTo2ezZfQyo2gXM/FGgCTb9YykszWm2gYp/9R4/hOyKgEtpfmfzB8bGVhF
         S+87xTJS2aIC15ZcwVMvhczkG1KeFPe/RwBMUTIBokxt4VU9peiaTD4QYQAunxJsEjcM
         DGNw==
X-Gm-Message-State: AOAM531/5AilN7ApLOC4RUv0VmOS2Ag5JD1zBzv/71XFPknJmAeMSWm+
        3bWiarh06OIDwBEy4jXS3XuqDL+tPpPjY4k8Uhk=
X-Google-Smtp-Source: ABdhPJxkJcriH2TmNFqc3sqzZ0b+P5jhQdGJDptmDO6V4A+IoqGH+yOR6N7+WnLvsbbaDt6JInBGysq6yF3ACe8Y7mA=
X-Received: by 2002:ac8:6f41:: with SMTP id n1mr29678010qtv.170.1607937415616;
 Mon, 14 Dec 2020 01:16:55 -0800 (PST)
MIME-Version: 1.0
References: <1607670251-31733-1-git-send-email-hemantk@codeaurora.org>
 <1607670251-31733-4-git-send-email-hemantk@codeaurora.org>
 <X9MjXWABgdJIpyIw@kroah.com> <81dfd08b90f841194237e074aaa3d57cada7afad.camel@redhat.com>
 <20201211200816.7062c3f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20201212060818.GA10816@thinkpad>
In-Reply-To: <20201212060818.GA10816@thinkpad>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Mon, 14 Dec 2020 10:16:44 +0100
Message-ID: <CAGRyCJG+5VNwz_OOCjeYM+G6c5cfLVD2wiMQtDubWigDmmWfLA@mail.gmail.com>
Subject: Re: [PATCH v17 3/3] bus: mhi: Add userspace client interface driver
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Dan Williams <dcbw@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Il giorno dom 13 dic 2020 alle ore 15:22 Manivannan Sadhasivam
<manivannan.sadhasivam@linaro.org> ha scritto:
>
> On Fri, Dec 11, 2020 at 08:08:16PM -0800, Jakub Kicinski wrote:
> > On Fri, 11 Dec 2020 11:37:34 -0600 Dan Williams wrote:
> > > Just to re-iterate: QMI ~= AT commands ~= MBIM (not quite, but same
> > > level)
> > >
> > > We already do QMI-over-USB, or AT-over-CDC-ACM. This is QMI-over-MHI.
> >
> > Why do we need a different QMI-over-X for every X? If you say there
> > are already chardev interfaces to configure WWAN why not provide one
> > of those?
> >
>
> Just because the underlying PHY is different and it offers more services than
> just configuring the modem (downloading crash dump, firmware download etc...)
>
> The existing chardev nodes are closely tied to the physical interfaces. For
> instance, /dev/cdc_wdm is used by the USB based WWAN devices. So we really can't
> reuse it for MHI/PCIe.
>

let me also add that the current MHI UCI approach makes sense because
it makes the switch USB -> PCIe smooth, since all the current
open-source userspace tools (e.g. libqmi and qmicli), according to my
testing until now, properly works without any need for a change,
behaving the UCI QMI char device like cdc-wdm.

While a different solution (which one?) would maybe cause to re-think
the userspace side for having the same high-level behavior.

Thanks,
Daniele

> > > It's not networking data plane. It's WWAN device configuration.
> >
> > Ack. Not that network config doesn't fall under networking, but eh.
> > I wonder - did DaveM ever ack this, or was it just out of his sight
> > enough, behind the cdev, to never trigger a nack?
> >
> > > There are no current kernel APIs for this, and I really don't think we
> > > want there to be. The API surface is *huge* and we definitely don't
> > > want that in-kernel.
> >
> > It is what it is today for WWAN. I don't think anyone in the
> > development community or among users is particularly happy about
> > the situation. Which makes it rather self evident why there is
> > so much apprehension about this patch set. It's going to be
> > a user space channel for everything Qualcomm - AI accelerator etc.
> > Widening the WWAN status quo to more device types.
>
> Well not everything Qualcomm but for just the subsystems where there is no
> standardization right now. I think we went too far ahead for standardizing
> the modems.
>
> Thanks,
> Mani
>
