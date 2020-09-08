Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19B626234D
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 01:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729622AbgIHXA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 19:00:28 -0400
Received: from mail-eopbgr1310112.outbound.protection.outlook.com ([40.107.131.112]:51472
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726657AbgIHXAY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 19:00:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h9MHv+iZ9H/G2lBTnlalT+BIi8x1ODc4DLkklMFgMMklmkyiXUZO0GD93N/nKTjoy4Z/qFP3HY9R53Zdl+L7mEzDmh3l6g5qCBnio32QI/BSkd79DM4GFdWNJY8s9p/RsgfM5PI1MaPfteYFW9jEOncKVVR/RXd04iRBkPYEVTfFJS36AV5CBEZ6jFc3ZnjOtI287Oo0Xy54MR9D8nfPzArVFAIsT3ZhAp+sQdDIDIvfvbuKqoZDCuu4Om/44ik2jx1bqj1iNsJa3Xh3iAhza5ICEAZZ8nsbUPf/733Wb+SWDNKzOkHbgYEuuUF/enYhF0L+ZzbUkf7V9clbLZCzmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m80r6IF1NHaK6kW++uFYVytHGQo4PH5AAW/UHA7y9kQ=;
 b=GeIgtPERiHFjB5DAh+hBvyfwXXH5uNH5lE52XrOQ5rzd5k14wgUdtRE9OWlOQAJO552rsJ2S/Qlvnq9DcPvVDYamlHQR8uRnuonGL8JZEiRXXLmPBXajb/MV8qJ1pvGEARtyeIg6oN910lHAx+tyCGs4Xwt27tKnIfOLcppAp+0pd3jOOmWCiKzg3arkcPk6KrHc7zHryFYLhddaWRejvR2lLIO7shkHN9/xx25pX4Q7dGHJUdrcZTeTuSC5DX5i55FDkXtRKCjZQFbazlmcWQTQv++S8TsRUl8fwezG1RRI0wGsdm1xV4kH+MkkquEytKKEuz3TqQ0KfbKAbAZ60g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m80r6IF1NHaK6kW++uFYVytHGQo4PH5AAW/UHA7y9kQ=;
 b=L3fba1RSDRfhL9Cy/nJAOLgTVjqbzL9C+NWkNb9iGfOEe3t2CLnXg3NHwFOx5sGBNoSR/l6ZxnNDBhn2rUxZYQvy6OssvHk2h9V4e5EisABK9OH5UNxwc/UI4a0ZVk6syeNwDzOi7CkYFwmys5vX2vuXgO18Fob9NBu3UcsoDsY=
Received: from KU1P153MB0120.APCP153.PROD.OUTLOOK.COM (2603:1096:802:1a::17)
 by KL1P15301MB0069.APCP153.PROD.OUTLOOK.COM (2603:1096:802:10::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.0; Tue, 8 Sep
 2020 23:00:14 +0000
Received: from KU1P153MB0120.APCP153.PROD.OUTLOOK.COM
 ([fe80::800c:633d:2d74:4f61]) by KU1P153MB0120.APCP153.PROD.OUTLOOK.COM
 ([fe80::800c:633d:2d74:4f61%5]) with mapi id 15.20.3391.004; Tue, 8 Sep 2020
 23:00:14 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Michael Kelley <mikelley@microsoft.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v2] hv_netvsc: Fix hibernation for mlx5 VF driver
Thread-Topic: [PATCH net v2] hv_netvsc: Fix hibernation for mlx5 VF driver
Thread-Index: AQHWhOZ3aJ4+rg54iUOHrDzCz+q7FKlfN90QgAANYlA=
Date:   Tue, 8 Sep 2020 23:00:13 +0000
Message-ID: <KU1P153MB0120DC1BBBA1F274E47B7D8FBF290@KU1P153MB0120.APCP153.PROD.OUTLOOK.COM>
References: <20200907071339.35677-1-decui@microsoft.com>
 <MW2PR2101MB10524833244E1E0AD68A12D4D7290@MW2PR2101MB1052.namprd21.prod.outlook.com>
In-Reply-To: <MW2PR2101MB10524833244E1E0AD68A12D4D7290@MW2PR2101MB1052.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-08T20:49:12Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d449b8a8-9a67-46f3-b3d6-3fdc37ab3b4f;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: microsoft.com; dkim=none (message not signed)
 header.d=none;microsoft.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2601:600:a280:7f70:cde3:b0bf:e4c7:806b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0985c47a-b029-4020-4667-08d8544af22f
x-ms-traffictypediagnostic: KL1P15301MB0069:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <KL1P15301MB0069E4213C32C5F6746671F4BF290@KL1P15301MB0069.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sqSnw6jwbwgjspCUD6bKEsi4Ig3U5OVNR1Fvhi0+JEpWicbDRByHQrON1dtLJqv4Oje1ggIxsd2uIfDrIXFoHTy5qjXnKOKsSWz52cfQPCFQtl1H0d2HLeFWGzVlGD2C7ShABsEla3/rx5sWEpjo3drIgu7EcV6T3yXF3uswKpu/YH/hYrLLqlNfhJE+jpol4uS7llby2CkX2PtUmGxkQ92nXoEV3S4Dmur+nXBqCgn4GlLCnuw0OPoJVqbA3eBswzbN4tPISX9CTMQ4gpungwy8Nxvdi/FiQwjhRL8wbejdGiZa63jc2OTGX7mRWCRkZvAEapGFrHEsjY94IoJCfpHVT8aDz6A4A0lfgjpgujQUOVYeSZPd0s1zB2i5ej02Ezqh0Xz+r7cGX/PvB4aTPRm7AF/A2KbYO/PCb1/N3+c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KU1P153MB0120.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(83380400001)(82960400001)(82950400001)(76116006)(66946007)(64756008)(86362001)(66556008)(66476007)(7696005)(52536014)(66446008)(5660300002)(71200400001)(110136005)(2906002)(33656002)(186003)(8936002)(6506007)(9686003)(316002)(8676002)(10290500003)(478600001)(55016002)(8990500004)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: bZgxARiYufX/MYtHS6RPUKpYoeZss+19OB1PSxAao++YK/fIp5kbWP/2KrTQf3+ylxryzHdBSpqaG392h0ckHATJa3n46G97d2+z8CLgIPJSyX5B4aVXDf2U7c6KcFt4UVTjRDiqcyKPp34iSDmWOnYJv6yiEPAiVljQiRZuVegOsJfoRK9z0AVveKi92nIt+j5bBuaXcJcEHoyMQxKDK87MwyGLRzgEdBKkpOrHXcKqVtefDyPHsYiSReVutWFFyj4bKyX973IontsrcihU2+TCzZoeAd08/m3Bcz3tlJSd+gBY2SIfiHudUmcnNdMVQEh8yOrGgtHvs4Y5gtMdIF9A6mD54T6AImQfbx9RZAJ73vFBbsd9E8kPaM7slxEVaUmm3OrcFyFSwufueiVpZdRaP0QlF1eePD8fTa/wLkXbi2nXvU1AxPXuakv/Ry1cLfDj75dP/6dpOaHj5JE9VUhdZ+qtWCTwQdxk41bBTfjPN/zRFcQ+alk7LlVsANVu1QMb1slBeNhn/HK0bGeYeol/Zr2LG/IH6C2MXeSIsk8Qq0VVv+V6TM5S7xXkN7wScEK6e+4FWdcW8kvLHPJ5en6GzAzRLnW/iLaNFAz48eI/6LUHowPD+zoftDw7XIc5vQdcANFFbWOkJJaLvmkdFPUlblbOIWCGh/wWKLmzCdVpPU2GMR5YSLH4imBc2q00wq7tBjc0d84JaxtfYTG9Gw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KU1P153MB0120.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 0985c47a-b029-4020-4667-08d8544af22f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2020 23:00:13.7834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UdZBjY0bXHRS0Fyh+urj4GxWZ5EKBUSSecyZ4mC7ZxKrxdjbsU/lGUPCS7Nf0wt0W8v6q5lIPc/ugoOTDcZmCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1P15301MB0069
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Michael Kelley <mikelley@microsoft.com>
> Sent: Tuesday, September 8, 2020 1:49 PM
> > @@ -2635,6 +2632,15 @@ static int netvsc_resume(struct hv_device *dev)
> >  	netvsc_devinfo_put(device_info);
> >  	net_device_ctx->saved_netvsc_dev_info =3D NULL;
> >
> > +	/* A NIC driver (e.g. mlx5) may keep the VF network interface across
> > +	 * hibernation, but here the data path is implicitly switched to the
> > +	 * netvsc NIC since the vmbus channel is closed and re-opened, so
> > +	 * netvsc_vf_changed() must be used to switch the data path to the VF=
.
> > +	 */
> > +	vf_netdev =3D rtnl_dereference(net_device_ctx->vf_netdev);
> > +	if (vf_netdev && netvsc_vf_changed(vf_netdev) !=3D NOTIFY_OK)
> > +		ret =3D -EINVAL;
> > +
>=20
> I'm a little late looking at this code.  But a question:  Is it possible =
for
> netvsc_resume() to be called before the VF driver's resume function
> is called? =20
Yes, actually this is what happens 100% of the time. :-)

