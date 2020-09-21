Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1087D271984
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 05:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgIUDF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 23:05:29 -0400
Received: from mail-am6eur05on2055.outbound.protection.outlook.com ([40.107.22.55]:39777
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726104AbgIUDF3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 23:05:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YGSi3LNZQBBMs9E6E0+/SKlS3pRVg7wXZp3joes6WIpSim3SOArXeF2p9MNW28qKM8f4G/5r9qDOUNjAaiXnKOeAtTQ1JsDE+JC/YHBgjr08laXSXDzm7y3ineY/NeeJF33Uqk7HiDL5SCsgqji8EkE8csX+pSMtN+UjdFuzYlheIvgd2boh4YZNvFSdX69nLwwDdjcf2GDkLA6VVlB4Uq4JjxEBGT4Fn/FGf3/mTP14uXE2MLjAJXaC0prKxDOQztXeh6LML2ln2QQIxPZnYSPVBDryg8bYYRFoNb0PolOsBeBsn6KO2A/2T/+wp6/E5J+1FkKJnjP0qgEdFj8OSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5rey8InP4iY2gH0z38Gi3LRjoE61iCXCCfyS/DD1xX4=;
 b=QhaQVs/I467qVlQHF6I368gPRgnj1gQDuykWp3rZT5TDLIXIP3N1bvH8aMwAfdci2rNObivQAU4ydcgIIIMHcefuOOsWW8TCxWJtD0NKw0fRh00y6X0ZzXH5Qj/X+/KOUHs+t0wBsC58ZCH+kqw56f4EJX78N+x0g+iDLAB8+CzGRQuFFrwP+xMWwG9SOBMAKVtQf1BfYJwz4v6OHZGjMPrBkLpsstRWA/+grg2jVGJOGRxhm23h+eCrOnCidl1GdvAJfU73wy4lOyYx/uUD4ehpX0IUB17mr7Pis5vqrhaLcS7W8Ki2bI1h/lkDcIJeuopeHgH2LeYqDKvvRG01Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5rey8InP4iY2gH0z38Gi3LRjoE61iCXCCfyS/DD1xX4=;
 b=m73h22wLTHbBtKx+Nt6F6dwBwGFy/JcD/wK/BXYlGflFjKgdsLov+bvbX8rtHd3AyccuCrtint7Zsutl0M3TLkiYZVES2bs47kXo4YkFM4KWeQ/Tar4WQksJ8eq6AFRMuvQ8KYWiNLIlMux15SlSE74oEHy8iyP4fs6fhHWQLE0=
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com (2603:10a6:803:ed::22)
 by VI1PR04MB4111.eurprd04.prod.outlook.com (2603:10a6:803:48::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 03:05:23 +0000
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c99:9749:3211:2e1f]) by VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c99:9749:3211:2e1f%5]) with mapi id 15.20.3391.019; Mon, 21 Sep 2020
 03:05:23 +0000
From:   Hongbo Wang <hongbo.wang@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, Po Liu <po.liu@nxp.com>,
        Mingkai Hu <mingkai.hu@nxp.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "ivecera@redhat.com" <ivecera@redhat.com>
Subject: RE: [EXT] Re: [PATCH v6 0/3] Add 802.1AD protocol support for dsa
 switch and ocelot driver
Thread-Topic: [EXT] Re: [PATCH v6 0/3] Add 802.1AD protocol support for dsa
 switch and ocelot driver
Thread-Index: AQHWjA4oKTirJX0x8UaU4z1kN1uF0qlvHTqAgANNP1A=
Date:   Mon, 21 Sep 2020 03:05:22 +0000
Message-ID: <VI1PR04MB5677B72C6AFFB0E97357C94AE13A0@VI1PR04MB5677.eurprd04.prod.outlook.com>
References: <20200916094845.10782-1-hongbo.wang@nxp.com>
 <20200918.172025.962077344132523092.davem@davemloft.net>
