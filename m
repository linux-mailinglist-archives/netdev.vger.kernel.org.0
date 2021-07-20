Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38913CF2BD
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 05:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347241AbhGTC5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 22:57:23 -0400
Received: from us-smtp-delivery-115.mimecast.com ([170.10.133.115]:32552 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346882AbhGTCyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 22:54:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1626752122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ahgOY0Vu9PeUljyZGo1Me5kj1yUjkUgPw69Mi0nOIaQ=;
        b=GeuwrUgCboQyJ0HK2XeTca8WZK5HN99FHa+xGNzJBHOUpq0RezmTVWFoPsAd17ZWlKApkR
        lBZgppwCclgO3LiPCOE/C28gMqYdH99lcD9k6Poh9kaPVWtEKF7Ok41c77RXFcsdZP1WwM
        /G9QqPfjzGEHKY+uFcebKMRonKriGU0=
Received: from NAM11-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-nSgTzl4sPwGul5IZccqtNQ-1; Mon, 19 Jul 2021 23:35:20 -0400
X-MC-Unique: nSgTzl4sPwGul5IZccqtNQ-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (2603:10b6:301:67::32)
 by MWHPR19MB0047.namprd19.prod.outlook.com (2603:10b6:301:6a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 20 Jul
 2021 03:35:17 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87%4]) with mapi id 15.20.4331.032; Tue, 20 Jul 2021
 03:35:17 +0000
From:   Liang Xu <lxu@maxlinear.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>,
        "mohammad.athari.ismail@intel.com" <mohammad.athari.ismail@intel.com>
Subject: Re: [PATCH v6 2/2] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Topic: [PATCH v6 2/2] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Index: AQHXfF93E9dlj6gxN0ii5bTKpxVpI6tKxfkAgABxygA=
Date:   Tue, 20 Jul 2021 03:35:17 +0000
Message-ID: <c21ac03c-28dc-1bb1-642a-ba309e39c08b@maxlinear.com>
References: <20210719053212.11244-1-lxu@maxlinear.com>
 <20210719053212.11244-2-lxu@maxlinear.com> <YPXlAFZCU3T+ua93@lunn.ch>
