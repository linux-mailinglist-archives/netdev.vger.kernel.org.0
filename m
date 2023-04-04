Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBA26D6797
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 17:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235740AbjDDPix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 11:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235811AbjDDPit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 11:38:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29CA49E6
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 08:38:24 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334DwtTD022669;
        Tue, 4 Apr 2023 15:36:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=1iTyPtjP8BT+pBQrj82x0ceuVOmed1nrW+Bs814SQss=;
 b=ZjRUDperOlqEbCuKim0HfjBDAqQ8noiiJPA2b41FnkTSrioJLpc/3YP0kmgMBvrBGrov
 ynvb6LojnLrku8lkcaEvTjca+zKAgDLl2Atq8vEpuJYA7FJHmweSuG0ZiaIFmRmbHo++
 DDTKSfG2QQ64f+4VPyuhYXwYeuzr+udykbNNt92ghudhC+atIom+SuJH5LgUnPeDFt3A
 m9kOh4jG+NCix6nUSEjYk6M7s8yKjQwhdILTtV8K1ubSUk+VGflWnfH9U01rWgGLYrv3
 28FN6pRqVep61lUU4NV9NwDyfjICkP9epfOQswdni+LnwFGn3K923tYD4foDzQP8KGMJ 2w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppc7tx3ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Apr 2023 15:36:48 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 334FMVBd001268;
        Tue, 4 Apr 2023 15:36:47 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ppt3h9spq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Apr 2023 15:36:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bo+AbSF2N6n0QBtWvGzh4I2PXL3gTfJPdflpL9xnb2rgoNpfHeP/umJ90NgqIpsSnWjRija602QrBWHmGncJJtiprMGbJL/iJUAKNRCtaletiztZ906e/iERml2J9z4tKhMCp5NfsYsGT60aqoKwMeKnq69kmMoLxk5oCtDi8xlNsEikzmWTYBOFCcLw7mhf9SGSsB9/3WZyBus+RMN/r0C4rkrQ9FmihtGet8aSpzfBlLp5/lxz3mlp48vFCDHwo8Y+8fk3V3unMZRiiTYSUXbOwVDBewOMxmH/pjX+2mGuzfpyl7FHKA7LGeTx6wu5MP1iC3PBI8m977B+mNmGFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1iTyPtjP8BT+pBQrj82x0ceuVOmed1nrW+Bs814SQss=;
 b=cki5CD0jQFr+aefC9ieHlAjp6gb7VDpIyISGXeKQpZgk0tnboT6o2T2gbkB176QkQyGppyJoqiDs92MTZm+fsz9iJ3Ok04BBtuEfRNYgX4PpNMXZ5Kg/TGQ2rZw2eT3VFv/xTGT+TmgNbjbpJuAKs7mIMl64Vbi+FXu4CpMpMn1r5CaYJYGqf+1QuWozbpwCUUL4/f84sK0UNMzNM7EHVFfbD00aOmkfyOXGpqV6h8JfWpUxXLpYBdtyRgiSzH9osectTdTHSRCLi7MZGdG1A4xjI9jJtcHJkLplMA9j8je75kYDColO0mpYW2EQ+P3sh4G4w82LHfcwUdWr5Iw0Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1iTyPtjP8BT+pBQrj82x0ceuVOmed1nrW+Bs814SQss=;
 b=NyQYlyJTxxv5/TpL23q6OsvMhhz3UQ+Y58uTitnmNMBaJpN5nzt8OCuvCLtpRS9F1l+t0lfDC/sIZ4GFEnj307rQiVB00UzQ4qd01Gq7r0Z1I9dxwAlq/nXRUVKia0c4ZhI1wJLoTXAwj7crjomNyJKUxaKXj5FGf4UkI1VwdWs=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by PH0PR10MB7025.namprd10.prod.outlook.com (2603:10b6:510:283::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Tue, 4 Apr
 2023 15:36:44 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%7]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 15:36:44 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Boris Pismenny <borisp@nvidia.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>,
        John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH v8 1/4] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v8 1/4] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZZlySHnrWBVVuSE6PrOQpkUIzqK8bSb6A
Date:   Tue, 4 Apr 2023 15:36:44 +0000
Message-ID: <63A1FBC9-8970-4A36-80B1-9C7713FF1132@oracle.com>
References: <168054723583.2138.14337249041719295106.stgit@klimt.1015granger.net>
 <168054756211.2138.1880630504843421368.stgit@klimt.1015granger.net>
