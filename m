Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2E664D41C8
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 08:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbiCJHZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 02:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240066AbiCJHY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 02:24:57 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30089.outbound.protection.outlook.com [40.107.3.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167775AEE8;
        Wed,  9 Mar 2022 23:23:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVCsV8PYkjKvCDNeIM41TB7oUXapSR/EcWcjSLMiOJ5eTTPAe3nQ8l+uy5WzdYHc6CR2ieIesfppTigfuAi9DKnEV7GsuFD7T2X+DIqll/Q1Y906zaOyj52bYC3QYD0jIPuAdoJlz15ok/hD5iL792KJ1uMfoDkUIRAq21KwFOYqtnJVXet8adBnn4iVVoCCy9QL1M8i1WXHKurFIt2hGAEDfnpvRFMXe8oklOdGs0aiffSqvpahzXBHGmom7Y2RR0ADa40liDe6rQxh8xCddV/xLCU3HHXio9HQscSLwiJMzGJlWELDOu2AhLgGCE9sADqo7DDLOaRL94vt3wJ8Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SLpu8HmjCbE8lcWyUL8S8u1q7AJnLoZgOVsJ2Ebg3ag=;
 b=NlxeIK0wjwHhH4Qij/R4ufBGOSQoiHzIeLP122iVGGeGHQtOMpdqC74LxYjztTNKPMXZr1cpRMeYDJnEi3x0oxrE+VkpEGIWFA+yYI5sc4wVyBL+Qxsj0DyqQa+D5p/m/wr4rH5Vc+ZJqHf478NsUS7ZTSliTQxa/T3B6W8rqDqp590tjukTOIH9FXqY4bvaH+AeLS90ZVbkPHrQa/b+K5twkVu3TejEhx2DZUezyLjO4o22kg4oSSFNQNFIdHLWMT3yZu9Ytt3gGm7AKiw2xPUoZ67RvFJAyqd6H3zQekmeRnkVP2kTcGK9+u2EEQKFMaqgX9LMmZYi28UftflxCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SLpu8HmjCbE8lcWyUL8S8u1q7AJnLoZgOVsJ2Ebg3ag=;
 b=cv4WuJ9M7QwQWY0gdDp8PQ7gmrgn3mmssVnUjghNsDColCoM82JGOyVfwOq+JhbEQsKHvu+gwKmf21/T+qURjt/I2YsTHHPWK9ih8jiBt1h0WRWkYbf68MXb+tYg4jViC71nNR9lPckryWef9vA17xPgxK/+sLfPJwXCzsjk00Y=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by AM0PR04MB5268.eurprd04.prod.outlook.com (2603:10a6:208:c0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Thu, 10 Mar
 2022 07:23:55 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::6c00:1ab7:6949:b79]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::6c00:1ab7:6949:b79%3]) with mapi id 15.20.5038.027; Thu, 10 Mar 2022
 07:23:55 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Miaoqian Lin <linmq006@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Y.B. Lu" <yangbo.lu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v2] gianfar: ethtool: Fix refcount leak in
 gfar_get_ts_info
Thread-Topic: [PATCH net v2] gianfar: ethtool: Fix refcount leak in
 gfar_get_ts_info
Thread-Index: AQHYNCGtN3clJ+D1hUuog5ZVB2MFSqy4NvOA
Date:   Thu, 10 Mar 2022 07:23:54 +0000
Message-ID: <AM9PR04MB8397C4159072C82CD99895EF960B9@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <e68aa1f1-233f-6e5b-21a6-0443d565ca65@intel.com>
 <20220310015313.14938-1-linmq006@gmail.com>
