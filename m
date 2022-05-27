Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860CE53682D
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 22:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353283AbiE0UmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 16:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbiE0UmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 16:42:16 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2043.outbound.protection.outlook.com [40.107.20.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595C11339DB;
        Fri, 27 May 2022 13:42:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AWFH+8tTnuEBwQrR4FAkFWUfNAQLioe/qOwbnp+UYmzQ76OZRZR8250NxdFLhhWfs41tO8pP97PLmyikKNzAs2r4aViAyVywg8Y4yGn6de/5f/nXhzbTcFD9njZRr+bZKFyqjnz7GwJyp5mKzP2mxnZJZD1RNh2t1hG0sv7uUqFFpAsfj64oWSaVem2FhNIg+v1Zh3ggO9kk66iECssig0PjOgWilK2M9myl+aWxBpxfVj6M7wZJ1/Yo1rqRtRf8/2qQxnm6/8nq+5p5rOPDGP4lCYguwZUt19RAtTfwO/qol6GwhMYMlVyoNSi+f08cTVpxZPU7/+QO5L8Kay41Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1b2XkXYw4I89Rie4stqDKtZbgCuZPWf7UTfo3V1mhGU=;
 b=Jl14DfJ3PlgbrUoRSsIBv3ojgYXZvJIct9j/0O6L84yn8pSkiy1oiAwVUz79JUG0T+GLM3/9/FfCu9Jx2eouyZf/ByTVNgAzmNuwQTG+bIzGszBBeyipyeIuv8NTU48saoNWDlcZe+exkqKlELVM+oWeTOWx4R+7snzHU/helvVhUtd16ZODQADnoPzgj697FG6/pAo+J4Bb7+9cgTux90gyqweGkitjnCps3JRT+3rm92FClkqtu9hM26aC5wdRip2JqJGuHs4fq4ssAx2P+BWgaDTl8r5NMJxnBzL4TpHCtGG/c3a8skcbHCv+BThZet4vhCIoYtTTSE9zwuuprw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1b2XkXYw4I89Rie4stqDKtZbgCuZPWf7UTfo3V1mhGU=;
 b=DABX90j5CqNLVEoCJTQ26Op1eFR/Oiy6PYJR7/lnGqmF4ptSaRA+LmygpbLNZ2F2SdwBilwdbUbDDDgWyQmCA79Np9fkNKqVIvRD27vjjOtc2c/0HZIoVqEO8cPhJwqDkB3YiigwZ9yXkioDtkRWxYozgxXSfufapePYKjRcGPA=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by VI1PR04MB5742.eurprd04.prod.outlook.com (2603:10a6:803:e5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.22; Fri, 27 May
 2022 20:42:10 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::fce9:a04b:d506:4e12]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::fce9:a04b:d506:4e12%7]) with mapi id 15.20.5273.022; Fri, 27 May 2022
 20:42:10 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: RE: [PATCH] net: dpaa: Convert to SPDX identifiers
