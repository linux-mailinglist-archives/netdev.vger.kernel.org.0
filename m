Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188FD1F162B
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 12:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729309AbgFHKCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 06:02:10 -0400
Received: from mail-eopbgr10057.outbound.protection.outlook.com ([40.107.1.57]:30017
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728745AbgFHKCI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 06:02:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U+mOKY7RHRQh+EwKjGn5xSqrZiMV9iLLWrtCnL5ACtiPhJGBjCG4uzmcv9cB0ZU18iA8CP7UZvHzfWKcpqP4Yukeqi7BCAvzI5//NZUQXS87J7PzJLpi8lXRSfg8tYghgfMxQckjAtIIBHN6w69Y8UDwO9N93MK1minsmaHmuD2/+Qp/EJEL1RtGYGtKMH5CzgnGVG2EOctskrziYLa9pOiNPVJOl11/zJ9v3yZJi1Ez0ReIaenNIwlcJH4QhFcuga8kfHww+j7A8VbrwxFMIJyByE2QZqcaZNfEhLAP5QERwj1b/CJ9L9PstOiQPhs8nJJHbtfAtXu4HeVLorNSHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hkd6vnUsumNq6K3u99+dkrfgPl8jgC2cd6DAh75q0hk=;
 b=BZnDCRZHgQYJIkwGZwQ7GF9joemCaOONtfridoPguJ+LQPgz34YhZVitE2ckvZXPPhJgdIQwRSwHvrQx0IP6xrzc/iTuIfNjWFuXhjWjdlkdsES067ihjTIvSRjn367a5SnyAwdGsItyaESCXyj1mIUYXDveKDU5MYLQxg69Sot+XOgUrmxjHykRvxTacEaslEB80xbLNCr3Uu++JJetmv5lBX+UxXuecm3Nk40buB2/AGw5eH+LlzKASkscH+aQVlaWDdjap7rENG7CeVas8ylZbaesqwbH+7NaYCN2vL7bjhoaQB+mCLoaXNJEyOq+lEHAbplmaQx+XmfFyayaTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hkd6vnUsumNq6K3u99+dkrfgPl8jgC2cd6DAh75q0hk=;
 b=XRpiM6wxySJ8f5vqlgYCiriW5SpibEENf+lHYc8IlM539oZEj97KwPsPxVqwlLCUQV0WpaXzMUmZpUUgsDLBU1yRm7sP1xYeb0+YEdbCZKpKWSf1w1FfANOz3a0s9roxKgZsY7+yC8OhBBgs0Fuyf7vbkMw/e9DYjfL1hh/PoyY=
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25) by AM0PR0502MB4001.eurprd05.prod.outlook.com
 (2603:10a6:208:9::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.22; Mon, 8 Jun
 2020 10:02:04 +0000
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b]) by AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b%7]) with mapi id 15.20.3066.023; Mon, 8 Jun 2020
 10:02:04 +0000
From:   Amit Cohen <amitc@mellanox.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "gustavo@embeddedor.com" <gustavo@embeddedor.com>,
        "cforno12@linux.vnet.ibm.com" <cforno12@linux.vnet.ibm.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux@rempel-privat.de" <linux@rempel-privat.de>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        Aya Levin <ayal@mellanox.com>,
        Petr Machata <petrm@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        "liuhangbin@gmail.com" <liuhangbin@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: RE: [RFC PATCH net-next 05/10] Documentation: networking:
 ethtool-netlink: Add link extended state
Thread-Topic: [RFC PATCH net-next 05/10] Documentation: networking:
 ethtool-netlink: Add link extended state
Thread-Index: AQHWPNxbhhHrLhnGg0iUndeLWzHeZKjNXRSAgAEfm4A=
Date:   Mon, 8 Jun 2020 10:02:04 +0000
Message-ID: <AM0PR0502MB382638933BF9B7BE0AB34E81D7850@AM0PR0502MB3826.eurprd05.prod.outlook.com>
References: <20200607145945.30559-1-amitc@mellanox.com>
 <20200607145945.30559-6-amitc@mellanox.com>
 <20200607164759.GG1022955@lunn.ch>
