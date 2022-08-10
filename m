Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10FA58E669
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 06:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiHJEbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 00:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiHJEbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 00:31:46 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2130.outbound.protection.outlook.com [40.107.243.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C49582F98;
        Tue,  9 Aug 2022 21:31:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZUbDnVRHwKNKJGkWDP9FgoIOtxnV9difbnj6N/BVFFXXDYzk2gYYUcpOXJeGXWB46jYOPYSXddH9PEtmlFR1ew6jvV145tcUuakZOvXPQGDQZWEeegWmuIoK/f9Q2Hmj3sdIGPKcge7yMwuilQSkPe7VAS/Bin7Mk0LE99OVw4R0CREmXO/e9l6Imc40dQqdVUnm7piCHWFZ6E/A3tnWivdA/PHLq4vnUE/JO0NHh10xHFHqbVx32yKCCa5jcyVzT1sJNSeLdOPi2CEGiX+SEFD5TCmL74pxDRnniq3uJg7ByGTnLpwK0IhZRQHaPEuqdbMxIwdCvljli8V157R+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FoVM4tDYZCuGrITwQGB0r4AnbdK5QZB+LZtxFOeZoEM=;
 b=cyeI2Sd5bcWZCFrdPafXfrmjJEkAgxL/SkkmIiUaXl1GvaMrDHWjV4Txw1KPC3r0u5TwcaZuVlyRMvL+I6QxG6Workg6BeaLVnDDrMbHY9ipa19FuPGwyNbNKZd4x1WgJTxUxmWrS1V8SzrOsYkPRljo3POxmqHDnRdB9+ttiwsPUAm1E6dslBrp5ytjy4aBMjgh9u+FUSu6/6C/ol5gv0OAkwwpu+8tErCQxvgS0To+cy7sP29y0w7/eVAsyYwg1j/69qKURkEk8Of41yiUelFku7NPY7ijjWG94psSJi6E9xuYTeP44i5dHtnjpRnQUP2xST0jB3TkNp92FfO+uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FoVM4tDYZCuGrITwQGB0r4AnbdK5QZB+LZtxFOeZoEM=;
 b=QsUutRFYx4WuSd6ZKx5W7Dru4cx0tcumr+W6ZsZKVdnimKJXfGYYVdkol7rZvtRuiIa0O7+k6jR+nRs5sGyG6oYcgPbxGAXVgUM6x8J9GiIli3vvm3wrtKowe6uoW+nXQDE2vPz0qPF3ZR/Td9qVFrgq2Aaz7wEkqB8QbD06Byo=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by DM6PR13MB3755.namprd13.prod.outlook.com (2603:10b6:5:241::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.7; Wed, 10 Aug
 2022 04:31:37 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::a9d5:4b03:a419:d0df]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::a9d5:4b03:a419:d0df%6]) with mapi id 15.20.5525.008; Wed, 10 Aug 2022
 04:31:37 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jialiang Wang <wangjialiang0806@163.com>,
        Simon Horman <simon.horman@corigine.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "niejianglei2021@163.com" <niejianglei2021@163.com>
