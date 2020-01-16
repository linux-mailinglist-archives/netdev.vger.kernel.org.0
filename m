Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11AFF13DCB1
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgAPN5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:57:24 -0500
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:47884 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726343AbgAPN5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 08:57:23 -0500
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00GDnuXX010961;
        Thu, 16 Jan 2020 08:57:19 -0500
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by mx0a-00128a01.pphosted.com with ESMTP id 2xf93b5ven-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jan 2020 08:57:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nX/I++kJTBAndsU3j165gqHOFSvT/Y7zby6mIy7qTohk6Dt2sMPE+y6M10bvlFqfaFA9BcblZjm3iKHXbl0VBjovZLGbX+IC72xywqpQlCcYIrt8mxcB3sEz+RrKj4OKhZYNtaVjV6Kt06XNxAIm5MZkTiZB8SEpho5A33xA74eUQgQgTjnwxcu8GM3wgoAh7PIZGfdGzwnnjeCGwIIvmANcU2p+z0m9EkM69IuIiJCR/g/RxJo+ax9/IRr4VGYlRLVgLFqO6vrLbSp64mmHXzhLcdDuJWRH3fnWT37uN50SWbtXLb/UNtbm5Bq0I4fWAikfZLIZ6Fh/Z9iyN0iY/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2GZZNFxyobpW2qCLi0x/qWEnFdpGsbghzDh90sY0+Gg=;
 b=TuLBn88kYSy4KuK98bn9vVmCRwInADFFIhQUUI0ah6dVmOlxkWisgvwc1ObN7eRaB+jkW5PH4zuSKI2i0QC6X+xzRZxbqlJ97jn/88+jCOsg7Nm5AV3bg/xnA20y8Bv6Y8ccHZN0rZdpNxb9UO6H7tEHqRbIbPdNxqj46AOReacLfWlPF+EtLaWBLhPwYFRhRjn6mGZQP1pA2rjYYy8g51+zOqTxJhlyie2M8rPz1LdOeClN7iSRP4sewBE0fK2u73auPUZeBP4Vs0lLnY2Dpu6mnavcjaPt1hGuGN4lRz5KMaRD6KPHEiak3zN4kJfjerIncMyfvv5zkjrRlXJKBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2GZZNFxyobpW2qCLi0x/qWEnFdpGsbghzDh90sY0+Gg=;
 b=ARLCT93g3jHmEQkezQv2WoWYTCNbbaPxguPPoOLewT+0/mFYzxBTL1uxRQkrVKLjyi5dHUBcwPSeLB61u65nH+s+WO2Mmffyhiai9zIp+wCNDLbE7PdHqkv6kWDBhOPhVZ55W9Exo6DavmghAMVeOe8wNOjQYrxSVPo4SRLKmz8=
Received: from CH2PR03MB5192.namprd03.prod.outlook.com (20.180.12.152) by
 CH2PR03MB5221.namprd03.prod.outlook.com (20.180.12.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 16 Jan 2020 13:57:18 +0000
Received: from CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::dce7:7fec:f33f:ad39]) by CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::dce7:7fec:f33f:ad39%7]) with mapi id 15.20.2644.021; Thu, 16 Jan 2020
 13:57:18 +0000
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 2/4] net: phy: adin: rename struct adin_hw_stat ->
 adin_map
Thread-Topic: [PATCH 2/4] net: phy: adin: rename struct adin_hw_stat ->
 adin_map
Thread-Index: AQHVzE0lElOsJByoVkqL6pPVQBso0KftS8KAgAAF+IA=
Date:   Thu, 16 Jan 2020 13:57:17 +0000
Message-ID: <d4f087d745744129aa07f79e47a303556700279e.camel@analog.com>
References: <20200116091454.16032-1-alexandru.ardelean@analog.com>
         <20200116091454.16032-3-alexandru.ardelean@analog.com>
         <20200116133805.GC19046@lunn.ch>
