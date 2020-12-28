Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F2F2E3B1F
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 14:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404965AbgL1Np5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 08:45:57 -0500
Received: from rcdn-iport-5.cisco.com ([173.37.86.76]:53260 "EHLO
        rcdn-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404934AbgL1Npw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 08:45:52 -0500
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Dec 2020 08:45:51 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3942; q=dns/txt; s=iport;
  t=1609163150; x=1610372750;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cFn+9jM6BZQa4VxkUjSOAzhKPnL527qUWBlENAcXC6A=;
  b=Rmq4VIvb7HGJatg9q5YEDYekL4NJONR1Rm+5X7TKeC6SAXlG0qe8ACtF
   +EiqRz2i8KVzsHFVywZc40PUZpMVbI/tixryxi4Ou6TzjBUs1MeeD9BJN
   rT4aQj1gif5rjm7lh8bmoIxvSZONkI8ZwSubDKnlwRvnhhbv12TkoVoU4
   8=;
IronPort-PHdr: =?us-ascii?q?9a23=3AtCnA5BZ1y+KTJ5GVRxmYzS//LSx94ef9IxIV55?=
 =?us-ascii?q?w7irlHbqWk+dH4MVfC4el21QaRD57G8P8CgPiF+6zjWGlV55GHvThCdZFXTB?=
 =?us-ascii?q?YKhI0QmBBoG8+KD0D3bZuIJyw3FchPThlpqne8N0UGA9vlahvZsC764TsbAB?=
 =?us-ascii?q?6qMw1zK6z8EZLTiMLi0ee09tXTbgxEiSD7b6l1KUC9rB7asY8dho4xJw=3D?=
 =?us-ascii?q?=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CUAADS3ulf/51dJa1iHAEBAQEBAQc?=
 =?us-ascii?q?BARIBAQQEAQFAgTwGAQELAYFSIy4HdlsvLgqENYNIA406JQOERpRHgS6BfAg?=
 =?us-ascii?q?DAQEBDQEBHw4CBAEBhEoCF4FcAiU1CA4CAwEBCwEBBQEBAQIBBgRxhWEMhXQ?=
 =?us-ascii?q?BAQQSEREMAQE3AQ8CAQgOCgICJgICAjAVEAIEAQ0FGweDBAGCVQMtAQGjQQK?=
 =?us-ascii?q?BPIgRBVN2gTKDBAEBBoEzAQsBgQyCQBiCEAMGN1cqAYJ0g3yCRoNyJhuCAIE?=
 =?us-ascii?q?4DBCCVj6CXQEDgU4PF4EhgWA0giyBaYFXLxAggSI9PDWPFAQcNIJ7pRsKgna?=
 =?us-ascii?q?BGIgSjz+CbwMfgymKK5R8LY4fhT+LEJFihEECBAIEBQIOAQEGgVgDNYFXcBV?=
 =?us-ascii?q?lAYI+HzEXAg2OIQwXg06EWYV/dDcCBgEJAQEDCXyJbYEzAYEQAQE?=
X-IronPort-AV: E=Sophos;i="5.78,455,1599523200"; 
   d="scan'208";a="576202342"
Received: from rcdn-core-6.cisco.com ([173.37.93.157])
  by rcdn-iport-5.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 28 Dec 2020 13:35:51 +0000
Received: from XCH-ALN-001.cisco.com (xch-aln-001.cisco.com [173.36.7.11])
        by rcdn-core-6.cisco.com (8.15.2/8.15.2) with ESMTPS id 0BSDZpXj009663
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 28 Dec 2020 13:35:51 GMT
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by XCH-ALN-001.cisco.com
 (173.36.7.11) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 28 Dec
 2020 07:35:50 -0600
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by xhs-rtp-002.cisco.com
 (64.101.210.229) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 28 Dec
 2020 08:35:49 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-002.cisco.com (173.37.227.247) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 28 Dec 2020 07:35:49 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MxcqOdtyTt9TZ7kJP8bb4qlpTpz4J4RvhiWlFUQ5l6lAk/E3hPA5687AQHDlyP3ToCiltqIO4w21i/dC7DBv1xLE1NA5jZY0ZdQ4+yYtoRLB2BxoV168Qw38G/XTWHoXwH4YmpfOHDoT1fLrK53cgDp2v2retZJJClcBUDyHORoGo/ots/KnWRt6QG6t0UPzNAqRxwDP089pRj7qNH1SYgnvssqBdFIKlVNfMq/QCOgPLElSzm33c97W1RQM3FyNyVNfFshWAa6ARU7YkRap6NnZlhLVNoq9oc/2jFUkZvzpeIxyWm/G5IeLB2icAxnaebKnBsSTGG8i5rOp/UEoKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cFn+9jM6BZQa4VxkUjSOAzhKPnL527qUWBlENAcXC6A=;
 b=RxPmUjFaU6nivCHe9IQ4hC/xghP/YQdwV8ur11GWZQLS0zr/eBhWr97x3Bc4aB/MuGHb50JyoOGQux1HyfuT/DaFltJaGBEQrXMAsNyObkxlJUG5gIyYssY/6NLy0TlujH4RqgS1Mtcil8J7P0v/V5QM6ZDyQz6H9ZI3Ur06v+PSFTBiK+48tr0xSQTjz+mSEalVz02QxTNchTyjZOqhetMK9ZHpG/OeeFJSDiS76RS583RU7iA9UoWE7nc25OLYobHTeqpwe82bpwopFwW2edOCphhZSe7hbcvbOINGmxnUD4SA37pkxao/JKH1mieFU1rLEuXDqMQC5BPSGfHI1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cFn+9jM6BZQa4VxkUjSOAzhKPnL527qUWBlENAcXC6A=;
 b=boIVO6/IqPTKILPW55bd8hLP2p72Qb/hyXTOvFgw+OlLvprnyiZnhYkOr02prxyLH/80pmPQCRh2D+gsM7uHt44w3R4UUkf3uP4lQvzsxTeUrXFUrbrXpaQWoU5ZE1ZNMbKsLS65SselejM+3Ow7JFx4IL7zgHwaKzJyyJZEPuM=
Received: from DM5PR11MB0057.namprd11.prod.outlook.com (2603:10b6:4:6b::12) by
 DM6PR11MB3673.namprd11.prod.outlook.com (2603:10b6:5:145::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3700.31; Mon, 28 Dec 2020 13:35:46 +0000
Received: from DM5PR11MB0057.namprd11.prod.outlook.com
 ([fe80::b581:18b2:7681:d902]) by DM5PR11MB0057.namprd11.prod.outlook.com
 ([fe80::b581:18b2:7681:d902%3]) with mapi id 15.20.3676.033; Mon, 28 Dec 2020
 13:35:46 +0000
From:   "Rudy Lei (shlei)" <shlei@cisco.com>
To:     Michal Kubecek <mkubecek@suse.cz>, Bruce LIU <ccieliu@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: "ethtool" missing "master-slave" args in "do_sset"
 function.[TEXT/PLAIN]
Thread-Topic: "ethtool" missing "master-slave" args in "do_sset"
 function.[TEXT/PLAIN]
Thread-Index: AQHW3AmPsq8A64Kj+E66v3bpidbYLqoKsj6AgAJYegA=
Date:   Mon, 28 Dec 2020 13:35:46 +0000
Message-ID: <F54C0F7F-7F43-4444-B900-5E5DAAB0B723@cisco.com>
References: <d7196d65-c994-2e19-d41c-386a4957ac63@gmail.com>
 <20201227094633.GA5267@lion.mk-sys.cz>
In-Reply-To: <20201227094633.GA5267@lion.mk-sys.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.44.20121301
authentication-results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [119.113.188.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7cfa4f86-5ad9-4fab-6960-08d8ab357b56
x-ms-traffictypediagnostic: DM6PR11MB3673:
x-microsoft-antispam-prvs: <DM6PR11MB36739C967A2C2AA1199EDEAFBBD90@DM6PR11MB3673.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Nr/XHpLOkcMJ0cenCeFjHmOMefM2dvuTl7urZMerR1Aeqx9yawav5z/aOgc9lSBKpczT+c3nvzjviajNA1LE19PTxgkpoxs1b8wcy+QMeM+XVpprwD7HpnLnGWfX5JZFSQjjinHSGtxDeIDp2bvJtMvxeZhKXbS+7k/+F8uJxJjw+wbs9ymeAs8nixxe7KhgmvZQuR8N2rZZDkLiWiZZ5K9rii30QdnOx5bowUZbCkYEtdBKl3+mtczlDoLj/HhsTtkIYEl5RXNYEVk2jZzgidy/T4o3XsqA5XJ/huL1Rabh9XkA7XlRhB+pI87oiv8Uh2FtNIRUuBuOewfozi31OtvnQZYY1X6EtOEjbTKWGlvgZln3knJmHduWlmreVifUFGsZPzVTkPTTxKji2z3qO4+J4gj6OpwJeeAlsnNTh7lRcSrmgiOD/Hm7S4OnRuQOhDWptGJ6zUt7ivuNFFE/JasxZJdTPLqzn/lz7nCgeta043l/wjdOWq7+8sxZctssHKMivLvcbV6+SwV4XNwNFA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0057.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(136003)(346002)(39860400002)(4326008)(478600001)(6486002)(26005)(186003)(36756003)(83380400001)(33656002)(86362001)(66946007)(91956017)(66476007)(2616005)(316002)(66556008)(8936002)(110136005)(8676002)(66446008)(76116006)(64756008)(5660300002)(2906002)(966005)(6512007)(6506007)(71200400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?L2g5Z2x6K3YzRGZGUlRteld3QTRQYktwQVJxRVAzcFZVaDdmUmF1d1gzeGVQ?=
 =?utf-8?B?OW9KRFkrdm9QOExqbEVPT3VycWcwN0xJSzUwaVJ0aE4wbFd1b3YxOUsvSWVt?=
 =?utf-8?B?R0VMVFNPTmxCQTR1d3ZKRnZyTE42ck5EWXJtNGROenZ6eUJVOXRoTXFzNVZT?=
 =?utf-8?B?WklDSHVwcFBMRyswaXZYOUd5K1g0SnpBRGsvVEExVTk1dU0xcHBzcmo1b1VU?=
 =?utf-8?B?R0M4ZmV5Y1BNY2s4M3hxdGIzT0lyUnBvdU9YVExGWUd1RWFpUk1ONmFHM1BL?=
 =?utf-8?B?QkNocm0ybVlZMCszVEhTekM4elBiZFBIaVhHSTJaaWFsMGhaeFVPK0xKZ3V4?=
 =?utf-8?B?dHJsTzVibEFqL3FuWnZaQ25kUzFBN0tKbS8wWUNCWXM5VDBoTGFsT01iZG1Y?=
 =?utf-8?B?amRaVXczekQxZ2F2UlZvNEVEdjZxcFVPcEpQdTV1Vy9Za3lXTms5RnFTU1pj?=
 =?utf-8?B?ZVF3T0dIVDE0VE81dUJCVWZZc3RsbFpZbGNKMzFEcVJ2MHhwemJoN3g2anpk?=
 =?utf-8?B?RFlLS0VYV0NxclRXZ2F0T3V6cmxZTDJWc2FNNHZXTzUxUnJkNlE2UTE3YlB4?=
 =?utf-8?B?eGZyNVBrR3RzQ1RUbkNsbjl5b1VUSERpdklreDlCZm4wajJoTm5nK3lhR3p5?=
 =?utf-8?B?RWt6Y2twR2lCOFFydnVSc1RaaUhMR004eDcrdG8vRWtGZ2RHRE85MXlPYkN3?=
 =?utf-8?B?VkorYmJLSmpjMThpdHhLRlZBNFJ4RHI5MFdYOGhBNDVOMnlONTlSNGJRTkZn?=
 =?utf-8?B?bU1pMjM3NUgwRS95OU54MTNocFBCY21FZ2p2WGtlbkw4UVNFZzRudnl0TXhQ?=
 =?utf-8?B?ZlNZSm1yL3g5ZHgwY0tuckhIVVhjalFFV1hIdmlQYXgwa1VCNDRhUUJtb3hQ?=
 =?utf-8?B?TEQ4THovUzhUdkdmUkE1SndzNVhWZlRPSXVzUEJCeGwrSVduOVc0UDd5Y2lY?=
 =?utf-8?B?Q1JBYVc1RWpxOWNpVHJFVlpTanM4MVhkclo0REpsaFlmbHh5QnRjT0xyMWxl?=
 =?utf-8?B?NU5zVS9NU1FKNHFBeUd2SklmZGZoakhoeU51R0JsMnZIeUo5T0ZQbnRyTm5O?=
 =?utf-8?B?WUpIbDBaUDcxajBQeGtMbDRxMnRFdzl2UWhabUUzYjdBNjBPRWkxdGEyUkNQ?=
 =?utf-8?B?Mm1EYlVaWXRxQ3gxNWJGcFRkNHhmWVNzOE1lRXRtSVJQMkdwbU9BaUxTS0k3?=
 =?utf-8?B?Z0FscFJMQ3MvWWxHTG52Tys0UHRVMmJyTEFTNkFBaDIySWM4UTVrMzVHTnBJ?=
 =?utf-8?B?T1JxQ1AwbWVlMTM5Y045bVpLbEZQK3NTcCtCYTNoRzhWZzRYUnZGaWJ0cDFY?=
 =?utf-8?Q?/I8LbqKW0Y9wpQbemDj3uDmpoUGzcTSFVZ?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D7A08D62FD40444968C47A5DE5E027D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0057.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cfa4f86-5ad9-4fab-6960-08d8ab357b56
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Dec 2020 13:35:46.2662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5cqEtFYijG6rMPTPkyBmGEKl3cArKZhqxKuaxOxqX7FqNuFy9rrrE3W5Kh1y1Rgj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3673
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.11, xch-aln-001.cisco.com
X-Outbound-Node: rcdn-core-6.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBNaWNoYWwsDQogDQpNZXJyeSBDaHJpc3RtYXMgYW5kIHRoYW5rcyBhIGxvdCBmb3IgdGhl
IHByb21wdCByZXBseS4NCkFmdGVyIHVwZ3JhZGVkIHRoZSBrZXJuZWwgdG8gNS4xMCBhbmQgd2Ug
ZGlkIHNlZSB0aGUgZXhwZWN0ZWQgbG9nczoNCg0KW3Jvb3RAc2hsZWktZGV2LW1hY2hpbmUgfl0j
IGV0aHRvb2wgLXMgZW5zMzIgbWFzdGVyLXNsYXZlIHByZWZlcnJlZC1tYXN0ZXINCm5ldGxpbmsg
ZXJyb3I6IG1hc3Rlci9zbGF2ZSBjb25maWd1cmF0aW9uIG5vdCBzdXBwb3J0ZWQgYnkgZGV2aWNl
IChvZmZzZXQgMzYpDQpuZXRsaW5rIGVycm9yOiBPcGVyYXRpb24gbm90IHN1cHBvcnRlZA0KDQog
DQpCZXN0IFJlZ2FyZHMsDQpSdWR5DQoNCu+7v09uIDIwMjAvMTIvMjcsIDU6NDYgUE0sICJNaWNo
YWwgS3ViZWNlayIgPG1rdWJlY2VrQHN1c2UuY3o+IHdyb3RlOg0KDQogICAgT24gU3VuLCBEZWMg
MjcsIDIwMjAgYXQgMTI6MzQ6MDlQTSArMDgwMCwgQnJ1Y2UgTElVIHdyb3RlOg0KICAgID4gSGkg
TWljaGFsIEt1YmVjZWsgYW5kIE5ldHdvcmsgZGV2IHRlYW0sDQogICAgPiANCiAgICA+IEdvb2Qg
ZGF5ISBIb3BlIHlvdSBhcmUgZG9pbmcgd2VsbC4NCiAgICA+IFRoaXMgaXMgQnJ1Y2UgZnJvbSBD
aGluYSwgYW5kIHBsZWFzZSBhbGxvdyBtZSB0byBjYyBSdWR5IGZyb20gQ2lzY28gU3lzdGVtcw0K
ICAgID4gaW4gQ2hpbmEgdGVhbS4NCiAgICA+IA0KICAgID4gV2UgYXJlIGZhY2luZyBhIHdlaXJk
IGJlaGF2aW9yIGFib3V0ICJtYXN0ZXItc2xhdmUgY29uZmlndXJhdGlvbiIgZnVuY3Rpb24NCiAg
ICA+IGluIGV0aHRvb2wuDQogICAgPiBQbGVhc2UgY29ycmVjdCBtZSBpZiBJIGFtIHdyb25nLi4u
Lg0KICAgID4gDQogICAgPiBBcyB5b3Uga25vdywgc3RhcnQgZnJvbSBldGh0b29sIDUuOCwgICJt
YXN0ZXIvc2xhdmUgY29uZmlndXJhdGlvbiBzdXBwb3J0Ig0KICAgID4gYWRkZWQuDQogICAgPiBo
dHRwczovL2x3bi5uZXQvQXJ0aWNsZXMvODI4MDQ0Lw0KICAgID4gDQogICAgPiA9PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT0NCiAgICA+IEFwcGVhbDoNCiAgICA+IENvbmZpcm0gYW5kIGRpc2N1c3Mgd29ya2Fyb3Vu
ZA0KICAgID4gDQogICAgPiA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCiAgICA+IElzc3VlIGRlc2NyaXB0aW9u
Og0KICAgID4gQXMgd2UgdGVzdCBpbiBsYWIsIG5vICJtYXN0ZXItc2xhdmUiIG9wdGlvbiBzdXBw
b3J0ZWQuDQogICAgPiANCiAgICA+ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KICAgID4gSXNzdWUgcmVwcm9k
dWNlOg0KICAgID4gcm9vdEByYXNwYmVycnlwaTp+IyBldGh0b29sIC1zIGV0aDAgbWFzdGVyLXNs
YXZlIG1hc3Rlci1wcmVmZXJyZWQNCiAgICA+IGV0aHRvb2w6IGJhZCBjb21tYW5kIGxpbmUgYXJn
dW1lbnQocykNCiAgICA+IEZvciBtb3JlIGluZm9ybWF0aW9uIHJ1biBldGh0b29sIC1oDQogICAg
PiANCiAgICA+ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PQ0KICAgID4gRW52aXJvbm1lbnQ6DQogICAgPiBkZWJp
YW4tbGl2ZS0xMC43LjAtYW1kNjQtc3RhbmRhcmQuaXNvDQogICAgPiBLZXJuZWwgNS40Ljc5DQoN
CiAgICBUaGlzIGlzIHRoZSBwcm9ibGVtLiBLZXJuZWwgc3VwcG9ydCBmb3IgdGhpcyBmZWF0dXJl
IHdhcyBhZGRlZCBpbg0KICAgIDUuOC1yYzEgc28gdGhhdCB5b3VyIGtlcm5lbCBkb2VzIG5vdCBo
YXZlIGl0IGFuZCB0aGVyZSBpcyBubyBjaGFuY2UgaXQNCiAgICBjb3VsZCBwb3NzaWJseSB3b3Jr
LiBOZXdlciBldGh0b29sIGhhcyBzdXBwb3J0IGZvciB0aGlzIGZlYXR1cmUgYnV0DQogICAga2Vy
bmVsIG11c3Qgc3VwcG9ydCBpdCBhcyB3ZWxsIGZvciBpdCB0byBhY3R1YWxseSB3b3JrLg0KDQog
ICAgQnV0IEkgYWdyZWUgdGhhdCB0aGUgZXJyb3IgbWVzc2FnZSBpcyBtaXNsZWFkaW5nLiBXZSBo
YW5kbGUgc3ViY29tbWFuZHMNCiAgICBzdXBwb3J0ZWQgb25seSBpbiBuZXRsaW5rIHdpdGggcHJv
cGVyIGVycm9yIG1lc3NhZ2Ugd2hlbiBpb2N0bCBmYWxsYmFjaw0KICAgIGlzIHVzZWQgYnV0IHdl
IGRvbid0IGRvIHRoZSBzYW1lIGZvciBuZXcgcGFyYW1ldGVycyBvZiBleGlzdGluZw0KICAgIHN1
YmNvbW1hbmRzIHdoaWNoIGFyZSBnZW5lcmFsbHkgc3VwcG9ydGVkIGJ5IGlvY3RsIGNvZGUuIFRo
YXQncyB3aHkgdGhlDQogICAgY29tbWFuZCBsaW5lIHBhcnNlciB1c2VkIGJ5IGlvY3RsIGNvZGUg
ZG9lcyBub3QgcmVjb2duaXplIHRoZSBuZXcNCiAgICBwYXJhbWV0ZXIgYW5kIGhhbmRsZXMgaXQg
YXMgYSBzeW50YXggZXJyb3IuDQoNCiAgICBXZSdsbCBuZWVkIHRvIGhhbmRsZSBuZXcgcGFyYW1l
dGVycyBpbiBpb2N0bCBwYXJzZXIgc28gdGhhdCBpdCBwcm9kdWNlcw0KICAgIG1vcmUgbWVhbmlu
Z2Z1bCBlcnJvciBmb3IgcGFyYW1ldGVycyBvbmx5IHN1cHBvcnRlZCB2aWEgbmV0bGluay4gTG9u
Zw0KICAgIHRlcm0sIHRoZSBwcm9wZXIgc29sdXRpb24gd291bGQgcHJvYmFibHkgYmUgdXNpbmcg
b25lIHBhcnNlciBmb3IgYm90aA0KICAgIG5ldGxpbmsgYW5kIGlvY3RsIGJ1dCB0aGF0IHdhcyBz
b21ldGhpbmcgSSB3YW50ZWQgdG8gYXZvaWQgZm9yIG5vdyB0bw0KICAgIHJlZHVjZSB0aGUgcmlz
ayBvZiBpbnRyb2R1Y2luZyBzdWJ0bGUgY2hhbmdlcyBpbiBiZWhhdmlvdXIgb2YgZXhpc3RpbmcN
CiAgICBjb2RlLg0KDQogICAgTWljaGFsDQoNCg==
