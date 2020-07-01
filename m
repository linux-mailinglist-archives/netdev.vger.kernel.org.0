Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC0F2115B9
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgGAWRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:17:20 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:57556 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725771AbgGAWRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 18:17:20 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0A75260065;
        Wed,  1 Jul 2020 22:17:20 +0000 (UTC)
Received: from us4-mdac16-37.ut7.mdlocal (unknown [10.7.66.156])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0A9358009E;
        Wed,  1 Jul 2020 22:17:20 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.174])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8F30F80057;
        Wed,  1 Jul 2020 22:17:19 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4069F1C007A;
        Wed,  1 Jul 2020 22:17:19 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Jul 2020
 23:17:14 +0100
Subject: Re: [PATCH net-next 06/15] sfc: commonise
 netif_set_real_num[tr]x_queues calls
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
References: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
 <f58eb18e-8b7a-5b79-be31-ec794f3262e1@solarflare.com>
 <20200701120537.0b36322a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <7e9ec87b-fb46-0717-7831-da1d7948c487@solarflare.com>
Date:   Wed, 1 Jul 2020 23:17:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200701120537.0b36322a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25514.003
X-TM-AS-Result: No-0.179700-8.000000-10
X-TMASE-MatchedRID: pBwXUM+nCwvmLzc6AOD8DfHkpkyUphL9amDMhjMSdnmnMb4m7aAqt15q
        52NV7rPta1crnatnSg9CCYt1RBb7ZKzxeYI2Af2t2PArUpVkoPwm4lf0t+giOHo3UQdlWBZj6BX
        hOTEsTTHi8zVgXoAltkWL4rBlm20vExAtD/T72EbdB/CxWTRRu+rAZ8KTspSzLciidlxzGVO0LF
        5g4gd+gG7Cfp139kFz6nr1N9r0ZUE4tB9IMwhMcQbEQIfFpkwHBtlgFh29qnpKzBwu5JpklnOUu
        oTXM7r4QwymtxuJ6y0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.179700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25514.003
X-MDID: 1593641840-lscdcqXcJ5Br
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/07/2020 20:05, Jakub Kicinski wrote:
> On Wed, 1 Jul 2020 15:53:15 +0100 Edward Cree wrote:
>> +	netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_channels);
>> +	netif_set_real_num_rx_queues(efx->net_dev, efx->n_rx_channels);
> For a third time in last 7 days - these can fail :)
Yeah, I noticed the first twoand was wondering if you'd complain :)

> I know you're just moving them, but perhaps worth cleaning this up..
Ok, can do.

-ed
