Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA4F264E23
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgIJTCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgIJTBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:01:23 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13954C061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:01:23 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id w1so7458356edr.3
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5ycr6q3fkBzuLTStCwqMPLmdVxFhIPUVk70kzrdKZ04=;
        b=X2kVtQe9mZCpFJ0l7b8BFFj5Or+jR4vsDpOIpB2fVOJ+acZU+F0Ze+9Zs8Q+DI7/Ho
         ISxdNXWlCOI372T6SxJB5mg1Oo4UqpZMWbqOStxQQ0Ls5Q6k14TMKpBn7LfhM8yQv0rf
         YgAHQN+IiBqn69e/pyRB6KFD07zjfkExQVX1CbfLkR/NcP8iQECmdNaVEMi/O6IEJIFV
         LWK5BNJn0x7yl5+a8RF16vwCEXEhlviekW8sB2EV+3SLfjIAk7yYTJi9gOpFEhwRr71r
         7a7VNyxUPV7MO01Li4nTMCBN21fLdADQ/xvJWHaHwJBxN+kqiOomsPLm/Nb2D7YuB+hB
         8oaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5ycr6q3fkBzuLTStCwqMPLmdVxFhIPUVk70kzrdKZ04=;
        b=i1y4ZPoFQnYGEOdH43a4KwutRFS8DKw8Dza5y6FkueqJ9YBPGSuZP1KusyQOjGyKkd
         sit5wuke+W29y6QRY+04QPyv1A+LOrZNZaZFgiY7NTy0jKXcebK8KqDlPeptvyQdPbfA
         klFwcLSWZ873kR7iYIiNOVyHRhqExYUiUv5UAqgIRce02Q5X3N9XSmGJsPie6s2b7pm6
         DwQWWDRcrdPGEYO11YurBILV9hKRa7dRBXW8oqu/9F+qVidwi3IJ3KJWBGpcHNiyNVXZ
         KFF2rlZRE6bj7pcNoZiXSKTQ7KhcFUKeIyCP3g5+P4A2/YbUegXSVgNecK4jF4Y7gkhf
         Pu9Q==
X-Gm-Message-State: AOAM532BaKYnvPVR+ioej2Hz5VIU7gQY6jcuFqxogYUrhnAW4zBKALWm
        5I9QcN9CzOgFGYS4F64LN5g=
X-Google-Smtp-Source: ABdhPJylcMr+HJkhU665COd7293VAMH/X+lOtsjJ29Fscw8f/W0JfYJTuZd5apTT7+jEF074LOMelg==
X-Received: by 2002:aa7:c70a:: with SMTP id i10mr10980511edq.218.1599764481732;
        Thu, 10 Sep 2020 12:01:21 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id b6sm8355802edm.97.2020.09.10.12.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 12:01:21 -0700 (PDT)
Date:   Thu, 10 Sep 2020 22:01:19 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: VLAN filtering with DSA
Message-ID: <20200910190119.n2mnqkv2toyqbmzn@skbuf>
References: <20200910150738.mwhh2i6j2qgacqev@skbuf>
 <86ebd9ca-86a3-0938-bf5d-9627420417bf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ebd9ca-86a3-0938-bf5d-9627420417bf@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 11:42:02AM -0700, Florian Fainelli wrote:
> On 9/10/2020 8:07 AM, Vladimir Oltean wrote:
> Yes, doing what you suggest would make perfect sense for a DSA master that
> is capable of VLAN filtering, I did encounter that problem with e1000 and
> the dsa-loop.c mockup driver while working on a mock-up 802.1Q data path.

Yes, I have another patch where I add those VLANs from tag_8021q.c which
I did not show here.

But if the DSA switch that uses tag_8021q is cascaded to another one,
that's of little use if the upper switch does not propagate that
configuration to its own upstream.

Thanks,
-Vladimir
