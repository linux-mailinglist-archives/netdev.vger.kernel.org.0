Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6A74AEC8E
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 09:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241727AbiBIIeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 03:34:36 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241439AbiBIIec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 03:34:32 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10088.outbound.protection.outlook.com [40.107.1.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AC6C05CBA7;
        Wed,  9 Feb 2022 00:34:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l21OwmrrDhy0RER9T41EuzpJoG2Sf12WoNFaKKuz6MzN/I/MsrEyOcLt7RexSamtPhtXGFdVTEyWhud/nbyqslsB++3UTm7WAOBjUPw3Ldp1sz0J9dtK+ZNzpGoP35AEXVFIRgs/UBSeaWPQTt3zJgv+9U6rgYe1uP+933ZrLCRL2zZunk0CCta93pjUJkSS7Y/tFiiIV+ERxR2PlWeJBvLmg2Qbu2RQKji+2Nc/PKmUGIpv0hM+7Jj5KdM0wbKfuCIj96So4X6E/I/uXdCnX5Zh1Ajo5dNrJRTvPmSNu7J5GleivKcF+/4gS8VG3NBZCMJAYfmf5cVi4BVoz5yPdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dFUpAlubu1jL676pHRFF3mJKM9BEteYRKPXdbcEvK0A=;
 b=XUKwwW5suANU/QxHGycOmR3EEUkzL5KNWcvJK+RPHJ1r3fJygjBEHrOifr7nUB6fgZQXM/lKl/C0WfAQGgbudhRhPu5CAnILrlPQh1gOiZhXBK+bHUfJKvgj9Gq6guegW0jKY+6S5YbtfNdr0KnqSBYee39aMzdn/JbL4KE3Xf3LI3Sf9PiPpIBRf3PwZVnIeK1qnjjLURdPpMNte2/DHt5AncULmqbah7JpdML3rwzowts3FE5f0+RTBHRqHXnaog8QasM0OKztb42ZwITLWmCMqU8gxCaYwiJbEV42Ru5CXHRRwvYWBn8zr+QXrv0No2+ECe5SnojHFY/8aXdX4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFUpAlubu1jL676pHRFF3mJKM9BEteYRKPXdbcEvK0A=;
 b=LxG3LJ5XZbS2u+MNCwQxG+0izScNNZkKplnDJMyJeon7IZ49ny1U4W27q5Wx61wHC44OQh0Oapt4co0rs7wV2FYvYMib/LpoeFWTJEtkCfnWilLJSk1uup8hIgfGeZ1q140c7Yl2C4TDIcUYJJ6oLkqyd9Q6Fm8+DB3Xd+8DKfg=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by AS8PR04MB7528.eurprd04.prod.outlook.com (2603:10a6:20b:297::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Wed, 9 Feb
 2022 08:34:18 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::99e6:4d39:1ead:e908]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::99e6:4d39:1ead:e908%6]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 08:34:18 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Po Liu <po.liu@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tim.gardner@canonical.com" <tim.gardner@canonical.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: RE: [v1,net-next 3/3] net:enetc: enetc qos using the CBDR dma alloc
 function
Thread-Topic: [v1,net-next 3/3] net:enetc: enetc qos using the CBDR dma alloc
 function
Thread-Index: AQHYHXjz+3vp0qXq50aTaMzulgY4TKyK5JMA
Date:   Wed, 9 Feb 2022 08:34:18 +0000
Message-ID: <AM9PR04MB8397B65672B98DC291DCC3F1962E9@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20220209054929.10266-1-po.liu@nxp.com>
 <20220209054929.10266-3-po.liu@nxp.com>
