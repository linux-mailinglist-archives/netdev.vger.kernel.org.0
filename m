Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B7D350648
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 20:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbhCaS0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 14:26:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47156 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234446AbhCaS0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 14:26:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12VIPHkD010554;
        Wed, 31 Mar 2021 18:26:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=el7DniJ3XFVezHG5eazfebs/uUs2J2Xn1qlbuQpm9dc=;
 b=zM4Mdkk7xc2inijJiwdglqurD+aKdFdS1Qe6amfcV/hh3wbb/UAdBGMc1bC3tjWAV0e/
 4FuYXTDFOV+SBCGjmvAvo9zVRs6W7H8psiuzvPqcBTN6GeyyKFrZex3Ih49fo5VQfcER
 po7/Mj3/SdiqQ1T4YkQ6Tai8zTBeYtBefFnfOugUSaMwF3ha2ouJLPV3TQS8QvXufBwp
 p8hZW37hMeGOsdJyYA8YB1ZnALI030c/vW/xSFx0UQXnYiXRc7Vo92plh6XFUhcSPEIc
 LX9pjGALsrjQwzC4aNshGO7TM4B4uCWute/Dog0rLAdfFmMtynby0RfOpXZgxCueHS9H 5A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37mad9u7xe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 18:26:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12VIOf9I178452;
        Wed, 31 Mar 2021 18:26:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3020.oracle.com with ESMTP id 37mac5u0ba-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 18:26:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ioDrBg2D+vGyrW3PYBm+xvSPefYvb+DXbQVXfJqtme5vlzz2AjfxjCDMhaWFUaJxNgO6X5O9pg80cQcZEbMFjTQr8vOcrxeofu9PumKAY6YLwHuLY8tdPTe2rE73i8NYR3tRCfZTGh2peCjPa+FvuGAfolDNbqlJWc3bMyzXZXCIyE1Rmb6dYd9ZYDEF7/4jDaFWR+Nh3U8c8yDZLWEVcTW9eXIPsVpw0ix+bFtlE8jSMF/t/5iXrAh0o5fBvzJpF6tqbZJ6mdpN37WRRGDbr8lnUOBdrl+lhpCmeZst2KgB1v+cLJZqYNqLliZbezo3Q6viAI2Hy1QKd8DZqozHQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=el7DniJ3XFVezHG5eazfebs/uUs2J2Xn1qlbuQpm9dc=;
 b=XJU2akZHxGrq1bKz3ga36Z4DenPBWakvwevo5FRTMe7j3RE2GLAnVMaMmWZkn9UT5WtNRrxbgZTm0wWFZx8gTu1N+n1xWX19tb/BkEA5A0fLP4hO+G0fNo0YHK89xLr3CLTU54DrmnVq7JpnXkNztTIQU2koV596OUfNc2hhA6oQwTFYeKr21KqBUy+48vhp+nSz4i3YFTqypIPHNTirqsZdnGTxRSMooc1XcZrLRSxLZ6vTfCvidpgJR6a832noYOAv0I0dH2mdGaJ9RcEfKBWdmbuohr6oKkxgrogEUiME24ypsuOim2l9IM0zCQ2PG6UUqn5LegsRrnqG31S/pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=el7DniJ3XFVezHG5eazfebs/uUs2J2Xn1qlbuQpm9dc=;
 b=uIKfiHGZPW/nnmAZ6k4bX8Z2Y1m48QcAnucMVaxN4dhIWKyMHHuaxL4H1uE0MOYk09o+btoIy58+O1rcdyEGJlJh8z8zzzzBhu+kqoDbO5xH78PagwH3jJZ+AJ6y3GWBNUOqWIAb7k/xDnFjICK6cg2Xk8f+gIXJuNwmmQY/8O4=