In-Reply-To: <20220310015313.14938-1-linmq006@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16ff4231-b2aa-4223-d5ea-08da0266ef42
x-ms-traffictypediagnostic: AM0PR04MB5268:EE_
x-microsoft-antispam-prvs: <AM0PR04MB5268A744135597E1C038B184960B9@AM0PR04MB5268.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IKNx3w7Fomm8ooN58WW8SfH/akxCAG5XcUq9WNgmLSwTJxIn/BU90w9S33YwsmRSiL8wGJxZaopsSHcj6rzCyEDl9KrsOEZq4dgfTv1IqV1vJ2xSekSwjawEyPoY4oR0q5LZ3nr+NhSFMz1n6y4OehVbwD5oxooyyvn+XTjHlB7bpq/1Q9Bco7/COyl/g2iWsl+G1Dsto+SGz4lMirQT4ltGXt9xEmdf5DHQrNconhY0AOu6Sz2NzlNl2XoPvaz8mja2NLsb/lM8BbD4ek0PNs0mZ4xnxDQw+uOU0KARVmPntMCGjnV3htCxOSHHlgny16K2lI+yL+VN2hDo2qlr68XqCl0BcUJ4bWbP2qUl0fI+OZFC85HpXn54UytB/3fFzTkng4WTQR3SHU0R1ewAhieBOLpCvY2UFFvzYekykYOC2K14nDsnbv1iup/w0l/m92LxH6OYksa9WzPUTa0hbWwlPdqUtcb5rBs4EvjPPsmy88ibBlUa48+MbgjZiJcb4l2CCsZnrqC2HbVXY16FqtSeOEjda4suXZWKjT6UffO27HAmmHXKsGmy5U3bbSe1oTTMSLcUZ4esytquDwCK40LXZT/q1Ho0u6iy2MFSLqiiAlyKgEYgwcTKy4cliOhxj2m2suT9VZJ6qT0/6W9Jhjrq9KvHewUkHNp1bDd21kPHfr4Ih5r8veRKYDKWkR5u2ZhOuGJmmuydV0LMNZZQhQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(86362001)(55016003)(110136005)(5660300002)(9686003)(66946007)(6506007)(2906002)(7696005)(64756008)(66446008)(76116006)(66476007)(53546011)(55236004)(66556008)(8936002)(4744005)(33656002)(71200400001)(498600001)(26005)(186003)(52536014)(38100700002)(38070700005)(8676002)(44832011)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?a/bKKP85lFYDufIGqmKInUf9570uwt7uyOOuRAAyQUJxi+AGkt86GwWVrHsy?=
 =?us-ascii?Q?UZwOVuF2ucwMVTB8gcms+340+oDLgqOl8ycSmye2wYEbh0NG1tAj68RxSC6R?=
 =?us-ascii?Q?itdzJuLM7/eJqJqgIGPj7SH8ePyl84GyayMmGiEskG1ce3H2Lm1VnsVsRgRA?=
 =?us-ascii?Q?VkCvClMYE+8DkArYE+YN5W6rCQP+Im89thhS+c28fQ6y1kjSwukO1bvHCpJl?=
 =?us-ascii?Q?lpjB6/W5q6KJe0B80eydbfIf66kP4j9fAy7Hw10ZFQHzBPMerfzK0dSLv3Ue?=
 =?us-ascii?Q?6SkkRv3tBM77+zbDtCi/vNl4ht20ZRC+2J1obzf0rcMGnSxwCY1nsQ8xH/du?=
 =?us-ascii?Q?wGgdV7Nhmi2pNEBZAbeBVxUiAwva5FIVxWy11nPY3LOa51tdlewiq6QJRPMU?=
 =?us-ascii?Q?i3PfhpQZ7yViIHCL/7GkJUPMqW2iLzmY4DnMLEIjgmrGrfMQUMm2uihr18Ak?=
 =?us-ascii?Q?3pECpRBdl+4Dqy7jCNQ6cpyAsnzkGPHuNYk1JgWBRc3p7qB1/c6fx9wN/cKM?=
 =?us-ascii?Q?sVk5Dtw+P18LH0h/RC+gnRiWSL3Cdot14HnIzwtv+e8Zm4Yv9T3ZnKFB+6L9?=
 =?us-ascii?Q?vpqmRm98wkKLy5Sa1S2M6HPuFk5a3bsoTMHiFu4h5HIUwWzrKDGVEqrzuc/L?=
 =?us-ascii?Q?9So72OuahuVwxxpxlClMQE7j+PC6v0vdr9hTDBDxJu+Lhzbr8joBOmNeTwe8?=
 =?us-ascii?Q?yxAumJyyqL1j/fe+JXUirkIUSq5xEDOpqxXo37NrOEFILE09WTolKxGR1cPL?=
 =?us-ascii?Q?CDBOSjVj4Bcb9Fo8YqeS18thHDsXA5O0LKlMg2vJSDACIExPc2oscMKJwPCI?=
 =?us-ascii?Q?mcYF31td7PEejgzk44KeVPmCQ3mgP2ChYzHn8g8Hfa5gMkzCFa6wNKN3M2fV?=
 =?us-ascii?Q?H6qeNpajBXmzUugOsLn1sawF//Y+5aWvTwy6RmWR5yjbjmXj2q4keje/5gpr?=
 =?us-ascii?Q?inrbLQY1FMqLWGDVubhqRpUOc/3Cao264KUz7zZGDy3hcOkh6kYdWLxvjB0V?=
 =?us-ascii?Q?q1TLcW+mnT6ZdLlyc8HidQWGWS3aR/CEKE9HNLiIIt5oLlBi0BOLzBL9ahyv?=
 =?us-ascii?Q?+3Sj6fhBtSmz+V2EqKAaaNglAFOXXh4OrMn534bVfkk0UUNbg5B2IfWnC0wM?=
 =?us-ascii?Q?hW2DadXPSfIIyHMrL89Ze75EoK5UXzF50JbuLrxnyDGikdbNncQXz8lQQwqV?=
 =?us-ascii?Q?iAYU3xLaT9iKp820QpMNjbcseug5jZUPajD+pTHozPdSp7ZhFMZZqkUOfnyV?=
 =?us-ascii?Q?ilRBvZGfzBzKVtdNhY8dJAUYGjS54IBrcKLlbmt8qSFM/yUQkFTXKwmzsDFi?=
 =?us-ascii?Q?AZRFybncIPvlExP6xQWBsmo7QPuKzo4vp2suy5mH5jZYRFjbDgJE/gaL4RFJ?=
 =?us-ascii?Q?WaeE3QL7sZXrgFY4VtctyYmC+jS+RZJgf8CXfXFCk1SZbMALnMNnBSVrE7zV?=
 =?us-ascii?Q?WuSWe4nhUrJ/q4+w4+V4V9u/inlk1urY4Hg6ixJx9hoC1lm08FfCw+zPXlTQ?=
 =?us-ascii?Q?L06Ms7cY+79o0wBJqOuNB3xbC6Zwi/1AmGtZit7ZojUGXlQSa1L1uppiFjHq?=
 =?us-ascii?Q?QUGfCg1wW+de7gYIEE3cmObSI0ICcOZOgdykd+GJW0VRKkDMxuIzIkjNm/2g?=
 =?us-ascii?Q?ekEpJE82WBxv980MgQ7qkg4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16ff4231-b2aa-4223-d5ea-08da0266ef42
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2022 07:23:54.9463
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3UK6MUASn5Rg1hkMZ6RA1ior6gLH7MOBEEuksPItKPu2DE6HqT+MwkUG/zIR5h/0QKhbGAQBnSEWhy43pNUjYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5268
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
> From: Miaoqian Lin <linmq006@gmail.com>
> Sent: Thursday, March 10, 2022 3:53 AM
> To: Claudiu Manoil <claudiu.manoil@nxp.com>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Y.B. Lu
> <yangbo.lu@nxp.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: linmq006@gmail.com
> Subject: [PATCH net v2] gianfar: ethtool: Fix refcount leak in gfar_get_t=
s_info
>=20
> The of_find_compatible_node() function returns a node pointer with
> refcount incremented, We should use of_node_put() on it when done
> Add the missing of_node_put() to release the refcount.
>=20
> Fixes: 7349a74ea75c ("net: ethernet: gianfar_ethtool: get phc index throu=
gh
> drvdata")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
> changes in v2:
> - Fix the subject
> ---

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
