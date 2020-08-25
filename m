Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35CC25219B
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 22:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgHYUK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 16:10:57 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19447 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHYUKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 16:10:55 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4570110000>; Tue, 25 Aug 2020 13:09:53 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 25 Aug 2020 13:10:55 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 25 Aug 2020 13:10:55 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 25 Aug
 2020 20:10:55 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 25 Aug 2020 20:10:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K63enzP/V1cVulN2q0kABMmoek7a46o0pE8B7kvqcZtkMAxVnUkkh+guf2jnT6RPB4Ug9efGPy/ZBwkud1q8YBPGVXgjSAAnKgGr3MupT1ZILPxxnztWQmH5Mvq8jVeR54IKM9YAg9ITyBToINDXHyVrXr8Cqn0p/beVJ74tVjHrwdq+WYsmaOWQJ3vMfPnfB2ylS7jMzSqusDCNtfxsiAYdovEoFBdzmpzC1HI1Wz+ImS2PcEZ1nNgRQZtbLj82BUaq/DuJf5SxrxVJ9S0MLq3jevqlbDk+KRRIPSGyoUnpkjW8tUs2r4z1O3BmWlK00OdY4NOajucS9BaEpuKHXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwhPAIK6YRfW7VrFtaCybyZlHz+HBJHqGS6Ey+0CpzY=;
 b=lx6AFw70HykEOtx1M/MX3tuQRopFHsIRs6x7mjnKx54KaApR78DlSoNT7LFDTW3ERjmEL9ks/C2LybSsxCn0oqFFgMpOig5gx18LiWUrfr3e9FvueR3tQbRn+HsEvAzw2h7pBwpoTl/IPvQv97r9R+nvaakiduJzZc81F/RncjmKsYqwrhoUD4PCanPeKV/VQGCCc9wTtkTKKEAGtXDxsDH8+3x12Y42GoFf/nBAyU+P4t7NgMd8wdtB8sYKRfNM8UPZzBv2Z3+K5S3RnyS6ClvPBvBZEm/OvL4etLVjfLJEdhG6fSg72POo7YeZcap+YMDui/Js8OLNjQ53s57wSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3365.namprd12.prod.outlook.com (2603:10b6:a03:a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Tue, 25 Aug
 2020 20:10:54 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707%7]) with mapi id 15.20.3305.031; Tue, 25 Aug 2020
 20:10:54 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Parav Pandit <parav@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH net-next 0/2] devlink fixes for port and reporter field
 access
Thread-Topic: [PATCH net-next 0/2] devlink fixes for port and reporter field
 access
Thread-Index: AQHWd+9m1XOhjZjUyUKQxn4PubUz2KlHwAwAgAGHbyA=
Date:   Tue, 25 Aug 2020 20:10:53 +0000
Message-ID: <BY5PR12MB4322A9BE54C02185FECFAE6FDC570@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200821191221.82522-1-parav@mellanox.com>
 <20200824134846.6125c838@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200824134846.6125c838@kicinski-fedora-PC1C0HJN>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 25c8bc5f-a670-4ce9-06d4-08d84932f894
