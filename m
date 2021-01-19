Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71A12FB8C5
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394519AbhASNre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:47:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387773AbhASJnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 04:43:39 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B344C061574
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 01:42:59 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id b3so11920070pft.3
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 01:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7S8BJ9E71QGUjoMsbM7R7bFNhP0M0RCDUnqEIz/LTU0=;
        b=T2ce0h1aKxfGTD188B5ysB78EIoD51SKYr0QCy8rEGw/Ql1p7kleii6O4YpAyLfVic
         3/XDjFGFb71eGl/XbHFuWk3pBtkRy6DwSNLM+Db9t0sqDsjDYWedwIFd+L1IlCBw+Igx
         2kg69atc6+rxyws7N2uHwYgC7SZ3MyKfG4/6ysitEp4l6umN0z3dKJA7H2H+uAICDDjC
         TlwHVrz+4OQA2sjobVj+I9I23P/fQq31roZNKPr6a/MSfIkiXqUYNTfuCdeG6+Iqh97S
         fArC7BVz+lMAH6aEYAGuYPx0Tm1FyvtTIZl34QFkCEkRP9kWta7yNllwb3ogMgY18jy3
         0wsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7S8BJ9E71QGUjoMsbM7R7bFNhP0M0RCDUnqEIz/LTU0=;
        b=l0XkmapPQZ0W7/2VXVtZ8Y/zcNutJh1pSHXt97EI7ewx3NsVkM8udLIJeRpILyszUo
         AgZC74QfNqGKjZ35PYbihy4i+mWEbGhZiv/Sl3+5KU4+Cth359+zbkRO0wBxLldP3n8F
         KQ2wsA1QD4wZquAIQk4AFheXAimdJrhkfxpAgG88dYGDeY9ijV8+Tfkz7OKh77YWWZpa
         PO/zh4fHqFbgjXwtrPa32L2wOkfWtIS1BRee/psQEK4LxvyEIUPhfuca96QLdcSsZljx
         VbkM/aWR6jaLrJMpF4nkgsh00SgAk+s/v2A6kNjD9/wFHTr1C1w/dZbrY8HpoUIHx63D
         PP7A==
X-Gm-Message-State: AOAM5326l2+Y/qaL8KujqHBzw9Iqj6H9x9AAeTr2OVowStCdfmmMH8Um
        0re+JEXOGy7Im3qhYTKtk+wP
X-Google-Smtp-Source: ABdhPJx8r0csAja55qm2L6GcuO7UQsGh3beyaY11fvbj47zO9Gc36MNLXZcfp01U/y8QYXGLrlllHA==
X-Received: by 2002:a62:1981:0:b029:1b7:ec14:e2d9 with SMTP id 123-20020a6219810000b02901b7ec14e2d9mr3308769pfz.54.1611049378518;
        Tue, 19 Jan 2021 01:42:58 -0800 (PST)
Received: from thinkpad ([2409:4072:6c8e:9a14:351c:5713:cb9a:6935])
        by smtp.gmail.com with ESMTPSA id y6sm1269136pfn.123.2021.01.19.01.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 01:42:57 -0800 (PST)
Date:   Tue, 19 Jan 2021 15:12:50 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org,
        hemantk@codeaurora.org
Subject: Re: [RESEND PATCH v18 0/3] userspace MHI client interface driver
Message-ID: <20210119094250.GA20682@thinkpad>
References: <1609958656-15064-1-git-send-email-hemantk@codeaurora.org>
 <20210113152625.GB30246@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113152625.GB30246@work>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

On Wed, Jan 13, 2021 at 08:56:25PM +0530, Manivannan Sadhasivam wrote:
> Hi Greg,
> 
> On Wed, Jan 06, 2021 at 10:44:13AM -0800, Hemant Kumar wrote:
> > This patch series adds support for UCI driver. UCI driver enables userspace
> > clients to communicate to external MHI devices like modem. UCI driver probe
> > creates standard character device file nodes for userspace clients to
> > perform open, read, write, poll and release file operations. These file
> > operations call MHI core layer APIs to perform data transfer using MHI bus
> > to communicate with MHI device. 
> > 
> > This interface allows exposing modem control channel(s) such as QMI, MBIM,
> > or AT commands to userspace which can be used to configure the modem using
> > tools such as libqmi, ModemManager, minicom (for AT), etc over MHI. This is
> > required as there are no kernel APIs to access modem control path for device
> > configuration. Data path transporting the network payload (IP), however, is
> > routed to the Linux network via the mhi-net driver. Currently driver supports
> > QMI channel. libqmi is userspace MHI client which communicates to a QMI
> > service using QMI channel. Please refer to
> > https://www.freedesktop.org/wiki/Software/libqmi/ for additional information
> > on libqmi.
> > 
> > Patch is tested using arm64 and x86 based platform.
> > 
> 
> This series looks good to me and I'd like to merge it into mhi-next. You
> shared your reviews on the previous revisions, so I'd like to get your
> opinion first.
> 

Ping!

Thanks,
Mani

