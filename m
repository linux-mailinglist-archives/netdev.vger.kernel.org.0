Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2FB45B5F0
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 08:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240520AbhKXHyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 02:54:54 -0500
Received: from mail-mw2nam12on2066.outbound.protection.outlook.com ([40.107.244.66]:54751
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230121AbhKXHyx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 02:54:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hhilQRvH97a9CnwcgyrOC35k67190ifwX2Y4IcbuHOSTbzzLTBUS0m4q2WNPALLCX2rWX2uOJGVV8EAclOqHnxb9VHVsdpjfZv/Fle2NrU/ekFzRE+hZVptxebagWxLf8HPl4iB1TZkBPDul7mPdS3kYPxmJMy5TpyolocqulN6eyShnn43wYzLJlCyurqhs39rdw/N1q8uCYmJt1HpDZv0KHCdCqeTV0l5LNeffvawl3GaZZEty5gtxOF7WUlsRySafantkWZGped2APIHMV+aPv/hjNdygXuuYnWIB8sIv8e+OhFy87MzXvAmrbkimvdzQ9JVs/AcLoYvh/nE0Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xHAUFiUT/LfwItQH2eZPVCpNSUbsp4RqTDBBzMv4/Bo=;
 b=njTplbdJChRttMPJ+BCqk+y+BSBQ0gwZJV4gJm3nRaZmwl+m62IQ3FEqtLUONb2f7Keh4b1LBHB7wJQ/j3OH62ponnsGCx+evbRsxvU8al8zyNpJoey4/POuYZmfGBiDSgGTwkvSLMm2fRMsVWjiFuvX2m/6tUWmi2yHhvpARA+5e0BKqBfgB3slzj/JOt+uNO+D5IfM5kaDfoaIw8fp34DOOF3g9ZcYMvyyHo+iN57Ojku9JbF0ZNba3GcceDv6enlnN7pQaw0n2etJzHst4MVV1Mo29p3vhBFO5q4BNxVlsUQ3tdSqyhdW/muQDCEOFaO/mrCNgz6GvzsxLetnNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xHAUFiUT/LfwItQH2eZPVCpNSUbsp4RqTDBBzMv4/Bo=;
 b=lNNadeHJ/+mcsPi4w92RhZfu49Rh3fWGdzFgMvW3BL5S6LSX2GGiltFPo6q0gxmiwz80oi0z3x5AFI1HdnqJ4jmY5p+3iSdpkUknMGgpRX2TSDkX9KuC/69bMCZcIdzWXU/uOfoJ0VPuze37xEzjC7ghVEmh+9vfn8UQ/VxVWA8KolgpUyUP5w3OTvph9tjf6lD7duWzWR//WilkSX2DRehVgS4+KRbN67AoPuOct1ypl/YYSYWIb6vqzOUicxTLLl+eDFdXVUESVWTYueO9C/Yi6Dojd++XSvZG/tv2k1IqCecanVxFj68LZJZGBSHoc8jFGjYjGpmJs0YaDZw6ww==
Received: from DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20)
 by DM6PR12MB4699.namprd12.prod.outlook.com (2603:10b6:5:36::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Wed, 24 Nov
 2021 07:51:42 +0000
Received: from DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::a5c1:7bee:503f:e0d0]) by DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::a5c1:7bee:503f:e0d0%8]) with mapi id 15.20.4734.021; Wed, 24 Nov 2021
 07:51:42 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: RE: [PATCH net v2] igb: fix netpoll exit with traffic
