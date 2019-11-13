Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0ADFB26D
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 15:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbfKMOVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 09:21:51 -0500
Received: from rcdn-iport-6.cisco.com ([173.37.86.77]:40387 "EHLO
        rcdn-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfKMOVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 09:21:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3588; q=dns/txt; s=iport;
  t=1573654909; x=1574864509;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GE6tTVsA8AdaK2jWSfC6qbqzuFfmQxUwutsowh9Uihk=;
  b=KtKXcJ4zrCdEEi/4rOh3Woi2ynV/hPNNSthiOyHi25omlm93WlS1hY6g
   2YlT07FuK4mwmh9B41W4pdyjmwX5PkN9duT+X6aPlUKvoI6+HV4b61ZFs
   0ej/+7UvaOfoq5WE58BlpjFJ7GcYrA5MG40Ahsd0Q2YFBvgpss67+UnlI
   4=;
IronPort-PHdr: =?us-ascii?q?9a23=3AYroK8xdyeVE1o+WTLWBqPSQClGMj4e+mNxMJ6p?=
 =?us-ascii?q?chl7NFe7ii+JKnJkHE+PFxlwGQD57D5adCjOzb++D7VGoM7IzJkUhKcYcEFn?=
 =?us-ascii?q?pnwd4TgxRmBceEDUPhK/u/bzYzGchLT15N9HCgOk8TE8H7NBXf?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0BaAQAlEcxd/4MNJK1kHAEBAQEBBwE?=
 =?us-ascii?q?BEQEEBAEBgW0EAQELAYFKUAWBRCAECyqEKYNGA4pzgl6YAIFCgRADVAkBAQE?=
 =?us-ascii?q?MAQEtAgEBgUyCdAIXggkkNwYOAgMLAQEEAQEBAgEFBG2FNwyFUgEBAQIBEhE?=
 =?us-ascii?q?RDAEBNwEPAgEIGgImAgICMBUQAgQBDSeDAIJHAw4gAaUXAoE4iGB1gTKCfgE?=
 =?us-ascii?q?BBYUVGIIXCYEOKAGMExiBQD+BOB+CTD6ELheDEDKCLI0CgwueDAoeggqVRxu?=
 =?us-ascii?q?Zfopvg1iZfAIEAgQFAg4BAQWBaCOBWHAVZQGCQVARFJEag3OKU3SBKJA7AQE?=
X-IronPort-AV: E=Sophos;i="5.68,300,1569283200"; 
   d="scan'208";a="664978393"
Received: from alln-core-1.cisco.com ([173.36.13.131])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 13 Nov 2019 14:21:48 +0000
Received: from XCH-ALN-006.cisco.com (xch-aln-006.cisco.com [173.36.7.16])
        by alln-core-1.cisco.com (8.15.2/8.15.2) with ESMTPS id xADELm3R027311
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 13 Nov 2019 14:21:49 GMT
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by XCH-ALN-006.cisco.com
 (173.36.7.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 Nov
 2019 08:21:48 -0600
Received: from xhs-rcd-003.cisco.com (173.37.227.248) by xhs-rtp-002.cisco.com
 (64.101.210.229) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 Nov
 2019 09:21:46 -0500
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-003.cisco.com (173.37.227.248) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 13 Nov 2019 08:21:46 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJ+03s/GfoMKZ3SQVr3FArObdbpdmcZn9PBZBcCN+AsjJeJ6w1KxqwftkPTMOEg3bc+OOncy0ZNMogp83X3TpBhTmlz4RVzYtoQjCiWvwBGFPk9VSJjajwKawTu7ujOfpqvtXyFPMAgVWVe1eaaPYPbmdBzqq0s/PipwM/46nCeQY27ohH+kw4F13sWCq3Cn1Mq/EFl2UN5eEg5350MqCrlU755Rtq6eVAvWmyM8+8ARnRulgbghrvZr1lTfyJ/AobxPMu3rFCKPtkTPGMi2WpxKKsb6gzkZIgmsQ+TFjXtB9fxJUJQ65hmqGtgpc7Dsf4AxyRXeFrqahvAILlpRzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GE6tTVsA8AdaK2jWSfC6qbqzuFfmQxUwutsowh9Uihk=;
 b=DGyuC0ad7VdIf3OlmmBNGK8AoRxEOgwcNZQ2TMY+BR6hndjARNfMOgchY3cYOy8SnZS/kzzh6UlLrhkxzy0QO9wkHpUbo3Oa0cGpBWxBxmY49mJfSQmLKyX57/BA6iPLhy3a7N0FurGT1Wo7sPXu+YDimWv73mOJTBuMS8gfheNZLh5VXTOnKWJEGIAiKvoaSLsXSsh/Ltec+nV6MLO7HJKWuliwIZb3GY1Q0OSoE9M3YF0r6Eyk7VY97ae8Mi4sdVuVsXWgj6hDCYBXutyWcyCLzsvPS+w+qBFlBx9ZYvSQUVl2Ex6CGxAumBRsdmqID4HZtu/tMGbef0MOVODRrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GE6tTVsA8AdaK2jWSfC6qbqzuFfmQxUwutsowh9Uihk=;
 b=thqtSU2LxCzVG1OWL+YDQu9Rkl/4Cb8CGVrKI285cIUqIx1YdVo4S4muinUM5lnVIE6Qlja9uhlWYzm6DuNBmGi+lMnfgen70ZfhHlxQZeRgoeHi9CtpMuEYuKyNDEv+LRGOMWh/mTA96nqFktfm5sHpzLhWSRcqpRgfbaPVUEc=
Received: from CY4PR1101MB2311.namprd11.prod.outlook.com (10.174.53.140) by
 CY4PR1101MB2247.namprd11.prod.outlook.com (10.172.76.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Wed, 13 Nov 2019 14:21:45 +0000
Received: from CY4PR1101MB2311.namprd11.prod.outlook.com
 ([fe80::703d:f3d9:40d4:55fc]) by CY4PR1101MB2311.namprd11.prod.outlook.com
 ([fe80::703d:f3d9:40d4:55fc%5]) with mapi id 15.20.2451.023; Wed, 13 Nov 2019
 14:21:45 +0000
From:   "HEMANT RAMDASI (hramdasi)" <hramdasi@cisco.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Daniel Walker (danielwa)" <danielwa@cisco.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Sathish Jarugumalli -X (sjarugum - ARICENT TECHNOLOGIES HOLDINGS
        LIMITED at Cisco)" <sjarugum@cisco.com>
Subject: Re: [PATCH net] gianfar: Don't force RGMII mode after reset, use
 defaults
Thread-Topic: [PATCH net] gianfar: Don't force RGMII mode after reset, use
 defaults
Thread-Index: AQHVmXjf3wbj+LJfjk+2lQ/PEvIoiqeIHUyA//+nmACAAGFwgIAA/AeAgABiQAA=
Date:   Wed, 13 Nov 2019 14:21:44 +0000
Message-ID: <79AEA72F-38A7-447C-812E-4CA31BFC4B55@cisco.com>
References: <1573570511-32651-1-git-send-email-claudiu.manoil@nxp.com>
 <20191112164707.GQ18744@zorba>
 <E84DB6A8-AB7F-428C-8A90-46A7A982D4BF@cisco.com>
 <VI1PR04MB4880787A714A9E49A436AD2496770@VI1PR04MB4880.eurprd04.prod.outlook.com>
 <873EB68B-47CB-44D6-80BD-48DD3F65683B@cisco.com>
 <VI1PR04MB4880A48175A5FE0F08AB7B2196760@VI1PR04MB4880.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB4880A48175A5FE0F08AB7B2196760@VI1PR04MB4880.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=hramdasi@cisco.com; 
x-originating-ip: [2001:420:c0e0:1004::163]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4841d1a2-9c17-4dc5-407e-08d76844cff0
x-ms-traffictypediagnostic: CY4PR1101MB2247:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1101MB224700DB85D80296911F2ACAC9760@CY4PR1101MB2247.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(199004)(189003)(6486002)(66446008)(54906003)(99286004)(66476007)(66556008)(64756008)(81166006)(305945005)(91956017)(76116006)(66946007)(8936002)(7736002)(81156014)(110136005)(5660300002)(6436002)(316002)(6512007)(229853002)(86362001)(8676002)(71190400001)(33656002)(2906002)(6116002)(102836004)(6636002)(71200400001)(6506007)(478600001)(14454004)(46003)(186003)(25786009)(476003)(2616005)(4326008)(446003)(11346002)(107886003)(76176011)(6246003)(256004)(486006)(14444005)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR1101MB2247;H:CY4PR1101MB2311.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9n09vReZRzCoB40qI4Mr2aFET774+2jZjZTZuWUdA6Uee268zv0ZYqw7MNAlKqes/fTn9XiySAeWlUB3kuQOp/Tux5GwjqNNvU4MokSVD88sd+9JbgZRgE/VGSe8MgX0BtVG/Lj2FFJFaILnWKzxz0p0DGAdJG+5/stHXqeoIz3nslbIQ7f5lLLWy8IIEw96fddzDwsYJh5qMip4T9r4UMbgqg8bkRgOcGiMIBngAhd2xRr5YJfglD6N1C9heDAM9UpyVul2PrRCqV1Eu3oshpMsJsjFkELli/CuRvSSC5vZa9fdQS0mvqEkp4rNzzjs7xP6C86WlfqaIyqVkS/MRfeBkSqA7I3xwSoDbIikySAbf4TUPt/XeqV1OH85EhjTsHgPTs/xS2aQozTECJdq/4Z2ehY6hBUrX0mnDQTLlYx3szXGzSYHjhbT304f8bbW
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE5DF3F40024C442AD874CBD724A5C3E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4841d1a2-9c17-4dc5-407e-08d76844cff0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 14:21:45.0149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tt/32rsdkLkpimDPXJV3AHGgqtCrIn9OfS9V6Q1/kUoMnQRajMLCw29r4FXGJGgoglJvqFUd65RuS3Hj92QyaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2247
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.16, xch-aln-006.cisco.com
X-Outbound-Node: alln-core-1.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ICAgID4+IFRoaXMgYml0IG11c3QgYmUgc2V0IHdoZW4gaW4gaGFsZi1kdXBsZXggbW9kZSAoTUFD
Q0ZHMltGdWxsX0R1cGxleF0gaXMgY2xlYXJlZCkuDQogICAgPg0KICAgID4gU2hvdWxkIHRoZSBi
aXQgYmUgY2xlYXIgd2hlbiBpbiBmdWxsIGR1cGxleCBvciBpdCBkb2VzIG5vdCBtYXR0ZXI/DQog
ICAgPg0KICAgIA0KICAgID4gRnJvbSBteSB0ZXN0cywgaW4gZnVsbCBkdXBsZXggbW9kZSBzbWFs
bCBmcmFtZXMgd29uJ3QgZ2V0IHBhZGRlZCBpZiB0aGlzIGJpdCBpcyBkaXNhYmxlZCwNCiAgICA+
IGFuZCB3aWxsIGJlIGNvdW50ZWQgYXMgdW5kZXJzaXplIGZyYW1lcyBhbmQgZHJvcHBlZC4gU28g
dGhpcyBiaXQgbmVlZHMgdG8gYmUgc2V0DQogICAgPiBpbiBmdWxsIGR1cGxleCBtb2RlIHRvIGdl
dCBwYWNrZXRzIHNtYWxsZXIgdGhhbiA2NEIgcGFzdCB0aGUgTUFDICh3L28gc29mdHdhcmUgcGFk
ZGluZykuDQoNClRoaXMgaXMgbGl0dGxlIHN0cmFuZ2UgYXMgd2UgZG8gbm90IHNlZSB0aGlzIHBy
b2JsZW0gb24gYWxsIHBrdCB0eXBlLCBpY21wIHBhc3NlcyB3ZWxsIGFuZCB3ZSBvYnNlcnZlZCBp
c3N1ZSB3aXRoIHRmdHAgYWNrLiANClNvIHRoZXJlIGlzIG5vIGxpbmsgaXNzdWUuDQoNCiAgICA+
IFRoZSBzdGF0ZW1lbnQgYWJvdmUgbGlrZWx5IG1lYW5zIHRoYXQgZm9yIGhhbGYtZHVwbGV4IG1v
ZGUgcGFja2V0cyBjYW5ub3QgZWdyZXNzDQogICAgPiB0aGUgTUFDIHJlZ2FyZGxlc3Mgb2YgdGhl
aXIgc2l6ZSBpZiB0aGUgUEFEX0NSQyBiaXQgaXMgbm90IHNldC4gIEF0IGxlYXN0IHRoaXMgaXMg
Y29uc2lzdGVudA0KICAgID4gd2l0aCBteSBleHBlcmltZW50cy4NCiAgICANCiAgICA+PiAwIEZy
YW1lcyBwcmVzZW50ZWQgdG8gdGhlIE1BQyBoYXZlIGEgdmFsaWQgbGVuZ3RoIGFuZCBjb250YWlu
IGEgQ1JDLg0KICAgID4+IDEgVGhlIE1BQyBwYWRzIGFsbCB0cmFuc21pdHRlZCBzaG9ydCBmcmFt
ZXMgYW5kIGFwcGVuZHMgYSBDUkMgdG8gZXZlcnkgZnJhbWUNCiAgICA+PiByZWdhcmRsZXNzIG9m
IHBhZGRpbmcgcmVxdWlyZW1lbnQuIg0KICAgID4+DQogICAgPj4gU28gdGhlIGRyaXZlciBzZXRz
IHRoaXMgYml0IHRvIGhhdmUgc21hbGwgZnJhbWVzIHBhZGRlZC4gSXQgYWx3YXlzIHdvcmtlZA0K
ICAgID4+IHRoaXMgd2F5LCBhbmQgSSByZXRlc3RlZCBvbiBQMjAyMFJEQiBhbmQgTFMxMDIxUkRC
IGFuZCB3b3Jrcy4NCiAgICA+PiBBcmUgeW91IHNheWluZyB0aGF0IHBhZGRpbmcgZG9lcyBub3Qg
d29yayBvbiB5b3VyIGJvYXJkIHdpdGggdGhlIGN1cnJlbnQNCiAgICA+PiB1cHN0cmVhbSBjb2Rl
Pw0KICAgID4NCiAgICA+SXQgd29ya3MgYnV0IHRoZSBzZXR0aW5ncyBkb2VzIG5vdCBtYXRjaCB3
aXRoIHdoYXQncyBtZW50aW9uZWQgaW4gcDIwMjAgcm0NCiAgICA+YW5kIHRoZSBiaXQgMjkgYmVj
b21lcyByZWR1bmRhbnQuDQogICAgPg0KICAgIA0KICAgID4gU28sIHRoZSBQQURfQ1JDIGJpdCBp
cyBub3QgcmVkdW5kYW50LCBhbmQgZm9yIGhhbGYtZHVwbGV4IG1vZGUgaXQgbG9va3MgbGlrZSB0
aGlzIGJpdCBpcw0KICAgID4gZXZlbiBtYW5kYXRvcnkgdG8gaGF2ZSBUeCB0cmFmZmljIGF0IGFs
bC4NCiAgICANCiAgICA+IFRoaXMgcGF0Y2ggaXMgaG93ZXZlciBub3QgYWJvdXQgdGhlIFBBRF9D
UkMgYml0LiBJdCdzIGFib3V0IGRlZmF1bHQgaW50ZXJmYWNlIG1vZGUNCg0KVGhpcyBwYXRjaCBs
b29rcyBsaWtlIGRvaW5nIHRoZSBzYW1lIHRob3VnaC4uDQoNCiAgICA+IHNldHRpbmcgaW4gdGhl
IE1BQ0NGRzIgcmVnaXN0ZXIuICBBbmQgSSBqdXN0IG5vdGljZWQgdG8gbXkgc3VycHJpc2UgdGhh
dCB3aXRoIHRoZSBkZWZhdWx0DQogICAgPiByZXNldCB2YWx1ZSBmb3IgaW50ZXJmYWNlIG1vZGUg
KDAwYikgdGhlIFNHTUlJIGxpbmsgd29uJ3QgZ2V0IHVwIG9uIG15IFAyMDIwUkRCLVBDDQogICAg
PiBib2FyZCwgd2hpbGUgdGhlIFJHTUlJIGxpbmtzIGRvbid0IGhhdmUgdGhpcyBwcm9ibGVtLiAg
T24gdGhlIG5ld2VyIExTMTAyMUFUV1IgYm9hcmQNCiAgICA+IHRoZXJlJ3Mgbm8gc3VjaCBpc3N1
ZSAoYm90aCBzZ21paSBhbmQgcmdtaWkgbGlua3Mgd29yayB3aXRoIGRlZmF1bHQgSUZfTW9kZSBv
ZiAwMCkuDQogICAgPiBTbyBsb29rcyBsaWtlIElGX01vZGUgd2FzIGJlaW5nIGluaXRpYWxpemVk
IHRvICJieXRlIG1vZGUiICgxMGIsIGFrYSBSR01JSSAxRyBtb2RlKQ0KICAgID4gd2l0aCBhIHJl
YXNvbiwgc28gdGhhdCBvbGRlciBib2FyZHMgaGF2ZSBmdW5jdGlvbmFsIGxpbmtzIGluIGFsbCBj
YXNlcyAoaS5lLiBzZ21paSkuDQoNCiAgICA+IEJldHRlciB0byBkcm9wIHRoaXMgcGF0Y2ggZm9y
IG5vdyB0byBhdm9pZCBzdWNoIHJlZ3Jlc3Npb25zIGZvciBvbGRlciBib2FyZHMuICBUaGlzIGlz
IHdoYXQNCiAgICA+IGhhcHBlbnMgd2hlbiBsZWdhY3kgZHJpdmVyIGNvZGUgbGlrZSB0aGlzIGdl
dHMgY2hhbmdlZC4gIEknbGwgaGF2ZSB0byBhc2sgaC93IHBwbCBmb3INCiAgICA+IGNsYXJpZmlj
YXRpb24gb24gdGhpcy4NCg0KU3RyYW5nZWx5IHJlcG9ydGVkIGlzc3VlIGlzIG9ic2VydmVkIG9u
bHkgb24gZmV3IFAyMDIwIGRldmljZXMuDQogICAgDQotaGVtYW50DQogICAgDQogICAgDQoNCg==
