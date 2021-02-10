Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6340F3172F3
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 23:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbhBJWJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 17:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233322AbhBJWJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 17:09:23 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5408C061786
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 14:08:42 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id s107so3334611otb.8
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 14:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w+9SdUEnsF4pHkU1tDBnRGj5XjHGKyGoPGtcwtMXZOQ=;
        b=gkS0u8cmNTGolILvLS0Dwr0RiB/B45hVpkkhRTTMu2YXJvcnjgWaphfMP0TVYtAHqN
         zatOdh2Kv8Lf6FuZoQqbe9NhOvciisgNtl76+eBolE9RbLN4wzeiWPTXFigqzZncHILy
         JOCz/8C+aNLC6Jg4CzkmUfhCaFhUIFtTjbIVcdw+MhTIul8PIdzOoKMLVqkQByrs4E28
         FIopILpoWfNiUiTbxkA7+7ZZDfTpF+8otLNBptkQ/mf3+pKLIZrNoIrBR1W8EGEHZXfC
         DgHR+GH4/it2RApLSln2cIjJnZN+V7JfiLPy25la9AimIYqxWL+AmYlwOko5vI2LlMNp
         C7xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w+9SdUEnsF4pHkU1tDBnRGj5XjHGKyGoPGtcwtMXZOQ=;
        b=iDr7k8/7Lv0xyBTqO6kwziKPBKJXt9f9wSqS2q4cQPAnqwg4ZfRuTYlkXZjrmO8WFF
         fgGuW5MLZknJ81To/4dyFmJFB/oLHJS9EmC98sbNiBzfQIAseL9UPHpzFP1uQue8spEU
         8hOPyUYN36RezVysNsgMExkMwvr9TardfVHcWCKs+Y31Ne2t99fJtf53Mp6TemhHFth2
         9Z/mLWDXL78zp2cNOoj4hAjka8e9nkeXXgX27XJ2tAKl2NXPC2aDag94XJQQIEZ/bM21
         +HiDdUK8zlEqph3oask0y6o9pG3hFN0fqrewv72HpXEpkqYpnb5cEVAHIPdRyI7rwDv4
         a/kg==
X-Gm-Message-State: AOAM530YC/kiRfWFqDsoAu6ZpZVtWt7T1BIwrnR4I6WeADqkMP8IZXbR
        VTPtvUXq4o5MSvpNaLFI/9wAJg==
X-Google-Smtp-Source: ABdhPJz5D+CtcYAozBzCKBT5hWpizTz0gKmYZWTHUyGgwjh1Bmoi7ZK677jcaf39gy+n0cBcEakW5w==
X-Received: by 2002:a05:6830:14c6:: with SMTP id t6mr3725168otq.4.1612994921988;
        Wed, 10 Feb 2021 14:08:41 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id d3sm652338ooi.42.2021.02.10.14.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 14:08:41 -0800 (PST)
Date:   Wed, 10 Feb 2021 16:08:39 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Loic Poulain <loic.poulain@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [RESEND PATCH v18 0/3] userspace MHI client interface driver
Message-ID: <YCRZZyHO/QkCT9sa@builder.lan>
References: <20210202042208.GB840@work>
 <20210202201008.274209f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <835B2E08-7B84-4A02-B82F-445467D69083@linaro.org>
 <20210203100508.1082f73e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMZdPi8o44RPTGcLSvP0nptmdUEmJWFO4HkCB_kjJvfPDgchhQ@mail.gmail.com>
 <20210203104028.62d41962@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAAP7ucLZ5jKbKriSp39OtDLotbv72eBWKFCfqCbAF854kCBU8w@mail.gmail.com>
 <20210209081744.43eea7b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210210062531.GA13668@work>
 <20210210104128.2166e506@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210104128.2166e506@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 10 Feb 12:41 CST 2021, Jakub Kicinski wrote:

> On Wed, 10 Feb 2021 11:55:31 +0530 Manivannan Sadhasivam wrote:
> > On Tue, Feb 09, 2021 at 08:17:44AM -0800, Jakub Kicinski wrote:
> > > On Tue, 9 Feb 2021 10:20:30 +0100 Aleksander Morgado wrote:  
> > > > This may be a stupid suggestion, but would the integration look less a
> > > > backdoor if it would have been named "mhi_wwan" and it exposed already
> > > > all the AT+DIAG+QMI+MBIM+NMEA possible channels as chardevs, not just
> > > > QMI?  
> > > 
> > > What's DIAG? Who's going to remember that this is a backdoor driver 
> > > a year from now when Qualcomm sends a one liner patches which just 
> > > adds a single ID to open another channel?  
> > 
> > I really appreciate your feedback on this driver eventhough I'm not
> > inclined with you calling this driver a "backdoor interface". But can
> > you please propose a solution on how to make this driver a good one as
> > per your thoughts?
> > 
> > I really don't know what bothers you even if the userspace tools making
> > use of these chardevs are available openly (you can do the audit and see
> > if anything wrong we are doing).
> 
> What bothers me is maintaining shim drivers which just shuttle opaque
> messages between user space and firmware. One of which definitely is,
> and the other may well be, proprietary. This is an open source project,
> users are supposed to be able to meaningfully change the behavior of
> the system.
> 

You're absolutely right in that we in general don't like shim drivers
and there are several examples of proper MHI drivers - for e.g.
networking, WiFi

Technically we could fork/reimplement
https://github.com/freedesktop/libqmi, https://github.com/andersson/diag
and https://github.com/andersson/qdl in the kernel as "proper drivers" -
each one exposing their own userspace ABI.

But to leave these in userspace and rely on something that looks exactly
like USBDEVFS seems like a much better strategy.

> What bothers me is that we have 3 WWAN vendors all doing their own
> thing and no common Linux API for WWAN. It may have been fine 10 years
> ago, but WWAN is increasingly complex and important.
> 

We had a deep discussion and a few prototypes for a WWAN framework going
around 1-1.5 years ago. Unfortunately, what did fit Intel's view of what
a WWAN device is didn't fit at all with what's run and exposed by the
"modem" DSP in a Qualcomm platform. After trying to find various
contrived ways to model this we gave up.

> > And exposing the raw access to the
> > hardware is not a new thing in kernel. There are several existing
> > subsystems/drivers does this as pointed out by Bjorn. Moreover we don't
> > have in-kernel APIs for the functionalities exposed by this driver and
> > creating one is not feasible as explained by many.
> > 
> > So please let us know the path forward on this series. We are open to
> > any suggestions but you haven't provided one till now.
> 
> Well. You sure know how to aggravate people. I said clearly that you
> can move forward on purpose build drivers (e.g. for WWAN). There is no
> way forward on this common shim driver as far as I'm concerned.

But what is a WWAN device? What features does it have? What kind of APIs
does it expose?


Note that in this sense "QMI" really is a "binary equivalent" of AT
commands, the data flows over a DMA engine, which is not part of the
"WWAN device" and other services, such as GPS, already has specific
transports available upstream.

Regards,
Bjorn
