Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7326411A2D8
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 04:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfLKDGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 22:06:32 -0500
Received: from mail-eopbgr10099.outbound.protection.outlook.com ([40.107.1.99]:35300
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726619AbfLKDGc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 22:06:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+br7YwWdytHk95tOQsdayew23Fqtgo4rmPNd1A9M9nDvRv5RbAYFyo9lOYXDJ6tYgMVF7wrHCoVzKiH+8CgUA/bN+HZnliSLVyxqUBvtueHiNFlLnNIzmiIBvFct7y5fiYoKZFjAoS38s+39+6GipaGqL2MpYs+pJ6taxW/LfPlR1AcSQ2UuKGR8jovvSIUHam1majHVZCTWXKfhxf8wA0AnvyuupVONnHx9kJ8BUSCP2nFsYMHVxPkYP6kyJ44AxMM2ny58/LiNT5WT/J8oFrvKDWle3Bx68GJS8RKFFoZmAkrxWJg3i6xQo/ws8NJyQSQX05jQ2sKpVWZeQuImQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gyt+9Ps3OL5tL65/MzkfFgTTRe3SM/zDRNQvB+SdlLc=;
 b=Ml6/Qy3/RTS6bgYTUyhWbowDzBbxPHRBu29dbvJE8+WUIJ7XK3YqGAp2FzXoetPEIbA3B6g/kMcfu9xVb2fWk768Q5djLpUILrImKdQgPYmzHYDIGcnPBd445e6r5/F5xlQoFAF3HLn2NK2C0vMRsFARpvJNsdga8jFP8RJ0/NYQ84vMaLGrj4TNWSPMCVTBQ8b7awwvQ8Ix0MSH0iGV3h0x9kenWbn9Tzmlnrceb615UC0xmekqkQSvaBrug6tKHUCBs94Ic+pZDDoB2SrieCZ3wWbSw91jHpC5w/ldDuC2Tlx5UL7E8pia8sBcVlWNhmm2AIF4O3JcNMDCvePvOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gyt+9Ps3OL5tL65/MzkfFgTTRe3SM/zDRNQvB+SdlLc=;
 b=YzS0rP3NBu/69I66wCWatheGDk43zT5uc+fyqiI+n61txBOm5iInVwXFsQrO3Jz0t5fVHzpKQwk4NvPI7aA+8XCmHOKAp782eX9hQdn7L7fOK/590Rnqm+PJin0HJ9bAJce8pVWKHoDumZxhbYDDhHCuBbbkUQjNh82NPOLkOTo=
Received: from DB6PR07MB4408.eurprd07.prod.outlook.com (10.168.24.141) by
 DB6PR07MB4216.eurprd07.prod.outlook.com (10.168.25.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.8; Wed, 11 Dec 2019 03:06:26 +0000
Received: from DB6PR07MB4408.eurprd07.prod.outlook.com
 ([fe80::e430:ac8d:bb4a:21cf]) by DB6PR07MB4408.eurprd07.prod.outlook.com
 ([fe80::e430:ac8d:bb4a:21cf%6]) with mapi id 15.20.2538.012; Wed, 11 Dec 2019
 03:06:26 +0000
From:   "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
To:     David Miller <davem@davemloft.net>,
        "martinvarghesenokia@gmail.com" <martinvarghesenokia@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pshelar@ovn.org" <pshelar@ovn.org>,
        "Drennan, Scott (Nokia - US/Mountain View)" <scott.drennan@nokia.com>,
        "jbenc@redhat.com" <jbenc@redhat.com>
Subject: RE: [PATCH net-next 1/3] net: skb_mpls_push() modified to allow MPLS
 header push at start of packet.
Thread-Topic: [PATCH net-next 1/3] net: skb_mpls_push() modified to allow MPLS
 header push at start of packet.
Thread-Index: AQHVry9Ze9r+xo2c2k2xXP/XP9VHD6e0Km0AgAAWxWA=
Date:   Wed, 11 Dec 2019 03:06:25 +0000
Message-ID: <DB6PR07MB440807A1042502E67507A55BED5A0@DB6PR07MB4408.eurprd07.prod.outlook.com>
References: <cover.1575964218.git.martin.varghese@nokia.com>
        <8ff8206cc062f1755292b26a32421a66eeb17ce7.1575964218.git.martin.varghese@nokia.com>
 <20191210.174334.2001305350497606544.davem@davemloft.net>
In-Reply-To: <20191210.174334.2001305350497606544.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=martin.varghese@nokia.com; 
x-originating-ip: [131.228.69.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e7eea6d1-9b61-4e6d-1206-08d77de71c5e
x-ms-traffictypediagnostic: DB6PR07MB4216:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR07MB421688D5C04FCE30BAF29A53ED5A0@DB6PR07MB4216.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(376002)(366004)(39860400002)(346002)(13464003)(199004)(189003)(33656002)(71200400001)(4326008)(110136005)(8936002)(55016002)(7696005)(8676002)(9686003)(478600001)(86362001)(76116006)(81166006)(81156014)(66946007)(26005)(2906002)(66556008)(53546011)(186003)(6506007)(66446008)(5660300002)(64756008)(66476007)(316002)(54906003)(52536014);DIR:OUT;SFP:1102;SCL:1;SRVR:DB6PR07MB4216;H:DB6PR07MB4408.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ffajB6+UMYj7BmsxD1ve2A3LqN8eIzQTM6VWNemkOvu5xNB5mpl1S0JM+LBFavCHV15DHJyqxpBV66tDZnqvpriLOovgcXLzxG3Rx7HAnjrLkhN0mt7xE2+bDy1ViFWxZLGwm3Gfr4fXV3LewLs3M6E1IDXjn3aMxDGWRV9wWyOPMKDWmiZpDPbLs8O/eAYK0AXMQ2z/AES/0/lc+OSod/FsCvfkqcJdUl1mI4qO5rZ6qlAHrXXYG8LtjreJA/C0G6y21+Ko5B055TjSRdYH+dnUxYRZMbEAukdeRFt8wBrSVAH/QnAcm1tsnNMN9uhNW2hGrqeeZDnsWcUHgUiFca3v9NGGEqJN8x1aA34XywN3hhwQfNuxEnUv9cJC45kn6bhjtWIHxJ92bQze3sETNbqMH+AEkhb5W9/cM3L3HkD5Te33cF6CpRfix3PG+kfDdUKIsAt7lxvYxhLdfq7RVFFja2nadFm7uESK2rqOwQK7o7+1vlIlRq2uGot672ry
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7eea6d1-9b61-4e6d-1206-08d77de71c5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 03:06:26.0880
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: te358Q23KWiH3eoCTIJHfgq6RVF2QTHEOeIaK/qGa9Ab/mGu4Od9Q+PDhCBFcnLu6cdsd/j/CXruEhcDDVHiCwgU+lr55ecBtQHBDFPU2Tw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR07MB4216
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oops Typo, will fix it. thanks

-----Original Message-----
From: David Miller <davem@davemloft.net>=20
Sent: Wednesday, December 11, 2019 7:14 AM
To: martinvarghesenokia@gmail.com
Cc: netdev@vger.kernel.org; pshelar@ovn.org; Drennan, Scott (Nokia - US/Mou=
ntain View) <scott.drennan@nokia.com>; jbenc@redhat.com; Varghese, Martin (=
Nokia - IN/Bangalore) <martin.varghese@nokia.com>
Subject: Re: [PATCH net-next 1/3] net: skb_mpls_push() modified to allow MP=
LS header push at start of packet.

From: Martin Varghese <martinvarghesenokia@gmail.com>
Date: Tue, 10 Dec 2019 13:45:52 +0530

> @@ -5472,12 +5472,15 @@ static void skb_mod_eth_type(struct sk_buff=20
> *skb, struct ethhdr *hdr,  }
> =20
>  /**
> - * skb_mpls_push() - push a new MPLS header after the mac header
> + * skb_mpls_push() - push a new MPLS header after mac_len bytes from sta=
rt of
> + *                   the packet
>   *
>   * @skb: buffer
>   * @mpls_lse: MPLS label stack entry to push
>   * @mpls_proto: ethertype of the new MPLS header (expects 0x8847 or 0x88=
48)
>   * @mac_len: length of the MAC header
> + * #ethernet: flag to indicate if the resulting packet after skb_mpls_pu=
sh is
> + *            ethernet

Why "#ethernet" and not "@ethernet" to refer to this argument?
