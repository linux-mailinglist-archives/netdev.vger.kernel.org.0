Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E112135724B
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 18:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347561AbhDGQl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 12:41:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51096 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234029AbhDGQl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 12:41:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 137GYgOX156212;
        Wed, 7 Apr 2021 16:41:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=thX+WakR7NQubaC40zLhRLEytuWUoVrxmzUdUTFcDig=;
 b=IZ5vXOIpP0/MaftHWVP8uP3ftCUD36J7GO5kxZpVa9OxIHZODgmhfp0XTEerxBVGv8GJ
 e50Ry0TCxWVV8QGv8L7ec1d9W/yDIBDR99qBx7KNk9eEjlz1kcjN2WkmJjVoAtscskBB
 kwRdtnpkohWBTrg/oJw/IOw/1o3vvMIFh9a50KnyjLmqhmWQafT34XPT9yRh8vOsyJkg
 12IJk0rUX2j9qQO3XMhDy5owGHRbHqjOGkFnuWr7iOozaHnzw6UXF4J3LvN2RPms8d6V
 DbBvhA71kItHZLpHmfR7a5qszKenZJi4bCTDNUAZirjD1CFvuVHk+L5IL8GRnwlz8o8z SA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37rvagb774-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Apr 2021 16:41:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 137Ga20g110038;
        Wed, 7 Apr 2021 16:41:09 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by userp3030.oracle.com with ESMTP id 37rvbekqcn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Apr 2021 16:41:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W8GIP3ko3/w5St1FUhGNzwK5xf4wRcCi/x8H29mazEdWetDZVHmbnH4DraOJaugutdVS9scPrAu704xvt9wk3+KE01hUUkgpQbeUc8KcXcD0UeTdxTe7kYnXuH7wg+2u9vwCxr9IQBtFhlv/1OQ9EnKtLBeGQxoauHxj20l0ZI9RRUQshKsA/QluZwyj7GRf6j0ZvO68IB5NVc5XI9nuqXQCvF2Stjtryau83VjeNReKTjn/dLeCPGkTBoxWnqTTDBLavOYN0QEQnDSurm50lM2DUln9kU8aGDMm0BZ46UKoDHgtY4zV17lbNUeF/LwDFQj/EgduMVRRCFHBCy5Cew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thX+WakR7NQubaC40zLhRLEytuWUoVrxmzUdUTFcDig=;
 b=DGsZr0TMxR/71QBfQUI6/nII1OhjyRVLxa1OL4PAiADA9F7mZmFo3Pjhk3fv8i4kjeQBd/A/KNSzrxGenNZhv7/Yl3LfJ6q9QUH8pu2HqtR3ckxqRpeOOfPjA4liw1KXMvnk8Dfq4cIlRlwVZpO+s1dxbs4WaCTj4g1HeBr+NO9JPxmON2Pnsf5GTRggWmAXInsdoMAMjs65G6Fbif8MvBoQZrF2vwNY4EypyGg1jQg9QQfMLzgHWDHd+GeVfcZ9pQLdY8ZOVAHxg+Q/cqcQS/Zp1JCPARbhoeK1xzmc37kylpQg6luL42G5UI/FL3wx5mRp9jXtK0WfZyGgIc1e9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thX+WakR7NQubaC40zLhRLEytuWUoVrxmzUdUTFcDig=;
 b=oBqIfvNyUHY6V03k8VwvTe5HULHyc5FGed+qYwkTtoqMkOW7qrHUOK+Y7mnHSE+TbP4fvCNmvtnQJ33WKWBwTNg7E6L5aO0CI67kXi40kyYuYs70MPI8wwtEvbFio5yswBBlaMJ7X6bytcc/8RR7mFPHEl3Ww+8xMgk0sjbciDs=
Received: from CY4PR10MB1989.namprd10.prod.outlook.com (2603:10b6:903:11a::12)
 by CY4PR10MB1302.namprd10.prod.outlook.com (2603:10b6:903:27::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Wed, 7 Apr
 2021 16:41:07 +0000
Received: from CY4PR10MB1989.namprd10.prod.outlook.com
 ([fe80::ad28:97d2:76cf:3fa5]) by CY4PR10MB1989.namprd10.prod.outlook.com
 ([fe80::ad28:97d2:76cf:3fa5%11]) with mapi id 15.20.3999.033; Wed, 7 Apr 2021
 16:41:07 +0000
From:   Haakon Bugge <haakon.bugge@oracle.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for-next v3 0/2] Introduce rdma_set_min_rnr_timer() and
 use it in RDS
Thread-Topic: [PATCH for-next v3 0/2] Introduce rdma_set_min_rnr_timer() and
 use it in RDS
Thread-Index: AQHXJl3kxGIldyYid0mmsgwi6FkGPKqegoeAgAFv6wCACVprAA==
Date:   Wed, 7 Apr 2021 16:41:07 +0000
Message-ID: <75DFACE2-CBA6-4486-B22F-EFE6D8D51173@oracle.com>
References: <1617216194-12890-1-git-send-email-haakon.bugge@oracle.com>
 <BYAPR10MB3270D41D73EA9D9D4FCAF118937C9@BYAPR10MB3270.namprd10.prod.outlook.com>
 <20210401175106.GA1627431@nvidia.com>
