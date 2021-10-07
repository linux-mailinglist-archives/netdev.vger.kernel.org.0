Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EC7425DBF
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhJGUnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:43:33 -0400
Received: from mail-eopbgr80088.outbound.protection.outlook.com ([40.107.8.88]:35200
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240647AbhJGUnb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 16:43:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/z6NuMMLuZ2g/lcI5hfIZ5wf51bEDR4A9ocaXJwbQqOnlCuoUBiTU+FDtLHgl+B0el41YSO4JxcTFte38SdFtVoUoPFWfn1LhF9q7WcrC7NfpnwmyILd0sVQiXTw5xL41vUggF1QH2escyXB8y7YlNWOBXqXqQeqLJaXmCzakm6DPS/INxEDVuTNvbxTruopi3+6yTBdn5t9pUe+9nq5rrVizN2DNiiWa00J0erEKSclGRtXiI2/Tzj9lozLRxlUlL48SgRNO0PFavs4sx6Lpj7UYqmubczr5DvTxyHzsPy/axXlwFNVPpu4DiGHu8EeEQPdNPZQdGFrhOvACYlYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9TfSxHdyuzrOAnJlcYAIZHTuNrUxIQTFDvLO7/Tb+9A=;
 b=V2FMu6mqhoJF3S8VJkFubJxIahwrnlxW+aY+4hDqDaT3ZU4sZgX/RFMVDtHdla4h68RYY9ToyMLgjNUwfSWQyhxKJKerd+IJg3PmG3sFOa3ZCn7DfHgDGWE+sm6kSRZYan25x2YzoJq/nbFTJHD0BjIj9BXRXYrZ9rxq4AGRJbLAC2Datf7MqunkMs3K6Z+3cBoVTK7GN9ts9LDbEQb4AFI6aWqrZ4zb4KdsmNU2MJoOWZVKf1fU634ji3+c4sW3duOUffjDAWzc85z0YyOTSCFqvD4NunUww86XgbtbFRspCuT7eIJqbThpnoWExGK0Jl0a9KOEMgw9q01mc/Dk7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9TfSxHdyuzrOAnJlcYAIZHTuNrUxIQTFDvLO7/Tb+9A=;
 b=gAr6bZtnYPvYBR0xmlMlsJTt/24Zy90tYGou8OaRjKg8CtCy167l1RJPPwP3WeNXNWj5UIqN4nKtpOXybMpuZGqE5lngXGq+gKXrGI229V4quuqiWWgKD9RI8ucpg2WhlHAnY8LM4V2NzUyqldsZ2Mbq4dYfhjWVxvqqYW7G9nU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6702.eurprd04.prod.outlook.com (2603:10a6:803:123::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17; Thu, 7 Oct
 2021 20:41:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.023; Thu, 7 Oct 2021
 20:41:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH net-next v2 1/2] net: enetc: declare NETIF_F_HW_CSUM and
 do it in software
Thread-Topic: [PATCH net-next v2 1/2] net: enetc: declare NETIF_F_HW_CSUM and
 do it in software
Thread-Index: AQHXu5BmSqPCVvNz+EeJlaHlrBnQpavIAE0A
Date:   Thu, 7 Oct 2021 20:41:35 +0000
Message-ID: <20211007204134.y5ppnce64top4nm4@skbuf>
References: <20211007153043.2675008-1-ioana.ciornei@nxp.com>
 <20211007153043.2675008-2-ioana.ciornei@nxp.com>
In-Reply-To: <20211007153043.2675008-2-ioana.ciornei@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed701e66-1efc-4ced-7f18-08d989d2daad
x-ms-traffictypediagnostic: VE1PR04MB6702:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB67023018926E74CCEB4BA2DCE0B19@VE1PR04MB6702.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1yJl+hz9yh98edReIXtclQxGz4dtxvDIOqtrPG8bwO7V2WzL5NyddDVLNz3DRT7YDhG0WlMXtfWIIwp+MXrqI7cFvS7E6M3Ar5azq8zhMs+e0Bjfbtwb3CEjkMqp1lMw58ZWSl6FSyguz45NKxmpjN9QYevfF4SH7Y1jT8YmehpbigY87vihq3bMnLo7hUtQwltJJQB571O9c7P/tLMrA/afJCmzayLgYTfCYcTY/9bAgioy5JWFi4Xpx0cxf6g8nGn+iP0VLUbLBcGkXUcjMkk7FlIzJFfAG2rV2x8K75l4w65hJdNPbwEKYT+FE3m2W/yd08Vvf0pF1QmH3BdrU9N8srcaRU+soRNZ1S0rlqc38E/CYrxqnoHJcxH0qUJGKjkSsg4BqqApxGdiu7H4SV0KpU/+QwdAT8qqzAjUCyOSzXMl2KNSc3K6jMGVZJ8y4LI2ikS8aAJmjW3pyUqts17Jq1hKSfs5B9oK874NKb5AqxhVxBBYpgmySnjJoFEn6AzMVb8+NJi7TrgHSFe8wJHg3FhKSNCNTmTi7ng6QzeFNbKVHv0QRM3oKtpjjbSR+S6J66ZYuZKUszKJuJjjfkbjL/anZ41LIqlii9JvvaxgSFYyorsI+hz1Jy3uTbXyKVUr+0dmfkDXWo59M3NovkfRZ0UtTcTRFx/6hls7XUHjXfFUNUIrJ8/V6uzRfZdXilVmkxekY6vh/cedeBuHpQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(44832011)(122000001)(38100700002)(9686003)(6512007)(26005)(6486002)(6506007)(66476007)(64756008)(66446008)(66946007)(76116006)(38070700005)(33716001)(66556008)(316002)(5660300002)(6636002)(4744005)(86362001)(54906003)(71200400001)(2906002)(508600001)(186003)(6862004)(4326008)(8936002)(8676002)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ssyRbOIPRSopr7GrMWpg9CNnzVqB6nX4Q6uhOfjTcMNPD2fJh8B/Z6K9rG6j?=
 =?us-ascii?Q?STNiXVb3yf/P2rBZqDHpxDtQO3grMHrAGQl4IY32hXVsSN0Gl6qsjjAjOD5i?=
 =?us-ascii?Q?jajuOx9LcVl5beIvAn6VpUQ2vM5KLCKIekSDlNDyO1Ql4HsVl/KaXJFTJv01?=
 =?us-ascii?Q?9V5/GuRmPCysbkjQLl/cSL25wlVGJyJNRa9mdfr9lT1WT5T24ECdpmRcClTa?=
 =?us-ascii?Q?uYV+oUSd/NvJkJGJPtLsX7GX75pm2xxGBT0FOGF8rDESvIhYOAAJ4/fVXDGH?=
 =?us-ascii?Q?X7SW14Hvh9F7oekj5M9OSXbEXTOVGkv6SPqXgCjkLeQ6IpLW6XOZDjUmkryG?=
 =?us-ascii?Q?4XfdW07EkbWaEiqXj3MGqmWCA5XIGSNAMJJoVXcBYjPf4ad5oJc4r8FC1uLh?=
 =?us-ascii?Q?XcepxxRYc2xDMNEw6MdaywiqpN1EO96Uy4n72NL+CE715C5bBz3WQQchDMX+?=
 =?us-ascii?Q?3gIT9M2+UQw5VxZPQyLIPAHz6Fvpuwfn69o5UcYiPAHq9BwM3ZmzfAevcFDY?=
 =?us-ascii?Q?E69mAxJrMLsY6eZ1HF57wJzrZZQNG5ODcFBOVKOsxCeiOG2Sz3ItBq7Msl8U?=
 =?us-ascii?Q?i1Cl0pznhbXtTFWwAP9VJqUqVgYkKnVbR0xRubVy29dSeIX5vzf9HU6Es5HA?=
 =?us-ascii?Q?G5mzEp/2oB1MhcBRAz74Du5o1WnEBpOludZZ4VxUAYqnZWYqfu1eyuBpkgUk?=
 =?us-ascii?Q?nNvR41TM3tp4dSro+onI5SUl2AyVztI/OHlfPB5G9ZSm3ClwZ0gn5QhzAwPa?=
 =?us-ascii?Q?rVhc2eqEcz5uk7C0B8LLpQq2Fuq6vO9eu52bTXPTbWh94DDNK5QCuTEQfcYl?=
 =?us-ascii?Q?nCaFn4ctnyCy/Ywqhtqthv8+YqRwELE58LDOcZNowuPUDO4HNuDx2zGjE4sn?=
 =?us-ascii?Q?TVZ5OiuY8q9kxcMOllQeSJbd/Ni4z0aFXRNETkuteGccRTFfRnHIoQ51rHX/?=
 =?us-ascii?Q?b7B0+d6M0kTQDtV2seelqxCCJ5uhFO7ttbtUte3BKgwF+U2XpvJ2bka4c9Pg?=
 =?us-ascii?Q?+z23f3NW83C3gnT/yPqYxVZPRG3yv1yF4wMZoSmGemJwGqPLxbdz9EyGHrjp?=
 =?us-ascii?Q?uQso7j4AeotT4FG7xud7/vKDmhCRJnxFBPrfi7mFXufMAdr3MJVtZwDvppd1?=
 =?us-ascii?Q?DKnaOgtRLlxcKvcMt3AVBVd90y4eOK4W6WZqlAVCBSsBBKj54LGI+l2fjz/y?=
 =?us-ascii?Q?pA98NZIpandBi++dvDv/w6OqwmedjVPB+BMLanjXJdF/3qdD0YqG2Mqz/kJA?=
 =?us-ascii?Q?Ignv7mS4+35OR7Sedxai2lIaif/yjpIoZODQU5mPemPkAKhEKlvaZ7l1cg2F?=
 =?us-ascii?Q?ScrJas7lHr7szjsl+nsgnWOnse27BTZHctxT7/SvjAoC/g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1CAC90641609154BBB5945DFB18DF9BD@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed701e66-1efc-4ced-7f18-08d989d2daad
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2021 20:41:35.4136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tu6kDCfYHhy6ZExxJWlWAhbH6CTb29IhnMv9/QmG0kuLpP0dSUiI9IgNbBSP/uWxfMYxw71O4JgAzm1xnYhLcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6702
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 06:30:42PM +0300, Ioana Ciornei wrote:
> This is just a preparation patch for software TSO in the enetc driver.
> Unfortunately, ENETC does not support Tx checksum offload which would
> normally render TSO, even software, impossible.
>=20
> Declare NETIF_F_HW_CSUM as part of the feature set and do it at driver
> level using skb_csum_hwoffload_help() so that we can move forward and

The comment is still referencing the other function you were calling in v1.
Anyway, not a big deal, in the end everything ends up in skb_checksum_help(=
).

> also add support for TSO in the next patch.
>=20
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
