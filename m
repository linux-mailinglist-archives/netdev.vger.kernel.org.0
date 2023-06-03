Return-Path: <netdev+bounces-7660-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45744721040
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 15:51:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBEFA281A29
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 13:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A95E3C8DA;
	Sat,  3 Jun 2023 13:51:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966DA1FD9
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 13:51:32 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01071A4;
	Sat,  3 Jun 2023 06:51:29 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 353Dl2Z9021560;
	Sat, 3 Jun 2023 13:51:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=aEI62PkhHHGyIH/w87SZEjpL6K7cOoN+h/NWLgwog4Y=;
 b=eaTIxVj+WS+ndKMqIVT1TuhM/ifmbhcMQ2qVPUmI+2jgpMzE3fQfFlzJR7GQUfHSDuOs
 /43HZ7YJ2kJOfrJMAuSH4q/imzVmVmpLWKb/ZVZkC9B69Xj6rrrHKxGymbxY1fnNKalD
 eCgJXv7OQeiiwfwFq21Vj6dbNYsK3ssiYwrSiWw0VnWfwlm2BDtmDKEp0oxH714lSnZw
 eJqZAShWLNFskKlapId5tHy1EoMBvsatEEWiNbqRdg2O5uKlufMhQzFhKztTTpo6CyyY
 ppvS501sGJqTtWY2Vftu/+rYbb7fEbfnUFXkjxXwUqT40i6lwzvsFntAQ/7IQu2djICe 5w== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r06q381a8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 03 Jun 2023 13:51:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eqkMhezuzzWyGMmdq62TQCI2QWydrQuvB2xpbyefyNMey6yhg91lQJatz27avyfbHzQn5/Qo/7lTS5m1e5B0Azcyx8kpvySjjAtehTCYiACacEW0SVz3C1H7a2fTq1YU5rDp71CTHeNzUCvufCaAMCMZs0LxVQ5N0IuCOyshzLrlscN9yl36QtZqylrU3bbMKOw5436zoTlyG0TXRvcLE+rgxOv9Kl63BdDdtRtCfWcOr2gmrlouxcWVV6iQmgmvKeWlFzFVIhqhQvHdhGlmyoqz0UZgzWnEwy8lJUdS7iXXKyrTiLrcHZYT2+j0msggi6X5mkM1784Zx1TMJDn2mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aEI62PkhHHGyIH/w87SZEjpL6K7cOoN+h/NWLgwog4Y=;
 b=mCPjK3SXOc34WwNPNlQukF+N1yiBmM4Xa4XQB6UurQxd4KPNzZLgHA75VzKvUuDbq2BH4evlP30vzopB3GTldJDAlBUpMfyHyRnfI/08H063BNEm7xQO7XnhNoPTpUu2lZyw1OX+DWqY4pwfsXkWrmVWa/cz1IGPo2BrOqeNxhM6s1Uhxv4QazvqAZVFPeNtJWBAWCpY4UafNHITUwNymv+m2Fla0FlNOMKy837udU/4bsJVlFoFwXMCJmpaMQ9yAC77winWojmDIb+SRwVTtwu6Uz/VONUkNtAP/zQ+nw2mGGTbWjrueH2Dgh/V7Z0d1OBAwQFTwqjl5GMzI1Q3cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=zurich.ibm.com; dmarc=pass action=none
 header.from=zurich.ibm.com; dkim=pass header.d=zurich.ibm.com; arc=none
