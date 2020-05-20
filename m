Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90CC1DA819
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 04:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgETCgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 22:36:02 -0400
Received: from mail-eopbgr00052.outbound.protection.outlook.com ([40.107.0.52]:19830
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726178AbgETCgB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 22:36:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRTXJxrtqqfxGYEQBMnqEb84OQyRCUNJ1LnKfDjp8LC99R9pWCGTk8eVh5qHb6beAicf4G+RebXnJCo3aMeKIpK0S2TnZxDBudq/MdS3bwsMHt58wnUmYHVj55YXz7bX0VClwgUe1j+4FaAPSP/CQDZ0ldEuIbxXyONcnZlzzStsV2XShpgQDI5nHmdPWHRXlEoFRd+auI/xwgA/n5XpKetHV0pSBklnHx0TUKLU7vFbccC6hz8lITpf4od2uATuf/Sl12v4pac5MmjD+hdNJk8f6o0GDwAor+gFdYsxbRrRC/jUXGnUWff3kitaO4wYsL4Vx5uOYu9bmJ9g0KCMwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3c135PkaDaUtNIsrD16AS8vdyipm6qZXtJWcX8z+DI=;
 b=Fs9ftuToqxyfAsrxxWfR1vYCawYPMgw9wWksLLQiK+mdJmNW8LkybQY9/W4W8+Q29ieTyCpvYRN0nEbwbq7fPVzhLPl5efCBBhL1TGmO1Se7XzJ5ZhddlwjeK2Cvro9UMkFTQ+OGPKoPye5rO0qeHLpH7wb3sIh3cSO0k0eSG9R02vdoLU1uH7gmNSb5jyMyqkVBZ9ndX1cWJgz39H0qn0GYaE+GjdoB+iQ68z4D2jPbPPmIWtUNUHaLV3HqSIQ+PJFNv2yo43aPDGaRdOKAG/cqLmGklL48PP5XNpYpxnM/fhs4WNrRra+v8UJ43OAdV7gbS1/vgB8gFdnMKos1Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3c135PkaDaUtNIsrD16AS8vdyipm6qZXtJWcX8z+DI=;
 b=lKooqizphDG9q0dZOsWxIgXn7MILouaiyEI6lY5yyWupg3UKn7IOZqQYDFjl31P3eaFC8QUURcSzRxVGZBA0Qj4SzG3stRomNNFDLWwxfWLGpCd+HFoJhjXntbqZbRa7l7DAlfAdtrpFlWaSoZ6DjgfQXrEdOAUqtYXev0Uk/Ho=
Received: from VI1PR0501MB2653.eurprd05.prod.outlook.com
 (2603:10a6:800:9d::15) by VI1PR0501MB2384.eurprd05.prod.outlook.com
 (2603:10a6:800:66::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Wed, 20 May
 2020 02:35:56 +0000
Received: from VI1PR0501MB2653.eurprd05.prod.outlook.com
 ([fe80::1c05:23c0:3bab:3f9b]) by VI1PR0501MB2653.eurprd05.prod.outlook.com
 ([fe80::1c05:23c0:3bab:3f9b%9]) with mapi id 15.20.3000.034; Wed, 20 May 2020
 02:35:56 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Jiri Pirko <jiri@mellanox.com>
CC:     Roni Bar Yanai <roniba@mellanox.com>,
        Majd Dibbiny <majd@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: BPF for hash calculation
Thread-Topic: BPF for hash calculation
Thread-Index: AQHWLkxHX4pUJzbnT0KjuBB/QRxPM6iwQicA
Date:   Wed, 20 May 2020 02:35:56 +0000
Message-ID: <BAD2E80F-E8BF-4FBC-8C55-DBD35793D08E@mellanox.com>
References: <D6D87E0C-3F64-4552-888B-D1152F062C48@mellanox.com>
In-Reply-To: <D6D87E0C-3F64-4552-888B-D1152F062C48@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [2604:2000:1342:c20:44ce:35d6:a9d2:4e9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1b539822-f60a-43b1-b589-08d7fc668623
x-ms-traffictypediagnostic: VI1PR0501MB2384:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB23846E90CF0BF0AD25F32FF0BAB60@VI1PR0501MB2384.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04097B7F7F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eL2LJVil1lZEfzI9GxwRcNDytRTC6tUFk3ucQx94Chqt6y6VJbwGFzBWxJc+AaOXwWiHBMi159Dn2gAzfMzS+jaC2NiRmaNj/2vl9FzQw0IzGPRPRSe9H8VPRsQUV9rXbxAoaB/nLSsoZpxWT91JZab/MC4o0bGzPonZ21lyUaRLCz8QYxjDw5Oz5/OU8LZ4GfGKoHaJxEu02mXsBh2MRoWrGpelPJ3QbBs9S+sCmloUGadPttJmQcgHXwmvW6JowbDM4VDlvgf/zROgf8mxnOHYtbK0c5BSELx/7m5HJ4md2xBRoPCZd6wu/TA4ro2a
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0501MB2653.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(478600001)(6512007)(6486002)(3480700007)(186003)(33656002)(66476007)(64756008)(6506007)(8676002)(66556008)(53546011)(2616005)(86362001)(66946007)(316002)(6636002)(66446008)(4326008)(36756003)(76116006)(71200400001)(5660300002)(91956017)(54906003)(110136005)(8936002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ybWvasHLE75gBNKXliSGCXGzvnz/dCy8Th3n4TM8mETA0d5lhY95LJOoB2wee4rhD9fgv5Kwpe/sxnq4GHgVcSj003w9uIv10ey4FdnqqzfbRG8rwwqMhTPYfRM2pxCGCnfmWxxDMNXPDbyooe5ufjOEt/oC1Z9nVZftAL304T/qdLriW0s1RVVdbdppWB8Fmn7Qe/pdqdCSUPZrQwNy7m2vOgyS/gpkCVTV64B8qtorFxGu966CCwLBmvmAUHBg4o/sDhzONIYqTxmjXYC/TjjPWElSZSSaGYycj4hwMvvMsHmwopRk0PEvI0uqV+Zk5nxYj1QCw4mgW1FMDfXtdh6cRWC6YNf33NIjjRAI7+o8yxGW/N+zUd/TP05UmXREB66V7WF43vXmaUW4Z7lPzvsuPVqDV4I65Dd+WaNbBW91PH3jg6p1+7wwn3QJyUemBY+7nqTVwZ2nvrvkhpRmTLCYZtsa9Ls3RtO2Y7ope7cwi7/0zMC9L8rrj3FEeeKfGd4miwltWANlnE86uVzpIrhWC8eAU8Vk0e1t83w1iZ+MC4ZSyqlNQAnMlZCVUndX
Content-Type: text/plain; charset="utf-8"
Content-ID: <52A860CC7138B7408AF7DEE1D07A3659@Mellanox365.onmicrosoft.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b539822-f60a-43b1-b589-08d7fc668623
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2020 02:35:56.3015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YdairEwDbOZzadMuogcDYjy7ilxPze9nLfBNT8Rlq4NVGJ0BHMeazNG5b8MIVyop/wyN9FkgKeTDPg8iMEMMmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2384
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTWF5IDE5LCAyMDIwLCBhdCAyMjoxMywgQXJpZWwgTGV2a292aWNoIDxsYXJpZWxAbWVsbGFu
b3guY29tPiB3cm90ZToNCj4gDQo+IO+7v0hpIERhbmllbCwgQWxla3NlaQ0KPiANCj4gSeKAmW0g
d29ya2luZyBvbiBhIGZlYXR1cmUgdG8gYWRkIHN1cHBvcnQgZm9yIGRhdGFwYXRoIGhhc2ggYWN0
aW9ucyBhbmQgbWF0Y2hpbmcgdmlhIFRDIEFQSS4NCj4gDQo+IE9uZSBvZiB0aGUgb3B0aW9ucyB3
ZSB3YW50IHRvIG9mZmVyIHVzZXJzIHRoZXJlIGlzIHRvIHByb3ZpZGUgdGhlaXIgb3duIGhhc2gg
Y2FsY3VsYXRpb24gZnVuY3Rpb24sIGluIHRoZSBmb3JtIG9mIGEgQlBGIHByb2dyYW0uDQo+IFRo
ZSBwcm9ncmFtIHNob3VsZCBhY2NlcHQgc3RydWN0IF9fc2tfYnVmZiBhbmQgcmV0dXJuIGEgaGFz
aCB2YWx1ZS4NCj4gDQo+IEFmdGVyIGEgbGl0dGxlIHJlc2VhcmNoIGFuZCB0ZXN0aW5nIEkgbm90
aWNlZCB0aGF0IHNvbWUga2V5IHBhcmFtZXRlcnMgaW4gc3RydWN0IF9fc2tfYnVmZiBhcmUgc2Vy
dHJpY3RlZCB0byBCUEZfUFJPR19UWVBFX1NLX1NLQiBwcm9ncmFtIHR5cGVzIHdoaWxlIEkgd2Fz
IHBsYW5uaW5nIHRvIHJlLXVzZSB0aGUgZXhpc3RpbmcgIEJQRl9QUk9HX1RZUEVfU0NIRURfQUNU
IHByb2dyYW0gdHlwZSBmb3IgdGhlIGFjdF9oYXNoIHB1cnBvc2UuDQo+IFRoZSBrZXkgcGFyYW1l
dGVycyBJ4oCZbSByZWZlcnJpbmcgdG8gYXJlIGZpZWxkcyBsaWtlIHJlbW90ZV9pcDQsIGxvY2Fs
X2lwNCwgc3JjL2RzdF9wb3J0IChmbG93IGtleSBmaWVsZHMpIHRoYXQgYXJlIG1vc3QgbGlrZWx5
IGdvaW5nIHRvIGJlIHJlbGV2YW50IGZvciBoYXNoIGNhbGN1bGF0aW9uIG9uIGEgcGFja2V0Lg0K
PiANCj4gU28gbXkgcXVlc3Rpb24gdG8geW91IGlzIGJhc2ljYWxseSB3aGF0IGlzIHRoZSBiZXN0
IG9wdGlvbiBoZXJlPyBUaGUgd2F5IEkgc2VlIGl0IHRoZSBvcHRpb25zIGFyZToNCj4gMS4gUmVt
b3ZlIHJlc3RyaWN0aW9ucyBvbiB0aGVzZSBmaWVsZHMgZm9yIFNDSEVEX0FDVCBwcm9ncmFtIHR5
cGUgaW4ga2VybmVsL2JwZi92ZXJpZmllci5jDQo+IDIuIEFkZCBuZXcgcHJvZ3JhbSB0eXBlIFND
SEVEX0FDVF9IQVNIIHdpdGggcGVybWlzc2lvbiB0byBhY2Nlc3MgdGhlc2UgZmllbGRzLg0KPiAz
LiBNb3JlIG9mIGEgcXVlc3Rpb24gLSBpcyB0aGVyZSBhbm90aGVyIHdheSB0byBhY2Nlc3MgdGhl
IGZsb3cga2V5cyB2aWEgc3RydWN0IF9fc2tfYnVmZj8NCj4gDQo+IEFwcHJlY2lhdGUgeW91ciBh
ZHZpY2UgYW5kIHRoYW5rcyBpbiBhZHZhbmNlLg0KPiANCj4gQmVzdCBSZWdhcmRzLA0KPiANCj4g
QXJpZWwgTGV2a292aWNoDQo+IFN0YWZmIGVuZ2luZWVyLCBNZWxsYW5veCBTVw0KDQpGb3Jnb3Qg
dG8gQ0MgcmVsZXZhbnQgbWFpbGluZyBsaXN0Lg0KQWZ0ZXIgZnVydGhlciBkaWdnaW5nIGl0IHNl
ZW1zIHRoZXJl4oCZcyBhIHBvaW50ZXIgdG8gYSBmbG93IGtleXMgc3RydWN0IHRoYXQgaXMgbm90
IHJlc3RyaWN0ZWQgdG8gU0tfU0tCIHByb2cgdHlwZXMgYW5kIHNob3VsZCBiZSBvdXIgYmVzdCBv
cHRpb24uIFRoZSBxdWVzdGlvbiByZW1haW5zIHdoZXRoZXIgd2UgY2FuIHJldXNlIFNDSEVEX0FD
VCB0eXBlIG9yIGEgbmV3IHR5cGUgZm9yIGhhc2ggY2FsY3VsYXRpb24gc2hvdWxkIGJlIGFkZGVk
Pw0KDQoNCg==
