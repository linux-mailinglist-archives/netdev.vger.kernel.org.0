Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94F32F685B
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbhANRxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:53:52 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3175 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbhANRxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 12:53:51 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600085060004>; Thu, 14 Jan 2021 09:53:10 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 14 Jan
 2021 17:53:10 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 14 Jan 2021 17:53:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cp0I9eiTvHN58da6MrRkLxv6AIufH0zzuX6Vt5romGf5JsS2EUU3IMR0KVEVHjeLbpPbsGNn0Imf+KuEZeWwFltnKMjL40sWJ+TtPKUf7G7yyP4q0VOzP/n4dloM9Fu8x9UQycvTEP5M2gRNV0Va5Dz/8LlbfOw8lafCKiJU8uVdigX4zNZ4J/TKiCDyTaGJDG7el+ooFP5Om0X7TiO8b/Q9L+9b34UFO0y5yV+8lqxfUgPEHrOrj+DbeUALXTixjd+QPKFXZPc6GRJ2mi3qnXvVWje5Ki+aFOiy0PK/QFkEztDWgFT0hag+RRcivElNUH+7JE9bTJZOiCwVF1/K5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wywFTeMW4EsK4TLU4qaH3j0gT1mnwrRBG5fsHoZDuMs=;
 b=Gejzj0lONScbWEA5Sc1O6x3na8oU+SstUzXpfrX/98WHQ6lnqZOXLQOKSQcLfaDbWOsg+w0Hws2kupcGeR1SyYeMPH7J1JNxp1kgq5H3qLvgV0l6raQ8tEN9hXn/mKpmmB+JarceHTCksegDRxIiWtmi9Nz/5MZJOmi55yBI/aG23T0wvj8j+jCcDV3iSqd3g34qpB8kZIvqm/DKRAhClQ+Y076BR1r+ICn4sNqvjONhFWHFr4CHlc+NZxCPoEwC2TbQKSkKX1Tg90e2B21Gruu2S3lBevU9BxSx90iSE0hVNFwjQ/AGD4cXZTh6dpvpBSYXxt3xzU+oKe5xp52F6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2872.namprd12.prod.outlook.com (2603:10b6:a03:12e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Thu, 14 Jan
 2021 17:53:09 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%5]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 17:53:09 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [net-next V6 02/14] devlink: Introduce PCI SF port flavour and
 port attribute
Thread-Topic: [net-next V6 02/14] devlink: Introduce PCI SF port flavour and
 port attribute
Thread-Index: AQHW6eIwbq3q2BZokkO623Y7jeJLvqonZX4AgAACO8A=
Date:   Thu, 14 Jan 2021 17:53:09 +0000
Message-ID: <BY5PR12MB43220F26F558A6CFCE013876DCA80@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210113192730.280656-1-saeed@kernel.org>
        <20210113192730.280656-3-saeed@kernel.org>
 <20210114094230.67e8bef9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114094230.67e8bef9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.167.131.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ca84781-1253-4f3a-68f4-08d8b8b5412d