Upon suspend:
1. the mlx5 driver suspends the VF NIC.
2. the pci-hyperv suspends the VF vmbus device, including closing the chann=
el.
3. hv_netvsc suspends the netvsc vmbus device, including closing the channe=
l.

Note: between 1) and 3), the data path is still the mlx5 VF, but obviously =
the VF
NIC is not working. IMO this is not an issue in practice, since typically w=
e don't
really expect this to work once the suspending starts.

Upon resume:
1. hv_netvsc resumes the netvsc vmbus device, including opening the channel=
.

At this time, the data path should be the netvsc NIC since we close and re-=
open=20
the netvsc vmbus channel, and I believe the default data path is netvsc.

With this patch, the data path is switched to the VF NIC in netvsc_resume()=
=20
because "netif_running(vf_netdev)" is true for the mlx5 VF NIC (CX-4), thou=
gh=20
the VF NIC device is not resumed back yet. According to my test, I believe =
this
switching succeeds. Note: when the host receives the VM's=20
NVSP_MSG4_TYPE_SWITCH_DATA_PATH request, it looks the host doesn't check
if the VF vmbus device and the VF PCI device are really "activated"[1], and=
 it
looks the host simply programs the FPGA GFT for the newly-requested data pa=
th,
and the host doesn't send a response message to the VM, indicating if the
switching is a success or a failure.

