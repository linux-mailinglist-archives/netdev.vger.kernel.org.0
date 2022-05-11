Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE8EC522E11
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 10:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243436AbiEKIRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 04:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbiEKIRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 04:17:51 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2040.outbound.protection.outlook.com [40.107.21.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40495419E
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 01:17:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=asQFJtgdKtcxEPU2oQD39XHLo6ZJhh6/3g5WI2dFpKyLi6oSpNsD2zv+5oJOMlBggGg+dpKYcALMeTZOR8/R3XFdSd+XnE7OzIIqde6bzO8yuoMJBmy6rvB5FvJ5EDyx9xPxHtypZPjJqWd5wg10gJHLmf60vr3oBfuChdUgjRGdDADAMcoaK4wyEoD0UdipYCM8ypiS1VSP4kKXqlBAy40X8TVsRnfFMGDsCT5LXB/P5G74zBYsqyizfKrOfi5d8SXM+Sa2/tEv/zXlSOd1qCWm9wCi45EMo6P1VSdULkuJLP03y8EvwOq0oK9Uu1Kc19rIhzsBa+GuT1TV18ykaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iWC0R+Q0JJCijkmp7Qa0IybfDoVI78v3wzT93h86ndo=;
 b=MQdbtR3TF6yz7xARMNqV4AbjRh1myldC5ssUHVHmfTWlD09lHzyriM0cUsF8qnjtWmt8nqSJlo6Q7umHk+T/3MRbjfKat7lMFG11SF7dtwrqUUmqm/OGrxbnduwk8c3aOg0VpdslyXgIFCx5KBTz3Pgu1S9H00f2J6kkvIb6ejSEnU/z4SUnQbG+geu5aEXaasSaSXWbFQpbzcGrXQYFM3UXbplB23ctWpExOx+En7U93Mab9y2FirgGo6GgtiWl3/2lUcQXG6pJISLD/Bspk/hLGkComBq2wU86gcF4vm/xfNwLVfBbK8NYXrlToDZdUEDJamrn8KlNbPgRwhp5tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iWC0R+Q0JJCijkmp7Qa0IybfDoVI78v3wzT93h86ndo=;
 b=PzDKCPa4CgBmJoUHcAppYWYhJYgbVH8a04vfvvy45OmyEL7A0k/gbi/rNmq6vMyewEFuro1qIYyWqWeIk2dPI8eEPtl9DI/iEeg12GYaX74w4Ea53Oy1jXiNBdv2LFhnJG9/3CM0fyWSYX1vNr+pejmvN2cjMBD+9vz5ofwagNA=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by PAXPR04MB9024.eurprd04.prod.outlook.com (2603:10a6:102:20f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Wed, 11 May
 2022 08:17:49 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::951b:fded:c6f6:c19d]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::951b:fded:c6f6:c19d%8]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 08:17:49 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Michael Walle <michael@walle.cc>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Po Liu <po.liu@nxp.com>
Subject: RE: [PATCH net-next 2/2] net: enetc: count the tc-taprio window drops
Thread-Topic: [PATCH net-next 2/2] net: enetc: count the tc-taprio window
 drops
Thread-Index: AQHYZIwYvFvw034zdkWDP7CDu5MLeK0ZVShQ
Date:   Wed, 11 May 2022 08:17:49 +0000
Message-ID: <AM9PR04MB8397D4DEDFCE75487195762A96C89@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20220510163615.6096-1-vladimir.oltean@nxp.com>
 <20220510163615.6096-3-vladimir.oltean@nxp.com>
