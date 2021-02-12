Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25F431A0E8
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 15:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhBLOux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 09:50:53 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43488 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229465AbhBLOuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 09:50:50 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11CEkNfR028942;
        Fri, 12 Feb 2021 06:50:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=82EOKuAnUIiuwpXt0POPAF4T54Mi1u9/wFlbGKeUNHc=;
 b=Kp3BrWXXzHGHdcDsFiTDLo+F4Z7VT/8W5miJP7mVCSCKjNKqmPKkwo1iyS5Kv5Qty8Mh
 zdx5Ttb5Lwz+R5xyGVosMJavNOPXLmn1dzNn6IZnN/wrt6xRG2g5G15HDbFRISfakWPu
 Z9rsbM8PFHiuCKdo4g+uACCeNpbLL3xDebMF3utS82qBQ86DcCf5WjSe5YELjsOmmWLh
 +2jm8L/nkaU2hg6f9TbDa2rIxyMttV8HNz+ZkTtbFnjMA0zysWPBmRcSrgG5KI16OTS9
 9um+OW+p1AimcMx4EjBIh/4VbQVFd0/Hq80BuCdUM0R0xI3p4tdZ/AlyIFcJMjpYTweu HQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrtys0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 06:50:06 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 06:50:04 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 06:50:04 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 12 Feb 2021 06:50:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVqashpOJNwbrG9AXv3As7uYcmECzNXVKGL077oedFVDUqchULh2VlLH+Mlb/DHUoI6Dlr3iPsHZEW86KGho1G7qIsrRKFBXp3U0HF4xncs51Wercv3ctBv/Q/1VYnEYFzF76DgeT//CMI5zPZbNA2JH/wpBdmxDXKIYgK9Eias0GBYW8NEgEWISgtG+vI5xJNag7COYkS53ORwc0DpGHolucafBVPq4KuIjorYKoKe4BnRl62IXvk9/jixeNEzDQXnxatobr5EK3YIugA+Q1ROg/luL8WYdHwtvJl4iGNo9+4tHT43+1x71Wzt2KeNdRRhfvr9RCP2Ntg6SEQJI7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82EOKuAnUIiuwpXt0POPAF4T54Mi1u9/wFlbGKeUNHc=;
 b=Pw1dwA8m6E7WNGG78JHNhX6yDl5Cw4QEYs+NBDgxmsovILJDAbk4VYPtukY9nDvm8sYtkoo+yES82OyH+u77JZ/nHt4GXhlPaWcnO9T1qDnMNe0ziB/4DqkDm3jWz77bfF36KKvC/I3b9H9aM2dNh6tn3Fuyz3cmUi1FQ69zp3aORi1Uuo7pxxl7h866EN33I8lzFArJrqxGwp633zbkmiblNHLITacEGT5oefoJBAiDSnslLn6ZuKZIyrBOwlwsD1c7IReAPx+wXtQN3cgwP6qiV0mob6rxNUd2K4yK6iUdAbNldT9wCHsz2wRYmpm3OC/7CAW0skHLlT9AX1j7SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82EOKuAnUIiuwpXt0POPAF4T54Mi1u9/wFlbGKeUNHc=;
 b=L/a6wJl6/EcGFJ7daFF3Ts7VhIjIBmj2a67xRv3rNCv/QzXYRXhQwVwGEINtuEzy1SKGEfDaUZNy88943jWV7IuGasmg87nejR8mndkvVBaQBp5p/YQGHWs0GBEEvyQeeM2ImeDqjIi4ucyI2elZfB0GQsRxFQgU6rIAEw8cQV8=
Received: from MWHPR18MB1421.namprd18.prod.outlook.com (2603:10b6:320:2a::23)
 by MWHPR18MB1005.namprd18.prod.outlook.com (2603:10b6:300:a1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Fri, 12 Feb
 2021 14:50:02 +0000
Received: from MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d]) by MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d%4]) with mapi id 15.20.3846.030; Fri, 12 Feb 2021
 14:50:02 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "Subbaraya Sundeep Bhatta" <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Christina Jacob <cjacob@marvell.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: [PATCH][next] octeontx2-pf: Fix out-of-bounds read in
 otx2_get_fecparam()
Thread-Topic: [PATCH][next] octeontx2-pf: Fix out-of-bounds read in
 otx2_get_fecparam()