So, at this time, any incoming Ethernet packets (except the broadcast/multi=
cast
and TCP SYN packets, which always go through the netvsc NIC on Azure) can n=
ot
be received by the VF NIC, which has not been resumed yet. IMO this is not =
an
issue in practice, since typically we don't really expect this to work befo=
re the
resuming is fully finished. BTW, at this time the userspace is not thawed y=
et, so
no application can transmit packets.

2. pci-hyperv resumes the VF vmbus device, including opening the channel.

3. the mlx5 driver resumes the VF NIC, and now everything is backed to norm=
al.


[1] In the future, if the host starts to check if the VF vmbus/PCI devices =
are=20
activated upon the receipt of the VM's NVSP_MSG4_TYPE_SWITCH_DATA_PATH
request, and refuses to switch the data path if they're not activated, then
we'll be in trouble, but even if that happens, this patch itself doesn't ma=
ke
the situation worse.

So ideally we need a mechanism to switch the data path to the mlx5 VF NIC
*after* the mlx5 NIC is resumed. Unluckily it looks there is not a standard
notification mechanism for this since the mlx5 driver preserves the VF netw=
ork
interface. I'll discuss with the Mellanox developer who implemented mlx5
hibernation support, and probably mlx5 should also destroy/re-create the
VF network interface across hibernation, just as the mlx4 driver does.


> If so, is it possible for netvsc_vf_changed() to find that the VF
> is not up, and hence to switch the data path away from the VF instead of
> to the VF?
>=20
> Michael

When we are in netvsc_resume(), in my test "netif_running(vf_netdev)" is=20
always true for the mlx5 VF NIC (CX-4), so netvsc_vf_changed() should switc=
h
the data path to the VF.

static inline bool netif_running(const struct net_device *dev)
{
        return test_bit(__LINK_STATE_START, &dev->state);
}

The flag __LINK_STATE_START is only cleared when the NIC is brought "DOWN",
and that case is already automatically handled by netvsc_netdev_event().

For mlx4 (CX-3), net_device_ctx->vf_netdev is NULL in netvsc_resume(), so t=
he
CX-3 VF NIC is not affected by this patch.

Thanks,
-- Dexuan
