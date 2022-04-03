Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52EAA4F0A1F
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 16:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237755AbiDCOQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 10:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236161AbiDCOQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 10:16:21 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3071225E90
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 07:14:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FYiW7rclO4IwUTAXRkLDAvyd6uI2oaNPl9vVq0g9sIIK87xYqHI0pXpjf4XoEYKCVOziPUgbDb76nMZZh5T+xZkBSN0IQ1KkvDkK4d+QJo2uTKyaXuWBTFk8WZHTzXMYaTy6AB7e3t+tqWgBTmA3edEiVEUA1Z8wV7RR7AM4pyLDdQngYYq5xOK8Ure7dy0YnNpa0nmOU7HHTf2Bn5rmnKDrXMqMvBBIKka8tpu2pwY/ePGwVXJYPpbTwAJkjsZxxp7yLR76w7+xk8yV41yALNTT+DwwgfLQRkF7kJzAHhlcLSQrYG4f/9unLpyzYfsPASWujUeO8E9fSyG3btNZdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EYTvZz12/OqFzrZF9GxyETVfqjaOXRANE6PVx1vA1+o=;
 b=T3mPColx2bsa8J1FEmn6vgzNj5Rmo0QQTCRkZt+Hsv9uSk3H9oChPIl94j0Dx7AeyvRhHKzorl2yZ+L5K7nD98T2Si9WQoNIU0pROgjJG1ZXGRX2MZe0KLSJ4kveclZhU5eR2Yr/5EexQF23MIRAiVcnRWdsrXtCAHbjk0gFSElZoo8xl0x+7Bz+5dV//8n2l98yZnTm6UeeNI0tJ17Itng5agolJGjgBf3QrS0yjClR8o3uKiRiqVtoFlGu9JkWD3gB8ysDHdy29Yn+lLIf/CBmsp9mCFV24Vu7oAWeEmJxmxKhVHID9d9MnA3adLoR42qj597CDCIuEw2wQ6PbmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EYTvZz12/OqFzrZF9GxyETVfqjaOXRANE6PVx1vA1+o=;
 b=pS+CIYHBXVZJPLR31DYRC19HQkMTV9u8yB/ubrdypp7gdBqPc4ZciMz0bV7r4OK4zm6K/FkZg9jU9MmH7yXqh2GQQXcNa6YrpWqiKvv/y2rKWgRXBuyplR1ApUZjHT2uyCNPJQq3tR+jfUL3KxjI+leheiL7tACSiOqJXyib0N1XuHizTzsgiOqXCEC1eHT5IuC3uYdGXKcK4x67aKAl58I58hMMQ8M1r3v3bUkkHlKLN4fyNM1FS5YvMLhBZ02kTqAGMwNnirKDHnz4OL8Uo9pluPn7kMWFy5Th+FT+kr1KqIZym8KXWbRMOGCB7jQ21TWU4YoHf9YKZwSp6Bg5uw==
Received: from DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20)
 by BYAPR12MB3318.namprd12.prod.outlook.com (2603:10b6:a03:df::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Sun, 3 Apr
 2022 14:14:23 +0000
Received: from DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::d561:8de8:a3fc:18ae]) by DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::d561:8de8:a3fc:18ae%6]) with mapi id 15.20.5123.031; Sun, 3 Apr 2022
 14:14:23 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     "mkubecek@suse.cz" <mkubecek@suse.cz>
CC:     Vadim Pasternak <vadimp@nvidia.com>, mlxsw <mlxsw@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH ethtool-next] ethtool: Add support for OSFP transceiver
 modules
Thread-Topic: [PATCH ethtool-next] ethtool: Add support for OSFP transceiver
 modules
