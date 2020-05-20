Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A4E1DB7F3
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 17:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgETPSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 11:18:48 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:41838 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726486AbgETPSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 11:18:48 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6F3E220056;
        Wed, 20 May 2020 15:18:47 +0000 (UTC)
Received: from us4-mdac16-59.at1.mdlocal (unknown [10.110.50.152])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6DC6E800A4;
        Wed, 20 May 2020 15:18:47 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.48.236])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id EDACB40077;
        Wed, 20 May 2020 15:18:46 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8A8B8400095;
        Wed, 20 May 2020 15:18:46 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 20 May
 2020 16:18:40 +0100
Subject: Re: [PATCH net-next v2] net: flow_offload: simplify hw stats check
 handling
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <jiri@resnulli.us>,
        <kuba@kernel.org>
References: <cf0d731d-cb34-accd-ff40-6be013dd9972@solarflare.com>
 <20200519171923.GA16785@salvia>
 <6013b7ce-48c9-7169-c945-01b2226638e4@solarflare.com>
 <20200519173508.GA17141@salvia>
 <dc732572-6f69-6cbe-5df1-ca4d6e6ed131@solarflare.com>
 <20200520143330.GA23050@salvia>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <981c02e9-6152-feed-2607-9607e58b760c@solarflare.com>
Date:   Wed, 20 May 2020 16:18:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200520143330.GA23050@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25430.003
X-TM-AS-Result: No-3.679000-8.000000-10
X-TMASE-MatchedRID: hls5oAVArl+8rRvefcjeTR4ejJMDGBzF69aS+7/zbj+qvcIF1TcLYILL
        5sr088cXhAaFAwxjJ1cOmKSDLU0HeW00sCPwNg7wqYUcLUvrWVj348e2CE/wYiNGK7UC7ElMNJD
        jFX5JKf1ZAHwcJSAboAXidoJ7b4hPfcSal8l6P7BIwW/Kvkvzgt1eFEoaE12nmbdPE3zcujhPpj
        LRqc8GlkfXh0xnZvblsgAkUr9nVXYvwcx4DcVB2wGdJZ3Knh6hqV3VmuIFNEv+UVve/ZY5tK5cF
        KGf3JC5Sl4zVySO23hOBek6Nnej9A/IIKW24r39ngIgpj8eDcByZ8zcONpAscRB0bsfrpPIcSqb
        xBgG0w6achrirk/mmT27L4wyeFLDpgnXqw6nBZdmBCSRfw/PXn8S1HbHCtojZ5wrY0zWCp9Fzux
        dhbVQwa1Y5Ca0eNDSo7M4c5rtlSDUNewp4E2/TgSpmVYGQlZ3sxk1kV1Ja8fhIo573pBCBw==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.679000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25430.003
X-MDID: 1589987927-2Hm1UR9Je-0O
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/05/2020 15:33, Pablo Neira Ayuso wrote:
> #1 Drivers calling flow_action_hw_stats_check() fall within the
> second branch (check_allow_bit is set on).
>
>         } else if (check_allow_bit &&         <------ HERE
>
> These drivers are not honoring the _DONT_CARE bit,
> __flow_action_hw_stats_check() with check_allow_bit set on does not
> honor the _DONT_CARE bit.
I don't understand.  There isn't a _DONT_CARE bit; _DONT_CARE isa
 bitmask of *all* the bits: BIT(FLOW_ACTION_HW_STATS_NUM_BITS) - 1.
So if allow_bit < FLOW_ACTION_HW_STATS_NUM_BITS, then
 BIT(allow_bit) & FLOW_ACTION_HW_STATS_DONT_CARE is nonzero, and
 thus the function returns true.

> #2 Your patch needs to update Netfilter to set hw_stats to
>    FLOW_ACTION_HW_STATS_DONT_CARE explicitly.
Ahh, naïvely I had assumed that you would have done that in the
 patch that added _DONT_CARE; I should have checked that.  Will
 fix that for the next version.

Thank you for being specific.
And you'll be pleased to know that I've managed to bodge a working
 nft binary onto my test system, so hopefully I'll be able to test
 with netfilter offload.  Am I right in thinking that an ingress
 chain on the netdev table is the thing I want?

-ed