In-Reply-To: <20200607164759.GG1022955@lunn.ch>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [87.68.150.248]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 131d0a3b-fe8f-449c-d0a7-08d80b92ff3d
x-ms-traffictypediagnostic: AM0PR0502MB4001:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR0502MB4001E7675DC972CCB8FD1C72D7850@AM0PR0502MB4001.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 042857DBB5
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2Qp72XsMGwwy5zdWb+O4tkeendhLDhARFBG7CE/oUzM2iQyPWwffJQiVjUE4FAqb73jkR1LbpTpfTug7IY+Sys4H3NRYgAKIKkB6enD37pNtMoGF/GJ67nsirYkH7LQhoVRcgxlwDGfk63zdKkOi+2VIv8BHewSx23xs3vdtq/jrZm1GZp5RCIQN+dGGKdmRhccEoPzg/q5OZyFHGdJIPJRcFQ/A8FVxiKhggBm6gTpRTY7jdSy24ocUXgX+K/4y7KIQhSjlqppp1Xj+TV++41axU2cAz3Z5yrKY9qqOoMvBAG4bx01eEHYdPEnL7txVfTPMG00yAOXT3NVgLf1tFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3826.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(8676002)(7696005)(26005)(83380400001)(7416002)(6506007)(9686003)(2906002)(33656002)(66556008)(54906003)(66446008)(64756008)(66476007)(186003)(55016002)(6916009)(76116006)(4326008)(5660300002)(4744005)(86362001)(478600001)(52536014)(71200400001)(8936002)(66946007)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: AWJmb1RItwBpYY1O6OLJ0eFw11wLeVYjzoNAjby7WvcyWl5XaL8PBTbYGpFLVRRkTLdFV46YA/zPlnkOBu6hCf316CsYtLAckFQkFHVBx72xiOfT56jF2jcduQ8Mep+hYf59J0qwzU6P0OZyaT3NPbO5T935zQs5Hy8tTdZAaPcNddwRqV15d+5NhX40yg+BU73NTitC93dgP3CmOtnGI+EjdtDgxRBjRHmK9lOU7VG9cdCb8eeKt5iRmbZS4+o3hNqgDdsCjfF+uMNe8eoS/d7Rd5m6QfN8HAky0Gh6YGKDmpTWS1uVrGL//kluRFdjsBsX1u5X59rKXd6BiX7EYTnTo9m+W3Bd5yLo09rw1Si3V1pIIQC+uAjWizj0aFA3gwPVjFyMhXJY/TBlEoAdGk9Fg8u+Se9C+Kn3XCBQd9BgLmRHOov80fgD1dWjK4gjDmsxpE3k0m+0NSLWtl5S+GiEySVLP4vRZ5B5hRoUU0n+Mhw6TihF4QbsXniELO8B
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 131d0a3b-fe8f-449c-d0a7-08d80b92ff3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2020 10:02:04.6847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2lNVl+IqK7ULKcpMtNm+8I5kM152bA6F+VE29I4qm1RbYTwEnhPcP7/knjnUPPovLH3IwE5PCX44MUa+QucFrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn <andrew@lunn.ch> writes:

>> +Link extended states:
>> +
>> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>> +  ``Autoneg failure``             Failure during auto negotiation mecha=
nism
>
>I think you need to define 'failure' here.
>
>Linux PHYs don't have this state. auto-neg is either ongoing, or has compl=
eted. There is no time limit for auto-neg. If there is no link partner, aut=
o-neg does not fail, it just continues until there is a link partner which =
responds and negotiation completes.
>
>Looking at the state diagrams in 802.3 clause 28, what do you consider as =
failure?
>

Ok, you're right. What about renaming this state to "Autoneg issue" and the=
n as ext_substate you can use something like "Autoneg ongoing"?=20

>	 Andrew

