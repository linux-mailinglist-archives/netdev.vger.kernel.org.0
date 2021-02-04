Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9344430EB66
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 05:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhBDEIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 23:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhBDEIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 23:08:36 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB83EC0613ED
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 20:07:55 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id o20so1293385pfu.0
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 20:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fOA87upY96wx5CXAVS9O4APStVDrdyQiHwsnXM+mTec=;
        b=sa59R/OzxkpnEIbtqjhQL5jTExM8FKCANWqyFCslWMkMYwBSZWDj4d1mAcRw8R7xn7
         isiwAAhKC31uEQSIjaYGr5EMoFAg+rIo/s0b8dQV82uqYwtZ8InKg9q8sjR7+6afEOb3
         SqsGALoM3Pa3yE9c8TQNhE0fRilA8LEBFltrujA3xzmyFjdVtRY8QnHSnNl6gFfxJahm
         wXXE2KSG4t0F5IIqSf70vxO6dwQDb+jdGgmbmcwsB1sVQov05cu/znMNuqq6ZhxDop51
         AZkb7laPpVi27NYfr8uhNjTea+XaDNUT4d3m7PDAzOwoZuZ6WCn0YTzl7GVFNvDtQKah
         Llrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fOA87upY96wx5CXAVS9O4APStVDrdyQiHwsnXM+mTec=;
        b=UHIJtKgB3NRhZToMHGUsdOhf6qVok8ld2AE4STKz7sFfXL4tX5WkFA6uXAC3UyE3m6
         dIIHMkkL7wkR7u6t5VLaxdjdRDtY3OOlzeGgimpFWT3FB1PZ/Tn/Sj3dLPv6VMkTmv5C
         yU8l6yRFhmGzf3NkB+BtRlOmnWBNGDIiczco6Bk8ZnAl+VDvBc876P205X/DJEQdW0J6
         QXYlIH33MoCGrQVKRKMjq4kpbhPOWBViUqRy71bsprxc5kuu6r/dPToClTzhAfVE5Eg4
         CE6vKFcrssbyAHraIcRkLcGro0+CGMo1lx3Gj+tAc7b1SgqHJqNZ8DnooWmXYAigGYbF
         sRYQ==
X-Gm-Message-State: AOAM530xr5/PF8Dt3XUHzXXyOMmPeddP+ECHbPbNiOq9kvyXKHDDm5oj
        8A7emfOW6pe2cZdw8iCpGE0t
X-Google-Smtp-Source: ABdhPJy467GxfvHn3Ve+OONVt2FbgC7gDKGno9kW/cY2dEIbXI24laqwCf54pVWRUEvz4zrvZuASrQ==
X-Received: by 2002:a62:bd05:0:b029:1ab:6d2:5edf with SMTP id a5-20020a62bd050000b02901ab06d25edfmr6267487pff.32.1612411675035;
        Wed, 03 Feb 2021 20:07:55 -0800 (PST)
Received: from thinkpad ([2409:4072:502:e1e4:2c42:3883:f540:5b9c])
        by smtp.gmail.com with ESMTPSA id j3sm3435456pjs.50.2021.02.03.20.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 20:07:54 -0800 (PST)
Date:   Thu, 4 Feb 2021 09:37:46 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [RESEND PATCH v18 0/3] userspace MHI client interface driver
Message-ID: <20210204040746.GA8235@thinkpad>
References: <YBGDng3VhE1Yw6zt@kroah.com>
 <20210201105549.GB108653@thinkpad>
 <YBfi573Bdfxy0GBt@kroah.com>
 <20210201121322.GC108653@thinkpad>
 <20210202042208.GB840@work>
 <20210202201008.274209f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <835B2E08-7B84-4A02-B82F-445467D69083@linaro.org>
 <20210203100508.1082f73e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMZdPi8o44RPTGcLSvP0nptmdUEmJWFO4HkCB_kjJvfPDgchhQ@mail.gmail.com>
 <20210203104028.62d41962@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203104028.62d41962@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 10:40:28AM -0800, Jakub Kicinski wrote:
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

Sorry, I do not want this to go towards rant... But I don't think this is anyway
near a backdoor interface. There are userspace tools available to evaluate the
chardev node and whatever this driver supports and going to support in the
future is part of the Qualcomm modems. The fact that we can't add a separate
driver for MHI QMI is due to the code duplication as the underlying interface is
same it is just the channel which differs.

And I got your point in doing everything in the chardev'ish way here. But we
don't have any standard mechanism (QMI, MBIM, firmware/crash dump download).
And lot of people argued that we are too far away from creating a WWAN
subsystem. And the usecase we are dealing here is specific to Qualcomm. So IMO
we should go ahead with the current interface this driver offers.

Thanks,
Mani

