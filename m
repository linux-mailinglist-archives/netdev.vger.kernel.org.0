Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C652665E4
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgIKRRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:17:20 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:49164 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726319AbgIKRRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 13:17:16 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B64C2600F8;
        Fri, 11 Sep 2020 17:17:07 +0000 (UTC)
Received: from us4-mdac16-8.ut7.mdlocal (unknown [10.7.65.76])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B0B4E8009B;
        Fri, 11 Sep 2020 17:17:07 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.37])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3BD12280081;
        Fri, 11 Sep 2020 17:17:07 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D5F71B4008F;
        Fri, 11 Sep 2020 17:17:06 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Sep
 2020 18:17:01 +0100
Subject: Re: [RFC PATCH net-next v1 06/11] drivers/net/ethernet: clean up
 unused assignments
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        <netdev@vger.kernel.org>
CC:     <intel-wired-lan@lists.osuosl.org>
References: <20200911012337.14015-1-jesse.brandeburg@intel.com>
 <20200911012337.14015-7-jesse.brandeburg@intel.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <5bcd5f6f-d0c1-b9c4-d5f6-4de845ee1ec7@solarflare.com>
Date:   Fri, 11 Sep 2020 18:16:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200911012337.14015-7-jesse.brandeburg@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25660.000
X-TM-AS-Result: No-4.123400-8.000000-10
X-TMASE-MatchedRID: zGP2F0O7j/vmLzc6AOD8DfHkpkyUphL9Rf40pT7Zmv7IPbn2oQhptVcB
        fjjXtvYam2VgmZOOf8V3j1jxhRfPxmm3SnkbLZr6qjZ865FPtpoxXH/dlhvLvzbOtNwwSGVOa3A
        6hcNu8nDq92GZEhpKAfhQCrII02E2lMpYDVQkkeg1VHP4fCovgtGOcAfHKa6u0KxsbaNnoupYRh
        FlJ0Kcr8GQZIKgJv1mHDzDwZlZOvCkFfZTffnkWZ4CIKY/Hg3AcmfM3DjaQLHEQdG7H66TyJ8TM
        nmE+d0ZQlaRmWoGI8vtP3FMG2qpQ/ZCvZhvkwJc+v0C+90s8ayaSPrO4scCc4KjMEMZCDJbJqj8
        +Mqtx6wwAhdFK3lkQsl7u4mtdYPD1DXsKeBNv04EqZlWBkJWd7MZNZFdSWvHG2wlTHLNY1JWXGv
        UUmKP2w==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.123400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25660.000
X-MDID: 1599844627-bZViuQwv02hp
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/09/2020 02:23, Jesse Brandeburg wrote:
> As part of the W=1 compliation series, these lines all created
> warnings about unused variables that were assigned a value. Most
> of them are from register reads, but some are just picking up
> a return value from a function and never doing anything with it.
>
> The register reads should be OK, because the current
> implementation of readl and friends will always execute even
> without an lvalue.
>
> When it makes sense, just remove the lvalue assignment and the
> local. Other times, just remove the offending code, and
> occasionally, just mark the variable as maybe unused since it
> could be used in an ifdef or debug scenario.
>
> Only compile tested with W=1 and an allyesconfig with all the
> network drivers turned into modules (to try to test all options).
>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
For the sfc/falcon part:
Acked-by: Edward Cree <ecree@solarflare.com>
(it's not the same as the solution I went with for thevery
 similar code in the Siena driver (../farch.c), but it looks
 reasonable enough).
