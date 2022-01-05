Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64EAA484F5F
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 09:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbiAEIcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 03:32:24 -0500
Received: from mail-am6eur05on2045.outbound.protection.outlook.com ([40.107.22.45]:17505
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229962AbiAEIcX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 03:32:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXIiQsoxkMsquTe5ISxmSoHwOzVlSbhC4m2Kj1tDxUfcPpOGSnvhqFH7iq5x/5JfjR027l+YPMkkuSg3dRzX6cppSJcmwsykAygIbaWmsc+iC2Wr7MWMEG+VgRob/TVHbkIW8TQi1Vk392tymnjlh7HN4Z5cDU0RUXUT+W/8ukVRJti1tUgAzTbgWWAmlGV7vvLIdkHmRFlK3PU0F/i0SD7lP1z75yg5P0YQLM/MBgBYm5wSJRzSfESXbFWilJfaV9INcUD/7UebBfOF17UMr8lSvE3JsYYRy6O8ayBtNNL4fHzUSbiTlZTkaj0Ws7+LUlEjPlYTGcSfIt/q5krbJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1v9Csecy9Xok7z0XddFg29K1uWcVbckPAwyX0W5nTwE=;
 b=PBC3lMd2Z90CbAVWbMPmpz/ZSjT3umooUf3flDs+V+mP90iF1VBVup/MpINCiQMjsFp5hC/MKDXNcgsRSe1de/0nYpu5NHW5gy0vdsgMyLFwZTMCJ4vG7MFVBznhrDE36FWZPYGGrpm10PYI4JuOXOZwMZ/ffLDBIJvVUQO/1PHYQ2dF8fP9jfMUISSpVdwTkxfXcuJtzkUu1L0ZGF1qKZhPdI0SsHFKkVBiGLKgblGKSips0imMbcwENjtqynOI6RWxpJ04uLbcvL5h+m2mkxgT+imjUzhNiVx2/GllzvZO32wNsSBsjGV1yYwTzJZZwCgvF3++27zWwtaWU+sHOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.72) smtp.rcpttodomain=canonical.com smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1v9Csecy9Xok7z0XddFg29K1uWcVbckPAwyX0W5nTwE=;
 b=yp6rZ6TVfhMxR5zUi2FcrIJfl8pELpt1iU3gFi6kCV1bmFTiaVt9cy0F6qk0FvjgVUzdbl2Kw3mChjfb6M+MHMIbKb7JPQebNQf1lN347uluQP97pl17F62xy1fIZr2qRtelaiWXlknAgGxed3s2SXVIVHPbRHN9YOmb+MC95AtOfFw1yRHgGzgO5bUXn3ZU9a83EwUJK5GYpB5peRprgGRxWRyPQXKyAkRtBf8xx3f3jeIu/aIZqWLo6v7cLzWEyDQm5C+xxXZD+sr1Lc3rKMgWOgO++qmHLlHddJe9RmWmuiH8G52NE77VMPpvjWLha9H1voUyPSwiff6SuwCD2Q==
Received: from AM5PR0601CA0057.eurprd06.prod.outlook.com (2603:10a6:206::22)
 by AM8PR10MB4705.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:363::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 5 Jan
 2022 08:32:21 +0000
