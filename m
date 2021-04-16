Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD87A36274D
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 19:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244072AbhDPR7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 13:59:15 -0400
Received: from mail-eopbgr680126.outbound.protection.outlook.com ([40.107.68.126]:27526
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243998AbhDPR7N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 13:59:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wv7XgsaNHuA1hsyNFCYRCn7g03qdzHZgVIw3j2P3x2zZae01fqd2lt/wHWfzQw4MiHAAHAA4BaIFKjKaEg21d2aJdIEC5TsRKoVNNlJuV8jvCtZDMu7/bZyCcaYm2RJsx1V+vWq6H+PE8kkpte66Qyb8gokcV6Cyc1QmWNiKz80ceAIuL8iXt9Ln2LYonkmYw3+XlaRR57H/+OC+jDcHkpA5z5G+IzEFEa6/+S4m/fk94ZSurTkziqv77MupI3gENxrtRUOwpW8k2MWwUW1Q6XJBE+uwkXVu3sRe0T3SYtIkC0tVLf70uuiw0RvyJzG5omWtPnEsK9HPEEp2xMeoow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7DDXFRNOPYdCJxVk73qmtNCOnX1IBgOU3oZwOR4kFEw=;
 b=g+SbBXte0vRV2cN2aBSl05xsXGnm+5G1z++eZ0wyHDKv4cEkFSjWHd+nkLMdDoyJIdYPUQNxBwhbkAuTThou6gRC3wdoq18qlKiVT6kVar8/Td/zQ2JzK+9wgHlSdVqjFkNh32uMPZCycILib5yho1mMB6cDLCrzRu74akGWFxXnLZDW2e+MMlzYPRIMUdeuO0AmlChCV1OwaUqJPWzTMLm/zz7BwID+oKzVUdY//iAuECayaSyFPwx3yAtNMPxB+FncpwC7dWZ9No+07BaNSChTSxKvr53Os8CJO5WW6GfQLpbrklDL3vq0/uUi+yfSAHyXFuckoLuZJZCOnNloWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7DDXFRNOPYdCJxVk73qmtNCOnX1IBgOU3oZwOR4kFEw=;
 b=CNWeTPm8uWyM3wWLji0Zc5MaLt4qo9Wk4LpcIKrPNDtwY1W2ExAdPbwqlXToWn3qKjhvtHw3+PQL8jn87L12Z4nf6JJZ1JeEVwLyRunrHH/oE3ZlhU3y1eZSHiQtALji19KiDbT8ev/U4Qqo5EJm7h2Sdz5kymo8guNTpNi5uLo=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MW4PR21MB2076.namprd21.prod.outlook.com
 (2603:10b6:303:123::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.7; Fri, 16 Apr
 2021 17:58:45 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%6]) with mapi id 15.20.4065.008; Fri, 16 Apr 2021
 17:58:45 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <stephen@networkplumber.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "bernd@petrovitsch.priv.at" <bernd@petrovitsch.priv.at>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v7 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH v7 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXMuNz15KfoBlrkkekxhRrL9s2dqq3ZoJQ
Date:   Fri, 16 Apr 2021 17:58:45 +0000
Message-ID: <MW2PR2101MB0892EE955B75C2442E266DB9BF4C9@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <20210416060705.21998-1-decui@microsoft.com>
 <20210416094006.70661f47@hermes.local>
 <MN2PR21MB12957D66D4DB4B3B7BAEFCA5CA4C9@MN2PR21MB1295.namprd21.prod.outlook.com>
In-Reply-To: <MN2PR21MB12957D66D4DB4B3B7BAEFCA5CA4C9@MN2PR21MB1295.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=c3e4926e-6dad-4db1-bc63-cbf797964561;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-16T17:07:41Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: microsoft.com; dkim=none (message not signed)
 header.d=none;microsoft.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:d56c:64b4:268d:aceb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53a3531e-b8b9-4ac7-24e7-08d90101478e
