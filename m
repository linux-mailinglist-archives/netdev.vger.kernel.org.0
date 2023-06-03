Return-Path: <netdev+bounces-7664-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E6E872104C
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 15:55:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D79EA281B12
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 13:55:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14AFEC8F6;
	Sat,  3 Jun 2023 13:55:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0149B1FD9
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 13:55:44 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037F59F;
	Sat,  3 Jun 2023 06:55:42 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 353DeV9A015649;
	Sat, 3 Jun 2023 13:55:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=/rPdSRPc6kBD1qIzYuEvranJENoRwvvcp/mcPX0t6Gw=;
 b=UZM2u7bNkyWVygGHwWaRRqGFoZGY7GV1HcUdChvPa/2b738Wp//tz7HQXD4f/o6aH6un
 YbK0XTlwlYHXs+N5mO8trl91x5OaDo//PqznYPXzqYGIUSzS/+o6pl5DbS1dweEIaoOQ
 3cU1V3ep6K43yOz2bAslAhBT+POuZLAGHYQZuJe1rCKc19kOZVudfsb0CFKEWtaPRc1R
 5y13g6twpOvzdfLCM6eTDgmGtFcHS7HpWv4sU6RM2415lIiallp6vBLCCmJ08J31FHn7
 Wl/lOq2Eo7Jj0tgBeD7U3xqYGU0kzYMG2LQ1v6qIq5TOZ4hGakMOqsech/N2zLBlGlAj fQ== 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2047.outbound.protection.outlook.com [104.47.51.47])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r06c5gdjd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 03 Jun 2023 13:55:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gW8w6hccGILmP0GoFy/K6enaF7+6SUwVPX4K/tsMJQpAJZyWvYw7LpN/0N/kIT63NvLA0Ps6yq7Vi68H4LDb+cHepsLoNdmp/hnazw/5wsI65PF2FPEoNGgbwjB2xwlvQsYLyrqsOcyDIWINSN3IaWDyfQivUo4cKhfq2lZbAo3MOCSlsw2Q+0fiT6kHQ+Nmy7OGvr2w8Fcbf/ApH1H/pSmfhDocIyofqMzljOiXZx5HajvQdopyHXAk1HU3n0c7Y4gkm1Hnt5tMvU4BtTo2ZnTJZzZxvv5/9jU84NMBPSlGW2LOJxToFLN93PRbcwLB33JOngEAfyYf6xw9TtShug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/rPdSRPc6kBD1qIzYuEvranJENoRwvvcp/mcPX0t6Gw=;
 b=oAaa4jBHwSRePkYEoRfXOGEzfZo4dVV2x5rMvxowE8akR3PK4UckmhqWp9RmneYLxE9cQWR9EEK0LjBR458agBXHXIDYeqIy9UkfE8y0zoC3YK6Q0g7kL1sfZDzjuuO93jKGG0DpHzUicL5jUOegLk1UVSl2WC0iWKdccUq19UvQk8aeFBCmUhLaaRqr3AlRIFK7LXhWokrxHXjfUr11KGio4oa2ieUXSOaxDgnYXR6q7fWz3zsfA1yvFCdj3vpwK6p8jbAgnVXyGjh9BNMfZd+CeYWXSLUPGpWBQw45mMxKJMGhHp1La95d3BL8qgQmptHC9ezsfg3rjWcLsdvGbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=zurich.ibm.com; dmarc=pass action=none
 header.from=zurich.ibm.com; dkim=pass header.d=zurich.ibm.com; arc=none
Received: from SA0PR15MB3919.namprd15.prod.outlook.com (2603:10b6:806:91::20)
 by PH7PR15MB5342.namprd15.prod.outlook.com (2603:10b6:510:1e1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Sat, 3 Jun
 2023 13:55:28 +0000
Received: from SA0PR15MB3919.namprd15.prod.outlook.com
 ([fe80::9643:3b56:2d46:eb26]) by SA0PR15MB3919.namprd15.prod.outlook.com
 ([fe80::9643:3b56:2d46:eb26%2]) with mapi id 15.20.6455.028; Sat, 3 Jun 2023
 13:55:28 +0000
From: Bernard Metzler <BMT@zurich.ibm.com>
To: Chuck Lever III <chuck.lever@oracle.com>
CC: Tom Talpey <tom@talpey.com>, Chuck Lever <cel@kernel.org>,
        Jason Gunthorpe
	<jgg@nvidia.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH RFC] RDMA/core: Handle ARPHRD_NONE devices
