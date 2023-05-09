Return-Path: <netdev+bounces-1187-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB2C26FC859
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:59:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 055271C20BB0
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:59:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB9BC1950C;
	Tue,  9 May 2023 13:59:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B449F17ACF
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 13:59:56 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFCC83
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 06:59:54 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34972uaA013206;
	Tue, 9 May 2023 13:59:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=2ZML4e7U5L1PADBL8T1ishvvApMCkMqmL9zMw52NfY4=;
 b=LKdZR4eHpjPjwYkSHClqjridyrnP+F+L8v3d10C2W/K0ukVjrmP7mPrAQnpc5CQVUOJ/
 x8tF9e/+y7XqbhGOPkeRvu6+phi12VnJ/l57JJNhbB/MT6/Chh/WgL8ZTt4zYgbiWSZi
 cUDrorwpiVigYaDKVQ1nCBZLAyJD7lscHLEwgbi8irOn4Z+pYOpvBup817TwPJ3sVmXt
 Zy6h6AAdfsH/RuMKJsyiiDeIVPqlpYrNhpZ4ZAdWXy9wvFOLZbx0iwlIk7xPE7r3zW2+
 LvGxRF9X52ehSZUDkJEJXswQnIBW7SRR4es8VYEgFLVaxK1hXD6H08KqWs6xCs0JBSOH ig== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qf77g1wxm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 May 2023 13:59:44 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 349Cu0UR015886;
	Tue, 9 May 2023 13:59:42 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qf77g143k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 May 2023 13:59:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bWtsZLqItrXu75h6whcyreAfVQOh2PWcIj9KnvC3zrN/64ANkqDbPPn0MKaBAgomChfV8G53GBDuozrcVqfpkbzITQiVzfVhfuapOWWtLlDFBr9uE+GFS4GCluZ8c6yGuh9AAmTxOxTR1uQuOLa/PAmgDflW/69Hasa/daN6H/hDitoqxKHLzdwoeoAjybUgPCz8rzIeHN+927mTtBclQGlSoNucN9Xc1G9ofECmZoy+bNvuI1hlftHV4E9TeVLx6wki70vhnSmfR2ZxPqFYRlyOUQphBnlTyDMqj5w6kL5oz2U+TiD0gkx9JHSDF1gtdlvr37qGcNmwp0UouOxLdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ZML4e7U5L1PADBL8T1ishvvApMCkMqmL9zMw52NfY4=;
 b=a7ec9rzJUbA9M3Y+M0CMQfa1v2cMVs+V+P0JxKG/kvapwWOqjL6BLHa6HGan8ZvN/EisFAcLHQqpfYSqXWt1voQkiye47EN/dEcIT9CeWliJIW4qsdD/6wYy5JFYr/1ZCdaXbg0Qhqtp1f4Vol5yufIC3G2uvWeJ/q+5aYbj1nptvDdiQqoPqyHPcMn2eItnoLCcqcFIlT84HydWh1bi5y6Fz5iarNe4jrnkXiMM5LDFTX2wRc2OK9e9hRIpBrvwtTWzHjDchhbqyoDFaOdVP7hnPri3FyjX0Nsha86IG1MS2wErqo2xoY10eilymLwkcyzWhl/2jAhF5CkzVsUYLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ZML4e7U5L1PADBL8T1ishvvApMCkMqmL9zMw52NfY4=;
 b=ItblA883zdABjteXZyKM/hTDkpVI5UlePSK3mAGjY3l/E7M2y7QsW6o06yD1DT5QnTiYptnEoqVF+jEE4mVfva9KJv+VvtQUu+KArpj2zPUOiQkP/cWcejDC8C5PBFes8EIy0+VLTJubv/zJwZGWFCxaGHDohAcMAoaa3krd37w=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DS7PR10MB4829.namprd10.prod.outlook.com (2603:10b6:5:38c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Tue, 9 May
 2023 13:59:39 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 13:59:39 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Paolo Abeni <pabeni@redhat.com>
CC: Leon Romanovsky <leon@kernel.org>, Chuck Lever <cel@kernel.org>,
        kernel-tls-handshake <kernel-tls-handshake@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>
Subject: Re: [PATCH v2 2/6] net/handshake: Fix handshake_dup() ref counting
Thread-Topic: [PATCH v2 2/6] net/handshake: Fix handshake_dup() ref counting
Thread-Index: AQHZf7QsoSIApHx1cEC5oKYOzkZtjK9Oe64AgAMN9ICAAHPmAA==
Date: Tue, 9 May 2023 13:59:39 +0000
Message-ID: <CD7ADFAB-137C-407C-93D4-4AF314FE0E52@oracle.com>
References: 
 <168333373851.7813.11884763481187785511.stgit@oracle-102.nfsv4bat.org>
 <168333395123.7813.7077088598355438510.stgit@oracle-102.nfsv4bat.org>
 <20230507082556.GG525452@unreal>
 <80ebc863cd77158a964698f7a887b15dc88e4631.camel@redhat.com>
In-Reply-To: <80ebc863cd77158a964698f7a887b15dc88e4631.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|DS7PR10MB4829:EE_
x-ms-office365-filtering-correlation-id: fed3d0b3-db5f-487f-b9e0-08db5095a182
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 XlJeMVikwcSdrHudQeG1GDQ/TJrAhLW8mP7U2W/OJ3byoBA8z6SAYMWEchAhtZvuO5dmICTdagy9w1eu2239/zvwldVE5ngfHc2Zyin22xWbeWkUuuQ+x9fnPLo4Nb75ryvKbYWfNOVwLgKnZMMBTY7ZJHeEoZnqN1LBfRszPX5sjurlZct1xkFVrUh+jXxmrtwABbUoS//7uNZvOMSgqEXSRnantO7krUVnIU7B1Fb62ZK+hDB7tuRdtRDN6EFXMwr9Z+KVWKkzM0GfLnO90BgkaSNiqGpz1N1PJGirAnvIKq7kEI923KSGIcWMnz0P5QTmEKfODqdJ9DUvDitoJTxuP55QnB3Pz4nk2Ax7Vv3iEFpTqLKRg2MFIQKSsGAfvvIYS+Ab+vriOPDLE00tzdGvJFg51r6KNHWxsnIlwdt6/hSg3uQCvWeF2rk9X7nOtG3H90iWct+rfWzr+yqs0eyhYjH1dcd+Jc0/5hRl+SsVLoFyJMEMmAVpi0rMYoLkL5/8trLhFeVn8/LPIkyqkf8TvYPjrlWHAeCZE07A2o1F/0aEdBBf7VpSPFvdizllm3TQtEpHdVGQF7ug6f8vu8ZCXXAOksLmYPDTcGQPOvYGjEav11CDL29qtlfz5OfhzJF23zXKjKrddcTpvA78uw==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199021)(83380400001)(54906003)(8676002)(8936002)(316002)(38070700005)(2906002)(66946007)(76116006)(4326008)(6486002)(66446008)(2616005)(6916009)(64756008)(71200400001)(5660300002)(66556008)(66476007)(478600001)(86362001)(53546011)(33656002)(186003)(122000001)(6506007)(6512007)(41300700001)(38100700002)(26005)(36756003)(91956017)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?Yf0mShnhs0wne+EHDRdfdhOKGJxhoptPgKppqG9cJViP94hXgjnN+kGfX5I9?=
 =?us-ascii?Q?TvJBLQMHD9HvLiRfX23a/p1/9I7HCr6IFw3bxZkZwFzvv4wsFWq4pjI0EHnw?=
 =?us-ascii?Q?Fqul/Ac3WZYDui/pQ4ND83rt12wVZtcQZ+UweFbgv4eQK8tU9bfka0dvHlT5?=
 =?us-ascii?Q?ecgOwMQnjiR99Xiey8+Otq5YtWt+GzKhza+U65qdun94SyfL97BvTLnjNqWO?=
 =?us-ascii?Q?z3HEYuW++YxAZV7ByY9x+EOy+YBPQVLJNB5KHmy55JYX8c215NsI0oYidnvH?=
 =?us-ascii?Q?8SgW2e/xSOY2Zs60gAwnerSTLEz7/X+S2G8IpFu535B9DxAuy79RO8+TnTry?=
 =?us-ascii?Q?GBwLZHttoizH4WRHyMTczTUMGd/Q8OZulYXg1Ni+y0fySdOQg0jMjYZnb5eE?=
 =?us-ascii?Q?RkI7cocUGbo5aTGl1etuqPA4p9w5FeEqz6kDKhS+zrZ7wm9ePiemYmodtyfv?=
 =?us-ascii?Q?OuGvt6FhC2n9PWYaUOz7xIC4N4tOgcfcGPMKL0expTNKLJ7TrSj/tN5LRkqZ?=
 =?us-ascii?Q?XGoYn2gbsPIn/5U9AgNY70f/YdJH1sicNgbbMK3GCvLJGUBHdu9+tIEnoi2U?=
 =?us-ascii?Q?TjVQIF2iuuGG8cP6uOw1zoQLG3YQ1gpIYlSMqLU9F4cHyBKv8kQoMtAvmd+P?=
 =?us-ascii?Q?UX+rPNIXnfMjx9kbkv0nFbOO/OZTTKPmrajFasXbuEIEoWDUzvbzoUUz9FIf?=
 =?us-ascii?Q?QxHwtlApEgxjRuDBFZW1MrCDqkuZjM0Klu9SNLkszyVmOvmsCQ2pSoGY2X1F?=
 =?us-ascii?Q?u8Eyq6+w91iHDJsCKATEuzfjgylp4SP9ysX5u+cdDcq+d+qxSBK0cD9w4d/V?=
 =?us-ascii?Q?sPRcuSp1tNeutchy89N2W6Q/yUb37NS2GoMNtIVi6nzfNHnc6FtI42GViMOR?=
 =?us-ascii?Q?AFgJRXI9GTGLiERuRHMIUnoRmwjtzKEbDWrwLKhw1GjK0CWDNd+TLm2HibXZ?=
 =?us-ascii?Q?goR5jay54SuUWfkyuxEyRxErGL1RUcMbWH35wUEcVExtXiSqHRgM2aT4naeg?=
 =?us-ascii?Q?aorBYcACD8l+kjrezz3GY7KxvfeCR658i1oj9VipzoWeH1dmIP2kO8cU/71Z?=
 =?us-ascii?Q?n1jAVVHv0Tccl3VG/jxnl8Ob2Cy43j6mTIDlX6Ksv2QXg66r3MEVAmXV+QU1?=
 =?us-ascii?Q?BjtApWpb0mECWa+AaaXJ5vvQuCHfjtCnxPDEdF4Qj+l4Ab3B2/T5/DWkvEEn?=
 =?us-ascii?Q?8xXf01KKmI9f86Un5DhHstMMM0lpCfU+HSCFkIDixm7sUKe6FLHfCmpY7MnL?=
 =?us-ascii?Q?Cbd7gIu5M6ZIFZrk397lKSXcVbj6WtwpaZEF7PIDPHoX4SDCu0IQxTSoNMYB?=
 =?us-ascii?Q?zyBKQGA38Ehzq/TrPuMp2GSkdd+WfqGOQOwbzCVkaGk4BLbnedeNYFNWgygB?=
 =?us-ascii?Q?c0wY/u4z6kJEBgVY7YJl1fV45kfT+ECcddklkmQnoAII+huNv6L/BotbgyUL?=
 =?us-ascii?Q?wtTzZZixj2UNlyD0aRuo1V4rKUFVOmQEipDe5RmwpfZLpfypF2cviE1+Y7Ua?=
 =?us-ascii?Q?LI6PjD01DwjeUkCy80h1NpDHEsGO5ri48gstBOh60d7EHj3CfS/eumYwajoG?=
 =?us-ascii?Q?+wTXgYXbERz6Q5j4grbLPm25JhOWwQ0Dgfxlmqaeab3fMKGtDyBAMjHKQl7E?=
 =?us-ascii?Q?og=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7866C5F15793EA40B15C18894CE69BC8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	MuRSzGCglWfd0lAzcSwt1SvWQXtMpjKVN8uzjY09Mnqo6ifMA1K/cZLyQ3FTPY7+0HN4KsmoFJKH96ePAmyBNA8Jw74RtGWSCDLhjrjTtEhoH5DbT+/YdzPfjMLYAlOcDYTe7J3GVwZQXoGAzM7TDyug9iPvqjbZZYwCfbxwBakhgBt0hvwnORLCl8RpVeyeKJnnhTdgVkYYrzISOSS+lD+3KKMzBELa+PuKDGAdEk7/tivS5DcT26OWeHvrySDqjYIM73/ensqvsbWuY/p66UMulDNLB/s/1YzszfoSuPi9tlrhGVGjjJ7AhCltew3CVvCnz0SbK3K0iL+U27VlPWwDVtvCrset/K91fT8i1vhcDo5J0C3gKCPTE0SOsYSMOZAWgBRAUIb/4OCmB3/l0UPi+/TFarNGDqVwK6E6p64ReT17c8zMj0Nv+Jtx/1KUjod4QL2VT5BJM6uRY82CSUF+dPUoOgvtOcXWC1lXjzCpMbHjw8iIiDCDJkjE8h4WQxzX6YsoC1b1BMeCzPsCCRBy9KA0sZvr03RIXXyv2nih7byyxlP3fdxuWiFAPeokuQYbfrHvOBgOhaK+J/kIDaOz+ByM2Rf2kxdyJE1hJ0GqGJg2oNaZQaYkKpTRSs8BVIbdJ4+W6kOxOuZ032f4mk4DIYHjqC/DYGkSULAiMJXrz9T2a8ZaQTPlZgA+5hJ3kr4AAFqZApWLOMV9b/ES+kV8nQfHweXmAGfMyPN+F/CHpVbVV3omv6IlOeeMp2SuYQJ1YGPZs3SksUUyMke8NWsaGaQT9nRoRnrL+nF/INNP582ia8JePsfN0fm5KJPXTyLAIAOmgwNoi2rOxoK0EpdFuy0UwO/rk1Aoyy4ClrN0Sx0J/iFQpBrbDTm8/6SYeYoqGR0lNSxc+QR3gj5UbQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fed3d0b3-db5f-487f-b9e0-08db5095a182
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2023 13:59:39.2688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uGaXv5NXF4CYQfnp7pP70xocrCbW/Q2pK4RDYEo1kAiy4c7g41mgHXxfKk5QV+gc4YDBBxBpKQdbtprelSzh6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4829
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-09_08,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305090115
X-Proofpoint-GUID: 2M0owQrXbAWHlne7PYLkIK4Dny9NwiAU
X-Proofpoint-ORIG-GUID: 2M0owQrXbAWHlne7PYLkIK4Dny9NwiAU
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 9, 2023, at 12:04 AM, Paolo Abeni <pabeni@redhat.com> wrote:
>=20
> On Sun, 2023-05-07 at 11:25 +0300, Leon Romanovsky wrote:
>> On Fri, May 05, 2023 at 08:46:01PM -0400, Chuck Lever wrote:
>>> From: Chuck Lever <chuck.lever@oracle.com>
>>>=20
>>> If get_unused_fd_flags() fails, we ended up calling fput(sock->file)
>>> twice.
>>>=20
>>> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
>>> Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handl=
ing handshake requests")
>>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>>> ---
>>> net/handshake/netlink.c |    4 +---
>>> 1 file changed, 1 insertion(+), 3 deletions(-)
>>>=20
>>> diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
>>> index 7ec8a76c3c8a..032d96152e2f 100644
>>> --- a/net/handshake/netlink.c
>>> +++ b/net/handshake/netlink.c
>>> @@ -101,10 +101,8 @@ static int handshake_dup(struct socket *sock)
>>>=20
>>> file =3D get_file(sock->file);
>>> newfd =3D get_unused_fd_flags(O_CLOEXEC);
>>> - if (newfd < 0) {
>>> - fput(file);
>>> + if (newfd < 0)
>>> return newfd;
>>=20
>> IMHO, the better way to fix it is to change handshake_nl_accept_doit()
>> do not call to fput(sock->file) in error case. It is not right thing
>> to have a call to handshake_dup() and rely on elevated get_file()
>> for failure too as it will be problematic for future extension of
>> handshake_dup().
>=20
> I agree with the above: I think a failing helper should leave the
> larger scope status unmodified. In this case a failing handshake_dup()
> should not touch file refcount, and handshake_nl_accept_doit() should
> be modified accordingly, something alike:
>=20
> ---
> diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
> index e865fcf68433..8897a17189ad 100644
> --- a/net/handshake/netlink.c
> +++ b/net/handshake/netlink.c
> @@ -138,14 +138,15 @@ int handshake_nl_accept_doit(struct sk_buff *skb, s=
truct genl_info *info)
> }
> err =3D req->hr_proto->hp_accept(req, info, fd);
> if (err)
> - goto out_complete;
> + goto out_put;
>=20
> trace_handshake_cmd_accept(net, req, req->hr_sk, fd);
> return 0;
>=20
> +out_put:
> + fput(sock->file);
> out_complete:
> handshake_complete(req, -EIO, NULL);
> - fput(sock->file);
> out_status:
> trace_handshake_cmd_accept_err(net, req, NULL, err);
> return err;

I'm happy to accommodate these changes, but it's not clear to me
whether you want this hunk applied /in addition to/ my fix or
/instead of/.


> ---
>=20
> Somewhat related: handshake_nl_done_doit() releases the file refcount
> even if the req lookup fails.

That's because sockfd_lookup() increments the file ref count.


> If that is caused by a concurrent
> req_cancel - not sure if possible at all, possibly syzkaller could
> guess if instructed about the API - such refcount will underflow, as it
> is rightfully decremented by req_cancel, too.

More likely, req_cancel might take the file ref count to zero
before sockfd_lookup can increment it, resulting in a UAF?

Let me think about this.


> I think it should be safer adding a chunk like:
>=20
> ---
> diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
> index e865fcf68433..3e3e849f302a 100644
> --- a/net/handshake/netlink.c
> +++ b/net/handshake/netlink.c
> @@ -172,7 +173,6 @@ int handshake_nl_done_doit(struct sk_buff *skb, struc=
t genl_info *info)
> req =3D handshake_req_hash_lookup(sock->sk);
> if (!req) {
> err =3D -EBUSY;
> - fput(sock->file);
> goto out_status;
> }
> ---
>=20
> Possibly explicitly documenting the used ownership rules for the file
> refcount in the relevant functions could help with future maintenance.
>=20
> Finally it's not clear to me if we agreed to a target tree or not ;) I
> see no replies so my suggestion.

Since we expect other subsystems to use net/handshake besides
SunRPC, I agree to going with netdev, even for this series once
it is acceptable.


--
Chuck Lever



