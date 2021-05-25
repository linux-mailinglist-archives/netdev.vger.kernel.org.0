Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D105139000B
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 13:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbhEYLem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 07:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbhEYLel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 07:34:41 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B990AC061574
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 04:33:11 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id l70so22505854pga.1
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 04:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KpDAB8+n/z2L32mF0SJ4X9NzufY3+D/rm+knFPNIffE=;
        b=fTUsRSsPTawLLHwcej5TiUUeNYNJEBhNe92jxjmw4Ntmp3mojm5gCrEKYmnrz0QZ8F
         cGWLXi+z5U94LtloBYg3BekeO3i/dVsqglB8zXg5mBCs4+HwhgYYmmF19v2HIEWErNPT
         7n9B3VIyr9IoWwz9OXuEQokPhfCG8YCvvIyNJ3KBlpEv3+8GNt349luDj5FTcP3UrRJl
         xEOnwVFPsPYg3cd8W2dSK91icFElEbfFbwEEvwJxFnHZwd5r2LnNg9zvmZYApqPK9uaL
         AKsOVv5FBpjlXrBtsYa9j87c7BlrWBbwbMICH6xk+kyK/lY+znbjgwKxrodrxSwgbZea
         8e/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KpDAB8+n/z2L32mF0SJ4X9NzufY3+D/rm+knFPNIffE=;
        b=esKV9RCVCiSYKugVQV7MhD1jsIfD35CTS75mJTIDH/EEDS2Z/CmWUcd78nEMYnMwrm
         nqfAp1+xSvBNdxqju5g/t0TvayrjVWbYrY8svfKKr3UAwQ1ZlrSHiIB/h93MV64HWuK2
         aD0YuuJZHMFqaXwg/HpQlf2pskosDw0Z+8FaTUldLVNbHWfFUnqYVcKWIiCD4k3d5ZGg
         JSBfgZ7vN4VWesy0UIVQVa4YrG9Jl7p3dHWGymItj3OizNFD9D2alFLFxIm1IyOPl40j
         x1/TelKf6OFi1QxC6a83d1Twgm7zQcN3StbTyT6gAToYsbD+Z5Pq/M1aaUpu/fcrqsA8
         R2jA==
X-Gm-Message-State: AOAM530w08AsNfcaI0jchwSQpub9YqYCaBZz7wSCNGG3xqefk0EuA0Xc
        p3QHfjPZTP93e2tIGJzRanyk/vvdPRQ=
X-Google-Smtp-Source: ABdhPJwaGY+Dcr066MGA4dTpFL+zdhqUElLJHhjcT44nw6jKY1KqyjrSFU9FxlyEEdtWUQKSQ4jRDw==
X-Received: by 2002:a63:d744:: with SMTP id w4mr18733949pgi.76.1621942391397;
        Tue, 25 May 2021 04:33:11 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id s65sm12481107pjd.15.2021.05.25.04.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 04:33:10 -0700 (PDT)
Date:   Tue, 25 May 2021 04:33:08 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next, v2, 2/7] ptp: support ptp physical/virtual clocks
 conversion
Message-ID: <20210525113308.GB15801@hoboy.vegasvil.org>
References: <20210521043619.44694-1-yangbo.lu@nxp.com>
 <20210521043619.44694-3-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521043619.44694-3-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 12:36:14PM +0800, Yangbo Lu wrote:

> diff --git a/Documentation/ABI/testing/sysfs-ptp b/Documentation/ABI/testing/sysfs-ptp
> index 2363ad810ddb..6403e746eeb4 100644
> --- a/Documentation/ABI/testing/sysfs-ptp
> +++ b/Documentation/ABI/testing/sysfs-ptp
> @@ -61,6 +61,19 @@ Description:
>  		This file contains the number of programmable pins
>  		offered by the PTP hardware clock.
>  
> +What:		/sys/class/ptp/ptpN/num_vclocks

How about "n_vclocks" to be consistent with n_external_timestamps, etc...
