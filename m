Return-Path: <netdev+bounces-7258-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCB3571F5D7
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 00:15:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FC931C2115B
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 22:15:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39A4646FF1;
	Thu,  1 Jun 2023 22:15:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277552414E
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 22:15:54 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2042.outbound.protection.outlook.com [40.107.6.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02841A7;
	Thu,  1 Jun 2023 15:15:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ckcPMT8PKIYQ9irXnRl5hZll75jZjTpiDvlmc5dYGtf8hRKum31N6+s73gpPbxBWUAlrE2vGtHTjpPFu9s1d2+tBmfiBJLpsiXK9W8VPRT+ovpDzSUKM9OEGCmDqvZgE0pezkuK+TUEzfsTGpOf4yoNvl3S8Fk4RFVtNUR/0iqmwOcvSkYk2zVyjt+oq7oCqQpWcEYRHZzNc2mmPHNwbeBgyq6F5YE/+Ich0NiqSBn7EIyZQOPsFItEPgLbha9prR/HB24OmzlyklRAp0K5KmxdOvU9TVzOhBjz404+pX3N1+Ea4YYSen1HZ3wTnhjHKoPey+Ds1jte7Km/Q1xfBzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TRFypScFKtUNpKmGSz21l4buvbTjH2J69cutDqMoN14=;
 b=RtcRVSGJxVmN/pg1Cbrt/OPkxa2aa0hD965FUq6VjePToFEZ4k/Aqh4Z5F/sXbWcJYRf/+5/7InX9YkGcrK03aRHQGqsvh2Q2IhWlQI9cixxC74vBe2bJDrvM3PfqZvH0nAmIFpycmAX1iY+Jw9yJjL3/fobj5F6crwFX+xRBdp4P1kIzeMh+RxsX7bOL/x57VjavzckWpQMLUjInPwG32Sx+srJZSadQCmfGuUE8MvBOPC07jHPvbRytOmWajFG0UA1HHcmOOCEi9++eUGxTDuFPsUA9JSAwY4qOzGGK+RMEc8SKbLiSLZlFCQKqORijJtQS2nbo7K/wJzW7zS/0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRFypScFKtUNpKmGSz21l4buvbTjH2J69cutDqMoN14=;
 b=j2M2ppx7rGh0WdxD0OUUpHji5ntqLnSO+LZ5/JWyhFiUMeloL9UYrR7rNziP8r9Pxp48uiwuOst4QXHvp19c4Af/pJtToUhtv78ATeg3awNjHueFYvUnI3/zGyeQlpSXP8+eSiW4SXq723hNz1o2PJiThGIV0DuYY7JC+mTobKw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM7PR04MB6823.eurprd04.prod.outlook.com (2603:10a6:20b:102::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Thu, 1 Jun
 2023 22:15:36 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a%4]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 22:15:35 +0000
Date: Fri, 2 Jun 2023 01:15:32 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-pci@vger.kernel.org, netdev@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org,
	Liu Peibao <liupeibao@loongson.cn>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: Re: [PATCH pci] PCI: don't skip probing entire device if first fn OF
 node has status = "disabled"
Message-ID: <20230601221532.2rfcda4sg5nl7pzp@skbuf>
References: <20230601163335.6zw4ojbqxz2ws6vx@skbuf>
 <ZHjaq+TDW/RFcoxW@bhelgaas>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHjaq+TDW/RFcoxW@bhelgaas>
X-ClientProxiedBy: BE1P281CA0139.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::12) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM7PR04MB6823:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cd1d636-742e-4ed8-bbdc-08db62edb91e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9b2c1/MsyTscTyVwKxAPcAttiXgRvT8vdUSQeYI6W/SnPpU+ieb57EFBtfK2Bjh01Bk7J3kepTRlJHAo+8dHJSIgNyXIBY2nUP9SteUqQI2tZtQN0J26TRiBMrEDJGaNdefyt3Rz+we+IEv6mN9mftms+kBRTKUu9VWmH4+OfXA8rXgzQtb5p3SSyNfILY8aGWnRteGQ05ItNiBEQI+4DtLdw7PLSVvtK6T4KlxrOVc16o57lVy8i/HhBioh3j1BQVmuJelXmrF9NWeNG6B31HcWrsGpV/Kj4noPmrAtMHfgp5T0oejLUt4meWQYNkbM/tA6rUMAA30RAVH4OiCDeFeJo/DogIwsSU2YNvgGjH9Cctf6n2aD3a3/ZBkl6cNIdm+1H2AaA2+JqqRhGUNm3FzTAOya9j9YCIWL6zSJPhiv1Z7jIpNtmPdfx0zLJV5MNrbJBi27Ou/Cb59LGqGLZ3uD/UrLHjJomlzpRSZaO+hb0nnsH0jgzWaKjFwlOvf8CvWCbhZoWF2EBOZwbu3JX9dysr3Lk5A2vr2ZxbgGb1aKpR1WUIOFwfqjliVR7DvG4ym7/8FuRI7dQnH/MdmXwA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(396003)(136003)(376002)(346002)(366004)(39860400002)(451199021)(38100700002)(33716001)(44832011)(86362001)(54906003)(478600001)(66476007)(66556008)(6916009)(66946007)(4326008)(6486002)(6666004)(966005)(186003)(9686003)(6512007)(26005)(1076003)(6506007)(316002)(8676002)(7416002)(8936002)(5660300002)(2906002)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f1dpq5y7PSyehkceGMPlkohW3I0XullDQb6zJhEC7thgaAZPMc8Ak2Mi6PiA?=
 =?us-ascii?Q?ZrrFDGjqVfDm+pQJS0erMng9oS4kyCxkztvzgFPmBKKnPg6nl89i6QRtGKBp?=
 =?us-ascii?Q?oQV8JK7tCsHukwzDlDp7tX1ZwrkAC+7ls/ymWlf/cOBzdFaow5gM/H+xAdgx?=
 =?us-ascii?Q?UteR1gpzKvXltGtfVTKuYd+oDlWZyx6vczWxUFmpQgwWHZRqLRm/XUsV4w0+?=
 =?us-ascii?Q?CsQ8QeTi73FLRs/JVYJ9Xzqes7V/m9ij8Ykogp4bOGdb9K1byl8/FfoHPtx7?=
 =?us-ascii?Q?hY+/HZZM/qAvFz/7qsf086ndb7PUEvwbEUwoHHY+2z2dkWtz44V94ndiW2Hy?=
 =?us-ascii?Q?HDNdjKlYS+QY1wowwqWmmJ9BFIyzZvi7ZucZeT2hb/e7f7MZ8Igp6j8ZmXKX?=
 =?us-ascii?Q?rY4shHXCkgFFyNP5Ydfx37hK7SJewcJEdxGDpyrJ9i/FvTlp5RZZB8uPRS2s?=
 =?us-ascii?Q?av8VMsFMA4nvx3ZuPXD/zMys0XQpJxqYecIjuoI50cFwikSmI2j5r22Nl5IF?=
 =?us-ascii?Q?tC4+goRN3PFtoFXErGeshZXgXod2UTvUqu06lKAcKPsmTRp98s5ERvlIfokL?=
 =?us-ascii?Q?sniYE1ax05pnJVofw5WGuuAAGoXzfUg4HXFBvzLpDV9rXFUqWfLdG0lR1O0H?=
 =?us-ascii?Q?IjFzSNPFuxwF76iMA3Xyf2ZD/OmAGa597rkwrGCpnVXvnrWjHE5LSzDotAb8?=
 =?us-ascii?Q?wNfeHZDpwCnw3TH9sLojIMaIqBdW3M0SvpzgEACM5JJ+SD+1WUmPIEgY+Rdj?=
 =?us-ascii?Q?ECZfsqfr7bAkOqkO7aYV5WLbRspZ101sKq2ooINjNRX2nyKhgImB014Wa05H?=
 =?us-ascii?Q?dY4BEorN0Y1pjJzqEjB2mhM1v8i5kRE2SV6t+gPbBpRnDiWrAATNuIpEilwJ?=
 =?us-ascii?Q?CvwksS1f1snqiHzva0qX+0CrNLe3tJ8zELkRYfZoHwecUBhXkOCz8BBi/Sr/?=
 =?us-ascii?Q?qm1573JpIdSLJb6Wd93Q+FofGhpj3mYnFYY9oEYMyRLjLVHiy4R90Qj4v1tC?=
 =?us-ascii?Q?jAygh7nLG4r3Qzc0o/PVlncuZTndFLZjB/joofNBpgGZehB2VM8CkWGWieAy?=
 =?us-ascii?Q?/+PaKEkiR0B2LPleE9XmVSQtM0A0QeljE3sPoawTpaPvxSZdbMBPOVeIhK4v?=
 =?us-ascii?Q?GwvyictYuML5W4TaIR1J54DR9A7evrqpHfORUtRPbzUJBMhmeHmAeo6ACzdR?=
 =?us-ascii?Q?QRHxY3ZWusKAMdubUZM0s+Jmr1qM3rpI0Vh/16zN5lkLwCwhe3tVKn0X8nwu?=
 =?us-ascii?Q?YNWDgHyGNKuuVI64o9vMb6YHOnOG8q7vHB9F9lS+b5FUO7fKU8c4MDt9YqLw?=
 =?us-ascii?Q?m2vY4sDAn6w4dDs8ufn1oiNvOFIqotplUBopAOZenlk1RR/e6eW4FNRuxH/o?=
 =?us-ascii?Q?oPMq/nH1Hvy2YQMKffMNyH/jvys37Bh3Fy8wVb0RiJPUqhFxJ9UnnP6uKS+d?=
 =?us-ascii?Q?+Go55iRHy9m5d+9n36X/gabTxVhFTUXnDXzN899xIs62B5YZuCBH8S7b4YF/?=
 =?us-ascii?Q?kmUf8r27qdq+rmtOyl8CuVWSQif/tTgwRHsiP3VbalvsI6d84UeCZtILz9AO?=
 =?us-ascii?Q?oz5GyXSSukU5i/8KJeVOoiBh1g1EYq2GGdq337lo65nRRIJ1+JrrSGnrklAK?=
 =?us-ascii?Q?hA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cd1d636-742e-4ed8-bbdc-08db62edb91e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 22:15:35.7373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bijxiAiyWrbZ82LowHTTrLkrzffkUwHMPiTPPIP3rDYX3r7Spq4KXrnz6IeT6IIkm25/zhoawshtLcElC4CF2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6823
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 12:51:39PM -0500, Bjorn Helgaas wrote:
> > > Doing it in Linux would minimize dependences on the bootloader, so
> > > that seems desirable to me. That means Linux needs to enumerate
> > > Function 0 so it is visible to a driver or possibly a quirk.
> > 
> > Uhm... no, that wouldn't be enough. Only a straight revert would satisfy
> > the workaround that we currently have for NXP ENETC in Linux.
> 
> I guess you mean a revert of 6fffbc7ae137?

