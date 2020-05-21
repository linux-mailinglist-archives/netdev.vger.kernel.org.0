Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02CD1DD095
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 16:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729878AbgEUO57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 10:57:59 -0400
Received: from mail-am6eur05on2088.outbound.protection.outlook.com ([40.107.22.88]:53728
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728136AbgEUO57 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 10:57:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QsyG9DhmsJoG7nm7xgBTFrBZBNjXFPm7TyeDN0qEJavLAIaxGBC8Y6oLGCTSMI9mQo4ORhdv30161CcaqfhxraBD5e2nngvZXSPYKVREkcVe9/3zJsv/qNcYJf6aRzGvaQo3wipdTsDUKuWwtO+QOikCcDodPPYCgRzH4zKa7scPLwFqR6kLIJLdQfszeRrcfw7fILPn4i8q627oNVR4B/DcBbtCsf9ciZPw8pzw17oYnOHfb1CHmDqzGDAIJhyJtrk2M9/VzF4pxSVE4M73Wb9vPPJGOyh9Cyn0S6lPOBT1kINzaFGh1TFzTjqa774ZDF9SQ9mD5hqjJQ13dOV1dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ZLHoH2yXyNf1o+4l+utYxa9VCpTEcws+5VKgY0s+l0=;
 b=bCPdMpz1iOiBGYtdx3b0uGkMcRMERH1okKvHpW4RkdhNPTvcUT3PSiIakUU7OP2TrqXpYkHI+S29n586UdnBOjuyKQnifLxmK/Qs++ZGvfLuiC6lcgeQpbojtG8jupSK3Q+sqxKE9N9KBZtUWxH9ci0i7Mq4niiV6a+MP5bpPBquQ9bEu70JMVYfdLufxHgBoCXtxmc4oXaQsPDjM+YKpa92wrVOYK1GNi0UOwZP0Tc+lI3iY9CqnwnSTZQxzYo5ZyiQwLwWcTBTf1o7GhHxYvD5cLf/kgZC8+gxIUj/Nv7/YPphp5+3wuASXqm9m4BamlSWoMgvP1ImU3Tt4yD/oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ZLHoH2yXyNf1o+4l+utYxa9VCpTEcws+5VKgY0s+l0=;
 b=HGq5KI6BOHfngyNn3+7EmV8jJocFTWzdFXm38U4fTU0l962NVkkkLPa023TgnOW5ETlmOmTaDje/nGIQd5zrX3jhPOjQuLO3B/IwVPMmwzGHZmGtQ8l9M7522EabPau4Vxm4Muj2S1GJPFEkC4rxYKYZfgIntE2BA88zALQXVqE=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB4724.eurprd05.prod.outlook.com (2603:10a6:208:b7::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Thu, 21 May
 2020 14:57:55 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::5dd6:fa09:c5d1:b387]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::5dd6:fa09:c5d1:b387%7]) with mapi id 15.20.3000.034; Thu, 21 May 2020
 14:57:55 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "galpress@amazon.com" <galpress@amazon.com>,
        "selvin.xavier@broadcom.com" <selvin.xavier@broadcom.com>,
        "sriharsha.basavapatna@broadcom.com" 
        <sriharsha.basavapatna@broadcom.com>,
        "benve@cisco.com" <benve@cisco.com>,
        "bharat@chelsio.com" <bharat@chelsio.com>,
        "xavier.huwei@huawei.com" <xavier.huwei@huawei.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "mkalderon@marvell.com" <mkalderon@marvell.com>,
        "aditr@vmware.com" <aditr@vmware.com>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next v4 01/12] Implementation of Virtual Bus
Thread-Topic: [net-next v4 01/12] Implementation of Virtual Bus
Thread-Index: AQHWLnSkewrcXqJNikqx3whzYE8Vhqiyo3yA
Date:   Thu, 21 May 2020 14:57:55 +0000
Message-ID: <c74808dc-0040-7cef-a0da-0da9caedddd9@mellanox.com>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
 <20200520070227.3392100-2-jeffrey.t.kirsher@intel.com>