Thread-Topic: [PATCH RFC] RDMA/core: Handle ARPHRD_NONE devices
Thread-Index: AQHZlbMKPb3FT2y0jUiIGk1htVApnq95FC7ggAAF9QCAAACAUA==
Date: Sat, 3 Jun 2023 13:55:28 +0000
Message-ID: 
 <SA0PR15MB391986C07C4D41E107E79659994FA@SA0PR15MB3919.namprd15.prod.outlook.com>
References: 
 <168573386075.5660.5037682341906748826.stgit@oracle-102.nfsv4bat.org>
 <783511ce-8950-c52c-2351-eef8841c67da@talpey.com>
 <F0D9A24E-CFC9-4100-89E5-A5BDF24D3621@oracle.com>
 <SA0PR15MB3919D432A5401D3E459A83B6994FA@SA0PR15MB3919.namprd15.prod.outlook.com>
 <4D92D284-5031-4676-BFBE-A47B60255219@oracle.com>
In-Reply-To: <4D92D284-5031-4676-BFBE-A47B60255219@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA0PR15MB3919:EE_|PH7PR15MB5342:EE_
x-ms-office365-filtering-correlation-id: 3e12ba04-4214-4160-854d-08db643a3055
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 ZIEwWWmLiuvU+Bud5cAihFvawdZD+W1/wtJbpTy70YbmdFAnTsVU4XKA23GxSnO/M0gIquP0IEJ4+1tc6Lsi392IZXsLlLWNsB8TMWJADxiw9nOsOfSPOtRTBcU3Nj6UtcPvvisetuhBNL1UoMErcdj1omJxdxJX2OeCBCsXP1t2OBpnrrW/qqMUes/nD/9h5CtXMPxXV0nB5DbRB28wefNIhg48Pg2V2mm4RzZBgK+jHAUBh7rGVrTOVgEyubuVIbZfFXql+u+n89l1ngU8EzMVSqOz4BhU9c1Yva/7HV3HOV8BK12F8qlo1YQASHIAFPjUMKFo84DD4frIlXNDkBPgxs2WoUkUo00n5j+gnqS4igp5XdJIFNHaW9lyQYlA4nl879Qs2PPrTRBRoky4WDLQmI8GoJD5ftm6oDSu5/m86XLsBS/zbXyHidhxu8EnEizyN19k2Bv8N8goR7+h9cviwBeD/bTscMBPwtMUwCnkgb2mROWMGxtf3hhj6+g61O54FcqRAFw6B6ecdt/iu4/Fl5YM5SriedQ4Be2sozHf1/P0zR22EQmcHfNj/Cgmvub2AJyrb6W+LDRaZXhV8QMXAofHoOvL9GpSO46XfaDfqC8VbTIO5RP+RkoIOc5X
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR15MB3919.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(366004)(376002)(346002)(136003)(451199021)(83380400001)(2906002)(33656002)(38070700005)(86362001)(122000001)(38100700002)(55016003)(7696005)(316002)(41300700001)(5660300002)(52536014)(8676002)(8936002)(54906003)(478600001)(66446008)(66946007)(66476007)(64756008)(66556008)(71200400001)(76116006)(6916009)(4326008)(9686003)(6506007)(53546011)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?YjJFbVRrbG5iNTBuUThJUUo0MGZEVkRBREZOSlAwMWVZbFNyODBNUGwrWk05?=
 =?utf-8?B?STR6Ym1IWlNUMWlHcGlTTU5OUm9rNEhlN09oKzE0ems2a0QzRzBNMUJGK3pP?=
 =?utf-8?B?L1E1Wk5XMWROOU5GRklPVUk5NmZCWmV5bzZtbFRUZ1ZwQ1ExQUY3TzlZU1FZ?=
 =?utf-8?B?L2h4dzJLUUhOVzlEU2hNL0tTQnZKTGFWbnNENFpPU1p2NTIwLy9jaEh1QVJy?=
 =?utf-8?B?SDAwNnMrbVJYUGxKUGJnRkVQWDJBT1A5TWh3c0JvTlFGWXIyVUt1YUN1akYr?=
 =?utf-8?B?eUF3U05kWjY2d0ZzMVNRNjBGM095Y2poa1VoMktGbVROT1VTR0RqeVhLRW8z?=
 =?utf-8?B?NHI3QlM4S2QwQXZxWDJqMHRNVjRVemZPNmI4Y01WN0xtNG9LWEZGQy9TbEJO?=
 =?utf-8?B?NURFRDVvT3doNUhwd1Q1MWkxR2RRU296V0gvbUVUd1pOazZBV0hETGxwNGpn?=
 =?utf-8?B?S1dpbWM0RUI2TzNOSTk5Zk5hckdmNUNQMjRwb2RQN2ZRRnEwZUFFVldVTXZp?=
 =?utf-8?B?RFpFRzFDVms3L0lEd0V0QkdEMzI5eUlLbmpoR3RCeFU3ZW5OOTJBTnd0RWxr?=
 =?utf-8?B?LzVnNlZ1dkI3dnFKRlE2bm45dm9CSkU4WlJFYmtucVBzVVpFb1FMU3l2RWR0?=
 =?utf-8?B?NUZwci9BdlQrY1JhU0tDYXVPSll2aEdvYUl0Tm13SVNZRzdxcXRsd1VXMXlF?=
 =?utf-8?B?dXVDbmNxckU4dWlSTzUzdVlZVmZwMGtRb2ZTOVNWVWxMV09Bak84dzJ4QlpY?=
 =?utf-8?B?WkdVTnJpTXFTbjFOUTg2cGVzMm0rUTNmZEpHZXdoS0ZwK3BSMmtIRksraUUr?=
 =?utf-8?B?cWpXRnpoQWFSVWZDVjFXTW4zeXJrSWV2Wm5RMXhrTFdWb0greStvK0grUzVo?=
 =?utf-8?B?YjBuSlk5cXJPc2ZEb2x2eHM5ejQzaXU2NzVNaThBVnh5ZGNsbWcrdFA5cWRt?=
 =?utf-8?B?QktWZE9pRHA5WWdRSFozVnlhUVJQRHpmNEtiOGtpZGFzWVZyNE1XZmo4S3ds?=
 =?utf-8?B?WUVHUU1uZDlLZGx1YU0vakVIT3NXSXJOR2dzY2hQSmdJMVcwQWllbWJkbDdO?=
 =?utf-8?B?MEFMUndrUWhBVGYvUDdWWjR1NXora0V1dytVRzFyQi9vbnhNZmxsSnBGQUxu?=
 =?utf-8?B?MnRLdVhpWUVZZjdGSDh6WFRJejZWRmw5YloyN2NxVzIyY2pjR3lTeGRiV24w?=
 =?utf-8?B?MGxHd0ZkclF3TnZBeHZybVh4a1ZxbjVvcjk3RS9OVnk3bS9JWE5kbllwQi9B?=
 =?utf-8?B?cW1KV0R6bnR6QVViMkl0eTNjY1VYdVdVSFZodytKSGhmSHNFcjdwZ1Y0ekRy?=
 =?utf-8?B?SnJxRGxacVlQejhlZXpJdVZ6QkVrV2Y2N2pDS2JhRlJpR2dQbVB5TDRWSmdq?=
 =?utf-8?B?cCtodzZVd2g5ZituSm0zeWplYU9lbWU3ODc5YXA0MzNtQlF5UmI4TUxEVnF2?=
 =?utf-8?B?cFhaUzhHa3dJYWxrazlFZU5QQlJMZ0NENUdOOWpSWUgrazBGWDJOa3lZSSsr?=
 =?utf-8?B?ZlNFczRybFREd3pqUjN0NzRSTWlnWCtuQU5ScFUzLzduOEN0U2hoMHV0R1ZO?=
 =?utf-8?B?c2JwMmkvZlVZd0RTalVyeEdTM2NpbUQwc1NLWlN3UTNQUndsSndWaVorY2Na?=
 =?utf-8?B?UkRaQVI5Nk1Mb0U4Wjg3WExadGVsS0tnYlk4NXV5dlBjMTRsWXlYOU4yWHVj?=
 =?utf-8?B?Z1hSN3d6M2pxMlZUU29ucU1DQi80SUFQSXc1SUk3SDVEMzRSRUUvNTdGTUEw?=
 =?utf-8?B?MzNObUduc0lVdzBTamFINHdLNzQ4TWYvRFMveUk3aVExUE9CWHZSMUtJaUZu?=
 =?utf-8?B?b2VSQzgxTk5vek55QmVtTXlEeWJvcHhyMlU3RU5wV0VDTkVpR01lV0ZZVzN2?=
 =?utf-8?B?RnNXd3pQSklvY2FzN01nT1pvRjNyTXhMVkZubXpVMTBrL2VpV25CZTRSYWxQ?=
 =?utf-8?B?TGg3d0kwOXBHM05zY2d3VGNJaC9QRHBqZ004Wk9pVHpIdko4LzZBOFlQd05E?=
 =?utf-8?B?NHEzcllveXYyeUpsL2Z6T3hlQmoycFQwaWM5cit5bjdoM012R0RTdVd0MnVa?=
 =?utf-8?B?WkFIbjNYUVlpM05kMVpFK1Y5NmRhZVp2NGY4V0NPeTFqWW9tK01NMkhmL1cy?=
 =?utf-8?B?cVcxWlpDZlhXWlNpazlRemxwdEdxSjM2ektkZmhDWDh2V2pQbjlpN3ZNZzRs?=
 =?utf-8?Q?bJ4n0ijH96dJti9S3qBHPmjUqjEz0i+bKH/g1i06WZCI?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Zurich.ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR15MB3919.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e12ba04-4214-4160-854d-08db643a3055
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2023 13:55:28.4725
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zOSCd09yzq85wVY9DOBoKvRgGVUkOW7so9a0jjNTupknO17sAyuPGC668xFQFZS0SKebQT3GPfP3bhNqFoliCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB5342
X-Proofpoint-ORIG-GUID: FhNJnrfM3AH-VlyYRPNmOCZoRLAc_qXY
X-Proofpoint-GUID: FhNJnrfM3AH-VlyYRPNmOCZoRLAc_qXY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-03_08,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 clxscore=1015 spamscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2306030124
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ2h1Y2sgTGV2ZXIgSUlJ
IDxjaHVjay5sZXZlckBvcmFjbGUuY29tPg0KPiBTZW50OiBTYXR1cmRheSwgMyBKdW5lIDIwMjMg
MTU6NTMNCj4gVG86IEJlcm5hcmQgTWV0emxlciA8Qk1UQHp1cmljaC5pYm0uY29tPg0KPiBDYzog
VG9tIFRhbHBleSA8dG9tQHRhbHBleS5jb20+OyBDaHVjayBMZXZlciA8Y2VsQGtlcm5lbC5vcmc+
OyBKYXNvbg0KPiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPjsgbGludXgtcmRtYSA8bGludXgt
cmRtYUB2Z2VyLmtlcm5lbC5vcmc+Ow0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1Ympl
Y3Q6IFtFWFRFUk5BTF0gUmU6IFtQQVRDSCBSRkNdIFJETUEvY29yZTogSGFuZGxlIEFSUEhSRF9O
T05FIGRldmljZXMNCj4gDQo+IA0KPiANCj4gPiBPbiBKdW4gMywgMjAyMywgYXQgOTo1MSBBTSwg
QmVybmFyZCBNZXR6bGVyIDxCTVRAenVyaWNoLmlibS5jb20+IHdyb3RlOg0KPiA+DQo+ID4NCj4g
Pg0KPiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBDaHVjayBMZXZl
ciBJSUkgPGNodWNrLmxldmVyQG9yYWNsZS5jb20+DQo+ID4+IFNlbnQ6IFNhdHVyZGF5LCAzIEp1
bmUgMjAyMyAwMjozMw0KPiA+PiBUbzogVG9tIFRhbHBleSA8dG9tQHRhbHBleS5jb20+DQo+ID4+
IENjOiBDaHVjayBMZXZlciA8Y2VsQGtlcm5lbC5vcmc+OyBKYXNvbiBHdW50aG9ycGUgPGpnZ0Bu
dmlkaWEuY29tPjsNCj4gbGludXgtDQo+ID4+IHJkbWEgPGxpbnV4LXJkbWFAdmdlci5rZXJuZWwu
b3JnPjsgQmVybmFyZCBNZXR6bGVyIDxCTVRAenVyaWNoLmlibS5jb20+Ow0KPiA+PiBuZXRkZXZA
dmdlci5rZXJuZWwub3JnDQo+ID4+IFN1YmplY3Q6IFtFWFRFUk5BTF0gUmU6IFtQQVRDSCBSRkNd
IFJETUEvY29yZTogSGFuZGxlIEFSUEhSRF9OT05FDQo+IGRldmljZXMNCj4gPj4NCj4gPj4NCj4g
Pj4NCj4gPj4+IE9uIEp1biAyLCAyMDIzLCBhdCA2OjE4IFBNLCBUb20gVGFscGV5IDx0b21AdGFs
cGV5LmNvbT4gd3JvdGU6DQo+ID4+Pg0KPiA+Pj4gT24gNi8yLzIwMjMgMzoyNCBQTSwgQ2h1Y2sg
TGV2ZXIgd3JvdGU6DQo+ID4+Pj4gRnJvbTogQ2h1Y2sgTGV2ZXIgPGNodWNrLmxldmVyQG9yYWNs
ZS5jb20+DQo+ID4+Pj4gV2Ugd291bGQgbGlrZSB0byBlbmFibGUgdGhlIHVzZSBvZiBzaXcgb24g
dG9wIG9mIGEgVlBOIHRoYXQgaXMNCj4gPj4+PiBjb25zdHJ1Y3RlZCBhbmQgbWFuYWdlZCB2aWEg
YSB0dW4gZGV2aWNlLiBUaGF0IGhhc24ndCB3b3JrZWQgdXANCj4gPj4+PiB1bnRpbCBub3cgYmVj
YXVzZSBBUlBIUkRfTk9ORSBkZXZpY2VzIChzdWNoIGFzIHR1biBkZXZpY2VzKSBoYXZlDQo+ID4+
Pj4gbm8gR0lEIGZvciB0aGUgUkRNQS9jb3JlIHRvIGxvb2sgdXAuDQo+ID4+Pj4gQnV0IGl0IHR1
cm5zIG91dCB0aGF0IHRoZSBlZ3Jlc3MgZGV2aWNlIGhhcyBhbHJlYWR5IGJlZW4gcGlja2VkIGZv
cg0KPiA+Pj4+IHVzLiBhZGRyX2hhbmRsZXIoKSBqdXN0IGhhcyB0byBkbyB0aGUgcmlnaHQgdGhp
bmcgd2l0aCBpdC4NCj4gPj4+PiBTdWdnZXN0ZWQtYnk6IEphc29uIEd1bnRob3JwZSA8amdnQG52
aWRpYS5jb20+DQo+ID4+Pj4gU2lnbmVkLW9mZi1ieTogQ2h1Y2sgTGV2ZXIgPGNodWNrLmxldmVy
QG9yYWNsZS5jb20+DQo+ID4+Pj4gLS0tDQo+ID4+Pj4gZHJpdmVycy9pbmZpbmliYW5kL2NvcmUv
Y21hLmMgfCAgICA0ICsrKysNCj4gPj4+PiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCsp
DQo+ID4+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL2NtYS5jDQo+ID4+
IGIvZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvY21hLmMNCj4gPj4+PiBpbmRleCA1NmU1NjhmY2Qz
MmIuLjMzNTFkYzVhZmExNyAxMDA2NDQNCj4gPj4+PiAtLS0gYS9kcml2ZXJzL2luZmluaWJhbmQv
Y29yZS9jbWEuYw0KPiA+Pj4+ICsrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL2NtYS5jDQo+
ID4+Pj4gQEAgLTcwNCwxMSArNzA0LDE1IEBAIGNtYV92YWxpZGF0ZV9wb3J0KHN0cnVjdCBpYl9k
ZXZpY2UgKmRldmljZSwgdTMyDQo+ID4+IHBvcnQsDQo+ID4+Pj4gIG5kZXYgPSBkZXZfZ2V0X2J5
X2luZGV4KGRldl9hZGRyLT5uZXQsIGJvdW5kX2lmX2luZGV4KTsNCj4gPj4+PiAgaWYgKCFuZGV2
KQ0KPiA+Pj4+ICByZXR1cm4gRVJSX1BUUigtRU5PREVWKTsNCj4gPj4+PiArIH0gZWxzZSBpZiAo
ZGV2X3R5cGUgPT0gQVJQSFJEX05PTkUpIHsNCj4gPj4+PiArIHNnaWRfYXR0ciA9IHJkbWFfZ2V0
X2dpZF9hdHRyKGRldmljZSwgcG9ydCwgMCk7DQo+ID4+Pj4gKyBnb3RvIG91dDsNCj4gPj4+PiAg
fSBlbHNlIHsNCj4gPj4+PiAgZ2lkX3R5cGUgPSBJQl9HSURfVFlQRV9JQjsNCj4gPj4+PiAgfQ0K
PiA+Pj4+ICAgIHNnaWRfYXR0ciA9IHJkbWFfZmluZF9naWRfYnlfcG9ydChkZXZpY2UsIGdpZCwg
Z2lkX3R5cGUsIHBvcnQsDQo+ID4+IG5kZXYpOw0KPiA+Pj4+ICtvdXQ6DQo+ID4+Pj4gIGRldl9w
dXQobmRldik7DQo+ID4+Pj4gIHJldHVybiBzZ2lkX2F0dHI7DQo+ID4+Pj4gfQ0KPiA+Pj4NCj4g
Pj4+IEkgbGlrZSBpdCwgYnV0IGRvZXNuJ3QgdGhpcyB0ZXN0IGluIHNpd19tYWluLmMgYWxzbyBu
ZWVkIHRvIGNoYW5nZT8NCj4gPj4+DQo+ID4+PiBzdGF0aWMgc3RydWN0IHNpd19kZXZpY2UgKnNp
d19kZXZpY2VfY3JlYXRlKHN0cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYpDQo+ID4+PiB7DQo+ID4+
PiAuLi4NCj4gPj4+IC0tPiBpZiAobmV0ZGV2LT50eXBlICE9IEFSUEhSRF9MT09QQkFDSyAmJiBu
ZXRkZXYtPnR5cGUgIT0gQVJQSFJEX05PTkUpDQo+IHsNCj4gPj4+IGFkZHJjb25mX2FkZHJfZXVp
NDgoKHVuc2lnbmVkIGNoYXIgKikmYmFzZV9kZXYtPm5vZGVfZ3VpZCwNCj4gPj4+ICAgbmV0ZGV2
LT5kZXZfYWRkcik7DQo+ID4+PiB9IGVsc2Ugew0KPiA+Pj4gLyoNCj4gPj4+ICogVGhpcyBkZXZp
Y2UgZG9lcyBub3QgaGF2ZSBhIEhXIGFkZHJlc3MsDQo+ID4+PiAqIGJ1dCBjb25uZWN0aW9uIG1h
bmdhZ2VtZW50IGxpYiBleHBlY3RzIGdpZCAhPSAwDQo+ID4+PiAqLw0KPiA+Pj4gc2l6ZV90IGxl
biA9IG1pbl90KHNpemVfdCwgc3RybGVuKGJhc2VfZGV2LT5uYW1lKSwgNik7DQo+ID4+PiBjaGFy
IGFkZHJbNl0gPSB7IH07DQo+ID4+Pg0KPiA+Pj4gbWVtY3B5KGFkZHIsIGJhc2VfZGV2LT5uYW1l
LCBsZW4pOw0KPiA+Pj4gYWRkcmNvbmZfYWRkcl9ldWk0OCgodW5zaWduZWQgY2hhciAqKSZiYXNl
X2Rldi0+bm9kZV9ndWlkLA0KPiA+Pj4gICBhZGRyKTsNCj4gPj4+IH0NCj4gPj4NCj4gPj4gSSdt
IG5vdCBzdXJlIHRoYXQgY29kZSBkb2VzIGFueXRoaW5nLiBUaGUgYmFzZV9kZXYncyBuYW1lIGZp
ZWxkDQo+ID4+IGlzIGFjdHVhbGx5IG5vdCBpbml0aWFsaXplZCBhdCB0aGF0IHBvaW50LCBzbyBu
b3RoaW5nIGlzIGNvcGllZA0KPiA+PiBoZXJlLg0KPiA+Pg0KPiA+IE9oIGluIHRoYXQgY2FzZSBp
dOKAmXMgYW4gaXNzdWUgaGVyZS4NCj4gDQo+IEkgaGF2ZSBhIHBhdGNoIHRoYXQgZmFicmljYXRl
cyBhIHByb3BlciBHSUQgaGVyZSB0aGF0IEkgY2FuDQo+IHBvc3Qgc2VwYXJhdGVseS4NCj4gDQpT
b3VuZHMgZ29vZCENCj4gDQo+ID4+IElmIHlvdSdyZSBhc2tpbmcgd2hldGhlciBzaXcgbmVlZHMg
dG8gYnVpbGQgYSBub24temVybyBHSUQgdG8NCj4gPj4gbWFrZSB0aGUgcG9zdGVkIHBhdGNoIHdv
cmssIG1vcmUgdGVzdGluZyBpcyBuZWVkZWQ7IGJ1dCBJIGRvbid0DQo+ID4+IGJlbGlldmUgdGhl
IEdJRCBoYXMgYW55IHJlbGV2YW5jZSAtLSB0aGUgZWdyZXNzIGliX2RldmljZSBpcw0KPiA+PiBz
ZWxlY3RlZCBiYXNlZCBlbnRpcmVseSBvbiB0aGUgc291cmNlIElQIGFkZHJlc3MgaW4gdGhpcyBj
YXNlLg0KPiA+Pg0KPiA+DQo+ID4gVGhlIHdob2xlIEdJRCBiYXNlZCBhZGRyZXNzIHJlc29sdXRp
b24gSSB0aGluayBpcyBhbg0KPiA+IGFydGVmYWN0IG9mIElCL1JvQ0UgYWRkcmVzcyBoYW5kbGlu
Zy4gaVdhcnAgaXMgc3VwcG9zZWQgdG8NCj4gPiBydW4gb24gVENQIHN0cmVhbXMsIHdoaWNoIGVu
ZHBvaW50cyBhcmUgd2VsbCBkZWZpbmVkIGJ5IEwzDQo+ID4gYWRkcmVzc2VzLiBJUCByb3V0aW5n
IHNoYWxsIGRlZmluZSB0aGUgb3V0Z29pbmcgaW50ZXJmYWNlLi4uDQo+ID4gc2l3IHRyaWVzIHRv
IHBsYXkgd2VsbCBhbmQgaW52ZW50cyBHSURzIHRvIHNhdGlzZnkNCj4gPiB0aGUgUkRNQSBjb3Jl
IGNvbmNlcHRzLiBCdXQgYSBHSUQgaXMgbm90IHBhcnQgb2YgdGhlIGlXYXJwDQo+ID4gY29uY2Vw
dC4gSSBhbSBub3Qgc3VyZSBmb3IgJ3JlYWwnIEhXIGlXYXJwIGRldmljZXMsIGJ1dCB0bw0KPiA+
IG1lIGl0IGxvb2tzIGxpa2UgdGhlIGl3Y20gY29kZSBjb3VsZCBiZSBkb25lIG1vcmUNCj4gPiBp
bmRlcGVuZGVudGx5LCBpZiBubyBhcHBsaWNhdGlvbiBleHBlY3RzIHZhbGlkIEdJRHMuDQo+IA0K
PiANCj4gLS0NCj4gQ2h1Y2sgTGV2ZXINCj4gDQoNCg==

