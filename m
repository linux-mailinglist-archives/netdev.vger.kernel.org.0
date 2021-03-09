Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F381033205D
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhCIITp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:19:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:37478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229553AbhCIITd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 03:19:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E331365173;
        Tue,  9 Mar 2021 08:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615277973;
        bh=g0dr8iBnVQiUnP5ep2b7HT+0d2SKdZyQa7mIEYieBvU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eBkpMPWqqefa+Zu0KdrrgMTyaMVONLvFHoH1GelJ/09j0JGT0B9pUtKW1HK4bHvq3
         6HChrvTHvEsVWua2XAQXM9Aez1NJi9KIHT3yqdVQSaXhvQZ02tGnvxCIb/+ifp1nn6
         yZkYM0ROl++BC+MfH3sQlf6yvLK4zXqjdvLqrRO0=
Date:   Tue, 9 Mar 2021 09:19:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     manivannan.sadhasivam@linaro.org, hemantk@codeaurora.org,
        linux-arm-msm@vger.kernel.org, aleksander@aleksander.es,
        linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, bjorn.andersson@linaro.org
Subject: Re: [PATCH v2] bus: mhi: Add Qcom WWAN control driver
Message-ID: <YEcvksXq1Rt0wCxb@kroah.com>
References: <1615237167-19969-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615237167-19969-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 08, 2021 at 09:59:27PM +0100, Loic Poulain wrote:
> The MHI WWWAN control driver allows MHI Qcom based modems to expose
> different modem control protocols to userspace, so that userspace
> modem tools or daemon (e.g. ModemManager) can control WWAN config
> and state (APN config, SMS, provider selection...). A Qcom based
> modem can expose one or several of the following protocols:
> - AT: Well known AT commands interactive protocol (microcom, minicom...)
> - MBIM: Mobile Broadband Interface Model (libmbim, mbimcli)
> - QMI: Qcom MSM/Modem Interface (libqmi, qmicli)
> - QCDM: Qcom Modem diagnostic interface (libqcdm)
> - FIREHOSE: XML-based protocol for Modem firmware management
> 	    (qmi-firmware-update)
> 
> The different interfaces are exposed as character devices, in the same
> way as for USB modem variants.
> 
> Note that this patch is mostly a rework of the earlier MHI UCI
> tentative that was a generic interface for accessing MHI bus from
> userspace. As suggested, this new version is WWAN specific and is
> dedicated to only expose channels used for controlling a modem, and
> for which related opensource user support exist. Other MHI channels
> not fitting the requirements will request either to be plugged to
> the right Linux subsystem (when available) or to be discussed as a
> new MHI driver (e.g AI accelerator, WiFi debug channels, etc...).
> 
> Co-developed-by: Hemant Kumar <hemantk@codeaurora.org>
> Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  v2: update copyright (2021)
> 
>  drivers/bus/mhi/Kconfig     |  12 +
>  drivers/bus/mhi/Makefile    |   3 +
>  drivers/bus/mhi/wwan_ctrl.c | 559 ++++++++++++++++++++++++++++++++++++++++++++

As Jakub said, why is this file in this directory?

Flat out ignoring review comments is a sure way to always get pushed to
the bottom of the list of things anyone wants to ever look at...

greg k-h
