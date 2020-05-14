Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00DF1D3210
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 16:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgENOEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 10:04:25 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:36370 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726037AbgENOEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 10:04:25 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7A30060154;
        Thu, 14 May 2020 14:04:24 +0000 (UTC)
Received: from us4-mdac16-71.ut7.mdlocal (unknown [10.7.64.190])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 77091200A4;
        Thu, 14 May 2020 14:04:24 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.198])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id EC7D722005B;
        Thu, 14 May 2020 14:04:23 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7F99F80079;
        Thu, 14 May 2020 14:04:23 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 14 May
 2020 15:04:05 +0100
Subject: Re: [PATCH net-next 0/3] net/sched: act_ct: Add support for
 specifying tuple offload policy
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        "David Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1589464110-7571-1-git-send-email-paulb@mellanox.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <3d780eae-3d53-77bb-c3b9-775bf50477bf@solarflare.com>
Date:   Thu, 14 May 2020 15:04:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1589464110-7571-1-git-send-email-paulb@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25418.003
X-TM-AS-Result: No-3.392000-8.000000-10
X-TMASE-MatchedRID: 5+1rHnqhWUTmLzc6AOD8DfHkpkyUphL9ftMGQDsmQ9VjQ6o1zjtGHt5Q
        ZVAH5Zt2cA6Je1CctfALsisEKlLgtkhOQdH7l0qd4h8r8l3l4eaMet8O/Z/mflsrjjPHCPnno8W
        MkQWv6iUDpAZ2/B/BlgJTU9F/2jaz3QfwsVk0UbsIoUKaF27lxQoD3ZFqgkCgeJhtL0mVQg8GDd
        hHR/NyeNYqYF1r5nIQ4OdZuoKqNwGtGnpIUiGpzvPYGUnijbw4l/vXpKd+m8Ge00mtWwdAelhyp
        MYDQDzxD9Au3sb+hzremBDir87rC45Kid9B1A2Knqg/VrSZEiM=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.392000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25418.003
X-MDID: 1589465064-MttGaeXoc65S
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/05/2020 14:48, Paul Blakey wrote:
> To avoid conflicting policies, the policy is applied per zone on the first
> act ct instance for that zone, and must be repeated in all further act ct
> instances of the same zone.
Is the scope of this the entire zone, or just offload of that zone to a
 specific device?
Either way, the need to repeat the policy on every tc command suggests
 that there really ought to instead be a separate API for configuring
 conntrack offload policy, either per zone or per (zone, device) pair,
 as appropriate.

-ed
