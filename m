Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F635F9F73
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 15:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiJJNdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 09:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJJNdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 09:33:09 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70074.outbound.protection.outlook.com [40.107.7.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0937285E;
        Mon, 10 Oct 2022 06:33:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OgKWIQ3rL5VlpFDxMUS8e8rHTMS9yBqwjvj5bZdlaVeQWFgNg3LJ6GhO6/lgNovarY3LI6lg74WCGITiCQBq2YJd/zF/gkp5l+1HybWHVH/MojQIj1d1GFRr1gxp1hfi58BjRIFV+oeX5fdcd8b4CfPTrkZfs0QHheG7HoPBHhRKr75bqbfa/nUaYl3DT6tfLyYI46/fkIodw2zTk4/vNy9n42Xrqf+Ap8rjmDBh1S0y8CMM6ueqANnBwj8qDmsGEZuog4sla8ix+N7mNdqHZPluKdHrElpZYMP50qwXB4voRRVLeselsu7+jCpateUWh4CGQ9r7HthZ2JskL+lHvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xhRFzTXvip2vF5JTEw+sqhSxuqM5YHGmOxWgMmQHhEA=;
 b=k5b3IfD7k4BY+9E7QpnmFt7mRCzHP868RB181KpeS9eBtT3CJSabqjldNIccb1WeE0d8vVx7DMIpR1lo1lgWKzHWfJTNO3v5l36H0LMWXjxvJbcJm0FNavGBZDFk0IhAcP+VDYmw49+vF11nH2In2gtHoDyUz//bSf2Qis0XyNh7gC4HR3R1qHr3UetGeZMoKwog7FvKMdIETupWIal5o7SH6WOE8IZhxUvlietispwojFMb31tW8d6S8t4jqFoj/I4WFSHFO3c+BIjGPxqCd1mXyVUe0SmVGOyItTX3w4aKJ/GOuMFv4GkCtqJ9mJmekfDhimCFZXSP5shEmVvsZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xhRFzTXvip2vF5JTEw+sqhSxuqM5YHGmOxWgMmQHhEA=;
 b=bXnxPYOnxpAjLL//9Fo5uggbTQtc0J6HS+B0fXTDbL9O9s7BUAOvUt4xRe2kxIx930mYinald0l4oD0H1b4aEiHdj3Zx73nN8oThZlWI7n4kAPWUrIK28XhCjOEpa61gpKAMPWYw8zD2iwbfyYQg6RWIcSZP5m77NdVECSpHDyA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8994.eurprd04.prod.outlook.com (2603:10a6:20b:42d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Mon, 10 Oct
 2022 13:33:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5709.015; Mon, 10 Oct 2022
 13:33:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.4 17/29] net/sched: taprio: taprio_dump and
 taprio_change are protected by rtnl_mutex
Thread-Topic: [PATCH AUTOSEL 5.4 17/29] net/sched: taprio: taprio_dump and
 taprio_change are protected by rtnl_mutex
Thread-Index: AQHY3C3VH2StnHVfxk6x4hHuhzC2jK4HoUuA
Date:   Mon, 10 Oct 2022 13:33:05 +0000
Message-ID: <20221010133305.rh34bkdsp5gi36kt@skbuf>
References: <20221009222304.1218873-1-sashal@kernel.org>
 <20221009222304.1218873-17-sashal@kernel.org>
