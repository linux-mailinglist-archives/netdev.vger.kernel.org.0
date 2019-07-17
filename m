Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA2F86BA71
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 12:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbfGQKkr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Jul 2019 06:40:47 -0400
Received: from m4a0039g.houston.softwaregrp.com ([15.124.2.85]:43265 "EHLO
        m4a0039g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725941AbfGQKkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 06:40:46 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jul 2019 06:40:46 EDT
Received: FROM m4a0039g.houston.softwaregrp.com (15.120.17.146) BY m4a0039g.houston.softwaregrp.com WITH ESMTP
 FOR netdev@vger.kernel.org;
 Wed, 17 Jul 2019 10:40:45 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M4W0334.microfocus.com (2002:f78:1192::f78:1192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Wed, 17 Jul 2019 10:25:21 +0000
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (15.124.8.11) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Wed, 17 Jul 2019 10:25:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tl4Ck39cJ8fZKR8az5axtbLjpuwWPmDAsm02Y2eB7MiO9wm3GLteyF5hIxkMZmr3gF/ba7UQVYkIgdB6OQjlr6uU/6ExTt2p6o+SXu56K0ddizTUZF6OHHqth1LsLhktxhyodX/+JKN6erj89iIkbkdyv09ZAAJRRK2PRItYbGLufuKFFf1c3Di+CSa4AWof3MUPi6JVpJD5HnrtsgfkaN7M6MAUJQhIc64TJd+WqYpqM6mMYQDKUpMQYCrocHgfdXWc8ycVQYcFECIWp43Pbsg5nmFHvp3bFtWZFfiBTZGj9GbCJzXuWrsScDTxaJy+kl7ySo+Olqri0hGDKoPqWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zuuAN3vg0dNFlBgLGocV58U/H1Jm+oXdmGIQeMjIb5c=;
 b=JeKJ71ErfGkgkwffe5LGAYm5Y7ydze63RSNaJ6P6IB9D3UVBoBHjncoVH7a2UDsOHrx8YIl1rYqH9oDIj/5kO6QnK1atIMOxmazK7rUtt4xLbKPbACxX/0xen1dSgovwtRCrkE1ZniIu3Gva/I0vvWChn0CEKcJGMHjED+Lb2Ws+KJrIzeDSbks8rGft3ytlKOYdwU003JzC61AkIGnx6MY+41vguhmR9LLsQl+udUiimFBsfJ95Z9b/MQtV1aACvqG9ErHFg7EgRLYQ7a0vT/tFVIRApHyrpPcRUKSSD2iPZ47q8Gi0fqCfmWkIRt48CqKaneLH7Dx0cept6aJRSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=suse.com;dmarc=pass action=none header.from=suse.com;dkim=pass
 header.d=suse.com;arc=none
Received: from CH2PR18MB3189.namprd18.prod.outlook.com (52.132.244.203) by
 CH2PR18MB3176.namprd18.prod.outlook.com (52.132.244.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Wed, 17 Jul 2019 10:25:19 +0000
Received: from CH2PR18MB3189.namprd18.prod.outlook.com
 ([fe80::2053:cdc8:d81c:a5d6]) by CH2PR18MB3189.namprd18.prod.outlook.com
 ([fe80::2053:cdc8:d81c:a5d6%7]) with mapi id 15.20.2073.012; Wed, 17 Jul 2019
 10:25:19 +0000
From:   Firo Yang <firo.yang@suse.com>
To:     Benjamin Poirier <BPoirier@suse.com>
CC:     Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sathya Perla <sathya.perla@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] be2net: Signal that the device cannot transmit during
 reconfiguration
Thread-Topic: [PATCH net] be2net: Signal that the device cannot transmit
 during reconfiguration
Thread-Index: AQHVO67z2A6t0cO8nkSyQhUeM2Az8KbOMBQEgABKiSaAAAY7iIAADO7ggAANWMg=
Date:   Wed, 17 Jul 2019 10:25:19 +0000
Message-ID: <CH2PR18MB3189803176C2D913A8476F9C88C90@CH2PR18MB3189.namprd18.prod.outlook.com>
References: <20190716081655.7676-1-bpoirier@suse.com>
 <CH2PR18MB31898E033896F9760D36BFF288C90@CH2PR18MB3189.namprd18.prod.outlook.com>
 <20190717082340.GA6015@f1>
 <CH2PR18MB3189AD09E590F16443D8D5BA88C90@CH2PR18MB3189.namprd18.prod.outlook.com>,<20190717093208.GA6511@f1>
In-Reply-To: <20190717093208.GA6511@f1>
Accept-Language: en-US, en-GB, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=firo.yang@suse.com; 
x-originating-ip: [45.122.156.254]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82ddb616-fad7-445d-0e2e-08d70aa111b5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR18MB3176;
x-ms-traffictypediagnostic: CH2PR18MB3176:
x-microsoft-antispam-prvs: <CH2PR18MB31768FE103FA51B8D9CD0B0888C90@CH2PR18MB3176.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 01018CB5B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(366004)(136003)(39860400002)(376002)(396003)(199004)(189003)(11346002)(446003)(186003)(14454004)(26005)(81166006)(66946007)(81156014)(102836004)(9686003)(476003)(6436002)(8676002)(44832011)(54906003)(256004)(7736002)(6246003)(2906002)(6506007)(53936002)(6862004)(76176011)(7696005)(316002)(76116006)(305945005)(64756008)(68736007)(5660300002)(229853002)(52536014)(4326008)(99286004)(66556008)(6636002)(66446008)(558084003)(66066001)(55016002)(3846002)(486006)(478600001)(8936002)(33656002)(6116002)(74316002)(25786009)(71200400001)(66476007)(71190400001)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR18MB3176;H:CH2PR18MB3189.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: T+gw7xIqcQeV1cqy9Y1Vvvh+TuOcoKCLYw8ehte4Rt34OjmofAVRlPc0o0rd/atrRytEoOtFAl4BVjzbTJsDGRpfMA+5+jvq68s2mkSKZdVvcvKrbzpwIXqs/armQycVIeJkiWSbOV0aAe0lBqzEhMm0Tkby/k0eH2flqOeYhBGM5ei6H7Gd65IkJHc0Faa/CmBdug8BPbuHF4ntFEv/JevS18qjh+FYIiLr2tVV5aVVTn6L3+GFGRRt7P/wvM2Xx20MA/jopf8IMEKPZBAoSoqQ70HMpkxlaWcJ97CGXGbwNzifpykboyEP/5xausdPOhPy7MDKovPSbuyibevDmavVSxmQ0zSdmgzu5HbH009pkd5jrI7JR91U0lFAKoAp8s7QDmHoUbcHjO5GCPO8XvznF/sIwR/OUVPKnDHmDlU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 82ddb616-fad7-445d-0e2e-08d70aa111b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2019 10:25:19.7666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: firo.yang@suse.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3176
X-OriginatorOrg: suse.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Crystal clear. Many thanks.

// Firo
