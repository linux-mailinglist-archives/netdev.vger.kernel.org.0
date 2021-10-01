Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430AF41F4F6
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 20:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355865AbhJAS3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 14:29:20 -0400
Received: from mail-sn1anam02on2054.outbound.protection.outlook.com ([40.107.96.54]:54414
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355691AbhJAS3T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 14:29:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZesuhNjYVW8DgXcJ+7zIXCSnaQfC2QpSpRAbMZB1uogCTBJENi+qpWTtAL6AjziVvJEX7PEAUk7X1wVNVlXFUFJhPE8cw8bxDTJWuLYfs0DmauBXN5eb5uRNCSsen629n6qvuZ06ugOhjV0MvZtFaHW1GtkbZ9hx5CVLk7u+cvB0/eJ92vdcYXONm7uzcp7ljIosAjxH/p8OuSrurOQEe63kJAaFdBcbpp1b5hLpE5Zydlpe9xkVSIwhTQVSaD25Ea2kSf4vqTXARFz4fbSsLi62vWQKOhnLIxPdLtE3ibpAaH2GewLq8EdX9I4tt6DSO1fnyjVEpjAmBgVjKPj7vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DYRyVBZaA7uZVGh1N9krNt8YYcGg0hlY5rp6etxiDMM=;
 b=Kh5IbKuhcWucGT26XLNJW2c8z5q4aJk526wbkLEcO1OzgJkKlNmdxZIcbci6Th1mdxofEWJJhI8gjP2p2rJ8PFompFE2g/w2zdu3fZXJzwvqF04YlOp0c0dMz3TRuRX+6r7rFXQJsL37BNz9g2r+SaMO5a/ynZ8sbYZVLDnvAUmNB0hjPlh/xWHJheCBo3RYEd72cX+Y+fyyXUPoLjvgiSf/CsaNOdWyelOPuTjcR199+ssZwCMHgFQ96VIanmBAuh1fhupazlr8KxeKfJ8J4g0Cprfc72dSYB99kkAhu8luur6Xl1P0WPYcsIzmWVjBa9CBiwzh9Pf0Rc5mf8/MGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DYRyVBZaA7uZVGh1N9krNt8YYcGg0hlY5rp6etxiDMM=;
 b=sSDh9NlR8AHoTYvVkjoVymiYQU6rn8zreR2AeqJ74+OsDaCMFAQZ0NjTHAlAjJgAh7vM+ovKPVOttZoLTuJCbqCNOXoD9+EKXsGonQORdLmOXTy99Pow2g3M4d47uCPP9dD7ghSgwY1m1rJPXT0QdC/APH69Q82437vDfRPtjfzEY6kOXbig2m/MtfoSZLd7N4K5gqAlBepZPaXGb1LIjmfphDC37iNJWKm9DIqwpjbr7LkoUksFnjiDmgSq3lXZ0TT/BX9lxquuCpGDAeARhnnL/313PLNUnLlLhc1Eck5wWeao2u+w+nIXdwI+WnkqaEsCxWtuU3G3fXlD7mUg1w==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4259.namprd12.prod.outlook.com (2603:10b6:a03:202::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17; Fri, 1 Oct
 2021 18:27:34 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034%6]) with mapi id 15.20.4566.017; Fri, 1 Oct 2021
 18:27:34 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "patchwork-bot+netdevbpf@kernel.org" 
        <patchwork-bot+netdevbpf@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>, Raed Salem <raeds@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net 01/10] net/mlx5e: IPSEC RX, enable checksum complete
Thread-Topic: [net 01/10] net/mlx5e: IPSEC RX, enable checksum complete
Thread-Index: AQHXtlEB6dKxKEJJskqQ9TvqFGuMlqu+Hq4AgABYsIA=
Date:   Fri, 1 Oct 2021 18:27:34 +0000
Message-ID: <b8be86319c06c5de4770a9f84b3e7a6847ff217f.camel@nvidia.com>
References: <20210930231501.39062-2-saeed@kernel.org>
         <163309380890.18892.12905958838273991886.git-patchwork-notify@kernel.org>
