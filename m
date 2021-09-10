Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73443406D67
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 16:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbhIJOPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 10:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233904AbhIJOPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 10:15:38 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80200C061574;
        Fri, 10 Sep 2021 07:14:27 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id n18so1912603pgm.12;
        Fri, 10 Sep 2021 07:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oe4VM1UblhS5+gJIFks4ik7gcc8ov9uDrnYIOA6m+LI=;
        b=pQ28E8z4ROEJSjDnjaoXfmDVQXV+FaMJ7j2Ao9Iv3Bg8H1ySc3TbHpE/Dp0THKY7x2
         FrtiekEFA/I87Ge2nyQ+09Xp2IjGeGuIbHNwymknYxUt8d8rzXTXEKZQWZMF/wfyq2SE
         Pjo6xH7sf5BBHszizp5nykKOB8QNZCDsn6x5lcFHDdUkh+95IYtjPmWz4E1FF4mcFGFQ
         5Do9ewuzSPURZXaUEqd4gCNnQ7eJp7atvGmqGwg8jVnPBoTbajC1PhtUf04LhdWUzGgM
         j4i+9JD/g3SDsWQd0nv7GZER8nywgTRdPdUJwMKLlnYyH+6z5bxezv3tkpZ25Ea4rIhI
         nhrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oe4VM1UblhS5+gJIFks4ik7gcc8ov9uDrnYIOA6m+LI=;
        b=m4Sch/yBguk6aVOFyGcT1axr2J29kD0un7LjA/4XFBjGHiL/UcPrFPgnY856krGbYr
         RBXIa4rYIzuQ8uurk1MnCiLajTqdvTff44FD1Dwh+0/esta2Tfr3OuXOiwk8/He24eKG
         Of0b31j4p0ayCLVXBKApG5A5S0ScMqRl2MTgDC++SyQFrxOEr95RelGfSS4KI8mbnhUl
         Q0av/Tdbr2tZGbmlLRxOkXnH4+Sea2Sye5Wzw2PrT2eUbJaa0hQUEwBJ20laciR+neMk
         iE0GyV1GnlCot+BH6IskS07js5JPWiSezP2IupNO3TAxuA2f18ax/6u2aUzkFHW99Ppe
         UjNQ==
X-Gm-Message-State: AOAM5331nrekiBJCaE5QK1vHAzfTiJyl30kAdBuUKUOpLgeQhVd7xwqA
        jhZma4E3TiauJFFkYv8ByGk=
X-Google-Smtp-Source: ABdhPJwOzKr8hK79NXiiFvMDuPJ5QyQWRVMQ+Hpt1ZMMluuVorlghIuaTIVRcqzGrXZQ3vlrka44rA==
X-Received: by 2002:a63:131f:: with SMTP id i31mr7547782pgl.207.1631283266990;
        Fri, 10 Sep 2021 07:14:26 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id a15sm5474422pgn.25.2021.09.10.07.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 07:14:26 -0700 (PDT)
Date:   Fri, 10 Sep 2021 07:14:23 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Saeed Mahameed <saeed@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Message-ID: <20210910141423.GA21865@hoboy.vegasvil.org>
References: <PH0PR11MB49512C265E090FC8741D8510EAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210907124730.33852895@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB495169997552152891A69B57EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210908092115.191fdc28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB4951AA3C65DD8E7612F5F396EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
 <YTkQTQM6Is4Hqmxh@lunn.ch>
 <20210908152027.313d7168@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YTlAT+1wkazy3Uge@lunn.ch>
 <20210909020915.GA30747@hoboy.vegasvil.org>
 <PH0PR11MB49515C4ACE9BAD7BD9172825EAD59@PH0PR11MB4951.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB49515C4ACE9BAD7BD9172825EAD59@PH0PR11MB4951.namprd11.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 09, 2021 at 08:18:10AM +0000, Machnikowski, Maciej wrote:

> Controlling the clock that actually drives any components (PHY/MAC) in
> runtime can be a good way to brick the part.

I didn't say that.

> I feel that, while the reuse 
> of structures may be a good idea, the userspace API for clocks is not. 
> They are usually set up once at the board init level and stay like that "forever".
> 
> The outputs we need to control are only a subset of all of them and they
> rather fall in the PTP pins level of details, rather than clock ones.

clk-gate.c
clk-mux.c

Making that available for user space to twiddle is a better way that
tacking on to the PTP stuff.

You can model your device as having a multiplexer in front of it.

Thanks,
Richard
