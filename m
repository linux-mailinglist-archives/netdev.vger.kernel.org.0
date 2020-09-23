Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED6727643E
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 00:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgIWW6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 18:58:07 -0400
Received: from mail-eopbgr70084.outbound.protection.outlook.com ([40.107.7.84]:55939
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726419AbgIWW6G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 18:58:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SI1wVyPzM+VDqLd1BvFgZxuqNBfynueTkOAzDEk55wEpkRp0oM+dtby4/LbJHceWvI8XK968YwarJ1YsM5fP7uxQOxbYEKGTN78e52t5zwzDsO5XE9ydhHzecfeF09jXUSBH0kLq1RHmtEihd3tcGPIfbTMKbEgBovVZ3QkbGQrQFvF6vCsr4ubAJonPKU5gLmEEa5EUM0Zl4zOIZkasff1Ugdb/aaXZTVOj97XKEGwaT29Jw9rRvS+sQZ2R7Rvozgy1PP5QttLMcVcm70rf71I5DSHi2qfEiX0hTnEGVRXCbKjEUunrejReQ5aDxE7eCkAp2o6B5au8gngjdv9XjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xvth+771VSddHOLOpwclEgb8eJHVlcDwK4tHq5AvvFA=;
 b=EgmK8sa3gVJD9Hq2qbFqInZgjoKDRY4SrohYjUv1ib4+D0AJCaH++iFtsypaLf3jrC+M+ijrMz9Z0fIvijAzWjoJRm4leuElua7byzmEyGOzUqnZI4G6iJbXELiw8BNuPalByj1Ayvbf83AzwQSaWI4VZ/HKSIRZW9AQQzXyUt+gT3E2fPXIqqzMFbp6i8XTlkRlk+mzlIySkluFGjU6x6rTWiE8lw0/9Vs/KWj2Yku5dVs/tYnaTyc+8a40ieoURY+96R+utcUHxyPHO7eR+/IcTc7wtVMrlHK1j7SU3peO2F7IqDdJOwmIma0q5rSDj//zs42rJRIZAZ7jMw1DAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xvth+771VSddHOLOpwclEgb8eJHVlcDwK4tHq5AvvFA=;
 b=HZMAFLAnYE+Kv8gdaOHofhXKs6NsRoltnzbQG1s6wuAtmzhhH8/DrTLHdP1d+r/Kg3GfQ2Hp0bonElPbnwWB4vACONM8gPtyV/p8XFNW0NvSV97rFBdVO0dWLtvm1I+CgP8av4uDVaHrwBoThVQkqfe2rbJgL/k+6esDFjI3ywU=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7341.eurprd04.prod.outlook.com (2603:10a6:800:1a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Wed, 23 Sep
 2020 22:58:03 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.020; Wed, 23 Sep 2020
 22:58:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>
Subject: Re: [PATCH net-next v3 1/2] net: dsa: untag the bridge pvid from rx
 skbs
Thread-Topic: [PATCH net-next v3 1/2] net: dsa: untag the bridge pvid from rx
 skbs
Thread-Index: AQHWkfI49n/dW6yWhUaSsyNzEyjVval2wsIAgAASeYCAAADaAA==
Date:   Wed, 23 Sep 2020 22:58:03 +0000
Message-ID: <20200923225802.vjwwjmw7mh2ru3so@skbuf>
References: <20200923214038.3671566-1-f.fainelli@gmail.com>
 <20200923214038.3671566-2-f.fainelli@gmail.com>
 <20200923214852.x2z5gb6pzaphpfvv@skbuf>
 <e5f1d482-1b4f-20da-a55b-a953bf52ce8c@gmail.com>
In-Reply-To: <e5f1d482-1b4f-20da-a55b-a953bf52ce8c@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ac5b7d0e-fbae-4587-72dd-08d860142062
x-ms-traffictypediagnostic: VE1PR04MB7341:
x-microsoft-antispam-prvs: <VE1PR04MB7341056985C44CF7A1C56E99E0380@VE1PR04MB7341.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:669;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hJzhb2Tns3Qs0ywB8SVl+3uR9Io7kjWc/RKunv5ErdxtqN7WwDzILQfOMj0oesw0C9osPOcHyz3ABe7JUzsiyzmBWHXtq7ud/84FsaAVr1lIWMBsdg9lkXz9k70HoVD3NBfsia3lZEUi8yuSPpVPtGBIMU7oR6laVimMEyPDYL9JxjOtSu5ZEwr3NBnUnE94ct9iXl7TIzOxGmuR8l6bXDg0Bwr7ye/Fsh09FtG8jQKtD4ioR5B+KRJu9VIKhg/jPerGxQXppQPIbF5yTEQNV2LI15rUoBGprxXtcHnwRYaLdpLjEkMuEWaHMbNtq1G7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(346002)(396003)(366004)(39860400002)(136003)(9686003)(33716001)(54906003)(26005)(6512007)(4326008)(186003)(6506007)(8936002)(44832011)(91956017)(2906002)(71200400001)(66446008)(66946007)(64756008)(6916009)(76116006)(8676002)(478600001)(4744005)(66476007)(66556008)(5660300002)(86362001)(6486002)(316002)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 4l+Q/PTRRXVDt7MYOMkiRi7wQAmm6Jp2BvMe6HF7Hbk7sjYKT1gYYuKwutjNCOMqEA/A3yu74prTPYZa2UorWG9YLZpOSouJvqnA65W5zxmrQIm8N3Tsl0L+6G3QUDeJO6t4mPc2HJzeudcHUhdq7cQfjow8mQt5k+/2wYiF2t64kSC8q8Mxoskkus5RSzCoDXvD0yvShmIUCztnuJ6joeJ/IcW/oPbJPjMvQECkWRvzXs2hLx5Y7GQOkngZl9B++K9Pwplnj4Sz/fP+8Hol6r8oxmEz3ZWxgZwyawko/TE5+c+2qtFurKUmxDHtrX2XxdzuvHh4O/ZzxRQDjHNlLz5w8fO8BdERD5yMpP/V/vQzXpBporlgUwvzsOYSWK8ED3HENC01a1B0mCFEMWePajbkZCXcE1by7kq/ca4qQxwzhaQe1ZJizRTm4HvnCdDpHmMDLOILxeQ0u2obASWWcm/MZCcB2cr9i1ZAV7K55fNd9ALVL5E1VN3tt6b7MUuqicm39S5BYZ846XD/0H9mWeGE5RcDskMEmqyPvxHIdlgXV36icyxnGTuQ/wH7vvQOEKfbbHmRLTjQ1egCfw4+2tXa717CE0Wmf3PEjrwp3D7FX3omeMsGxSedXlgqcW8uDXNEtmmgaDl1HzzzkHqHmA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <504CA5D0E53F6048BFE26C46A22763BC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac5b7d0e-fbae-4587-72dd-08d860142062
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 22:58:03.0641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r4QWun1UBRkmR2mBn8bh+Y3zihkMxgaWyodpkvFhXvaJpg8yJu2giwnw0es2ZFYthQu4tnwZrl2KtFGUmi432Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 03:54:59PM -0700, Florian Fainelli wrote:
> Not having much luck with using  __vlan_find_dev_deep_rcu() for a reason
> I don't understand we trip over the proto value being neither of the two
> support Ethertype and hit the BUG().
>=20
> +       upper_dev =3D __vlan_find_dev_deep_rcu(br, htons(proto), vid);
> +       if (upper_dev)
> +               return skb;
>=20
> Any ideas?

Damn...
Yes, of course, the skb->protocol is still ETH_P_XDSA which is where
eth_type_trans() on the master left it.=