> Thanks,
> Mani
> 
> > V18:
> > - Updated commit text for UCI to clarify why this driver is required for QMI
> >   over MHI. Also updated cover letter with same information.
> > 
> > v17:
> > - Updated commit text for UCI driver by mentioning about libqmi open-source
> >   userspace program that will be talking to this UCI kernel driver.
> > - UCI driver depends upon patch "bus: mhi: core: Add helper API to return number
> >   of free TREs".
> > 
> > v16:
> > - Removed reference of WLAN as an external MHI device in documentation and
> >   cover letter.
> > 
> > v15:
> > - Updated documentation related to poll and release operations.
> > 
> > V14:
> > - Fixed device file node format to /dev/<mhi_dev_name> instead of
> >   /dev/mhi_<mhi_dev_name> because "mhi" is already part of mhi device name.
> >   For example old format: /dev/mhi_mhi0_QMI new format: /dev/mhi0_QMI.
> > - Updated MHI documentation to reflect index mhi controller name in
> >   QMI usage example.
> > 
> > V13:
> > - Removed LOOPBACK channel from mhi_device_id table from this patch series.
> >   Pushing a new patch series to add support for LOOPBACK channel and the user
> >   space test application. Also removed the description from kernel documentation.
> > - Added QMI channel to mhi_device_id table. QMI channel has existing libqmi
> >   support from user space.
> > - Updated kernel Documentation for QMI channel and provided external reference
> >   for libqmi.
> > - Updated device file node name by appending mhi device name only, which already
> >   includes mhi controller device name.
> > 
> > V12:
> > - Added loopback test driver under selftest/drivers/mhi. Updated kernel
> >   documentation for the usage of the loopback test application.
> > - Addressed review comments for renaming variable names, updated inline
> >   comments and removed two redundant dev_dbg.
> > 
> > V11:
> > - Fixed review comments for UCI documentation by expanding TLAs and rewording
> >   some sentences.
> > 
> > V10:
> > - Replaced mutex_lock with mutex_lock_interruptible in read() and write() file
> >   ops call back.
> > 
> > V9:
> > - Renamed dl_lock to dl_pending _lock and pending list to dl_pending for
> >   clarity.
> > - Used read lock to protect cur_buf.
> > - Change transfer status check logic and only consider 0 and -EOVERFLOW as
> >   only success.
> > - Added __int to module init function.
> > - Print channel name instead of minor number upon successful probe.
> > 
> > V8:
> > - Fixed kernel test robot compilation error by changing %lu to %zu for
> >   size_t.
> > - Replaced uci with UCI in Kconfig, commit text, and comments in driver
> >   code.
> > - Fixed minor style related comments.
> > 
> > V7:
> > - Decoupled uci device and uci channel objects. uci device is
> >   associated with device file node. uci channel is associated
> >   with MHI channels. uci device refers to uci channel to perform
> >   MHI channel operations for device file operations like read()
> >   and write(). uci device increments its reference count for
> >   every open(). uci device calls mhi_uci_dev_start_chan() to start
> >   the MHI channel. uci channel object is tracking number of times
> >   MHI channel is referred. This allows to keep the MHI channel in
> >   start state until last release() is called. After that uci channel
> >   reference count goes to 0 and uci channel clean up is performed
> >   which stops the MHI channel. After the last call to release() if
> >   driver is removed uci reference count becomes 0 and uci object is
> >   cleaned up.
> > - Use separate uci channel read and write lock to fine grain locking
> >   between reader and writer.
> > - Use uci device lock to synchronize open, release and driver remove.
> > - Optimize for downlink only or uplink only UCI device.
> > 
> > V6:
> > - Moved uci.c to mhi directory.
> > - Updated Kconfig to add module information.
> > - Updated Makefile to rename uci object file name as mhi_uci
> > - Removed kref for open count
> > 
> > V5:
> > - Removed mhi_uci_drv structure.
> > - Used idr instead of creating global list of uci devices.
> > - Used kref instead of local ref counting for uci device and
> >   open count.
> > - Removed unlikely macro.
> > 
> > V4:
> > - Fix locking to protect proper struct members.
> > - Updated documentation describing uci client driver use cases.
> > - Fixed uci ref counting in mhi_uci_open for error case.
> > - Addressed style related review comments.
> > 
> > V3: Added documentation for MHI UCI driver.
> > 
> > V2:
> > - Added mutex lock to prevent multiple readers to access same
> > - mhi buffer which can result into use after free.
> > 
> > Hemant Kumar (3):
> >   bus: mhi: core: Move MHI_MAX_MTU to external header file
> >   docs: Add documentation for userspace client interface
> >   bus: mhi: Add userspace client interface driver
> > 
> >  Documentation/mhi/index.rst     |   1 +
> >  Documentation/mhi/uci.rst       |  95 ++++++
> >  drivers/bus/mhi/Kconfig         |  13 +
> >  drivers/bus/mhi/Makefile        |   3 +
> >  drivers/bus/mhi/core/internal.h |   1 -
> >  drivers/bus/mhi/uci.c           | 664 ++++++++++++++++++++++++++++++++++++++++
> >  include/linux/mhi.h             |   3 +
> >  7 files changed, 779 insertions(+), 1 deletion(-)
> >  create mode 100644 Documentation/mhi/uci.rst
> >  create mode 100644 drivers/bus/mhi/uci.c
> > 
> > -- 
> > The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> > a Linux Foundation Collaborative Project
> > 
