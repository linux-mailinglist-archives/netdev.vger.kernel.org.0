Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1E833979D
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 20:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbhCLTo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 14:44:26 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:38138 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234400AbhCLToJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 14:44:09 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12CJgtFb024353;
        Fri, 12 Mar 2021 14:44:05 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2058.outbound.protection.outlook.com [104.47.60.58])
        by mx0c-0054df01.pphosted.com with ESMTP id 375yymhm53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 14:44:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bm1SwIe8gk/LcgMhbvg7v4kPVJFUwP7DPs/ITwG5R5KaLkyBnfcOhkwvh8aAQLYm3zwO6kEr5yEUrF9De/1EfqpxrXCSMh5msqgxMXCLucechOdoCHMthSidYISGgFEK84ltrDu52CarmxwCHOZz2+LJw7cfPblf3DW8O9Oc4NclmF0NT0WE8F6eQifbsibaUd0sx1uwM/PJYHPzQgo1Sqi90B299HAOBEZyaHMR0EPE/+G9It7i3nz4f0+WEZA8vJFz7SF55V+YNusrYP8G/t2gLf7GzI1Xyb5qWOYhjkyZIjcfepNfGrMylWq79w+Wu8QSbzh6RpaH+Fu/AP6gYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0janlAuir1d0sVjNSN8baRG+k+4N+IpMXy4k8TlNb8Q=;
 b=U/liCby2J50GtwgAqWBoMcKUfEL92Bgkf58n0ZHCp9SlFd8dFmTIesGZBP+dYumbbliQY7Piw2s5JFJQx7Q9baJsZTIwYiwngtC/rQpDDMlXDxYh2zEbHn87dtX3Z7NiwmFRIiJes0CTAjzDqRwPMgZMJ+VjmyDm4jZGHrK9xPGkRzOndAkeoEl0Rs1eB7+jR9aQpPyfIbA9tJTvVfugJ6yNWZ0xsquh92p6X0yhAkoOvBvaR+WJm2Su6UJMaePbbMdhdn52S5bTe1l0PajA8NHcs0LqXGv5j+lQgA8tf69OPMsJLaomCX1ofWFnBqT6U6YpzipauqlSSq9HYNtqnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0janlAuir1d0sVjNSN8baRG+k+4N+IpMXy4k8TlNb8Q=;
 b=Tz4F77IClrxGOkmwVmP4fJw9bN/yaS9KIDaq+IusaWilx4+WZEEq3nMJwWIHs/dSaAHXrjpPKmvHOF9A8J01SzGSYvEdy3FWmtYNkC9yp8CBPGOHIaUox5IKgxdR5+ygiNEg5eqhaCXfnZ6J73S1gNtE8sR2nUPndAw3ET3bBlQ=
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTXPR0101MB1501.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:3::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Fri, 12 Mar
 2021 19:44:03 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb%7]) with mapi id 15.20.3912.031; Fri, 12 Mar 2021
 19:44:03 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "radheys@xilinx.com" <radheys@xilinx.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 1/2] dt-bindings: net: xilinx_axienet:
 Document additional clocks
Thread-Topic: [PATCH net-next v2 1/2] dt-bindings: net: xilinx_axienet:
 Document additional clocks
Thread-Index: AQHXF2dCwBCFPqSxoEOt8MOOYI0tkKqAr0kAgAASAwA=
Date:   Fri, 12 Mar 2021 19:44:03 +0000
Message-ID: <c0df773ed9bc07172f38760fd1e4509b6164e790.camel@calian.com>
References: <20210312174326.3885532-1-robert.hancock@calian.com>
         <20210312174326.3885532-2-robert.hancock@calian.com>
         <BY5PR02MB65203D654C8B9E991B8EFDC9C76F9@BY5PR02MB6520.namprd02.prod.outlook.com>
In-Reply-To: <BY5PR02MB65203D654C8B9E991B8EFDC9C76F9@BY5PR02MB6520.namprd02.prod.outlook.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-16.el8) 
authentication-results: xilinx.com; dkim=none (message not signed)
 header.d=none;xilinx.com; dmarc=none action=none header.from=calian.com;
