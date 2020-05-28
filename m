Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FAF1E6CEF
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 22:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407428AbgE1U4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 16:56:12 -0400
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:34255
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406652AbgE1U4K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 16:56:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJzmu10+x97oIGJa4Gdh7fhHTxCpnyPJp9jYOMqcCtdCZZADJEl2syGBZ0f79eHEVZE0SJi0Ih63IR0BIFhHTh+Yea1ZDT44QuTmuQFn61qGPVhs+X1GX9P+pN9lkqKRwDggkCjBM6DL31EB1udz6UVGdc/guL6XQnkU78UH67Nv0MdGE24ZTY6W+X36i+lmhEBJYkWybM/79ZJZUmnnGbnhkCLt5UEizOnDc1a9NAPtPu8WfF2nLcrFOSscPbBbTSfR+t98AzaTmp/3vshR3GkidVrN4dQK7MW1PUJgn3EYj8MR2hqn5zjqWyThqEPE3Ai/YIcW64VmlYtZbmBmMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y2ZfdSVQgL3VwYU7/u1QoEmSmk9AGSF1Mt1hZqRxpIg=;
 b=Jm3gme6QOsbwtP4ovYBTayjVPQubMnQKyxamapOYpdxfa2jNRbp6rMLAYYCcOvyUCBYS3j6gcDjnGGiUQK7OPae2VSlF5lOO2rt7WUkgyYjhpBAAaqb9WtGKGG7u2OD0ombfw1hftml9tfYHMv8OAJs2BT9x2tlA+nIw8TDDYuOcslWR3ZE/ePdPOY45SILIwBtn31E6TkC77mPe61UO9YtY8PYFkm5rNq1Q5iRzQxNxZLJbaMD56JMe6rcRQZFfIC7kOfTwnEh3E2i2Ho4jfNnvJIdclaQhqcQKeHCCfftjqRwdDk+aOsuO/81S3BLl3YbWEDWImUTHo/L/S4OIQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y2ZfdSVQgL3VwYU7/u1QoEmSmk9AGSF1Mt1hZqRxpIg=;
 b=piEv1FezTzsKWjjsBRANRDYhbs/Pl2wKLW+z/OvM5Ahog9fuuOYK8ctgYi/Z/2CPvykWuwvqR7dK+CJs5V5muCJBS1Fvy9saT1ohu0WaTQbds7cB/mzgusocsuxxpPCyoboCUrmsBl0gwD+wSYQNU2Izzlr6fj3VSO6onQdZFGw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5423.eurprd05.prod.outlook.com (2603:10a6:803:9b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Thu, 28 May
 2020 20:56:06 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.030; Thu, 28 May 2020
 20:56:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vlad Buslov <vladbu@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>, Eli Cohen <eli@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>, Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH net-next] net/mlx5e: Uninitialized variable in
 mlx5e_attach_decap()
Thread-Topic: [PATCH net-next] net/mlx5e: Uninitialized variable in
 mlx5e_attach_decap()
