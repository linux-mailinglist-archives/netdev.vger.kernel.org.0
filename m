Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E69529375
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 00:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347603AbiEPWOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 18:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232441AbiEPWOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 18:14:22 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176FF2A729;
        Mon, 16 May 2022 15:14:20 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GJnLZU019605;
        Mon, 16 May 2022 15:14:13 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3g2bxsrx66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 15:14:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPP9Iuf42ttuK8gcaIaWD273TzD/lA5DvgZUe+rfyEs5XE0/p8V+0mu70MizFH1JpAvomsAXUCnypoeKjK4CTEM2xI9DkfupuZcZIkCfrvZb7Q3ppH3AXMmHET8bTNEEWUx9E7YH4qhKTcavL4DmSB8MIPER4DLmmA7NXkSiQvKZDDVeEGdVg1D0uF0iqsYy+fQHDzeiSPaxstb1Z+jp2NC1hRbmoktDyJskd/HJ7ZmhIG9QTamPj4NztE8EeK9RrLp4v4MMMZAMdw4xGOZ1cMzEQXy9fPTWYv8l0Rb7tCNJoM5fNQASfMrY1SRH9NFFBBXDfAjHsnuRMUR2AsB/TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ooZbkh4TuG69pmleZK6KkuIDjZNMNHSzfQhU7Yirxe0=;
 b=Y+WivDKudhreJrL05AjUn38PqnYz9rJ44h26cb7d74Hmd/9E2m35pvc3mYS9Tchg9L8GDS1I05PF59ojG8glkHu6dvfDU4vYvn22hK/WC0FKEl8DzNYM8ZXFwm3/HCnncwKnNYOQeqWFI1FTcx9KUagHrvPSichi0HLV8p2kwBm2P4nfDLsz1NxqpVXTZN3SLCD0SvbJUP9fZuV2rnknr+pUcsDvR2hMTbcL5sUZVP+sAuGJ251pZDjnj4fdyzE8x+jj1ZzrXS0qVRROnTNRvMlHaLrvTGhfJt9OsMKhtj5MaMszEm89THqXxgLY9FTlnV3XA3ANnmLvoKC9qCMvJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ooZbkh4TuG69pmleZK6KkuIDjZNMNHSzfQhU7Yirxe0=;
 b=d1wsUBjMIPh2V1Uw38Mchx37inHR3L/LJTwv0Br+P/pis0x9tKXekfyJQ6ib9gIPXvMqQS0JRIrEhHpBmQeSWJGWvEqAKb5Fh6whhysLC0bKTXXGcgBsfQESk93r1HEwLLxKxQDFr+2APlr5bdrg5unGtgK6OJrfjbrGtIQX1+Q=
Received: from BYAPR18MB2423.namprd18.prod.outlook.com (2603:10b6:a03:132::28)
 by DM6PR18MB3754.namprd18.prod.outlook.com (2603:10b6:5:31::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Mon, 16 May
 2022 22:14:10 +0000
Received: from BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::3980:e46e:f615:b60e]) by BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::3980:e46e:f615:b60e%4]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 22:14:10 +0000
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Satananda Burla <sburla@marvell.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [PATCH 2/2] octeon_ep: Fix irq releasing in the error
 handling path of octep_request_irqs()
Thread-Topic: [EXT] [PATCH 2/2] octeon_ep: Fix irq releasing in the error
 handling path of octep_request_irqs()
Thread-Index: AQHYaHS08JJNEo65QEuXSq8nTGeOUa0iE1Pw
Date:   Mon, 16 May 2022 22:14:10 +0000
Message-ID: <BYAPR18MB2423E4D10EC53CB4E00D111CCCCF9@BYAPR18MB2423.namprd18.prod.outlook.com>
References: <cover.1652629833.git.christophe.jaillet@wanadoo.fr>
 <a1b6f082fff4e68007914577961113bc452c8030.1652629833.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <a1b6f082fff4e68007914577961113bc452c8030.1652629833.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f2f4232-8f52-48ec-788f-08da3789671d
