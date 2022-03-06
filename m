Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42F814CE9D9
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 08:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbiCFHBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 02:01:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiCFHBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 02:01:06 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01olkn2034.outbound.protection.outlook.com [40.92.99.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13DD32EF9
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 23:00:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QqmKuFMEYCHRxbRlHHjypi8EsV8CHlBTEtvyT/tTAOlKOwnM3i27Hr3tdYr7EgSvmiH2t88JG/hzgrtJwcYxPKQFziZehdJTNsuCtLk49D9+Kp1r+S0W3V2VngMBO9P21NmrVpEJDL0JdVRPp3gsq56ZWPIAk7Bwa3JFmqNBCgevcwuFcaxNZ6RJH4h7exgEGAsz7+dMTPXqwYw5XcFEyyJI61Pch4SdVnGc/hHGZMhv9caP1oqdacI3GoCE6U87QLhwrJF+8BnKCBHNnNQxd0hImdj3xKFH2Rc2Txh6mHGu2V012jIWWGQUqBAvvHOyaZivuEkzoOrwTa963trnzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L3IvLoa/3JkxTvyUfrXUkSmSREdQ33gDcMLJJJ6r3g8=;
 b=JPOPSi9ZOT7sThFt6ECvKD6Xa1LsWlsDKmALbuRp1PyBasIKo1osw0NWn4sCjCONB8WysCo9btdnp2gZj/9lINSFI/3I4Rg0AXjNHt55kyMSt5bKrwd5zK4fjc0ZDfzjJCpkTWKKiLSnV188wUXkbUrmlqBXh+etOB5ZHMOEt1pQgReIxKNmJVz4cnETJ0MRQKQzvk8x2WEg/wx6nm6+qS6vY5WiJOHJqUlQjcniNOWddWuoyrOxJyF+e+WNZUi+ULEdvVNYpwxCu0fufeWDxD77kMaae1uHk+ni75RWkm2xro/LILvGU6R7LXY40KxLs9+ePyk5f16dEFD6zHJPXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L3IvLoa/3JkxTvyUfrXUkSmSREdQ33gDcMLJJJ6r3g8=;
 b=iytP9I+ElEYzeW2Qcc/38e5KgXfHtbvVYO+tFVMiNV2Xmlm38BwvTszP+w2H4FX6QU9Dx9iZ/qmFVfAHiTHVaSkPU6C6ArggMv3eKNjwoZ2tgXA89QR3oTnrDgbkS5U2s8pW2CWlK0WKPOXR8mgWlIN3LP/uI7+jLNF5H7KiAV1h+8dKFaEO6s2lSUUNHtj+35OWFCMxaN6fi818RP3EjOJh2MJ5EnZiFTUZbbm0EqZ4jr4lDUHGILJd3wtht6gGXIc+vOoPjUz/kyhHa7/5V2aeK4CO55a7ybJWtj8A9XC4SOcfm7OjzivWG1fzHtdp8lEAp0Dx5351P3DSUVR89Q==
Received: from OSAPR01MB7567.jpnprd01.prod.outlook.com (2603:1096:604:147::9)
 by TYAPR01MB5055.jpnprd01.prod.outlook.com (2603:1096:404:12f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Sun, 6 Mar
 2022 07:00:12 +0000
Received: from OSAPR01MB7567.jpnprd01.prod.outlook.com
 ([fe80::ed12:bc41:7a3b:ea5d]) by OSAPR01MB7567.jpnprd01.prod.outlook.com
 ([fe80::ed12:bc41:7a3b:ea5d%6]) with mapi id 15.20.5038.026; Sun, 6 Mar 2022
 07:00:12 +0000
From:   Shangyan Zhou <sy.zhou@hotmail.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v3] rdma: Fix res_print_uint() and add res_print_u64()
Thread-Topic: [PATCH v3] rdma: Fix res_print_uint() and add res_print_u64()
Thread-Index: AQHYL8XyYNmpfUt0W02ZaAPMAr7rOqyvfHqAgAJyn6A=
Date:   Sun, 6 Mar 2022 07:00:12 +0000
Message-ID: <OSAPR01MB75671F748C7F91E972132BE6E3079@OSAPR01MB7567.jpnprd01.prod.outlook.com>
References: <OSAPR01MB75677A8532242F986A967C9DE3059@OSAPR01MB7567.jpnprd01.prod.outlook.com>
 <OSAPR01MB7567AF3E28F7D2D72FFA876BE3059@OSAPR01MB7567.jpnprd01.prod.outlook.com>
 <YiJNfx85POmhzGQV@unreal>
In-Reply-To: <YiJNfx85POmhzGQV@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [brmjjMiucY6TJGIyzw7QgESUEWMCPyrf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe852e30-81ea-43ba-af92-08d9ff3ef5ca
x-ms-traffictypediagnostic: TYAPR01MB5055:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YsyFw+GPyB8CTJ7MHZ78Fi8BJtjVWjbwhV3djNSK6FuEdTpmwc1jBZn/2rbVabbUAZmfMTwungEHpn3PI8bf2fIPoEG6ERc3gVBxo47oVeW7cO+DsGkWN+2SeVubcB4voMuS5tE22cQeJL1DnYu8F4toSy6yfh4nZEpOMkiERyupspMWsfd4gkHEuPM0Ca8Kc3bWBt8Ajwne4QJ1NQbWBX75dR1g92vsBqY8ZhPBC+NOSLBB/yRZnJrMBMzDW72HJIeKClM3+rmL4SdDzY8TJa4DCB04qQoygWmwfM3unqGq5cbSyMWOz0WOhTtV7S4sPCsOYggfTjTZ371RqC7su5WipXKbIPdHgEzT6UQGe4l6+lo0o5HvGrAkyEv3rynqcmAE2J7tqbASYFntSgXXJb+ha+nYAkRr+KAeE+JAFWjYwg60OH3WayW5hvWgD1qCupknvTvC+SuQCXtrVD6Z+cwVc6+SbeSzqwUb1034u24cRYlg658V8lh6s1Z0G/7cdAI6dUliumUpH7PB3smDBZMiyaT8X3YXnnMxy2k1btvXaZU3s2cVEj6oGqpmsipz+18L9AwbWT9YR+VbWqewTQ==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?A33iZ6bBns3lfkpWtv8njk/H3fXH50MAciKlE0EE6dXS2UsN4Fr/jYHImCs8?=
 =?us-ascii?Q?s03LD6HR7wrQ8Zv0tHdnFb4ptg85Ew6lpBMpvQ+xXzS/ZHXLEkSydd94JPYM?=
 =?us-ascii?Q?Tu822EENXUEBpnyjhNGnbciZ8zf2hxs/TJYpTZqZXrkAUQegcIJzQcmSbu+4?=
 =?us-ascii?Q?yskD3fGFfYo97t9XhEJrqvEUkBMhD+m1lsi+QAVdf3kEw2WXUKsuYWE4BLMm?=
 =?us-ascii?Q?nGEUaAHijJyttmCvZSSh0nbRe0q3CMN40xEQC19z0VMXTkh/Tk7BsH29nXL8?=
 =?us-ascii?Q?FjYm8l+x4Daz9YhdiUQc1uQ0TdDk1TcxTlUqhQFr3y0ZY9ELM5EtIst8BJid?=
 =?us-ascii?Q?EFjq1L51/hTXmQO9+HLfUft3BuQ7IqvXSYwoRDdu2zW8JUJ9yAIASxtMPYdn?=
 =?us-ascii?Q?880ihZxYE1hQU6Iw9Qq0gGoaPACjF1ziIfXe1qSqN9LHGzGwyVP825HX8zpR?=
 =?us-ascii?Q?qlme0kOaKeGHHDOavKWigzhK2BcQ1q9TjbWiE5wbjQ6evh1qAu74/jUPdSM0?=
 =?us-ascii?Q?8438r5H4CHnfNeg5nlQRiCkDNzKpIbCvDOZt0Kx969Xw33MoVykaQlxCUH7D?=
 =?us-ascii?Q?eo+F8pfw31IdWPaVjwkP6YHey99+vsUNS4JJZXBIX9bUfTpugnoUxn970IVI?=
 =?us-ascii?Q?cXoZ+wUw+BvwVMRbgDZcYKzj4746wJjcrfKOBNAznWzB4FTkDPT3e6jBP+WL?=
 =?us-ascii?Q?/zkvQUVbUIz0R5Vd5due3jJL/vNW2er803ts2GnoQ76wTC91no8A9kDxGgdw?=
 =?us-ascii?Q?5M7+RFcB/JKpkhxLH1ndr5QI81csT4iHz+BuDXzcuGmkTzBXIG1PBr+oJBHM?=
 =?us-ascii?Q?AHydDjORXTl7LnJAzUxPmewFnM2++C9gPYNVSd2bkwVRxElM550VyxnuH4UI?=
 =?us-ascii?Q?hWMrmYdWculb7My8EB1O8E63T5+Q9ktIT3caTEVF9dPAYLlZ89OzaznASS7i?=
 =?us-ascii?Q?Q3bqIpwWSEkhfoyKVHIdlw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-9cf38.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB7567.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: fe852e30-81ea-43ba-af92-08d9ff3ef5ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2022 07:00:12.5766
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5055
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Got it. I renamed it and submitted a new version.=20

Thanks.

-----Original Message-----
From: Leon Romanovsky <leon@kernel.org>=20
Sent: Saturday, March 5, 2022 1:34 AM
To: Shangyan Zhou <sy.zhou@hotmail.com>
Cc: netdev@vger.kernel.org
Subject: Re: [PATCH v3] rdma: Fix res_print_uint() and add res_print_u64()

On Fri, Mar 04, 2022 at 08:46:37PM +0800, Shangyan Zhou wrote:
> Use the corresponding function and fmt string to print unsigned int32=20
> and int64.
>=20
> Signed-off-by: Shangyan Zhou <sy.zhou@hotmail.com>
> ---
>  rdma/res-cq.c |  2 +-
>  rdma/res-mr.c |  2 +-
>  rdma/res-pd.c |  2 +-
>  rdma/res.c    | 15 ++++++++++++---
>  rdma/res.h    |  4 +++-
>  rdma/stat.c   |  4 ++--
>  6 files changed, 20 insertions(+), 9 deletions(-)
>=20
> diff --git a/rdma/res-cq.c b/rdma/res-cq.c index 9e7c4f51..475179c8=20
> 100644
> --- a/rdma/res-cq.c
> +++ b/rdma/res-cq.c
> @@ -112,7 +112,7 @@ static int res_cq_line(struct rd *rd, const char *nam=
e, int idx,
>  	print_dev(rd, idx, name);
>  	res_print_uint(rd, "cqn", cqn, nla_line[RDMA_NLDEV_ATTR_RES_CQN]);
>  	res_print_uint(rd, "cqe", cqe, nla_line[RDMA_NLDEV_ATTR_RES_CQE]);
> -	res_print_uint(rd, "users", users,
> +	res_print_u64(rd, "users", users,
>  		       nla_line[RDMA_NLDEV_ATTR_RES_USECNT]);
>  	print_poll_ctx(rd, poll_ctx, nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX]);
>  	print_cq_dim_setting(rd, nla_line[RDMA_NLDEV_ATTR_DEV_DIM]);
> diff --git a/rdma/res-mr.c b/rdma/res-mr.c index 1bf73f3a..a5b1ec5d=20
> 100644
> --- a/rdma/res-mr.c
> +++ b/rdma/res-mr.c
> @@ -77,7 +77,7 @@ static int res_mr_line(struct rd *rd, const char *name,=
 int idx,
>  	print_key(rd, "rkey", rkey, nla_line[RDMA_NLDEV_ATTR_RES_RKEY]);
>  	print_key(rd, "lkey", lkey, nla_line[RDMA_NLDEV_ATTR_RES_LKEY]);
>  	print_key(rd, "iova", iova, nla_line[RDMA_NLDEV_ATTR_RES_IOVA]);
> -	res_print_uint(rd, "mrlen", mrlen, nla_line[RDMA_NLDEV_ATTR_RES_MRLEN])=
;
> +	res_print_u64(rd, "mrlen", mrlen,=20
> +nla_line[RDMA_NLDEV_ATTR_RES_MRLEN]);
>  	res_print_uint(rd, "pdn", pdn, nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
>  	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
>  	print_comm(rd, comm, nla_line);
> diff --git a/rdma/res-pd.c b/rdma/res-pd.c index df538010..6fec787c=20
> 100644
> --- a/rdma/res-pd.c
> +++ b/rdma/res-pd.c
> @@ -65,7 +65,7 @@ static int res_pd_line(struct rd *rd, const char *name,=
 int idx,
>  	res_print_uint(rd, "pdn", pdn, nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
>  	print_key(rd, "local_dma_lkey", local_dma_lkey,
>  		  nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY]);
> -	res_print_uint(rd, "users", users,
> +	res_print_u64(rd, "users", users,
>  		       nla_line[RDMA_NLDEV_ATTR_RES_USECNT]);
>  	print_key(rd, "unsafe_global_rkey", unsafe_global_rkey,
>  		  nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY]);
> diff --git a/rdma/res.c b/rdma/res.c
> index 21fef9bd..62599095 100644
> --- a/rdma/res.c
> +++ b/rdma/res.c
> @@ -51,7 +51,7 @@ static int res_print_summary(struct rd *rd, struct=20
> nlattr **tb)
> =20
>  		name =3D mnl_attr_get_str(nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_N=
AME]);
>  		curr =3D mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_C=
URR]);
> -		res_print_uint(
> +		res_print_u64(
>  			rd, name, curr,
>  			nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR]);
>  	}
> @@ -208,13 +208,22 @@ void print_key(struct rd *rd, const char *name, uin=
t64_t val,
>  	print_color_hex(PRINT_ANY, COLOR_NONE, name, " 0x%" PRIx64 " ",=20
> val);  }
> =20
> -void res_print_uint(struct rd *rd, const char *name, uint64_t val,
> +void res_print_uint(struct rd *rd, const char *name, uint32_t val,
>  		    struct nlattr *nlattr)

It is res_print_u32() now and not res_print_uint().
But it is nitpicking.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