Received: from CY4PR10MB1989.namprd10.prod.outlook.com (2603:10b6:903:11a::12)
 by CY4PR10MB1768.namprd10.prod.outlook.com (2603:10b6:910:c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Wed, 31 Mar
 2021 18:26:15 +0000
Received: from CY4PR10MB1989.namprd10.prod.outlook.com
 ([fe80::ad28:97d2:76cf:3fa5]) by CY4PR10MB1989.namprd10.prod.outlook.com
 ([fe80::ad28:97d2:76cf:3fa5%11]) with mapi id 15.20.3977.033; Wed, 31 Mar
 2021 18:26:15 +0000
From:   Haakon Bugge <haakon.bugge@oracle.com>
To:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>
CC:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net/rds: Fix a use after free in rds_message_map_pages
Thread-Topic: [PATCH v2] net/rds: Fix a use after free in
 rds_message_map_pages
Thread-Index: AQHXJdHGeKrNoqaL4kKU86HtsmKaPqqeawWA
Date:   Wed, 31 Mar 2021 18:26:15 +0000
Message-ID: <43236E0D-65B4-46F5-A4F7-1659FC1F33A0@oracle.com>
References: <20210331015959.4404-1-lyl2019@mail.ustc.edu.cn>
In-Reply-To: <20210331015959.4404-1-lyl2019@mail.ustc.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: mail.ustc.edu.cn; dkim=none (message not signed)
 header.d=none;mail.ustc.edu.cn; dmarc=none action=none
 header.from=oracle.com;
x-originating-ip: [51.175.204.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 219670fd-3fa4-4d07-8a64-08d8f472786a
x-ms-traffictypediagnostic: CY4PR10MB1768:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR10MB1768C7ABD0706B3B40D0C509FD7C9@CY4PR10MB1768.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wT/q9pu9YBbsNmj1c5i6xGhTgg8Gsa9mynOclYpxMYQoK/PbpqhWJmqbNydAaxMR4ZKAxvJ/VRFovjxVJBXV+oIV/qON1VFenQhX4YFEN7ix3xTdZGjn8GbqR5y0VhvJVu7XmvWXd8wmYk0EzydcGJRtrz7xJRzCCZVa8kHlUt8X5HjItAZcpo4iyG+/GUuyPyGS/WatFreb7UTKsJQAq7lnpgyuiYEwHlXww+7WSBAw/Q+4wSF/gcA8W2qRwcqtGqOyqvx/3nmxn+s7CupT6CP5rP1NnU2MFmi7Xi3hbuEsC7FmzdubGzllv5ZWjByQvbBJEV/GJaJtOttgkKxBP5jbdzNUqPBKDDzWcq6GxmMSk5y5x0mHdaV6audEqgeZvmc1JN2VDSYpm6tPZvlO+q6nWg3Q0BNKDmJBsJZOuT8buvrWn7Bx3vRT/nnLZg3ThluWTXV/z3wW6AvLomf8lqp9CcV2sULZzBt+ncUcce8OtvNMzMSbF+ScTaamKho9s5C0c90ls8eCq8zNuAi8a/oViY1lOPTpwWGQgVqtGhpq0sJLOKJ5XQMm2e//xfi6I6B63JQhkQjeOiiJCCIIIibFv2Esy4eIULtp3D2IhqYWL4SY01kFV38Wx8a+wdjAniahnX2WDTs8wHyxDz7rzRCr5J5Nfbs3oYp4lnkMK6JxPOuHUToO7Oap0TBh0Eu8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1989.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(366004)(136003)(346002)(38100700001)(66946007)(8936002)(2616005)(76116006)(66556008)(91956017)(66476007)(64756008)(44832011)(6486002)(86362001)(53546011)(6916009)(6506007)(83380400001)(8676002)(186003)(33656002)(5660300002)(478600001)(6512007)(66574015)(26005)(36756003)(2906002)(71200400001)(4326008)(66446008)(316002)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?YnJoTFVCUnF1dGpoNnNoLzh6Ri9xWEozcDNhb0xhN2Z1b0YzU0QwYThUQUt3?=
 =?utf-8?B?WUhhZEQzMW5OZHdyaENXSEQzOXYxRFBxSDhWRUxZcGZEZmlUaExXK2NVVUNQ?=
 =?utf-8?B?dXhudms5UzF4TGREWTRqM0NSY2ZQVXJRSUtvV3VzZVEyL3VNb2JkbzFVbncx?=
 =?utf-8?B?dnVra1ljRDgwYVMzaUxWVHZFSG9sUElaSkE0Y1piWlBoTmUvUGVNR1JnQitE?=
 =?utf-8?B?cnk4dVAxY3N0ekJra2pHRDVTeGJROWwyTzJOQVBqTWx6RUFZcEVKd1luaXg0?=
 =?utf-8?B?NktLUE1KYTllcGRVQXpyRmdyOGFPYzIvRVJUTDBGYmJnZWFPNURLQnRQc2cy?=
 =?utf-8?B?UWFYY0tqTCtRTTRzTjFVczZ3ZExIc2x2MlNOWi91YUJreDlFdkgxVlF6aEdt?=
 =?utf-8?B?dWxObTV1a2VOeWVTdHJJM0NPbThPT0VRUVBxQXB2c0hmKzlNbjBYMDJxYW1F?=
 =?utf-8?B?S1BpVWhDY3dUamtqTlNSbFNpT1h4d2d3Rkt0b0c5T2Uyc1ZYNy9uV21iOGlU?=
 =?utf-8?B?QnNoZDh0c1ZPM1dvTDFldW01czFPNTlsOSszU2JDMkZMV04yZ1Vlay9BMSts?=
 =?utf-8?B?OU5aTTJtWEE1VXRhY2VPZUhBU1d3REtmaWhYek9MdjFLV3dLbUt2S1JtRFNK?=
 =?utf-8?B?dXRqNDRWUUdpYjFKTVcrTzRjTVBxMDgvY1d4c0VkZko5cGhxMGNQWU15cEdr?=
 =?utf-8?B?QWUwdWFma0FKNGxacnFRVTl3VStYQ2xBbjRkMDBva0JKcHZPVDJTQ3FkelFk?=
 =?utf-8?B?N2xPdFNJUVZLVHhrQ2U0LzB0ZVU2NStxQkJvYWZiUVprSVgyQ0dKU08wVEpK?=
 =?utf-8?B?MTJ0azg2U1FYc1dFelJFMzJtb21MZ3V3NnVUcFNrbkxLeEtVZlU1SDhDeE8r?=
 =?utf-8?B?L1g5MFkrQThnTzBkOC9IbElRT1liYXc2SmMrQnFpazNuUGQrdllHZ1J1b2pr?=
 =?utf-8?B?RkRtem1sYU40VHVRSlhmd0o3N0NsdDZSbkNVRk5oN1F1cktDSUpWMnV4ZDh4?=
 =?utf-8?B?bDZuZ3Y2M3UxYkxsVUNrVTF1YWhJTmQ1Y2xMS3lVVS9TbGIrdHR4V2I0OGVm?=
 =?utf-8?B?QzZWdVVKZ3FndnhBUXZ5b1Zvc3NjQUVNQnVhdTBscVdwN20xWWludW54UTRG?=
 =?utf-8?B?bHY4SWpsUUxSK011RGxoNk42dWd4bVdsSnpTZ3BlYnYrL0ZwQlNSTkgrbWxT?=
 =?utf-8?B?LzQ3RFdqQmRpMkF6MG9KSGM1ZlZrOTVxdU1IT05ISlN3Q2JpWE1pMzltRENF?=
 =?utf-8?B?RC9rdEwwSUVjWEhBbm1yT3h0clE5QjZzMW9NcFNNdXhJRUl1Q2Y2ak1ib0ty?=
 =?utf-8?B?cDNFWkZkT1VpS2xET3RuK0pRNzJta2RsN3FUZ3FPY2xLU1ZiaytkOTFCY2Mx?=
 =?utf-8?B?eXV0UjRYMVcvVGZ1Zk5kNThoVVJKY25xQmZIM2d3NUtidFZ4dHF0aWdrM1RO?=
 =?utf-8?B?czQwaFJrb2k2T3FNM0FpUzEzL3JnUDFwQ1BvOFhQWTJVUlFtNVE2dTNIT3lS?=
 =?utf-8?B?b1JBOU9uNlJPNkhOTlBmTlZSU29RQ1pWRkFxRjUwSG1VRS82TWtMVDRha0xK?=
 =?utf-8?B?bDBPQjN4anNBelRxUzdxaXVKbElyMHI4VktrTFVYR3IvM29vWGxXT1kxVm1t?=
 =?utf-8?B?S3RWUjE0UmdLWFhEMTAwQk80L21FekNGcVRVU1krVENGRWp4QXB3RkFCa3dr?=
 =?utf-8?B?ZklkM0VkR1EzcmxiZTZnQVp4ZUtyRGVaYUVuSXUxeDBWUFhhMzJoNVNjVDdZ?=
 =?utf-8?B?ZzNVZElUdTluakVPTGlLKzZXSTlET2FNcTlybHlyV0Q2VG5hQndLT05HeE5q?=
 =?utf-8?B?WE9uUGhPSElPRXRVWFMzdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <73BD374B29F072429B07176A71B3E2D7@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1989.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 219670fd-3fa4-4d07-8a64-08d8f472786a
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2021 18:26:15.5772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HMtn+2i2MRAUQHWY/gHjwQtuJ4AXTu1UEf5Sh9gr4JoluG32ACpnMxfzQRTNrQCIUwYetpICdankg9KZhAqVFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1768
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9940 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103300000 definitions=main-2103310126
X-Proofpoint-ORIG-GUID: urzjfBjtEuOr4R0mvzrAwCLgkrV0a4SP
X-Proofpoint-GUID: urzjfBjtEuOr4R0mvzrAwCLgkrV0a4SP
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9940 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 bulkscore=0 clxscore=1011 lowpriorityscore=0 suspectscore=0 adultscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103300000
 definitions=main-2103310126
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gMzEgTWFyIDIwMjEsIGF0IDAzOjU5LCBMdiBZdW5sb25nIDxseWwyMDE5QG1haWwu
dXN0Yy5lZHUuY24+IHdyb3RlOg0KPiANCj4gSW4gcmRzX21lc3NhZ2VfbWFwX3BhZ2VzLCB0aGUg
cm0gaXMgZnJlZWQgYnkgcmRzX21lc3NhZ2VfcHV0KHJtKS4NCj4gQnV0IHJtIGlzIHN0aWxsIHVz
ZWQgYnkgcm0tPmRhdGEub3Bfc2cgaW4gcmV0dXJuIHZhbHVlLg0KPiANCj4gTXkgcGF0Y2ggYXNz
aWducyBFUlJfQ0FTVChybS0+ZGF0YS5vcF9zZykgdG8gZXJyIGJlZm9yZSB0aGUgcm0gaXMNCj4g
ZnJlZWQgdG8gYXZvaWQgdGhlIHVhZi4NCj4gDQo+IEZpeGVzOiA3ZGJhOTIwMzdiYWYzICgibmV0
L3JkczogVXNlIEVSUl9QVFIgZm9yIHJkc19tZXNzYWdlX2FsbG9jX3NncygpIikNCj4gU2lnbmVk
LW9mZi1ieTogTHYgWXVubG9uZyA8bHlsMjAxOUBtYWlsLnVzdGMuZWR1LmNuPg0KDQpSZXZpZXdl
ZC1ieTogSMOla29uIEJ1Z2dlIDxoYWFrb24uYnVnZ2VAb3JhY2xlLmNvbT4NCg0KDQpUaGFua3Mg
Zm9yIGZpeGluZyB0aGlzOi0pDQoNCkjDpWtvbg0KDQoNCj4gLS0tDQo+IG5ldC9yZHMvbWVzc2Fn
ZS5jIHwgMyArKy0NCj4gMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlv
bigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL25ldC9yZHMvbWVzc2FnZS5jIGIvbmV0L3Jkcy9tZXNz
YWdlLmMNCj4gaW5kZXggMDcxYTI2MWZkYWFiLi43OTkwMzRlMGY1MTMgMTAwNjQ0DQo+IC0tLSBh
L25ldC9yZHMvbWVzc2FnZS5jDQo+ICsrKyBiL25ldC9yZHMvbWVzc2FnZS5jDQo+IEBAIC0zNDcs
OCArMzQ3LDkgQEAgc3RydWN0IHJkc19tZXNzYWdlICpyZHNfbWVzc2FnZV9tYXBfcGFnZXModW5z
aWduZWQgbG9uZyAqcGFnZV9hZGRycywgdW5zaWduZWQgaW4NCj4gCXJtLT5kYXRhLm9wX25lbnRz
ID0gRElWX1JPVU5EX1VQKHRvdGFsX2xlbiwgUEFHRV9TSVpFKTsNCj4gCXJtLT5kYXRhLm9wX3Nn
ID0gcmRzX21lc3NhZ2VfYWxsb2Nfc2dzKHJtLCBudW1fc2dzKTsNCj4gCWlmIChJU19FUlIocm0t
PmRhdGEub3Bfc2cpKSB7DQo+ICsJCXZvaWQgKmVyciA9IEVSUl9DQVNUKHJtLT5kYXRhLm9wX3Nn
KTsNCj4gCQlyZHNfbWVzc2FnZV9wdXQocm0pOw0KPiAtCQlyZXR1cm4gRVJSX0NBU1Qocm0tPmRh
dGEub3Bfc2cpOw0KPiArCQlyZXR1cm4gZXJyOw0KPiAJfQ0KPiANCj4gCWZvciAoaSA9IDA7IGkg
PCBybS0+ZGF0YS5vcF9uZW50czsgKytpKSB7DQo+IC0tIA0KPiAyLjI1LjENCj4gDQo+IA0KDQo=
