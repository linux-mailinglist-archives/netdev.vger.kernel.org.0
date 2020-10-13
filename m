Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EA228D037
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 16:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388658AbgJMO3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 10:29:38 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:60324 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388627AbgJMO3e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 10:29:34 -0400
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f85b9cc0000>; Tue, 13 Oct 2020 22:29:32 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 13 Oct
 2020 14:29:32 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 13 Oct 2020 14:29:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WW4ed3LCt91dNuTHCguIzxJPqpvnPa3n+1yPqj8yv5ZlKTcpuu4UnsHaBKRmtgfHR86onPwhz6WEvtDjgTQn0pTk0N8WkhzHsnSCu0bGT2eDSdo1X2v+rDc92bzrwaTGErKOacC6vo1X/85DGfQkXHw++mto20R3R/AvQLI1oXfdo21z6AeIMsQN9uXjuCYIB78tWmsU7udyvhFdpepHNTvv4KesfcLVHYRF11XVAfFcoENgqsMz2+uPFATDS58IvjWiuSqHvFo9FaN4R7zdt4aGs92pyLQrEOFg71cevVPGbTdTxjPWqubApvQNoqL6sR3wqanNQ3X3dIwAQ/9RBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dn3lh9mOzlgOLz+7JlovcriTxx16blm335lrPJeY0Y8=;
 b=duOTCZ2xhJUnFh5XdKDVQ0GWkEx70EjxYjhZOug0HtWSbucp5pw8uf8mhApZ+jgKY71XRas0lYsgFUNSYpZx3ivz88yE7Q1rZwxI1IV+nnwZgeq+St0SsAqsGEjYdzCAizk+txNH9neES6H/e8gXxljz46BdrCuUiEMDgdqEsxri5znjWxMhuDee7ZsUATUSX3l7sjU0EkZbrNjzUya/AI7uIbbyY05mJC+q9Rkkb1C3WW95PZkqY6IwlQP5PVfhWDOi40yXuRVtnyd7ov1KPsTxlGk6rBUqpxOF/LYWzekr1PvcRClIS2Epp2bwxJCerQGeTHhnIyf94jY0J8c8KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (2603:10b6:5:1c4::14)
 by DM6PR12MB4941.namprd12.prod.outlook.com (2603:10b6:5:1b8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Tue, 13 Oct
 2020 14:29:30 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::7538:53df:80a:24e8]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::7538:53df:80a:24e8%2]) with mapi id 15.20.3455.030; Tue, 13 Oct 2020
 14:29:30 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Jiri Pirko" <jiri@nvidia.com>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>, mlxsw <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: RE: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Thread-Topic: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Thread-Index: AQHWnxvjfEscixWoTUGw9NLDRcgaq6mTAB+AgAEV0YCAAAzGgIABa6aQ
Date:   Tue, 13 Oct 2020 14:29:29 +0000
Message-ID: <DM6PR12MB3865E4CB3854ECF70F5864D7D8040@DM6PR12MB3865.namprd12.prod.outlook.com>
References: <20201010154119.3537085-1-idosch@idosch.org>
        <20201010154119.3537085-2-idosch@idosch.org>
        <20201011153759.1bcb6738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DM6PR12MB3865B2FBA17BABBC747190D8D8070@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201012085803.61e256e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201012085803.61e256e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce985218-e94b-426e-0a46-08d86f846580
