Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07B1C7015F
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 15:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729834AbfGVNnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 09:43:02 -0400
Received: from mail-eopbgr40055.outbound.protection.outlook.com ([40.107.4.55]:21718
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727510AbfGVNnB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 09:43:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVWA9d4zIZgRcYlt5Z36LN8lcV1HajImCd2PNiHUqxU=;
 b=1maylKVCTK+DNX016Mdj5SFxCpG8w7PJIs8Xg9gUSzpBbIEhu7yeICXOOMJi4JQMqlc8RAFj8NfrpQiPLQKFuiAHv+tqQIav/MkxAcMN0f2huD7ClMFlIdmtr5DHGYGtoZoWz4i+pOnyh2FkRdDrehoQoPUpMUnY35yAJM0g12k=
Received: from DB6PR0802CA0040.eurprd08.prod.outlook.com (2603:10a6:4:a3::26)
 by DB8PR08MB4954.eurprd08.prod.outlook.com (2603:10a6:10:bf::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2094.17; Mon, 22 Jul
 2019 13:41:16 +0000
Received: from AM5EUR03FT029.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e08::208) by DB6PR0802CA0040.outlook.office365.com
 (2603:10a6:4:a3::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2094.16 via Frontend
 Transport; Mon, 22 Jul 2019 13:41:16 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=temperror action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT029.mail.protection.outlook.com (10.152.16.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18 via Frontend Transport; Mon, 22 Jul 2019 13:41:14 +0000
Received: ("Tessian outbound 350ce6c32571:v24"); Mon, 22 Jul 2019 13:41:14 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: c16cd98e9c622405
X-CR-MTA-TID: 64aa7808
Received: from be3e83855668.1 (cr-mta-lb-1.cr-mta-net [104.47.8.59])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id D5149CBE-5ABA-4AB6-B196-0B59BDEC37AC.1;
        Mon, 22 Jul 2019 13:41:09 +0000
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-am5eur03lp2059.outbound.protection.outlook.com [104.47.8.59])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id be3e83855668.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384);
    Mon, 22 Jul 2019 13:41:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cgxJJWZItZmU7uBg3/R0Aek6WZYAM3z591Qj0Cj4Wyq6u3qqal1avk53TlqHv8dZHnGflV+EzcG/M8nmNBcshKYxN82oaz1+T9v0c85+2+b8W4EX77PyuubgApKngVoC90Z5pUs97mtN0/uP/n2i4u643kjHvts19ko89pKb92dYOsPuqxd6wgVc6GT/BUvc6ZV+lRmCpNqCVGZgqSU4M1pPH84vPedpXxejNTIQQP2QE8FBEOm+nTtxUsv5hgkO8cyd4Elnnq7YPmc2O/wuXHfw29yLchC5M9DcLnIKTmn2R/9nE+QrrtkmvLX4MhZqUkC81cE79EMGciX0FFtzZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVWA9d4zIZgRcYlt5Z36LN8lcV1HajImCd2PNiHUqxU=;
 b=f+VbtWnUSTMnChYiG0NUNzSBH5dHpfhcEczE+YAGVBcMor+cO634DDVISQ/LwRgrg8cWSG6Yd9mTZOGTSqW1ub9FCAa9QkeEqON/QG4epHbW7p7o5bVTgb5M2c70/jmJoAknrmOlEWtIOxLyWX7H7ZWCGOqYyTyVPTAzqMwuD91shJ52eBRw4zOi0GRGmU25wwfHRuCHlDHogymT34B+EhqFGQTGqSsVsLzkQurse1f5gQskIs/LxtJAZ2fTUC5OCbU0uQvhO+ha6RnAfN7Snk7k2knIbn6T+APcBJuX3AxPLPLJ7HCUBc9Z3qPw/lHgoyr/11da72g5wdCHdL6alQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=arm.com;dmarc=pass action=none header.from=arm.com;dkim=pass
 header.d=arm.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVWA9d4zIZgRcYlt5Z36LN8lcV1HajImCd2PNiHUqxU=;
 b=1maylKVCTK+DNX016Mdj5SFxCpG8w7PJIs8Xg9gUSzpBbIEhu7yeICXOOMJi4JQMqlc8RAFj8NfrpQiPLQKFuiAHv+tqQIav/MkxAcMN0f2huD7ClMFlIdmtr5DHGYGtoZoWz4i+pOnyh2FkRdDrehoQoPUpMUnY35yAJM0g12k=
Received: from AM4PR0802MB2371.eurprd08.prod.outlook.com (10.172.217.23) by
 AM4PR0802MB2338.eurprd08.prod.outlook.com (10.172.220.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Mon, 22 Jul 2019 13:41:07 +0000
Received: from AM4PR0802MB2371.eurprd08.prod.outlook.com
 ([fe80::5d45:7f25:b478:3e8b]) by AM4PR0802MB2371.eurprd08.prod.outlook.com
 ([fe80::5d45:7f25:b478:3e8b%3]) with mapi id 15.20.2094.013; Mon, 22 Jul 2019
 13:41:07 +0000
From:   Szabolcs Nagy <Szabolcs.Nagy@arm.com>
To:     Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>
CC:     nd <nd@arm.com>, GNU C Library <libc-alpha@sourceware.org>,
        "Sergei Trofimovich" <slyfox@gentoo.org>,
        Networking <netdev@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-man <linux-man@vger.kernel.org>
Subject: Re: [PATCH glibc] Linux: Include <linux/sockios.h> in <bits/socket.h>
 under __USE_MISC
Thread-Topic: [PATCH glibc] Linux: Include <linux/sockios.h> in
 <bits/socket.h> under __USE_MISC
Thread-Index: AQHVQID/UfNITT/bfE6+ZU8LnWDrF6bWge0AgAAjSIA=
Date:   Mon, 22 Jul 2019 13:41:07 +0000
Message-ID: <2431941f-3aac-d31f-e6f5-8ed2ed7b2e5c@arm.com>
References: <87ftmys3un.fsf@oldenburg2.str.redhat.com>
 <CAK8P3a0hC4wvjwCi4=DCET3C4qARMY6c58ffjwG3b1ZPM6kr-A@mail.gmail.com>
In-Reply-To: <CAK8P3a0hC4wvjwCi4=DCET3C4qARMY6c58ffjwG3b1ZPM6kr-A@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
x-originating-ip: [217.140.106.55]
x-clientproxiedby: LO2P265CA0135.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::27) To AM4PR0802MB2371.eurprd08.prod.outlook.com
 (2603:10a6:200:5d::23)
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Szabolcs.Nagy@arm.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: c5e7e75a-f614-4b80-4494-08d70eaa4403
X-MS-Office365-Filtering-HT: Tenant
X-Microsoft-Antispam-Untrusted: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0802MB2338;
X-MS-TrafficTypeDiagnostic: AM4PR0802MB2338:|DB8PR08MB4954:
X-Microsoft-Antispam-PRVS: <DB8PR08MB495489C81C8772DD178A81B7EDC40@DB8PR08MB4954.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:2512;OLM:2512;
x-forefront-prvs: 01068D0A20
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(199004)(54094003)(189003)(66946007)(66476007)(66446008)(66556008)(256004)(64756008)(99286004)(44832011)(65826007)(64126003)(31686004)(316002)(71190400001)(110136005)(54906003)(486006)(8936002)(3846002)(6116002)(58126008)(2906002)(71200400001)(81166006)(81156014)(478600001)(7736002)(6512007)(26005)(186003)(5660300002)(25786009)(65806001)(66066001)(65956001)(2616005)(476003)(11346002)(6246003)(305945005)(102836004)(36756003)(8676002)(53936002)(446003)(76176011)(4326008)(68736007)(52116002)(229853002)(86362001)(6436002)(6486002)(53546011)(6506007)(14454004)(31696002)(386003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0802MB2338;H:AM4PR0802MB2371.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info-Original: HuSKyJlvvnIX7M5n6dqG+oD1a7VmhckBynqYNGjCeIXmvXrvN/+I3sE8TVuTBlL7RMxInJ4Il3qgWd5LPFuhzMqiVm4wE33Ic26TyKbM8kB7mfya09eBD8Y4Q5MCVjWBBYwPOFW7+4eQbyx8E+QXl28uC9o7rQ1PF6g98sPiKlOxYF13bNyBaD+esB6EXjBQBg91g3EO/6Zcsul1HDsj6iWC5QeutcwwGQz7oZymTn5r5Eex3S8N/1ST/mfmxR3UE1US6UqP1GP5c+wkBpTxMvqpTDyYXjy20jWlcKJBuwSSX96TKD/7IuV+5Z+GAeoXeykw0YTcpIpxnoesgF6Gc22yCoFzHj+U2crjiJAPWw/L/6PZ2awL3+yfddcqgXcMBjiXw29x0IqchBefmEbx+zZ02ZhqztanMW5eUDBNOgk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <653E09513AC07444B39A4F60BE5EBB14@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0802MB2338
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Szabolcs.Nagy@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT029.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(136003)(396003)(2980300002)(189003)(199004)(54094003)(64126003)(6116002)(3846002)(81166006)(81156014)(356004)(6486002)(6512007)(86362001)(6246003)(22756006)(14454004)(8676002)(99286004)(478600001)(26826003)(7736002)(305945005)(25786009)(54906003)(110136005)(31696002)(36906005)(58126008)(316002)(450100002)(65826007)(76130400001)(70586007)(70206006)(5660300002)(229853002)(63350400001)(47776003)(63370400001)(26005)(186003)(65806001)(65956001)(66066001)(102836004)(126002)(436003)(11346002)(446003)(2616005)(476003)(336012)(8936002)(4326008)(50466002)(486006)(2906002)(36756003)(2486003)(23676004)(31686004)(386003)(76176011)(6506007)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR08MB4954;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: bd06e09c-02b7-41b5-aed1-08d70eaa3f9f
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(710020)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DB8PR08MB4954;
NoDisclaimer: True
X-Forefront-PRVS: 01068D0A20
X-Microsoft-Antispam-Message-Info: bXtJIyZAa0DbxOzUdbdVWCw0dxC2ACCJdjnWQBju6JqmQQLckf6rpVa490H2W/++VdrX46gtNEm5fRugs9yqKUb4jvS+xeZXxfZTJelymHNtsgrAMEH6llnseAkA3bdWLPx6C1XePH5teplShofxv1n5fMjjwBgxmBeyNAa4EfpvP2oUCF23jiA6CgBBLTqdr7ivwk+ben/NT+lIHOUx4jmgpCcobbvc+oUSmrEbRszcle6vnLfy/toes7C1MX8KEwrrFFWkYiCUoIvwHaAfOEjfpxTh47fF1I0g2FpSo8osks4yncxNsPzVszfWQKNM/CnzWnaVVB8ltNgNi/0NeilvYaEBrU5+d87vJYxwqMWqRfbyrNr/nl5qY8MBYZ8F0EMFOSIlLlMjKQjc5G8S7CCb0J6PtJBoQmc32VkMSfE=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2019 13:41:14.2186
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5e7e75a-f614-4b80-4494-08d70eaa4403
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB4954
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjIvMDcvMjAxOSAxMjozNCwgQXJuZCBCZXJnbWFubiB3cm90ZToNCj4gT24gTW9uLCBKdWwg
MjIsIDIwMTkgYXQgMTozMSBQTSBGbG9yaWFuIFdlaW1lciA8ZndlaW1lckByZWRoYXQuY29tPiB3
cm90ZToNCj4+DQo+PiBIaXN0b3JpY2FsbHksIDxhc20vc29ja2V0Lmg+ICh3aGljaCBpcyBpbmNs
dWRlZCBmcm9tIDxiaXRzL3NvY2tldC5oPikNCj4+IHByb3ZpZGVkIGlvY3RsIG9wZXJhdGlvbnMg
Zm9yIHNvY2tldHMuICBVc2VyIGNvZGUgYWNjZXNzZWQgdGhlbQ0KPj4gdGhyb3VnaCA8c3lzL3Nv
Y2tldC5oPi4gIFRoZSBrZXJuZWwgVUFQSSBoZWFkZXJzIGhhdmUgcmVtb3ZlZCB0aGVzZQ0KPj4g
ZGVmaW5pdGlvbnMgaW4gZmF2b3Igb2YgPGxpbnV4L3NvY2tpb3MuaD4uICBUaGlzIGNvbW1pdCBt
YWtlcyB0aGVtDQo+PiBhdmFpbGFibGUgdmlhIDxzeXMvc29ja2V0Lmg+IGFnYWluLg0KPiANCj4g
TG9va3MgZ29vZCB0byBtZS4NCj4gDQo+IEkgd29uZGVyIGlmIHdlIHNob3VsZCBzdGlsbCBkbyB0
aGVzZSB0d28gY2hhbmdlcyBpbiB0aGUga2VybmVsOg0KPiANCj4gLSBpbmNsdWRlIGFzbS9zb2Nr
ZXQuaCBmcm9tIGxpbnV4L3NvY2tldC5oIGZvciBjb25zaXN0ZW5jeQ0KPiAtIG1vdmUgdGhlIGRl
ZmluZXMgdGhhdCBnb3QgbW92ZWQgZnJvbSBhc20vc29ja2lvcy5oIHRvIGxpbnV4L3NvY2tpb3Mu
aA0KPiAgIGJhY2sgdG8gdGhlIHByZXZpb3VzIGxvY2F0aW9uIHRvIGhlbHAgYW55b25lIHdobyBp
cyB1c2VyDQo+ICAgbmV3ZXIga2VybmVsIGhlYWRlcnMgd2l0aCBvbGRlciBnbGliYyBoZWFkZXJz
Lg0KDQpkb2VzIHVzZXIgY29kZSBhY3R1YWxseSBleHBlY3QgdGhlc2UgaW4gc3lzL3NvY2tldC5o
DQpvciBpbiBhc20vc29ja2V0LmggPw0KDQptYW4gNyBzb2NrZXQNCm1lbnRpb25zIFNJT0NHU1RB
TVAgYnV0IGRvZXMgbm90IHNheSB0aGUgaGVhZGVyLg0KDQptYW4gMiBpb2N0bF9saXN0DQpzcGVj
aWZpZXMgaW5jbHVkZS9hc20taTM4Ni9zb2NrZXQuaCBhcyB0aGUgbG9jYXRpb24uDQoNCmlmIHVz
ZXIgY29kZSB0ZW5kcyB0byBkaXJlY3RseSBpbmNsdWRlIGFzbS9zb2NrZXQuaA0KdGhlbiBpIHRo
aW5rIGl0J3MgYmV0dGVyIHRvIHVuZG8gdGhlIGtlcm5lbCBoZWFkZXINCmNoYW5nZSB0aGFuIHRv
IHB1dCB0aGluZ3MgaW4gc3lzL3NvY2tldC5oLg0KDQoobm90ZTogaW4gbXVzbCB0aGVzZSBpb2N0
bCBtYWNyb3MgYXJlIGluIHN5cy9pb2N0bC5oDQp3aGljaCBpcyBub3QgYSBwb3NpeCBoZWFkZXIg
c28gbmFtZXNwYWNlIHJ1bGVzIGFyZQ0KbGVzcyBzdHJpY3QgdGhhbiBmb3Igc3lzL3NvY2tldC5o
IGFuZCB1c2VycyB0ZW5kIHRvDQppbmNsdWRlIGl0IGZvciBpb2N0bCgpKQ0KDQo=
