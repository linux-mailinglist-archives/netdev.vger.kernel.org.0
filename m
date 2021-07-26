Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF75B3D5958
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 14:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbhGZLkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 07:40:52 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38060 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233713AbhGZLkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 07:40:51 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16QCALLw023474;
        Mon, 26 Jul 2021 05:21:12 -0700
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by mx0b-0016f401.pphosted.com with ESMTP id 3a1m961jk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jul 2021 05:21:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFW+HDToMann1LU5crRNTJmrakW4CZN59OvCyxw1m5OyDk/eWS8Y77qQsF16dkjkxeHr+Uq1YwUGlN5pYD52G6nX487+xG5mMGPy1PhVrhetYH9R49bFYB5RkMCkP0JglNv+TCMRvxoKANr4589zfiRfq6vjHI0GzKVqebh73DKU38y16BlBKp0w+TiZ9BWqWilNwuE3qxVr2GsOcfljCxlQwW9M1O3ee152JORhOHVGcuxd3TcyJhBhSTPqgOOXDCiUjlekiioEXcj/nQOc/QMvjCEJ0addrY/HptA5d5vKCHNq72LB073cmiws3VQ3ynxWVpGVLhcSvlMfGOxi/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hlvrLUkA6MThL5gpBZt6Rx44hfot/lBZnnleXXSbno8=;
 b=RezIosHElet62eFS+n0FPmseVSUe5fHMXZ6vSbZnnCsMmHmc2psW8WVHYIyky2F6zx2jwc17qRnNIB0cfsF2on+wmUkONeVlkg6igIqvbdNi7XlKSoCY9ZxaI6+T0tIyD5oXXyq6sYAd5+En3pfK2aGfGubTfR4P5L/UvgGcv2sBSudRRAaxXe8SMXVeRbBMydPw6pyaXTtHmfu1dYe7RVg2SnrjQhGv2W4AxWVCHmG8rbDKUDLkp0RD7h0ZTdjow755NZNg3J+WL0fR+5m0hidNtJhYq8BZpR6D6mScULE5Hwz48Sul6wuLAENblREXBA5CpMNgKPShyVxKD/PK/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hlvrLUkA6MThL5gpBZt6Rx44hfot/lBZnnleXXSbno8=;
 b=SxN6qTXNHS/Tvg6I6oOpfjAr5ZuZ71JdOPMBrimKROoIfOHumW3iDF0G1MoWIT9MT/Ro/bSbg7SWvYLNBq5xBv+kKE06On0LLj+hVqg1BJHTuTSGS2fCbENDZxotWqEzs9YuUIpyPRHJzMQHjXmXFSQb88ciDujzPrX007k2xG4=
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com (2603:10b6:a03:2c8::13)
 by SJ0PR18MB3882.namprd18.prod.outlook.com (2603:10b6:a03:2c8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Mon, 26 Jul
 2021 12:21:09 +0000
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::6513:d2ca:d44a:537c]) by SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::6513:d2ca:d44a:537c%9]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 12:21:09 +0000
From:   Shai Malin <smalin@marvell.com>
To:     Jason Wang <wangborong@cdjrlc.com>
CC:     Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: qed: remove unneeded return variables
Thread-Topic: [PATCH] net: qed: remove unneeded return variables
Thread-Index: AdeCGC9IfE4nt3qIS3m05qzRm1RMrA==
Date:   Mon, 26 Jul 2021 12:21:09 +0000
Message-ID: <SJ0PR18MB38825F95FA58CF72393D0951CCE89@SJ0PR18MB3882.namprd18.prod.outlook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: cdjrlc.com; dkim=none (message not signed)
 header.d=none;cdjrlc.com; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad312217-632b-4e8d-d799-08d9502fd9ca
