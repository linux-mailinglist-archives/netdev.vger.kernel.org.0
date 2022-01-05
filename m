Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45CB484F8A
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 09:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238635AbiAEIrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 03:47:20 -0500
Received: from mail-eopbgr70051.outbound.protection.outlook.com ([40.107.7.51]:19332
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238594AbiAEIrJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 03:47:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XCaHH4pKBKRCtOyt71+G7tG26ruwGzvKpMcC11PUQLlluKpYKHp2pnZ72Ot7cf0NT/+y3tYvGDCeFVdYOYa84BVOCBiSiwRxTV87NBDutTNpXFtjn3VOB2NbouWiYj6fR/kc/6v4OFNSFg7r6I30LnHf6g8ZWpIVLrDsCVRQfKQllcThd82PKIcczue8yv8+lV2pbzaYDhGqjxIc6E/hBSgcwEJ92mONuFIU+kKypH25AI5HvkOCopMw5bnZsYX6b8J59WZdEll8FNfQIk22jhFZf5+0zkPIn47nt2Bot597pXJ9iQQ95BdlGgh7qc8tNIn3Y+epiFgO/2Rc1e+wZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b45WjhN4Ylvsauq51Rl2aheOIdZgCfxLsDLoSb14JZw=;
 b=b2OuRSuKYAo6j/4iJw57/kn6q86kglQMvf5maQ/TfkYZyR33rye3YDd6xpZpSjzWm01Z+6p08b5TBXZs4T0h2dNqEyu+IHUK2x8IK3yQlE4ISswfYMlblmCVffYAV+LnJg/J3tfbSPLKv25CsQt6mw23FSss0E1OC9MGEhqreTiZSO1s8/g1UK7wGwbCU/B4fkN4vfQP2S7LK08UeiW20z2pmseFSHuor1XiNjAc79xp5nWBf/ei1HK9KHPl2XpsgTbN61d/AjsJ2uuoUCI9Wt8B5XH4CfjYXr2NfdZoeuDeBoAmTK/zwQ6U4R2+fNZRThp5/jAPuyvkycuGcoa1uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.72) smtp.rcpttodomain=canonical.com smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b45WjhN4Ylvsauq51Rl2aheOIdZgCfxLsDLoSb14JZw=;
 b=BPwwuS1RfeTHym8wKd432NwuQjFgSTrFFMy/K0svbkk5iVBv+uOO7fq8vhGJKAIJATSTirvPhFmsexi9WR+xvdH1BNeBga+g/NssRy5ZiFt6gNGHQNP8g9vLZJsLcv2rOIOHT6AnO5VUepzra99QkLTcacPxpwLyuArlNkMsRQDwEc1aC14/w/Abns6llOwwpAzGp1+POn2vitDCCcjB5ps4td/G37e7bLyjwmphf75e5a3APctRCBBNsh77aWXUqeA6GxMMg+eWu0TqYRYKjr0UqslErjS2DNXcH4nV+tgufnPs5VMrl5iilq2563Cp/wP1zlQxkmsDAgEfb8ntAw==
Received: from AM6PR10CA0061.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:80::38)
 by VI1PR1001MB1248.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:800:de::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Wed, 5 Jan
 2022 08:47:06 +0000
