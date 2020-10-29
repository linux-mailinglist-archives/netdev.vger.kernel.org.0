Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF4A29F72A
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 22:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbgJ2Vwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 17:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJ2Vwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 17:52:34 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1678C0613CF;
        Thu, 29 Oct 2020 14:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=1BNpuLMVsyNkBZuMd56DTZ97qokZDoLMw0jpFigQh6c=; b=2WDEOkwCzDH5WoA1oQysoYm2r+
        Vv/y8QToJYsxtWk9GN+qK6V69qoF4yh0I7ifk+/sx51c4LeGT6Jcc8K51CXb4dkItCXSt46RWKC8Y
        oFGPeHDSFvYZYgCjcOyJrhJkY2tr6HcqpFv9BcANWcAnvj+X2IvFd3aXU0nn+LpknOLCoBC71OjxJ
        SULsQdt5e/mjBoFwLPEktUmQ/0Bvmlk+6yw3y/KVsAiu1e5W/VsbcRBUR1UB+wGMqm/uKTHqghjv5
        3jUebcMoBete3cXvjYZOmjVHHdTKum1XUn+oUz9fDILJuXLE2lujKgm0nDUnNkVnwKanlnMwmb0cX
        vUAn6dzA==;
Received: from [2601:1c0:6280:3f0::507c]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kYFpz-0000cj-TO; Thu, 29 Oct 2020 21:52:04 +0000
Subject: Re: [PATCH v10 3/4] docs: Add documentation for userspace client
 interface
To:     Hemant Kumar <hemantk@codeaurora.org>,
        manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org
References: <1604007647-32163-1-git-send-email-hemantk@codeaurora.org>
 <1604007647-32163-4-git-send-email-hemantk@codeaurora.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <6f508e54-a170-8409-886c-a882b6fd5f63@infradead.org>
Date:   Thu, 29 Oct 2020 14:51:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1604007647-32163-4-git-send-email-hemantk@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 10/29/20 2:40 PM, Hemant Kumar wrote:
> MHI userspace client driver is creating device file node
> for user application to perform file operations. File
> operations are handled by MHI core driver. Currently
> Loopback MHI channel is supported by this driver.
> 
> Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
> ---
>  Documentation/mhi/index.rst |  1 +
>  Documentation/mhi/uci.rst   | 83 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 84 insertions(+)
>  create mode 100644 Documentation/mhi/uci.rst


> diff --git a/Documentation/mhi/uci.rst b/Documentation/mhi/uci.rst
> new file mode 100644
> index 0000000..fe901c4
> --- /dev/null
> +++ b/Documentation/mhi/uci.rst
> @@ -0,0 +1,83 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=================================
> +Userspace Client Interface (UCI)
> +=================================
> +


Lots of TLAs.

> +
> +read
> +----
> +
> +When data transfer is completed on downlink channel, TRE buffer is copied to
> +pending list. Reader is unblocked and data is copied to userspace buffer. TRE
> +buffer is queued back to downlink channel transfer ring.

What is TRE?

> +
> +Usage
> +=====
> +
> +Device file node is created with format:-
> +
> +/dev/mhi_<controller_name>_<mhi_device_name>
> +
> +controller_name is the name of underlying bus used to transfer data. mhi_device
> +name is the name of the MHI channel being used by MHI client in userspace to
> +send or receive data using MHI protocol.
> +
> +There is a separate character device file node created for each channel
> +specified in mhi device id table. MHI channels are statically defined by MHI

                MHI
unless it is a variable name, like below: mhi_device_id

> +specification. The list of supported channels is in the channel list variable
> +of mhi_device_id table in UCI driver.
> +

> +Other Use Cases
> +---------------
> +
> +Getting MHI device specific diagnostics information to userspace MHI diag client

                                                                        diagnostic client

> +using DIAG channel 4 (Host to device) and 5 (Device to Host).
> 

thanks.
-- 
~Randy