Thread-Index: AdcBTWZzMtH7JWZ3TBqVJnpwtQnYmQ==
Date:   Fri, 12 Feb 2021 14:50:01 +0000
Message-ID: <MWHPR18MB142173B5F0541ABD3D59860CDE8B9@MWHPR18MB1421.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [117.206.226.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87d24777-5181-49ea-3aa8-08d8cf657a1f
x-ms-traffictypediagnostic: MWHPR18MB1005:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB1005623DBA3ADB7AC99E86EBDE8B9@MWHPR18MB1005.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1L8TXBDbGW48PqQsVKZTXSRLBVOekjnBMcPar5VKa7ZCEflf3HkCUU6Ws+6n20HdI7MWaVmqs+6OLOW7kv2G7YMbcL2qMnI6pC0ktxDciPjjJ5BACM+YDT04CMAFech1BqfTfbFew/rIM/OhdRxxeeUa8Pke3IHBdGFQNPDOM1Kq+CpTQBA1Je3ejnQ8m3Mv+V0AHmbvLusSfWAtJbZFjOovj45pDcsDARuLQiKD6Xh5iVBGDMt/FSsnVKA8XZrUgV+k+tmWVIepwEYx6ZSQVT17lzHpmR7pOQ9lwGXav0iPk5v9Cpre6qeYFWFJsiCr6idFtLgQbgVRHG3ma2OQSglh9C2ozm0aQxTJKU6k/+kF+P/bknZozL2fGYccsQYdn+OJ50rZHiHYQTmdsJpXjrqT4A0stJ41XdFHUSTlyCxJHgxYj8mg/MhDQH+io4J6vd3dWQL1P6vYORrRXZnJZgy5aPCnY9NdKhtzuT+jQusVZWGO/BrUdILOmJMVv58Wjl2yyDMcvmW7W+Sn+LWkPQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR18MB1421.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(396003)(376002)(136003)(366004)(55016002)(8936002)(5660300002)(54906003)(64756008)(316002)(8676002)(86362001)(7696005)(66946007)(53546011)(52536014)(4326008)(2906002)(478600001)(6636002)(76116006)(66476007)(66446008)(110136005)(186003)(9686003)(66556008)(83380400001)(33656002)(26005)(6506007)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?8rF1ak3UWUljdYNIOB5+xpFIA52dAqGJE+7qSjSfRh0C+hxXWb8Q6vYev7vp?=
 =?us-ascii?Q?F4SdwtuDraW0mShNnEeNrpXBcOyWXA1IXnJ8FRlj1L37Ql5vyLOJC26AMuAn?=
 =?us-ascii?Q?BIKz7GeVGEYmWrRwE2apCMVIMssBglIwPiAqIo6cyVwHtn05/TKvEXPDWu0V?=
 =?us-ascii?Q?psOIXvWcVQpxWS1ZcG7FBaG2gJKXiCvlD/0BL1ofBvmcvf03li3eztcgH+e6?=
 =?us-ascii?Q?Y3tcLZ+wQW6yvVvttxgrWAPn6xCrGfU3caQJrbarzNVtxtWn3PcZPNNXICjs?=
 =?us-ascii?Q?wTFPoDohs89ixJbX6FPWAQA9BnsVMleXMRWF6o9pCmsKcVUwTsHBYYgE9hWw?=
 =?us-ascii?Q?gu+4omxw1FQMcnA3ejiDht0uT4J/5hE/1ZPN24t4FalHYI/35jQJYKh+vVvm?=
 =?us-ascii?Q?MkrA1ZX/69RqWJq7M8QnzQqqQq/OTomX/1inP7AQjtByav1H6vVRxa0Cz9Ob?=
 =?us-ascii?Q?qInFsgGPan00OUNor0XuRWwTDQUODH8+/5l+WHyl74pIzQT5QZijBJGiu/53?=
 =?us-ascii?Q?uC8UeuEb2c4F++39PaVitACoBix4ceZXPkpOgFWT/PPo/pE3fU07/bra5l08?=
 =?us-ascii?Q?yYPO/CRk9/0s+1clGXRqBfyCDDss2o8KMipB1ITe5MInesJUf5cfOzpKMi/n?=
 =?us-ascii?Q?SQc4nq+w9gklOAVPORBk6E/7TC5ropowYbtGOGRhx22HPLrYNKremlqDkKqN?=
 =?us-ascii?Q?O+iGpQNrYlQhesb4oilW6m7ipEwgtUAiuCdkCK1bRJMLP9GQf5JKKLNQs/aO?=
 =?us-ascii?Q?MKKyAsP2xDD9vwT4p9WLr+It9hXxNIFNftBkghGa6OPlCUPkhd9bFWIZpWII?=
 =?us-ascii?Q?nFi9d6gJr349iOV1wi0VZzZRkznsAGaezGiX2Amrf+bfU93OIaP3PeQfBlFF?=
 =?us-ascii?Q?/RdLXUdkTY+kLTBvag2bwP0MDtinu6crQj4BkbuEVgz25ZNW24/zBIetpYX7?=
 =?us-ascii?Q?vPURIcmpJy6gg2N3EyHWAlmvwwHVvFkNpF5iRxUSqJvJ4PrrQMXd4sG94aEi?=
 =?us-ascii?Q?+WIVAbdIKcQGTAB7BLQOWForqE1E54MpAOE6VXxVf0QVaGE4bUCIxaY5xTlL?=
 =?us-ascii?Q?N4AH9vvu1RwEbOE0bwbHqcFee/+Tbr2rQvhadZX+OVMYYW1hER7g/FRTSmYw?=
 =?us-ascii?Q?vBexmEuwzWlxtNVAlJROorDK7c4oQXEVn39xJhxKsTgfmJOIWBDbt9A7RduE?=
 =?us-ascii?Q?1veVCwAkH2rj+0xu+RtOHL0neluYJEAOKsMJFdhqBFC4GQmcPsLn/KB+3880?=
 =?us-ascii?Q?vSbLMKJQO8GA9RBVCuVcJKZp7yi7W8TWhJYZQm1BegDFX3s5krEu876KXQDw?=
 =?us-ascii?Q?VDCSlC2eWB8tdb3zBPWhwCgX?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR18MB1421.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87d24777-5181-49ea-3aa8-08d8cf657a1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2021 14:50:01.9239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dFhmMgnRQ1C6se2Of4z7lBYKXHgLr8vjKWV4rDkf4QNri+MIdi61LhiwknPA+ITh2yR3DACGdUzrYZHSW4LcRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1005
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_04:2021-02-12,2021-02-12 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gustavo ,

Please see inline,

> -----Original Message-----
> From: Gustavo A. R. Silva <gustavoars@kernel.org>
> Sent: Friday, February 12, 2021 5:53 PM
> To: Sunil Kovvuri Goutham <sgoutham@marvell.com>; Geethasowjanya
> Akula <gakula@marvell.com>; Subbaraya Sundeep Bhatta
> <sbhatta@marvell.com>; Hariprasad Kelam <hkelam@marvell.com>; David
> S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Jesse
> Brandeburg <jesse.brandeburg@intel.com>; Christina Jacob
> <cjacob@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Gustavo A. R.
> Silva <gustavoars@kernel.org>; linux-hardening@vger.kernel.org
> Subject: [EXT] [PATCH][next] octeontx2-pf: Fix out-of-bounds read in
> otx2_get_fecparam()
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Code at line 967 implies that rsp->fwdata.supported_fec may be up to 4:
>=20
>  967: if (rsp->fwdata.supported_fec <=3D FEC_MAX_INDEX)
>
Thanks for pointing this. I missed this case .
rsp->fwdata.supported_fec range  is 0 to 3.  Certainly 4 causes out-of-boun=
ds.
But proper fix is=20
-  if (rsp->fwdata.supported_fec <=3D FEC_MAX_INDEX)
+ : if (rsp->fwdata.supported_fec < FEC_MAX_INDEX)

Thanks,
Hariprasad k





> If rsp->fwdata.supported_fec evaluates to 4, then there is an out-of-boun=
ds
> read at line 971 because fec is an array with a maximum of 4 elements:
>=20
>  954         const int fec[] =3D {
>  955                 ETHTOOL_FEC_OFF,
>  956                 ETHTOOL_FEC_BASER,
>  957                 ETHTOOL_FEC_RS,
>  958                 ETHTOOL_FEC_BASER | ETHTOOL_FEC_RS};
>  959 #define FEC_MAX_INDEX 4
>=20
>  971: fecparam->fec =3D fec[rsp->fwdata.supported_fec];
>=20
> Fix this by properly indexing fec[] with rsp->fwdata.supported_fec - 1.
> In this case the proper indexes 0 to 3 are used when
> rsp->fwdata.supported_fec evaluates to a range of 1 to 4, correspondingly=
.
>=20
> Fixes: d0cf9503e908 ("octeontx2-pf: ethtool fec mode support")
> Addresses-Coverity-ID: 1501722 ("Out-of-bounds read")
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> index 237e5d3321d4..f7e8ada32a26 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> @@ -968,7 +968,7 @@ static int otx2_get_fecparam(struct net_device
> *netdev,
>  		if (!rsp->fwdata.supported_fec)
>  			fecparam->fec =3D ETHTOOL_FEC_NONE;
>  		else
> -			fecparam->fec =3D fec[rsp->fwdata.supported_fec];
> +			fecparam->fec =3D fec[rsp->fwdata.supported_fec - 1];
>  	}
>  	return 0;
>  }
> --
> 2.27.0

