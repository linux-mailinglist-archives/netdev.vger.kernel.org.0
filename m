Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3543E54F0
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 10:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237341AbhHJIQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 04:16:47 -0400
Received: from mail-eopbgr140078.outbound.protection.outlook.com ([40.107.14.78]:16387
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235675AbhHJIQl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 04:16:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=am+FfgV+1ahT+SlVfwVsQi/AaoNdFm7Naah66iscLPg39lgen6otCue9t1IcuCoIussDzOH+oMRuivavzhjiO2DFsllp7N2fyCEGe0VO9upC5oA62MRH8uigCpxUkytBCGGBSEQpkCBPCNaqxq4j0dGnp3e28dKJ2Kh1iqJ3+LNsNvAD0wxmcZ3duX5ajSxfrH/RadzMJMwua9cb7h99/QwVJO0+BFcIYSLPCG4VCAOcuZoWL0uixurhlUOQogwH4MarvRQwoSOF3w7kdfNB8wYwJli5j7zmdt5ScgoMyNpyPJs18+hcDsN28WUMj6dfc1v9TrAIygU8mUwD6qL76A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F6wetzpNNj6OvNCIF3shE/JiED8NEe6USLwMO7rBa8A=;
 b=ZaHd8FBO+TCDj2xDYaynjdczaSkUxBrzHK3nF5r568g9VonvorIRjB7w9xkcuOUMKhGDPJs6r0JQ3iz3drM7NRH4LU5K3cuJU/5So+dWBhuIxZZzvM5QLk31/rT9LYTH40wfUSZHhli4vIMxdLis5pJdD7NW0Ui6gSmZgDH7DdvHLrM7d7eUQv3PrCn9J/psQp0sq043BZPZsGL/T3LWicf8RjTEtYlrsbwlUiOPrjRJw2U0NPlLXOq0rp2lQePrrwp7yK0oFLJXkPURWNNlHXrCaMqlXLlmAM5zmIVl4WXH5aL8pYs7lfRzZhjSo0IzxoIrXH55QFb/s4Z5y2Ll9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F6wetzpNNj6OvNCIF3shE/JiED8NEe6USLwMO7rBa8A=;
 b=NYwhThjuZLAOLQkSRyWvaAjHfSMFJC/htBV4xEU0owPtohpUNztgwYd+Mh7APLubILZoW8i6dZFHx8hObGXm1Z+mdaEFdd8OaACi1v4cS95YT81NOEAWtBZ0Lhq6EvkjzdxU2EM1hHLco0rI4u25ZsYMYWN4oYDQCa6O1Xw3Ot8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2302.eurprd04.prod.outlook.com (2603:10a6:800:2b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 08:16:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 08:16:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [PATCH net] net: switchdev: zero-initialize struct
 switchdev_notifier_fdb_info emitted by drivers towards the bridge
Thread-Topic: [PATCH net] net: switchdev: zero-initialize struct
 switchdev_notifier_fdb_info emitted by drivers towards the bridge
Thread-Index: AQHXjSAoM5FylMZBM0itAyPu8B/6WKtsTdGAgAAX6QA=
Date:   Tue, 10 Aug 2021 08:16:17 +0000
Message-ID: <20210810081616.wjx6jnlh3qxqsfm2@skbuf>
References: <20210809131152.509092-1-vladimir.oltean@nxp.com>
 <YRIhwQ3ji8eqPQOQ@unreal>
In-Reply-To: <YRIhwQ3ji8eqPQOQ@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e81c2070-3f94-4d74-7103-08d95bd720c9
x-ms-traffictypediagnostic: VI1PR0401MB2302:
x-microsoft-antispam-prvs: <VI1PR0401MB23028DDA52B05BB5C8300FE2E0F79@VI1PR0401MB2302.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B7WVhOSYM0UQoRsrt/BCfUGbZAay8Ve203WZLLQiMJkJ1taAaqsjZIaiPtegrm05a80UASP4zN6gca5LCVIF5s+3dLV7Jmsq/tXZDKYOy2XTOhWEQOktPrfU+Ogqn5btMilc8waBcxjs0Xd68QHMCbaWGYAc9XpgSBVlRJ4pbPmSsAHwIB4/Fqm1/KXDLgZPxXgQy5B8YtJqMX0OCV1AHMmce/OEeI/22OrQIqshAqxjI9pa56mNhN7hgXQtK4uaHw8RXEqZI/JHzaJMGjI73yj2qvzYMqIilTeq7tSpRVYsDeElQ/XOFVv1HEHmC3wTmu2+x9VhrhoENNVBj4EKNhKOdMYza0aEM8wcWZlZC6xulDgANl5qqEDeamQdkRQbN2xTRhdDDY7OMdgx+cJIUTeztO6OBS8EQUHJV/+mtDDClNPRU6TpY91nk8V/bjIcrc4RRQm9NPb0WaJnFljW/NrtpQxGOqq0loZpZos0fYU697Uw18no72KBC7p1V+Mq0EUXG78XAeWYm5EbnBZxNEQc4c+uZQ7TXZxVl4CUgYwhO6mYDtVjUUxPL0nESm2bJ/jKeWycr2KtZIKEaTqTDoBubGyRboJ/cLN9GNb3nbwmelGLwcUAZmQ5H7vT6mhCqMsMnPf7Ubn1HOIETpQBGHj+D7TE7vPxRZjJCYEyV25IzFNyOm4EXLBUEz2F0f8GxnVfn2UTKxWxtEVOdG/FrpZXYgmtbOypEMm0pI2YizK5jbPZcC94GNFFYv/wru6B6MB82dQDOIQBa93qQiFKls25iV+IyEaRwc7bNABtKkY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(6486002)(4744005)(1076003)(316002)(4326008)(33716001)(71200400001)(6506007)(91956017)(44832011)(8676002)(76116006)(186003)(38100700002)(54906003)(5660300002)(966005)(66446008)(66556008)(66476007)(64756008)(7406005)(66946007)(8936002)(6512007)(7416002)(9686003)(6916009)(86362001)(508600001)(2906002)(38070700005)(26005)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pWHW2jok8rYbQApHKaUuSd+fmQO7xlazRyVz85dwUxe7CV/UyQIWabz6/+o0?=
 =?us-ascii?Q?TIFopdW53XSStQJ1tfkiY+FoZ1vUlFjV1wYj/mHseD1rxfGX3Yd9OBqeVZ36?=
 =?us-ascii?Q?2IIyXqBQsej4n2L4tdbI8b3C2V3kAJKGD/Lp37vv/sESCMx5R8mLuA1gmf6B?=
 =?us-ascii?Q?fvPBgzB6RWat/qiW9rWUGOH+HhjLk68jCoRRbeVxOV7TBg7Rr/rF2MnSM7IW?=
 =?us-ascii?Q?lnQFKlipgFodmY0vzftY60Wj5iSBrYxiRL6JvGJa+IE+0kNjuhwmmNdm1g72?=
 =?us-ascii?Q?ZCQNO6CDXKY15WVD1Lff8w1DpCHRyif7cUeLu4cTzrseRbgGZls70UezpHRr?=
 =?us-ascii?Q?E3cA7fQbIe93bD9YNg0G7aKjh7YWmBTFVWJ5HMl+5G1ziPsNJRKg5hCdQ1+G?=
 =?us-ascii?Q?UYkFdzOoYLdKn9lv5OOP8hr0qN0VWoV8cbGTYXX3c7TfLysTy1ybNGlq6eGr?=
 =?us-ascii?Q?kukwMR3816kaiGMZUvRnSnw36mMX8N6S6/laO68WewRtuTvxqkjuXgUr39fX?=
 =?us-ascii?Q?VvfgYejtJHPxS8fgoCoSs4lwnUoT+bSysIVsRfW3QWlRTker7q9+40X989I2?=
 =?us-ascii?Q?aZmOFF8pQ57VQ/Gg/7oZ8/z/plNq0wK4N3Kdkm/e3kuXk7B3G+hT5B+R063U?=
 =?us-ascii?Q?5NWH+yQzg1Kgf04eMtnhT+61L2QDhrbX+xtLkn80UVzs23Ne9QP3f0kd/66X?=
 =?us-ascii?Q?othxX5tMLmZ/BfzwrXlZ5tJBLKR3YOHs2Ekfik8t9tKEwPvIoKIWK9kc0xXd?=
 =?us-ascii?Q?+cdMi+tz7baODRrXjlzzcXjb8MiMvs7n17D5q0X8+ZmWk036at4Vkoyy1Cpe?=
 =?us-ascii?Q?WAct9ORwoM3aswVKO0fG8ocbGPvL0YlVrrHwv95hCzSiHtlSoYHENmpMCCA+?=
 =?us-ascii?Q?tsj11tI1ulN1fY1hX/Jx94SGpiIPGcaiJYney6WFZNFGF6GEuOCG1ka2is+G?=
 =?us-ascii?Q?W+lNHf7CEb3ykl421qVpkP+Oxv2xTk+iPA0sqJUTh04fJD2m8OEjVGE7I7AZ?=
 =?us-ascii?Q?FUk43CYWUGzXPtSMicO+w6ceHJmRli2wZuQudUUkIrgGqPM5wGZ5eQSCce07?=
 =?us-ascii?Q?eWr4segt2Nzt3JgClKWaMMYGBotvFsGxFUSBGZ3XukgSbLC/G7jHgJkUdYM3?=
 =?us-ascii?Q?UQm/H/6nnKvvjGUTHVLAyg7Ep5DNTPf3GAaxefJXfky+1rQvlSvenzF4TdBH?=
 =?us-ascii?Q?OvXFdrTxh8hcefp3xl5QslNlpr9xTu96nyA8yNBtah+Nx3By+k8EEEa0kacq?=
 =?us-ascii?Q?RpOyaSbGZDTZoJ5VxZr50MILgoW0JGIGCPtl6U/OM3fEL3WcL1UhsbyBxF13?=
 =?us-ascii?Q?l/nv+a/r7q38tkFO8D5UBk5t?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <62A1A85FC8707541AD9E1BAF0D1C4E80@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e81c2070-3f94-4d74-7103-08d95bd720c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 08:16:17.5045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4i054VArNdPxzoum9GcIiHfwo5qM58OwOrKfIePjxfro1H7mB8fCuoWNLzy2rwNTUTnEU383Xzw05eFQebOxdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2302
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon,

On Tue, Aug 10, 2021 at 09:50:41AM +0300, Leon Romanovsky wrote:
> > +	memset(&send_info, 0, sizeof(send_info));
>=20
> This can be written simpler.
> struct switchdev_notifier_fdb_info send_info =3D {};
>=20
> In all places.

Because the structure contains a sub-structure, I believe that a
compound literal initializer would require additional braces for the
initialization of its sub-objects too. At least I know that expressions
like that have attracted the attention of clang people in the past:
https://patchwork.ozlabs.org/project/netdev/patch/20190506202447.30907-1-na=
techancellor@gmail.com/
So I went for the 'unambiguous' path.=
