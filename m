Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC7548513B
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 11:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239445AbiAEKlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 05:41:03 -0500
Received: from mail-eopbgr10068.outbound.protection.outlook.com ([40.107.1.68]:31724
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234804AbiAEKk7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 05:40:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JxBp5p3eqMV0LveUP8E7SwVpy3twL+197sQHzF+fm50Z20uJwJRqV5iclAxwsbPpfSY5i/OBVuQ8ZaToMGOGiBBauk4KOeuvevs+MwJbKoM+/Wap8k+yDkh4ZV6cjQhhUCOJXljdA9GAgE8RJ8dqDuFl0OhgMqb2IP4ElhFACALfnWK7KrE7VofUIm6Zeyzj6culQ+DRZPtLsZEv4KjCePaqTxERsV6xo8Yuft6wiXjtRfTXNHDxfADPobJ/iSrODR01MjD562IaW+nQfmLde2J15ILiM99wUuu6/jGw1WuhxThG8GiiFTuoYe8U/TwagWaPNqsNFRStIcng4udawg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5rLc+nDikYUBKC6GKD160IB8u4jbQpg7up0jS/jJZew=;
 b=efj2ctE9hhvy0Rfq8lnYrsztuwJ5sfa38AJWODBOXpZ8zRf+QRXvFjMd/JpP6YpWJxAN0RVnrT9hMZHoQ5KN3hVyxzzQsku0NPToFSrMWeqvpnyvpKETyl1loLcaiJ70+/OTRBHdwfxSBAF0Q6WR2Q57OCbw28BAHGvEhBP6dh1oa9YLB/R7d/gb60pIIR4NAa31lm11F3cC6vix0aV9md5woVCOus0ktEQoPNC3NrCyoTpond0nb4Bb6Fnlt3jwsptf3RBjGwIa4zJ2ovPDVpZZKCN2JaXikhiCrpxfBFWqzPvm7dMRuEulmxQ8wwChkXJNchLaWADwqTCBFMY3dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.73) smtp.rcpttodomain=canonical.com smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5rLc+nDikYUBKC6GKD160IB8u4jbQpg7up0jS/jJZew=;
 b=P/SzbJMoZWw4+IAfRLikkzAnGU/mLX8EGmr2gGLmg/qJyvx2Hg/lhZAQ4DI2CtfOwIyPS+kkn2p81fhLZZuHB7F/HMvwsOspPpt/hOKQbn2tBCjbBslrBXmgFmfgbcjW8QE/HSUCzi/crxHiu+jSoYlHTW3U8VrO8nq2iEkW6wKrXFsPBXVWgVX/2UKRQD5L5c6vlkP31RcInJTAX34XpSLMLCve4RKYXlNTS2CGHr6atdbip5lQZYD22oercHZrjf9E0PNdehbAo34JjBXfikAGtC/f/JDI+yk84Tj6Gzlhg/WvSZehHrkCuFAolloN9imiCXi3/qrtXv1E/E9blQ==
Received: from OL1P279CA0027.NORP279.PROD.OUTLOOK.COM (2603:10a6:e10:13::14)
 by AS1PR10MB5261.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:4a5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 10:40:56 +0000
