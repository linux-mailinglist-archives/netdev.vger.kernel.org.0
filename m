Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89993347F2A
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 18:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236825AbhCXRTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 13:19:53 -0400
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:27283 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236700AbhCXRTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 13:19:37 -0400
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12OHD895016684;
        Wed, 24 Mar 2021 13:19:29 -0400
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2052.outbound.protection.outlook.com [104.47.60.52])
        by mx0c-0054df01.pphosted.com with ESMTP id 37dc5xakqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Mar 2021 13:19:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMpItqnD0weP+kYPN1pHgxGeRaPOFoSeJUnIS8IHMYxYdPMRYLZfBjABRz7JEd9YlHyJo/a8IIp6/1ME7E2FiQd5BrSQAEdbbpfRxvdKluFTOXVeSzxJzwKUrfCKfaNlSCZi3v6g+4zitirAjZ4h3XBT/3sZMiPREYPGZrosA1MzJblC+69Evt6JTc1hyXt7uWBxxrC1hgAjGTfJbbnNmVSOlv3GR8lH6gJsxBYPwuw76sTSUqz2cOrvTlHXzplGS/eQ+lrjWmAVpUJkcXvvo5D5rL8aJGYKWQoPQSv4TeBc0cGYg5W+xX6JTKyLY1g7SD3pQksWimtPJkqZjFsYiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lqlKarx1poB7xbY1OP7fzC8raVoLRf91N2J4SUIz5nI=;
 b=He8g8w8c7orek1mURT7l/7LHGIMjl75CATXG/QrDpBp5HNtanHTPja5FFix+2La5R9TUNWYKHfcu7SU3aQ70sc4q5XXtbch448bQTlZxgUgCMLWSqlYMhsYp5FdnyFoHW3GfAItIu5M2zCTWMjInJw4Th+u4XFX5WJu0ZG5JuxGfxEZ9Jk5R0OoKvBtbEldGbVvBAj9nm1xmr+xPY9yZ0/TSni5qxiS1KcVgZEzr4/HUMi9B84fhgk2yximiKIkrSkqHggHA/rtP8K5ZLOjtimn/+SboDEIuh8D0/ojleXg3wyp1cumYR8t4p+Z5O3kqyYjO279Inm+wLuDOp1JZrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lqlKarx1poB7xbY1OP7fzC8raVoLRf91N2J4SUIz5nI=;
 b=ThNbFCRHRrd8VoaZyw1xQ2gKaCny5VcTGRqJ8U59hhMcBIg6L2S0JLn8IUFtCFbaZ/MyNlpLWFEFmHiqodYvsIxFPwd3pxIEXcJk+eovzBESZlD2JWL1f5ONt7/ZW3P53Y1qFnoyIztBUJx+rVnokgB9+noK+IovyFMjR2IH7pE=
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTOPR0101MB1067.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:24::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Wed, 24 Mar
 2021 17:19:27 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb%7]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:19:27 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "robh@kernel.org" <robh@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v3 v3 1/2] dt-bindings: net: xilinx_axienet:
 Document additional clocks
Thread-Topic: [PATCH net-next v3 v3 1/2] dt-bindings: net: xilinx_axienet:
 Document additional clocks
Thread-Index: AQHXF3lSHjl37eKWM06mSLaSxdN6wqqTcZAAgAADLIA=
Date:   Wed, 24 Mar 2021 17:19:27 +0000
Message-ID: <9d9c8eb80f9b1573931a948e69ec0a44b65491b7.camel@calian.com>
References: <20210312195214.4002847-1-robert.hancock@calian.com>
         <20210312195214.4002847-2-robert.hancock@calian.com>
         <20210324170806.GA3252450@robh.at.kernel.org>
