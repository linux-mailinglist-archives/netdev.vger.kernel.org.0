Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB9048CF7B
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 00:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236373AbiALX5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 18:57:18 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:46011 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236243AbiALX4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 18:56:50 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CGT5tR010873;
        Wed, 12 Jan 2022 18:56:32 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2056.outbound.protection.outlook.com [104.47.61.56])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj2j2g7v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 18:56:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l2ECSjq07ZfOolUD9WVU/ahyXsJCZshhf53OmfwH20j4tVQ/ZB86kD2ezZisMogWGFtsn+owFYlxLrZWoeeEuk1sS84ZG+s/u9LvpX5E1OFFkH60LCD4HBxcas5FuUFC+XtOln7QF0N8ophQQZ1xJwrC+W1sh1cVq7hizO9oN2S4swxsFcogXGgumRd1mqW4Dn5o0OqgiV+ZX8ACl6Eecu/4OczMJTSuYHYyBzF6rhoVuaC1iXn02XXwSROAcFTU3Sr4Foja6I6si3zefSNzLmy4QWKw3he7esDu5PHTLhFHzwddQWefNlGNs8NucqaoEtFI422ZTdrYv96/6nh3rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ghZgax7TUEmEnSPLtB+E0Qxa4fS7rM46KlW1G67y3bo=;
 b=nHHJ/hTuQOc6WW5PkwKiEmYTJ8WT+NUnVvslfVgbgxNR3v1mIZKrnesXI4RTpEByd4LXPY5lV5oxzG/usOnvgNRTbKmjqaY6dcn0h9yAw2Axhjy71FCwlvhOjyRrUJ3IKGSCvOCX1BxkBIoLZVva75D10ooKyLPTLl/p0yuMut50n48vwWI9XZbrIg3vAOSMP+roh2OqnaoU9hOw2nWqjfcqImNVoXSThSyxAUmYUqB52C+Hfeoa5lKXLNP0XGFlcZ+MyTRVerLoF9ggXyFjszkK8aSEwqQjJyQ1MSbVoWxl31nhVNGuGfFtHMRlk3K0zcJdX2tqqw0b92Sd54sKwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghZgax7TUEmEnSPLtB+E0Qxa4fS7rM46KlW1G67y3bo=;
 b=qxa1Vqx068gqVTAP+GacVCthG9a4JVmDkGSSyc0hjPJeBvdzNyx7llIxNzJaTcUzTUOdVnxjbzhJwNTj+4qDmvqRSfWA1Tkf9ufmGlddrV8+Ux6/0JDBMLQ/7w5ORx/jiFg9tQzRyiqsa+LdUDlKPW1sex0/PvxCxUvROjSxaXg=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQBPR0101MB5364.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:47::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Wed, 12 Jan
 2022 23:56:30 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 23:56:30 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: phy: at803x: add fiber support
Thread-Topic: [PATCH net-next v2 2/3] net: phy: at803x: add fiber support
Thread-Index: AQHYBzXzLNXq90W5OkaZTaOCjzQdcaxegz4AgAAIwQCAAUCygIAAROuA
Date:   Wed, 12 Jan 2022 23:56:30 +0000
Message-ID: <3de186ef1c6a06cfe33f5ffe6ae3783d163e5f2c.camel@calian.com>
References: <20220111215504.2714643-1-robert.hancock@calian.com>
         <20220111215504.2714643-3-robert.hancock@calian.com>
         <Yd4cgGZ2tHzjBLqS@lunn.ch>
         <acb08860e200f94638663e48eb85565a41903fca.camel@calian.com>
         <Yd8w3a39GRDE7SUw@lunn.ch>
