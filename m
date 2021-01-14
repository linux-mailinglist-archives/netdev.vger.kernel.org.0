Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22DC2F59B3
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbhAND6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 22:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbhAND6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 22:58:34 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950DAC061786
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 19:57:54 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 11so2590094pfu.4
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 19:57:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KnfaLeN5eyeEcZ129vFM1y3OaYA4UCBKDNMgkXpINkA=;
        b=CZsT5uofXYln4P9I15tZQJYi3SRWMWhJLA6PIduBW2UneISPPDna6OZgOXyfbFQsaG
         3g9HC5kagRrabZtrutmg5PbWCHrIF//6yTQo1j8URKNFBhIcLCTWcQD8R4oZ/XHGQVXA
         29KDjTQcHcWqkFA5oFueJMbblMkPA7Kw5tyrJCdLbLaviLNNpHOsS+KeKs9sEYj7pPTf
         aQboKVsBgU/2+258omSCDdeGm6+Xbhswhn7i/NunHcPn6Hn+Ve1vXO0P94HWsZVFnjml
         xvu/H8nyFAw7kqgKnskO+wywuZFrqtV88Na4VXm3lxuHs4W0aRFd4uvLkZJlBvptR04V
         v2ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KnfaLeN5eyeEcZ129vFM1y3OaYA4UCBKDNMgkXpINkA=;
        b=gmTTz6LaidIvihfLahznT+VIqqanDyUkG1pRPMdJOeYzkKMRbvJGRVfsuW2KhURNeO
         89y7IgdYIuCzKq7s2CcSkUxgdqf0w4X8pAbt0Cwi8ofcp2WST8KHTytAX7RtSugPORXU
         0SuTbI4plEsUdVZgu/QDrrOvA1I/2XBUpk6x4RmRVaspVt0ZWsBby7lRUnBiRPIQhuus
         wshsNlgo82OAduzUpXWojU6ecU0DEfDkoWhNt4JExMPODO6KZZJ4WnQdV8oFLKk53p6t
         KfTnV9M6zbknFLFqouF3NnHFseHfae+2Pi6bFAHVTZj6XZNCXmEU6lMg7YEMIpVYr8Dy
         jU/A==
X-Gm-Message-State: AOAM53346h2psPBRIt03cYHo+g5i6ds9S2KpApzj9fdKtXcNdzpg29mJ
        HpBBb/MvFYchCuAMOV9RY0q6
X-Google-Smtp-Source: ABdhPJy4tPOUbPjXU4mubi6NFyIC9Pgtr3Ca92FtBjZY1wMK2T31N7YM4JXakngl53t84vAV1F6P6Q==
X-Received: by 2002:a62:4d03:0:b029:1ac:6159:4572 with SMTP id a3-20020a624d030000b02901ac61594572mr5631270pfb.10.1610596673890;
        Wed, 13 Jan 2021 19:57:53 -0800 (PST)
Received: from work ([103.77.37.186])
        by smtp.gmail.com with ESMTPSA id z2sm3759575pgl.49.2021.01.13.19.57.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 13 Jan 2021 19:57:52 -0800 (PST)
Date:   Thu, 14 Jan 2021 09:27:49 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Hemant Kumar <hemantk@codeaurora.org>
Subject: Re: [PATCH net-next 1/3] bus: mhi: core: Add helper API to return
 number of free TREs
Message-ID: <20210114035749.GA4607@work>
References: <1610388462-16322-1-git-send-email-loic.poulain@linaro.org>
 <20210113193301.2a9b7ae7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113193301.2a9b7ae7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 07:33:01PM -0800, Jakub Kicinski wrote:
> On Mon, 11 Jan 2021 19:07:40 +0100 Loic Poulain wrote:
> > From: Hemant Kumar <hemantk@codeaurora.org>
> > 
> > Introduce mhi_get_free_desc_count() API to return number
> > of TREs available to queue buffer. MHI clients can use this
> > API to know before hand if ring is full without calling queue
> > API.
> > 
> > Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
> > Reviewed-by: Jeffrey Hugo <jhugo@codeaurora.org>
> > Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> 
> Can we apply these to net-next or does it need to be on a stable branch
> that will also get pulled into mhi-next?

We should use the immutable branch for this so that I can pull into
mhi-next.

Thanks,
Mani
