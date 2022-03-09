Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB184D2A6F
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 09:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbiCIISF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 03:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiCIISD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 03:18:03 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C095163D4A
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 00:17:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTHUkr7rVkwWXV9JIEqSThFizc/7MGhUQbMfo8o4+DMUJ3216nvjpzGq1Dyyd5KnUwsOYso3PkKKe7x0BvD8DEH2JGILvzPal0UHLY6gSYn1vIw8Iv6Qpmb+mMfbltmfVnj1DEeAUayfkGGmRowLteqoEfF1c9oidgfisQG+07HEw7bCIUWYVRi1OtTOSn0djoCz8tatHdrVcSPqzFEC3FlV4ZI/3LC/CnTVqTCUXX040QIVDfDnJeuB8M48XqBcKb9trsFU0fj1Zk6gwxjzQhJyX4x7M4efLGw+5PFQB70/A1nEUOkJl+lmP3R3NMR3CxgNSpuMkfKXPlGVN+WBig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AQmV8oWamXURoCJbGwQYLESXg1Tk/B484D/cq0NPIWY=;
 b=QDqpPAOdMivpMDtIT3jIKtNJiu+a9wWfCzHXeLSH8jFIJuhzXKSUY/4qThXdud70iGNXT1yF3rA47pmCfdgEjpoQU6YdsJ4T1oWEyO4cCpkEq4ac62YczeMV/eQJ7biXM+zOt+wOOdhyQWnYnWcgWs496TpBO3zlFOVE6s8U9vQqWegQc1dw0gQjsM/q0BOWqSR1z3T1i5hwRshEsUF2gZ8bE1ssbz6sxDXb3h7wPV3l/PLVMQKrcm2Na/mcKUjAk3J5jbEvtoXb+ksD1PuqeD4qxg8Asf8OUEAml08eWDvJR7xRQebRaw+rT2HoBbzu1rPZn8wkKnuBuHVaPD4Z+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AQmV8oWamXURoCJbGwQYLESXg1Tk/B484D/cq0NPIWY=;
 b=bSw9yHLWslhnIuJt6Wefq9mlr1Tgd3BvHPnd6l6LPK949Uaohxcff1v7Uo+bIYmE6/A6gFIId2osaNtWl4TTTCtoXc+6xi+vmRRXLM1ybxw1i/rzOQrQ/q1OXIL8pEQ3E1V7osyDs0xMyx83MBYStmiJ1G+T8v0LtiJH1bjrRTE=
Received: from SA1PR02MB8560.namprd02.prod.outlook.com (2603:10b6:806:1fb::24)
 by SJ0PR02MB8580.namprd02.prod.outlook.com (2603:10b6:a03:3f9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Wed, 9 Mar
 2022 08:17:00 +0000
Received: from SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::f5ea:a23b:b03a:f1ef]) by SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::f5ea:a23b:b03a:f1ef%5]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 08:17:00 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Robert Hancock <robert.hancock@calian.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Michal Simek <michals@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "jwiedmann.dev@gmail.com" <jwiedmann.dev@gmail.com>
Subject: RE: [PATCH net-next] net: axienet: Use napi_alloc_skb when refilling
 RX ring
Thread-Topic: [PATCH net-next] net: axienet: Use napi_alloc_skb when refilling
 RX ring
