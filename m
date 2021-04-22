Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E290368380
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 17:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbhDVPjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 11:39:01 -0400
Received: from mail-eopbgr760075.outbound.protection.outlook.com ([40.107.76.75]:37601
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230005AbhDVPi4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 11:38:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U5eHasnc23FtLf6l8mWlugadimW1oRDG4dIIR4cCYYAcnUoh6IfBkydRrwk0efhhfT6aXeCBLkkJTAuVBT8joFZIBaUvg1HCC6jof8Z2ThExJpYVq1wuJjLDtHsNV5QgmRglbxD8cL+BtAlZkRI9FzLtGWNp7zPIbiIZ+IzQGR0XD6vaio5CYuQs0AF6YvSPwfUHrpjpBrFl99VRW0hiVVk17QEpXBGJ+DDLY+BAV4J3SNgPeog0kKQoDguOffdr9ZrJMc+DVmWCk3TJeAt2soUbRottGdBKG7iN4wTMrUuNd3f5Oysp0mG8m7aoXtF146IjxufBVC+lqBH9V822RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V1Scsn3mKoCRaj4NLKgmism7tozEDbOy85ZmonZoaW4=;
 b=OyZzpn9X6MritSP057atE4iWjn9zJKhoqKThufyX/fLZAj+8NpVW4vqe2dbL021G3xcPiApfm2O72YaZji3GVjrHMB8xiMurYw1EDUvhqEfdNLniYc5mEJYryhA22LR2xzS1+OCYHNcuiC42WQ8rEXnpFNoXNsYcL5yXYCBPSzq+1N6cVqa2oLSf9IVn8rzyxAP2oYlVjiZnFv1EvUtpj/hiUm1dOkPW2YGBiXt9Zyi+ylZCKDfkS15+GFe815Ra6ptIQOM4Zz0gWsrYVIEjpNtBKbbznAHgzjCCZRGa0haYMuaSdnXzRGvM0qW43+902ouUE43Y6hzKjjQjkwbS2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V1Scsn3mKoCRaj4NLKgmism7tozEDbOy85ZmonZoaW4=;
 b=HQVxON7Pk0730EJavvxqVBYbUve087R/a2QwzMW4L3Y7C8AWQIw9pZXt7F8vt5vkz1BVgw3Gzos0ri37d114tYW6wsPCPDw54IsEF/3JFpQZFpoBo/UytzMjQAJm9lvCKZ8jVyDPDDutOgVtcmmYR9NFx3eMeskl2k9IN3AWMaMn1TUrENcvC5716IC6G6w9DXWSU6Ip2AfWBFPAiTYT3XwT2o5O7cTQaftHndqak0+2agywrABeP1UVDbLzevcU6mCbZYYWFXmIeHtEuWkYaolX9awooLMD+afe0zslh2sTZEemxGY+U4JJT3t06Q2O3DQ4HjHQPcL16wkP6CYsWA==
Received: from DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20)
 by DM6PR12MB2619.namprd12.prod.outlook.com (2603:10b6:5:45::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 22 Apr
 2021 15:38:19 +0000
Received: from DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::8423:fe54:e2ea:7775]) by DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::8423:fe54:e2ea:7775%6]) with mapi id 15.20.4065.023; Thu, 22 Apr 2021
 15:38:18 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "alobakin@pm.me" <alobakin@pm.me>,
        Meir Lichtinger <meirl@nvidia.com>,
        "dmurphy@ti.com" <dmurphy@ti.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "irusskikh@marvell.com" <irusskikh@marvell.com>,
        "alexanderduyck@fb.com" <alexanderduyck@fb.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "ecree@solarflare.com" <ecree@solarflare.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        mlxsw <mlxsw@nvidia.com>
Subject: RE: [PATCH net-next] ethtool: Move __ethtool_get_link_ksettings() to
 common file
Thread-Topic: [PATCH net-next] ethtool: Move __ethtool_get_link_ksettings() to
 common file
Thread-Index: AQHXLGYhK09PAvsPd0ejFpN7OgkHKaqqo0wAgBYevxA=
Date:   Thu, 22 Apr 2021 15:38:18 +0000
Message-ID: <DM6PR12MB451615D959313E7675C3AEF8D8469@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20210408105813.2555878-1-danieller@nvidia.com>
 <YG8KAOtjkpNuEPkN@lunn.ch>
