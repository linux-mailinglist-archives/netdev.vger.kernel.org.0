Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A2D4E3E78
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 13:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234841AbiCVM31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 08:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234843AbiCVM3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 08:29:25 -0400
X-Greylist: delayed 384 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Mar 2022 05:27:54 PDT
Received: from mx07-005c9601.pphosted.com (mx07-005c9601.pphosted.com [205.220.184.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A157DA9E;
        Tue, 22 Mar 2022 05:27:53 -0700 (PDT)
Received: from pps.filterd (m0237840.ppops.net [127.0.0.1])
        by mx08-005c9601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22M3uAkT029592;
        Tue, 22 Mar 2022 13:21:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wago.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=p012021;
 bh=XIqodM6WOk7Btjq9kBgGOpwyP+XBnta2cwheJFW9q6s=;
 b=gbHi9uweOPL260j0RHIsQkgAyArLeoIYPmDNqWWqNZK0RrsfHnJL7WEXsnNTOcfmmicr
 VWRodtPn613YKbGzVgpkfbJFU/F9MtT2WrNi8vvm9gb55QMDqngD4o1EJcwaEomxm2kb
 pgbakl/6vFdZT3BTfgSE3/7I+nSIMB2KAV/+b4zEl1RbTj2hjPvaamej/B0xjNzP2QCZ
 61393VZ/7ZYQ0Pv+wBnGflzGC7kQOcg66Bbj3yHD14OnF9n4y57GcfSRfOXgeus6Li7S
 ZeAYytChCz/sXQVeMwSI8piARZcCoWdwMjhRXr3493WiAJaH3LajA2g3dJ0oylgWFAdX FQ== 
Received: from mail.wago.com ([217.237.185.168])
        by mx08-005c9601.pphosted.com (PPS) with ESMTPS id 3ew5ws2yhq-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 22 Mar 2022 13:21:06 +0100
Received: from SVEX01009.wago.local (10.1.103.227) by SVEX01012.wago.local
 (10.1.103.230) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Tue, 22 Mar
 2022 13:20:48 +0100
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (10.1.103.197) by
 outlook.wago.com (10.1.103.227) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21 via Frontend
 Transport; Tue, 22 Mar 2022 13:20:48 +0100
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bKnljpYmwyOLZJjG1sjFb21zZ6Jf+udAwnKEyFSJkf6m6yDUIS/Uw6me8UOOTer/TqwbZhnRGFjdpBIgmVwW+Z/P6PKxmb2Krf2bpWzD4CuVYeVkvQW5jHZqi0MzBdEgZziMIBSr7oDZX3/73g/5DIItVCdvyC/Ci6+llpSqxPA7GfO1TPNNjoxYjQBps1XTecJhgV3SCoT7crVBVtOInM0rAEJP+HfN9Eq9Fj2qMhw3P2SJVC90j10eRPK/dbWup7FA5gek2QFfvF5cM6Dc/l8W7EPdwplQKhvq/bGSnvwtRuYR9xLRxi8fRNCwLUz/sGF87BBUD+vW8M97iBWWUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XIqodM6WOk7Btjq9kBgGOpwyP+XBnta2cwheJFW9q6s=;
 b=jioxgqtXpUOqa0TJxYEa2EJCWPoqZ1Ta/xIqLsYomQsMeEAO4bnBt1elGeFNqYfvaCb4ERoD1yvG5vDeRy2XkvLqRy/4h9bDp/g4+XQAwyOdKXEds1vtQRGYrsDNdGPxatMtlxTsw8ubaoDMjKtt6DFtD60ES8ihm5UliElQ4dMX8jn0Mh6dPK/V7ifsmgOdPOlMXU3GhfHO5Q7IxI62bcWql3HHe9jaCQNlCSKVcY5NKCEXounxrsg8iZiZ6g31EYBdNumIQCNJKSrlIiTegNRRBXJ9d+XddCsrfFPenk4a3/1rXvLKMqv2sUPkaSpSMkQEwswZmwbEVke7BX8HQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wago.com; dmarc=pass action=none header.from=wago.com;
 dkim=pass header.d=wago.com; arc=none
Received: from DB8PR08MB5097.eurprd08.prod.outlook.com (2603:10a6:10:38::15)
 by DBBPR08MB5962.eurprd08.prod.outlook.com (2603:10a6:10:202::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.16; Tue, 22 Mar
 2022 12:20:47 +0000
Received: from DB8PR08MB5097.eurprd08.prod.outlook.com
 ([fe80::cc57:a7c3:cf03:e4cb]) by DB8PR08MB5097.eurprd08.prod.outlook.com
 ([fe80::cc57:a7c3:cf03:e4cb%6]) with mapi id 15.20.5081.023; Tue, 22 Mar 2022
 12:20:47 +0000
From:   =?utf-8?B?U29uZGhhdcOfLCBKYW4=?= <Jan.Sondhauss@wago.com>
To:     Vignesh Raghavendra <vigneshr@ti.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>
CC:     "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] drivers: ethernet: cpsw: fix panic when interrupt
 coaleceing is set via ethtool
Thread-Topic: [PATCH] drivers: ethernet: cpsw: fix panic when interrupt
 coaleceing is set via ethtool
Thread-Index: AQHYPbapsZNzoyO3w0eRMBgmDSKdY6zLNV+AgAAdtoA=
Date:   Tue, 22 Mar 2022 12:20:46 +0000
Message-ID: <dd897805-38a9-b1e7-b1cf-707aa3de1afb@wago.com>
References: <20220322063221.28132-1-jan.sondhauss@wago.com>
 <d3fac0ae-6d5c-33d7-4e1e-da9058ef525f@ti.com>
In-Reply-To: <d3fac0ae-6d5c-33d7-4e1e-da9058ef525f@ti.com>
Accept-Language: en-DE, en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 478f0aba-038c-4faa-2bcd-08da0bfe652b
x-ms-traffictypediagnostic: DBBPR08MB5962:EE_
x-microsoft-antispam-prvs: <DBBPR08MB59629AF3A3BDA843D03B83938A179@DBBPR08MB5962.eurprd08.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 17qVcKmQA3ynFnuVrX+MMNAK2enX+ohCG23I2T7tOiIuhHlNNZWBR2nYn50ICupvIY57N+l7Tzof7d6rXFI9Sxx3iYeWVfEZ8rXqBaGNweFWuWpy6bMGWDfAZU/v+V0E/wRYpRRuO0K/Tc++WPaAXCIw0Sbso19BVonunXsBp0oucSsIuGkut9O7UsiyMR5Rvx1V2fJDoeKalTmFG6JDQUtRnP9EyKfn7wYRkp4nY5I2F055QCXYS9N9ReKfpQdLnD7Ww/TzEVc4FtjqAEC4jwI5QAovzJxGumfeXZDDKEVJUP6+MSdNHjJXiJghyJ1paPka5mRZ9MlEKP6/6Op9+2bU93vXKbkZqJpUDgowL7ZclEdh3wiWD2UZhFqlxaTyfAYzvQHJgmN6gTNh71A/JlhGG/+MFlF8qRnI/Nwr6bX0xNYDBXteTs5O98s7iRrRn/9yFDU6dAREX/tfKr6TuGL0Hg0aX5m2L6qvF+SlktILv8CGyvQ2l/C53IYZDs/nD+jqCdhurkmItUiQo7Ljlj+t5IBYtkhER3UUY3gxCjBkB/1q9JO4/WsQyQh0E43Z+IQc7OODebrHHvvHvvhkmCsvPgJg0DcMFfoSQ+jcKhuj1/V6hp+hVUIn2s1c1QJjVQgMO8H3gP8Q+RJxSDjbOeF+qh/1NidzmZIPguy5aAFiSApTTQ7Sc76n/iz3px/wDLuIaXNWhgZO51ZUdEDS/c8OL2Uf6lpYDyDsd/2019VP00hytfnimJFtaMGRkV2O
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB5097.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(2616005)(8936002)(110136005)(26005)(91956017)(64756008)(66556008)(66476007)(66446008)(66946007)(31696002)(76116006)(8676002)(4326008)(86362001)(6486002)(508600001)(186003)(38100700002)(6512007)(71200400001)(38070700005)(6506007)(54906003)(53546011)(122000001)(2906002)(85182001)(83380400001)(36756003)(5660300002)(31686004)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZW1tbGlYZUlYYkI3cmlwY3BxRk9xL3k5OVFFQmNnVjdYQXlwNTdLTkIyeVF1?=
 =?utf-8?B?aHNyODdydWQ0SThEQU5xOFk3d0pFREhkK1BhOExmK0V2c1V0RzNYaGxTOHY2?=
 =?utf-8?B?dm9XSzM5WHE3T2ZEYlh2SmsvOW5Sa0w3K3Nyd0dQWUs1SHFCUTJUZmNERVFi?=
 =?utf-8?B?cmxDWVRtUk5xc2tkSk1vL040ai9vU0tNaDVyeWE0VXo1dUZTUWQ0bzdaTG90?=
 =?utf-8?B?ak1DcFBwc3NwaitLSWZVNzVhOVRLb05IazdMT2pOUVZMQ0d0UzBmT0J5Q25p?=
 =?utf-8?B?WjdSekowdGc1NEhla3orUW5DK3BtT1dXUEJRYzQ2SFkwSXQ3OXV3V2NjTlJI?=
 =?utf-8?B?dzJsTUJaeThuVTVMVjl4ekRsUFg3Y2VSWE1GTW9WbDVQVGkzQ292Z2dxS09P?=
 =?utf-8?B?VVVxTUZwanN4T2dJK2oyS0Z5TTk0NTFYa2dtNTZwUEVvZVZ6eERtM2hqWDlI?=
 =?utf-8?B?WEJncU5QbTFkRVpCczVhakt3VFcwcjdaQUVnOUV1ZXlBeU5vSjAzWW0rRlZR?=
 =?utf-8?B?V21MLzAyNE9MbWNXMGZMeTFrcDZiQ0pLRXR4MW43T2VTaUZ3ZE9XTkpZSFBo?=
 =?utf-8?B?R1VVN2FtSTNiYXdHaDY3c0t6Vk9kR09PZzlCQ1htKy8welF2V2JmbXZMOEY1?=
 =?utf-8?B?bG9PWlJST0FtVHRuRGsyc2taWCthaEZQSlVmQWhsK0RVZE94UHJJK1VtS2lJ?=
 =?utf-8?B?czl2MDlpV1RCQWxMMWdETVJOYVIxWHhYMWJMN0FHRjNTUjhWeTdWZ2RjV1o2?=
 =?utf-8?B?VWduQnVKTUxvR2ZCdVE3VThuMFEyOHNhZG15cU9icytUc1lyQlRDTVFIYVo0?=
 =?utf-8?B?ODJXZExSNHUzYitTaHk2L2xTVWxCZTgrZ1FFSUpjMEcvTmxWSk9aM0xVcDVw?=
 =?utf-8?B?bGVJR2xGcU5NbDBxSU1rT294YmZaTHJBc0tJZ0E2cThRY05uRm0wS2I2S29k?=
 =?utf-8?B?R3BraDVOQkVUU3lTMTdzN3NjaDRHVzBVemduK29lcFNBWFJwYVJURlpMZmFK?=
 =?utf-8?B?SHZlSFpxYk5mK0k1b3MvemxGSEZER1kxQk1TaFBLcXdMY1lRaDc2ZzR3cEVY?=
 =?utf-8?B?a1lSMnRMNUVQZktIRjNjZ2R6Ym1tN1FMSzUwaDhYazJYWVFQVDNZUkxPb3hj?=
 =?utf-8?B?NWdFa3JRU2VUYmpyNGg2RzFBRzNpM0ZyeUdSeXgvN1ZGUFpLM0paZW13L3h3?=
 =?utf-8?B?SitHQXFDaVJ0VXdESGM3M2FNNnRKNDNxNGJpcTZIZ1hlcnY2ckZXNk9QdG54?=
 =?utf-8?B?cnVSMUdvZU9rWEJEbm1LeDBZUzdYdmdNZFZFczNrN25RSUtGRi9kZG5DbEI4?=
 =?utf-8?B?ZmRnMmR5MEJrZXI2RFl3YVdnK2dwTXBLblpYL1FmbVZIMUpxRHNiYzJEYUY4?=
 =?utf-8?B?alhPcHNiUHBub2JHRHp6NnI0TkM0U0lKeTRKR1cwM3E0ekplWkhvbGJRa3pt?=
 =?utf-8?B?aXJNQytPTE96aVROSXllSjRibEpJalZtcUhlL3NVR2dQZGROMjhhNW0wc1hD?=
 =?utf-8?B?ZktUdzNtaWR4VDVUS25xZ1J3OEpuaVIvb2FRVml6UXBlOTdkL3hZdEpFR1hx?=
 =?utf-8?B?elFOZENtMEJsalJ6WnlmMEJhdHFUWVZBN0dDMEdGYkcxSm9WTjYvRFlURlVP?=
 =?utf-8?B?Vkx4ckl2TTRKWkRDMkIzbnIyb2MzSlIyVzdnWDRFaGkrNmFNeHpPVkRWaGhK?=
 =?utf-8?B?bytsbjhWNW05bkpwZmJZRmFsR0NsRFVKZWJDc0xvZWZCK1UwRktwMjV2dXRW?=
 =?utf-8?B?U2l0aitFVXgxSWNpaTR0WmpQMU9RSTVGYVdkN25CZHljdVUzZjhuZkE2cVI1?=
 =?utf-8?B?K0xIYUZrQ3BjM25MNU5hVnZRdkI5dHdKMExVR3pCd1FGSTVrNFhRT0NnQWx0?=
 =?utf-8?B?aU9JM2FZRnJqMVpqNS85TU0zVXExbStXeXo1VUtJU2V0MUt5R3pHZlRnK1Vv?=
 =?utf-8?B?YUJ2TU9qelNxRVBQVXZYZFlKamtOMFlTNDlNQVhOUDdxQzVNT0lpNnB3UGZ4?=
 =?utf-8?B?RmNkemN2dUZRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8425A0509E4984478FFAC9038FF41548@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR08MB5097.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 478f0aba-038c-4faa-2bcd-08da0bfe652b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2022 12:20:47.0617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e211c965-dd84-4c9f-bc3f-4215552a0857
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3MdUqRc6NFqljG1p7fuNrPL8EO14Ux13RMpmhdMNW2CHLjfg7zP1O+4RD8sBSb7VHlXY3TgNGhbb5zYKQALiMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB5962
X-OriginatorOrg: wago.com
X-KSE-ServerInfo: SVEX01012.wago.local, 9
X-KSE-AttachmentFiltering-Interceptor-Info: protection disabled
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 22.03.2022 10:04:00
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Proofpoint-GUID: NVkf_w1RDR-LZDOFZdW6-Dq1ddg078PN
X-Proofpoint-ORIG-GUID: NVkf_w1RDR-LZDOFZdW6-Dq1ddg078PN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_04,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=824 impostorscore=0 spamscore=0 bulkscore=0 suspectscore=0
 phishscore=0 adultscore=0 priorityscore=1501 clxscore=1011 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203220071
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkNCg0KT24gMjIvMDMvMjAyMiAxMTozNCwgVmlnbmVzaCBSYWdoYXZlbmRyYSB3cm90ZToNCj4g
SGksIEFkZGluZyBuZXRkZXYgbGlzdCBhbmQgbWFpbnRhaW5lcnMgUGxlYXNlIGNjIG5ldGRldiBN
TCBhbmQgbmV0IA0KPiBtYWludGFpbmVycyAuL3NjcmlwdHMvZ2V0X21haW50YWluZXIucGwgLWYg
DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L3RpL2Nwc3dfZXRodG9vbC5jIE9uIDIyLzAzLzIyIDEy
OjAyIHBtLCBTb25kaGF1w58sIA0KPiBKYW4gd3JvdGU6ID4gY3Bzd19ldGh0b29sIHVzZXMgdGhl
IHBvd2VyIG1hbmFnZW1lbnQgaW4gdGhlIA0KPiBaalFjbVFSWUZwZnB0QmFubmVyU3RhcnQNCj4g
VGhpcyBNZXNzYWdlIElzIEZyb20gYW4gRXh0ZXJuYWwgU2VuZGVyDQo+IFBsZWFzZSB1c2UgY2F1
dGlvbiB3aGVuIGNsaWNraW5nIG9uIGxpbmtzIG9yIG9wZW5pbmcgYXR0YWNobWVudHMhDQo+IFpq
UWNtUVJZRnBmcHRCYW5uZXJFbmQNCj4gDQo+IEhpLA0KPiANCj4gQWRkaW5nIG5ldGRldiBsaXN0
IGFuZCBtYWludGFpbmVycw0KPiANCj4gUGxlYXNlIGNjIG5ldGRldiBNTCBhbmQgbmV0IG1haW50
YWluZXJzDQo+IA0KPiAuL3NjcmlwdHMvZ2V0X21haW50YWluZXIucGwgLWYgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvdGkvY3Bzd19ldGh0b29sLmMNCj4gDQo+IE9uIDIyLzAzLzIyIDEyOjAyIHBtLCBT
b25kaGF1w58sIEphbiB3cm90ZToNCj4+IGNwc3dfZXRodG9vbCB1c2VzIHRoZSBwb3dlciBtYW5h
Z2VtZW50IGluIHRoZSBiZWdpbiBhbmQgY29tcGxldGUNCj4+IGZ1bmN0aW9ucyBvZiB0aGUgZXRo
dG9vbF9vcHMuIFRoZSByZXN1bHQgb2YgcG1fcnVudGltZV9nZXRfc3luYyB3YXMNCj4+IHJldHVy
bmVkIHVuY29uZGl0aW9uYWxseSwgd2hpY2ggcmVzdWx0cyBpbiBwcm9ibGVtcyBzaW5jZSB0aGUg
ZXRodG9vbC0NCj4+IGludGVyZmFjZSByZWxpZXMgb24gMCBmb3Igc3VjY2VzcyBhbmQgbmVnYXRp
diB2YWx1ZXMgZm9yIGVycm9ycy4NCj4+IGQ0M2M2NWIwNWI4NCAoZXRodG9vbDogcnVudGltZS1y
ZXN1bWUgbmV0ZGV2IHBhcmVudCBpbiBldGhubF9vcHNfYmVnaW4pDQo+PiBpbnRyb2R1Y2VkIHBv
d2VyIG1hbmFnZW1lbnQgdG8gdGhlIG5ldGxpbmsgaW1wbGVtZW50YXRpb24gZm9yIHRoZQ0KPj4g
ZXRodG9vbCBpbnRlcmZhY2UgYW5kIGRvZXMgbm90IGV4cGxpY2l0bHkgY2hlY2sgZm9yIG5lZ2F0
aXZlIHJldHVybg0KPj4gdmFsdWVzLg0KPj4gDQo+PiBBcyBhIHJlc3VsdCB0aGUgcG1fcnVudGlt
ZV9zdXNwZW5kIGZ1bmN0aW9uIGlzIGNhbGxlZCBvbmUtdG9vLW1hbnkNCj4+IHRpbWVzIGluIGV0
aG5sX29wc19iZWdpbiBhbmQgdGhhdCBsZWFkcyB0byBhbiBhY2Nlc3MgdmlvbGF0aW9uIHdoZW4N
Cj4+IHRoZSBjcHN3IGhhcmR3YXJlIGlzIGFjY2Vzc2VkIGFmdGVyIHVzaW5nDQo+PiAnZXRodG9v
bCAtQyBldGgtb2YtY3BzdyByeC11c2VjcyAxMjM0Jy4gVG8gZml4IHRoaXMgdGhlIGNhbGwgdG8N
Cj4+IHBtX3J1bnRpbWVfZ2V0X3N5bmMgaW4gY3Bzd19ldGh0b29sX29wX2JlZ2luIGlzIHJlcGxh
Y2VkIHdpdGggYSBjYWxsDQo+PiB0byBwbV9ydW50aW1lX3Jlc3VtZV9hbmRfZ2V0IGFzIGl0IHBy
b3ZpZGVzIGEgcmV0dXJuYWJsZSBlcnJvci1jb2RlLg0KPj4gDQo+IA0KPiBwbV9ydW50aW1lX3Jl
c3VtZV9hbmRfZ2V0KCkgaXMganVzdCB3cmFwcGVyIGFyb3VuZCBwbV9ydW50aW1lX2dldF9zeW5j
KCkNCj4gKyBlcnJvciBoYW5kbGluZyAoYXMgZG9uZSBpbiB0aGUgYmVsb3cgY29kZSkgYW5kIGJv
dGggcmV0dXJuIDAgb24NCj4gc3VjY2VzcyBhbmQgLXZlIGVycm9yIGNvZGUgb24gZmFpbHVyZQ0K
DQpwbV9ydW50aW1lX2dldF9zeW5jIHJldHVybnMgLXZlIGVycm9yIGNvZGUgb24gZmFpbHVyZSBh
bmQgMCBvbiBzdWNjZXNzIA0KYW5kIGFsc28gMSBpcyByZXR1cm5lZCBpZiBub3RoaW5nIGhhcyB0
byBiZSBkb25lIGJlc2lkZXMgaW5jcmVtZW50IG9mIA0KdGhlIHVzYWdlIGNvdW50ZXIuDQpTbyBm
b3IgYWN0aXZlIGRldmljZXMgdGhhdCBkb24ndCBuZWVkIHRvIGJlIHJlc3VtZWQgYSAxIGlzIHJl
dHVybmVkLg0KcG1fcnVudGltZV9yZXN1bWVfYW5kX2dldCBpcyBhIHJldHVybi1mcmllbmRseSB3
cmFwcGVyIHRoYXQgcmV0dXJucyANCi1lcnJvciBjb2RlIG9uIGZhaWx1cmUgYnV0IHJldHVybnMg
MCBvbiBib3RoIG90aGVyIGNhc2VzLg0KDQo+IA0KPiANCj4+IFNpZ25lZC1vZmYtYnk6IEphbiBT
b25kaGF1c3MgPGphbi5zb25kaGF1c3NAd2Fnby5jb20+DQo+PiAtLS0NCj4+ICBkcml2ZXJzL25l
dC9ldGhlcm5ldC90aS9jcHN3X2V0aHRvb2wuYyB8IDIgKy0NCj4+ICAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4+IA0KPj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L3RpL2Nwc3dfZXRodG9vbC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
dGkvY3Bzd19ldGh0b29sLmMNCj4+IGluZGV4IDE1OGM4ZDM3OTNmNC4uNWVkYTIwMDM5Y2MxIDEw
MDY0NA0KPj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvdGkvY3Bzd19ldGh0b29sLmMNCj4+
ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3RpL2Nwc3dfZXRodG9vbC5jDQo+PiBAQCAtMzY0
LDcgKzM2NCw3IEBAIGludCBjcHN3X2V0aHRvb2xfb3BfYmVnaW4oc3RydWN0IG5ldF9kZXZpY2Ug
Km5kZXYpDQo+PiAgCXN0cnVjdCBjcHN3X2NvbW1vbiAqY3BzdyA9IHByaXYtPmNwc3c7DQo+PiAg
CWludCByZXQ7DQo+PiAgDQo+PiAtCXJldCA9IHBtX3J1bnRpbWVfZ2V0X3N5bmMoY3Bzdy0+ZGV2
KTsNCj4+ICsJcmV0ID0gcG1fcnVudGltZV9yZXN1bWVfYW5kX2dldChjcHN3LT5kZXYpPiAgCWlm
IChyZXQgPCAwKSB7DQo+PiAgCQljcHN3X2Vycihwcml2LCBkcnYsICJldGh0b29sIGJlZ2luIGZh
aWxlZCAlZFxuIiwgcmV0KTsNCj4+ICAJCXBtX3J1bnRpbWVfcHV0X25vaWRsZShjcHN3LT5kZXYp
Ow0KPiANCj4gDQo+IEluIGZhY3QgY29kZSBub3cgZW5kcyB1cCBjYWxsaW5nIHBtX3J1bnRpbWVf
cHV0X25vaWRsZSgpIHR3aWNlIGluIGNhc2UNCj4gb2YgZmFpbHVyZSwgb25jZSBpbnNpZGUgcG1f
cnVudGltZV9yZXN1bWVfYW5kX2dldCgpIGFuZCBhZ2FpbiBoZXJlPw0KPiANCj4gU28gc29tZXRo
aW5nIGxvb2tzIGZpc2h5Pw0KDQpTb3J0IG9mLiBUaGVyZSBpcyBubyBhY3R1YWwgZmFpbHVyZSBi
dXQgcG1fcnVudGltZV9wdXQgaXMgc3RpbGwgY2FsbGVkIA0KdHdpY2UuIFRoYXQgaXMgZHVlIHRv
DQoJMS4gY3Bzd19ldGh0b29sX29wX2JlZ2luIHJldHVybmluZyAxIHdoZW4gaXQgc2hvdWxkIHJl
dHVybiAwDQoJMi4gZXRobmxfb3BzX2JlZ2luIHRyZWF0aW5nIHZhbHVlcyBub3QgZXF1YWwgdG8g
MCBhcyBmYWlsdXJlDQoJMy4gY29hbGVzY2VfcHJlcGFyZV9kYXRhIG9ubHkgdHJlYXRpbmcgbmVn
YXRpdmUgdmFsdWVzIGFzIGZhaWx1cmUNCg0KVGhlIHBhdGNoIGFkZHJlc3NlcyAxLg0KDQpJbiBu
ZXQvZXRodG9vbC9uZXRsaW5rLmM6MzMgZXRobmxfb3BzX2JlZ2luKCkgdGhlIGNwc3dfZXRodG9v
bF9vcF9iZWdpbiANCmlzIGNhbGxlZCAocmV0dXJuaW5nIDEpIGFuZCBpbiB0aGUgZXJyb3IgcGF0
aCBvZiBldGhubF9vcHNfYmVnaW4gYSANCnBtX3J1bnRpbWVfcHV0IGlzIGNhbGxlZC4gVGhlIGZ1
bmN0aW9uIGNhbGxpbmcgZXRobmxfb3BzX2JlZ2luIG9ubHkgDQpjaGVja3MgZm9yIG5lZ2F0aXZl
IHZhbHVlczogbmV0L2V0aHRvb2wvY29hbGVzY2UuYzo2MCANCmNvYWxlc2NlX3ByZXBhcmVfZGF0
YSBhbmQgY29udGludWVzIHRoZSBzdWNlc3MgcGF0aCBjYWxsaW5nIA0KZXRobmxfb3BzX2NvbXBs
ZXRlLiBldGhubF9vcHNfY29tcGxldGUgYWxzbyBjYWxscyBwbV9ydW50aW1lX3B1dC4gU28gdGhl
IA0Kc3VjY2VzcyBwYXRoIG9mIGNvYWxlc2NlX3ByZXBhcmVfZGF0YSBhbmQgdGhlIGVycm9yIHBh
dGggb2YgDQpldGhubF9vcHNfYmVnaW4gYm90aCBlbmQgdXAgY2FsbGluZyBwbV9ydW50aW1lX3B1
dCB3aGVuIG9ubHkgb25lIG9mIHRoZW0gDQpzaG91bGQuDQoNCj4gDQo+IFJlZ2FyZHMNCj4gVmln
bmVzaA0KPiANCg0KUmVnYXJkcywNCkphbg==
