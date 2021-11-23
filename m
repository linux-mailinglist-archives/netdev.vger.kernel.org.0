Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E58245AA1C
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 18:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239225AbhKWRdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 12:33:50 -0500
Received: from mail-am6eur05on2075.outbound.protection.outlook.com ([40.107.22.75]:1889
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233491AbhKWRdt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 12:33:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fgqXcbQul/QZIf5A11Yb7CDoofc12yT2EXJPzKyec2Xjit31hN9VA3vbarFRVqgL3SvKzyD7GSx97QTThrDtsGgSSho3nTUJhE2A5Uw1IavjPocV5qwvMHR95OV8bFgmKZ/P9HMqwBgSTgMtJSA0pZNKq1UFZDAhboZpNYVEGKqLYNz4HluSktoeSDwDz2xIVsUtF9NFBDwqVVLEpulKxpu/Mt2464Cop4ogOCFkXM9f3g4UQbzl2EcYqGQZ6M2ClFGOv/kNd7peUIBHRTVJJzv5AWX9OnaNonPouuQ/AOCQZvlbhqtBSFQdNiiUh4a4GEY4tFpxrEdG+odc8/ywBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xnsj+54Nl6ljgCYta1AQMNl1g05h5LJxhkIsh8BF2Ho=;
 b=A82vzSgNz+F6yGxkxM5G5F4PbRsUuCe2ItL1mBPTNmm7yMV9QQLz6UiOkqobY08saikcHH8INx5gPjBrJdOY8cRRVZ1RDKerDGwOz6heOeS10WzIVd/0GXD/7RrR/cit3WwpoND73FKQ2DiprrhWtebF6qGf0a4PCwjtE/aSI59UZAj1sTy3hDd/TE9YuMRHUX/h6ZvUIbgyAmDqD7wu6Axs7Ytv2PZacbCmizB6MiNmlNlRD9TkGk83p3ectIg+j4yDbl90TE6HEVGHDWuLxHC/ecAmODnkMU9eJ7oPSIMY8ANrGA+7DOAYB3iI4sOo+0VByG4EFn0Gw2HuQ85b4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xnsj+54Nl6ljgCYta1AQMNl1g05h5LJxhkIsh8BF2Ho=;
 b=OpUqzLfxNB9wyXpr8utqKvEdStSmqRr7tpwqOe6JJKrXQJlAWYHYWB6nRZiZSFohbXlMRPrEV8WyNljmNbUMCPLJaBRLKjElbBfhKcg6QMsI+Eg59uA42eIqRmDBDUjXP+6sp7t12bMiaBQ3u08bli9wdCTBhL4/gjKsEiWc0pc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB8PR03MB6025.eurprd03.prod.outlook.com (2603:10a6:10:ed::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Tue, 23 Nov
 2021 17:30:39 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee%4]) with mapi id 15.20.4713.025; Tue, 23 Nov 2021
 17:30:38 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH RFC net-next 8/8] net: phylink: allow PCS to be removed
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Chris Snook <chris.snook@gmail.com>, Felix Fietkau <nbd@nbd.name>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
References: <YZy59OTNCpKoPZT/@shell.armlinux.org.uk>
 <E1mpSba-00BXp6-9e@rmk-PC.armlinux.org.uk>
 <20211123120825.jvuh7444wdxzugbo@skbuf>
 <YZ0R6T33DNTW80SU@shell.armlinux.org.uk>