In-Reply-To: <20210324170806.GA3252450@robh.at.kernel.org>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-16.el8) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=calian.com;
x-originating-ip: [204.83.154.189]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85be88ef-0d16-4e34-83a5-08d8eee8fab3
x-ms-traffictypediagnostic: YTOPR0101MB1067:
x-microsoft-antispam-prvs: <YTOPR0101MB10673066FF6727CFFA50F377EC639@YTOPR0101MB1067.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ytqrHWlCsUv2S+U7C3fbTo25xxD4yEBMtTGdLIuPL4dBmsZVkcHIKlHSmGaayBMYTJ6UWCuRzUp0J3lkdoVMHrt5jjzC/SeIYbs2XUFtj27bKTqDJfoeQzC5tCj60Mt3Um+C/5hakTf70uFSxXXf2bGct4mjl3A9+3RBdt1OYl5+KImv5BrCOnJd24F1oyRLNmWAOuW26It1GunG21lBAYSB0ZodY7/r4WxLQxBX4jilljEFKSyZEMfyUSnU4BvHSEIWmCbcpulv53pXB8HxWSQYPmWnWdjWlHRKAaBHhJ1ErO5YyTHMBMYbJNwgUXjpDFrapvDxTJfEhNtD7URHB/ZIfPhGpdRIzfEMiCVKWBMgqkPmRXHkMwsc4JRZap+M77kfNOS3eeYDgN1tmA9jXC1iAc4/aeCXZMJU5gb/oXKQPm2/9LlDWWmvLkfRQ+U7hMjiNHqOFJPpKCCoFpxHYSJEDpbYvnevH+PG7h88Z16hBzqpLRi5Rqe5KWxRZJkIEYsD2Fjgikq91sWwsDHIJVb0pLP+NvY1JD9+p6CUFH2NplZEWQRtjp7+fvAeujts7fm5gH6lrUQ8V3/F8Q459EKs/koWLTbBtV5/MsLoWKCaup/PykB8onGmZpBy+98lwEPtRrUj6onH1xaOu77lVH5QHeIDLCJz6tSuD+qI5yZcGCBInvB+nKCnXJAOVzGawK9t+h4YgxbP3ktrjY7tIHNn4UlMZbNInymmQzRc4Cd70LfpU2IZQcNuMcB+2772h1JKEJRgCYtn9zMIfv4pTPXyG2p2x8cSu1KWzm7iJm0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(39850400004)(396003)(6916009)(6506007)(6486002)(66946007)(66556008)(54906003)(66476007)(64756008)(66446008)(6512007)(76116006)(316002)(91956017)(4326008)(8676002)(5660300002)(478600001)(71200400001)(8936002)(186003)(15974865002)(38100700001)(86362001)(26005)(44832011)(2906002)(83380400001)(2616005)(36756003)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?d1RBbHJrb2RQSGd5aVVFZ1N0YmdTSXB5c0pTcWFxa25WVGxqL0xJN1dWWTlT?=
 =?utf-8?B?MGdOZ2poYW0xNG0wZkxRYUVGWi9ia2t5MG9pWW1pNHZndXJKclJrNEN4UVBo?=
 =?utf-8?B?SCtSUnM2VTllaHhzTlJrQ21jZlg0dWZIdkoyNStPYTdib08rNzhUYXRIdkFi?=
 =?utf-8?B?Y0FpU2w4SjUyc01heGg1bEN1bFdNTkdQSk5Eb0lUNkxaeFZNTjh3Vy93d2RH?=
 =?utf-8?B?ZXBzUmlWaktSUGZPK014VjZBWGlUOXFNRzhxU3pPSW1qZXhGZTdmWTZoNXAx?=
 =?utf-8?B?TDdyUlNlbE5MQkNWRFlMb0plZjRiUXJaa0tzSDhwcCtmRWxydnFtZW1aVHBs?=
 =?utf-8?B?dGwzZ1ZGdUdxQ0RPakhvNWw2cmFBTnAzOEJBNW8yR0tGZ1hnTzBJY3U3L2dR?=
 =?utf-8?B?RjlNYTNqSHVWWFQzUEJiZm94dGpjTDc0U0U5TWk0NnAwV24yMXhVNDVqKzFY?=
 =?utf-8?B?N24zSUlPcU5JNW1VcWhNcHR6TE9jOE5TL1JxTzZuM1FteHFEMlBTcjVBM3hM?=
 =?utf-8?B?MUFHOWk0N2g1WHBzZEdkeG5kY0hEMlFBYjJldXlWSmc1MWQ3NUllcldBY1lC?=
 =?utf-8?B?ZkRSQXZycnQ1UEtBdVpPS3RuV2lySjU1SEc4b3dETGw1WTFGeFc2M1pMVnRv?=
 =?utf-8?B?SVlBcEoxbVdxYmFaeGoxUk1wdnY4VGJyVDhobERuTXgvV2o0NEZqVTFvWDRz?=
 =?utf-8?B?VzdhMWtES25Ld25SajdiT1lBeGE3U0lxMmtvOXVuSFBNZkUwZ3Zkbkl0Ritz?=
 =?utf-8?B?SXlPZ1JldHRjR256bktZMENlek03YjVlT1Y1emlxTXR2T1M2UVVpVWt5RGtR?=
 =?utf-8?B?MGFUZHIwa1dGc1NZeFpuVGZsMi9xUWNZRkpwR2RIbXNYZzgwOUJKZWpiSitD?=
 =?utf-8?B?dlhvRGpQRGwxTmJGOVFrOS80MU4ydVZhbWtPOE1MWFJQSEdnSkgvYnk4bW1C?=
 =?utf-8?B?MkQzREJMVWMvSlpaZjVCR0VYOEhOMXBJQWswNnNxZ2tQUG51RjV3S1AwUDlw?=
 =?utf-8?B?SnRUalNlQlpkUDZIUkU5QUI4b21MMWZjNlYvZkN0em9zTFp2eWVWNTEvbmdU?=
 =?utf-8?B?TkFmRTF0d3lReFB2UzNodDVwUWg1bHdiUk9Nb1FoRXRMWW1pY1BxRkRINEIv?=
 =?utf-8?B?aVdYb3pFTDFkVHE5NFZWbnl1MFlrWHdXVFg4ZlBSbitGQjdCNVo5NmsyT3VH?=
 =?utf-8?B?em1sNzNyQzJBYjhENzlXMkNmT2dqb1BzSUxtb0FTODV0TFNKZHFHOW00NzRV?=
 =?utf-8?B?d0IxSGorRG40YWpkdnA2VW0zWG5UaUhwbTgyVVlMRm5WU2VQRjhDNjNZbHFT?=
 =?utf-8?B?b1lncmF6dFF0ZE8vUk56eWFpOFlLYk5sYzRoZUI1eEphR3JtcWF5RFhpZTF4?=
 =?utf-8?B?bTBoaW1rK0s5eFFKWGtXNmhkNWJGWTk0K1dsdVZKS00rRUxpZmxMc2lLZVNN?=
 =?utf-8?B?a3B3cnkrb1lLOXh2RVNsb2dQOStHN0FnZ1M5Y2o2NXlZV3U5OVdEbVU2OTJo?=
 =?utf-8?B?WUdzNTVIbnpPajRXVzhNUkUxYlZ6L2lDb2tBLzlXaEMvZm9JR1pLYy9oR0xu?=
 =?utf-8?B?cUs1OFpxRnhnUDdrN3h5eVVqT2J5TWtzdjR4Q0Rac1Vrc0s2MXZRSWoxN3dX?=
 =?utf-8?B?S3R4djZzYWViK3crSXBkTE5neGF1bVJ5UUxkdjFCeXVJaWlGYUZTQ242a0FL?=
 =?utf-8?B?ditBOEQwYnhCTm1ZME9zNjBLMi8ybUYvYlFCNkl6aXRmVGdhc0NabGpYT3lj?=
 =?utf-8?B?bk9uUjc0dXFsNUZmT2N6bEZIbEYwaXBiM0xJRGIxV0ZhOU02QUk4Y2M4dkJQ?=
 =?utf-8?B?a3lIYWhsczk4QS80VjZudz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7EAA57651A8A9146AB64DB76BBD7AA7A@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 85be88ef-0d16-4e34-83a5-08d8eee8fab3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2021 17:19:27.7797
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bBb5IbE2zL0UsrLOIaFufKt84MLMcH+ioI4NK6BS1qZmvetRAY83Q/cUXGqsDom0k+k9+X7AWPuqcab6TjHXCMgIqh8vCRlT8Tb0NFW9nrw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTOPR0101MB1067
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-24_13:2021-03-24,2021-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240125
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTAzLTI0IGF0IDExOjA4IC0wNjAwLCBSb2IgSGVycmluZyB3cm90ZToNCj4g
T24gRnJpLCBNYXIgMTIsIDIwMjEgYXQgMDE6NTI6MTNQTSAtMDYwMCwgUm9iZXJ0IEhhbmNvY2sg
d3JvdGU6DQo+ID4gVXBkYXRlIERUIGJpbmRpbmdzIHRvIGRlc2NyaWJlIGFsbCBvZiB0aGUgY2xv
Y2tzIHRoYXQgdGhlIGF4aWVuZXQNCj4gPiBkcml2ZXIgd2lsbCBub3cgYmUgYWJsZSB0byBtYWtl
IHVzZSBvZi4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBSb2JlcnQgSGFuY29jayA8cm9iZXJ0
LmhhbmNvY2tAY2FsaWFuLmNvbT4NCj4gPiAtLS0NCj4gPiAgLi4uL2JpbmRpbmdzL25ldC94aWxp
bnhfYXhpZW5ldC50eHQgICAgICAgICAgIHwgMjUgKysrKysrKysrKysrKystLS0tLQ0KPiA+ICAx
IGZpbGUgY2hhbmdlZCwgMTkgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4gPiANCj4g
PiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC94aWxp
bnhfYXhpZW5ldC50eHQNCj4gPiBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9u
ZXQveGlsaW54X2F4aWVuZXQudHh0DQo+ID4gaW5kZXggMmNkNDUyNDE5ZWQwLi5iOGU0ODk0YmM2
MzQgMTAwNjQ0DQo+ID4gLS0tIGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25l
dC94aWxpbnhfYXhpZW5ldC50eHQNCj4gPiArKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUv
YmluZGluZ3MvbmV0L3hpbGlueF9heGllbmV0LnR4dA0KPiA+IEBAIC00MiwxMSArNDIsMjMgQEAg
T3B0aW9uYWwgcHJvcGVydGllczoNCj4gPiAgCQkgIHN1cHBvcnQgYm90aCAxMDAwQmFzZVggYW5k
IFNHTUlJIG1vZGVzLiBJZiBzZXQsIHRoZSBwaHktbW9kZQ0KPiA+ICAJCSAgc2hvdWxkIGJlIHNl
dCB0byBtYXRjaCB0aGUgbW9kZSBzZWxlY3RlZCBvbiBjb3JlIHJlc2V0IChpLmUuDQo+ID4gIAkJ
ICBieSB0aGUgYmFzZXhfb3Jfc2dtaWkgY29yZSBpbnB1dCBsaW5lKS4NCj4gPiAtLSBjbG9ja3MJ
OiBBWEkgYnVzIGNsb2NrIGZvciB0aGUgZGV2aWNlLiBSZWZlciB0byBjb21tb24gY2xvY2sgYmlu
ZGluZ3MuDQo+ID4gLQkJICBVc2VkIHRvIGNhbGN1bGF0ZSBNRElPIGNsb2NrIGRpdmlzb3IuIElm
IG5vdCBzcGVjaWZpZWQsIGl0IGlzDQo+ID4gLQkJICBhdXRvLWRldGVjdGVkIGZyb20gdGhlIENQ
VSBjbG9jayAoYnV0IG9ubHkgb24gcGxhdGZvcm1zIHdoZXJlDQo+ID4gLQkJICB0aGlzIGlzIHBv
c3NpYmxlKS4gTmV3IGRldmljZSB0cmVlcyBzaG91bGQgc3BlY2lmeSB0aGlzIC0gdGhlDQo+ID4g
LQkJICBhdXRvIGRldGVjdGlvbiBpcyBvbmx5IGZvciBiYWNrd2FyZCBjb21wYXRpYmlsaXR5Lg0K
PiA+ICstIGNsb2NrLW5hbWVzOiAJICBUdXBsZSBsaXN0aW5nIGlucHV0IGNsb2NrIG5hbWVzLiBQ
b3NzaWJsZSBjbG9ja3M6DQo+ID4gKwkJICBzX2F4aV9saXRlX2NsazogQ2xvY2sgZm9yIEFYSSBy
ZWdpc3RlciBzbGF2ZSBpbnRlcmZhY2UNCj4gPiArCQkgIGF4aXNfY2xrOiBBWEk0LVN0cmVhbSBj
bG9jayBmb3IgVFhEIFJYRCBUWEMgYW5kIFJYUw0KPiA+IGludGVyZmFjZXMNCj4gPiArCQkgIHJl
Zl9jbGs6IEV0aGVybmV0IHJlZmVyZW5jZSBjbG9jaywgdXNlZCBieSBzaWduYWwgZGVsYXkNCj4g
PiArCQkJICAgcHJpbWl0aXZlcyBhbmQgdHJhbnNjZWl2ZXJzDQo+ID4gKwkJICBtZ3RfY2xrOiBN
R1QgcmVmZXJlbmNlIGNsb2NrICh1c2VkIGJ5IG9wdGlvbmFsIGludGVybmFsDQo+ID4gKwkJCSAg
IFBDUy9QTUEgUEhZKQ0KPiANCj4gJ19jbGsnIGlzIHJlZHVuZGFudC4NCg0KVHJ1ZSwgYnV0IHRo
ZXJlIGFyZSBleGlzdGluZyBkZXZpY2UgdHJlZXMgd2hpY2ggYWxyZWFkeSByZWZlcmVuY2VkIHRo
ZXNlIG5hbWVzDQpiZWNhdXNlIHRob3NlIGFyZSB3aGF0IHdhcyB1c2VkIGJ5IHRoZSBYaWxpbngg
dmVyc2lvbiBvZiB0aGlzIGRyaXZlciBhbmQgaGVuY2UNCnRoZSBYaWxpbnggZGV2aWNlIHRyZWUg
Z2VuZXJhdGlvbiBzb2Z0d2FyZS4gU28gZm9yIGNvbXBhdGliaWxpdHkgSSB0aGluayB3ZSBhcmUN
CmtpbmQgb2Ygc3R1Y2sgd2l0aCB0aG9zZSBuYW1lcy4uDQoNCj4gDQo+ID4gKw0KPiA+ICsJCSAg
Tm90ZSB0aGF0IGlmIHNfYXhpX2xpdGVfY2xrIGlzIG5vdCBzcGVjaWZpZWQgYnkgbmFtZSwgdGhl
DQo+ID4gKwkJICBmaXJzdCBjbG9jayBvZiBhbnkgbmFtZSBpcyB1c2VkIGZvciB0aGlzLiBJZiB0
aGF0IGlzIGFsc28gbm90DQo+ID4gKwkJICBzcGVjaWZpZWQsIHRoZSBjbG9jayByYXRlIGlzIGF1
dG8tZGV0ZWN0ZWQgZnJvbSB0aGUgQ1BVIGNsb2NrDQo+ID4gKwkJICAoYnV0IG9ubHkgb24gcGxh
dGZvcm1zIHdoZXJlIHRoaXMgaXMgcG9zc2libGUpLiBOZXcgZGV2aWNlDQo+ID4gKwkJICB0cmVl
cyBzaG91bGQgc3BlY2lmeSBhbGwgYXBwbGljYWJsZSBjbG9ja3MgYnkgbmFtZSAtIHRoZQ0KPiA+
ICsJCSAgZmFsbGJhY2tzIHRvIGFuIHVubmFtZWQgY2xvY2sgb3IgdG8gQ1BVIGNsb2NrIGFyZSBv
bmx5IGZvcg0KPiA+ICsJCSAgYmFja3dhcmQgY29tcGF0aWJpbGl0eS4NCj4gPiArLSBjbG9ja3M6
IAkgIFBoYW5kbGVzIHRvIGlucHV0IGNsb2NrcyBtYXRjaGluZyBjbG9jay1uYW1lcy4gUmVmZXIg
dG8NCj4gPiBjb21tb24NCj4gPiArCQkgIGNsb2NrIGJpbmRpbmdzLg0KPiA+ICAtIGF4aXN0cmVh
bS1jb25uZWN0ZWQ6IFJlZmVyZW5jZSB0byBhbm90aGVyIG5vZGUgd2hpY2ggY29udGFpbnMgdGhl
DQo+ID4gcmVzb3VyY2VzDQo+ID4gIAkJICAgICAgIGZvciB0aGUgQVhJIERNQSBjb250cm9sbGVy
IHVzZWQgYnkgdGhpcyBkZXZpY2UuDQo+ID4gIAkJICAgICAgIElmIHRoaXMgaXMgc3BlY2lmaWVk
LCB0aGUgRE1BLXJlbGF0ZWQgcmVzb3VyY2VzIGZyb20NCj4gPiB0aGF0DQo+ID4gQEAgLTYyLDcg
Kzc0LDggQEAgRXhhbXBsZToNCj4gPiAgCQlkZXZpY2VfdHlwZSA9ICJuZXR3b3JrIjsNCj4gPiAg
CQlpbnRlcnJ1cHQtcGFyZW50ID0gPCZtaWNyb2JsYXplXzBfYXhpX2ludGM+Ow0KPiA+ICAJCWlu
dGVycnVwdHMgPSA8MiAwIDE+Ow0KPiA+IC0JCWNsb2NrcyA9IDwmYXhpX2Nsaz47DQo+ID4gKwkJ
Y2xvY2stbmFtZXMgPSAic19heGlfbGl0ZV9jbGsiLCAiYXhpc19jbGsiLCAicmVmX2NsayIsDQo+
ID4gIm1ndF9jbGsiOw0KPiA+ICsJCWNsb2NrcyA9IDwmYXhpX2Nsaz4sIDwmYXhpX2Nsaz4sIDwm
cGxfZW5ldF9yZWZfY2xrPiwNCj4gPiA8Jm1ndF9jbGs+Ow0KPiA+ICAJCXBoeS1tb2RlID0gIm1p
aSI7DQo+ID4gIAkJcmVnID0gPDB4NDBjMDAwMDAgMHg0MDAwMCAweDUwYzAwMDAwIDB4NDAwMDA+
Ow0KPiA+ICAJCXhsbngscnhjc3VtID0gPDB4Mj47DQo+ID4gLS0gDQo+ID4gMi4yNy4wDQo+ID4g
DQotLSANClJvYmVydCBIYW5jb2NrDQpTZW5pb3IgSGFyZHdhcmUgRGVzaWduZXIsIENhbGlhbiBB
ZHZhbmNlZCBUZWNobm9sb2dpZXMNCnd3dy5jYWxpYW4uY29tDQo=
