Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACABE415B39
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 11:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240215AbhIWJqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 05:46:10 -0400
Received: from mail-db8eur05on2049.outbound.protection.outlook.com ([40.107.20.49]:24928
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238217AbhIWJqJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 05:46:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hk3+KFbD11hfypY0eXQow1XW4/V1HAZeUEri14AncvVknrYEJ7GGGON1rQEWilYZpXguH/gKFtulqUs66NtayutxjJW6pB1E5J83DMknY0rjwSIqaSJHHMEX9pfDv+8rOs8SXL0f5xMiHdO7ThXH1jIuUcbe88MUW2cTRqQZxvTg+t+Lr+gl9KUfxr8apDVGGp67xQBfToc0lUpAqu5gCjUhpqa1WQpDYgvJ3Jra7R9fTYkSofR4lWQzGWPzh8m7WqKYg8ap4pFIyycE2bcx24tvA/bOfKuV4bXLhTg8n+xt0N6Cs43fXEaLzbh3qKQYgjqgK0GtZHRW00Stg1Pgaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=vSsXp+KZdLI52zt37r/dbdLE3XV7LDf079F2OCrZDjQ=;
 b=BV0hI5WLTqS3R/xqwKzs6L8QeJk4k47vPeq/atcd+yMjD+v/NRNLBq+uKt4uKEM5QOe1mifxSJurfG/xackhl7vY4XByRfm+4eU2TvFcpdoJoiE4jiX4sPEXIGNLihWczadVwlLbRRhTX6cmH8ByCupZ6v+w5Il/E4UsYvnG1EUdD9wdgJgMuM/bJ6O7/KU3desICu9TU8wZm7yVg+u7dAsAlZrRgN9JaouiN49IHGE+55ucrtYsdcIfn1ENhjusvYB/iscwVVlvKoNpz+ILljrzHClKN5mP3I4XAkAmSUWQ/LZl/66/4hAD5Ny99jBygcZSlcEOVuCKRPn6ggz22g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vSsXp+KZdLI52zt37r/dbdLE3XV7LDf079F2OCrZDjQ=;
 b=IgEDT9KyVNxGLmo79OO+mxBls6S/ASlk+JRhr/jzafsViLmjraznGZeNE9NLiEdalAD2FwpbUNtVwe31pAauQy1N1TqO/k0KX4MgU9Nuw9xF15oDlTw5oFJdtFtakW+XdFcEOcW26xcUUhvd0EtYHxANcaeju0DI18YeKtc3HOI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7119.eurprd04.prod.outlook.com (2603:10a6:800:12e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Thu, 23 Sep
 2021 09:44:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.021; Thu, 23 Sep 2021
 09:44:36 +0000
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
Thread-Index: AQHXr56GWZAJ2atrv0ecdycHDF0T3KuwAOYAgADlwACAAHlYgA==
Date:   Thu, 23 Sep 2021 09:44:36 +0000
Message-ID: <20210923094435.3jrpwd63fnmwhx7i@skbuf>
References: <20210922105202.12134-1-xiaoliang.yang_1@nxp.com>
 <20210922105202.12134-6-xiaoliang.yang_1@nxp.com>
 <20210922124758.3n2yrjgb6ijrq6ls@skbuf>
 <DB8PR04MB578547CBED62C7EEA9F8F534F0A39@DB8PR04MB5785.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB578547CBED62C7EEA9F8F534F0A39@DB8PR04MB5785.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 987ba28a-3e4f-48d6-c1a4-08d97e76c13e
x-ms-traffictypediagnostic: VI1PR04MB7119:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB71190D76541E4783AE5396D7E0A39@VI1PR04MB7119.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UPNl+tyXwSk8Pd0d9g5dpBr9OtqKryXRBE/uvI8Y+9dOZNljoXuXZt+EZE40KIoNMA0DVcayvplg8abSRvn/ukK0VuEtq0Rsggf7Sg+T0/6s4fAwje9fHvNTUS+++CdJ6udHrSevs/cE9OHCSTGfoT8TWEGwFkKCT0cFmDO8TRWwsdGeDCmBNbtLxySJOkF6FBlRxcnxbatkUARCzyYBHcsYlO9jL3voCjLQUyFRKDfgJLCtPZeDERV8oSZo4AAEHERvFphqN2M8Evh3J16tJkfz3cEHt4vGK8aoiNpyMc2VHfmWHvkplbfFFy6w8JmedQYo/F80aQlMjVmW+xzx9tjYeVKlfKoFK4kpLFzWOQqAvJz8F2FPI0JLGxV2g5OJ6BhmGjRAq/fpZhHQ9lAP/eR++ItYObVpjt606eIPnBxIqzM1AGsSPfQOyrWp7lHpHM5vX/bvvtirnYUtdFX3EVNp5Ss7L+SbTo+5lQqm6uTTCt/MRJeww0WUh6RMsxD/criH1x6rGhx/9FiDTkeWrMJ8fcMGt9bLJqnRjKPVQJeQRLlFZK0tsYn98LfaD7r5SH/M2J7YOrqG5cQYhAquXXA5zTfcEhJe0u1S6ii0wDa1MkmZhMAIddDew6IkrR9UT+tR1spDlmCT8iDT+SySqUXGYRYTSeDnpBtc1Vtj5oF9/x6Dvfq9fZqyDiLGA6jBKk6Je3WlxdtsQZes8q/Z5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(83380400001)(66476007)(76116006)(91956017)(5660300002)(8676002)(66946007)(54906003)(66446008)(64756008)(71200400001)(33716001)(38100700002)(66556008)(6506007)(44832011)(508600001)(6636002)(316002)(7416002)(122000001)(8936002)(38070700005)(1076003)(6512007)(9686003)(26005)(186003)(6862004)(2906002)(6486002)(86362001)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rVh3PbehDYLaeJGaGAQU787EMgD58nVQqVog2ZTCH8K4zBB8MTMOUUiZJl79?=
 =?us-ascii?Q?X7g2Tsoadm4d4TXw4V54bWNyqGHGBn0IIAltOIs5GctrGVBzWEV37cG//EmN?=
 =?us-ascii?Q?VOFVOmeIh6IX+gnkAIRcJGvkdVF5emIZLHaPs7kBudj6kbRMIwJLLhIs5UhE?=
 =?us-ascii?Q?gz2u1NpIFeNu6udN9bnOn92nhevHQIqTHTzN1f6tW6SpCYiF/9CwCTADzwyW?=
 =?us-ascii?Q?kjzOWfnfUUh9uM3msosPbVF6VUAYjIZwAThqEG1JN9B4BSjsh8T16AW8Dacp?=
 =?us-ascii?Q?1LlxdIv7MUhNACMvvnSqZDHbco0TwACrDZBjCaVMmdtCpntXGYbAteEQPpdO?=
 =?us-ascii?Q?OeNkjZdweF65w5/vpG84YjdhTYbs2q5gUsumnYLPySjQhpdpwDQyoIxXDYVE?=
 =?us-ascii?Q?dL1aOwMoAGHXaHhPb9oVlJP0GgNNf5JcOll/z2ThSOzcwbsUzZ1+LSjkLF6G?=
 =?us-ascii?Q?vX1kvlBoTFGM75kBrJ9Li57Psa7gNRzWyl1DYk6URhm9dTTnvwXj6d6VKEVP?=
 =?us-ascii?Q?ztde7c2rlwSFxY4DyLQz9eHOFJuN848RARo3wmJ8oQ1SJO1RmnKvqqmsUwbm?=
 =?us-ascii?Q?l9Dllk+vdkv7HWWXK5DOh5452gNN/bC9IxLq+46F/s4Tbn+TC/1QlBiVRAVM?=
 =?us-ascii?Q?xWhLrpHMjryRK8t6w+rVS4+fXOE244RImTEsELz5MPOFKDG8smvTGr6pbe3w?=
 =?us-ascii?Q?1yfuw6UHHX+1QiRw1I+XDtv0Hn/Wnxos7w2C9q+SVZjWm2RJAUzWWwjyETHu?=
 =?us-ascii?Q?KMQEC+Yv5OVaAphwsLSNDMDJB9oO9I3lnEbgu8AiJrdY61U5KYTSaunp6xb9?=
 =?us-ascii?Q?R8Xv2PuRrHC6x5MgL01TGJWxcvGoHOXJVf36FkYgcDuHYsRPEtqQBmTMcz7T?=
 =?us-ascii?Q?lfoA/v6nfFbH1yq578yS4c215hJQKcqSvwEUgzZ9+4mjeiQoOdnVr7VcbUPS?=
 =?us-ascii?Q?CCJHGOPlyh6+C5+F8FYsNGdbcjPwSTdL/R2CJn3rLos43UpoQbVnDAjjw3dn?=
 =?us-ascii?Q?9NQ/EO0zcYzUmHd5LG03Et1qGO5R+2nyZXE5WFAEvt3kP1FQnaaBcQ2Vex1K?=
 =?us-ascii?Q?uAWfFOuGeYhhB3F0+6VTS4IqLOeF/bNeY6iURX0qE6q/sB3mmex7Fq3noEcO?=
 =?us-ascii?Q?VQZVVO/c9OW9JkKaCD/CfvUugRPG5vr8/SlFiTLKLuMoAVjEqzHlfXdkFHjT?=
 =?us-ascii?Q?KkNa6iCMyRs5ITvRDSxAjgjS5iiWpqhfMXZ/hUKbGHi5Eew8wsxREApdxHS/?=
 =?us-ascii?Q?PSgfq4c0W4EhxyrhwL5yxdj2dN43uO2jIKRxItoWghhv9F5FjtuUGWCMnVT1?=
 =?us-ascii?Q?gFOP4naGYPmzxBDUo81ZwEL2R3X3QfL4WUZjyFOO0DCtNA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B96DA62532403F4096624BA2DBA63F2E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 987ba28a-3e4f-48d6-c1a4-08d97e76c13e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 09:44:36.1682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f5rjwvY7IRF40cZJnarDA3bE/VJ9o6zlRBOscI/xAfZhBzWH7Mwm7Tps1ViCiut9uF9MQJ7LX7bYIyzG8bwNgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7119
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 02:30:16AM +0000, Xiaoliang Yang wrote:
> Maybe we need to use ocelot_mact_learn() instead of
> ocelot_mact_write() after setting SFID in StreamData. I think this can
> avoid writing a wrong entry.

So you're thinking of introducing a new ocelot_mact_learn_with_streamdata()=
,
that writes the SFID and SSID of the STREAMDATA too, instead of editing
them in-place for an existing MAC table entry, and then issuing a LEARN
MAC Table command which would hopefully transfer the entire data
structure to the MAC table?

Have you tried that?

In the documentation for the LEARN MAC Table command, I see:

Purpose: Insert/learn new entry in MAC table.  Position given by (MAC, VID)

Use: Configure MAC and VID of the new entry in MACHDATA and MACLDATA.
Configure remaining entry fields in MACACCESS.  The location in the MAC
table is calculated based on (MAC, VID).

I just hope it will transfer the STREAMDATA too, it doesn't explicitly
say that it will...

And assuming it does, will the LEARN command overwrite an existing
static FDB entry which has the same MAC DA and VLAN ID, but not SFID?
I haven't tried that either.=
