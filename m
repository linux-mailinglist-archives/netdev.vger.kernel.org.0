Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9662248CBFA
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 20:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344085AbiALTaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 14:30:05 -0500
Received: from mail-dm6nam12on2066.outbound.protection.outlook.com ([40.107.243.66]:60385
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345296AbiALT1x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 14:27:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FEzwkObSCoVfm+MPesOJI4rd/4ElWqhPN64lUkCgTINpMpuRtSJins2BVbnH2hPumTmkn4xkywfLByJLkZl0aTPg6k5cMc76cw5a7Rr29SoaUfdlRmvUsSbhFRJP1HL/ib00fqJIiwd0LvtNtBSC1vPO87x5RohTHdATV6hM+iDsisUY8Q0kJx1u58ZlMsTcMcXjVhBcdHya7ePbVqsS+iP9uWV0PesqKVrgkMnfZB0pjMf1L3cm/zlT+yz01f5wip4BD/vdyceBD2XqV+Tbu2XQM20/1UwaDae9T64vyFCRM6Zm/KNwZ1GZlhq5GP+wMqOYujbY37DcI7QrIN0nHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A9UGBEqchrQ8DKryIaQFOpjS6hLbrKYelciqhSnxCqE=;
 b=dIRCn0+5Wqk/IqNDBTklKvQnZiK6m3MAQnZNWVrON4jVcdVBZoyyP8xiK5117CdP56dt/5lBcNgdeYP7t33AqGVw9etIkrUATtJOlyGaGOIJDHZT6SsqQM0Gwsx5L45tZ72sL9DsjxSDzgWFm7ovU1NHgiu9RQZI5BaTQY0j9gBkzvjnIqttgrjZlRkKA1SbnCdA5q8pdHziRKfIQT836PMEGRtKHrCchB5oRUy6cFzJSE6yIlq3AnYs0nceWdEB5meVeb669boEM/xqECfIehahZgSDt7M4goxLELuBf1KHrTxK5xSWdhqetqOzbweHyxO5IzVU2/z3/lJuLRVy3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9UGBEqchrQ8DKryIaQFOpjS6hLbrKYelciqhSnxCqE=;
 b=wF3EKJkxVCC9FOaBSmUrjmFgSnzR6wLM4wYT9MDWTzLbVEi5BKVU09+VOoa7Q7TySDYWNNLwZgcvnp82Zrtt1QO/XAunDHrmOtLHFyTLUcegqMoIW7D0F1nxcrvg2ruIVl1F+eXxPl9AO1DZBXeWhpI8bFx/2zq4x8fYQPM5FQA=
Received: from DM4PR12MB5168.namprd12.prod.outlook.com (2603:10b6:5:397::8) by
 DM6PR12MB3562.namprd12.prod.outlook.com (2603:10b6:5:3c::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.11; Wed, 12 Jan 2022 19:27:50 +0000
Received: from DM4PR12MB5168.namprd12.prod.outlook.com
 ([fe80::9863:4908:dab:d05b]) by DM4PR12MB5168.namprd12.prod.outlook.com
 ([fe80::9863:4908:dab:d05b%7]) with mapi id 15.20.4888.009; Wed, 12 Jan 2022
 19:27:50 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Henning Schild <henning.schild@siemens.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>,
        Aaron Ma <aaron.ma@canonical.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hayeswang@realtek.com" <hayeswang@realtek.com>,
        "tiwai@suse.de" <tiwai@suse.de>
Subject: RE: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Thread-Topic: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Thread-Index: AQHYBo3A8dWJa9atDUWpGRFkRgjWYaxd6guAgAAY74CAAAHkgIAAAtYAgAADFQCAAANYAIAAASMAgAG2zoCAAACZIA==
Date:   Wed, 12 Jan 2022 19:27:50 +0000
Message-ID: <DM4PR12MB516889A458A16D89D4562CA7E2529@DM4PR12MB5168.namprd12.prod.outlook.com>
References: <20220105151427.8373-1-aaron.ma@canonical.com>
        <YdYbZne6pBZzxSxA@lunn.ch>
        <CAAd53p52uGFjbiuOWAA-1dN7mTqQ0KFe9PxWvPL+fjfQb9K5vQ@mail.gmail.com>
        <YdbuXbtc64+Knbhm@lunn.ch>
        <CAAd53p5YnQZ0fDiwwo-q3bNMVFTJSMLcdkUuH-7=OSaRrW954Q@mail.gmail.com>
        <20220106183145.54b057c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAAd53p7egh8G=fPMcua_FTHrA3HA6Dp85FqVhvcSbuO2y8Xz9A@mail.gmail.com>
        <20220110085110.3902b6d4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAAd53p5mSq_bZdsZ=-RweiVLgAYU5+=Uje7TmYtAbBzZ7XCPUA@mail.gmail.com>
        <ec2aaeb0-995e-0259-7eca-892d0c878e19@amd.com>
        <20220111082653.02050070@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <3f258c23-c844-7b48-fffb-2fbf5d6d7475@amd.com>
        <20220111084348.7e897af9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <2b779fef-459f-79bb-4005-db4fd3fd057f@amd.com>
        <20220111090648.511e95e8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <5411b3a0-7e36-fa75-5c5c-eb2fda9273b1@amd.com>
 <20220112202125.105d4c58@md1za8fc.ad001.siemens.net>
In-Reply-To: <20220112202125.105d4c58@md1za8fc.ad001.siemens.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-01-12T19:27:42Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=866f82d8-67e4-4dbf-88ef-177c16ea7b82;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-01-12T19:27:48Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 9ec76a64-7b5a-41aa-bfee-863ece529732
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b5dd6fe-128a-494f-23a5-08d9d6019f2c
x-ms-traffictypediagnostic: DM6PR12MB3562:EE_
x-microsoft-antispam-prvs: <DM6PR12MB35629FF29BD65277E779EB98E2529@DM6PR12MB3562.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nIvw/6NXSDsIwUXp+KzYZM8SsreYinzJwgE9H51kxoIanOa/UEi3P0lVt5kNnjkHALV4WPmUXErCmo2WfFqaLxo+TQvkyu5tyDLTM6NKGCI3GgVoZFwJo5GHxAsNvcWgOYL4ln2nYmOdApzmmYh4QN2HJ4M6CZpIpIz9x+NbQn6OkuS0Qgx5X760KhYOVQ/PxMJw0DwZmdFAaEFPEwF9By9WbBJ14HxkxsTkUvOy4yCVdyxlXg0noXHF8wQaHOlrL+vZtYH/yaUQilP0MPguLoTu0NytX+Ljbgsn8v0wpWP60hpttaAUtc/v50eTsTAK6LJveEkuAV+uxJ5Lyc1X9bP7BHHx16q/ke5ftZp1be2/fKGVfnZSlPrFE7duSe8RM8cmvTYeADu44E3BSJv5n1bqyEeQPvn80cj7uJu5DHIEPiAzUoEF8yuvJ8yDxGVOGfos6dfuDxag77SS69paRHYbHBnfS/PPzowv+bCTIk2Q1t7DkUEObS+ClJjsG1q6Jici+DLBiCAb9w+TmcaaJjUZHN9rbGW7AD6LWuXq7VxT24R2FmDg1WwsBaHw8SJ+RchOkz8OZZv3VsOxB0QNsAVSbDEmKpLbsNH1d9SRso7UYZzQDzxJZSYE83ItAkMP1nRTDsXZx1NLCkG4PQLcMXDcPwIbeDDS3bmkkn9JsvjwS96JKQaLhWaNrC0Y1W9ujUc6ms6Sk7kRCMAk1H/Zmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5168.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(122000001)(55016003)(38100700002)(76116006)(186003)(508600001)(66946007)(2906002)(26005)(6506007)(83380400001)(5660300002)(33656002)(6916009)(52536014)(8936002)(8676002)(9686003)(71200400001)(66556008)(54906003)(66476007)(4326008)(7696005)(316002)(7416002)(64756008)(66446008)(38070700005)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?togqvpeiHwom/nTeNIVaF3qiZfFks7EUNu1iOjHUXik+HMQZgWbEjymZkERm?=
 =?us-ascii?Q?9UPV6R38KQOvB5PzcJTtwDEqytxcyu2U1ySszG6U02X/7PFmPa/Ec5VKB5/F?=
 =?us-ascii?Q?4ZO3GkJJGO4XOzhKwif2oSx95KOAp6FycRm7/uvyy8ZAgrQ6K5WLXXP+498w?=
 =?us-ascii?Q?SyEUml9O3vH9cDs542sO3ox3Pe/tDM0FPIwd1fl9UI1hCTv5C89n01R3XqK4?=
 =?us-ascii?Q?g1+letyJPH5OAH/n1R3RuzYw6Lh0yvHh21V1MNFr7qwwlWj29LDQbcE+j+Mu?=
 =?us-ascii?Q?G2HGG1V5nx8I5mxXZ72DluyFxXZ87/wahHLJ1IKilv9vnxlFhBAXVCkZH5We?=
 =?us-ascii?Q?xRJnXgJyM7uQvMd1Udi4Qd8HVWCz8XYEmjoQvhfMFUjQlNSp9mTtMvh7M4+K?=
 =?us-ascii?Q?iI3VjuEH0NXPsqb91mmKIyE9tB6zraHH1uPCQCKNXN+i7+skDxBTL1FcaTSE?=
 =?us-ascii?Q?6PdEC4fF7Ow8iMan9ueEwiXf4iiV/puJVoRLvEN9UlSCVyUbFHmKfysTmHt7?=
 =?us-ascii?Q?0kXsHLNxP747nfgm0KgKmhI5813KC/tcH5TyVuB2gaqJArucjUpx5TA0NQiF?=
 =?us-ascii?Q?DBy5iYa/CN7hEJy+o0UWfc/otjpfPJbYOlbR9H1FvSTN4XmKimtmDrACgB1P?=
 =?us-ascii?Q?dT4uC4lrqyazDhIWQIJJVDP44luR4HrKk3cPv8a0LXmc8w/QdwU+WE6xzMuP?=
 =?us-ascii?Q?HttKUgapCZGjKK7f576qEjnMpP6XPkotzDGqHnZCohIbgZab6noNIw+8dzMX?=
 =?us-ascii?Q?1eE8NrWZ19gRHSU0AWAOuGOW/OtW7K7yiYtN6qTD+Jo4PNUUVZnm1ewqTS0N?=
 =?us-ascii?Q?bIwKF5XN0/93sImD5upECmJxlRPM9v07uz6ayi/uf38BsqqgrNrEavBW4mGu?=
 =?us-ascii?Q?4hiNtw7eofR8SJIb4N3UpbGQIwRdpQqFk2hnRytXg/3xjBpwCJT/xlQzgvB8?=
 =?us-ascii?Q?Zal9dwUnNj8YCGN8GlVerehXCmihhR7f2EWfbv69kDjaWRqTP0qbZ5Ue01oG?=
 =?us-ascii?Q?y9OjSGiaHSmz9jKeWv7Efh8ZN+RUZPkHdVE3uHAcC//x53IWa8ei3ya8ILD2?=
 =?us-ascii?Q?RKnLxqlJIeewQdPavep0oH0aq6DaeI62Qc7mFEKlxaVRJR2DOtwTWhahdvrJ?=
 =?us-ascii?Q?CRjK9ViV8ol1nQjnBGXW1cLJ++Qw6pBteFGB9KyNed2tT2TXC4sIxOg2i3ym?=
 =?us-ascii?Q?VVo0RAmaWtjk10eNwZl+SvQtJx+l+P2ja6fdyAJsj6+MAenngq4BXDeJJGmu?=
 =?us-ascii?Q?yVPBHAuTr6jgn6Ip7zTPJhCiJEE7QTYLOkFJ+XBHYeuOm4V6KTYiUGeDwvqd?=
 =?us-ascii?Q?qMV4T3T1RAMkwwPJCwBOp7bfHYMKQfm0A7M+C9Q67y2PKwQQTPmB+QjU17uJ?=
 =?us-ascii?Q?YfVSOF8Bqj2KSjJOqLd9iQ6PLtFoIhLOTSIm7oF1iiHjzMsu+fgbIndxvo6t?=
 =?us-ascii?Q?bA2ZlOKxg8gRhXK6PwBSzE7CEyRyXizREmehxq4VzPcki4ShBqBlLgZ8zemc?=
 =?us-ascii?Q?5F6vTpNHJNdREPz4ZAW9QeoQJDZFefIFVDNaK61LU5q35XGKLMKiaHLC2Gl+?=
 =?us-ascii?Q?LentHwaVfadbHjVRW0se8OgtQ4Qozfig7D0ZjNRji6dcG42qrdcuT+X0k1Pa?=
 =?us-ascii?Q?KFo5stVdRZWdiLE/EuNXG2U=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5168.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b5dd6fe-128a-494f-23a5-08d9d6019f2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2022 19:27:50.2636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WzkNYr0iMEoJTZBXmJXo3t6vgtJwfDpYs2FOB4lIc1jp8uqjBG/N0hH3KHSP1fj/ZMKYkWB86S5kQISQLby+qQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3562
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Public]

> -----Original Message-----
> From: Henning Schild <henning.schild@siemens.com>
> Sent: Wednesday, January 12, 2022 13:21
> To: Limonciello, Mario <Mario.Limonciello@amd.com>
> Cc: Jakub Kicinski <kuba@kernel.org>; Kai-Heng Feng
> <kai.heng.feng@canonical.com>; Andrew Lunn <andrew@lunn.ch>; Oliver
> Neukum <oneukum@suse.com>; Aaron Ma <aaron.ma@canonical.com>; linux-
> usb@vger.kernel.org; netdev@vger.kernel.org; davem@davemloft.net;
> hayeswang@realtek.com; tiwai@suse.de
> Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
> address
>=20
> Am Tue, 11 Jan 2022 11:10:52 -0600
> schrieb "Limonciello, Mario" <mario.limonciello@amd.com>:
>=20
> > On 1/11/2022 11:06, Jakub Kicinski wrote:
> > > On Tue, 11 Jan 2022 10:54:50 -0600 Limonciello, Mario wrote:
> > >>> Also knowing how those OSes handle the new docks which don't have
> > >>> unique device IDs would obviously be great..
> > >>
> > >> I'm sorry, can you give me some more context on this?  What unique
> > >> device IDs?
> > >
> > > We used to match the NICs based on their device ID. The USB NICs
> > > present in docks had lenovo as manufacturer and a unique device ID.
> > > Now reportedly the new docks are using generic realtek IDs so we
> > > have no way to differentiate "blessed" dock NICs from random USB
> > > dongles, and inheriting the address to all devices with the generic
> > > relatek IDs breaks setups with multiple dongles, e.g. Henning's
> > > setup. > If we know of a fuse that can be read on new docks that'd
> > > put us back in more comfortable position. If we need to execute
> > > random heuristics to find the "right NIC" we'd much rather have
> > > udev or NetworkManager or some other user space do that according
> > > to whatever policy it chooses.
> >
> > I agree - this stuff in the kernel isn't supposed to be applying to
> > anything other than the OEM dongles or docks.  If you can't identify
> > them they shouldn't be in here.
>=20
> Not sure we can really get to a proper solution here. The one revert
> for Lenovo will solve my very issue. And on top i was lucky enough to
> being able to disable pass-thru in the BIOS.
>=20
> From what the Lenovo vendor docs seem to suggest it is about PXE ...
> meaning the BIOS will do the spoofing, how it does that is unclear. Now
> an OS can try to keep it up but probably should not try to do anything
> on its own ... or do the additional bits in user-space and not the
> kernel.
>=20
> Thinking about PXE we do not just have the kernel, but also multiple
> potential bootloaders. All would need to inherit the spoofed MAC from a
> potential predecessor having applied spoofing, and support USB and
> network ... that is not realistic!
>=20
> Going back to PXE ... says nothing about OS operation really. Say a
> BIOS decides to spoof when booting ... that say nothing on how to deal
> with hot-plugged devices which die BIOS did not even see. But we have
> code for such hot-plug spoofing in the kernel .. where vendors like
> Lenovo talk about PXE (only?)

Something that would probably be interesting to check is whether the
BIOS uses pass through MAC on anything as well or it has some criteria
that decides to apply it that the kernel doesn't know about.

>=20
> The whole story seems too complicated and not really explained or
> throught through. If the vendors can explain stuff the kernel can
> probably cater ... but user-land would still be the better place.
>=20
> I will not push for more reverts. But more patches in the direction
> should be questioned really hard! And even if we get "proper device
> matching" we will only cater for "vendor lock-in". It is not clear why
> that strange feature will only apply if the dock if from the same
> vendor as the laptop. Applying it on all USB NICs is clearly going too
> far, that will only work with IT department highlander policies like
> "there must only be one NIC".
>=20
> So from my point it is solved with the one Lenovo-related revert. Any
> future pass-thru patches get a NACK and any reverts targeting other
> vendors get an ACK. But feel free to Cc me when such things happen in
> the future.
>=20

KH & Aaron - can you please talk to Lenovo about making sure that there
is a way to distinguish between devices that should get pass through or
shouldn't and to document that? =20

I think that a policy that it should be a NACK for anything else general
makes sense.

> regards,
> Henning
