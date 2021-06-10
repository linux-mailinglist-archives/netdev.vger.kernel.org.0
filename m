Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28E53A32C2
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhFJSN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:13:56 -0400
Received: from mail-eopbgr20078.outbound.protection.outlook.com ([40.107.2.78]:1285
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229941AbhFJSNy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 14:13:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f5PtkrrK0ZvIPDt6xx11IShEjqh31s9YifF7oTXkhHw=;
 b=19k/tdB0aaMpf/WoE31yFBLjDFIQ5k3xpHuyJ/CPhS1pJP6KGBMcbYi5hgcZcRCfKl30QQ84w6lZVzdOI1hpcmZjSYftV9MEtVZzLWVbeTU2TqHjPIgiryzwdhlkXjlGWvW1FTURQxSHTVTO19OeN2yjy0rzuUrjStPuahuAhWA=
Received: from DB8PR03CA0016.eurprd03.prod.outlook.com (2603:10a6:10:be::29)
 by AM7PR08MB5414.eurprd08.prod.outlook.com (2603:10a6:20b:105::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Thu, 10 Jun
 2021 18:11:55 +0000
Received: from DB5EUR03FT052.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:be:cafe::65) by DB8PR03CA0016.outlook.office365.com
 (2603:10a6:10:be::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend
 Transport; Thu, 10 Jun 2021 18:11:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT052.mail.protection.outlook.com (10.152.21.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 18:11:55 +0000
Received: ("Tessian outbound a5ae8c02e74f:v93"); Thu, 10 Jun 2021 18:11:54 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 16332e2f10c6a4fb
X-CR-MTA-TID: 64aa7808
Received: from c9d3dc1a36d9.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 3E6043F1-B23D-416E-B29D-7B389EB4333A.1;
        Thu, 10 Jun 2021 18:11:45 +0000
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c9d3dc1a36d9.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 10 Jun 2021 18:11:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LI3OXqbXe4mZ9/4tdxAYiP92QLkUBAjKjCnPvjAUJxzoiRPFZige903ODoNC6t4xEN6h5EbzBslxLNuXE1fMRsEp7EgrTEFV30b2LIFwEZpxOQcx4eecRKyBtoeLFemybdeMNXKPio8eesaS1Fm1JJH8rwKxrjdl/cJki8lLsggoFPZ2xFp8XYK2gB2/lFW2DPimBEg1B3RrPGSobWAaSXtJlhAXdjx/o1piM4tkiilmigzrbGSxF8N/5zOMRKGEUzO3RUVhX3MR9u3Owda1xFpfCP5MqZ1YtF8TYtw7NoHlxwrrs2fHNi13drnwdnkxEUaW4aMyv2CxMBoF/HuBvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f5PtkrrK0ZvIPDt6xx11IShEjqh31s9YifF7oTXkhHw=;
 b=LKzy7GZBGrHtGmbmSUHLzC5Ii4njZCcbaNU3jVV8hmtdImKoMJnplnZhNKWt+1vDaRShKAVtc8lC/skVDta4m5bfTLtMe5ukig8/lifJbXpK/PzbX+FNarDXIXjWLPnu+WNAYsZ1Ift2H2s24XLZIwg1aLS8GykeLaW3fhrWsKE3zjgkT4siDm4/TSYQpK9o8ocCjlq+25pAVdJT3VIW2nmf44k/fIPr18kuDNRVbv3u9aa000bIiTOKpMnHGf0YzhAhbs2jJ89SLLlavYRoU28T9el/YsnSaEUHUhtOhQwSFTbtNtqbPV+gGZrPFo7nn8HdKauivMZvRk+KPEAbCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f5PtkrrK0ZvIPDt6xx11IShEjqh31s9YifF7oTXkhHw=;
 b=19k/tdB0aaMpf/WoE31yFBLjDFIQ5k3xpHuyJ/CPhS1pJP6KGBMcbYi5hgcZcRCfKl30QQ84w6lZVzdOI1hpcmZjSYftV9MEtVZzLWVbeTU2TqHjPIgiryzwdhlkXjlGWvW1FTURQxSHTVTO19OeN2yjy0rzuUrjStPuahuAhWA=
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
Received: from DB9PR08MB6809.eurprd08.prod.outlook.com (2603:10a6:10:2ae::5)
 by DB7PR08MB3193.eurprd08.prod.outlook.com (2603:10a6:5:24::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Thu, 10 Jun
 2021 18:11:41 +0000
Received: from DB9PR08MB6809.eurprd08.prod.outlook.com
 ([fe80::e56f:3aec:7693:e53b]) by DB9PR08MB6809.eurprd08.prod.outlook.com
 ([fe80::e56f:3aec:7693:e53b%3]) with mapi id 15.20.4219.021; Thu, 10 Jun 2021
 18:11:41 +0000
Subject: Re: [PATCH net-next v8 01/15] Documentation: ACPI: DSD: Document MDIO
 PHY
To:     Ioana Ciornei <ciorneiioana@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, calvin.johnson@nxp.com
Cc:     Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "nd@arm.com" <nd@arm.com>
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
 <20210610163917.4138412-2-ciorneiioana@gmail.com>
From:   Grant Likely <grant.likely@arm.com>
Message-ID: <2b7d955c-c775-04e4-d317-07bd47e30210@arm.com>
Date:   Thu, 10 Jun 2021 19:11:38 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210610163917.4138412-2-ciorneiioana@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [84.69.27.191]
X-ClientProxiedBy: LO2P123CA0046.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::34)
 To DB9PR08MB6809.eurprd08.prod.outlook.com (2603:10a6:10:2ae::5)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.16.128] (84.69.27.191) by LO2P123CA0046.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 18:11:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c748eb5b-c58c-4f8d-e5a7-08d92c3b3ad8
X-MS-TrafficTypeDiagnostic: DB7PR08MB3193:|AM7PR08MB5414:
X-LD-Processed: f34e5979-57d9-4aaa-ad4d-b122a662184d,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR08MB5414CABC2A50DC43D34AF76D95359@AM7PR08MB5414.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: ebongHQ7DNXa012eCnwROLTEFwQAJ0PQnFT+PYEI7NyAE9R8dCRsOPDuMtOUxWtIbxsTJEubWzqGI9KMczWNvTNxv1UJmwFdIwd5QQ9SZkzR6/Ili94RW9+jcR4qaB5qOvrC7NP6AZDcBEoUMfJPw5nV1cgG+yV2fjetcAd+2aqCtGvqFmdkGk6Zu4nk6pe78vpWwvW1CsJfKYiIFg7GWnZfWy8WYrdsSlgPqY77X7DxXew2rS22JwjDYqfbZSiGwNL909BIyjvsZa+cUdWCkuN0hwUhG+acG7VA3CDOdmyznzlEYh79xKHDuazXkZvy/cjDqqWVeLyUkHt8f1bC667zd9objS8/2HhREQ7AdhnmaoXtPwAxg0mpj/2zEYrl6sb2zoFxhybzR7wPycTHO6oTsecTk8/1w7PZd/nXcjTFcRfOUsFrDuGw4C/HH1wsiCWD9eGgzrhQfdzF0A+KK4k+7nw1G0m2Y1hrZi8SxdyUIIHhbbaU4cSKFN5OpzXfYAWx93Jaaiw1HmokNyGi+H9M5bUrTRBlN8MhqQ98nA/0aM11iZhmggE3eRJWX/TqlxITPF4609dexPDIb1wPXOLR0YqWG6mPtj28n/AM81L3cnxMD+dKQRyPebljBo5nM1BpeCT5MfZmItPvIkEh2pk/nOW6SFahHNe55FjOsJAsXfCCPWqx0H1WvzxvhuIaVP8Fncm+7F8NOsKupzszwoX6Wb0sQRJ2WIGG2IkexrSMiw6Mu1wmsjFalcJ/Cr1vmQvgAp4Ev5e6ZxVw7Jwo7tKoxgKCqLhRJtGITSoaZjEXeYG51bwH3To0sCBxKx2jquz7DHKIEA5c9WIppNn9I6KNA6iuMnAVg6fxbGnw4qc=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR08MB6809.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39830400003)(346002)(366004)(376002)(66946007)(26005)(956004)(66556008)(110136005)(16576012)(2906002)(66476007)(478600001)(4326008)(8936002)(316002)(54906003)(2616005)(186003)(86362001)(5660300002)(8676002)(83380400001)(7416002)(16526019)(6486002)(31686004)(38100700002)(38350700002)(966005)(52116002)(44832011)(921005)(36756003)(53546011)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QUJCMVhDV212bzRqTkVidlY5TVgzTzQ3OVROajlFVlJHY3luN3VOMDUybGhw?=
 =?utf-8?B?R2E2VVdwdGpFNko2alVxK3VlanBTVDNKcnFwUVZpcnh4NWRaaThYTDFsZms4?=
 =?utf-8?B?RVVnUXZtTVRxSUVUQWxSVDVVN1JCKzRTbTFqN2NpUVhVV2dibVJ2NW9nSUVx?=
 =?utf-8?B?Sks1WnEyeXlRY2VNYUJCejFqWXdWTG1ycDIyczRoVnZrVlNuNUxNYllCa2pV?=
 =?utf-8?B?cEx6RnNCVWZUd1BlVVFYUkR3OVFPYTBMcDUreFRLL1JXek5SRWkrSzdSTnZw?=
 =?utf-8?B?eWlnUzFkUXp5cVpuTkpob1Y5dThIM0VKMDdqTFlCZ2VoaW5qNFByV3RsOGxl?=
 =?utf-8?B?OWdsbU15clIzQ2NEMW5EWk96MEpFaXlhU0czOHhkMko4MTV5Z1JsM1RMeU5s?=
 =?utf-8?B?WXViQnlUWEM2U1hkUEtqMGNDVW1GTHQveDAwU2dIeElSbFBURVRpcVB1Umkx?=
 =?utf-8?B?VGhzNVF1Q1pvNmhpYzNzVVB6V0hoaFY2LzFnZlRoWnpwc21vWmtPdE1lZlhr?=
 =?utf-8?B?SXNGMDc1RGJ0N2VKNG42QTF2eFZGNmtSbmgrMXBPOWZmSnZQaVNHYnEyMUJV?=
 =?utf-8?B?dHBBejFvUWhHVU1peTU0N2VHR0NsZHN5RkQwMlRaS2VoVFhGcjd1c1FiajdV?=
 =?utf-8?B?dUxWZmlFaktoZzd5M3RZKzZKdFpaeTFPdk9wV0g2bi9UVEgwUE4vT1BBTXhm?=
 =?utf-8?B?VVRmZjl3OUJ1UUUrOUQ3UldhQU1BNGx1dEMvVnBsajNOR0VPWnlibEU5a0Ux?=
 =?utf-8?B?U09qeUU2NVdMN0pENjdOY1VTcFl4QmxLZVN6VkQzYWM1U3hjMytFZmU0QzhJ?=
 =?utf-8?B?ZHhiWm5lWkNWb3FZSk02aDBOQW5hRzlmZUJiSDZsSGxRaDNFd0d1TUc0UW82?=
 =?utf-8?B?Z2ZqYWw3a2J4YVFzYk42Rjg3S2ZiRklsV1M5VE1LcVcybWxlSFFYeWxzZitI?=
 =?utf-8?B?VkJWbDVoSUc5cllCZlMwSTcrWXBqSE5ORFpHT2xNa1ZWbTI3VmFSOEZZNlMy?=
 =?utf-8?B?cDR4bGVPMTg1cWpMTE0zRE0wNUxvd2JmczJQa2V1dmQ0dWRvVkZ1QVlabUhZ?=
 =?utf-8?B?QnAxbXY5allhMkc4YURaWUQ4WHQ4eGNGbmRRK2ROS2hpa3oxb1o0bnhENmRa?=
 =?utf-8?B?MmpQWjBjSjlra0Q4YWsyUHF1Z3N4d3MrVm8yQXBuQ2tFU2c4MHJtd2Y2UTNj?=
 =?utf-8?B?eFpNR3NXU0xXZUdNenJ0c20rbWdmUitFc0kxaGZ6NlltNTlBVkRGZ2dBK1Fw?=
 =?utf-8?B?QU0yOXdFUmdTREo5YXJuUlEwS1dQQ3dCdWgwTmJHSFI2WnFvVXRDQ1VUVnBr?=
 =?utf-8?B?c0o4VEkySW5EYVp6d2FVRmpGSE1yK0NIYSt6ZTE4U2thSUtJNjRRSEhhdjZ4?=
 =?utf-8?B?ZlZHTDJXU1FOL0hDbnZ0cE8wRUNJUkxyam02M1IrZUpnL0dXaVQ4WVo4RDV0?=
 =?utf-8?B?SUNVU1J5SUVBa2QxUGRnNmNkM0xvZXluN1EvY3EwNDE0dE1NZ0k3MEZLRzV4?=
 =?utf-8?B?QnJvcFZ1RnFxSU5CTlNuaUZXRlJVbEhWNVVIS2NJRmhEdStKSkVqTzI5VWRU?=
 =?utf-8?B?REFKWEc1SmcwSWlCNVZPMnNtYjFyNVBaMFdDdkpyWkc0OVhrU2tzT1B3Tkth?=
 =?utf-8?B?OGRhR1BzZ1dDVVU2eVR4ajlaSlkzczNpNVQzbWdUdnBJVDE1VG00Yk9sVXV6?=
 =?utf-8?B?MmZhQnE4OEdLU3RxcHJzSUlMaUw0MWZSN2xxZHhYUzNoUjIvYlRsU2JWUnpz?=
 =?utf-8?Q?pyfrBwGdv3zOycMZeUTLaJFh1hSni8vN2XBM9y/?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3193
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT052.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: d91548c2-de15-48d7-15cb-08d92c3b3261
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P4m19yCcD9nzGEL5DRe6qsJZBROu4ozXpPtDZq8H0AiRbtrqQ1c2wVM4I5ikAvn2i5pao0Kr44C3W5YiRkGtSRrMBOqCmClwxj+Xzqw7iK9vKlCkDWRcJ92NwTWbECA3YomcTIhhKAsPiCswFr9OsxBW6YGjfOx9RPPrs21QWpEjEFotKtQehENzq/1EcU7wc687gi123QGx4zyG0JUpULmZ2/X5X7Tj5rRWCcys06ZvTTjieEhKH9TDFXMmVHbnKM461gkDnE2U2rnQAIsfyi61mchTBdobOmXXTVG6te2D13mdyTy6+0jSk8yFBvBpSqelbMl0vPHlFCPe6HeQ4sebDguJ3RT4TrqMW1DJZmKZI2etxbpIizdDESw9+dg41ySIv73jCYStTutX0Fw8meLZu8ykHVHT9EOnnx1ovdSEDg9SnqxESGQberdOUq0ng1fxFY7c3UybBs3llI7US9QH6qPtUxwAn+UJM9O7sa9mODuajHwg7y7jfDnnm5VNxrODQdkftk2xEVR/hN2y9fM3TQDoM3mZ+aMroAAkHMs/gIWh69V8/c5NLki288Q3SdA2qBfq6Gt4UYXCDEVxrbCIeBVEgagrYJCZd4ZkkLgvV6ccW7e5vWV9PIH9PQSJt1XD20nDW8FK+gtKBYgAqHdQeJ9J75JySd3zYB+FusYqZdgxtQewpGDFD0eI+pr8dOymYdfPfQDz8o5w+WLz7XrZXBHzrKB911SeNmqSnfGiKQg5lH00rzZHqpTB1pG79cAeORe5cwm6olf0lKM8YpOxkFubdcrust4P1sJfdEru6RyTiHkqiafdXhH17FmKpeeSMV0HrcNF1ayalUiJjA==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(39850400004)(376002)(396003)(136003)(46966006)(36840700001)(450100002)(31686004)(83380400001)(478600001)(16576012)(47076005)(8676002)(86362001)(36860700001)(44832011)(31696002)(966005)(2616005)(110136005)(5660300002)(956004)(2906002)(316002)(53546011)(6486002)(921005)(82310400003)(336012)(8936002)(26005)(70586007)(70206006)(16526019)(356005)(81166007)(36756003)(82740400003)(186003)(4326008)(54906003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 18:11:55.1491
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c748eb5b-c58c-4f8d-e5a7-08d92c3b3ad8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT052.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5414
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/06/2021 17:39, Ioana Ciornei wrote:
> From: Calvin Johnson <calvin.johnson@oss.nxp.com>
> 
> Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> provide them to be connected to MAC.
> 
> Describe properties "phy-handle" and "phy-mode".
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Looks reasonable to me. I'm not a kernel maintainer any more, so my 
Acked-by: may not be very valuable, but here it is anyway:

Acked-by: Grant Likely <grant.likely@arm.com>

> --- >
> Changes in v8: None
> Changes in v7: None
> Changes in v6:
> - Minor cleanup
> 
> Changes in v5:
> - More cleanup
> 
> Changes in v4:
> - More cleanup
> 
> Changes in v3: None
> Changes in v2:
> - Updated with more description in document
> 
>   Documentation/firmware-guide/acpi/dsd/phy.rst | 133 ++++++++++++++++++
>   1 file changed, 133 insertions(+)
>   create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
> 
> diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
> new file mode 100644
> index 000000000000..7d01ae8b3cc6
> --- /dev/null
> +++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
> @@ -0,0 +1,133 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=========================
> +MDIO bus and PHYs in ACPI
> +=========================
> +
> +The PHYs on an MDIO bus [1] are probed and registered using
> +fwnode_mdiobus_register_phy().
> +
> +Later, for connecting these PHYs to their respective MACs, the PHYs registered
> +on the MDIO bus have to be referenced.
> +
> +This document introduces two _DSD properties that are to be used
> +for connecting PHYs on the MDIO bus [3] to the MAC layer.
> +
> +These properties are defined in accordance with the "Device
> +Properties UUID For _DSD" [2] document and the
> +daffd814-6eba-4d8c-8a91-bc9bbf4aa301 UUID must be used in the Device
> +Data Descriptors containing them.
> +
> +phy-handle
> +----------
> +For each MAC node, a device property "phy-handle" is used to reference
> +the PHY that is registered on an MDIO bus. This is mandatory for
> +network interfaces that have PHYs connected to MAC via MDIO bus.
> +
> +During the MDIO bus driver initialization, PHYs on this bus are probed
> +using the _ADR object as shown below and are registered on the MDIO bus.
> +
> +::
> +      Scope(\_SB.MDI0)
> +      {
> +        Device(PHY1) {
> +          Name (_ADR, 0x1)
> +        } // end of PHY1
> +
> +        Device(PHY2) {
> +          Name (_ADR, 0x2)
> +        } // end of PHY2
> +      }
> +
> +Later, during the MAC driver initialization, the registered PHY devices
> +have to be retrieved from the MDIO bus. For this, the MAC driver needs
> +references to the previously registered PHYs which are provided
> +as device object references (e.g. \_SB.MDI0.PHY1).
> +
> +phy-mode
> +--------
> +The "phy-mode" _DSD property is used to describe the connection to
> +the PHY. The valid values for "phy-mode" are defined in [4].
> +
> +The following ASL example illustrates the usage of these properties.
> +
> +DSDT entry for MDIO node
> +------------------------
> +
> +The MDIO bus has an SoC component (MDIO controller) and a platform
> +component (PHYs on the MDIO bus).
> +
> +a) Silicon Component
> +This node describes the MDIO controller, MDI0
> +---------------------------------------------
> +::
> +	Scope(_SB)
> +	{
> +	  Device(MDI0) {
> +	    Name(_HID, "NXP0006")
> +	    Name(_CCA, 1)
> +	    Name(_UID, 0)
> +	    Name(_CRS, ResourceTemplate() {
> +	      Memory32Fixed(ReadWrite, MDI0_BASE, MDI_LEN)
> +	      Interrupt(ResourceConsumer, Level, ActiveHigh, Shared)
> +	       {
> +		 MDI0_IT
> +	       }
> +	    }) // end of _CRS for MDI0
> +	  } // end of MDI0
> +	}
> +
> +b) Platform Component
> +The PHY1 and PHY2 nodes represent the PHYs connected to MDIO bus MDI0
> +---------------------------------------------------------------------
> +::
> +	Scope(\_SB.MDI0)
> +	{
> +	  Device(PHY1) {
> +	    Name (_ADR, 0x1)
> +	  } // end of PHY1
> +
> +	  Device(PHY2) {
> +	    Name (_ADR, 0x2)
> +	  } // end of PHY2
> +	}
> +
> +DSDT entries representing MAC nodes
> +-----------------------------------
> +
> +Below are the MAC nodes where PHY nodes are referenced.
> +phy-mode and phy-handle are used as explained earlier.
> +------------------------------------------------------
> +::
> +	Scope(\_SB.MCE0.PR17)
> +	{
> +	  Name (_DSD, Package () {
> +	     ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +		 Package () {
> +		     Package (2) {"phy-mode", "rgmii-id"},
> +		     Package (2) {"phy-handle", \_SB.MDI0.PHY1}
> +	      }
> +	   })
> +	}
> +
> +	Scope(\_SB.MCE0.PR18)
> +	{
> +	  Name (_DSD, Package () {
> +	    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +		Package () {
> +		    Package (2) {"phy-mode", "rgmii-id"},
> +		    Package (2) {"phy-handle", \_SB.MDI0.PHY2}}
> +	    }
> +	  })
> +	}
> +
> +References
> +==========
> +
> +[1] Documentation/networking/phy.rst
> +
> +[2] https://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
> +
> +[3] Documentation/firmware-guide/acpi/DSD-properties-rules.rst
> +
> +[4] Documentation/devicetree/bindings/net/ethernet-controller.yaml
> 

