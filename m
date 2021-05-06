Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8751374F9D
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 08:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbhEFGwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 02:52:05 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:49324 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbhEFGwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 02:52:01 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1466jYMI109120;
        Thu, 6 May 2021 06:50:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=tjbzmmEgUMnhf9BPcMbyBlovFc2YrWN5oEUIpzBwkmk=;
 b=ed0F7+X5XhTI/q0Pa3wdqaFMxohpSsOwUstpyXbmlm+OSc8bpmUhf0h0ZGeT3pwN3mzN
 o7FUl+sOYaXiik8RgL8DTGWl04kQ9yPJ6ul6yMzTYbRwClWUKeYZYhJfS8lRW7yXt26K
 8ibgHtYoW4n72+k136W3POEjkT2TMEXUbm4ozFlsYbvMC9YClHHb4gpbVYDIxJ5JnWak
 P0ZOPXVDNWPZPlf1KUhpYWsUxK6i40WHyWSO70bpw/3A9o5RdLrohnfbFSOhntteYygo
 pczVL8+bdx0XiPwL37paxgGNYI7n8bFrUhxpaQG9VfH6FqInrqzLiaXghfXkwHC3gHVS kQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38begjbw2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 May 2021 06:50:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1466jUMT154266;
        Thu, 6 May 2021 06:50:45 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by aserp3030.oracle.com with ESMTP id 38bews9r5c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 May 2021 06:50:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rp+2zTESgAbMPcBqnhdIOmP1WJpRwgJTJpoFQJJ1QoFySs5plsXSp+Hpi1jTsO3mXLey3qTd087efc6E1T5GNcF5Yc9tQURk2IpDj/tBR4qT/7Avfa0TiRveubfOWnmLmI4MzHOQnodvBOzgxoZc18XeV7EYuJDgUZaFjU4IYFOQMzDZi/EaU6uk/abG1uQ0iqt6jo5JYdEzY3gG6fKp5M4asetJPuLoaMeV3B+JT0KiAzsWPlq8J9uoxUYfp5c06I3jf1IxeyKqUHDiwr75OvKcTlZdX9RUGM+7uio6lwMJua5xJT90fJKBX6ZK/CebAnbDHWIlAkbhOmsjan/gHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tjbzmmEgUMnhf9BPcMbyBlovFc2YrWN5oEUIpzBwkmk=;
 b=ENpGCCbeepEuhObB8h78xYYPFzN8vtlB2N+3bTknLr1CVnnLtqG7BWIxIzijkDJqEJfPyhuvR5WdKNuOos3/wzwDj8v5ODr2ZhobGTkRDdUAqflv4II0Wm23f4K6/EBHpmwLHMNKCh9nC9yMUst37L3ipeFeL/kkoNUcI5kF+XVuip/Iv9U+Ae0HCegRIg7PyccL3TuNG7ASd69/9T5jFqw7EzTW9NOFwOG01igkc7wuuTeI/kz30THxYP4v8HiLSULJ03ra53x0WXT49qkiyWQATJjwGiE1x8VcclQKmj6Rkp4p9tPrcxWYTOhLM9iI56PEg/QvfZrC2oPW8/G/kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tjbzmmEgUMnhf9BPcMbyBlovFc2YrWN5oEUIpzBwkmk=;
 b=SBUB72qpCPxDjEABuFVE9lgUDRG5QXzhVA2z61KNNpm0kckJT5QzsMe0BcOrg4e57zLLERVV8TOYjzE9xNbV+elkP8hxGG23Wq5B9kh1Jq5dUJsN0LrAwh0PwvHWjHcyo74muubKaG6/wmQWi9iPA5LwrN4hW+0RfH5xxP5Y1E0=
