Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8416458480
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 16:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234075AbhKUPnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 10:43:32 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:12692 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231509AbhKUPna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 10:43:30 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ALELjh1003720;
        Sun, 21 Nov 2021 15:40:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=dHE70YHuhe7ERChVUOBKgLwzYIyizBPaT6SYtv4lAjs=;
 b=Wmkz47sWzHoTC/GBSMKRy+G7G2bcyxTSj0H+62WAQSscJLds1y0rVytFFAoyK4VduLAn
 FfBA9X+mdo0TT+Em8YeduWWjVBurOJFtoL/RHYMXw0z3cZHf6Kfp2fq7GxFnWa2+QE6j
 x1ioF9YaLdbdTtgeZk0eCApM2Y2s30z4/V7Tne+EXBxCnIOGDwDD9MolOj4D8SwawFQn
 /opaIwDn+FTuBoc0c3YfpxqPwhwJwbQ8D++Ieb9rxwe4Jh/5z8tG41SVoQPVfLV7WWZ2
 AIMhJ5xLi84MgbpD5zzaZx9V1djsrgjTcewKWz/5daiOEhOi6+ILkvYWAB5Hf+xWirvl Jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ceqt24f1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 21 Nov 2021 15:40:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ALFaZHF142469;
        Sun, 21 Nov 2021 15:40:15 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by userp3030.oracle.com with ESMTP id 3cep4vkfdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 21 Nov 2021 15:40:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UB4y8b5IqP4InzrQgeTDEZ3fqQhx2er+33C3S7sdNVdSVnIYlEw3JxDlNqYdisvII8/NjIu1CBxj7XndSHWm8rug/p4v6aRTs+Jf/yfPP+UFxrpulHnNS7Znv17yKMLKVUx9Le0v86nJfVc13qm9R+lpRxM22rU7rfyG8fgnUX/biTOlRFS1QyjMIFj8d5/1T2h0X4BOZy71x9FolmnJGp69jun0qClefl1b2IifOl3fypYFoy321RXBNNcE+iPL/C0qJecj/gnEo72YJbpTvcpbKJsZIlvN8t7oEnKNx/weGMdOZpoV7SNLf8nK4PetLIEXHT+3Y9xRRtD2vj4CKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dHE70YHuhe7ERChVUOBKgLwzYIyizBPaT6SYtv4lAjs=;
 b=VlUTMuFxv0c0rEbaddVvtNIWASYoAZOakgyzO0d5nC9PQ1mIAQref6oi3RvGS2nOWZq0TBPrUTd63FpnQ9Dbm2e0hnxa402IrETJyoqhm4Z0i9z3gfFctliPw/2bblcAnpDTcOBL8xf2QBy+4TySLbSftucreu74zYTNivHf9y60n7G8EukM/u1Xak/CDr8ul8zQ+b1a/HFI2IhgoGmn2mol2G0xNOEAZenWsZw13i0K3idX9sJxzOwb/fO3Ctj8KVvqtm00g1PELFSEC2cE5HuT6diWEbIcPgXMrBIj+BOPUM8MQjX+XI4ZA1khCBCpcE8w0po6BbiTvRe7HGQaQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHE70YHuhe7ERChVUOBKgLwzYIyizBPaT6SYtv4lAjs=;
 b=pgP6bxSPBnLgOUsKCA2fy5ozgR+GExjXczhczFZcgcsiCdIm6fm+NA+7skOypn5QTS+qgeLTc/+9DMrEfEt041uWaEhm2fs3tDWk1DYNIvOCckrlLVT7Mwrq9FPtas6d0bqEFpcdsa0d3HC1urWAlJwhRXfxMu7dpssaIZVJ3eg=
