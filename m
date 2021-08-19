Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18AD03F1CE7
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 17:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240118AbhHSPe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 11:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239996AbhHSPey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 11:34:54 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70491C061575;
        Thu, 19 Aug 2021 08:34:18 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id e15so4119401plh.8;
        Thu, 19 Aug 2021 08:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Yf76Syz4brtNT2TPVq7X0dadrTNOLoFmj1QJaJIiTh0=;
        b=cAJ6RiRT86QPYqR0X26s7mSswyRpVowPuUsENIZx1l6egJXH0ozLyWgnnWjt2u7puP
         UJWhVXiq3RHn27K0KkiDtwEZxSo8ZCNpAIkf0kSPeuy1IelUA66tK+LhJQsoJbFUlVG1
         Ei9sPJmvHZqgJB2/JjS5mTmtWKYnUHZcmpUDn2L4ztjC8CGx47AvJHsDoApVN9uEQI2I
         CU1LH353mENYzuk5uHHyU3JqmU2mU4l0xz02sn8fI5gb2I3pEH4ei18k2xQQSKRT5AG0
         +9sPyqv5HD5VAxy2VxYFz2EKqap3RLoSGSCR1Xelpi/giM9T9y2pe7KsSwZcMNgVa9tX
         1b6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Yf76Syz4brtNT2TPVq7X0dadrTNOLoFmj1QJaJIiTh0=;
        b=p9fsXkADEVNthgELgv379BP+hUWCnGnDIOEkAl9VVDhfsvVf6FJ/7THjJqKxc1LY9r
         TRNBXDp+NTQUBAaWc2+0GAQgoYKLbA/kGWiqwF2Tt+hOY8C/AqKv0Hnu8Q3p4b3MWxw1
         XwToVDstHjjcorXYRRwtuhF+H4fZ/+yl/2qpin4FHKcS5aJYiuoHTtMkUC7e3PPL/KPl
         VcirJcluVUfwGDpnDn9vax/FTaWsGo6HGaSkkobWaiqnZSEArWGS7uPB3H7kKLkOugbh
         P+WCRxOm9pyLpPjvJjwLXNJhD4ODm85i+d3HqTNmre21cZmCTC/YLnDafmUCmre+Hlv+
         oK6g==
X-Gm-Message-State: AOAM531CpM4sMNloAKHsRKvX8xNkP95/sw3oL9qwANqcjZeqg15JVgce
        zyNB/u79tYyzQHQh588xd/4=
X-Google-Smtp-Source: ABdhPJzyiL3n2Xh1QDko3bDrys5TfB9fCfpwSIu0S/f9HqoWzmiD8ThaywV883OAlAo1goG1/F5lcg==
X-Received: by 2002:a17:902:8c81:b029:12c:ee37:3f58 with SMTP id t1-20020a1709028c81b029012cee373f58mr12328918plo.45.1629387257981;
        Thu, 19 Aug 2021 08:34:17 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id t13sm3532881pjg.25.2021.08.19.08.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 08:34:17 -0700 (PDT)
Date:   Thu, 19 Aug 2021 08:34:14 -0700
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
Message-ID: <20210819153414.GC26242@hoboy.vegasvil.org>
References: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
 <20210816160717.31285-2-arkadiusz.kubalewski@intel.com>
 <20210816235400.GA24680@hoboy.vegasvil.org>
 <PH0PR11MB4951762ECB04D90D634E905DEAFE9@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210818170259.GD9992@hoboy.vegasvil.org>
 <PH0PR11MB495162EC9116F197D79589F5EAFF9@PH0PR11MB4951.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB495162EC9116F197D79589F5EAFF9@PH0PR11MB4951.namprd11.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 10:36:03PM +0000, Machnikowski, Maciej wrote:

> OK, Let's take a step back and forget about SyncE. 

Ahem, the title of this series is:

    [RFC net-next 0/7] Add basic SyncE interfaces

I'd be happy to see support for configuring SyncE.

But I guess this series is about something totally different.


Thanks,
Richard
