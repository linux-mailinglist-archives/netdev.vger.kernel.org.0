Return-Path: <netdev+bounces-1195-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF0C16FC913
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 16:33:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAE611C20C09
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 14:33:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE90A17FE5;
	Tue,  9 May 2023 14:33:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A965F17FE3
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 14:33:05 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824991BD9
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 07:33:01 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 349EHdEo008804;
	Tue, 9 May 2023 14:32:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=pr0dZX2CDyRIHAsjl07l1U978NwW05OcObu3mrrSDjI=;
 b=C4O14YMTS111c7BW+fVcYiqTRK9IworjWg6+nSewmCVPB7zctO+enV9ihlpiNkvY9ZYg
 OUiLsHPtWbE+n2R/8q8W1jbg+vov/pt0drpUiLXZF3eq67/bmvSNww5t6aeJOfLXNJx7
 gJD2r0eFjxq+JU0qVTjZgzwQeegM0xQ0mwHbasucmD+Sw+BgN75MOQapeIZcuxeig6El
 iL577tGQZHGsWQpzAqUR/nZr7YTKP8JhQcNkI61349l2phtrCxU1xr+xTV3i3wggewfu
 S3DcXmpnewaokQf56aWN16b1Sy5UqatKRwpjIzmyRhuZQVK/BemN+S/wbY1Rx9TiDCub 3Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qf7771ypu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 May 2023 14:32:47 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 349De6OP026830;
	Tue, 9 May 2023 14:32:46 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qf81efs83-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 May 2023 14:32:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NoMD6dAcWwrLN8uMs2ZDX/Ck36fKvykxQzdWbBRl2mBLE/Zw2DdxQobRpRfOC63qlUIRHbaUp5Z0uHLNwHCGVi4A4qQma8GzZqEdXe7hTrCnDGbQ24MqXbUxjSrBnKrPxXzAC/2sLLuyPToNaX1YIa7KqvC8ALONrhT4SaPt56fZWCxKAFSxIt+AF+7YTHHA1j2Cg7PTXYw3kSrGENBrfsCKBUC0ErwA/CfaxscGA28bAqAzNtgbAdurqW2mjmqnG5PmjFflJ+a5NsBgu6MEDKmWLlN6Lp44aLNNAPKF280b8KbR6yIiBLs7L5VHznSqUEZxlZuw++TvDZwtbJI5Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pr0dZX2CDyRIHAsjl07l1U978NwW05OcObu3mrrSDjI=;
 b=npJ69Kcl4f0NNVrGjdb02oP6yJwc/FpbB1V4a3VPbJJFaMPxFYvJw/WUeJG4d75qkBwcw58J/7BbMeaWsosHqezfpyrtNxz6J7GAxUxIT69HsQfp6c0H1iD1QLEL8SiFA3Emz7dLPCBIlDcHeWR9ZNL4AX4zkreFhEW3xjIFin71C/FYJ5WAn/1g817x+PbB2Rfk/YDLtDneSI6zbYSQbf60D3Eo1llYkl/ZbeZ9msUHU9fBH1XvSQDpEtlTJ2lhlzJtlgzrZMfNJ8G+NoapN5y6LGgL6f/SfH4+s5a2GTxeYQAJe4BAkeAnEfpYgJmpAKKCqmHGMaGlfVL9juOenQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pr0dZX2CDyRIHAsjl07l1U978NwW05OcObu3mrrSDjI=;
 b=YoOb0Az+0nDRCt4xScroLceHi8iMXQ/kL5gztQt4XIZrX+wc+wDBr2RluEnpaGV18/KaFRLvg+oPDSI0psqqUhHKGmdGLHSKsdK2B4mzxsVAWQQBehUpjvNWOy1NM+SCuJjByXaKiQwZhYKEByXHY8jrAA/3USr0w3+7xjRybcE=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by IA0PR10MB6841.namprd10.prod.outlook.com (2603:10b6:208:437::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 14:32:39 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 14:32:39 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Paolo Abeni <pabeni@redhat.com>
CC: Leon Romanovsky <leon@kernel.org>, Chuck Lever <cel@kernel.org>,
        kernel-tls-handshake <kernel-tls-handshake@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>
Subject: Re: [PATCH v2 2/6] net/handshake: Fix handshake_dup() ref counting
Thread-Topic: [PATCH v2 2/6] net/handshake: Fix handshake_dup() ref counting
Thread-Index: AQHZf7QsoSIApHx1cEC5oKYOzkZtjK9Oe64AgAMN9ICAAHPmAIAABk2AgAAC6wA=
Date: Tue, 9 May 2023 14:32:39 +0000
Message-ID: <D02AD35E-E28E-4998-B1C5-9019F258F738@oracle.com>
References: 
 <168333373851.7813.11884763481187785511.stgit@oracle-102.nfsv4bat.org>
 <168333395123.7813.7077088598355438510.stgit@oracle-102.nfsv4bat.org>
 <20230507082556.GG525452@unreal>
 <80ebc863cd77158a964698f7a887b15dc88e4631.camel@redhat.com>
 <CD7ADFAB-137C-407C-93D4-4AF314FE0E52@oracle.com>
 <2e1fb95f613b6991b173d7947334927b22e49242.camel@redhat.com>
In-Reply-To: <2e1fb95f613b6991b173d7947334927b22e49242.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|IA0PR10MB6841:EE_
x-ms-office365-filtering-correlation-id: 6b22b55f-3cdb-44e2-544d-08db509a3d91
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 iQDDGm6QXDcICYdPXDWgQq4QiSeF1buffvhcPgDSIg73YNHfRk3tB93hx//pDmQqfMbfd8kbxF8GJoe6floEjsJPatCVdaGuHBbaBjFyON8fVSgdzh/vQeE6SjhZesq3rfXK5BC4G2+TS5+lDX51b9Oc2jexhOUQ/5PKWDmWvQtwWNXCtEh6ZIOq6a5C9IwxyGBD5aX/4iw0p/WmC9o2mgIEHl/FT0traFOeSdAEPAeyXJ1STn6OLhWtfXqZ6y/My+8gWEyvIFN2K1eKIN3u+KcD261nuV7P2IB7GscuI3LRHwrmoRKEUSXn/mjXbmlO1i5senATWSpPpdKjdIFND6CkTEf49q42+f9+lXq+z+RCRSnVWmku2hICmksmN6iB+wNmk4MIkipFOjWgKtHVafhLHXtOCA7et225WHUAxn5ObOpZjw1S+MuetFrHAZFbPIyT1T2fPbnLs1F1rzUQrtDwPRZMN0dFtr2h6/i9TNPP7QnbApbIsQu8mRUK9/h31iqe6DfgdAQSvvBd+Xk64LDL4mv1jORvZQKiyvVVRO/QHv9+jp9Sfajc3Tkr2YE+LmRgIDJ+dWL2LQrIa0aWkr+VSTjYbIWycTjpjfsrYzbgNpv38Mq82FH13juVLuUqUz9wQi79obuZLdt2PgnOKA==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199021)(36756003)(33656002)(83380400001)(91956017)(2616005)(71200400001)(478600001)(6486002)(54906003)(26005)(186003)(53546011)(6506007)(6512007)(6916009)(2906002)(66476007)(38100700002)(66446008)(76116006)(66556008)(66946007)(122000001)(64756008)(41300700001)(4326008)(8936002)(86362001)(38070700005)(316002)(5660300002)(8676002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?XHy84TWQL/taLnVxkAdBofg/fjQiRbE1DdZ6PEvyXu8t2QsHH7hsKjA4KoTU?=
 =?us-ascii?Q?OrP9nuhYRoERoJdqPO9AtzSSPqrt7QM5SWH2jIb7pVOM6Iy9/Id1ORiY/FGJ?=
 =?us-ascii?Q?ZYrCUXlOsJc5rdLEdpr59pbvSIhnQscbA6XK/Gczh1YwAokpb7Erz2pBJU6b?=
 =?us-ascii?Q?EM98hIN2zq1bUvqsgboMTqrWx0ZPyqyIUpUsmGJTM3pKX1tkswc3xsEiMo1I?=
 =?us-ascii?Q?dXg7OdnH9ctYsbN3Z5l9xumjFCLK9UMMOW6fzc8BHz46z/hl27tJ8L2jlMk6?=
 =?us-ascii?Q?UQEs7v8xGKE6Qz+6Nw2VrQhJqxq9iUusuQ6Nobtwg4WnYHwZDIYttkLO2dJU?=
 =?us-ascii?Q?BbsHZv1hMFkzYbg8S3SHPPEOC+UYxRFtjslpuU90wq+Df9558a9zgAzVDmDJ?=
 =?us-ascii?Q?nIu/BiPAXYS/1To7uhhaG/Intr1kqHE1nEcNA5qQPA9Ut4SN9RApcmfgKoC1?=
 =?us-ascii?Q?m6mD3ocQ9l7XVgE7yXajfWP127lbN95RUI0g9nAOEYYBazfPSahinaSVn8wL?=
 =?us-ascii?Q?IlFNeNAfpHpy28d7yUC4WlSC309sxNGGjgG3Vb39fq4sHYUqeAeEzdIoeFlu?=
 =?us-ascii?Q?/U4zI3i1Y0WUD5mTeNMISH2qt04Ho1CCTDmmgxFsBzkAEE/yv2KqJi814mcs?=
 =?us-ascii?Q?gf4iOnkYfQnJYMYhbC6DdLM7s6GfgQpuG7KibfAUNstKDzu9tNqbibWdvM0N?=
 =?us-ascii?Q?9qBrLeoSHbiKJo/uLjDaZLSoogVweuTqL0VOdfyQ9qijz5nmExx3UpNDDgeR?=
 =?us-ascii?Q?vKqGwXVysvHqwDrMmV8uZ4q5bMHYysUEE6Qxr8fKT07PaT83LJ/FofX8puIJ?=
 =?us-ascii?Q?HMMF6fpWshRtY10SFtImhcMXSDczGaLTf2LmcHTFET/52UBZHMSEL+WlpNSG?=
 =?us-ascii?Q?ipunt/ILZ9A77I5GWgdkyzSfNvexoijPvFsQ4x36Y00rNvdcu73s7xbSVktM?=
 =?us-ascii?Q?ekPX9xfR5Alr6Ngj02nXcnei2x5bQ/hYr+3P/MMDhdUZwxvMRaQ3ux6FxdGh?=
 =?us-ascii?Q?aJjSOSBg0xddWKyhpIYh5mtdfrXLDfGHb6vJxzhphH9P4PFKt8FXKH3LgO6E?=
 =?us-ascii?Q?KUcBV1tEVic4UTc+BbhlEI3Je5EYXtBU2u94Z8z4qyT68QOXnq+R7ye0ZMK8?=
 =?us-ascii?Q?nX3NiZGDmLdHMqhP2hdD7EvyrL7SVAKDUClbo42XSXY4vlHP4GOf6c6CrO17?=
 =?us-ascii?Q?6Mf50UgGRxoPG4AfsKsAhVw61aLXHnyDkibau2y5K2LkIRyXmMJMn4jPs0u5?=
 =?us-ascii?Q?nJOW0a3zhjDOIFmtzndKDGmDglxDFo5N7wHOq5zHR4Z9QAnc/tJdA8ecn/Ob?=
 =?us-ascii?Q?imoDu/GtMP46gHZ7TdhKsAFRbW1IYGmlF00sNQg/pMufNVc/bKy+q8CHFXb+?=
 =?us-ascii?Q?4bu87BKGTGq+I3IwyNZTscsx7F4MYxXUziCdO5rkaVf8VCzdrar+5m4X67hR?=
 =?us-ascii?Q?Oj5nzmiPCB7j69vRYEAVt9KE0gOTR/ebgwf4n452cCfnN6v5hwhMfI3WkM7g?=
 =?us-ascii?Q?DSHxc9NzO225vYkYXfzmNy1t9Z6VCP/3a9ChEvFzesC2uOGlizS2HkDDveVN?=
 =?us-ascii?Q?tVkeh2dMuWl/8TjtsL0Sz1jnCmVkizskJz7REvec+XNu0ourV/zNO8pmRNLx?=
 =?us-ascii?Q?Tw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1D9A7B4B462F0E40B22239BAC31F9CEA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	P6oHs4p15yQUK3PQvAX5qDsSdfv7PpyVYSDKgJZfZU+LpUsb6uTXpAeagYI1zD71avi1WYw7NLZ4/P3J6JeuHf9n20H9gHHZxEzAqilpmgSlOqdJw3MumWbY+sZJwhm7/IrDX0gnDAMzSaypAke2ETCiarcroej6RXO4wS8nLok305w4occShxRy0j4b722QTTXckAjh0Dt56U6InWFV+4QjJuzZhw6194Emyxm184TZfzeaiThE8jMsGjEW6mgGXvWxKCIfleY0Fuk0RJUm2p0Ud4DmryycY89xY4eB8ahtU7dIAf/jfQ/rziJcSfGLGhmeTPa4PO+6IVa9xPVc/f3UImlomEpwVE2xeQtd30aPLbf8j4wxdU3uhWsW0DWodG+okXVuykPghIqJ4j6n8GzMLsNFdNl4uwnB8M6BEXQE5MwXvG50C33/Hh4L76T4w8P3t05QW6p5w82TDzeY5YItsnISHYFSnYawZFAsQ+w6hVgk5/2BGNNuYUX4BOCNFEneHbV+y6MlhnC+FPYN+/hvZ1EP0Vaf+ED4ckrE2C0dAT2XXqIao2fMuBwgJUX1OI/xuAlKvxFNpa4pdihXBs+xsC/wNA6tN1Y4bdaQSqgGk5EUgrRysPMVBxJnRt+4ZgQfkRhGHp0qKliBgGoYtDphm5+TaxebWi1gU3+r7EODbRnF0LtJQ8c6NoHt3ZuE6Og5f6qXuXqaD73EPwWLH3A7YudXrv3OsIlVigQJ0DmUTKsBWNtznSqOHA369cX0KEvMWV21AECl/WSopfJMkn6Dwe5MieoTOItptFXKEvBvL/sjVxuJIvk+DowTrl+OBDqlknwr6U9iPta47wgwtIa2DqkrsqHs6COlLw9TYSfME0SRrA1m1/L/TaWTEBkhwQZOrZ46juPXpIVIg3WK8g==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b22b55f-3cdb-44e2-544d-08db509a3d91
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2023 14:32:39.0652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7Hj3XApax4t54wONI5pPRsqciKOtIMaKQM56rH/WprtxKW8M6CbDxnh9OTkqIGCbuDdpSkA1TMdT0j2QV+0hGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6841
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-09_08,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305090119
X-Proofpoint-GUID: GGJuA_fA-joPtIMz_Rf38h77E-sBurVC
X-Proofpoint-ORIG-GUID: GGJuA_fA-joPtIMz_Rf38h77E-sBurVC
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 9, 2023, at 7:22 AM, Paolo Abeni <pabeni@redhat.com> wrote:
>=20
> On Tue, 2023-05-09 at 13:59 +0000, Chuck Lever III wrote:
>>=20
>>> On May 9, 2023, at 12:04 AM, Paolo Abeni <pabeni@redhat.com> wrote:
>>>=20
>>> On Sun, 2023-05-07 at 11:25 +0300, Leon Romanovsky wrote:
>>>> On Fri, May 05, 2023 at 08:46:01PM -0400, Chuck Lever wrote:
>>>>> From: Chuck Lever <chuck.lever@oracle.com>
>>>>>=20
>>>>> If get_unused_fd_flags() fails, we ended up calling fput(sock->file)
>>>>> twice.
>>>>>=20
>>>>> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
>>>>> Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for han=
dling handshake requests")
>>>>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>>>>> ---
>>>>> net/handshake/netlink.c |    4 +---
>>>>> 1 file changed, 1 insertion(+), 3 deletions(-)
>>>>>=20
>>>>> diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
>>>>> index 7ec8a76c3c8a..032d96152e2f 100644
>>>>> --- a/net/handshake/netlink.c
>>>>> +++ b/net/handshake/netlink.c
>>>>> @@ -101,10 +101,8 @@ static int handshake_dup(struct socket *sock)
>>>>>=20
>>>>> file =3D get_file(sock->file);
>>>>> newfd =3D get_unused_fd_flags(O_CLOEXEC);
>>>>> - if (newfd < 0) {
>>>>> - fput(file);
>>>>> + if (newfd < 0)
>>>>> return newfd;
>>>>=20
>>>> IMHO, the better way to fix it is to change handshake_nl_accept_doit()
>>>> do not call to fput(sock->file) in error case. It is not right thing
>>>> to have a call to handshake_dup() and rely on elevated get_file()
>>>> for failure too as it will be problematic for future extension of
>>>> handshake_dup().
>>>=20
>>> I agree with the above: I think a failing helper should leave the
>>> larger scope status unmodified. In this case a failing handshake_dup()
>>> should not touch file refcount, and handshake_nl_accept_doit() should
>>> be modified accordingly, something alike:
>>>=20
>>> ---
>>> diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
>>> index e865fcf68433..8897a17189ad 100644
>>> --- a/net/handshake/netlink.c
>>> +++ b/net/handshake/netlink.c
>>> @@ -138,14 +138,15 @@ int handshake_nl_accept_doit(struct sk_buff *skb,=
 struct genl_info *info)
>>> }
>>> err =3D req->hr_proto->hp_accept(req, info, fd);
>>> if (err)
>>> - goto out_complete;
>>> + goto out_put;
>>>=20
>>> trace_handshake_cmd_accept(net, req, req->hr_sk, fd);
>>> return 0;
>>>=20
>>> +out_put:
>>> + fput(sock->file);
>>> out_complete:
>>> handshake_complete(req, -EIO, NULL);
>>> - fput(sock->file);
>>> out_status:
>>> trace_handshake_cmd_accept_err(net, req, NULL, err);
>>> return err;
>>=20
>> I'm happy to accommodate these changes, but it's not clear to me
>> whether you want this hunk applied /in addition to/ my fix or
>> /instead of/.
>=20
> It's above (completely untested!) chunk is intended to be a replace for
> patch 2/6
>=20
>>> ---
>>>=20
>>> Somewhat related: handshake_nl_done_doit() releases the file refcount
>>> even if the req lookup fails.
>>=20
>> That's because sockfd_lookup() increments the file ref count.
>=20
> Ooops, I missed that.
>=20
> Then in the successful path handshake_nl_done_doit() should call
> fput() twice ?!? 1 for the reference acquired by sockfd_lookup() and 1
> for the reference owned by  'req' ?!? Otherwise a ref will be leaked.
>=20
>>> If that is caused by a concurrent
>>> req_cancel - not sure if possible at all, possibly syzkaller could
>>> guess if instructed about the API - such refcount will underflow, as it
>>> is rightfully decremented by req_cancel, too.
>>=20
>> More likely, req_cancel might take the file ref count to zero
>> before sockfd_lookup can increment it, resulting in a UAF?
>>=20
>> Let me think about this.
>=20
> I now think this race is not possible, but I now fear the refcount leak
> mentioned above.

Not sure why I haven't seen evidence of a leak here. I'll have a closer loo=
k.


--
Chuck Lever



