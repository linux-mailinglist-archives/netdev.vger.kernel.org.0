Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263944CD473
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 13:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbiCDMs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 07:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiCDMs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 07:48:28 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn2065.outbound.protection.outlook.com [40.92.98.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DEF32ED6
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 04:47:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PpEhxCOfJROG146rEVtP7qFRDnPfwFMeTZV26+hszUX9tyWWKSp8gvCi9HMRL7fUNuFFNmBFuDWXIv0plVIBmxvXDLfMRn9vjWbB5xyr78Qvt0zqwmuqGBt2BweZCIINxv6H9QnV7KzdiGZGDCTghlqwVTdRwzJBmFk+j/cqxtXJgTWKq5eGZTKV3RBY257eYmL7N3iaLOXWysDqGoXVekPhWJR2vA4qCoZZHeMTTXFQrOfAdDhcrpCVLC0qXo2AN0Z44nyEap4t+5vNCovcfA10dwbWUjS4S1agF7MstaIdWgrAc5YGsk6EiV+sSes+UGF6l+LAPqj+gx4HqJbqtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cZkNE3vfKPrpvj7dVCttmiepkAfbMUnRb16R9/ifzhk=;
 b=c1/Zb5fSiI1t90BcWmNRrch53upMubmzvoXR9iAUXiEF2nHm+/M0TIcC2D5PDEz8BS2ZOyYytle743eecDOjq19B9yPEQ6ssh4PI8XhRUA2QzUpoQwzXHFpBA8o1vMKyZqugT5nZa+LbWwUdEn/xdM7RVmqsrazjIEmk+V8Etst4cSYaqXXD7+ZFyZSPtvgMk0QPGHCXcMEn76/Rg8Agv+uuDjd2Czv1IHhjgvgkW7ajSH/5GFpE2c1avvSAHB8z4Y7IPIOGy1gJtla6v4b0sBdBT6cEspwNUdUShKImz+vNeq10hMuE5gRRPC2wJlUss1LxeyZ3USWStj/Kl+/kGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cZkNE3vfKPrpvj7dVCttmiepkAfbMUnRb16R9/ifzhk=;
 b=HN305grSEz8CbtjebPpS3+Uz0xDFJwoTSXfco7w+jtNMXV0jT3WobeVjsR8HbLeDDfmC8f52V5j7EhkMKvOnV36ZDbtsCKZ0ntZAHP7r4geLK/gEcPx/KzAhg3phskd568ouoH9TTEmTbD8iae7VV0y+btb9z2sk9R6RC7um4WKu7XSPLjiQVEli0Rw1Kwlu0/wS7q1nSlkNjxaw6+hAMLHRmc0x85a+Y1hZ/XKDAkPIMgg4kV5X4N+Bd1e3XN1KZu8ltv2dHZqNbWYil0eir3IImdKNcazUcKPa2Fk3pj7bTqz9eQy0rUJRFP1LZ3Eutm8nw1atmSCfAd8vMwshdg==
Received: from OSAPR01MB7567.jpnprd01.prod.outlook.com (2603:1096:604:147::9)
 by TY2PR01MB3435.jpnprd01.prod.outlook.com (2603:1096:404:d6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.16; Fri, 4 Mar
 2022 12:47:39 +0000
Received: from OSAPR01MB7567.jpnprd01.prod.outlook.com
 ([fe80::ed12:bc41:7a3b:ea5d]) by OSAPR01MB7567.jpnprd01.prod.outlook.com
 ([fe80::ed12:bc41:7a3b:ea5d%6]) with mapi id 15.20.5038.016; Fri, 4 Mar 2022
 12:47:39 +0000
From:   Shangyan Zhou <sy.zhou@hotmail.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2] rdma: Fix res_print_uint()
Thread-Topic: [PATCH v2] rdma: Fix res_print_uint()
Thread-Index: AQHYL3Q43+5Ed/aduU2HGz50LYAYLqyuzMCAgABXQ6A=
Date:   Fri, 4 Mar 2022 12:47:39 +0000
Message-ID: <OSAPR01MB75672F674485556F9DE61C92E3059@OSAPR01MB7567.jpnprd01.prod.outlook.com>
References: <TYCPR01MB7578E54F06AEFE50785B771CE3039@TYCPR01MB7578.jpnprd01.prod.outlook.com>
 <OSAPR01MB75677A8532242F986A967C9DE3059@OSAPR01MB7567.jpnprd01.prod.outlook.com>
 <YiG5jQHDA7HuGjrO@unreal>
In-Reply-To: <YiG5jQHDA7HuGjrO@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [SLQgcnQQzShvchXOAjy8eiwzw6F/8+qw]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b5a0351-867d-4cfe-2b0f-08d9fddd2a6b
x-ms-traffictypediagnostic: TY2PR01MB3435:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U70bBdlyJI4S7ghDv1rNMdJPZkaWj/2qBkUKs5wtjTJ5mJfRmoZDMb9UzMdQ09wcCYDjE1znDF34FvLD1EOHdEL34rWzHctFREOgDPhBdceDa5KX9In0DoHwt0Vs/mNMyGFXyT1aAYIQctzkyHQZoniXVYmROJ64mYFV7tPHPMb2+ihRtD29E/VkBGOEImsRBgbKwNojKtD9Rvd1PaSbYzzBtD0Fp1J2/DwibSyGFDVmfM+qETHNUjetlQCHYSNXbSbD3UNnd+dRnr407m1cRubgHHKCpe6eg0+1Al73Qyjlb6mB6ApoOLzBrBtUSvUp9FJqQhLp70NemTEOtwGfBGGaZ37VQt4A/EVA2/QB6Lp1b4QrJy2DI3vEF6yT5LJ60YudKI95rC7RVB2Jhcv0IS2fTqaNTpGM4PA45XKDjZstqaX8fCBimBtdOtCg02Fc/ug19PCm6U0IVg8aA+6MXmsruf/Nu8TtlU0yNyxgcgQ39H+OpzmS9QJikXNAxPULPhg0fHwgckpO0LoecAc7ZFyZSKsDgLUIqZT9/KWowtxNsek7/nHF+kKSuBnSvBDRJNH6v106KA+HqABSqI9ulw==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ueq8g0bRavK8hGQXAGVce6m/AvhP218zyshEzqcEEkKoPmRnLWoLywIEm+N3?=
 =?us-ascii?Q?s+OtiQLgei99LlWjMw1tKZLw6/XnKt0BLeDLpql+bjbkGZbizXe1XEgmuUXc?=
 =?us-ascii?Q?OeUOmvDDhNriftmc0EYRsjx6+DgxJ2p91JW4+sV0MCiabGJusV1WToWyE7cc?=
 =?us-ascii?Q?GPk52+aWOO86Qb/VmnjdJuw5hc49jTHIZx3n7+JYZKBmfQyZpIJ7v9DY4jVu?=
 =?us-ascii?Q?pUK1l82OmWxad/JqingeX+LfyCBOti/ku2EbiB0RwNrBngNw6vZgs8Ml5vdD?=
 =?us-ascii?Q?Pg8iyOqRpsGpqgiVkqcoDx3ajHvNxYfF/29RbcQ70Htd5nrNhJnZD+ARibur?=
 =?us-ascii?Q?jmI+gvcQ5qSpyBfUzqaVHahDvzDG3R8JqfteTeiriIezzT2WQp84fcq1tqEL?=
 =?us-ascii?Q?EOZ5vpsVzTetrV9XZuR5WFlySxiUGity+PwnramhpipQVvppowBlaEqatExp?=
 =?us-ascii?Q?zXCE6bfNd7UaLMFQZCAq4V54ycetrf+t+U5VAS6Gl9bEf3dbxcLksYrJ0CiV?=
 =?us-ascii?Q?GdntkedEN5oWt/9mrxZ7JkXhzD/nRn+tvR7ZCJCzgtG4Xi2vkJleTgjl8VX/?=
 =?us-ascii?Q?A6igCnhnf7dcguJZ/wWie5BwMA6XTIw4goziT8QmBkK0S57KoVNYQG6VyYW2?=
 =?us-ascii?Q?hWQNP4LApXW+Xb1PV6FIYL/BoARJ2qErauhuhRMcNqgCd0Jp0N3v39ip6kfW?=
 =?us-ascii?Q?rucCKJogPlNJVMaxVad87PGw6lVhbvqNkJUFlmzBEnuryRiimLjd2/5ChPK3?=
 =?us-ascii?Q?l/EuRqDR6WknNiq4oh2t1Ng10ouDo2DYmPjnTcb1baoWg3LuQVskfMxzennI?=
 =?us-ascii?Q?JrV7RctzJzUvHCrcya7DumOwc+BV0FGnfjpsdM+gR2BN8kloBxUzRW2tCtqY?=
 =?us-ascii?Q?nyJ/Xirp6hIG+WJXCNHg0ZBdHapWGec4VKbz0/ZfNvKeWI1FxiTqAYjcnxLI?=
 =?us-ascii?Q?J8E/YKxhSy7/gDNmsCUDkA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-9cf38.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB7567.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b5a0351-867d-4cfe-2b0f-08d9fddd2a6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2022 12:47:39.0120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB3435
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Did you mean the function name?

I see some of the input values are uint32_t and other is uint64_t, so I add=
ed a res_print_u64() and submitted a new patch.

Thanks.

-----Original Message-----
From: Leon Romanovsky <leon@kernel.org>=20
Sent: Friday, March 4, 2022 3:03 PM
To: Shangyan Zhou <sy.zhou@hotmail.com>
Cc: netdev@vger.kernel.org
Subject: Re: [PATCH v2] rdma: Fix res_print_uint()

On Fri, Mar 04, 2022 at 11:00:28AM +0800, Shangyan Zhou wrote:
> Print unsigned int64 should use print_color_u64() and fmt string should b=
e "%" PRIu64.
>=20
> Signed-off-by: Shangyan Zhou <sy.zhou@hotmail.com>
> ---
>  rdma/res.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/rdma/res.c b/rdma/res.c
> index 21fef9bd..1af61aa6 100644
> --- a/rdma/res.c
> +++ b/rdma/res.c
> @@ -214,7 +214,7 @@ void res_print_uint(struct rd *rd, const char *name, =
uint64_t val,
>  	if (!nlattr)
>  		return;
>  	print_color_uint(PRINT_ANY, COLOR_NONE, name, name, val);
> -	print_color_uint(PRINT_FP, COLOR_NONE, NULL, " %d ", val);
> +	print_color_u64(PRINT_FP, COLOR_NONE, NULL, " %" PRIu64 " ", val);
>  }

Except the res_print_uint() that should be changed too, the patch LGTM.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
