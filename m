Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DD2253CC2
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 06:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgH0Eds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 00:33:48 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:54107 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbgH0Edq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 00:33:46 -0400
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4737a80000>; Thu, 27 Aug 2020 12:33:44 +0800
Received: from HKMAIL103.nvidia.com ([10.18.16.12])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Wed, 26 Aug 2020 21:33:44 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Wed, 26 Aug 2020 21:33:44 -0700
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 27 Aug
 2020 04:31:46 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 27 Aug 2020 04:31:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KUxMku8Vif1ARAJMX6/DCOp8FOueo5Kd4+QI2RxSDcaxOnuFMdmgGYpXC+xJYIJ/uepoekBmT+HiY6UsxaqSkquXvg4e8IrdC1RGgIfX9v+EMRsgxlqxN8S8gMylgxmI/N7IUfWQBpaBqa3OCOaiOrnK95zo0JDjjvgjkiT0LnKRbQti2Wmx/dUGwjwxechL9YOf1DLngtMZX+MxUhuLuDO8hidU5Jj5bq0YRpHo6RNJAX5aBvCCmdo493jLmsZYT5of9jH/pBbH0sjHSVXWoSRS80cPlUaFbe/8Dli5kVtuoFeLC8cfM527c72tzCUWKR6diSg0j0c0uOsWjItx8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jdJOKRRljgPpOvqY0aBOxbW2gERyrxikzWdzCeh3d9E=;
 b=LiNnKc9mppGC0HBb0IHZsr68cB/1NrvSNvNNiVk7Hl7b0ZdUCyO1RO9OWftM7k6SS2i44y8HwLkEGjkvTtDRrSij0Gy5glNMBT+IAlSdyBtnF/ipriOGT1KhwZQZY9ooGC5jXsI+vYk8+e154Myf3sy83UbMeDu10qFj+7G/rC+hxrY4sMR53sKpYC/+dbKKBzkSLUUoWqKXHGZdKG7QUHz43KmVsIvEQdtYKqs4vmKP2tOE6QOJOcedX6+MnbVwnsd6BOhuPQzfZQqM/AjZfqjsgoiwlsR9u541VDKq6yyALcjeByrsfG6+f1nEJ+Zg8T9eboekKArgXDBi4JR49A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB3955.namprd12.prod.outlook.com (2603:10b6:a03:1a2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 27 Aug
 2020 04:31:43 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707%7]) with mapi id 15.20.3305.032; Thu, 27 Aug 2020
 04:31:43 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Parav Pandit <parav@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@mellanox.com" <roid@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Thread-Topic: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Thread-Index: AQHWeugVEZjy8+Bcu0qKDL1vbGgf/KlJitKAgABAGdCAAQhmgIAAinbQ
Date:   Thu, 27 Aug 2020 04:31:43 +0000
Message-ID: <BY5PR12MB432276DBB3345AD328D787E4DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200825135839.106796-1-parav@mellanox.com>
        <20200825135839.106796-3-parav@mellanox.com>
        <20200825173203.2c80ed48@kicinski-fedora-PC1C0HJN>
        <BY5PR12MB4322E2E21395BD1553B8E375DC540@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200826130747.4d886a09@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200826130747.4d886a09@kicinski-fedora-PC1C0HJN>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47df37ad-d6e4-412e-da70-08d84a421a1d