x-ms-traffictypediagnostic: SJ0PR18MB3882:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR18MB38821E92E5FE2DCF4409FCE5CCE89@SJ0PR18MB3882.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yuc1IcaziyT7b4sJBfPoqqtyotVAmlNRMIwfOtBVhzoayCjZVJKHKb6Y1xmdQcsjQ6AT0Qq+ugkkfgXgjIsOpGfPOahASDYy6YAKx6h3EXuYEb7w2gOosC9mGJolf+UUDUNUBiHzulgwRTJn+F6zdSln3g/2q76DPsbp5hrmIi91M+nj/EW6D/h4hkbSJnsC20z1iVIOLbyGFBtPbPCP5RaOMLAOvLlk0kwhdLiU2FH6kVYcOnPa5pYPxFd6idGIuEZWY/k8xySjXYi7EBYqGKTQ/hdgglN47sjq76oTVe0V6JOUsQWuMMUYhiaN5iB83R/EzyzbRAFj7KKNeqLPCuloyB6Lg1OczKwffLZfxUZ1InCJJH/aiqUqziYm3dMOYSDrVCVjThQ4Xy0xf8Qz0KaejKzscoloHeX1PZ/DLVHGUtVQpe6d+i5MKDCM9v27+T8QjnxGdYiYjlFhvOPAlIgFmvCCZ+PWpgvDr2Ra4jeZlrB5sAYf1tqCTSXl5b8xzK4My1hp9h0vKkvcFkNtOMahMFGBn+hc2yx2MWLh0rdgEnWBTP49gWohJQrsyG7E8KAUbPDmCO/2RCDsDb8OL7Oz5ymK7AQU2nK6at2StG/OIdSthERTQresoWIlZ2BTyD6qjTrQu3qNteqGmuLn9o8OWTiRexCSscfT1WQkN5KT1RYG0NWWyNLo1oTE7VGh12MSxcf7voRxxORmuP6w8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB3882.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(71200400001)(186003)(4326008)(8936002)(64756008)(38100700002)(7696005)(52536014)(2906002)(6506007)(9686003)(122000001)(55016002)(86362001)(83380400001)(6916009)(33656002)(316002)(508600001)(5660300002)(66946007)(8676002)(26005)(76116006)(54906003)(66446008)(66476007)(66556008)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DKTxck5Y7iF4fpftHtRCZ4embhTX/45inOBFYlYQnSQImhSiZqbex50vOZQj?=
 =?us-ascii?Q?TVzRt27W0fJmjrFq190KWyF0DBK60ZfGiNUkk4Ris8DQStx76ascueHG6mGr?=
 =?us-ascii?Q?599YVQor8L9FKOxxNIaqFYuWcYBQ0kSgV92IDGIKvWchLJjEKE474N6HUMGI?=
 =?us-ascii?Q?8G5OFkgPlYJVpPKtqAGLeF5ukLG7Kumu9XyFvQa+5kqFxuS+jqBIRk5wcYww?=
 =?us-ascii?Q?WDEg0fAwHiAkDTio5p62jwhF59+fZ/tT9RvRgXP0lvzQuHdwzIwboGhQdjgA?=
 =?us-ascii?Q?J7NcS1KcWFRsjNuhimDyQ3iqobIfuNu0xQ0TCABOBRIKmWQFd19sN1pGrfAb?=
 =?us-ascii?Q?kN4GliCSh67fmvkIlsL+WzbDrdkzEMj1N1tAfo5O8in3pf4CIUjxfZkQ15H6?=
 =?us-ascii?Q?ZOGj4+IApcGo8ODt+Se+Wqu/Muxy201ak9P7/lLVwKbAy/NV+/e8kdKZCjNb?=
 =?us-ascii?Q?/yrzxtu+WeYx5UkuQ0uDHN74L3qpHTOOCVhUpvoKGFzmS9v2ornvLrH9gtER?=
 =?us-ascii?Q?D1BTryOIEHc0J3Bee7eyHittXxwoNhZ6ZogKc982MRppNIuKjTNV1xLXSEZP?=
 =?us-ascii?Q?QA7CjolsJe8XFGj1MyOCCRVyDd91Ld9guLczAS5sD0wRnCdt9QL/BxhXMaN+?=
 =?us-ascii?Q?kAaAmuDL6MCmPeuM1xULJUnbGNFcFCN+qzvY/VOgbL27JvydgzP/h7nYimkN?=
 =?us-ascii?Q?niYFUUVAdJmLw435dcmpHEAfiREV6YjpHgZaILTOxaEIqIXS+l5jVkx7meRq?=
 =?us-ascii?Q?E1o0B5vQRbmHlDWnU9gAjLW9wDuCslmyOHpLlmeCwbPpdUHZVswAvbziE0wH?=
 =?us-ascii?Q?hm2nx3UaTHp4Mi9QcfylPK/KGukR1Ju42bAGn92LYeBKES8OVqnCitMbzaSP?=
 =?us-ascii?Q?pFgNSqErO44y0K6q/c2nm/RzrxjFIM518PIa2n4lP0HUwuzXZjvibwuBteyX?=
 =?us-ascii?Q?frWREDuOyfE8j5/B8FAsQms8mLuHdtY72WQ2QRFMd0+xypHSAQcQNQg9SOUc?=
 =?us-ascii?Q?qsvXdmYRtA4HX60o1tq7UCn85nGTJifQJMWQG695T1Y0RxSj1LDj0F8AszwQ?=
 =?us-ascii?Q?czFL209VDrOlSonYdS/pSdfOm+9IfkNosedp7qhvZ1wX+byUceyQ4r18+4jw?=
 =?us-ascii?Q?98mEOz92Bdzgbyps1ai7CJ8TnJussHpjrTarqQUSBNuWPjTpuGi4lzPYiY5w?=
 =?us-ascii?Q?gZ39cVcWO//Zj4EjbM7iuBSUsJ4psmj3+gblD3gO3VniQSQqgvK1u1Hpyriy?=
 =?us-ascii?Q?iqPONNTwDICmjhAbqtrJQkF+DyifKkOGWbWW6KLjGjUPm9HbP+AOrrtJyPMY?=
 =?us-ascii?Q?rBcd6DQRBbYvMQ1KmeFxltwv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB3882.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad312217-632b-4e8d-d799-08d9502fd9ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2021 12:21:09.6842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wEDfrXEAWJpvbXU1TuuX58UopHBz99x/YxmhadEtor6mkH4n81qOpEdPx5xURaOARK49v71mNP7SOx4CpuLmkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB3882