Yes.

> This whole conversation is about whether we can rework 6fffbc7ae137 to
> work both for Loongson and for you, so nothing is decided yet.

After reading
https://lore.kernel.org/linux-pci/20221117020935.32086-1-liupeibao@loongson.cn/
and
https://lore.kernel.org/linux-pci/20221103090040.836-1-liupeibao@loongson.cn/
and seeing the GMAC OF node at arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi,
I believe that a solution that would work for both Loongson and NXP would be to:

- patch loongson_dwmac_probe() to check for of_device_is_available()
- revert commit 6fffbc7ae137 ("PCI: Honor firmware's device disabled
  status")

I'm not sure what else of what was concretely proposed would work.
Anything else is just wishful thinking that the PCI core can start
enforcing a central policy, after letting device drivers get to choose
how (and whether) to treat the "status" OF property for years on end.

As an added benefit, the disabled GMAC would become visible in lspci for
the Loongson SoC.

> The point is, I assume you agree that it's preferable if we don't have
> to depend on a bootloader to clear the memory.

I am confused by the message you are transmitting here.

With my user hat on, yes, maintaining the effect of commit 3222b5b613db
from Linux is preferable.

Although Rob will probably not be happy about the way in which that will
be achieved. And you haven't proposed ways in which that would remain
possible, short of a revert of commit 6fffbc7ae137.

> After 6fffbc7ae137, the probe function is not called if the device is
> disabled in DT because there's no pci_dev for it at all.

Correct, but commit 3222b5b613db pre-dates it by 2 years, and thus, it
is broken by Rob's change.

> > My problem is that I don't really understand what was the functional
> > need for commit 6fffbc7ae137 ("PCI: Honor firmware's device disabled
> > status") in the first place, considering that any device driver can
> > already fail to probe based on the same condition at its own will.
> 
> In general, PCI drivers shouldn't rely on DT.  If the bus driver (PCI
> in this case) calls a driver's probe function, the driver can assume
> the device exists.

Well, the device exists...

> But enetc is not a general-purpose driver, and if DT is the only way
> to discover this property, I guess you're stuck doing that.

So what Loongson tried to do - break enumeration of the on-chip GMAC
PCIe device at the level of the PCIe controller, if the GMAC's pinmuxing
doesn't make it available for networking - is encouraged?

Do you consider that their patch would have been better in the original
form, if instead of the "skip-scan" property, they would have built some
smarts into drivers/pci/controller/pci-loongson.c which would intentionally
break config space access to gmac@3,0, without requiring OF to specify this?

Are you saying that this "present but unusable due to pinmuxing" is an
incorrect use of status = "disabled"? What would it constitute correct
use of, then?

The analogous situation for ENETC would be to patch the "pci-host-ecam-generic"
driver to read the SERDES and pinmuxing configuration of the SoC, and to
mask/unmask the config access to function 0 based on that. I mean - I could...
but is it really a good idea? The principle of separation of concerns
tells me no. The fact that the pinmuxing of the device makes it unavailable
pertains to the IP-specific logic, it doesn't change whether it's enumerable
or accessible on its bus.

> > > Is DT the only way to learn the NXP SERDES configuration?  I think it
> > > would be much better if there were a way to programmatically learn it,
> > > because then you wouldn't have to worry about syncing the DT with the
> > > platform configuration, and it would decouple this from the Loongson
> > > situation.
> > 
> > Syncing the DT with the platform configuration will always be necessary,
> > because for networking we will also need extra information which is
> > completely non-discoverable, like a phy-handle or such, and that depends
> > on the wiring and static pinmuxing of the SoC. So it is practically
> > reasonable to expect that what is usable has status = "okay", and what
> > isn't has status = "disabled". Not to mention, there are already device
> > trees in circulation which are written that way, and those need to
> > continue to work.
> 
> Just because we need DT for non-discoverable info A doesn't mean we
> should depend on it for B if B *is* discoverable.

But the argument was: we already have device trees with a certain
convention, and that is to expect having status = "disabled" for
unusable ports. I don't believe that changing that is realistically in
scope for fixing this. And if we have device trees with status =
"disabled" in circulation which we (I) don't want to break, then we're
back to square 1 regarding the probing of disabled devices.

> This question of disabling a device via DT but still needing to do
> things to the device is ... kind of a sticky wicket.

It boils down to whether accessing a disabled device is permitted or
not. I opened the devicetree specification and it didn't say anything
conclusive. Though it's certainly above my pay grade to say anything
with certainty in this area. Apart from "okay" and "disabled", "status"
takes other documented values too, like "reserved", "fail" and
"fail-sss". Linux treats everything that's not "okay" the same.
Krzysztof Kozlowski came with the suggestion for Loongson to replace
"skip-scan" with "status", during the review of their v1 patch.

In any case, that question will only recur one level lower - in U-Boot,
where we make an effort to keep device trees in sync in Linux. Why would
U-Boot need to do things to a disabled device? :)

> Maybe this should be a different DT property (not "status").  Then PCI
> enumeration could work normally and 6fffbc7ae137 wouldn't be in the
> way.

I'm not quite sure where you're going with this. More concretely?

