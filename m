Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02AF33A8C0
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 00:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhCNX0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 19:26:06 -0400
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:26255 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229473AbhCNXZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 19:25:46 -0400
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12ENMohB012213;
        Sun, 14 Mar 2021 19:25:42 -0400
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2058.outbound.protection.outlook.com [104.47.61.58])
        by mx0c-0054df01.pphosted.com with ESMTP id 378sd2rr8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 14 Mar 2021 19:25:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=It2m4ccDuB6IZXLwGK8tZTyNTfQP4/7P57rRwg0deJfiIvyIFutK3QLUrfk8xgzAu+Mpr9lwDdyuFpxh1ZutGBdwwT2/SlMKwLNAoHCFWZtlStC9InVnoLU+EQtv1akPFz/ecF9d1qXwODZcDb7zNhjq9//thO7ja1QrRyFwIcp2qsfgdOAPRnHvds6ZqTQnoL9D36j1oMYfw/Qot5dnjzYOrwOWbo7Fxv8xztWeyNItPvJMzhKdhjstz3Xai3G5qB09MECfiMN8Frb6ZMRCj8Ha7+V67LydS15Xy0uUrj3uznObK+40HdltrjGxS6VfLr0Rk/IZKyIQt01RBRPXfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nOn1z4tpPVxPnch6qSOmpHsz/IJ4p2E7bGmI3xtyQbc=;
 b=N1sSx/YT746H8tSuI3FvF9Kc3sXEtmk4OOqTjHdOqQoxd3D7j11wXMz+3YusyKnX7IBEd5QzM/wESi022/mqEeXVomNVhs+OenbbAMDfAqIakgRcYGKOgcs/YMdCA5lOnz9c+xN9wyJzK6lGn2j6S4zeTvK21FPNwaCPY0ujk41ZJRE7EDeTFSmAgKadE0uhTac+DhONQEN3OJSSjijOgXjYZTzhTrFMyn6Fu1Sxs4rPOvRMs/L+CwivKh/6hOq8AsNBjReNGEQ9ZzF1XJvH3g5FNqc/QITHBXi3fwkB7+Nx24umq/vwl1mebSfGxlJhW8ucp9zjL5UVwqHClDeYFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nOn1z4tpPVxPnch6qSOmpHsz/IJ4p2E7bGmI3xtyQbc=;
 b=viU6pKaaCH0JhhSNiztKInLPbASdVeXiLnaLLB5Vc5wWlPxe6/1fMajEFbvnWKvat/FPCFOfnhiI21/v0mr0gwF1Q/QMzTgnvIGEErv/mC6ppgb9y3MiY3j4xMbJlfHNDQRWoEWsU7FeyHGFsADLAk5iwQs5bdqqb3zu2lfJwBY=
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTOPR0101MB1289.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:1f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Sun, 14 Mar
 2021 23:25:40 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb%7]) with mapi id 15.20.3933.032; Sun, 14 Mar 2021
 23:25:40 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] axienet clock additions
Thread-Topic: [PATCH net-next 0/2] axienet clock additions
Thread-Index: AQHXFrLCAoxMekX5+UCtPUflMH32b6qEBCSAgAAhJoA=
Date:   Sun, 14 Mar 2021 23:25:40 +0000
Message-ID: <a138b33fd01e6a6bef24efa635b2cce7b43e96c0.camel@calian.com>
References: <20210311201117.3802311-1-robert.hancock@calian.com>
         <20210314.142701.2294646546411779456.davem@davemloft.net>