In-Reply-To: <163309380890.18892.12905958838273991886.git-patchwork-notify@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d6ded4e-a66f-45bc-23e6-08d985092347
x-ms-traffictypediagnostic: BY5PR12MB4259:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4259D9CAB9F0DEA01EA29DF2B3AB9@BY5PR12MB4259.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bdERwMcTxwnLHDkPSOu+jggKMncV7BNYrYLlEQ70vVnpwpjeHLOAY6CSFw58qul5CaVlONsxs3beSZptUhh6HPpQBzKaZOg05xQmO+3cjk+IsIlyhvbH1bNZjBu/Zr06YVkBVkGUxHw/vRAjlamzC8zDItG63wJE76U+tyjmamb0Nwv/Pds6zze6ZZ640cbKup1dtu3oBmNRmRQsmnNzs2QnoVlDL1BkphQ4btM3NJf6n7w7ba0DMMcM/4qalhKmhBaoMYXm5id+4tgVYZXQqr7BjsZcnqJfTQxz12oSV5AdkJq/zvkJXLH0kCMuHQKhWvOAEvrgdh4PSSHNQC0IOynq3Q2P091weFurt6FzfgVklzyEYc9dk/aV83x5FzxlPGuemNqNhfaoNkzwl4+IJ0y32c6QYu6wX+lBI1qbNUOX0lHr/DSTn7gL7Coa5ic4lJr/4eNdQO07XWwh9Rc108GhiM9C/XcZdRtC0uGHml4ouEVw6Os8eO4FEVf8HtBjMElGjVZ57AWpdhB8BDErq6qVzhCQVS/aD6bAraFNyzeBVg6JaqG6lgC+DkDgBLsivFaXQSfTZv3Bb/+opqA1qOl1G4j76esdPAuQTnBYvkMj3Km6l039B8KVIxUWYMmxOHuNY1VAJ3Mq+lgv6LHVu/RbskFWbSQEC8Lc/ZluC3sWMk0ScTBVn6QVk/jcE8g2WCPHye7yPTyHbZrINGLjFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(2616005)(5660300002)(38100700002)(38070700005)(4326008)(71200400001)(186003)(54906003)(86362001)(26005)(558084003)(64756008)(6486002)(6506007)(66556008)(508600001)(8676002)(66476007)(122000001)(36756003)(2906002)(76116006)(66446008)(8936002)(316002)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZjVvYmJVL1NoZHMxRlh1NTdlOGorS0JJVXE2Mm5uOE53WmFkenRoSHJLd1F0?=
 =?utf-8?B?ajZ6RnpCdi81KzI1RlhENjYxMGI0QUphNnJzU2lEL1hYbEo2UGUvRjdQdXRW?=
 =?utf-8?B?aCtoalhXL2h5YVgxU1dydm1jSHZURTlqOXdBSFI3VDBUM3FWZ0ZQaUw3Wnp5?=
 =?utf-8?B?d0loQlpHK2xHNm5ZajEwbUNXaUlRWW42akZPNEZGVlU1TGJtY28vMG80VmFy?=
 =?utf-8?B?aGFiNnlMeWxlOGtQV1dMRUtrWTZJYkJJcXlQY1RXdDFvbFRwZHZjT1p2U0I0?=
 =?utf-8?B?cnVQZzlrK3Y3QmhYMlBkSE5LVktzQUJDa2FBNUg4aDdSRE5wVXB5blhkN0p1?=
 =?utf-8?B?TldQRlhTR1Qva01BZklOR1FmaXZ5MVl3SlNNTGNEM20xZnFuTk1IUFd0UkxZ?=
 =?utf-8?B?M2VuRnV2U205WUlib2NzaHQ0VUQ4dGNVNDIzVENRakRYM0FucS9ySDVKcm9C?=
 =?utf-8?B?V3ZnUy90SjBFZDFxUU9CRkJLVGhhU2JJN0xkZFZoVTk3MVVZSmVlenRralNF?=
 =?utf-8?B?akZjYjNCMEQwUjlveXZtRDhKTWxqWFZ1R0RCKzR2U2xBUFd1NWtGeUoydjF1?=
 =?utf-8?B?UGllWFdZVEFjZ3hrckdtM2ZSUTljN0h0TnpTWG1MSGUwR3NZNG1nTGtvdnVV?=
 =?utf-8?B?Tlh2RHkyRHRWcWlObzFvMXp1MENodFhaalBRNVhKd3JkVitKMS9LZ3R6OTN5?=
 =?utf-8?B?M1I1MExRVnU0bS9Od08rYWhNVkMxbllkRkxaTDlKTjJIbHBZc1hWYW1hblQr?=
 =?utf-8?B?Z3VVekR2NklwWlhyQkNxbFhBNFVjNG1aVloySkhacFRVNlg1OExtaFBDV1Bp?=
 =?utf-8?B?N2pvbENtVmVKbTdCZmJ4Vm9lZVg3aUdmVXBoblI5bFZxTm1rekthV1VvaHpX?=
 =?utf-8?B?VWdHazcrL1lyUEUweVJlRGlWZ1FkNVdkd2EzWFJzVlhWVHY2SGpBVW1wYVow?=
 =?utf-8?B?bnR1ZHBOSTdDZGFYQ3owbFpDZkVYWG9JUnZSVUJ1Q0IxY00zOElEMFFGS2xa?=
 =?utf-8?B?YlM3QU9kaFlrcUxwNzh0NnZSUzRqYjRGMFJoY2JiNG1UOXVpamgrcm9MdTUz?=
 =?utf-8?B?eW45b0ZKWXl6eTVTKzYwOStaU0tvSjBJL0VQZEZueE1qUXBZZFFiTUJBNzZE?=
 =?utf-8?B?NlpUY0l6NzRaaWpZbVVrUmRNYjVYR0xxTjhsU0lTZDA3a3h1blp1WnI1NGY5?=
 =?utf-8?B?OXRrVUdEMFBNcFdXQ2o0eGhiK1VHTDhxWWJxb0I1dWJKQmhlRmd6dlc0SnIw?=
 =?utf-8?B?QVY3R01kZU02dzJ3cG1pRS92WDFkMG1ZcnFMSWNjendrZ2JqT21GbFh6VGlW?=
 =?utf-8?B?N2w1Nkowcnh2bS9sQWlVVndOSjVmOGVxQUwrRWl5WmVHaG4zVGVRcVNOWUZr?=
 =?utf-8?B?eEx6Mjc0NTVxQTJGZFFiN01PekJ0bVlkRHRpNHdnWFpLODNqbzc4RXlWYmdT?=
 =?utf-8?B?amZ1VlEvZmRHcVc3b3JFc2M2THBnMmVYMm1WYzBwSCtqY0Yvcm9McDl1cVZE?=
 =?utf-8?B?aEp0NG8vbUk1SHowS0thWWZ6cDduVEhxb0FldWNydnFrQUQwb0toYkZmU1VQ?=
 =?utf-8?B?b3RoYWZHOXJXdGRHcEkzM3ZtWGEvMlM0em9tUy85dWhCTHBBVmo5Mm5kUWVS?=
 =?utf-8?B?U0V4MnZscy95cTZkbjUvdFVGN2tVNCtPWHpNekU1amZibDJLU2s2T0FqNlhr?=
 =?utf-8?B?SmMzYlcwNGRtSnZZeWZXVk9xVTN2RUFMZ1BXL1lzV3ZKMExVSzZwS1ZCTS9T?=
 =?utf-8?B?elowRG5YWnJSN2dCdnZiQ2FiZXVxQmRUZjdBT0JFQkJoVHcreTc2bDFxMnB5?=
 =?utf-8?B?dzJ5UTlNOGM5Q0lCN0xaZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2027554D60C1C94EB956BCEA3FA88229@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d6ded4e-a66f-45bc-23e6-08d985092347
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2021 18:27:34.0808
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1CHBy0dvN2vk+fpWRBSbtd7wkmjfV/S4zLHAYXc0jIE/W3p+kwYNMhY5Pdw2waUx5xkUi0IPeiFDXBvVIMYfBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4259
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTEwLTAxIGF0IDEzOjEwICswMDAwLCBwYXRjaHdvcmstYm90K25ldGRldmJw
ZkBrZXJuZWwub3JnDQp3cm90ZToNCj4gSGVsbG86DQo+IA0KPiBUaGlzIHNlcmllcyB3YXMgYXBw
bGllZCB0byBuZXRkZXYvbmV0LW5leHQuZ2l0IChyZWZzL2hlYWRzL21hc3Rlcik6DQoNCnRoaXMg
d2FzIGZvciAtbmV0Lg0KSSBzZWUgaXQgYXBwbGllZCB0byBib3RoIG5ldCBhbmQgbmV0LW5leHQs
IHdoeSB0aGUgYm90IHNheXPCoGl0IHdhcw0KbmV0LW5leHQgPw0KDQpBbnkgbWlzdGFrZXMgb24g
bXkgZW5kID8NCg0K