CC:     oss-drivers <oss-drivers@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] nfp: fix use-after-free in area_cache_get()
Thread-Topic: [PATCH v2] nfp: fix use-after-free in area_cache_get()
Thread-Index: AQHYrG6K7FBsW08rDkqTULILikrQMK2nik7A
Date:   Wed, 10 Aug 2022 04:31:36 +0000
Message-ID: <DM6PR13MB3705EDC32EDE9FD97DA47F8EFC659@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20220810040445.46015-1-wangjialiang0806@163.com>
In-Reply-To: <20220810040445.46015-1-wangjialiang0806@163.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33e56c58-8fcd-4e79-a9a9-08da7a893678
x-ms-traffictypediagnostic: DM6PR13MB3755:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H1EBTWoTKjKp58V5MMrYV+YPD1uUJGuGyf2+1j8LW7DQFqT/r/1uzs5Mij4BDo1kB5loidNi6pKmnLcsyZQ+YnmJv/ot6l7prUHbhxk9GqV8aPc5x2zxgSSZ4l8KUlTmMnU09JMsnRQA4q8NWns1eESz2wA1MiRKHHjB+D1SsYlvgAmoyCzrwUu57WEvzTHrH/6CbVWAI9I1mLCDKwBGF0LeCHusGTONg6QxaBq+QPSMpA0wse6k0eJ264jF5WgTK4DBSU5cEiNLb85+snkENlHrW6EJSm9go8UoDwgoBFioeot/qybvXQL4W7kj4T+r9y94BqoRkIyfWokngwjvBiagJp+sfgZG+ypCtN6IYFKTayAk/Wr68Ht+WBkbwxnrHoHLMm/n8n+LeB0GOv3VUfhi2D1EbYFTpmDyRgPDRU1jV/9hnqv0mvZgi9IE4dFdLWZdT9twxdhrdRqaygC94a36kmQ1/gtiP1NXIwPkbV1zXV10bn60FuL+UMkdi0BRqoiu1h0TPTrXMU5cdnZzfZKL0CjLIyF9p62LgfVOJlPrzDo3Uvf0mUNIj+keOCH17PGQi570sDGZJ9rNmxbr1qEW5ZZ7E1pl0/qJCTdEYVWBH1u5+EuutB1MErz3zvz9FwCSwtKKa5u/B26bp8Jza6yNMdNU630nyV2tJttlYw1mPjMrlxK4+vurjlwTFMEITbyhHHgt43Z0/Ec2Qb1tAqKWrnHYxzuLH/TK+5QkS55P+e/odLCnvB/AFVm3ObXTTOulcTUcslECwirNpBR63Ihhb913zh6f2drV60BiFUksg5fwe7uFz0ma3SEqk44+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(39840400004)(136003)(366004)(86362001)(38070700005)(41300700001)(33656002)(38100700002)(7696005)(26005)(6506007)(9686003)(186003)(54906003)(478600001)(316002)(71200400001)(8676002)(110136005)(64756008)(76116006)(66946007)(4326008)(52536014)(66556008)(66446008)(44832011)(66476007)(122000001)(8936002)(5660300002)(2906002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WnjD+9DsHhuDMKIZAdqlKBdxEihORmek8GoYWhedpVQPA4AlcLzndkAUOge9?=
 =?us-ascii?Q?pfT00gqxzoRV4Lg8Ia0dm3U/DjLwrn+fb8jNHa5N3KFxvOi3jGTzBxJD24JC?=
 =?us-ascii?Q?4b8pNj8y2j9Dd3ERTRlBezdWlOteCwUhnfoL3ygbRh7gLu8JXggXA3Cy0as1?=
 =?us-ascii?Q?Z2WVhxxATMowGShDnFekOojzONBBcdvQ2uJqD23QC3ZyX/Sw2fw1J+aeI0p6?=
 =?us-ascii?Q?rMpiKd33SICsLc+1fecmM2xRbDZzRb7V5o36QPW3NJbpo11jxIDf+BRv5ZMB?=
 =?us-ascii?Q?toQ7cVmPHcN9Mu1RSKg0Im3WqYZJEPMjWzOztMWYmXqT6VssdJ84ClrsTLA6?=
 =?us-ascii?Q?tCBzSK/H69MjhToXMhdZwu567ZznMuaDA+9DGM/lDDJ2k/haVv4yCTGtVVHq?=
 =?us-ascii?Q?0nfJ5abQsSbSTFHL3rF/KIi0e6bketr/iEdPL36R2aHBMiAERFUO1zsMypl2?=
 =?us-ascii?Q?ye5lEEkplfV869K1KpQjFzNkRfE5Jt1J+IOP4SMAhFhvnxKsSXwjZt2mFrEe?=
 =?us-ascii?Q?QS2qD5MVQiojf+81Q/V8B+DowopM/ABC1+edmdPsjPbe/Ac+siqaDTqBf1DQ?=
 =?us-ascii?Q?uAK3deCd0+UiQbzr7e6r9L9IcjN/DYLSjzAUjqFrNd7UGN+Fx3W149FLtnwk?=
 =?us-ascii?Q?zTr6gBfItMAwWeZNHSjhaq+5gAAcYjY0slUes55hwY7wPZS4kA007yEg0veb?=
 =?us-ascii?Q?i2RFLGxjVorJ9H0+c1lKJqRwHd9xMfo9PL/hLJYu4Ujxh4G1mmsD7Vjo7P0l?=
 =?us-ascii?Q?f4b5Uf4O0AsL6ZL4l/7uI2zKrFuc34JTieSmI8iKVAm/X8CB/az/pLFFgtFG?=
 =?us-ascii?Q?4Z+PH2To1bPC5PG7cRd7VXyKcrlR4BFpDQ/8mAFECFeeoSCTa0/lQzwdkmlX?=
 =?us-ascii?Q?61cOGX8jfK2rc2I78XeiQQibej79KPvq5joWhVnp5C677eAAGsji2VOL37d3?=
 =?us-ascii?Q?yJqxoxRErekiymzjmHozelNBZXlChEQlmx2yxEBZQ39kJWyllc/uzlBmiGj+?=
 =?us-ascii?Q?ZtoTbs8MNBaL6/TBzFudNM5FL5PYUgGqE3atrF/hRdBOBDaKFKVLlyNCGZ0I?=
 =?us-ascii?Q?9WJDhMa+cGQpFwPpsVcQEq4Fg5g+QGUVYroZ79MB3DHrBaxKivjY0G5OqcUj?=
 =?us-ascii?Q?lLrRqLjBY4NTIpNj/RL1ywFOfhEVr5JxdgPZXj+4dpODNlzNPhRn/OmRsGsF?=
 =?us-ascii?Q?g0HDgNbsbalAvqqLTF7AWXY9DuBhN3N76O+XmXwOsbv8sSvyk0liaPEFH6aj?=
 =?us-ascii?Q?M3oVPdUrNiUKMfdBqniuKjTGcyWvrPfsGsKOMF6fTQz2WZvExkZQXcVrbsCf?=
 =?us-ascii?Q?7PuBCe3t4MC3eVXvjKxKdH+CU9XWS0PJ9M6wBZ2G/TrGmHg5pw0OK0PsNDoM?=
 =?us-ascii?Q?hFKevWEEnrTMAEqiltzvLlUruqPdKEte8oGnN1tUdbev02mboIEKxKmIUs0v?=
 =?us-ascii?Q?Ii4hkiVM8TesoIk45Hws3BuVOmWNPHRWkgbAEcEmgd+tplZ1YSkCa0MuDFxu?=
 =?us-ascii?Q?+d7DaFdMbS34QeXLxWCL4wYDSLL+PNhdWvS8x1ejxWe1tPfvhcmWkYsUVoAm?=
 =?us-ascii?Q?8MAI3dSo/JxPEB6GKijaUyflNvwUICBGJnWm1JbC1ml0r10ZFeYJJnFNX+Uj?=
 =?us-ascii?Q?Xg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33e56c58-8fcd-4e79-a9a9-08da7a893678
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2022 04:31:36.9175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xo+PIo+wNVy5pTnokM+A8nePTt2GPLu6osWWJ96MCS0Su9WmFc8lZe5NrVKNlrjwxomJgA74CIz0vhz2bhGjq05L3UEt+eQRUKvFX7Aeabk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3755
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Aug 2022 12:04:45 +0800 Jialiang Wang wrote:
> diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
> b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
> index 34c0d2ddf9ef..a83b8ee49062 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
> @@ -873,10 +873,6 @@ area_cache_get(struct nfp_cpp *cpp, u32 id,
>  		cache->addr =3D 0;
>  	}
>=20
> -	/* Adjust the start address to be cache size aligned */
> -	cache->id =3D id;
> -	cache->addr =3D addr & ~(u64)(cache->size - 1);
> -
>  	/* Re-init to the new ID and address */
>  	if (cpp->op->area_init) {
>  		err =3D cpp->op->area_init(cache->area,
> @@ -894,6 +890,10 @@ area_cache_get(struct nfp_cpp *cpp, u32 id,
>  		return NULL;
>  	}
>=20
> +	/* Adjust the start address to be cache size aligned */
> +	cache->id =3D id;
> +	cache->addr =3D addr & ~(u64)(cache->size - 1);

`cache->addr` is used in `area_init`, so it should be set in advance.

> +
>  exit:
>  	/* Adjust offset */
>  	*offset =3D addr - cache->addr;
> --
> 2.17.1

