Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28938F54F2
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388683AbfKHS5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 13:57:06 -0500
Received: from mail-eopbgr10053.outbound.protection.outlook.com ([40.107.1.53]:38727
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388592AbfKHS5E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 13:57:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MXMVFLi8DFFe405sWwSFf0XsJVWo8/MAG8lflqXYduUT6UbsmN5SfS/2Iu9E1CBhG5M0jeaEluhFxakJguw6tGaFTAetzrLymBPjUwcXstwnyVMj5WqIUPB9RjoZx05qflTIyXWTeHByp78JY9+NUxH6T6RvPmMcd+/j+pt63gT5OMZzeLmQmzIKnGBVuWB2HjLcdzUlkXK8gYDACiVNU1aabuq+lakKmxfvgUQpEqSw9ykF964HiDpVUuFMcnGvxv/jmSoBaIGVDor0VgdM8Fte67XyhIHvpOxUBzmBf9oZjUp6YyqsptvzqTvM+VZmII0WIerXwW7Vn7vj9HTLZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gmOYtdjMjRMKI+YXdD13xaeqU88JMh/8ZJqlS2JCOkA=;
 b=oFozGGkLl+TR36obAJpZ8557j9IUdg5dm1An1r5e63cWwEh64cNE4/M94hZ7K0J+rZoWlqmMBthS2vO05ZD5XQQyb64jmfmVsnYgzynF9chAGXSvZ4vpUrXjGjGQbXp4aOAYN6LD1lmRwmS78FLxcZbgN3N2nk8tEYt8ZZ3C3oyWxpa+2WELjsc2697F1MoIaMEUBHVOcZLwm3d7t31dK5gigtAXoYYhfQFCqJ1ipl9fMNpTVy7vN3jpjWWNKvVEIAXVU1ot5x8N2OGLq1cUdlpjsILROWM1adp+QhWP1QWNYq6md3h4Sv5QDVIhVAUG5n+ibe4GD8KYlttlBLgifg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gmOYtdjMjRMKI+YXdD13xaeqU88JMh/8ZJqlS2JCOkA=;
 b=p7OJoQTdtrIQLBQ6OjsXSg9xKNxxLkaouodRZTwjYnPuoamhbyhnxek3EA45Rz/SAyTL/eWjgpl+9zPInpEoJIdrEbFKe1DHeeg3LKj9fSRgf0JXnRKjRzArKeZgaBIN/HyQh5aXEAC9KTADRi0JVzMW1PytMhVoeQJ6vUjLoVU=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4354.eurprd05.prod.outlook.com (52.134.90.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 18:56:59 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 18:56:59 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
Thread-Topic: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
Thread-Index: AQHVlYW+5ckj7/tyDUu1ocZ3bBFvo6eAK5wAgAAEe2CAAEmKAIAAA1+ggAAOHACAAAFAIIAAe3YAgABjcxCAAA2tgIAAAeXAgAAZ84CAAALlcIAAA3+AgAAGPcA=
Date:   Fri, 8 Nov 2019 18:56:57 +0000
Message-ID: <AM0PR05MB486663979B27ABD9B0281EBDD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107201750.6ac54aed@cakuba>
 <AM0PR05MB4866BEC2A2B586AA72BAA9ABD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191107212024.61926e11@cakuba>
 <AM0PR05MB4866C0798EA5746EE23F2D2BD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108094646.GB6990@nanopsycho>
 <AM0PR05MB4866969D18877C7AAD19D236D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108163139.GQ6990@nanopsycho>
 <AM0PR05MB48669A9AE494CCCE8E07C367D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108181119.GT6990@nanopsycho>
 <AM0PR05MB48667057857062CB24DD57D2D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108183411.GW6990@nanopsycho>
In-Reply-To: <20191108183411.GW6990@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d195eb83-c0b0-47b7-17eb-08d7647d6f27
x-ms-traffictypediagnostic: AM0PR05MB4354:|AM0PR05MB4354:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB43540DA75618DFD0FAAD8E52D17B0@AM0PR05MB4354.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(376002)(136003)(366004)(346002)(13464003)(199004)(189003)(71200400001)(81166006)(33656002)(14454004)(6436002)(76176011)(53546011)(6506007)(102836004)(54906003)(5660300002)(76116006)(186003)(86362001)(52536014)(6246003)(4326008)(9686003)(305945005)(66946007)(7416002)(26005)(66446008)(64756008)(66556008)(99286004)(7736002)(66476007)(74316002)(446003)(8676002)(229853002)(256004)(316002)(2906002)(55016002)(476003)(3846002)(66066001)(81156014)(6916009)(7696005)(478600001)(6116002)(71190400001)(25786009)(486006)(8936002)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4354;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WygO6pM+feE3qEyPE9r7646Wfz7VdANfR55DRs9shgaaOgQkxuwQ+jTXHo6ax/iddfNVwq5DeMkG+UsX2s7eLJ8XD/ORkeO9ijCdF7ZnAgjhYOvjGM4ehkw5alyXNRIJMP0NEZQAgOA/COEg4mwwlL2iAee6K9hN5GPYqEHC2ddZBn+JwkvTc9qpyfKRSUEtkG3LfXqBdkoNoveHvQkRzNDsEI7rEeQnl/NyJDBQdIsIznkOUxH9swtuMdxYcIRtv4/Y0piq/ztKT/PQ0ZqnLLVFFRAsCRwHp7UcaYOKiWaQKqs9Xfs6ZuQw/q6PppwFWClwx57PusoSXsQwbiJQctygwtf5f3NuZyf+rLh4hfd5QZNoY9tVoayEDP30bu/IcQuKLZx7KWI0YaQ6UlkgiyRWSfPrHMqY/osCg67f60DVcjyByKVZqcww7xG0Incx
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d195eb83-c0b0-47b7-17eb-08d7647d6f27
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 18:56:58.2264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5mEPCsU/PCGGH+r5p7Vlvn+R9MUZoS0szQe46tde5WgBLMjL4BOj7ZxEtYqaQHG0zNk5vdbMIkCxKlNJ+CHTkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4354
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Friday, November 8, 2019 12:34 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>;
> alex.williamson@redhat.com; davem@davemloft.net; kvm@vger.kernel.org;
> netdev@vger.kernel.org; Saeed Mahameed <saeedm@mellanox.com>;
> kwankhede@nvidia.com; leon@kernel.org; cohuck@redhat.com; Jiri Pirko
> <jiri@mellanox.com>; linux-rdma@vger.kernel.org
> Subject: Re: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
>=20
> Fri, Nov 08, 2019 at 07:23:44PM CET, parav@mellanox.com wrote:
> >
> >
> >> -----Original Message-----
> >> From: Jiri Pirko <jiri@resnulli.us>
> >
> >[..]
> >> Well, I don't really need those in the phys_port_name, mainly simply
> >> because they would not fit. However, I believe that you should fillup
> >> the PF/VF devlink netlink attrs.
> >>
> >> Note that we are not talking here about the actual mdev, but rather
> >> devlink_port associated with this mdev. And devlink port should have t=
his
> info.
> >>
> >>
> >> >
> >> >> >What in hypothetical case, mdev is not on top of PCI...
> >> >>
> >> >> Okay, let's go hypothetical. In that case, it is going to be on
> >> >> top of something else, wouldn't it?
> >> >Yes, it will be. But just because it is on top of something, doesn't
> >> >mean we
> >> include the whole parent dev, its bridge, its rc hierarchy here.
> >> >There should be a need.
> >> >It was needed in PF/VF case due to overlapping numbers of VFs via
> >> >single
> >> devlink instance. You probably missed my reply to Jakub.
> >>
> >> Sure. Again, I don't really care about having that in phys_port_name.
> >> But please fillup the attrs.
> >>
> >Ah ok. but than that would be optional attribute?
> >Because you can have non pci based mdev, though it doesn't exist today a=
long
> with devlink to my knowledge.
>=20
> Non-optional now. We can always change the code to not fill it up or fill=
 up
> another attr instead. no UAPI harm.
Ok. sounds good.
Will implement this in the respin.