x-ms-traffictypediagnostic: DM6PR18MB3754:EE_
x-microsoft-antispam-prvs: <DM6PR18MB375433BCCAC0C73B2EA37361CCCF9@DM6PR18MB3754.namprd18.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F9BU46uW6OckoSIOmuACqWtIOvVNBJvNM/y15edbQH3GBh0htZW7JTfesm+7ufMXb8sZgO8ndCuLkTkzoBYR2DFfxDOAQAWKOZkEPHsJIMQqv5DV/JY2bTkQax5Gax1WHMPa7XcPhCvJ1Q45HRXNIipYn9WDYSugvy78Eb1VEoWpYh2uDgblDoVxJIyeml0Wg1p7lZ36gZensx/hQj1OkR8hq4o0zVD+n9TbL88hQeFi1nWitfJ34lxa5hYATCnxuVbeuK6B5PqAZPB8EPaD7kQk1u+ngQOOz1nSNNB6WAumintTuXU21O585cdOUTyAKnqhzfDCrVRsYFewuDHLamz3rRmpKfIAPtb0l+drbbqiApT99ps+KndWCrseDCO/WH/GMOWBEUBlov9qFxiHVFKHMHbxKi3MMorwwwEplm8ZsM2ZMftlHexzXaNZbbnZlKOV89umHFRz3ahoNMorHd4rmnaCvdld6zdaCEV5o9b3a+qcD1W+tB2uPUYQqbLTfEmIC7J/E7RW/juZ7L18Efb3Qys8CZGns3f+ueMfHGwOSlm1gbQEKZ6qJTdIzqMVx0vlsQnxk8D52e6KGFNYvfCd7ny5Kvt4elNqe5P+5pwolhrvGTVX6gdqljjtzKfh93uG2aAEL8GjtTFPpjR8bZXvyGV0k1ydOkE0xTixQa8vZCuFLkU8oQIKbPSLb+rLL8PnBc2xG7jgCuvZp7SWLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2423.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(71200400001)(186003)(38100700002)(316002)(83380400001)(110136005)(26005)(9686003)(33656002)(66556008)(55016003)(8936002)(52536014)(76116006)(38070700005)(86362001)(8676002)(64756008)(66446008)(66476007)(2906002)(4326008)(5660300002)(7696005)(6506007)(122000001)(6636002)(508600001)(53546011)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YbY8LD6x/gWNU75eY2vEOqMyRbkB1lX0SByv04ZQSc8j3YdCPnRG+FzLe2Nn?=
 =?us-ascii?Q?ztqhdHAirSld5vlikh1MUxGhmctVwRtLIkDdYcbQDdHvm/dloMI1DqVYa3F8?=
 =?us-ascii?Q?6qF108Sw+ali0AYZqU+bJuTsq9YTZNi+ZZmUZPyuboJ+wOjNt8+dHOgXpWA6?=
 =?us-ascii?Q?dtiCK0MDbODXztuFoFGXh+FnV5/NOiNkNsChI3F9SxIkGLCAoQz6ABDzFeo9?=
 =?us-ascii?Q?DgHZfZVXukpdEGAaZvg1FDQW5YCqjDkZPVKatlOuAU27I6qSsWX5teWshSyX?=
 =?us-ascii?Q?zfdt9uGNy+spevxI6dquZ6TjKjNJ3w0O1R4bkqbW+oqsrRj0h3yq4ldOny4G?=
 =?us-ascii?Q?z91XoiTODhcimS+jCTBWXG3i9IZjVssqLBwYOFEgp/8KKWvj+xsq4Y0+L/Vo?=
 =?us-ascii?Q?Q4kP1Ewq9bZgr3t7gNVS0Kh341UOYnNwAmKUg+tK5OipO0C3xu9M8GeGgmx5?=
 =?us-ascii?Q?oT5yLKTQUCKCuUjapO9z54QB7GHySbvVTHJ5gU1mfA2tILctau5KN9wcM79K?=
 =?us-ascii?Q?TuFWerfMt+OsezW/5KMCf5q6/S5mteMW9JczJrjJ12rZJk3HXfSqzXZUiGMs?=
 =?us-ascii?Q?Zis658OkSfYWjFnlO4CKHOCQt6POYbsUy/k0HR2C3nMzA2Ck8T/Z8pMxCJhx?=
 =?us-ascii?Q?9fCVTlPorpkMqv+wEFCeg2h5ZaAtbs+GwDwVDZZ4GTXx0hOWxucfLQuClpPn?=
 =?us-ascii?Q?SvbYBGpARB88A36ofP78JQc0uLHBm4BOKWnVBYq9PoX5RT2oP8RHUteQE8hL?=
 =?us-ascii?Q?9wf6Um8JaAT1FoxdNKjXk/ENUwb/Iw9uuADhEIksi0GqGn6l5Dri8wNxJoaR?=
 =?us-ascii?Q?QvvZUucZPdrA1tSg2SfBYfqJN3qWV5xppnLeuaMwFzUah+dD85GrFAZaf15c?=
 =?us-ascii?Q?Rrz8W34OFeD01XTmOZnyyo10V33BYwbdGVXY7H+g7yXym0RWSKNnZ+c4lgDK?=
 =?us-ascii?Q?0Ky96wYBHHjs7/PBEz/8p/TkkMezPGSX5XTiLSsN8LK9N1BqlBK1ex8+oTzG?=
 =?us-ascii?Q?BBXaMVn34GGtjAbvSk8l+ySWe/22czobL/WlRx381EAqrlla251NcDRQN85V?=
 =?us-ascii?Q?ZdwxlZKXx4b4QhxA5ozi95Bqgg+imLfO5iAnLXvqQb2D7fAtF8369qa7nyBj?=
 =?us-ascii?Q?ixLffag60pCCv6mlkjtFyPb1a69fjOcQANb0B8zL+QojtsISQFo/iXQS7wix?=
 =?us-ascii?Q?3X3jlDGUR6DhdPbmWkGbU1WiOT6MnM1Ki974n9qUCPwxQUGVablteWHwnBY0?=
 =?us-ascii?Q?nCG+mpYZY8nLs106lXRUf3l4yg4rEX+W3OAR20hLlyd26mTeTV2y8qsUB+ij?=
 =?us-ascii?Q?nSQP3lG6er1fPfFeDe+0DCxahShTEpD/TpZ+qLxwB1psUTZy5/X0YHkhsynE?=
 =?us-ascii?Q?knTI45BleaDzYEFZJ/m4KGEAA62IN8rOsvIXxh89HYYD70nFQ5hZdUKjy2qS?=
 =?us-ascii?Q?6iPEVuBa+ixuXbSyxvlFUzDBujEVBw+nhW45k15+Sk9r4UuNjneVqIE0K/xy?=
 =?us-ascii?Q?FcOrI+ZBSSkuQD4NGCdmA1ffjxyEXRgneGpcMA7PjPoibIsCV52r1BrgpAGF?=
 =?us-ascii?Q?/G2ZXsrCNM23LkDnqxHpU+aqCcfkvjecUCe9863XWYH20Pc+umKXaLaWEzaF?=
 =?us-ascii?Q?koWl8oq/fGMkNxwJ32zBG72aRNxxrD8dQfP7J0apSk0uRjTztFKZbmGrRtrO?=
 =?us-ascii?Q?A1q8DpQccaFz5zQBHoE00VnfSdKvEYLGd7ca20qTY68fspcEI2Hwtm1s7uIB?=
 =?us-ascii?Q?T82uHSniVQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2423.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f2f4232-8f52-48ec-788f-08da3789671d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2022 22:14:10.5909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EZNnmnxZHh+OnmgMPsRVFy/Hj5D2QA66FXIPhVZWZQl/cKeCfioUha2pxdvjp4j52eqbtYiEBSsR9lWFjvcmvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3754
