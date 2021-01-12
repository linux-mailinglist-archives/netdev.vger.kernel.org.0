Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887432F2D42
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 11:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbhALKyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 05:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727730AbhALKyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 05:54:41 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA514C061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 02:54:00 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id g20so2894337ejb.1
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 02:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=rrPJamrWyO8ERbZGTpnTQZtUSeEPcJD16qdKKOE8csc=;
        b=KSJilCKIYbvNOKU/vIkKhlycwlVH3Chkb5DI5HoTbWE6D2TPgJFFoyLrxayYEuRs+C
         xJYv8y4oY/GX5W0HdoILZK+etS3YRTxocWg2I/rTuQ6XrZn2RbtGGKTEq0G2NjvMguxz
         CbtnRTZfKHNmSjQcQq5LHl/Tdip5fOR75CiLy0Gy8pR/6cuZMc9JqD1V1HENnmTnAlwc
         8uQciJImUjPN+sCnE9raIB7fRprc+TL+K+BXe+38AQGxSH2rXZtpTi+rAaqVTkKuYaO/
         EdEQYClZs41W+kYrT8ftRTrbbWOaPx5dKoKpXhVSfZ4TtiSnHw8OE7mK09zVLH5T6Vqs
         H3yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rrPJamrWyO8ERbZGTpnTQZtUSeEPcJD16qdKKOE8csc=;
        b=fWyQhyB77HVWCRpA+RsrGu47/h56brygdLXmiuGyWzEWASxZeXHxwcwvLMms3nJyVP
         B6l9H2N7Yf6SdHzwxk+HqHbj2K5jyGqBK+Hfw6B0HFESZ5qn8lbFVyubXfX6i63rQHaf
         vUDce2KNSTbiiwwrkAhqAwX7duoZ/vsNaAWm6BCSAaT2tAAUtb1b7Y5jrn+p8zGblpoc
         hwQ+d3EMyd4pe0FzK2vnF/F1rQir/ShTaDx1f/h2YFQH6dXn1E7gE95g4fjvOAqIiSdk
         XWjwtlhaA5RLvbMEoKXlBhSjAOCigzB6xHvLkaowUXOsGzsK0asP1nPdnRis6xNA1jEA
         Z7xA==
X-Gm-Message-State: AOAM531DIijAJDCLzsAOJiV5VxMB65rm1mDId+36DZssjzrO+LvPSQMl
        AETWpglZ9nRP0iWeeGe/CBI=
X-Google-Smtp-Source: ABdhPJxW4DC+TEiFpMLEO9yjg4cBRLlEtCOm8ojTMIQwKeQ0S3p9fFMI7Oycq6ZwfoGfuG5i1WdKLg==
X-Received: by 2002:a17:907:11ca:: with SMTP id va10mr2638406ejb.78.1610448839407;
        Tue, 12 Jan 2021 02:53:59 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id qu21sm1025811ejb.95.2021.01.12.02.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 02:53:58 -0800 (PST)
Date:   Tue, 12 Jan 2021 12:53:57 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        lkp@intel.com, davem@davemloft.net, ashkan.boldaji@digi.com,
        andrew@lunn.ch, Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v14 3/6] net: dsa: mv88e6xxx: Change serdes lane
 parameter type from u8 type to int
Message-ID: <20210112105357.sjlz27pjlqrnhia3@skbuf>
References: <20210111012156.27799-1-kabel@kernel.org>
 <20210111012156.27799-4-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210111012156.27799-4-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 02:21:53AM +0100, Marek Behún wrote:
> From: Pavana Sharma <pavana.sharma@digi.com>
> 
> Returning 0 is no more an error case with MV88E6393 family
> which has serdes lane numbers 0, 9 or 10.
> So with this change .serdes_get_lane will return lane number
> or -errno (-ENODEV or -EOPNOTSUPP).
> 
> Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Marek Behún <kabel@kernel.org>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
