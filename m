Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86988347D3C
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 17:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236933AbhCXQCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 12:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236923AbhCXQCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 12:02:34 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53599C061763;
        Wed, 24 Mar 2021 09:02:32 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id hq27so33749432ejc.9;
        Wed, 24 Mar 2021 09:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p0h1I2tU40MVEe/iq0GPb6BvRGF0+jimshHBcD8Y96o=;
        b=UYxL1aPIIPS7dZJFvNFh6Gi7rWcPCnq0LT08QW+F6/HZXq6mbwF8gr9DEQ2z8ZgO7r
         dZ31Oe2JgNLZIf9KX+4S0UvQ7V8y9v2n7/jYvHfNHjm2k15HIuaVceJG3qkJg1EqLtPB
         LkJ96zui76hJkuznZNalH0tvK4QFSp9k7YTqifqDGJAnCze1bamfgvt+N2oHMM8ldjPu
         Ibf1rMbmngk1Gbhy79F6gTXVORnLsE2VieIu639CP+HpZeC19nu8SkRsMO9cIKc/fXhr
         HaXgNOl1e9UXZKneUfj9dHbbQG9e7QOTVv8j6soU7b+hOIsDZOXsCYmgAqip8RCJmcy3
         ZAGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p0h1I2tU40MVEe/iq0GPb6BvRGF0+jimshHBcD8Y96o=;
        b=gfw81uvtx1dEaEV1PKTswviesaNawjfHlt+SNfYOmqpOOJOwHfFP6iQZAlOYC5Z1dO
         oC7stNdbR20J6RRloF4jn7rjhYsywgxA0W9qxymbiBGXd1MiQz7m/Ktz+ikAoho+vo3n
         yAToG1Wn5YhF/hq14d5/U6HKHcXbXqIOW1OT4rlJAD8KYGDLYs0ZZV8BQU8Wxf7H1x5X
         8lNAeN73sHHg7pCFKwFq24sZV9iYuwYpU2RHkDvJuEaXjqQFfdl/Mi9lI7ghslvTg0yG
         6fyLb0BrZ6kmKPVDtWVP9rRmfGBhwdzX4AAGIfnrfzCIC+VgUFQrbCOdEUzFfeh3yoD/
         WcjA==
X-Gm-Message-State: AOAM530uQpkOjUYIR7VDRr+ClzmYVUociimcfy+Kc6J/iVqqNUvz3lSK
        TCeIrEaBr36HN+75vTwP5j4=
X-Google-Smtp-Source: ABdhPJwpUavXt4EHnTzT+ae8zvQSOiy4MHaEHtHWR/X63xNd+NtmzaX78oG8X3nz4lj7OuTgsBJ6zQ==
X-Received: by 2002:a17:906:9888:: with SMTP id zc8mr4575571ejb.310.1616601750960;
        Wed, 24 Mar 2021 09:02:30 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id si7sm1131470ejb.84.2021.03.24.09.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 09:02:30 -0700 (PDT)
Date:   Wed, 24 Mar 2021 18:02:29 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: bridge: Fix missing return assignment from
 br_vlan_replay_one call
Message-ID: <20210324160229.cyzepir5fnfnfeox@skbuf>
References: <20210324150950.253698-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324150950.253698-1-colin.king@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 03:09:50PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The call to br_vlan_replay_one is returning an error return value but
> this is not being assigned to err and the following check on err is
> currently always false because err was initialized to zero. Fix this
> by assigning err.
> 
> Addresses-Coverity: ("'Constant' variable guards dead code")
> Fixes: 22f67cdfae6a ("net: bridge: add helper to replay VLANs installed on port")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
