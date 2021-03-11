Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0C033814F
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 00:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbhCKXRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 18:17:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhCKXRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 18:17:33 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF3FC061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 15:17:33 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id e19so49803592ejt.3
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 15:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=s+VR4yYjx+90yUXYot7M7i6yuSqRInM+qCnv1tyB17I=;
        b=SU7DkBTBGG2gGuDJKC+DZN/grRBDggoVxf+wO2JbruNNFOlCDNm9vSK5heU9L3owvI
         pokoIZ4vtLu1ffTJu18xIbXfU4Xf8qfzUeayaXCWBsk4mRoyoxqQsoQt8DfVJczj2W4j
         EoliHS4Y7rApZBp5SYYwE1MbLF+PZsrDzPsPl/poWWublmwxoE40F5jBoL+I9VGgjA3R
         tJbUwmAYiWmpHV0RNqmWYGOQYugifVBrox+UtGEtFXM/H52jShmNbozB07dvXQDObOf9
         ciTsd4ZNSRZVLusXeQGVWdELXm0GFCpNnnCm5QCzu0PZkmU34Um/0SHHxC0K2sGkO+kq
         dMPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s+VR4yYjx+90yUXYot7M7i6yuSqRInM+qCnv1tyB17I=;
        b=Ht7Ai/uDxyp2pHJqvMuz7ArRBwddDqmReV+4C8V7iiO9DPT3GTksPxJJ0mKTacy+07
         pxqS4jCDNZCB5fmEIQKQOQq8x8Qk8s/aTvE6wdLX5IP8rL4O8o5RLrj897aB2l5TwgTc
         nYSYy6LKFPbRPoB/WTC52egLtqSbd3NLXswSM7zSkNmReGAej6lG57RNnM8XV2RlC78+
         hzIyHu9wYYGe3XqD3A79DkE2cuNu1/zuGw3+nJ0pXYbPGbPr8OKTSUjaIRO6hhGDTg1v
         NupWEZucXlaxysPCDxIo6CtL32GMXDyKn0WmD8KZF3pebadJKf/DrFNd1iuF8fHABK/t
         0deQ==
X-Gm-Message-State: AOAM5316NN9/1VAg8ONXxu1IG3BDFMqv8sEMqjxv+o9rkFSeNDorqEGT
        RVGe0kHNnBC7z2CXaAvfkAs=
X-Google-Smtp-Source: ABdhPJwD/IrouuKOIltXIHtcvFpHdLrI+grrdt7b6vF6twcNn3OM6BW8ihgU1qanoh6CGeV8ZE213w==
X-Received: by 2002:a17:906:2ad8:: with SMTP id m24mr5552771eje.512.1615504652232;
        Thu, 11 Mar 2021 15:17:32 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id gj13sm1969460ejb.118.2021.03.11.15.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 15:17:31 -0800 (PST)
Date:   Fri, 12 Mar 2021 01:17:30 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Kurt Kanzenbach <kurt@kmk-computers.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/6] net: dsa: hellcreek: Report META data usage
Message-ID: <20210311231730.23wcckyzihmp6elk@skbuf>
References: <20210311175344.3084-1-kurt@kmk-computers.de>
 <20210311175344.3084-3-kurt@kmk-computers.de>
 <YEqfOc3Wii7UTH8g@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEqfOc3Wii7UTH8g@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 11:52:41PM +0100, Andrew Lunn wrote:
> On Thu, Mar 11, 2021 at 06:53:40PM +0100, Kurt Kanzenbach wrote:
> > Report the META data descriptor usage via devlink.
> 
> Jakubs question is also relevant here. Please could you give a bit
> more background about what the meta data is?

Not having seen any documentation for this device, my guess is that
metadata descriptors are frame references, and the RAM page count is for
packet memory buffers. Nonetheless, I would still like to hear it from
Kurt. There is still a lot unknown even if I am correct. For example, if
the frame references or buffers can be partitioned, or if watermarks for
things like congestion/flow control can be set, then maybe devlink-sb is
a better choice (as that has an occupancy facility as well)?
Fully understand that it is not as trivial as exposing a devlink
resource, but on Ocelot/Felix I quite appreciate having the feature
(drivers/net/ethernet/mscc/ocelot_devlink.c). And knowing that this is a
TSN switch, I expect that sooner or later, the need to have control over
resource partitioning per traffic class will arise anyway.