Received: from SA0PR15MB3919.namprd15.prod.outlook.com (2603:10b6:806:91::20)
 by PH7PR15MB5342.namprd15.prod.outlook.com (2603:10b6:510:1e1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Sat, 3 Jun
 2023 13:51:11 +0000
Received: from SA0PR15MB3919.namprd15.prod.outlook.com
 ([fe80::9643:3b56:2d46:eb26]) by SA0PR15MB3919.namprd15.prod.outlook.com
 ([fe80::9643:3b56:2d46:eb26%2]) with mapi id 15.20.6455.028; Sat, 3 Jun 2023
 13:51:10 +0000
From: Bernard Metzler <BMT@zurich.ibm.com>
To: Chuck Lever III <chuck.lever@oracle.com>, Tom Talpey <tom@talpey.com>
CC: Chuck Lever <cel@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
        linux-rdma
	<linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: RE: [PATCH RFC] RDMA/core: Handle ARPHRD_NONE devices
Thread-Topic: [PATCH RFC] RDMA/core: Handle ARPHRD_NONE devices
Thread-Index: AQHZlbMKPb3FT2y0jUiIGk1htVApnq95FC7g
Date: Sat, 3 Jun 2023 13:51:10 +0000
Message-ID: 
 <SA0PR15MB3919D432A5401D3E459A83B6994FA@SA0PR15MB3919.namprd15.prod.outlook.com>
References: 
 <168573386075.5660.5037682341906748826.stgit@oracle-102.nfsv4bat.org>
 <783511ce-8950-c52c-2351-eef8841c67da@talpey.com>
 <F0D9A24E-CFC9-4100-89E5-A5BDF24D3621@oracle.com>
In-Reply-To: <F0D9A24E-CFC9-4100-89E5-A5BDF24D3621@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA0PR15MB3919:EE_|PH7PR15MB5342:EE_
x-ms-office365-filtering-correlation-id: 3e172082-bd25-486f-c620-08db64399699
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 zUHw2Ud16qFrwitmVHj8ZLyqefcevfhbRIW6dfTtcykw5xFeIdQ/av3+z4wx38VfNYmS7z0CCNdlXk+SpmeQsSmd7+ehlX0V/i0JYwaJzzXVstrQ8YUYgo1PbY3M1E/iqKgqUYME+MnJHxTLXlIA7Wy4FBozPcnH6DGp836lqy8UrNV5IItsGUU568o4YEScSKBtSJogrAMPESAdZWis/sMZcqzR0J5Xlqx4OtRAHYF9yxe75fWgBy0DGhzsvsToPqIAfVfdlQzAYo325kh5AdtBsG6tEom4OMbnc0w0JFq+IU0zSxAdTneQjLGm8/P7zlieVaNwGqqE5xi7EbmUX6fOaVaLfgi6wavPWFaANp8wPXLLIZjKd8sASpeE480FL+EexXtQtOi9PlF1N30Gy3Z2CIuTp4P4/rBS2Nuwcz1TfL5NQIdmzWrYTCRQo3zSFpEhrhMVjnCniN5UD3AHVyfwmKmDdTsJe/jLiTN4kH37NdE5FeXypO3trGvMCj6WhNT5iilBCPc+m8c4NN3zRqF3SkdxuwrCRlUkr7xIbecDd/YmhWOmMyJWBb8FIBN+oiOGM8280EfSWJeJ3YK3zB/uUEzzMMMNSnLpmfqc5roqEk61FEa+Efm8CkZdirmX
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR15MB3919.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(366004)(376002)(346002)(136003)(451199021)(83380400001)(2906002)(33656002)(38070700005)(86362001)(122000001)(38100700002)(55016003)(7696005)(316002)(41300700001)(5660300002)(52536014)(8676002)(8936002)(54906003)(110136005)(478600001)(66446008)(66946007)(66476007)(64756008)(66556008)(71200400001)(76116006)(4326008)(9686003)(6506007)(53546011)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?Mk9uT29xRXkyOVZGVThRQm12OTNLVU0yaDQxdnBuRkUrYzB1K3F1UC9jMGNF?=
 =?utf-8?B?OWlWT1BoVDFXRWxiSnh1QTF3WXpqdEplY0xidW1zSnVYV3JzekxUZHBUNGVz?=
 =?utf-8?B?eW9wNnprWnlxN2NZZDBpeFozS2pVWUNLSjdyQTZOTzVkNjU0SmJwVmJhOG5t?=
 =?utf-8?B?ZjRoU1M1cDVNanVFeDdIcXVHWlVZNmxXSHUwSFpYeEtQWE9IWmE0V2p2K2t1?=
 =?utf-8?B?bUg5NjkwbXNuc2VWRlRhazlYS09Ua1VUMmxtdmZVYVoybjhqRE1jU2JVb2hT?=
 =?utf-8?B?K25mRzAzOFdlY0xnVS9KM0pic1FGSGltZVB6dkZGbTNENFJQMWYyRDFBMml3?=
 =?utf-8?B?YmloSmZtYyt1cFhjN21nRlFaYnZDZFZYRTRYM1hQY05kTVVDV2FMT1JWWEhj?=
 =?utf-8?B?c09zdVlGRGI5Yk50bXNxbkVMZFEzdVBZeGNJeXpHYnRkRHVLSlZYWVpjS09k?=
 =?utf-8?B?M2dIdGxETHA5UHJvVmtoY3hzSXUzbWtrZzhjcWNySjJDZFR2Um9lZEVmNi80?=
 =?utf-8?B?eTJJWHA5cjZTaE56OHFKMWlrMFhRaFp6NUVROXdjTFRCMXg3c2ljaXVxbUha?=
 =?utf-8?B?VjVvTWVvdWRvb21rUUdTVjd6czJObVFzVDZNM2E0S2lkRmxkWDdsbHl3eUlv?=
 =?utf-8?B?VDJVbDhDYlNWNmxkYVR1eTRsR2NoQ1pXRElRZHkxb0laenk4Q3d0My9rZ2dN?=
 =?utf-8?B?NUY2R3Z3YmNmdGQ2V1EwNjlUZ3V4VkQ3N29JZVU1QjI3M3R5MmExeTUybWQ3?=
 =?utf-8?B?dnlCa1hLYU5jaW1IVHRwN2dsRCt6dEtURDlQcU9tTEhCakMvN0VGYzVrRWMw?=
 =?utf-8?B?NEdFTUorRExPYTk5b1o5Q2o1TUZyVnpNZWtFYkVxaFcraUZYOW9ndGJUckNs?=
 =?utf-8?B?VlRzT2JHTVdNN1BNamkrNVZ4d0w4Y2g4VXA5QjEybUtwS2lINFVhQkhieU8z?=
 =?utf-8?B?OGthMWVVaFhmb2FrVWd1WXp5SEh4SW9KZ2pleVE5dnZSYmYvbXA3bHk1U3Vv?=
 =?utf-8?B?ZGJXNWRiUTVZcThnZ2VPNmE1bXFZN25nanZUaUJlQk42MnRPTnBwcHlIaW9s?=
 =?utf-8?B?QjdlU29OOFhzRmlWQW5IcHRNZG56UFNvZG9kNHJ6WGdNUUk4U01ZWlgwU3RW?=
 =?utf-8?B?Q0hrV0FaeFJ3cEN0U1pBRFJ0SlVCbDJBN3N5bWhmeVNNZTZTaTRGNW9hd0xh?=
 =?utf-8?B?LzNKTjhTc0F3ekJ0OXdFemhPQ0RUb3JzZkRhY0theTJ2SVhIZDI4VjFNY1BM?=
 =?utf-8?B?NGRya0hyZ1JNd2lvY0l5eG41QkxhZm10S0F3eDltMXQ4MzNVbkVqdlUxYmFO?=
 =?utf-8?B?TzJlaEZFM3U5RzI0NFpqajloWU81NDJRRG9Dbm1GU2t0SFZMK0p2YzdEekFL?=
 =?utf-8?B?NkFRaTltMU5Eak1venVyNVM0d2RydGFQZnJLVWpnMGl0aGtrYTFCMnNudXBZ?=
 =?utf-8?B?bnJGNDVwajROdnAyK0JMYThnUytRSkF4RDFBaUR3Unl3SE14ZksrSGwrVDZs?=
 =?utf-8?B?aHRYK2gwamZYdFVtUWYyR09iK003cndSN2hnQS9KOFBRTXlONU95RzF2c3Z2?=
 =?utf-8?B?ZmJNZFRlTFhpYmtYYTRrQVU4UXE3cFBMTXh4UjZaQzlRbWZrSFVsKzRWN1B6?=
 =?utf-8?B?WHRRRW9mY3ZFbHliR2NrTzNKUWV6OS9LK29aSU5aNlZWMTJ5RmtvQUlVTzhM?=
 =?utf-8?B?ZUlVdlA2bCtvcUR2Z0ROd3FkdGdRUER0WTZOL2RDSmxkNWJEa1pTendIMDJX?=
 =?utf-8?B?dGFzbjA3U0JHM3BXV1RwV2oxMlVnRzhlU1Awb3YyZGpXUkNCNGY1cDVrbG53?=
 =?utf-8?B?T05LcGpPQ0RVdU9OajhzNFA3dGkycHlhYmlHbHBYdmZ1VkxEYXZnekZ6R0xZ?=
 =?utf-8?B?dndNa2UvSDB4NDNDYXJXZzlCWngvOFhqL0NVdlcwTldscWhjL0tOV0RSTmN1?=
 =?utf-8?B?NkltS3h6QlZ6L3Fxa0FGYk9WRitxSkZxSVFsSlVQcy80QUxOT1BBbEgvb1RE?=
 =?utf-8?B?d0ZSZjdBeFpQa0s5WjF3VURkejhLRXUxMThVSmpaSTdURGsxdUNIZU1YS3Va?=
 =?utf-8?B?Q3lZYTB5d2VNV3FJY2o4akZ6RmFwVko4eHkramRIejRqUkl6STM3TVVpbDVJ?=
 =?utf-8?B?bzR2SEZIa1RmRzUrVjlqRjR1d1FyZFZKUUFBaCtwT3hmdkp0WFdTZS9FaFp3?=
 =?utf-8?Q?WxreaolApx5mov98z9O9BkOMWan8UuU+a5Ie5kzqYiha?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e172082-bd25-486f-c620-08db64399699
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2023 13:51:10.5444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hQvoCW0Vj6K4yeJyTObOYUrCuWb2a2PGlWPP8zVxmo/0hn81AQ6QPp1HMlaasI27+UcOIZsCmf0yF6PIg1VFzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB5342
X-Proofpoint-GUID: NbOJyrTdlK1l5XQdL6zbVSzStfPfoWvT
X-Proofpoint-ORIG-GUID: NbOJyrTdlK1l5XQdL6zbVSzStfPfoWvT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-03_08,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306030124
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ2h1Y2sgTGV2ZXIgSUlJ
IDxjaHVjay5sZXZlckBvcmFjbGUuY29tPg0KPiBTZW50OiBTYXR1cmRheSwgMyBKdW5lIDIwMjMg
MDI6MzMNCj4gVG86IFRvbSBUYWxwZXkgPHRvbUB0YWxwZXkuY29tPg0KPiBDYzogQ2h1Y2sgTGV2
ZXIgPGNlbEBrZXJuZWwub3JnPjsgSmFzb24gR3VudGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT47IGxp
bnV4LQ0KPiByZG1hIDxsaW51eC1yZG1hQHZnZXIua2VybmVsLm9yZz47IEJlcm5hcmQgTWV0emxl
ciA8Qk1UQHp1cmljaC5pYm0uY29tPjsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJq
ZWN0OiBbRVhURVJOQUxdIFJlOiBbUEFUQ0ggUkZDXSBSRE1BL2NvcmU6IEhhbmRsZSBBUlBIUkRf
Tk9ORSBkZXZpY2VzDQo+IA0KPiANCj4gDQo+ID4gT24gSnVuIDIsIDIwMjMsIGF0IDY6MTggUE0s
IFRvbSBUYWxwZXkgPHRvbUB0YWxwZXkuY29tPiB3cm90ZToNCj4gPg0KPiA+IE9uIDYvMi8yMDIz
IDM6MjQgUE0sIENodWNrIExldmVyIHdyb3RlOg0KPiA+PiBGcm9tOiBDaHVjayBMZXZlciA8Y2h1
Y2subGV2ZXJAb3JhY2xlLmNvbT4NCj4gPj4gV2Ugd291bGQgbGlrZSB0byBlbmFibGUgdGhlIHVz
ZSBvZiBzaXcgb24gdG9wIG9mIGEgVlBOIHRoYXQgaXMNCj4gPj4gY29uc3RydWN0ZWQgYW5kIG1h
bmFnZWQgdmlhIGEgdHVuIGRldmljZS4gVGhhdCBoYXNuJ3Qgd29ya2VkIHVwDQo+ID4+IHVudGls
IG5vdyBiZWNhdXNlIEFSUEhSRF9OT05FIGRldmljZXMgKHN1Y2ggYXMgdHVuIGRldmljZXMpIGhh
dmUNCj4gPj4gbm8gR0lEIGZvciB0aGUgUkRNQS9jb3JlIHRvIGxvb2sgdXAuDQo+ID4+IEJ1dCBp
dCB0dXJucyBvdXQgdGhhdCB0aGUgZWdyZXNzIGRldmljZSBoYXMgYWxyZWFkeSBiZWVuIHBpY2tl
ZCBmb3INCj4gPj4gdXMuIGFkZHJfaGFuZGxlcigpIGp1c3QgaGFzIHRvIGRvIHRoZSByaWdodCB0
aGluZyB3aXRoIGl0Lg0KPiA+PiBTdWdnZXN0ZWQtYnk6IEphc29uIEd1bnRob3JwZSA8amdnQG52
aWRpYS5jb20+DQo+ID4+IFNpZ25lZC1vZmYtYnk6IENodWNrIExldmVyIDxjaHVjay5sZXZlckBv
cmFjbGUuY29tPg0KPiA+PiAtLS0NCj4gPj4gIGRyaXZlcnMvaW5maW5pYmFuZC9jb3JlL2NtYS5j
IHwgICAgNCArKysrDQo+ID4+ICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspDQo+ID4+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQvY29yZS9jbWEuYw0KPiBiL2RyaXZlcnMv
aW5maW5pYmFuZC9jb3JlL2NtYS5jDQo+ID4+IGluZGV4IDU2ZTU2OGZjZDMyYi4uMzM1MWRjNWFm
YTE3IDEwMDY0NA0KPiA+PiAtLS0gYS9kcml2ZXJzL2luZmluaWJhbmQvY29yZS9jbWEuYw0KPiA+
PiArKysgYi9kcml2ZXJzL2luZmluaWJhbmQvY29yZS9jbWEuYw0KPiA+PiBAQCAtNzA0LDExICs3
MDQsMTUgQEAgY21hX3ZhbGlkYXRlX3BvcnQoc3RydWN0IGliX2RldmljZSAqZGV2aWNlLCB1MzIN
Cj4gcG9ydCwNCj4gPj4gICBuZGV2ID0gZGV2X2dldF9ieV9pbmRleChkZXZfYWRkci0+bmV0LCBi
b3VuZF9pZl9pbmRleCk7DQo+ID4+ICAgaWYgKCFuZGV2KQ0KPiA+PiAgIHJldHVybiBFUlJfUFRS
KC1FTk9ERVYpOw0KPiA+PiArIH0gZWxzZSBpZiAoZGV2X3R5cGUgPT0gQVJQSFJEX05PTkUpIHsN
Cj4gPj4gKyBzZ2lkX2F0dHIgPSByZG1hX2dldF9naWRfYXR0cihkZXZpY2UsIHBvcnQsIDApOw0K
PiA+PiArIGdvdG8gb3V0Ow0KPiA+PiAgIH0gZWxzZSB7DQo+ID4+ICAgZ2lkX3R5cGUgPSBJQl9H
SURfVFlQRV9JQjsNCj4gPj4gICB9DQo+ID4+ICAgICBzZ2lkX2F0dHIgPSByZG1hX2ZpbmRfZ2lk
X2J5X3BvcnQoZGV2aWNlLCBnaWQsIGdpZF90eXBlLCBwb3J0LA0KPiBuZGV2KTsNCj4gPj4gK291
dDoNCj4gPj4gICBkZXZfcHV0KG5kZXYpOw0KPiA+PiAgIHJldHVybiBzZ2lkX2F0dHI7DQo+ID4+
ICB9DQo+ID4NCj4gPiBJIGxpa2UgaXQsIGJ1dCBkb2Vzbid0IHRoaXMgdGVzdCBpbiBzaXdfbWFp
bi5jIGFsc28gbmVlZCB0byBjaGFuZ2U/DQo+ID4NCj4gPiBzdGF0aWMgc3RydWN0IHNpd19kZXZp
Y2UgKnNpd19kZXZpY2VfY3JlYXRlKHN0cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYpDQo+ID4gew0K
PiA+IC4uLg0KPiA+IC0tPiBpZiAobmV0ZGV2LT50eXBlICE9IEFSUEhSRF9MT09QQkFDSyAmJiBu
ZXRkZXYtPnR5cGUgIT0gQVJQSFJEX05PTkUpIHsNCj4gPiBhZGRyY29uZl9hZGRyX2V1aTQ4KCh1
bnNpZ25lZCBjaGFyICopJmJhc2VfZGV2LT5ub2RlX2d1aWQsDQo+ID4gICAgbmV0ZGV2LT5kZXZf
YWRkcik7DQo+ID4gfSBlbHNlIHsNCj4gPiAvKg0KPiA+ICogVGhpcyBkZXZpY2UgZG9lcyBub3Qg
aGF2ZSBhIEhXIGFkZHJlc3MsDQo+ID4gKiBidXQgY29ubmVjdGlvbiBtYW5nYWdlbWVudCBsaWIg
ZXhwZWN0cyBnaWQgIT0gMA0KPiA+ICovDQo+ID4gc2l6ZV90IGxlbiA9IG1pbl90KHNpemVfdCwg
c3RybGVuKGJhc2VfZGV2LT5uYW1lKSwgNik7DQo+ID4gY2hhciBhZGRyWzZdID0geyB9Ow0KPiA+
DQo+ID4gbWVtY3B5KGFkZHIsIGJhc2VfZGV2LT5uYW1lLCBsZW4pOw0KPiA+IGFkZHJjb25mX2Fk
ZHJfZXVpNDgoKHVuc2lnbmVkIGNoYXIgKikmYmFzZV9kZXYtPm5vZGVfZ3VpZCwNCj4gPiAgICBh
ZGRyKTsNCj4gPiB9DQo+IA0KPiBJJ20gbm90IHN1cmUgdGhhdCBjb2RlIGRvZXMgYW55dGhpbmcu
IFRoZSBiYXNlX2RldidzIG5hbWUgZmllbGQNCj4gaXMgYWN0dWFsbHkgbm90IGluaXRpYWxpemVk
IGF0IHRoYXQgcG9pbnQsIHNvIG5vdGhpbmcgaXMgY29waWVkDQo+IGhlcmUuDQo+IA0KT2ggaW4g
dGhhdCBjYXNlIGl04oCZcyBhbiBpc3N1ZSBoZXJlLg0KDQo+IElmIHlvdSdyZSBhc2tpbmcgd2hl
dGhlciBzaXcgbmVlZHMgdG8gYnVpbGQgYSBub24temVybyBHSUQgdG8NCj4gbWFrZSB0aGUgcG9z
dGVkIHBhdGNoIHdvcmssIG1vcmUgdGVzdGluZyBpcyBuZWVkZWQ7IGJ1dCBJIGRvbid0DQo+IGJl
bGlldmUgdGhlIEdJRCBoYXMgYW55IHJlbGV2YW5jZSAtLSB0aGUgZWdyZXNzIGliX2RldmljZSBp
cw0KPiBzZWxlY3RlZCBiYXNlZCBlbnRpcmVseSBvbiB0aGUgc291cmNlIElQIGFkZHJlc3MgaW4g
dGhpcyBjYXNlLg0KPiANCg0KVGhlIHdob2xlIEdJRCBiYXNlZCBhZGRyZXNzIHJlc29sdXRpb24g
SSB0aGluayBpcyBhbg0KYXJ0ZWZhY3Qgb2YgSUIvUm9DRSBhZGRyZXNzIGhhbmRsaW5nLiBpV2Fy
cCBpcyBzdXBwb3NlZCB0bw0KcnVuIG9uIFRDUCBzdHJlYW1zLCB3aGljaCBlbmRwb2ludHMgYXJl
IHdlbGwgZGVmaW5lZCBieSBMMw0KYWRkcmVzc2VzLiBJUCByb3V0aW5nIHNoYWxsIGRlZmluZSB0
aGUgb3V0Z29pbmcgaW50ZXJmYWNlLi4uDQpzaXcgdHJpZXMgdG8gcGxheSB3ZWxsIGFuZCBpbnZl
bnRzIEdJRHMgdG8gc2F0aXNmeQ0KdGhlIFJETUEgY29yZSBjb25jZXB0cy4gQnV0IGEgR0lEIGlz
IG5vdCBwYXJ0IG9mIHRoZSBpV2FycA0KY29uY2VwdC4gSSBhbSBub3Qgc3VyZSBmb3IgJ3JlYWwn
IEhXIGlXYXJwIGRldmljZXMsIGJ1dCB0bw0KbWUgaXQgbG9va3MgbGlrZSB0aGUgaXdjbSBjb2Rl
IGNvdWxkIGJlIGRvbmUgbW9yZQ0KaW5kZXBlbmRlbnRseSwgaWYgbm8gYXBwbGljYXRpb24gZXhw
ZWN0cyB2YWxpZCBHSURzLg0KDQo=

