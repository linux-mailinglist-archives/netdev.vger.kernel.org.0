Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150233FBDE5
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 23:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237446AbhH3VHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 17:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236983AbhH3VHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 17:07:09 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37B4C061575;
        Mon, 30 Aug 2021 14:06:14 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id e16so12796770pfc.6;
        Mon, 30 Aug 2021 14:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=l4mUL7KTlI0Cq3qGA1ysHUWbzUs7cEfmJVpqyyFGsp8=;
        b=ePChrhmbbjXl7+ObMyn+IvqZOrTyHT5tNsX2lranOL15xxrn+yMRAhiP1CezlFQoxr
         gPm1LSnikhBOcDhIrKuKlUTJ5hzEYyj1Q9N2QhgbFRXZdUXcPl6Zm//lAXjfbUjbcV2E
         zeFEdjI9LG5UegQkvgAl9yn9FTnJZAp8vCQWGJ9L1nQFeJNcd9G3j85DaPg41F2FRcGC
         BPCBpNXxZd0ykhWq3NBSl/w1FDef1evk7wo8lrtsoaQuhfD/JLnNFQ0gFEKJnKXTRRyR
         l2ULmtbP0uz7t2DzKZceQt/j+dX51ZsMJpHvQI2UPEhtP9Jr6jzOmj9XF87MKf/GYN/H
         NVXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=l4mUL7KTlI0Cq3qGA1ysHUWbzUs7cEfmJVpqyyFGsp8=;
        b=mF/5QVKeK/0menB9bd218AI5WuD8RU5ERWlDe2KM7Wq8sdtH+1s/N1eDMZ6rwbGeuQ
         Ano62+O4SsDjLaTIzpSPTdpFkC4UIssD0cVzAnG40PKyvR0X4HCGXLBy0aRGopdc5jQk
         R1O89cKlh4NM23gwSLhcKVGiCD6j98eLqNxWgfkQjP+VNPg8YTocStLZQFFjL3zRXcCU
         Dad2NIxkaJQr7yms2nTSXTqBz1HodBsfRXWmfyN1SB2cU/V5LLQc0SRnWvhhgIRthiVS
         zAdVBhTGQAN6LwqUx2uQIXL9v521SaPzpZmbw6eEqbaP2MWQ/+NbdS5OJGGiwb5vSlqQ
         Tcug==
X-Gm-Message-State: AOAM532tpvaqyOrcp740t44PJa212TR+gDQDcV3P+qzUce85qtpPbujH
        SiQjvXwZoY90sclf3wLtoI4=
X-Google-Smtp-Source: ABdhPJyARgDzaEEd/8lorS/vMkvnCj3AXWAsnDYS5hXmLzHLF5RfQHRMPhy0sBoroUS55Mx/IwaJHg==
X-Received: by 2002:a63:d250:: with SMTP id t16mr23928547pgi.95.1630357574551;
        Mon, 30 Aug 2021 14:06:14 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id j17sm16057194pfn.148.2021.08.30.14.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 14:06:13 -0700 (PDT)
Date:   Mon, 30 Aug 2021 14:06:10 -0700
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
Message-ID: <20210830210610.GB26230@hoboy.vegasvil.org>
References: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
 <20210816160717.31285-2-arkadiusz.kubalewski@intel.com>
 <20210816235400.GA24680@hoboy.vegasvil.org>
 <PH0PR11MB4951762ECB04D90D634E905DEAFE9@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210818170259.GD9992@hoboy.vegasvil.org>
 <PH0PR11MB495162EC9116F197D79589F5EAFF9@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210819153414.GC26242@hoboy.vegasvil.org>
 <PH0PR11MB4951F51CBA231DFD65806CDAEAC09@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210820155538.GB9604@hoboy.vegasvil.org>
 <PH0PR11MB49518ED9AAF8B543FD8324B9EAC19@PH0PR11MB4951.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB49518ED9AAF8B543FD8324B9EAC19@PH0PR11MB4951.namprd11.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 06:30:02PM +0000, Machnikowski, Maciej wrote:

> So to be able to control SyncE we need 2 interfaces:
> - Interface to enable the recovered clock output at the given pin
> - interface to monitor the DPLL to see if the clock that we got is valid, or not.
> 
> If it comes to ESMC (G.8264) messages, SyncE itself can run in 2 modes (slides 29/30 will give you more details):
> - QL-Disabled - with no ESMC messages - it base on the local information from the PLL to make all decisions
> - QL-Enabled - that adds ESMC and quality message transfer between the nodes.

How do you get the QL codes from this?

+enum if_eec_state {
+       IF_EEC_STATE_INVALID = 0,
+       IF_EEC_STATE_FREERUN,
+       IF_EEC_STATE_LOCKACQ,
+       IF_EEC_STATE_LOCKREC,
+       IF_EEC_STATE_LOCKED,
+       IF_EEC_STATE_HOLDOVER,
+       IF_EEC_STATE_OPEN_LOOP,
+       __IF_EEC_STATE_MAX,
+};

Thanks,
Richard