Thread-Index: AQHYHALijCACVskGfkuLR3GKhqJ68azekVSQ
Date:   Sun, 3 Apr 2022 14:14:23 +0000
Message-ID: <DM6PR12MB451696241B52B22D20171120D8E29@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20220207091231.2047315-1-danieller@nvidia.com>
In-Reply-To: <20220207091231.2047315-1-danieller@nvidia.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f41939bd-0d4d-4645-cef7-08da157c40b7
x-ms-traffictypediagnostic: BYAPR12MB3318:EE_
x-microsoft-antispam-prvs: <BYAPR12MB33183B415443AB8786B22331D8E29@BYAPR12MB3318.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KDTGwkVB5/z+2zamzXLtfEwsKAfuvDzLAmtjgivcTiIs8ISx/TLGNThEJiUIS5aO+spxYfgPQkVz6priu047mAv6ow/LndELvxdrFm/yGjJxmkpcV3d5uC0YLMXGtpnrAmwIUQK67VaS6RaaQRyQUp5bjmX7nFb1+nqKySnJ4piRstm4W8BKqmw+b8N4dzA8qoAizdK6U8W3vBcgSpP9iBZfZ7njh+cDJ6/EsNKbThaYqAz6Ducy5ftIAuBsNz/rXTPmjKFsU8K/Ns7WSukHK7pfOGLQoHv0tJ9L15B1bfAvKtTkSnSSJB0J2GDx6OPyi5lf/mSRiuK/imFrshnZ1pmhQO+bNimKYI8ktYEaFS/sKBnPNKiTOeEN6acWhSwyr4CtZmyYFOkA9Oe5l5hk1GIyza4magTj4RXCdW0XA9SYy57JzLvxl19VRwuMEN3lTOTwIWrT2Kxlkq35sCSBNX9hjRseGiyRr/tkTsIKkYnuP3BnVob3jusPxzJeZ3J5Vcln6/4KC8fa0X2Jg0nLCceQ5MnFhhWud3fhF2ipdpTCGzm8RFVztioFTUI8UPBwo3shm2aQSH1ZI44inNRQTeU9+MMD3oA/sKJdaGCkIwIT29Xo+AoXB3BCYQkjH6dM1+LTPKf7Ej2LAi/baYIvcojaYS+W/2FAumx5/S7q5dU90HAzQgGnRDKTSiQZ63OGje1ewrYESrRl6bhqEFY4sg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4516.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(9686003)(71200400001)(6916009)(54906003)(38100700002)(66556008)(64756008)(66446008)(66476007)(6506007)(66946007)(7696005)(316002)(508600001)(86362001)(38070700005)(76116006)(83380400001)(122000001)(26005)(186003)(53546011)(8676002)(8936002)(52536014)(5660300002)(55016003)(4326008)(2906002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Q7DnB7j3T/l91eAbvW1eoO4triyuD992d/I4FZpMGJzQ3bMnYnQquN1I26jy?=
 =?us-ascii?Q?582J56rSxWQkgzzppUOhQE1b0TvpDA/C4pujwPZBCOP8aEA54SVb59EnDz8x?=
 =?us-ascii?Q?pzhAQSfHGY4+t9e+/OT2/huWdSvLhpXTghQDE5oU7XJwdVvt+rA8HzsB1T8e?=
 =?us-ascii?Q?KJsNVGgJtg5Xb7Y7wx60rF7L2LDOoBVUt/QCAU2eh48P5ynnBI9fmWjYRuYY?=
 =?us-ascii?Q?4vyPDfiBvPv4piF6lTIMdO+vKA9G18/RcGPzFlvngSP87YLXDHDcpbbBFczA?=
 =?us-ascii?Q?ZvP/6w1D0h/zAp4NH35eLnQKPrNwLQyWDqCZgOUvuPbj44sLaG0knED42jy5?=
 =?us-ascii?Q?RZJQIulH50hj6vZBZO8qF7fvX/NgrIDvOjnqlcESSM9+0+TRX1qG6AW8IEKN?=
 =?us-ascii?Q?kMB0wPnaA4f+U8cYIJLq1AhF91ojVqT6/Y3LwJvx6+eC14ZT15leUQS0cQI/?=
 =?us-ascii?Q?3Uo2zrAcnnNDo6DiNnUfKLIFjYIe4G55MPscYUEQmms+HcpGFEP3fFPv7fFn?=
 =?us-ascii?Q?ZpyyXx+wH00HmCy5wNGQrfhL0zdHTJ2udqxRSUfVB1ztFj+bVh6FPzHKbGSw?=
 =?us-ascii?Q?S12WktRhKVoWYi0LJay5+1+dIwTr8YQb2P6/KDDNdVe7EPx7Ema3M4srprK9?=
 =?us-ascii?Q?DX16T8NnV4epCLTtvd/dKLSkvZ+0uhafN4FOOT6u6v9oQPRCoUHAZntbzXWW?=
 =?us-ascii?Q?1lQUKXIkVu88FjvLhuQcGdyZgZYSZD74DEnRydZGZ5SwnF88/lqpBEp9P3FJ?=
 =?us-ascii?Q?NoPSp/y/X/ttkl6iTCYp0dRuPoMVoK3DCFd8OgS6rU649LNNFl7lUw3u9Nmd?=
 =?us-ascii?Q?wyigzVs1+IbWOBYY32+02GM0IW0xl4Ns5CE7hDfgptULMClU1pDN5mRMZyad?=
 =?us-ascii?Q?C8trpDR6VByJ9kjUVtJU+PUG4hY1Xn5G7kw3uQlIeSBtuQfsCZDSufWSotZM?=
 =?us-ascii?Q?VoaDOeBWts7Hd8zXTQ8b//6+liFHRAatOM/bz3SMnmH32Awsloblh32f8ypH?=
 =?us-ascii?Q?IYbd3Z1bGMSBQ4f1TPCk88geeuQeXGEw8beGS5tuvn/iLJ8UVKpldP6/F1OS?=
 =?us-ascii?Q?GpfkANUKaQPHPjNCoUo6DYynyi+zv8pwTi4KWvSM9LPUGaEivNKOKrwJXvdO?=
 =?us-ascii?Q?LOAQRV2UuhCoPrpD1Wsd9CBjxfufudfvom7MBYsl4zooVQniQ4s07zmkKSZH?=
 =?us-ascii?Q?7ijn4Qot9PrfLf+du/TWC9/u6ZrcKkCMC9kJLsgLqpr3b0wQMr/Ym1Yzwe0W?=
 =?us-ascii?Q?m/q5a8b0zorax4o3JhoA6LSBCLlYNjR+odgbL3DIjVk5kA+CzOnqvNzocuE3?=
 =?us-ascii?Q?3sJ5eyn7sKaCMWPxsPMBduHbkU7ymPTSTN6FQY1v3pG6xmXfwxVSHtrQKgVO?=
 =?us-ascii?Q?AbiONRwAD9UvS6Q3zfH12K1SvZKJRQxaF9+tXCIcu1fpeN0dem5nlLxQ5IA8?=
 =?us-ascii?Q?xpILJX9MuyD2Z2gqHmomktyCmRYkD0Og+vNXpmdXioafsNkFWsthd4gELKyP?=
 =?us-ascii?Q?kzxHaH1NOTrTu8tnfjy6Ftip1OtJze5MwL+S6TI0/uHiKrDVImI1yTLNldIQ?=
 =?us-ascii?Q?bZwSrkQRvTgcCpCkiLBkmlN+N0lBJ3WIkjRjLcCy58wQ6KBUbeEI1vwFCSUJ?=
 =?us-ascii?Q?F1cE3adygazBc3H3eqnNuAEpXCYad/n29QFwNKFYe3IU6QeXJpSaCQKZJLoZ?=
 =?us-ascii?Q?JwJQa3Nr1iijfieHo2iNT/1pWpxOpAhnmnsdKFA/Zf7gP7MyhfKVV1bqxPoT?=
 =?us-ascii?Q?ObSfEwTHrg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4516.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f41939bd-0d4d-4645-cef7-08da157c40b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2022 14:14:23.1637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +Fio0TB68wtyDoF0bkWaG14VaLd6ctAw7qgk0mGE/FCNcyLwzRuz52weXZ8T3fK7uWEIMzHxRnWLBWOvtbEsJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3318
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Michal,

Can you please take the patch?=20
I haven't got any comment about it.

Thanks,=20
Danielle=20

> -----Original Message-----
> From: Danielle Ratson <danieller@nvidia.com>
> Sent: Monday, February 7, 2022 11:13 AM
> To: netdev@vger.kernel.org
> Cc: mkubecek@suse.cz; Vadim Pasternak <vadimp@nvidia.com>; mlxsw
> <mlxsw@nvidia.com>; Danielle Ratson <danieller@nvidia.com>
> Subject: [PATCH ethtool-next] ethtool: Add support for OSFP transceiver
> modules
>=20
> OSFP transceiver modules use the same management interface specification
> (CMIS) as QSFP-DD and DSFP modules.
>=20
> Allow ethtool to dump, parse and print their EEPROM contents by adding
> their SFF-8024 Identifier Value (0x19).
>=20
> This is required for future NVIDIA Spectrum-4 based systems that will be
> equipped with OSFP transceivers.
>=20
> While at it, add the DSFP identifier to the IOCTL path, as it was missing=
.
>=20
> Signed-off-by: Danielle Ratson <danieller@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  netlink/module-eeprom.c | 1 +
>  qsfp.c                  | 4 +++-
>  sff-common.c            | 3 +++
>  sff-common.h            | 1 +
>  4 files changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/netlink/module-eeprom.c b/netlink/module-eeprom.c index
> f359aee..49833a2 100644
> --- a/netlink/module-eeprom.c
> +++ b/netlink/module-eeprom.c
> @@ -223,6 +223,7 @@ static int eeprom_parse(struct cmd_context *ctx)
>  	case SFF8024_ID_QSFP_PLUS:
>  		return sff8636_show_all_nl(ctx);
>  	case SFF8024_ID_QSFP_DD:
> +	case SFF8024_ID_OSFP:
>  	case SFF8024_ID_DSFP:
>  		return cmis_show_all_nl(ctx);
>  #endif
> diff --git a/qsfp.c b/qsfp.c
> index 57aac86..1fe5de1 100644
> --- a/qsfp.c
> +++ b/qsfp.c
> @@ -947,7 +947,9 @@ void sff8636_show_all_ioctl(const __u8 *id, __u32
> eeprom_len)  {
>  	struct sff8636_memory_map map =3D {};
>=20
> -	if (id[SFF8636_ID_OFFSET] =3D=3D SFF8024_ID_QSFP_DD) {
> +	if (id[SFF8636_ID_OFFSET] =3D=3D SFF8024_ID_QSFP_DD ||
> +	    id[SFF8636_ID_OFFSET] =3D=3D SFF8024_ID_OSFP ||
> +	    id[SFF8636_ID_OFFSET] =3D=3D SFF8024_ID_DSFP) {
>  		cmis_show_all_ioctl(id);
>  		return;
>  	}
> diff --git a/sff-common.c b/sff-common.c index 2815951..e951cf1 100644
> --- a/sff-common.c
> +++ b/sff-common.c
> @@ -139,6 +139,9 @@ void sff8024_show_identifier(const __u8 *id, int
> id_offset)
>  	case SFF8024_ID_QSFP_DD:
>  		printf(" (QSFP-DD Double Density 8X Pluggable Transceiver
> (INF-8628))\n");
>  		break;
> +	case SFF8024_ID_OSFP:
> +		printf(" (OSFP 8X Pluggable Transceiver)\n");
> +		break;
>  	case SFF8024_ID_DSFP:
>  		printf(" (DSFP Dual Small Form Factor Pluggable
> Transceiver)\n");
>  		break;
> diff --git a/sff-common.h b/sff-common.h index 9e32300..dd12dda 100644
> --- a/sff-common.h
> +++ b/sff-common.h
> @@ -62,6 +62,7 @@
>  #define  SFF8024_ID_CDFP_S3				0x16
>  #define  SFF8024_ID_MICRO_QSFP			0x17
>  #define  SFF8024_ID_QSFP_DD				0x18
> +#define  SFF8024_ID_OSFP				0x19
>  #define  SFF8024_ID_DSFP				0x1B
>  #define  SFF8024_ID_LAST				SFF8024_ID_DSFP
>  #define  SFF8024_ID_UNALLOCATED_LAST	0x7F
> --
> 2.31.1

