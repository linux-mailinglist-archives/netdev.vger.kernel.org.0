Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4B4327342
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 16:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbhB1Pxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 10:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhB1Px3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 10:53:29 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6A5C061756
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 07:52:49 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id i14so7705937pjz.4
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 07:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+MDVsqFDrX74IRsp1myuYu41HQaFKHLL77DDnEB1Fqk=;
        b=QFt4hidHZE4BfKl25fDDfoXQ5/4d4UZEpkGApT7taJp9DlVTsH/3YgSE+WtqZm+r/R
         ahteSvZNOLUtbll6//Hx/6QHnM9QFDT3ocjQtNbUxVbeTL3zZ2hG1qWX4vd+UipKMsep
         Pmg9QIp9LQ58rwLbo05hzNHJbCXnkaYWdNcUQtA44CKw/H/A1ErZwjbN07Gz4KQdrYUJ
         aieFypSsfr6BF/jp872hanyTO8CrLEHMxxxXeOCVBJNhMGc9gcr19ZQ27c1vHg7TFGe6
         BI+2eEKYHQAgVQEODsnclaXDloWogLAMNU+dGHuJkHjrLO0RY8Sp+ec+tOwN2KkThrd1
         q/oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+MDVsqFDrX74IRsp1myuYu41HQaFKHLL77DDnEB1Fqk=;
        b=iXnSZlqFD/JkvYMLivrz78yV7zRe2R+AQqZlQ4wHlkfJsM/o0giGmw2A3KL+Sh078E
         iDjkNnCdAOzduIjtmoo6Q+i2FgRqqTY93Lj92PYp4IylOV/lf9hWUW9DBZlA69sCmHF7
         26VDX+/gXsGlecgkxkMtzL2kt4g6pjHPqSozXjDVMPwaxuPgI8ZDB19bnU5HLAdu0ekZ
         3qXO55svXVsuDAWa9xvJteBxc5g9cLJKcu3Ar51rirI3xbxy61cqO+QICn6aG75CXwb8
         7oOQzIWZXpnuz0ZKzd9Oi4WseEHk1Za8a3vQCNcOq6WBgckr9Cad6MZEcwdnWBSa++0k
         W/9w==
X-Gm-Message-State: AOAM532iMW0aj49v/1NtuRdSTREoqS7CXexQB78pkzqmjV/jRvg5TkeA
        JNr69+0QIbWiyjn1relV3Zic
X-Google-Smtp-Source: ABdhPJwnbT7D4+J5kaM+lK5Oa96bxgW7RFnZGoENJR/wCg5zoTWrXJrYf4oM6h1msGStQUy0MD7XSw==
X-Received: by 2002:a17:90a:67ca:: with SMTP id g10mr12617629pjm.166.1614527568432;
        Sun, 28 Feb 2021 07:52:48 -0800 (PST)
Received: from thinkpad ([2409:4072:630a:43e1:8418:10a8:7c13:a7a3])
        by smtp.gmail.com with ESMTPSA id q3sm15303413pfn.14.2021.02.28.07.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 07:52:47 -0800 (PST)
Date:   Sun, 28 Feb 2021 21:22:36 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Aleksander Morgado <aleksander@aleksander.es>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [RESEND PATCH v18 0/3] userspace MHI client interface driver
Message-ID: <20210228155236.GA54373@thinkpad>
References: <20210202042208.GB840@work>
 <20210202201008.274209f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <835B2E08-7B84-4A02-B82F-445467D69083@linaro.org>
 <20210203100508.1082f73e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMZdPi8o44RPTGcLSvP0nptmdUEmJWFO4HkCB_kjJvfPDgchhQ@mail.gmail.com>
 <20210203104028.62d41962@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAAP7ucLZ5jKbKriSp39OtDLotbv72eBWKFCfqCbAF854kCBU8w@mail.gmail.com>
 <20210209081744.43eea7b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210210062531.GA13668@work>
 <CAAP7uc+Q=ToKVNz4wDv0JWHK4NTniSLE1QwMbP0eXEqVMTUwwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAP7uc+Q=ToKVNz4wDv0JWHK4NTniSLE1QwMbP0eXEqVMTUwwQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 28, 2021 at 03:12:42PM +0100, Aleksander Morgado wrote:
> Hey Manivannan, Jakub & all,
> 
> >
> > So please let us know the path forward on this series. We are open to
> > any suggestions but you haven't provided one till now.
> >
> 
> I just found out that Sierra Wireless also provides their own version
> of mhi-net and mhi-uci in precompiled binaries for several Ubuntu
> kernel versions and other setups; and that made me extremely unhappy.
> They're not the only manufacturer doing that; most of them are doing
> it, because we don't have yet a common solution in upstream Linux. Not
> the first time we've seen this either, see the per-vendor GobiNet
> implementations vs the upstream qmi_wwan one. I was hoping we could
> avoid that mess again with the newer Qualcomm modules! :)
> 
> In ModemManager we've always *forced* all manufacturers we interact
> with to first do the work in upstream Linux, and then we integrate
> support in MM for those drivers. We've never accepted support for
> vendor-specific proprietary kernel drivers, and that's something I
> would personally like to keep on doing. The sad status right now is
> that any user that wants to use the newer 5G modules with Qualcomm
> chipsets, they need to go look for manufacturer-built precompiled
> drivers for their specific kernel, and also then patch ModemManager
> and the tools themselves. Obviously almost no one is doing all that,
> except for some company with resources or a lot of interest. Some of
> these new 5G modules are PCIe-only by default, unless some pin in the
> chipset is brought up and then some of them may switch to USB support.
> No one is really doing that either, as tampering with the hardware
> voids warranty.
> 
> The iosm driver is also stalled in the mailing list and there doesn't
> seem to be a lot of real need for a new common wwan subsystem to
> rework everything...
> 
> I'm not involved with the mhi-uci driver development at all, and I
> also don't have anything to say on what goes in the upstream kernel
> and what doesn't. But as one of the ModemManager/libqmi/libmbim
> maintainers I would like to represent all the users of these modules
> that are right now forced to look for shady binary precompiled drivers
> out there... that is no better solution than this proposed mhi-uci
> common driver.
> 
> Manivannan, are you attempting to rework the mhi-uci driver in a
> different way, or have you given up? Is there anything I could help
> with?
> 

Hemant is currently in-charge of the MHI UCI development effort. We were
thinking about doing "mhi-wwan" driver which just exposes the channels needed
for WWAN as Jakub said "you can move forward on purpose build drivers
(e.g. for WWAN)." But we are open to other suggestions also.

Thanks,
Mani