x-originating-ip: [204.83.154.189]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 525758da-a628-4dad-953b-08d8e58f30ee
x-ms-traffictypediagnostic: YTXPR0101MB1501:
x-microsoft-antispam-prvs: <YTXPR0101MB150139E7346C0D785A24DEF2EC6F9@YTXPR0101MB1501.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wbHd1peBkbZwc13bSxKro07DXdTpjjKEq3BRdhDzAMU4pmGTKQDC1ChQE6DRKcMBwBNT3CNp6Nhk8+l6jeYMEaRfnQNm39mplIolxPI8fzm/jC375AwNdIwU7dRSlOQdTs5I2YDwAu4JtVIeyKfGoZLBkodRQBWiZq7l/FHMukKkVevmKgdR+A+wFm5ruJ5QNcW09wb9PqGQNk/r4z2z4eIeoAgm5EVfMShk5dYCw5bR4lkXPwKoNyEOG/5TbpCPMZAMjwu7zfzachZE6rljARXPBM/7sKiRqIkcVYDxuWdATGRorDBM6ITtcmRpsed4P5KhiOoGtKK7bUVow4iRqZn+P/FqF1Y96ZiTsoBCOEw/65f1MXLK0yW4KufopC6KA6xiPCp6AyAqjuQOfOQ1FAGHY1GfBg6XPKRkpE31ybMQbeO4XvxT9Z5Wf3QW9Gb4bQhAlmr/ncf15eOOE5SbMG3oHnaPd7njGVLWsTSwZ6x0SE9VCScEKW65jf4+9bs0nGOWjuEgNblPuqZIUJXY7cuf16uQoSQTXm/wRkLmUpCmrdlcUz9zk03oRoECaAmM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39850400004)(346002)(396003)(376002)(2616005)(478600001)(64756008)(8676002)(6506007)(2906002)(66476007)(110136005)(86362001)(66446008)(6512007)(44832011)(53546011)(54906003)(71200400001)(6486002)(36756003)(316002)(5660300002)(83380400001)(76116006)(4326008)(8936002)(91956017)(66946007)(66556008)(26005)(186003)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?R2lHWEZhN1M3ZURTSFFrM0hDaW0rTWhHMDc4YnlmVFJZUk5tYTVDVUNTQW53?=
 =?utf-8?B?UTdUYS9FM3VyUkFHay9RM1ZnZE5iVWRPYzRycXg3bSt5NDBFQjJyWWVTOUdR?=
 =?utf-8?B?VnZ1eW5jU0dadHVJbk5jMHVFalpXSmRYam42U09zSTJ4WDBRUTlEcm8zM0RL?=
 =?utf-8?B?b040Q0lxTmJFNm0zelh2Ti9uTTlrQXVVRExCRFI1K3h5MFdLQ0d1anM0UDY1?=
 =?utf-8?B?UGIwSGFwaXdaY1hVczJGbVVRbmFSdGU4UXVYWm94UktUVnJKUXRHZGxOTm5V?=
 =?utf-8?B?SXlmMEhwSVA1Mi9GeVV4UTd2dXhzUHlRYzBhaXpSVGxBeVIxcmxZOTlEU1cz?=
 =?utf-8?B?bndIM3I1SmNrMFB6TUY4UC83V0JmTTJoNVlqaW1vL2NkSDZOYVp0Um9kYjRk?=
 =?utf-8?B?NXd3RjIxbUpqdFFPM1g4UFBhaWNhUVNMc01MRjJaOE5JMjZwUEpDeDczMmFt?=
 =?utf-8?B?U3JzRUxJZUNFVXlYQmlZek1xZE95YUdPZzd4aFAvbWtYdkxMWFFLUmR2S25i?=
 =?utf-8?B?RUNDdVVtN24zSDB6Ylk4bHY1ZmtHTFYzb2p5YzNEVVVHRldDdHN5bldWZ0c1?=
 =?utf-8?B?OVVEVVNYZTV3UTFPbnRGRi9QM0IrRFNxTjRnNGxsUmxKRUpUNm9XNEwrUnpl?=
 =?utf-8?B?SlhQSSswcjRlQ2pSRmZPcXgzcG1LNTZCd2VXRUFTTXVrSW1aTENVeG1aVWZu?=
 =?utf-8?B?OTNneXFneGNIQVUzUDhRaXBCWi9PL20rSjVOaUhyM09OMjVDbG1tLzVhdU1z?=
 =?utf-8?B?Vlcrd1hJaFJLY1Ztb0EyUS94N1JmL1l3dDR5UGJ4NUFVRmdyTzA0dFQ3MkV4?=
 =?utf-8?B?Yk5DOVluRjdMUWx5MG5YcXZnZC9ya2Zvb3VnRFpKeHZZWE9JbE9zcmJvdUFU?=
 =?utf-8?B?VlZVSlVGQ2lpdHN3dUxYUUlyOFZBbCtTcDVKVkZxRlZpNlM2Ukt3UHV6NmRM?=
 =?utf-8?B?L0M1elN3SG5Pc0w3ZU0raHB5Mm0yenVCb0RpUEpuaElmQTY3dzE5RmxRQlgy?=
 =?utf-8?B?amN5NFNsb1NPYUJpUnFiRUl2a0g1cmVRRHZud3ZtNzFoa3BzT282eXNvOVIx?=
 =?utf-8?B?VERzd2RXV21CdXlsZWxMOTc0SGx4YnNXeXR2b1hjcVgrYXZyazJXSS96elBW?=
 =?utf-8?B?UVQ1YjBuYUdySXF3VHNEejlWV0U4VnBYQ29MRkgyWllIRC9hQzE0YnNhdXZN?=
 =?utf-8?B?eSt1M0JLQVAxV0hRMlFrVkVsUDkrL3B1OUtmNVkxV0xVT2JJK1Y2QVBsckJq?=
 =?utf-8?B?RVlYbEQvVXdXTndTdFlvNnByRitybXNNMnh6TXFmZTRMaEdzbFpYSmMyNjJh?=
 =?utf-8?B?UG40cGI2ZFFqdUpmSHFuTmFnblNudk5KS2lScDRRTG5jTldtRmJ4blA3N1o1?=
 =?utf-8?B?T3JDZ2FQMHNkUWMzbnF4b2ZodmdJdFhRQjgwVjJMUldBTlVBOXFRNGI5TW85?=
 =?utf-8?B?Q3IrbEcxa1YxRHpUclBwclIzMTYrY0RnMmNuR2t4OU51dDBhR2JlZm13eUF0?=
 =?utf-8?B?MEZIbktIaGhEZGlJbmxWWVhwMk1OaEdKcXdCUlhnaFNablVIYXlRbklrcnk5?=
 =?utf-8?B?d2I2ZGRZeHpYSG9XL3MxdVRZajRoZjB2MWdSdmwzZGQrckUyU3l2QThTSkc1?=
 =?utf-8?B?Mk5uWk8xaUdyOXZwSkc1a1d1M1dEYWI3NWN3ZEFXZnlacUVhYTMzUDREMmhw?=
 =?utf-8?B?SHNLejNiRXBJOUlud3NpdE5BaXIxUzZYRVVGRlRkSXJwclpJYkZhT0ZwcFhi?=
 =?utf-8?Q?Pv/uE1fdq+GXjfjivleh8ClMjRwkadaZTtPmX9o?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D393F25C2498DF4F8A4D9DEFB4BDF167@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 525758da-a628-4dad-953b-08d8e58f30ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 19:44:03.6201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +6rHjs9yYki2F4lmyQJCjUDkaC3eeKATJkalNwOXRB2ZShwC6uj0FIWe6O92LoweAbqWgXr92YFoitXlOF0ZpxXmMpYZwXtpbzJmcgjlJPc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTXPR0101MB1501
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-12_09:2021-03-12,2021-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1011
 spamscore=0 suspectscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103120142
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTAzLTEyIGF0IDE4OjM5ICswMDAwLCBSYWRoZXkgU2h5YW0gUGFuZGV5IHdy
b3RlOg0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogUm9iZXJ0IEhh
bmNvY2sgPHJvYmVydC5oYW5jb2NrQGNhbGlhbi5jb20+DQo+ID4gU2VudDogRnJpZGF5LCBNYXJj
aCAxMiwgMjAyMSAxMToxMyBQTQ0KPiA+IFRvOiBSYWRoZXkgU2h5YW0gUGFuZGV5IDxyYWRoZXlz
QHhpbGlueC5jb20+OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiA+IGt1YmFAa2VybmVsLm9yZw0K
PiA+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9y
ZzsgUm9iZXJ0IEhhbmNvY2sNCj4gPiA8cm9iZXJ0LmhhbmNvY2tAY2FsaWFuLmNvbT4NCj4gPiBT
dWJqZWN0OiBbUEFUQ0ggbmV0LW5leHQgdjIgMS8yXSBkdC1iaW5kaW5nczogbmV0OiB4aWxpbnhf
YXhpZW5ldDogRG9jdW1lbnQNCj4gPiBhZGRpdGlvbmFsIGNsb2Nrcw0KPiA+IA0KPiA+IFVwZGF0
ZSBEVCBiaW5kaW5ncyB0byBkZXNjcmliZSBhbGwgb2YgdGhlIGNsb2NrcyB0aGF0IHRoZSBheGll
bmV0IGRyaXZlcg0KPiA+IHdpbGwNCj4gPiBub3cgYmUgYWJsZSB0byBtYWtlIHVzZSBvZi4NCj4g
PiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBSb2JlcnQgSGFuY29jayA8cm9iZXJ0LmhhbmNvY2tAY2Fs
aWFuLmNvbT4NCj4gPiAtLS0NCj4gPiAgLi4uL2JpbmRpbmdzL25ldC94aWxpbnhfYXhpZW5ldC50
eHQgICAgICAgICAgIHwgMjUgKysrKysrKysrKysrKystLS0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdl
ZCwgMTkgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0
IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC94aWxpbnhfYXhpZW5ldC50
eHQNCj4gPiBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQveGlsaW54X2F4
aWVuZXQudHh0DQo+ID4gaW5kZXggMmNkNDUyNDE5ZWQwLi41ZGY1YmE0NDliOGYgMTAwNjQ0DQo+
ID4gLS0tIGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC94aWxpbnhfYXhp
ZW5ldC50eHQNCj4gPiArKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0
L3hpbGlueF9heGllbmV0LnR4dA0KPiA+IEBAIC00MiwxMSArNDIsMjMgQEAgT3B0aW9uYWwgcHJv
cGVydGllczoNCj4gPiAgCQkgIHN1cHBvcnQgYm90aCAxMDAwQmFzZVggYW5kIFNHTUlJIG1vZGVz
LiBJZiBzZXQsIHRoZSBwaHktDQo+ID4gbW9kZQ0KPiA+ICAJCSAgc2hvdWxkIGJlIHNldCB0byBt
YXRjaCB0aGUgbW9kZSBzZWxlY3RlZCBvbiBjb3JlIHJlc2V0DQo+ID4gKGkuZS4NCj4gPiAgCQkg
IGJ5IHRoZSBiYXNleF9vcl9zZ21paSBjb3JlIGlucHV0IGxpbmUpLg0KPiA+IC0tIGNsb2Nrcwk6
IEFYSSBidXMgY2xvY2sgZm9yIHRoZSBkZXZpY2UuIFJlZmVyIHRvIGNvbW1vbiBjbG9jaw0KPiA+
IGJpbmRpbmdzLg0KPiA+IC0JCSAgVXNlZCB0byBjYWxjdWxhdGUgTURJTyBjbG9jayBkaXZpc29y
LiBJZiBub3Qgc3BlY2lmaWVkLCBpdCBpcw0KPiA+IC0JCSAgYXV0by1kZXRlY3RlZCBmcm9tIHRo
ZSBDUFUgY2xvY2sgKGJ1dCBvbmx5IG9uIHBsYXRmb3Jtcw0KPiA+IHdoZXJlDQo+ID4gLQkJICB0
aGlzIGlzIHBvc3NpYmxlKS4gTmV3IGRldmljZSB0cmVlcyBzaG91bGQgc3BlY2lmeSB0aGlzIC0g
dGhlDQo+ID4gLQkJICBhdXRvIGRldGVjdGlvbiBpcyBvbmx5IGZvciBiYWNrd2FyZCBjb21wYXRp
YmlsaXR5Lg0KPiA+ICstIGNsb2NrLW5hbWVzOiAJICBUdXBsZSBsaXN0aW5nIGlucHV0IGNsb2Nr
IG5hbWVzLiBQb3NzaWJsZSBjbG9ja3M6DQo+ID4gKwkJICBzX2F4aV9saXRlX2NsazogQ2xvY2sg
Zm9yIEFYSSByZWdpc3RlciBzbGF2ZSBpbnRlcmZhY2UNCj4gPiArCQkgIGF4aXNfY2xrOiBBWEkg
c3RyZWFtIGNsb2NrIGZvciBETUEgYmxvY2sNCj4gDQo+IERlc2NyaXB0aW9uIGZvciBheGlzX2Ns
ayBzaG91bGQgYmUtDQo+IGF4aXNfY2xrOiBBWEk0LVN0cmVhbSBjbG9jayBmb3IgVFhEIFJYRCBU
WEMgYW5kIFJYUyBpbnRlcmZhY2VzLg0KDQpNaXNzZWQgdGhpcywgd2lsbCBhZGQgaW4uDQoNCj4g
SW4gdGhpcyBwYXRjaCBJIGFzc3VtZSB3ZSBhcmUgb25seSBhZGRpbmcgYWRkaXRpb25hbCBjbG9j
a3MgZm9yIA0KPiAxRyBldGhlcm5ldCBzdWJzeXN0ZW0uIEZvciBkbWEgY2xvY2tpbmcgc3VwcG9y
dCB3ZSBuZWVkIHRvIGFkZCANCj4gbW9yZSBjbG9ja3MgYW5kIGJldHRlciB0byBhZGQgdGhlbSBp
biBhIHNlcGFyYXRlIHBhdGNoLiBQbGVhc2UgcmVmZXIgdG8NCj4geGlsaW54IHRyZWUuDQoNCkNv
cnJlY3QsIGhlcmUgSSBhbSBqdXN0IGZvY3VzaW5nIG9uIGNsb2NrcyB3aGljaCBhcmUgY29ubmVj
dGVkIHRvIHRoZSBFdGhlcm5ldA0KY29yZSBpdHNlbGYuIEl0IHNlZW1zIHRoZSBETUEgY29yZSBj
bG9ja3Mgd291bGQgYmUgbW9yZSBkaWZmaWN1bHQgc2luY2UgdGhvc2UNCmNsb2NrcyBhcmUgYXR0
YWNoZWQgdG8gdGhlIERNQSBub2RlIGluIHRoZSBkZXZpY2UgdHJlZSAoYmFzZWQgb24gdGhlIFZp
dGlzLQ0KZ2VuZXJhdGVkIFBMIGRldmljZSB0cmVlIGNvbnRlbnQpIGFuZCBub3QgdG8gdGhlIG5v
ZGUgYmVsb25naW5nIHRvIHRoZSBFdGhlcm5ldA0KcGxhdGZvcm0gZGV2aWNlLiBMb29raW5nIGF0
IHRoZSBYaWxpbnggdmVyc2lvbiBvZiB0aGlzIGRyaXZlciwgaXQgc2VlbXMgdG8NCmltcGxlbWVu
dCByZXRyaWV2aW5nIHRoZXNlIGNsb2NrcywgYnV0IGl0IGlzIHVzaW5nIGRldm1fY2xrX2dldCBv
biB0aGUgc2FtZQ0KcGxhdGZvcm0gZGV2aWNlIHVzZWQgZm9yIHRoZSBFdGhlcm5ldCBjb3JlLCBz
byBJIGFtIGNvbmZ1c2VkIGhvdyB0aGF0IGlzDQp3b3JraW5nIChvciBtYXliZSBpdCBpc24ndD8p
DQoNClRoZSBETUEgY29yZSBjbG9ja3MgYXJlIGxlc3Mgb2YgYSBjb25jZXJuIGZvciB1cywgc2lu
Y2UgKGF0IGxlYXN0IGluIG91cg0KZGVzaWduKSB0aGV5IGFyZSBkcml2ZW4gYnkgdGhlIHNhbWUg
Y2xvY2sgc291cmNlIGFzIG9uZSBvZiB0aGUgRXRoZXJuZXQgY29yZQ0KY2xvY2tzLCBzbyB0aGV5
IHNob3VsZCBhbHdheXMgYmUgZW5hYmxlZCB3aGVuIHRoZSBFdGhlcm5ldCBjb3JlIGNsb2NrcyBh
cmUNCmVuYWJsZWQuDQoNCj4gPiArCQkgIHJlZl9jbGs6IEV0aGVybmV0IHJlZmVyZW5jZSBjbG9j
aywgdXNlZCBieSBzaWduYWwgZGVsYXkNCj4gPiArCQkJICAgcHJpbWl0aXZlcyBhbmQgdHJhbnNj
ZWl2ZXJzDQo+ID4gKwkJICBtZ3RfY2xrOiBNR1QgcmVmZXJlbmNlIGNsb2NrICh1c2VkIGJ5IG9w
dGlvbmFsIGludGVybmFsDQo+ID4gKwkJCSAgIFBDUy9QTUEgUEhZKQ0KPiA+ICsNCj4gPiArCQkg
IE5vdGUgdGhhdCBpZiBzX2F4aV9saXRlX2NsayBpcyBub3Qgc3BlY2lmaWVkIGJ5IG5hbWUsIHRo
ZQ0KPiA+ICsJCSAgZmlyc3QgY2xvY2sgb2YgYW55IG5hbWUgaXMgdXNlZCBmb3IgdGhpcy4gSWYg
dGhhdCBpcyBhbHNvIG5vdA0KPiA+ICsJCSAgc3BlY2lmaWVkLCB0aGUgY2xvY2sgcmF0ZSBpcyBh
dXRvLWRldGVjdGVkIGZyb20gdGhlIENQVQ0KPiA+IGNsb2NrDQo+ID4gKwkJICAoYnV0IG9ubHkg
b24gcGxhdGZvcm1zIHdoZXJlIHRoaXMgaXMgcG9zc2libGUpLiBOZXcgZGV2aWNlDQo+ID4gKwkJ
ICB0cmVlcyBzaG91bGQgc3BlY2lmeSBhbGwgYXBwbGljYWJsZSBjbG9ja3MgYnkgbmFtZSAtIHRo
ZQ0KPiA+ICsJCSAgZmFsbGJhY2tzIHRvIGFuIHVubmFtZWQgY2xvY2sgb3IgdG8gQ1BVIGNsb2Nr
IGFyZSBvbmx5IGZvcg0KPiA+ICsJCSAgYmFja3dhcmQgY29tcGF0aWJpbGl0eS4NCj4gPiArLSBj
bG9ja3M6IAkgIFBoYW5kbGVzIHRvIGlucHV0IGNsb2NrcyBtYXRjaGluZyBjbG9jay1uYW1lcy4g
UmVmZXIgdG8NCj4gPiBjb21tb24NCj4gPiArCQkgIGNsb2NrIGJpbmRpbmdzLg0KPiA+ICAtIGF4
aXN0cmVhbS1jb25uZWN0ZWQ6IFJlZmVyZW5jZSB0byBhbm90aGVyIG5vZGUgd2hpY2ggY29udGFp
bnMgdGhlDQo+ID4gcmVzb3VyY2VzDQo+ID4gIAkJICAgICAgIGZvciB0aGUgQVhJIERNQSBjb250
cm9sbGVyIHVzZWQgYnkgdGhpcyBkZXZpY2UuDQo+ID4gIAkJICAgICAgIElmIHRoaXMgaXMgc3Bl
Y2lmaWVkLCB0aGUgRE1BLXJlbGF0ZWQgcmVzb3VyY2VzIGZyb20NCj4gPiB0aGF0DQo+ID4gQEAg
LTYyLDcgKzc0LDggQEAgRXhhbXBsZToNCj4gPiAgCQlkZXZpY2VfdHlwZSA9ICJuZXR3b3JrIjsN
Cj4gPiAgCQlpbnRlcnJ1cHQtcGFyZW50ID0gPCZtaWNyb2JsYXplXzBfYXhpX2ludGM+Ow0KPiA+
ICAJCWludGVycnVwdHMgPSA8MiAwIDE+Ow0KPiA+IC0JCWNsb2NrcyA9IDwmYXhpX2Nsaz47DQo+
ID4gKwkJY2xvY2stbmFtZXMgPSAic19heGlfbGl0ZV9jbGsiLCAiYXhpc19jbGsiLCAicmVmX2Ns
ayIsDQo+ID4gIm1ndF9jbGsiOw0KPiA+ICsJCWNsb2NrcyA9IDwmYXhpX2Nsaz4sIDwmYXhpX2Ns
az4sIDwmcGxfZW5ldF9yZWZfY2xrPiwNCj4gPiA8Jm1ndF9jbGs+Ow0KPiA+ICAJCXBoeS1tb2Rl
ID0gIm1paSI7DQo+ID4gIAkJcmVnID0gPDB4NDBjMDAwMDAgMHg0MDAwMCAweDUwYzAwMDAwIDB4
NDAwMDA+Ow0KPiA+ICAJCXhsbngscnhjc3VtID0gPDB4Mj47DQo+ID4gLS0NCj4gPiAyLjI3LjAN
Cg==
