Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C142D8443
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 05:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438108AbgLLEJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 23:09:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:42910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438099AbgLLEI6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 23:08:58 -0500
Date:   Fri, 11 Dec 2020 20:08:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607746098;
        bh=Zhu1REojfchWeln1FozhS7doUfpd5aciMb98gfWrzEw=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=JDpTABt8mCMa3alSU7t5Pd/zKfxQpvw8Uh5MES7wR/oedtimNk9/b90H8LzxEP/ec
         O5RtHfroGOFrwD2ZiV+RgWqqg5LPJWcZuBslFkxrkcD6DbnVQQN36ONDseDP/se2/x
         50b1buhlkpfE2P5JIsbtWUKN+XLaaomM5gYpH/MrrbxtJKxTv5f6oZyGt1rGVLFgTi
         sHdDMZ63nIfJ6JbcgzIXxPbrzery/VyFqWzI+4nWI741FP0EzBiw/l7qsZ05jGf/zv
         hg+T2tH6MFJI3A9hpGuOYk2r+tUWq05/W1c86GZREeIPa73Yro3/dq/rsSuEs092Y4
         48wDBlfwWJjDQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Williams <dcbw@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        manivannan.sadhasivam@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jhugo@codeaurora.org,
        bbhatt@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v17 3/3] bus: mhi: Add userspace client interface driver
Message-ID: <20201211200816.7062c3f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <81dfd08b90f841194237e074aaa3d57cada7afad.camel@redhat.com>
References: <1607670251-31733-1-git-send-email-hemantk@codeaurora.org>
        <1607670251-31733-4-git-send-email-hemantk@codeaurora.org>
        <X9MjXWABgdJIpyIw@kroah.com>
        <81dfd08b90f841194237e074aaa3d57cada7afad.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Dec 2020 11:37:34 -0600 Dan Williams wrote:
> Just to re-iterate: QMI ~= AT commands ~= MBIM (not quite, but same
> level)
> 
> We already do QMI-over-USB, or AT-over-CDC-ACM. This is QMI-over-MHI.

Why do we need a different QMI-over-X for every X? If you say there 
are already chardev interfaces to configure WWAN why not provide one 
of those?

> It's not networking data plane. It's WWAN device configuration.

Ack. Not that network config doesn't fall under networking, but eh.
I wonder - did DaveM ever ack this, or was it just out of his sight
enough, behind the cdev, to never trigger a nack?

> There are no current kernel APIs for this, and I really don't think we
> want there to be. The API surface is *huge* and we definitely don't
> want that in-kernel.

It is what it is today for WWAN. I don't think anyone in the
development community or among users is particularly happy about
the situation. Which makes it rather self evident why there is 
so much apprehension about this patch set. It's going to be 
a user space channel for everything Qualcomm - AI accelerator etc.
Widening the WWAN status quo to more device types.
