Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E939C42BB5
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729970AbfFLQD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:03:28 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46438 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728282AbfFLQD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:03:28 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CFt5x2007161;
        Wed, 12 Jun 2019 09:03:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=JYJYl1JZMZS+gwm7HkSwa2xytKuliQ4u4Wr1ZIGnmDQ=;
 b=OdaMxMVNyeqO+XNpn5tRMe+WAz5lJGPP4PdVXn5+CD64hJxpsdZ5dfrp1uF47MyjwAAx
 G+crqmfSd6MV/q4auqxIL98rj7cQCUfxOJgGz0E6dI/1fvFl1DH4JVXlD58IulOc33Tj
 F7MDzo7RhsvV6hSNRWDnfhv1/tZPM3d5WWKwRNIocUlgbUdpOe0jzEJgP92QDqVj10el
 1DHxmsQZK01ehJAmcCTpC+lzsHqn6BXWFWDiqoWF/HkUx56wE+thDCr/2auKtbE2xp1x
 LU0XdotE14/aojLTsrP9d20yKdOFRb1HRYc5O+m5T92hx0zhbkTu4S+n0VgF0jpw8WcD dQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2t2r82axff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Jun 2019 09:03:13 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 12 Jun
 2019 09:01:05 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (104.47.50.58) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 12 Jun 2019 09:01:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JYJYl1JZMZS+gwm7HkSwa2xytKuliQ4u4Wr1ZIGnmDQ=;
 b=skghAik3ZOEilhQHf4pEppfya8aSzqnoCFFwTRR7HcbEwPhp/esT2aJbMMtC9ZbAp44vgkioJzH8xIP4IS2nzPYvPpve/JU9bn2ps1jdQmA+S7fAumvzsjwr07i1iAFwdxv20o9Iez8x9aNxnwMe11aOxhEN0vvfxLj86k59DZw=
Received: from MN2PR18MB2637.namprd18.prod.outlook.com (20.179.80.147) by
 MN2PR18MB2622.namprd18.prod.outlook.com (20.179.84.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.17; Wed, 12 Jun 2019 16:01:01 +0000
Received: from MN2PR18MB2637.namprd18.prod.outlook.com
 ([fe80::3c77:9f53:7e47:7eb8]) by MN2PR18MB2637.namprd18.prod.outlook.com
 ([fe80::3c77:9f53:7e47:7eb8%7]) with mapi id 15.20.1987.012; Wed, 12 Jun 2019
 16:01:01 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     Dmitry Vyukov <dvyukov@google.com>
CC:     syzbot <syzbot+dc4127f950da51639216@syzkaller.appspotmail.com>,
        "amitkarwar@gmail.com" <amitkarwar@gmail.com>,
        "andreyknvl@google.com" <andreyknvl@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "huxinming820@gmail.com" <huxinming820@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nishants@marvell.com" <nishants@marvell.com>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>
Subject: RE: [EXT] INFO: trying to register non-static key in del_timer_sync
 (2)
Thread-Topic: [EXT] INFO: trying to register non-static key in del_timer_sync
 (2)
Thread-Index: AQHU8UKXrSaZj3qnvU6hFZ7GfmsosaaHYqxQgAJS84CAADevwIAOoBJw
Date:   Wed, 12 Jun 2019 16:01:00 +0000
Message-ID: <MN2PR18MB263710E8F1F8FFA06B2EDB3CA0EC0@MN2PR18MB2637.namprd18.prod.outlook.com>
References: <000000000000927a7b0586561537@google.com>
 <MN2PR18MB263783F52CAD4A335FD8BB34A01A0@MN2PR18MB2637.namprd18.prod.outlook.com>
 <CACT4Y+aQzBkAq86Hx4jNFnAUzjXnq8cS2NZKfeCaFrZa__g-cg@mail.gmail.com>
 <MN2PR18MB26372D98386D79736A7947EEA0140@MN2PR18MB2637.namprd18.prod.outlook.com>
In-Reply-To: <MN2PR18MB26372D98386D79736A7947EEA0140@MN2PR18MB2637.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.193.128.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 921133ab-d3ec-44ba-e3b7-08d6ef4f2a54
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2622;
x-ms-traffictypediagnostic: MN2PR18MB2622:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR18MB26223D12869F5F0D06BB8AB7A0EC0@MN2PR18MB2622.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(346002)(396003)(136003)(39860400002)(189003)(199004)(52536014)(78486014)(186003)(558084003)(5660300002)(71200400001)(25786009)(229853002)(33656002)(6916009)(26005)(74316002)(3846002)(7416002)(54906003)(86362001)(99286004)(76176011)(71190400001)(102836004)(11346002)(316002)(7696005)(6436002)(2906002)(6116002)(76116006)(256004)(446003)(66446008)(66556008)(73956011)(55016002)(66946007)(6246003)(9686003)(53936002)(8936002)(68736007)(8676002)(7736002)(966005)(4326008)(305945005)(6506007)(476003)(66066001)(66476007)(81156014)(486006)(14454004)(6306002)(64756008)(81166006)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2622;H:MN2PR18MB2637.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DEC65rI0s6EDJ7yAOUPWWRHLxl/llyRewlrxckX/3UuWNK27iA4f1FCwqwDG6ZpY7qfIrZczn9HHcsCXhNZsFJoCJk4GSFbzn67pANSvZkQ7J6Z510TzUDjToN+iLfyjf1/h6Aujx3fUft06t2KRDOlZYXfWJP9zZ2Ri6ZESV13LXX4wYJHm/wtN9ppj+gNFAQ3YjiteZkzwyuvZO08McADpMophXDwMM9jmzMGP03rQ4BAG7ipRwB5rxQ2+ZwyWHzhpKb2iGUzRJ/UEj8nLr+b5lEnGcQHxQpHmmCA3NPRVYnuGZsbl8sFRdjjlcOFytGnYpXnk6+zarOQE9x8QZANiTEMIXV+HB7q7S2VNnCk7Y5M+Z98YmK/ttrhgfiWIwZKvZZHuhDD25OEyU5NNb6xRh6W+JxOFFgI3SGD5vBQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 921133ab-d3ec-44ba-e3b7-08d6ef4f2a54
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 16:01:00.9315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gbhat@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2622
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_09:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRG1pdHJ5LA0KDQpXZSBoYXZlIGEgcGF0Y2ggdG8gZml4IHRoaXM6IGh0dHBzOi8vcGF0Y2h3
b3JrLmtlcm5lbC5vcmcvcGF0Y2gvMTA5OTAyNzUvDQoNClJlZ2FyZHMsDQpHYW5hcGF0aGkNCg==
