Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6F2433C28
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 18:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbhJSQbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 12:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234130AbhJSQbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 12:31:43 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E99C061749
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 09:29:30 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 187so391388pfc.10
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 09:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fFEh57XjcGZVMKBRwiESvTpWJiCdB5W9SosJkX+vQWA=;
        b=PDEz3QO6bizr3TeemGpmyFhZMkcbbFAno6plOYztjq61G/qJbbMmx9OUMcpCocg/IH
         n0ospFhCGFpeEx8pue3eDNfKhtC37lUIPIagl9Wduw3nU4WiM8kxdaHPJ51rH/pn2T7m
         gy6dF68XY9NFhoVBCXFihjXY9h5h2YdTKj1tkKH+8XYJhqeIy0csNKN6usIEu/U6cV1i
         v1l/Q2KuS0BV2p/XT7XZiGhGygv1FjBCqMr0fBQab1mlb2pV44hOYho8IO2/7FdoDXDo
         TCZOtkIT6AOf7sge4pArMm+IFCs9OhdJ6X69sc79tpWBpb28LRuXR09PitYj6AlXLF9s
         2+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fFEh57XjcGZVMKBRwiESvTpWJiCdB5W9SosJkX+vQWA=;
        b=E6F/Gj2enVYCSrj/mVMSYNuVt97HeB9f48RzXFDrJmUFPL434ycfkthyZrEzBc3vqt
         ZyV0u967vBB1DzoF7uunSz/QQpAnPOXrgbbMnjc0n0rUrAHLca9DZ5UMrThfOnOy3ZGF
         pyf7NsA1WVqsDtoh3apIK4ciVOSc3CytgZGCD+ZInSv7YGKIHbWXf30fSB+lHiX5qyzo
         uQCKhGMS4Ty6+xkSOewBpPlZsxEdnryHGCl0z+c7obI0a2yJ7HjjLDQeTfDg1rHSva7o
         08BEoEGwyWc6yxQZMkW+NtaGjXEoJEqFipYzt+Z6K22jcCSd12kAagZitmibcZAoGp3/
         fluw==
X-Gm-Message-State: AOAM531DVpSwX4VRCMW6ZGEp3aATY6UfBpgyCbzpqqFgYgr1vHqtQwpP
        80REqp11xgsp4iNpxnipy0bF
X-Google-Smtp-Source: ABdhPJxg1UV9ay1tnqW4qYoObXmuV5HDK5RsbsdNduyr70lGkjBTQUW/8sVpeoD3DwtkpUdBRULl+Q==
X-Received: by 2002:a05:6a00:1484:b0:44c:de7f:30 with SMTP id v4-20020a056a00148400b0044cde7f0030mr757072pfu.62.1634660970206;
        Tue, 19 Oct 2021 09:29:30 -0700 (PDT)
Received: from thinkpad ([2409:4072:6e0a:4e8d:17f:7a74:8180:8fca])
        by smtp.gmail.com with ESMTPSA id x13sm15808132pge.37.2021.10.19.09.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 09:29:29 -0700 (PDT)
Date:   Tue, 19 Oct 2021 21:59:23 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     mhi@lists.linux.dev, loic.poulain@linaro.org,
        hemantk@codeaurora.org, bbhatt@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] bus: mhi: Add mhi_prepare_for_transfer_autoqueue API for
 DL auto queue
Message-ID: <20211019162923.GA189099@thinkpad>
References: <20211019134451.174318-1-manivannan.sadhasivam@linaro.org>
 <20211019074918.5b498937@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211019074918.5b498937@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 07:49:18AM -0700, Jakub Kicinski wrote:
> On Tue, 19 Oct 2021 19:14:51 +0530 Manivannan Sadhasivam wrote:
> > Add a new API "mhi_prepare_for_transfer_autoqueue" for using with client
> > drivers like QRTR to request MHI core to autoqueue buffers for the DL
> > channel along with starting both UL and DL channels.
> > 
> > So far, the "auto_queue" flag specified by the controller drivers in
> > channel definition served this purpose but this will be removed at some
> > point in future.
> > 
> > Cc: netdev@vger.kernel.org
> > Co-developed-by: Loic Poulain <loic.poulain@linaro.org>
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> > 
> > Dave, Jakub: This patch should go through MHI tree. But since the QRTR driver
> > is also modified, this needs an Ack from you.
> 
> CCing us wouldn't hurt.
> 

Okay.

> Speaking of people who aren't CCed I've seen Greg nack the flags
> argument.
> 

I usually send patches to Greg during the PR time as MHI patches goes through
char-misc tree. I don't include him during the patch reviews.

And yes, Greg indeed NACK the API that had flags argument. But this one didn't.

Thanks,
Mani

> SMH
