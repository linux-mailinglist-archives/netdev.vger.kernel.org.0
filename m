Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733C44D9BF0
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 14:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348591AbiCONPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 09:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348594AbiCONPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 09:15:30 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2083.outbound.protection.outlook.com [40.107.20.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9A0527C7;
        Tue, 15 Mar 2022 06:14:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XY+lqVo5ES45XZcTInxpcdPUCjWDutnqlLFcf8sEuffZfPu8PgkRgDKouke2FM+yoDw4y6Pz8MTWd33giWbSprtvfENzv8aNv6zUR+uduaphKXjzllv5E+3FKJRxLMnZsaIdbXR9bTUVCFa9mdhuxZ4rnu+0Wx64xjmfuFK+PQawhirLReK1wq5oUUdwS1+Xv9qj5d9hUCt7zlMOAAUnK4kCDlHBb6WNLWXcaG01GSrkt1nbcXxOxY75050YlW2Z0UhTZGqje3yX3k6CwYV08engK0iLvaj7Mt3yOm9116Eu9bZV5kuateW85bYLM9h3tBkSrqxLWFBbHkN4MT4n2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fs/k+Orx2lDH1VKFhCmA16HCvmkP7QZT7FIVAXlNdkk=;
 b=SJDzrgZd4hVhQVweL9CV8kM1jeR5hrzFfUXeUgw/sQrSe8LclDqmeXV5fjxD6mI6/+eK+QfLijZV/XFAdBOq+AU/aPMFYu3rsn0hStqNvg4lgSTsNkWGgJ68k9HavSQC5wYM3lBFwv+CLsHuwi1d90VYIThJRgYubsLysVkkqABujWAD1eVaZTvVZhZXO+WdpeaZnyWmh3FVVeTuy0AiD9AA14k5UerLyxXBJtm+51fhqzXmlJWD6UdVEPMg5GPC1tRylHnBtiQp1N9KJB59U0YfrrbiUXJmO9TNOkBwYh5GngPOmYDotzVOtml2gnn3TIABjgTgP1wmyZQE5bW6yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fs/k+Orx2lDH1VKFhCmA16HCvmkP7QZT7FIVAXlNdkk=;
 b=Gn3g4576NE3w3ua6eHV4sHAgvQ9UUNMCMgBtHb9rmjpaU3tUYl+4gFuirQX+DdIglnD1StfIp0+nMXcszWdKDiaP7LcbjiI1URSPBO6DJw/CCpc0IY16K2O3kxqivCClasIseGaX/SBwlZyXlMPHSxa6vLqoT/CoKwnAB0CDzb8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8551.eurprd04.prod.outlook.com (2603:10a6:10:2d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.28; Tue, 15 Mar
 2022 13:14:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5061.029; Tue, 15 Mar 2022
 13:14:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
CC:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Thread-Topic: linux-next: build failure after merge of the net-next tree
Thread-Index: AQHYOGIIHFHDFTA7c0O0FNLe6+TL5KzAbF+A
Date:   Tue, 15 Mar 2022 13:14:15 +0000
Message-ID: <20220315131415.2tipxk4ccl5qtdl5@skbuf>
References: <20220315224421.23a8def1@canb.auug.org.au>
In-Reply-To: <20220315224421.23a8def1@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d27802f4-64e4-481d-4f9b-08da0685b4e2
x-ms-traffictypediagnostic: DU2PR04MB8551:EE_
x-microsoft-antispam-prvs: <DU2PR04MB8551A6980332E36162A89D35E0109@DU2PR04MB8551.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kZKzmTMHPN76OQEY4eFfVL6XQsiGbVnVc4rgf5C7nqc1EcG9ACG/RgVVSoH8Jtro9JeP7+5Pzgu6MT+T4B5/mJC3LrBx9Ru5AoCkMYE2ypanduAX4osaxoNgWcyUzRP5dV82LzEd/i+0DLV0LL7Ds3U4TJgMJFWccB8PZguO283OC8mEci8DSLshy2u9346qC0IlUHrVzUNBhL3utTVssx0/cITkt212QCc9kkq507ylIuio7OidFUbQyIyC82O2UW67AFQVYMopK+p6TUHXcssJRaR2+mfX862ly8ktiSGyg8obysPPV45rMfp2k8b1muT8FaJl/Lw60TPv91QQNS8UeCf8mKYRTqu3Kdq8yDG+5HsauLPr4zE9k9ta6gnhV4I4V9Y3jVVM3DmFEcF+kl/TK2hxDw1W1tdSXABqwm6I0nWgvwoQ/1+z4AaumAVPUa6ELXGl0+t0UcQbF7OgRmJ4Yq7fl2vjwLz39ZfCU7zt4P9XcPBGLRzvrBx5Gsai/XYa22bUGsd5dVxGB2daal49vL0omvmgkbfIeTL82RmoGUoJO0EYtaKIXnTrT8GVfTqf8B17DPkDLx0H2DPa/niifg27TxSAl4HeOJfzQs7jFtJOjCkcaZfsGdim/9K11CQQOFtxXg6OIFtILRC8uIi4Wu6Cu8HJFOk+jqDtvLBDZRAarV3bWi6Jd+zmhNgv6wETXmCsbW9rATOzu6eo9tUmcV3HY7J9TATh59QhCHEVQK6joTKdM0M0J7nSDwcOf5jkidEi5XmbZormJBuGqZ7XatC2K1TOF1M2cq2X0eA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(86362001)(316002)(38070700005)(122000001)(54906003)(6486002)(6916009)(966005)(5660300002)(38100700002)(66946007)(8676002)(66476007)(76116006)(4326008)(64756008)(66446008)(8936002)(66556008)(2906002)(44832011)(1076003)(71200400001)(508600001)(186003)(6506007)(6512007)(53546011)(33716001)(26005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XZGXq4qqbICjPcAVPeZWFX7GoOOjegSMZYkpjQBo12mVmeDvCm02vTYOCs0C?=
 =?us-ascii?Q?5uZ6TQFeaBRu3OtdKC2d1TauXiK45h2Q2pRpBwr9xQyxYPqnmAOA7JS7QYgH?=
 =?us-ascii?Q?smtz0aOIC1AqLeb/wQUlVvC1Lb1/6jhtZc6VF8Nz5Ss57pipHeBrr8YdBvQ5?=
 =?us-ascii?Q?y0x+YEc9dID4gw2trRdIwBr6orOR1LeaDlSKyXGFTFjMaAzGbbRE1aNQIQgE?=
 =?us-ascii?Q?vLBrOP3AeP+tRHHvb07mRQJqz2/yNUqV+Vd+FKZ/SYHM6+LhZY7K6OS0eOFs?=
 =?us-ascii?Q?FsPx9yofSwGkTg4gY0KrlRbI1dSj+4IJ73z4KOc+D9LQAi8q9+iXFpPbChFN?=
 =?us-ascii?Q?Gt80e3L8h3JPa2GSY5NxgAV+U8c4Y34XwEkEjdv84vp86fvbX4zsWzAIUSrp?=
 =?us-ascii?Q?iIdnNNibLQksulNnXUACHNNhVII2mCoUt56gLkhG/pXdJYWyKAlQCuV4BUJR?=
 =?us-ascii?Q?FyhasVHF182lVvt9r+6WPClx8NGiNtnlESOCnh82855xxbUXfKg8MHmgvHFe?=
 =?us-ascii?Q?k2XxBIrIYEksuEwhepE7+uHVoxcBvfM78oORbQRbJAAdzeP9grtBSgMuXyhF?=
 =?us-ascii?Q?CSeF1Sq3ehnwhd+hL4tnXc+7Rr3f3IDCxkdNzHRAnXyeUYeqe1n+QRBxuGhD?=
 =?us-ascii?Q?wnk0uzRpo18IP59AiaCAaZ0bwWcsojLytO9n9Fw/4x5XHtc0h+ifBVAeN7Sh?=
 =?us-ascii?Q?zojeDkO7+d8c0Wg7TInqqI89tgK3Dgybq3tEVWwoQ84ClwQAkaZMtbSaQq7v?=
 =?us-ascii?Q?e9iCvYwNVruyeH/xp7ruxYteXMDHXUC/tOxvy9EFPY51uke8ICD/NFzqjAYe?=
 =?us-ascii?Q?Ct69/oK/s/odtqMvNHfVHZL+bkakonnGRrHwe+/B9eeuAPKQAbywZ77C6TjY?=
 =?us-ascii?Q?BA3MhJu+PfLHBKSDuuurZsSWkPXD/yEnlh11XQk3MgxlszBDeS2EBhwjACue?=
 =?us-ascii?Q?v7c9hem/nncTHxq7jU6T/Ns/LMKoepYmt3yC72n5R0x+Gm/vGwBrdkd7XHLD?=
 =?us-ascii?Q?FUUVP3+C3SygHRUNPrBBDclttn4aKivO0vHWsLwn6zrLsgxw6vh/O5Rb0VoF?=
 =?us-ascii?Q?dHVqzwEFt0djatBu1f0mQu50vh6COOBjV0pM5hCzt/Pney44kzA02QP/Es+m?=
 =?us-ascii?Q?IJAJUGb0dGnBlvYA0laFLO8qQmtrg4TBcZnvjM6JRhD7ICReP2eGH377jxSh?=
 =?us-ascii?Q?hk+2YwTC1aQqynhwiiXAfOuFPBeKJACVQcTzED7XoAxRw/+tnqZYILXs34mX?=
 =?us-ascii?Q?mOYOQKkFVzKChlbv4oA7o3tmOvToGKCIMNCYXhJFFQ3tmUmivnNs/kjbjZ3z?=
 =?us-ascii?Q?ciBYLxEqhKGH2MTSN50tOXCrlumXG6fObTSi9Ph1IworUkWy8moiXK+ugtE3?=
 =?us-ascii?Q?TVj2yTjJBeG7CRhPGxT93rhDpetwwF/ssFtDrLf7GTxOP11rRRj3D3/0qZox?=
 =?us-ascii?Q?vox9Yi8fUw2ZA2Mc3YyBGrxvnZzFMMdFjYv9cYS/iYF4QunJVi6hYw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21C088531895FE419809D607F3FEF5BD@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d27802f4-64e4-481d-4f9b-08da0685b4e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2022 13:14:16.0087
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f6RWtOI0iBi5e+5w71OfbWKLzLivG6R4HznOAUNvWZNuI1WdoeJRjIhY2Oa+cxkdos0pg8n4dIAKW85zhYbTkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8551
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 10:44:21PM +1100, Stephen Rothwell wrote:
> Hi all,
>=20
> After merging the net-next tree, today's linux-next build (arm64
> defconfig) failed like this:
>=20
> drivers/net/ethernet/mscc/ocelot.c: In function 'ocelot_port_set_default_=
prio':
> drivers/net/ethernet/mscc/ocelot.c:2920:21: error: 'IEEE_8021QAZ_MAX_TCS'=
 undeclared (first use in this function)
>  2920 |         if (prio >=3D IEEE_8021QAZ_MAX_TCS)
>       |                     ^~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/mscc/ocelot.c:2920:21: note: each undeclared identif=
ier is reported only once for each function it appears in
> drivers/net/ethernet/mscc/ocelot.c: In function 'ocelot_port_add_dscp_pri=
o':
> drivers/net/ethernet/mscc/ocelot.c:2962:21: error: 'IEEE_8021QAZ_MAX_TCS'=
 undeclared (first use in this function)
>  2962 |         if (prio >=3D IEEE_8021QAZ_MAX_TCS)
>       |                     ^~~~~~~~~~~~~~~~~~~~
>=20
> Caused by commit
>=20
>   978777d0fb06 ("net: dsa: felix: configure default-prio and dscp priorit=
ies")
>=20
> I have applied the following fix up patch for today.
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 15 Mar 2022 22:34:25 +1100
> Subject: [PATCH] fixup for "net: dsa: felix: configure default-prio and d=
scp priorities"
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/net/ethernet/mscc/ocelot.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/ms=
cc/ocelot.c
> index 41dbb1e326c4..7c4bd3f8e7ec 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -7,6 +7,7 @@
>  #include <linux/dsa/ocelot.h>
>  #include <linux/if_bridge.h>
>  #include <linux/ptp_classify.h>
> +#include <net/dcbnl.h>
>  #include <soc/mscc/ocelot_vcap.h>
>  #include "ocelot.h"
>  #include "ocelot_vcap.h"
> --=20
> 2.34.1
>=20
>=20
>=20
> --=20
> Cheers,
> Stephen Rothwell

Thanks. I've sent this patch:
https://patchwork.kernel.org/project/netdevbpf/patch/20220315131215.273450-=
1-vladimir.oltean@nxp.com/=