Received: from VE1EUR01FT040.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:209:80:cafe::a2) by AM6PR10CA0061.outlook.office365.com
 (2603:10a6:209:80::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15 via Frontend
 Transport; Wed, 5 Jan 2022 08:47:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.72)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.72 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.72; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.72) by
 VE1EUR01FT040.mail.protection.outlook.com (10.152.3.46) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4867.9 via Frontend Transport; Wed, 5 Jan 2022 08:47:05 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SMA.ad011.siemens.net (194.138.21.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 09:47:04 +0100
Received: from md1za8fc.ad001.siemens.net (158.92.8.107) by
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 09:47:04 +0100
Date:   Wed, 5 Jan 2022 09:47:02 +0100
From:   Henning Schild <henning.schild@siemens.com>
To:     Aaron Ma <aaron.ma@canonical.com>
CC:     <kuba@kernel.org>, <linux-usb@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <hayeswang@realtek.com>, <tiwai@suse.de>
Subject: Re: [PATCH] net: usb: r8152: Check used MAC passthrough address
Message-ID: <20220105094702.561967ae@md1za8fc.ad001.siemens.net>
In-Reply-To: <ba9f12b7-872f-8974-8865-9a2de539e09a@canonical.com>
References: <20220105061747.7104-1-aaron.ma@canonical.com>
        <20220105082355.79d44349@md1za8fc.ad001.siemens.net>
        <20220105083238.4278d331@md1za8fc.ad001.siemens.net>
        <e71f3dfd-5f17-6cdc-8f1b-9b5ad15ca793@canonical.com>
        <20220105085525.31873db2@md1za8fc.ad001.siemens.net>
        <fc72ca69-9043-dc46-6548-dbc3c4d40289@canonical.com>
        <20220105093218.283c9538@md1za8fc.ad001.siemens.net>
        <ba9f12b7-872f-8974-8865-9a2de539e09a@canonical.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [158.92.8.107]
X-ClientProxiedBy: DEMCHDC89YA.ad011.siemens.net (139.25.226.104) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be01d704-d08a-4695-6b56-08d9d027f39f
X-MS-TrafficTypeDiagnostic: VI1PR1001MB1248:EE_
X-Microsoft-Antispam-PRVS: <VI1PR1001MB1248F803FFDF15669DE3B2C9854B9@VI1PR1001MB1248.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Ia922ELf97wLibvBMYMIzBQKIBFxHyGL5JDOxe3heyZAYwOf3gz/84iEJNC7QBXu3BHZ91mKCJM2iG3g0ShlRYIsGvAfbrQ4MpxF/m1IU4oYdgeQZaZLZVA4rg/CsA+Gx40kvvkKomTI/RlIvvYIysLC2ybrT/rwkfh7U0NycPmmcB/5jfbpPsXbY5ZNE/GfFp2SA/kYDui0ETzLwpjWTFT4tIlinovrrFA4IgVEacPc2vjWlSKMLU4NBeRv7CHtD0WdcQ7z0apJBI0/h0CCZTHzw2Gpwj3Tv31jD66o9mWZZI+b0JXnnLX64C+tCZ4x9lHAO5lfSfcnBzjyw21sRxHm2PYV9PGXN6Qvz67IeI930AP7E+y4HHk81TnycKBaxFmemCFZpPibfMSH7qgvYze1WMR5xygjDZWLhaOzzxHTrjoDNiW+esaibcbKgE5Xkv0dCms1E806oA0X3m170FsCDAweT7scdaBHi47ANwEi3fKanrn/zrIwlzbt1a0W2AMfHeWvgpoBpejPT5YF+PrXA43uNGPpd3CNATHO0k6Bx3iDyt3BiHgN/jOOTYJXkOgTIjPw2g32REiUxy235AnC4/LjqjYTzInnW3sZlPIw6PJqaMiVevb+mwwYp6AqroCLWFDfzVBnMxZ6Qr1WAG3FzVDVNZJ8EsKf27yp9C41d9ligyWmJ7kJ1bHCkKoZAuJVFQrM59QnPlOtYAOjrqkXnYQkisC+tSvuhss1ATszgx5xaTNbh51kNTwkSlINrGOhFdWRdOUtBrf/Ufj5ayge5YO0oXePvqgs/Ndtb0=
X-Forefront-Antispam-Report: CIP:194.138.21.72;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(9686003)(8676002)(83380400001)(44832011)(4326008)(336012)(53546011)(8936002)(54906003)(5660300002)(47076005)(82310400004)(956004)(81166007)(7696005)(55016003)(498600001)(36860700001)(356005)(16526019)(186003)(82960400001)(6916009)(70206006)(86362001)(1076003)(26005)(70586007)(2906002)(40460700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 08:47:05.8624
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be01d704-d08a-4695-6b56-08d9d027f39f
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.72];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR01FT040.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR1001MB1248
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Wed, 5 Jan 2022 16:37:11 +0800
schrieb Aaron Ma <aaron.ma@canonical.com>:

> On 1/5/22 16:32, Henning Schild wrote:
> > Am Wed, 5 Jan 2022 16:01:24 +0800
> > schrieb Aaron Ma <aaron.ma@canonical.com>:
> >   
> >> On 1/5/22 15:55, Henning Schild wrote:  
> >>> Am Wed, 5 Jan 2022 15:38:51 +0800
> >>> schrieb Aaron Ma <aaron.ma@canonical.com>:
> >>>      
> >>>> On 1/5/22 15:32, Henning Schild wrote:  
> >>>>> Am Wed, 5 Jan 2022 08:23:55 +0100
> >>>>> schrieb Henning Schild <henning.schild@siemens.com>:
> >>>>>         
> >>>>>> Hi Aaron,
> >>>>>>
> >>>>>> if this or something similar goes in, please add another patch
> >>>>>> to remove the left-over defines.
> >>>>>>        
> >>>>
> >>>> Sure, I will do it.
> >>>>     
> >>>>>> Am Wed,  5 Jan 2022 14:17:47 +0800
> >>>>>> schrieb Aaron Ma <aaron.ma@canonical.com>:
> >>>>>>        
> >>>>>>> When plugin multiple r8152 ethernet dongles to Lenovo Docks
> >>>>>>> or USB hub, MAC passthrough address from BIOS should be
> >>>>>>> checked if it had been used to avoid using on other dongles.
> >>>>>>>
> >>>>>>> Currently builtin r8152 on Dock still can't be identified.
> >>>>>>> First detected r8152 will use the MAC passthrough address.
> >>>>>>>
> >>>>>>> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> >>>>>>> ---
> >>>>>>>     drivers/net/usb/r8152.c | 10 ++++++++++
> >>>>>>>     1 file changed, 10 insertions(+)
> >>>>>>>
> >>>>>>> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> >>>>>>> index f9877a3e83ac..77f11b3f847b 100644
> >>>>>>> --- a/drivers/net/usb/r8152.c
> >>>>>>> +++ b/drivers/net/usb/r8152.c
> >>>>>>> @@ -1605,6 +1605,7 @@ static int
> >>>>>>> vendor_mac_passthru_addr_read(struct r8152 *tp, struct
> >>>>>>> sockaddr *sa) char *mac_obj_name; acpi_object_type
> >>>>>>> mac_obj_type; int mac_strlen;
> >>>>>>> +	struct net_device *ndev;
> >>>>>>>     
> >>>>>>>     	if (tp->lenovo_macpassthru) {
> >>>>>>>     		mac_obj_name = "\\MACA";
> >>>>>>> @@ -1662,6 +1663,15 @@ static int
> >>>>>>> vendor_mac_passthru_addr_read(struct r8152 *tp, struct
> >>>>>>> sockaddr *sa) ret = -EINVAL; goto amacout;
> >>>>>>>     	}
> >>>>>>> +	rcu_read_lock();
> >>>>>>> +	for_each_netdev_rcu(&init_net, ndev) {
> >>>>>>> +		if (strncmp(buf, ndev->dev_addr, 6) == 0) {
> >>>>>>> +			rcu_read_unlock();
> >>>>>>> +			goto amacout;  
> >>>>>>
> >>>>>> Since the original PCI netdev will always be there, that would
> >>>>>> disable inheritance would it not?
> >>>>>> I guess a strncmp(MODULE_NAME, info->driver,
> >>>>>> strlen(MODULE_NAME)) is needed as well.
> >>>>>>        
> >>>>
> >>>> PCI ethernet could be a builtin one on dock since there will be
> >>>> TBT4 dock.  
> >>>
> >>> In my X280 there is a PCI device in the laptop, always there. And
> >>> its MAC is the one found in ACPI. Did not try but i think for such
> >>> devices there would never be inheritance even if one wanted and
> >>> used a Lenovo dock that is supposed to do it.
> >>>      
> >>
> >> There will more TBT4 docks in market, the new ethernet is just the
> >> same as PCI device, connected by thunderbolt.
> >>
> >> For exmaple, connect a TBT4 dock which uses i225 pcie base
> >> ethernet, then connect another TBT3 dock which uses r8152.
> >> If skip PCI check, then i225 and r8152 will use the same MAC.  
> > 
> > In current 5.15 i have that sort of collision already. All r8152s
> > will happily grab the MAC of the I219. In fact i have only ever
> > seen it with one r8152 at a time but while the I219 was actively in
> > use. While this patch will probably solve that, i bet it would
> > defeat MAC pass-thru altogether. Even when turned on in the BIOS.
> > Or does that iterator take "up"/"down" state into consideration? But
> > even if, the I219 could become "up" any time later.
> >   
> 
> No, that's different, I219 got MAC from their own space.
> MAC passthrough got MAC from ACPI "\MACA".

On my machine "\MACA" and I219 are the same, likely "\MACA" was
populated by looking at that I219 by the BIOS.
Not sure if "\MACA" can change when plugging docks, but probably not
since the BIOS is also trying to implement inheritance of the main MAC.

Let me try this patch, maybe i do not get it.

Henning

> > These collisions are simply bound to happen and probably very hard
> > to avoid once you have set your mind on allowing pass-thru in the
> > first place. Not sure whether that even has potential to disturb
> > network equipment like switches.
> >   
> 
> After check MAC address, it will be more safe.
> 
> Aaron
> 
> > Henning
> >   
> >> Aaron
> >>  
> >>> Maybe i should try the patch but it seems like it defeats
> >>> inheritance completely. Well depending on probe order ...
> >>>
> >>> regards,
> >>> Henning
> >>>
> >>>      
> >>>>>> Maybe leave here with
> >>>>>> netif_info()
> >>>>>>        
> >>>>
> >>>> Not good to print in rcu lock.
> >>>>     
> >>>>>> And move the whole block up, we can skip the whole ACPI story
> >>>>>> if we find the MAC busy.  
> >>>>>
> >>>>> That is wrong, need to know that MAC so can not move up too
> >>>>> much. But maybe above the is_valid_ether_addr  
> >>>>
> >>>> The MAC passthough address is read from ACPI.
> >>>> ACPI read only happens once during r8152 driver probe.
> >>>> To keep the lock less time, do it after is_valid_ether_addr.
> >>>>     
> >>>>>
> >>>>> Henning
> >>>>>         
> >>>>>>> +		}
> >>>>>>> +	}
> >>>>>>> +	rcu_read_unlock();  
> >>>>>>
> >>>>>> Not sure if this function is guaranteed to only run once at a
> >>>>>> time, otherwise i think that is a race. Multiple instances
> >>>>>> could make it to this very point at the same time.
> >>>>>>        
> >>>>
> >>>> Run once for one device.
> >>>> So add a safe lock.
> >>>>
> >>>> Aaron
> >>>>     
> >>>>>> Henning
> >>>>>>        
> >>>>>>>     	memcpy(sa->sa_data, buf, 6);
> >>>>>>>     	netif_info(tp, probe, tp->netdev,
> >>>>>>>     		   "Using pass-thru MAC addr %pM\n",
> >>>>>>> sa->sa_data);  
> >>>>>>        
> >>>>>         
> >>>      
> >   