In-Reply-To: <168054756211.2138.1880630504843421368.stgit@klimt.1015granger.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|PH0PR10MB7025:EE_
x-ms-office365-filtering-correlation-id: 97708603-3d98-41dc-edf2-08db352264e8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g6iJ3zz4z0zUlD5WWtXa39CJbXSJ9S1bmVTqFQEra/0H/EnVUaoWD94WOUjvUUTo6XtFr8WzLGvvYDY5RA3ZedFkoO9s6sYDBjqQ09AkHy35jzSazTj/z210y9H25f9Orc5mgunrNAzWveOd7EyFhBKhnElrP4CNUie617QSS5DZv1Np3E2XTzRk1aOBWaD/flaXvtmAkX99hrjwmlvM2R25wpGePLGWRLjaq9ADY0uPss+Ar/UKieXhlHKBI4o/trl4p6G5WldoiLNmuSgXRAIZCmzRU345nvnUApli/fp232uGJ5QAmC0Pgr+DYIZlyUzanD3flsHPZ43PjmF6jz5cmv4fmPkIhngDQSfijYTPqhdZ0WCrN02m+DzTL/cGUi5rHkGvC3g0MmV8JV4YsHbONV9Z8cZ35jeuKJG3FZCUzmT2sgN6gnoLHLU0Z0vFEEbCuZFrxWPaxg7xyVtO204ertUO3lGz4nEknOTncOnfAeej0g1ksIx2L2n5ya7V4Ag2jOkM7MT8XCHuB26/SQhkGZw4fW9ak8coSpeZr4ahsQ1CP/8HhnEkhluqQeNjveDChsWU5acaTBoZFwEomV0L0JqEmxpi+p4CsAwVWIOwy3MmyAyQWi8UfZE1zPxvbUNOeuJWRWwfiBT3JxxAug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199021)(6486002)(5660300002)(38070700005)(38100700002)(122000001)(8936002)(107886003)(83380400001)(53546011)(26005)(2616005)(6512007)(6506007)(36756003)(186003)(2906002)(33656002)(54906003)(86362001)(41300700001)(66476007)(66946007)(76116006)(64756008)(66446008)(66556008)(91956017)(4326008)(478600001)(8676002)(110136005)(316002)(71200400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?l5oDAOmT84wH7SIQwBJv03GEvdg6NPxtLAT3816pkYQF0gPy/by4EdpryO2s?=
 =?us-ascii?Q?RMT0crv1wXMlI/yivUrcv1EO9qCIwlrEnP+lgPcbRryOIySff550iNnPzVRp?=
 =?us-ascii?Q?YxjZrTG1Vs9TmxljM2GyCfQJY/nf8CvmrO2u0tpb+jCGdN5jyqo1ot6odhF3?=
 =?us-ascii?Q?BEN5OQ27xTD0Ms0G0cL0ormw+rFRGk/8H9U+I1KZ6tCc5IgO1NTW4fTFNv8J?=
 =?us-ascii?Q?dqfqW34gQZEqh1CYCpZy9faPOCSmtumzN6SXHRATyCrrxinYEweTlLciMJ2K?=
 =?us-ascii?Q?VXwM9ZqXpLY5w3vQhW6HpHtjd3AOorh31GlSFBJSR38GXlH5h1FIOwH7SFsm?=
 =?us-ascii?Q?5klFBHYrqpJ0YyxClZDt/MXvzbxWtWp3W34pLLQEMXrxEZQk7zFtBr4Cyg1x?=
 =?us-ascii?Q?j67HMKeCcxvM9c/0NNm2oyodu+ikLcX4TmT5t/oNn3IpkRNScnTVfe132wYn?=
 =?us-ascii?Q?dUMlpfHLmmdxMXfu8nrVNtmPkPJE2Ax47lYRuD0ZtHHNqgL6lFv16wvKcszs?=
 =?us-ascii?Q?unpBFqiSZWvu0CWKkCRUxUV/b1uPBw6M/y31tDagsB7SoSKIrNc7Zy7kqBMv?=
 =?us-ascii?Q?ElXoZAMq1unPP7i2gIDEM4uoM9TPa0YklX2teFtsilMe+YPwd2vncUs/7Ytr?=
 =?us-ascii?Q?i+lxlG4z1yg225PdHaEYDI8GFV/ha4FdCx22e3a7aqTs/Vgb349IHldEzOSB?=
 =?us-ascii?Q?Bc1l0lcNhAETjQqyQ0wX0P8Byr8yYA4kqEj3JUxa1Bc6aJdjjtx5O8cJ2itR?=
 =?us-ascii?Q?j9AsGL6dEq6A66bjzkdsXHYdcvJQ0fC3/MQ5KFOh78RoyinBNk5rg2PPVufM?=
 =?us-ascii?Q?J95kMW4aQKjhuwdxsOr35vfHoDGStPX9uwsEyqZy8+qrosMAXH+pNFyYUJta?=
 =?us-ascii?Q?Vy0FxNwkUJdGpGWkVRYyDLgzEO4c92rm6tQz7FP0LCRmIHxD0pS7M6dZJzgZ?=
 =?us-ascii?Q?hb19eYN2RaxZsKOIJZ0lv+JV87vc05ANXZA3AkEl6haKWBWdPhFKd57oOpI/?=
 =?us-ascii?Q?/4uZOlgcCE0nRkWVJDcHf3mUgFBC1+F+3rJxte4VEqBSB8F/LeFk6HhiumuI?=
 =?us-ascii?Q?WjndPKnsAS0ONZyKydXFhXZZ8p2IcsLKlemL+/nLR55nU5AmbZQb+Z2fOgZw?=
 =?us-ascii?Q?UxZXTlBqB4dCUMYonPXdSyYlwH9DODSgxQoEZYU6TbGcsWJs0WGu6rAmb8jX?=
 =?us-ascii?Q?b6kyV1AKx+/COdbP+kL0TnBLn6n7dps7kj+bYVM8zVDyiCsGQeCCd5ahpM0r?=
 =?us-ascii?Q?zl9UZzRD/ZdoMjdH6j2fZxc5o4i1QkHWol3Dt5LjyRURbJDmsGeYgRZpYJeh?=
 =?us-ascii?Q?kKpHvyU75UReyM6b7GcK5LU0qNfnTvG1jyZc2wRg9yzyvYTIP+l3vQp/gAyI?=
 =?us-ascii?Q?jKsUe5iJ2p2Fo0UaXO+Ii1coWNIzSP6G3fy4WA3ibuwk5qcRDHTm1j1WA8J/?=
 =?us-ascii?Q?sPumQYe3EtebVClsnAIbfz5oqbDEI4yuLe2/bsXK+nNuvZeEBjdBvYhXhXq/?=
 =?us-ascii?Q?KZe0f+4l5/W2VkpaHHgtJZhPvi4/j4vePntdbcJNNbCt6F5fJSk9/WnnI8QZ?=
 =?us-ascii?Q?+fCC21QQmoJihZYMaazUf5ayA3vCqeH0fNlc+wb8HRI4nFrhqM/coQQ6257R?=
 =?us-ascii?Q?zA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0E96D6D7B94957429A059A95BC711BF2@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: dOhxWE31cBCM7PkWLAPSJjZROxQjZFaB5o8aL7PWaNvlaIY1SFsOHi9Xlw4Cq6fu5QlbMYoKGwXae4cGBE7cbVG+Zdz7YhoCvNbJFDl4uDb6u9+dLB4fb6nMk2tp/+8hBAq97bOiC1EYpY/D8K9ReXNAxVAvflatrHRJFgAAkABXziZxHjKIczLQ5UMi9CV4YlOskyzu+IA9ZungFyqtQAZsuegbTsEHeOueS2eMdiXghxqhzLkKvwRU+F8u0nnF2uU9wVifktB3VmRXEB+TkOB55v0nWRvWRXWwkusiOV3n8FReZz8uOXK84DaovERwXAAP2tTQBMLSW7c1oMkX/nO6V+JB4yK/8A35ydfM9KalKznLYSfH4UlMGUjvWFj+7TesZJVNOiJ0TH8pMWxezVZqpQdxhv86oBVAQR4AHrWQvWVDcrlk3tpJibU0eUow/NdkAa/mTXg441QESp17XaCwidO7e1IV8KnIMxMmearkjgneDEryG13BJCWrl3WEt6Zmp9kRXPco/J36LUmLJVi/8JJNa1PRTEfhN/RqIuNkwdE6xC6Dsjfi/9QvvkNmdy5cM5iiY5HkA098MvMNmNlc6EUgZzuLIh7vPZTuvjaWa7imJgPeuSP1hACcWnbPLKOFIHvdPabokJ8LrEgn846kXLMJhuZFepsuDZABxjYvwv03jZKKsDqJ4XzdFoMncpN0rTqNg5X5uNV69HP22K0thLXPoBVMeNL/8nHDX3poH9XybjtY1ZKauvpfgPz0eB2l0H6PPALmXnKnXk4MF4DEQxwb3C0aVAoArODjBxRwf5We4e//ImtA856nzQ7EUlTAGEAwvFPvwqDmhqwexRhdodIxfQ7lzLGj3Q5kGGmY2gATARqOLc6WqdYqM2/ZWWYk47KbxCWavskLqHrV1feZmQNYrCIevleyk/gwhx0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97708603-3d98-41dc-edf2-08db352264e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 15:36:44.0883
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UF1aF+63FJ15CcWe7dwAePBEo8ISJ9VJIeqprfxZhDojSXqrW8cCwRS6CohmHCGZySYU8JAmgsKzJzDqKTf49g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7025
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_07,2023-04-04_04,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040144
X-Proofpoint-ORIG-GUID: mD4UEYLSoogcmNvtZEESdp3wfING8ICe
X-Proofpoint-GUID: mD4UEYLSoogcmNvtZEESdp3wfING8ICe
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 3, 2023, at 2:46 PM, Chuck Lever <cel@kernel.org> wrote:
>=20
> diff --git a/net/handshake/request.c b/net/handshake/request.c
> new file mode 100644
> index 000000000000..0ef18a38c047
> --- /dev/null
> +++ b/net/handshake/request.c
> @@ -0,0 +1,344 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Handshake request lifetime events
> + *
> + * Author: Chuck Lever <chuck.lever@oracle.com>
> + *
> + * Copyright (c) 2023, Oracle and/or its affiliates.
> + */
> +
> +#include <linux/types.h>
> +#include <linux/socket.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/skbuff.h>
> +#include <linux/inet.h>
> +#include <linux/fdtable.h>
> +#include <linux/rhashtable.h>
> +
> +#include <net/sock.h>
> +#include <net/genetlink.h>
> +#include <net/netns/generic.h>
> +
> +#include <uapi/linux/handshake.h>
> +#include "handshake.h"
> +
> +#include <trace/events/handshake.h>
> +
> +/*
> + * We need both a handshake_req -> sock mapping, and a sock ->
> + * handshake_req mapping. Both are one-to-one.
> + *
> + * To avoid adding another pointer field to struct sock, net/handshake
> + * maintains a hash table, indexed by the memory address of @sock, to
> + * find the struct handshake_req outstanding for that socket. The
> + * reverse direction uses a simple pointer field in the handshake_req
> + * struct.
> + */
> +
> +static struct rhashtable handshake_rhashtbl ____cacheline_aligned_in_smp=
;
> +
> +static const struct rhashtable_params handshake_rhash_params =3D {
> + .key_len =3D sizeof_field(struct handshake_req, hr_sk),
> + .key_offset =3D offsetof(struct handshake_req, hr_sk),
> + .head_offset =3D offsetof(struct handshake_req, hr_rhash),
> + .automatic_shrinking =3D true,
> +};
> +
> +int handshake_req_hash_init(void)
> +{
> + return rhashtable_init(&handshake_rhashtbl, &handshake_rhash_params);
> +}
> +
> +void handshake_req_hash_destroy(void)
> +{
> + rhashtable_destroy(&handshake_rhashtbl);
> +}
> +
> +struct handshake_req *handshake_req_hash_lookup(struct sock *sk)
> +{
> + return rhashtable_lookup_fast(&handshake_rhashtbl, &sk,
> +      handshake_rhash_params);
> +}
> +
> +static bool handshake_req_hash_add(struct handshake_req *req)
> +{
> + int ret;
> +
> + ret =3D rhashtable_lookup_insert_fast(&handshake_rhashtbl,
> +    &req->hr_rhash,
> +    handshake_rhash_params);
> + return ret =3D=3D 0;
> +}
> +
> +static void handshake_req_destroy(struct handshake_req *req)
> +{
> + if (req->hr_proto->hp_destroy)
> + req->hr_proto->hp_destroy(req);
> + rhashtable_remove_fast(&handshake_rhashtbl, &req->hr_rhash,
> +       handshake_rhash_params);
> + kfree(req);
> +}
> +
> +static void handshake_sk_destruct(struct sock *sk)
> +{
> + void (*sk_destruct)(struct sock *sk);
> + struct handshake_req *req;
> +
> + req =3D handshake_req_hash_lookup(sk);
> + if (!req)
> + return;
> +
> + trace_handshake_destruct(sock_net(sk), req, sk);
> + sk_destruct =3D req->hr_odestruct;
> + handshake_req_destroy(req);
> + if (sk_destruct)
> + sk_destruct(sk);
> +}
> +
> +/**
> + * handshake_req_alloc - Allocate a handshake request
> + * @proto: security protocol
> + * @flags: memory allocation flags
> + *
> + * Returns an initialized handshake_req or NULL.
> + */
> +struct handshake_req *handshake_req_alloc(const struct handshake_proto *=
proto,
> +  gfp_t flags)
> +{
> + struct handshake_req *req;
> +
> + if (!proto)
> + return NULL;
> + if (proto->hp_handler_class <=3D HANDSHAKE_HANDLER_CLASS_NONE)
> + return NULL;
> + if (proto->hp_handler_class >=3D HANDSHAKE_HANDLER_CLASS_MAX)
> + return NULL;
> + if (!proto->hp_accept || !proto->hp_done)
> + return NULL;
> +
> + req =3D kzalloc(struct_size(req, hr_priv, proto->hp_privsize), flags);
> + if (!req)
> + return NULL;
> +
> + INIT_LIST_HEAD(&req->hr_list);
> + req->hr_proto =3D proto;
> + return req;
> +}
> +EXPORT_SYMBOL(handshake_req_alloc);
> +
> +/**
> + * handshake_req_private - Get per-handshake private data
> + * @req: handshake arguments
> + *
> + */
> +void *handshake_req_private(struct handshake_req *req)
> +{
> + return (void *)&req->hr_priv;
> +}
> +EXPORT_SYMBOL(handshake_req_private);
> +
> +static bool __add_pending_locked(struct handshake_net *hn,
> + struct handshake_req *req)
> +{
> + if (WARN_ON_ONCE(!list_empty(&req->hr_list)))
> + return false;
> + hn->hn_pending++;
> + list_add_tail(&req->hr_list, &hn->hn_requests);
> + return true;
> +}
> +
> +static void __remove_pending_locked(struct handshake_net *hn,
> +    struct handshake_req *req)
> +{
> + hn->hn_pending--;
> + list_del_init(&req->hr_list);
> +}
> +
> +/*
> + * Returns %true if the request was found on @net's pending list,
> + * otherwise %false.
> + *
> + * If @req was on a pending list, it has not yet been accepted.
> + */
> +static bool remove_pending(struct handshake_net *hn, struct handshake_re=
q *req)
> +{
> + bool ret =3D false;
> +
> + spin_lock(&hn->hn_lock);
> + if (!list_empty(&req->hr_list)) {
> + __remove_pending_locked(hn, req);
> + ret =3D true;
> + }
> + spin_unlock(&hn->hn_lock);
> +
> + return ret;
> +}
> +
> +struct handshake_req *handshake_req_next(struct handshake_net *hn, int c=
lass)
> +{
> + struct handshake_req *req, *pos;
> +
> + req =3D NULL;
> + spin_lock(&hn->hn_lock);
> + list_for_each_entry(pos, &hn->hn_requests, hr_list) {
> + if (pos->hr_proto->hp_handler_class !=3D class)
> + continue;
> + __remove_pending_locked(hn, pos);
> + req =3D pos;
> + break;
> + }
> + spin_unlock(&hn->hn_lock);
> +
> + return req;
> +}
> +
> +/**
> + * handshake_req_submit - Submit a handshake request
> + * @sock: open socket on which to perform the handshake
> + * @req: handshake arguments
> + * @flags: memory allocation flags
> + *
> + * Return values:
> + *   %0: Request queued
> + *   %-EINVAL: Invalid argument
> + *   %-EBUSY: A handshake is already under way for this socket
> + *   %-ESRCH: No handshake agent is available
> + *   %-EAGAIN: Too many pending handshake requests
> + *   %-ENOMEM: Failed to allocate memory
> + *   %-EMSGSIZE: Failed to construct notification message
> + *   %-EOPNOTSUPP: Handshake module not initialized
> + *
> + * A zero return value from handshake_req_submit() means that
> + * exactly one subsequent completion callback is guaranteed.
> + *
> + * A negative return value from handshake_req_submit() means that
> + * no completion callback will be done and that @req has been
> + * destroyed.
> + */
> +int handshake_req_submit(struct socket *sock, struct handshake_req *req,
> + gfp_t flags)
> +{
> + struct handshake_net *hn;
> + struct net *net;
> + int ret;
> +
> + if (!sock || !req || !sock->file) {
> + kfree(req);
> + return -EINVAL;
> + }
> +
> + req->hr_sk =3D sock->sk;
> + if (!req->hr_sk) {
> + kfree(req);
> + return -EINVAL;
> + }
> + req->hr_odestruct =3D req->hr_sk->sk_destruct;
> + req->hr_sk->sk_destruct =3D handshake_sk_destruct;
> +
> + ret =3D -EOPNOTSUPP;
> + net =3D sock_net(req->hr_sk);
> + hn =3D handshake_pernet(net);
> + if (!hn)
> + goto out_err;
> +
> + ret =3D -EAGAIN;
> + if (READ_ONCE(hn->hn_pending) >=3D hn->hn_pending_max)
> + goto out_err;
> +
> + spin_lock(&hn->hn_lock);
> + ret =3D -EOPNOTSUPP;
> + if (test_bit(HANDSHAKE_F_NET_DRAINING, &hn->hn_flags))
> + goto out_unlock;
> + ret =3D -EBUSY;
> + if (!handshake_req_hash_add(req))
> + goto out_unlock;
> + if (!__add_pending_locked(hn, req))
> + goto out_unlock;
> + spin_unlock(&hn->hn_lock);
> +
> + ret =3D handshake_genl_notify(net, req->hr_proto->hp_handler_class,
> +    flags);
> + if (ret) {
> + trace_handshake_notify_err(net, req, req->hr_sk, ret);
> + if (remove_pending(hn, req))
> + goto out_err;
> + }
> +
> + /* Prevent socket release while a handshake request is pending */
> + sock_hold(req->hr_sk);
> +
> + trace_handshake_submit(net, req, req->hr_sk);
> + return 0;
> +
> +out_unlock:
> + spin_unlock(&hn->hn_lock);
> +out_err:
> + trace_handshake_submit_err(net, req, req->hr_sk, ret);
> + handshake_req_destroy(req);
> + return ret;
> +}
> +EXPORT_SYMBOL(handshake_req_submit);
> +
> +void handshake_complete(struct handshake_req *req, unsigned int status,
> + struct genl_info *info)
> +{
> + struct sock *sk =3D req->hr_sk;
> + struct net *net =3D sock_net(sk);
> +
> + if (!test_and_set_bit(HANDSHAKE_F_REQ_COMPLETED, &req->hr_flags)) {
> + trace_handshake_complete(net, req, sk, status);
> + req->hr_proto->hp_done(req, status, info);
> +
> + /* Handshake request is no longer pending */
> + sock_put(sk);
> + }
> +}
> +
> +/**
> + * handshake_req_cancel - Cancel an in-progress handshake
> + * @sock: socket on which there is an ongoing handshake
> + *
> + * Request cancellation races with request completion. To determine
> + * who won, callers examine the return value from this function.
> + *
> + * Return values:
> + *   %true - Uncompleted handshake request was canceled or not found
> + *   %false - Handshake request already completed
> + */
> +bool handshake_req_cancel(struct socket *sock)
> +{
> + struct handshake_req *req;
> + struct handshake_net *hn;
> + struct sock *sk;
> + struct net *net;
> +
> + sk =3D sock->sk;
> + net =3D sock_net(sk);

We're still seeing NULL pointer dereferences here.
Typically this happens after the remote closes the
connection early.

I guess I cannot rely on sock_hold(sk); from preventing
someone from doing a "sock->sk =3D NULL;"

Would it make more sense for req_submit and req_cancel to
operate on "struct sock *" rather than "struct socket *" ?


> + req =3D handshake_req_hash_lookup(sk);
> + if (!req) {
> + trace_handshake_cancel_none(net, req, sk);
> + return true;
> + }
> +
> + hn =3D handshake_pernet(net);
> + if (hn && remove_pending(hn, req)) {
> + /* Request hadn't been accepted */
> + trace_handshake_cancel(net, req, sk);
> + sock_put(sk);
> + return true;
> + }
> + if (test_and_set_bit(HANDSHAKE_F_REQ_COMPLETED, &req->hr_flags)) {
> + /* Request already completed */
> + trace_handshake_cancel_busy(net, req, sk);
> + return false;
> + }
> +
> + trace_handshake_cancel(net, req, sk);
> +
> + /* Handshake request is no longer pending */
> + sock_put(sk);
> +
> + return true;
> +}
> +EXPORT_SYMBOL(handshake_req_cancel);


--
Chuck Lever