x-ms-traffictypediagnostic: MW4PR21MB2076:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW4PR21MB207684FFE58272D6162AE81DBF4C9@MW4PR21MB2076.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UuA1qI2ftj38NAgyFc0sN2RIznnHcIOKMsMOXABQx3BnFCagndYr49EDf4NJYQCgXnAhUtotplzDRnihVpjswxzQldddajhOTtevN90apjaNJtZklrVIQqfYjvRgspxSkeU1AFA0EDN6UiuvunCB6wNLS8pBaTRZhDIytA3N4rmfyUEUJdRiPXzpn8guKPzIhdzWL8C9NrGNmcmr0E/kA00ExQRY9ZDJVVmPYBtoemN7OEW/ty1gb9OFs70YB8t4PfNWvSs57vbdDBLYohkF2Jmotx/3/6J0D7CxJBAq3QCBtNjo76HJyAGKVCV5zIymL5u/6xbAMgfwnIUf0MteExvHGJq7fEeC0rEZvzwZBHv7bYsCpxNxXDvzzzCWi3CL26Tya/rOtWV9bYQlWsMbU2lw5ZKL+ZTKjNclZM1UxypnMoQLmu3Nnx+y316BMavRRg12AYCQLuG37LqHIVmtnBkfn+Y/LntB0Ew7oS7JanQ0lk4QmXsHvYWAyYFtwQY94VVMjOfM5c3FxSXzcgJIYemDIIyyxjsHpgzcWU5HUSmU8Kq4XTSorfcvIusCSD3/VJDfDJxNiuGu2fIH8ODx4Llplm4gM2CMS+JgdKWFuIk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(47530400004)(82960400001)(82950400001)(76116006)(8936002)(66946007)(33656002)(71200400001)(54906003)(186003)(38100700002)(5660300002)(122000001)(7416002)(8676002)(110136005)(2906002)(8990500004)(9686003)(10290500003)(55016002)(66556008)(66446008)(4326008)(66476007)(83380400001)(64756008)(6506007)(86362001)(7696005)(478600001)(316002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?T+BNOWPQ4f3RhMsyWyHXHjSRL6+iDsSc/E2XzxDvF4oSq4ApHF/AX3zTDt5t?=
 =?us-ascii?Q?1SxYn5oNJ400lcWZmkHjZy+Jet2BDCquDYaGL3YPZhKF/2U5T9gegtlYalO7?=
 =?us-ascii?Q?vTsQPEg6HE8/L8Xqd7CZrojofP4icuAfl173WVcbpW1quTH+COxA35IUmOII?=
 =?us-ascii?Q?NswsS4hmIby+I/DfajWdqZz9J4Cth+KFI2HQXJs3shYRhStUBaqhouFcJY88?=
 =?us-ascii?Q?mU1vHdkiehymPYu8A2w6FLIIgUmDK6N4z8TuvbQV3ozpzCV5QtkFSBZSHEqm?=
 =?us-ascii?Q?zqNA27JCjtGeswwZtYoiDXm8WB/ie/692P5jJ8i9vPBPGAEUyvxpT50AtsX1?=
 =?us-ascii?Q?p58Xhmm2GCCnT5vyRa6dzBx5TFHCtr1z867s4Itm6wLIezt+WyEJvk91MuY3?=
 =?us-ascii?Q?Y9Gv4MrtJ+oPC6JpzTj42/d+O5C32T3DlHolefn1nuPCce3no/M1e9+gOfNQ?=
 =?us-ascii?Q?YwZ/kSO+hHsCViaiAY7L1yX42OrGEekXtyk1UWUceWFIvLj+3T7cXF7HjQjY?=
 =?us-ascii?Q?LaQ5M3nCncACqz3a5Zs6TGycRqbhWKwqyiVHwyZNXybwIfWJhfoS0+SXJdTC?=
 =?us-ascii?Q?5+a2cNrsyBFhBSFpBVSHyxlGIVefqZwLoKJ+P2RMpqj/fC3eQ6caBX+UVYCW?=
 =?us-ascii?Q?a1pIuglguYr06lSZaOkTZFb5PFn2G2SBQX2qX87d+EMLkdPS2kzchcLX5eYi?=
 =?us-ascii?Q?yYts/RKuIym2hd1IQR14VP57KqCWpX6slFaBd2gvVdI9k6CxuSQfJs6Q7GN4?=
 =?us-ascii?Q?wlNw+0kqs4DlAkPgtfwANndS3uljWfHMmFHm7ycU7gAgndudHNqUhwU4beF2?=
 =?us-ascii?Q?Q9ALkRoahN4E0ElVI/pgYnLpiis11er9NiMlRaCUJCrFitB0JHjiW/ctx9Mz?=
 =?us-ascii?Q?GHO+t5GHuc9sAmmPV4726q7GkOte1t1+NBoN2VFSap45npDfrQ1JX6tLZWRb?=
 =?us-ascii?Q?ccskkd0XGiFTwTzXhyIhrUJ+OZRzEzU2eKgIyJ6+XT1xUSdSMAee7Vd8jQnt?=
 =?us-ascii?Q?CI4ic59lxo2NHHas2BWZp3jKi8lJ+9zlO+VLXaoXmpK7tKjkTR6sfy+4FPc/?=
 =?us-ascii?Q?S4OjYrgKqeF5oMxDTpsWVUPnG4Jmqb/cFgxn++OO0gl/TmGZIb+izTOemgT+?=
 =?us-ascii?Q?YgXt8n1BdJEICK7ksdYf9i/yPrFdo4N7MMcW2UPpk4bBXnuffWE9OS5WAZBm?=
 =?us-ascii?Q?qRM1jL7tdHDKs+Jos14jdWOb7UgK+c8E5PG2OaQZqJmpeY/9PvTTk+NnZLpl?=
 =?us-ascii?Q?s0P1vkBEDXSI/q1Hbdg8wVF4Dxcm9sPKsH8zkvBl9heOb9+1fliFM9B7EQ+E?=
 =?us-ascii?Q?jdixQNh3GjJwz2o4aCp+JGaUZwp8aM5j6U9KxZWFrgXdPdJJ9kBT+NQciepd?=
 =?us-ascii?Q?I5Yfr4Ts3dWFZKOFSwjfDKNIIlQh?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53a3531e-b8b9-4ac7-24e7-08d90101478e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2021 17:58:45.5479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9dQi236H40Z+KU2NY0su0mdqOXem+HDz9GTQQG81xHYhk6KjHQwmb0r5g8gNNJyKO8tYVP0+qPUUoPlllZR/tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB2076
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Haiyang Zhang <haiyangz@microsoft.com>
> Sent: Friday, April 16, 2021 10:11 AM
> > From: Stephen Hemminger <stephen@networkplumber.org>
> > > ...
> > > @@ -2319,8 +2320,17 @@ static struct net_device
> > *get_netvsc_byslot(const struct net_device *vf_netdev)
> > >  		if (!ndev_ctx->vf_alloc)
> > >  			continue;
> > >
> > > -		if (ndev_ctx->vf_serial =3D=3D serial)
> > > -			return hv_get_drvdata(ndev_ctx->device_ctx);
> > > +		if (ndev_ctx->vf_serial !=3D serial)
> > > +			continue;
> > > +
> > > +		ndev =3D hv_get_drvdata(ndev_ctx->device_ctx);
> > > +		if (ndev->addr_len !=3D vf_netdev->addr_len ||
> > > +		    memcmp(ndev->perm_addr, vf_netdev->perm_addr,
> > > +			   ndev->addr_len) !=3D 0)
> > > +			continue;
> > > +
> > > +		return ndev;
> > > +
> > >  	}
> > >
> > >  	netdev_notice(vf_netdev,
> >
> >
> > This probably should be a separate patch.
> > I think it is trying to address the case of VF discovery in Hyper-V/Azu=
re where
> > the reported
> > VF from Hypervisor is bogus or confused.
>=20
> This is for the Multi vPorts feature of MANA driver, which allows one VF =
to
> create multiple vPorts (NICs). They have the same PCI device and same VF
> serial number, but different MACs.
>=20
> So we put the change in one patch to avoid distro vendors missing this
> change when backporting the MANA driver.
>=20
> Thanks,
> - Haiyang

The netvsc change should come together in the same patch with this VF
driver, otherwise the multi-vPorts functionality doesn't work properly.

The netvsc change should not break any other existing VF drivers, because
Hyper-V NIC SR-IOV implementation requires the the NetVSC network
interface and the VF network interface should have the same MAC address,
otherwise things won't work.

Thanks,
Dexuan