Thread-Topic: [PATCH net v2] igb: fix netpoll exit with traffic
Thread-Index: AQHX4KpS8IRO8CTaPUObrYaieVzqnKwSTnvQ
Date:   Wed, 24 Nov 2021 07:51:41 +0000
Message-ID: <DM6PR12MB451635351CFBBD86059A0078D8619@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20211123204000.1597971-1-jesse.brandeburg@intel.com>
In-Reply-To: <20211123204000.1597971-1-jesse.brandeburg@intel.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28f1205e-8314-426f-1dbd-08d9af1f4120
x-ms-traffictypediagnostic: DM6PR12MB4699:
x-microsoft-antispam-prvs: <DM6PR12MB469961C982CA7974752E10CAD8619@DM6PR12MB4699.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f6Y1mcpG5t5B8bolZZ2VpKgZ+KVE6F89GPxPsBjecm53QzyZoupK+ETBmlBqOjcbn+OIN728G4P2hH5VzVKFhjvLuFIYnr4pdl+HHl9ERn0AQMnk76xF65oFKcKDRFgyyGD5nq4AbT3yLtX3QksVEF9PScywyN9TBUa1fq0xNlwB9s7pkh796wsr6WATGdfIODSQzNxsX1GP1OSezNsBQycMru4hBnBfOqmOeBFnXCuEUKFV/oDGOFgF1PwyZGiYFXuvQT/7ZPGBh1/aDczi/HuJ9t3cOqQC8UPj0qEilvw+xFqdGEnTUTcJaqxwFZv62lUYuXIykFHDtHC+ZzE8D09ztDOyfD6jHEaZoEvwAf44wLuEDkgJI/0ZlzrqM2fMciM5yN3JpRZ+L1QEeYWlSqeQuyqGM8ip45hKOGXDyGqW033fYcj7ysQPiriizhy62zqJTyfe4dz+y5bXlMDSBLLTfQYp0kTvONrKbI4O5TU740ienfSfGg5G/Ku3sPoPVTP4NZKRieKsZt7wd1d+Oh0RENb0zYfXg0wYZ/2bRcFIw5W3DESvupZ7LAA7Bv3PPmIyM5zxn3+Wcn9/Ygi5Y/ZJxx8iNVhfAtFLAgzuAZMpkQ+S53VlZTBsKxqElnsjc6IGlCXM5WbJNJuhuwIiEDy+2PNZHAk9tFPbQXP5lxNNfE4SZJBL5+SkIljjlLwSiF+xtwolIPYnfBOs+wycRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4516.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(9686003)(66556008)(186003)(8676002)(53546011)(66476007)(5660300002)(71200400001)(6506007)(54906003)(66946007)(4326008)(8936002)(26005)(38070700005)(64756008)(33656002)(76116006)(66446008)(110136005)(83380400001)(122000001)(38100700002)(55016003)(86362001)(52536014)(508600001)(316002)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wFlco+qKQ9fJl4BVil4H0gIqdPuytx1z/eByDBqCD5S5F8YXa7k9POo5wb4t?=
 =?us-ascii?Q?UMoXttZPF0zzKBoM/p0f3pZw/oYqU4ulU39/ajLPgk+aHCYXBcgve8HGKW8j?=
 =?us-ascii?Q?sXbY5RcP/698JotPSxWqUT9u+TrRhZwyyQKkOy+TfWqCKSsQQulOIzXrMBHg?=
 =?us-ascii?Q?VD6zzK2FNHE6IrqV1pT5Dbh0xoe6D8GRa7naoa9zBKQuDiyqdVfT4F7f0Ynh?=
 =?us-ascii?Q?9IxuLI5Zec8VgEia30mGq6h6c97uko/CJTfrF4Q/5D5KNJ/BL/Z7KJydihUU?=
 =?us-ascii?Q?Bb7nt+D21YZqZMEryuDCK3h9vn5epkjGr+hqz1iTyzbfujilx0XN+avIWH01?=
 =?us-ascii?Q?IN2Achsojq46HYbZIyTJsyiGv0bhxrH4v1/aY1UkOrIQXfBSUVuEd5mubYSs?=
 =?us-ascii?Q?ErOw+cirEHJtGwGbBCNqPodOi6NlDyVCqNgshCpyjqCaXSZwRkfWtnAFsPo2?=
 =?us-ascii?Q?FASq2D0+JG8QlYQcBvrB7BbG3ZB6lFB4UZ9k+O8GNFr4+hvb8QbRacCw+3YW?=
 =?us-ascii?Q?e4GMDZGZjiRjyvgY26rRGjOu0pHGtaByjtPaFul5f/aT8pfFtEceWoQATMs4?=
 =?us-ascii?Q?TvRA8Txwu5CCKa+nGtIwPLkyU5TvTJ8KqFj6TCxIk3gnRyvsMhuEmLjRHbwU?=
 =?us-ascii?Q?FzpD+Rm6BH5noBGBZmOcBQKiFNplKUj+cEVrbWPcrNFP1uz2Gc3Mjva7/ntq?=
 =?us-ascii?Q?H1YpsrI13F560KaQXQ4bPLUJYYNvrsKxFhJDgx2bVajktUXQg2BXDWYhIXhW?=
 =?us-ascii?Q?LAu3AdOzk2agEDbSy5bEbl9IefdIrhnVxtFq8SyA9fv12+s30sT6CI7z/Gfh?=
 =?us-ascii?Q?w0/ihr3JaFP2iaCUN34/U9CeuSufZcOky5SGOrlSx+Mo2kok80NJmG1PtXhu?=
 =?us-ascii?Q?XvDbYOJZLKotLA5KIUsG/2TCRcm7gAGy0EnOJFALX3OQ5iV6YXXKei2WYDt7?=
 =?us-ascii?Q?tS0JKTWrRLxvdTLEnUQwa7w7tURLAe73lv138i2sgoI+8CSHPw5lgHAS82II?=
 =?us-ascii?Q?/pN6FAhSN5M/R39qakaFYOxFjcne2GWrqSnmj4kMXsuXt5v0BSN6qHgoFvje?=
 =?us-ascii?Q?kMdlSOg6qrV3YddXiuAfJF0SuID/I1VgUCaPzB9YNPYUB4fUs+F5CNXj1/eA?=
 =?us-ascii?Q?80apiu17yVn2OejcISoVJFhiTAUpMNyrjFVIv1CLfV+O+xWpCvUFRWPGv17y?=
 =?us-ascii?Q?IkoEhbYYNxQ6pShOdDCumu2EdyPJMWtzzkAaCdYKGmxsavWacXThWcUy6M2n?=
 =?us-ascii?Q?bdFTDav2rbvkEWEunOUFaq218CRvdEZTvX/Gx4Fsgk2KgOyRQ7g6g8cZT9A7?=
 =?us-ascii?Q?GGgSnl08ahPifofqoJGzahVmzpxVO4AS+zEr6I254CS3NrXjwye+SQ5pya4S?=
 =?us-ascii?Q?uY/ybn7zoeGA+Sm1LekjRvwk3yBRBa+UQ5rcEpzF3IjkCwgwRi3iHqve6Xxo?=
 =?us-ascii?Q?m2Vvg38F4AOf2gGEjUveTOfjwQE+tWHSK6As2U0Xr2ZfXABxgnhaWwfM330c?=
 =?us-ascii?Q?/n6jlkRS+mkCsBf9h+P+d6JZONnsTNNVQyb8b+pxRHqlQp5NuLWC1IqPue1O?=
 =?us-ascii?Q?U1nIhRZULi89xnwp8onPPbd4ecayO+7SS6IVO1JLYILZZbzWP9l2bWxEqGv7?=
 =?us-ascii?Q?JtUqnshkiB+bkDE4cUZMebU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4516.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28f1205e-8314-426f-1dbd-08d9af1f4120
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2021 07:51:42.0140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3DQgx60npcuIyWI2dhlDmzLaN9S0SDqPw6bWAmLaUEjujgYZz8Awh+tj6OB1x6uvkj70fuB0NoCgHiBpXaR39w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4699
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Sent: Tuesday, November 23, 2021 10:40 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>;
> netdev@vger.kernel.org; Oleksandr Natalenko
> <oleksandr@natalenko.name>; Danielle Ratson <danieller@nvidia.com>;
> Alexander Duyck <alexander.duyck@gmail.com>
> Subject: [PATCH net v2] igb: fix netpoll exit with traffic
>=20
> Oleksandr brought a bug report where netpoll causes trace messages in the
> log on igb.
>=20
> Danielle brought this back up as still occuring, so we'll try again.

