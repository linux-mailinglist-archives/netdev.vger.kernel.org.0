Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4765A5F28
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 11:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbiH3JUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 05:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbiH3JTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 05:19:38 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7F7D91FE
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 02:19:33 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27U1blTc029745;
        Tue, 30 Aug 2022 02:19:23 -0700
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3j8s2ew6dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 02:19:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=izUy1bKT/cWPKt4WAVDbyZgqAVPq3gG4YE+pSxMJDhTo7WpGoY+IKMwdwAnSHQBBX9RR9JionDi9x2umFsEoUEOFXUQoQRDvRT3XXsg5C1FYlrhteJhv92AznrmWTMDniX4/U8LtL4vKf4g/3jp2Ct9Sf0OnmLuI2wT2U2G9in8PItxo/XeTifuHM7at5cUEaHUF0LjysrJqtj3hxqyNBlTrgEcc54pG6a2rZ2MoW6Di2GkhLhlU/lRNhjfPcv/qrrL/pZENzkN6uKrONs289JVpczocXApk50QBVUx/wVHvGZ1H0liNoneuzqLcKn5HnBmwoMwFQHSxxUDAcFjSiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Nz78aRefUGJTnPGR8rpZKVVejRhGVbRtNkvntbCH9g=;
 b=eKLsR8wDJpqLyaKaCfEuVQCPT87ZfmsZ3TtKLL9V05bjm6/Vn0npkZMq2Yoqml6E7csto6JzYbM9qhgZRD8vG4TNCL9elTG65vunf8WopnlP8OLTIMwGvflfuhIX4TU9n+TiMFaYJifrM7ndgKxhRb2XHRmhwT9lGI5NteFL+mPjPml0zDH8OSWiff6TT9ApffjoUWpOjF644q+Zr5KAIH6fvv1Wmc6N6y4JhnREfk2Ov+CzmR9aHeUolUwmYWhl4cI9rLrfdCxfaLzuWlHJFKju4iyNE+5UwE/STN/OK0t7kxol8ZVfE+dlU7nrbLlAzDIacUIeZp7xvtvhRD6hIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Nz78aRefUGJTnPGR8rpZKVVejRhGVbRtNkvntbCH9g=;
 b=lLwnGktML4v8NWQUZV0xxZY50wPzch8IU/WURwo52JBCXX7jNSz4D6lWZKSXVYSDlZUSydUNl6BdcSSvBhf3tvHpJW8WFuWPVHpFAduQEcsLYxuoj6eSCo1dHmjysTTLbrUpcGfZkpBfFWC+yFscxv7f+MXnKS2E+rcPxlWD6gY=
Received: from BY3PR18MB4612.namprd18.prod.outlook.com (2603:10b6:a03:3c3::8)
 by PH0PR18MB4391.namprd18.prod.outlook.com (2603:10b6:510:49::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Tue, 30 Aug
 2022 09:19:21 +0000
Received: from BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::408f:c7c9:f84e:d5c4]) by BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::408f:c7c9:f84e:d5c4%9]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 09:19:21 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Thinh Tran <thinhtr@linux.vnet.ibm.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Alok Prasad <palok@marvell.com>
Subject: RE: [EXT] [PATCH] bnx2x: Fix error recovering in switch configuration
Thread-Topic: [EXT] [PATCH] bnx2x: Fix error recovering in switch
 configuration
