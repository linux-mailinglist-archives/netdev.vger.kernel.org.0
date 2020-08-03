Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710C623A89A
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 16:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgHCOgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 10:36:22 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:46090 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726358AbgHCOgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 10:36:22 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D6A166007B;
        Mon,  3 Aug 2020 14:36:21 +0000 (UTC)
Received: from us4-mdac16-71.ut7.mdlocal (unknown [10.7.64.190])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D46C9200B2;
        Mon,  3 Aug 2020 14:36:21 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.42])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5826622008B;
        Mon,  3 Aug 2020 14:36:21 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id F10D4A40073;
        Mon,  3 Aug 2020 14:36:20 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 3 Aug 2020
 15:36:15 +0100
Subject: Re: [PATCH v2 net-next 04/11] sfc_ef100: TX path for EF100 NICs
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
References: <31de2e73-bce7-6c9d-0c20-49b32e2043cc@solarflare.com>
 <9776704b-d4b0-7477-42ba-f82ad3d4ec48@solarflare.com>
 <20200731123936.38680a53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <4cd2e7e9-a5e4-283e-d4f2-f7f1d3b41669@solarflare.com>
Date:   Mon, 3 Aug 2020 15:36:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200731123936.38680a53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25580.005
X-TM-AS-Result: No-7.424600-8.000000-10
X-TMASE-MatchedRID: 7ySqCuYCpfjmLzc6AOD8DfHkpkyUphL9amDMhjMSdnlVZCccrGnfyHjm
        0APnwZU2oPDBsdLv/Zv8NU6T4XpIugDNPxu11HXjbRZGrsoeW/g0AJe3B5qfBrNgNI2I9bOAjL4
        B9OUMY3Wng9t5QPCRN4el0gm1sucmSSOWVJeuO1CDGx/OQ1GV8hFMgtPIAD6i+gtHj7OwNO2Ohz
        Oa6g8KrX8DclAO/Dl/a6flRovitHvL/0Lff1MiTOYILMwne6onLnieqqu9S5g=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.424600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25580.005
X-MDID: 1596465381-3nxdFfiY-pin
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/07/2020 20:39, Jakub Kicinski wrote:
> On Fri, 31 Jul 2020 13:59:04 +0100 Edward Cree wrote:
>> +static inline efx_oword_t *ef100_tx_desc(struct efx_tx_queue *tx_queue,
>> +					 unsigned int index)
> Does this static inline make any difference?
>
> You know the general policy...
Damn, I didn't spot that one.

Why doesn't checkpatch catch those?  Is it just not smart enough
 to remember whether it's in a .c file or not?  Or do I need to
 pass it some --strict --fascist --annoy-me-harder flags?

Will remove 'inline' in v3, thanks.

-ed
