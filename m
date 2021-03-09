Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E605332587
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 13:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbhCIMd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 07:33:56 -0500
Received: from mail-bn7nam10on2062.outbound.protection.outlook.com ([40.107.92.62]:62689
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230386AbhCIMdy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 07:33:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RHSwf3wCJMq+lzWMPB5NJguJwH9ZbpK1OSj6my646MhBHGSu1fzRqtejpWJZUxrwszdcZFIvwqp2rLUpzU9MVFFc9ulP4DP7Bta7ETaql8jhQvW1GCOnKG/UNYcM9tJyHVaMj95gxmquW9nVAMuGNczI0pKt0WkKco7UFI+FlDzNV1vTmnckMfgtxE6ieMyBwtoovIoivjaPRebvzNLBfU2qYx7KQ07nIPpYwoeHI24zP401theEicCFXq1zJx9A+oPZrG9OIqFVHtZto/BIecOQgSYuJtr1Nw01awEam2hDOxMnpbDgXYLd+mP4zheA3BWX5rRbAqU/7nd8ut9aNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Erefg4SD3XEdiyStzr0yOCcKsmtYRxeQgvqaSoBAriQ=;
 b=YoYkKspIjZBVX1FlVvnkyPmjhXR7eX2cdKXAeZlgwrrX2e2Az6PZCOErzuy3kf2NgWrQnOz0tcbaGIE7saSEzkkHqYbPdN/fUXCReUJK5ohSATNoceRGCjXgIFql/3F1ywUyCZZBmSpXzt/uaGGSTwQRXzZEx95G6DD0+33ra69sUAn302PWrqcfNzHiEkk/2XHHhmyMyPjU+bk7RO2FPAw3KRsb+dqJ3bdPHO+9yN8PaZa+lr4clILGvdjR+K4WTVbaTEVaSudJhbw99sP/dSuC0AcAAN3tZP1L06sBYZhgN/dPJTF+j0chhxyx7CHmR4NX/jDusLsiTCSBNG4/+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Erefg4SD3XEdiyStzr0yOCcKsmtYRxeQgvqaSoBAriQ=;
 b=VcD2AUIh8uBFtVCvfwnj6xkrT8wekIypjAZa7PawvattKXxSDwEALCZEaHboBn2AcU0iN3eM/3cBIt9jiiB8y7WsFVDJbEQxM9ZErlqYY446ykvUWxxdQxT1m0mOKxwFKiDHv7o/gem6jj5IO/fDpkAH0faTSIqtzff6XWqOOaywNWoiapJvSIrvtJbT+jY0vSOFPux7uKyd6Irw9kQJKvEJH1W+82j91UHbPElAkUkSkcVOrD307x4K449pBsd41HBCgYLDvVQI64r5zdf/kcUJj70A8JruoAIuPYv/yylDM/vz43VrxteoLeuosGsTr/LNXAu5Z5nM6P7UE0pJYg==
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB4616.namprd12.prod.outlook.com (2603:10b6:a03:a2::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Tue, 9 Mar
 2021 12:33:51 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b0c7:dacb:8412:19e5]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b0c7:dacb:8412:19e5%5]) with mapi id 15.20.3912.029; Tue, 9 Mar 2021
 12:33:51 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     David Ahern <dsahern@gmail.com>, ze wang <wangze712@gmail.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: mlx5 sub function issue
Thread-Topic: mlx5 sub function issue
Thread-Index: AQHXE72y2+GYMtRR80igRDiiJTpnUap5iw/wgAAk5ICAAI11AIABW1/Q
Date:   Tue, 9 Mar 2021 12:33:51 +0000
Message-ID: <BY5PR12MB4322B5ABE71F74F6D7B70D10DC929@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <CANS1P8H8sDGUzQEh_LEFVi=6tUZzVxAty9_OKWAs4CU67wdLeg@mail.gmail.com>
 <BY5PR12MB43226FF17791F6365812D028DC939@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CANS1P8E8uPpR+SN4Qs9so_3Lve3p2jxsRg_3Grg5JBK5m55=Tw@mail.gmail.com>
 <b026b2c8-fdd5-d0fc-f0a6-42aa7e9d26f8@gmail.com>
