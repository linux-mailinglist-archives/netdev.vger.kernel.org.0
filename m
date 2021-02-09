Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8239B314B8C
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 10:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhBIJ0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 04:26:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhBIJVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 04:21:22 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC50C061793
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 01:20:42 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id l3so8779050oii.2
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 01:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aleksander-es.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DTuMJKWknYrnZ1xNYLzvsaQ4qGCwYj1qIz7kzYoSeRA=;
        b=Qvh2eOYXxet9fIRUiK5jbirxVA95uKvfHeqJxDuEqaqGmqez7+7SRKdVYPxjchgmS5
         yGKUVXReARDTXcxSTTxD5WpiINvj1C4U32vy+IJZhG5H4zED5LVLlyIF+iWsFagZk/VK
         DYWGw+cm/45qOW0SokH6DnTFC6/v4IKUXQ5xeA9agT978WkDUNGa3b/mMLnPxwy50ZAy
         1C3w4EWLszGGsxqtHJoh9qPHc9Hha9mT98z9NHGjUyO2GSP4ywUasmWaaMrCJ+Ms7Wrp
         t8eI1oDZhznkfM1rU5uqw8W3kS0Mn553wDxvX3bVYdD1kaLQ2y6YS1mUZNOB3g4SUZpl
         KN2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DTuMJKWknYrnZ1xNYLzvsaQ4qGCwYj1qIz7kzYoSeRA=;
        b=gmZcBylyPVqAyTi11ppeuaQaXmccFFWCGCGG193iSBnIBut/cWTjJGJRjx9s+s7BzM
         cveOzLRD1cJxIQYM8KcknDWuwUk0UV4v3/bwCCYSmWdCn0yTJsG31lctRw6oJit4f2Rp
         xX5VNxgEIwyP6ddfX3vTnWwKjaAPbeAbHzQB3B2xhpRrmVZkjdCkRwJog4L4mF9OSGvU
         R8HUt1GANrZzPDz/ArYRu2gkdmh4g7qK5TOmv28Mo+IwHENU6Gu9EMsqbhs/fJUbluDk
         DdJo9T5GR71BdfCLwuyBlbChL5ToQC/cc6FO1/ZyG60H0NcwUVFo4OurmHpm1CVBhXsg
         E0/A==
X-Gm-Message-State: AOAM533e4orY1xmnr2TSvZMs+UheRmOEliNGffU3W4NvPrEFwApZ5bXg
        Dg2bw8/pnybYCHfjxzHumFI9mLpXihdu7B5OGw8nJQ==
X-Google-Smtp-Source: ABdhPJzLJ0oqa6+5bZtVfKINmAk0MnWV5DDDsEUpdQr5xU20juQWB4o82JCmg0PmqAhwFRdn8WGiuMPUsCipS3eJVOA=
X-Received: by 2002:aca:d908:: with SMTP id q8mr1781140oig.67.1612862441549;
 Tue, 09 Feb 2021 01:20:41 -0800 (PST)
MIME-Version: 1.0
References: <1609958656-15064-1-git-send-email-hemantk@codeaurora.org>
 <20210113152625.GB30246@work> <YBGDng3VhE1Yw6zt@kroah.com>
 <20210201105549.GB108653@thinkpad> <YBfi573Bdfxy0GBt@kroah.com>
 <20210201121322.GC108653@thinkpad> <20210202042208.GB840@work>
 <20210202201008.274209f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <835B2E08-7B84-4A02-B82F-445467D69083@linaro.org> <20210203100508.1082f73e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMZdPi8o44RPTGcLSvP0nptmdUEmJWFO4HkCB_kjJvfPDgchhQ@mail.gmail.com> <20210203104028.62d41962@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210203104028.62d41962@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Aleksander Morgado <aleksander@aleksander.es>
Date:   Tue, 9 Feb 2021 10:20:30 +0100
Message-ID: <CAAP7ucLZ5jKbKriSp39OtDLotbv72eBWKFCfqCbAF854kCBU8w@mail.gmail.com>
Subject: Re: [RESEND PATCH v18 0/3] userspace MHI client interface driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Jakub

On Wed, Feb 3, 2021 at 7:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 3 Feb 2021 19:28:28 +0100 Loic Poulain wrote:
> > On Wed, 3 Feb 2021 at 19:05, Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Wed, 03 Feb 2021 09:45:06 +0530 Manivannan Sadhasivam wrote:
> > > > The current patchset only supports QMI channel so I'd request you to
> > > > review the chardev node created for it. The QMI chardev node created
> > > > will be unique for the MHI bus and the number of nodes depends on the
> > > > MHI controllers in the system (typically 1 but not limited).
> > >
> > > If you want to add a MHI QMI driver, please write a QMI-only driver.
> > > This generic "userspace client interface" driver is a no go. Nobody will
> > > have the time and attention to police what you throw in there later.
> >
> > Think it should be seen as filtered userspace access to MHI bus
> > (filtered because not all channels are exposed), again it's not
> > specific to MHI, any bus in Linux offers that (i2c, spi, usb, serial,
> > etc...). It will not be specific to QMI, since we will also need it
> > for MBIM (modem control path), AT commands, and GPS (NMEA frames), all
> > these protocols are usually handled by userspace tools and not linked
> > to any internal Linux framework, so it would be better not having a
> > dedicated chardev for each of them.
>
> The more people argue for this backdoor interface the more distrustful
> of it we'll become. Keep going at your own peril.

Are your worries that this driver will end up being used for many more
things than the initial wwan control port management being suggested
here? If so, what would be the suggested alternative for this
integration? Just a different way to access those control ports
instead of a chardev? A per port type specific driver?

This may be a stupid suggestion, but would the integration look less a
backdoor if it would have been named "mhi_wwan" and it exposed already
all the AT+DIAG+QMI+MBIM+NMEA possible channels as chardevs, not just
QMI?

-- 
Aleksander