Received: from HE1EUR01FT027.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:e10:13:cafe::c6) by OL1P279CA0027.outlook.office365.com
 (2603:10a6:e10:13::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7 via Frontend
 Transport; Wed, 5 Jan 2022 10:40:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.73)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.73 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.73; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.73) by
 HE1EUR01FT027.mail.protection.outlook.com (10.152.0.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4867.7 via Frontend Transport; Wed, 5 Jan 2022 10:40:56 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SNA.ad011.siemens.net (194.138.21.73) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 11:40:55 +0100
Received: from md1za8fc.ad001.siemens.net (139.25.68.217) by
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 11:40:55 +0100
Date:   Wed, 5 Jan 2022 11:40:52 +0100
From:   Henning Schild <henning.schild@siemens.com>
To:     Aaron Ma <aaron.ma@canonical.com>
CC:     <kuba@kernel.org>, <linux-usb@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <hayeswang@realtek.com>, <tiwai@suse.de>
Subject: Re: [PATCH] net: usb: r8152: Check used MAC passthrough address
Message-ID: <20220105114052.5035b602@md1za8fc.ad001.siemens.net>
In-Reply-To: <20220105094702.561967ae@md1za8fc.ad001.siemens.net>
References: <20220105061747.7104-1-aaron.ma@canonical.com>
        <20220105082355.79d44349@md1za8fc.ad001.siemens.net>
        <20220105083238.4278d331@md1za8fc.ad001.siemens.net>
        <e71f3dfd-5f17-6cdc-8f1b-9b5ad15ca793@canonical.com>
        <20220105085525.31873db2@md1za8fc.ad001.siemens.net>
        <fc72ca69-9043-dc46-6548-dbc3c4d40289@canonical.com>
        <20220105093218.283c9538@md1za8fc.ad001.siemens.net>
        <ba9f12b7-872f-8974-8865-9a2de539e09a@canonical.com>
        <20220105094702.561967ae@md1za8fc.ad001.siemens.net>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [139.25.68.217]
X-ClientProxiedBy: DEMCHDC89XA.ad011.siemens.net (139.25.226.103) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d56cb900-db75-476d-0044-08d9d037dac4
X-MS-TrafficTypeDiagnostic: AS1PR10MB5261:EE_
X-Microsoft-Antispam-PRVS: <AS1PR10MB52612A6A2B82DBB60E8E571B854B9@AS1PR10MB5261.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e/oWIlSqVsy1dsPmBVBF+8iOKAb0K1qbbwAieA+6mt9Xdpf/onINBwmQmCdx47W0axvHe9kXDqut9pKMWLFxDYGU5KZCZ0Pyx8I402h6yI0oZcwmL4U7+4hx3qt6P536Pxxfn0S63fsFCTsRWlywGV8gL9UJEEhHFCzarWQgNwmoBRoXpefBlRj1Ddb+7Kipwx3mLJt2hlwd7p2srndTICeMa+a9W+RfaagMKqdwTdb3cDrUM+ivrYRdxruUl8O9K+C8QKB5TpWnzlBwmsEdI2NE6ROgwTFUT2CkJM2Z8wenT9gcNlPo2sFjVUO+2qA1aNpbdzkO4EfjpQNRotzycPCSHi1OvFdkmMmm6R5wuk4Zw36HMzdoH1896Dbexrz2mjFfrxFnBTpjnvLciam6InYMNsXDB1hg338yYA6dBClBsUv/7o0GegGae2MeCuwovHvA7NqBrdVgYqhV4NWQYQyRs5mQ2fKK3Kyw34FJsytBUVDzPwp4FjwUVyloRt+tJFjwfDUPgjnJiYdw6onhJHxaTFopESlVnb4CkcNXw/OVVMfOrnHouWO2q8ZJJoVHGyjyvXzLBmL2SOZfV/40w484KAM6iR4iTPzPE2283SKxrgCjBy6qlC0tCgstl1u8+YelQB5sb4K1P7kqbUthG12XipYkevvQbfJvlO8r0YZ6BOJ4DUFyN7Is3QB8mSZvcsBekgkYjVpveLqW2lWr/9gpL9wNA2EhCdAiU71bTbFDenEKdLBP68XP/oG5h9wxgbChhPYNgr6KUTewXk7q8gwHzOxySbPKyTUO3pAW8SI=
X-Forefront-Antispam-Report: CIP:194.138.21.73;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700002)(36860700001)(47076005)(53546011)(6666004)(316002)(2906002)(4326008)(54906003)(508600001)(55016003)(956004)(1076003)(70586007)(8676002)(8936002)(70206006)(40460700001)(83380400001)(82960400001)(26005)(186003)(6916009)(7696005)(356005)(82310400004)(9686003)(5660300002)(44832011)(81166007)(16526019)(86362001)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 10:40:56.0911
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d56cb900-db75-476d-0044-08d9d037dac4
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.73];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: HE1EUR01FT027.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR10MB5261
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Wed, 5 Jan 2022 09:47:02 +0100
schrieb Henning Schild <henning.schild@siemens.com>:

