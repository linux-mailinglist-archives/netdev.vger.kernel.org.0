Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65D542862D
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 07:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbhJKFUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 01:20:08 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59214 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231966AbhJKFUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 01:20:06 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19ANxbLU007688;
        Sun, 10 Oct 2021 22:17:38 -0700
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bmaa5rs82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Oct 2021 22:17:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TLSsTtQmS3+lUYCOcIb1Mbz0zm9W8gHDzLwGe7Bm9iUeTVknO1U8qrLVRmrhwvmyAAAseAxEmr6HcHtFqwuEhW7Yh5VTBjaLdlpfrmgfsPWY8vYKHWDR6w3H9YOSKKe1nllCO+wD8x9PePYrhKq7kJvXNnUFAUOnv5mcLHLgnf1/FWvIXk7OkBW4flOgxiKoeoZyzuIBXKnkHJUgaKfCEYwXfL6SNrvVqCJX4A7MRKkSQgz6C8dx/lej4ciIXfz4veAHrb9gDhYjuaE+lr716kYeFbeQ6S96zRcJCVCe0ShkRYJumXKbbZts6Y0taHnG9l83Q1we9lGHj3kzXDX2aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DMiH3UhnX3LsoB28Eq2CIkGI/Be7XGAsdjuZqmCAXHA=;
 b=Yj2xX7DDwbxZm0VrDZ02i/r372aTa3bkUR7oAyKiW5m/7CewxhIY2OL2yumBPMg/ZjU5O+ikJsIleY056fYh7eMW53HFt1OU70vKdH2U6/HXskn7VPzXJzYAY9mHkV/0In4SbNnPBqdg088uDM+Mpi52OjVoXWsGi8A4+lch56w5B6mJ0h0v1e1VaTeDFL588mfZykozAAVE9jvqbqFUc/fooJM9qeBqbSDVKUEsMC52qoHeN5/Ywf5302BdHO3K0Z6ltfPggPM3ikJyxX9DbUMBfsQ2dCv5NjiywRkKZskb7h6iwtXstooD/0+eVs+7RtfJ6smg1ZsalMEIprw/VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DMiH3UhnX3LsoB28Eq2CIkGI/Be7XGAsdjuZqmCAXHA=;
 b=sHmwx6JRGnvBthWCTIXpMYAt/j5JnI689Qx15NZY2VJVf+x7MKeoZAassjKhNzmKUd1eIV4aCQBqbB87v1aAzv7pBpb8z8iApisVPCpTg2NTVJW4FRWpOTd7C9tQWv4qjOrRLfrYRO/rRpTZJh81nKqevrU3X4TWOBCKBCLZpaE=
