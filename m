Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31CFA2FEE28
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 16:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732591AbhAUPLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 10:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732512AbhAUPLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 10:11:18 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F149EC06174A;
        Thu, 21 Jan 2021 07:10:37 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id kx7so1846299pjb.2;
        Thu, 21 Jan 2021 07:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mnQaO86LPw2v5BHeS49AN/uhNPbOqOlrwhHKzFx8Tc4=;
        b=s50KXEzjQaC9B07WoryHYS0iFi08FT5SUkbDvVYCCZjxB+5hL2ifusr3LYhjr/JzNX
         cqHnqbXfFaIoiI3w8oSPstSZ1bVEzGSiPSKTjSpQX+sJl+BFI2Cos4/U6/3lIZOeA7vs
         YemEpQvDU4Of2zkxLClluA14qgeCLPrGQ+NDekJU8UA1cZbzwi1oxfAsbLQ1ftTELlzn
         vBPThXP3WO7Ywa7n6jiu37Naz9ZCuChtcr808Ygs5N9yCz2myeSbbgcAl41ncvHYmc3F
         x9RRBI1/GIHia1MfWCT5wwNlzvkclKBeJOwN+QUUBh6p5j1fZnNbEX24Yrn596aIoRex
         quJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mnQaO86LPw2v5BHeS49AN/uhNPbOqOlrwhHKzFx8Tc4=;
        b=dOOem8U6FjSnmj7YHqQd7PgfgW6A6QBSlEEhnvGurqquSEFr33NXOrDu1sjYiOgGXh
         k0UqtLuisw4UT5KIyQBzR+BKCnj+F3mwUvHJ6g+nxcLnLSDPUupgfL9RSbvAygImKwz6
         vVx76v9IlziASHFvWkTA+37HWRxGidkHDCZ/WoY+3OTDR8NkMTV7BbsGgES12IRXEQ8k
         3CIRBNPqcGHdwij4BXBsL0nqJTlCCpmpzwet6eRCLtsCX95eJlXIlNGo1GbIvaxoVHaa
         LmzsJL4S7n2DbJIhx1VZ/fG7grOxntCn4f3QAg0IfNcNmsMpaxxh6weRBdd4jTID+wjR
         ypgw==
X-Gm-Message-State: AOAM530H9dwU3PxlGRayu7HGu/4lKk2AnqMohSjn3yrWWDwgBXmW1nQX
        6N6CLlSx8BAQtpOJLAYX2w9OqsOissM=
X-Google-Smtp-Source: ABdhPJynlACqghUN9IwWOBiviHdheCNjpaWCbwuV75dYEi2nj1rc3OyDqV84VdNIJ71bzk5b+ddPug==
X-Received: by 2002:a17:90b:33c4:: with SMTP id lk4mr2332689pjb.157.1611241837252;
        Thu, 21 Jan 2021 07:10:37 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id bv21sm6298519pjb.1.2021.01.21.07.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 07:10:36 -0800 (PST)
Date:   Thu, 21 Jan 2021 07:10:33 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Brandon Streiff <brandon.streiff@ni.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Olof Johansson <olof@lixom.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/4] Remove unneeded PHY time stamping option.
Message-ID: <20210121151033.GC20321@hoboy.vegasvil.org>
References: <cover.1611198584.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1611198584.git.richardcochran@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 08:05:59PM -0800, Richard Cochran wrote:
> The NETWORK_PHY_TIMESTAMPING configuration option adds additional
> checks into the networking hot path, and it is only needed by two
> rather esoteric devices,

Correction: there are three legitimate users of PHY time stamping...

> namely the TI DP83640 PHYTER and the ZHAW
> InES 1588 IP core.

There is also net/phy/mscc.

Thanks,
Richard