x-ms-traffictypediagnostic: BYAPR12MB2872:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB28720A01ED54B4668B809642DCA80@BYAPR12MB2872.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L/sceUBRift3cNP/9XAEjdU51CJihLhpMkQJLWJ4BWly6PXDzRIGswG23JoDyHbr4WDOHmrUEdowkabZi+yype5ZOMhmmAlz6Un2sPETBRPXK7P5rM/MsCH53p0ANzAMhVUz+6urJIJoh2eT5YMoRg57H/CfCFDkB3In6xwXCSSvwNV5Mgdn2bMDI7prqOir2JnfyqpzcC78SjvybEgyi2ann7mofnQFPUCHG20fZJc+jHQAMzbsPVYJkxbZCxW2iMC1GqHHaAnv3Pv2rVRC5lQmu1LCTtGVJps/60vNaIHKgSwoD3zH19a0ceVwIXGLVpLoj22FOyXZVTOlF0jHQ8SnwBvDHiJVXfAAqihUmPpWOex95v2cR3lBx5nj+P51+DtfIa7hG7hJ4747PZOddg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(366004)(39860400002)(376002)(54906003)(9686003)(110136005)(66476007)(2906002)(55016002)(66946007)(5660300002)(52536014)(76116006)(7696005)(64756008)(8676002)(83380400001)(186003)(478600001)(86362001)(6506007)(26005)(4326008)(66446008)(316002)(107886003)(71200400001)(4744005)(33656002)(8936002)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?O3uFvgWg5NHyK18JZ7GSXdH2zpj49Tb+pzrP2e3+Ka8Du2IW4dI5JP+HiMsd?=
 =?us-ascii?Q?ROZf0xhbl1MNbP7/dHjvUQ/o0RtvaQ/aIuAuBElLmf72h8msX8+M3vo0js4l?=
 =?us-ascii?Q?9HZreefKczK9KH/IwBuJu51acl7LVTXMN/2gZ3NOZHMm61+1r2Bzp9+WOy5Z?=
 =?us-ascii?Q?oz1VhqzWY9p2iZcr7GLuiJuASkyGfwHzVEW1cF3K9FaU1dWLlMV/3vmzocTB?=
 =?us-ascii?Q?GOM4hzOgo/E01HCy9XRzz8oPhzi4oi8QE1gCNAgdCF4Ht5vpjC57IL0m2DoG?=
 =?us-ascii?Q?DYBMhXgaI84FTmm0txlM2kgVaGWwb4RIwpJZCBEhjsoNJoIOrgUnQpPnTiZu?=
 =?us-ascii?Q?0eQZrluRWIaimjqz/npO1BPgoivLhGjryGmggsDAeylovaYJTu2+5bGaJdOJ?=
 =?us-ascii?Q?vhBGiQLuSn64Gmjd0wg2j2LIz9aFRc2bzk8ZoutWEQY7tRlra6h9pQ33tNcy?=
 =?us-ascii?Q?cNGrgNTSp/w0geoizg5T/F9xRQOJFWabjKBXGr/8T0H9caCCe7NIAuUi3hlS?=
 =?us-ascii?Q?mR7kieJ+n95SlMEYKODhVc10fHTzEjUpVsOLZbv/HsxPt0mS6wl8zzfUhctD?=
 =?us-ascii?Q?5WCrP+DPI2Exd3IfVpuc4cRaQ/fhPP79DfSuM9EXMJq4SoHQJes9Gxwqsx4k?=
 =?us-ascii?Q?3mQeKtJTdqYxJ1U47vynYpai6GVkDP9rhHO0ZukmV5ZEs6R5UaAnuoryva7V?=
 =?us-ascii?Q?38EQZ3OS/8cSmQJFwldpVTea8kmkWhVhuoC7yvKxJsGklsOv1ms6Xm6yTluB?=
 =?us-ascii?Q?yjM0/6UEr79+RGDJ3m3x6PIqZVyxK1YN3aj+RrqWA8pTIP5x/YKdh016Cyk3?=
 =?us-ascii?Q?YC8f/lQT+Y7LKbfhhyPfac797b8dJMuI/imIYbjfwZ1ksnlG1F7JmH0Pn7h3?=
 =?us-ascii?Q?+X+G2f5xN6DEqkkhkxZz/cq8eL4bk+9zJYbPfgR/z3KmNOSgIZjnzQM+q77E?=
 =?us-ascii?Q?Zb+Nz9HVA1lzX4bGlbN/o2dhYjFDJbTsk20Qos7YAzE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ca84781-1253-4f3a-68f4-08d8b8b5412d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2021 17:53:09.4603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zIGLRPJZpMkbNYCarBDsQH/hYndulElpJMNTTIppQeTDeGwW6j10Tkkw6PJbscL4ErZE7gw2vbAPnBls+IsUtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2872
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610646790; bh=wywFTeMW4EsK4TLU4qaH3j0gT1mnwrRBG5fsHoZDuMs=;
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
        b=ULbYmw5MuVhHz8UQHGwG4Rew2DJeptgqEdvcHh++h2PNkQUbMIUk4dHtGKcN9l/0s
         /2zzkNzS0lH1lUVOhTffZ5vqGo80WBq4YVZ0UBroHfXQ7hrzc3DpcUTYz6pl83QMTN
         jM8JBUf+Y71XitcbeFgCtNG31Q50QbntsCQPnxCzxu5LuKod8LyJp6mhHgMkm9evvA
         6bB0M3xpyf0lZCuArwvyoV8DjZ9OBunOlb95if7i/+9SQhyobHdc7HxD+qmBsf3j93
         KARdrQHJnp6CSuMkEhmWxTDia6zW50xKGWhWxH020ZtnEvR22ekc/sMQpBIECqrVZg
         KAMceJc/3KnQw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, January 14, 2021 11:13 PM
>=20
> On Wed, 13 Jan 2021 11:27:18 -0800 Saeed Mahameed wrote:
> >  /**
> >   * struct devlink_port_attrs - devlink port object
> >   * @flavour: flavour of the port
> > @@ -114,6 +126,7 @@ struct devlink_port_attrs {
> >  		struct devlink_port_phys_attrs phys;
> >  		struct devlink_port_pci_pf_attrs pci_pf;
> >  		struct devlink_port_pci_vf_attrs pci_vf;
> > +		struct devlink_port_pci_sf_attrs pci_sf;
> >  	};
> >  };
>=20
> include/net/devlink.h:131: warning: Function parameter or member 'pci_sf'
> not described in 'devlink_port_attrs'
Wasn't reported till v5.
Can you please share, which script catches this? So that I can run next tim=
e early.