x-ms-traffictypediagnostic: DM6PR12MB4941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB49411101130989B407B1EEE5D8040@DM6PR12MB4941.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qWoEB4O70ticbnyXo60vsWZ4l6C5/Ebw36PUqmqLvISAXyjWMVEk16AsUPF8zmJbvZXBDQEpJ9sDbwF4g6s9rKAlWCPmuw230V9f+YjAPq8UrGxMe3Z2bQ9boO/oY1f49+YkmxJD3uf+1lsosYmJ1Br/2rURrLMkkFuOJTawBbcc8cs8TWot8MewsiH6FmPKcMCCEulTjCx+IwkQzK2lGitiUm/wX64mN+yuZKdvaT+/s35/2qmdmee3y5OCrUgcM0PUgoJs4teqekXAQ1SA+4k8AP9HI419OgJEzQlT3G+2ItkjJqnrxjCrfEUUHiBKnnN6axi9gO+Nz4zPVabxNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3865.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(39860400002)(346002)(376002)(9686003)(316002)(54906003)(478600001)(33656002)(4326008)(83380400001)(71200400001)(53546011)(64756008)(66446008)(76116006)(26005)(52536014)(86362001)(66946007)(8936002)(6506007)(8676002)(66476007)(66556008)(55016002)(7696005)(186003)(5660300002)(2906002)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: wEWF3PFN4AC8lVE1r5idpPBzyImv54f1nZyPdoOv62useNEHAc13DsOXTMSPkwW1AIUSkiJQNPXK2gekhIU87qC9bxg1KSQ6C8sG4OvB6rXGiZgSbFA5KzFFKLd3qGZSqTSNKQbV45IkA0bcjCIh5e640fyDLpfv2DDFkQJ6LnmCeSDHrjIIDU7vtHOiMo+FtgrWjZWPNnj+NT2VKlVUZpGOtTXhxJFjaHdwXODun8ppWH4+4/iDLzyLknHn4JJyQ9Ie1lOnaGzfmZDXnWP/8EMR2eNLpuZ/r5u6ZfAHZrSuRVb3LGnuj7UzO7fuAU1UB6rX2uMRlht+0dAa1XYGa3EQSzaNpp54o6itCkFidD8s8nA5XTcwg78ZGSTFbwcM3JVluGIHgooKqaO0fvDUojRPKR7uxDlIgDr0qYMQEWrxNv3QP8sRf6IdDcx7PGCDaFrSHv424aV663EfsJ6GzwM3sjic7XJ5QqyVHJ+DwdFQgyIIlvXoZyjuameBJSZri4gesjyuTt/fIfTRkUcXvhhRmivqdfCv/RKQfCX9ioej18FNKm4aSb2CeBf+Vno0IIbHP9pTp4XnqvK6oRwZ4uq6WCgacpl3HDXB4gpXu/sYMvdSFAh//oNd4KiTJsOTj5SnZgdktP1pBW61YEzMMw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3865.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce985218-e94b-426e-0a46-08d86f846580
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2020 14:29:30.0892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gWRTBI/4bd34iV8Nvs3zsbEVNomzGMmJt5Ec6GGR62fWePMG6tx0KM4gheiKQAYXe4HdBgSs9YrugBkP9xhqww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4941
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602599372; bh=dn3lh9mOzlgOLz+7JlovcriTxx16blm335lrPJeY0Y8=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
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
        b=c4ftPwioRgHvJh1J9wlCAXG6PNqEf4ZApSZQN/i5U59MQ11ynCgNT3RIEHDfaG0LO
         CvU7uScYxfnDY1wNSrkNo1KhEC0xiJWofZ9qGZ+pKHvqy1MN8WSr0x5gSL8hKn3/jF
         3t0mvupH7C/vWtbGauCvNgExeX7/WA/iO/xvt4FIDBwav66W0HsTJG5tAkJOdjrQUM
         P5dd+mdW+h70VGoUx/HVml+TPqcMD5Na41GsPysuRlvVP/F7I5gpj3mztmGj5WyVrc
         Cri+Ogi4Jn5P6WGvZA/07X3awDcATUI631uKCSOyGOpmxMDH29lAZX3YuFVEfaQHwy
         763wLfZpHOPlA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, October 12, 2020 6:58 PM
> To: Danielle Ratson <danieller@nvidia.com>
> Cc: Ido Schimmel <idosch@idosch.org>; netdev@vger.kernel.org;
> davem@davemloft.net; Jiri Pirko <jiri@nvidia.com>; andrew@lunn.ch;
> f.fainelli@gmail.com; mkubecek@suse.cz; mlxsw <mlxsw@nvidia.com>; Ido
> Schimmel <idosch@nvidia.com>; johannes@sipsolutions.net
> Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAP=
I
> with lanes
>=20
> On Mon, 12 Oct 2020 15:33:45 +0000 Danielle Ratson wrote:
> > > What's the use for this in practical terms? Isn't the lane count
> > > basically implied by the module that gets plugged in?
> >
> > The use is to enable the user to decide how to achieve a certain speed.
> > For example, if he wants to get 100G and the port has 4 lanes, the
> > speed can be achieved it using both 2 lanes of 50G and 4 lanes of 25G,
> > as a port with 4 lanes width can work in 2 lanes mode with double
> > speed each. So, by specifying "lanes 2" he will achieve 100G using 2
> > lanes of 50G.
>=20
> Can you give a concrete example of serdes capabilities of the port, what =
SFP
> gets plugged in and what configuration user wants to select?

Example:
- swp1 is a 200G port with 4 lanes.
- QSFP28 is plugged in.
- The user wants to select configuration of 100G speed using 2 lanes, 50G e=
ach.

