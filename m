Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C47B2B9D9D
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgKSWY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:24:57 -0500
Received: from outbound-ip24a.ess.barracuda.com ([209.222.82.206]:58976 "EHLO
        outbound-ip24a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726362AbgKSWY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 17:24:57 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107]) by mx6.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 19 Nov 2020 22:24:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M+9a9ylBUX+5Nyl4CPRYrOJ1yV7Q5dWwM5O6wA4CO41k713hm3GAZ7njtXB4/kAU2Jq2SGQX8YsyzQ5AASiPJ/gDLmZuP11Mo2XUBDQa1he//2Lox06vqQddG5q+clOTJs5i2agUXPIQ4VZDkg3F0GqvcVlFmEXA03KWoNscKF/cHEkz2XDd8gCGhepjKuG/chzs1o6cu0asI38cnaKI6SXyopizgCTRb4Rp7mz6VdIsCoMWTcAoicgNvqAXylUU8Bp0VtXqQ4qo7EJqr8dTEa0/uIagrNWwqrbl2Ii0BTffEnGnPzK7M0nJoel77So4kUgeuAy0WB7aMWu3jC7ibQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ed7vKZHmPC7XSymwJNjTbkW2YFJ1erRr6XzJw0LALqQ=;
 b=TaWif1wubck3ApLY+oX91T+bTqmYPsu2pvA+XhJ9Scxz+tIngxERa9ZFCMC3WkbD/qYruuSaB+jnpYVcEDFqgr/HdboSPa0tAgc1Ntyepc2buj+3CvD1OrM2UlsVLEIOdHdYUJENnXX0ZLWQnGUj/duX8EYwTyBOaMx0lAhQLc3KmNV+HDvw2y+Bb3fTcQ2a1hk8f0yXrPT2ydx0V/KwpsNdkosWmKfzwQN9dQ3YZhGqcChOurLKRL36jk1Co4svQRq3G1jeovWkZZbryrE2rQeEvrpuBuJYI249Xgraw8KzKJARfhKYYUZBpmOH6HHk1y2HZ680iB9VXDmCj/G/eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ed7vKZHmPC7XSymwJNjTbkW2YFJ1erRr6XzJw0LALqQ=;
 b=dE0peaoV8lTWspWe/OhFIMlQbhQ9bXYxv2uMJUP5jXnFX7BOxPrfVaDbFkUUJBO0A7y0CQf/Ue2aM8W4OtXQXTZ6flXrouOYheJxqd3i20EMm15h4AcRVgFj0Qn5MWXMuYPOC85As4/tKLH3/8A8wpaHoMwUtQIsfdSRlNmRI3M=
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 (2603:10b6:910:44::24) by CY4PR10MB1639.namprd10.prod.outlook.com
 (2603:10b6:910:b::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Thu, 19 Nov
 2020 22:24:43 +0000
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197]) by CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197%6]) with mapi id 15.20.3564.033; Thu, 19 Nov 2020
 22:24:43 +0000
From:   "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>
To:     Florian Westphal <fw@strlen.de>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: [PATCH v2] aquantia: Remove the build_skb path
Thread-Topic: [PATCH v2] aquantia: Remove the build_skb path
Thread-Index: AQHWvsBOsAmPkY/rTESqMk0pvOgIGanQBWIAgAABcTQ=
Date:   Thu, 19 Nov 2020 22:24:43 +0000
Message-ID: <CY4PR1001MB23113312D5E0633823F6F75EE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
References: <CY4PR1001MB23118EE23F7F5196817B8B2EE8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <2b392026-c077-2871-3492-eb5ddd582422@marvell.com>
 <CY4PR1001MB2311C0DA2840AFC20AE6AEB5E8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB231125B16A35324A79270373E8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311E1B5D8E2700C92E7BE2DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311F01C543420E5F89C0F4DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>,<20201119221510.GI15137@breakpoint.cc>
In-Reply-To: <20201119221510.GI15137@breakpoint.cc>
Accept-Language: en-AU, en-US
Content-Language: en-AU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: strlen.de; dkim=none (message not signed)
 header.d=none;strlen.de; dmarc=none action=none header.from=digi.com;
