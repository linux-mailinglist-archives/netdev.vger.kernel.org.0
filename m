Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C89F83840
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 19:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731603AbfHFRvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 13:51:54 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34314 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbfHFRvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 13:51:54 -0400
Received: by mail-pl1-f195.google.com with SMTP id i2so38187619plt.1
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 10:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=0dCYKxO0i5wM8chJrpv9Lr66yY1cuUfg/GxcnS+h9ko=;
        b=bOz77KMMCkgVMN/+CTj9r5zDUBGUCp3SjhSe5q2qTNUFuL9MijVh6NPo0SgRCuPkWt
         QA1MZW7/BoeUwtsii9AznBp+I+NawMy57neDiKGYTIMXZzGpXA08lvpMY72av3v+5mx6
         nwByr70PiSHvAQnI0pAcYWPzdjBKALJ0r8VVujxiZHClyFU5OJY3VaQgFuH2rbwFCTKE
         8Hfy03MitGfCqmaNfA6HFF54HVdqDHQPsOs08VxkP9fothqLBoQ5amdp+NWqSwOZijr5
         82g4hzjyPYXa1OHaXTomNDMXWY9G6fnenMrIopL+SZad1nZnV+JxWpUcyZ7xYJMr8lPJ
         E5pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=0dCYKxO0i5wM8chJrpv9Lr66yY1cuUfg/GxcnS+h9ko=;
        b=BzBmdbvyIzsphkiWpKu9yYRpTlFanEKPrt1N0vH/jQWwo56cfaIxULXgwqnoUugmM7
         aDCHUOCwkOC+DrNGQkk+6ngL8uv+O0aU8j3H4d5L1GPCvshr2A7D1/vxDl87NTzzLMC8
         fq1jdipVur/Ri7/qh8HXi/iOatIiEpRrJrCqos0ZPAWARfeCxR5VbmwvnImGEEWd2/ZH
         zSkBzICJbfndFQSbp4ED3B+gJQVUNL23v3vKSQR0a8L3XHpTWWiXFewnM9KCThBNyweq
         EtCD/rYy1r03E6CPBSRxscR++Z4ajgufRP0o0gCiDJLafvMKM4vssHsDF/YVfmvsAeFe
         +aew==
X-Gm-Message-State: APjAAAWoG1YBkpW/0v7IQEecRxvsIqQF3zy2+U8htNYCAALNSxNrL47X
        xoJJuHlaLaMOTGMVUxBfF14jCi4=
X-Google-Smtp-Source: APXvYqyvDig9V/mNvnyK3MZtIAwf7igZJQ6KTFa195kGIjnB7cllNOT/RErTxrkpcif+VSY/kk68tg==
X-Received: by 2002:a17:902:ba96:: with SMTP id k22mr4457852pls.44.1565113913204;
        Tue, 06 Aug 2019 10:51:53 -0700 (PDT)
Received: from ubuntu ([12.38.14.9])
        by smtp.gmail.com with ESMTPSA id q23sm18205893pgb.68.2019.08.06.10.51.50
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 06 Aug 2019 10:51:52 -0700 (PDT)
Date:   Tue, 6 Aug 2019 13:51:41 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Subject: [sashal@kernel.org: Re: Back-porting request]
Message-ID: <20190806175141.GA17852@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

How do I request back-porting of commit 5b18f1289808 ("ipv4: reset
rt_iif for recirculated mcast/bcast out pkts") quoted below? I think for
4.19, the following diff is needed in addition to the commit:

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index cd84f7f68032..120ef1f284fa 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1652,11 +1652,7 @@ struct rtable *rt_dst_clone(struct net_device *dev, struct rtable *rt)
 		new_rt->rt_iif = rt->rt_iif;
 		new_rt->rt_pmtu = rt->rt_pmtu;
 		new_rt->rt_mtu_locked = rt->rt_mtu_locked;
-		new_rt->rt_gw_family = rt->rt_gw_family;
-		if (rt->rt_gw_family == AF_INET)
-			new_rt->rt_gw4 = rt->rt_gw4;
-		else if (rt->rt_gw_family == AF_INET6)
-			new_rt->rt_gw6 = rt->rt_gw6;
+		new_rt->rt_gateway = rt->rt_gateway;
 		INIT_LIST_HEAD(&new_rt->rt_uncached);
 
 		new_rt->dst.flags |= DST_HOST;

Thanks.

----- Forwarded message from Sasha Levin <sashal@kernel.org> -----

On Mon, Jul 29, 2019 at 05:56:27PM +0200, Greg KH wrote:
> On Mon, Jul 29, 2019 at 11:42:34AM -0400, Stephen Suryaputra wrote:
> > Hello,
> > 
> > I'm requesting this commit to be back-ported to v4.14:
> > ---
> > commit 5b18f1289808fee5d04a7e6ecf200189f41a4db6
> > Author: Stephen Suryaputra <ssuryaextr@gmail.com>
> > Date:   Wed Jun 26 02:21:16 2019 -0400
> > 
> >     ipv4: reset rt_iif for recirculated mcast/bcast out pkts
> > 
> >     Multicast or broadcast egress packets have rt_iif set to the oif. These
> >     packets might be recirculated back as input and lookup to the raw
> >     sockets may fail because they are bound to the incoming interface
> >     (skb_iif). If rt_iif is not zero, during the lookup, inet_iif() function
> >     returns rt_iif instead of skb_iif. Hence, the lookup fails.
> > 
> >     v2: Make it non vrf specific (David Ahern). Reword the changelog to
> >         reflect it.
> >     Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
> >     Reviewed-by: David Ahern <dsahern@gmail.com>
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
> > ---
> > 

[deleted]
> 
> For networking patches to be applied to the stable kernel tree(s),
> please read:
>    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> There is a section for how to do this for networking patches as they are
> accepted a bit differently from other patches.

To clarify a bit more here: technically you're asking for a patch to be
included in 4.14, which isn't one of the "last two stable releases", so
that document will tell you to send that patch directly to us.

However, this patch isn't in 4.19 either, which is still Dave's domain,
and we can't take it in 4.14 if it's not in 4.19 (we don't want to
introduce regressions for people who are upgrading their kernels), so
this will still need to go through Dave.

--
Thanks,
Sasha

----- End forwarded message -----