In-Reply-To: <20221009222304.1218873-17-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS8PR04MB8994:EE_
x-ms-office365-filtering-correlation-id: 935b5c15-72a6-40f5-c00a-08daaac3f686
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2a4zQjkfHud2wF01NFbOGGg8N3dTH62mHQIEf83Xvexzp/cK9dFcLNLjQo0nifIbVyXqjj6sIjCPoEhEdl9rLC8zkB0mUojUlRcU7Njufzyqp4lEaeFh+j6p1LPA+kQT+ERbQzjp+arxe40eYXruzkvakuzKVBrYJc9jfUMagMbOIxZAXwiGvknHH5M1Q51TJOTFnWRKp+m5E9dju/ADdLJaYM4LdyTFHxC6poqu3UtAC1WuzFjW2PpxbPoNPGmdpiUTWOmqNRNaDRSIBhnoU3ZMlZe620/4k4yYBYZEJhTUIy/ritScxp9+2dMUJqb9qjMMscjMPV7JEjAT0Buy8sI4XblRrpIL8gvN6PY+XoksWVrfp79rKgJIqnbllTFcMj7H2QPPLO2xiH5VWOgxwwp1phk0w8OVpyrXao5lt0YL/s/MMfOCLnLIxWwO6HuTlaG4mewIWUHf2o5iyQAlJQl/sQdVKS4BQZD5sjnoFcclMn+dczuo7ggI8mTKobhN0BKw2OBrrfelggfFTw87it3gkKwO0aw6pP3NdqzyuBbC1JVEN+Zfb0Y70Sd6H5jzPJKymVyfG3GQaAHzKZtm84ed/BaZnDuiCKWaf0aabqUG0We0DQJNJsbyBqQhZsCHu2dW5T99VIlVMWj9wlcs7DiTJ7z59OUAzB00yWSXngYTc367/L4NlmvasO2uGMkSqIELeEqbdH8sPbmwwvy5KPoNHy1F5enxy4NFfybMEfJP0mv2xg2QHHUkUCJybvI6UwmELkY93A9hpABZtfqJqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(39860400002)(376002)(366004)(346002)(396003)(451199015)(66476007)(38070700005)(38100700002)(122000001)(66556008)(76116006)(66946007)(64756008)(4326008)(33716001)(66446008)(8676002)(316002)(71200400001)(86362001)(6916009)(54906003)(2906002)(7416002)(8936002)(9686003)(6512007)(44832011)(4744005)(41300700001)(5660300002)(186003)(83380400001)(1076003)(6486002)(478600001)(6506007)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yfnzrJ73S2jrFnwWFCRfJcJj1LWpyx2bygm+Rg/i4pBI5dBbA84rkRe8Go3t?=
 =?us-ascii?Q?l90rQO42WrWcRiR7Dp0XhPw9aSXbhyNKj/hwQOcc6N3ZvBNn0g0GqtW4PyMk?=
 =?us-ascii?Q?qO7DM0VvK/wFHY/Ywu0chAkd9PYkpF+cWX19PwsmVKqSM+9fDnVpF6gqP6Po?=
 =?us-ascii?Q?HkVGBqdLlaj16s19Uegz2XQEQRM9U/jMR0y/+3TVGzdkWQ8eY17q1LFE41hR?=
 =?us-ascii?Q?rMwfnuhIjbLrHObE7dIjowZXoaxfzVti/dMLraADeowbBaWdMaCM5zultD6t?=
 =?us-ascii?Q?6C9Fh0eLoSa37c+e51ufrwPo1GJmNdBG/5ZcyMbIoGoTKy1dmuyrtOeretHP?=
 =?us-ascii?Q?LxzeUEfQusCLRfWO7fN9MLOafX08H2GUr5/r6XFzSAko9Md/pUU+3Bwq6Sg4?=
 =?us-ascii?Q?emPHsENwYXS8tbwcULECqbIK99B+3nET6W3ljaHJ3akovYk9syGt/+7HbIFz?=
 =?us-ascii?Q?BrxJcfyCO3BUu7ZT0rTUTplBnI2IrVXBucAImaoqKl91Rbsv6euDS/BaJj6I?=
 =?us-ascii?Q?zDyFqnW1xSlCXk/cZjgKIupBTea95H9//DxZWXFQjGNVrtbyIPI4bgIRTE8H?=
 =?us-ascii?Q?v3m92/t3SCECv/KM8klm9GOtxa9Gk+EHdncPAig+9p8jjC8MG8HVTeyl5Y+W?=
 =?us-ascii?Q?gxxMjdvxuLQUFWrL9UpY27horEaiHavtFyR2O0SbxWIEtn9JeA1Nj6LBYtXT?=
 =?us-ascii?Q?uULj0W3q8NeqTYUArXcSxdEI78Iz14ooIyDWZbnnZp6Sm09yVLVGz7dVe19q?=
 =?us-ascii?Q?Wn6C7oR6/iIWBSI3c3vOF1ZldqA9IJW53BWw1CW21ElGWXFZ9fsM2s/vEeQi?=
 =?us-ascii?Q?VYQZMs0qJeXzXrFaa2H1JWudDfPhfjbd6nv+LpRm8m0kZWXWUxgnwQhwRz2+?=
 =?us-ascii?Q?n6taolnh5ar49erY7T4Jq0tCEBsafk0ue4W1UcntLD1SUH0SwwBZ0g+rb8WP?=
 =?us-ascii?Q?LqeQfug+DINxSkhBpCJ95dd6fjhLMej7XctqMks/gijMguuHC66dYx5DzKZH?=
 =?us-ascii?Q?PMw0ji//nSp7O/YFTBgE9zlVJlf/bvKveqB1zGA5HDvwcD8KBfUKoXvYXh8j?=
 =?us-ascii?Q?tnPdHkQ0UmNfw3YNaDgf7pwZNOP1f//meFxvbgGyfex6YM8jkHOPNDiT4hzG?=
 =?us-ascii?Q?tLmeoHhSUh+wIYQcpVhyhFlWFsTUOssb2nJABzCLABmLirZPWRBr53UjScIP?=
 =?us-ascii?Q?Y/435KPKUycZvqEp9ZOIklejXjbDknuIDs90Pr2QCqCKeYgEAFODp+MWTyEA?=
 =?us-ascii?Q?O8KHeRQpOYrfDGV/QHMzV0qmJcXO7ZBH6aY9/28lxXuFtvaQDH9i1K8sl67M?=
 =?us-ascii?Q?QSnsZS9PJ0uXgwZQWv44cacTdfdI+wo0KxD5ZDj5KSGSIQ5dHQDgfb8SJGoI?=
 =?us-ascii?Q?9ttCqFdAm8v2d6vPj+oXdRVm5LogNa0VGS/m37cjYHgx+Zm+QTCiXHgfs6Ya?=
 =?us-ascii?Q?DzLyPZocJs0+fl4ZU8V0Uk3ZfBWQOCWbRInQCrpoQiIl4+T8qq8Z3hRD7JD9?=
 =?us-ascii?Q?DmIvZMmImismYTvSqm/EBPcg5J4IcnXfmWafJKy9mWfo7QirCZntILy4IuvY?=
 =?us-ascii?Q?HyMXxKsvbOVbjV1wA06ypGJmx8FjHO0Q5dvAf8+8QdQrFVsEs0Qdu0GBWcqR?=
 =?us-ascii?Q?aQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <11C25356D1613D47BC091FD63AA0A77C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 935b5c15-72a6-40f5-c00a-08daaac3f686
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2022 13:33:05.7404
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y/3I1bbkMOIzje2rwHPESJul7yoaF7JLmINzjrlbMsgI0b4iriYRxFeFnxg8cEYkVffJOQfPS5dGacX0FWYTaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8994
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 06:22:52PM -0400, Sasha Levin wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> [ Upstream commit 18cdd2f0998a4967b1fff4c43ed9aef049e42c39 ]
>=20
> Since the writer-side lock is taken here, we do not need to open an RCU
> read-side critical section, instead we can use rtnl_dereference() to
> tell lockdep we are serialized with concurrent writes.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Not needed for stable kernels, please drop, thanks.=
