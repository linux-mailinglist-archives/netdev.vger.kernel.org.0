Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D7D3711F8
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 09:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbhECH3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 03:29:47 -0400
Received: from alln-iport-7.cisco.com ([173.37.142.94]:61640 "EHLO
        alln-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbhECH3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 03:29:45 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 May 2021 03:29:45 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=880; q=dns/txt; s=iport;
  t=1620026933; x=1621236533;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=uXPzcdIMzhVq6AUShicKbtXFVeYEzQUEoYI9UthrhQw=;
  b=JVqgVAyt5eO6oIDuJtg0ISz7ojuCvl3+30TTszIP1R6jC7QO5WL3BIl9
   uFR2DMdgq7oPgjao5qugzq16UQNqUsCqOdl0DxbCt3uvxrlMGTzZOBNIM
   0NHpo5HhxexeHvWn5/a79Xy97IRs2RmAmtXjPTYpAU+Mlf7TE8AzzYbkK
   U=;
X-IPAS-Result: =?us-ascii?q?A0BEAgBQo49gmJpdJa1aDhABAQsSDECBTAuBU1F+WjYYG?=
 =?us-ascii?q?YREg0gDhTmIcpVEhA2BLoElA1QLAQEBDQEBJA4CBAEBhFACF4FkAiU0CQ4CB?=
 =?us-ascii?q?AEBAQMCAwEBAQEBBQEBAQIBBgQUAQEBAQEBAQFohVANhkUBBSMRDAEBNwEPA?=
 =?us-ascii?q?gEIGAICJgICAjAVEAIEAQ0FG4JWAYJVAy8BDp0OAoofeoEygQGCBAEBBgQEg?=
 =?us-ascii?q?TQBhAgYghMDBoEQKoJ5hA6GWSccgUlChAgvPoQgAQEgF4MAgmGDRicYWJY/p?=
 =?us-ascii?q?m4KgxCJeZM1J4NCoWAtk3SBDot/l2ECAgICBAUCDgEBBoFUOIFbcBWDJB8xF?=
 =?us-ascii?q?wIOjh8Zg1eFFIUECAE8czgCBgoBAQMJfIwTAQE?=
IronPort-PHdr: A9a23:c3tJAxdyjY2RqUo6d0kPneunlGM/QYqcDmYuwpM6l7JDdLii9J3+P
 UvZoO9gl0LNQZ6zw/lFkOHR9avnXD9I7ZWAtSUEd5pBH18AhN4NlgMtSMiCFQXgLfHsYiB7e
 aYKVFJs83yhd0QAHsH4ag7Zo2a56ngZHRCsfQZwL/7+T4jVicn/3uuu+prVNgNPgjf1Yb57I
 Bis6wvLscxDiop5IaF3wRzM8RN1
IronPort-HdrOrdr: A9a23:ROW71KARSu3GVizlHei9tceALOonbusQ8zAX/mhLY1h8btGYm8
 eynP4SyB/zj3IrVGs9nM2bUZPgfVr1zrQwxYUKJ7+tUE3duGWuJJx/9oeK+VPdMgXE3Kpm2a
 9kGpIQNPTZB1J3lNu/xQG+HcopztXvytHWuc715R5WPGZXQotn6Bp0DRveMmAefngHObMSEp
 2A6s1b4x+pfnoKZsq2b0N1IdTrjdvNiZ7gfFo6HBYh8gaDlneF77T9Hhie0H4lInBy6J0l9n
 XIlBG827W7v5iAu17h/kLwz7ATotvuzdNfGNeB4/J0FhzAghulDb4RIIGqkysypIiUmTMXuf
 nK5ywtJsFir07WF1vF3SfF/ynF/HIQ52T5yVme6EGT4/DRYD4hEcJOicZ4X3LimjAdlepx2q
 5KwG6V3qA/ZXir8UiNhKmrazhQmkW5unYkm+II5kYvLLc2UqNbroAU4SpuYfE9NR/684wuHa
 1PC8zR9Z9tACunRk3ZpWVmzZiQWG0yFH69MzE/k/GSugIm+ExR/g89/ogyj30A/JUyR91v/O
 LfKJllk7lIU4s/cb99LP1pe7rzNkX9BTb3dE6CK1XuE68Kf1jXrYTs3bkz7Oa2PLQV0ZoJno
 jbWl8wjx93R2veTem1mLFb+BHER2uwGR73zNtF2pR/srrgAJ3mLDOEU1Jrt8e7uf0QDon6Vp
 +ISdVrKs6mCVGrNZdC3gX4VZUXA2IZStcpttEyXE/LrdnMLoHsq+zHYPfeLLfgCl8fKzrCK0
 pGeAK2CNRL70itVHO9qgPWQWnRdkv2+o81EKWyxZlK9KE9cql39iQFg1Ww4c+GbRdYtLYtQU
 d4KLT71qeypWy8+3fU/3xkUyAtVXp90fHFaTdntAUKO0T7ffIooNOEY11f23OBO1t4VMPZEA
 lWolxt4qKpJ5mMxSQvYujXdF6yvj82njanXp0ckqqM6YPOYZUjFKsrX6R3CEHWDRBvgB1rr2
 1CcQcAQUfaGlrV+P+Ypa1RINuaW8h3gQ+tL8IRlGnWsl+Eo9ozAlEBWSS1bMKRiQEyZjZdi1
 Fr6ZUDiL6YlTvHExpjvM0IdHl3LEWeGvZvERmMboQ8oMGbRChACUOxwQG8pz52UGzw7EkWjn
 HmNkSvCIH2K2sYnGtZ3Kbs+E5zbUOHcStLGyxHmLw4M3jasXBu1uLOQay/3wKqGwU/69BYFi
 3Zaj0PJQ4r/fSL7Vq+nTaPEmhO/ORwAsXUEKkjf7bP2nmkNY2PkuUcE+VJ+Yt+XeqewNMjTf
 iSYEucIj/+FooSqn+oj2dgNy9upHY+l/T0nBXj8WijxXY6ReHfOVJ8WtggUp6hxnmhQ/aDy5
 Nii90p+eO2L2Xqc9aDoJunIgJrO1fWoWSsSfsvpo0RtaUutKFrF52eVTfTznlI0FE/K8jz/X
 luDJhT8fTEOoV1edYVdD8c9l01lM6XJE9uqxfoGIYFDBkQpm6eO8nM76vDqLIpDEHErAzsOU
 OH+ykY+/veRSOM2bMTFqpYGxUZVGEsrHB5uO+SfYzZDwunM/tO+1e3KXexer5QQqrtI8Rbkj
 9qp9WT2+OHfSvx3w7d+SZhKqVV6mC9XIe8BhmPFeMgya3yBX2cxq+xpMi9gzf8RWHlNwAWhY
 hZeVcRacoGgD84l4Ez2jWzTKuyok9NqSoo3Rh30lr2no6h6yPHGEsDNwvTiJBfRyNSPXiFlt
 6ty5nS6F3tpDxenYDeH0JRdMxUE9ceToLrPz5jQPJgyIKA7u4qmGBfex8gAG43lSDl0+5n1b
 m/3u/OW+eKMwafBXsRvThfBoB1mSQ3qWZPN8imhKjNFzkqKg==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.82,268,1613433600"; 
   d="scan'208";a="688522430"
Received: from rcdn-core-3.cisco.com ([173.37.93.154])
  by alln-iport-7.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 03 May 2021 07:21:45 +0000
Received: from mail.cisco.com (xbe-aln-007.cisco.com [173.36.7.22])
        by rcdn-core-3.cisco.com (8.15.2/8.15.2) with ESMTPS id 1437LjH3015386
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 3 May 2021 07:21:45 GMT
Received: from xfe-aln-003.cisco.com (173.37.135.123) by xbe-aln-007.cisco.com
 (173.36.7.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3; Mon, 3 May 2021
 02:21:44 -0500
Received: from xhs-rtp-003.cisco.com (64.101.210.230) by xfe-aln-003.cisco.com
 (173.37.135.123) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3; Mon, 3 May 2021
 02:21:44 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-003.cisco.com (64.101.210.230) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 3 May 2021 03:21:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dGNBsDJGG3UcgG5QzzwhOV0s5r1D3+nDHfaX7DzZhADXYeGUph+1b4MvHOE9xzXtQ+ZsnHwppKC5cLd0q1MpmhImp79wSefeY+wtJcNTRxPu16APJ0+YAEZBD3klQPlHCthVfBOFDTYCFbI469NPAGzsH+Rfm9Ep5gGKQFIkm5/Sq/BOki5sRFHoZjH1n2lnTby4fU5w74LPESpXNBVD4LYN/9Er62ioynBNVH/FzwH2zc/yUHfViVTloBU5mVVQy4XZ9K0Zkk/0V3/562jswjz1Wbw7D75orE6PE1Z9C/Wd2Uu066XeBNeSjqqlBegtZAuYn0EZ/hCK/wfkIazMMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXPzcdIMzhVq6AUShicKbtXFVeYEzQUEoYI9UthrhQw=;
 b=FTxSJ4CbkNImT0hujuYyyOX+/bkGUiYZpZp9FQ1peznq70D1PiSrDnLCJQk+Bhcz9N1Po8sWipJv1DvG+Re9C7larY94u9axBDjx2e4uEKt/pFs046+IYbA7XAiIIZOIIVJCFCVbUUQkDw0E/aXdqHnv/eEre5mxRr6yqGGLXKvHkpMFkWzZGOsbHn/Iaq4HjXsE3+d47G7yYq6cY7XhI3o77lpEgEfexvpKPUOI0DX3nq/kDNPIeAFwjLkRHDqOoSLHX6tdHwoWHY3RKMP8O6DX49ItDrZzEDREQb7EhXTJDGf4rVoZY4f9FReQS5VwfDyUUqJCrn41M8w8QnncKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXPzcdIMzhVq6AUShicKbtXFVeYEzQUEoYI9UthrhQw=;
 b=NR9Fe1aW0wwmzxh6sS2htrwW1OkPBF9PuVJ37IoZl+4tsAoBCc1pPAsGNQU7V5JvfT2a6HXviyhI39cZIx3lZnbhsQmG8H5HY12NZkTdfOW0a+rsYsExLKzySD2x/DF2fcxfMfKobOqfUbreEREERpZGGj4tU3gzQZYe7WfxM/s=
Received: from MN2PR11MB3711.namprd11.prod.outlook.com (2603:10b6:208:fa::26)
 by MN2PR11MB3838.namprd11.prod.outlook.com (2603:10b6:208:f3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.38; Mon, 3 May
 2021 07:21:42 +0000
Received: from MN2PR11MB3711.namprd11.prod.outlook.com
 ([fe80::ec1c:f2b:bc14:e5b0]) by MN2PR11MB3711.namprd11.prod.outlook.com
 ([fe80::ec1c:f2b:bc14:e5b0%6]) with mapi id 15.20.4087.044; Mon, 3 May 2021
 07:21:42 +0000
From:   "Govindarajulu Varadarajan (gvaradar)" <gvaradar@cisco.com>
To:     "Christian Benvenuti (benve)" <benve@cisco.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "lyl2019@mail.ustc.edu.cn" <lyl2019@mail.ustc.edu.cn>,
        "Govindarajulu Varadarajan (gvaradar)" <gvaradar@cisco.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ethernet:enic: Fix a use after free bug in
 enic_hard_start_xmit
Thread-Topic: [PATCH v2] ethernet:enic: Fix a use after free bug in
 enic_hard_start_xmit
Thread-Index: AQHXP+z3DNzrGvQsbkSstRXhV9TZIA==
Date:   Mon, 3 May 2021 07:21:42 +0000
Message-ID: <a7063675191930af6b5be0566244534de558869a.camel@cisco.com>
References: <20210502115818.3523-1-lyl2019@mail.ustc.edu.cn>
In-Reply-To: <20210502115818.3523-1-lyl2019@mail.ustc.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.0 (3.40.0-1.fc34) 
authentication-results: cisco.com; dkim=none (message not signed)
 header.d=none;cisco.com; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [2001:420:c0c8:1001::1b6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f627aadd-b773-496d-3657-08d90e0419db
x-ms-traffictypediagnostic: MN2PR11MB3838:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB38388C9C3EC53D13123893BBD45B9@MN2PR11MB3838.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: onwGN08ek0qztSIHWvTsc0y6DviGVlHKAWBscD8N0Tr4DjS+Llj1Saf/u8q4Gv+mNnCqr1fHK82KD3S+2tp3BtN0xkeIPTOj8K5Zj1+iJutuUGkE7Lzt5zor0zsooE99r/W1Nk0CN21S41g3xRoLAHNhlnqieqaI8zmJLPnI1rd74zaai0ZHT4hyjgLTxNf9/dTL7NqRjCIsoqB0rvVa//FinBiT6tXvsGa644Nk6K1gcPIlH7JIPvRsCCZizNBvW6ksjOf9MB8ER0PAPkCaNEtxVdjKkYRfo5WPixynOhEufPVEChm282LiYG+ZJ05uHhqOZ17KHu1XVOO4kNGac4W8tIFo7iabm3KfuyTguIqScCfno+93hqx1ZSxsJkvG4wq7IVrNlsF1jfdYLdlcmWyRPb5o0uiPvLeP1Ea9bXSLzp861j+0cGySy5RLgQ29XNYlUbYPiEkW4RZziPiTR/Aswz88xTUb3lQzVnO83kIb/+sUdxG5jpAKCMEF4sjv6JuOW9q+5ojIjBCcjuQ7HX4lD68QLbyAtetTiN3dRNONKXQLOgKUAXzciFbRoy/dzSOg27Pt4lqv9i0f63isYPjOUf7lKasIy0k+4Eek1kvOZIL5aNdZrV0kV5OmJa/jPYn8SSluheGVYUCuosrZVWVKtTaPFhd0IhToJqQkBuc1Ez4g9coBFrT0yPnHf47Z
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3711.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(396003)(39860400002)(366004)(66946007)(91956017)(76116006)(38100700002)(6506007)(122000001)(66446008)(4744005)(66476007)(66556008)(64756008)(71200400001)(83380400001)(5660300002)(36756003)(4326008)(316002)(478600001)(8936002)(186003)(2906002)(8676002)(54906003)(2616005)(110136005)(966005)(6486002)(6512007)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZitFZXdMeUNWNFYzakRQaG9sOFZwdExUVlBxK3hITlF0V3VvSVFrN3l5WGdm?=
 =?utf-8?B?ZldGTnp0QXY4TEZ4YThFQzdISGcveUxjRWtRV1JKTHNJT2VHK004SFp5TmhW?=
 =?utf-8?B?QkVNakNCYm9Lekt1a3M4dUdWbG1RcVE0RlZZVU01L1JBOW1aTEFkS3lLQzdL?=
 =?utf-8?B?b0k4cmpVQXJEaU00NUhrNDNaNFZQS3FIeWEyRnV5dVdCanRCcHcrVXV3c1Bh?=
 =?utf-8?B?bHdteWJLcVpjNmFDUkZ2MUxXNTg3aDkzL1RIU3BvclJ4aG9FUENnNnpuZm11?=
 =?utf-8?B?WGpJYTRuRG5ZTjdHaE5OMk54SWY1M3RDS2RURGRUbHBUUDE4QjhuQkw5YXRT?=
 =?utf-8?B?Ym9WR2tpOGFkMSt0QVdrVDlYclVjejJ3UWNDUGVaTzhwUjNucGVpSzJWbGpl?=
 =?utf-8?B?NUlON1dUTTFkcjR5WnBQMUlXbHJLZzlUYmpHR3oycklLTHhnSklaL2RlS0Qy?=
 =?utf-8?B?K3BSOEJTb3lWeDdnU2l3UmdwcjBqdUJPelY5KzRHWm1kWDNpMkZkMXVNMFVP?=
 =?utf-8?B?TTBYQnpXV0w2dEsyckJWanI0K1o2VXlXdkJScmVmQldJNjhUdGRNNXJOQUZ1?=
 =?utf-8?B?UzNkREZrUUg1QVZHUGNmOWJEWStnRnpkNGtrb0V4V2hub2pqN3UyclhVL01k?=
 =?utf-8?B?K3NjTUxydTRVV1F0U2J0M0VOZ21vTjhKYXNxMUFVVmVBb3Vsa1p5UzN6R1Ru?=
 =?utf-8?B?bTFhclNQcDdUYkpsRUdlR2wxdDdXYjVKcHdkSGgxN2xLTWNrTC9aTWY4dEtY?=
 =?utf-8?B?K3ROZWxaZ1lHL01TNGtBOVV5SC9aZTRDZ0FXYWt6NldlcDhBU3NFYVFXTyt2?=
 =?utf-8?B?VmJZL1NIQmZ1b29nYzBOeS8wS3IvRndFLzM0czloOU4xUDc3MUM4UUk5UHoz?=
 =?utf-8?B?TkhhK3lhMENBOXdiTytDbFFzWVdTOEU2aXRJTGRMcjd4YVQvU2pLeGRpQ1Zj?=
 =?utf-8?B?Qmk4Tk96UVFkeUFaR2Jyd3lkL01rRTBoZklSczJzdmhaRFR4bUxHTnR5Vm9F?=
 =?utf-8?B?Z1djNkcwZW5JRmJLZ1gzVmVOL29YQ1JzcjVZTmhQVnJNZVgwa3h1SEI1aml2?=
 =?utf-8?B?aWo3NjJQYkUzL05rUlJjSTFwWEUyK3Jva2NDdDdteTIvYXZHUU5ZWW5DUnZM?=
 =?utf-8?B?RnY2SnUwS09XTmlyRk1YZUx1bU1KYTZNTnEvOXVZWEZ5U1VjcVBYQ0szQkhw?=
 =?utf-8?B?bmZlRXA5Z3pCemhnUzl4YlppOUVHQlgzZUlwWWVHc3lhT2xJaGRkSTFuMHFX?=
 =?utf-8?B?UG5hSTNqUk00SGlFUERoNWhKY3lqd2krQ2NrZUFEQWxIMHlQb09MYlE4c04x?=
 =?utf-8?B?VWUwODVyOUdVd3Z3QVlvaVRheUFnSHlXVEowektOT1ZpM0pJNTNFdFVCNGNK?=
 =?utf-8?B?N3pYWEJBQys1dlRkQVV0UU9mRzJ1Y2YxR2MzVFJxSGZmeUJVa1hRemNJVWNN?=
 =?utf-8?B?OFFtN0pYTVFNcFRwZm1zQnJFL1JWT3luTVF4UWxzeXlySjZRZk5yNjZoMTZu?=
 =?utf-8?B?Vi9ZMjZzWVFaQnRvT3FJRGhkZmwyM2NjK1hIeGJ3SWRvVlJ0QWVMeUtrQUla?=
 =?utf-8?B?UzhiaDN5Vm8yRkU1ZmI0Yk5IUGJJNDZ1MHo5eHRCeldoR3ZSVDR6T1h2L3Ja?=
 =?utf-8?B?azNndWg2OHBKdjJ0ZkhJaDhXYmJjeVptMmhsblIvWWVpZTllcldENG44Q3A4?=
 =?utf-8?B?MUxsT1NZZTl1VTRPS2EzckdEWUMyR09ueW42UkZwYmw1SUMyNjRhcldiRk5w?=
 =?utf-8?B?cW9DNGx3bGhUOEFPK0UvTVJSazI2NW1wSHhmQXlPVGpLZzFYa1lqTUV1RWZw?=
 =?utf-8?Q?0Oj2WeyacKsWIhhax9UIWuEMX+51SndIWsie8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A3A482FDD348B499D515606654CA003@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3711.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f627aadd-b773-496d-3657-08d90e0419db
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2021 07:21:42.3941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QR3slYUpy6eLz2erN0ispOZSfLjmnX9IwweF1sFzgy7JAK06DGrnA7LSr+CG8SFRRyAH2bpY4kewjFWi4haf/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3838
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.22, xbe-aln-007.cisco.com
X-Outbound-Node: rcdn-core-3.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIxLTA1LTAyIGF0IDA0OjU4IC0wNzAwLCBMdiBZdW5sb25nIHdyb3RlOg0KPiBJ
biBlbmljX2hhcmRfc3RhcnRfeG1pdCwgaXQgY2FsbHMgZW5pY19xdWV1ZV93cV9za2IoKS4gSW5z
aWRlDQo+IGVuaWNfcXVldWVfd3Ffc2tiLCBpZiBzb21lIGVycm9yIGhhcHBlbnMsIHRoZSBza2Ig
d2lsbCBiZSBmcmVlZA0KPiBieSBkZXZfa2ZyZWVfc2tiKHNrYikuIEJ1dCB0aGUgZnJlZWQgc2ti
IGlzIHN0aWxsIHVzZWQgaW4NCj4gc2tiX3R4X3RpbWVzdGFtcChza2IpLg0KPiANCj4gTXkgcGF0
Y2ggbWFrZXMgZW5pY19xdWV1ZV93cV9za2IoKSByZXR1cm4gZXJyb3IgYW5kIGdvdG8gc3Bpbl91
bmxvY2soKQ0KPiBpbmNhc2Ugb2YgZXJyb3IuIFRoZSBzb2x1dGlvbiBpcyBwcm92aWRlZCBieSBH
b3ZpbmQuDQo+IFNlZSBodHRwczovL2xrbWwub3JnL2xrbWwvMjAyMS80LzMwLzk2MS4NCj4gDQo+
IEZpeGVzOiBmYjc1MTZkNDI0NzhlICgiZW5pYzogYWRkIHN3IHRpbWVzdGFtcCBzdXBwb3J0IikN
Cj4gU2lnbmVkLW9mZi1ieTogTHYgWXVubG9uZyA8bHlsMjAxOUBtYWlsLnVzdGMuZWR1LmNuPg0K
DQpUaGFua3MsDQoNCkFja2VkLWJ5OiBHb3ZpbmRhcmFqdWx1IFZhcmFkYXJhamFuIDxndmFyYWRh
ckBjaXNjby5jb20+DQo=