In-Reply-To: <b026b2c8-fdd5-d0fc-f0a6-42aa7e9d26f8@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.166.131.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0028ac67-5cce-4072-e0ae-08d8e2f7985d
x-ms-traffictypediagnostic: BYAPR12MB4616:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB46162982624E92AA5E617D72DC929@BYAPR12MB4616.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r7NuFnZJQszVwZ0tqfXTeoK7ARWsrBjKsqq5LtWKXHduXTXev747bk53XSrHqYZQKmsqp+3cGYeICvVELUBwrb6Y6EaYsHMEv/yc2EPncQCVEexd+f6MY10iHi4KchfYD4zNprgTVYDrVddeljwYj3aJpjZ7HSxiabiDQBaIaY53iS4WpcczvPG61VmKaTWbB+h7uGcfbJeUi5tEqrb4zOnfTAwPEJJZ73ETcVpe/WmFxAJl0ffTIBqvF9+1dVtvjhLQRbT+L1+s92wsBZP9lNbDln+IU4d2UyCYOXHVzXqV/QxraesG4OCQ42qn5RgA2V6J1F+VvOttfi1v4H7CeMulrqHuo1QYuPCTwB2ZgdQo55OrjHz7yMlSB2QdccKEtH6M/iPAtezgsm/3GsCGC2xSKGZFGniRxTMCQzK6BtoSBii7KNumre/kNJlztfX5RItptGyFE5OCOY/qwNfuT8ubY3FOn1MednUccvOOPsL/Af25hUyYzqozDP8/TP2X7un4EH7RAA/xUFB3OUVzaQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(366004)(136003)(346002)(8936002)(33656002)(2906002)(76116006)(316002)(83380400001)(4326008)(26005)(186003)(8676002)(9686003)(7696005)(55016002)(66946007)(52536014)(86362001)(66446008)(64756008)(66556008)(66476007)(54906003)(71200400001)(110136005)(5660300002)(478600001)(6506007)(53546011)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bENoemczVmNPTjd3YXNCeWNjNVpVOHQ0d1BIZnErWm4vUmx2TEtEOGd2b0pP?=
 =?utf-8?B?bVlwM3JFUXVOdVBsdDM4SGhDd3VCWEFuWFBkL3JpRm81eTVSTkNtRjhGNmIz?=
 =?utf-8?B?WWpIVWJOZXZSUlhabVdNYnUwNXd3UVplU2h5eXdiTEhDS25DVXlvT3ZTVkpR?=
 =?utf-8?B?WmsrZEpzeHB5Smd0clhtQ3JIRHU4ZUUrUUdkOU1mMXdLYTdBaktmZE1Nekt1?=
 =?utf-8?B?RE5aUnBQQmh3QXZkbDN5WGhvWFFBSXZJV2VxZnVORkpkZGU3emVWc3IxSU5y?=
 =?utf-8?B?a3JvTktYeTZ5OStZdkM3MWtGRXE5OVRVeElzMUwzaGpyMjV1c2JlQlBJTWEv?=
 =?utf-8?B?a3EwVjBWd0VSMHRFK2ZSOVpnS21yQ0lMVnF4L09nOGgwNlRkZHMyaFRCbnVw?=
 =?utf-8?B?NEpZWVlUbWk0S1ZDc29VUEJabmJYZkFHdUVmbVF3VlJiUExPQjFlRDZseTlY?=
 =?utf-8?B?dXdIKzFpWGRXTmdWU3hlS0JOeUZSQkZEa20rdllGTWxpYmhkR2FBMWFnMVEr?=
 =?utf-8?B?eStiU3ZPWjBjWk56K3JKZU1HeEprS2lrWHlJSU9NQUpGNGtMb3dnQTZwTGRj?=
 =?utf-8?B?aTBSMDVXbkFtZTlFQkJDR09EQmIrUmorUFZjNXNJOG9FdGx2WVBVWGJDbXdr?=
 =?utf-8?B?SGIyYlVTeUJGRWpOT2FMYk1VazVlR2xDRmNBejhYb1c1Wm00R29FR2xLS2p3?=
 =?utf-8?B?OVp4U1Z5WWlGeG5sODdZTlhXVmNoKzMzZ0dzUWkvbGZBcjdQcVg1Y3Juc3hj?=
 =?utf-8?B?aS9POW1LVkNPdVIyY2JjQkF6OVNnUkFtY2hkTmdiSVdKUW15ZWtXeXgzc0Mw?=
 =?utf-8?B?bU0yMWo3OHQzZTRDa1NJZ3ZiV3ZjSEd1eEtyZ0p5ZlYwR2huV3dDV29sK3FG?=
 =?utf-8?B?Uzl1SWpXTE41NC9VdStHbGdqWmdzbC83TVQ4N1pWcmhYRGZMZ0FlOVpoWFQx?=
 =?utf-8?B?THVYa2o4bUlya2tRTDVib3ZnU1F1TkxvUnA1bzFiaHRMS1JTKzUvdFI4TUQ2?=
 =?utf-8?B?L0YrOFN5OVNhWnVRcyt2TXdTM1NDcnVFeXVhNm1vRnZ0WVU3UmpKUHBUb3JL?=
 =?utf-8?B?OXZOYStrRXlDeVo1cmNHNFRCS1kvSzlzNHdud3p6UFExeGdWbjJNTElVaThR?=
 =?utf-8?B?a1g3ZFVjZXMyaWMrNjZwdjBzTnFXZ0Izd1kxUnRFaGFlbDVranJRL0FnMXI5?=
 =?utf-8?B?M1hIdnlOSHZwdjJvaTVuNzI4bGlDZDRIVG1oZGNOdzNuWGJtRUFPMUNwenJa?=
 =?utf-8?B?cGFYSXQyS1NyOGZjK0lCQW5FeEJqWG8yRDl1akFFWDlTQURCS1VPSFo0RWxj?=
 =?utf-8?B?R3I1Tmh3TFNiTW1wVkZMTFdqOWNnM081YVJ0MjFyN1JtUzJJVWtORENVb3px?=
 =?utf-8?B?OUVzaWFWc2hxdHl6d3RHSzZzQWdkUnNtOE9JSXQ1aU9lbmJkTjlxbzdkeWZt?=
 =?utf-8?B?eHMxdDZXempZU2dHMmowckJFcE5DWXdOU3VDRjZUN3A1WEprblRKNG5xNHpP?=
 =?utf-8?B?cExQV09vNDZTSko0cEtiM3d6RlFlempwV2x1WHpYOExDVnBSL0ExUlRyK0xs?=
 =?utf-8?B?aytrMHViSTRSeWpKVElJdDlGS25uVGNScDZaMWNDTXFSY2FUaVhNUWJRRWRX?=
 =?utf-8?B?cFNJQ21hODQ1bElLcTN3eFEzOGg0VEErSTV6ZFB6bzFBRmp2MjNEWVlhMDVY?=
 =?utf-8?B?T21YMUZsbURLYittU2xNcHlGVVBBVEpNTnpmeW1XUFUycHE4RnNTdlVCbzNw?=
 =?utf-8?Q?YGz5WvIhgUYdYDvx2A1gtBMcn3Oy6CoHX+55OMw?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0028ac67-5cce-4072-e0ae-08d8e2f7985d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2021 12:33:51.2590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uJXGa+g+V3n4wFKhkYJKOXtQ5CkItKZYmGPzysFA8fSeFWQ4inyK7zT1jfHSOPO+sV7cE5nLWnnuuIRpeltHNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4616
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWQsDQoNCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiBT
ZW50OiBNb25kYXksIE1hcmNoIDgsIDIwMjEgOToxOCBQTQ0KPiANCj4gT24gMy84LzIxIDEyOjIx
IEFNLCB6ZSB3YW5nIHdyb3RlOg0KPiA+IG1seGNvbmZpZyB0b29sIGZyb20gbWZ0IHRvb2xzIHZl
cnNpb24gNC4xNi41MiBvciBoaWdoZXIgdG8gc2V0IG51bWJlciBvZiBTRi4NCj4gPg0KPiA+IG1s
eGNvbmZpZyAtZCBiMzowMC4wICBQRl9CQVIyX0VOQUJMRT0wIFBFUl9QRl9OVU1fU0Y9MQ0KPiA+
IFBGX1NGX0JBUl9TSVpFPTggbWx4Y29uZmlnIC1kIGIzOjAwLjAgIFBFUl9QRl9OVU1fU0Y9MQ0K
PiBQRl9UT1RBTF9TRj0xOTINCj4gPiBQRl9TRl9CQVJfU0laRT04IG1seGNvbmZpZyAtZCBiMzow
MC4xICBQRVJfUEZfTlVNX1NGPTENCj4gUEZfVE9UQUxfU0Y9MTkyDQo+ID4gUEZfU0ZfQkFSX1NJ
WkU9OA0KPiA+DQo+ID4gQ29sZCByZWJvb3QgcG93ZXIgY3ljbGUgb2YgdGhlIHN5c3RlbSBhcyB0
aGlzIGNoYW5nZXMgdGhlIEJBUiBzaXplIGluDQo+ID4gZGV2aWNlDQo+ID4NCj4gDQo+IElzIHRo
YXQgY2FwYWJpbGl0eSBnb2luZyB0byBiZSBhZGRlZCB0byBkZXZsaW5rPw0KWWVzLCB3YW50IHRv
IGV4cG9zZSBhcyBkZXZsaW5rIHJlc291cmNlIGF0IHBlciBjb250cm9sbGVyIGxldmVsLg0KSG93
ZXZlciBkZXZsaW5rIHJlc291cmNlIGRvZXNu4oCZdCBoYXZlIGVub3VnaCBwbHVtYmluZyBhdmFp
bGFibGUgdG8gZGVmaW5lIGNvbnRyb2xsZXIsIHBmIGFubm90YXRpb24gd2hpY2ggd2FzIHRoZSBw
cmltYXJ5IGJsb2NrZXIgZm9yIGxhY2tpbmcgdGhpcyBpbmZvIHJpZ2h0IG5vdy4NCg0K
