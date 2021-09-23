Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E830415CC6
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 13:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240585AbhIWLZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 07:25:19 -0400
Received: from mail-eopbgr40082.outbound.protection.outlook.com ([40.107.4.82]:9376
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240493AbhIWLZS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 07:25:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmPtABGvOK47uQ1lre7voQXgVT8vR2wt4ru7b6ILGDaqBxRuIfp5tWvgnkncqJhpdfvlIHblIlaxjrXbbyih2M8COuAia0g2QZ50lojI6SU+g/9L/lwz5ifMZckyy6DtbaSIHd5nRdl23QZjVBPJ7A1D2jvZcd/kiSVec/OypNBwIwIRof36yu2xvIb0GqruUCy79TELjchGHehaegggjB82aT4FhdxYpxsSg1QOt5k5u+PE9i9hO2q+Nh/r6BQ7nkWtxtOIFn6lgIuw4dU0NHhH844uIrIyahBaA9UKkPXBAbYIyYXzaLbN/apLsgfVwt2gx3BuLTAKb/9rTk6bzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=+7nLA3vnPZdVwKWOjqy1PPEAv2Ejw/SxBCUcBgc+NbM=;
 b=ZGKmvFoGKnrW1KwJT/5ketRLePXBxIV3Rx0StrFypwHsXv/eCWfxI6dIZq2P/usgwJdAPHIm+xMmxayJ+LVhUa1imUUH7sEO8dmfbh2WQFoVXqHdIQYqYcVvOYORW3UNkMQCXlDOzp2nQs77fSEi40moJsgnOEhP4HoTAJvTX2npgsh8Tl1M+3eNIh89jTD6QLv+ICZQxP5PZlSvf7l8z/FAR07g7Qwov7cAb9nXmIPQsMUxewryTr7CJ8s+93U89SlS37jk25fxW+VUxqfwwOirPMROLWsvtywoS6Gl0/eSsGLJr2NE7tkCo7EN0M/TPVhB8XFOlS6rRn9rI6JWng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+7nLA3vnPZdVwKWOjqy1PPEAv2Ejw/SxBCUcBgc+NbM=;
 b=lW5H74s+LGdar990dVXbgqgPjGwYxuCfQyNkhRc3Yv89vM5JyiU7sTlg+/6zsLmI2sCC2WUV3CkrVh3WT99Nj4K79+Poricy4Oykfb0czjjPoIKHiAe15G5slDtXJ0ISlobb5UsOvKTdfC3NXRBxvHaYFm3QXaVP8CD4EmP9J+4=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB7PR04MB4282.eurprd04.prod.outlook.com (2603:10a6:5:19::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Thu, 23 Sep
 2021 11:23:45 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::7c1f:f1c4:3d81:13fc]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::7c1f:f1c4:3d81:13fc%7]) with mapi id 15.20.4544.014; Thu, 23 Sep 2021
 11:23:45 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: RE: [PATCH v4 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Topic: [PATCH v4 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Index: AQHXr56G+7I3t59N40au/ymUR0+Ct6uwAOeAgADj42CAAHs2AIAADamQ
Date:   Thu, 23 Sep 2021 11:23:45 +0000
Message-ID: <DB8PR04MB578574BC7F055D55725374CCF0A39@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20210922105202.12134-1-xiaoliang.yang_1@nxp.com>
 <20210922105202.12134-6-xiaoliang.yang_1@nxp.com>
 <20210922124758.3n2yrjgb6ijrq6ls@skbuf>
 <DB8PR04MB578547CBED62C7EEA9F8F534F0A39@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210923094435.3jrpwd63fnmwhx7i@skbuf>
In-Reply-To: <20210923094435.3jrpwd63fnmwhx7i@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e15fc28f-31d7-427f-37a8-08d97e849b33
x-ms-traffictypediagnostic: DB7PR04MB4282:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB42824D9AA9500D29F4658CBEF0A39@DB7PR04MB4282.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7ju/sWJ20hO+u6YCT1cDmRBg2WyVgxIRKqWHFJA7p0Zcq1S7mlbkjcSvUeTJT90gcNLTMlrEJ4Hpz+YHeY179Nm7KbH1T2wqu+cS9gjeZKlA0PpAYRok/PHrn5F1lCoJJXlTi8YtVDKMEMmf8PLaQ330QVrTvB5Uvdw2sIjfswENx2ghCqYq+IUTkOfCvhAoIttx8RTOPDsQ22NSitqqarupKhlb4wXhdoe9iP5bj3PLu6PFticSYjtbHpKIEk3q+L1VwoIsd/lVoIvnVCzKz6t3p/QJQxWq9/w9ZQsJXrePRKUzaUvnW5A00cvpjd//BKrkj0+DKFpyXcursiE7flagYqj+41lPeKvf/50YO9KxtNC2HZbLHC6zUwxH5ZNLwZZQhYREJ0rCVmkdm8OKXZQw+eQ3i/yQuW67L04Mr8EiWhfXjSukOz8LqyqCw4aIkl0FvDY+3arWy0K+rsYAFQbb3f+YArwGk37jcTL0wC5TvCoe8ecdyu+ilbTJSjhOhQvqOAfuWhhEloN/iAi974EOIY5vLoqk4ZMZtD6SSUWv4UK/0URbQ4lyXXxFx/eaZTRwM9jFAT+OWXGlgSD/vUJs9I437EWGvcvUeqKJSRpEWzVJTlT6m/1d4kBeyjhdX/EYmwy4zAYkRmm8d40b9ITr4Qjmo9Vov58WkRAxhnA/q+DpoWGiBUh5Mu+b7ODNP9KdEMCuMYcdelUN5fU++Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(186003)(5660300002)(53546011)(7696005)(6506007)(122000001)(38100700002)(38070700005)(6862004)(508600001)(33656002)(9686003)(83380400001)(71200400001)(6636002)(86362001)(76116006)(66446008)(2906002)(64756008)(66556008)(55016002)(8676002)(54906003)(66946007)(52536014)(66476007)(8936002)(316002)(4326008)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nGrb+8CoUu2E1jwIWL7xEG9gfgmowlDOZA3xJnOiJLcCaJDqTiZ7rsfKMGr6?=
 =?us-ascii?Q?x5Z+i8VfKn31XiGR+Kw864KGfnW2kgcdtTJ1yksPrOAENmWANipRD7/ZBViK?=
 =?us-ascii?Q?mqGxdEq8ibtm8LGAyGJ3a1Pa+KeyVV87PylKgd0Hl1DLqeQ+K+N8SOEI0Cto?=
 =?us-ascii?Q?Umqbd7l6WYXXK4Xr6qcgpqZYfPbxcz9vowUFWxqkdJ4cDtcjNOCinXifH1Uk?=
 =?us-ascii?Q?U43GoOMzoN7P4MS2eufqKbivseR3MWeBE20KGk4fIlxGRFZ88Jb+QoQXhCTr?=
 =?us-ascii?Q?fAh6YqmgZK9vWgbEMTDWrngCiCIWCaCK3Pp39jNqgMowUyyr9RJqZpqtZaFg?=
 =?us-ascii?Q?kr1J6cOtmuqTzwWdcutZi7kGDlHc/GYwv4iTCG7C7Tgr8o4IDqEe8k4EvSAh?=
 =?us-ascii?Q?wWYAioQeRxVJTtFnnZqghbU6I79Iq0gFdqlmey0urRX7KDVYgBhKS4TKMcIt?=
 =?us-ascii?Q?f2JjpsTQicQ972RsmQUh4+g4nX8BWxsGPOC8A+MN3ESZt93eIevszSPxmO1I?=
 =?us-ascii?Q?Ij7w/fv7iqhBR7aEyT/oHnU4bcfbC/GmW4sLz8CiSJXUJxvcCmXvhrT+rCa3?=
 =?us-ascii?Q?UPP62HtvtxxlfAga5o2WHJOp1gpJomg8iKGXDF4v2khd0kCF2BicigLEXfvF?=
 =?us-ascii?Q?TBCB1pzg5KsRMKXpzFwhOcf4q84TmL+xmXNOVJVRU10iaZgE8lBJg5HRO1JS?=
 =?us-ascii?Q?iCQYYFZRdHhJwfDtLGk5lOtLtkCtCqGbU5KNl9mPQBYdCX0riYpTSidRG9Si?=
 =?us-ascii?Q?oIzWjzMniqGXC/T40ILXlQOnKpgcpwYzS9oBTwhwfiAbiiz1YktNtLOxL2yY?=
 =?us-ascii?Q?DHC3X1OU5gkIASiA+4l9dAO+1evAXkNRl5htkbn8JgR5E6ND+DbuL1gggPB6?=
 =?us-ascii?Q?7E/9eIC98LVj6auGWMuKJE44U7WMje8oLK5VI8DirvjpXdgLkigFybqHwxWo?=
 =?us-ascii?Q?j9Qf53ZsU75LJMgoqkw8TWLy0AIjBKbveIBUj7PyyWhUcXIcYfhHEOCzPBzv?=
 =?us-ascii?Q?uT2z1bv8xILJxWfOYgnYNdMivsslURhnmAJU7z9YJ02wWDI6kH05/OwXxZBN?=
 =?us-ascii?Q?M4bTERIReU93+3pErlvwIWivCCTtZ6Vhr6pUYen+k7cPoCp/GLsxreAwxwdq?=
 =?us-ascii?Q?yZQRgyzH2vyPI4WPEnqhUH3dIJ+Mwk7dSN5wkO2XxUcdlTD7ltsUM0RwNqIp?=
 =?us-ascii?Q?zBYEoKr0JZdlO1VUSdB2DzQzcsa9jg4N0u9QihyTABe5yoFX9WhYGEupEy2N?=
 =?us-ascii?Q?BfwYK76O366Icd2gVS/tCgTAraKXrPy/SJkOpH1H+8kpQwoDhM/hN/1jWQeD?=
 =?us-ascii?Q?aElAlNBoasB0bwlm7RcteZIW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e15fc28f-31d7-427f-37a8-08d97e849b33
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 11:23:45.2894
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F/k6bgLmVXK+nHnVkezYeblANKYI0KTF5WVD+eqK82Y8uhoNDy2F0V4vyq+VJvJGhWNcsPgKY3fmcVXf2e2OZAYtR6dc4XmaYMxPGq0dpHc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4282
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Thu, Sep 23, 2021 at 15:45:16 +0000, Vladimir Oltean wrote:
> > Maybe we need to use ocelot_mact_learn() instead of
> > ocelot_mact_write() after setting SFID in StreamData. I think this can
> > avoid writing a wrong entry.
>=20
> So you're thinking of introducing a new ocelot_mact_learn_with_streamdata=
(),
> that writes the SFID and SSID of the STREAMDATA too, instead of editing t=
hem
> in-place for an existing MAC table entry, and then issuing a LEARN MAC Ta=
ble
> command which would hopefully transfer the entire data structure to the M=
AC
> table?
>=20
> Have you tried that?

Yes, I have tried. I mean writes SFID of STREAMDATA in vsc9959_mact_stream_=
set() first, then calls ocelot_mact_learn() function to write VID, mac and =
STREAMDATA in MAC table. We don't need to introduce a new function. Once we=
 call ocelot_mact_learn() function, STREAMDATA will be stored in the learne=
d entry.

>=20
> In the documentation for the LEARN MAC Table command, I see:
>=20
> Purpose: Insert/learn new entry in MAC table.  Position given by (MAC, VI=
D)
>=20
> Use: Configure MAC and VID of the new entry in MACHDATA and MACLDATA.
> Configure remaining entry fields in MACACCESS.  The location in the MAC
> table is calculated based on (MAC, VID).
>=20
> I just hope it will transfer the STREAMDATA too, it doesn't explicitly sa=
y that it
> will...
>=20
> And assuming it does, will the LEARN command overwrite an existing static
> FDB entry which has the same MAC DA and VLAN ID, but not SFID?
> I haven't tried that either.

I tried the case that when MAC table index has changed, STREAMDATA will kee=
p move with VID and MAC. The entry { STREAMDATA , VID, MAC} also can overwr=
ite a static exist entry. I think we can do like this.
