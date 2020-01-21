Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 735D8143DA3
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 14:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbgAUNGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 08:06:55 -0500
Received: from mail-eopbgr80132.outbound.protection.outlook.com ([40.107.8.132]:1783
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725890AbgAUNGz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 08:06:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UtI3b/IanFoQtuJWQizdwHesek9P74hKp5SdWs4d8Icc/5UMheHnV5qgb4bKVReSZa1Or6sOrdbOQI6+p+n2nNX7rnOD9AS+31zj72bQCuyxUupWbZOCwkrODme5NbG754JQDFb6sasSRGGdc9vxoH54TbOTxXfJND3/3PXLBWWSj+FUSfLhQmwZ6OnB5qliNRarX0KlQSNzNWAymKpY485oCXrxnMVE6iUylvcXWmHwFctmQVxSgsfRR1Zp/3F++UWhvfJuFT+ZEsU5BkSNLE7bi4AcGTyvTt/OsJDQZn4n1Hl3cIHF9SVXw/3JfGSUPBVjSgMsAlamKLrrb6Fe2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4njqZFghVF0DNSdg8jhN753DsFeMZCArhKtHy/PsR0=;
 b=ZMplbWFndIevRruQeDLahHlw8gzk8CH+JtFoZ8uNyDW/FN/TfjKQJ4IISDk6Nb3Av7lAoVEL8tP/E7aWeeSGgpHcmYExJcifIZAD3QkWGE1Na75RShxKOsDYhOrJ+JIHED+i9U4oUiyfk8O4zJzjkTVR5ZVfJv7/VdLPWl53JSuns9C8kBeiu87o8eNwjauU2pwxzW6HEyabrhLL3Zbm6VuH2CdvdOxMJydMS8o01MQL344kMgjNWQpujZtlpDu1qSVMbGdTqap6UYyfxqmnUSqsje4j1PSxtBZMwnrggpCA9ir3hA+3q6wLj0iZO9ljXMOdhyJOqi46pZq2Uk3wDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4njqZFghVF0DNSdg8jhN753DsFeMZCArhKtHy/PsR0=;
 b=rxBNFGJ36BbUJ7IF3U07aqME713uLoXFHnQ5OOSsQGRn15yL6PHx2IgIUx+sV+2Cmb0lD7FMu52fEp8n4tjldIx/UhR0ukIMUxXKDsIfB14/NnJX3Tqm0R1qepLbNxyzkhKKFqd6/+9Gi23k+V9Zij6hiXbJyoWdu355PRkyTwo=
Received: from DB3PR0402MB3914.eurprd04.prod.outlook.com (52.134.71.157) by
 DB3PR0402MB3915.eurprd04.prod.outlook.com (52.134.71.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Tue, 21 Jan 2020 13:06:48 +0000
Received: from DB3PR0402MB3914.eurprd04.prod.outlook.com
 ([fe80::917:f0e9:9756:589b]) by DB3PR0402MB3914.eurprd04.prod.outlook.com
 ([fe80::917:f0e9:9756:589b%3]) with mapi id 15.20.2644.027; Tue, 21 Jan 2020
 13:06:48 +0000
Received: from mail-lf1-f44.google.com (209.85.167.44) by AM3PR07CA0135.eurprd07.prod.outlook.com (2603:10a6:207:8::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.12 via Frontend Transport; Tue, 21 Jan 2020 13:06:47 +0000
Received: by mail-lf1-f44.google.com with SMTP id 9so2180712lfq.10        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 05:06:47 -0800 (PST)
From:   William Dauchy <w.dauchy@criteo.com>
To:     "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>
CC:     William Dauchy <w.dauchy@criteo.com>,
        NETDEV <netdev@vger.kernel.org>,
        Pravin B Shelar <pshelar@nicira.com>,
        William Tu <u9012063@gmail.com>
Subject: Re: [PATCH] net, ip_tunnel: fix namespaces move
Thread-Topic: [PATCH] net, ip_tunnel: fix namespaces move
Thread-Index: AQHV0Fd6evhWdJUqM065nqwxHKnbU6f1E9mAgAACr4A=
Date:   Tue, 21 Jan 2020 13:06:47 +0000
Message-ID: <CAJ75kXaAxNh90Qq_FYCKXmMD_Q3w318pTQG6ZB-0K-K3bL=Oag@mail.gmail.com>
References: <20200121123626.35884-1-w.dauchy@criteo.com>
 <45f8682a-1c72-a1e4-7780-d0bb3bc72af8@6wind.com>
In-Reply-To: <45f8682a-1c72-a1e4-7780-d0bb3bc72af8@6wind.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [209.85.167.44]
x-clientproxiedby: AM3PR07CA0135.eurprd07.prod.outlook.com
 (2603:10a6:207:8::21) To DB3PR0402MB3914.eurprd04.prod.outlook.com
 (2603:10a6:8:f::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=w.dauchy@criteo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAVXfOTak186t8NHG8kjtlLeijyIfmgHXFAevYz0RYyPO88VRmwa
        sVDVxw/+Rt/qbZOSu5bpOktCYix37+F1PMK+58A=
x-google-smtp-source: APXvYqxKhB8qeo1tBV9nIwCGFtNGRJo3OpCwJ9myGsiXLc48Lk7SPRQloMAd6c0nll9CuqtHqx8anlDNS1vWFXAwW9s=
x-received: by 2002:a05:6512:15d:: with SMTP id
 m29mr2749412lfo.51.1579612006714; Tue, 21 Jan 2020 05:06:46 -0800 (PST)
x-gmail-original-message-id: <CAJ75kXaAxNh90Qq_FYCKXmMD_Q3w318pTQG6ZB-0K-K3bL=Oag@mail.gmail.com>
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b1e0100-75c2-44f2-b01e-08d79e72c5bd
x-ms-traffictypediagnostic: DB3PR0402MB3915:
x-microsoft-antispam-prvs: <DB3PR0402MB3915F33F0FDB35C937C1C566E80D0@DB3PR0402MB3915.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(346002)(366004)(39860400002)(376002)(396003)(189003)(199004)(52116002)(4744005)(186003)(107886003)(316002)(26005)(42186006)(53546011)(5660300002)(2906002)(55446002)(66556008)(8676002)(64756008)(66446008)(8936002)(86362001)(71200400001)(478600001)(66476007)(81156014)(4326008)(66946007)(54906003)(6862004)(81166006)(9686003);DIR:OUT;SFP:1102;SCL:1;SRVR:DB3PR0402MB3915;H:DB3PR0402MB3914.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: criteo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7pY1ReWEMJKHWZQGHNI0GgGFQe1u+cSR+Vs9Qaxkt8E+0/vGmBv7ZcocYXJqtrYdUcF4Muq1iUJNUDaH9Xxn+1OcNHWBAohQBrQQX43iKaV/c9o48ebgzNw8rQaUmSFQnNJheO4F0zMgIC0m3qfTYZFP6celcC8leeW5eyNxu+5XHa6KqxMvigYqDTXLrIMb/Siu9KuBkmaJu+3eHrUaKqLmFiM+ieUryr6E/SLtjldUsDSlRFVtON75nh2mHmgJt0HuvJFQidvCecbjsdkArzwnjUYbtPiaDnPhBDqy9Al/j+nVC6n5gvO1S6L8gydten7vjrcB7UP+YS9FPIugFRhBO65U9xK5Eg870QuzrR1jTCqxZC9fFcwdMnbvA7WNmMfbkPo2FRVsRlouh/mE1cN0YbaR2cU9pPxDhdneELVHjQvvF2uPWKjBLYVSgasd
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C312E1DEFAE364A9DDD938284091F4A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b1e0100-75c2-44f2-b01e-08d79e72c5bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 13:06:47.8886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RJgA0cY6P33V+mAMLYb8xwv/fUKCq1xgfZ8cA8cLH0LaIaDubcUtrWLvOYgnRlKmx5elFG461aaUx+5Y1Cb7sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3915
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTmljb2xhcywNCg0KVGhhbmsgeW91IGZvciB5b3VyIGFuc3dlci4NCg0KT24gVHVlLCBKYW4g
MjEsIDIwMjAgYXQgMTo1NyBQTSBOaWNvbGFzIERpY2h0ZWwNCjxuaWNvbGFzLmRpY2h0ZWxANndp
bmQuY29tPiB3cm90ZToNCj4gQWNrZWQtYnk6IE5pY29sYXMgRGljaHRlbCA8bmljb2xhcy5kaWNo
dGVsQDZ3aW5kLmNvbT4NCj4NCj4gTWF5YmUgYSBwcm9wZXIgJ0ZpeGVzJyB0YWcgd291bGQgYmUg
Z29vZC4NCg0KSSBhZ3JlZSwgc2hvdWxkIEkgc2VuZCB2MiBmb3IgdGhpcz8NCkZpeGVzOiAyZTE1
ZWEzOTBlNmYgKCJpcF9ncmU6IEFkZCBzdXBwb3J0IHRvIGNvbGxlY3QgdHVubmVsIG1ldGFkYXRh
LiIpDQoNCih3ZSBwcm9iYWJseSBzaG91bGQgaGF2ZSBkb25lIG9uIHRoZSBpcDZfZ3JlIHBhdGNo
IGFzIHdlbGwpDQotLSANCldpbGxpYW0NCg==
