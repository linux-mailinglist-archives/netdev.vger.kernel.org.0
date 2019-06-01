Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E32132040
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 19:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfFARwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 13:52:43 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58636 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726013AbfFARwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 13:52:43 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x51Hq17f014330;
        Sat, 1 Jun 2019 10:52:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=o1kYnMLEfdOLB8lkGWLQzqKg1zXHbKXzRQkQE+FKwVM=;
 b=QG8ToTYs5LHvE2VT5ioXFjxNE/TxMRW0ui33R/O/9k2DdbNQMXJNyobBMW2twgczF+QF
 WUfzwAOnw/BW9PKccWi5G5L+U1p/PRWOWKPGp8ExLRg0C+Mc/SuGpWfUqY4FyzlDsEjP
 UwZOiICS/BYEPNX1Pvb39wCKVf2sOvlWDseCLTwpW/mwcMYwAiaVSJGCogMAvbaAbX2L
 RcdWGPVDQveLfDxvMqgRjul1WItmfvy24mZH6RHQCc+91Z5yZM/PIH8DxyvKmCNVcMuI
 DxiWLfpLD6kG2g7FXmMWwqsl9anSgCApgXmAutMTuyiW5NIDX7aGMcoMZcBM7Px7LTKB vw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2survk0wxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 01 Jun 2019 10:52:35 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sat, 1 Jun
 2019 10:52:34 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (104.47.33.59) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sat, 1 Jun 2019 10:52:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o1kYnMLEfdOLB8lkGWLQzqKg1zXHbKXzRQkQE+FKwVM=;
 b=DbsQLishDofywwPOaDs8QR3DbRwjP4IxI2wkKtrs612ON/AbdoB9KiHFji3LLXCqKY7qXNcFrNx7AKvITukuw3WLxw15PUXXTZciXC6PW6VyOQz/nyMghCWRy4pVIUBHEfBc8r4EODDYkTOr5mtG+QoomqpJXnEZh893L5i6jwc=
Received: from MN2PR18MB2637.namprd18.prod.outlook.com (20.179.80.147) by
 MN2PR18MB3296.namprd18.prod.outlook.com (10.255.237.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.17; Sat, 1 Jun 2019 17:52:29 +0000
Received: from MN2PR18MB2637.namprd18.prod.outlook.com
 ([fe80::3c77:9f53:7e47:7eb8]) by MN2PR18MB2637.namprd18.prod.outlook.com
 ([fe80::3c77:9f53:7e47:7eb8%7]) with mapi id 15.20.1922.021; Sat, 1 Jun 2019
 17:52:29 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     syzbot <syzbot+dc4127f950da51639216@syzkaller.appspotmail.com>,
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
Thread-Index: AQHU8UKXrSaZj3qnvU6hFZ7GfmsosaaHYqxQ
Date:   Sat, 1 Jun 2019 17:52:29 +0000
Message-ID: <MN2PR18MB263783F52CAD4A335FD8BB34A01A0@MN2PR18MB2637.namprd18.prod.outlook.com>
References: <000000000000927a7b0586561537@google.com>
In-Reply-To: <000000000000927a7b0586561537@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.45.208.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4058494e-7237-41d5-b83d-08d6e6b9ea68
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB3296;
x-ms-traffictypediagnostic: MN2PR18MB3296:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR18MB329664EFBE84AE19800465AEA01A0@MN2PR18MB3296.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00550ABE1F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39850400004)(396003)(376002)(346002)(136003)(189003)(199004)(52536014)(66446008)(81156014)(316002)(66946007)(86362001)(256004)(64756008)(76116006)(186003)(558084003)(81166006)(9686003)(5660300002)(8936002)(14454004)(6246003)(73956011)(68736007)(76176011)(66556008)(99286004)(25786009)(8676002)(7696005)(229853002)(55016002)(110136005)(71190400001)(26005)(71200400001)(2906002)(305945005)(3846002)(33656002)(486006)(6436002)(2201001)(7736002)(6506007)(476003)(6306002)(2501003)(74316002)(66066001)(102836004)(6116002)(11346002)(478600001)(446003)(66476007)(53936002)(7416002)(99710200001)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3296;H:MN2PR18MB2637.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vzYafyOKcozAqFNKw7gT1+49CJ/H4Vw2uJZ0KXt49lZ/SnfGV1jGuIyruO1rzYykQ1Q56Br7Ua02xg5dLD5+SJGjqHZgxx8bys0KEvxdXqgXoIcLYbWBZnNS3sO3T3OqSv1RowZwqWZXYvrWXtw+wgih5JIsP0RvKHUW29cS9P/NJ+9cMmMDG1qAZMs/DEo63UmnMZtQ+BjES1G44HluEYi/dCzPhD+y7UxCU58MW59qIBkWG2okjOAqQV+ROV4vTKEkEixecOpxQ3vxp8GOuKmZWS0PCt8imwILpL8lFig6zBZI1r7Fw6wUyIoGnTr3WY6RVrghdTpQ1fXuDSYDf5AKY6+YItN+bCKW829y9z6GYIBMjFGSeGw7QiMty4NT3ze2U4XkLYiuvfObUdmpZ2YUwtWAumNeUKBqN4F0bkQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4058494e-7237-41d5-b83d-08d6e6b9ea68
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2019 17:52:29.4514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gbhat@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3296
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-01_12:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgc3l6Ym90LA0KDQo+IA0KPiBzeXpib3QgZm91bmQgdGhlIGZvbGxvd2luZyBjcmFzaCBvbjoN
Cj4gDQpBcyBwZXIgdGhlIGxpbmsoaHR0cHM6Ly9zeXprYWxsZXIuYXBwc3BvdC5jb20vYnVnP2V4
dGlkPWRjNDEyN2Y5NTBkYTUxNjM5MjE2KSwgdGhlIGlzc3VlIGlzIGZpeGVkOyBJcyBpdCBPSz8g
TGV0IHVzIGtub3cgaWYgd2UgbmVlZCB0byBkbyBzb21ldGhpbmc/DQoNClJlZ2FyZHMsDQpHYW5h
cGF0aGkNCg==