In-Reply-To: <20220510163615.6096-3-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c2309b3d-7ab2-4bc7-9be3-08da3326bc90
x-ms-traffictypediagnostic: PAXPR04MB9024:EE_
x-microsoft-antispam-prvs: <PAXPR04MB90249F1F97254239ACEDCFD696C89@PAXPR04MB9024.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jKhI2bhemEdG37nZgEPM42Q7touHFwHO+Bp2x+OlQ8XYtmE2vHUvclh9d0RiB/5lDMO3vYHKcLFDJZgs2lSQRg1b9t7yGxtjO34iD6kl0C9MEm5Cyr6ZTfwco3Ui5Qy8Tn6dcznNjHXsKtmIeKF41fNeK5dkU2W0DAukxFo0ARZxBI01cZRAX/pUTa8wcQ4C3xg86BAuNGn+4Sf8kgfm5P+1nGiFtCw23JMANysn/Ll3jMr8LPGgYB8AmJTUDDEhws4agPvYAiGgUxaw2Nurqd8CdD49uTP7HyP5FCBbAALmNWDY7x2wBObJR66SAEwKKZy2NAyBKS/rEW921ahAxgHPFyGdNQt1n7bEEBv6rrkdwNkIOOsybPOvZFpIOcX0SdDR2fp/d8x+V8x4ugGP/41sT1Aeg2cIVTqfJ9bHsmvfDwqqXGNEpB7AE9We1XlhvGMDwTOiaxQ8E6VJaZ5EBvJmnBZzppYu4T45Jo9GqaAteavFhAO/WN9hqR3Xx2lUL2BONdfbhah25OLGWAKDRmR1Pg91DiZC89csC9SmOo/EACH0KwCaR8XCNkj3/hDeOB8Msm0DAEScYYGJRVeARX314rNw/jPyFeQHemt1UWFuzMG7LjMotqVSFnlBE1JAJN3Gb8UFmfH1478BshVG6MAIseYC4t8EJxPe4LcLpoZvbfHEeBLxJyaJKUXmnhfgMV7gYn0lcrTbaQtY4szc8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(71200400001)(7696005)(6506007)(53546011)(44832011)(9686003)(55236004)(83380400001)(26005)(33656002)(5660300002)(186003)(2906002)(316002)(122000001)(66556008)(38070700005)(38100700002)(508600001)(52536014)(55016003)(76116006)(8936002)(66476007)(66446008)(64756008)(8676002)(4326008)(86362001)(66946007)(54906003)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rScRjLWb4txzFHZiqXJxWpwnzbkltU+JrUeLCO2DEayyS9QSxT1q4m4NrlOk?=
 =?us-ascii?Q?jhYoa1Ccoj+6J5YqRTmgTEnC7PsZG86/NXUq049a1Qv9UWuV9DFreqgC5j5s?=
 =?us-ascii?Q?lfuIpC3rOdGabrvVaNy8JVxPtZxBjb9fsuTHVpJiVpwp7mi+gbE2PGmiDbUd?=
 =?us-ascii?Q?cgxgTNvAjmRkIGkJCKnbj6k42Y+9JfAkP4Vd8sxsz6FwL14OxYI/duQYRUTX?=
 =?us-ascii?Q?a++0/ej+2LPArTxD+lF827mdnW4QTfcE4Ck7E4IeEZTWYv7awdulQF36wUMn?=
 =?us-ascii?Q?Eg6Vp4WNwo9WTgJIlpCdcoxgrEzpENf/G3b0KAFpClEQaJjwCaA+eTWHTMyl?=
 =?us-ascii?Q?VTZwaiLkBDK/VPoKpDJCse2xxxFDvGIsMmovvZCptjApuKdmZl7eGLKFQCtT?=
 =?us-ascii?Q?YgSIQTVg9hhKgHLSj3oPu/9LiS7E4tbCxAUWDI9bzvS8oEmsH99GUFS9f1zX?=
 =?us-ascii?Q?hs5poplgNbQpL9xnM1B8TfV23SXrEAiXK3u/g+kXYAUD2WDgSmXFCLGCZ+Pg?=
 =?us-ascii?Q?m0/LY6ucuo3+xWsU/awAqhECyVUgYzR6IIG4WOU/MdK/6hVkXY6FVP5Khv/r?=
 =?us-ascii?Q?GVE3BMwilrkCI/1yRtM9VNWmWEmvttsOvLN6DsPzJR7i7TldaOcCNnktutnz?=
 =?us-ascii?Q?K4PiLwHpe+7+fzNFMNBF0ssvxYV7Q2hKoG5PuU7Z8vtbgdRq82gCecdSBDzM?=
 =?us-ascii?Q?txjVMC+ptF/ss9hH+apwOExzprB2q9BtTa4poUU/wVnc6WdvoaR9Bnpgc4fh?=
 =?us-ascii?Q?SQrqOdUsWbtffLW1YsfMxv5l7uBKDHWGf0UHnIXSHWfr4kzW3/VV8rKuo+a7?=
 =?us-ascii?Q?bu3f8oGIl1stSPxOWYJaHnnWdUCGkALOc8gtze06qg3hIdGUMLybMuaNm028?=
 =?us-ascii?Q?ZJ5vLN2urYbJ3O9FVp8yM7sF4btODA52xtMkJFJMjX6S6CYvS5gKfqgCftkv?=
 =?us-ascii?Q?6UuUXUY3I+yUYjol0dY6QOhhA/OyRPEesrjuzdIMCMUHAtEfoHJ+Ah1JCpUI?=
 =?us-ascii?Q?aTs8XDBAwQbNfuma6f8g6yC8x4YdAmTaHBXOHxHLWgIqi98Bpr895rktS61K?=
 =?us-ascii?Q?he3TPxGv7sKPQutzF7L1qGb4JN+/iXlaL9tRLpuPc8zwNf9rq1u2by1k5EFV?=
 =?us-ascii?Q?H5TZ1PHDt3fo5psVDHi7iRgVYVTLqWjM/4I3CXByiMV7ypmVWPnn80B0EmOR?=
 =?us-ascii?Q?FT1Tj6Hw8IYszzcO/9/5JXEMFSp5qlScFl1XAdV5zvrZOSx7KMYHTJ8+lASc?=
 =?us-ascii?Q?RlRPKLAV6itWJxVkX5qseV3mW1/yIo54Yv6gcffd9wTnBnOlB8vkxWRFxirR?=
 =?us-ascii?Q?4/lpwJ2Q81oWGbQ+vLSyKnhUj0/COgSAomOixpLFO74gwcRjQFcz/KmFotKN?=
 =?us-ascii?Q?Zd/l1Rp6fBxXrt5oKxft5uYkYl1xLiDtk+Mkr0nfRqng9cFsrin7RkA8kxes?=
 =?us-ascii?Q?H9jsoi2HSObK1aVVvzIqX0rNU7qXuWSv8EomarjUodnNOneTjuE60LU3yVpf?=
 =?us-ascii?Q?xM8c4Tvi9K1+W2+oLF5NngOxV4YEvO8sz+pTElWdLKWan4YL+AHyAmgPJV93?=
 =?us-ascii?Q?GMHH8Jg+yfRLJY14RWgZ2xatWSdL7aHCPt810JjrReWMloPRxplzAYmPhTz3?=
 =?us-ascii?Q?lIZk0ueUzcczlvMSbvEeWA+KEkI7agYlulb1iH8PVy1bhKDAlIm10M2Mlxd2?=
 =?us-ascii?Q?P2kUAk9gFY9AjP4pHdoayFWb5jf7GTUEylGfDyFCFul33os8BqBrDY0ehvtW?=
 =?us-ascii?Q?8JN5NQwK7z7vVA+1yttGbrtK04ZmUik=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2309b3d-7ab2-4bc7-9be3-08da3326bc90
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 08:17:49.1245
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BLU3kWuG8Z8XAJcTOWKhRoErBBQuhMDrFJb9scoimhl51l1Z2z1Z2qPGU28jBb68h/nAHEU0URklU8RTqg8EnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9024
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Sent: Tuesday, May 10, 2022 7:36 PM
[...]
> Subject: [PATCH net-next 2/2] net: enetc: count the tc-taprio window drop=
s
>=20
> From: Po Liu <Po.Liu@nxp.com>
>=20
> The enetc scheduler for IEEE 802.1Qbv has 2 options (depending on
> PTGCR[TG_DROP_DISABLE]) when we attempt to send an oversized packet
> which will never fit in its allotted time slot for its traffic class:
> either block the entire port due to head-of-line blocking, or drop the
> packet and set a bit in the writeback format of the transmit buffer
> descriptor, allowing other packets to be sent.
>=20
> We obviously choose the second option in the driver, but we do not
> detect the drop condition, so from the perspective of the network stack,
> the packet is sent and no error counter is incremented.
>=20
> This change checks the writeback of the TX BD when tc-taprio is enabled,
> and increments a specific ethtool statistics counter and a generic
> "tx_dropped" counter in ndo_get_stats64.
>=20
> Signed-off-by: Po Liu <Po.Liu@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
