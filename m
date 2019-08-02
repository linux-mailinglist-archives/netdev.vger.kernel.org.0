Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 512C980042
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 20:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406803AbfHBSiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 14:38:16 -0400
Received: from mail-eopbgr40071.outbound.protection.outlook.com ([40.107.4.71]:8834
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406031AbfHBSiQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 14:38:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mTIH055eiU2C7FZIj0m7SsgCbVlQupE0ul8vmQKVCiXJztQEJtq0ZYk/5jwv7vzzKj5qs3AD/Ua/hfDd4labyPH3jTrz6NMO3ZrbnTRRLpaU5kvnm2SyOr2EmR8BUaLu8I5akqNswsWNHUAXXOcS3cd5dhWRZKsSgHIAVgRoaGu6QgMVByg4uZcsLUEkElugNgJofLzc9T1+XlFFV+Xm6vs7T/+Hd4w2HndL1HoiAOPuwglOigyafYnsPlNzYLrj3SXwHnC/jrD2AN1kreIo6HarzEpff6jfQZmGIQIodY2FFMFbv1YA8nQTDPp3MrSuLtLS/6QwG2wddb1G7ZOdJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ay4ogoaFsUTMsLjNg9Ch0n/oxQIV0FIoDzD3AkToIFw=;
 b=MUov6SqK1Mu5u3miDmULXPeyL7kfId6BTBIReXRh6GQtipM/TdB0lFfvwQRBfs0KYIi/ULOeOmO9KgQIFgTV5L5vu8LIAp4Jr4SC6dYB/ALoVy+gInIS4FgPyoVs+mnSRNxOtQ2YY7IVqb4GvO4j4k8KaWByInQlVaWiarVIf1hFYwtKHX9Wb39RsJZkc/ZxlV0mwvb9YAHrcKgIn11/Y9LsjYtnonBVzaZT675blkDjTgvxYq5BMXEnnCU/cgg19sX8yJqCvL49psTC7MlYgFrL/dhKvEF/2NCxct0ULnisPzh7+cjtWPPuIsdDmxpOQG3gzw7muZs4z5VXDVmY2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ay4ogoaFsUTMsLjNg9Ch0n/oxQIV0FIoDzD3AkToIFw=;
 b=pVaBTL+ptviGYzugTZi5ZykKr/0udyzy1bC/CKulJfpV94N056U7cZgSZJzvz7hbszQXejGQjUrwV892PMsJSy1KgVAsOMNvMuMSUmSh0upli0+s53gQ40TkXGEHmfTyQRNdq+8TEfRT9LrL3wVvUmqyDQt4icRuq/sXVW4Dn0I=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2357.eurprd05.prod.outlook.com (10.168.56.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.13; Fri, 2 Aug 2019 18:38:12 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2136.010; Fri, 2 Aug 2019
 18:38:12 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "hslester96@gmail.com" <hslester96@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net/mlx4_core: Use refcount_t for refcount
Thread-Topic: [PATCH] net/mlx4_core: Use refcount_t for refcount
Thread-Index: AQHVSStMLiVN2iFTN0GUnSwRdh0TSaboB10AgAApK4A=
Date:   Fri, 2 Aug 2019 18:38:12 +0000
Message-ID: <47bb83d0111f1132bbf532c16be483c5efbe839f.camel@mellanox.com>
References: <20190802121020.1181-1-hslester96@gmail.com>
         <CANhBUQ1chO0Q6wHJwbKMvp6LkD7qLBRw57xwf1QkBAKaewHs5w@mail.gmail.com>
In-Reply-To: <CANhBUQ1chO0Q6wHJwbKMvp6LkD7qLBRw57xwf1QkBAKaewHs5w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5528a7e7-8373-4247-f0fd-08d71778932f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2357;
x-ms-traffictypediagnostic: DB6PR0501MB2357:
x-microsoft-antispam-prvs: <DB6PR0501MB2357699A8453B14BBF577565BED90@DB6PR0501MB2357.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(199004)(189003)(2351001)(1361003)(68736007)(7736002)(478600001)(4744005)(66066001)(26005)(66946007)(99286004)(3846002)(66556008)(91956017)(6116002)(102836004)(76116006)(5660300002)(81156014)(305945005)(6436002)(6512007)(53936002)(118296001)(6506007)(71190400001)(64756008)(5640700003)(229853002)(2616005)(476003)(486006)(11346002)(66446008)(76176011)(81166006)(446003)(2906002)(256004)(186003)(36756003)(6486002)(6916009)(4326008)(71200400001)(2501003)(66476007)(25786009)(8676002)(1411001)(86362001)(58126008)(316002)(54906003)(14454004)(6246003)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2357;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fSm71Wz9d+kzHxepVq3nJcWNmYsjIwMGKPb+w5EKNMc3L/GHsyD4GQNYuiRSE8f6K5iBfEVQV7txma/ZJIkXCplCH2+SbUNza7VFcsS6KqdOzJ/PnGJ8Ol0PaZqs9mdoZ6lN/W+GwSJcRVOiddT5ZavdR2kbpNzLQ2VbGQ2vISUbfJMQ+40dLP7G+fpnOxsoJQfOaolSHTPgaM3TpK/HEGRHFPlyudRswWaVcT4ZQ1E7BTj0fEbNLof3UP104VXQxjEZHuqIlr0UMTbX2MmZh5Pnj5wQeVJEiUGmM4YPJ/V3geTvH6J4fLmfKru3nPn1Fjd9jmCHbLbnl1iCudHHbCOakitjHJIcy/8DHwaekSqu+M8/yJhQkdNzdTgRUsBXBOSiuxB2FPRBKXfAvTWEBaqaHR6kRs1zXnOftXOto5U=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D8B334C94E5324196A324D59583A0A7@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5528a7e7-8373-4247-f0fd-08d71778932f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 18:38:12.7692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2357
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDE5LTA4LTAzIGF0IDAwOjEwICswODAwLCBDaHVob25nIFl1YW4gd3JvdGU6DQo+
IENodWhvbmcgWXVhbiA8aHNsZXN0ZXI5NkBnbWFpbC5jb20+IOS6jjIwMTnlubQ45pyIMuaXpeWR
qOS6lCDkuIvljYg4OjEw5YaZ6YGT77yaDQo+ID4gcmVmY291bnRfdCBpcyBiZXR0ZXIgZm9yIHJl
ZmVyZW5jZSBjb3VudGVycyBzaW5jZSBpdHMNCj4gPiBpbXBsZW1lbnRhdGlvbiBjYW4gcHJldmVu
dCBvdmVyZmxvd3MuDQo+ID4gU28gY29udmVydCBhdG9taWNfdCByZWYgY291bnRlcnMgdG8gcmVm
Y291bnRfdC4NCj4gPiANCj4gPiBBbHNvIGNvbnZlcnQgcmVmY291bnQgZnJvbSAwLWJhc2VkIHRv
IDEtYmFzZWQuDQo+ID4gDQo+IA0KPiBJdCBzZWVtcyB0aGF0IGRpcmVjdGx5IGNvbnZlcnRpbmcg
cmVmY291bnQgZnJvbSAwLWJhc2VkDQo+IHRvIDEtYmFzZWQgaXMgaW5mZWFzaWJsZS4NCj4gSSBh
bSBzb3JyeSBmb3IgdGhpcyBtaXN0YWtlLg0KDQpKdXN0IGN1cmlvdXMsIHdoeSBub3Qga2VlcCBp
dCAwIGJhc2VkIGFuZCB1c2UgcmVmY291dF90ID8NCg0KcmVmY291bnQgQVBJIHNob3VsZCBoYXZl
IHRoZSBzYW1lIHNlbWFudGljcyBhcyBhdG9taWNfdCBBUEkgLi4gbm8gPw0K