$ ethtool swp1
Settings for swp1:
        Supported ports: [ FIBRE         Backplane ]
        Supported link modes:   1000baseT/Full
                                10000baseT/Full
                                1000baseKX/Full
                                10000baseKR/Full
                                10000baseR_FEC
                                40000baseKR4/Full
                                40000baseCR4/Full
                                40000baseSR4/Full
                                40000baseLR4/Full
                                25000baseCR/Full
                                25000baseKR/Full
                                25000baseSR/Full
                                50000baseCR2/Full
                                50000baseKR2/Full
                                100000baseKR4/Full
                                100000baseSR4/Full
                                100000baseCR4/Full
                                100000baseLR4_ER4/Full
                                50000baseSR2/Full
                                10000baseCR/Full
                                10000baseSR/Full
                                10000baseLR/Full
                                10000baseER/Full
                                50000baseKR/Full
                                50000baseSR/Full
                                50000baseCR/Full
                                50000baseLR_ER_FR/Full
                                50000baseDR/Full
                                100000baseKR2/Full
                                100000baseSR2/Full
                                100000baseCR2/Full
                                100000baseLR2_ER2_FR2/Full
                                100000baseDR2/Full
                                200000baseKR4/Full
                                200000baseSR4/Full
                                200000baseLR4_ER4_FR4/Full
                                200000baseDR4/Full
                                200000baseCR4/Full
        Advertised link modes:  1000baseT/Full
                                10000baseT/Full
                                1000baseKX/Full
                                10000baseKR/Full
                                10000baseR_FEC
                                40000baseKR4/Full
                                40000baseCR4/Full
                                40000baseSR4/Full
                                40000baseLR4/Full
                                25000baseCR/Full
                                25000baseKR/Full
                                25000baseSR/Full
                                50000baseCR2/Full
                                50000baseKR2/Full
                                100000baseKR4/Full
                                100000baseSR4/Full
                                100000baseCR4/Full
                                100000baseLR4_ER4/Full
                                50000baseSR2/Full
                                10000baseCR/Full
                                10000baseSR/Full
                                10000baseLR/Full
                                10000baseER/Full
                                50000baseKR/Full
                                50000baseSR/Full
                                50000baseCR/Full
                                50000baseLR_ER_FR/Full
                                50000baseDR/Full
                                100000baseKR2/Full
                                100000baseSR2/Full
                                100000baseCR2/Full
                                100000baseLR2_ER2_FR2/Full
                                100000baseDR2/Full
                                200000baseKR4/Full
                                200000baseSR4/Full
                                200000baseLR4_ER4_FR4/Full
                                200000baseDR4/Full
                                200000baseCR4/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: Unknown!
        Lanes: Unknown!
        Duplex: Unknown! (255)
        Auto-negotiation: on
        Port: Direct Attach Copper
        PHYAD: 0
        Transceiver: internal
        Link detected: no

$ ethtool -s swp1 speed 100000 lanes 2
$ ethtool swp1
Settings for swp1:
        Supported ports: [ FIBRE         Backplane ]
        Supported link modes:   1000baseT/Full
                                10000baseT/Full
                                1000baseKX/Full
                                10000baseKR/Full
                                10000baseR_FEC
                                40000baseKR4/Full
                                40000baseCR4/Full
                                40000baseSR4/Full
                                40000baseLR4/Full
                                25000baseCR/Full
                                25000baseKR/Full
                                25000baseSR/Full
                                50000baseCR2/Full
                                50000baseKR2/Full
                                100000baseKR4/Full
                                100000baseSR4/Full
                                100000baseCR4/Full
                                100000baseLR4_ER4/Full
                                50000baseSR2/Full
                                10000baseCR/Full
                                10000baseSR/Full
                                10000baseLR/Full
                                10000baseER/Full
                                50000baseKR/Full
                                50000baseSR/Full
                                50000baseCR/Full
                                50000baseLR_ER_FR/Full
                                50000baseDR/Full
                                100000baseKR2/Full
                                100000baseSR2/Full
                                100000baseCR2/Full
                                100000baseLR2_ER2_FR2/Full
                                100000baseDR2/Full
                                200000baseKR4/Full
                                200000baseSR4/Full
                                200000baseLR4_ER4_FR4/Full
                                200000baseDR4/Full
                                200000baseCR4/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  100000baseKR2/Full
                                100000baseSR2/Full
                                100000baseCR2/Full
                                100000baseLR2_ER2_FR2/Full
                                100000baseDR2/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
