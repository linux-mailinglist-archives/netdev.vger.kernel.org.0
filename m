Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FEE3A32EE
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhFJSVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:21:36 -0400
Received: from mail-vi1eur05on2052.outbound.protection.outlook.com ([40.107.21.52]:31462
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229823AbhFJSVg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 14:21:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/IVaM3BfMGxdDgY7rxKARRqtRMcJ0gsoQEnsmUV3II=;
 b=kblx37f5ipkE9MKxqgPvsf8eKEhOIbW8FaPEnxaRhlT52tS96Ss4V8FpXkwlqTYtvIroQRp6H+fS+HmvJvf9/KT5AzTIYsYrvLQv5GW9d+ejpeAi9ljfL8EO0FlvNeZFgCCiFrz3l2rGScXZJnCZlojcr8cdBHHmSvdegtlrTjc=
Received: from DB6PR0501CA0002.eurprd05.prod.outlook.com (2603:10a6:4:8f::12)
 by PA4PR08MB6157.eurprd08.prod.outlook.com (2603:10a6:102:e3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Thu, 10 Jun
 2021 18:19:36 +0000
Received: from DB5EUR03FT044.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:8f:cafe::51) by DB6PR0501CA0002.outlook.office365.com
 (2603:10a6:4:8f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Thu, 10 Jun 2021 18:19:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT044.mail.protection.outlook.com (10.152.21.167) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 18:19:35 +0000
Received: ("Tessian outbound 5e4f56e125a9:v93"); Thu, 10 Jun 2021 18:19:35 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 52e3cfc08960dd66
X-CR-MTA-TID: 64aa7808
Received: from 8eb901e893bb.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 211EB56B-7B12-435D-A81E-675AC4B60F2D.1;
        Thu, 10 Jun 2021 18:19:26 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 8eb901e893bb.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 10 Jun 2021 18:19:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PaoYF7MydgpMmdW3TqBv4GTdC3WVmLyO4LzRQmLtJKz5iNmpoinORwZrkr8moe+X9/L/A335gB2rlBIflTleVADEoVXc8Hcqb7Vgzq88Q/PjSzIJ/a5Te0p0H3+VgEdm8I099vEvXpj0ecoqIx6nQzHSjKbf6S/YzMffrs5lfbOi4BBVL6DYPccIBok17YPygaH+wOF9HGt5p6Fo+v4j3srpSpRNkzKj6lwg/kD8AIYqURKHWf9sBy+6CvIntow9a3CuPTyHd4PqcYEzCyfy4LJWO0qCmMnxipJIiXkUX7xNVxZm7q3RCI+0fZqfARFFYZ01JBT2mweboDS3OMynrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/IVaM3BfMGxdDgY7rxKARRqtRMcJ0gsoQEnsmUV3II=;
 b=VVvhlEMv26Tm0lCoDsYneZvkpTomVUWiuLWcaNiI+0RZbZsfsi305tSf7nGSd7OstCzRCgpIZ8pzBhzZsHBa1qKj15fON77Nj/ZpWfa9OwK6euEZw6Simvkl1tV2SizeSdNoqrlA3HQIKGTotSWkSRYKfY0fT2alKKzAqYzW9UyGoSq/Kq4efvI9Yjv0gt40t9Enyz1+aDZdUl0GNZssJe6HW05PV5uaX6YFjUPMwABifwSZTt95TdhHz0qtwc8JiXEZ8s3FuzzoRtloFB32ZikPUbIwKnAzpxTMAkDwhKntAqQt7Clrb025gLnC3+0qgnF3seWsbxPf3Mu2Ng3WLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/IVaM3BfMGxdDgY7rxKARRqtRMcJ0gsoQEnsmUV3II=;
 b=kblx37f5ipkE9MKxqgPvsf8eKEhOIbW8FaPEnxaRhlT52tS96Ss4V8FpXkwlqTYtvIroQRp6H+fS+HmvJvf9/KT5AzTIYsYrvLQv5GW9d+ejpeAi9ljfL8EO0FlvNeZFgCCiFrz3l2rGScXZJnCZlojcr8cdBHHmSvdegtlrTjc=
Authentication-Results-Original: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=arm.com;
Received: from DB9PR08MB6809.eurprd08.prod.outlook.com (2603:10a6:10:2ae::5)
 by DB9PR08MB6473.eurprd08.prod.outlook.com (2603:10a6:10:257::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Thu, 10 Jun
 2021 18:19:21 +0000
Received: from DB9PR08MB6809.eurprd08.prod.outlook.com
 ([fe80::e56f:3aec:7693:e53b]) by DB9PR08MB6809.eurprd08.prod.outlook.com
 ([fe80::e56f:3aec:7693:e53b%3]) with mapi id 15.20.4219.021; Thu, 10 Jun 2021
 18:19:21 +0000
Subject: Re: [PATCH net-next v8 00/15] ACPI support for dpaa2 driver
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
        Ioana Ciornei <ioana.ciornei@nxp.com>
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
From:   Grant Likely <grant.likely@arm.com>
Message-ID: <18bdfea5-5379-c930-5598-e63d4a046825@arm.com>
Date:   Thu, 10 Jun 2021 19:19:18 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210610163917.4138412-1-ciorneiioana@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [84.69.27.191]
X-ClientProxiedBy: LO2P265CA0085.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::25) To DB9PR08MB6809.eurprd08.prod.outlook.com
 (2603:10a6:10:2ae::5)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.16.128] (84.69.27.191) by LO2P265CA0085.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:8::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 18:19:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45008528-db6b-4040-007f-08d92c3c4d80
X-MS-TrafficTypeDiagnostic: DB9PR08MB6473:|PA4PR08MB6157:
X-LD-Processed: f34e5979-57d9-4aaa-ad4d-b122a662184d,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PA4PR08MB61575634801C2BBAC469757895359@PA4PR08MB6157.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: EPuLrqzK/a6oXKLU5ZYB82PPnYWgUgHnhNsjn4suvOGdz1ug2hMRnMMgpKMOsZdtMg9f0NKf+k4cTo9EsGfEOWBtnwCspxDdhJ2VD6KmQEmBd1wrmo1wCuoDqiI1hs5cyHDoU55Mhk+Cw0LY2u6sXZc+3/JDT3XcRtYFtuWJCwJnLotIC8ScPpj6TTL975WtDX86Rno/6jmWfCutHr+MMek+a0AggAcg2s4ez8PdlUEKSK60RsriOTMQRnDEuE8gxhCl2dAkKgjYOMIRo+L1m4c5T3Jui5QpojRqTNJ0ojdWG5rn1Ne+Ddj6Uju3GBG/4ocgZH4g9fMqqAvHdbI/mHA068rgCbtbVN13XJTVWsHez6KSZDzP3tL99J8vqo3Fo/GY0IYBYLV8ZERbazMLT4wwFBPskFmi0BeyUMYYuh9qhleY3O9NVbYgBZwx9nrxM351iW0F1xEvNtOzThxt6wjE3bfb8ptMI75EYyuuvS5DuAMpu/HvG+2Ibgj9rXNtQX3ecQ94sSrogHzdKbH49nqDmmjd7Xe9DoLUEsFo9jAbRdg7pFWmCkXpF0ijmhr1WK8HBIhFkyESItd9sfwrHeW3LQHpTfhhYshkK5mrGgEGaJVZKvs+k2+KotArhpNrGS9am/KD9uzRfUFs0n9EEtZ/A48EjVF3kKiPK02F9B8kB/z/Gp5Nm0GW3aB3Z5U0ec9aT9IhfbReDzxlufQmzeIMH88xS98/BuVW8N69EI126sceED6rq4uvlm+HGrzg
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR08MB6809.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(376002)(366004)(396003)(346002)(86362001)(31686004)(7416002)(31696002)(2906002)(66476007)(44832011)(956004)(66556008)(66946007)(2616005)(186003)(26005)(16526019)(16576012)(478600001)(52116002)(5660300002)(110136005)(316002)(54906003)(4326008)(8676002)(8936002)(38350700002)(38100700002)(6486002)(921005)(36756003)(83380400001)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TWp0VlFXNHI4cWF2VlJVbjZTQkxXVnVrblk1TERtbGFUWWV2QitDWTFleHhH?=
 =?utf-8?B?b3NSTVBZbHY5M2tyOVpaYWFkeTBGc2k3NllRcEk0ZmVNYjJQMHRJQzVBOFZ3?=
 =?utf-8?B?UVlzSEVFZ0VFbnpsZmVNUEw4T2x0Z3BHSXhBcnVEaVlKVThjYTFBT3ArUHhZ?=
 =?utf-8?B?RWQvS2I5Q1NiMHFiWE91TytlK1BrWnJBMCtLQ0JkNmRUK24vWFpCMEVDMlIv?=
 =?utf-8?B?ajkrK3B3WXc2NG84VHZlSmpqUTNLOWQ0SktjRm1Pa0MyZEV3UnlydXYyV1ha?=
 =?utf-8?B?WVl4WEhwS2JRS2Q4VGRRcTVsQ3FTQlJocEFCMlAvNndqMXlaSDBoWGtHcHRU?=
 =?utf-8?B?UTllN0Y0WGt4b1dTZHNLZUQwdmx4U0llUmk5K0VXaTJDWERTcTBvNHp0RVJF?=
 =?utf-8?B?dHhDWHg0Q3J1d0dWQXdsdkdqMDQ4amxCbG5MSmZyYThrUllZOW9BYThLbHZV?=
 =?utf-8?B?d1A1enVYVjJ1WTdibU1lL21WNkIzeFBJV2ZlNHcrT21YdEx4b0o0VzJHUU0z?=
 =?utf-8?B?ajVmOWpZQnNheWlsNERJQVdUM2IvcjZjdDIveFBIWSsyakdYeVZDdkw3Uyt2?=
 =?utf-8?B?L1ZNbG5kbDRZbG95QmtJZm5tL2RPTkJtc2h3azhCYU9HMzU4RWtjeXlXUXA4?=
 =?utf-8?B?Vk9WOUNWTGVHdWt4MUJUVVlRSE1na0t3TjlEUFB3ZTNUVHB4bGozTmFJcm1k?=
 =?utf-8?B?Q24rMEt3ekQ3YWl5YUN6LytQeHArTVpQd2M5K1h2UVNhZWEvOWM1MWR3d0NM?=
 =?utf-8?B?YmpYQ283Z05wSXJySnJlWmlIaFhsQlZNQ0xRRkdBT1h5Wm1KeC9KMm1DZklX?=
 =?utf-8?B?aldUVVFZUjBja3VSOVVvaXJEOE9iS1gwckhROHdBSWdUN0hYM1RucHp3WE10?=
 =?utf-8?B?NFVtSk4weWRKRUViOFU4MTUwS0NuVkdLS21kTEFKem1EVmQzMWJEMGlQSFBz?=
 =?utf-8?B?WUlOdUpSWVhUbGJMK2tDWHo1ZUhTWjRKcmlTOVZaR1hsNFBPbFdQc3RpYWR2?=
 =?utf-8?B?TjE1RFNabElzYzB4U0FOdHRWSW0vQ3JicUw1cFV6ZFJMckJaaTcrRUhaR2RH?=
 =?utf-8?B?cXZGbVNOc09Bb0gvVzhGYTZnTmo2VTZPMkxpZ2ZWV3lMakRzOUFoOUE0Z0dN?=
 =?utf-8?B?NUVYamRPNzcra1RIVVF5V0VsbExjbWRKbXFqYWNIMEExNWpjQXpFT1ZRS0J5?=
 =?utf-8?B?QWN5amxMNzQzdnZzZmZOVkJTVFhya01FYVhWVVB3TmV1ZGYvQXl0UG5MbkJn?=
 =?utf-8?B?NTFRdkhWakNwNUFvN25JOGhsL2Nta3VZWTh0UW1yN3BmSVFZR3F0aHQ4L0tH?=
 =?utf-8?B?N0R1d2JoaFlMeEQwME16VWhlM3JUU3NLVUY2STIyc1gyd1oyVUtHZmtTdzFN?=
 =?utf-8?B?MHFHSDUzTEJEaVFpYURES21GQ2JoeW54SHZucEdmY3J3cDcxL0Z0VDM2R2pW?=
 =?utf-8?B?azlrc09mL3JFTm9XS2VIdjV4UUZnd1EwUFBoNGtDbmp5NUVYblpRSmFQQ3pH?=
 =?utf-8?B?VmoycGlCak5NNDN0bU02YjVxcldhR3VhU0tsRCtXeWdGOVJsWjJPMTYxRXhk?=
 =?utf-8?B?UHZFUjg5Zzc3OEhHNUF0ZjhnWTgxUnlpc1psVlRFNGNvL29WRW1WTE1MaEhE?=
 =?utf-8?B?SnArTEw3a2lCOHQ2elFqZ1RtQ1l4WDYvU1k3TXA0NUpMakxwdUdHdnJFUmU3?=
 =?utf-8?B?cWREVnhsT1krOS9aTlFIbXpCQkt4VjVJU3lwOEkzSytNb1crR2psaitNVWJp?=
 =?utf-8?Q?4V/maQvaAOteznVQuVEaJvny4SYDdpuLFjFv80O?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6473
Original-Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT044.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: bcbf7fe2-3791-4f5f-497e-08d92c3c4478
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5kYXSyRJDk9oF+mtjIe2qZ/CvALaTCNggjKv3JB8ICPD/rrJSRlbxn65sXu6D3GfGIldICjU6nquEsPzGcARY9+1Cs0bECfaBkFmIhY6iSRz3ocwDMsjiKYBfA6xfeLO/0n4pznBfR+X0Jai9ExsEYXD29TFdxDCD1RK0MXtFfspnlb/Ygu+K5YZeJT8urzFE/fqfci0khxOJOLoeYuhvKxhXvAAff4Nl9Nb4dJ0OLU0VXYuminAYJ+5zn0g1gNDdQQCfe1MIV0cnpVUtssgQbP63tPF1UDSwaJoKcEKCq+SpjfJ4kq6Ti1Er7F7y63bbfaeXCHvBobijz/5jtVIipp4BHMHoDahaOQQKGOHuWvnBNwBeqY07+HXQFuMDkTsKz86B4cXuvyVMielI3u+8e6/O1nl2XYezhyYn/L9Qy3KPerUYtQ6ThotGbl5Wa8Aqve8D7IM5zLZ0GcR+gJ1XFoLNMoZOqmH4jtfN4GAiQeprb44nSOAUDEzEYzMt1EZPQZb2u42NhEcrOHHDDWAxuCQ88xYaF4VjfV2RnRmSCS+ylltokFNTojrUiUKRJHuNcrxM0YPQe/tq7aZELzlGvJqSvtbOMS4z00mNPAZee4Rr8DuNA5p6pS1VMhk/tBYOFoNCFEnhKxxdCWyJw0S7IvL7beOMqBPVDr0RiLHsWAwFoi028VgBWXrXIXwXKTAjZj9ZUjaajm8OriW8U9Hmw==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(396003)(376002)(39840400004)(136003)(346002)(36840700001)(46966006)(4326008)(450100002)(316002)(36756003)(82310400003)(31696002)(44832011)(478600001)(16526019)(110136005)(186003)(6486002)(36860700001)(70206006)(54906003)(70586007)(2616005)(31686004)(921005)(16576012)(83380400001)(86362001)(47076005)(8936002)(356005)(53546011)(956004)(81166007)(26005)(8676002)(5660300002)(336012)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 18:19:35.9410
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45008528-db6b-4040-007f-08d92c3c4d80
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT044.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6157
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/06/2021 17:39, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> This patch set provides ACPI support to DPAA2 network drivers.
> 
> It also introduces new fwnode based APIs to support phylink and phy
> layers
>      Following functions are defined:
>        phylink_fwnode_phy_connect()
>        fwnode_mdiobus_register_phy()
>        fwnode_get_phy_id()
>        fwnode_phy_find_device()
>        device_phy_find_device()
>        fwnode_get_phy_node()
>        fwnode_mdio_find_device()
>        acpi_get_local_address()
> 
>      First one helps in connecting phy to phylink instance.
>      Next three helps in getting phy_id and registering phy to mdiobus
>      Next two help in finding a phy on a mdiobus.
>      Next one helps in getting phy_node from a fwnode.
>      Last one is used to get local address from _ADR object.
> 
>      Corresponding OF functions are refactored.

In terms of design, this whole series looks right to me. The way data is 
encoded in ACPI is entirely appropriate. As long as Rob Herring is okay 
with the DT code changes I support this series being merged.

For the whole series:
Acked-by: Grant Likely <grant.likely@arm.com>


> 
> Tested-on: LX2160ARDB
> 
> Changes in v8:
>   - fixed some checkpatch warnings/checks
>   - included linux/fwnode_mdio.h in fwnode_mdio.c (fixed the build warnings)
>   - added fwnode_find_mii_timestamper() and
>     fwnode_mdiobus_phy_device_register() in order to get rid of the cycle
>     dependency.
>   - change to 'depends on (ACPI || OF) || COMPILE_TEST (for FWNODE_MDIO)
>   - remove the fwnode_mdiobus_register from fwnode_mdio.c since it
>     introduces a cycle of dependencies.
> 
> Changes in v7:
> - correct fwnode_mdio_find_device() description
> - check NULL in unregister_mii_timestamper()
> - Call unregister_mii_timestamper() without NULL check
> - Create fwnode_mdio.c and move fwnode_mdiobus_register_phy()
> - include fwnode_mdio.h
> - Include headers directly used in acpi_mdio.c
> - Move fwnode_mdiobus_register() to fwnode_mdio.c
> - Include fwnode_mdio.h
> - Alphabetically sort header inclusions
> - remove unnecassary checks
> 
> Changes in v6:
> - Minor cleanup
> - fix warning for function parameter of fwnode_mdio_find_device()
> - Initialize mii_ts to NULL
> - use GENMASK() and ACPI_COMPANION_SET()
> - some cleanup
> - remove unwanted header inclusion
> - remove OF check for fixed-link
> - use dev_fwnode()
> - remove useless else
> - replace of_device_is_available() to fwnode_device_is_available()
> 
> Changes in v5:
> - More cleanup
> - Replace fwnode_get_id() with acpi_get_local_address()
> - add missing MODULE_LICENSE()
> - replace fwnode_get_id() with OF and ACPI function calls
> - replace fwnode_get_id() with OF and ACPI function calls
> 
> Changes in v4:
> - More cleanup
> - Improve code structure to handle all cases
> - Remove redundant else from fwnode_mdiobus_register()
> - Cleanup xgmac_mdio_probe()
> - call phy_device_free() before returning
> 
> Changes in v3:
> - Add more info on legacy DT properties "phy" and "phy-device"
> - Redefine fwnode_phy_find_device() to follow of_phy_find_device()
> - Use traditional comparison pattern
> - Use GENMASK
> - Modified to retrieve reg property value for ACPI as well
> - Resolved compilation issue with CONFIG_ACPI = n
> - Added more info into documentation
> - Use acpi_mdiobus_register()
> - Avoid unnecessary line removal
> - Remove unused inclusion of acpi.h
> 
> Changes in v2:
> - Updated with more description in document
> - use reverse christmas tree ordering for local variables
> - Refactor OF functions to use fwnode functions
> 
> Calvin Johnson (15):
>    Documentation: ACPI: DSD: Document MDIO PHY
>    net: phy: Introduce fwnode_mdio_find_device()
>    net: phy: Introduce phy related fwnode functions
>    of: mdio: Refactor of_phy_find_device()
>    net: phy: Introduce fwnode_get_phy_id()
>    of: mdio: Refactor of_get_phy_id()
>    net: mii_timestamper: check NULL in unregister_mii_timestamper()
>    net: mdiobus: Introduce fwnode_mdiobus_register_phy()
>    of: mdio: Refactor of_mdiobus_register_phy()
>    ACPI: utils: Introduce acpi_get_local_address()
>    net: mdio: Add ACPI support code for mdio
>    net/fsl: Use [acpi|of]_mdiobus_register
>    net: phylink: introduce phylink_fwnode_phy_connect()
>    net: phylink: Refactor phylink_of_phy_connect()
>    net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver
> 
>   Documentation/firmware-guide/acpi/dsd/phy.rst | 133 ++++++++++++++++
>   MAINTAINERS                                   |   2 +
>   drivers/acpi/utils.c                          |  14 ++
>   .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  88 ++++++-----
>   .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |   2 +-
>   drivers/net/ethernet/freescale/xgmac_mdio.c   |  30 ++--
>   drivers/net/mdio/Kconfig                      |  14 ++
>   drivers/net/mdio/Makefile                     |   4 +-
>   drivers/net/mdio/acpi_mdio.c                  |  56 +++++++
>   drivers/net/mdio/fwnode_mdio.c                | 144 ++++++++++++++++++
>   drivers/net/mdio/of_mdio.c                    | 138 ++---------------
>   drivers/net/phy/mii_timestamper.c             |   3 +
>   drivers/net/phy/phy_device.c                  | 109 ++++++++++++-
>   drivers/net/phy/phylink.c                     |  41 +++--
>   include/linux/acpi.h                          |   7 +
>   include/linux/acpi_mdio.h                     |  26 ++++
>   include/linux/fwnode_mdio.h                   |  35 +++++
>   include/linux/phy.h                           |  32 ++++
>   include/linux/phylink.h                       |   3 +
>   19 files changed, 691 insertions(+), 190 deletions(-)
>   create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
>   create mode 100644 drivers/net/mdio/acpi_mdio.c
>   create mode 100644 drivers/net/mdio/fwnode_mdio.c
>   create mode 100644 include/linux/acpi_mdio.h
>   create mode 100644 include/linux/fwnode_mdio.h
> 