Received: from CO6PR10MB5635.namprd10.prod.outlook.com (2603:10b6:303:14a::6)
 by CO1PR10MB4596.namprd10.prod.outlook.com (2603:10b6:303:6f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Sun, 21 Nov
 2021 15:40:12 +0000
Received: from CO6PR10MB5635.namprd10.prod.outlook.com
 ([fe80::7d4a:284a:f0b8:1511]) by CO6PR10MB5635.namprd10.prod.outlook.com
 ([fe80::7d4a:284a:f0b8:1511%9]) with mapi id 15.20.4713.022; Sun, 21 Nov 2021
 15:40:12 +0000
From:   Devesh Sharma <devesh.s.sharma@oracle.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH] rds: Fix a typo in a comment
Thread-Topic: [PATCH] rds: Fix a typo in a comment
Thread-Index: AQHX3uz4Z+Re61EmG0+MvJ5jngOc8qwOHgLQ
Date:   Sun, 21 Nov 2021 15:40:12 +0000
Message-ID: <CO6PR10MB56357A8CAA9C187DDA378276DD9E9@CO6PR10MB5635.namprd10.prod.outlook.com>
References: <006364d427b54c8796dd1a896b527cd09865bba1.1637508662.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <006364d427b54c8796dd1a896b527cd09865bba1.1637508662.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e8e7cee7-17da-43f1-e082-08d9ad053524
x-ms-traffictypediagnostic: CO1PR10MB4596:
x-microsoft-antispam-prvs: <CO1PR10MB459668A0CA9FC9C0AE7E70E2DD9E9@CO1PR10MB4596.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:233;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SrlmbAkWF39DDOupySxB1GvcwqpyfGXZ4UeFsIG2OtrsEg8CIsXIvTuKvLdjbOf9c/d4P+LYhGGK/pdzzLWgUkukAaZkvEMj5tqLXEupMToRlmYIT3q46I9IhBS+JfNto6HJnA9BN0ePsKesuzX0PRzMDWau9+C5ybdQtefTek8g9o41iTlAkpjiQT5uO8jyoJ0V9pzgqr5kXySwZNO3xt38R7/Ab2zgUR/QW/mtmunc3q1Q/fjaHE7DKVTuJkOqgwHJdKq3DnzTt8HJJTXoEVLY0Fo/H3XJ2i+GzlaCRR7G0OKc4ydAakF7H5FCBO7Ogry827LCn0FC7kJpdLo5h/pyE7HXgQ2f8btpoECIP8UsB4ZN8M+CHfuIeMbgi2Ojd2pg6kOqMmzsFZYBqQBwYRMBoSGCoL5OhSGC8vb5LS1wdCw+C7YavcI9kpLmHY8TekxMXcZNEryBm1l5gDTF/jsX6tSDPKLCz518axWKc83NfAhwixg0H12KhpbUNxVrE49paZO1RGCpRAni93VvJv/zhVm4qDDEc9Lv1mdbYfxR0Fl78G6qv8h1tsT+kLYqL281lUIv+UpPg3+vNCwJ87ZHDYRwUaIiwAsudc86eNOOHSbP+/uUW+5TSjE8j+aBjGzik2qZhOPG9VqgTfowEEmWJwmVz3QfR08CDW6RJ76IpgzYVM/PZpL4X5fafuWcbPAOlyC4xGEWdFz7CbhNYQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5635.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(7696005)(6506007)(4326008)(83380400001)(8676002)(54906003)(53546011)(316002)(186003)(508600001)(2906002)(8936002)(52536014)(38100700002)(33656002)(38070700005)(9686003)(86362001)(76116006)(5660300002)(66556008)(64756008)(71200400001)(66446008)(55016002)(110136005)(66946007)(122000001)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wT8TtTPjNMGtkWnn4sOf2nfs6fN0Gd8UuhrhrGGEBbGqJNFDiY/EM+KmraAE?=
 =?us-ascii?Q?vDC5oloEthSEhj8VqGA4j6NYHHCeI6ErPHzlInRF/MDl93SHn4hsrHJRTYOV?=
 =?us-ascii?Q?kvWjd0i93T+rbmgE+OGWo7aWD28hJ/yQ0+3HsuK0iMn6O2nUyrZphibf5RaA?=
 =?us-ascii?Q?gI5Geoo7d4T9PwWDLJzMbEnS+qfBaOjZtao8NiP3JMiS7LCx3hKRzGvcpbco?=
 =?us-ascii?Q?50wdX4xw7e+LTYbexEfbzmV85j2eTaHxSOAkQAUzv4oPQDAgg6fGDOT3BrEw?=
 =?us-ascii?Q?2ll8+Rl3uDRN+o2spuEKGcVtPdfKWcP8yidC9jxsVxBj70dbfAWlQTPMRzGt?=
 =?us-ascii?Q?MhHjDqQrbIIlIPYWMyL4eQHlInVa4Y5HoYYEorm5YegHZpBWtSLQ2oha7TRL?=
 =?us-ascii?Q?ZOOXUhTG83r0VywXDf/DVGB7y8gl+SYJ4E0zrXr08Gfm1nBSdGoqWyxp2CkN?=
 =?us-ascii?Q?5TBBclXLfqlFPbijmA5fntH0F1oItJ1ueQlrCT5H6aaiiFvydUe8YK/XlSXc?=
 =?us-ascii?Q?aT+t/ARtoEd/B/RrRhiMko4mHASb95uQY1zveuHalvu7AmvDW43dO+uKC734?=
 =?us-ascii?Q?TtAEiiowp0ZtKrZpI58c7qT3LR2qlOCvYYEkIWfWMVbmXo0xfTNm969F5xPu?=
 =?us-ascii?Q?1lK8XsOW7MgB2PckGWn3eKBmQUASNIAVs2fWM449lBxDO8wd2YVWnevkExUJ?=
 =?us-ascii?Q?TSBwjs4cne/ldSV57g54cwYdBtyFc76uFcpFkj9YPP+IJmW56jh+97HMoWkU?=
 =?us-ascii?Q?oQaabsQnx+dtuhWJKulWN7sBjR0Yg7pCtLu1zjLFbeDql2NVlItQgBO11jUr?=
 =?us-ascii?Q?hzaG7Wdwwylt6XhJyOAo90ZiLMYcC7xFOihhIVOOja83Q4QDMUJJAFaTad6V?=
 =?us-ascii?Q?iK3g2IfzVmT4sIqgqmrVxB8ySmmW8RRovIPGdvw0PivitCwPprJKJn56ADkm?=
 =?us-ascii?Q?vjtWusZMp1LnkJQf7YNCMSWCEmc186lY7sdZ0CIt9mYfSXH1N3btaiUe/e2W?=
 =?us-ascii?Q?4Yb61uXd3KYMU5gqyvEjp8HNF6lImH1HEJk/eKTYMk0JLNwGS9oJ4gMffznT?=
 =?us-ascii?Q?hxVrR/EtnfJDevnO8CnDnL5DoCENTYLeY8oTDfqCCQiKDlG8YkFqaDy/iI3d?=
 =?us-ascii?Q?h2Bs+j7AS03KKS0VFBabrncXAgNt5deVVBlWs/cwqBUnBpKpzwAWh0//DdCw?=
 =?us-ascii?Q?70I7Kd503DofwP4vSHwuBUh5I70OxymWJBWgddaMin9B6pMJjxT4J0GZAcE/?=
 =?us-ascii?Q?ek9O8kEuie4vsq3VgLZv56E4L9ftit6fUwm6yWIyaMZOZUsOGTcrLIQbbT6u?=
 =?us-ascii?Q?SpUSR8XQ3RyzXZl9ihG/71XK+frmcWYw66kySIvWk2oShsGA0wuHykGR4i+2?=
 =?us-ascii?Q?5XF9iZg8Tj192JvBqr82wis8YKKlPGNpui6IJpev1UFw4ZFyH8SG+r14k3iR?=
 =?us-ascii?Q?++Q7p50Nfrwh6oaiuwcUDtj4fGrHYVetzO7tXoMkRVdlLMw7oUt+VT1rrv8E?=
 =?us-ascii?Q?7ZhC/LyVqwnf7+TaHrNbDJbho5qKZ6NjuqcXaC8W6epWlVUNwUeSN03oefYK?=
 =?us-ascii?Q?YSOLBvs8odHXRS3YC1kqUyaV0fmQZ7KbiT3GqyaLzq1uQQvgL4owj/qc+ZAb?=
 =?us-ascii?Q?JLsxUfNaeAoT0j7s+Bmrzaae7PmajIyeQcuc9eNJMZ8K9iIZVPhFITklVq3X?=
 =?us-ascii?Q?r0gcYw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5635.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8e7cee7-17da-43f1-e082-08d9ad053524
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2021 15:40:12.6302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pwJz9kVakw4obFBdjgmTQYhGGg+xgtRfRbhF1VQuWlEh1LYzqeaFCG9E2OB71kdPF09aW+cVSjWDMX2NB3gS/ez3so96mbnuE47RJ/axTkU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4596
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10174 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111210096
X-Proofpoint-GUID: rHSOTRrc_bpreyBLGkNFvj0EpiHYij_r
X-Proofpoint-ORIG-GUID: rHSOTRrc_bpreyBLGkNFvj0EpiHYij_r
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Sent: Sunday, November 21, 2021 9:02 PM
> To: Santosh Shilimkar <santosh.shilimkar@oracle.com>;
> davem@davemloft.net; kuba@kernel.org
> Cc: netdev@vger.kernel.org; linux-rdma@vger.kernel.org; rds-
> devel@oss.oracle.com; linux-kernel@vger.kernel.org; kernel-
> janitors@vger.kernel.org; Christophe JAILLET
> <christophe.jaillet@wanadoo.fr>
> Subject: [PATCH] rds: Fix a typo in a comment
>=20
> s/cold/could/
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  net/rds/send.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/rds/send.c b/net/rds/send.c index
> 53444397de66..0c5504068e3c 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c
> @@ -272,7 +272,7 @@ int rds_send_xmit(struct rds_conn_path *cp)
>=20
>  			/* Unfortunately, the way Infiniband deals with
>  			 * RDMA to a bad MR key is by moving the entire
> -			 * queue pair to error state. We cold possibly
> +			 * queue pair to error state. We could possibly
>  			 * recover from that, but right now we drop the
>  			 * connection.
>  			 * Therefore, we never retransmit messages with
> RDMA ops.
> --
Acked-By: Devesh Sharma <devesh.s.sharma@oracle.com>
> 2.30.2

