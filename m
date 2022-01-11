Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F063648B772
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 20:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236751AbiAKTjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 14:39:40 -0500
Received: from mail-dm6nam08on2080.outbound.protection.outlook.com ([40.107.102.80]:43232
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237158AbiAKTjj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 14:39:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZG2x50obHyTpDaz+meQbXcUOikhgS1BGGaNJo8AVNK8Ofq3yIycom6xPYzYRGy6iKVKvva8GJfdZ1kkuAFPUghROI/2a5TxOZpRsZtAX2phjlZ0aP7/PREfbJSZkKU5QmyExTl+QXq0knYT5r5j0X/JB6XyMjLNtwRnY+XtMXh4k+ymIPUoDq0SNqZjtJEQ5iVs6Lu8oVJLd+uC93K2846r3/4sF0QdUvoWIQPq6zQ47ZqD+TqQ0iJ/n5r+4EhrAg2L/lBMDsvNXTqwddbP68Hmys190qwXKInzBb6oVXpt7eMLzsviZXpkJ97XTMnHrw0Fr0+Vv52mAt0INss5AGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q1t1NP0MSG7/UbeTZ1qbFNY8/VlB7fC2TBAhZF/eo+s=;
 b=G4IrSlcpkXjY47qoJHQ+Zi0XbeihMkQmGUxnjL04fE22P7id0Q8iGILs+cT1BFTBpMvp4td/WGf0PkqMRMVYeplf19jU3XtNN/HRSU2/6NF4EW8vF64kT240/+1sRibZ5XJmZoNVIAeAV+Y40QRIpKZGH1InaMp1hvCRMh0Y4TdKNZcHoilXVzteY04PKSiQBgXrMX9mnBqDCBasnzdaDbss6a07t+arl15zAan2562ZLmZvGAGBRMa6sPYWMx3vOsnHbZB5J0Bd3WvqLRO5w2LGdUFO4xFHIYcbz1cv05t7T3iryu4l4A1gdCVtcHWO3s0Q5G3cvfhsDfXaRrgQIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1t1NP0MSG7/UbeTZ1qbFNY8/VlB7fC2TBAhZF/eo+s=;
 b=VxsEYQHpEFBquFlQfxG6knz+x79Qp8jnz0NJqrSZKM5G4rOskFNuGDk7ig4kM5T4pUVRlpBa2Uyld0DJ0WK/xT/LA5uZ1zqAeo043hOuXQ1cihRiV4J9YWJc9kGDDzIPmUgYufbEZjFoh6alilu1FONzNKxwwzhzMfofN9SQYi7KxMCkPrKRvAG6y9645UwO8+2IVO9h2U79v8nye68aiqfNXjGGvfN47AbFacbogFVXEDFwUaVlGnpyECGaFnSNhMeTPOiYGf0hUJCbZlz18V/m6b9docAaZnwMv1G/ecFpswtLOFM9ZXOG7hbIYcuSW2OEXUeBM2lzbszZcL5rsA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5484.namprd12.prod.outlook.com (2603:10b6:510:eb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Tue, 11 Jan
 2022 19:39:37 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1112:648e:f77b:9bd5]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1112:648e:f77b:9bd5%3]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 19:39:37 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: RE: [PATCH net-next 1/2] devlink: Add support to set port function as
 trusted
Thread-Topic: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Thread-Index: AQHX369dAvMd8dQm6EWLk4Akff8tAKwQUeyAgAxe1YCAAFJzgIAAQYWAgAJAsgCAFHu/AIAAEYwAgAAwXQCAAA3JAIABIJ2AgAADBQCAKOGdUIAAGjyAgAAAZ2CAABGKAIAAAMHQ
Date:   Tue, 11 Jan 2022 19:39:37 +0000
Message-ID: <PH0PR12MB5481E3E9D38D0F8DE175A915DC519@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
        <20211130191235.0af15022@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5c4b51aecd1c5100bffdfab03bc76ef380c9799d.camel@nvidia.com>
        <20211202093110.2a3e69e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d0df87e28497a697cae6cd6f03c00d42bc24d764.camel@nvidia.com>
        <20211215112204.4ec7cf1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1da3385c7115c57fabd5c932033e893e5efc7e79.camel@nvidia.com>
        <20211215150430.2dd8cd15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SN1PR12MB2574E418C1C6E1A2C0096964D4779@SN1PR12MB2574.namprd12.prod.outlook.com>
        <20211216082818.1fb2dff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR12MB54817CE7826A6E924AE50B9BDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220111102005.4f0fa3a0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB548176ED1E1B5ED1EF2BB88EDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220111112418.2bbc0db4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220111112418.2bbc0db4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4c4917bc-a146-424d-16fb-08d9d53a1a3d
