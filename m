Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8DA0465E42
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 07:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355818AbhLBGbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 01:31:33 -0500
Received: from mail-mw2nam10on2083.outbound.protection.outlook.com ([40.107.94.83]:35841
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355836AbhLBGbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 01:31:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IW/jtopxWBgd2S7AaSg3m4+AdQiL9M1I9FNwA21PUXziCYM5F0lariQTZ5piDVOumiEqc08s8azpvWOoFDUGoSGDfJST7+cICl7IyKBoQjgOrxzwBfPJYo8OAbwBCz8pPhMBd+LG7FEoD+rtnkao5HXtp9LPzu2qGZ4c6OLne9QLIxfug7KNDERZUa6jf7wHRRzd+xwZ1SQeDFdzMdJodsVIBb75PtG9yZPi6QaZshCcsy0s0FI9qbIrLxVRbyDN0XOV3yMyMcn+acduP29PtH7YBhHtLwmfXLzIIsw8rpIDKiKRWCMX8yAptwKMurltZbh71tXbyqnIgib+aFC2iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/0hh028U/uCTRCBcobUiZ97WHseGElgMG5TLUnrvSyE=;
 b=UOCdwFYj5tBAzdW5FdScc2RBUp/HnGXRcKvtiQ8diDCvqYdngU1uhNArIl0X0jdOlXRF2alqUfZuSX4CZT4WwQmhCWycsgEB6dAVzl0SdNQ2cKqffLUmcGk8Rs1TktUAMkYCJEgypTPTKqVU/kuPbo17Gvw0dnim5At3qO7H/cxyXIls9Wu72HyS6d09SxgrG0bD8rKwH+snGIEaJcFO+iwCWYMISg9bHen8BpfiF2zKc7TIB6nuZ5LNVBDLfSt0UTlCpATwvyQKk+NkAayP40osmnQjRuIVEBrnAUbWTfvz/griviAKQbw8/KI2k/91Tt1QtJtLM1sEvxyHxYNSKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0hh028U/uCTRCBcobUiZ97WHseGElgMG5TLUnrvSyE=;
 b=mtUP694ypNBGIkkEEDBOf6TxxkQ1uYOr93gY+ikZ+qsjHeW46fnOYSrm7VrZJkj0UlsJTMqJ2EyhcxVmKRKSBsMyrfojEsUcqbtr5eUurLVT3dDyHw364aGl4P7G19Aql0eFwDHBIM8jsbqvdiOsjcLn3w/7ef1BWPO4HzuY/+rCDUF/j6w5UfumLKEnwZaj8lAtYFdB2U11SSkylupmmW6PlNBQ8NkdBhRnkr2GW5acQFEllfinGtiRNV3/20X+knmbY1UO/hJoZI6TA//oyaSXp4dDeH1Fc4Kxtry4O4+NkVWZYZE7lnv5W+QAFFO5l5XEMMpV4RIY52fGTuIEwA==
Received: from DM6PR12MB4220.namprd12.prod.outlook.com (2603:10b6:5:21d::7) by
 DM5PR12MB1356.namprd12.prod.outlook.com (2603:10b6:3:74::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.22; Thu, 2 Dec 2021 06:28:07 +0000
Received: from DM6PR12MB4220.namprd12.prod.outlook.com
 ([fe80::1977:9584:4202:dfda]) by DM6PR12MB4220.namprd12.prod.outlook.com
 ([fe80::1977:9584:4202:dfda%3]) with mapi id 15.20.4734.024; Thu, 2 Dec 2021
 06:28:07 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "leon@kernel.org" <leon@kernel.org>
CC:     Shay Drory <shayd@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "wanjiabing@vivo.com" <wanjiabing@vivo.com>,
        "jiapeng.chong@linux.alibaba.com" <jiapeng.chong@linux.alibaba.com>,
        Vu Pham <vuhuong@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5: SF, silence an uninitialized variable
 warning
Thread-Topic: [PATCH net-next] net/mlx5: SF, silence an uninitialized variable
 warning
Thread-Index: AQHX45nqsaSdGlGv8k6L/AAEyD3RqawYrPUAgAYXXwA=
Date:   Thu, 2 Dec 2021 06:28:07 +0000
Message-ID: <e27f1956b9ac9f63c392990bb3f05125f08720c7.camel@nvidia.com>
References: <20211127141953.GD24002@kili> <YaNLXvuDBnX1LU4y@unreal>
In-Reply-To: <YaNLXvuDBnX1LU4y@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eeb28f5b-a9dc-4005-17c7-08d9b55ce779
x-ms-traffictypediagnostic: DM5PR12MB1356:
x-microsoft-antispam-prvs: <DM5PR12MB135679A5F299008EC848C8BBB3699@DM5PR12MB1356.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /bx5hJTVq40gsC7qWD6psHjpbMpqRDShSiUH2SrY9Fkl0kN/SNCe7dayOGQw6D1QXzYlHYJFl47qksaNesPQJidbL7zHl519/RLND3nN2GvdDHaAppTqznt3I0lrprY85V8DyOyqyNVkW3PzBuY49yhexK5ZngCsQ6jAS99kYS5zeBAxh+Z+pftAXPsE0TRq45NRUtSeJGK5THgCzTAKSqIc5eGwc6ttqbeu7fsI/jKviNs2tCqCU38vqgPIGxP5GWjEo/MmRsB7Jly4acuzau9oECJqOAhJ7ppArk/vgLjf3FWIpH4fg446pTG5xaNy08CPYaRw05Nokohrs//1caqmrzgAnu2fdUpKOGfj+6zJS19wT2v+ymXu3ZbCpbWcL+cUVld8bKyTUuRH4EE9Js+nI1kttAa5RKZ/OLLezDgMX+5VeotxjQ6MeMaeS7pixI1KnuS33a89xuJ6eo05+L/G2XByc8uhiB8MfZUxaFf7V1BPSVi8rzV8EvZhHSSafLE6OAi9s6qHJ/ZEmjNay2Yr+Xw/o8wJDYcaTkWPqnHGd2wb/EOm7WiMBCzbJZHiWzyfRCYY3OjHH08OLY78JBb4S2t2yf1K0xWAX+EvlSXVJPrevj8CQbA/KJUFpfeievXQ/f9O1ron9qi54LZRt1FdJ0o5tw2lobJXiqzFYy5SKmfycfde8AuadQi11ZT/K2J3qVB1U2DpoFVyWCHLgw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4220.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(5660300002)(6486002)(83380400001)(54906003)(2616005)(6506007)(4326008)(508600001)(86362001)(66446008)(2906002)(66476007)(64756008)(8676002)(66556008)(4744005)(71200400001)(6512007)(8936002)(36756003)(91956017)(66946007)(4001150100001)(122000001)(38070700005)(316002)(186003)(76116006)(38100700002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Sk5iNWxmeEttdXFRWkhRUEpQL0ZoNUJrZzdlOEw3OEYvbHkvamNKOXJvR3Y2?=
 =?utf-8?B?b2MxQVE4Ymp3eGFjMlc0ZVVEQTlMdWlCMmxNSndMcWw3ZHAzNTRRenlnd3Ja?=
 =?utf-8?B?RVJFVFRvZEtOajlOYlZNamdEMSswN1JGZG5hMytiYXRIaG1ST3hFM2VMNmN1?=
 =?utf-8?B?UHNaWCtQczY2aytwbFdSdjlIaFpFTHhjakx1YVpMWG5lNjJXY28rYnVNT1F0?=
 =?utf-8?B?aDVNLzhLVCs0aTYzNmlrOVN4TzhjbTk5RlU4dWk4MUJMdkk4VkhDODZES3Ji?=
 =?utf-8?B?N1pTcHg4cmhlSHJCUHNVMmU0NEFYZXNyR2M5NHY1cHlydGRCTDRuWndBRk5s?=
 =?utf-8?B?Zkc4MHdvdDVWblkzaUg5ZFlUbDVPN1VvTUFTTkI5dmd6NDEzbk5Lc1V3eVZL?=
 =?utf-8?B?SHFNelhsQzhyZXdlQnc5QTBzUVB3bk41eXBubjhPMmVxQlRpOHZOTWVCVDhE?=
 =?utf-8?B?c0tDaFBONFBuK3RmVjBPcFo3bTZzSm5JajluSWVyUVVxM0pCek9RVENrRzA4?=
 =?utf-8?B?VXA1ZmExckt6NDVpdzRLZHV5M2VjREhVZWR6RVI0ZEFzcForVGZBczV3MFZk?=
 =?utf-8?B?V1RtQm9VcHBVQUlmd0M1RU9VajRmaytWL0h0cVFUUFhMVjVyckFRekFvYW82?=
 =?utf-8?B?SHJtSmlEZ3IxT3NISTZMcmVPd1FLVzgzcEYzZkNzejZub3E3L2NJN3lIQjdl?=
 =?utf-8?B?d1B4M3JZNFJvUWdMZTdtTGo3ZGM5WmZBNVYvdzlqR1c0QnNnNDRZZ3RJd0Za?=
 =?utf-8?B?V1greW1xSWRLeCtJSU5sNXlydEtTK0VHdkFhVS9aMkZqWWN0a2ZGMXBVNTJY?=
 =?utf-8?B?OERoaDNGRWNqRkladkY4WWFZLytQMUx0eEZZbTFRc1NyOEdnUG13VUxmVzRs?=
 =?utf-8?B?ZWdQMk5teDZKd0puUENkVjVGaGg4S3RwQ2lnRUxIb1B1Ymt0SXdNaDlKN2RF?=
 =?utf-8?B?RkwzQzJBZW8xaEUzSkVLakcvWG5BSVFBMklmZm5FcytGWUo5UmVmNGxWbVJl?=
 =?utf-8?B?RndiTzhGVWZxclpmRlJtMDNFQ3JGTUZEaWVKNUl0QThhcmszN1JSaWhlU1FJ?=
 =?utf-8?B?ZkpWNGJtQTJOVWpwa2FveGsrVHRCRmUwbHU1WmI5Y3RxR2tLU1hOT3JlZmNz?=
 =?utf-8?B?SXY5MzU1QmJJN09IOXp1OXl6VjM1TThHQS9sVVpDZ0VIYllqZVBKbHlHT2Zp?=
 =?utf-8?B?d0MrQWpEelliWmtnc1lITisxN09YSlN3b2daUUNLdVIrRGl3aWI1dGlDMlQ2?=
 =?utf-8?B?YXBRQnZCZXBtUGFiUkRYdm8wWVViSFJCa0c4dXJ3aGFRb3A4b0FOK2Z2S2Vh?=
 =?utf-8?B?Z3dQVTNUK09DR0xKUlJIOThGOUwwZnltTWVpdGFEa0xuT2x5QzJHZXhWQ3M2?=
 =?utf-8?B?SjJtQStoakhqV2gxckxPRWVNNTh1Q1d6TWFJY1g1eXJuRFVQQjlVeVJBU2Nx?=
 =?utf-8?B?WWFwaW5FMXhzSDFoS1FOYVk5dG11KzR5TjJhU29UaW9TMG9TQ1FlNExBNkcz?=
 =?utf-8?B?ZVdQN1hacmtZUzRTSzZVanRyRkxnOCtUOWdmWXd2WXJqc25HSEtOc1A5Tmwx?=
 =?utf-8?B?bG01ZVo2dWhVMjBwWjQ1eG1EMTN1NDZEZ2t6ZkJFMkFFSmE4OU1hbVo1d2NQ?=
 =?utf-8?B?YXRCRzB2ZkR5MFJ2UjBOZlZoQ1h1dmxXU2RRbG9lNG1xQ3R3Q0VyVkZNTUc3?=
 =?utf-8?B?czJDSDd6NGVNMm52eEd4aG9RNlAyVXRtTkF4bG9WNW9HQWNYbXJqdkpDcnJ3?=
 =?utf-8?B?KzFURC9EZnQ3dGcxekdKejlDbng0VkRjVjkzUjIrT0Y1b2xBL0diZHpaeVhm?=
 =?utf-8?B?ZVVhL3RNR3RTUGQvaDBJZEpjaTFLRjRLMDJQbEdhTUdVSWRIcnk5cXN5SUVz?=
 =?utf-8?B?eTVMaVVEQlV3eWxBemwwcytVaXNreGROTFh0bkhPYXkrQ2lJVTdZc2RHY1A4?=
 =?utf-8?B?NWk2NWtRQlZmV0RNUENEWU1TU2xYSHZxU1B5V0Y0aGNCd2xmY1NTU2NQSVJY?=
 =?utf-8?B?NGZFSFZZNURSaU1EOHBxc1ByRlFuK2UrY2dQVWVaV3p5UUI2cXVpSk9RbUZi?=
 =?utf-8?B?bFdJVWhWcm4zNjU5a0RxQ2JQM2FsY25wdlQvTWhiQjJOR1pvbUNORnBEQjdL?=
 =?utf-8?B?V0pLem9laTIzeVpzNzF5MTh4VWFCWEZrYlMyRTliSE9WM1h0akxEWlpISGxP?=
 =?utf-8?Q?5dtjTRJaVLGYAKdqkji8EEo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B520D8C8840274C9F266ED416EB130E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4220.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeb28f5b-a9dc-4005-17c7-08d9b55ce779
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2021 06:28:07.2935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fqH4JK8ZRmCUiy/E40EbsnPjmR+u+yzkr2d8WpXKHPgizWTV1EZ1SG+5H03ZvyBTd3E2aRHX90zmrMG9e9eLhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1356
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIxLTExLTI4IGF0IDExOjI2ICswMjAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIFNhdCwgTm92IDI3LCAyMDIxIGF0IDA1OjE5OjUzUE0gKzAzMDAsIERhbiBDYXJwZW50
ZXIgd3JvdGU6DQo+ID4gVGhpcyBjb2RlIHNvbWV0aW1lcyBjYWxscyBtbHg1X3NmX2h3X3RhYmxl
X2h3Y19pbml0KCkgd2hlbg0KPiA+ICJleHRfYmFzZV9pZCINCj4gPiBpcyB1bmluaXRpYWxpemVk
LsKgIEl0J3Mgbm90IHVzZWQgb24gdGhhdCBwYXRoLCBidXQgaXQgZ2VuZXJhdGVzIGENCj4gPiBz
dGF0aWMNCj4gPiBjaGVja2VyIHdhcm5pbmcgdG8gcGFzcyB1bmluaXRpYWxpemVkIHZhcmlhYmxl
cyB0byBhbm90aGVyDQo+ID4gZnVuY3Rpb24uDQo+ID4gSXQgbWF5IGFsc28gZ2VuZXJhdGUgcnVu
dGltZSBVQlNhbsKgIHdhcm5pbmdzIGRlcGVuZGluZyBvbiBpZiB0aGUNCj4gPiBtbHg1X3NmX2h3
X3RhYmxlX2h3Y19pbml0KCkgZnVuY3Rpb24gaXMgaW5saW5lZCBvciBub3QuDQo+ID4gDQo+ID4g
U2lnbmVkLW9mZi1ieTogRGFuIENhcnBlbnRlciA8ZGFuLmNhcnBlbnRlckBvcmFjbGUuY29tPg0K
PiA+IC0tLQ0KPiA+IMKgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL3Nm
L2h3X3RhYmxlLmMgfCAyICstDQo+ID4gwqAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyks
IDEgZGVsZXRpb24oLSkNCj4gDQo+IFRoYW5rcywNCj4gUmV2aWV3ZWQtYnk6IExlb24gUm9tYW5v
dnNreSA8bGVvbnJvQG52aWRpYS5jb20+DQoNCmFwcGxpZWQgdG8gbmV0LW5leHQtbWx4NS4NCg==
