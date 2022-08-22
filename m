Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE3759C394
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 18:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236911AbiHVQBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 12:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236930AbiHVQAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 12:00:39 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70047.outbound.protection.outlook.com [40.107.7.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAC315A38;
        Mon, 22 Aug 2022 09:00:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Te8PU7brxdMHbpHtTgmtet1TBWFP4kr6Wq1sY5Q0qQMDnmVrFzLdvQBTx/uVttEq9mbHNwsvr06cDjT613mpi0Ub2DnesAdjrYbgNzfXs/KAkTM6ucOssUbFD0O25anJesnYOIAlV4l1W2MvFphgmzl0rjrjj4eh4ZLjayGTEL6GJER85d+D16ihLssi1TMcQGcKuZ2PciZ5IgZin4B9qg5Kq5zJUKYD/Co4HEp9ZkuoAsCFbQuya8WkkrWGwjvTwTX4ZacnERK6/oFk+I9qMu+bH699pqw1jbyPO9m7+t08OmV1oLI9+hrmSmPcvXzxES4ja4SoacmJd0YOgnqJtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AlP9rYbLXUFbMjvI3oJYVsKO1UgnJPTkmVEafL9844k=;
 b=GeF3/rk8+XQWZeHHaxoRNC0EP34y7ywEKYJiG1VqLGr8G1XO5Mc6YUDXypk+SvnnOypmL21GaS05VOGVZ7ppVFqSHji+1CQSnD8Q8Jj3sYOoYczRkRMm9P/GupD0TgifYQ+um1svKde8BT+Dpuu1t/6R5kt9nQzCabfi9WmN2Hma635fU8RV/owl53VgoYCymyrvY8mtyRwUOOer96OuB3rlXUncUdrEQO1yqq95Dp4pFWVJaqcL7xhhB1z/Gs2z/Cpr6JU4AUEEHnqNbGERdw7WIjzBHFyp1c/hnapBfj55udaj0c57GsNnyfl/4hjDHkH2PYExKq7vHBt5o+h3YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AlP9rYbLXUFbMjvI3oJYVsKO1UgnJPTkmVEafL9844k=;
 b=SDaZ/SKXjTntuZIlkBnWqy4YVuiKl4u7Z4bTnhgQ8bNETUyFm0E14EJDGCgm7TSEHlLfn5UZNsZEquqQZ5DmkV+MTGLQwepwq2QR40QZokRGmVSxas2EqYCie64RElFYtYXd/WwmTWH9yWoeoZ65WVPZpW7k7l0R7xl9K+LfqifFGrqxB5mfsUMlBsPNA+5IRRBCKaH6ueztLhNaCuCGWLFg1LXpaaU7SmVo4FNeWOxQkLXYY+PTHxbajlNuxV0e1nOTjqFmsrsd8bs887ddVy1fxD3fDXTyBICN5bwjQeXAfogeIt9jxQhkYfbugvMU4retTQBHEAYxbtRknPS5KQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM0PR03MB4259.eurprd03.prod.outlook.com (2603:10a6:208:cb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Mon, 22 Aug
 2022 16:00:31 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Mon, 22 Aug 2022
 16:00:31 +0000
Subject: Re: [PATCH net] net: phy: Warn if phy is attached when removing
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20220816163701.1578850-1-sean.anderson@seco.com>
 <20220819164519.2c71823e@kernel.org> <YwAo42QkTgD0kOqz@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <b476d7b1-1221-2275-e445-6a70b3a31fe6@seco.com>
Date:   Mon, 22 Aug 2022 12:00:28 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YwAo42QkTgD0kOqz@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0314.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::19) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ee791ef-cc6a-40ff-db2f-08da845770c6
X-MS-TrafficTypeDiagnostic: AM0PR03MB4259:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tyk2wFytbGTglCHinF9pc8MuX93jJl8mBtqt6CzEcz2R7C+VrShSTzR8jHQ0Md3Lg/S1dtKsq6qlll12y0vqUGuS+36Fg5yvSZc6GSJSLxXJgdsmGJBZqtQwTCnpK9BLM88JP3Ry9AbwMbl1fxPjjHVpOXvbajISVj7y0H/HE0vwmrC/NDm5OCuXSTxZOpUs3hy7arhS21KDuOnJ09pPnEqU3f8q7YqGKvG31e6OQ/nBiaq5D1iIEB4A1zr1W39JXPNUaqtLUPswDdbGvgj6RU35/PHCFc8YEGTQHHxm3usH75BJoTjDIuF0/neX5V8fTKm4wez/2q0qo/5Jk0aY2SoXQFVC68NJOAIBfu0z7t7Nl/tnKwW2YyufU7EE+ltjw0yhVudy6aM2w2kjFJGieiP2aKXt/MOe/EhPz3Crr6K5bowd+Ae0RTRqzVjmA/NDjEeEGtOlZavV4xJYQV5iK8pP1/u4I/MMPzNP86Hn555kEVuZw2TMBnVj5737uuPAX58wISua8lxHTv/qTrbB9NQiPSaUVn3IsHBl1530fPSytVwCYsvzT38fHNiw949QEW7FeA2RZflcDBrRMw8C0xnYI/k3Z3foTtI+0gwcjxqSJ8opzOYjbzWt1HGpV/BO0hXMBXyuojOvE/ez8n/adsyZ7QPjO8vMeUPgIbSscZ6dfbbWFHBefszleT3Im6HZ6OyxR8xi8rvP0J9ndEVlkqV8G/2g22WVLPq+aTv0RK6X3Q1Ae73VmViW6JknA0eB+Mv5ir39Rx93If1SH2zXZvmiyr3qjb/DgYFdNeLRzv5dwVhUzTlfB1kD1ZLeEnU0YWETC/gXyXBE1m92nDC7DQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(366004)(346002)(39850400004)(136003)(44832011)(66946007)(8676002)(66556008)(66476007)(4326008)(31686004)(86362001)(31696002)(54906003)(110136005)(36756003)(38350700002)(38100700002)(2616005)(186003)(6512007)(26005)(53546011)(52116002)(6506007)(6666004)(6486002)(478600001)(7416002)(316002)(2906002)(83380400001)(8936002)(41300700001)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUZrRlBhVWwrSVlad3NjSnNXdmIrZlMrZ3RrNCtVZ2FOQlc4cGlWN3dVbkpK?=
 =?utf-8?B?cVpVMUdlcDBvQ0c4U3g0Yzd3VmoyVTRWV2FJMlFyaVU4N2NVQnVhRHBOb3N1?=
 =?utf-8?B?MHc1Sit2SnhrdHh2N2dGUG9MM3kxT3c3WmRxR1lzekErc1NrWUkxZ1cvcHlM?=
 =?utf-8?B?ZGNjWWkwMzdydjV1ekgzVUpjNnNXcWtUK3htVE1RN0gwQVkwVnRWZUZNYlY5?=
 =?utf-8?B?enNwMUxRUGpmeCtzVkdnMEhoQVk1Q1daZDFxZWFYa1poeGlReVVJSVh3MHlG?=
 =?utf-8?B?a2drSDdKbFVwL2FFNEplY1V3TFB5MzdvaWdzQnRGUTFEUEFKUUN3ZUVESEhV?=
 =?utf-8?B?Yk1JL3NjQTlwMVRwWVgwUGhZMkR6eDVzc3NaUENnakNRcUM1N01FeG5zQWZL?=
 =?utf-8?B?bHJSWExieFNKbWs3MmtOUjYzN0ZFdlNkUmZkVWlmcWpiMXF3OGFTZkcwSjhw?=
 =?utf-8?B?aW9IWkdzMXBUNXBjcUVyRGhOR3ZJL3ZJNGhhaURMR1NRNS91dWFCTHZuTGpZ?=
 =?utf-8?B?MHVEZHkxZ0tITXFwUlcwZkM2Um4xWWRQMDJSNXJsdHNuejNIZGVyYWdhbUlt?=
 =?utf-8?B?Q2pGQjd4TGJXNmV6a1RXelhyMWJsZEdaNmh5WDlCeCt4RXF2TVF3MFMrR29x?=
 =?utf-8?B?ejRpZjY5QjJ1Vm90TjZNcHB5RzYyOWFKUWlIbXB4bEl4aGxTVG00WDJjTDNj?=
 =?utf-8?B?MDBJMHNEMWRhY3g1RXE1SzVHdW1ud0NEQm1DZjNYYlZyUS9oZ3Z1TnJHNG1t?=
 =?utf-8?B?aEtob0EzeFNVMHdBS2hKRVZCZkFWaXg0aDcyc3ZhVjAwcHNvdFJYTjV5L2cw?=
 =?utf-8?B?R2RTdlQ0aXkyNE9WRmFVSWpURHU2TmY1QXlUODdNaGhTcldqaE1kWkFwazQr?=
 =?utf-8?B?VmUxUC92aU0vd2YwSUpoSjdmTGJYMWRaN2QrbzJIZHlPWmRRRTc1ekNvb2xr?=
 =?utf-8?B?RVh6NzRJMDlFdEcyNW94WFNvY2R1VW5WS1YrQUpORmhtQm5TR280aTlsU09q?=
 =?utf-8?B?ZGdISndPVDV4Y0VaNUZWTHZ1aW1taFBuTDJaZ21hV1BEUCtISWZoSkUrTHpi?=
 =?utf-8?B?elh1NWV2NzhUdWNTYXNUR25EU0FOWElLOTdGZFhURW4vNE9pN3dIRVJTaFk0?=
 =?utf-8?B?NVRGL2x0SXlKclVMK1RYc25ZaWRaNmVnZFQxOFVLZkFyNGJ0dUJzWGcxY3VW?=
 =?utf-8?B?Y0U5bGVRRHBnZUR2NENhTTV5ZUNSSVc2NytWdERTZmkxUFVOcll1Sk1FVEN2?=
 =?utf-8?B?cUJvYXdrcFUxcUZmeTd5RFNEYmZNVFRGaG9udG5SYVdBNU9IOUMvY3ZZNEJB?=
 =?utf-8?B?K01MM3JLdThqZlU4VTZISmlNc2grK1Qrb3pNTy9XazNlQzlkVlVCbWdIcy9S?=
 =?utf-8?B?QjJ3cVNTT3NJRG40NkZCRFNBcVVCL29yVWx0TmFBc05oNDMra2hGbExYN0ox?=
 =?utf-8?B?TU9BR1hQQ0dBa3RMNURvMksrNWtCS2tZeWRaeU1QVHo1N284VFVvY3BUbXZI?=
 =?utf-8?B?TnFMRFZhZTNTd1BGVWxvRzI1UTFtaFNvR0RiWXJiTTd1SDlRM0xsaEprN1Z5?=
 =?utf-8?B?S290aUxNajJLbEVycXEvYWNDWHlWc1o0VWptaDEzRENXUDEyelI5M0d6UTlX?=
 =?utf-8?B?VW0weXdhV0RXSlplM1NVcko5Zk9vZkl6dXVKcUJsM29ybkRXMUZJK3FFTjBE?=
 =?utf-8?B?Sk1zdXNVOWVjUk9xbncvaFcwVXpJK3psYWR4NlVsUzhRQnZSRW9TSnQwWVRV?=
 =?utf-8?B?Wk5mcnFTYmNmV2FmWHNaak9nVHUzSy9Ga01jZXVXZVJQYitzdUQ3MTBSWjA5?=
 =?utf-8?B?empEL05RVzExYXFSQUlrbkZXWm9QVU1PWWlkTjMyRG1CZTIyOXZ1WnVFSlVv?=
 =?utf-8?B?bGNwclVZaUQyTjIwRHZocUVzMGxxWFVyTDk5ZkxPQmgvSWxaanE0djZIQUdK?=
 =?utf-8?B?aTk1WUl6dnNORVVST05WaTlHTzFVeldtUzcxM1RHNTBrNWJtNkduZk5YR1dG?=
 =?utf-8?B?UXBsdjUvT0I5M1ZpU0pEeERZVG9XeXZSamVZWkIwMnpaVFN2azBibHZ2d056?=
 =?utf-8?B?bitodTkwMzlwbmNCczU1RVlicTAvWmRDNXQyY21LaWl2QzBSMGlJZHd4UzJK?=
 =?utf-8?B?YnNVdDkxNHJwNE8zd1pNU01GcFFBa0wrQWZFWDBDWE5oVDBWVDhmUnVqZVJ0?=
 =?utf-8?B?eWc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ee791ef-cc6a-40ff-db2f-08da845770c6
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 16:00:31.6541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4lUCzd4ElTrrcl9IGXAOPBblfM7vHth1MiiFjdnGRGEPuLZrVw+CL6EsiSjeHsEsyjvIyNNsmxS3jhFzVzu7oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR03MB4259
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/22 8:20 PM, Russell King (Oracle) wrote:
> On Fri, Aug 19, 2022 at 04:45:19PM -0700, Jakub Kicinski wrote:
>> On Tue, 16 Aug 2022 12:37:01 -0400 Sean Anderson wrote:
>> > netdevs using phylib can be oopsed from userspace in the following
>> > manner:
>> > 
>> > $ ip link set $iface up
>> > $ echo $(basename $(readlink /sys/class/net/$iface/phydev)) > \
>> >       /sys/class/net/$iface/phydev/driver/unbind
>> > $ ip link set $iface down
>> > 
>> > However, the traceback provided is a bit too late, since it does not
>> > capture the root of the problem (unbinding the driver). It's also
>> > possible that the memory has been reallocated if sufficient time passes
>> > between when the phy is detached and when the netdev touches the phy
>> > (which could result in silent memory corruption). Add a warning at the
>> > source of the problem. A future patch could make this more robust by
>> > calling dev_close.
>> 
>> FWIW, I think DaveM marked this patch as changes requested.
>> 
>> I don't really know enough to have an opinion.
>> 
>> PHY maintainers, anyone willing to cast a vote?
> 
> I don't think Linus is a fan of using WARN_ON() as an assert()
> replacement, which this feels very much like that kind of thing.
> I don't see much point in using WARN_ON() here as we'll soon get
> a kernel oops anyway, and the backtrace WARN_ON() will produce isn't
> useful - it'll be just noise.
> 
> So, I'd tone it down to something like:
> 
> 	if (phydev->attached_dev)
> 		phydev_err(phydev, "Removing in-use PHY, expect an oops");

That's fine by me

> Maybe even introduce phydev_crit() just for this message.
> 
> Since we have bazillions of network drivers that hold a reference to
> the phydev, I don't think we can do much better than this for phylib.
> It would be a massive effort to go through all the network drivers
> and try to work out how to fix them.

In the last thread I posted this snippet:

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index a74b320f5b27..05894e1c3e59 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -27,6 +27,7 @@
 #include <linux/phy.h>
 #include <linux/phy_led_triggers.h>
 #include <linux/property.h>
+#include <linux/rtnetlink.h>
 #include <linux/sfp.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
@@ -3111,6 +3112,13 @@ static int phy_remove(struct device *dev)
 {
        struct phy_device *phydev = to_phy_device(dev);
 
+	// I'm pretty sure this races with multiple unbinds...
+       rtnl_lock();
+       device_unlock(dev);
+       dev_close(phydev->attached_dev);
+       device_lock(dev);
+       rtnl_unlock();
+       WARN_ON(phydev->attached_dev);
+
        cancel_delayed_work_sync(&phydev->state_queue);
 
        mutex_lock(&phydev->lock);
---

Would this be acceptable? Can the locking be fixed?

> Addressing the PCS part of the patch posting and unrelated to what we
> do for phylib...
> 
> However, I don't see "we'll do this for phylib, so we can do it for
> PCS as well" as much of a sane argument - we don't have bazillions
> of network drivers to fix to make this work for PCS. We currently
> have no removable PCS (they don't appear with a driver so aren't
> even bound to anything.) So we should add the appropriate handling
> when we start to do this.
> 
> Phylink has the capability to take the link down when something goes
> away, and if the PCS goes away, that's exactly what should happen,
> rather than oopsing the kernel.

Yeah, but we can't just call phylink_stop; we have to call the function
which will call phylink_stop, which is different for MAC drivers and
for DSA drivers. I think we'd need something like

struct phylink_pcs *pcs_get(struct device *dev, const char *id,
			    void (*detach)(struct phylink_pcs *, void *),
			    void *priv)

which would also require that pcs_get is called before phylink_start,
instead of in probe (which is what every existing user does).

> As MAC drivers hold a reference to the PCS instances, as they need to
> select the appropriate one, how do MAC drivers get to know that the
> PCS has gone away to drop their reference - and tell phylink that the
> PCS has gone. That's the problem that needs solving to allow PCS to
> be unbound if we're going to make them first class citizens of the
> driver model.
> 
> I am no fan of "but XYZ doesn't care about it, so why should we care"
> arguments. If I remember correctly, phylib pre-dates the device model,
> and had the device model retrofitted, so it was a best-efforts
> attempt - and suffered back then with the same problem of needing
> lots of drivers to be changed in non-trivial ways.
> 
> We have the chance here to come up with something better - and I think
> that chance should be used to full effect.

---

This whole thing has me asking the question: why do we allow unbinding
in-use devices in the first place?

--Sean
