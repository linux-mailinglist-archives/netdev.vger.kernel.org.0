Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F0B368864
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 23:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239440AbhDVVDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 17:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236877AbhDVVDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 17:03:44 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60900C061756
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 14:03:09 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id e5so17468645wrg.7
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 14:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i7DD+/0KtDzlOaM9CNLggbeaur6RPNbh2vfq3OSjo4k=;
        b=GVMAvXnjeI+4q2pu8ek5Clft9BpJalNSCU7fpRxYERIhVqUmfo5Bbp2Fit2GK684gd
         58/VnHDidnXJqnvug2d8wdD7UZGXLimZ2/tthfF20o+au9dVHU1USkvO1uNVV2VU+ijl
         YAF9m4GByK4p+ALe6IrwModahB+ycvddEiX+AiT2cjFlwkRADCEsvNH6GN0uv1qBMHmu
         oVe8SWoERhbqtDQFG4L8MPl38Ys8nsTdr7PEq4Bd9ZYbIUnDo1Vh1DLJIfydyAycam6c
         BUqohUL+sWqEutLAeah9++XJRQCYVlyXeoSLpWrYIKuLU1urB3EIsuNKTE0ABhQa4bcu
         qncw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i7DD+/0KtDzlOaM9CNLggbeaur6RPNbh2vfq3OSjo4k=;
        b=FJ/2N0228tr8ULmcNAb5YDazadXDbhvV3G4i1AUG2RvHtYV4mm5/2AK/uvcJvRVNkO
         DMRW5SPVck895LUy/RDMEFcnc3fEPrjTdHZv5KHBoAUhbzELdwT3/nWAwJPGkL1C8JsL
         TX3sXcI8SXDFdqkpyRI3NchZqOSklEBVtiX8DbS5QPN4nehYNVeXDVq4/vegIXooGzCu
         iSeeVwti3i7zOfMUg1dxXOcTpmSd0HpSKOhGzAz0Q8+KRwNH7Sp7rGzJPrmmkzH5l4dG
         qOFNEPPEYSm1yZ+KbuqsQY8NIw3HMvNhL8b+7FvFZ7F1mEQ79gRSHSh9hISrsao6+hVL
         J5Xg==
X-Gm-Message-State: AOAM530ezht7JShcjye/zODbPcs6/tUgayNCAa99SSKz9zjMEQ4hF6rk
        0PPhacZ2bBQwaNsolFeqJEovug==
X-Google-Smtp-Source: ABdhPJyP4PM08VW2GpqI2yf2qrFoZbJ0W68KrhSrQELrsCW61J1Qx1koCs2sBy/5Ijbm2dMuuC8iVA==
X-Received: by 2002:adf:f6c5:: with SMTP id y5mr331389wrp.121.1619125387926;
        Thu, 22 Apr 2021 14:03:07 -0700 (PDT)
Received: from equinox (2.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.a.1.e.e.d.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:dfde:e1a0::2])
        by smtp.gmail.com with ESMTPSA id t6sm5417054wrx.38.2021.04.22.14.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 14:03:07 -0700 (PDT)
Date:   Thu, 22 Apr 2021 22:03:05 +0100
From:   Phillip Potter <phil@philpotter.co.uk>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: geneve: modify IP header check in geneve6_xmit_skb
Message-ID: <YIHkifgWY2zzvuZ9@equinox>
References: <20210421231100.7467-1-phil@philpotter.co.uk>
 <20210422003942.GF4841@breakpoint.cc>
 <YIGeVLyfa2MrAZym@hog>
 <CANn89iJSy82k+5b-vgSE-tD7hc8MhM6Niu=eY8sg-b7LbULouQ@mail.gmail.com>
 <YIGv+UOHIl8c/JVk@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIGv+UOHIl8c/JVk@hog>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 07:18:49PM +0200, Sabrina Dubroca wrote:
> 2021-04-22, 18:52:10 +0200, Eric Dumazet wrote:
> > On Thu, Apr 22, 2021 at 6:04 PM Sabrina Dubroca <sd@queasysnail.net> wrote:
> > >
> > > 2021-04-22, 02:39:42 +0200, Florian Westphal wrote:
> > > > Phillip Potter <phil@philpotter.co.uk> wrote:
> > > > > Modify the check in geneve6_xmit_skb to use the size of a struct iphdr
> > > > > rather than struct ipv6hdr. This fixes two kernel selftest failures
> > > > > introduced by commit 6628ddfec758
> > > > > ("net: geneve: check skb is large enough for IPv4/IPv6 header"), without
> > > > > diminishing the fix provided by that commit.
> > > >
> > > > What errors?
> > > >
> > > > > Reported-by: kernel test robot <oliver.sang@intel.com>
> > > > > Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> > > > > ---
> > > > >  drivers/net/geneve.c | 2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> > > > > index 42f31c681846..a57a5e6f614f 100644
> > > > > --- a/drivers/net/geneve.c
> > > > > +++ b/drivers/net/geneve.c
> > > > > @@ -988,7 +988,7 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
> > > > >     __be16 sport;
> > > > >     int err;
> > > > >
> > > > > -   if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
> > > > > +   if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
> > > > >             return -EINVAL;
> > > >
> > > > Seems this is papering over some bug, this change makes no sense to
> > > > me.  Can you please explain this?
> > >
> > > I'm not sure the original commit (6628ddfec758 ("net: geneve: check
> > > skb is large enough for IPv4/IPv6 header")) is correct either. GENEVE
> > > isn't limited to carrying IP, I think an ethernet header with not much
> > > else on top should be valid.
> > 
> > Maybe, but we still attempt to use ip_hdr() in this case, from
> > geneve_get_v6_dst()
> > 
> > So there is something fishy.
> 
> In ip_tunnel_get_dsfield()? Only if there's IP in the packet. Other
> tunnel types (except vxlan, which probably has the same problem as
> geneve) ues pskb_inet_may_pull, that looks like what we need here as
> well.
> 
> -- 
> Sabrina
> 

Dear Sabrina,

Thank you for your feedback. I will try and rework the patch to fix my
original commit using the technique you suggest.

Regards,
Phil
