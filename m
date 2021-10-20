Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E8243520D
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhJTR5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:57:14 -0400
Received: from mail-bn8nam12on2075.outbound.protection.outlook.com ([40.107.237.75]:28513
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230073AbhJTR5M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 13:57:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ww914AA/mH1N+WY+3YMOPBPz5S+fEmv9mLM2cNyMoj4ammCtNRhl9TahmyKZKp2KSqqnXNjRd7B3srrJzxIks97X0WMQhFa3eYq6zf1fHDijm/E610YyPZgjt0BBy+nWmBFMRVuCCn7HZMlZOAVwRdfto6fRHLkEPSEMQrGDgxb0N1RlsktxIO1xDE6ksIZFQeNxNVp7W/DOyimBlwHGRhwdtwSpFRA+Nk8Eu514e6cCzZMB1+04IEhqgirs0z+WPFxpgUHwWzJUqD/vIpS/U+ff9sEPyX8NRUnoBA2JQCvbAJ3QD+DsQS0HWOrTfdvb19Re85m9qEGUCFSi7cE3RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ioPOQNAN24mobj/ApYeuiqHtiymIIaIYUSlYCA+/7JY=;
 b=WRlXHKm+i258kyyVb8857CFeYQd6zp7Xf/th2gXnXBvgrDRoZe2hQdbtqG9f3hmO0NHJMeIZ+LcOPb4dccmN/N4tYRulaIjpdgmzTqUUwIjOIiVbZuqyEFOPyTfYJ4fMzhXV+iA3lBktw0SnVkKPYypKgOm0gZn1ibq8HOb/sLv/lESvARJJGqIhiHDRcFmpImfcZkpyb+1ddhlaBFcPZvBg5ONiswRObBMToypLgjv+mvGpo4Xmx7hPJ1v24WM6V8DG/KJMxFAWUFIfwgHOtJalU0Gg6bgNu7G7xZpNNnP5UVuSNbz9wLvfzvzmio0PhCfH6up10XiSKmwUTOE63g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ioPOQNAN24mobj/ApYeuiqHtiymIIaIYUSlYCA+/7JY=;
 b=JHGKcSlZ5XioxpVYNQQzcXtmVEgMW9I3W89Dq0QpK6eTqw4/7IOCovavla/lZGvON6CESSvctWnqxqltUm1N3iB2ToIsGfqxVtjrht71DUfQRvIjKt5lxQJh9Z3TaYGrU+Y3lb0v/doZOo/qXuEh9R+W50C7R2mKT9APQth0PICoA1r3HtilxfweNJibpCoGXUHKuTCm/CSHQhwLcgKX03HAEQxrx1wfH+C2cL0I8jjZC3C2vJ4fE8nydLTgEMgsFEeRD04wAr3zRcNa8YtCzNNfSNhaJTlZmXAIkcF9DdUv18HaObQbP1oAysvvnCW85OIYFp53F7GPwj7PA/qg+w==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4082.namprd12.prod.outlook.com (2603:10b6:a03:212::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 17:54:56 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034%7]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 17:54:56 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] mlx5: don't write directly to netdev->dev_addr