In-Reply-To: <20200520070227.3392100-2-jeffrey.t.kirsher@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [106.51.29.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 088e1aad-bf2a-4e66-8880-08d7fd97581b
x-ms-traffictypediagnostic: AM0PR05MB4724:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4724E8E09F0F147B36AB1BAAD1B70@AM0PR05MB4724.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 041032FF37
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 11y7IGHaa6+4wKpSxfdJxxqtX56HfMJT5W6m/1tlBVOYN6VEYJflMHNF6ePcTLmJ9AXL+qv8h3EvrENuqhY25jtfofOlO0F3/YGJZoD8r3UlDKRWC5gsNBvhRwOXM69BzfzeaYelLMXGCIxkWRlbqLBC7I84kmgBQgUF5OjkzwxQMQekJWJtgmOcIJspEL98V8adONKSSJyEeXvq2O/FCWJv0kZwo959mVWfIdwWFqf+hzqvvQqBmWYILHSJM5x2zNqFEB9jq6mw6kyiA5g5LUBJFxJm2kLFTJk+5kpbelNYGKJoVJAx2TRVYEiPM1tCFCqNdA3r/dUutGWQRnkcEhjwX/wAwKz2vtu9I+ZUqUAT/Fb7F1qYq0FsogjFYpK9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(66476007)(91956017)(64756008)(66446008)(76116006)(8936002)(66556008)(2616005)(36756003)(31686004)(4744005)(186003)(5660300002)(8676002)(316002)(54906003)(110136005)(478600001)(66946007)(7416002)(71200400001)(26005)(6512007)(31696002)(53546011)(55236004)(6506007)(4326008)(86362001)(2906002)(6486002)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: KFjjEcyq6NiqRWIu3h7OMCt+lsXHKWxEWl8EHtY+fg01q5+T4Rigbxj7Gzsu3TL7AxvUQDLhRFLenDVkdW9gq+FHpdd9OYN7bqRlACx47wE60PhmmuLHA0e/iwi4UbaeB9iJ+LZQgFLoCNlXeyX1KXbdlVvFtCBGr7qAsyQtxGRkJuZW268xSsxCsSknWIROO1ANwZXerE0fib7BvtLOyLOsSq5b3deHzzUojodPkcYunDdoyQxHuAHc+fwk1mLChIXUFB34LIXI0DoZ8lN1mH69UmyzqeGmdUfD/6gv0MrpNDIQFQlJ4BKujet/u9adFpBbw9IEzBv7CoynEazJFxoYwCbAXaMFQYqb+wHSVe5zQkRw1zCRZZ0dgJW2qaQf2K2e3LfUE/O8whLKZmG8ykM+WPDEcSb788KQbKOpHUL14FGFAeZQwtadfZcsZM7xP0OSpkJhOwpr0sDPVb5aza9oapBvgKn86IPhMQTQ2+ruuZIwMwH2jayV/kS07KIH
Content-Type: text/plain; charset="utf-8"
Content-ID: <591912C0439BCB4AAD00BE347FFC66F7@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 088e1aad-bf2a-4e66-8880-08d7fd97581b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2020 14:57:55.4194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N8V7qKK7Aw8s6HAAXPaDPnNGt94qYhFCoA6KYoMxQjavbBoVs50s7VnNgrx19nVVna3LJpB+bI0BEZy9HaWhfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4724
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR3JlZywgSmFzb24sDQoNCk9uIDUvMjAvMjAyMCAxMjozMiBQTSwgSmVmZiBLaXJzaGVyIHdy
b3RlOg0KPiBGcm9tOiBEYXZlIEVydG1hbiA8ZGF2aWQubS5lcnRtYW5AaW50ZWwuY29tPg0KPiAN
Cg0KPiArc3RhdGljIGNvbnN0DQo+ICtzdHJ1Y3QgdmlydGJ1c19kZXZfaWQgKnZpcnRidXNfbWF0
Y2hfaWQoY29uc3Qgc3RydWN0IHZpcnRidXNfZGV2X2lkICppZCwNCj4gKwkJCQkJc3RydWN0IHZp
cnRidXNfZGV2aWNlICp2ZGV2KQ0KPiArew0KPiArCXdoaWxlIChpZC0+bmFtZVswXSkgew0KPiAr
CQlpZiAoIXN0cmNtcCh2ZGV2LT5tYXRjaF9uYW1lLCBpZC0+bmFtZSkpDQo+ICsJCQlyZXR1cm4g
aWQ7DQoNClNob3VsZCB3ZSBoYXZlIFZJRCwgRElEIGJhc2VkIGFwcHJvYWNoIGluc3RlYWQgb2Yg
X2FueV8gc3RyaW5nIGNob3NlbiBieQ0KdmVuZG9yIGRyaXZlcnM/DQoNClRoaXMgd2lsbCByZXF1
aXJlZCBjZW50cmFsIHBsYWNlIHRvIGRlZmluZSB0aGUgVklELCBESUQgb2YgdGhlIHZkZXYgaW4N
CnZkZXZfaWRzLmggdG8gaGF2ZSB1bmlxdWUgaWRzLg0K