In-Reply-To: <Yd8w3a39GRDE7SUw@lunn.ch>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6343e3c8-3d7d-4e4f-6733-08d9d6272751
x-ms-traffictypediagnostic: YQBPR0101MB5364:EE_
x-microsoft-antispam-prvs: <YQBPR0101MB53642EB2C63AB8F75365405FEC529@YQBPR0101MB5364.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hl1WY8eppLKFNbguqyM+m8WG5v3xJhmRCjLuxKdieow/CbEAooaGJbC7GUDzPKNkBR05oak4P5YbMtnzUFCLCEFYJLrjWnfTJBYfwIlbl2Li2wd3YQN0AtMlQvq2vo1+gNSPjt6q7LddA/FTlgm5t/CJbdvse1AGMpVGOEUjo9EfEqdccCHFai7mrl71vct/xNSb0IbUTkRKRfhZR5gmqo5zPFBVKJnEoyyhYo7324unadL+ADIVlCL/51uKNsmxaj595wYHQz2rs3XoCQKKnu7AEBBtQKPRN/Z3PfpWG31pLL34jSJ6VPLTJ2hYxwjsCwoq2AakwI4NL0MVD7C8v9D0jxkErJTjpUvmAJtvZKwh5344n3odA4fm9lRZwy51r8x1BwIXdTHe0EM5/ql7FSPiB0NWINaR4ZXiM9WcbV79TfxqVwlNnjfpqSzX0v9vs4nhBct2JNDXAyAPCB1uWrNW5RLY0jVKe9wTKXGWk7swDXr2mtYrDz9wrflZ2gND2TUqK385QU61VXyciUmw06yAhXXrRzP0N5en1RjRIE1W5j4GsamcTtvs3gWHxoIwzbWDesQjx1hNpcXj25BzDx5a8+vFNnexBQwrC6V10qm/5zguXIeZH2XNKj4Kh0WOep1tRfRghlrF+RUVPVPVXb638xgFEkxmZUgAhGCsx+vtAxxOKrqM5Z1gTOthFqlasrQ37eFpCxbLxXaRB9sLfmQ5NtKUBIpPf60S8s20yX7a4GbFWd+/+TNJtH3XudGnEowHdRHftJJpqlSxqNbwAmumeDVf2KLP/NL01E9rgaAkYB7DVVMwUC/XQJtxxiLp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(2906002)(91956017)(76116006)(83380400001)(44832011)(6512007)(66946007)(36756003)(71200400001)(86362001)(8936002)(8676002)(4326008)(966005)(6916009)(64756008)(66556008)(508600001)(66446008)(6486002)(38070700005)(26005)(6506007)(186003)(122000001)(38100700002)(66476007)(54906003)(316002)(5660300002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V1ZkMnM5QXZ2MHJyQ2l1ZWZOZW1vQlg4N0VIazJyYTltOW9ocW1sS2F4QXBD?=
 =?utf-8?B?ekpPTDhXZVJtZkNJWmZjWC8zVUwrYk5HMVI3Vkd1M0toVHRIMEpDd0ZFZ1dR?=
 =?utf-8?B?U1F0eGhGd2pxR1gxd09KSEcyZUVhTS8xSHM4TlVObmxJSHFTUmtPSE1ESXRE?=
 =?utf-8?B?bkxXcHNoYk5QZEM3TlpNSXBGQllIRitFNUxxV0xoMFpFZ1doSThKSUx4SUF6?=
 =?utf-8?B?MVNRWkZHRG5qMjVpUk1DRlBoRnhIZXh2QmhRUkZGRmU4Q0dEU25td1FJMjlk?=
 =?utf-8?B?SjdGcVVBY2pHK1JLZklBWmdtVzViRnNoTG9pWW9rMCs5ZlNRNkkxT2ZnNmdw?=
 =?utf-8?B?WHQ4dG5WMGs5dXBjTndYRDE2blIzYzU2ZDUrQTkyWDNsbTJsb2Jodjh4Sjhi?=
 =?utf-8?B?NkRGZFQwTlR2OCtrSkpwK0FXbEFmMVlqZlIrMDVNalVKL294OWRVVFpPTm9o?=
 =?utf-8?B?QlNsTVRLR2wwYVlWcGJDaGdKQ0ZjU0N5KzRXdE9EVW9kUzZIMkxNaTV1R0dm?=
 =?utf-8?B?VlJDVkhUN2RnckhkeHB2Q3VuOWVJZ2QyaHF1SkU3N2c3SmQwa1RZSUluZWlH?=
 =?utf-8?B?NFY3K2YvdUtjTE10K2dNKzJZK3Y1c0hjbjNobVFIZTZ4UXY3LzFHSkk0aWM3?=
 =?utf-8?B?blJ3Q01UNURUUjBnNkJpMVpkdk5WVFpIY0FWK0hoQUJPUkxVYUJwRW0yUDJR?=
 =?utf-8?B?RWN5MGwxL2ZNN2Fna0JndlNDalRTTkF4RUt6c0hDSUdSQU5CNWtweE9WNTZX?=
 =?utf-8?B?SkJTSjNkSWl5clZYMitIOUgrR0VzQ0V4aytTTVR4MFZUSHVpT2NCLytWRzN5?=
 =?utf-8?B?U1NLYTZBMExDajlKQU56d0UrSTdEc21QVEYxK3FKQy9qUzdGdDkzQ1phUzhE?=
 =?utf-8?B?MmlmNXBLek1nakhlZkoyTDJjbDNkUWJhbUNMejlKdndsNHhrdENyUEZaRWxo?=
 =?utf-8?B?SkttY0FBK3Z6ZU5YN2RGSHFHcHVNMlFQaHErMGszd0pQNlVOMVNJSWdVaWd6?=
 =?utf-8?B?QlhLSHpQYWwwRHJxaDR0dWcxdFgwWUE5Q29vZGJpc2I5QlhqS3FWMW1qVzAz?=
 =?utf-8?B?bm9paGZoTERlaWwzMk1EV29OQVZNeTAvbWNWVjRJdkV5d3V0QzNhcmdQditL?=
 =?utf-8?B?UnJXS25wZWRFVWJ5amQ4dytzSWRxNmZrQlpDKzBrYVlWWEQxLy9Pbk9lbnZJ?=
 =?utf-8?B?OW5nZDNFb1gxZ0hkWjUwQXY1bG40dTRjMGxoNGtNMGcweXJyMzk1aU9DQ1dY?=
 =?utf-8?B?NzI0MUlWSTBSTFBJUmxOck5malZ5MXp0NTJ0eHJnZ29XK1J3a2FNaktZZkJC?=
 =?utf-8?B?RlVHZGJibFdWN0g5Z2tOdHFLelVVdnlvZDJTQVl1Tm1yTTgvWXBNampieXp3?=
 =?utf-8?B?anBnRjhneDV0U3NYcGlKMzcrb1YwQlp1K3paSVVqVUg1dXNXWE9hTGVoKzg5?=
 =?utf-8?B?aXJtOEkrOUdGaVRaOERjc2tTL0JOTng5eEVwQUhwTmF0N28ybllLbVY2Qk8v?=
 =?utf-8?B?NG4yaFBUYktlVEcrNXM0VGdWd0R6MDlmK3J1WU0zL2dQNzdvaGFpQVpCSEJE?=
 =?utf-8?B?Y0ZBdkx6c3Bnc1U0WVY5VG94NHFkYXR4aVA1cVhkMDlxTXhhWEFkQTdpcHk3?=
 =?utf-8?B?aUd2MGRUdVlzRHhsWUZDTUsyUXVGaHlvSGluNk54S3c4UEJJbmMvcmpOT2Q4?=
 =?utf-8?B?VFZOcDVYVEk2SFV4N1YvMTR1OXExNVFtTUZZWGc1enZYQ1RPbC9udi9IaE90?=
 =?utf-8?B?UHJlUG0wMjAxc1QrQUQrUU5MVHFNMXd6dmpUQ09nWmN5Z0lnMWQ1TmZWK2xz?=
 =?utf-8?B?OFF4TGwvQzFVdVIzSi9xdlRSaHFKY0RscWt1RmdwNlZnNDhxdVYwdGpRNnN2?=
 =?utf-8?B?Rzl5c0d0dEUxMUswYm9wRWVWSDVpU1NNNFM3VmlzblJ5QXIrUWFKQWZEREwx?=
 =?utf-8?B?aVFkblBBaXE4VmUvc3hFaEVQL1M3NzZuSitzQldUd0pVVFIraUdLNUJhamIw?=
 =?utf-8?B?L2M4QWtMMTBDT3BlVTZqSHhjbTBpV0JDaTQvOE85OUNPMTM5dzJLenlrOXpZ?=
 =?utf-8?B?VEswbGtVN0h0WVJjbE1zV2RsQTlidkxsbytmMHF2ZGd3ZjkxeVd4SmdkUWRw?=
 =?utf-8?B?ZEFlSWFSSE5XRDJMYjRvWURyV0FZTFJWTHF2OXhVK3VnMGJabTd3cFhEajZw?=
 =?utf-8?B?OTZ0RHprNlpEblRkK0hrQkU3cXRNVnIrbUhYT0ZKUlBIK2RLM3NWRDhyWXAy?=
 =?utf-8?Q?9ul3cs0QNsjaXJPBsY+kwwkMV69J4swQkGzFPYpxOg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5DFEFFB11FECC643816912F417B26FB2@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 6343e3c8-3d7d-4e4f-6733-08d9d6272751
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2022 23:56:30.0568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fsc/f6/YuVZqxjYXVt252vasZWWXYbnCSWxMb9BaOA2ZrtQEtE4+MVMV4dOKW7n0x53HHlM0x/3Ogvb3bHTNQoLctTP37kJrJDAgWeAwbUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB5364
X-Proofpoint-GUID: MV0iCc970KvRqa34sSUHfkO8KF6np-lZ
X-Proofpoint-ORIG-GUID: MV0iCc970KvRqa34sSUHfkO8KF6np-lZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120141
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTAxLTEyIGF0IDIwOjQ5ICswMTAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
T24gV2VkLCBKYW4gMTIsIDIwMjIgYXQgMTI6NDI6MDBBTSArMDAwMCwgUm9iZXJ0IEhhbmNvY2sg
d3JvdGU6DQo+ID4gT24gV2VkLCAyMDIyLTAxLTEyIGF0IDAxOjEwICswMTAwLCBBbmRyZXcgTHVu
biB3cm90ZToNCj4gPiA+ID4gICNkZWZpbmUgQVQ4MDNYX01PREVfQ0ZHX01BU0sJCQkweDBGDQo+
ID4gPiA+IC0jZGVmaW5lIEFUODAzWF9NT0RFX0NGR19TR01JSQkJCTB4MDENCj4gPiA+ID4gKyNk
ZWZpbmUgQVQ4MDNYX01PREVfQ0ZHX0JBU0VUX1JHTUlJCQkweDAwDQo+ID4gPiA+ICsjZGVmaW5l
IEFUODAzWF9NT0RFX0NGR19CQVNFVF9TR01JSQkJMHgwMQ0KPiA+ID4gPiArI2RlZmluZSBBVDgw
M1hfTU9ERV9DRkdfQlgxMDAwX1JHTUlJXzUwCQkweDAyDQo+ID4gPiA+ICsjZGVmaW5lIEFUODAz
WF9NT0RFX0NGR19CWDEwMDBfUkdNSUlfNzUJCTB4MDMNCj4gPiA+ID4gKyNkZWZpbmUgQVQ4MDNY
X01PREVfQ0ZHX0JYMTAwMF9DT05WXzUwCQkweDA0DQo+ID4gPiA+ICsjZGVmaW5lIEFUODAzWF9N
T0RFX0NGR19CWDEwMDBfQ09OVl83NQkJMHgwNQ0KPiA+ID4gPiArI2RlZmluZSBBVDgwM1hfTU9E
RV9DRkdfRlgxMDBfUkdNSUlfNTAJCTB4MDYNCj4gPiA+ID4gKyNkZWZpbmUgQVQ4MDNYX01PREVf
Q0ZHX0ZYMTAwX0NPTlZfNTAJCTB4MDcNCj4gPiA+ID4gKyNkZWZpbmUgQVQ4MDNYX01PREVfQ0ZH
X1JHTUlJX0FVVE9fTURFVAkJMHgwQg0KPiA+ID4gPiArI2RlZmluZSBBVDgwM1hfTU9ERV9DRkdf
RlgxMDBfUkdNSUlfNzUJCTB4MEUNCj4gPiA+ID4gKyNkZWZpbmUgQVQ4MDNYX01PREVfQ0ZHX0ZY
MTAwX0NPTlZfNzUJCTB4MEYNCj4gPiA+IA0KPiA+ID4gSGkgUm9iZXJ0DQo+ID4gPiANCj4gPiA+
IFdoYXQgZG8gdGhlc2UgXzUwLCBhbmQgXzc1IG1lYW4/DQo+ID4gDQo+ID4gNTAgb3IgNzUgb2ht
IGltcGVkYW5jZS4gQ2FuIHJlZmVyIHRvIHBhZ2UgODIgb2YgdGhlIGRhdGFzaGVldCBhdCANCj4g
PiBodHRwczovL3VybGRlZmVuc2UuY29tL3YzL19faHR0cHM6Ly93d3cuZGlnaWtleS5jYS9lbi9k
YXRhc2hlZXRzL3F1YWxjb21tL3F1YWxjb21tYXI4MDMxZHNhdGhlcm9zcmV2MTBhdWcyMDExX187
ISFJT0dvczBrIXhyWnBySWlDSzVubmZobm1BZHh0Q3hPSEdJUDkxNDl5YVZ4WlJqT0lydlhaT25t
ZVhEVkZtUkg4UkI5TXZfcm1xZEkkIA0KPiA+ICAtIHRoZXNlIG5hbWVzIHdlcmUgY2hvc2VuIHRv
IG1hdGNoIHdoYXQgaXQgdXNlcy4NCj4gDQo+IEkga25vdyB0aGV5IGFyZSBnZXR0aW5nIGxvbmcs
IGJ1dCBtYXliZSBhZGQgT0hNIHRvIHRoZSBlbmQ/DQoNCkNvdWxkIHByb2JhYmx5IGRvIHRoYXQs
IHllYWguLg0KDQo+IA0KPiA+ID4gPiAgI2RlZmluZSBBVDgwM1hfUFNTUgkJCQkweDExCS8qUEhZ
LQ0KPiA+ID4gPiBTcGVjaWZpYyBTdGF0dXMgUmVnaXN0ZXIqLw0KPiA+ID4gPiAgI2RlZmluZSBB
VDgwM1hfUFNTUl9NUl9BTl9DT01QTEVURQkJMHgwMjAwDQo+ID4gPiA+IEBAIC0yODMsNiArMjk1
LDggQEAgc3RydWN0IGF0ODAzeF9wcml2IHsNCj4gPiA+ID4gIAl1MTYgY2xrXzI1bV9tYXNrOw0K
PiA+ID4gPiAgCXU4IHNtYXJ0ZWVlX2xwaV90d18xZzsNCj4gPiA+ID4gIAl1OCBzbWFydGVlZV9s
cGlfdHdfMTAwbTsNCj4gPiA+ID4gKwlib29sIGlzX2ZpYmVyOw0KPiA+ID4gDQo+ID4gPiBJcyBt
YXliZSBpc18xMDBiYXNlZnggYSBiZXR0ZXIgbmFtZT8gSXQgbWFrZXMgaXQgY2xlYXJlciBpdCBy
ZXByZXNlbnRzDQo+ID4gPiBhIGxpbmsgbW9kZT8NCj4gPiANCj4gPiBUaGlzIGlzIG1lYW50IHRv
IGluZGljYXRlIHRoZSBjaGlwIGlzIHNldCBmb3IgYW55IGZpYmVyIG1vZGUgKDEwMEJhc2UtRlgg
b3INCj4gPiAxMDAwQmFzZS1YKS4NCj4gDQo+IE8uSywgdGhlbiBpc19maWJyZSBpcyBPLksuDQo+
IA0KPiBJIG5vdGljZWQgY29kZSByZW1vdmluZyB0aGUgbGluayBtb2RlIDEwMDBCYXNlWCBpbiB0
aGUgY2FzZSBvZg0KPiBpc19maWJyZSAmJiAhaXNfMTAwYmFzZXguIERvZXMgMTAwQmFzZUZYIG5l
ZWQgcmVtb3ZpbmcgZm9yICFpc19maWJyZT8NCg0KVGhhdCAxMDAwQmFzZS1YIGxpbmsgbW9kZSB3
YXMgY29taW5nIGZyb20gd2hhdCBnZW5waHlfcmVhZF9hYmlsaXRpZXMgd2FzDQpwYXJzaW5nIG91
dCBvZiB0aGUgZGV2aWNlJ3Mgc3RhdHVzIHJlZ2lzdGVycy4gVGhhdCBmdW5jdGlvbiBjYW4ndCBh
Y3R1YWxseQ0KZGV0ZWN0IDEwMEJhc2UtRlggbW9kZSBzbyBpdCBjYW4ndCBlbmQgdXAgaW4gdGhl
cmUgdG8gbmVlZCByZW1vdmluZyBhdCB0aGlzDQpwb2ludC4NCg0KPiANCj4gCUFuZHJldw0K
