Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C702D17EC36
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 23:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgCIWkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 18:40:17 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:49628 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726656AbgCIWkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 18:40:16 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 53FA4B00064;
        Mon,  9 Mar 2020 22:40:15 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 9 Mar 2020
 22:40:08 +0000
Subject: Re: [PATCH net-next ct-offload v2 05/13] net/sched: act_ct: Enable
 hardware offload of flow table entires
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Paul Blakey <paulb@mellanox.com>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583676662-15180-1-git-send-email-paulb@mellanox.com>
 <1583676662-15180-6-git-send-email-paulb@mellanox.com>
 <62d6cfde-5749-b2d6-ee04-d0a49b566d1a@solarflare.com>
 <20200309221953.GJ2546@localhost.localdomain>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <a6817bc6-17bf-ee29-4910-9c287bbc6646@solarflare.com>
Date:   Mon, 9 Mar 2020 22:40:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200309221953.GJ2546@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25278.003
X-TM-AS-Result: No-5.696800-8.000000-10
X-TMASE-MatchedRID: scwq2vQP8OEf2uG5NUkiu/ZvT2zYoYOwC/ExpXrHizw/hcT28SJs8qDS
        FbNSvOcncSBIJeE8AJSr/+Gm/JK2uueiDxJcK5MJY1bQMCMvmn6MeFePU0tuMOFjQ62VhP8bS8X
        QUmo7QNh1C0eA/+ELkI0pfouzkP9TlML+266Ikxokp7iSXiinhC/6pa9YxNkxvPwQoyIZS6c0Vl
        Fe0MnlXqPcX3xJIWl8vZOz5ptwyPpD/MGHLum03p4CIKY/Hg3AcmfM3DjaQLHZs3HUcS/scCq2r
        l3dzGQ1LKRDQhtaB1iTBPEehRpVL5LZaKBQPBJ0/quB0ltwFDbcebm8SUe7c8C+ksT6a9fy
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.696800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25278.003
X-MDID: 1583793616-Tg3RTdCX9RTF
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/03/2020 22:19, Marcelo Ricardo Leitner wrote:
> On Mon, Mar 09, 2020 at 09:25:49PM +0000, Edward Cree wrote:
>> This doesn't seem to apply to net-next (34a568a244be); the label after
>>  the __module_get() is 'out_unlock', not 'take_ref'.  Is there a missing
>>  prerequisite patch?  Or am I just failing to drive 'git am' correctly?
> That's a mid-air collision with Eric's
> [PATCH net-next] net/sched: act_ct: fix lockdep splat in tcf_ct_flow_table_get
> That went in in between v1 and v2 here.
>
>   Marcelo
Thanks.
Unfortunately, although going back to that commit's parentmakes this
 patch apply, #6 still doesn't, and I don't particularly feel like
 playing whack-a-mole.  Paul, could you either specify the base from
 which you generated this series, or stick the branch somewhere that
 can be pulled from, please?  I'd like to build it so that I can
 start experimenting with driver code to interface with it.

TiA,
-ed
