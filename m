Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66981360FD4
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 18:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbhDOQHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 12:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbhDOQHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 12:07:08 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637B3C061574;
        Thu, 15 Apr 2021 09:06:45 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id n38so16374482pfv.2;
        Thu, 15 Apr 2021 09:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m2XpvcgrsRqRFB4678HXPjifJZCFXJAxagMfKGWNKUw=;
        b=WDdnt/Ov3HK+kWroYo45UkEJDSV/XxOWo1TMHxxfSKH5lC/BCN/csprfnErsnaQ/j4
         tJWuC9A1hlvu+kKpeu3dSU1VmeNita0D+Px7fxWTqCcOB9ABjDXlgb4NXj1v6i7RQChA
         cObRxG5Q9HAf2DUgNQEKKRN7Qd6FiMY/iJU4dhAhTvCs4vxYlb1xyjeBthGa+ZkLCIze
         n00/ml+0Mx7G5O7EYkgbgwq1yxtyvqWjNrE9lf1tX30yu8sH4gWWZSpP2saAHpjq7Um1
         8nFwZI3STcxuC2JRXIkcxtubBfUi3gazNR3ztayeImcj6zN8am+Y4VfltxZsX6iZUPOW
         PCUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m2XpvcgrsRqRFB4678HXPjifJZCFXJAxagMfKGWNKUw=;
        b=uIg3HNlRv4kv2/iglAh0kHzZ/d6pCRxD2rbhhC18ScmQxiY6Nc2o8LiYtmtEFYUfAh
         e8LV+GbZqEHKke3xn2H9oEWph33bRi08dyYJLDU38MJSVIvVeis6fGnpL7GJtK9tcCl9
         hh0zt6dqhkpYknwq6diyKMFoNNa7Vkv7s6lG+9stdjEXTf15ACmLam7nF0PdYds3JwAv
         789Nc1Z9kSLWzZFVC1bMHvpxtvrHvvBycuYgfXCSozfhUIWYpYtwOoQ02pRBx7rzoxCA
         KYooZmnlCFZtyc6QhyetfaYAMY0IbjSofiy3W6v8TbyNe5RGNn/Kuc+6dbTf8oCK8Q/g
         D4UQ==
X-Gm-Message-State: AOAM533sCmZnoN26WglpljokM1EKDD7MBcJBP7BvUI21oVJEyvGY8n1B
        Y+ZbGqQn7ZfHCjS0QN2+vA0=
X-Google-Smtp-Source: ABdhPJzDK5B1l+vYd4aIQO3uRvmPCA1psufHiwR10kbPEN0mdWBpCEqOCkIK8vR1qpAjbWml/QJMzA==
X-Received: by 2002:a63:1125:: with SMTP id g37mr4062104pgl.56.1618502804950;
        Thu, 15 Apr 2021 09:06:44 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id l62sm2522229pfl.88.2021.04.15.09.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 09:06:44 -0700 (PDT)
Date:   Thu, 15 Apr 2021 19:06:35 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/5] net: dsa: mv88e6xxx: Allow dynamic
 reconfiguration of tag protocol
Message-ID: <20210415160635.t32xgj5z5myag2pb@skbuf>
References: <20210415092610.953134-1-tobias@waldekranz.com>
 <20210415092610.953134-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415092610.953134-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 11:26:07AM +0200, Tobias Waldekranz wrote:
> For devices that supports both regular and Ethertyped DSA tags, allow
> the user to change the protocol.
> 
> Additionally, because there are ethernet controllers that do not
> handle regular DSA tags in all cases, also allow the protocol to be
> changed on devices with undocumented support for EDSA. But, in those
> cases, make sure to log the fact that an undocumented feature has been
> enabled.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
