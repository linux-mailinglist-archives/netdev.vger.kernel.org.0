Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D1740FB83
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244272AbhIQPPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:15:55 -0400
Received: from mail-bn7nam10on2088.outbound.protection.outlook.com ([40.107.92.88]:46465
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240788AbhIQPPr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 11:15:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEOuBvudRRRZC3c+jZE/QS2N7SkYM57oUowU/j+VBZBjLxpW9WGt168Et7v6og4HcsqXNU0pg3aNFY3FC35hbkL+sEKOozU/Qm5n4Lt4qkmIMHXnBKAamEUJ+bC3Q/fX3mR3myHUI5PwgKa6sFUAZkSoTrtHLpzbEzvA2X3oUJlx94++eb8BCazSe0671Yc3hDutQ9Zdg9fb6Aos3iRG3piY+twZnQN1lpcDdPPhTt7oCSwlVTMMdm+9juBv9STG7hWrevYBW1NWLFGM3hRFERuviFsEoSmvJ+ckYHIazPZf1BDdROOEwpzH/yaBTDv81P1J9Xbpt7MJwLsEWCLXDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=nzBb8Fn9gKf6LChvA6DMNY6Tcck/ECvvmg288A3o0zs=;
 b=fIFNcKELD4LYE/aTJfAlwkEK+SiPfw0KX+Gkv16dZfDrlm0Vcg5jRsOxiLugLmRBF/aouWCdlgIMju0qKJmTIT7G2HBynvj5R/KlbdwKgYIg5BAB61qGBZZL1a9sXcuMExSWzKwGtSrMLIWSR643xe2zugkM5Z/JX4nqIy+ev7hVNa9YsuKbQD6k90tCfoE+A1ge74OIMmZCNruUJT/AZALcUtuKeOhHUpcKlv1RmWtJGIGeNu+m5GaH2mrJgoBrwqWLoHNGE7lHuBGYnh2uDGzhFKw/keqe4x8SQ/W9c6j74olyWXsYgfk/uXQxzyBluXNeCWrw1KbD4NPawOU8Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nzBb8Fn9gKf6LChvA6DMNY6Tcck/ECvvmg288A3o0zs=;
 b=Y0LJUIU73uOJTKbPvTzA3Q2I2oKP4o2TFuSNkfszNe4USOUJ9e0G+Ce1zXtDMV2uEx0ExHnf2EhifgrXdar2sLRr4Ida+rvm7Xa13MF3y7LpNelV37aQuQmlGJfeVWmkCepSl7x+O7HieYZa7w5BiN7bW/CZfWs7VMJgjSj6pMo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4574.namprd11.prod.outlook.com (2603:10b6:806:71::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 15:14:23 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 17 Sep 2021
 15:14:23 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v6 02/24] dt-bindings: introduce silabs,wfx.yaml
Date:   Fri, 17 Sep 2021 17:13:38 +0200
Message-Id: <20210917151401.2274772-3-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917151401.2274772-1-Jerome.Pouiller@silabs.com>
References: <20210917151401.2274772-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA9PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:806:20::34) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SA9PR03CA0029.namprd03.prod.outlook.com (2603:10b6:806:20::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 15:14:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 644dcacd-a966-4e96-9e8a-08d979edd48c
X-MS-TrafficTypeDiagnostic: SA0PR11MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB4574E909BC1621B953282CEC93DD9@SA0PR11MB4574.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hIPNzE7TBwr+oY/U3e23XZpnbUhHvTM22f9bZ7i4ILjAZevs3wWES0A0ZqhAnVBPoTJYe1oEoc983dxJEvkQDimu2+nELovuq6z9GmW0+04A7guIG3J2JCgVDRUbzVhRQGrlO/BGFYJ/3e3vl1bsGdpdVsR1aP2ZQnAYuzvn1dqeQhkOqDCg/7oVqTchW7VPDWtOLnrYGZB/71g1EpwlqmGOOrpkMutRztwM0FGrK2S2uTqaq4B8Ky+9xMcwynqBjXYOl3saCnXJ4WSC6scAKz71LxhhqEmjNQQbuVxGKqxs7QIzbvu/BwQ7s+n1V/bILkrRtpeXOkFJY10EhVoJ+YaaO5S4A2GPfyifm2/IRssLeU1bgLTCK+1nwvDqUkZEHM6v2tX7IT6O6NX7HZV2sSmVxDzGuFuXtJ9rBU4awAy/6CiKzZFpCNHvrTc9xNVmEz5dBZxbXo4wFHfLY58W2bDYMywjj/wmU5yDImFk6agm0wtnC4WtNxeENswKQacljW5frLoZFDLCF8DgAXIc1hCyMWNtKo0c6gwsVQ9AcEnD/5L690NbUMbOq8iyqVlCcEsYm0AbBBfdfFmiHxIml4vLorHmP6idvgQ7Ec5UvGTnoFb6Dy8Nv2ezNLJjWdRt0zQUl5opRhqdmI72cVWPk/y/0Iw9I/6NvxAnrBmis8cP/sdCfKQ/MFKtxUIvPcj+Nl6glu0xdiY19VM5WO5S2yLAn/xkbyRF0KTuOLo4go0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(39850400004)(396003)(366004)(52116002)(6666004)(38100700002)(8936002)(7696005)(966005)(478600001)(6486002)(186003)(7416002)(86362001)(5660300002)(54906003)(66556008)(66476007)(4326008)(1076003)(66946007)(2616005)(107886003)(6916009)(316002)(36756003)(8676002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MkJLVzBXYk1Ta081WjBtTU9YajFiNWZUOVJ1aUJVdzNYcEp1dFlJMGpDY1hU?=
 =?utf-8?B?VG85RnZSaDFnWExhZTRVcXRvWmdSYzNVR3k0TXFKYmRyTldCWjlpQk1CRENK?=
 =?utf-8?B?VWlCOUgvaG14dFYxWEg0YU1UKzdZYzVJM3UrV2cyeDRzMFNjWDdHL0tHeEpT?=
 =?utf-8?B?c0thMFJXRXpqRnlDd1FlR0VFQTk1ZXo4SlZpQ25MeTgvZmNsRXNmVmFUeUh0?=
 =?utf-8?B?NXY4NHhVRjR2Mis4ejczd0RrQi90WkFlc2VlUmZTRFl0bkdZY1FKYUR1aCty?=
 =?utf-8?B?bzgzQWNZOEtzT3hocVQ5bDZGMjZYM3g1Ylh3SXhzdXNNNjFVUUFGOThtaWxy?=
 =?utf-8?B?R29oYmo4Q2FoR0haMmVlWVJsUHF4ZGowRmpyZDVVbEhaVkdNQUk1OWdERm9x?=
 =?utf-8?B?aWQxMHNnMHdvQlV2cEtMWkphOEZaSWFYVmZyZVFQQkJ2cHg2NXVaRkVPdzIw?=
 =?utf-8?B?S3VHdzI1YmE1bWtEa2pneE9CU25oQnNDcmVsZ1FVYWk3eWZUY3V0Z1I5emU3?=
 =?utf-8?B?OGxNc0xVVXhvT0NGbXRIaldrQXcwNmpOUjZ6VzN3MDMyU21rVThiYlJmWEZi?=
 =?utf-8?B?QXc2TmVrVVhPQ1d1TGVLWUlaYkFUamhVR3JNdXk4YnFvR2NhNnFYamE5OEdh?=
 =?utf-8?B?WWRXcGNMRkZCQ0NQK0Z6TE9XVVI0QWFqTDRyeFlyaEFIaXgzT2tUTm05c3dy?=
 =?utf-8?B?V1RqU1hvaXJuWmZPU29ETm5kQzhlM2YvTzZVa1VyUGMwTm1yQmhqMlRlTHZj?=
 =?utf-8?B?WEM0VWZ6UEZRK2pVQ3l6ejNsL1F3eURWeDk5bE9kWmROdDVWenlacks0TkdR?=
 =?utf-8?B?aVpadU9ReVBkaU1yM1hQZThyYncwQkxINWhoNHV0UnlKbWN6NzhSOVpoNlJS?=
 =?utf-8?B?S2srQkxpWVd3QzdCcSt3UXVUMEExS2RYd2xYQXM2MnBLZk15RHJENU12ZlNG?=
 =?utf-8?B?QnFCVlF2TmpxTXFjM25GY2lvREd2WVBCZ0daaFlMSCtuOS9DRHVyK0g1ZVVh?=
 =?utf-8?B?NU1ZYUU0MTdXRnpZQmkwNWxRL3pGVVNmTXZEa3cwYmNzNzlhTHM5REtJSjYw?=
 =?utf-8?B?WG14TnhzQ2k2YjJ6ZW5zeW4rQzY0OFJ4TjVXbGh1S1NaV2g2MnNRZnIrZkhq?=
 =?utf-8?B?dld5bThvU0lSTE9nYVNUaXZJLzJrbFlqTWRWSjhsa2dHOWpNYU40TGVCSGtj?=
 =?utf-8?B?MGdYaisvdjBUSVRzc3VETEFvMzJpN0NadnhQYjNlM0pBVzByVmFHSGtPeU9v?=
 =?utf-8?B?ckZRK2dFRGFDU2dlWERFclJHMSs3WW03alVJWDNUdWVKU1BDWnZlYzUvQVRM?=
 =?utf-8?B?Mjg2amp6UWwxQWFaaXFGNjRDbit0c0IyUVNWRnRtUCtpazl6dVQ4SzhDanVG?=
 =?utf-8?B?dndrSXA3Q1ZscEJoUVc0WklScXlJY3laWkd0Uy9XUnQ0cy9BVHhLU3YyQWgr?=
 =?utf-8?B?WW1QY0dqVUdPZUw3dVBtS1BvVXM4VUxSZzFQd25PenlyTUJBSEJqSmwvSXB1?=
 =?utf-8?B?QkpNaTg5NHF4NXhMdFhIakNnQXBCSWZOSWFrSExGMzMwQVBCWmR5NzJQaFlh?=
 =?utf-8?B?a0NsVFFwMUZRZzVtYzFMa0dzOTlnNWcyV0E1N0lCaUJFODhzWGVvRlhtNjRa?=
 =?utf-8?B?MEJVd1BSbDlwQ0g2WHlSYk1VTnJyMVVFQ0FSYU9wRSt0N2dLeDdaTSszaERZ?=
 =?utf-8?B?V0tMMnAxUDdNRzE2dTJnMmVNWkVDZ09wQUJVTEIwdUFjajhHa0c3WDJCT0M1?=
 =?utf-8?B?VTFjR2xsT0dJS0xWR2ZXN0ZuRmZzMWZUVTUydVB2bXZ3UHVNMllGZE94My9O?=
 =?utf-8?B?RXhGKytvQ1FQT214Wnc1NjNNRytnSzBFNXdQQzJSZ0tsWjQyRTlUNHk2RGNJ?=
 =?utf-8?Q?80r30Pf86Q4x1?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 644dcacd-a966-4e96-9e8a-08d979edd48c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 15:14:23.6427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EFdq1+c237S91UYO7Db6NCJz89UxG4sZi7sBD9Vkcz8qRNOIikI0xvKzyryPrTUGEPqrYYUNnAvXBj6lwXU8Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4574
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKUHJl
cGFyZSB0aGUgaW5jbHVzaW9uIG9mIHRoZSB3ZnggZHJpdmVyIGluIHRoZSBrZXJuZWwuCgpTaWdu
ZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+
Ci0tLQogLi4uL2JpbmRpbmdzL25ldC93aXJlbGVzcy9zaWxhYnMsd2Z4LnlhbWwgICAgIHwgMTMz
ICsrKysrKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDEzMyBpbnNlcnRpb25zKCspCiBj
cmVhdGUgbW9kZSAxMDA2NDQgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC93
aXJlbGVzcy9zaWxhYnMsd2Z4LnlhbWwKCmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2Rldmlj
ZXRyZWUvYmluZGluZ3MvbmV0L3dpcmVsZXNzL3NpbGFicyx3ZngueWFtbCBiL0RvY3VtZW50YXRp
b24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvd2lyZWxlc3Mvc2lsYWJzLHdmeC55YW1sCm5ldyBm
aWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAwMDAwMC4uOWU3MTI0MGVhMDI2Ci0tLSAvZGV2
L251bGwKKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC93aXJlbGVz
cy9zaWxhYnMsd2Z4LnlhbWwKQEAgLTAsMCArMSwxMzMgQEAKKyMgU1BEWC1MaWNlbnNlLUlkZW50
aWZpZXI6IChHUEwtMi4wLW9ubHkgT1IgQlNELTItQ2xhdXNlKQorIyBDb3B5cmlnaHQgKGMpIDIw
MjAsIFNpbGljb24gTGFib3JhdG9yaWVzLCBJbmMuCislWUFNTCAxLjIKKy0tLQorCiskaWQ6IGh0
dHA6Ly9kZXZpY2V0cmVlLm9yZy9zY2hlbWFzL25ldC93aXJlbGVzcy9zaWxhYnMsd2Z4LnlhbWwj
Ciskc2NoZW1hOiBodHRwOi8vZGV2aWNldHJlZS5vcmcvbWV0YS1zY2hlbWFzL2NvcmUueWFtbCMK
KwordGl0bGU6IFNpbGljb24gTGFicyBXRnh4eCBkZXZpY2V0cmVlIGJpbmRpbmdzCisKK21haW50
YWluZXJzOgorICAtIErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNv
bT4KKworZGVzY3JpcHRpb246ID4KKyAgU3VwcG9ydCBmb3IgdGhlIFdpZmkgY2hpcCBXRnh4eCBm
cm9tIFNpbGljb24gTGFicy4gQ3VycmVudGx5LCB0aGUgb25seSBkZXZpY2UKKyAgZnJvbSB0aGUg
V0Z4eHggc2VyaWVzIGlzIHRoZSBXRjIwMCBkZXNjcmliZWQgaGVyZToKKyAgICAgaHR0cHM6Ly93
d3cuc2lsYWJzLmNvbS9kb2N1bWVudHMvcHVibGljL2RhdGEtc2hlZXRzL3dmMjAwLWRhdGFzaGVl
dC5wZGYKKworICBUaGUgV0YyMDAgY2FuIGJlIGNvbm5lY3RlZCB2aWEgU1BJIG9yIHZpYSBTRElP
LgorCisgIEZvciBTRElPOgorCisgICAgRGVjbGFyaW5nIHRoZSBXRnh4eCBjaGlwIGluIGRldmlj
ZSB0cmVlIGlzIG1hbmRhdG9yeSAodXN1YWxseSwgdGhlIFZJRC9QSUQgaXMKKyAgICBzdWZmaWNp
ZW50IGZvciB0aGUgU0RJTyBkZXZpY2VzKS4KKworICAgIEl0IGlzIHJlY29tbWVuZGVkIHRvIGRl
Y2xhcmUgYSBtbWMtcHdyc2VxIG9uIFNESU8gaG9zdCBhYm92ZSBXRnguIFdpdGhvdXQKKyAgICBp
dCwgeW91IG1heSBlbmNvdW50ZXIgaXNzdWVzIGR1cmluZyByZWJvb3QuIFRoZSBtbWMtcHdyc2Vx
IHNob3VsZCBiZQorICAgIGNvbXBhdGlibGUgd2l0aCBtbWMtcHdyc2VxLXNpbXBsZS4gUGxlYXNl
IGNvbnN1bHQKKyAgICBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbW1jL21tYy1w
d3JzZXEtc2ltcGxlLnR4dCBmb3IgbW9yZQorICAgIGluZm9ybWF0aW9uLgorCisgIEZvciBTUEk6
CisKKyAgICBJbiBhZGQgb2YgdGhlIHByb3BlcnRpZXMgYmVsb3csIHBsZWFzZSBjb25zdWx0Cisg
ICAgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3NwaS9zcGktY29udHJvbGxlci55
YW1sIGZvciBvcHRpb25hbCBTUEkKKyAgICByZWxhdGVkIHByb3BlcnRpZXMuCisKK3Byb3BlcnRp
ZXM6CisgIGNvbXBhdGlibGU6CisgICAgY29uc3Q6IHNpbGFicyx3ZjIwMAorCisgIHJlZzoKKyAg
ICBkZXNjcmlwdGlvbjoKKyAgICAgIFdoZW4gdXNlZCBvbiBTRElPIGJ1cywgPHJlZz4gbXVzdCBi
ZSBzZXQgdG8gMS4gV2hlbiB1c2VkIG9uIFNQSSBidXMsIGl0IGlzCisgICAgICB0aGUgY2hpcCBz
ZWxlY3QgYWRkcmVzcyBvZiB0aGUgZGV2aWNlIGFzIGRlZmluZWQgaW4gdGhlIFNQSSBkZXZpY2Vz
CisgICAgICBiaW5kaW5ncy4KKyAgICBtYXhJdGVtczogMQorCisgIHNwaS1tYXgtZnJlcXVlbmN5
OiB0cnVlCisKKyAgaW50ZXJydXB0czoKKyAgICBkZXNjcmlwdGlvbjogVGhlIGludGVycnVwdCBs
aW5lLiBUcmlnZ2VycyBJUlFfVFlQRV9MRVZFTF9ISUdIIGFuZAorICAgICAgSVJRX1RZUEVfRURH
RV9SSVNJTkcgYXJlIGJvdGggc3VwcG9ydGVkIGJ5IHRoZSBjaGlwIGFuZCB0aGUgZHJpdmVyLiBX
aGVuCisgICAgICBTUEkgaXMgdXNlZCwgdGhpcyBwcm9wZXJ0eSBpcyByZXF1aXJlZC4gV2hlbiBT
RElPIGlzIHVzZWQsIHRoZSAiaW4tYmFuZCIKKyAgICAgIGludGVycnVwdCBwcm92aWRlZCBieSB0
aGUgU0RJTyBidXMgaXMgdXNlZCB1bmxlc3MgYW4gaW50ZXJydXB0IGlzIGRlZmluZWQKKyAgICAg
IGluIHRoZSBEZXZpY2UgVHJlZS4KKyAgICBtYXhJdGVtczogMQorCisgIHJlc2V0LWdwaW9zOgor
ICAgIGRlc2NyaXB0aW9uOiAoU1BJIG9ubHkpIFBoYW5kbGUgb2YgZ3BpbyB0aGF0IHdpbGwgYmUg
dXNlZCB0byByZXNldCBjaGlwCisgICAgICBkdXJpbmcgcHJvYmUuIFdpdGhvdXQgdGhpcyBwcm9w
ZXJ0eSwgeW91IG1heSBlbmNvdW50ZXIgaXNzdWVzIHdpdGggd2FybQorICAgICAgYm9vdC4gKEZv
ciBsZWdhY3kgcHVycG9zZSwgdGhlIGdwaW8gaW4gaW52ZXJ0ZWQgd2hlbiBjb21wYXRpYmxlID09
CisgICAgICAic2lsYWJzLHdmeC1zcGkiKQorCisgICAgICBGb3IgU0RJTywgdGhlIHJlc2V0IGdw
aW8gc2hvdWxkIGRlY2xhcmVkIHVzaW5nIGEgbW1jLXB3cnNlcS4KKyAgICBtYXhJdGVtczogMQor
CisgIHdha2V1cC1ncGlvczoKKyAgICBkZXNjcmlwdGlvbjogUGhhbmRsZSBvZiBncGlvIHRoYXQg
d2lsbCBiZSB1c2VkIHRvIHdha2UtdXAgY2hpcC4gV2l0aG91dCB0aGlzCisgICAgICBwcm9wZXJ0
eSwgZHJpdmVyIHdpbGwgZGlzYWJsZSBtb3N0IG9mIHBvd2VyIHNhdmluZyBmZWF0dXJlcy4KKyAg
ICBtYXhJdGVtczogMQorCisgIHNpbGFicyxhbnRlbm5hLWNvbmZpZy1maWxlOgorICAgICRyZWY6
IC9zY2hlbWFzL3R5cGVzLnlhbWwjL2RlZmluaXRpb25zL3N0cmluZworICAgIGRlc2NyaXB0aW9u
OiBVc2UgYW4gYWx0ZXJuYXRpdmUgZmlsZSBmb3IgYW50ZW5uYSBjb25maWd1cmF0aW9uIChha2EK
KyAgICAgICJQbGF0Zm9ybSBEYXRhIFNldCIgaW4gU2lsYWJzIGphcmdvbikuIERlZmF1bHQgaXMg
J3dmMjAwLnBkcycuCisKKyAgbG9jYWwtbWFjLWFkZHJlc3M6IHRydWUKKworICBtYWMtYWRkcmVz
czogdHJ1ZQorCithZGRpdGlvbmFsUHJvcGVydGllczogZmFsc2UKKworcmVxdWlyZWQ6CisgIC0g
Y29tcGF0aWJsZQorICAtIHJlZworCitleGFtcGxlczoKKyAgLSB8CisgICAgI2luY2x1ZGUgPGR0
LWJpbmRpbmdzL2dwaW8vZ3Bpby5oPgorICAgICNpbmNsdWRlIDxkdC1iaW5kaW5ncy9pbnRlcnJ1
cHQtY29udHJvbGxlci9pcnEuaD4KKworICAgIHNwaTAgeworICAgICAgICAjYWRkcmVzcy1jZWxs
cyA9IDwxPjsKKyAgICAgICAgI3NpemUtY2VsbHMgPSA8MD47CisKKyAgICAgICAgd2lmaUAwIHsK
KyAgICAgICAgICAgIGNvbXBhdGlibGUgPSAic2lsYWJzLHdmMjAwIjsKKyAgICAgICAgICAgIHBp
bmN0cmwtbmFtZXMgPSAiZGVmYXVsdCI7CisgICAgICAgICAgICBwaW5jdHJsLTAgPSA8JndmeF9p
cnEgJndmeF9ncGlvcz47CisgICAgICAgICAgICByZWcgPSA8MD47CisgICAgICAgICAgICBpbnRl
cnJ1cHRzLWV4dGVuZGVkID0gPCZncGlvIDE2IElSUV9UWVBFX0VER0VfUklTSU5HPjsKKyAgICAg
ICAgICAgIHdha2V1cC1ncGlvcyA9IDwmZ3BpbyAxMiBHUElPX0FDVElWRV9ISUdIPjsKKyAgICAg
ICAgICAgIHJlc2V0LWdwaW9zID0gPCZncGlvIDEzIEdQSU9fQUNUSVZFX0xPVz47CisgICAgICAg
ICAgICBzcGktbWF4LWZyZXF1ZW5jeSA9IDw0MjAwMDAwMD47CisgICAgICAgIH07CisgICAgfTsK
KworICAtIHwKKyAgICAjaW5jbHVkZSA8ZHQtYmluZGluZ3MvZ3Bpby9ncGlvLmg+CisgICAgI2lu
Y2x1ZGUgPGR0LWJpbmRpbmdzL2ludGVycnVwdC1jb250cm9sbGVyL2lycS5oPgorCisgICAgd2Z4
X3B3cnNlcTogd2Z4X3B3cnNlcSB7CisgICAgICAgIGNvbXBhdGlibGUgPSAibW1jLXB3cnNlcS1z
aW1wbGUiOworICAgICAgICBwaW5jdHJsLW5hbWVzID0gImRlZmF1bHQiOworICAgICAgICBwaW5j
dHJsLTAgPSA8JndmeF9yZXNldD47CisgICAgICAgIHJlc2V0LWdwaW9zID0gPCZncGlvIDEzIEdQ
SU9fQUNUSVZFX0xPVz47CisgICAgfTsKKworICAgIG1tYzAgeworICAgICAgICBtbWMtcHdyc2Vx
ID0gPCZ3ZnhfcHdyc2VxPjsKKyAgICAgICAgI2FkZHJlc3MtY2VsbHMgPSA8MT47CisgICAgICAg
ICNzaXplLWNlbGxzID0gPDA+OworCisgICAgICAgIHdpZmlAMSB7CisgICAgICAgICAgICBjb21w
YXRpYmxlID0gInNpbGFicyx3ZjIwMCI7CisgICAgICAgICAgICBwaW5jdHJsLW5hbWVzID0gImRl
ZmF1bHQiOworICAgICAgICAgICAgcGluY3RybC0wID0gPCZ3Znhfd2FrZXVwPjsKKyAgICAgICAg
ICAgIHJlZyA9IDwxPjsKKyAgICAgICAgICAgIHdha2V1cC1ncGlvcyA9IDwmZ3BpbyAxMiBHUElP
X0FDVElWRV9ISUdIPjsKKyAgICAgICAgfTsKKyAgICB9OworLi4uCi0tIAoyLjMzLjAKCg==