Thread-Topic: [PATCH] mlx5: don't write directly to netdev->dev_addr
Thread-Index: AQHXwG+3Pg2pxab7TUCLiBqah0gv/avcNk6A
Date:   Wed, 20 Oct 2021 17:54:56 +0000
Message-ID: <d11a744067a3481c37d013a1f770af9b761dd57f.camel@nvidia.com>
References: <20211013202001.311183-1-kuba@kernel.org>
In-Reply-To: <20211013202001.311183-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d768d6e9-c2e2-4967-5702-08d993f2ba42
x-ms-traffictypediagnostic: BY5PR12MB4082:
x-microsoft-antispam-prvs: <BY5PR12MB4082014D0295060321255B9EB3BE9@BY5PR12MB4082.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SqSUz3PdcRQHNeARYpACULF5wU4VPoxCk4Mxf6BvmgwszKch6fjBtW+5snjagnBJ5LDeRUAUwd6sAYk5rrzRyyK1wlHqNP386aWbRuNY9BE84gW9Al6zflvlm27TN+AOynmWvk7ZJ/FsH3OoVqP+8PayjJePyhycKHJOlyoLHwAyaPC1ki7bNmw67dzrlDFcorEswj3k6HUX6crYK0Q5mcPp1qqKYqa0ZxlAsv7Rial8DqKmSKxMLLJzWyRWQ7l8aPN4YpLB0qWheTYE0UFMvJlr8M9XowLPIvhDusWKzCfZvIogzxOXqxLbCayR/azLO+JYE1DtdvU/hMjJDlpqK0q8om75nAisXYZ+tM2+hBwdJG4COh8CUEbwcIQYnIGnS5ZOkfdq2az+RDDQXH30ir023eJosOiugSZFcIsCIBy4EvRL9HrM716A5pihoXu3MmiLPxA2L2r8976MLMn8ixRIcoCqfX6GdRNVsZ3OR0q9LVoShnTe8kcOjwMi1CByOyEWTGDWwUU9+1flzDDUWThWxe9EBJg+lAsiPyi9bqVwS2b5j4pWMaIsVbfp5WxisxO/ZLxCvtOmqCCoJIQQd4Zfx/Vz/135YUtOVY5W4XZjlkaUeCY2+A9+/1yCjuJn8mZQeuPmou9XpVyLwPTHIE2tO7BSlH7F5J+sw4KmACnnXqiDOi05i4LsBzSt9kVYyckvrNHt3ob47vYDQZotKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(4001150100001)(71200400001)(6486002)(2906002)(4326008)(508600001)(4744005)(66556008)(66946007)(316002)(66446008)(6506007)(64756008)(66476007)(6916009)(76116006)(38070700005)(38100700002)(5660300002)(122000001)(86362001)(6512007)(186003)(2616005)(8676002)(36756003)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TVNZNUprMkpidWZudlVVaVM4WjJ6MDAxeEVieDN0aU5keS9oOTROODFab0Uv?=
 =?utf-8?B?WlBOZUZIdkJoK1VteWcwRGo5N1FTNkhEOWJ0dnlIejBZWnhpcFNTWmMwV01H?=
 =?utf-8?B?YnNjTUFJaW5RYUhYOFhJWHRKQ0t3T213NWVmOE9YUVVOU0x0ZS9sOFhVZ2wx?=
 =?utf-8?B?U0JaUjY5ZmdOQzQ0WTJ5YzlvUCtLTHVldW9tUXczcDNLWnVleWU1bmJhd0FN?=
 =?utf-8?B?MUhyV3EzWVA1ZldDa1liN2ZRYWtUNG5JK2xnYndlei94aVBRNXM5cCtRVVFE?=
 =?utf-8?B?WTBjT3pXYWJsSTFMUXcraFRZdERWT2RZa0JZVllpcE1RT3QxaTNlcUZXVE5j?=
 =?utf-8?B?MS9jVTZ1VWw5amJKWEZYSWhtWUQzWDRrUGt4alkvV3lQUEJoNEl4UE1DNEQ1?=
 =?utf-8?B?V2JXR2ZSMDIrbC9VVUUzWkxIbUliQi93eUcwcFlhNnZHMUNEUDlwb1g2VU8v?=
 =?utf-8?B?VEhWY05leE90Z0ZOWml4QkJ0RkpTdWxjY0E2aXRVVnRnWFJjbjVWcUNMY0Mz?=
 =?utf-8?B?Ykk0bmpCTFlaZnA1TW5TUG5iaE1uM1hrZkEyaTgzWmNzNnNjMFd3MDVOZkwv?=
 =?utf-8?B?ZDV2NllKb3FTQ3BHKzFFZW9EbnNEaHhkZFhta3BRK01uakxBT09DeGROV3hN?=
 =?utf-8?B?ejc5QzBXWVJ3RnZrZzZFVjRkRWcrcjgrSHJLZGIrem1adjk3VlkzVXhtNU4z?=
 =?utf-8?B?U3RBSmlSbGwxd3o1NUJkZDVDYzBIcVcvcEdHTmNwOEtndzhTMHJPZnMxaFNa?=
 =?utf-8?B?eUt4MWNJQnRQWlkyem1CTGx6WlI1M3o3ajBiYkdFQkd1cGNmUmNodEw2T3NO?=
 =?utf-8?B?MkN2N3J6YTVybUdBQjBpNDBGdUg5NFBBTHdtOEg1VFhZOWRsYmJVeGFxbFZ2?=
 =?utf-8?B?YURFZDJlOUJCQWVNVGJyVGNSenZObzVOLzZpTUMrQ3hOR0I4M1h2REdZdUUx?=
 =?utf-8?B?SlRma3Rhak5HQktZSGV2dzJJN1pxTzJieHFJcW16Sm05SXVoTmw2OTRxTzVR?=
 =?utf-8?B?RVdKQm1WVjh5MThRRXJrNmxtRzR5MHJya1R5bHZmL2dOR1poRzVhVFBXMDFx?=
 =?utf-8?B?czVoL3lDSWRYcEFKVXgxYnpPVTJGbHlOOWdXblJsQXRTdzF5Z25mbkxCakFY?=
 =?utf-8?B?a2laeGNtOUlTTWY2eFQ0RDFhQXRnZEFFdmdkSExvYVJNVXBWK0R1SUJJNklS?=
 =?utf-8?B?cmlsa2dJL2gvRlc5MlNwYk1MR1JjZFZJcnRMR3kzNjJ1Wkx5d1lsREZmTGVL?=
 =?utf-8?B?UVhkc1JGa0dKQzBJd3NWUURNcGJPbUFsZCttMVBZOFpvdUc5a1ZoT3c3VG9y?=
 =?utf-8?B?N094WnBndFVDWWpsUlNkOFJyMzd1NWw1YlRKQUlJVVRkbWhtRDVrMWxNVUdy?=
 =?utf-8?B?dVVMeGdzUkRRYi9mRHk3ZjNhcU93SHF6YUgvbUtwRFhubkUvS3VvKzdEeTBI?=
 =?utf-8?B?dFUwK01JbWxpT2lwY0xVVjc3UGpBaDB2eG0xdDRRWnBQYmJJa29KbmxPUXFD?=
 =?utf-8?B?Lzg5dXlMUzNXd1p4TXdKNENFWVIxalE3M0VjSStRR3JpZThldXVFaUptdkFo?=
 =?utf-8?B?Mlp6ZTUxaTF2cjNNSFIzQ2R0R0FzS2F5VUdjUEp5YzhYWitzajJEL09HWG1h?=
 =?utf-8?B?Q1A2T2c2TjQ5aXlsSHlUSlcyMS9rU21jUDF5K0JvSy9RcUErSVlLdk5VZkRs?=
 =?utf-8?B?blYrN01lcmo0VFhURTMxdnVpZ2lDN1FNMEUvRkZGc1l4YlZPTjlRa0c1YjBB?=
 =?utf-8?B?M3pNdEc1ZkQ1cjlJc3lRdEkrOEFqNVowMUZ0bVZ0MW1sTXpQSjFMOFdoL0ZK?=
 =?utf-8?B?MFVOVW1nVUs1WGY1VjRzU0h0WDhZVTBWT25mVS82UU91T3R0NG1nODNndjFz?=
 =?utf-8?B?UFA0UVlFV3BRYW1zbUtXMmZNR0dqcmU4eDEyeVRqZ1NUdVhqK1JFWnkzNEFJ?=
 =?utf-8?Q?QYudrRg3FNpWfL3ixtjkBTACGBGVtOnH?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <44E58A9E82CEAE4CABA1E84DE6925A30@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d768d6e9-c2e2-4967-5702-08d993f2ba42
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2021 17:54:56.4739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@nvidia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTEwLTEzIGF0IDEzOjIwIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gVXNlIGEgbG9jYWwgYnVmZmVyIGFuZCBldGhfaHdfYWRkcl9zZXQoKS4NCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+DQo+IC0tLQ0KPiBUaGlz
IHRha2VzIGNhcmUgb2YgRXRoZXJuZXQsIG1seDUvY29yZS9pcG9pYi9pcG9pYi5jDQo+IHdpbGwg
YmUgY2hhbmdlZCBhcyBwYXJ0IG9mIGFsbCB0aGUgSUIgY29udmVyc2lvbnMuDQo+IA0KDQpIaSBK
YWt1YiwgDQoNCnRoZSBwYXRjaCBsb29rcyBmaW5lLCBpIHdpbGwgdGFrZSBpdCBkaXJlY3RseSB0
byBuZXQtbmV4dC1tbHg1LA0KDQpJIGRpZG4ndCBnZXQgdGhlIHBhcnQgYWJvdXQgSUIgY29udmVy
c2lvbnMsIHdoZXJlIGNhbiBpIGZpbmQgdGhhdCA/DQoNCg0KDQo=