x-originating-ip: [158.140.192.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d2db742-24bc-4598-360a-08d88cd9ea2d
x-ms-traffictypediagnostic: CY4PR10MB1639:
x-microsoft-antispam-prvs: <CY4PR10MB1639546CC3212B6624E485D8E8E00@CY4PR10MB1639.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nnBRBPnRhp2AmxFV3XG3/rUVUqaLtFKAambxiLVURebBWGK1DXPPRsJYI7uEYBsUjGX9RungcwN4O7eYCe+Xh4028LIvxMXl1LTzv5asTu2r79dbscfMHPILPXC/MpiGnq2J6eiS2JZy1OnBxhY8cci2FAQKsbKyqfh+WtSHTVcwuC9FwbCZY5PnFrGK8/+ZywgQhZfhmJZD9+o8ZwF97ZanVO4xd9hJTUaxPZfMRcLv/3gmS8Zi8QWhLFnxEsYbo6Tn2S6dnkyJo3bqmRHj1Nj+zME9etf5nO/zauuzR2x/jzmJf0//NuKFOl8NZ5dSZ4T7ebm4tkGXeTP+gJ5rPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2311.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(39850400004)(136003)(346002)(33656002)(86362001)(4744005)(186003)(7696005)(52536014)(5660300002)(54906003)(76116006)(91956017)(55016002)(6916009)(316002)(26005)(4326008)(66446008)(9686003)(66556008)(64756008)(2906002)(66476007)(8676002)(66946007)(8936002)(478600001)(71200400001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: NUJPYqxcbXJhdGQ4YAzFRdSfAOBz4N/4KTgoMSi/QSPbRGdWC59bkuxKt2NqZZ6clOtPKHL00JCXzMIy0KDc5BuEnfr2AueYqjHNxiL1z+b5CMUGiHVh7a58RuYoBw+tqzG1VZpez9JS+rssv0BSr039iuHSvHHqy8gTsDWKVeK1OfF1u++0oua/cutOnnARx9giUy53Hp1+XCLubBY5RYVkPQ0nfPv7KXefZujQmL/yjrvN34SyQLUkXdfHPmrlb4dtjP3AlDiVlYwBt1vcZr73VeZQSV2hkcPB8g5Wt2fyvspuWIIhCnH4C/wy2Ju/R/FJ9a/NZgCLsVfXVkf9cMmjVKmz8M600fbvijD9Bk3K5hZfNaK9EAASuepGWudeF0nIMlpRK6nM559m+TzPAP9zXctHEqkyoqhdGGCwYNVBFZY++9ecEvopQI4VttXLW6b3BN2deYgEzrwfcsUyJNSJm4HZJLGvsF6J7G6fUfGdRIudlRurIqkB6qzyA/g1PgJiFwp9Fg2QeCs44oeWtpeYsJgKWYPnkidaPXiTekkda1bxTct0OQOUg9roC5sWxQrEs6vjUAQ3262OEcGNo3DE89rv7afyxk57exkI0DhihF7IulOKfQu+Kgl2L6yk+6QwT+wRkueemzcWJpv97Od/+dQnXoC285w51/u2BjTlKyfvKMuek+xVtquLYhEhC68+M70NtN+qsG1IHBF2bBaH/3RDC79R4ONQH1g/1aAB/AezSp01nN9ZJNrt8fTyrTQ1ilNhTnhC8ERBS+Yu9UTntWmLVmxXt1gKIzk3A/xYSw5kKJF7kHVwXcMhObDU4gDIfTIjr4xANS/cpg5plarw2QvwlggJHm6OowVWWnOZDXXA+d3jHzccnmPdn5Vhpp1hxlxy+jNM8OPxyGtM7w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2311.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d2db742-24bc-4598-360a-08d88cd9ea2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2020 22:24:43.6039
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pYxErXVtjoGH/3XEGkz63gyC7HS1XoDpf7X78AE18oaU2yVv2z742bGOzJCiibCIOdovf8c1zHkz/sQM5UR6xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1639
X-BESS-ID: 1605824684-893010-4401-16060-1
X-BESS-VER: 2019.1_20201119.1803
X-BESS-Apparent-Source-IP: 104.47.55.107
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228306 [from 
        cloudscan10-74.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Ramsay, Lincoln <Lincoln.Ramsay@digi.com> wrote:=0A=
> > The build_skb path fails to allow for an SKB header, but the hardware=
=0A=
> > buffer it is built around won't allow for this anyway.=0A=
> =0A=
> What problem is being resolved here?=0A=
=0A=
Sorry... Do I need to re-post the context? (I thought the reply headers wou=
ld have kept this with the original patch that included the justification, =
plus the discussion that led to this revised patch).=0A=
=0A=
Lincoln=0A=
