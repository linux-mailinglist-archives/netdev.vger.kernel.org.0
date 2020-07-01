Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFBC2115A8
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgGAWN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:13:27 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:55152 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725771AbgGAWNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 18:13:25 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 214B660067;
        Wed,  1 Jul 2020 22:13:25 +0000 (UTC)
Received: from us4-mdac16-42.ut7.mdlocal (unknown [10.7.64.24])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 1FA648009B;
        Wed,  1 Jul 2020 22:13:25 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.32])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8A069280052;
        Wed,  1 Jul 2020 22:13:24 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 27E03B4006A;
        Wed,  1 Jul 2020 22:13:24 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Jul 2020
 23:13:17 +0100
Subject: Re: [PATCH net-next 01/15] sfc: support setting MTU even if not
 privileged to configure MAC fully
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
References: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
 <db235d46-96b0-ee6d-f09b-774e6fd9a072@solarflare.com>
 <20200701120311.4821118c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <3b76efb6-4b02-a26d-5284-65ab37b79ef5@solarflare.com>
Date:   Wed, 1 Jul 2020 23:13:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200701120311.4821118c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25514.003
X-TM-AS-Result: No-1.491700-8.000000-10
X-TMASE-MatchedRID: 9zTThWtzImvmLzc6AOD8DfHkpkyUphL9amDMhjMSdnni7ECA5q90ucuO
        qs00obe3SU7wejPT3bUF3u5AqD4V8mdOuIGC/rzd4h8r8l3l4eaXGEdoE+kH/+D3XFrJfgvzEeW
        UGBiCoDXI5DUFqV7Gem5DnVO9k1z2unowF76PGIqgKqg7YGylCHzjW7ke067QK4YqHgCSopXUiz
        ka+GYZvOeU+JIba2eRX7bicKxRIU2No+PRbWqfRK6NVEWSRWybTmgOlgQOHKHXJrRH1FpaKlQyy
        yBNOQGh050hSzxZ7gL1YPY7DGI2dI6nWUBpvSabjzBRM5OTcfNarF5J9mYpZI1hLYwC7nFxhXIC
        XPkDTMLvGyaLyWJvBWLqcdF40kDywzhVZiqhieGz597RaJ+lCg==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.491700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25514.003
X-MDID: 1593641605-1YyOPCC_wjC3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/07/2020 20:03, Jakub Kicinski wrote:
> On Wed, 1 Jul 2020 15:51:25 +0100 Edward Cree wrote:
>> Unprivileged functions (such as VFs) may set their MTU by use of the
>>  'control' field of MC_CMD_SET_MAC_EXT, as used in efx_mcdi_set_mtu().
>> If calling efx_ef10_mac_reconfigure() from efx_change_mtu(), the NIC
>>  supports the above (SET_MAC_ENHANCED capability), and regular
>>  efx_mcdi_set_mac() fails EPERM, then fall back to efx_mcdi_set_mtu().
> Is there no way of checking the permission the function has before
> issuing the firmware call?
We could condition on the LINKCTRL flag from the MC_CMD_DRV_ATTACH
 response we get at start of day; but usually in this driver we've
 tried to follow the EAFP principle rather than embedding knowledge
 of the firmware's permissions model into the driver.
I suppose it might make sense to go straight to efx_mcdi_set_mtu()
 in the mtu_only && SET_MAC_ENHANCED case, use efx_mcdi_set_mac()
 otherwise, and thus never have a fallback from one to the other.
WDYT?

-ed
