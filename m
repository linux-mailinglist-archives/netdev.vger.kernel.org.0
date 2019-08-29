Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D57A145C
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 11:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfH2JIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 05:08:02 -0400
Received: from mail-eopbgr140051.outbound.protection.outlook.com ([40.107.14.51]:56334
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbfH2JIB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 05:08:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9sgV+9stda2W6RIcFsSeC/gTuEAabFsj0bfEf9dmnyCwvMGjJYr3fULv8BBKcp1uCvKi7pzpKlElvEbDONu+7ykaUTHKbdby1LpZiktaXdkHcw+XcBvXTNu3uiv9MJ/GVavKSVo87NPrmtmD7wdRYyWc+ert4KM3Mat7r9rail5fmQImJta1kbmSOAS5MhB8DFpAl5PWh4YlLF6iKv+DqX1XcpLlbqy4cQWd+UjoEWaJRgazRHSmgUwkBcZP+qYizJ6OflaQzA6zXCHbGF9KwCjdPpKCYEeaoCDGN17IJNd1aHnlQFwtT8lTUbjcucEu9j3xtKmmqA4D442TJkHXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5amKbeP5DOH6+SuHnHv8b1JexsqDXH3S1o3I9FX9gs=;
 b=l1oWVWuVV7PoMxhs9pFe72Skl3N0o5jXqeE26xZdOs7oVMuln3eRMxwYqFTerV+gahPFS07W3KSn6cvDcq2EfOrhJdiaGdXBOtlClNgIhnU4S8FZoxrEIryGe39IM8ukZvXm1HnCSQj9T+fgOGYIHu/BWUuZTLl5mG0+RYZhI18jvOgiOBoGTQwuDV36CnALgiDKAuFdPPlpIGDEfrJb2OPhf6YbpJe6YQHUlB8vwHmcmNPigJC5QFQ8N87OaFzsx0UYk1NoM0nzfl4xcuH5CHkLo/SV8qdwYTOzB4fzEe7KrPrLJTDlKCVlJZz8A+5f6D27ikMY5tdM6r16XTlgzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5amKbeP5DOH6+SuHnHv8b1JexsqDXH3S1o3I9FX9gs=;
 b=AeIE9JSdRucvddFgfslQMLh3ifwbgWmJ48Wv5mb7Ox1bBfL0c8ESbY2R4pNPTc64iHKAZvzchekjVefjV5Sl4l8gk2jI4WB3vF0sPQC13Vlz+jZA9fbUbBVwYnt2/c9WNPQbl3CMSOiwIdFjb9G2iTsMxTPFKXmFtMVC2Avs8Go=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5937.eurprd05.prod.outlook.com (20.178.119.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Thu, 29 Aug 2019 09:07:58 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 09:07:58 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v1 2/5] mdev: Make mdev alias unique among all mdevs
Thread-Topic: [PATCH v1 2/5] mdev: Make mdev alias unique among all mdevs
Thread-Index: AQHVXQwNAbFu0HBvBEOVNM9QLjIzW6cRF1AAgADBBiA=
Date:   Thu, 29 Aug 2019 09:07:58 +0000
Message-ID: <AM0PR05MB48660A0EC22AD9B1E2A6B629D1A20@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190827191654.41161-1-parav@mellanox.com>
        <20190827191654.41161-3-parav@mellanox.com> <20190828153652.7eb6d6d6@x1.home>
In-Reply-To: <20190828153652.7eb6d6d6@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a08574c-ffb5-4c76-409f-08d72c6062f1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5937;
x-ms-traffictypediagnostic: AM0PR05MB5937:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB593786852A0F6DF1C0E640B8D1A20@AM0PR05MB5937.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(54534003)(13464003)(189003)(199004)(186003)(4326008)(81166006)(66476007)(66446008)(66556008)(316002)(64756008)(7736002)(5660300002)(256004)(11346002)(66946007)(33656002)(86362001)(446003)(9686003)(478600001)(3846002)(54906003)(14454004)(6916009)(476003)(52536014)(6246003)(66066001)(81156014)(6506007)(53546011)(6116002)(486006)(53936002)(229853002)(55016002)(2906002)(55236004)(9456002)(71190400001)(74316002)(25786009)(6436002)(76176011)(8676002)(99286004)(7696005)(71200400001)(305945005)(76116006)(8936002)(102836004)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5937;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: l7BLcTiGcXo2mGdsaRf9nIPVjNB5OiJi3L5551/IzwIMDfm6fSgsgk1da2RLLKtwUc040+zapmefTo2I2UWmfcJuAG56NtxupCdgAigLRv3D2/0J/dE7oRpsKTCUAVUcaZU4etMzz+jeDb5PmANrh+NUhZ2MbfvvpWtdo3mc4D+C6ToOArW2n1a6zcFwR3VrQW5UDtFCDoeLxzySW4RBoEjNh6H5PR9bR2GHr94jYBCmPw3rOcLwh5uYtDm3NhwsJQUq+ti3u9A22PEM81AtmWP+Jum1zLjwlQZEoqgKyDP18JBjPJScpVJFz8pl9NJxOEjpmZVsESkVNoBcGVjaUXL02XTxL8RE97opGmsXg2A4jvCFyQ7cihDQZbjQVsG94PNne9j6Y0olq/8/ANlCVA+BcdWbSZa0nFU2B2drlx0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a08574c-ffb5-4c76-409f-08d72c6062f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 09:07:58.2786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0UOwkMgbMUTAFTbCdKNxoOmNZ0r2gagrtztjFAY7wy6EayXmVlWmsYsDHqPmByWxgXn6ZOZd7RnbVo9IKVUBOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5937
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, August 29, 2019 3:07 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>; kwankhede@nvidia.com;
> cohuck@redhat.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH v1 2/5] mdev: Make mdev alias unique among all mdevs
>=20
> On Tue, 27 Aug 2019 14:16:51 -0500
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > Mdev alias should be unique among all the mdevs, so that when such
> > alias is used by the mdev users to derive other objects, there is no
> > collision in a given system.
> >
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> >
> > ---
> > Changelog:
> > v0->v1:
> >  - Fixed inclusiong of alias for NULL check
> >  - Added ratelimited debug print for sha1 hash collision error
> > ---
> >  drivers/vfio/mdev/mdev_core.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/vfio/mdev/mdev_core.c
> > b/drivers/vfio/mdev/mdev_core.c index 62d29f57fe0c..4b9899e40665
> > 100644
> > --- a/drivers/vfio/mdev/mdev_core.c
> > +++ b/drivers/vfio/mdev/mdev_core.c
> > @@ -375,6 +375,13 @@ int mdev_device_create(struct kobject *kobj, struc=
t
> device *dev,
> >  			ret =3D -EEXIST;
> >  			goto mdev_fail;
> >  		}
> > +		if (tmp->alias && alias && strcmp(tmp->alias, alias) =3D=3D 0) {
>=20
> Nit, test if the device we adding has an alias before the device we're te=
sting
> against.  The compiler can better optimize keeping alias hot.
> Thanks,
>=20
Ok. will do.

> Alex
