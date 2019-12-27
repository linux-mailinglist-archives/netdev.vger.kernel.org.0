Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 092E112B630
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfL0Rjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:39:54 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37248 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfL0Rjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 12:39:54 -0500
Received: by mail-pf1-f196.google.com with SMTP id p14so15026004pfn.4
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 09:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=j+S0gndQGPQFmb73+zbyxuI8YGLrejiamFndW3ohNSw=;
        b=BcDPCWHfQsLVlmtVEKDLTzo4/AL3/jaMGWKjBZN9ts6QFV/gQwA/WI2lddwor8DA/b
         os5sa6k2VrKZDEEfJpIp+cLfveuyTzm5adhtKW5NYRkimzOpAKr5Pq51At5SXhGOXoBX
         Liy3OdwfKRAx8u0LcokyyMciFmVNqjXSTFEF29hnzk+tr/SQCo0YC06/Lx3qml2Y1Sos
         hTMSs722EuusoOzzTfzTBkoNGLEMKwoCuWmlbKbI1CHVjilRIGMi97gRKBtWyAMDdQnl
         yXJ/On9Q/eGqtRL23aE8ZE0zvOXPbBc/v5NgOhsSngCtUAdEGhRbvToqnOhXataB/p/w
         NKPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=j+S0gndQGPQFmb73+zbyxuI8YGLrejiamFndW3ohNSw=;
        b=RzBOCnAK3oaxpaoaxnUCnNgm7pY5OIT+bG/Jr8psJALDotkoqQjvGQIlv8cGioot59
         zsaXxeWXwQkuVNveqFXmohOz9s8eY0dg8uZm8/uJEwi2Jd5mk70/fpiLvJ1+9d9P3vkE
         FwdpR9ZmPWJzy9Ugwg7fgA0B0zEbYRznn4by/5eqDQT44U/2LZr3aKQxeUDXEvmH+7G4
         CS8RW+D/b9LWu2SMW+sqLIHbXV6hnzjXw5ZQ3UKIOGHrP9nsAoLBTWmCTHSjIksEIB7y
         t0tUVcHE21LFPrdE41ahkDdAFB8KaZ9pFtyltYF9sQdX4yE3xy5CNJOe4ym7uhipDfqp
         Z2Kw==
X-Gm-Message-State: APjAAAWF9O1f674CPwgwtL73R9KJ8XiFKM/WZ7KLj1I7zX1wlEp2LHSK
        x1c72YLgRkXq7BpU+4tb2mAinkYY
X-Google-Smtp-Source: APXvYqwXSe0zeCUZlAKSMxVznD3jFChmPKd2T+qsTWIlWgC3tXHNk4UpL6Qv3qfF6aufUXOIK+mYww==
X-Received: by 2002:a62:6401:: with SMTP id y1mr34535075pfb.18.1577468393784;
        Fri, 27 Dec 2019 09:39:53 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id b20sm22399803pfi.153.2019.12.27.09.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 09:39:53 -0800 (PST)
Date:   Fri, 27 Dec 2019 09:39:50 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net: dsa: sja1105: Fix double delivery of TX
 timestamps to socket error queue
Message-ID: <20191227173950.GD1435@localhost>
References: <20191216223344.2261-1-olteanv@gmail.com>
 <02874ECE860811409154E81DA85FBB58B26DEDC3@fmsmsx101.amr.corp.intel.com>
 <CA+h21hob3FmbQYyXMeLTtbHF1SeFO=LZVGyQt4jniS9-VXEO-w@mail.gmail.com>
 <02874ECE860811409154E81DA85FBB58B26DF1C9@fmsmsx101.amr.corp.intel.com>
 <20191224190531.GA426@localhost>
 <CA+h21hrBLedLHCfP3oY2U96BJXqMQO=Uof3tsjji_Fp-b0smHQ@mail.gmail.com>
 <20191227015232.GA6436@localhost>
 <20191227151916.GC1435@localhost>
 <CA+h21hoq2-CAVfv7zQkQCsaTFmOTrxj-93MbHpJLPAt7jbOgbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hoq2-CAVfv7zQkQCsaTFmOTrxj-93MbHpJLPAt7jbOgbg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 27, 2019 at 05:30:09PM +0200, Vladimir Oltean wrote:
> But in the case that I _do_ care about, it _is_ caused by DSA. The
> gianfar driver is not expecting anybody else to set SKBTX_IN_PROGRESS,
> which in itself is not illegal, whether or not you argue that it is
> needed or not.

Ok, so I've reviewed the whole SKBTX_IN_PROGRESS thing again, and I'm
starting to see it your way.  (Or maybe not ;^)

The purpose of SKBTX_IN_PROGRESS is to prevent a SW transmit time
stamp from being delivered (unless SOF_TIMESTAMPING_OPT_TX_SWHW is set
on the socket).

So DSA drivers (and PHY drivers) should indeed set this flag.

However, most (or all?) MAC drivers do not expect anyone else to have
set this flag.

In the case of DSA, the DSA driver has the chance to set the flag
first, before the skb is passed to the MAC driver.  (PHY drivers don't
have first dibs, but let's concentrate on DSA for now.)

So, you could introduce a new rule that MAC drivers must check to see
if the flag is already set, and if so leave it alone.

MAC drivers should in any case respect their current SIOCSHWTSTAMP
configuration and not attempt time stamping when it is not enabled.

So I'm afraid that, as I've said before, you'll have to patch the MAC
drivers one by.  It will be lots of work.

But if and when you submit patches for the MAC drivers, please
remember that DSA time stamping is the new kid on the block, and
yelling that the MAC drivers are broken won't make you any friends.

Thanks,
Richard

