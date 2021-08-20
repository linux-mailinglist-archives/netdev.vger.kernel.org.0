Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528DE3F3044
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 17:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241237AbhHTP4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 11:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240865AbhHTP4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 11:56:20 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618DBC061575;
        Fri, 20 Aug 2021 08:55:42 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id o2so9594984pgr.9;
        Fri, 20 Aug 2021 08:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MIoupKU3Moruzsm8QPKL5bg4Lip5l5y1B47NuZC/4IM=;
        b=r+PvnCwYImSiC3Nut0xm3m3wb4UrN969SsszBr9JKgB77hlBUNTQNyfL6roOkkOGRa
         KrBKP9+u4YE7Ktfu/AAprpCxD5Yxi9YNuiDNBsGi7iHpzasmrGfQ6JmV4o1AL+IFHzNc
         JzQU5IOIFznyFiNTx+N5FPFBFbPh50YpyRsWSimyeF/56PotRBuV7PTrZVwYD1+GyhPv
         boxGSl6k1FfmQCZ7qUDKTxwcBYb8LhG393aAuVYqWgs/wN9/O2qwT+mHojzrfu4+5shE
         dd6+hsApWdJ6Iwz6PF0weL9bsbojahtIhj2aOxhIYjZE/fg49rq5CWwNKQhdbA+R7mAO
         hr4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MIoupKU3Moruzsm8QPKL5bg4Lip5l5y1B47NuZC/4IM=;
        b=WMMJ00CtyFga8bI/ZfPte7CSAV6QA+Swo70msNBdWftUvHUV5zjQSCPDN942RpcNuC
         Cspoi2AYAOUjL/IhTHIleRo5NK6JASMXelaylF4P1IK1WdbcaTKYmGDMsRx3bfY3yBHD
         bayyMCc0fzNGVD7dsPg5aSWQ6+2TP64W18JyXkCOlDJXZnUq4QQe6l+BESRqKJQgXvAD
         jA6QpZ8HidcHGs/crn1pjtQJYZP3wRSWCfcei3k3O4eNk/B6+a7VHi4YIynFPE5lIcVO
         vZFC44pmc4wpYsh54KNRBf43WASZCwA8vy+QKHpYYgtNU7Y3e+lGYNFkbQo1N5yhfUI3
         3YsQ==
X-Gm-Message-State: AOAM530NnvjSbW8BXx+5wySbjH4VsR398mhMS+DfBf1bG4flqSLCqxub
        OVsylAnc3qx6uDOk3j/P9Yc=
X-Google-Smtp-Source: ABdhPJzRSioBxgzRHifQYGk7LPxW9/eAyxuZnBnOOY1SstliQrJ2oxeWZsCv7JeKODoMIZGifx1H3g==
X-Received: by 2002:a62:154b:0:b0:3e2:c15d:f173 with SMTP id 72-20020a62154b000000b003e2c15df173mr16637025pfv.9.1629474941955;
        Fri, 20 Aug 2021 08:55:41 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id p15sm7632095pff.14.2021.08.20.08.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 08:55:41 -0700 (PDT)
Date:   Fri, 20 Aug 2021 08:55:38 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "Bross, Kevin" <kevin.bross@intel.com>,
        "Stanton, Kevin B" <kevin.b.stanton@intel.com>,
        Ahmad Byagowi <abyagowi@fb.com>
Subject: Re: [RFC net-next 1/7] ptp: Add interface for acquiring DPLL state
Message-ID: <20210820155538.GB9604@hoboy.vegasvil.org>
References: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
 <20210816160717.31285-2-arkadiusz.kubalewski@intel.com>
 <20210816235400.GA24680@hoboy.vegasvil.org>
 <PH0PR11MB4951762ECB04D90D634E905DEAFE9@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210818170259.GD9992@hoboy.vegasvil.org>
 <PH0PR11MB495162EC9116F197D79589F5EAFF9@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210819153414.GC26242@hoboy.vegasvil.org>
 <PH0PR11MB4951F51CBA231DFD65806CDAEAC09@PH0PR11MB4951.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB4951F51CBA231DFD65806CDAEAC09@PH0PR11MB4951.namprd11.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 03:40:22PM +0000, Machnikowski, Maciej wrote:

> If it helps we'd be happy to separate that in 2 separate RFCs.

It would help me if you could explain the connection.  I have a
totally different understanding of SyncE which I explained here:

   https://lore.kernel.org/netdev/20150317161128.GA8793@localhost.localdomain/

So you need to implement two things, one in kernel and one in user
space.

1. Control bits according to IEEE 802.3 Section 40.5.2 as Ethtool or RTNL.

2. User space Ethernet Synchronization Messaging Channel (ESMC)
   service according to IEEE 802.3ay

The PHY should be automatically controlled by #1.

As I said before, none of this belongs in the PHC subsystem.

Thanks,
Richard
