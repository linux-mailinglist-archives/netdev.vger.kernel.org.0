Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7426C425FAC
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 00:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbhJGWMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 18:12:46 -0400
Received: from mail-eopbgr40088.outbound.protection.outlook.com ([40.107.4.88]:10054
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233180AbhJGWMg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 18:12:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZZsAQnJMRq6AJNs/a5sxxzpuiqKY7cN0XML41/8uz8g6oATourZYEwvuaTIsxa8tNkqBFSEHyorwaU4eF9avXGu0xyFnQcMCp9f9N1TKobxo28PTCCMu5f9OTBGvZEQmxl48xDBCB/3DSWmTLv+Yd5M1pIQIMVE2RU1+yBVTz7GTZaiqrXwYd0t2jFlls3N5Lv9Q4C+WQPayrKzD7iMof3Ap1qMfnXIS/CM1tP71GuS4xFvTUn291nmFzyrsmVZv0Bkyvc65kE6iCzqCmtgIeP6sPiwUReOHaiwkD5980r70ZGbWb3hqxzC8jpKb1K0F1Oo8SP+6AMuo9YBkwuNIZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/AkwGiSlndd+9DmgXPbM0PKqdKOQuITEpjebEAXlrg8=;
 b=MUpNgWt9WBPERmVRqNL3Frkjy3JcoWsf902h02rhBL4Tyu2wNdF/V4esC37TT1c97nmf8lelD0gzwjUtcwnkUOZxi82T/sS0gLinen+lewBcySOZNjgoRI0ehNVUns/2fd0nbyoEVcHvmlF2EB0PBFvna5W1mWKTSA2BW+gkL4beoOOO3nI3VMkKBR5b7iNML+lHlpCQRqcADQ3wEdyGulHSYs6TV/shCx71LEzCgKJ/BZXsGUWZkoZsI8//T6NTKjmo9uqq2VYEXmioxNvOnS4Ur4i4s5eAxJZBXD2+oEDAx5BoEeOz3L2VkJfq8GpdYQbTAXuTYyELsJftkmviKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/AkwGiSlndd+9DmgXPbM0PKqdKOQuITEpjebEAXlrg8=;
 b=O1Opv8xOwNVNRGoAq/MKbt/HUbbIiCe/72INKNT2mG5D2jjWGn+WPs6vfO53z6fKFegHQ/R6QWPYVlbYQ7NAj39zxljd865Kh5ghz4Vvq9Ygi16JzOtjf+B5sAjplj9vkfwlkx+nKY5cNQoKAq4HlHqbdvNOq539ETwFpbCncAw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3549.eurprd04.prod.outlook.com (2603:10a6:803:8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Thu, 7 Oct
 2021 22:10:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.023; Thu, 7 Oct 2021
 22:10:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH net-next v2 2/2] net: enetc: add support for software TSO
Thread-Topic: [PATCH net-next v2 2/2] net: enetc: add support for software TSO
Thread-Index: AQHXu5BnZVWnShh3Q0urNRO7fmaHeqvIGTGA
Date:   Thu, 7 Oct 2021 22:10:40 +0000
Message-ID: <20211007221039.x5gyjcjqc7xl72mt@skbuf>
References: <20211007153043.2675008-1-ioana.ciornei@nxp.com>
 <20211007153043.2675008-3-ioana.ciornei@nxp.com>
In-Reply-To: <20211007153043.2675008-3-ioana.ciornei@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c26516d-d5e6-4008-c9a8-08d989df4caa
x-ms-traffictypediagnostic: VI1PR0402MB3549:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3549B61A2F4641F98929CF0CE0B19@VI1PR0402MB3549.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +uyXU20X+DX20UUWebCyVNlwP90ZAZnZi21aT9GXe/zxkwGkzrSX3ApOoXowgMLO+esPgiQzXdHq02UhayeCyWnfMdOaoYbHMS1TJhfUuGS/kwFRXQAcPsNVwLWNRereWREgIno3kDj+JZbWFgnSob5SWyHtY0j5AqRU+jU6QKQkXGwNQMbDK57ozbmBRcewhZt3AROIGK6c5rxb6Z5dyetbHmni6aaapqnJa8BZVfckJPjDtsR8GryCpZx0HV9DPI3gq8XgzNN588/ZeKT2vL0Z0RgnzvvOETOQ1hyFrPF3B/ZKyZxfmi/tAhy0KEWkU+mINftqX8w9XDzr7KJ8Y3WjVuivCHgOAQDKYbrGRHpwApnvHL6Ym0wm9lLpUgv6OsqSPz/vHF2XKgLjEAutxNS39QXcxOiNUuLiDnIAwF1aytddOlwmQ6KW2JZ1VHZ5j7SZNWnLQB5v05jzp5TBM4EN6my16EO7IV9X5/9NxlJlDEQNmlstp2xPas3wqujHMJheMqFSUMnx4m44E2PX7tFsW8I6EDQo9gC+9pVvWlYn3gOoHViBWsx6Awwmg6aveunZI+lGdOPQGyDyIsgS0VF/oHmZTZWBWxzRLRIqDv5Ap//o05jJEyrdNdxkTQUC/cJVPiwfgF5SvTUMQFxcCC/Wrg4yfEpfzDkU1C6krtW67Pp9FcvIi/+LH+YREDJ+d3scUgM2pCl5Im39YUWXuw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(71200400001)(86362001)(83380400001)(122000001)(38100700002)(6862004)(316002)(5660300002)(2906002)(66946007)(1076003)(6512007)(64756008)(66476007)(38070700005)(76116006)(66556008)(9686003)(66446008)(54906003)(6486002)(8676002)(4326008)(6636002)(6506007)(26005)(508600001)(186003)(44832011)(8936002)(4744005)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1Qyi8IW8t5ZUMjt5/KveWi0v/XuUF00E2nY4sBUyZ/7zKJLUbpmsZmAWanW5?=
 =?us-ascii?Q?5D/UrBnx6Us3sKaPlsAWsanS6ZBfpqtfHVFp1HOHdnVPD28p4BO8ucEokwtC?=
 =?us-ascii?Q?t9CTOobtDUNRyFjyXRmJtSZ6eD0ojY4q+rgZ608yHAATgfVCMXOLKDw5bw46?=
 =?us-ascii?Q?cPBUJ0rI3y/ulwZ9ASiApEI98irC6k2Zm6GDTroelwR/PGK9HxpNGIXW1oJe?=
 =?us-ascii?Q?TP7pOaQUB2Y4je168lbGumEnBLiKQSZWFEmNfJaxNK3ZtZy6fFUJtiFlpK5j?=
 =?us-ascii?Q?1YXxxPAWVNmnfDOS3I4gnq2lRGjiwR+aHG9AX24B6qU9C/1H/mivmPfpAw0w?=
 =?us-ascii?Q?J0KZ9XRQpDa2eAk+OlsHEpq/N+LwemXp8+viorOa+eSExm5cS8AM8iV/sdT9?=
 =?us-ascii?Q?urWTic6Dforl4JUMSqo97D/l0soENbYy0u2lkYc4DKFa16gvN81LqUsrSIPZ?=
 =?us-ascii?Q?jUmcVb8btbaiELgBDog9Ep0urLkdZtTYeVmogzsj7iF5Or9KIyZ/HyG5v9zu?=
 =?us-ascii?Q?1/+KQJ68T6fHw94KtjYPI2t2o9AzoagWSIk/g17KsUbQLH/X1who9J63uZDM?=
 =?us-ascii?Q?NFnQOXx7jzlgkYa3LB0ZMCeag3aC2E+USxYixEMrv2S2hhmA9wZYaS9bQ624?=
 =?us-ascii?Q?A3jVOKauJYOGo6pAnjWeNfU8kC+BZh/GsoyFAsEs6OyOUqBKyYBY3AadKOpM?=
 =?us-ascii?Q?ZwOHIO82Oe44WejfF43sswlsh+8UCPA48seQD/crMUjLzlmWQJ4hLyg53jXO?=
 =?us-ascii?Q?KsCHyugKdwriCZDTN9V/NVkMUsakrL2+G8fdBRNDVgTlYAaDC2P7hZsZsQdu?=
 =?us-ascii?Q?Y9irqbJTDCsESnGw4Z/U0WAeIg+YsmBcnQOh8xPbhmE6DvedsgsrnR2iaCHW?=
 =?us-ascii?Q?ilIs7zCrcjRfdCT1CeDDcIj+OmjarWCUaCo98dCq6VcpawmU9SetyMwsR/gP?=
 =?us-ascii?Q?woc8Mv0iNV4wVco4C2YV7GWksABh/V/mA7KBqUriLiiRX7FWexNcat1xcyt4?=
 =?us-ascii?Q?4tZF5PaD1t4iZg+kifQl5J6vh/DlyT1GBjFKfd8qtRjT8pJZkjSdeOxFTO9x?=
 =?us-ascii?Q?XjXFSwdfCo4Prf8Wpqm7LHsg/Ry5MTjOE3+8DmJYUOFg7GUImfbyAe2nukuq?=
 =?us-ascii?Q?51g7+IvoCD+IQYv4xVx/BZpJ5o8xIEhpdC9hC0cUNMb2lq3Xi1WSnYxEGxkN?=
 =?us-ascii?Q?h/TjMOQ1U2Ir5wR8gwqIjdKhX9B/x0zWePNfc/1jg1DZUet5f+Nol59aKua+?=
 =?us-ascii?Q?WxofsUNobDUQIXPLlBExcbn+CBcI8jSjL8vTx2wrBK4HcxjdqBlmh5rKuhmX?=
 =?us-ascii?Q?Sznqln1I9j4tOmzZSCRFSdXtOqE0iPZX460VYxtU45YegA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4503FD7B0C11204F92C6CE532304D947@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c26516d-d5e6-4008-c9a8-08d989df4caa
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2021 22:10:40.5230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xmq61okhwPShlVd41HIBA0GWhaD51wjMUa55d/8i55EkCGsxY3CpxKFySsZVAR8SaZiRa08N07eVnNY41JCxiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3549
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 06:30:43PM +0300, Ioana Ciornei wrote:
> This patch adds support for driver level TSO in the enetc driver using
> the TSO API.
>=20
> Beside using the usual tso_build_hdr(), tso_build_data() this specific
> implementation also has to compute the checksum, both IP and L4, for
> each resulted segment. This is because the ENETC controller does not
> support Tx checksum offload which is needed in order to take advantage
> of TSO.
>=20
> With the workaround for the ENETC MDIO erratum in place the Tx path of
> the driver is forced to lock/unlock for each skb sent. This is why, even
> though we are computing the checksum by hand we see the following
> improvement in TCP termination on the LS1028A SoC, on a single A72 core
> running at 1.3GHz:
>=20
> before: 1.63 Gbits/sec
> after:  2.34 Gbits/sec
>=20
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