Received: from SJ0PR18MB3900.namprd18.prod.outlook.com (2603:10b6:a03:2e4::9)
 by BYAPR18MB2629.namprd18.prod.outlook.com (2603:10b6:a03:136::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Mon, 11 Oct
 2021 05:17:33 +0000
Received: from SJ0PR18MB3900.namprd18.prod.outlook.com
 ([fe80::d06:b37c:6f9a:ed3d]) by SJ0PR18MB3900.namprd18.prod.outlook.com
 ([fe80::d06:b37c:6f9a:ed3d%6]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 05:17:32 +0000
From:   Alok Prasad <palok@marvell.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Ariel Elior <aelior@marvell.com>
CC:     GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [EXT] [PATCH] qed: Fix missing error code in qed_slowpath_start()
Thread-Topic: [EXT] [PATCH] qed: Fix missing error code in
 qed_slowpath_start()
Thread-Index: AQHXvOUintAc0Mmdg0y251b5bu/ceavNQYdA
Date:   Mon, 11 Oct 2021 05:17:32 +0000
Message-ID: <SJ0PR18MB3900AFB7ECA41BC29B73B1B3A1B59@SJ0PR18MB3900.namprd18.prod.outlook.com>
References: <1633766966-115907-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1633766966-115907-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93d99f9c-c069-4d4a-3707-08d98c766dcc
x-ms-traffictypediagnostic: BYAPR18MB2629:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2629EF59685C98EACCD2156EA1B59@BYAPR18MB2629.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hdhYZf80aMl+3l7Q6qeBDwbX1IsgIXQqWOAyIUXbFyTqGSVDZW5p4zWa7bLgKTGL9DDiPJW6j68zjfFZ+Yn/+5l6XWnAmIedog8L6xXQCNj2A6GjyURXOvfn9MYw/shg0wWXEmqXqF1ZUlpHrRRz/XaPMacqPz2tDIbcE3BMLYaG92mIbl23aBqwHLYbompMpULzBsF6TZsQFmZZocELdyv6Of9WJ/L5eRdLBbZdt2sg3rJyKu8xaYu9p0OfvOVBP5UiG6Z0GOLqr91mkG5NzCC6eIH3xCAPjiQfiRiif2g8A5wu7J1IG8fORlnOyoDB6HYobzSN0VICHocvwK5vHZrsZppQJUjEoILKJUUX69rwfnGzORGUlpo7EYxPMdXjmJZ5k7/jujm2GPWCuhJSBBYBIdLMkiPg+i1BFk2ELdmKeAxE3zh5sTQcB5Y7RfmtErKY6EsROZVCSEAn+493VMNAZybkShl/PeEZbDQMULhkYgYCDjlBYve0u5wINXCFgJzRPRVdVWlCDQWsgmCDY1JwwmbSwgT9o0ecS1ZkRco532tB7G2g05YkYHKK3Xmm7MRScazI20D9lH6zQzzG7Whuw9EsASMTBr5RP/SaOkZHbwjQnjossV4qpS/87Ga4X8JxSz8ey/Pi9mGtD5KxoAW82zpZYH2513bhqJzbzC56D24kStxDBB2i4Oq0Snvphoib5YZY8chMSKAIrglobQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB3900.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(52536014)(38100700002)(6506007)(122000001)(186003)(4326008)(83380400001)(38070700005)(508600001)(33656002)(26005)(53546011)(316002)(8936002)(5660300002)(71200400001)(7416002)(2906002)(6636002)(110136005)(86362001)(55016002)(66946007)(76116006)(66556008)(64756008)(66446008)(9686003)(7696005)(66476007)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vz6lGr+a1bHMZEPl9pB4Dspoq9/I5coqMCTCc4cR8BafypDUWpyAkefIABi8?=
 =?us-ascii?Q?j6D9FmExovsWLmC8DlRlLBsz8ARDLmhQHeXk9aC/MoFYI97nMyRcKZLevaHP?=
 =?us-ascii?Q?Xa0jlf9Nzynt5op9BkFgNblA7HaWuaZvmb/BAnjlHqrU+dVP8GvaEb9pmo7s?=
 =?us-ascii?Q?SQzKJBkBZatp46XdeMHod1V2mwQe2RdYGS3EvlL8vBQD0DGgEKs73qGnfqgL?=
 =?us-ascii?Q?TkCxVz5YyxvgKyHeRZpAZlPn50fCWw7zY4pk+0xrzQFrb/NpmAZP9ZIDLnPW?=
 =?us-ascii?Q?UM4j6CRfWiZ9D3eBcNcUUeVm0q6f7IwH3RsGNuawn/0rMTgy+YYIUXUDddrz?=
 =?us-ascii?Q?1BxyrpDeBAWh26yALFVme0dJVeDZdYsJxi2su1u04jA4OWVa9lQYFLaw1OFm?=
 =?us-ascii?Q?xUQO/XaDn4PLTbynSouJ4uOlJP3b2VAUSmV8bQc5G8dJg/SIogrhuDbZkyiN?=
 =?us-ascii?Q?SPqFIomcLnDO2ca58tOQUlzzevoHXsmGF7/MdkAiXZk1Eq7iuqWvLZieGWlC?=
 =?us-ascii?Q?hLuaJTX3k55VWZLRyny3DppAqrq6icCsDgNOEQOyBWPC+wRwb5OkM+qRt2mY?=
 =?us-ascii?Q?2KDaYK+KhN69goMuSwdfW5kiPxSMD9TL/uv5HUsVtp/THvjhuGttau5mjkDU?=
 =?us-ascii?Q?7qDrWkTqGtG/z7lhk7aNBk8sqNrIJNS1a5XAUU19Woeh5GtXkr3LvhXOsL3i?=
 =?us-ascii?Q?l+A961Yg5O65ea8Nw2160SW/yXJKE20Aehs3gaFqe9jCD3qflddgCeYvHDLz?=
 =?us-ascii?Q?zTZuMGNz2AGT0pYmH8MYvNXan5g857tvawEiTT58aQTo9ychF2CCne+dsJ15?=
 =?us-ascii?Q?n+KBoWfXxKrr/XSvOrpQ2VXykaTMBP3dsUG6zpYf1JXc7qbb/ib0WX3oeUIx?=
 =?us-ascii?Q?TvUkTuMdCk4pOSxhAThXiLinJrs3doSS4zXJCeihyY7eFPLG7ajKJkLLx14A?=
 =?us-ascii?Q?fBisWlP/79VjmiG1B+MBtgE6TpLOMOWUDkFpDLByeQTdvpQhrArWtB88ibQP?=
 =?us-ascii?Q?8MSO7DhyEjvw4kmSUpvTqwumP2qYz96tJw/7kbFr9az8HlRyh3+MZRdJfjEp?=
 =?us-ascii?Q?HK3EjyAo2LiJIIykU1sYpzBIVQzp5WlZ8D2aTd36R5Cr/9kBc0yJNcPkW0vf?=
 =?us-ascii?Q?kPZwPwirCYEVCntPNlIzWdV4j7pgPj27cuuxQTtaQHDbjwW6bVlauFriM9Zc?=
 =?us-ascii?Q?IxncqlSEbKiqiXId0tx700wgOMUIC/n5tl6WHG5/U2R4TPvF9gHFe+5zg9Uq?=
 =?us-ascii?Q?pmGDKBj1Vnfouw9VQ206p2Np4t8xy8K5aYz6XscceR1xndRG+dyGcutA8PpF?=
 =?us-ascii?Q?4zcGR4fixNvbbsjf9zkGVZE5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB3900.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93d99f9c-c069-4d4a-3707-08d98c766dcc
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2021 05:17:32.3674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tmJzx6E58vTpgbpOyaBqog99lkQ8kfC8La/QAqhl4aja+gBrGyhXsvlDb1+k/a+iPNsk7BazBApOwmNDxqD+YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2629
X-Proofpoint-GUID: lgvKTbYlsDqctYb5v2u1x23wNo9NBCIU
X-Proofpoint-ORIG-GUID: lgvKTbYlsDqctYb5v2u1x23wNo9NBCIU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-10_07,2021-10-07_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> Sent: 09 October 2021 13:39
> To: Ariel Elior <aelior@marvell.com>
> Cc: GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>; davem@davemlof=
t.net;
> kuba@kernel.org; linux@armlinux.org.uk; ast@kernel.org; daniel@iogearbox.=
net;
> hawk@kernel.org; john.fastabend@gmail.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; bpf@vger.kernel.org; chongjiapeng
> <jiapeng.chong@linux.alibaba.com>
> Subject: [EXT] [PATCH] qed: Fix missing error code in qed_slowpath_start(=
)
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> From: chongjiapeng <jiapeng.chong@linux.alibaba.com>
>=20
> The error code is missing in this code scenario, add the error code
> '-EINVAL' to the return value 'rc'.
>=20
> Eliminate the follow smatch warning:
>=20
> drivers/net/ethernet/qlogic/qed/qed_main.c:1298 qed_slowpath_start()
> warn: missing error code 'rc'.
>=20
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Fixes: d51e4af5c209 ("qed: aRFS infrastructure support")
> Signed-off-by: chongjiapeng <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_main.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c
> b/drivers/net/ethernet/qlogic/qed/qed_main.c
> index 5e7242304ee2..359ad859ae18 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_main.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
> @@ -1295,6 +1295,7 @@ static int qed_slowpath_start(struct qed_dev *cdev,
>  			} else {
>  				DP_NOTICE(cdev,
>  					  "Failed to acquire PTT for aRFS\n");
> +				rc =3D -EINVAL;
>  				goto err;
>  			}
>  		}
> --
> 2.19.1.6.gb485710b

Thanks!

Acked-by: Alok Prasad <palok@marvell.com>
