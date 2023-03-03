Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F2C6A9DC6
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 18:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjCCRf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 12:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbjCCRf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 12:35:27 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1EE46149
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 09:35:25 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id p3-20020a17090ad30300b0023a1cd5065fso3020761pju.0
        for <netdev@vger.kernel.org>; Fri, 03 Mar 2023 09:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677864925;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xmR3ha11UO216mLj8Sdg39lpZWXWAADbUEHIEcmgdA0=;
        b=hWiB8C0OPisg4Ld1YeMlK+a7MbWcObYTDEkvV8FAeeyQ3SBD09a1iPz7DIuGjBGuyL
         ap23NnwoBKGTUOuIdz2qVnd1+v0Rzuq0OpqteWZXNsDG1AEYInms4dAGdsNoeAzKmqJZ
         jM5nrAq8ywmphxuoEEg1i6eT+IOW2u0TL8GUvFCFWh+aZkYoyk/ZosoILqGHBHqhM8kX
         CFsaIdiqvwdBfsPztq5oR4jDm5LuwmXODLcomD7kH//L8nPhsWuykBf4C797wE4uB/RO
         Jfs+hvGHGDCQMhSlg6WsNDNnmwRxMW0riRwkCX4yq32c13ofeulxZIXiHTJZBhETqZcG
         EePQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677864925;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xmR3ha11UO216mLj8Sdg39lpZWXWAADbUEHIEcmgdA0=;
        b=krQxxb0QPDWOkY3JQCcVhQFWVXfpEd27GRfTvfkpeCbdP8LR1UOboNWNnW5aGKmgPs
         7k3YXFEnzkuyEQkry+cB8sSt9RFo7wy3zbvrhC4Lb1aTGIMrpZzP0fVkBmMYqfDjEw0a
         oK/FKCW48N6TQ1IZxO0nH5uinFekrInK6JpK4VyD0PB+NjskSTy268p4tUdObgRQzDEM
         KfxUNnAxag88mj1aERkXyxOuaja6MWip822wtwfGDJwYjc4Jo0oplTdMzDuG60DY217E
         QNXopP6Loax9S720ch9yQqKpvqnKK1J059zJx7eqFGvfwFpDPQtqssvsVm7CaDJ5bO02
         6PcA==
X-Gm-Message-State: AO0yUKWOXbgjKGaP1R+Mwf4aq9CxNA/tqhyW97fECVxSvBLgZw61BOrk
        lY1hvaIdbGOoSTc8yXxzJ2U=
X-Google-Smtp-Source: AK7set9xJJkicUfbKGmUxPpV0pmZ2TykrP3b1qHRQaIxTTWti33afeyTIsKjpj2d1PRrdUa7aQtzLQ==
X-Received: by 2002:a05:6a20:440d:b0:cd:18a2:f6cc with SMTP id ce13-20020a056a20440d00b000cd18a2f6ccmr3077199pzb.3.1677864924874;
        Fri, 03 Mar 2023 09:35:24 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id v24-20020a62a518000000b005dca6f0046dsm1980549pfm.12.2023.03.03.09.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 09:35:24 -0800 (PST)
Date:   Fri, 3 Mar 2023 09:35:21 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Michael Walle <michael@walle.cc>, davem@davemloft.net,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        kory.maincent@bootlin.com, kuba@kernel.org,
        maxime.chevallier@bootlin.com, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <ZAIv2aqx8pzmOzo2@hoboy.vegasvil.org>
References: <ZADcSwvmwt8jYxWD@shell.armlinux.org.uk>
 <20230303102005.442331-1-michael@walle.cc>
 <ZAH0FIrZL9Wf4gvp@lunn.ch>
 <ZAH+F6GCCXfzeR+6@shell.armlinux.org.uk>
 <0c0df176-1fbb-43d5-9fb0-358b3873f4e0@lunn.ch>
 <ZAIvQVm9TAOAjrXo@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAIvQVm9TAOAjrXo@hoboy.vegasvil.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 09:32:49AM -0800, Richard Cochran wrote:
> On Fri, Mar 03, 2023 at 05:34:35PM +0100, Andrew Lunn wrote:
> > > > 4) Some solution to the default choice if there is no DT property.
> > > 
> > > I thought (4) was what we have been discussing... but the problem
> > > seems to be that folk want to drill down into the fine detail about
> > > whether PHY or MAC timestamping is better than the other.
> > > 
> > > As I've already stated, I doubt DT maintainers will wear having a
> > > DT property for this, on the grounds that it's very much a software
> > > control rather than a hardware description.
> > 
> > We can argue it is describing the hardware. In that hardware blob X
> > has a better implementation of PTP than hardware blob Y. That could be
> > because of the basic features of the blob, like resolution, adjustable
> > clocks, or board specific features, like temperature compensated
> > crystals, etc.
> 
> IMO a DTS property is the most user friendly solution, even if it
> isn't strictly hardware description.

Afte all, the engineer who designs the board will know which is the
better choice for use case the board targets.

Thanks,
Richard
