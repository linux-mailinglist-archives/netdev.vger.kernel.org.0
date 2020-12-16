Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CAE2DC88D
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 22:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbgLPV7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 16:59:30 -0500
Received: from sender11-of-o51.zoho.eu ([31.186.226.237]:21158 "EHLO
        sender11-of-o51.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729927AbgLPV73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 16:59:29 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1608155770; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=JQDHC4slUzBoij3RO45h9tSfbkrdDX/DnDYu/OOSmhF01mRZzTQ77fmvAQcTjOmcjUVfEInkUH3ZPJsGOwNI8PSFd5zR+pIopMhZazKlZHQMnlJUG0EJmalWAVl0EG2PTP5+ipO0B6CIy0McjLNV8f1RG1aemP2ypqznOKVHg2U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1608155770; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=mA9+hV2Q0BEvi4TvD4xEIsDLXIE3bNUfmVinRh7usW4=; 
        b=YjNp6NyE8U1VDhmjjed0jDfbHzoyU7en/OR9PzYz6mSREcLVCNwuulYuXNfLsEyYfyXfyy8WMuM9xy+4PQvWcW67w1eu/VEVzbbdbmMPivvGe/kTA++jIAaBatOLoSE1sQ1YLXCV4aRn5glGcKi8PefEP8w5i1kbMbGBXKzjk3k=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        dkim=pass  header.i=shytyi.net;
        spf=pass  smtp.mailfrom=dmytro@shytyi.net;
        dmarc=pass header.from=<dmytro@shytyi.net> header.from=<dmytro@shytyi.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1608155770;
        s=hs; d=shytyi.net; i=dmytro@shytyi.net;
        h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=mA9+hV2Q0BEvi4TvD4xEIsDLXIE3bNUfmVinRh7usW4=;
        b=fjWptFniiq7UpORPXJDFPqIvLH4sKZTxbJW4aX1ndZy8bZNsR48fRfcKCbe6I7PG
        XpWDJT1Hzd3MFWC8c9VL5x8V0Rd7496baj+GQDFC8HR9m/QfBAw7feDpAT3hJmtzz9J
        7Yp8wF1PUeM/ssrFS7lb0mO9t7FpyQ+UhxlkY7Xk=
Received: from mail.zoho.eu by mx.zoho.eu
        with SMTP id 1608155763090919.7476516670547; Wed, 16 Dec 2020 22:56:03 +0100 (CET)
Date:   Wed, 16 Dec 2020 22:56:03 +0100
From:   Dmytro Shytyi <dmytro@shytyi.net>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     "David Miller" <davem@davemloft.net>,
        "yoshfuji" <yoshfuji@linux-ipv6.org>,
        "kuznet" <kuznet@ms2.inr.ac.ru>,
        "liuhangbin" <liuhangbin@gmail.com>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <1766d8d9190.dc863033212708.1815005709337797779@shytyi.net>
In-Reply-To: <20201216092831.31a6e8d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <175e1fdb250.1207dca53446410.2492811916841931466@shytyi.net>
        <175e4f98e19.bcccf9b7450965.5991300381666674110@shytyi.net>
        <176458a838e.100a4c464143350.2864106687411861504@shytyi.net>
        <20201215.160049.2258791262841288557.davem@davemloft.net>
        <1766bdb2894.11cec656f187711.2683040319761227283@shytyi.net> <20201216092831.31a6e8d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [PATCH net-next V8] net: Variable SLAAC: SLAAC with prefixes of
 arbitrary length in PIO
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

---- On Wed, 16 Dec 2020 18:28:31 +0100 Jakub Kicinski <kuba@kernel.org> wrote ----

 > On Wed, 16 Dec 2020 15:01:33 +0100 Dmytro Shytyi wrote: 
 > > Hello David, 
 > > 
 > > Thank you for your comment. 
 > > Asnwers in-line. 
 > > 
 > > Take care, 
 > > 
 > > Dmytro SHYTYI 
 > > 
 > > 
 > > ---- On Wed, 16 Dec 2020 01:00:49 +0100 David Miller <davem@davemloft.net> wrote ---- 
 > > 
 > >  > From: Dmytro Shytyi <dmytro@shytyi.net> 
 > >  > Date: Wed, 09 Dec 2020 04:27:54 +0100 
 > >  > 
 > >  > > Variable SLAAC [Can be activated via sysctl]: 
 > >  > > SLAAC with prefixes of arbitrary length in PIO (randomly 
 > >  > > generated hostID or stable privacy + privacy extensions). 
 > >  > > The main problem is that SLAAC RA or PD allocates a /64 by the Wireless 
 > >  > > carrier 4G, 5G to a mobile hotspot, however segmentation of the /64 via 
 > >  > > SLAAC is required so that downstream interfaces can be further subnetted. 
 > >  > > Example: uCPE device (4G + WI-FI enabled) receives /64 via Wireless, and 
 > >  > > assigns /72 to VNF-Firewall, /72 to WIFI, /72 to VNF-Router, /72 to 
 > >  > > Load-Balancer and /72 to wired connected devices. 
 > >  > > IETF document that defines problem statement: 
 > >  > > draft-mishra-v6ops-variable-slaac-problem-stmt 
 > >  > > IETF document that specifies variable slaac: 
 > >  > > draft-mishra-6man-variable-slaac 
 > >  > > 
 > >  > > Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net> 
 > >  > > --- 
 > >  > > diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h 
 > >  > > index dda61d150a13..67ca3925463c 100644 
 > >  > > --- a/include/linux/ipv6.h 
 > >  > > +++ b/include/linux/ipv6.h 
 > >  > > @@ -75,6 +75,7 @@ struct ipv6_devconf { 
 > >  > >      __s32        disable_policy; 
 > >  > >      __s32           ndisc_tclass; 
 > >  > >      __s32        rpl_seg_enabled; 
 > >  > > +    __s32        variable_slaac; 
 > >  > > 
 > >  > >      struct ctl_table_header *sysctl_header; 
 > >  > >  }; 
 > >  > > diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h 
 > >  > > index 13e8751bf24a..f2af4f9fba2d 100644 
 > >  > > --- a/include/uapi/linux/ipv6.h 
 > >  > > +++ b/include/uapi/linux/ipv6.h 
 > >  > > @@ -189,7 +189,8 @@ enum { 
 > >  > >      DEVCONF_ACCEPT_RA_RT_INFO_MIN_PLEN, 
 > >  > >      DEVCONF_NDISC_TCLASS, 
 > >  > >      DEVCONF_RPL_SEG_ENABLED, 
 > >  > > -    DEVCONF_MAX 
 > >  > > +    DEVCONF_MAX, 
 > >  > > +    DEVCONF_VARIABLE_SLAAC 
 > >  > >  }; 
 > >  > > 
 > >  > > 
 > >  > > diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c 
 > >  > > index eff2cacd5209..07afe4ce984e 100644 
 > >  > > --- a/net/ipv6/addrconf.c 
 > >  > > +++ b/net/ipv6/addrconf.c 
 > >  > > @@ -236,6 +236,7 @@ static struct ipv6_devconf ipv6_devconf __read_mostly = { 
 > >  > >      .addr_gen_mode        = IN6_ADDR_GEN_MODE_EUI64, 
 > >  > >      .disable_policy        = 0, 
 > >  > >      .rpl_seg_enabled    = 0, 
 > >  > > +    .variable_slaac        = 0, 
 > >  > >  }; 
 > >  > > 
 > >  > >  static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = { 
 > >  > > @@ -291,6 +292,7 @@ static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = { 
 > >  > >      .addr_gen_mode        = IN6_ADDR_GEN_MODE_EUI64, 
 > >  > >      .disable_policy        = 0, 
 > >  > >      .rpl_seg_enabled    = 0, 
 > >  > > +    .variable_slaac        = 0, 
 > >  > >  }; 
 > >  > > 
 > >  > >  /* Check if link is ready: is it up and is a valid qdisc available */ 
 > >  > > @@ -1340,9 +1342,15 @@ static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp, bool block) 
 > >  > >          goto out; 
 > >  > >      } 
 > >  > >      in6_ifa_hold(ifp); 
 > >  > > -    memcpy(addr.s6_addr, ifp->addr.s6_addr, 8); 
 > >  > > -    ipv6_gen_rnd_iid(&addr); 
 > >  > > 
 > >  > > +    if (ifp->prefix_len == 64) { 
 > >  > > +        memcpy(addr.s6_addr, ifp->addr.s6_addr, 8); 
 > >  > > +        ipv6_gen_rnd_iid(&addr); 
 > >  > > +    } else if (ifp->prefix_len > 0 && ifp->prefix_len <= 128 && 
 > >  > > +           idev->cnf.variable_slaac) { 
 > >  > > +        get_random_bytes(addr.s6_addr, 16); 
 > >  > > +        ipv6_addr_prefix_copy(&addr, &ifp->addr, ifp->prefix_len); 
 > >  > > +    } 
 > >  > >      age = (now - ifp->tstamp) / HZ; 
 > >  > > 
 > >  > >      regen_advance = idev->cnf.regen_max_retry * 
 > >  > > @@ -2569,6 +2577,37 @@ static bool is_addr_mode_generate_stable(struct inet6_dev *idev) 
 > >  > >             idev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_RANDOM; 
 > >  > >  } 
 > >  > > 
 > >  > > +static struct inet6_ifaddr *ipv6_cmp_rcvd_prsnt_prfxs(struct inet6_ifaddr *ifp, 
 > >  > > +                              struct inet6_dev *in6_dev, 
 > >  > > +                              struct net *net, 
 > >  > > +                              const struct prefix_info *pinfo) 
 > >  > > +{ 
 > >  > > +    struct inet6_ifaddr *result_base = NULL; 
 > >  > > +    struct inet6_ifaddr *result = NULL; 
 > >  > > +    bool prfxs_equal; 
 > >  > > + 
 > >  > > +    result_base = result; 
 > >  > 
 > >  > This is NULL, are you sure you didn't mewan to init this to 'ifp' 
 > >  >  or similar instead? 
 > > 
 > > [Dmytro] I put the entire function to comment below the instructions. 
 > > [Dmytro]: 
 > > +static struct inet6_ifaddr *ipv6_cmp_rcvd_prsnt_prfxs(struct inet6_ifaddr *ifp, 
 > > +                         struct inet6_dev *in6_dev, 
 > > +                         struct net *net, 
 > > +                         const struct prefix_info *pinfo) 
 > > +{ 
 > > +    struct inet6_ifaddr *result_base = NULL; 
 > > +    struct inet6_ifaddr *result = NULL; 
 > > +    bool prfxs_equal; 
 > > + 
 > > +    result_base = result; 
 > > +    rcu_read_lock(); 
 > > +    list_for_each_entry_rcu(ifp, &in6_dev->addr_list, if_list) { 
 > > +        if (!net_eq(dev_net(ifp->idev->dev), net)) 
 > > +            continue; 
 > > +        prfxs_equal = 
 > > +            ipv6_prefix_equal(&pinfo->prefix, &ifp->addr, pinfo->prefix_len); 
 > > +        if (prfxs_equal && pinfo->prefix_len == ifp->prefix_len) { 
 > > +            result = ifp; 
 > > +            in6_ifa_hold(ifp); 
 > > +            break; 
 > > +        } 
 > > +    } 
 > > +    rcu_read_unlock(); 
 > > +    if (result_base != result) 
 > > +        ifp = result; 
 > > +    else 
 > > +        ifp = NULL; 
 > > + 
 > > +    return ifp; 
 > > +} 
 > > + 
 > > 
 > > [Dmytro]: 
 > > 1st initial stage is : 
 > > +    result_base = result; 
 > > 
 > > 2nd stage is (as you mention, 'result' will be assigned to 'ifp', in the process): 
 > > +            result = ifp; 
 > > 
 > > 3rd stage is to compare if  "result_base" and "result" are not equal (and take required action). 
 > >  if (result_base != result) 
 > > +        ifp = result; 
 > > +    else 
 > > +        ifp = NULL; 
 > > 
 > > Looks more/less ok for me. 
 >  
 > I think I see what you're trying to do here. Use result_base as a 
 > "marker" or the base value? 
 >  
 > But I'd say it makes the code harder to follow. It looks like this: 
 >  
 >     result_base = NULL; 
 >     result = NULL; 
 >  
 >     result_base = result 
 >     lock() 
 >     for ... 
 >         /* search logic */ 
 >     unlock() 
 >      
 >     if (result == result_base) 
 >         ifp = result 
 >     else 
 >         ifp = NULL 
 >     return NULL 
 >  
 > This would be a lot simpler, and functionally equivalent: 
 >  
 >     result = NULL 
 >  
 >     lock() 
 >     for ... 
 >         /* search logic */ 
 >     unlock() 
 >  
 >     return result 
 >  
 > Right? 
 > 
[Dmytro]: I see and I agree. Understood.