x-ms-traffictypediagnostic: PH0PR12MB5484:EE_
x-microsoft-antispam-prvs: <PH0PR12MB54840ADE0F5FC77725A3DB88DC519@PH0PR12MB5484.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q174630mxErZhuip4ozGCJjbebWTSqVdWY4CSrW8HfVBblQXCJ6GI+TCcYKEm0OFfqQoqQV51opka4KPvgB5/wYsouMOm8hRBzl7tmekVHjPDmHzhY0DEo5ADwveWnHEcpNiP0ka2H+7f1EjfVmcdOfFpbSbuNGMl3HeB5Ge0W6fqkLXWQdqyj0SMhWlVb+2ia67hNlCxZpEdMeybemY/DklGaC0kRsmiNbfR/G3FRT7mXitzE6/GtZmniqITb7wuJvgwfSLT/HuFckGSfpzmD1MbIPEe9zz4th/HRngAVfhI4sesnUZYdaLdCRCKh8MORgNHtGm6iCfBe6zIP7MsYx/bsz6bKAdVLAt1B263QKwUNlNQNXB3VAfo2gZGYXGEcCAUvqtzwtIF9rG8++99mt602Yf56DQ+xran8hbJ6IyOa4jHW7x8DQp1OM4cpUBUmVrg5P6tYoOVDOD8iolbcQwBE5XADmuXFbHC38tS+uXs85a+82oCpXc0gI43CBFR7gB0txBcbEOoXinu+++f6PdmglgnhrafjN5xLq3ufg1bcq/By9xp6Ci2X8C/B++8KoxXMOuteGHG8nSR5aklXQZxLRAsSH0jM7SRZ8mhYKX/kmabP7HgFyrXFNNAl+AX25ZLvzkDKoQrEAHG0ZNi4tJaAp5Mv9+/2d5oZFp0UAN02A/tcm8VKR9HxKwkaWm37Af1rAZxZyBMjFF56xWDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016003)(122000001)(76116006)(26005)(6506007)(2906002)(66946007)(83380400001)(508600001)(38100700002)(186003)(5660300002)(86362001)(64756008)(6916009)(8676002)(4326008)(54906003)(33656002)(66476007)(71200400001)(66556008)(8936002)(316002)(7696005)(66446008)(107886003)(52536014)(38070700005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QuxuAyKEC8FYBuJEUb1/tV4pCA9O+72j9KJMR2FqrumwdXlYlK+ZENXNTR1z?=
 =?us-ascii?Q?CBRvKv03xJVIQiv9e+YjicYT6F286/t4PbyFZTTF3tb2frK7e9MiROs/zC7p?=
 =?us-ascii?Q?2uBgz0KJ3loJK7+cNII8YQITy6kpK2/S2gc8R76Zwad1TDbX/ZNBYp+TE8uO?=
 =?us-ascii?Q?9d6g9Ku5XNFNWNOuRxlxcjVlKIcoK4HS1t4qQof1SssFlHwBm4oC3gV7wFSF?=
 =?us-ascii?Q?0Oliobomrb0FXSIsYz5i6IbMFHscnsddXmiqkg6yI1CNHw9fAguvr/R4iT35?=
 =?us-ascii?Q?S3laJRguyON7HC+HK/3dEqyqS654D5dMc/liDaiedwbOC/OR1ZO2BGuJMNqh?=
 =?us-ascii?Q?xTsNjb6cG/e0I1JZe28YOeX3rdbmMiNj7ht1ErqjP16RbPi1olzBUNBugUzj?=
 =?us-ascii?Q?GsZJDy3ydmWxqHKtum4cVnK9vF4bgxs2mOWT8kLqlfBt/4ZNwWPp9ne9Xzxs?=
 =?us-ascii?Q?YLx8S0vPe0ZHDvT4+MmjU+elfFZdNT6tbitwt1fGims+Fiqd1h3M+kdYbGTS?=
 =?us-ascii?Q?fIzjmIer6mUc5iLzL1MmAZQkPTZrSzHGPJ5QdGVXz+jK7u5snSmZbEvBSw2l?=
 =?us-ascii?Q?mIimh1UtaSYFIU4tXME3tKUYVhlA4a7aXISdS2dmC0N5QEr8NNy1jx148qFu?=
 =?us-ascii?Q?I+x1mpCYSvv5gSd4LOwcEdXDIncdxKyM1Rwb3XF6cAgVb0RjBAotH/YUzLCQ?=
 =?us-ascii?Q?QRJ8Xp7pKuaBiaVTO4TOHF00CUNHxBCSapYyfgLmFiiEpYH4K54Ki9FxD+Ad?=
 =?us-ascii?Q?nxlcCYyZsWXDAPcn6sfbOfNqftqX/+UIR6Zy7Fwcpgys743NghXgV8kYEmN/?=
 =?us-ascii?Q?+/CtG7WcHebX0MBSsYkxOrr+OttAo3B8tR9MN9CVXhD9iJbJFz8PkSLjZVn4?=
 =?us-ascii?Q?9MuHKBg6M+jb0cM/iTqbaRTU6IYO8Dw2aWzIdceuRAOhEvfhPQCjxSu5dNv3?=
 =?us-ascii?Q?YCHSgx+Ip0pQqOg74+iFeKb11FzjVF0E3wzu85KsX5H5Nb6kcbRdNpj6sTui?=
 =?us-ascii?Q?I/CmEX7c6nxxnUK8wWh7sN7NxUeVUXd6spkSppukszlnuMkjMrGA4zO8MQWJ?=
 =?us-ascii?Q?6n7l9a0gy24vxMw39lWght12BkIjVDeUniu/Jjj1C+xC84Jjz4u/w5W10lu3?=
 =?us-ascii?Q?E/5wFp/ft9goIAfOe38nlruntgS8QtX+fH5XLLGU342DnqnaRRrCxgSlH2Ie?=
 =?us-ascii?Q?6LYMhM5uXQki55pJ9Mra0mas92/bAK3piYqVgILwGHpOC5Bu/pM4RyBl09QW?=
 =?us-ascii?Q?TRo6RbiqAtt1qO3gXtdOOfQ4gEWJjPWpjutyAkSH7uieHFYTIih9KIhaDDRW?=
 =?us-ascii?Q?sl+9+HFr07etI4vkJczJehzL5+ZezN1uXBsrLQ1cVLIiD7t6yE53+C4Suv+m?=
 =?us-ascii?Q?d3JUE/e+G6sh4u7q4Z7SUBx2zxFXg1jcwMwj5ZB8tNVrbnGS97ZQk1K3t8zO?=
 =?us-ascii?Q?CDXLcy0xlJNAtNVwpMhSlgxm/yIeAgTLIVMLPMOEhsid9Cf+SIkLNgYJPSTo?=
 =?us-ascii?Q?6X/zbFYG+7MRucexu0G0EEODA/sH3lEo/MUvhbjf5HApWehRFWkxiEQW+sFk?=
 =?us-ascii?Q?uceJEzBgRvzmg8zqZuOkVfrylXZceR0NR9wjeKE8L89u50nPkegzhyiZ9LfW?=
 =?us-ascii?Q?AZiQvCXeY5ahnIyXOzW0d+8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c4917bc-a146-424d-16fb-08d9d53a1a3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 19:39:37.3260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f5CpEKeJv4B7DpcWN2I+kO/lGXIT0fJQK/4LJ5HsHSy+ZNNszfjRe06lAtdQHhtihGypdh2tsIxaCLZ6hKmslA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5484
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, January 12, 2022 12:54 AM
>=20
> On Tue, 11 Jan 2022 18:26:16 +0000 Parav Pandit wrote:
> > > From: Jakub Kicinski <kuba@kernel.org>
> > > Sent: Tuesday, January 11, 2022 11:50 PM
> > > > This discussed got paused in yet another year-end holidays. :)
> > > > Resuming now and refreshing everyone's cache.
> > > >
> > > > We need to set/clear the capabilities of the function before
> > > > deploying such function. As you suggested we discussed the
> > > > granular approach and at present we have following features to on/o=
ff.
> > > >
> > > > Generic features:
> > > > 1. ipsec offload
> > >
> > > Why is ipsec offload a trusted feature?
> >
> > It isn't trusted feature. The scope in few weeks got expanded from
> > trusted to more granular at controlling capabilities. One that came up
> > was ipsec or other offloads that consumes more device resources.
>=20
> That's what I thought. Resource control is different than privileges, and
> requires a different API.
>
It's the capability that is turned on/off.
A device is composed based on what is needed. ipsec offload is not always n=
eeded.
Its counter intuitive to expose some low level hardware resource to disable=
 ipsec indirectly.