X-Proofpoint-ORIG-GUID: MwmNV8lhtszXFRtc6q6ESlqKXqTfSQym
X-Proofpoint-GUID: MwmNV8lhtszXFRtc6q6ESlqKXqTfSQym
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_15,2022-05-16_02,2022-02-23_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Sent: Sunday, May 15, 2022 8:57 AM
> To: Veerasenareddy Burru <vburru@marvell.com>; Abhijit Ayarekar
> <aayarekar@marvell.com>; David S. Miller <davem@davemloft.net>; Eric
> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>; Satananda Burla <sburla@marvell.com>
> Cc: linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org;
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>;
> netdev@vger.kernel.org
> Subject: [EXT] [PATCH 2/2] octeon_ep: Fix irq releasing in the error hand=
ling
> path of octep_request_irqs()
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> For the error handling to work as expected, the index in the 'oct-
> >msix_entries' array must be tweaked because, when the irq are requested
> there is:
> 	msix_entry =3D &oct->msix_entries[i + num_non_ioq_msix];
>=20
> So in the error handling path, 'i + num_non_ioq_msix' should be used inst=
ead
> of 'i'.
>=20
> The 2nd argument of free_irq() also needs to be adjusted.
>=20
> Fixes: 37d79d059606 ("octeon_ep: add Tx/Rx processing and interrupt
> support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> I think that the wording above is awful, but I'm sure you get it.
> Feel free to rephrase everything to have it more readable.
> ---
>  drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> index 6b60a03574a0..4dcae805422b 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> @@ -257,10 +257,12 @@ static int octep_request_irqs(struct octep_device
> *oct)
>=20
>  	return 0;
>  ioq_irq_err:
> +	i +=3D num_non_ioq_msix;
>  	while (i > num_non_ioq_msix) {
>  		--i;
>  		irq_set_affinity_hint(oct->msix_entries[i].vector, NULL);
> -		free_irq(oct->msix_entries[i].vector, oct->ioq_vector[i]);
> +		free_irq(oct->msix_entries[i].vector,
> +			 oct->ioq_vector[i - num_non_ioq_msix]);
Ack.
Thanks for the fix.

Regards,
Veerasenareddy.
>  	}
>  non_ioq_irq_err:
>  	while (i) {
> --
> 2.34.1