x-ms-traffictypediagnostic: BYAPR12MB3365:
x-microsoft-antispam-prvs: <BYAPR12MB3365020EBDF0EEE04DA6E507DC570@BYAPR12MB3365.namprd12.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FALCsGpJRApr+gLMr7cAMT93QEVlxJeTQdC8BPFipBI1PmZGkjeEZihV/9Q+ldYPnN8WZCjVNijCteydN9qheAumFmQMvsMyJM2CkenRgT4YnbZ/N1bX5Uv+lJwsxtf/A6j47PmVtjE66FX+Uj7tcpsOTfKxFPz1t/Pxpf1FoFOXTx1J52des4y9xDRQPF2FOjccGyRH9PyYlLbzhpVR/cvcap7m0QlvhOw2ZsZjxoTGVWsPz3KkYJLSXCwmOArzcuhkjPFnQHhb1c2d8DV9zNM5HrOFOlhS9Z6eaLHV7OcMjH69AUOrwsdnfA12bloiN/VT9wEA1E9J5dGSA8+kKg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(346002)(366004)(136003)(376002)(83380400001)(26005)(71200400001)(66946007)(64756008)(66476007)(186003)(55236004)(66556008)(7696005)(6506007)(52536014)(66446008)(5660300002)(76116006)(54906003)(86362001)(316002)(8936002)(33656002)(478600001)(4744005)(8676002)(9686003)(55016002)(2906002)(4326008)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: WvTdp2xy59VsWevcLZaZZxwKs97kZO+aasthy2A0UkqwTJSK/jG7rOOXJ+4msmwqEDxCLGGymcALA8mlXt3rcIoSPRcBtZXJjyTPjJLJabxPDKvoV6dGm7FfGJr2VsJ3mjrCZNRqRZk0rCYwYM84zT3TDEeZCWVdsMSbbBVOCLuC9B6H1SLyJIxBu/fpRFx1WnzIjBzW3IycMm93IkRhVoShRWhTZVF2EyJG5ypKk9w2JSANSKWnqNeHayqlm5zaQ9fz1IE7/IBHibzK0NPhT5o8PL1O2tmSqJJAGg+HEi88Wb5p2XfiTKHes/vmDOmKuL+1gsvjGyFUJ0rqFxqZnX5NvLFia7RGwxwFFl9KVtADHmax56aVGIq9D42L0LLKJh+WRsLeZAtw66f3ZopcZwND2flxwrj6xZBr1ezQz/DzcbhYVY9ZwLGB3It4W7HBZb+RIPTkWF/X6aNf8mHwZe5Ved6PnQGCYga73FsjbUwFs20rUyXJ401AuflBtDW3L6DwlOCw19aBUTBgD73zQT4sjKWNwGLiTKrpmK6Nv/Em1AbznqKOHTvqOgmvoIU+02CSO+GwzOHI4jhbZr7Nw62a+tlWyWO4Z6a+3ZwdsIbPPrK5mv45xqaBMwDAgkJlpTKV24v/mJEnN3wlsBBoOg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25c8bc5f-a670-4ce9-06d4-08d84932f894
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2020 20:10:53.9413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mBq/R+3NkXHpmjqNXRwB/1R86RlEPbPZ2iCXgcu6KYtQ5ejNCsJvNS7Aa6DtHY5lWIRCdgTrZMFkc5E0YOztig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3365
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598386193; bh=YwhPAIK6YRfW7VrFtaCybyZlHz+HBJHqGS6Ey+0CpzY=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-microsoft-antispam-prvs:
         x-ms-exchange-transport-forked:x-ms-oob-tlc-oobclassifiers:
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
        b=Jf4+p6GzZ6wl8t+EkGAsYPC3klzxgoQuHnLwA/8zBiev16ow59+C/TltniB6D3Sn4
         /EoTjysxU/RD3MjMpoLLrdbPLRTA1YuBUvr4+LqK9vXtL+siURxJMgIPESqxn2S97s
         +9X4lWKMSwOiuwG0T1DY0CIkpKedqx8Vcqk6OxQTbnRMHsc9cHOTELz71N/PH49ArE
         C9hiNWwkxzW4w8VpYVuibbfndQGq8q6/iFcx5OKOobbI9l3amFfIPSMUPNqeibM05N
         76yBFP98kY5RBzkWlFU/6/v1YBvnNNPtSSC/VYOxoTc9K6u0sLPOoHJF3nO6GRxQ8m
         Nr7lC6OTw1hOA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org>
> On Behalf Of Jakub Kicinski
>=20
> On Fri, 21 Aug 2020 22:12:19 +0300 Parav Pandit wrote:
> > From: Parav Pandit <parav@nvidia.com>
> >
> > Hi Dave,
> >
> > These series contains two small fixes of devlink.
> >
> > Patch-1 initializes port reporter fields early enough to avoid access
> > before initialized error.
> > Patch-2 protects port list lock during traversal.
>=20
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
>=20
> Why did you tag this for net-next, instead of net?
My bad. I will take care for subsequent fixes to tag for net.
