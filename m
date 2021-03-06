Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835B632FABA
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 13:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhCFMyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 07:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbhCFMyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Mar 2021 07:54:31 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8BD4C06174A
        for <netdev@vger.kernel.org>; Sat,  6 Mar 2021 04:54:30 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id d13so6922555edp.4
        for <netdev@vger.kernel.org>; Sat, 06 Mar 2021 04:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gXweVSUi66/ZX4HYvRUE1segjxvOGKIYeCf95q4g0Qo=;
        b=sepyIE7qMKOVw1pltUQ6Ej7h55qFkXtZCFOe3bepApgSzQHRcB/nVRsuGu/0tNdTWJ
         IOiNvmRmAzjmf5BY4XWe58nHXuGZRmRtUP77DQEZIccRdU8dYqDFwiSvxfo5yqD/CMwU
         aHQnbhnmolKY4X2ZWN/Ja4niYC63IhBSZHQH42RPUW1uM9V6M8bM1Dlj+tcjzQDZwDo3
         +Do9lBiU+3ynpLSSrkZmDGYeEIGsJMNl5ftZsPZEgCPeS9c3OjwAp9T8tc8fm5GCT3mc
         fC1Z3O6ShfQOPsua/gmlpkjF7+eO0tnU3QTcAUh+8J/F0mKtCygQiCzzdAb4+mtvUQUb
         K8Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gXweVSUi66/ZX4HYvRUE1segjxvOGKIYeCf95q4g0Qo=;
        b=lICelGVwKzJUudxBEEkvXcyBw3pHkBAYaXOFgD8NcQGKZ0aedctK3apQYeezzUQvJd
         cOSm6WQfbSHkqURd3WKdnWjlZw8ypF0O4y1o+KTIbAahDq8DIQXfFnANQnegIziniadg
         Eoep1GJEXz4bF/fTeTyNoKEd99fh4P3esP6M5gFxpIHgxRV4VO/C1pw02cZiav8kI2j7
         cmbIB6kBMdqhPDJycuy17YQV+aqfbXfES5qj/j9161M165L8ipt6WPzvt71/5JAPrF7i
         GBdbSYlJKRIaaTnVfb4Vvq5jtkboiYipHeHfdZvj45NRGP/7saUNSneHIZp1SX7g/KeV
         NW6w==
X-Gm-Message-State: AOAM532pSM1TcYI4CNi2X7Lb2foUmjksOwCipuzNNLLpDQ6fqTa5xEDV
        +U3Ol1d1OtWFsMiaAAV2aeo=
X-Google-Smtp-Source: ABdhPJzbzmA41vvbdR8kIUcrIVHX11GDw++YW2T7zCNcGkhq7Yda2wpfBX8kC+2tqMoF3goA414gQA==
X-Received: by 2002:aa7:c450:: with SMTP id n16mr13337512edr.16.1615035269353;
        Sat, 06 Mar 2021 04:54:29 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id k26sm3192906ejk.29.2021.03.06.04.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 04:54:29 -0800 (PST)
Date:   Sat, 6 Mar 2021 14:54:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        George Cherian <gcherian@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: Query on new ethtool RSS hashing options
Message-ID: <20210306125427.tzt42itdwukz2cto@skbuf>
References: <CA+sq2CdJf0FFMAMbh0OZ67=j2Fo+C2aqP3qTKcYkcRgscfTGiw@mail.gmail.com>
 <20210305150702.1c652fe2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CA+sq2CfwCTZ1zXpBkYHZpKfWSFABuOrHpGqdG+4uRRip+O+pYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+sq2CfwCTZ1zXpBkYHZpKfWSFABuOrHpGqdG+4uRRip+O+pYQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 06, 2021 at 05:38:14PM +0530, Sunil Kovvuri wrote:
> > Can you share the format of the DSA tag? Is there a driver for it
> > upstream? Do we need to represent it in union ethtool_flow_union?
> >
> 
> No, there is no driver for this tag in the kernel.
> I have attached the tag format.
> There are multiple DSA tag formats and representing them ethtool_flow
> union would be difficult.
> Hence wondering if it would be okay to add a more flexible way ie
> offset and num_bytes from the start of packet.

How sure are you that the tag format you've shared is not identical to
the one parsed by net/dsa/tag_dsa.c?