In-Reply-To: <20210401175106.GA1627431@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [51.175.204.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83a2435c-3404-4a84-b029-08d8f9e3f177
x-ms-traffictypediagnostic: CY4PR10MB1302:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR10MB13024C753BAE38FB18E59EA3FD759@CY4PR10MB1302.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vmVZWMWWMgDbxGutKBA/JQPNwRhssFUVkARfFsi+fvytmRuvT7bpPzstlh3T9L15o2lNAvsNayjVriFuM/ouGmmzhBhjajlZSfe0ixR9XzFBMayuHwihTurgpmz5/N2McnVpfryz1+izTy4VSIL5fOzh5s5V3+Ut2Po4C/jorY8Dvel/WqJYpTORzhANGySw5X31O5AWA/LisKVHLjkXsMZ5MBd6yxVyn4r58o57eXq0Y2KxbOYv40GhbD6DhkdM7wvMQqLoBm0z10J1tb/MBcamAkizCAV1Ld2dIk+CyTtcEaWl52dDbb3sswtJ5e132gefwkmmr8YnNE1AfTgkILZzgj8vcIKT4rYIPD3n85qCino+nKBe1Kv5KkIEUnBbZ+j21TVHJ+NRbpUJvuqt/EybtNsFDfHM6FPZOFtJCuXrvMgUkQbJaxb7ZZugSdCPImTgnrLxm/6puvzEmVZk284oXqJentiBSqzQdHlFao0bUUiiftOH36lBSxikGW0hA2dZXWUdgc5QWYyDypkkdUPTzLRbvh6FKjJ5Up5FRo0/Apg7FuOWk7T9EG9bcsVZKzxuzD6xCZ3w80H39zf29WN9BGuM+h43geNDSKrvXL2CtCrDkMOY2hVrXiZ1D2n3eKezHdUiLNw4dyFqiILTQoKWZWE6+leZCVeuSKu04UeTgprqxGi/vd1PP6xpoCUt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1989.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(376002)(346002)(136003)(6486002)(2906002)(316002)(6916009)(86362001)(71200400001)(2616005)(33656002)(54906003)(44832011)(36756003)(6512007)(186003)(53546011)(6506007)(4326008)(4744005)(8676002)(8936002)(38100700001)(26005)(5660300002)(66556008)(91956017)(66574015)(66946007)(66446008)(478600001)(64756008)(76116006)(66476007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WkJWZlRnQTFuT3ZjTmhiOEE1MXZpR1pvQ3NtZ0tpRWZKNFpJVFJMS0JlazVz?=
 =?utf-8?B?dW5VSGlyMmZzVDJlUDloRmY4eWJ4NWh0eFNQY0d1U3huSjZXcXNsS3ZMMkk4?=
 =?utf-8?B?VTRWQU1NVEZlQy8rQnVmMkk3NzZCV3NBSUxGZHpXVFFqVmdNS2ZaMnJ6M3Z0?=
 =?utf-8?B?NnREc3NsdlRTelh2eFlXbThsR0FZRzBFZlEwWDV5MEpZeVpBQ016MWNjM3lO?=
 =?utf-8?B?bDd2dDFhZGdUcURNVWxleUhhZ0VjcHhLOThrNzlDcko3WWdiNzdtUzE0TFJI?=
 =?utf-8?B?TVFwWGF0YTl2dmF0ell3Nm0zK3Q1OUNrSjNuWCtkOE9KV1RjSEVpTmtCaTJv?=
 =?utf-8?B?TnpzTHJvcWFwQ2NBQkM4TDRkTzlxbTExWkJtZTA2SEl2VTJBTzcwUVVOWlRq?=
 =?utf-8?B?VjNhVDJlQnkwa1c4eGN0OURaQ09QOUxVeEpyd0c0d0pXbVd2L3dnSVpZVThU?=
 =?utf-8?B?THd6bGUrdW5GL3BhQTRaR2daRURWZnFaMXhzTkYxSm90NVhqdXBUY3hGQTlr?=
 =?utf-8?B?eHBjQnU2WmJaZ3RUSjE0QUdDMm1OVzZSQVMvaWVaMHRvY2x1K2RTZ1BXVmVT?=
 =?utf-8?B?Z1ZHa21VRHgxNlF3a3JVOUtzZlQxSFk1TGhLSXRkdWkvK1ZVQlVqdmtZVW5C?=
 =?utf-8?B?Ni9aZC9KVWFCUEMwRDhiMlBQcEFzejNOSzZ6c0pPcm95Zk05c0RLczNVR2dS?=
 =?utf-8?B?bDJTaHFkckwzQ1FhbmpTaGptSUFjYUpkQkpHdUhCTjh5L1k3TzN5dWhXV1dh?=
 =?utf-8?B?OTRrblVhL2d5MzZpNktsemp1aG93MFlQODgxbjJwSzk1NEs4ajhIZlpkOUVQ?=
 =?utf-8?B?djkxOGZEeWdLdkl5R1pnTFZMMG1ydFh3R0VVMnYza1RDQW5tRk5tQ1NqRWJY?=
 =?utf-8?B?MjRicHU5NXZqL2pLMzZLR01hOC9EN0dtMjRoWTh4cUc5UGpGRytOWXE5ZDJK?=
 =?utf-8?B?Z1B5aGdZMnhDN1kzbEJWbVVlUEtYUkxEQmVMOGhEdkY5angyL0FIdkRWWk43?=
 =?utf-8?B?VVpKcGs5VktFN0VFYkV1dXBiZ3p5dE4ycEVmQkx3V3AvQjZEdW94NTRuM016?=
 =?utf-8?B?N2FSVm13OGk4dmZjZHdNcjl4VG9NWUQ4bnVtd0F2RXpaWFJQUWl5SklVMXFw?=
 =?utf-8?B?dHI4R0RWNFFOL05ncEFBSHdLOFhiYkpJQlB4blNvQlVJTEIxOXZaTXBKc25y?=
 =?utf-8?B?eUVtNUZ2ejltYk1uamRlLzRwL2FyV0FBRDYvUGVmVTJpMmpwUTY2RzMzSGJQ?=
 =?utf-8?B?QTc1R2krSGpHRXJ4WGdnVnRKQXgxTTIzYmtNeG5FOHdDWlA4MjVEcnVHZjlL?=
 =?utf-8?B?ZVAzWVRlZ2FkU0pvcDk4czBUaWQvUFJrN2tzTmlEZzlWRUhXUXgvM1JSUmt4?=
 =?utf-8?B?aVRNNHpxcW5YSVh5SEN5bXAwMUR3TVQzVUd6cjJMMW5xbUdzbVIyOHdHTkJO?=
 =?utf-8?B?TkZIa1o3bnRPOW1FajE2T0RGMFo3Y2xSL00rakNHSTU3cVVrakdDMXpRYWV2?=
 =?utf-8?B?Z1NmS3dWaDJaTmVVcWlRUEUyeTVXc2JqRDRlWnNkNzgyMjdsUUd3OTFDUTFs?=
 =?utf-8?B?YWlKZEROZXJkQ0l4MjdENTMwb0JzNWlFc2VLZGp4UHNQWm1JTlZWQXUxYzhx?=
 =?utf-8?B?NGtoN2FUTlpkU3YyQW03ZEZVZ2RXUm5EMERWdHI4SXV4OENRcnJZeVQ4TDBu?=
 =?utf-8?B?Zm11WEdDZk9yNWsrNkoyWU0rR1d3OXFJUE8rRlExdkRFUkNYU2MxRnEveXdF?=
 =?utf-8?B?ZFpHRzN2VW4vVjQ3WHFQb2VPSWdOeVI4dzdpRWFyaVFjRGxWaEFZY053cndp?=
 =?utf-8?B?UEVIc2U5TTNjTjZWNVlLdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C11CC47976BE064E93823FEEE3D2FD93@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1989.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83a2435c-3404-4a84-b029-08d8f9e3f177
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2021 16:41:07.5881
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +hhd3tzq7RaE51RNFNRTex8XeUONvzgnZA6liMsrzCRUbpckuK2ADlqIizGeROniKsSUs5aP8GaFZB+Btqmerg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1302
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9947 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104070112
X-Proofpoint-GUID: -KDy8bF0CyAhEvgNT8JsN41QPPrsKupb
X-Proofpoint-ORIG-GUID: -KDy8bF0CyAhEvgNT8JsN41QPPrsKupb
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9947 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 spamscore=0 phishscore=0 clxscore=1015 bulkscore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104070112
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gMSBBcHIgMjAyMSwgYXQgMTk6NTEsIEphc29uIEd1bnRob3JwZSA8amdnQG52aWRp
YS5jb20+IHdyb3RlOg0KPiANCj4gT24gV2VkLCBNYXIgMzEsIDIwMjEgYXQgMDc6NTQ6MTdQTSAr
MDAwMCwgU2FudG9zaCBTaGlsaW1rYXIgd3JvdGU6DQo+PiBbLi4uXQ0KPj4gDQo+PiBUaGFua3Mg
SGFha29uLiBQYXRjaHNldCBsb29rcyBmaW5lIGJ5IG1lLg0KPj4gQWNrZWQtYnk6IFNhbnRvc2gg
U2hpbGlta2FyIDxzYW50b3NoLnNoaWxpbWthckBvcmFjbGUuY29tPg0KPiANCj4gSmFrdWIvRGF2
ZSBhcmUgeW91IE9LIGlmIEkgdGFrZSB0aGlzIFJEUyBwYXRjaCByZG1hIHRvIHJkbWEncyB0cmVl
Pw0KDQpMZXQgbWUga25vdyBpZiB0aGlzIGlzIGxpbmdlcmluZyBkdWUgdG8gTGVvbidzIGNvbW1l
bnQgYWJvdXQgdXNpbmcgV0FSTl9PTigpIGluc3RlYWQgb2YgZXJyb3IgcmV0dXJucy4NCg0KDQpI
w6Vrb24NCg0K
