Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134281D9F6C
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 20:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgESS0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 14:26:54 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:33900 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726502AbgESS0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 14:26:54 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 84A96600B0;
        Tue, 19 May 2020 18:26:53 +0000 (UTC)
Received: from us4-mdac16-45.ut7.mdlocal (unknown [10.7.64.27])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 82E21200A4;
        Tue, 19 May 2020 18:26:53 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.30])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id EE7A422005F;
        Tue, 19 May 2020 18:26:52 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 647B2100079;
        Tue, 19 May 2020 18:26:52 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 19 May
 2020 19:26:46 +0100
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
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <dc732572-6f69-6cbe-5df1-ca4d6e6ed131@solarflare.com>
Date:   Tue, 19 May 2020 19:26:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200519173508.GA17141@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25428.003
X-TM-AS-Result: No-7.974500-8.000000-10
X-TMASE-MatchedRID: HXSqh3WYKfu8rRvefcjeTR4ejJMDGBzF69aS+7/zbj9RXC4cX65cJJQp
        8P1TdmSa6p2MwhnGDkBHloHIAzso1UlNkNzbYQ+3Iwk7p1qp3JbdYVrFVbszaMuSXx71bvSLcID
        y7DqlE8v/Jhd10Wr/0M3UceiBmxhNuAzO9oQibGf/Te3t5cJMGx5FmvZzFEQustuan4ScYgrJdO
        SGA6s0i13zi/eJ6s3jRV9DrFlwADH+Bakt0aHHFvjQkA7rdCuF6roloi3VB6JE/s+hW1mwCKPFj
        JEFr+olSXhbxZVQ5H+OhzOa6g8Krb+b/roeYfX8iBn8yIHai+Ci/kb9xHdg/puVhI58xtMJxV1H
        IZ8FcTU=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.974500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25428.003
X-MDID: 1589912813-iVhqZSJFWdM3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/05/2020 18:35, Pablo Neira Ayuso wrote:
> Did you test your patch with netfilter? I don't think.
As I mentioned in v1 (and should have repeated on v2, sorry) this is
 compile tested only, as I don't have the hardware to test it.  (I have
 done some testing with the not-yet-upstream sfc_ef100 driver, though.)
But as I'm not a netfilter user, I don't have a handy set of netfilter
 rules to test this with anyway; and my previous attempts to find useful
 documentation on netfilter.org were not fruitful (although I've just
 now found wiki.nftables.org).  I was hoping someone with the domain
 knowledge (and the hardware) could test this.
(Also, for complicated reasons, getting nft built for my ef100 test
 system would be decidedly nontrivial; and any test I do without offload
 hardware at the bottom would necessarily be so synthetic I'm not sure
 I'd trust it to prove anything.)

> Netfilter is a client of this flow offload API, you have to test that
> your core updates do not break any of existing clients.
Okay, but can we distinguish between "this needs to be tested with
 netfilter before it can be merged" and "this is breaking netfilter"?
Or do you have a specific reason why you think this is broken, beyond
 merely 'it isn't tested'?
