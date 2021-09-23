Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF27D415CDF
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 13:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240638AbhIWLhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 07:37:04 -0400
Received: from mail-eopbgr70074.outbound.protection.outlook.com ([40.107.7.74]:45379
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240610AbhIWLhD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 07:37:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H804kEAaRtYfZZkNDq5oBLTRfZK8vP1C9EUdK8Kzwed62Oc3k8o75rOeqDPSYzHyq0FPvpqp+ggPCNrlYAcwErL2JQRy+V9P4c+51l7g6KA0J9jsTwAKNinkhw6AbU1mfwVEBwoJx5dtUbe5icmBEgpOvCPXBOA9Kvrb0+rx0DViWa+/Jn8q03Apk9tIK1Se10TS512sV2YyObBBUnVFFEdVVDmDRRTAJ8E802c6gzIdn8EYBw5n7ngsOwLNHd2G9OfBimuvpMXQXoDgXGiaXfaPMa+WMHfSxcRzhJADB7KVGkAROJCLbIRPCnVpP7MROSeDpySudXbhVJJuWZRDtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=5CPiZFT/7GfqyhbK9FEtlDk88pKtnnOBfFRjHtwRKGY=;
 b=DUPH4x1a93HO7DXFacyDnymvHLvZl0EW0mpcn8DWamxgihbVngwa0YVvWtNp8O1gPXeaF6bd4PoAx6I4eHPRidtT9GbTN8KA0cxzdRKCpD8rrP/HjGKmHQdKYPwO+Ocwkx6YvTBusMS5BcPZGoKjCg7R6TFTa3SrlJNyK2gIM/v6B4tdTR47SQ6Yl4ULe6WTUVr9/wbhvNCEo6q9wH7/me7Iw0tqhLgbcDgUR+xigR9GlzwM0rzod/vg+epvuF7bC1MVtEDladksUkSKG0us0a0p28Z1Uq4IYtaIVahIBlwxU4AqxzD6fn/i+dHazZWppfrkv4Jc5BcVhOjAkgl6uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5CPiZFT/7GfqyhbK9FEtlDk88pKtnnOBfFRjHtwRKGY=;
 b=gurqg99wxi4vtt4WkDsvGpZguth+yR8B7t7ESienljQdGhOYbdstles69KAD23MZ33kKFpErGQCat3B507wnjsx09jbXjn35qzCv/E/ylA9d3mIjHl5cgaNdiuJEbNiUqWICAtM0pQYOdEBS80Om1ksS9VBMf8dBQAPXYhUFckE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3406.eurprd04.prod.outlook.com (2603:10a6:803:c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.18; Thu, 23 Sep
 2021 11:35:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.021; Thu, 23 Sep 2021
 11:35:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
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
Subject: Re: [PATCH v4 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Topic: [PATCH v4 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Index: AQHXr56GWZAJ2atrv0ecdycHDF0T3KuwAOYAgADlwACAAHlYgIAAG7WAgAADRYA=
Date:   Thu, 23 Sep 2021 11:35:28 +0000
Message-ID: <20210923113527.jd3buthrh2rx6ulz@skbuf>
References: <20210922105202.12134-1-xiaoliang.yang_1@nxp.com>
 <20210922105202.12134-6-xiaoliang.yang_1@nxp.com>
 <20210922124758.3n2yrjgb6ijrq6ls@skbuf>
 <DB8PR04MB578547CBED62C7EEA9F8F534F0A39@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210923094435.3jrpwd63fnmwhx7i@skbuf>
 <DB8PR04MB578574BC7F055D55725374CCF0A39@DB8PR04MB5785.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB578574BC7F055D55725374CCF0A39@DB8PR04MB5785.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f0e8e86-a0ef-40f5-5379-08d97e863e56
x-ms-traffictypediagnostic: VI1PR0402MB3406:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB34062A4EA7C7D7BA2874D346E0A39@VI1PR0402MB3406.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: emg6LMqrrFokUqaOb8Fzz1zWngoYOrVtTbW4GP9fo70SwWXSS3p9ujirEPRMuEOsiFxMvupZNPtqxhGGYjEE7RuQ/awogGMcGvJzv31VEPcgzAlz1lHKUl72R573120ABw1Jmp/fj7f8/Bu/BTHxRqCx9utkrPDC/MX+Sh7iNkfABXvrIjhX0vh1KYwrxNh6uCKddXWGSbBGKNoRpYjias2MwBTC59jzsZz3nmDMv9jbCWHGd4S2cnSFgCKa2KGFxrrP7vM1i5lI3zpf2dyWalFSLcxdUxPhb/QrvnMpFCXk9Q3l+yP8DzhxuGvkAikA0uLVcSrDsPFPPlXgqidMokOicA3ZPt4aHMs89Dr6bX24gAW7JX8WQxDkR6OrLvbHjLjPronC9L9JOj5JGtiVTnoh2I3lzZNN4QnNMzjeQFBbawfllBMZ37Kgby4CQnyde8Thj14oIjbie+FQzmO6otRuWsgg+hajGCmNpJaM6oWFCR4CTdhHcO8WutH0B/PUMkAfEaf4jhc05ou9xl7vGY0QN9CYU0rP7bR0NZK9skPXhO21G3n0alLZF2Wy5TmqtgJtpHDR/rCP1XYOv7+istNYL0Q2TQFuIDTJQb28KmoU5AvSbGMsdbEd9q5f2YP875fevgkRxVV6yqS0ZuqAcqLKSiRoILfWUkpzlK6ZzK76+x21pDttCedrxpZ9V82mnuMg/8r/JpfNiLWUsSCTK/XvWHGRiuVM7gMlcTgWLrq3X46/XYGHsW6lWdFjk1IR4rR67vfSbDej/y3bEy0bwuulOPVRZjPW1pCq9FbBAHg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(33716001)(86362001)(2906002)(6506007)(8676002)(508600001)(316002)(5660300002)(53546011)(122000001)(966005)(6512007)(26005)(1076003)(6636002)(83380400001)(66946007)(4326008)(38100700002)(7416002)(44832011)(186003)(6486002)(54906003)(8936002)(76116006)(71200400001)(66556008)(66476007)(6862004)(66446008)(9686003)(38070700005)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QS5XNJQPPZWTf7sCLKCOXYCqoFzxB0TlrkiR20Iu+qpVFNZv09Gh5Hr1u6rX?=
 =?us-ascii?Q?PJz9o3+vgnEFPCae+AKOnDBRER6+sYr8qGARZv1Kykn2V64OI15a+esAUEV4?=
 =?us-ascii?Q?DcTRhavpD7olo0uexODRcwPJ0lHL0dxufL4MQtHpbN0QI+agKQInnsx24E3V?=
 =?us-ascii?Q?HCfwfvQTf3Sn1THY2FhpxpQMrzv2CJtrm5GzvrzQ5xtUii5mVMgt7DW9Hz+7?=
 =?us-ascii?Q?nb+HGRqBX3+7ECX9bJCkmAgZPIDYIqbeSg4NWpjYNQyhTN0pmCXT/6AAbr5O?=
 =?us-ascii?Q?9f0+Vndnb5cnVxhHjzGRdZZBeLRnPdzAoP48+n0Z5bnXyfqo3IeJzT/Lvm/B?=
 =?us-ascii?Q?yC9tAn9GJ6PE+jVMqASDt0zmyYPycFobUx5Ub841d47hp1XeuJBxwEbWV5EZ?=
 =?us-ascii?Q?pupbhmZRM4gzgW2xmOV4yX22D/YfDX4YoTXziySxolMGQvckObv9Ry1GFnJf?=
 =?us-ascii?Q?E+jQ7iO9Q9cvKVolzkLVsyLbHfws5Zy3luXX0cNqaAqy5cfxni0itdIp8nRc?=
 =?us-ascii?Q?O3jT9EM9fAyggHIDX9ui92EV+ksl932iAVBDuJ2Bwcav9gkRHk+qEoRUpmtV?=
 =?us-ascii?Q?ooDNiCj9BQmoAskEsuQPxy4LTnO7zDy1dzSa+rk7AL4BPL8fX/4P2/MFHHlz?=
 =?us-ascii?Q?M0f8kFyEDEqbdoEqtVgWMZ01stFYxixutz3aRMCF56bTeGbqPkfRsLfNJUzy?=
 =?us-ascii?Q?Gurth4PTdI82wd9n0H1m/WPhwiCBNi7NnJWT2ddeHat09O3g8/q5neQfVtNf?=
 =?us-ascii?Q?ePGN4p6Q7fGbx+/ItSdsVakNvMkvAsfggFYZbgUTusYuraKDSMseJnCN9gP+?=
 =?us-ascii?Q?UGJ7mjylC9J80g5575tXYO5yWG60IfiA0UeHozeoftPhw5DKIMqEyNEQidLN?=
 =?us-ascii?Q?A82gEa0A/vpFI1iT1ZKUkdU9cXoL+n+88tq/3SO8m6h2z+duO2B/Fz+7mLzV?=
 =?us-ascii?Q?VEfu3a/FRvjSUoi8BfOs2NTIgTEiMrSeXGWzWjzaDFVB2JUQPRIqFiIA3vj1?=
 =?us-ascii?Q?XaXvVOn78RMq0749w4Z9+ZuhFa6eGWtywgKczcNG+VZMRdQrB/GUP79SKCNq?=
 =?us-ascii?Q?wR7KxdPCLI+dwzCbX0zK9QB1FwPnoaLM02d8+GFPKRJsonCNtSrl2w/gsn2X?=
 =?us-ascii?Q?wCmpI7QkEwR/Lry6lkNgMols1qa7bhHftzPabYe58USGhyd3an/8gxFjzj4l?=
 =?us-ascii?Q?XoL9LqZQ7yK0zWj+OROp49xX+aeUYav9VwtGW7UE1aVIu6G6qr49qZxvZVYU?=
 =?us-ascii?Q?xbb2EP5/ojbj68B+NEwU00PIZInfuq/83gHPSrTziNLIOy4YKsyw5qAYu6g4?=
 =?us-ascii?Q?usUSYZodbz4oLlz4hJKdmYEZWLcWPPanfdbSgZHxiNbPog=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <81BC30E2C9097542B69D82816DAB543E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f0e8e86-a0ef-40f5-5379-08d97e863e56
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 11:35:28.4479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6pu8rbEaY8kQ/pdjDa+nz6agbOJu34BLhQTkGkk9runPFQsAHVS7zmPesYDHw0eOGK11wZn5iraxfrobdxA40A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3406
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 11:23:45AM +0000, Xiaoliang Yang wrote:
> Hi Vladimir,
>
> On Thu, Sep 23, 2021 at 15:45:16 +0000, Vladimir Oltean wrote:
> > > Maybe we need to use ocelot_mact_learn() instead of
> > > ocelot_mact_write() after setting SFID in StreamData. I think this ca=
n
> > > avoid writing a wrong entry.
> >
> > So you're thinking of introducing a new ocelot_mact_learn_with_streamda=
ta(),
> > that writes the SFID and SSID of the STREAMDATA too, instead of editing=
 them
> > in-place for an existing MAC table entry, and then issuing a LEARN MAC =
Table
> > command which would hopefully transfer the entire data structure to the=
 MAC
> > table?
> >
> > Have you tried that?
>
> Yes, I have tried. I mean writes SFID of STREAMDATA in
> vsc9959_mact_stream_set() first, then calls ocelot_mact_learn()
> function to write VID, mac and STREAMDATA in MAC table. We don't need
> to introduce a new function. Once we call ocelot_mact_learn()
> function, STREAMDATA will be stored in the learned entry.
>
> >
> > In the documentation for the LEARN MAC Table command, I see:
> >
> > Purpose: Insert/learn new entry in MAC table.  Position given by (MAC, =
VID)
> >
> > Use: Configure MAC and VID of the new entry in MACHDATA and MACLDATA.
> > Configure remaining entry fields in MACACCESS.  The location in the MAC
> > table is calculated based on (MAC, VID).
> >
> > I just hope it will transfer the STREAMDATA too, it doesn't explicitly =
say that it
> > will...
> >
> > And assuming it does, will the LEARN command overwrite an existing stat=
ic
> > FDB entry which has the same MAC DA and VLAN ID, but not SFID?
> > I haven't tried that either.
>
> I tried the case that when MAC table index has changed, STREAMDATA
> will keep move with VID and MAC. The entry { STREAMDATA , VID, MAC}
> also can overwrite a static exist entry. I think we can do like this.

Ok, so maybe we should do that?

Even though I must say I don't really like the idea of partially writing
MAC table entry data from the vsc9959 driver, and partially from
ocelot_mact_learn. I also have this patch pending:
https://patchwork.kernel.org/project/netdevbpf/patch/20210824114049.3814660=
-4-vladimir.oltean@nxp.com/
and concurrency will be an absolute mess. The ocelot->mact_lock will
need to be taken _before_ we start writing the STREAMDATA, so this
variant of ocelot_mact_learn will still have to stay somewhere in the
ocelot library, and be organized something like this:

__ocelot_mact_learn()
{
	do what ocelot_mact_learn() currently does
}

ocelot_mact_learn()
{
	mutex_lock(&ocelot->mact_lock);
	__ocelot_mact_learn();
	mutex_unlock(&ocelot->mact_lock);
}

ocelot_mact_learn_streamdata()
{
	mutex_lock(&ocelot->mact_lock);
	write_streamdata();
	__ocelot_mact_learn();
	mutex_unlock(&ocelot->mact_lock);
}

otherwise I would need to introduce avoidable refactoring in the driver.
In fact, could you please pick up that mact_lock patch? Even if the
rtnl_mutex was not dropped yet, the extra lock should not hurt anyone.=
