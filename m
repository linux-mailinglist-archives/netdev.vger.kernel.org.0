Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76354370984
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 03:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbhEBBUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 21:20:52 -0400
Received: from rcdn-iport-5.cisco.com ([173.37.86.76]:16877 "EHLO
        rcdn-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbhEBBUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 21:20:51 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 May 2021 21:20:51 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3042; q=dns/txt; s=iport;
  t=1619918400; x=1621128000;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Chi456gp2doeGIXMGdAJrw5U3fch+Zw+oaF+7M0cSbA=;
  b=gquXtaoYZ/ETxnkxntyRRQzWv0Z/mmUfpzLaJI+7F2g4yXp+/G9M0Ext
   2KH9b8EYm2sPmfF+htvAdUev68VdhpYBL3QWabPPOsFux+trx09twJY8C
   spMYaXMfyOnGCA1Pq/3m2FZEjEIITdO8lMK+96eM2NjnpyFK0JSJ2NJE7
   c=;
IronPort-PHdr: =?us-ascii?q?A9a23=3Acc00LB2m4lciZf6WsmDPW1BlVkAck7zpIg4Y7?=
 =?us-ascii?q?IYmgLtSc6Oluo7vJ1Hb+e4FpFTIRo7crflDjrmev6PhXDkG5pCM+DAHfYdXX?=
 =?us-ascii?q?hAIwcMRg0Q7AcGDBEG6SZyibyEzEMlYElMw+Xa9PBteGd31YBvZpXjhpTIXE?=
 =?us-ascii?q?w/0YAxyIOm9E4XOjsOxgua1/ZCbYwhBiDenJ71oKxDjpgTKvc5Qioxnec4M?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AxwOvu6wbSpaglOp5/u3GKrPxPe8kLtp033?=
 =?us-ascii?q?Aq2lEZdDV8Sebdv9yynfgdyB//gCsQXnZlotybJKycWxrnlKJdybI6eZOvRh?=
 =?us-ascii?q?PvtmftFoFt6oP+3ybtcheRysd07o0lSaR3DbTLYmRSpczx7BCkV/Mpx9ea+K?=
 =?us-ascii?q?6l7N2usEtFZysCUdAG0y5SDAGHHkpqAClqbKBJVKa0zMxBujamZDAzZsO0Gn?=
 =?us-ascii?q?EKU4H41qP2vbjhZgMLAANi1RKHiimm5KW/Px+T2BofVD0n+8ZgzUHulQvl6q?=
 =?us-ascii?q?K/98yq0xO07R6T0716uvvEjuFCCsuFl9QPJlzX6jqASYx9V9S5zUsIic617l?=
 =?us-ascii?q?JCqqionz4BOIBJ52rVbiWJp3LWqnXd+RIPz1On9lOCm3vkpqXCNXAHIu5Mn5?=
 =?us-ascii?q?hQfBecy2dIhqAH7Itx02iUt4VaAHr79UyXjbWlJnIa9HacmnYsnfUeiHZSS+?=
 =?us-ascii?q?IlGcJshLYC90BYGopoJlOd1KkbEfJjBMyZxPFafULyVQGggkBTwcehVnl2Ix?=
 =?us-ascii?q?GeQkJqgL3t7xFqmhlCvi8l7f1auk1F2IM2SpFC6eiBGL9vjqtyQsgfar84LP?=
 =?us-ascii?q?sdQOOsY1a9BC7kASa3GxDKBasHM3XCp9rc+7Mu/tynf5QO0d8bhInBalVFrm?=
 =?us-ascii?q?Q/EnieTfGm7dluyFTgUW+9VTPixoV1/J5ioIDxQ7LtLGmlRE0xldCj59ESGN?=
 =?us-ascii?q?fSVfr2GJ8+OY6lEULeXaJymyHuUZhbLncTFOcPvMwgZl6IqsXXboLwsOjWd+?=
 =?us-ascii?q?vSOartHT4oVniXOApbYBHDYOF7qmy7UH7xhxbcH1n3fFbkwJ52GK/Gu+gfob?=
 =?us-ascii?q?J9brFkg0wwsxCU98uLITpNvugdZ01lOo7qlau9uC2z9WbM5GN5JwpFAi9uke?=
 =?us-ascii?q?7dekIPgTVPH1L/cL4FtdnaU3tVxmG7Khh2SN6TFhVeqVRx8ae+NIeR2igmFt?=
 =?us-ascii?q?KiPguh/j0ujUPPa61ZtryI5M/jdJ99JI0hQrZNGQLCEAEwhRxns35ZaAgPRl?=
 =?us-ascii?q?bWEzTnjanNtu1POMjvM/1HxCu7K89drnzS8XiGrcY0X30BQnqFSsiMmzsjQD?=
 =?us-ascii?q?JSm3x8+6ISm6C7hD6qMGcz6d5IbWFkWSCyOvZmBB7ATJhIkrrrETsAPFuitH?=
 =?us-ascii?q?i/sVUPXUbEs28VnXfsKCWIf+qjOCsshlloloDw8F11cW2BeVlXcX4Si/wgKU?=
 =?us-ascii?q?32/lBuzOSMeq2/l0yWZ1dq+JBCDBj1JR0PPwhp29e7kCSwpQ/HP3AnypIyV9?=
 =?us-ascii?q?atU4gLe63P23+rNY2DnbwHGfgR55p+KNXyqIYwIJCiUhOOICi9A+0k3BH9nA?=
 =?us-ascii?q?dXBABk7HYjiv/mwxvj8Syx22M+G+PbJBB8S6gcOMz01Rmqe9+YlJF4h8kyp+?=
 =?us-ascii?q?2+LyH4bcOH07jea1d4W17uiH/zS+EjspZPu60u8LN1ApnASDPNkHVKxg83Is?=
 =?us-ascii?q?uxlEQQRs1Akfz8E54qe8wZYCRC+FU10NyJMUswqwTzRvYkYktFtQ6SA/qZp7?=
 =?us-ascii?q?7T7bY/CEyIowX9fVGZ7i1G5v/AGy+Oz6QTBa48KXlfAXJMpkhK7aeHbcndGQ?=
 =?us-ascii?q?+qf+ZM8B6hPnixfKRURaKFFb8TxywKqe2gjquSbW71yQrQtTx0LuZS6G6hW9?=
 =?us-ascii?q?q1Gx/JFuhS8dC2UG78y5eC8Yq2lnPwRjS6YUhD2tEAekwUc8hZij4tyIcwyT?=
 =?us-ascii?q?O/T6TrokQj11tSiAsX4WLFy8yj+iPcG0oDLAjSxpNRVjNXOmKTjcvE/fODvU?=
 =?us-ascii?q?6NqwRtyN3GDgNIYtpKG9IMVYD5ICdlNNgIsNeTjt4SqzUGZA1rEnU1hz/81f?=
 =?us-ascii?q?53xLu12P3dXOv5FHfjUGhxjwJtF8pzhSwkqWZJbsi449a8e2wsZ5s1P8c=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0D0BwCd+41g/4kNJK1aDnuBV4FTUQd?=
 =?us-ascii?q?3WjYxhESDSAOFOYhwA5VEhA2BLoElA1QLAQEBDQEBJA4CBAEBhFACF4FkAiU?=
 =?us-ascii?q?0CQ4CBAEBDAEBBQEBAQIBBgRxE4VQDYZFAQUjBA0MAQE3AQ8CAQYCGAICJgI?=
 =?us-ascii?q?CAjAVEAIEAQ0FG4JXglUDLwEOi32QbQKKH3p/M4EBggQBAQYEBIE0AYQAGII?=
 =?us-ascii?q?TAwaBECqCeYQOhlknHIFJQoQILz6CSYFXAQE3gwCCYYJLWiETFAgQWHSVS5U?=
 =?us-ascii?q?DkWsKgxCJeZM1J6UiLZN0gQ6Lf5J0hG0CAgICBAUCDgEBBoFUOoFZcBWDJB8?=
 =?us-ascii?q?xFwIOjisWg06FFIUERXM4AgYBCQEBAwl8jBMBAQ?=
X-IronPort-AV: E=Sophos;i="5.82,266,1613433600"; 
   d="scan'208";a="620482678"
Received: from alln-core-4.cisco.com ([173.36.13.137])
  by rcdn-iport-5.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 02 May 2021 01:12:53 +0000
Received: from mail.cisco.com (xbe-rcd-005.cisco.com [173.37.102.20])
        by alln-core-4.cisco.com (8.15.2/8.15.2) with ESMTPS id 1421CrTh016499
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=OK);
        Sun, 2 May 2021 01:12:54 GMT
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by xbe-rcd-005.cisco.com
 (173.37.102.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3; Sat, 1 May 2021
 20:12:53 -0500
Received: from xhs-rtp-003.cisco.com (64.101.210.230) by xhs-rtp-002.cisco.com
 (64.101.210.229) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 1 May
 2021 21:12:52 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-003.cisco.com (64.101.210.230) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 1 May 2021 21:12:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K+71cvvTIC1RJ3IDbSdvFkM2Vdg69zZDdel/q7E0J63B8AUBlVd8JJfrhzfzNBFjWPBaF+no4uO4zz+kPoFvKfKwHcvEVMqGfBCZ+VQEEdoIdp297ZqaAe/8G/s6fCtkmZmfpkesK47A+3f725/WcG323ddTjFgxYt5MmGJvORdpHWYyhKAgIfbAp5ENk8V32e+5r86uqpd8VbVnuaUTfrXPU6CvkMKnjCMM0WrQ0PYfg0WI0LTHj1d2DgEKTRDlAwMrAcF5LCOJTz57bhBKvwHAWVw8mFeFcB7lBXNgy6mn+subS3vRBUYdeI2vwrLhGmd1dmxcv5pdQx4zwXGcTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Chi456gp2doeGIXMGdAJrw5U3fch+Zw+oaF+7M0cSbA=;
 b=PBS3UK0Yh/s/GMaI7uR2e6ThOcSMVP47uGyTFOTkcU/ulw4FAU7qWDg8M9GeaqK36J4JnUIA0633hkIBsX7hfMaMPdEhF0zx77m5IqwYxCxrc1Zkdx09xJwRDtk7qmuJIxZR3JBqTIcmnw83033RE0e3+utowxY7yOTu94jp3b0jgy0aQNaVIRS+vrvK5UeMl56psFDvC+aPq0d1FDinleJM4d7LJUtgCZmhN3SO5fb4leSlMygHXzofwPvAyR5b3azvzil/TUPPz3eoFk6pjqQRdsx/cmeaXx7VlPDsaLyAjaRVQQjROSd1Busw6/qVq6qKfMxC5Et8K1BRZYY47g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Chi456gp2doeGIXMGdAJrw5U3fch+Zw+oaF+7M0cSbA=;
 b=j8tVA0vAVNqrylEeO/Y8w9JWJVYTLJnuf4yDRkU3V9lsr5KOjYXcedFmGTRVLkgpoyV/5hj5twwIszux+deqvkBwMF6CtIeCL8xhDNvXG4r5RBb/7hdfZHym7XAcUgIFSy9I+GCL2hTExxaj4bEJccv4YNulzc6txKZS48S7C/Y=
Received: from MN2PR11MB3711.namprd11.prod.outlook.com (2603:10b6:208:fa::26)
 by BL1PR11MB5302.namprd11.prod.outlook.com (2603:10b6:208:312::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.38; Sun, 2 May
 2021 01:12:50 +0000
Received: from MN2PR11MB3711.namprd11.prod.outlook.com
 ([fe80::ec1c:f2b:bc14:e5b0]) by MN2PR11MB3711.namprd11.prod.outlook.com
 ([fe80::ec1c:f2b:bc14:e5b0%6]) with mapi id 15.20.4087.040; Sun, 2 May 2021
 01:12:49 +0000
From:   "Govindarajulu Varadarajan (gvaradar)" <gvaradar@cisco.com>
To:     "Christian Benvenuti (benve)" <benve@cisco.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "lyl2019@mail.ustc.edu.cn" <lyl2019@mail.ustc.edu.cn>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Govindarajulu Varadarajan (gvaradar)" <gvaradar@cisco.com>
Subject: Re: [PATCH] ethernet:enic: Fix a use after free bug in
 enic_hard_start_xmit
Thread-Topic: [PATCH] ethernet:enic: Fix a use after free bug in
 enic_hard_start_xmit
Thread-Index: AQHXPvBEd0+rC5gAN0yWCCdwnKjZHw==
Date:   Sun, 2 May 2021 01:12:49 +0000
Message-ID: <d3b9cc3a6bdc0dcdd64b4070a120c481b12b79c5.camel@cisco.com>
References: <20210501153140.5885-1-lyl2019@mail.ustc.edu.cn>
In-Reply-To: <20210501153140.5885-1-lyl2019@mail.ustc.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.0 (3.40.0-1.fc34) 
authentication-results: cisco.com; dkim=none (message not signed)
 header.d=none;cisco.com; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [2001:420:c0c8:1001::1b6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c104d939-4b0b-4df0-0de7-08d90d07674d
x-ms-traffictypediagnostic: BL1PR11MB5302:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL1PR11MB530286746876A556616ADDA8D45C9@BL1PR11MB5302.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 14sghQWtdatTAr99IFjLt1MmrIc4qukzS45Kr1B3v8fprvTNa1chNvnUJxGqkMw2G7K7pl8vBsndajlkTbRM9Y7vJtaXqPyqixRMyqh56pJVrNbGIb1V7PMCSf/qzhJv7Pmy8Yk4+2X//EOMFMY19HenY1zVcIM2Nt8FAYymA+F8L2csPU9eAQAFbpXffazq/DzY3HP0XMZa9ILghfP4R3WWBRxqA3tIaeNGALDj3TAJQkVvEmYPDIlQFOLcV1YbuYPbwl43+GRv7qGuI/x33cZYNUSgjQITyHY5uMWVM33QJTmhZxT0/BMph6gRH6LCE174OXqQDDwg9yjyF095ghyyN/SY7kQuK5pNlEdyGJhkZhMXVQpkc+yDzzZxbQzahZwFT/rpViXGFLjNIz5Q87/yXTfmnx8fPr+pqusoPGJQmv7MijuJVIA3tjowm317estL410zUI1adbgJKhCgLAdFBmWOai14ufKlD10Ml6J+XhsKSGZU/EakjIoKct1X0WFepuGCssiYVKF/K5JFLdkl2/QGla8TGARw/LumIgOvd0LzZWWecIV8uTrcbT6ROV6EpY3VERGmm1dPGsCumKQ/fWhR7XZsXwGOc3bI7+tbE8l6TRN7vla3VnrW+R6+fc6eqJ0O1vNkswOjmUotcL46uV6JCG9ELcrMqULh8bYHt53UKjOj5Qf+Jj+8xSkI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3711.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(136003)(366004)(39860400002)(346002)(6486002)(316002)(38100700002)(66946007)(6506007)(2906002)(36756003)(186003)(2616005)(54906003)(110136005)(8676002)(8936002)(122000001)(86362001)(478600001)(66476007)(966005)(5660300002)(83380400001)(71200400001)(107886003)(66446008)(6512007)(64756008)(91956017)(66556008)(76116006)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?d0hQc0ZIVkE0K1FiTG05TUs5T3BtMGpNNFhheWc2aGx2a0RhdUN0L01Zak9C?=
 =?utf-8?B?aWFBZVBwdks3YW9oMkRNZlFHV3RCZXE5YnBEL2ZkS3BjS3FTa3dZMllOU0RV?=
 =?utf-8?B?Q2FyaVU1WHREVkRXTllXUnNpTVVvUU9NRU9xOHdDa0lDRFppcXJRWUhrUC9k?=
 =?utf-8?B?cG1DY0ErQjJpR1VOMm1rQ1VzVU1ibzdQdEdMVG5wRWNTUU10cmVlYXY2UkFO?=
 =?utf-8?B?RGd0ckpnVExZMjZNNk1wTGE0eEFNNDczNENieUFUdVhROW5tRlp5dCtVWHBB?=
 =?utf-8?B?VlpBa25ONmV0M0crSkg2dmlNOFA0N3ZLKzdsY0dwL3VMdUZGVmtkTVcreWc3?=
 =?utf-8?B?bUZ3anNoWWVrVktXZm5rVjgzMnFjTHpmU21pYVJCU25tMzNxaHVWeHhpb2Fy?=
 =?utf-8?B?RjE5UUF2SGwwRStlZHJVb01pWk9KaXU4K1pEOFhYMnBDdlh3UkRJY1FOSFBz?=
 =?utf-8?B?WGVyZ1FNTTFmTWl1NE0zNDk2S0MyRk1jdHhSMzVFejFhdklxc3dkL0xybEZw?=
 =?utf-8?B?ZHJvcE91SGNDNkhSNTI1Q0lKd0NJRlNOL1hUdm92TUVnV1g0aUh4VHVadWMr?=
 =?utf-8?B?SzZhYzFPc3BpdUpadHFTbHhXQkR4MnhlUmpaaTZ3WGUxWU1TOG1MaE44ejR2?=
 =?utf-8?B?OXNuSngyNHExWDZXaHY2ZFpxLytFOVVDQ0ExTElOZk9jeDF6RURXd3hwVEZP?=
 =?utf-8?B?elFPZ1Y3VkpQRkJwK1E2NnRKUGRGYnNZWFZ0VVlyTE5yakVHMUZSNGlReDZO?=
 =?utf-8?B?dXRXeWVNSG5nQlYrWDNzbUFONWQwZzlKc1pyNEg5MXI2S0RQNlcrZGoza09M?=
 =?utf-8?B?WVRqdFI1Zk5Nbmg3bFlMbkR1Zzg3U2JlbU01QjFWOEZpL0x2N3N0OEk1UWFJ?=
 =?utf-8?B?ZkxYaWUyeUZ3UzlRMWUySUFkU3N4bUZzeDU4cWVVNllhL1ZCMXZSQTg2VDJ3?=
 =?utf-8?B?QnpJZWl4bVFnZUlMeXF6RGNud1c0aUYyemR0Z1NMcU15TlI3MzB3UzE0dUJN?=
 =?utf-8?B?ZE9GbmdqWGRRYXdaRjMvUU9DeWlveldVMTJ5TzFnNTdWWHBqWDZQU0t2UnhV?=
 =?utf-8?B?VWdKZTUzTDVyUUkwSjAvN0JUOCswemVFMTZ1bHZsSVp3ZlpDNWhVbHg2N1I2?=
 =?utf-8?B?OVVEV2NoODJqLzZzbldKcGFUWHNjTFJCV0l0aXp5YW5rMm1hMW1ZRDFENVFr?=
 =?utf-8?B?Y0srNitMeUJKWDQ3N1RMQ1pVSkVYenhtbmRVcW5kMmRZTTEzdml3LzQ1cXcz?=
 =?utf-8?B?aThBY0l6MC9CV3dLOFBYbGZJM0dsdUpheHJxTDV0alBac0t0U1FVbzlEQ21L?=
 =?utf-8?B?TE9tcXU2NEx4S2ZWR05BdVlRaWJab1RFUEFja2Vjd1Nkdkl1dFQvYnpmdzha?=
 =?utf-8?B?bUhYb0VjMjBKZTRlcGRRaXJFLzhrN1IzcWU0UDhNZFdVcG9sVlZDakxOSm5l?=
 =?utf-8?B?L0JVVkRqcmt5WlloL240TVlDL1Nkd3ZkOTJ4UnhBWXNiWC9tSUk5akFNYjJy?=
 =?utf-8?B?Z2VDQnF5WEJNVU9odTliRkhxKzR2dWZTQ00vUkIyM09XL2JFeEtTaDdqUjFo?=
 =?utf-8?B?QlhSaVFxUldiWm13MFlDR3lwZHRVcWhpcll4NzRucUk4bkYwV240WDlWckp0?=
 =?utf-8?B?SjYwWWp5Z1JyOEQwaGR0QndiendLMExGMWlNQ3NOeEZHSDNiRHNjVUxtZnEw?=
 =?utf-8?B?bVRLQkNzbng4Y0xPQWxBTDkxUjFhTVByMUh4eEliSXV6V1JQZGN1M2pVRDdB?=
 =?utf-8?B?MUIydDh3bEZ6b1YrL1pNNWlCZ2QzR2psMHg0Yy83SVA4YTZXQk5HcGs5MEJQ?=
 =?utf-8?B?dEllaHFUeWo2WmcyOHU2QT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A19E132E8DC76B4BB6556AD270FE03A4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3711.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c104d939-4b0b-4df0-0de7-08d90d07674d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2021 01:12:49.6792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cYx+G+8jHTwOkAugj7m7t5eYkkyEAMn8USm/OFio7BId/vSOySMaQGtZHdEK+O13KFeFZ7Y1UMf4BbyNAR4Teg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5302
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.20, xbe-rcd-005.cisco.com
X-Outbound-Node: alln-core-4.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIxLTA1LTAxIGF0IDA4OjMxIC0wNzAwLCBMdiBZdW5sb25nIHdyb3RlOg0KPiBJ
biBlbmljX2hhcmRfc3RhcnRfeG1pdCwgaXQgY2FsbHMgZW5pY19xdWV1ZV93cV9za2IoKS4gSW5z
aWRlDQo+IGVuaWNfcXVldWVfd3Ffc2tiLCBpZiBzb21lIGVycm9yIGhhcHBlbnMsIHRoZSBza2Ig
d2lsbCBiZSBmcmVlZA0KPiBieSBkZXZfa2ZyZWVfc2tiKHNrYikuIEJ1dCB0aGUgZnJlZWQgc2ti
IGlzIHN0aWxsIHVzZWQgaW4NCj4gc2tiX3R4X3RpbWVzdGFtcChza2IpLg0KPiANCj4gTXkgcGF0
Y2ggbWFrZXMgZW5pY19xdWV1ZV93cV9za2IoKSByZXR1cm4gZXJyb3IgYW5kIGdvdG8gc3Bpbl91
bmxvY2soKQ0KPiBpbmNhc2Ugb2YgZXJyb3IuIFRoZSBzb2x1dGlvbiBpcyBwcm92aWRlZCBieSBH
b3ZpbmQuDQo+IFNlZSBodHRwczovL2xrbWwub3JnL2xrbWwvMjAyMS80LzMwLzk2MS4NCj4gDQo+
IEZpeGVzOiBmYjc1MTZkNDI0NzhlICgiZW5pYzogYWRkIHN3IHRpbWVzdGFtcCBzdXBwb3J0IikN
Cj4gU2lnbmVkLW9mZi1ieTogTHYgWXVubG9uZyA8bHlsMjAxOUBtYWlsLnVzdGMuZWR1LmNuPg0K
PiAtLS0NCj4gwqBkcml2ZXJzL25ldC9ldGhlcm5ldC9jaXNjby9lbmljL2VuaWNfbWFpbi5jIHwg
OCArKysrKystLQ0KPiDCoDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDIgZGVsZXRp
b25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2lzY28vZW5p
Yy9lbmljX21haW4uYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Npc2NvL2VuaWMvZW5pY19t
YWluLmMNCj4gaW5kZXggZjA0ZWM1MzU0NGFlLi40MGFiYzNmZGViYTYgMTAwNjQ0DQo+IC0tLSBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2Npc2NvL2VuaWMvZW5pY19tYWluLmMNCj4gKysrIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvY2lzY28vZW5pYy9lbmljX21haW4uYw0KPiBAQCAtNzY4LDcgKzc2
OCw3IEBAIHN0YXRpYyBpbmxpbmUgaW50IGVuaWNfcXVldWVfd3Ffc2tiX2VuY2FwKHN0cnVjdCBl
bmljDQo+ICplbmljLCBzdHJ1Y3Qgdm5pY193cSAqd3EsDQo+IMKgwqDCoMKgwqDCoMKgwqByZXR1
cm4gZXJyOw0KPiDCoH0NCj4gwqANCj4gLXN0YXRpYyBpbmxpbmUgdm9pZCBlbmljX3F1ZXVlX3dx
X3NrYihzdHJ1Y3QgZW5pYyAqZW5pYywNCj4gK3N0YXRpYyBpbmxpbmUgaW50IGVuaWNfcXVldWVf
d3Ffc2tiKHN0cnVjdCBlbmljICplbmljLA0KPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IHZuaWNf
d3EgKndxLCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KPiDCoHsNCj4gwqDCoMKgwqDCoMKgwqDCoHVu
c2lnbmVkIGludCBtc3MgPSBza2Jfc2hpbmZvKHNrYiktPmdzb19zaXplOw0KPiBAQCAtODEzLDcg
KzgxMyw5IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBlbmljX3F1ZXVlX3dxX3NrYihzdHJ1Y3QgZW5p
YyAqZW5pYywNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9DQo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgd3EtPnRvX3VzZSA9IGJ1Zi0+bmV4dDsNCj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBkZXZfa2ZyZWVfc2tiKHNrYik7DQo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gZXJyOw0KDQpyZXR1cm4gZXJyIHNlZW1zIHVu
bmVjZXNzYXJ5IGhlcmUuDQoNCj4gwqDCoMKgwqDCoMKgwqDCoH0NCj4gK8KgwqDCoMKgwqDCoMKg
cmV0dXJuIGVycjsNCj4gwqB9DQo+IMKgDQo+IMKgLyogbmV0aWZfdHhfbG9jayBoZWxkLCBwcm9j
ZXNzIGNvbnRleHQgd2l0aCBCSHMgZGlzYWJsZWQsIG9yIEJIICovDQo+IEBAIC04NTcsNyArODU5
LDggQEAgc3RhdGljIG5ldGRldl90eF90IGVuaWNfaGFyZF9zdGFydF94bWl0KHN0cnVjdCBza19i
dWZmDQo+ICpza2IsDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIE5F
VERFVl9UWF9CVVNZOw0KPiDCoMKgwqDCoMKgwqDCoMKgfQ0KPiDCoA0KPiAtwqDCoMKgwqDCoMKg
wqBlbmljX3F1ZXVlX3dxX3NrYihlbmljLCB3cSwgc2tiKTsNCj4gK8KgwqDCoMKgwqDCoMKgaWYg
KGVuaWNfcXVldWVfd3Ffc2tiKGVuaWMsIHdxLCBza2IpIDwgMCkNCg0KMCBpcyBzdWNjZXNzLCBh
bnkgb3RoZXIgdmFsdWUgaXMgZXJyb3IuIGlmIChlbmljX3F1ZXVlX3dxX3NrYihlbmljLCB3cSwg
c2tiKSkuDQoNCk90aGVyd2lzZSBwYXRjaCBsb29rcyBnb29kLg0KDQpUaGFua3MNCkdvdmluZA0K