Received: from CY4PR10MB1989.namprd10.prod.outlook.com (2603:10b6:903:11a::12)
 by CY4PR10MB1255.namprd10.prod.outlook.com (2603:10b6:910:b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Thu, 6 May
 2021 06:50:43 +0000
Received: from CY4PR10MB1989.namprd10.prod.outlook.com
 ([fe80::ad28:97d2:76cf:3fa5]) by CY4PR10MB1989.namprd10.prod.outlook.com
 ([fe80::ad28:97d2:76cf:3fa5%11]) with mapi id 15.20.4087.044; Thu, 6 May 2021
 06:50:43 +0000
From:   Haakon Bugge <haakon.bugge@oracle.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
CC:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH RESEND][next] rds: Fix fall-through warnings for Clang
Thread-Topic: [PATCH RESEND][next] rds: Fix fall-through warnings for Clang
Thread-Index: AQHXEZ70IVxEeMts1UqoqPxQZDIhRKq+HyGAgBhF5AA=
Date:   Thu, 6 May 2021 06:50:43 +0000
Message-ID: <6AB78D3D-C73D-4633-A6FD-9452DD8E4751@oracle.com>
References: <20210305090612.GA139288@embeddedor>
 <cd935ba5-a072-5b5a-d455-e06ef87a3a34@embeddedor.com>