Thread-Index: AQHWNO5DwrX+rPTcSECQ1OrLUIYM0Ki9+vAA
Date:   Thu, 28 May 2020 20:56:06 +0000
Message-ID: <49b098dad758ba232c1e41a00421daafedc1fda0.camel@mellanox.com>
References: <20200528124803.GC1219412@mwanda>
In-Reply-To: <20200528124803.GC1219412@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 (3.36.2-1.fc32) 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c309b716-65cd-4c44-e5e2-08d803498ab5
x-ms-traffictypediagnostic: VI1PR05MB5423:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB542344F08CAB55BA2566E2C5BE8E0@VI1PR05MB5423.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0417A3FFD2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mNJT+UXRBMys1AxBSb3hVjP/7uef5BgRnLKE86OY/Z4cuaJ+X2I9nH5W1rrKaWz2rsQ87EqiwE8CwEmkg//AtEI/xBQkVdgYGBBdQ+1FocCFUgV5F8OACcYqXXItAYjyT8Rr4acM2cLynUgFNVcSkdlqOUuShXhJum2bhppWr7LnyDYTDArEcbsFCO6SCjjQcJVFIAH/lovDUplE6EzQhw+RYKdvkFRXAeL/FmED/q7I/HPX6/tJSa2x6ZBzp4hqkljDo2/tNASj7SsEMFZR5v/xb+iQZ4AbdXRKnVJCFdPMkFatxwW46Mpkaqbawx+K
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(8676002)(6506007)(6486002)(4326008)(478600001)(54906003)(2616005)(186003)(26005)(71200400001)(6916009)(316002)(8936002)(6512007)(83380400001)(36756003)(91956017)(66476007)(66556008)(66946007)(4744005)(66446008)(64756008)(76116006)(86362001)(107886003)(5660300002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: +cORoJh66yQotqd7OROXca1oslnLbyfLjeEIUP1hC/AedHyLBOQGlLUFw5Dv4f+DvvcWAMRMtT56IHyhPZg+bjBoCPGOyE35ElQuPTjuaRiSCqq+xHjwoEXpNrrp9WJxvA2Z754Gdakz6Ma9BQbXHNseuh/Ho6Erm+gUAAvJq2a/nB4/RCQMzYqVJp6Bacn69ZS1LSRNq8U3ZVfsWUdy3ji7IzgVBiD32l/gfIqfnvVaP1DQ5wi/gJPr/6j9B9WxlzfUcSs6ykDTTAP+suUgwmksE4+q05qSUu5EBM3Zv/rJV00nZiQo41evRzHtXjwepRuV2EOP3T6jbANSHlgq3b7k2/WQaDP2gWIENeJvzMGIzggAdp5f9ZMUi9QRq5v/eopr/6sm7G7495cU0c4Zy5syyv9Uzs66n6KVlbu6PuCjchTAl/ZKw+BwQH8fjbEtugvNVxkrAOT1uLdaACIODrpY5cWuGSuXIBwBOLXRvho=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A414E5E58DF2044B8D4D5743C4E5B30@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c309b716-65cd-4c44-e5e2-08d803498ab5
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2020 20:56:06.6888
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q7o9uKXY3brE5Wutb7SrOhzvgARSK9Qzim2E6jlQFKCn+qdURpM8cn7N/sKysCi3lX9PBeVBYmPCy3s9gDnYmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5423
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA1LTI4IGF0IDE1OjQ4ICswMzAwLCBEYW4gQ2FycGVudGVyIHdyb3RlOg0K
PiBUaGUgInJldCIgdmFyaWFibGUgaXNuJ3QgaW5pdGlhbGl6ZWQgb24gdGhlIHN1Y2Nlc3MgcGF0
aC4NCj4gDQo+IFRoZXJlIGlzIGFuIHVuaW5pdGVudGlvbmFsIGJlaGF2aW9yIGluIGN1cnJlbnQg
cmVsZWFzZXMgb2YgR0NDIHdoZXJlDQo+IGluc3RlYWQgb2Ygd2FybmluZyBhYm91dCB0aGUgdW5p
bml0aWFsaXplZCB2YXJpYWJsZSwgaXQgaW5zdGVhZA0KPiBpbml0aWFsaXplcyBpdCB0byB6ZXJv
LiAgU28gdGhhdCBtZWFucyB0aGF0IHRoaXMgYnVnIGxpa2VseSBkb2Vzbid0DQo+IGFmZmVjdCB0
ZXN0aW5nLg0KPiANCj4gRml4ZXM6IDE0ZTZiMDM4YWZhMCAoIm5ldC9tbHg1ZTogQWRkIHN1cHBv
cnQgZm9yIGh3IGRlY2Fwc3VsYXRpb24gb2YNCj4gTVBMUyBvdmVyIFVEUCIpDQo+IFNpZ25lZC1v
ZmYtYnk6IERhbiBDYXJwZW50ZXIgPGRhbi5jYXJwZW50ZXJAb3JhY2xlLmNvbT4NCg0KSGkgRGFu
LA0KDQp0aGFua3MgZm9yIHRoZSBmaXgsICBhIHNpbWlsYXIgZml4IHdhcyBhbHJlYWR5IHN1Ym1p
dHRlZCB5ZXN0ZXJkYXkgYW5kDQppIGFscmVhZHkgcHVsbGVkIGl0IGludG8gbXkgdHJlZSwgSSB3
aWxsIHNlbmQgYSBwdWxsIHJlcXVlc3QgdG8gbmV0LQ0KbmV4dCBzb29uLg0KDQpUaGFua3MsDQpT
YWVlZC4NCg0K