Thread-Topic: [PATCH] net: dpaa: Convert to SPDX identifiers
Thread-Index: AQHYcgmrfMnMMeviZ020kaSZX+Llj60zL8sw
Date:   Fri, 27 May 2022 20:42:10 +0000
Message-ID: <AM6PR04MB3976A11AD39155C07706328CECD89@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20220527203747.3335579-1-sean.anderson@seco.com>
In-Reply-To: <20220527203747.3335579-1-sean.anderson@seco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c872b01-2c7a-400d-0da6-08da40215f90
x-ms-traffictypediagnostic: VI1PR04MB5742:EE_
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-microsoft-antispam-prvs: <VI1PR04MB5742C08FE0A5BCFA51BBFC9FADD89@VI1PR04MB5742.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GlBS9QLoMI9YwFtkeWam4okRUVHGzNAnbb4kFszzHwt9kP6n7dVUBYXmlf4kRJ5Gi2kPssUpv4lvi7VHf0TTFRFp0RtrMllVPqxvUPdm0EZ1hTPJIPrwJLmq4t3upqDgTbB6++TzOXPJiAYSF8mdYr6UoSWoQLuD0asGB3bE4DTHpz18tY2Pghi92cO4IB4dNDzr5gZ39ycVc3yMhtsp9IxmM+i1XLZdOSixDQl50t6mkBNmo5Btqaro59g4dzcCvHDXYLz1kI6ccs6CblJGQRtJPA9yieENPirbu9/p7f9y9roou+HyXYrANKcVLRj4MlhQtmD8SKyQhtepDorkGgGvVkBwz+hdGsNm655JK998AVq/bqFwpcEGZGocm8Rwn1/s4oVwE81aDiOdkuMSmUhfVg1JivtNRBYPWmNYSHk0tM8UX3HUR3PtY6J5T0qoBgqTT8BM+S1kByWkY2zi4ZwSYiAtQhpv8XO6kP2igjQd1bFlwgRLN3RMZrCZfvkE8NL1SB2w0BZuGqL5fazlOLrh6oYGfPNX98E++/fllYLw6nxCBIo+LoFH8Ud/C05/pTGLcymVYC7XTKXx9+E7+cebpz17fQMxz0x5H2FstLHXJlpzSdoPbr6Z0/v1rq/wfyq0GB02aL1lYeknl9suyOS2Sj/joKs8idoK37OVclPnRXS0E2t8ghn24lh471eapvS8Xg7KLo7kozEnreB7tg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(9686003)(186003)(52536014)(7696005)(55236004)(86362001)(5660300002)(53546011)(2906002)(26005)(66946007)(76116006)(66446008)(8676002)(66476007)(4326008)(64756008)(66556008)(6506007)(8936002)(122000001)(4744005)(55016003)(38100700002)(71200400001)(38070700005)(508600001)(33656002)(83380400001)(54906003)(110136005)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nhQEsWRuYR+m4AbhPx7ZXRI1w3nyf2UddG4rOQ0uH7NMtQ5+/QkHiK0cOATI?=
 =?us-ascii?Q?RwCKDEPLAuK5W0SlCfJJcAG5zmJqFjMNk6TloQUK3/ygNZ6msVhC1bbneo4N?=
 =?us-ascii?Q?pIpJdTmx1KrNC33WZL2SxWR2z1uyHl4gBwAe1F5gnu0XY8dhXCDgialEApc+?=
 =?us-ascii?Q?BxsgogEojwQNTrAbKYXK+fvZ95Ve4ayxuGBs5c1GfrWhoBb02nekqTkPonxu?=
 =?us-ascii?Q?a90H1p+yNxwoQQ6vKa8ur+wmG0uZQKP1eo6v+ZGcvHWgyFoU+rUpWTHlpJuc?=
 =?us-ascii?Q?LJWrJr4CQPndb9IvMC6tiKN+xCpMQ1eytckT19GfoWcQFY1L7Pfj17lXIWWO?=
 =?us-ascii?Q?9UfhiXej6tTsHU1KAv9CORF9igpMl3H3qoVUjaNkUJ+PkP/DO+4c/grpDvDC?=
 =?us-ascii?Q?cV8OeGA3yuhXVfXEXRKV+0eMFuUV3W0rsW7k7ApNnP0eQMKEDBu0iPaXrOKx?=
 =?us-ascii?Q?4sA020mxwZjzqIvKyeMNgr/48tBf4tZixkPeq9JB1gVzZdZ/nJHSB53LbWm+?=
 =?us-ascii?Q?PHE5eobfANwCfgtmoSjvptFg8TpO87VsBB+lL4JFpXnkjy9pNci+ORKss2Tb?=
 =?us-ascii?Q?hYKhg2qYpxxQLB4tRVl19VI3UocftOvt7j50jTwe5H6OzvRpbKewXQdKEucH?=
 =?us-ascii?Q?V6TeFqVRf6ofCYV6cQMA0Ry8HO94wTj7kjGnACgevSXvb8YKAdcnR7L1Giaj?=
 =?us-ascii?Q?i0UuWLHVV4OX/Tpco7fU776Le8y+GxpfPehHHC8RfHhhDB+l6Ba/CSqyc9Hh?=
 =?us-ascii?Q?igLFDma4DnCHTz9lzm/wPaU+/ennRdruA1z5sWT891GiH0Ii6DEPJRrxG38g?=
 =?us-ascii?Q?U74Cyvabsmgbx3LShgAmfk8Z3i7WUwj+BcRmheNDWSVCJZzHtTFlymDMnHdi?=
 =?us-ascii?Q?Er0SxdhwfpHFgImskoiykI6zzfUwD1qI5uiajSt7KNuLvBLwWNUR5iZCmA71?=
 =?us-ascii?Q?5ToJcqnAjh526MXe9HABYQ6PG+6MB/sdacFTysA4ZE7heGg4xJWD4ecKy1BS?=
 =?us-ascii?Q?49C7lm7fLkHxGTO8W6UE/NVMvrzfaiQu9wu829yjimEE3jvrjMLI1EIyYVjR?=
 =?us-ascii?Q?xrSzGUX/t3pbZfzB7qP6mBYtwsXkjhpRtamx2kjgz2PeF3sWXdcBK1z7hZNR?=
 =?us-ascii?Q?W4u1qitW8WoTXUQrF8io47Aa0keKhhczVVy8+UCSca0w/aJCY/QH3UWQsOLi?=
 =?us-ascii?Q?KQX2vZs7fctBOS7dItoCWiINd3u1uK5pnZJKluAQX0rLJpvTfpuG4u4QUt5/?=
 =?us-ascii?Q?caXWZe0jPatb0RSyv/4ePyUpmGKvq1g39Xt6RCveMTQ53bcgUYmNy9XNuL6U?=
 =?us-ascii?Q?uhPfMTE8tcQKd2M6Uve8rmJCPO4jA0Hu/QvxQ/Iz7x5ELH/ND71gtB3CMon4?=
 =?us-ascii?Q?FbT1w3cIcdIsQoyiUN5YGrYwYjcBejxndVEgWF2nd4wrXT4uJkBSXIIgbbsO?=
 =?us-ascii?Q?Y36nqrrHD9QTzhUoLNjp+G/hccpGl2S1Cf9Kz6vNfXfFqa4MugJHkUadvifu?=
 =?us-ascii?Q?Q2/pCpF9rsFKoYnD4m5ViPrk3qTDM/uDy9VHQBdn6DdNty2BGE31Bw4z62de?=
 =?us-ascii?Q?KY9nX+S/SmUBvwa8/w4H03Rs7TGEl5Kzkb+B3FMpAqYaQVIjfivvoiZwYuAC?=
 =?us-ascii?Q?kqxFbBgkqKs2QrFDweFEEUP4hojMgvzzblI25g1KGaF3C5qr+ooaIN0jSpk0?=
 =?us-ascii?Q?bSfLrV2ldfVuK7w6v8334heA15K0bN+34zV57k5Tdo+NfPH8ceJspUthU4N6?=
 =?us-ascii?Q?h47FJCkXPW840aphMcwZgJbUYhacvv0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c872b01-2c7a-400d-0da6-08da40215f90
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2022 20:42:10.7252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U/OMGMPN8HawxHplMqcmPkqUPZTBJup4+/XyNGbGCHOwPTG2lSoy0YcOC8AT96bGoUrOUEJo0+1JNdY08Ghfjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5742
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sean Anderson <sean.anderson@seco.com>
> Sent: 27 May 2022 23:38
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; netdev@vger.kernel.org
> Cc: Madalin Bucur <madalin.bucur@nxp.com>; linux-kernel@vger.kernel.org;
> Sean Anderson <sean.anderson@seco.com>
> Subject: [PATCH] net: dpaa: Convert to SPDX identifiers
>=20
> This converts these files to use SPDX idenfifiers instead of license
> text.
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---

Reviewed-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