> Am Wed, 5 Jan 2022 16:37:11 +0800
> schrieb Aaron Ma <aaron.ma@canonical.com>:
> 
> > On 1/5/22 16:32, Henning Schild wrote:  
> > > Am Wed, 5 Jan 2022 16:01:24 +0800
> > > schrieb Aaron Ma <aaron.ma@canonical.com>:
> > >     
> > >> On 1/5/22 15:55, Henning Schild wrote:    
> > >>> Am Wed, 5 Jan 2022 15:38:51 +0800
> > >>> schrieb Aaron Ma <aaron.ma@canonical.com>:
> > >>>        
> > >>>> On 1/5/22 15:32, Henning Schild wrote:    
> > >>>>> Am Wed, 5 Jan 2022 08:23:55 +0100
> > >>>>> schrieb Henning Schild <henning.schild@siemens.com>:
> > >>>>>           
> > >>>>>> Hi Aaron,
> > >>>>>>
> > >>>>>> if this or something similar goes in, please add another
> > >>>>>> patch to remove the left-over defines.
> > >>>>>>          
> > >>>>
> > >>>> Sure, I will do it.
> > >>>>       
> > >>>>>> Am Wed,  5 Jan 2022 14:17:47 +0800
> > >>>>>> schrieb Aaron Ma <aaron.ma@canonical.com>:
> > >>>>>>          
> > >>>>>>> When plugin multiple r8152 ethernet dongles to Lenovo Docks
> > >>>>>>> or USB hub, MAC passthrough address from BIOS should be
> > >>>>>>> checked if it had been used to avoid using on other dongles.
> > >>>>>>>
> > >>>>>>> Currently builtin r8152 on Dock still can't be identified.
> > >>>>>>> First detected r8152 will use the MAC passthrough address.
> > >>>>>>>
> > >>>>>>> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> > >>>>>>> ---
> > >>>>>>>     drivers/net/usb/r8152.c | 10 ++++++++++
> > >>>>>>>     1 file changed, 10 insertions(+)
> > >>>>>>>
> > >>>>>>> diff --git a/drivers/net/usb/r8152.c
> > >>>>>>> b/drivers/net/usb/r8152.c index f9877a3e83ac..77f11b3f847b
> > >>>>>>> 100644 --- a/drivers/net/usb/r8152.c
> > >>>>>>> +++ b/drivers/net/usb/r8152.c
> > >>>>>>> @@ -1605,6 +1605,7 @@ static int
> > >>>>>>> vendor_mac_passthru_addr_read(struct r8152 *tp, struct
> > >>>>>>> sockaddr *sa) char *mac_obj_name; acpi_object_type
> > >>>>>>> mac_obj_type; int mac_strlen;
> > >>>>>>> +	struct net_device *ndev;
> > >>>>>>>     
> > >>>>>>>     	if (tp->lenovo_macpassthru) {
> > >>>>>>>     		mac_obj_name = "\\MACA";
> > >>>>>>> @@ -1662,6 +1663,15 @@ static int
> > >>>>>>> vendor_mac_passthru_addr_read(struct r8152 *tp, struct
> > >>>>>>> sockaddr *sa) ret = -EINVAL; goto amacout;
> > >>>>>>>     	}
> > >>>>>>> +	rcu_read_lock();
> > >>>>>>> +	for_each_netdev_rcu(&init_net, ndev) {
> > >>>>>>> +		if (strncmp(buf, ndev->dev_addr, 6) == 0) {
> > >>>>>>> +			rcu_read_unlock();
> > >>>>>>> +			goto amacout;    
> > >>>>>>
> > >>>>>> Since the original PCI netdev will always be there, that
> > >>>>>> would disable inheritance would it not?
> > >>>>>> I guess a strncmp(MODULE_NAME, info->driver,
> > >>>>>> strlen(MODULE_NAME)) is needed as well.
> > >>>>>>          
> > >>>>
> > >>>> PCI ethernet could be a builtin one on dock since there will be
> > >>>> TBT4 dock.    
> > >>>
> > >>> In my X280 there is a PCI device in the laptop, always there.
> > >>> And its MAC is the one found in ACPI. Did not try but i think
> > >>> for such devices there would never be inheritance even if one
> > >>> wanted and used a Lenovo dock that is supposed to do it.
> > >>>        
> > >>
> > >> There will more TBT4 docks in market, the new ethernet is just
> > >> the same as PCI device, connected by thunderbolt.
> > >>
> > >> For exmaple, connect a TBT4 dock which uses i225 pcie base
> > >> ethernet, then connect another TBT3 dock which uses r8152.
> > >> If skip PCI check, then i225 and r8152 will use the same MAC.    
> > > 
> > > In current 5.15 i have that sort of collision already. All r8152s
> > > will happily grab the MAC of the I219. In fact i have only ever
> > > seen it with one r8152 at a time but while the I219 was actively
> > > in use. While this patch will probably solve that, i bet it would
> > > defeat MAC pass-thru altogether. Even when turned on in the BIOS.
> > > Or does that iterator take "up"/"down" state into consideration?
> > > But even if, the I219 could become "up" any time later.
> > >     
> > 
> > No, that's different, I219 got MAC from their own space.
> > MAC passthrough got MAC from ACPI "\MACA".  
> 
> On my machine "\MACA" and I219 are the same, likely "\MACA" was
> populated by looking at that I219 by the BIOS.
> Not sure if "\MACA" can change when plugging docks, but probably not
> since the BIOS is also trying to implement inheritance of the main
> MAC.
> 
> Let me try this patch, maybe i do not get it.

So i tried it and inheritance now is killed as expected because that
I219 has that MAC. So for devices that have a PCI device built-in ...
this patch is like removing pass-thru altogether. And very likely not
what you intended.

On top the device will receive a random MAC because there is no error
code before "goto amacount;" some randomness from the stack of the
caller of determine_ethernet_addr where the "sa"s come from.

I now have an "ret = -EBUSY" in mine ... but still there can never be
pass-thru because that I219 is always there.

This patch is very wrong! And i am still not sure about the race, you
did not say anything about that.

Henning

> Henning
> 
> > > These collisions are simply bound to happen and probably very hard
> > > to avoid once you have set your mind on allowing pass-thru in the
> > > first place. Not sure whether that even has potential to disturb
> > > network equipment like switches.
> > >     
> > 
> > After check MAC address, it will be more safe.
> > 
> > Aaron
> >   
> > > Henning
> > >     
> > >> Aaron
> > >>    
> > >>> Maybe i should try the patch but it seems like it defeats
> > >>> inheritance completely. Well depending on probe order ...
> > >>>
> > >>> regards,
> > >>> Henning
> > >>>
> > >>>        
> > >>>>>> Maybe leave here with
> > >>>>>> netif_info()
> > >>>>>>          
> > >>>>
> > >>>> Not good to print in rcu lock.
> > >>>>       
> > >>>>>> And move the whole block up, we can skip the whole ACPI story
> > >>>>>> if we find the MAC busy.    
> > >>>>>
> > >>>>> That is wrong, need to know that MAC so can not move up too
> > >>>>> much. But maybe above the is_valid_ether_addr    
> > >>>>
> > >>>> The MAC passthough address is read from ACPI.
> > >>>> ACPI read only happens once during r8152 driver probe.
> > >>>> To keep the lock less time, do it after is_valid_ether_addr.
> > >>>>       
> > >>>>>
> > >>>>> Henning
> > >>>>>           
> > >>>>>>> +		}
> > >>>>>>> +	}
> > >>>>>>> +	rcu_read_unlock();    
> > >>>>>>
> > >>>>>> Not sure if this function is guaranteed to only run once at a
> > >>>>>> time, otherwise i think that is a race. Multiple instances
> > >>>>>> could make it to this very point at the same time.
> > >>>>>>          
> > >>>>
> > >>>> Run once for one device.
> > >>>> So add a safe lock.
> > >>>>
> > >>>> Aaron
> > >>>>       
> > >>>>>> Henning
> > >>>>>>          
> > >>>>>>>     	memcpy(sa->sa_data, buf, 6);
> > >>>>>>>     	netif_info(tp, probe, tp->netdev,
> > >>>>>>>     		   "Using pass-thru MAC addr %pM\n",
> > >>>>>>> sa->sa_data);    
> > >>>>>>          
> > >>>>>           
> > >>>        
> > >     
> 