So it is better to do as capability/param rather than some resource.
It is capability is more than just resource.

> > > > 2. ptp device
> > >
> > > Makes sense.
> > >
> > > > Device specific:
> > > > 1. sw steering
> > >
> > > No idea what that is/entails.
> > >
> > :) it the device specific knob.
> >
> > > > 2. physical port counters query
> > >
> > > Still don't know why VF needs to know phy counters.
> >
> > A prometheous kind of monitoring software wants to monitor the
> > physical port counters, running in a container. Such container doesn't
> > have direct access to the PF or physical representor. Just for sake of
> > monitoring counters, user doesn't want to run the monitoring container
> > in root net ns.
>=20
> Containerizing monitors seems very counter-intuitive to me.
>
May be. But it is in use at [1] for a long time now.

[1] docker run -p 9090:9090 prom/prometheus
=20
> > > > It was implicit that a driver API callback addition for both types
> > > > of features is not good.
> > > > Devlink port function params enables to achieve both generic and
> > > > device specific features.
> > > > Shall we proceed with port function params? What do you think?
> > >
> > > I already addressed this. I don't like devlink params. They muddy
> > > the water between vendor specific gunk and bona fide Linux uAPI.
> > > Build a normal dedicated API.
> > For sure we prefer the bona fide Linux uAPI for standard features.
> > But internal knobs of how to do steering etc, is something not generic
> > enough. May be only those quirks live in the port function params and
> > rest in standard uAPIs?
>=20
> Something talks to that steering API, and it's not netdev. So please don'=
t push
> problems which are not ours onto us.
Not sure I follow you.
Netdev of a mlx5 function talks to the driver internal steering API in addi=
tion to other drivers operating this mlx5 function.
