Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7DA3A330A
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhFJSZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:25:46 -0400
Received: from mail-eopbgr80070.outbound.protection.outlook.com ([40.107.8.70]:7074
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230001AbhFJSZo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 14:25:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVz2MjXff6hLm8ed5yXJCHN5t4FAbzlWlap9oPGiK3s=;
 b=FfAZyHE2y1CXHUdjHarHZjYeQC3CVbORW1K7Vqy8bnHQNADLW3ZeTNB4QpHnwgij2+Xv7ffzI1SfSRFVUQmUuk0I4z4HhwJDfX072DPQbLt4l9CEk47DBpijSIww9Wk/J7SfQkdIRM9Wa47S9AUbxa8MPgaWNwRtLN0xh2bWYeY=
Received: from DB6PR0601CA0019.eurprd06.prod.outlook.com (2603:10a6:4:7b::29)
 by VI1PR0801MB1821.eurprd08.prod.outlook.com (2603:10a6:800:5b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Thu, 10 Jun
 2021 18:23:40 +0000
Received: from DB5EUR03FT041.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:7b:cafe::8f) by DB6PR0601CA0019.outlook.office365.com
 (2603:10a6:4:7b::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend
 Transport; Thu, 10 Jun 2021 18:23:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT041.mail.protection.outlook.com (10.152.21.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 18:23:40 +0000
Received: ("Tessian outbound 6d1d235c0b46:v93"); Thu, 10 Jun 2021 18:23:39 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 205d52bfc52859d2
X-CR-MTA-TID: 64aa7808
Received: from ab3cfceef73d.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 8E820E5E-5EC1-423F-926D-0B8AC3A7FE03.1;
        Thu, 10 Jun 2021 18:23:29 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id ab3cfceef73d.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 10 Jun 2021 18:23:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XHXZjdBl/zttR848zZ8syQ6m7WYNQ8RYAI9OG4Tot8hMnQOleKkUF3on50tI7+TNTfUAgqQlNOZ22oMeKPBpqaESSgQ1fAZPtshVRPRKddo7QOlDzqa4DX6713EMTGGiWHZKm7yCyB8hJ4AGZlg+RHKVz12tofgcwNCMR33wte+0bUXBWAz8Kx/+ssvJuu2VsY675cFCOOc48Jy9iazI+BhwhR6sRpqjnlXeHvBX6FOQ208W0JOCSQWvpHsZA39SqVW/HmTx0I6s6cBCTZqEq11B8CTGktEyCIvq7e/tW7vcXGpZ8JXHAmNLVNniQfm/ZZYuxzj6PB30KI6vzRA/Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVz2MjXff6hLm8ed5yXJCHN5t4FAbzlWlap9oPGiK3s=;
 b=iiQShr39mDWG+GJh5Gq5AAkiNdrDU4AkFF6RoMHqL7W0EUkSX3ERdpiMq4kpd4My879xKMU2JT74BoUGawHZ+RMJZhix//Ytz4pJDqAXRCvWgWAAVUNDAheiuB3dlHyUgcnnQCOpvbNnDQLbSjUUI5IOYfixBJXKHK4iRPm6ROA3ezf3BYBNW+2Xh876UBf/nOif7cdxUsGn4S/BT7tYii3wZhBiDQxMlyxv5BHk/FnL1FayN1j/ykbaLBmj3RL159SEdoEdu7xgQ7fVoWqETiF90rPBDSJCiojCWkLtV7USw4Pc54ILQq1o47hIsrqCLUkPdRQ10P8ZEZ3DlvW1JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVz2MjXff6hLm8ed5yXJCHN5t4FAbzlWlap9oPGiK3s=;
 b=FfAZyHE2y1CXHUdjHarHZjYeQC3CVbORW1K7Vqy8bnHQNADLW3ZeTNB4QpHnwgij2+Xv7ffzI1SfSRFVUQmUuk0I4z4HhwJDfX072DPQbLt4l9CEk47DBpijSIww9Wk/J7SfQkdIRM9Wa47S9AUbxa8MPgaWNwRtLN0xh2bWYeY=
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
Received: from DB9PR08MB6809.eurprd08.prod.outlook.com (2603:10a6:10:2ae::5)
 by DB8PR08MB5065.eurprd08.prod.outlook.com (2603:10a6:10:e8::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Thu, 10 Jun
 2021 18:23:27 +0000
Received: from DB9PR08MB6809.eurprd08.prod.outlook.com
 ([fe80::e56f:3aec:7693:e53b]) by DB9PR08MB6809.eurprd08.prod.outlook.com
 ([fe80::e56f:3aec:7693:e53b%3]) with mapi id 15.20.4219.021; Thu, 10 Jun 2021
 18:23:27 +0000
Subject: Re: [PATCH net-next v8 01/15] Documentation: ACPI: DSD: Document MDIO
 PHY
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, calvin.johnson@nxp.com,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>, netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "nd@arm.com" <nd@arm.com>
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
 <20210610163917.4138412-2-ciorneiioana@gmail.com>
 <CAJZ5v0jMspgw8tvA3xV5p7sRxTUOq89G5zSgaZa52EAi+9Cfbw@mail.gmail.com>
From:   Grant Likely <grant.likely@arm.com>
Message-ID: <070d33be-8056-d54c-05c1-a13432b3167e@arm.com>
Date:   Thu, 10 Jun 2021 19:23:23 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <CAJZ5v0jMspgw8tvA3xV5p7sRxTUOq89G5zSgaZa52EAi+9Cfbw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [84.69.27.191]
X-ClientProxiedBy: LO4P123CA0290.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::7) To DB9PR08MB6809.eurprd08.prod.outlook.com
 (2603:10a6:10:2ae::5)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.16.128] (84.69.27.191) by LO4P123CA0290.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:196::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 18:23:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e795bf7-f018-4973-099a-08d92c3cdf10
X-MS-TrafficTypeDiagnostic: DB8PR08MB5065:|VI1PR0801MB1821:
X-LD-Processed: f34e5979-57d9-4aaa-ad4d-b122a662184d,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0801MB18219DF1F5ABFAA8A3A4503495359@VI1PR0801MB1821.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: OeGaPQNGp6KuoSRK05MGxwhlV7FdRwEBA0fggqURxQnBvbS9vs9VL2ySetKr9Y1nZgnFG/FwWdncyeQCE6jPQUErHlJ6G+Z+xcMCK/aKogm5OPd2ERlgypYDk9opdSeNlJ1xg7pobwMpObObh5j0uChf9DaNPmUF5Bv9syx1WONkjdDRug3Zzm2YspTWZT+b5hgiCpiTljjDLwThia8uQ1P1N40s4VkEir/ZhJNWsitM3ZOm0Xlwr/A7szyENnqQMwaLDsgkFLji4u2LMIMlcGQ7LdpQAP8dEW7upGjTHt93SLlIsghIS2dXIxtiqpI9oeQKC91fEHXH6h+CAUBQRm7WYCSsO5NtvRLcnGY4hwZBtbaRQ2bAw2e4q6AkD822Ngyi2bIeRN8ZoyttET4hP2haVcYcCjac+x3w/XcOujHBDHRWNMhH9qKwIIh+xthXOxuzpdSElKzNZq6Sgv3LNYP+dR0tetQUlt4VN2OZ3BJJHMD4Inhj5La1Zff+8vBNHfYvRx0QjiUTJEoc/thVKNCt9JkgEm0EtJ1NAPnE+GhrW49pwRKlkPBLFrRpggeqP47Mbxls6ORyCsJpCYhhweQ8ILRPuuKT8Gmnw4I/pbpM+5taLs0VlYmlff/4rSbwXu2Okc93r7OySzvVuuz+0wh1fud+WY2aSQch1lcuw0tcGMkPSKs467epH1mnjtnwjLDaiHUrEZsyw11mMSjHyThMH1rrgIdS2l/o0yvwjGuO5x1G+T4nI+5qmHK/NlH8cFNGQirhKmxuuB+6lMpI7bTlNEUZ2UixqLUKnsVVgxYVCA77UwTdTAV0dZSC9uZYlQdnc9ixjScP7rKqynDDtw==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR08MB6809.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(366004)(39840400004)(6486002)(54906003)(110136005)(53546011)(83380400001)(7416002)(36756003)(66946007)(316002)(4326008)(16576012)(2906002)(52116002)(5660300002)(44832011)(31696002)(956004)(31686004)(86362001)(186003)(8936002)(16526019)(478600001)(38100700002)(8676002)(38350700002)(66556008)(66476007)(966005)(26005)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VjAyTmViUlQ3ZjI5a2xEdUxMYkd1d1BheE5KUFhHaTNURkhUSWswVFc1WjlV?=
 =?utf-8?B?OWxsZFdMUXdBVDZLRE5ScXhGRGFzTktxSDJKK0dPM1dwM0lpMk1wT0pyOXNz?=
 =?utf-8?B?bXpUVHl0NEliMUFFRGtWWXZVVndtMnZKa2JENnM0K29od2VEZjkwYnQwa2xV?=
 =?utf-8?B?aUFrSEZuRzJqMUUzOFg0U082OWxWVFptK2RyU3ppV0tjbEZmN2ZnaS9BbXZC?=
 =?utf-8?B?QTZYeGkvWVJSaVNFTmxmMVlnMUZ0UFlyRTcvSHNzdHlEUjdFbS8wZ0RnNWZY?=
 =?utf-8?B?aVRNUlRwbWFROC85Umdtd2RDdzQyZ3V2ckNhVUxLMVZ2MWhINkJaSE43Wnpu?=
 =?utf-8?B?RUIxUHo1eWpQTWVieXU0aEtqQ0JUVllxOW5jRmFKN0tJQnRCRmkybk5sOTVT?=
 =?utf-8?B?bWkxYnVEQVZocytSSXRPMWVvMTF4SVhXbkhCbllhV2VkckEzcHVjN1pQYW92?=
 =?utf-8?B?a1U1TW5mUXRBdXJ4MjFLTUhEWHdFbTN5UXRTb3hyVEJYcVYwdUZTdmgwVXJ1?=
 =?utf-8?B?S2dlSER6SzBHVHArelN4TUpkSmRxY3lkeHNQTXMxbXFLS1ByWEJKL3FqcXgr?=
 =?utf-8?B?OHN5cHdCbEVnY2ZYTjh1bkZ4eGZFN1RVVUFwTUdlb1k5V2pOanV3VUtVK1hP?=
 =?utf-8?B?Q0h3VTdULzdtS3dtSGpqeno2NlVldUFkK0lMaVc2MXVNRTU5MXRFemxZMkky?=
 =?utf-8?B?UVhDTFBaTUpIWlhnM1U0RFN6OXdoUHYySzlKUGZhcWhuWmFJRHcrbEFqaTV3?=
 =?utf-8?B?VzVjaUJpNFl0ZC9FbzVWUmxoRm0xTDRhenZ0ZExhK1N0OGI0Q1pFMDNMK2xn?=
 =?utf-8?B?Mjg4aTVaSmVINzNLSEpTeE8yODlkUm1yMmJqeklCVGgrWmZzdDFqVFF5Tmpw?=
 =?utf-8?B?QVdKV3grZUxQaEg1MHkwc1V6Qjg2eWNqZUxKMUtkWDZrL295WG1ENFhOYkEx?=
 =?utf-8?B?V3VKL3MyT2tMQjhJNHdmVE5oSFhpUVViS1VVUFZsWXNhWGZJQlN0STZORkNl?=
 =?utf-8?B?YklXRG5ua1c4RkZtNGFDUEV4dUhFSjZaemI2R0ZLNE5vSXcyOEJ6SVlXVWhl?=
 =?utf-8?B?ZklsMUkwcUY5UmNpa3h5ZmQ1M0hpNzdhdWNmQUVXNEs1YU1LaXlBdDVURGdu?=
 =?utf-8?B?LzA3bXVVekp3VG9HSGtyTXBCeWF4eHozVVJ5TVJBUUh1M2h0VHN3cXUxZjVs?=
 =?utf-8?B?NlhvMFhldisrU3JlLyt2dXc0WFdBQ1kyWUNIYzAvRk0zbnRUeHhpajlvTVFX?=
 =?utf-8?B?NWtuRWJtbDFUTkMvVGdqRjhiUW5VYzhVdnNrZnpaS0VnUVdUanNIcVRpd00y?=
 =?utf-8?B?SW50TEpMck0rZU9EWnBWbjhDSHZBOEgydjhzU3h2N21KNDM1eWhiN0MxdWwz?=
 =?utf-8?B?aUYvNHVRSjlveHNMUU5kN0ZEd2dNbDJMYlV5ZWI5WTFRcmc4aGNTT3FEcHJF?=
 =?utf-8?B?UDYvZVNwbkM5Yjc1OWRHNVQ0Rm9tU2ZIYno4VUIyMGkyanM3NlN6SjgwWjhD?=
 =?utf-8?B?NkRlQkNzeVJFc29zeWNUYTkrOUIrclJjOVZhb1QxL3BILzVVbjZMbEJLdDlk?=
 =?utf-8?B?QlBaRGZNRXdTdzJxajJRWUp0ZTNHWEdBREs4TEtIVHVQTU5hTUtMbjNsOG9G?=
 =?utf-8?B?VVN4dmtGMUhFL01iZmlmbWcxZWVRZjJUajlraFZQaU9uN1B0RTNQR210Q0Ro?=
 =?utf-8?B?ZGgzLzZJTGFnUVFVdDFqaXQ0dHpxTFZaODNVckJ3Qm9HZTcyU2ROK000MVcr?=
 =?utf-8?Q?li+UOd8vt5bbzuAw3lt2dtWRSG6RWEAqKcWnGUI?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5065
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT041.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: ce20f934-a556-4011-15f8-08d92c3cd6dd
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y0Ywd9s4PVOIIj7HzlBlyVBiNEyJ0J6Fl626bcwAkQ54SzwEggyzd7yTJrwMSGSc7SC5WH4d03t6HEZGmfOmT4RqMnjxCxOyAmCURSWCuKwgg9CRb9B31mT6y4CbmzeBxJDcAJkE7FtdGAqtp6luiApTdqK7COn+c5xkJnWSBKOoMcpOSWsAf1FKpbEXLfgVsGD5/j6CkEnBU1BN3LIzlWdwH0CS6EkBZZK3Qnzrr3AtQg8hxF3mhlI7VE19/0pgRgDD1/0YEM7l1IWj7SgdsW9/D+ZqvMSFKhbIwFSwGjP8sf8BGAzI4aRiVZgKByURYs4REtIV1l2HQkY4rK20NTWFCYcyzjrzLMYARwWtdIQ1QwABzj6o3ZhwMCX1ITlIhWGFmOnK8ngRmQBBcfZIAJhMsitLVC/67McnqAeLn4uPXgu4kriFV8v9G3ddK3pkVLcKoRC6z5iW3H4xrdC7GyNM/0vWUqC81K3y0owRQhGbMX7LE/78oy7j5MuJZlKHMTRrZ9+2VZu1xoJNIqasDuz2rI4XPW4De/v5ecsxHXBzEiXB3h5sSPCy9GPh3Fjq5oKrXIQo6MW5CwuOxilAGNKTKKABSIS6hj6AWx9IBTrcWFHmVYO22gasPT0mmmuhlC3DsX9ghpoAAQes1qclUnvrCvOvZKHapEDZCiEjkXgiGLcP6BYzswX6Ak2ykEgopxbeYgNbpRh/jjNYfb5JBK9Jrm/b7W/tKgO+/RDWC46hgbSDFBclW+btjKlzrsmAPaX+3Hdu/+bhQTQn7vaf8j4ssWcrTcNkMEWNx/Vqi0ByzetMtrYDnm4smbxVnPEl
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(39850400004)(46966006)(36840700001)(16526019)(2616005)(36756003)(956004)(82740400003)(26005)(6486002)(8936002)(478600001)(81166007)(31686004)(44832011)(8676002)(31696002)(186003)(4326008)(2906002)(450100002)(53546011)(83380400001)(82310400003)(16576012)(5660300002)(47076005)(70586007)(70206006)(36860700001)(336012)(316002)(110136005)(86362001)(356005)(54906003)(966005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 18:23:40.1546
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e795bf7-f018-4973-099a-08d92c3cdf10
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT041.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB1821
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/06/2021 19:05, Rafael J. Wysocki wrote:
> On Thu, Jun 10, 2021 at 6:40 PM Ioana Ciornei <ciorneiioana@gmail.com> wrote:
>>
>> From: Calvin Johnson <calvin.johnson@oss.nxp.com>
>>
>> Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
>> provide them to be connected to MAC.
> 
> This is not an "ACPI mechanism", because it is not part of the ACPI
> specification or support documentation thereof.
> 
> I would call it "a mechanism based on generic ACPI _DSD device
> properties definition []1]".  And provide a reference to the _DSD
> properties definition document.
> 
> With that changed, you can add
> 
> Acked-by: Rafael J. Wysocki <rafael@kernel.org>
> 
> to this patch.
> 
> Note, however, that within the traditional ACPI framework, the _DSD
> properties are consumed by the driver that binds to the device
> represented by the ACPI device object containing the _DSD in question
> in its scope, while in this case IIUC the properties are expected to
> be consumed by the general networking code in the kernel.  That is not
> wrong in principle, but it means that operating systems other than
> Linux are not likely to be using them.
> 

Doesn't this land at the level of device drivers though? None of this 
data needs to be consumed by the OS generic ACPI parsing code, but the 
network device driver can use it to parse the MDIO and MAC configuraiton 
and set itself up appropriately.

The only difference in the Linux case is that the code is implemented in 
a way that can be leveraged by other network drivers instead of being 
entirely contained within the dpaa driver.

g.

>> Describe properties "phy-handle" and "phy-mode".
>>
>> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
>> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
>> ---
>>
>> Changes in v8: None
>> Changes in v7: None
>> Changes in v6:
>> - Minor cleanup
>>
>> Changes in v5:
>> - More cleanup
>>
>> Changes in v4:
>> - More cleanup
>>
>> Changes in v3: None
>> Changes in v2:
>> - Updated with more description in document
>>
>>   Documentation/firmware-guide/acpi/dsd/phy.rst | 133 ++++++++++++++++++
>>   1 file changed, 133 insertions(+)
>>   create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
>>
>> diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
>> new file mode 100644
>> index 000000000000..7d01ae8b3cc6
>> --- /dev/null
>> +++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
>> @@ -0,0 +1,133 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +=========================
>> +MDIO bus and PHYs in ACPI
>> +=========================
>> +
>> +The PHYs on an MDIO bus [1] are probed and registered using
>> +fwnode_mdiobus_register_phy().
>> +
>> +Later, for connecting these PHYs to their respective MACs, the PHYs registered
>> +on the MDIO bus have to be referenced.
>> +
>> +This document introduces two _DSD properties that are to be used
>> +for connecting PHYs on the MDIO bus [3] to the MAC layer.
>> +
>> +These properties are defined in accordance with the "Device
>> +Properties UUID For _DSD" [2] document and the
>> +daffd814-6eba-4d8c-8a91-bc9bbf4aa301 UUID must be used in the Device
>> +Data Descriptors containing them.
>> +
>> +phy-handle
>> +----------
>> +For each MAC node, a device property "phy-handle" is used to reference
>> +the PHY that is registered on an MDIO bus. This is mandatory for
>> +network interfaces that have PHYs connected to MAC via MDIO bus.
>> +
>> +During the MDIO bus driver initialization, PHYs on this bus are probed
>> +using the _ADR object as shown below and are registered on the MDIO bus.
>> +
>> +::
>> +      Scope(\_SB.MDI0)
>> +      {
>> +        Device(PHY1) {
>> +          Name (_ADR, 0x1)
>> +        } // end of PHY1
>> +
>> +        Device(PHY2) {
>> +          Name (_ADR, 0x2)
>> +        } // end of PHY2
>> +      }
>> +
>> +Later, during the MAC driver initialization, the registered PHY devices
>> +have to be retrieved from the MDIO bus. For this, the MAC driver needs
>> +references to the previously registered PHYs which are provided
>> +as device object references (e.g. \_SB.MDI0.PHY1).
>> +
>> +phy-mode
>> +--------
>> +The "phy-mode" _DSD property is used to describe the connection to
>> +the PHY. The valid values for "phy-mode" are defined in [4].
>> +
>> +The following ASL example illustrates the usage of these properties.
>> +
>> +DSDT entry for MDIO node
>> +------------------------
>> +
>> +The MDIO bus has an SoC component (MDIO controller) and a platform
>> +component (PHYs on the MDIO bus).
>> +
>> +a) Silicon Component
>> +This node describes the MDIO controller, MDI0
>> +---------------------------------------------
>> +::
>> +       Scope(_SB)
>> +       {
>> +         Device(MDI0) {
>> +           Name(_HID, "NXP0006")
>> +           Name(_CCA, 1)
>> +           Name(_UID, 0)
>> +           Name(_CRS, ResourceTemplate() {
>> +             Memory32Fixed(ReadWrite, MDI0_BASE, MDI_LEN)
>> +             Interrupt(ResourceConsumer, Level, ActiveHigh, Shared)
>> +              {
>> +                MDI0_IT
>> +              }
>> +           }) // end of _CRS for MDI0
>> +         } // end of MDI0
>> +       }
>> +
>> +b) Platform Component
>> +The PHY1 and PHY2 nodes represent the PHYs connected to MDIO bus MDI0
>> +---------------------------------------------------------------------
>> +::
>> +       Scope(\_SB.MDI0)
>> +       {
>> +         Device(PHY1) {
>> +           Name (_ADR, 0x1)
>> +         } // end of PHY1
>> +
>> +         Device(PHY2) {
>> +           Name (_ADR, 0x2)
>> +         } // end of PHY2
>> +       }
>> +
>> +DSDT entries representing MAC nodes
>> +-----------------------------------
>> +
>> +Below are the MAC nodes where PHY nodes are referenced.
>> +phy-mode and phy-handle are used as explained earlier.
>> +------------------------------------------------------
>> +::
>> +       Scope(\_SB.MCE0.PR17)
>> +       {
>> +         Name (_DSD, Package () {
>> +            ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>> +                Package () {
>> +                    Package (2) {"phy-mode", "rgmii-id"},
>> +                    Package (2) {"phy-handle", \_SB.MDI0.PHY1}
>> +             }
>> +          })
>> +       }
>> +
>> +       Scope(\_SB.MCE0.PR18)
>> +       {
>> +         Name (_DSD, Package () {
>> +           ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>> +               Package () {
>> +                   Package (2) {"phy-mode", "rgmii-id"},
>> +                   Package (2) {"phy-handle", \_SB.MDI0.PHY2}}
>> +           }
>> +         })
>> +       }
>> +
>> +References
>> +==========
>> +
>> +[1] Documentation/networking/phy.rst
>> +
>> +[2] https://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
>> +
>> +[3] Documentation/firmware-guide/acpi/DSD-properties-rules.rst
>> +
>> +[4] Documentation/devicetree/bindings/net/ethernet-controller.yaml
>> --
>> 2.31.1
>>