In-Reply-To: <YG8KAOtjkpNuEPkN@lunn.ch>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [89.139.122.244]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb31b369-a8cd-4209-fec9-08d905a4a756
x-ms-traffictypediagnostic: DM6PR12MB2619:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB2619E8F659D1D36971B2BC17D8469@DM6PR12MB2619.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AarlL1hj5tlFHlz/j79rvkhRsM1jP+x2rT0l8Ir9fQB1xN1S3DiVqPG7CDNRdSxkXTyO1b5t4nH3LrbBGujWWHQL2sXLg0duai+OBM0dch7gYxVfMHLWVc/xqdl8eJmbfvR1iVObf6jrCCReF7YuKc1qRbsI9/Pm0nx2ZehHhj4ZZcrVHsgqk33Dcxa6HILI6i5WDnhsleEUV15rD/bfO222L916k8afnj3ND2BE8iQnrsEdFOcKwibLC6w5jBNM6NYdaM0gxinnIzW4w6AtE0iQwC7BHL+EKfmZxYGXD6LuHSF/nrl+VltUc3QdUkRPYwA4cRWNVHLJbav6pycDlg+iVwUE31AFSwWjTZFGXwSoCVQkrud4lWEpuVWm8cX5xI2YVyQuWvYnZbg1VIDXfNpbD7q/ftWv9ROpJQcpcyiCgkf30Q3Yn+cMR788wIiM/uHvNgpSCc4zKd84RYao/00yr0FvSdXbT4x419GFjlzbbjstqWwONkykf+cj2XxqDgR0SM6fIBIw+UCbPc/ott12ManqmiJwMrDgYwGId+uGlOuNT473WG5L72UHJtcOwcgRPKxP8ECRur59RdiddZIiw9BQ3oTB58MtEmMGGec=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4516.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(7416002)(8936002)(83380400001)(38100700002)(66556008)(122000001)(66446008)(498600001)(66476007)(64756008)(186003)(26005)(6916009)(71200400001)(7696005)(76116006)(2906002)(52536014)(66946007)(54906003)(55016002)(4326008)(5660300002)(53546011)(6506007)(33656002)(9686003)(107886003)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: t0+4dtfWr2/XtS+LvZXzFat5EmCKTY0PUKjHS0P/3Xh/o8LDJU27Hdq5IJu5F4P2jzBiTcFLgIaY3nZi/WuLfnwWAbL9FCJF3Nwj9pMc9eHkTs0iSHOdAoad/wggyjMdq0rHLjxz/kMCkQ0/u4LHFLsGhPBfJd98Np0QahOaOGNxAKufAhLEC9oWp4CcQMmu94O4XxXiZEw2FbKWP4pYuscsgO8RJEaLHeKoZx0zW5NhlwTEq06mq0rU2OwOc5eboeY4skbF5nxZh7+wm4hk8kuMMzwtwhKXpV96gfw5dEL6WmqX1ehRdo91EYIKyOjCUaRlAKmEl2oKNZIMVZfiXRokg34BefWNG+VmrwXgBWp78bVzSzdUa8Q3EbakpZmcDGaEeHSKdLeUTM6Bu8aYqqu2trtmHT37AhYyK0/yhwLUh26H/BJDeAb62e32kLr3iJ2INtrleqcI9Ac5jsfzNQM+HrNuivwEskcP1b25Zxp3METlvrCvvUXoYJs9j4piQcR7Av6Eu7fBIt3LDEsba3qXAUsyuyuwAsps0khj4kHhWOngoNLSGggvrRaPXtYqPWlykHmjp9mrq60EV97W2PFb6JgtEdTmfjn5hP8NwRoxwVul13iLF2ClLevMV2AzIOMFt6Yl6pAozyvWRLec5hkjdqJ+mS+sa04+7y1RR+enE/eXuGPkbtXSR0hCZdLBiQ9FrnJCSQy64kzvf7SxRG7A62C8pcfe1gVVUdDoP2g=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4516.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb31b369-a8cd-4209-fec9-08d905a4a756
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 15:38:18.9429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YRB4LOGnF+lpYCcx8Eh5VqWOOzK1pypNLPhDKOsMMNpviXBhjjinkBcBMjxBRA8SQ3T7+FZl4yE5muiBKysDiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2619
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Thursday, April 8, 2021 4:50 PM
> To: Danielle Ratson <danieller@nvidia.com>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org; alobaki=
n@pm.me; Meir Lichtinger <meirl@nvidia.com>;
> dmurphy@ti.com; mkubecek@suse.cz; f.fainelli@gmail.com; irusskikh@marvell=
.com; alexanderduyck@fb.com;
> magnus.karlsson@intel.com; ecree@solarflare.com; Ido Schimmel <idosch@nvi=
dia.com>; Jiri Pirko <jiri@nvidia.com>; mlxsw
> <mlxsw@nvidia.com>
> Subject: Re: [PATCH net-next] ethtool: Move __ethtool_get_link_ksettings(=
) to common file
>=20
> On Thu, Apr 08, 2021 at 01:58:13PM +0300, Danielle Ratson wrote:
> > __ethtool_get_link_ksettings() function is shared by both ioctl and
> > netlink ethtool interfaces.
> >
> > Move it to net/ethtool/common.c file, which is the suitable place for
> > a shared code.
> >
> > Signed-off-by: Danielle Ratson <danieller@nvidia.com>
> > Suggested-by: Jakub Kicinski <kuba@kernel.org>
> > Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> > Reviewed-by: Jiri Pirko <jiri@nvidia.com>
>=20
> Seems sensible.
>=20
> Did you look to see what else is shared and should move? Rather than doin=
g it one function at a time, can we do it all at once?
>=20
>     Andrew

This is the only one I found that needs to be moved, thanks.
