Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF784A0043
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 19:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344035AbiA1SlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 13:41:19 -0500
Received: from mail-dm6nam12on2084.outbound.protection.outlook.com ([40.107.243.84]:24384
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343613AbiA1SlS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 13:41:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GWR8dMKnyohD23/QS8TYpnxMvyZwlaTXraIoqnkYxT6wjonUbXx4ghHzALiH8l2Sa5jMSPQ/AIOljiipeFjjB13buvgmSI3lHk2/P1CqXKduNXfKDa1TjOx0WI4FooMMG37dBBwST/HVfQX6cFaAcJ7Fmr7J/Gis/FEY1lNtF/18KoAW0tF9enuK7iuPoOZpdSvFSB5OQWsPzeulHDIZ/mx2s2Ww5Pu3pFA6I3ay9jx4VyN/gB938+0c/sFZMH4g3zTftOIvuNhoZVdvcU5yepvMCGFhC32r6LL2EhfCppFNueMqJU0otc6rAQD6pfSrPnRnz6OGJ9rczlk9/oxZ/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vspFqpt/o9ZCwL1/66+qYrhpfTdPz4c1c9rly063Bf8=;
 b=SQ9wD5TkqcHDMh2mGb8q7lzxlxmNG5n4Mlo1ptBVHywLyG3n9UJtELXJwbzcKJjwa0+IcIruudYH4iMJpU+2ATE3o9P76U74URyBrzexjhly4FryTU0YaL83hSNAGdNk8HjeOHBl6xuLsi1wJe9WrfnPD0b10WfXNUKiAKGggILmAzRFbJesLdX+wQz20VfXs1UdUDzS9jHbOis6vddD86xYSCmwVpKl29SiTbb1T/BKYDJbxyuSdazuKxkQkx5tYaLwk6Zb1BPpasdJGpdfTK+YK/Cqcav64wpLkg0rqMnm/AcGeSbpkn2qiRVCZRSVXtyY5Lz2EYEB6GYs5nlqkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vspFqpt/o9ZCwL1/66+qYrhpfTdPz4c1c9rly063Bf8=;
 b=NZeAUbyFvrGV6b9LINlMJ9rYVp4vDOSO3Ir2FNyrBNg40bklsr/WXZpqeZanPjF7UoGc8E7upFiKnLv+p4epNLp+iIxupVWRe/FEJJDGyooy53/0SNoOKYLl4lS/LDKjWN+RzLeeFQz+84/gRC9LzGEvlP/0G1KJ5SBaocDpCmY=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by DM6PR12MB5533.namprd12.prod.outlook.com (2603:10b6:5:1bc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Fri, 28 Jan
 2022 18:41:16 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f%4]) with mapi id 15.20.4930.018; Fri, 28 Jan 2022
 18:41:16 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Henning Schild <henning.schild@siemens.com>
CC:     Aaron Ma <aaron.ma@canonical.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hayeswang@realtek.com" <hayeswang@realtek.com>,
        "tiwai@suse.de" <tiwai@suse.de>
Subject: RE: [PATCH v3] net: usb: r8152: Add MAC passthrough support for
 RTL8153BL
Thread-Topic: [PATCH v3] net: usb: r8152: Add MAC passthrough support for
 RTL8153BL
Thread-Index: AQHYFAALP4fXSy15IESwbHMcR00FLax4F/qAgACjk4CAAACvgA==
Date:   Fri, 28 Jan 2022 18:41:16 +0000
Message-ID: <BL1PR12MB515773B15441F5BC375E452DE2229@BL1PR12MB5157.namprd12.prod.outlook.com>
References: <20220127100109.12979-1-aaron.ma@canonical.com>
 <20220128043207.14599-1-aaron.ma@canonical.com>
 <20220128092103.1fa2a661@md1za8fc.ad001.siemens.net>
 <YfQwpy1Kkz3wheTi@lunn.ch>