Hi Jessi,

Ill run tests with you patch and give you results for if it is ok.
Thanks!

>=20
> [22038.710800] ------------[ cut here ]------------ [22038.710801]
> igb_poll+0x0/0x1440 [igb] exceeded budget in poll [22038.710802]
> WARNING: CPU: 12 PID: 40362 at net/core/netpoll.c:155
> netpoll_poll_dev+0x18a/0x1a0
>=20
> As Alex suggested, change the driver to return work_done at the exit of
> napi_poll, which should be safe to do in this driver because it is not po=
lling
> multiple queues in this single napi context (multiple queues attached to =
one
> MSI-X vector). Several other drivers contain the same simple sequence, so=
 I
> hope this will not create new problems.
>=20
> Fixes: 16eb8815c235 ("igb: Refactor clean_rx_irq to reduce overhead and
> improve performance")
> Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> Reported-by: Danielle Ratson <danieller@nvidia.com>
> Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
> COMPILE TESTED ONLY! I have no way to reproduce this even on a machine I
> have with igb. It works fine to load the igb driver and netconsole with n=
o
> errors.
> ---
> v2: simplified patch with an attempt to make it work
> v1: original patch that apparently didn't work
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c
> b/drivers/net/ethernet/intel/igb/igb_main.c
> index e647cc89c239..5e24b7ce5a92 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -8104,7 +8104,7 @@ static int igb_poll(struct napi_struct *napi, int
> budget)
>  	if (likely(napi_complete_done(napi, work_done)))
>  		igb_ring_irq_enable(q_vector);
>=20
> -	return min(work_done, budget - 1);
> +	return work_done;
>  }
>=20
>  /**
> --
> 2.33.1

