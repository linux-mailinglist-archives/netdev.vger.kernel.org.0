Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5057D232679
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 22:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgG2Uva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 16:51:30 -0400
Received: from mail-eopbgr60075.outbound.protection.outlook.com ([40.107.6.75]:31553
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726476AbgG2Uva (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 16:51:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hToJcbzHzPSSITevL1qAy1f19zh5GuaboAuDdUGbe3evddQFtUDmm/4U3Zaf3nmMT2qbUr/n/iDeApVc0PMJp0ygRhvtY1GwLhx1hN4WCw6LvLeau9EsqRPpMJmOtjG75YYbNo1Hk/ZLljdh+TZFQocx0IynCqlBlO4s32N59I/paYW4JBuBChCmAX0TvveNLJw7mVohFQPbk4eTNnpMquhlWV8noZ2uKpkjFq6XV15wgYzcc8/IFT6p+ASzEfDW44/LKiOKw7+UvKRdrTcpvYXJO/NcjNu/qZDq4jxufMXk+6MQayH8A0SgOflGAcKk7RheUPZTEd8qRYpky+a6Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATG7qSS3S9bcECWvrs2lvkTK1zLz6m/24bzDxeJq0Dg=;
 b=B8HPwWfr+/wxMR8MIQlBVQj3krAuz72QL+0mlWosPU0DI6rZ7MLVPEATwJuiZ7e9gS0FFEBtLe2Jk9zbSSXfb8/5EH633plzEZlGoYVAzj8N6lUbdwfak9n+R8TsAZwv2bvyWBq7w/qrIOVoyqSScpaQIJmv8Q4SLgGrl2GRKn0zVHIZFtRh8lBj4wbL+QZxcAF1637jKIC+dvN8vgBNALom5uMOCyv66wYVN9oiXAmQq+alLO1Zj5/tZ7vtf+NH2RokH38Q+2lWRkd+2KnHH1s/9RRkBbOAdztlkpYAkGqxDv5OLRUT7pZWOJ22ADt2Zrz9Jym5meA6hp2vPNvW0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATG7qSS3S9bcECWvrs2lvkTK1zLz6m/24bzDxeJq0Dg=;
 b=aW8ZYKnk8+tmDV6IfvJMwrJ7GawC6hHE8+BFNVC/fI0irqNvQAQfmS6Y3elSAo8d9xfpzSVCa02Bc/F2eBX5NXU89WPe62lO5aMnJ+UsY6i6e1ppXZYvSUr3QahxkDmKT9cDaitk9msNU3KHGRsDfH4O9Ujl276XrpcOisIH4Jw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5694.eurprd05.prod.outlook.com (2603:10a6:803:cd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Wed, 29 Jul
 2020 20:51:25 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Wed, 29 Jul 2020
 20:51:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "songliubraving@fb.com" <songliubraving@fb.com>,
        "hawk@kernel.org" <hawk@kernel.org>, "kafai@fb.com" <kafai@fb.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "xiongx18@fudan.edu.cn" <xiongx18@fudan.edu.cn>,
        "yhs@fb.com" <yhs@fb.com>, "ast@kernel.org" <ast@kernel.org>,
        "andriin@fb.com" <andriin@fb.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "tanxin.ctf@gmail.com" <tanxin.ctf@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyuyang19@fudan.edu.cn" <xiyuyang19@fudan.edu.cn>,
        "yuanxzhang@fudan.edu.cn" <yuanxzhang@fudan.edu.cn>
Subject: Re: [PATCH] net/mlx5e: fix bpf_prog refcnt leaks in mlx5e_alloc_rq
Thread-Topic: [PATCH] net/mlx5e: fix bpf_prog refcnt leaks in mlx5e_alloc_rq
Thread-Index: AQHWZaSD4+bJSZVEQUqH8FFGnSv/eKke6kCAgAAYKQCAAAZTAA==
Date:   Wed, 29 Jul 2020 20:51:23 +0000
Message-ID: <2199f90fb6394d60d8dc62b15c6a6e62a22e4f41.camel@mellanox.com>
References: <20200729123334.GA6766@xin-virtual-machine>
         <613fe5f56cb60982937c826ed915ada2de5e93a2.camel@mellanox.com>
         <20200729.132842.190888844026802233.davem@davemloft.net>
In-Reply-To: <20200729.132842.190888844026802233.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.4 (3.36.4-1.fc32) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 90d107f8-8831-41c5-51f9-08d8340127c1
x-ms-traffictypediagnostic: VI1PR05MB5694:
x-microsoft-antispam-prvs: <VI1PR05MB5694F1077594284AE01C5A16BE700@VI1PR05MB5694.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iIlP7rbhfD5Y4Xk/JXqor+J3p0DNARUVrxV+eEkjEljypVGzpWlfesg0QUt5HFOncEmexVtr3YgmeD8xlLUDI6bGlBpyb4R06vJPZx98+JSdQBs7KShvzB5s3zC6AAC0zGHrR0dhNUqFHHKhcG1E8eIfmyMIcU/zFbAYwKJo+H1WBY1TQJW952YuW1IiZbws8BoB/gqNl1VuVUU9jasNPm6MMgkha9Ie6BSQZdJbGd864dFqjUr93zGgcO1zyX/17H4cgpAegdd2XRz7SmT7YuQRlsSml5vOcrrt/DabToYCadC2wk/KSsUdytH2GGFrCQ4KRhbDk3Ma57wmRt/f7g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(2906002)(36756003)(66946007)(71200400001)(4744005)(76116006)(64756008)(478600001)(6512007)(66446008)(91956017)(66556008)(7416002)(316002)(66476007)(54906003)(8936002)(6486002)(5660300002)(86362001)(6916009)(8676002)(26005)(186003)(6506007)(4326008)(2616005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ZkPioEl42y7OftyPWrvJknbAsV0qCntyHZ84huThK5eb8B0oXLWU89sUhzMo2oJacuxNyX6nAUwbODpGP5s9IpCo2yXtZNVOjQi49djay2JGk7BaYSa5bUwhuMLc9bd9i8l75RtemFsR6n9rUgIR1j3UafdVqSsrmt93+l7LN2dzexTtgm+O++gPI5m0Hm1RTpgkXrI1GCR7W+m5JEIcxhY+DjooF3O/V7+s/piN7oTH4wBulaNoH+syuaWyOhsjoLPqcMe1Z6mtFX5Um8Z3HBGRembCiHDvZ+Y1i1o5oPh1spmgp87lnc6Qt1puaxt/bB6dWboIyt2GtyTV16e2d2DTHhgqPewbeCJtpACvGycFGxI0TtDT696/+7oHhJ8GlFN5kpa3zcaNoZ+1AQ4VNuzANitJhvJVOeKR4Blw8dbbo8IQvbtBs2ydDKdORzXc4diADZGiqYgGHl5s+6kCS+WsSgmXJitQJC3lpOrirLs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A05DF2DD34D2F145881D6421727DC25A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90d107f8-8831-41c5-51f9-08d8340127c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2020 20:51:23.7775
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b/pxPP7UffeILrjkEIqxQIo+qTP6CMDSbnJPcil6bt5uTlLFHjnWgCejcanmht727znZYyJF+IyBILN2TeyLeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5694
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA3LTI5IGF0IDEzOjI4IC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiBEYXRlOiBXZWQs
IDI5IEp1bCAyMDIwIDE5OjAyOjE1ICswMDAwDQo+IA0KPiA+PiBGaXggdGhpcyBpc3N1ZSBieSBq
dW1waW5nIHRvIHRoZSBlcnJvciBoYW5kbGluZyBwYXRoDQo+ID4+IGVycl9ycV93cV9kZXN0cm95
DQo+ID4+IHdoZW4gZWl0aGVyIGZ1bmN0aW9uIGZhaWxzLg0KPiA+PiANCj4gPiANCj4gPiBGaXhl
czogNDIyZDRjNDAxZWRkICgibmV0L21seDVlOiBSWCwgU3BsaXQgV1Egb2JqZWN0cyBmb3IgZGlm
ZmVyZW50DQo+IFJRDQo+ID4gdHlwZXMiKQ0KPiANCj4gU2FlZWQsIGFyZSB5b3UgZ29pbmcgdG8g
dGFrZSB0aGlzIGludG8geW91ciB0cmVlIG9yIHdvdWxkIHlvdSBsaWtlIG1lDQo+IHRvDQo+IGFw
cGx5IGl0IGRpcmVjdGx5Pw0KPiANCj4gVGhhbmtzLg0KDQpJIHdpbGwgdGFrZSB0aGlzIHRvIG15
IHRyZWUgb25jZSBYaW4gYWRkcyB0aGUgbWlzc2luZyBGaXhlcyB0YWcuDQpUaGFua3MuDQoNCg==