In-Reply-To: <20210314.142701.2294646546411779456.davem@davemloft.net>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-16.el8) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=calian.com;
x-originating-ip: [204.83.154.189]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c2c5f2ee-413b-431e-70da-08d8e7407b33
x-ms-traffictypediagnostic: YTOPR0101MB1289:
x-microsoft-antispam-prvs: <YTOPR0101MB1289B533F5B4E5E27FF32440EC6D9@YTOPR0101MB1289.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ljrMESUPJ5UNdQb0aAUWqIt97Y7ePTUYR0e7tweWOZJJwQP8+FV2jCh2OnPqI/sVBgcZEOxUh49bsRRsmkoOg7IhQ3e/jmZCj+FGA9aXugLFUsYTwCSzlh3YjgGExDjKQiB5jnrpSgozdP1San/SD8nfdD8nmUf+KrPOgomTQCc31OJ/mvxkcDwzZaMcQkRb93wv5DShx+aMKBoTtgxu20SzzCJCAQu0l2pVit8OJDuPNIxCgRKvYD+IW9H7r4dCMldZzcSw5EweBCeME5wNvi6SjzlfMzc0d9laTFz/T4YX6DPKVPbIBg++jhBwN2Cdd6LmuJK9u6FQwpJ/6ksym7VRksZRwW7nn075vdzceC9PgwyguH5bXzI6lUwCkn1lvf9stpqf3/NPBiNZ+LZ/+t5oY2VON/jbeB+aLuR3VFP+Z04N31AE7dlmq7YJWazb902H2oKlYT0FcQ9T/rgFNwIrwDiLOIMOzuBf+YNlYyMe4easO205ACG2Jf2djkqPgmFVm0teIzLVPzKaBDxZI1mZvlYNEjGVfDVUHbYg0ofmJGW8+LIKeUwm2ywYKDUnjzW8xrDMSA9oTC/22y+yyNFsKcpdPCm35Pp/SckHInrHhax3/2Ei4YbrN76ZlKxMtLcKmzT2a2k/Kum3g56n2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(39840400004)(346002)(136003)(376002)(396003)(2906002)(44832011)(6916009)(4744005)(6506007)(76116006)(64756008)(83380400001)(6512007)(4326008)(5660300002)(36756003)(316002)(54906003)(186003)(8936002)(66946007)(478600001)(71200400001)(8676002)(86362001)(2616005)(6486002)(966005)(26005)(66476007)(66446008)(66556008)(91956017)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TmNlbjRzS2ZhTVgzczFHYXhPdS8wS0pXQUFVZngyWWVUUUNnV1NHTFFHWmtM?=
 =?utf-8?B?MjIrb0NnVkpRTkJLbzNpTHQvZ21hNGRpcitpVXRWUmJrVm1OTlVxNllTcHdr?=
 =?utf-8?B?akU0VFBXZUtadG9FbzBjQ1VlNUIwWEJHVFJxb2xCVnVOS3ZyYmJSM3B3b3I2?=
 =?utf-8?B?cXdjeng2TFB3NHpUWlkvZ3dPTHcxU1VoOUxyWkZEc2Q2aituaEZqWGRxcWRa?=
 =?utf-8?B?OFVrVTI4d0gvTE9mNnEvR0NaZFhsbnVXU1J6N01HdFVRclNFTUVMMW1NSzVa?=
 =?utf-8?B?L2haRnQreG10blE3SEtVN2t3TElXK05FQXBQNXJhWHpTQ2hyY3lxTVdaallx?=
 =?utf-8?B?TjJpN09hTE9PTHhaZWVISXNXZkxrVDFYNzl1NEUydDhzMmlwR3lOUmtvNCsr?=
 =?utf-8?B?cHhBRFdIamloZkxNSW81enhpV2tMV0NHbDlJTkRad1lBM3dIbENHWEpVVzUw?=
 =?utf-8?B?Vlk4TG5hMHBDQnlQQzRKYVduc0VOd3orZ21Mcy9OZTVHRkUySVFHeFRqTmVh?=
 =?utf-8?B?VTM0MTRjQi9JVUhWRDEwZTdjMXg3OEZ0M09yMDA5WkVHVW9ldGhaRGZtK0x3?=
 =?utf-8?B?NU9na2xmeDNUVlJWVHFnc3FXL3JCOHR3d01EMXBkazdUaUJGOHIveUZWdlJR?=
 =?utf-8?B?QlNmeFc3M085TldFQnNFVitUU3JmZzk4TzQwcXdUNUdwR3NxSGlVMXNvYTRp?=
 =?utf-8?B?SlNwdDVha1BpREQ4cVlTR0k2dVprQ01obFdubHl3SFBmaWdxWkVYUEhEcE5r?=
 =?utf-8?B?SVp1eVZpYVFWRHNsUHJMVVY0Tjd2d0prSENoVVp4aitiM1J6TCtQUzY2TDkw?=
 =?utf-8?B?WTd3VHVPakFMRlgyNk9aVjRzbyt6OXpiM3R6cTB5STM5UVZSNmh6T29GR0kv?=
 =?utf-8?B?Q09OV0MrQ1RJSDdraHEzMFE1aDhYMWp1bFBLeTRiT1Y1dWxUQlBJVnFSdlZO?=
 =?utf-8?B?dWIwUmx0VHBUUkQ2b2ppVFBBc2J4VTFJMlVaT3ZJZkIvMjZBdG94Q2ZHZ0hj?=
 =?utf-8?B?Q1ZRelQ1UHdkb3JqY3JLRCtDUTZjSUxWREx5UHlSalpYT0czT3pPeVkxVTNP?=
 =?utf-8?B?bjg3U2dMelB5dFpLVWZuQkI1Y1hZMS9FWFhmV0xseXFuOEVTV3ExdnZPS0o5?=
 =?utf-8?B?VkpLa1BTTzBBTy9JNCsvZ2VoZlEwQ0FMQmZMSVg0S0dZcnh5MjJyYmxBVzN4?=
 =?utf-8?B?dEVRWGI2QWZzaTRCb1lXR0lHcjVyN0NsaCtRZ2NIUi8vVzUwd0dMQmRzbitF?=
 =?utf-8?B?TWZEK0VvRkd4WDZxdlR5KzVoN2hLRGxZcUdWSERHdUtHSWt4WVFCeXlEb1VD?=
 =?utf-8?B?MjFQcjF2amIrQVNpV0ZqaG44Ti80cDNPdEZ2cGFSNXhDSFJqak5xSXg5WDVx?=
 =?utf-8?B?TXZCVm9Xci9zUUJ0UU1iV2VVaGFTdXo5UHNsOTNKeWNoejBKMUR0Nktxb2pm?=
 =?utf-8?B?RWVQcC9wRkg3anplZHZVNVZ3U3pwRXhmNHNxeG9qTXNxeDhNNUhtNVF3MGNQ?=
 =?utf-8?B?cG93aVpmazF5ZU9peDFTcXZVSE96Vlh5Z2p5dGxWK2FwUWFUeXptbVJQUzRJ?=
 =?utf-8?B?bThOYzltQnlvMlcyUXEvWEg1eEFJdEdQK3ZjUXlieGZ0MU1GdTZnK3NXVDdI?=
 =?utf-8?B?MWxTL2xyR3hQNnAyTkxZTzVodzhTWEsvbFBvUk05ZHZWME95L0w4UVJvTVB6?=
 =?utf-8?B?YUdnNzZhQ0d1TGpnekcxbVlDT3BCQjcrZWZ2ZFV5SVhVMjh2TjY1bHBuMWQ4?=
 =?utf-8?B?ZjQ2YVBYNTFHT3d0ZW9KWTdtUEZ4ZjViVmpWbTMyVWl3RUFsNFR2akg5WDJ1?=
 =?utf-8?B?NDE2U0t4dzZUWFRoc3hNdz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B3F4CBDEAA451F4097D74000CB6A8BEA@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: c2c5f2ee-413b-431e-70da-08d8e7407b33
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2021 23:25:40.2687
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7VRPer84TGb2wSy0xiQjP9K/rL+WzzYFh0K/y4NS4zeH1KT139G9dYRWRt9lCvwizXfnH9GLVsUbvYYkViEVfCW/FZRJrpLn/EcaFrdIm7I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTOPR0101MB1289
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-14_13:2021-03-12,2021-03-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxscore=0 bulkscore=0 adultscore=0 clxscore=1015 spamscore=0
 suspectscore=0 priorityscore=1501 mlxlogscore=997 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103140181
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIxLTAzLTE0IGF0IDE0OjI3IC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IFJvYmVydCBIYW5jb2NrIDxyb2JlcnQuaGFuY29ja0BjYWxpYW4uY29tPg0KPiBEYXRl
OiBUaHUsIDExIE1hciAyMDIxIDE0OjExOjE1IC0wNjAwDQo+IA0KPiA+IEFkZCBzdXBwb3J0IHRv
IHRoZSBheGllbmV0IGRyaXZlciBmb3IgY29udHJvbGxpbmcgYWxsIG9mIHRoZSBjbG9ja3MgdGhh
dA0KPiA+IHRoZSBsb2dpYyBjb3JlIG1heSB1dGlsaXplLg0KPiANCj4gVGhpcyBzZXJpZXMgZG9l
cyBub3QgYXBwbHkgdG8gbmV0LW5leHQsIHBsZWFzZSByZXNwaW4uDQo+IA0KPiBUaGFua3MuDQoN
Ckl0J3MgZGVwZW5kZW50IG9uIHRoaXMgcGF0Y2ggd2hpY2ggaXMgbm93IGluIHRoZSBuZXQgdHJl
ZToNCg0KaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbmV0
ZGV2L25ldC5naXQvY29tbWl0Lz9pZD01OWNkNGYxOTI2N2EwYWFiODdhOGMwN2U0NDI2ZWI3MTg3
ZWU1NDhkDQoNCkkgY291bGQgcmVzcGluIGEgdmVyc2lvbiB3aXRob3V0IHRoYXQgZGVwZW5kZW5j
eSB0byBhcHBseSB0byBuZXQtbmV4dCBub3csIGJ1dA0KdGhhdCB3aWxsIGNhdXNlIHNvbWUgY29u
ZmxpY3RzIGxhdGVyIHdoZW4gbmV0IGlzIG1lcmdlZCBpbnRvIG5ldC1uZXh0Li4gbm90DQpzdXJl
IGhvdyB0aGlzIHNob3VsZCBiZSBoYW5kbGVkPw0K