In-Reply-To: <20200116133805.GC19046@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.71.226.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0970c18f-0b2d-4347-abad-08d79a8bffdd
x-ms-traffictypediagnostic: CH2PR03MB5221:
x-microsoft-antispam-prvs: <CH2PR03MB5221822158F5AFF07C4E753FF9360@CH2PR03MB5221.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 02843AA9E0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(366004)(136003)(346002)(396003)(199004)(189003)(478600001)(66476007)(66556008)(6486002)(66446008)(4744005)(66946007)(2616005)(8676002)(81166006)(81156014)(2906002)(64756008)(86362001)(8936002)(186003)(6506007)(6916009)(54906003)(4326008)(6512007)(5660300002)(71200400001)(76116006)(36756003)(316002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR03MB5221;H:CH2PR03MB5192.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: analog.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ++hSF5AJfZtmwBh7g8U/5iWxkpocgfOn/sbI6idLiTElgnH0O1y6iLZOzsSg0ZnI5cTFeYpyZqwB55UxLagf7JeF9eZH0J2ItgDka/pHpdzjxr1sod8IwwlvYDaYbyQNNqpSxGC1rRBTAwoyuRGJxEh9qOkpFis/FMhaa5M86PMu9JWKk4HW1qnL4pa6jsYa6FBq20RwecTrp1Pbn4+wvWPE8Q74IOev8ZIfIOJyAHjnZea0dymZWCdo5XH1Uja75RE4DvfR0QHS4exNZ+mq1eYJ7tdhwGDdOCOrGq0eUxmV78Ud/oVLqzV8bbC8e3TbhTxUoEPZ8gN5Oo8CwIJdlRY9XmoazF5vEWsezm3fz3ayi62Wv7KZCVjCSka/fWmniRI8w+nCbikxLcxCulKU9qrYUWhwARYVKxYPZcdQQkJhfTpRUKuW45O/urwk8uW9
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA1957EF424FFD4F9C6E38C1B15217EF@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0970c18f-0b2d-4347-abad-08d79a8bffdd
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2020 13:57:17.8221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1+f+DxbCr0LHgAKowZp68piYMO3ZnGmAqeysjvjUbwRCFSWPLmt46i9hRmzAP7o1h/e1qODG59N+OjSgjczotn7LyYKfAVDuvQWAJvAYhJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR03MB5221
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-16_04:2020-01-16,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 adultscore=0 mlxlogscore=770 bulkscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 phishscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001160116
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTAxLTE2IGF0IDE0OjM4ICswMTAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gT24gVGh1LCBKYW4gMTYsIDIwMjAgYXQgMTE6MTQ6NTJBTSArMDIw
MCwgQWxleGFuZHJ1IEFyZGVsZWFuIHdyb3RlOg0KPiA+IFRoZSBzdHJ1Y3R1cmUgZm9ybWF0IHdp
bGwgYmUgcmUtdXNlZCBpbiBhbiB1cGNvbWluZyBjaGFuZ2UuIFRoaXMgY2hhbmdlDQo+ID4gcmVu
YW1lcyB0byBoYXZlIGEgbW9yZSBnZW5lcmljIG5hbWUuDQo+IA0KPiBOQUNLLg0KPiANCj4gRGVm
aW5pbmcgYSBuZXcgc3RydWN0dXJlIGRvZXMgbm90IGNvc3QgeW91IGFueXRoaW5nLiBBbmQgeW91
IGdldCB0eXBlDQo+IGNoZWNraW5nLCBzbyBpZiB5b3Ugd2VyZSB0byBwYXNzIGEgYWRpbl9tYXAg
YWRpbl9nZV9pb19waW5zIHRvIGEgc3RhdHMNCj4gZnVuY3Rpb24sIHRoZSBjb21waWxlciB3aWxs
IHdhcm4uDQo+IA0KDQpBY2suDQpXaWxsIHJlLXNwaW4uDQoNCj4gCSAgQW5kcmV3DQo=