In-Reply-To: <20220209054929.10266-3-po.liu@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 399a85bc-b8b7-458e-af1c-08d9eba6f6e7
x-ms-traffictypediagnostic: AS8PR04MB7528:EE_
x-microsoft-antispam-prvs: <AS8PR04MB7528807CD8961964C842C92B962E9@AS8PR04MB7528.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:595;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RO/kgXrVtfm8W1CU7FsrQH1h9eSSrAwI8mwEryO4wRSnI6Dj2mIdaZGeUoJSZr/eCpgLLMexW8I8WNyEbheXt8RleNBUhqxlMysoW3SPxNswAIzmE0JIm3Fq1190Vue9Cw2OIrCAHzpC49O5OA89vzjFDmzZUT77C4u0NI5uxrXwjGOBHKqsWG5kbYABh17mI7PJewM060OM2BWGiYqtWxzAck70xKYjKfUpN/IDb+e4yQoYCY2T1ftK7grSNjK5Ftnw7Mzqx3i27RteIg3rATVUzWzWoRMq+8BIxXSK6G16cVobe3jhRReyP+btrkNQN+iynZKRMOKUQmGPkMsgCqRWvapLcocologCm+p0s0GF+vAo45Fa8eQHTxOiiLnElkotqVDVR6s5kbdS45ux2HduABa4PqLCIY5LRawF0u+75dNqNWSIPiU/bUd3PQnBbJa/BcwxECJmEvxptvr/xONnHM4X2e0nWLHjR/2lcsmFUkrWe+pXhx3zVJOmEBEb2mWzDEPHcGighTk++9KYBBa9cGEWobMp9rB3JDojuW6FtJSlU+ylIsjFrH8bh7w0fIHLUiUpS1evIWXORl1vrub+sKD2RUHZsusltxTn7Ngd8wHnxFcwEIG1Gf6NgBNB8nV8nWIgb+RY+fIgM16zuJuopUnqBOgwCgp+t+ZrdQYTxAAThaStaBhgSW6dPhDFInBiRU9QSMOw+R9MesGL1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(4326008)(9686003)(86362001)(8936002)(8676002)(7696005)(6506007)(66556008)(38070700005)(76116006)(66946007)(64756008)(66476007)(66446008)(53546011)(83380400001)(122000001)(5660300002)(110136005)(6636002)(52536014)(71200400001)(44832011)(4744005)(316002)(55016003)(508600001)(38100700002)(33656002)(26005)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hW/5KIGuI1Jo/9YX6MpPMbEJRYTudkCmAGq4KvRr6O1qPZIuKKfHW55bLobB?=
 =?us-ascii?Q?Talbbyayr/zaIt7m16RiqyAUhi0qPKZeSwuy7/xqTf91we6wVY8uM5xmEqa9?=
 =?us-ascii?Q?+8cwD7K6wO8VNBBgsdaTnJyDea7baUceYZ3mUW41HMNiagTv1QiFi9pbtg54?=
 =?us-ascii?Q?/CnYQyjgsrwsSdB25Kja5dRI1zPHJIeMbgoe0h4joBZNaeK6sgHa/3h0D3cb?=
 =?us-ascii?Q?aYvcHEcb8BjJaHOp9BgaQ+sKJsoWbUByYgls9LaMfuE3xrHFYfM3WNh8n6Tx?=
 =?us-ascii?Q?wS/b1imXHCPhot5GRF/xm909PfSEJZPRoz7Hj8kBOQ/89e+6eoIYmoY+8+8S?=
 =?us-ascii?Q?30wRGiVT848T5Jk5iwTOjx4jzsnqdQ+3E87vrWhTgapux6Oooa+hHCKxaBYu?=
 =?us-ascii?Q?qJFYDKqtL0SodqcA6pJQ5Ks+vrYNJ2wfcUNoF/bu63/gR6kwxa7oVv357Szr?=
 =?us-ascii?Q?IQ71HwHJ/lsS0J+IByaLIifsx3/97zo+Cynw8F7lkjQZtuhrQG35obBSLox8?=
 =?us-ascii?Q?Ri/Q8xQdLSk6JPeOTTa5Sem8uwn8YHDTYa3pwDa2RCszQV7RAdF1bfl94C0Q?=
 =?us-ascii?Q?xGKu+9uZnkTtvY/ZJt//npza+goHm05dJW8gZwHLT+9HsU6h6vkpvkbUn1Zk?=
 =?us-ascii?Q?brwqwRjd8AJumJNEnnYO1P2exYyAl9/+40UVELa59lxv70rTaT/Ya1pdkTVg?=
 =?us-ascii?Q?Xbv7XN6H3c/nbrl0RocycGrvU/dQROp/72VZzMYZUnJ22ZfhCA5zgs/R0em/?=
 =?us-ascii?Q?4NIBDlUT7HYoomDleTCTgH9An73rk51nRvBZVY5o/zKZIVWwilBF9vejl4H3?=
 =?us-ascii?Q?TqTqBvmMXJjdWJ2Z1n+PHZywJfBpH9kZHoyHLyzZXKZvmH812hxalqLLAK0v?=
 =?us-ascii?Q?ILJ/C4ELtPUSIjT5ouTyiCVPpuaGSyWXgc301NRk1OsyEGGMEIvAWivnzhva?=
 =?us-ascii?Q?aJhSP6sPB0GReOxfuImlNeHvSgwxrqbogozAEIHhN4M7OlBM+459fpetTZdJ?=
 =?us-ascii?Q?cIJEJsBNFtQ73g9OFa673D9PBmtiQnzWEJ2O1jcXbBKK+ekvjva5FJO/RrdB?=
 =?us-ascii?Q?tA/XqrH9LHmTVq6gHLycSQt7aBYL4ykMRhPCcvAPByhK8coCLbXozeKOe8It?=
 =?us-ascii?Q?15PEckyOnAhvQyG2h7kSOmo3HjtdPCju+s8VBMKA86yib5UVtMMR5oYJKeoi?=
 =?us-ascii?Q?AJWh3YZ9ebiIyayGil7ubbBVjZtXFAlqNjREiOb2EnDhI1uyufsNmSu7HBSq?=
 =?us-ascii?Q?9hCh5yK/SiBrM9BCR5yt3/rFs/oqNbdB477ISNhK9Whi/7RoXFQZUlyT4Qyd?=
 =?us-ascii?Q?YvXrcElNE5eiChqP7hDyJwFEKVBG0FC7iJbPJMQFzkqfjtlkKTSxhdlT7Bni?=
 =?us-ascii?Q?zfrDVFnCepcdqtaX7yOfAfsdAc+SzvZlygWQBF3wcFIYgtMnBwqWHOvn0TKq?=
 =?us-ascii?Q?ASiLro7dCL5YR4o4Bw8p7v0lr7nRWH50fhuzyLZ5ERV7GdGkJTeB6cRRnNQb?=
 =?us-ascii?Q?zMOLbNb/1XjAdJknksXhtReOaG5pgpBLRYeytECkJnVwNToIsdpnYMJRFME1?=
 =?us-ascii?Q?wDDXFDJAdpIHbfmSjgDaW+gX4y3u4Y8RkqOD2/B1e1HgmhjUZIAa8/t7aK9c?=
 =?us-ascii?Q?fQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 399a85bc-b8b7-458e-af1c-08d9eba6f6e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 08:34:18.8488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gknsb12sAJ/T2UkOlAJzLAkaJIDuiADO6uKomupJl+3gFcLhd9q1fiN3T/XonGmcSfO3hmzvy9Y/mQmqvbctlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7528
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Po Liu <po.liu@nxp.com>
> Sent: Wednesday, February 9, 2022 7:49 AM
[...]
> Subject: [v1,net-next 3/3] net:enetc: enetc qos using the CBDR dma alloc
> function
>=20
> Now we can use the enetc_cbd_alloc_data_mem() to replace complicated
> DMA
> data alloc method and CBDR memory basic seting.
>=20
> Signed-off-by: Po Liu <po.liu@nxp.com>

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
