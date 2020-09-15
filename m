Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB9726A174
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 11:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgIOJDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 05:03:02 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:60802 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726102AbgIOJC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 05:02:59 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6FB2020079;
        Tue, 15 Sep 2020 09:02:58 +0000 (UTC)
Received: from us4-mdac16-41.at1.mdlocal (unknown [10.110.48.12])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6E1A0800A3;
        Tue, 15 Sep 2020 09:02:58 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.12])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 17A69100061;
        Tue, 15 Sep 2020 09:02:58 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CE86F40067;
        Tue, 15 Sep 2020 09:02:57 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 15 Sep
 2020 10:02:53 +0100
Subject: Re: [PATCH net-next v2 04/10] drivers/net/ethernet: clean up unused
 assignments
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        <netdev@vger.kernel.org>
CC:     <intel-wired-lan@lists.osuosl.org>
References: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
 <20200915014455.1232507-5-jesse.brandeburg@intel.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <d647a101-412b-8f17-2460-5171e0a3a218@solarflare.com>
Date:   Tue, 15 Sep 2020 10:02:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200915014455.1232507-5-jesse.brandeburg@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25666.003
X-TM-AS-Result: No-4.450200-8.000000-10
X-TMASE-MatchedRID: 7ySqCuYCpfjmLzc6AOD8DfHkpkyUphL9Rf40pT7Zmv7IPbn2oQhptVcB
        fjjXtvYam2VgmZOOf8V3j1jxhRfPxmm3SnkbLZr6qjZ865FPtpoxXH/dlhvLvzbOtNwwSGVOXWj
        vA8TpWFj5fbRHi1cz0bh8wiI4NasiTX7PJ/OU3vKDGx/OQ1GV8mMVPzx/r2cb+gtHj7OwNO2Ohz
        Oa6g8KreTAu+y3PS5Q7xo0KfyV+cLYmY0nJJGcDuS8VnTZISehYp/aJjb634m5lYFAukxj+wjaZ
        DBiXdKG8FMD1Vzv8Xm1ARejXjmGguL59MzH0po2K2yzo9Rrj9wPoYC35RuihKPUI7hfQSp5eCBc
        UCG1aJiUTGVAhB5EbQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.450200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25666.003
X-MDID: 1600160578-Oa1zuXsLDrja
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/09/2020 02:44, Jesse Brandeburg wrote:
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
> Only compile tested with W=1.
>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
For sfc/falcon:
Acked-by: Edward Cree <ecree@solarflare.com>
