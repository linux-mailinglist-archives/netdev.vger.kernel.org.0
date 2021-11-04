Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE8A444E5A
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 06:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhKDF3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 01:29:01 -0400
Received: from mail-sn1anam02on2056.outbound.protection.outlook.com ([40.107.96.56]:60262
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229824AbhKDF3A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 01:29:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OTR5TnUKfZGXqUwlCuN8jseUeIto5gEQCz2WDlKyprCWoaxJrRTdwwDSlA8+SjzrzbufkAT5JJ9hxLEG8125avnB5woWDBH+B2Bc+NBIK9ODOIw3208DqCaoBWw6CS2J3MQ/Id6nh80u9lmdXzQEkreBc4uWi5qmeNqpGFrss9jqcbKvxdasm7zTMtUezNlbq5Km0/NYiZNRbyJaqcmOHipRhap7ig8XvTC/zSfLe+nyjBoLxPGkreiaxSuBIcM1Hv8wndgWceXVP6bhMNnQ7RVnlzSflhosK98iEXG8kXqhDyphSCFUklOzpY0Sr4494NTUZ/RuqXvYzEd3BevPLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XL3wuMj3Qtk9kKxxOW7uxtJZEeGq7oFHAuM3l4H7AaY=;
 b=jMx5EZ2gl7lL0Z/qQCbqzirzF3/be0mViuhHpQuu1Wth3Q2lJCYL643r0Tc/GlkSzee/rb9bV54VsQ5F1vVLvEW5vDF7j9xwxyXQ1KgZ9I68ZImNa7zghXWOchstrg9Zo2paNLyGHJqhGQNfgwTahKigUVoTZozQRj8iTiGWffyf2P8lNCIOl3O5nBdDVqfYl+U9YDEXuB2JoN23/4/wD8kToKM507NEL5rI7gKJZAqIk/QkhDgktO37huAC/oq1ei+JIA7uq33L/1hRVZ2+cOHDVElsSoCCMjOMUvgwsAtqb7aWyAFvWQDO8iKg45GCq4WZnRAExcephMzBFv4KMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XL3wuMj3Qtk9kKxxOW7uxtJZEeGq7oFHAuM3l4H7AaY=;
 b=XwHehhYGtfWHzZPABtsLfOvM+LQH2MeY0gWZc2udq6EG7IY/6hJyhefJoRG6IVrzQL+W+IikkWhogXCScPW1MPep3UhySIXwuc+5P72HUgC6UwEZBGsGOBE0DrlyvQubH7SZ29E1JEaKZUk34AR/4o3NNhPBM79GhppZ8PXVd/2bEHcRbtriXfE40FjwR7bGuhO+JfXyYyrqKryUQVerLSxZOnJ2TAPHZxcT1pEzBBGJWpjGoC7HTR4sQzXSDVfwfCZvyAIRw8FVR7bKMBtNE3/tRlDEQx9KOQnatq7fPseFr7F17J6EQRFjRU4Bdgdlqi2IJGs2Pb7QXr2n9vXOcA==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB4598.namprd12.prod.outlook.com (2603:10b6:a03:10d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17; Thu, 4 Nov
 2021 05:26:21 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034%7]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 05:26:21 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "davidcomponentone@gmail.com" <davidcomponentone@gmail.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "zealci@zte.com.cn" <zealci@zte.com.cn>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mi <cmi@nvidia.com>, "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>, Oz Shlomo <ozsh@nvidia.com>,
        "yang.guang5@zte.com.cn" <yang.guang5@zte.com.cn>
Subject: Re: [PATCH] net/mlx5: use swap() to make code cleaner
Thread-Topic: [PATCH] net/mlx5: use swap() to make code cleaner
Thread-Index: AQHX0RnMjnbed+9b5kWJ8gjf9VlaXKvy1sqA
Date:   Thu, 4 Nov 2021 05:26:21 +0000
Message-ID: <0145f58f83c902b641d1d09ce0e53f6cb94d8aa3.camel@nvidia.com>
References: <20211104011737.1028163-1-yang.guang5@zte.com.cn>
In-Reply-To: <20211104011737.1028163-1-yang.guang5@zte.com.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87f5cedd-d278-42f4-e097-08d99f53a2f0
x-ms-traffictypediagnostic: BYAPR12MB4598:
x-microsoft-antispam-prvs: <BYAPR12MB45986C9CDFF41FE49489BC0EB38D9@BYAPR12MB4598.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gyuXYgSPZj7hgdbRqsoHxVtEN0VH1U9u8Zr6iWr5jjvvVEQG/6gtXYlH6uuinmKbuLkwB9TEbtit7nHUUgwKzmNewEFDGCKu8Ybj4fOLApBL3k04GgCPNpo/lFudQIYjfrm73cp4dYZrJQflWFmdqctNBWjccwj2ayfeH7T5KEwfhAV0/ZBph1J8gOjckpZ9M0S99MckpEl7w910fP2ownrBfmqit5yCZSEfDn2qfNdJ5YjCHypXri5k7LOKnH3Drky5hsNIZtWe9w53Pv97jIKjmunLEW3M5YzIj99FNpxOitifz/iZjEWeC9u9xUyziyb7jKouqR/WxCHkEG8TcF/N21B2w7X5rRO1qEH+ZzLi0wKwyoVIHhIHHG0x05wMXXO/+pDXt8XjpqXyz37X91NFN8zs14TNulpxwYoAb28JFcCN6iShcfQdHWLii7lV1TCbt23jVCLdqyowykL9kS1TrF0LIYD1yUr0+0tc+fQOwGM1arrGqnVCVDyfMBosrcHdA+L8rrM+MW4b/r5LAkGENd3OHfDuJFgm7YVSXgGFJxe1LG6pH2lUfJRSt+w1oOBv6QWCfmbJvkQfExG8AER5q8Yb3m8TskL8zrrXLlOi+Bsi7agC373bfU8oilAcBgUw0k9A64j0JAFRJFD4EgRnF2fez5Qx6oHjBW4az4R5wkW3uto1gN6OJCd8CZsBCzoOKvBiYPYHXKT/oU8L8Ral8Y/0doEs5XioafcuNg7Lghh7BmaY5JN15I3/6UOnxosFMnlv+k6Z+pmCtFoMxMTpF2werWSJCrkDITjng+s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66946007)(8936002)(66446008)(64756008)(66556008)(38070700005)(76116006)(8676002)(6486002)(71200400001)(6916009)(5660300002)(86362001)(54906003)(316002)(26005)(4326008)(6506007)(2906002)(4744005)(186003)(508600001)(2616005)(6512007)(36756003)(122000001)(38100700002)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bUViUkFmQzd6UlM4cnJHZ3plSmp1ZE9xVnlsZjVvbXBaSXowVlNJSHBWb2tU?=
 =?utf-8?B?dGJOZTUvemVyWEhEZHVYQVBpcEtqVm5WL0dLTm1JN3RwMmlwRVVKZzhnTTQ5?=
 =?utf-8?B?aEFmeEg5N1FQcGVteTloZmRyanFoR2Y3aDB1aWRWS3Y5a2lYekhvTVBLODBt?=
 =?utf-8?B?RjUvbi9Pc0p0c2IxK25Nc2hDNm4xZmVqeUJVeFJSZytYT1Bxaml0ZHB3SjFE?=
 =?utf-8?B?UWNpV090OWNKSG5VbzVoMnFIRG9SRkxmQWcwSDdHZGMwdU9jRGRWRHp5UVQ2?=
 =?utf-8?B?cjlTbXZ3RXlpYVRvK1pZbENQTTZZVUQwZ3c4b2xvTmtTVExNdlU2TDhhRFkr?=
 =?utf-8?B?WExUVXgrbHRhenJYQXRUR3VsTUNFYStPVDRZRzkvWlpqZVAvdFZIQUlEQ2li?=
 =?utf-8?B?MXVMVm9IL3FPR0ZHaGNJVXlJNGFHK283ZGJQaHdNVVYvZkxDZDFxQ0RLLzZu?=
 =?utf-8?B?SU04bitPRWdiUVhQbDVoVDFVMWNTRlJWN01HZ1kyeEJUSUNDM0xHTlIxV3Np?=
 =?utf-8?B?U1FKWG5weHYraHltRk9ITHduMUFhYnhmWjlZTzVLVFl3c0Y4aVk5dGZaaVgr?=
 =?utf-8?B?VFVWeEdNd1JmZkJOWjVHYm9XNERzY0FXWVhMZThkMkxEZjEwd0F4bUdqNEhk?=
 =?utf-8?B?RE5icitaZ0NwNzY2UDE0NFpTVjFWT2hicXo2TG92dENiMGxvSkRNaDN6TmpM?=
 =?utf-8?B?aEowSGNKREFWNWEwbm1ZTzkvK2czdzFEaHB3NWJIa3E0NnBKYTd0L3Z1YkhT?=
 =?utf-8?B?MCtXWlBPYWxwMkoxYnJ3a2VFUzR0amU2bDRkRmxNRkhpVE9sR1VxaTMvTCta?=
 =?utf-8?B?MnoySkxXdmhCWUY2dTBEeG5RQ29aMUxOeWZFeGIvVm51bk9PVkFRS2hCbjV1?=
 =?utf-8?B?NjJGaUd5aWdwVW5HTThBUFI1aFNSR2xRb2I2bFZSTU5CSWlaYzFESDR3QzAz?=
 =?utf-8?B?QWp6NjN1NzJja3U3NG0wdFlSeWN3VWozanJEbDc2SXh0NkxmWVRpV2FqcDA1?=
 =?utf-8?B?UVRyNXFxeGV2QmowY0pKT3dyNno3bzQ2Ly9PSEhTNTlyTE1zd3oxMEZ6N3Zi?=
 =?utf-8?B?TEU4VW1IdHkyNEhNc25Cc1ZVUytZY0REUEVaRXJMa0VDQjVtLy96TXJyalhR?=
 =?utf-8?B?ZmkxMHAwWEljS3AzVVI5UFNiWHdUa0tndXlnMG50RUFpSExkQWpIZE5KR0VO?=
 =?utf-8?B?dkg5c1NPK04zandJMEFHVFZmbFFRTHFWNnVFd0FNeTR4OEMrY2VmNFRrUUk1?=
 =?utf-8?B?YTlNS2dzcUQ0allneVpabjlVbXU2RVgwN1dYdVBITVBNcVJBb3Y4dVpnWFJS?=
 =?utf-8?B?SjlocDNGY2U5VjZFQWtEcHUySUk5aGNWYi82ZlUzOFE4SHZuc016UVhWeFpO?=
 =?utf-8?B?a0hSZUdDTTFVSUhOQ0RFSXBXb0FGWThxTW1TWjVUZGdqN2ZDVEorQnRmaEVV?=
 =?utf-8?B?OUN4R2toOWE3TzRZUXBDdW9ma2ZMVjhQd0VwT2NQSkZhakZ1MFFmUGxlbUJN?=
 =?utf-8?B?a3UzM3Bxamw5ZGxCWmtqUGpsYWNsZWhwc2xJK1dhR0p3RXdhdncvdWRpSHdV?=
 =?utf-8?B?Nm9VanhORDdWdEl6VE1NWGR4V3U3TG0wZ3BCVmxpVXFxN0xxb3VEV1NtcW5Q?=
 =?utf-8?B?UU5FYzFOWTBmalByRktoOGtybVBNZTJiYWtiaWt4YkpOQUd4WGlJR29FdFJT?=
 =?utf-8?B?T0dwVkhSNnp5Smt5ekIyZnRGdjFyVVRJcWFnUTJzbmRQc29LUlJRZTdyc1Q1?=
 =?utf-8?B?SG5qZ0h5WkM4TVk1WU1MazNKVVdZS1VDYUJFVWtIOTR2NSsxSWRNKzdwN05t?=
 =?utf-8?B?QVBWVjVqTTN6YWNLeWFnMmZ6RTNDaTdZVkcrcitkdUJ2eGUwRjNhQ050UFNm?=
 =?utf-8?B?UkZoRG1LNmxES1JoMUFBRjE1MlFrUk5sa0JkTS9pZEIydGM3bnFaSjkyVFlw?=
 =?utf-8?B?L0FlZDFiS1NRZ3RxSCtmYzJ3NmFXd3dad2VvK2hOSVZsbjcxdWYwRjhJaEJO?=
 =?utf-8?B?bDgvTTBrbHA1YUkvUVp0UU1XeDZ0UTFPdkxaSGQ5Vm1UR09UcWZ0TDJIMDQv?=
 =?utf-8?B?eDVlMy90Z3JSWVRzUGRjZndWZzNGZVJwQ0dESHR4b0tTa01vN1BXWCtlNUth?=
 =?utf-8?B?eTZBMlZsTXNRSkx6T2RqU0h5ckRZTTIyRXVpMlcyR2xhNUdiRFczK2czWnJn?=
 =?utf-8?Q?spzUfD0M1hemuJGiIgX+H3E=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D182B02C8CBFA14593EF9CC9CD6A6299@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87f5cedd-d278-42f4-e097-08d99f53a2f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 05:26:21.3835
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A4tZ1dl8uCa/AXgSO2bgE1U2mPxf3nMjVczATDGyAQvo6zbLQ7o6QHadFf4zxJL35nUEWHw+DgezgjknikOxAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4598
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTExLTA0IGF0IDA5OjE3ICswODAwLCBkYXZpZGNvbXBvbmVudG9uZUBnbWFp
bC5jb20gd3JvdGU6DQo+IEZyb206IFlhbmcgR3VhbmcgPHlhbmcuZ3Vhbmc1QHp0ZS5jb20uY24+
DQo+IA0KPiBVc2UgdGhlIG1hY3JvICdzd2FwKCknIGRlZmluZWQgaW4gJ2luY2x1ZGUvbGludXgv
bWlubWF4LmgnIHRvIGF2b2lkDQo+IG9wZW5jb2RpbmcgaXQuDQo+IA0KPiBSZXBvcnRlZC1ieTog
WmVhbCBSb2JvdCA8emVhbGNpQHp0ZS5jb20uY24+DQo+IFNpZ25lZC1vZmYtYnk6IFlhbmcgR3Vh
bmcgPHlhbmcuZ3Vhbmc1QHp0ZS5jb20uY24+DQoNCnNvcnJ5IHlvdSdyZSB0b28gbGF0ZSwgYW5v
dGhlciBwYXRjaCB3YXMgYWxyZWFkeSBzdWJtaXR0ZWQ6DQpodHRwczovL3BhdGNod29yay5rZXJu
ZWwub3JnL3Byb2plY3QvbmV0ZGV2YnBmL3BhdGNoLzIwMjExMTAzMDYyMTExLjMyODYtMS1oYW55
aWhhb0B2aXZvLmNvbS8NCg0K
