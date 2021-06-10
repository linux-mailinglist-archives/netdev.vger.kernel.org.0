Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2213A3314
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFJSaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:30:17 -0400
Received: from mail-eopbgr30050.outbound.protection.outlook.com ([40.107.3.50]:56743
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229823AbhFJSaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 14:30:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JNOhU1XV/vLIuqlPCMq2/I/XR2v1U2bfYkA/hvQ8bK0=;
 b=xMluItLaiRVBioxoorXmJteixRHha5SYrUNd3XOKH80yuK/5NdhUBFgK/Kim+jkywAGEh+bZyliRk8wBK61Cy2s1XkORmJfn3mTKRnhOnWCSgMOvrcS6z5v4zHdX8EZD6Te79lfFCJuDzS95PmUxzUxvItx7klLzyh8Heaj9Jxk=
Received: from DB8P191CA0028.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:130::38)
 by AM7PR08MB5318.eurprd08.prod.outlook.com (2603:10a6:20b:104::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Thu, 10 Jun
 2021 18:28:17 +0000
Received: from DB5EUR03FT026.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:130:cafe::42) by DB8P191CA0028.outlook.office365.com
 (2603:10a6:10:130::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Thu, 10 Jun 2021 18:28:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT026.mail.protection.outlook.com (10.152.20.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 18:28:17 +0000
Received: ("Tessian outbound 836922dda4f1:v93"); Thu, 10 Jun 2021 18:28:17 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 8e6fc0ebc598bb74
X-CR-MTA-TID: 64aa7808
Received: from 1fc4a790ac1b.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id C75C2657-F969-4834-B1F7-D53AF1D3467C.1;
        Thu, 10 Jun 2021 18:28:15 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 1fc4a790ac1b.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 10 Jun 2021 18:28:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cAdHXYiavyBeqVEx6GHYuivYT+YhysRdWYFonn8pc41aCe8GEmT1AUHQPUAjdKEF3s1lNYxPX7xNoJ/sIJ+37NkOQLD4TPJHfeSG5j8LzuH3RHsppsl4YIEEd00c52Snn9lbXAmIf6ulE/bU2m10fDH1wYS6lL/CWCXq2EnP80QRPsz9ZZ7jubcmf7G5PQL13FGXVWrF08IyqLupi5KzI7WknEF7zBhnUhXXvVuX4WLcOKYS8Yycpa/3C4Pqp4vxpYp7E11VEdInkGXRaD5Yv6IJbcX5QJixrj6wXIJkQEcgd42FbcENxqjd7v1K+mef0tcu22ObLLuUFftvI0O9iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JNOhU1XV/vLIuqlPCMq2/I/XR2v1U2bfYkA/hvQ8bK0=;
 b=Z3FxU4DbkOVYMN0X/3HitzIJToYbiQx8DCBIQYTb5e8qvsdVcng3zoG4ALkWeCoQj13CGN7fKuZhUP5Zpn79oPTO7fgVxZ8Nr/p8x22IKYqUNe8UIkCKOnmrNbZOSNVjTUmj0gJp2yfV6Y5e8y5QwM7j8VD9BktnPXdZEQwWJHL4V5b/l1J4BcW+EktSo51xalj8OhtqB+LYUY4HF70NZNMafqnC+zEfRMeniVyog7IUsr7+xbsXG0IyZ72D5qdRRaYr7qIMsxnxhOh0B39h/lO9jfmR8jVdPKtwgeTU5vUc0m770jUgwh2/W+XGDQ+l8wGRnrck87ZWwSkiGArXdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JNOhU1XV/vLIuqlPCMq2/I/XR2v1U2bfYkA/hvQ8bK0=;
 b=xMluItLaiRVBioxoorXmJteixRHha5SYrUNd3XOKH80yuK/5NdhUBFgK/Kim+jkywAGEh+bZyliRk8wBK61Cy2s1XkORmJfn3mTKRnhOnWCSgMOvrcS6z5v4zHdX8EZD6Te79lfFCJuDzS95PmUxzUxvItx7klLzyh8Heaj9Jxk=
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
Received: from DB9PR08MB6809.eurprd08.prod.outlook.com (2603:10a6:10:2ae::5)
 by DB6PR0801MB1944.eurprd08.prod.outlook.com (2603:10a6:4:73::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Thu, 10 Jun
 2021 18:27:57 +0000
Received: from DB9PR08MB6809.eurprd08.prod.outlook.com
 ([fe80::e56f:3aec:7693:e53b]) by DB9PR08MB6809.eurprd08.prod.outlook.com
 ([fe80::e56f:3aec:7693:e53b%3]) with mapi id 15.20.4219.021; Thu, 10 Jun 2021
 18:27:57 +0000
Subject: Re: [PATCH net-next v8 00/15] ACPI support for dpaa2 driver
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Jon Nettleton <jon@solid-run.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ciorneiioana@gmail.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Calvin Johnson <calvin.johnson@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "nd@arm.com" <nd@arm.com>
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
 <YMJEMXEDAE/m9MhA@lunn.ch>
 <CABdtJHv-Xu5bC2-T7a0UgbYpkNP1SLfWwdLWLLKj5MBvA2Ajyw@mail.gmail.com>
 <CAJZ5v0iNTaFQuZZid77qTpfbs-4YdDgZdcC+rt4+mXV9f=OpTA@mail.gmail.com>
From:   Grant Likely <grant.likely@arm.com>
Message-ID: <bfadddd0-2a4b-abf7-bb6e-659640d49128@arm.com>
Date:   Thu, 10 Jun 2021 19:27:53 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <CAJZ5v0iNTaFQuZZid77qTpfbs-4YdDgZdcC+rt4+mXV9f=OpTA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [84.69.27.191]
X-ClientProxiedBy: LO2P265CA0267.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::15) To DB9PR08MB6809.eurprd08.prod.outlook.com
 (2603:10a6:10:2ae::5)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.16.128] (84.69.27.191) by LO2P265CA0267.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a1::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Thu, 10 Jun 2021 18:27:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5f66d98-183f-429d-cf34-08d92c3d843f
X-MS-TrafficTypeDiagnostic: DB6PR0801MB1944:|AM7PR08MB5318:
X-LD-Processed: f34e5979-57d9-4aaa-ad4d-b122a662184d,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR08MB5318ADE04AD0924F90BCF62E95359@AM7PR08MB5318.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: eu0bw7fYfJLDPeAgvibbFosErtWvmf0bx8yli2R86Anza5ObUTGVianjKuhR850EuaMF+77VU/7BJFmdS5he8jZwIYzd1ak+sP58q/iKhrzJpldYrWxNn4akXNRiq/KDeE+dPk+xVFtYixnEbGMPwElaek6WUXRhfkKUCI4/Pink0yvfMM/P3kAdqogrqIv3w6vH+aOm4J3LrfCgyai7KRArsLcJJJEjOpOcqWpbkjkeutsMY+bjCWa+ZXv50fGEGmhkm12kA1Nh7Bb5/RFE8+3l9noh3RYEx95JHRP6WLMch0KXtdbWpzYynDdW3Qgoxj4zneXl1qY/lxkseKwLFP6YTyVOpvHWc9HR6WUhQLNSz4GklUVAXzzeLTf2tdM4u5sK+n0EVuU0p/K2lisCiLCR1M6rIvc0CTzg/gFMItXI3L+BBer4cbN5soE/YW49LtdXnv0HVDDpTiBHl4auPvL4Vjt/uTv6KZ92zezbYr7fJglnTBLuS1FJPpm4wF0kvItICDknG8KZUiudqCXQXcwGOoeNefGfIObOJkQScNbnuNwrPcG1aBiiycEPew5mTKPb9/p0Jyt92sG6OJahbor1BtiA8X8zZgIoipSkAAiMgL5nn6QvL0NO4l1q732vOMozCYbaAQcH/K+MzhBeZe/zfQomj5UTUQPp1Mx3Xj2vGuF/NSZ0iqMqZUvUmZ/7bguWEifD7dRoYe0mZP20KAJYspRCrzj0NR+DPuAJdO3fNcjlfSQxNfh3ezc9DYY0iFCmk/MuCWgQIIOPsECVUc/UVTCBl46LAf32zEB1Ky1W8iI82lZ7SuMzVvHbd474YLDj31ZOt+rPhoKsZsKwZw==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR08MB6809.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39850400004)(346002)(396003)(136003)(5660300002)(52116002)(478600001)(53546011)(31696002)(6486002)(54906003)(966005)(4326008)(26005)(316002)(8676002)(86362001)(2906002)(31686004)(66476007)(8936002)(44832011)(2616005)(66946007)(66556008)(16576012)(186003)(16526019)(110136005)(956004)(38100700002)(83380400001)(38350700002)(36756003)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q0NzbU5iNVF1ZXNLYlhBRk5jNFU2SDR0NnhBdW9SWU9oWVpnM2VaZzJUWGtK?=
 =?utf-8?B?NTZLdStqT21zNk55TEc0UHFEQW9oQXVwRWpHb2sxd29veGZTTUo3U21BY3Rt?=
 =?utf-8?B?V1hxdGEzSnZKOWg4eU9mU2Z3RERnQ1ZxWVloRldaZjY4WXJqU0x6NndVY1F1?=
 =?utf-8?B?K1c0Q0YwKzZWTTcrZmpzamV2Y2MrN3UvWEZ6Q1VDczRXUEpHK240RUk5VDdm?=
 =?utf-8?B?RmE5cFdBYlBKOTFFSzBCWWtqckZOSXJpYmhYMWhvOFJKWlUvSmlla2Rma1Yx?=
 =?utf-8?B?ZW9SRk5Id2JmRno2SDhrUS9zcGtOVkprbE41anhORXI0WXdMNVRsZFJOUUpM?=
 =?utf-8?B?T1I1ZUl6eHdmM2h1YjlVUUUvOHY2enVxbTE4emUwdFdRbjdFeTgxOEprN2lx?=
 =?utf-8?B?WGNGRU9GRDFSWTFxbEFEbjF3RnNFbzloRzRDQ25PYnFwakhacndvVjhYN0RD?=
 =?utf-8?B?ZDJjVG1ROHFTcUxIeHFjbkE3MkRad1FvUjlpZjF3NnQ2L3YwT1VQV01KbGk5?=
 =?utf-8?B?eGlUeGtZUEQ2SjJZVEdvU00wdlBFYmxiczFORWdqVEJESE40djBBbDZrWkJ4?=
 =?utf-8?B?OXdYNjBtdEJWZGNvaFMyMXhhOGdUYmtYUW5iV0phbkRGS2VKTTNRalE3R0xs?=
 =?utf-8?B?ZlZ3L09IREt4R2JYb051SDd1dGl6NGNLRXhnVlE5L05taXRXdnBGWUt1Tit3?=
 =?utf-8?B?MDNsZHdWQ0k4RGdNWEdERzB0OTVRdU1YbGpsbUZ3MDVZUEIyZ3V0aWxTd0Z0?=
 =?utf-8?B?STUzNWtUL3RzMmdaOWt5cDFja0FCZzMyeDlLbWpMekNDM3hYNXJCMzkzc0p3?=
 =?utf-8?B?TkkzTGtTU09kRksvQ2dDeTIzenVWL3hiaytia1ZMNHh1di9xVDVFT3MvMHlm?=
 =?utf-8?B?SnNTdWU0dVowTkE2WmY1NTBjSHZsc2M3TmxZNlk3V3NUZ0s3ci9oQnJabTNO?=
 =?utf-8?B?ZllKK2RiKzFyemltU1Njb01qanE4QVZqa1RuUjIramZwMUNMQktJejlUb3d3?=
 =?utf-8?B?YkVxYWJTZ1VqVkNrZ21jZWZ5bEQ1V0hGejZxK29IamNvRGFRS2huSHJmTFpV?=
 =?utf-8?B?Y2RvSzhtQzQ5M2h1ckc4SElxSEhMRkRLVnRUMHBPQnBmRVRwVWtaeDJQdENs?=
 =?utf-8?B?M3pSYVN1SXo1bWxSamd2Q2ZhWFVQNkUyZ3pDZE5vRFhyVU9Zc2FRbEhGSFFQ?=
 =?utf-8?B?L094eU1XUVg4NDVsUWVyOGFhUVZhTmRvVG5Udkg2YlpDSlRMWDdRV2c4R29B?=
 =?utf-8?B?NGc0Qkd3YzdTMGN4OW9KNXYycXlmL3dqVVB0Y1ZZNjBtWWJnSXdOTHd4Unhl?=
 =?utf-8?B?aTR4VllEdnFZbi9JR1JDejBVRGpoRm9VUWR5cXlUNG50amhiZWhoVDFNWUt2?=
 =?utf-8?B?NTZCOG1MaS9oRHN2VjQ1WGNkLy81aU1memxsYmMzN0l3SFEva3BKK2k4ZVVk?=
 =?utf-8?B?dkV2ZlBsb1JLTkpCL1gzWlZjSWt5YUdScnVtTUNoT2lxTlBOZlJHb2NKMko0?=
 =?utf-8?B?NkFLU1RaZnRzZmFCMU0rQ09NbEt4akV3a1JSN0JZYVNWVHg5NTZQVW84djJ5?=
 =?utf-8?B?RE5IVzl1NlNJYzdKZ2NhTytYd0xyVFlOVjQwZFdsUk5JamRtVUpxSWVNaDZD?=
 =?utf-8?B?cyt6SCs3YXFJRDBrdTMwVFczR2JBdGxsclVnb2IwZTRENC81ZWJjdWZZRDBr?=
 =?utf-8?B?bTgzTzZvRU40Zys5NW8rdmlaSDFZcXpqVmZseW9kSXYxZURmOEEzdXdwWkZK?=
 =?utf-8?Q?3REOuvWUREv0MSy7i5sbAt6emHblDyEcU5la3pD?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0801MB1944
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT026.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 2b1d3d12-8e21-4a39-3654-08d92c3d77b6
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KTpEZTNwsANSWcs20XHoRqN3+IC3Yrkyv98Gtbii/tlxvnvOTlDzqp3mNvMtoOb+SJ8i4kk4gEb/E+YbqKoBRrrgv8JlFikSvapyYNU6H73Mq0gZnisxjcXvP/LvbWoFN4e3kbJLSNmzdNvIdH8KK+FVw/oGR3EOa1vSZpjtiy8+qyxpoMud20OiLiL2xVewmHYo3ZNj99It17SJH6Hei6EyHMNtiBRJSGJ5XKvb/SS21Q3KgKWZRn5NpQROzwZ0JoSXVbhzWbeJKtFmqaPPlriYaUFaaURxjNUtuqVtPJ7+GJNeYC8fv9pMsYVfbHT2t+tBpszAdeJmBQzG7msMNXGaOYD0KE9NUd0jeIuI3e0ZRodmkbs1VOvvNl7zxRIMmG+FQvTuJdclWLNHhyEnwTrcnVnnz64PuIx+hLhOWOgXHUKevUo2IlfQjzUdeUscIcMB313HlJf2AyY1wAjldqYgDcNBuJSD0fKXDcs2FktpVKFUn6UAn5HlDK8u8FGqyLSEZnZ8T+IBGX5BaDeToLJ1TfyXXhD5dcuKlxN1mDS+h9agVYErmc7b9Ze5ZQB/lGMuLETGR/8ro/XAgsBMQ8E+5cC4iK/d3glsVcB7YjAWAX9W0AptaIxJTU6UCQPqGI0lxHfnN77ivJW2DH36XQMwJ+HmwiO/TK4lxPIVhTbbxSJCFJeIiqg7OUO3UbViZ9LMZDtb6NayZrgVrhMCA24/QIRLLXkJVRkDEqYCvasLIURRFo4g4uqXOg5fiCnnVcnE5o7Nmyp3xuGDAPxqHXKRdQB8Jn+thAloE9LvRAm07+VuML9McdgJkRrthzEd
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(39850400004)(136003)(376002)(346002)(396003)(46966006)(36840700001)(82310400003)(83380400001)(8936002)(186003)(2906002)(31696002)(16526019)(86362001)(54906003)(26005)(316002)(8676002)(110136005)(16576012)(336012)(44832011)(53546011)(5660300002)(31686004)(966005)(70586007)(70206006)(6486002)(478600001)(36756003)(36860700001)(4326008)(82740400003)(2616005)(956004)(356005)(450100002)(81166007)(47076005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 18:28:17.2917
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5f66d98-183f-429d-cf34-08d92c3d843f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT026.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5318
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/06/2021 19:25, Rafael J. Wysocki wrote:
> On Thu, Jun 10, 2021 at 7:51 PM Jon Nettleton <jon@solid-run.com> wrote:
>>
>> On Thu, Jun 10, 2021 at 6:56 PM Andrew Lunn <andrew@lunn.ch> wrote:
>>>
>>> On Thu, Jun 10, 2021 at 07:39:02PM +0300, Ioana Ciornei wrote:
>>>> From: Ioana Ciornei <ioana.ciornei@nxp.com>
>>>>
>>>> This patch set provides ACPI support to DPAA2 network drivers.
>>>
>>> Just to be clear and avoid confusion, there is a standing NACK against
>>> this patchset. Please see the discussion here:
>>>
>>> https://patchwork.kernel.org/project/linux-acpi/patch/20200715090400.4733-2-calvin.johnson@oss.nxp.com/#23518385
>>>
>>> So far, i've not seen any indication the issues raised there have been
>>> resolved. I don't see any Acked-by from an ACPI maintainer. So this
>>> code remains NACKed.
>>
>> Andrew,
>>
>> The ACPI maintainers did bless the use of the ACPI standards followed
>> in this patchset, and their only abstinence from ACK'ing the patchset
>> was whether the code was used in production systems.  Well currently,
>> not only have we, SolidRun, been using this patchset and the associated
>> ACPI tables in our SystemsReady certified firmware for the HoneyComb,
>> but we also have customers using this same patchset and firmware on
>> their systems rolled out to customers.
>>
>> Additionally we have an entire new product line based on Marvell's
>> Armada CN913x series, which also needs this patchset to be fully
>> functional.
>>
>> I am quite certain this is more than enough production systems using
>> this ACPI description method for networking to progress this patchset
>> forward.
> 
> And I believe that you have all of the requisite ACKs from the ACPI
> side now, so it is up to the networking guys to decide what to do
> next.

You've also my ACK as emeritus Devicetree maintainer. It is well past 
time for this series to get merged.

g.

