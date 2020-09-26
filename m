Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB6C279B84
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgIZRpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgIZRpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 13:45:17 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A15C0613CE
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 10:45:17 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id z23so2802507ejr.13
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 10:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JUhppgIecogjJ2wLkwWrjPNDFhCDSFKJXyRHlSS4b3I=;
        b=UP4ao2R0NINF0hDr3ZYnj8rtHgyZiTHjNTZkxye5QuSeF3RFmM7Aj4Uji6xIygoaz9
         9z15op4zDHNVX6DfSy2PP5JGutpTIv+emxo6YsGbYbYNc9CiDJhywtIYBzkygPHJ0dVe
         3CDn6Gi6ijL1kFLaGatcT0cl30UJ6gdb3yoEs5VpNsjgvq8amuAOwL0GW4YuhoMaJHpQ
         CgyrLNS4Lk2Km7VMEQutv3MKtOqZ338FZBWHjqmXF6eTy5IOsoRTE8jVVV6YiVlndiRM
         83wHH19SsfRkNaP9S0iOfuAjKJ3PKDD2G5anWVMx5xaAxODFRo5NvshsCaDVXNK6cN9+
         zIYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JUhppgIecogjJ2wLkwWrjPNDFhCDSFKJXyRHlSS4b3I=;
        b=AxDMxO4ON9T9cRmS4nDOIbP0bprAGK5HgdRckWysDKHnbcZ1IKRxzMVXXXmyM9AzQh
         w7MfNs0v7wu6ct3gDc8Ndp0NeRAsuIq0EIBYVWoyYLQhSz2WtCFyF/blnuizVbFXborv
         G3Ise2Vh8s0JxK97tWUfGNVywyotTgRoFm8X9OvmGYycLlwdqKiJTHzdJMkRuZD1Vu0Y
         xhTbRGLCC/ueEAGYA0PO2vjjq0HvPEgmI8aqAfHQ1WedSQ2bJyIRqaM2VI4bWHvFEgwC
         OVyKGRuA/lNhduKQhM1IfwbmJqLK6Ru34+Rrv80dgo2TZI4NFK2nmqEdcrQuroMs+UT4
         uAcQ==
X-Gm-Message-State: AOAM532sNFTc8Ur4RhDny8lvSgbkltspt7aM2kp54s8xjdN6G8qUpTwX
        +f74/1iVZJM8A8MCG9Zpx5c=
X-Google-Smtp-Source: ABdhPJzVZxEkcP6NIrJCLVqsBaI+DtDjAFRwA1yomRaJ8HSn+t7RMp7L1/nsrCnMw/72gZ9BM+/b6A==
X-Received: by 2002:a17:906:344e:: with SMTP id d14mr8592625ejb.42.1601142316275;
        Sat, 26 Sep 2020 10:45:16 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id qu9sm4573430ejb.24.2020.09.26.10.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2020 10:45:15 -0700 (PDT)
Date:   Sat, 26 Sep 2020 20:45:13 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH net-next RFC v1 3/4] net: dsa: Add helper for converting
 devlink port to ds and port
Message-ID: <20200926174513.6nxpbmd3imaj6dwx@skbuf>
References: <20200919144332.3665538-1-andrew@lunn.ch>
 <20200919144332.3665538-4-andrew@lunn.ch>
 <20200920235203.5r4srjqyjl5lutan@skbuf>
 <20200926172826.GA3883417@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926172826.GA3883417@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 07:28:26PM +0200, Andrew Lunn wrote:
> Hi Vladimir
>
> Just finishing off the next version of these patches, and i looped
> back to check i addressed all the comments.
>
> This one i tend to disagree with. If you look at DSA drivers, a port
> variable is always an integer index. dp is used to refer to a
> dsa_port.
>
> If anything, i would suggest we rename dsa_to_port() to dsa_to_dp(),
> and dsa_port_from_netdev to dsa_dp_from_netdev() or maybe
> dsa_netdev_to_dp().

Maybe it's just me, but I don't like the "dp" name too much, and I think
all conversions of those functions sound worse with the new names.
But you do have a point with the inconsistency, so I suppose you could
leave the name as it is? Or maybe dsa_dlp_to_port() if you fancy that
abbreviation for a devlink port?
