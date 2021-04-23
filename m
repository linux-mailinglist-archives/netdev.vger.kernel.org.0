Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C586368B0A
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240187AbhDWCbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 22:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240107AbhDWCbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 22:31:13 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B20C061574
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 19:30:29 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id i81so47858944oif.6
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 19:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=upXmbuxKEHe1Frac75yuLwrw35UBfEWE3IK73lIo86k=;
        b=A3kRZXQdL2jYMbW+ZspIY1YlC49pRKfSjXD1neVtvdAZFrL7MP4jVNGhbMkClzb0Xe
         L8Nh/QmJnjta502KyHXrVWW/BEjGDVaLApNdAVb4zy3I2GTRd0LDNlLOHgoCBdo5oupA
         ggFqk8zCQpmhdNqys+D15Grs1mjPnaOk0dWa5yKmFEKNO9oovCq6PNhMMtdA8nuFYOKl
         xNdNRZ2OraGVGzdVGLpnlQ3WvCupjJGo4no6pnnY0taBONzxodEC81KpmDIIE8abmymJ
         FkylEuWdZQRe83BJsXm9WWsXkGJBKP6Ixy417bQOuwx7Kv+xVjTItu5E8gCueWRPDOAM
         yF4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=upXmbuxKEHe1Frac75yuLwrw35UBfEWE3IK73lIo86k=;
        b=SZS+uEhcLOlLMG/3AwWonnPwHrbO18Sy1ifJPMZiQCEd5MjIA4HonD9WORl0MHOmSI
         uQYrxLWs6hBPXAHiadZh1+anea8Ba71liuYzmMTtza+x+e9Qbryb1C1ylj8pwy7NTN5E
         UgQx4hrx8DjTB2UpVclpy6eb9nhhsoFDP+aNh7EkKUL+HWsM/3UfZiq7DGQT0C4GsmnC
         HU67z7t6mFT1LpFhfX7h6PP1b1k+ZioA/V8VvbCsll7rL1wT3mKn/aLKY6WVqNCAcW0D
         FioVqEs/uXV4JLLkkwBfd5qXAcpQCSiE3je013Xd/0QHdKLeI8fJw/m0pEMJlKhTnW2K
         gE8A==
X-Gm-Message-State: AOAM532DmUf0dGE6eMsVCvFE2TxVD8YT5K+IlCSDxtAuNzw8s6R6TAiw
        n7a7iWhnuOq99Oey68J20e1+PQ==
X-Google-Smtp-Source: ABdhPJyT1lv3sauaqPOhP3s33P/VnF0H7znLhue/8JfqtbRUCelDPro1Mf8DaYBh8eW8DWbb4AAZGg==
X-Received: by 2002:aca:f412:: with SMTP id s18mr1038501oih.144.1619145028674;
        Thu, 22 Apr 2021 19:30:28 -0700 (PDT)
Received: from yoga (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id n13sm1050028otk.61.2021.04.22.19.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 19:30:28 -0700 (PDT)
Date:   Thu, 22 Apr 2021 21:30:26 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     subashab@codeaurora.org
Cc:     Alex Elder <elder@linaro.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Loic Poulain <loic.poulain@linaro.org>
Subject: Re: [PATCH] net: qualcomm: rmnet: Allow partial updates of IFLA_FLAGS
Message-ID: <20210423023026.GD1908499@yoga>
References: <20210422182045.1040966-1-bjorn.andersson@linaro.org>
 <76db0c51-15be-2d27-00a7-c9f8dc234816@linaro.org>
 <89526b9845cc86143da2221fc2445557@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89526b9845cc86143da2221fc2445557@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 22 Apr 18:28 CDT 2021, subashab@codeaurora.org wrote:

> On 2021-04-22 12:29, Alex Elder wrote:
> > On 4/22/21 1:20 PM, Bjorn Andersson wrote:
> > > The idiomatic way to handle the changelink flags/mask pair seems to be
> > > allow partial updates of the driver's link flags. In contrast the
> > > rmnet
> > > driver masks the incoming flags and then use that as the new flags.
> > > 
> > > Change the rmnet driver to follow the common scheme, before the
> > > introduction of IFLA_RMNET_FLAGS handling in iproute2 et al.
> > 
> > I like this a lot.  It should have been implemented this way
> > to begin with; there's not much point to have the mask if
> > it's only applied to the passed-in value.
> > 
> > KS, are you aware of *any* existing user space code that
> > would not work correctly if this were accepted?
> > 
> > I.e., the way it was (is), the value passed in *assigns*
> > the data format flags.  But with Bjorn's changes, the
> > data format flags would be *updated* (i.e., any bits not
> > set in the mask field would remain with their previous
> > value).
> > 
> > Reviewed-by: Alex Elder <elder@linaro.org>
> 
> What rmnet functionality which was broken without this change.
> That doesnt seem to be listed in this patch commit text.
> 

I recently posted a patch to iproute2 extending the rmnet link handling
to handle IFLA_RMNET_FLAGS, in the discussion that followed this subject
came up. So nothing is broken, it's just that the current logic doesn't
make sense and I wanted to attempt to fix it before we start to use it
commonly distributed userspace software (iproute2, libqmi etc)

> If this is an enhancement, then patch needs to be targeted to net-next
> instead of net

Okay, please let me know what hoops you want me to jump through. I just
want the subject concluded so that I can respin my iproute2 patch
according to what we decide here.

Regards,
Bjorn