In-Reply-To: <YfQwpy1Kkz3wheTi@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-01-28T18:41:11Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=406cafc8-f3e0-452e-9250-cc85a407a24b;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-01-28T18:41:14Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 30ce5fbc-6edc-43e3-821c-136502db3da2
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 154a8a94-e69b-4a09-91f9-08d9e28dc467
x-ms-traffictypediagnostic: DM6PR12MB5533:EE_
x-microsoft-antispam-prvs: <DM6PR12MB553386467BBBF2575B63EC64E2229@DM6PR12MB5533.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tbU49077i+hZ+HhJGR12JSwcmqKiQkqUVtXDVyx5lE1qSfV6uvrxXleh6qXXPiUmB7iSi3qAQmTGFPrpmdL3YAhCl+RrN92adoZjrcuLjcYHC8RK5NBDQr1ZF9h3jKz2rZ0RQL68zbp2LErjHoQdfcWPkY9spAP1UUYo6naa6ZAYKxhKYZ1Mq9pr4zN05gfbgmSIS6MXOKCgovIpNysoaL07F2MEmI561hC+1YiQrgynEk2Y79mNHSovWIoojnhaUBsS0PbJ1rw+eN3BF40BA11aFON8ESzK/R3x7iZFxxV8Jgjmn9NPGWrcgsFGTQTgcl4iOJyM9p/bMUDXKM8QzoJXvLDPsgqf5t0M7fQWiwlYQhVgCYySZSlTt6EnqvISjE5KuFFTNtk3IfITYvAzMz7GEtnQn/n5ZPOJIzJSco1uSxJQqOsVRhkPpr3JmZXbOpPRjQYJdGlVA6VMCR4jsgP7UwU80Q1k8SnHnlCDSb08oeUJvH4PTZZ1R/DdLkak9XdVAP6+nOzRzNYv3miibEjXqSN4Ae3AN/ElYI7Ih7iZ5UMtA7jRE3T5BkH7mooPLngaOENKidKtpLfeBxE7Z7y9I89cTn2DJXtHrlrn+5RY4lGGW+iYTaZmGftdSAzEYd4mKPdmF+L19hm11ZU/a7xEMfMWHsYPyairZfXd6UTz4k3VR36IrfaVfv8sI4lIRd0sYOTWdu2/0HhPZVZ2Bg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(71200400001)(55016003)(4326008)(53546011)(26005)(38070700005)(66556008)(66946007)(66476007)(8936002)(66446008)(64756008)(8676002)(76116006)(83380400001)(6506007)(7696005)(508600001)(122000001)(33656002)(316002)(52536014)(5660300002)(38100700002)(110136005)(54906003)(186003)(9686003)(2906002)(7416002)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DMRuIoZw8FOEqrdd1XOWwEjM3+kxEO8jf0I3fFCUN/DGhB/9F8CV96Tiy3cO?=
 =?us-ascii?Q?Jhcs53E2uoFXmNzGpncGFf/f2dF19qDGdq9/TP3gfCOy6dxWz2p9JMBzYPoo?=
 =?us-ascii?Q?h7XJefkGUt6T9lkCmWLgTWGIeOzgQAURFj8qEzYEcjvpcQosyJII56QY6PRL?=
 =?us-ascii?Q?OuNEgXYIH/pznVUmwZnYTRQPuWqSkM2oag4HaKW/yOa7m04Y5ppJ0f0mFK+L?=
 =?us-ascii?Q?46Rqv1JSlbPvUcyRgkNYZIoCyGzbRC7Uzqzv0G6XdyK7tY/BTChRPFJo3tC6?=
 =?us-ascii?Q?zdOe9RhFxwjHj+/nBmnKnVzQVX4cJ8i5G//i+CarO8Q3YllLZto15ROrmPjD?=
 =?us-ascii?Q?0dZe05YR5LNYJtSTBflCCWPSkQo27WK1+gYI2knmsdUwAd360SU2wSzptI4A?=
 =?us-ascii?Q?nBxMSsZkPBbHlaW6eSe0O3PiAuOk/GuYfmC3MaZNFMOG0ZkdJdxAWPxLeZRH?=
 =?us-ascii?Q?WzqEEF1eFdC5pGLvJ+owmI0bptHldL+c7rI7Hic3V+VWakV6+H9Qe01E6fXV?=
 =?us-ascii?Q?DuW4QdrEp8Z5n4WhCilGmKkDYOat5T9WeAK/7ZFNNox7xVa+B/kLZYzLbaY2?=
 =?us-ascii?Q?SgL+tTS8Rbqn9j+o/tBBoWbFQUt2jsEdP9v0GdUWjkLn3pP2K39QTb2Cb2/e?=
 =?us-ascii?Q?2nSCIF7tlABWk89JrUyxmNz0BfgrnDocLe+fgopA9gLTxx8g7yx3H+NaLbKD?=
 =?us-ascii?Q?TcVODxX4+TB5TKIQrj55o6pKYjE5TILFJyBilVEaIyKYrEpGU8SQZPWuFq1D?=
 =?us-ascii?Q?fqcyEn1nsB2gBJsZ2SPjSBkrnPfgccvE+BJumJ6I1OqjzLIsOHxj1JTQrnpa?=
 =?us-ascii?Q?HQorMX1nk7ZrBDTnip2Opx4qkURJsdeJKiXmGnmA3fhhC4cHr3J+1vs+2wS7?=
 =?us-ascii?Q?8kUROo/tKG+ddmS8/GLAnQzBf3r2lGC1ajgE9ERZLeIBC9L/lwfoQ8EzSRrd?=
 =?us-ascii?Q?NAnrnSjstVMYc8juEbW6fiipmD2sQkQWOdkrx/zOQX1GHSU/CUL/PNBuE0QX?=
 =?us-ascii?Q?ssyUcArjHy8sFg7x6m8gRmBR7By+hu0N7JOjTLz4akznXb0+SknuhNBSzbTU?=
 =?us-ascii?Q?TmKnumaucnAwpjgm3gU5mXcZpvQcqZPiIKB8U6QbFtWbMpR/BlDxoivrTker?=
 =?us-ascii?Q?4jJWtr1Ll1CLBWroI40Mur/xBsE7j1uBHCrUu+jYUjGKSZpVVSQifJrnm+ud?=
 =?us-ascii?Q?Z1LJHdpR2NZvKP6l06Mw9f5MlZkySXsiHU+sxhzIXz7xbiXyE/xIbQG6nSij?=
 =?us-ascii?Q?gO2Qfe7LuOdcBwbFh6jbLARlzNLWhb9l1LQy0YqdL4aofkK7NMGTFgjKaqUM?=
 =?us-ascii?Q?S2BQibYFi4BRqNznAvNL+eUDuXT2l/D92/ihYl5fm1KBIrp8teIuGVvc0+aV?=
 =?us-ascii?Q?REu4xR/3yBJriMif29ddwElalJgvWtP4wfS0KeXXd/q7MkEOXQo/JrMVx/nN?=
 =?us-ascii?Q?Z1y/1+ca5HWR3FKZXYV59lworFsdeB5FeQkvxq23qsoszKUWTL/tyh+3whRT?=
 =?us-ascii?Q?JNIoACc20XdzHrGFSW147kxi3jiGkPFD+cb5viRplMZe2Yp27knc0eBKbPj3?=
 =?us-ascii?Q?iKfF5tgsOxUKZcDO1/inbwIT5vzXTD7lhp366Goy4EQrq4axiODWMJrV17Rs?=
 =?us-ascii?Q?SotJZ7cTPLri4JetWVvYVYI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 154a8a94-e69b-4a09-91f9-08d9e28dc467
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2022 18:41:16.1148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OTUsRbT2ptM9ZsULUbp79flCyaqrNWC5JYWulVISFtPmh5AAMl10OikyY6VS4D+Mx71tcxLy+aS5x9A6/SAMNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5533
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Public]



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Friday, January 28, 2022 12:07
> To: Henning Schild <henning.schild@siemens.com>
> Cc: Aaron Ma <aaron.ma@canonical.com>; Limonciello, Mario
> <Mario.Limonciello@amd.com>; kuba@kernel.org; linux-usb@vger.kernel.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> gregkh@linuxfoundation.org; davem@davemloft.net;
> hayeswang@realtek.com; tiwai@suse.de
> Subject: Re: [PATCH v3] net: usb: r8152: Add MAC passthrough support for
> RTL8153BL
>=20
> On Fri, Jan 28, 2022 at 09:21:03AM +0100, Henning Schild wrote:
> > I am still very much against any patches in that direction. The feature
> > as the vendors envision it does not seem to be really understood or
> > even explained.
> > Just narrowing down the device matching caters for vendor lock-in and
> > confusion when that pass through is happening and when not. And seems
> > to lead to unmaintainable spaghetti-code.
> > People that use this very dock today will see an unexpected mac-change
> > once they update to a kernel with this patch applied.
>=20
> I've not yet been convinced by replies that the proposed code really
> does only match the given dock, and not random USB dongles.=20

Didn't Realtek confirm this bit is used to identify the Lenovo devices?

> To be
> convinced i would probably like to see code which positively
> identifies the dock, and that the USB device is on the correct port of
> the USB hub within the dock. I doubt you can actually do that in a
> sane way inside an Ethernet driver. As you say, it will likely lead to
> unmaintainable spaghetti-code.
>=20
> I also don't really think the vendor would be keen on adding code
> which they know will get reverted as soon as it is shown to cause a
> regression.
>=20
> So i would prefer to NACK this, and push it to udev rules where you
> have a complete picture of the hardware and really can identify with
> 100% certainty it really is the docks NIC.

I remember when I did the Dell implementation I tried userspace first.

Pushing this out to udev has a few other implications I remember hitting:
1) You need to also get the value you're supposed to use from ACPI BIOS
     exported some way in userland too.
2) You can run into race conditions with other device or MAC renaming rules=
.
    My first try I did it with NM and hit that continually.  So you would p=
robably
    need to land this in systemd or so.

>=20
>    Andrew=
