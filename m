Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4192B18D9
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 11:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgKMKPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 05:15:40 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.48]:53656 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726176AbgKMKPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 05:15:39 -0500
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Nov 2020 05:15:39 EST
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D30FEA5D5D
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 10:06:18 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2538B6008F;
        Fri, 13 Nov 2020 10:06:18 +0000 (UTC)
Received: from us4-mdac16-29.ut7.mdlocal (unknown [10.7.66.139])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 23DE18009E;
        Fri, 13 Nov 2020 10:06:18 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.90])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A889080052;
        Fri, 13 Nov 2020 10:06:17 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 46C239C0068;
        Fri, 13 Nov 2020 10:06:17 +0000 (UTC)
Received: from mh-desktop (10.17.20.62) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 13 Nov
 2020 10:06:11 +0000
Date:   Fri, 13 Nov 2020 10:06:07 +0000
From:   Martin Habets <mhabets@solarflare.com>
To:     Edward Cree <ecree@solarflare.com>
CC:     <linux-net-drivers@solarflare.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/3] sfc: further EF100 encap TSO features
Message-ID: <20201113100607.GB1486579@mh-desktop>
Mail-Followup-To: Edward Cree <ecree@solarflare.com>,
        linux-net-drivers@solarflare.com, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org
References: <eda2de73-edf2-8b92-edb9-099ebda09ebc@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <eda2de73-edf2-8b92-edb9-099ebda09ebc@solarflare.com>
X-Originating-IP: [10.17.20.62]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25786.001
X-TM-AS-Result: No-1.049200-8.000000-10
X-TMASE-MatchedRID: 5+1rHnqhWUQNBIms22BrT/ZvT2zYoYOwC/ExpXrHizxTbQ95zRbWVlAX
        z8FXjvtiCmviniliH8qtoxokPqGIrBuf8+qwj2wBZ7QXUcH2LaHrixWWWJYrH0OrZJUSTvYoTHD
        UEwHVLSvZs3HUcS/scCq2rl3dzGQ1GpeevGsoI5fBsY/CjCFgmeigwiJM+C0aSnVV9pTSzERxMh
        c8poLGg97tEDGPCf/SRXNUjAtxSZKhO2U+IR8g6QwNjX9cYjdM/FUSjgh03KxDDKa3G4nrLQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.049200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25786.001
X-MDID: 1605261978-CCTFmEp_gytg
X-PPE-DISP: 1605261978;CCTFmEp_gytg
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 03:18:01PM +0000, Edward Cree wrote:
> This series adds support for GRE and GRE_CSUM TSO on EF100 NICs, as
>  well as improving the handling of UDP tunnel TSO.
> 
> Edward Cree (3):
>   sfc: extend bitfield macros to 19 fields
>   sfc: correctly support non-partial GSO_UDP_TUNNEL_CSUM on EF100
>   sfc: support GRE TSO on EF100

Acked-by: Martin Habets <mhabets@solarflare.com>