Thread-Index: AQHYuL2C3UsOuojAMkOOjSojKyJF7a3HJi1A
Date:   Tue, 30 Aug 2022 09:19:21 +0000
Message-ID: <BY3PR18MB4612468FB0CFB6DB031F888CAB799@BY3PR18MB4612.namprd18.prod.outlook.com>
References: <20220825200029.4143670-1-thinhtr@linux.vnet.ibm.com>
In-Reply-To: <20220825200029.4143670-1-thinhtr@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26f6c172-40e1-4378-387b-08da8a68b902
x-ms-traffictypediagnostic: PH0PR18MB4391:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZE2t4YFiLXn6XxfqVLo0YGpfxPgghTs4RZK8x+gdF1J2aabzPJh8sxLQokEG48Ebm0sEe+HkX2h4COcamYsrueCs5+vNZoPbMTR2H7fL1u+SIu2zB6d4zV8WeFcJU2IfCnyR8KNY0VLZj9j6vp1CnAurbJAbuN2U8UCPhYNMHTknRNBqmQ1WDtdoF6usJY9xcThO28fTHHZxyZA16Nj0vC3s4pLLiSb8InfcObqbIxHwbP093/VCxqmMQunt66bEbGJUOOio/+guvtqtq+c+prx013SuE14L2SnYjn12PAlL8tSY4Ot7koC6zlRohMb0LIE2iUZz2UZwMEk8u+WOZKrPlw//u2UX5efssnB/7EPgOXkdh1CPyMA/tkVUUdD7XafVUFIIRWEFS4/dYwvHsHYDGFBYVoWRpwo4Kr77RhoEb2K79+MOGYPIoqhdqzudrQGArWIoovR5JZDu1qQ/hl/jbzVkFDwqOCD+PZ/J06g7o0IFPJgGPb0nz7LHIrLv+Fciq6s7MZS4C8dqjg+1ZiDogwuy/U+Nni9Dbzv+iaJQ01cLabV/e04zXkR7yw9qRIUJ2gCAIlVwqo1n8Yn7sctRlG0pFgrGUxzLqjQcbQyZwFErxjHKHBpXLgM9SQoNRDipdyNw/Df5kdXZLwa7KrPy6Qiz/VIBwLQwFxs//4u9VXpGpMkGOsMKuNLN0A9Exiy0d2PLn00gx6hUk5hQ7lbBD68ln2TiuUgEhCxOvG11i1HneZqpJl1+p/D6cV3LyWlhN7OzXMc4WLf0oBmF7g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4612.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(9686003)(86362001)(53546011)(71200400001)(478600001)(55016003)(7696005)(6506007)(107886003)(41300700001)(26005)(186003)(122000001)(38100700002)(38070700005)(83380400001)(66476007)(66946007)(66446008)(54906003)(66556008)(5660300002)(110136005)(8676002)(8936002)(52536014)(64756008)(4326008)(316002)(2906002)(76116006)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?e8OSzz6Qm7SQaHFSR9fB3XNOVy2elt9JdMKnaYIo15BX36qID+ozDa4bl56g?=
 =?us-ascii?Q?DF/jwK9qltzQNAJhWNdFL4UQGxgRfd5HUk56Jgze9EA0GIo3qeW/to/GWaxn?=
 =?us-ascii?Q?1KBG9EsCR3H2JQhKIAsAhlShq0RIjiE8RGQMcpOncvMQsCkkyj19kHqLCY7s?=
 =?us-ascii?Q?5XhBqfsa3NhByRVUtLJiZM0UBSW6Kvj1Ppd5JwjvS7bY+VNjM0I9ghhXcT77?=
 =?us-ascii?Q?0tuZTtnlt0OYxH2jc8nOdeMq4oiElaScaLvWnY/HzPlEhCrOzZ37TYm1XAz2?=
 =?us-ascii?Q?enwikrEE1GAxPc/COOOnPjWadXXGY6amEHu7+cXuMPomuhZZLXgVHXmQy8SH?=
 =?us-ascii?Q?7Vmi3AD+W74SGMjtwtb8bBCu9M3T0IJ2kqNg6SX63YWO9Qf0MufNVj2AAft5?=
 =?us-ascii?Q?J9S9qa7Bn+1yzNLjuHSv+N1K98wfaJv9PtRdXAWtorxIETnR4GO94J6/p+p/?=
 =?us-ascii?Q?rnzLL9HirNY9EgTp87v9Bp6FnFv5ev+nhR9broIqyDxtPGa5c6g4A406kdCE?=
 =?us-ascii?Q?JGqEwflkICRnVtS+BNgHcMFVHgNAXXDLW8CxC9PlTJzbz8eDHeUaTarDdpFK?=
 =?us-ascii?Q?nzwrMqlXKl+SNHIm7vRSn4I3XS885W/ZipxKREg0evDq18o/LKyK4DP1Ox+c?=
 =?us-ascii?Q?yYcXb23CtoS3W0vXCqX5zADcQ4Ti1+7t/P2ZgpZnF4GGVCEIDPn62E6cSUJ5?=
 =?us-ascii?Q?mEnfBvf0Z/aVcoBIiOPLs9UZblc1FMsCxq1PNc7c9hTfkVKjDAty8mW/iXak?=
 =?us-ascii?Q?nkDfbpEffOuRfVi6VEKSRaYmQHGVD7bQGJdYH2h29gkH1P4t2np6sVXcu7VJ?=
 =?us-ascii?Q?Uvs1rHTqmViTPymioEZ/wQS3M2GQm7KLvF8Xga2mpMxbiiX3SA42gWsPn1Ph?=
 =?us-ascii?Q?hw42oKJ6HhDPk5VKRYUof5iHB/YmbccvqCPHC55WJ7AgsNANyYSiIX/DsnGD?=
 =?us-ascii?Q?QAS131MCFtxD9vhuKja63nWDB8tB5u1otwFXiSDvicgKUKbQD1o29MukeiO7?=
 =?us-ascii?Q?X+iGCYJYCmElbN63A1voQqneYLAhYMWJSzk9coKlCAiYxXkgUo6j+A5qM9L4?=
 =?us-ascii?Q?9+VqQF/Yu7qHIp2CuHVM0gfhEQvfbDOY2RYiNeq+99Tu9GLoseJt4XcNCOdR?=
 =?us-ascii?Q?vsQptvIFGkSEleXquBBMdGEbXtPiOEB+HZ6Q80Tm4LOArRZZvtLSXYsMKF70?=
 =?us-ascii?Q?jxLcW+o4mYIsLqYD2tlCw4l6ftduJSfko2yGvUjqJ/Iz99UEauKYm4N1h8Sv?=
 =?us-ascii?Q?Hy5O1jP+iYHiDZM9RFh5Nt7kvmG8Tujsm4p+6zkg20bHbl6FHb6o93rO9l8r?=
 =?us-ascii?Q?ogvMegztIXRbQk3bE4vu5UyNJdZtIHklBZu4Yj5b8R9SIS/94IvqfI0UX5gc?=
 =?us-ascii?Q?HGD8C0kiW5OKAkPoSoHgomJZNRDv+LlrBUggDt+iTC4TFLFTJMvTbWQ8ZwBx?=
 =?us-ascii?Q?GqDxPcCRkXZjnINA76nb3tUs13GM7a7s3mBkjvBgAidaoIu9aMRH3YwxfSd6?=
 =?us-ascii?Q?lPhrx8WtGY7ws1Yii/KO2VkzG1j/R1zo7ath51wk3VzeaS1S8N24yw3ZRoDJ?=
 =?us-ascii?Q?8ZThv3yiL366y1qRgRCv44Bgwdf9u5EYs6CTnj8/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4612.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26f6c172-40e1-4378-387b-08da8a68b902
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2022 09:19:21.0571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MP90K641oOEWEy0Ce5jNLY0B0Yyt/b8BqwDg6fJhKkLF35UWrZ7m6i/G7I36W+jJTOtLFnFW9jJ4B96wWYOB7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4391
X-Proofpoint-GUID: WVBQH2ZOxuSaPv4wfHFdEptvzGsTKnZ0
X-Proofpoint-ORIG-GUID: WVBQH2ZOxuSaPv4wfHFdEptvzGsTKnZ0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-30_04,2022-08-25_01,2022-06-22_01
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Thinh Tran <thinhtr@linux.vnet.ibm.com>
> Sent: Friday, August 26, 2022 1:30 AM
> To: kuba@kernel.org
> Cc: netdev@vger.kernel.org; Ariel Elior <aelior@marvell.com>;
> davem@davemloft.net; Manish Chopra <manishc@marvell.com>; Sudarsana
> Reddy Kalluru <skalluru@marvell.com>; Thinh Tran
> <thinhtr@linux.vnet.ibm.com>
> Subject: [EXT] [PATCH] bnx2x: Fix error recovering in switch configuratio=
n
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> As the BCM57810 and other I/O adapters are connected through a PCIe
> switch, the bnx2x driver causes unexpected system hang/crash while handli=
ng
> PCIe switch errors, if its error handler is called after other drivers' h=
andlers.
>=20
> In this case, after numbers of bnx2x_tx_timout(), the
> bnx2x_nic_unload() is  called, frees up resources and calls
> bnx2x_napi_disable(). Then when EEH calls its error handler, the
> bnx2x_io_error_detected() and
> bnx2x_io_slot_reset() also calling bnx2x_napi_disable() and freeing the
> resources.
>=20
> This patch will:
> - reduce the numbers of bnx2x_panic_dump() while in
>   bnx2x_tx_timeout(), avoid filling up dmesg buffer.
> - use checking new napi_enable flags to prevent calling
>   disable again which causing system hangs.
> - cheking if fp->page_pool already freed avoid system
>   crash.
>=20
> Signed-off-by: Thinh Tran <thinhtr@linux.vnet.ibm.com>
> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x.h   |  4 ++++
>  .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   | 24 ++++++++++++++++++-
>  .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |  3 +++
>  3 files changed, 30 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
> index dd5945c4bfec..7fa23d47907a 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
> @@ -1509,6 +1509,10 @@ struct bnx2x {
>  	bool			cnic_loaded;
>  	struct cnic_eth_dev	*(*cnic_probe)(struct net_device *);
>=20
> +	bool			napi_enable;
> +	bool			cnic_napi_enable;
> +	int			tx_timeout_cnt;
> +
>  	/* Flag that indicates that we can start looking for FCoE L2 queue
>  	 * completions in the default status block.
>  	 */
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> index 712b5595bc39..bb8d91f44642 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> @@ -1860,37 +1860,49 @@ static int bnx2x_setup_irqs(struct bnx2x *bp)
> static void bnx2x_napi_enable_cnic(struct bnx2x *bp)  {
>  	int i;
> +	if (bp->cnic_napi_enable)
> +		return;
>=20
>  	for_each_rx_queue_cnic(bp, i) {
>  		napi_enable(&bnx2x_fp(bp, i, napi));
>  	}
> +	bp->cnic_napi_enable =3D true;
>  }
>=20
>  static void bnx2x_napi_enable(struct bnx2x *bp)  {
>  	int i;
> +	if (bp->napi_enable)
> +		return;
>=20
>  	for_each_eth_queue(bp, i) {
>  		napi_enable(&bnx2x_fp(bp, i, napi));
>  	}
> +	bp->napi_enable =3D true;
>  }
>=20
>  static void bnx2x_napi_disable_cnic(struct bnx2x *bp)  {
>  	int i;
> +	if (!bp->cnic_napi_enable)
> +		return;
>=20
>  	for_each_rx_queue_cnic(bp, i) {
>  		napi_disable(&bnx2x_fp(bp, i, napi));
>  	}
> +	bp->cnic_napi_enable =3D false;
>  }
>=20
>  static void bnx2x_napi_disable(struct bnx2x *bp)  {
>  	int i;
> +	if (!bp->napi_enable)
> +		return;
>=20
>  	for_each_eth_queue(bp, i) {
>  		napi_disable(&bnx2x_fp(bp, i, napi));
>  	}
> +	bp->napi_enable =3D false;
>  }
>=20
>  void bnx2x_netif_start(struct bnx2x *bp) @@ -2554,6 +2566,7 @@ int
> bnx2x_load_cnic(struct bnx2x *bp)
>  	}
>=20
>  	/* Add all CNIC NAPI objects */
> +	bp->cnic_napi_enable =3D false;
>  	bnx2x_add_all_napi_cnic(bp);
>  	DP(NETIF_MSG_IFUP, "cnic napi added\n");
>  	bnx2x_napi_enable_cnic(bp);
> @@ -2701,7 +2714,9 @@ int bnx2x_nic_load(struct bnx2x *bp, int
> load_mode)
>  	 */
>  	bnx2x_setup_tc(bp->dev, bp->max_cos);
>=20
> +	bp->tx_timeout_cnt =3D 0;
>  	/* Add all NAPI objects */
> +	bp->napi_enable =3D false;
>  	bnx2x_add_all_napi(bp);
>  	DP(NETIF_MSG_IFUP, "napi added\n");
>  	bnx2x_napi_enable(bp);
> @@ -4982,7 +4997,14 @@ void bnx2x_tx_timeout(struct net_device *dev,
> unsigned int txqueue)
>  	 */
>  	if (!bp->panic)
>  #ifndef BNX2X_STOP_ON_ERROR
> -		bnx2x_panic_dump(bp, false);
> +	{
> +		if (++bp->tx_timeout_cnt > 3) {
> +			bnx2x_panic_dump(bp, false);
> +			bp->tx_timeout_cnt =3D 0;
> +		} else {
> +			netdev_err(bp->dev, "TX timeout %d times\n", bp-
> >tx_timeout_cnt);
> +		}
> +=09

Hello Trinh,
bnx2x_panic_dump() dumps quite of some useful debug (fastpath, hw related) =
info to look at in the logs,
I think they should be dumped at very first occurrence of tx timeout rather=
 than waiting on next few tx timeout
event (which may not even occur in some cases). One another way to prevent =
it could be by turning off the
carrier (netif_carrier_off()) at very first place in bnx2x_tx_timeout() to =
prevent such repeated occurrences of tx timeout on the netdev.

Thanks,
Manish
