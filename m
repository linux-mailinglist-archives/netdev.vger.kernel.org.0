Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0140B36769B
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 02:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244339AbhDVA5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 20:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244333AbhDVA5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 20:57:32 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A0AC06174A
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 17:56:57 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id f195-20020a1c1fcc0000b029012eb88126d7so2164669wmf.3
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 17:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RMcxAc3bT3n/yl2vxPyU4HWbgYtisPNEV2uY9DSNfAs=;
        b=uwkenkncbsJESIBHS9mPWpBwvyg3x0Y2ZRUiFqWbb4Hwp3JBZIigH0fMlYr0aJGpOx
         O6lNQ7ye9ZSMQbHaiM8Jb3G9WDUd8T38/c4FXBbjrunpJFRtkqM7RgFHrXPLFpusu3CN
         Q23bp1SSV0UfrTI3zwfZD06d2o1ZPY3uYvA/+0xgXUMeUdHk/gNiAb6RpEexxRgsweiX
         GpdjFcxSFdEEPvr8sQj3ZwAcLj0u0Zb7hygS0LdtCqZm/gEH8ZuDZOVfpAC3cvgDBpyi
         a2tg4yw7L/4qq6YqeETTcEbir7zUc63pfYx1CxeND0bN1QaS5meNiL28mbAriAH95ecZ
         f+KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RMcxAc3bT3n/yl2vxPyU4HWbgYtisPNEV2uY9DSNfAs=;
        b=B3noIoHdp7RotLeEGOoMpgR3N046Yc/AnGYPS28yScOSKCJ4g8gXdqLVA9UPSxt+Ox
         4vE2nwsWoaG7w00oBYFh8u/RBGxZ7fQBeBSIGjnCwlO0iT5/JAJ5/k3uwhyo15Gphk2O
         paXXlZKjEMrBxLzsJAwwlvGxJnS+mXDjFf3uNJzTvVhL8tzNgMGcTwgoHbBhK2bL5OfF
         NpfzMqwLIwRHbHTHyq2K+W51+n/zlDpvjy3f3KJkUG+RWPMg3PObKRgai/kY35Gb+b7m
         QrlycGko6aRI3GLPwVhIIebfwqiNwCAeu7r1Foq41+a99f6AUvuK5alZFZn/xosce8On
         ncUg==
X-Gm-Message-State: AOAM532PNXFyZi1dqZwqWqv7bAy55RkHPbRXZmm43RZvzNLu9s9jNMUM
        IiEkLY3QjuJ4ONgUWlDvw0xRPctHOmjj9SGH98x7Zw==
X-Google-Smtp-Source: ABdhPJwa2X16yYGlY7mpYZUMIE4Q1frqLxkxXFcI4ayr7tXXg3G5lZFma6Cj87jRvVWBIKuiZRV3wA==
X-Received: by 2002:a1c:e006:: with SMTP id x6mr12666139wmg.40.1619053016353;
        Wed, 21 Apr 2021 17:56:56 -0700 (PDT)
Received: from equinox (2.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.a.1.e.e.d.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:dfde:e1a0::2])
        by smtp.gmail.com with ESMTPSA id v4sm1179807wrf.36.2021.04.21.17.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 17:56:55 -0700 (PDT)
Date:   Thu, 22 Apr 2021 01:56:54 +0100
From:   Phillip Potter <phil@philpotter.co.uk>
To:     Florian Westphal <fw@strlen.de>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, edumazet@google.com
Subject: Re: [PATCH] net: geneve: modify IP header check in geneve6_xmit_skb
Message-ID: <YIDJ1npZ7h4Vt0mi@equinox>
References: <20210421231100.7467-1-phil@philpotter.co.uk>
 <20210422003942.GF4841@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422003942.GF4841@breakpoint.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 02:39:42AM +0200, Florian Westphal wrote:
> Phillip Potter <phil@philpotter.co.uk> wrote:
> > Modify the check in geneve6_xmit_skb to use the size of a struct iphdr
> > rather than struct ipv6hdr. This fixes two kernel selftest failures
> > introduced by commit 6628ddfec758
> > ("net: geneve: check skb is large enough for IPv4/IPv6 header"), without
> > diminishing the fix provided by that commit.
> 
> What errors?
> 
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> > ---
> >  drivers/net/geneve.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> > index 42f31c681846..a57a5e6f614f 100644
> > --- a/drivers/net/geneve.c
> > +++ b/drivers/net/geneve.c
> > @@ -988,7 +988,7 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
> >  	__be16 sport;
> >  	int err;
> >  
> > -	if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
> > +	if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
> >  		return -EINVAL;
> 
> Seems this is papering over some bug, this change makes no sense to
> me.  Can you please explain this?

Dear Florian,

I made the change to fix failures in the following tests:
IPv4 over geneve6: PMTU exceptions
IPv4 over geneve6: PMTU exceptions - nexthop objects

Error for both tests was:
PMTU exception wasn't created after exceeding link layer MTU on geneve interface

I was notified by the kernel test reobot due to the failures being caused by my
previous patch to this file. Sorry if I've done this the wrong way, just didn't
want to hold anyone up. I also tested the patch with syzbot again to make sure
it still fixed the original problem from my last commit.

Regards,
Phil