In-Reply-To: <cd935ba5-a072-5b5a-d455-e06ef87a3a34@embeddedor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: embeddedor.com; dkim=none (message not signed)
 header.d=none;embeddedor.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [51.175.204.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7cf3d031-fc70-4bbf-1e95-08d9105b451d
x-ms-traffictypediagnostic: CY4PR10MB1255:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR10MB12550DBCFDE845295305DA7DFD589@CY4PR10MB1255.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tdF/ue4l0zZIJYYvMRPsclDzCX/e0BlJIU6V4K5uDKYzUbCHm/0qHc+GnNPNcG2UZCh2psd/UmpGPaSUkFCsZupuj+hgMjXS3hzMqWMMp72WOv8pQsoFBgHWktEZ0PF+S3FUVZfUTItWm+gC8qINpkhZp8OIqA4/GLqqGsgGpi6YTUoj6HSjpT1INeO3H+0J57KM50WdcAlenojM+a1XPhWGbN4y36duYdwcIiBDnrxO71Oq5EjBPswmUfp90g438AKPbFN5p3I3Yl3IRmI4ad/MvVSPeJu0Ff+6BdKAtYVUmpkEYvvpRKr//eDV8EYxOolVY9QHYaUgTYVHvQUzLcTfzjp6KPwm9Xk2MCQmRSL5pNhFVzN/TS6F5xFQK7LAKhMWNAGwRTgKEnG+Bou+p7Xog0egrhzkI/uLVRDsfmvXH6EHp4kRwXZzPKT1Qgyu67B8lcoLVx967woo5PEm3uCBSYod3vGKIbhIkU8/LNRLVMsJ5MhkvHUJbYIsvOE2fZ4EaWR+wQ+a/YuNvDgZLTMU5f1t+1Ul7XuFsapi2k6TUKoi/yxGiGCvIPmbp31lSZpbsl58+cRBdpIBGBxtzfu6oh91I5XroJHRMX6WB3D9Jw63U2q9f/khbYCTg6Jq38l0a+zFvT1+T6SpAgUzPXtVDvAnaH+9ymiVP0KFllEFsoQspJP/jEpeSaqO2ipp7kJYhgDnGcWUJ4XbCp8eRzpKD4mFwdm3UeLXJRi5h9k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1989.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(136003)(346002)(376002)(44832011)(66574015)(5660300002)(83380400001)(316002)(2906002)(8936002)(38100700002)(122000001)(6916009)(6512007)(54906003)(76116006)(66476007)(66556008)(2616005)(64756008)(66446008)(33656002)(53546011)(6506007)(71200400001)(186003)(91956017)(86362001)(36756003)(8676002)(966005)(26005)(6486002)(478600001)(66946007)(4326008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?OU5jc2FpUkQ0RDNZeUpUZWhhSWZZU1JRT3BZM3pyOXdFNUQ2YWhFS3RGcEYz?=
 =?utf-8?B?WTdDK1NrR21MUnJHM0JJNkZDOUt3R1daTTlxV2dpRFFvNEV3bG5vRWdJNk92?=
 =?utf-8?B?QXJqU0VBTjZRbkV1Q1JqanhFakd0ZlR5Y2hCUGRNd1U5UFc4L1Vhck9kNjBu?=
 =?utf-8?B?VFZFU1hZbHBhcXNpSkh5eUFiczJtRDBXckYvcldDWTA5YVRQQWhMUThSZUhN?=
 =?utf-8?B?cFpWSW1wZmlSMFBjczZRbU96OStPc012eGNoQ2Z4TWNtOVloT0p4eFpjZ0p4?=
 =?utf-8?B?MjczQ0QvSGhiMVRYODlSbjdFK3FPeDRkZlFlQnpRTUYvQXQ0MVNnMlhoSWxl?=
 =?utf-8?B?aHNuM3NRUVlOUnFmWlAwNXB6SFBBWnQyK0lBdTJkSlNwUWh5QzBqTVRqTDNi?=
 =?utf-8?B?UVNMTVVwTkhzSHd2Vnk1a2lsenIzSGdLNysyYS9kVllQcTh1SmlGblpaRlhG?=
 =?utf-8?B?dWt4T0R4VzI3Nmlud3VxK2ZOSitKVHBmMHFJdk5iS3JoKy96bGZOL1dib2Ju?=
 =?utf-8?B?ZTFyRTA3c05EemhSaWxvOG5Za3BvSEJWSnlGZXBhRGRHL0tGd0FXKzJiSWk2?=
 =?utf-8?B?V0o2VlJqL09YLzhYU2ZqUlVuZFhDenJrcEdLQkF4ai9DRnZMK0YxQUxPcGl5?=
 =?utf-8?B?eVd4SkV1eDZtNTFueXJqQWkxQmF3M1daMFM0THFvU0lTZSswSWJRVDBzUE9L?=
 =?utf-8?B?YU1DcmN2bENqK1k3RkVUc0FDV3hJUk04RjlSOW5zUFJFa1NhTUV6bEgwQnFi?=
 =?utf-8?B?L1lEdHJMUmlrMFRLZEVrUi9RUjlHOUE2YkhtVlptbGtQTGRrZTk0b0NJSmJD?=
 =?utf-8?B?TVVISEtuSndjUFU4Yko1Tml4ZGV1LzVwdFMrQWE1YjR1eFBKUGJvTk1lTFFF?=
 =?utf-8?B?SFVCUmM4bXBuSGVoVC8rMjROYnExTm5oVzVUVndwWFdCdzgrc1ZwUDhaUEF0?=
 =?utf-8?B?Tm8yeEtNNkZUZ1ZZZTdsaXhPT0NEZFpvL3dVS2YvWmRrV3JHd01kMVpyQWVx?=
 =?utf-8?B?VnNIRjJ5cnNKdzdtbG5pYlZ5dHdPMEJ1RnRDS3R1Q21nMVlYb3IrZmw3WjdT?=
 =?utf-8?B?aEFuWForRzcxRForMlhnTTN2cjdQdE1SUmM5dmlndklrMmgzRDBYQ3ZHeEsr?=
 =?utf-8?B?VTgrZHQxdG96dFNoNWc1eW9WdEo3T3pDWk1VYlJYcFQ2dWNSTXlNb2FXRWZp?=
 =?utf-8?B?aWdhV0tlVEU5OE53Sk5Kak9GQ3E3NE96VkxNMGcrMW4rQzRSN0p5K1BRdjhR?=
 =?utf-8?B?c244RmRDbldJZFZIUGFyMVV6NmI4cm9NbVhBaGRtcXF6SlQrclVFTHV3OXFu?=
 =?utf-8?B?a0Yvb21jcGUyNWtNb1hNZlpEOU5hSmJWWHZxenl1VGlXMjZha2svdzl0WXpj?=
 =?utf-8?B?RlIrajA3LzJMaHFJOUxlaTNkNitrSlRhUFVlSEJSQ09DZFFyeEI2S0VsRG9o?=
 =?utf-8?B?TEJRdTRNdS9uS0xRS01kbVN5eVZwVEh6Tk5CYkE4WGpFTXVwSlBQOTU3aUVO?=
 =?utf-8?B?VU4vdHNIZlFFRzhCckFQb2MxNm16c2pjSlBxNkxQWm9tL2lpMmxBVS9ORkxr?=
 =?utf-8?B?VDlGMkxISjZUa2FiQmViWFlKM2hxdjREcXdQaStGbnRqRlV5aUdKT0ppSXh2?=
 =?utf-8?B?ZGVQR1BNWmNVbUIvRHBDOU8zWE1RdEVwTUxGY1lrZzdrbHZiNjhpazU4dlll?=
 =?utf-8?B?NzlydnRkK2c1UWREcS9YN3pmUklrOGhzRUhOTkJIejEyWWkvbWtmeGFwdXVC?=
 =?utf-8?B?WFRXSkh5b1ZkZEJ5cWRDY2ovQ3psL3YwTVdaVjFhbFFhaEFkaUJKbVlNNGgy?=
 =?utf-8?B?ekpJN2pUNksrRjdmLzdSdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2B239216F9DD9044984BF03D07576042@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1989.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cf3d031-fc70-4bbf-1e95-08d9105b451d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2021 06:50:43.3372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t3D7EH16M8dUc913AynIpvLtjhRc81J0mAOaKP5T/wFdAtyEw1CP54dBfdDVM2/Y3qgvTZMYeUE/MPvDKywLYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1255
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9975 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105060044
X-Proofpoint-GUID: r8BFfnsOh3VB6Jiag0IBuoV9Ky9vzEhh
X-Proofpoint-ORIG-GUID: r8BFfnsOh3VB6Jiag0IBuoV9Ky9vzEhh
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9975 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 malwarescore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2105060044
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U29ycnkgZm9yIHRoZSBkZWxheS4NCg0KDQo+IE9uIDIwIEFwciAyMDIxLCBhdCAyMjoxMCwgR3Vz
dGF2byBBLiBSLiBTaWx2YSA8Z3VzdGF2b0BlbWJlZGRlZG9yLmNvbT4gd3JvdGU6DQo+IA0KPiBI
aSBhbGwsDQo+IA0KPiBGcmllbmRseSBwaW5nOiB3aG8gY2FuIHRha2UgdGhpcywgcGxlYXNlPw0K
PiANCj4gVGhhbmtzDQo+IC0tDQo+IEd1c3Rhdm8NCj4gDQo+IE9uIDMvNS8yMSAwMzowNiwgR3Vz
dGF2byBBLiBSLiBTaWx2YSB3cm90ZToNCj4+IEluIHByZXBhcmF0aW9uIHRvIGVuYWJsZSAtV2lt
cGxpY2l0LWZhbGx0aHJvdWdoIGZvciBDbGFuZywgZml4IG11bHRpcGxlDQo+PiB3YXJuaW5ncyBi
eSBleHBsaWNpdGx5IGFkZGluZyBtdWx0aXBsZSBicmVhayBzdGF0ZW1lbnRzIGluc3RlYWQgb2YN
Cj4+IGxldHRpbmcgdGhlIGNvZGUgZmFsbCB0aHJvdWdoIHRvIHRoZSBuZXh0IGNhc2UuDQo+PiAN
Cj4+IExpbms6IGh0dHBzOi8vZ2l0aHViLmNvbS9LU1BQL2xpbnV4L2lzc3Vlcy8xMTUNCj4+IFNp
Z25lZC1vZmYtYnk6IEd1c3Rhdm8gQS4gUi4gU2lsdmEgPGd1c3Rhdm9hcnNAa2VybmVsLm9yZz4N
Cg0KUmV2aWV3ZWQtYnk6IEjDpWtvbiBCdWdnZSA8aGFha29uLmJ1Z2dlQG9yYWNsZS5jb20+DQoN
Cg0KVGh4cywgSMOla29uDQoNCg0KPj4gLS0tDQo+PiBuZXQvcmRzL3RjcF9jb25uZWN0LmMgfCAx
ICsNCj4+IG5ldC9yZHMvdGhyZWFkcy5jICAgICB8IDIgKysNCj4+IDIgZmlsZXMgY2hhbmdlZCwg
MyBpbnNlcnRpb25zKCspDQo+PiANCj4+IGRpZmYgLS1naXQgYS9uZXQvcmRzL3RjcF9jb25uZWN0
LmMgYi9uZXQvcmRzL3RjcF9jb25uZWN0LmMNCj4+IGluZGV4IDRlNjQ1OTgxNzZiMC4uNTQ2MWQ3
N2ZmZjRmIDEwMDY0NA0KPj4gLS0tIGEvbmV0L3Jkcy90Y3BfY29ubmVjdC5jDQo+PiArKysgYi9u
ZXQvcmRzL3RjcF9jb25uZWN0LmMNCj4+IEBAIC03OCw2ICs3OCw3IEBAIHZvaWQgcmRzX3RjcF9z
dGF0ZV9jaGFuZ2Uoc3RydWN0IHNvY2sgKnNrKQ0KPj4gCWNhc2UgVENQX0NMT1NFX1dBSVQ6DQo+
PiAJY2FzZSBUQ1BfQ0xPU0U6DQo+PiAJCXJkc19jb25uX3BhdGhfZHJvcChjcCwgZmFsc2UpOw0K
Pj4gKwkJYnJlYWs7DQo+PiAJZGVmYXVsdDoNCj4+IAkJYnJlYWs7DQo+PiAJfQ0KPj4gZGlmZiAt
LWdpdCBhL25ldC9yZHMvdGhyZWFkcy5jIGIvbmV0L3Jkcy90aHJlYWRzLmMNCj4+IGluZGV4IDMy
ZGM1MGYwYTMwMy4uMWY0MjRjYmZjYmI0IDEwMDY0NA0KPj4gLS0tIGEvbmV0L3Jkcy90aHJlYWRz
LmMNCj4+ICsrKyBiL25ldC9yZHMvdGhyZWFkcy5jDQo+PiBAQCAtMjA4LDYgKzIwOCw3IEBAIHZv
aWQgcmRzX3NlbmRfd29ya2VyKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCj4+IAkJY2FzZSAt
RU5PTUVNOg0KPj4gCQkJcmRzX3N0YXRzX2luYyhzX3NlbmRfZGVsYXllZF9yZXRyeSk7DQo+PiAJ
CQlxdWV1ZV9kZWxheWVkX3dvcmsocmRzX3dxLCAmY3AtPmNwX3NlbmRfdywgMik7DQo+PiArCQkJ
YnJlYWs7DQo+PiAJCWRlZmF1bHQ6DQo+PiAJCQlicmVhazsNCj4+IAkJfQ0KPj4gQEAgLTIzMiw2
ICsyMzMsNyBAQCB2b2lkIHJkc19yZWN2X3dvcmtlcihzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmsp
DQo+PiAJCWNhc2UgLUVOT01FTToNCj4+IAkJCXJkc19zdGF0c19pbmMoc19yZWN2X2RlbGF5ZWRf
cmV0cnkpOw0KPj4gCQkJcXVldWVfZGVsYXllZF93b3JrKHJkc193cSwgJmNwLT5jcF9yZWN2X3cs
IDIpOw0KPj4gKwkJCWJyZWFrOw0KPj4gCQlkZWZhdWx0Og0KPj4gCQkJYnJlYWs7DQo+PiAJCX0N
Cj4+IA0KDQo=