X-Proofpoint-ORIG-GUID: n2BfSMyVdPUrCWkBP7ouXTYRItRkcdDM
X-Proofpoint-GUID: n2BfSMyVdPUrCWkBP7ouXTYRItRkcdDM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-26_06:2021-07-26,2021-07-26 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sunday, July 25, 2021 6:14 PM, Jason Wang <wangborong@cdjrlc.com> wrote:
> Some return variables are never changed until function returned.
> These variables are unneeded for their functions. Therefore, the unneeded
> return variables can be removed safely by returning their initial values.
>=20
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_dcbx.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
> b/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
> index e81dd34a3cac..dc93ddea8906 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
> @@ -741,7 +741,6 @@ static int
>  qed_dcbx_read_local_lldp_mib(struct qed_hwfn *p_hwfn, struct qed_ptt
> *p_ptt)  {
>  	struct qed_dcbx_mib_meta_data data;
> -	int rc =3D 0;
>=20
>  	memset(&data, 0, sizeof(data));
>  	data.addr =3D p_hwfn->mcp_info->port_addr + offsetof(struct
> public_port, @@ -750,7 +749,7 @@ qed_dcbx_read_local_lldp_mib(struct
> qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
>  	data.size =3D sizeof(struct lldp_config_params_s);
>  	qed_memcpy_from(p_hwfn, p_ptt, data.lldp_local, data.addr,
> data.size);
>=20
> -	return rc;
> +	return 0;
>  }
>=20
>  static int
> @@ -810,7 +809,6 @@ static int
>  qed_dcbx_read_local_mib(struct qed_hwfn *p_hwfn, struct qed_ptt
> *p_ptt)  {
>  	struct qed_dcbx_mib_meta_data data;
> -	int rc =3D 0;
>=20
>  	memset(&data, 0, sizeof(data));
>  	data.addr =3D p_hwfn->mcp_info->port_addr + @@ -819,7 +817,7 @@
> qed_dcbx_read_local_mib(struct qed_hwfn *p_hwfn, struct qed_ptt
> *p_ptt)
>  	data.size =3D sizeof(struct dcbx_local_params);
>  	qed_memcpy_from(p_hwfn, p_ptt, data.local_admin, data.addr,
> data.size);
>=20
> -	return rc;
> +	return 0;
>  }
>=20
>  static int qed_dcbx_read_mib(struct qed_hwfn *p_hwfn,
> --
> 2.32.0

Thanks!

Acked-by: Shai Malin <smalin@marvell.com>