Thread-Index: AQHYMzEqcxYqUaLWnk26kAq19h3H86y2jG6g
Date:   Wed, 9 Mar 2022 08:17:00 +0000
Message-ID: <SA1PR02MB85605D085CA75C0022C99E38C70A9@SA1PR02MB8560.namprd02.prod.outlook.com>
References: <20220308211013.1530955-1-robert.hancock@calian.com>
In-Reply-To: <20220308211013.1530955-1-robert.hancock@calian.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 957ef2d0-7b48-4453-3301-08da01a52f54
x-ms-traffictypediagnostic: SJ0PR02MB8580:EE_
x-microsoft-antispam-prvs: <SJ0PR02MB8580FE17E737A05F7533CB62C70A9@SJ0PR02MB8580.namprd02.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /sH40YHoi2uvHMaop3F7fjZ7ClorH5WVznd8loVuEbFNjNV4eDxffngqSPkcs+Qd3MJzZw7ulJpgq2TxRV1ysc3Akz7F1GgVsbG2RoPMnNT7LTv/PWlLr4ps6LxGtdBt1N+v8WXTYtbPuItSIBusk5L5yCDgC5tzHVV5eyaPcLBd+pRsvndabSRJ9igLpG0ZVwxcFsAJevHjpWFqylx1eKPFZjGQFDt8JsQY0n4DZ47Tn+kvETkvFNBeIj3voEiITqQ3q6en2oJY2PZdClVpC+EB0/RUznLmFBBPPsF14D1/oeNpo1kzC7qe0k730IVB09nQ+vjq9QVpojUYtl+8sbXvckLVS4/N7sCJnwPZ7a9USALm0A6HF6hm0eDSPZUhGkJK+/LzVtNJHqA3HNndMILbeTDcH1H43Odmold4WjEQ2ew4utAl9SerCwk9DRILdTpEpNdwP862HDTfYBrZ7DMHr/LWZ5kXVX/xRUGKepGc5hyDMHSInaIBvzS2CLoBehewTr7zvmnYalbEoq0n4BgewFiWfpq0kwvYhyCGG8cCvOHVNbmXWzIETfTfgcbwAotui6/b/oHaYNV/x8cZKRGu09gHvuk1+RDdGNu58iSVKXD62rXLP2JMW1PLSUWS77C5gUtqumCqhMJ2RB5Pqv2Jx73V+zM6alhyX2nfnFCoVB32UcGNO0GGKk17p9iLlCSTEGXLOeri4uCOLNWVEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR02MB8560.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(71200400001)(38100700002)(8936002)(52536014)(33656002)(4326008)(8676002)(508600001)(64756008)(76116006)(66446008)(2906002)(66476007)(5660300002)(83380400001)(55016003)(86362001)(26005)(316002)(9686003)(6506007)(7696005)(110136005)(186003)(54906003)(38070700005)(122000001)(53546011)(66946007)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?o6W6HMjSBSR/MKmuMBfTeEI6+hP+W8kzUGxoACFdk2wDegowZsW4O92gYELN?=
 =?us-ascii?Q?MVdUXwlPPIxHz5Xy32cZhgMJS1GEOFxG2XCxfNXnTLiZDJ68VLumcrQLHcbn?=
 =?us-ascii?Q?bYwQO56ySjGLO8G7CxzkA0M/DqX6TN2a5dRU7k0Xf8MEHfOJsi6viETe5e16?=
 =?us-ascii?Q?p+B4zFSEgHKJhBkqCEvvr0coGszTZh4ahrPVxgBpAWkv7MIG0gy5cvbw1yhL?=
 =?us-ascii?Q?aDhVzng4hcMRNqoFw4qVqRaOuQrD64Nu8iDNz22H9NvDKECbmxvAeaYAwKFM?=
 =?us-ascii?Q?2q0QUBdcoqUSw0saFiXldA/FF0CC1MOhTbdd1WW+13m1wUuyLyMkN3aEbeU2?=
 =?us-ascii?Q?sU7taNgSZ7T/OInXoZ5RXp9JK1Nx1hEBfeJlL3iSouVG2CGz7TldJ88lgvJ4?=
 =?us-ascii?Q?zZMCcCBlWSUoeDQ/1lLBv5YQLGo0nCbSrILafe7AhTF5U9vjrZN1hsgd5uyp?=
 =?us-ascii?Q?XAoMXhHdpPrWRVHCMKmmWXYQ/ABxtE/m99yNkBgZ302sViz2IrvO8tIQuGjg?=
 =?us-ascii?Q?XR/t7B4DaqiIYjc/aGiLwpH3bKnNcBopR6h43g7l7m9tLQO632VDT+QJEb4H?=
 =?us-ascii?Q?ClFqqDUc/VRZ+XGCMU38RvAtQdAAwmN/c1ezElktC2GCRepTJ7Hza0QGO5Un?=
 =?us-ascii?Q?UIQpTl4eNFd46HzvHpHJjnm/1gqDmKe9eigVgOFtc8IEx4CANVXsfHvY4443?=
 =?us-ascii?Q?ZhYiG92da0zD9qO8INFY2HtcUTP7Yu+l59UMdk+nzQlv2nAISVC2Q8MxivkZ?=
 =?us-ascii?Q?2N5X7L/frlfnMt30pHk/22Fb69fxHGbSBDmDAivOOrKWjUPeev4qH3xJHJJH?=
 =?us-ascii?Q?dlzKnuxH/wipYBqJCGR7VtSwlO0ROi962N1Y/375fHGwz9cY9IZeJs4ZSJEw?=
 =?us-ascii?Q?NJkoX6MmjuCb4EZ6/VGUgSQR9XXrorxmhHD90KFug6BjEc0TT2JpEmdfS6f9?=
 =?us-ascii?Q?lzcbJwtDDkYBvG0ukQmSrSAM2t7T7icSmOvogGoEs2IfZDdB13DpwHIHfRml?=
 =?us-ascii?Q?1FEafufdcM2N1B2YQR9tHgOhh5zJws4jcvzPab+fgoaKwEVUApESnRvvbVuR?=
 =?us-ascii?Q?aPTuaOZFAYK5lIrI8QS36CizaE5iveA5GqQwV5+sIpJk5b0pl+4qcavqWyhR?=
 =?us-ascii?Q?0a6v0t72b2Ovkt5bqSsAu7t9VYaVv4aitl/VujsNLt1senrrY+AdymGT81UV?=
 =?us-ascii?Q?zxa78vXDvveFGRzHEiPjltH4SYnDZlY21JARwFq9C2V398lnnhAdX2OtTxUj?=
 =?us-ascii?Q?tNTkBfn/6f5ukSDExcSiHPHVV2Nr34vUAmAhquEh6jkjV6xoOzKOZztsARal?=
 =?us-ascii?Q?bH5OcRSlx0jWipEGjhMbFmaL3IYudzPXnrZZDzYmcFbt9byWz2JEh0rKMkUt?=
 =?us-ascii?Q?GWacKFtEaiRRClBeYmu4Ne2TqQfdgz3/phjMT66ULcF7qnexAwRduVzQ/ZF7?=
 =?us-ascii?Q?uEP+YwO3C2iJfL/8lfjYnPYJO0703R9SAD0qz0q1gQnVP14iCmi0IRI/y5JM?=
 =?us-ascii?Q?qiRxZk4KaWn7vDQXOZFRTHaz7tjexuPHBQlsBg1uF2lwubai1lcTzXSMgdRn?=
 =?us-ascii?Q?8mHJTMF+GDX/Rc+3SZE9DWwDhMZ6aNjCSd8LgGsRQBj8TnPWCZd/wkRsQtRY?=
 =?us-ascii?Q?ZQEcfk4UrFvM8DBK8sfwxtw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR02MB8560.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 957ef2d0-7b48-4453-3301-08da01a52f54
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 08:17:00.1000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JwYADV67O0B4HC5udUAw5QVeV3mJxflo9D9sQ41ZCi9sMcYrfS7iqjtuyk4iUx8UZKIZl6x4Nroo2qdtX4Ay0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB8580
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Robert Hancock <robert.hancock@calian.com>
> Sent: Wednesday, March 9, 2022 2:40 AM
> To: netdev@vger.kernel.org
> Cc: Radhey Shyam Pandey <radheys@xilinx.com>; davem@davemloft.net;
> kuba@kernel.org; Michal Simek <michals@xilinx.com>; linux-arm-
> kernel@lists.infradead.org; jwiedmann.dev@gmail.com; Robert Hancock
> <robert.hancock@calian.com>
> Subject: [PATCH net-next] net: axienet: Use napi_alloc_skb when refilling=
 RX
> ring
>=20
> Use napi_alloc_skb to allocate memory when refilling the RX ring in
> axienet_poll for more efficiency.

Minor nit - Good to add some details on "more efficiency" (assume it's perf=
?)

>=20
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index a51a8228e1b7..1da90ec553c5 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -965,7 +965,7 @@ static int axienet_poll(struct napi_struct *napi, int
> budget)
>  			packets++;
>  		}
>=20
> -		new_skb =3D netdev_alloc_skb_ip_align(lp->ndev, lp-
> >max_frm_size);
> +		new_skb =3D napi_alloc_skb(napi, lp->max_frm_size);
>  		if (!new_skb)
>  			break;
>=20
> --
> 2.31.1