In-Reply-To: <YPXlAFZCU3T+ua93@lunn.ch>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b4c1e1a4-7a4b-4112-7236-08d94b2f64cb
x-ms-traffictypediagnostic: MWHPR19MB0047:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR19MB004767B8EAD7B8B15A026E19BDE29@MWHPR19MB0047.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 0n3hEZs1L5Z2pCejeJJrBdQEJO7Eizk/ZT8bIRyVQKdIhAqT2KZ6YuTtCBDWDsUmVQvcLGhOq+zeXJbkYSPnol9qpv8+i0wgoZVXwmx+7hjHAyup98pBipL9uoM2S40YHKpTrQxDVK8bPny5v7QHBoXqcySBQm4mwK9CnKaeiYCE3y4B7r/bzKjjg4EINZrxXeSeTQkLH3WPSnCpbC4L0pocgGtIOhmjFCRsgXyX8mnMZN2fF2YdgfKSQjwYgLvV3hg/ujFR+wuORAexy0tcZoM0tpUy0nHBwfPkw/+hxvxNDvKMgsmvl5RmO5KUGGGrEr0DX2w/u3kUBoSt/rCR8UTo6KtwIikbrk7AD3KtoE1eaH/dKrp9VC9CGsIzyaGZw5/nFt6OENWnI8p0KmJoJnqLLFSbfWcfKw1aeg2okZ3CgnQRQlqq8CJgzIMLUPqO/2QKBA65+1kvTXnxji88pgUFcwtDMCwP33b7byBGrdMGBK8mXlKsw0GrKkvkHSnpG8GKHWnBYkVKTVnFgYJ14ZsbSkwhCpy+8RU6KFelsVP/F4Okf+CWGRfeD4se/kCjMLfcf7kuSyUsqc16OeBxhrj31XLvwvZbg8urXcyuxVpSbOu79ZgcOjs0U4clBQHjgiWf1RPBEeztPzLE9+3CtOmKQW+QO/GJW+7R72cd/rF50pQ+uHsV3i3HCjb/WXtiJsryYcNmP9kHcAoZTPZn4Otetc7y5Mrd740clxs+SYTUspqhQ3xHsMqYmBGqexDc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39850400004)(366004)(136003)(346002)(66946007)(36756003)(53546011)(6506007)(71200400001)(4744005)(6916009)(66476007)(66556008)(66446008)(91956017)(76116006)(6486002)(64756008)(2906002)(8676002)(2616005)(38100700002)(86362001)(122000001)(5660300002)(26005)(31686004)(186003)(8936002)(54906003)(6512007)(478600001)(316002)(4326008)(31696002)(45980500001)(43740500002)(38070700004);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?emdBR09sVlpUUjRDcVpYa2ZDaGtjVWlMM2h1bVVocU5DVDZWOUxiYXIwYzZD?=
 =?utf-8?B?SXd4RE9LT3U4Q0QwV0hsMG4vaXY2ZWZtSXlIeVhnRkhybnBxUXYyU05aMnlU?=
 =?utf-8?B?R2hqOXJQZTR3aHpndXc2b0xlZmFGdXpId3VPRnc2b2haYnhrY1lTWmZmQS84?=
 =?utf-8?B?NUp1ZVJvZXdlUDNkTE9HL0FvWlVtSk9sS3Rkdlc4WEUzckdQdFRFZ1BlK2pE?=
 =?utf-8?B?RzdQbTZyb0EyWkZ4dWRHY2FxbmhEdHRnR2JaWFVjVjFVa0cyRDBPVUxsSyta?=
 =?utf-8?B?L1lBRzJlY0VaekltQkFlZlZRL1lVWWc0T1RiNEhZbVpZWElaSDhTYXNqMlor?=
 =?utf-8?B?QklDUTZoSW9kaEZNd0g3RVVjQmtTY21YVC9QdWJWQ3R1dnBMc3lNcXg0V1lq?=
 =?utf-8?B?Qm95a1RrMGs0dDlBbU95UU5VUVBxTEd0cXBPamhEMDM2cXVFQmp6Y1lXaGhB?=
 =?utf-8?B?LzgyUm1qeDZBbmhYQ3ZQcEd2MUEwdWdVeVJjbVFhaXFpSkQvV0R4RXFHTGtX?=
 =?utf-8?B?UWx1bVFDQml4UFBKQjBwbTFaTE03ODd0NGFDY0pWeWlwdUprUkJQSTEzZHFi?=
 =?utf-8?B?TCtXZC9zbUlVT3JGNG5MS0trRThrYkltdXJCaTBQMzh5YVUvWUhjc1gvVHlj?=
 =?utf-8?B?Y0xtb0ZkWi8xTXJYMGRLOENpN0g0aUxnVlYvQWJjTHFvTmpxZm9XamZBUHN3?=
 =?utf-8?B?cks2UFJkT09WSk92K09BRVcwaVdYb3ljTFhHNTF1UGZ3MzlqeElSZ1R6Z0NK?=
 =?utf-8?B?MzBLd1kwTVBET3ZTYjhjckFpWUFVNDNKMUc2dnFLT0hORktPNEsrSzlUWSts?=
 =?utf-8?B?eVdXY1NPZCtFZGhuRXI4aFFTanJiMXYzZjc2dG1FYnF2azl1eW5ZWHBvNGhC?=
 =?utf-8?B?c3Y0aW5haDlBcDJ4TnF1RFhRVmxrUWpTdEtrVVRFdklIMFFEdDM0aEpmNG5m?=
 =?utf-8?B?MEJjdzFsbFQ0enZBdnB6cWdWNmozdUNHamNKdkwzczBPTkxQTHc5VWl3ZExl?=
 =?utf-8?B?VGcrMUdlL0lVUnQ0aCtHbmJOK3NPS28wYXZiTjdjcFZVWElFenV1T0g0V0RB?=
 =?utf-8?B?aTZTcmo0RFlPN1FSVDVtL2JNMEgyMDd1cStDR2VtRHBScVByc3F2VE54bjIz?=
 =?utf-8?B?c3JNOERsWWZpcWliK3JBWEIySm9TeThLWmtWeXErdHQzcWYzaHNId1JhRGZB?=
 =?utf-8?B?L01EbkhidVZCL1Ryb0o4U3BuYmFBUVVTck8rNEE2Z3JjT2FIWDBpVjB4RmFC?=
 =?utf-8?B?aVdQS0JOSFZwOU1Jd0pWckdRTU9JeExnVW51K2g5RlpYbWppajlhYXZkZDRw?=
 =?utf-8?B?ZVJUaUYwalNrWmcxKzRrNUc3Zk4zMjRJTEJrK0FKekJoRTF0RWRta3c0S3Vu?=
 =?utf-8?B?OVhCUGtwSGtUZDNsVi8zR201bi82TzJCdmkwd2VoSzlvWldFZksyVy9wc0dx?=
 =?utf-8?B?Y01KbDRTZlVTeC9iZW4zaG9LUmRobE1DcFNQYjJlWmJGaTZGQ3Z4N0dQS25U?=
 =?utf-8?B?OGlGcExSdm5jdFo5VkI5QWlueFlPR0N5dTVWcUt3VGdGNnh4SmpwZmh5aVl2?=
 =?utf-8?B?eTNpVWM2QjNtU3ZESk1JSmlHaHg0VGw4a25uTklTYm03OVVqRGhyc1k1MnZH?=
 =?utf-8?B?QjV1OC9iVUs3MkJobGFIL2tHek1vNWxFTjhLYkJ5QTVsME5VNUxTai85bVFX?=
 =?utf-8?B?OER6R1FBQlJQRk50cDZhejFYMzNuUTkvbHFpSjM0M21UYUk3MDEwSXZGTW9l?=
 =?utf-8?Q?8gq1HmkX/TC0F+1dw0=3D?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4c1e1a4-7a4b-4112-7236-08d94b2f64cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2021 03:35:17.5537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /ch0M/HXEcuFHgy3jqpn8e70vaUHtkFc288QMqeOk7fUL940kW9LaTgQ7AvVO5+1NyffXhTY3WY6J021QHPXJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR19MB0047
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <4A0D23F67CE78C43B01FE045778331CD@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAvNy8yMDIxIDQ6NDggYW0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPiBUaGlzIGVtYWlsIHdh
cyBzZW50IGZyb20gb3V0c2lkZSBvZiBNYXhMaW5lYXIuDQo+DQo+DQo+PiArLyogUEhZIElEICov
DQo+PiArI2RlZmluZSBQSFlfSURfR1BZeDE1Ql9NQVNLICAweEZGRkZGRkZDDQo+PiArI2RlZmlu
ZSBQSFlfSURfR1BZMjF4Ql9NQVNLICAweEZGRkZGRkY5DQo+IFRoYXQgaXMgYW4gb2RkIG1hc2su
IElzIHRoYXQgcmVhbGx5IGNvcnJlY3Q/DQo+DQo+ICAgICAgIEFuZHJldw0KPg0KSGkgQW5kcmV3
LA0KDQoNClllcywgdGhpcyBpcyBjb3JyZWN0IGFuZCBoYXMgYmVlbiB0ZXN0ZWQuDQoNCkl0J3Mg
c3BlY2lhbCBiZWNhdXNlIG9mIGEgUEhZIElEIHNjaGVtZSBjaGFuZ2UgZHVyaW5nIG1hbnVmYWN0
dXJpbmcuDQoNCg0KVGhhbmtzICYgUmVnYXJkcywNCg0KWHUgTGlhbmcNCg0K