x-ms-traffictypediagnostic: BY5PR12MB3955:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB39559FA256AC5E3F809C9716DC550@BY5PR12MB3955.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F4te42sBi4wEfYvS5duDbCGUv7V6dE00qU2hMhRp5I912UIRtQb4j4/1Nq4TRHbwfSim8SSEVlhVoSFLnFQPTrcGLZOhJawhl1rahO1TJiPZ9HI+5FHnAM/vosLCu8/NLgU3BnECv3NZSgvqtNMCHQCJLN0ZjdVdDNiucybEmorQePEBwZbClNznfgYNdqfkw37xCD8fOoOpeCRTlV+rvaqCaZIAvioXHH6cubi2rm/1m+0fI9pd3LGQhgYA2w7OsTUNHi69wG1BHKBOtR+yQhkTyMTGdU0JseOxFTdS/WG47JTmHp52Yd/bgOZKr2R6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(66476007)(66946007)(76116006)(52536014)(64756008)(66556008)(71200400001)(66446008)(6916009)(55236004)(7696005)(33656002)(186003)(107886003)(6506007)(8936002)(8676002)(9686003)(55016002)(4326008)(5660300002)(26005)(54906003)(2906002)(478600001)(83380400001)(316002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: JldnjdsFU7Vr7xGCJcFuoRo4us3eAYU5wgrptB1bg7XGMGi1j4TODVpTBT0wI5HgDwi50hvgsoznSjl6vBLB3HbVbvC3Xavwsz9zq4TJO9XkVwj8GiHgW6uCFkDyqfZsRouZlYiZ+TfJbJPORQvHqpA/gX946fNqlp1TjGKrvG3jO6Chen4UU8PWwdoXqgNYUD9cBYPyXna7MMHLykSR5TKa4imSVQlI/UP+ZDp7Cr7/Ca9AS+yys4L3MvKa/3yZtqiUwrAN6FjPdi+2lSNmvVG4Fzl38IeH8t24lyItwQjgo76VvPWVEaDNKg5yKaTsCJpv1ciuBsoJMUqYmd3Zd+xTQoplH+w7ZUvXdqH28giYCmTG6KmOEVL6AKB4DWRqRni21Nh92Ae2XtPvq8LtGVK2rgF0RxtH4p8zKdcC26DEEg2rHqZcOHM2ljwTJSIZ/f1zIsKdKQRvFxOetZwOa6cd/AYK3l4vrstaT8BwSAo989ydU4IL2Qw3qvnJVgjf0Q72eNBmHI0OzhIaYFpETNDIA3jzKRXlR7qESZJa6cKKqwuN153fftq1uLaMfE2Mq8nNCHxUIvxYTNJ183l/jHn9ggHBTV4+ZP363aC2RW6P+JArzS6a5LhJvsJkFxrgy13PQD3eFXxFQRUO3HV7KQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47df37ad-d6e4-412e-da70-08d84a421a1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2020 04:31:43.8460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uFisE+8ip3QPuse/CC4ByQd5jQDzeUNmPvj24fcNkAwnK9iKXsiHOGwXo98phF4gtDTSPr3rz0BVoM4cq6G1pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3955
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598502824; bh=jdJOKRRljgPpOvqY0aBOxbW2gERyrxikzWdzCeh3d9E=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=dc1wA+rhHH1kAQoKm1L/gA3cno/CFQmUI5GIFijAQcCiuL030S/E8w2++WU05x+73
         1or3GFLfL7NtWNdrjkcxxrrVaU+ZIAFyuhQ+fz+qZvThmcoFscj8U0XWtvcNYME1DR
         NmaFouOP91CLRFBdp1fygkAxgDWhgyjR7njghge4tYZROJHJv2+CZvc4MjIYzBV/h5
         MhzG5RACbdIQPApDJQXutP11oVTLpgm/yTx4g32B16E71GX1SB0Hq8DNLQlVOqYcXp
         MeipqI2lVGiRnNmKzmC0rW0dZuniBPkHD8/Bwzf0LSCL5mahn5MLDWsTY/MVMSOc5S
         v9JBIY7JENPLw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, August 27, 2020 1:38 AM
>=20
> On Wed, 26 Aug 2020 04:27:35 +0000 Parav Pandit wrote:
> > > On Tue, 25 Aug 2020 16:58:38 +0300 Parav Pandit wrote:
> > > > A devlink port may be for a controller consist of PCI device.
> > > > A devlink instance holds ports of two types of controllers.
> > > > (1) controller discovered on same system where eswitch resides
> > > > This is the case where PCI PF/VF of a controller and devlink
> > > > eswitch instance both are located on a single system.
> > > > (2) controller located on other system.
> > > > This is the case where a controller is located in one system and
> > > > its devlink eswitch ports are located in a different system. In
> > > > this case devlink instance of the eswitch only have access to
> > > > ports of the controller.
> > > >
> > > > When a devlink eswitch instance serves the devlink ports of both
> > > > controllers together, PCI PF/VF numbers may overlap.
> > > > Due to this a unique phys_port_name cannot be constructed.
> > >
> > > This description is clear as mud to me. Is it just me? Can someone
> > > understand this?
> >
> > I would like to improve this description.
> > Do you have an input to describe these two different controllers, each
> > has same PF and VF numbers?
>=20
> Not yet, I'm just trying to figure out how things come together.
>=20
> Are some VFs of the same PF under one controller and other ones under a
> different controller?
>=20
Correct.

> > $ devlink port show looks like below without a controller annotation.
> > pci/0000:00:08.0/0: type eth netdev eth5 flavour physical
> > pci/0000:00:08.0/1: type eth netdev eth6 flavour pcipf pfnum 0
> > pci/0000:00:08.0/2: type eth netdev eth7 flavour pcipf pfnum 0
>=20
> How can you have two PF 0? Aaah - by controller you mean hardware IP, not
> whoever is controlling the switching! So the chip has multiple HW control=
lers,
> each of which can have multiple PFs?
>=20
Hardware IP is one. This IP is plugged into two PCI root complexes.
One is eswitch PF, this PF has its own VFs/SFs.
Other PF(s) plugged into an second PCI Root complex serving the server syst=
em.
So you are right there are multiple PFs. Both the PFs have same PCI BDF.

> Definitely please make that more clear.
>=20
Ok. yeah.
I should add above details.
I think a text diagram might be more useful.

> Why is @controller_num not under PCI port attrs, but a separate field
> without even a mention of PCI? Are some of the controllers a different bu=
s?
I think It can be added under PCI attribute, but than we need to add it for=
 PF and VF and in future for SF too.
So added it as generic. But yes, keeping it as part of PCI port attributes =
is good too.