Received: from VE1EUR01FT019.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:206:0:cafe::60) by AM5PR0601CA0057.outlook.office365.com
 (2603:10a6:206::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9 via Frontend
 Transport; Wed, 5 Jan 2022 08:32:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.72)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.72 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.72; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.72) by
 VE1EUR01FT019.mail.protection.outlook.com (10.152.2.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4844.14 via Frontend Transport; Wed, 5 Jan 2022 08:32:20 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SMA.ad011.siemens.net (194.138.21.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 09:32:20 +0100
Received: from md1za8fc.ad001.siemens.net (158.92.8.107) by
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 09:32:19 +0100
Date:   Wed, 5 Jan 2022 09:32:18 +0100
From:   Henning Schild <henning.schild@siemens.com>
To:     Aaron Ma <aaron.ma@canonical.com>
CC:     <kuba@kernel.org>, <linux-usb@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <hayeswang@realtek.com>, <tiwai@suse.de>
Subject: Re: [PATCH] net: usb: r8152: Check used MAC passthrough address
Message-ID: <20220105093218.283c9538@md1za8fc.ad001.siemens.net>
In-Reply-To: <fc72ca69-9043-dc46-6548-dbc3c4d40289@canonical.com>
References: <20220105061747.7104-1-aaron.ma@canonical.com>
        <20220105082355.79d44349@md1za8fc.ad001.siemens.net>
        <20220105083238.4278d331@md1za8fc.ad001.siemens.net>
        <e71f3dfd-5f17-6cdc-8f1b-9b5ad15ca793@canonical.com>
        <20220105085525.31873db2@md1za8fc.ad001.siemens.net>
        <fc72ca69-9043-dc46-6548-dbc3c4d40289@canonical.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [158.92.8.107]
X-ClientProxiedBy: DEMCHDC89XA.ad011.siemens.net (139.25.226.103) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04c9483b-f4a2-460a-ee1a-08d9d025e428
X-MS-TrafficTypeDiagnostic: AM8PR10MB4705:EE_
X-Microsoft-Antispam-PRVS: <AM8PR10MB47059E6C3E60DD1EE7243C07854B9@AM8PR10MB4705.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BC4QrrHGZ73lozIXaLOlu0APKUh8sJSVdB70tdWYmdjohDTiQ46ZB98Z+IH1fzd/YLALWVftzR2plohq6hJFswY0kIDvL3b8sdti/X7tRZX0b9676RqgyY1lEOo6lOtNHoIrCxivHfgNTUGLFldke2B8H7PNi2KnXg9R4mNUc0jdHVXBoWVlBcvR8euGrCsV2XX77c1gtJmgFxi615uMMaMJfyyUZWP3Cs23R1msU0KzaDajgQ2WUV8U9aVlK33q2x/xkB2GZ2lKI0EVcErucgllWi8pQlFKx8rgxjMoeUghDKzBfTwO70JwgJNKjqKYVzdGQyXcXX7y34mW4HSSKtY5aOc8TMKCS7gtdxlmE0NkYJXQy1avg2iR7CKSZBd42Fu2P+BhG2nEi674+WEK8ZTGy5cAhIAS6qUmVs2izBABWV1nNTFaTw2PsPYg/pmiIxpnXpnYSCHAZkZHU1YVLT4GpnL77tX5w4e/bZPm87gHdzTT1FYJZN0obvc+upZlf7mMIHJjWyDLzeqFg9kuId7texXHCCxr7q1wZ5hcOZJzAfLCv1BXHMxTCfaFPD6QHeZoEXlIsilRo8enN5j5R8FWgdiRTj4ioQ4/VDAoqYGDFvaibGXncVFRXpeQ3xcuK3WbNV3d63oKSIc6H5bd80IZoMF9CSuz4wjWGrifj+GZnzfKFsX3fIU26h3vBIwuyOQgx3Ygb8KCybB9LuAmr4G3PL476S/1B20IyPUtT/T5r455gKrbpO19dxkj7tFeVa4jet7moXbu2fK3Z2EkCDqdwd8Y8y1sFTW4OuCrLYE=
X-Forefront-Antispam-Report: CIP:194.138.21.72;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(40470700002)(36840700001)(46966006)(44832011)(82310400004)(956004)(8936002)(55016003)(54906003)(86362001)(82960400001)(70586007)(40460700001)(5660300002)(336012)(16526019)(26005)(83380400001)(7696005)(4326008)(508600001)(1076003)(186003)(36860700001)(316002)(53546011)(70206006)(47076005)(356005)(8676002)(6916009)(9686003)(81166007)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 08:32:20.9265
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04c9483b-f4a2-460a-ee1a-08d9d025e428
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.72];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR01FT019.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR10MB4705
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Wed, 5 Jan 2022 16:01:24 +0800
schrieb Aaron Ma <aaron.ma@canonical.com>:

> On 1/5/22 15:55, Henning Schild wrote:
> > Am Wed, 5 Jan 2022 15:38:51 +0800
> > schrieb Aaron Ma <aaron.ma@canonical.com>:
> >   
> >> On 1/5/22 15:32, Henning Schild wrote:  
> >>> Am Wed, 5 Jan 2022 08:23:55 +0100
> >>> schrieb Henning Schild <henning.schild@siemens.com>:
> >>>      
> >>>> Hi Aaron,
> >>>>
> >>>> if this or something similar goes in, please add another patch to
> >>>> remove the left-over defines.
> >>>>     
> >>
> >> Sure, I will do it.
> >>  
> >>>> Am Wed,  5 Jan 2022 14:17:47 +0800
> >>>> schrieb Aaron Ma <aaron.ma@canonical.com>:
> >>>>     
> >>>>> When plugin multiple r8152 ethernet dongles to Lenovo Docks
> >>>>> or USB hub, MAC passthrough address from BIOS should be
> >>>>> checked if it had been used to avoid using on other dongles.
> >>>>>
> >>>>> Currently builtin r8152 on Dock still can't be identified.
> >>>>> First detected r8152 will use the MAC passthrough address.
> >>>>>
> >>>>> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> >>>>> ---
> >>>>>    drivers/net/usb/r8152.c | 10 ++++++++++
> >>>>>    1 file changed, 10 insertions(+)
> >>>>>
> >>>>> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> >>>>> index f9877a3e83ac..77f11b3f847b 100644
> >>>>> --- a/drivers/net/usb/r8152.c
> >>>>> +++ b/drivers/net/usb/r8152.c
> >>>>> @@ -1605,6 +1605,7 @@ static int
> >>>>> vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr
> >>>>> *sa) char *mac_obj_name; acpi_object_type mac_obj_type;
> >>>>>    	int mac_strlen;
> >>>>> +	struct net_device *ndev;
> >>>>>    
> >>>>>    	if (tp->lenovo_macpassthru) {
> >>>>>    		mac_obj_name = "\\MACA";
> >>>>> @@ -1662,6 +1663,15 @@ static int
> >>>>> vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr
> >>>>> *sa) ret = -EINVAL; goto amacout;
> >>>>>    	}
> >>>>> +	rcu_read_lock();
> >>>>> +	for_each_netdev_rcu(&init_net, ndev) {
> >>>>> +		if (strncmp(buf, ndev->dev_addr, 6) == 0) {
> >>>>> +			rcu_read_unlock();
> >>>>> +			goto amacout;  
> >>>>
> >>>> Since the original PCI netdev will always be there, that would
> >>>> disable inheritance would it not?
> >>>> I guess a strncmp(MODULE_NAME, info->driver, strlen(MODULE_NAME))
> >>>> is needed as well.
> >>>>     
> >>
> >> PCI ethernet could be a builtin one on dock since there will be
> >> TBT4 dock.  
> > 
> > In my X280 there is a PCI device in the laptop, always there. And
> > its MAC is the one found in ACPI. Did not try but i think for such
> > devices there would never be inheritance even if one wanted and
> > used a Lenovo dock that is supposed to do it.
> >   
> 
> There will more TBT4 docks in market, the new ethernet is just the
> same as PCI device, connected by thunderbolt.
> 
> For exmaple, connect a TBT4 dock which uses i225 pcie base ethernet,
> then connect another TBT3 dock which uses r8152.
> If skip PCI check, then i225 and r8152 will use the same MAC.

In current 5.15 i have that sort of collision already. All r8152s will
happily grab the MAC of the I219. In fact i have only ever seen it with
one r8152 at a time but while the I219 was actively in use.
While this patch will probably solve that, i bet it would defeat MAC
pass-thru altogether. Even when turned on in the BIOS.
Or does that iterator take "up"/"down" state into consideration? But
even if, the I219 could become "up" any time later.

These collisions are simply bound to happen and probably very hard to
avoid once you have set your mind on allowing pass-thru in the first
place. Not sure whether that even has potential to disturb network
equipment like switches.

Henning

> Aaron
> 
> > Maybe i should try the patch but it seems like it defeats
> > inheritance completely. Well depending on probe order ...
> > 
> > regards,
> > Henning
> > 
> >   
> >>>> Maybe leave here with
> >>>> netif_info()
> >>>>     
> >>
> >> Not good to print in rcu lock.
> >>  
> >>>> And move the whole block up, we can skip the whole ACPI story if
> >>>> we find the MAC busy.  
> >>>
> >>> That is wrong, need to know that MAC so can not move up too much.
> >>> But maybe above the is_valid_ether_addr  
> >>
> >> The MAC passthough address is read from ACPI.
> >> ACPI read only happens once during r8152 driver probe.
> >> To keep the lock less time, do it after is_valid_ether_addr.
> >>  
> >>>
> >>> Henning
> >>>      
> >>>>> +		}
> >>>>> +	}
> >>>>> +	rcu_read_unlock();  
> >>>>
> >>>> Not sure if this function is guaranteed to only run once at a
> >>>> time, otherwise i think that is a race. Multiple instances could
> >>>> make it to this very point at the same time.
> >>>>     
> >>
> >> Run once for one device.
> >> So add a safe lock.
> >>
> >> Aaron
> >>  
> >>>> Henning
> >>>>     
> >>>>>    	memcpy(sa->sa_data, buf, 6);
> >>>>>    	netif_info(tp, probe, tp->netdev,
> >>>>>    		   "Using pass-thru MAC addr %pM\n",
> >>>>> sa->sa_data);  
> >>>>     
> >>>      
> >   

