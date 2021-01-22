Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AB6300BD1
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 19:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbhAVSuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 13:50:03 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:40270 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728894AbhAVStJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 13:49:09 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 10MImBaI087979;
        Fri, 22 Jan 2021 12:48:11 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1611341291;
        bh=SL3bal519l0z/SIDoCENFuho5UyCCub8099H/tqvq2E=;
        h=Date:From:To:CC:Subject:References:In-Reply-To;
        b=K/IjCN7YzH5kM/ZOnXLZIxB4nqvbhiz6RPuPTibx9FvKeYGh7QcoCyker9aLl3ikh
         Iw7gT7VTPOphaRonTeElPlk6UTrEl7txwp+YiJfDkjyQKXwFC3cHKlerDJLRLw9GID
         S42jnqayRhGO1We9aKcqYsZnev+sVdVDNotCC0Hs=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 10MImB8c117862
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 Jan 2021 12:48:11 -0600
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 22
 Jan 2021 12:48:11 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 22 Jan 2021 12:48:11 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 10MImBTR022110;
        Fri, 22 Jan 2021 12:48:11 -0600
Date:   Fri, 22 Jan 2021 12:48:11 -0600
From:   Nishanth Menon <nm@ti.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     George McCollister <george.mccollister@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, <netdev@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>
Subject: Re: [RFC PATCH net-next 2/3] net: hsr: add DSA offloading support
Message-ID: <20210122184811.7asicloltgnshddt@primarily>
References: <20210122155948.5573-1-george.mccollister@gmail.com>
 <20210122155948.5573-3-george.mccollister@gmail.com>
 <27b8f3f2-a295-6960-2df5-3ee5e457fea3@gmail.com>
 <1c8833b8-12db-fd5d-0db2-532b9197a0a5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1c8833b8-12db-fd5d-0db2-532b9197a0a5@gmail.com>
User-Agent: NeoMutt/20171215
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10:00-20210122, Florian Fainelli wrote:
[...]

> >> +
> >> +This should be set for devices which duplicate outgoing HSR (highspeed ring)
> >> +frames in hardware.
> > 
> > Do you think we can start with a hsr-hw-offload feature and create new
> > bits to described how challenged a device may be with HSR offload? Is it
> >  reasonable assumption that functional hardware should be able to
> > offload all of these functions or none of them?
> > 
> > It may be a good idea to know what the platform that Murali is working
> > on or has worked on is capable of doing, too.
> 
> Murali's email address is bouncing, adding Grygorii, Kishon and
> Nishanth, they may know.

Gee, thanks for looping us in.. Yup, unfortunately, Murali is no longer
with TI. I have bounced the email over to right folks, whom I hope will
be able to help add more color..

-- 
Regards,
Nishanth Menon
Key (0xDDB5849D1736249D) / Fingerprint: F8A2 8693 54EB 8232 17A3  1A34 DDB5 849D 1736 249D