Message-ID: <90262b1c-fee2-f906-69df-1171ff241077@seco.com>
Date:   Tue, 23 Nov 2021 12:30:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YZ0R6T33DNTW80SU@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0158.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::13) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL1PR13CA0158.namprd13.prod.outlook.com (2603:10b6:208:2bd::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.11 via Frontend Transport; Tue, 23 Nov 2021 17:30:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18d4b05d-33e5-411d-5cf0-08d9aea6f750
X-MS-TrafficTypeDiagnostic: DB8PR03MB6025:
X-Microsoft-Antispam-PRVS: <DB8PR03MB602508A15692DC151AA5F6BD96609@DB8PR03MB6025.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wucGvEyKUrUX5YsvfWLdGrD13KESoKPZzujtOaOsugb4MxmTSMajtDrqN2JnNwQ8gvm764BDk1d05uzSPHl5yeL9SOVH6aZ4/2UY1lTYHi0jG+n02wMHhXrVH+TPoZaK8SKFXvQjnfKpk+EroZC3CpX/u8YKoZDTLSOtSijhrtpEP86UUa7r0IaqNAgBbF31Foi7cHRKZfTx1ypYzwULzs9yvXPcFSQYBMG4MVXpeEF5uPmh8UarCK9Px8mQos8lzPyW7fjRpqcVULczFltXX2SoqOIMEb9g+1oWUKl33IvWBc2NGjyBgna0Q00kwTooYGydnFLEYTiKWjkAw6OVzt+cq+016IlhAvk5XYLes1JZV72oNhOAS8rMMfbX+bWfF1MIUfg1hcPT4y+KKBdLQ7po88CG1c4abMrXmawEgsEBb6lAFmkkXA5FncG8nIoNP3miTJLivFJ9fI/tYsj64W3NkAlTKREP8zmkU0DheWRzey99h7p0c8OiSofWCBVfwyrsvoLjOZNkZCf+digXMdyTLQdKDaxgACqD4AISPCJ1551pz3Gav3GnQeBvtStoYk5WxL2V+ZZXIdhSv8iJ2+JdIYFgWZDpI+4N3idrIxrThlqv+nvG34eu2RMyH4cHp9ewy7AvpUdEgnyzS79IjodMQDe0CUEMbQleSUx+Kqrd4Hp5a1E7PHu8mzlCQ8RWiUIG6rYandxmbgTMuKve86ab/zuSmTVP1MJ246jZ6UjtNDtbtP7iAZcnX3lOVjNabEsFBOi5JcnueJvntOoEBm902HiIqTYglBuz0yIpCt19/akaDUIn2RlIqksZA9XVEl4VoiJ+02g0l7gg/LdjcMPGqOZW1BNtO9FEPXoLeII=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(966005)(31696002)(6486002)(53546011)(8936002)(16576012)(86362001)(38100700002)(38350700002)(956004)(36756003)(2616005)(54906003)(110136005)(4326008)(8676002)(186003)(44832011)(31686004)(52116002)(6666004)(2906002)(316002)(26005)(7416002)(83380400001)(508600001)(66556008)(5660300002)(66946007)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjQrZUJTSENsdkVPWGg0OE9WYUNNTmtDYkZjMys5MkFmVDA4b3JJZU5ucjVx?=
 =?utf-8?B?bkpnY2FIT21qbWsvZXdSYTdkV1BHeDZuUmowTG9iZC9PdmtsWDBCd09xUW9W?=
 =?utf-8?B?bGVrVnozWDNlREx1ZDhoL0NGQ2ZaV2pjTGVjOFhBc2dJVlArS1NSNXd6cFpL?=
 =?utf-8?B?NXNwMzlQZC90bWdEc3ltSUpmMDdCRFp3THp0aEVuRitwaTM0YjR5ekxta1FQ?=
 =?utf-8?B?ZFUrMWxzM2xOeFRpdjVEaVc2YUJDbmRFQ1hCQXdRVGU1aWpGVnEzd283K2do?=
 =?utf-8?B?dGxTaktsK2dkWXFBSVlJMERESUhKV1QzUmxndFg0RkJKZzV1VW41aVN6eUc0?=
 =?utf-8?B?U08vbDlma2RNNFpPTlczbnYzZ0J4UEVOOUtTTHVIYkVvRnN4UXlUcjA5a1ZW?=
 =?utf-8?B?Tk1ubXR6T2xObXZyZkkyeGVUK0JkR3VuN21mZDBZcEpwZDYxZlpmdjRuancv?=
 =?utf-8?B?TDVsWHRxV2VQZk4vUUNZN2k0aElWZDVFdHdiaWN0TE9pb2FBWGNKeE1KVU5j?=
 =?utf-8?B?a251NFBCMzFlU1dLaXVrWGluVFBCNExZOEhGRnFRamJ5QTd6elVqaG9tV3E5?=
 =?utf-8?B?bG5aYUhLMzFXbWtZakVBbXRvZlBid0xHZksxdkxYcXJ1YzN4Y1loNGQ0T2NF?=
 =?utf-8?B?VlRpczd3bExMZXBlWStIZ0k2RThUYzJVTXBQQzhuaDEydWhtUnVlNW0raTY3?=
 =?utf-8?B?NTBPbmtXNkg5SWhQYkNDTzYzZUdNQk5IN2ZnM2tpZFF5TmR2ZVgxVkJkMFl4?=
 =?utf-8?B?Q0FrdStpdFVLOUNLSmlLYko5QjhGTWhMS1pEeVF0YWtpVjYveC9WMVBHTHM5?=
 =?utf-8?B?ZWQvKzFyMUNSUDh2dzZxTUU0RnpKb1ZiV2l5TERYUnlrOHVtTkx0SlJuN0Zs?=
 =?utf-8?B?TWdHZUsxWmNFOTNid2dYWWhSNDJCU2w2bjI0SzFhZmlDZDlvUDUzSFBGRGJH?=
 =?utf-8?B?R3hFdkJ0emVWdy9NcVk1b25IdnRYV2plcDlKUmdFbVU0alltclF4S2JJRjV5?=
 =?utf-8?B?SjVvcXFyWWpoU3JOc0YrREw1eXVvR0xrMWVLSVQxL0xxZFJ3TEVrZDFnTVhx?=
 =?utf-8?B?UzFZZ3A1d0l2STdyZFdpcHE3Ym53TU9SQk4xWE40VEhCYWtCSFV1eFdNdHNC?=
 =?utf-8?B?cmxWU3BWM3VSK1JUNWNIUXNlNnB6bUNBQkVHa29aYmkzTzh1TkxTUXJpYUVq?=
 =?utf-8?B?MnJ2Ty9sZldhSVpDbVBxb1V1R1EvL2FoYjhVQk9EZkcvZE10eWF0OHl3czQ0?=
 =?utf-8?B?UE8xQ1JVZUFCQ1o3ZjFwQmwyWm5oZXBoaFJtZjRSREdEMXl2aHQ1ZWM0bVNn?=
 =?utf-8?B?cStqZUcweCtxVzE2MTNhYmV6Ym9JUW5qNGtxWXl3Z1NsbGgwSUtoT21JSmxP?=
 =?utf-8?B?aFowa21EanpSVmVzcUZ0eG16R1Raai9Ic21vVGNUMHNHRGl1R2VTNTZJM1Za?=
 =?utf-8?B?S3FvUTNyeEVKVzk5L1M0UmVGbU5NSEo5OFNOUFRmeU9zd1BKK3ZiVld2VzBk?=
 =?utf-8?B?dGx5eG1kazJVeWRZQ1lwcEYzY1lWVXJ5eXJTTDdNd2M2VERDUGhGRlJ5alNa?=
 =?utf-8?B?UjQ5WUdkeVNvdkZrOWF5dnM2K0xoOExPaldvL1JDVjlOQW9Gc0tvdVBWMnlk?=
 =?utf-8?B?eVhNVlNYWWwvakUzZXdYMytsRHRjRS9mdDZvenlhZEJkSDRsbTdFRGNRNThu?=
 =?utf-8?B?bG5UNDRxUHpJeVdhYWM1VzM5eThyV2dUZ1ZDaDBvbk1ZOVZDZkVhUm5SSkRH?=
 =?utf-8?B?NnIwZlV2ZE10SXhRVnQwYk82K205YzZlQXZrRzlXWWp0UE1vNExPVzU4TU1T?=
 =?utf-8?B?TkRDWmFwenZQc3ZoZVlQU3V4UWlNamRtdENYN0NoWTdoYjFxNkFuQUVsdmQ3?=
 =?utf-8?B?S2NCbjZhc0JacWp5WlV1clJYRWVoNFJUbzVKL3NHdThRc2Z0NkxFWHFCRzc3?=
 =?utf-8?B?SlZnTVFSMDB4bkUzQlQyeXBOVmppOU5UTXhMU2FxSUY3MTlPQTY5cVA3NTd3?=
 =?utf-8?B?S0JQNHVaZWM1ZzJWbFdaZkdkeHlkQWJ6UUFkQVM4Wk5GUTJ5dHMvaFVYYmNw?=
 =?utf-8?B?ZzVjTFd5ZWYwTWllckhNVXh1aDVLclhWRDRxcTBhUzNpT240WWlWdnpTVmFt?=
 =?utf-8?B?bGhXaU9DTjVxY2p1RldhajhSc3NKeEd3QzBXWVcvbGdla2ZjZTJlWEprOFEr?=
 =?utf-8?Q?aZAOWeHwl6t0CEB1t3nlTjk=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18d4b05d-33e5-411d-5cf0-08d9aea6f750
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 17:30:38.7838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kM7BpV+uGgG9hcqw14b+hL96R1qTJ585bFYfrF/nUYkqSZgTzmi3+O9XGnf9eKpsJa1d4MA8KXjzBFTJw7Mtcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB6025
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/21 11:08 AM, Russell King (Oracle) wrote:
> On Tue, Nov 23, 2021 at 02:08:25PM +0200, Vladimir Oltean wrote:
>> On Tue, Nov 23, 2021 at 10:00:50AM +0000, Russell King (Oracle) wrote:
>> > Allow phylink_set_pcs() to be called with a NULL pcs argument to remove
>> > the PCS from phylink. This is only supported on non-legacy drivers
>> > where doing so will have no effect on the mac_config() calling
>> > behaviour.
>> >
>> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>> > ---
>> >  drivers/net/phy/phylink.c | 20 +++++++++++++++-----
>> >  1 file changed, 15 insertions(+), 5 deletions(-)
>> >
>> > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
>> > index a935655c39c0..9f0f0e0aad55 100644
>> > --- a/drivers/net/phy/phylink.c
>> > +++ b/drivers/net/phy/phylink.c
>> > @@ -1196,15 +1196,25 @@ EXPORT_SYMBOL_GPL(phylink_create);
>> >   * in mac_prepare() or mac_config() methods if it is desired to dynamically
>> >   * change the PCS.
>> >   *
>> > - * Please note that there are behavioural changes with the mac_config()
>> > - * callback if a PCS is present (denoting a newer setup) so removing a PCS
>> > - * is not supported, and if a PCS is going to be used, it must be registered
>> > - * by calling phylink_set_pcs() at the latest in the first mac_config() call.
>> > + * Please note that for legacy phylink users, there are behavioural changes
>> > + * with the mac_config() callback if a PCS is present (denoting a newer setup)
>> > + * so removing a PCS is not supported. If a PCS is going to be used, it must
>> > + * be registered by calling phylink_set_pcs() at the latest in the first
>> > + * mac_config() call.
>> > + *
>> > + * For modern drivers, this may be called with a NULL pcs argument to
>> > + * disconnect the PCS from phylink.
>> >   */
>> >  void phylink_set_pcs(struct phylink *pl, struct phylink_pcs *pcs)
>> >  {
>> > +	if (pl->config->legacy_pre_march2020 && pl->pcs && !pcs) {
>> > +		phylink_warn(pl,
>> > +			     "Removing PCS is not supported in a legacy driver");
>> > +		return;
>> > +	}
>> > +
>> >  	pl->pcs = pcs;
>> > -	pl->pcs_ops = pcs->ops;
>> > +	pl->pcs_ops = pcs ? pcs->ops : NULL;
>> >  }
>> >  EXPORT_SYMBOL_GPL(phylink_set_pcs);
>> >
>> > --
>> > 2.30.2
>> >
>>
>> I've read the discussion at
>> https://lore.kernel.org/netdev/cfcb368f-a785-9ea5-c446-1906eacd8c03@seco.com/
>> and I still am not sure that I understand what is the use case behind
>> removing a PCS?
>
> Passing that to Sean to answer in detail...

My original feedback was regarding selecting the correct PCS to use. In
response to the question "What PCS do you want to use for this phy
interface mode?" a valid response is "I don't need a PCS," even if for a
different mode a valid response might be "Please use X PCS." Because
this function is used in validate(), it is necessary to evaluate
"what-if" scenarios, even if a scenario requiring a PCS and one
requiring no PCS would never actually be configured.

Typically the PCS is physically attached to the next layer in the link,
even if the hardware could be configured not to use the PCS. So it does
not usually make sense to configure a link to use modes both requiring a
PCS and requiring no PCS. However, it is possible that such a system
could exist. Most systems should use `phy-mode` to restrict the phy
interfaces modes to whatever makes sense for the board. I think Marek's
series (and specifically [1]) is an good step in this regard.

--Sean

[1] https://lore.kernel.org/netdev/20211123164027.15618-5-kabel@kernel.org/
