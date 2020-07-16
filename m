Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DF0222D47
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 22:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgGPUxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 16:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgGPUxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 16:53:52 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A408C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 13:53:52 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id m16so4390837pls.5
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 13:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=e2eLs40NBrargl0hOEEkEpHu5frMIfyTXiDVhcMYS+c=;
        b=maQl1m1uTLieMyoOfCX627xDtCfZtP50klT2YD3vTIUChq/UenyintvD0+WML0yfif
         yYTp3NqrA+FrfM6hPTG0A0Nfltq5PDjv6pMA1YmA9vx3SR6KnDil7EYSKg7KsAhqQ6YH
         I78TvX/K2EYQteG4hS40DKcXXoPpoIBtm2jq81CrRJsAYu/1n9n+DtTW1jOSTBhv8Znl
         qtFeDd5adq3h93eqWAeDet7XbiyQPY3IT2W0eJEKRX0Zgn3SNn1j+otxTxr+UdeAlliB
         b28E9OehviKkF18CLuLMoV8PedDav1BNXgGH47deeNzT3+riwsh/RN8vXWD+MihtzJO6
         u43Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=e2eLs40NBrargl0hOEEkEpHu5frMIfyTXiDVhcMYS+c=;
        b=mSLlllBPlyVUrtNoa3UuLZcNK+oNpBk1lfx3dkCWmNgWUxHWr2+uo7lbnMTS3yblEX
         CkWKWvzj+YUXyFjFFWZIRzYsxwcNXsGWrYE69ZCIRF764uZLJvXjwtAnBo/fkeQpWt2V
         8oO7y9Rmm4q1Ao7AMjy+2tIVS3uuVPptHgc7HR4Rx/pY568V16Lzm3nN+NohVlAKVBO3
         8PjLv6VfpUPt0OVbauMmYWFA/B2W0HNTIIx59V4SRi9tnNoSZLaDS5++diYaLLsz0hhG
         7hbVfR/i9dpJz5OEB3WZ/A/0oIX38NXREG+DBARvz+xBdtSoi1+ekKD28tn2pyYeV43K
         1q7A==
X-Gm-Message-State: AOAM530Hk0VoulS+wYQ0CEkb66+irveA9VZZlax8oFK/mmhRI+wl17co
        j5YwRn1J40LW0axva27UKd8=
X-Google-Smtp-Source: ABdhPJwhoOHncVRiYTrtW4D2NWwqf6F/+k6XN9QL5ErV3MvE3wEdwhyQrpGEGoW2YA/J3APqUWo4Lw==
X-Received: by 2002:a17:90a:9287:: with SMTP id n7mr5906057pjo.223.1594932831753;
        Thu, 16 Jul 2020 13:53:51 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 9sm5594992pfx.131.2020.07.16.13.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 13:53:51 -0700 (PDT)
Date:   Thu, 16 Jul 2020 13:53:49 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
Message-ID: <20200716205349.GB1385@hoboy>
References: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
 <20200715183843.GA1256692@lunn.ch>
 <20200715185619.GJ1551@shell.armlinux.org.uk>
 <20200716113354.GS1605@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716113354.GS1605@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 12:33:54PM +0100, Russell King - ARM Linux admin wrote:
> 
> PTP_1588_CLOCK could then be used as a global enable for PTP support
> where appropriate.  We can also avoid all the Kconfig complexity
> introduced by having two independent subsystems either of which could
> be modular.

I'm sorry about the Kconfig confusion.  I think it all started with
the tiny-fication work and the new "select" Kconfig keyword.  The
purpose of all this was, IIRC, to allow leaving dynamic posix clocks
out of the kernel, but it still makes my head spin.

Thanks,
Richard