In-Reply-To: <20200918.172025.962077344132523092.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ca796846-e870-4897-a76b-08d85ddb2e5d
x-ms-traffictypediagnostic: VI1PR04MB4111:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB41110B4EFE9D87811954AD19E13A0@VI1PR04MB4111.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FHheEarcz7Syh1oqXSND5SuKOv37zxhRdxEkiK0EUC+q9AEKH9ivt/eP3SXv3dGyTmCMV83GB047xR4pTObmf8HItTtQqVXCF6bq/0vBiSqNAKYx3GepV+TDaGrYfmS9k1IPBy/KZwYIoOr3G+IDiGyUOmhPRphQ2WuWetTPEHAzuZmZ4iBoCjT6dOFUoLPqOheMsAwNgOdoYeyE2WyU5GPniTulB0BhuhVDwzi2BXQ6wIkBwkpPBp/O8OUBngs6N9QcqoC8602lYPVoW8MxZgfQusAREQbyc0P90ad7IdijyN0GRKMyiLoAvvqdHCf40cx0y+0DXiPDJU/0HhJAUA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5677.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(4326008)(83380400001)(71200400001)(8936002)(7416002)(2906002)(9686003)(54906003)(55016002)(186003)(316002)(478600001)(6916009)(26005)(33656002)(66446008)(6506007)(64756008)(66556008)(66476007)(66946007)(76116006)(5660300002)(52536014)(44832011)(8676002)(7696005)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: PnzUykrsEURptOURG9WXY3RHLPiLurkBhdfAARQbNupnenZEo601lbUIIYQdTex6ejFij2KDe6Bx2aDCL3jOcIqxxYQ6RmiePYX6MWoah74wN51FSyLJAVQkLcBtsMNNNTUmHRZ3lalBjC6VE7Bq8JKTjMWQ2hAdwLjnZIC+YW9Km2xuwPfYJcSGsd8SSNXWj9lKeBoJN/OwTqAcvlUb19jXckfkbXVTAsPJ1nQiaQgcCE1Xasi5Da7p0CDGqZukjL8hNnzmKtV3NR9hEL0O5wHTq0GnXwYoAV9XNElRv85RGUtxyDLpg4R2HbEjTDt3CpgztVBdInayusn5gAvt6fxHGZ5Benfac+60wUcDUrOBx2ggN/WWtTs78C1wLGjfhpIO7OWZnVJDgWrDpVeZkynElbEigUwaL96YfmpRNkjOZlj6VNabH/kuN7I8w/+5lg0qDfzJOUDNCDPFy4AxqfL/H3xnSRIp2FXEo1/M/f2tBQGNXCwITTtXokEra6WIalqKNEcECKeO3A/VT4VnAXBHiunLeJ2aJ1NG4t94CYLddL8lZXtu+LcIT7H1WGaYZp7a7yqFZ0ID2Jj9IJFhlh4RIyu02aCxAfp11Vsypkuxq/suqFgoT7NQs3CLu0ifsmEezXrozUzdPaaKaBUN/w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5677.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca796846-e870-4897-a76b-08d85ddb2e5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2020 03:05:22.8246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JjhshqdHbUDAk/7L3fiS+IL/1E5eAClFQPQz4WDpEx6siBRZACa2HlAauU+WVxMZCqxTT4YCtyV0TMPJ5C9Epg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4111
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> You're going to have to update every single SWITCHDEV_PORT_ADD_OBJ
> handler and subsequent helpers to check the validate the protocol value.
>=20
> You also are going to have to make sure that every instantiated
> switchdev_obj_port_vlan object initializes the vlan protocol field proper=
ly.
>=20
> Basically, now that this structure has a new member, everything that oper=
ates
> on that object must be updated to handle the new protocol value.
>=20
> And I do mean everything.
>=20
> You can't just add the protocol handling to the locations you care about =
for
> bridging and DSA.
>=20
> You also have to more fully address the feedback given by Vladimir in pat=
ch #3.
> Are the expectations on the user side a Linux based expectation, or one s=
pecific
> about how this ASIC is expected to behave by default.  It is very unclear=
 what
> you are talking about when you say customer and ISP etc.
>=20

Hi David,

Thanks for your comments.

I understand your concerns, I will review the code.
Generally, the packets from customer port will have only C-TAG, but the pac=
kets form ISP port will have both S-TAG and C-TAG. For ocelot switch, these=
 two ports have different register config.


Thanks
hongbo
