Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866F327D33D
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 18:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgI2QAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 12:00:02 -0400
Received: from mail-eopbgr70081.outbound.protection.outlook.com ([40.107.7.81]:36353
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725497AbgI2QAC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 12:00:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BbWgu0/rbEvekqaT9vCrScRucAtNVK6b2992UlEMrRU=;
 b=mr36OwRYDfXdQ+C2wskcAcHtA59G4a7BDl8sGWYkr7XOWYoDFO/EnpRJvsmYrzonhUaDf7sFpNVf1QyQFt/6SyEF4p2+YT/fsAZxb+1zDRoKq8ZbQXgXq85uTT6YBfEmqLdlnagCEo65g6fz46uCsv4k7G9hxAymDpnoxcx2hmI=
Received: from AM6PR08CA0020.eurprd08.prod.outlook.com (2603:10a6:20b:b2::32)
 by HE1PR0801MB1819.eurprd08.prod.outlook.com (2603:10a6:3:89::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Tue, 29 Sep
 2020 15:59:55 +0000
Received: from VE1EUR03FT026.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:b2:cafe::45) by AM6PR08CA0020.outlook.office365.com
 (2603:10a6:20b:b2::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21 via Frontend
 Transport; Tue, 29 Sep 2020 15:59:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT026.mail.protection.outlook.com (10.152.18.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.21 via Frontend Transport; Tue, 29 Sep 2020 15:59:55 +0000
Received: ("Tessian outbound 7fc8f57bdedc:v64"); Tue, 29 Sep 2020 15:59:54 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 270d983603d819f8
X-CR-MTA-TID: 64aa7808
Received: from fe9453fe044a.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id DF8BBFDA-69D1-4D7E-AE88-5DF17D4C2219.1;
        Tue, 29 Sep 2020 15:59:48 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id fe9453fe044a.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 29 Sep 2020 15:59:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RB3NHtIG6ftyPontTHvfVkIwwIbPcLvz6QWyvM9GTip1z/xtNyXEINIi0g1RzXL3D5JXJcbeigSIVOJ05O1DnS80DnZxcwZy+V91ACdHxZrbWvYunmlazJO9buKdoFFyOytmIR0FHoVH8zFIkrC9FRfFw41b9D+9dDsG6ysuxooJAqvz8pJRIu85Hu+DtpoiwIi7hu4L/ND5tfgsXMO/1hAk2Lvsm9FxvkEAWiu6FVv5TBHo9fQHJ7hPQweCswb6QGnp11rudNobd5UBDWPdhKpQrITjlBTRy0Gwt26dycLdAt0hPdq/eEKhnYq1t2/5LLD3xNQyVAWvbyUb/f+D8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BbWgu0/rbEvekqaT9vCrScRucAtNVK6b2992UlEMrRU=;
 b=PTJb85lYxiRFiURY6n2gPIwobMRj3l7Tep8nMu3RqdkQ3P7eas3vspnyX5jrd2DAf0yBE7iuuQVxxwb6g7CrYydt0BzCrlvgBvQRR8slYpiAy0EboRUR6toYkH5CwkXLfeK1k3ag0X09s0oUdKa0U1xEDiq4u66+8Y86maJLz8dyID/ipS/Ktred5W8ysYNryuA5ufk4KN9bhaaleHW+g+heZbYqv0WJ8MM05C+maWkmpIFsZ6uGLo+RG8egIkO5ffXgmIg7vxcN3lLeZlTancmo8zD9Z3xRyQ4PE83Bz8gTZo6X9kQ9h2SmaY+Heu3lxybPMX15ZFiNPGhjYmpnGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BbWgu0/rbEvekqaT9vCrScRucAtNVK6b2992UlEMrRU=;
 b=mr36OwRYDfXdQ+C2wskcAcHtA59G4a7BDl8sGWYkr7XOWYoDFO/EnpRJvsmYrzonhUaDf7sFpNVf1QyQFt/6SyEF4p2+YT/fsAZxb+1zDRoKq8ZbQXgXq85uTT6YBfEmqLdlnagCEo65g6fz46uCsv4k7G9hxAymDpnoxcx2hmI=
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
Received: from DB8PR08MB4010.eurprd08.prod.outlook.com (2603:10a6:10:ab::15)
 by DBAPR08MB5703.eurprd08.prod.outlook.com (2603:10a6:10:1ad::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Tue, 29 Sep
 2020 15:59:45 +0000
Received: from DB8PR08MB4010.eurprd08.prod.outlook.com
 ([fe80::2d77:cba8:3fc8:3d4f]) by DB8PR08MB4010.eurprd08.prod.outlook.com
 ([fe80::2d77:cba8:3fc8:3d4f%3]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 15:59:45 +0000
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
To:     Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Networking <netdev@vger.kernel.org>, linux.cj@gmail.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        nd <nd@arm.com>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <f7d2de9c-a679-1ad2-d6ba-ca7e2f823343@arm.com>
 <20200929051703.GA10849@lsv03152.swis.in-blr01.nxp.com>
 <20200929134302.GF3950513@lunn.ch>
 <CAK8P3a0etJf_SG8qLY0VjR+JamKQ8MtyPwoXnb0mpnGZawLfRA@mail.gmail.com>
 <20200929145910.GJ3950513@lunn.ch>
From:   Grant Likely <grant.likely@arm.com>
Message-ID: <28906ffc-8774-6479-b292-e8ab2c6f5434@arm.com>
Date:   Tue, 29 Sep 2020 16:59:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20200929145910.GJ3950513@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0050.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::14) To DB8PR08MB4010.eurprd08.prod.outlook.com
 (2603:10a6:10:ab::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.16.178] (188.30.19.167) by LO2P123CA0050.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 15:59:43 +0000
X-Originating-IP: [188.30.19.167]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 311f7057-fbd9-4cdd-fffe-08d86490b564
X-MS-TrafficTypeDiagnostic: DBAPR08MB5703:|HE1PR0801MB1819:
X-LD-Processed: f34e5979-57d9-4aaa-ad4d-b122a662184d,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0801MB181986AFB58C22B07F6706CA95320@HE1PR0801MB1819.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 2hK7IVeA/N2yi/Jg2P0lNlrPASS+kfm2FgNukrDoMWKwHPeUbQc36tHHjUkZg9zoQMq6niGkggglJCiGbEXfUefHpC72zxeYlsO9KQHjiTjWEbqFgyB/Q8mPzCLCJRQ5sdvvInjjUC+OcXjwMP6KuThxGPB8vBHxSw3tjWZL4SaHU3AjxdL/8Z8fm0SjdHoAbPYev/13CEk91mPyX8WwlNULfnFzhmyiK4DQs8xtUXr8R5anpjCYOXEWSPNTpzvLG17/GWPJA/WE4pn+7UW6f9Rb60FEm9FQ5M//cMaKbN3W81LRwyZoFUUEq6wfi5qzg+4kt9NWyLSjyU/LJOfFo+rj49z4o2OL84CsjeCvOKCrduy6O3TzoOc3MjO2mS9W
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB4010.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(4326008)(53546011)(55236004)(6486002)(8936002)(16526019)(186003)(26005)(36756003)(8676002)(86362001)(31696002)(52116002)(66946007)(66556008)(66476007)(5660300002)(478600001)(2616005)(956004)(16576012)(54906003)(110136005)(44832011)(316002)(2906002)(7416002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fGYWMv/9RsnE9KEhiVslM1leIgBWR+AfLwrKCRaAOfrslg5QbevxRZCfNJ8v/puIfLDKuOZxl8IQV+LZWRpV4jYnocsccBVLvahHVd4UZUnLAtoyaIUMyKHqHtIO95nIQOviynsqOpwzcyh7oZumBfrCbfQ08BS/1LVBHfNofDBcToz+3WeN5//YOKmB90NFskqteKkZu+uX3xOySpubT+zNjFCiJYSy8txfgPkPmleNGtTfOvz0nQcn8CaEkzKbq/QSHidwv7EAIJiv82DCfV/BFnVE0+otcO/0YnAejFVkFz0IdpdZnetLPGiR5EKsIionn4Nf1JlSyDLXcnyWhXT6bbJJbYdUbqRPR5exVewXy2wULUqoKANjPlK0ziRcKak9ETk6LdmR9SY1/UBPQGdqHq5ch5s4Yy8+acDqZLvYYtMrE2qi7DsteHphJpv5kAjSn1tiuAofiCyDrvx4/NkowOaq/P4AQ4bKX+WUPf3rZGEYDY2Rto0ZIYmvFew3VhgvzxdMT67uAGHsxxeunIZNhrr11Y6NU3s2tnLCD9Xyd6lUxhJl2RYJEETOOu3rekm9/nGhfc4U2mZZeE/K6wjZhU5bWznM5iJtVB4PbDG7PzMM4jA0ApmgFDbRCtHzo7XdbKnDLNufwyIVjR5IIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5703
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT026.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 5fb74058-9947-42f4-43b7-08d86490af3c
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OUjt7xiRl23RMftRkENCh2/63Wu8vZ/NyhYYJYzf8X8/nIVfU444h9xiSJ3jNIErMH9lAGvuTdATQ5leKGtKeGtjrWv1LRnifujbThY/pqPRzlmQs9m/nj8SkFEL5UStNZciQM5tkIbXrCLA0GECrU8h+J6cZINmttWdZJWna0w+YbGsZXwj6rbeAFyXtwxrpWr60os3zOxJPynvmKtB+cnuxATF272liGp61YzZLxMwVgR/jJG0IfQXRc0nqHlBeIweSIxlNP58q8uW2+hTSKRQdUJA/qd0v4m4p1wEHGVmhGiHBbwu4AeWam4cVX3+dp5hP8ryOs5irGmhpz4cN49L06VB+/bhYhaaJwxDtlGscQXH3fXwtCmUslfRT7jp+iduSkY8KcJx7c7rOuVfuO94FYRSgfPD2SBrh6b4jPSU52+bbSv1nWTxcuer08vG
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(46966005)(450100002)(36756003)(336012)(2906002)(70206006)(8676002)(70586007)(47076004)(2616005)(82740400003)(86362001)(956004)(186003)(44832011)(16526019)(316002)(26005)(54906003)(110136005)(16576012)(6486002)(53546011)(36906005)(55236004)(31686004)(4326008)(8936002)(356005)(478600001)(81166007)(5660300002)(82310400003)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 15:59:55.2786
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 311f7057-fbd9-4cdd-fffe-08d86490b564
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT026.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1819
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29/09/2020 15:59, Andrew Lunn wrote:
>> IIRC both UEFI and ACPI define only little-endian data structures.
>> The code does not attempt to convert these into CPU endianness
>> at the moment.  In theory it could be changed to support either, but
>> this seems non-practical for the UEFI runtime services that require
>> calling into firmware code in little-endian mode.
> 
> Hi Arnd
> 
> Thanks for the info. So we can assume the CPU is little endian.  That
> helps narrow down the problem.
> 
>>> If this is the bus controller endianness, are all the SoCs you plan to
>>> support via ACPI the same endianness? If they are all the same, you
>>> can hard code it.
>>
>> NXP has a bunch of SoCs that reuse the same on-chip devices but
>> change the endianness between them based on what the chip
>> designers guessed the OS would want, which is why the drivers
>> usually support both register layouts and switch at runtime.
>> Worse, depending on which SoC was the first to get a DT binding
>> for a particular NXP on-chip device, the default endianness is
>> different, and there is either a "big-endian" or "little-endian"
>> override in the binding.
>>
>> I would guess that for modern NXP chips that you might boot with
>> ACPI the endianness is always wired the same way, but I
>> understand the caution when they have been burned by this
>> problem before.
> 
> So it might depend on if NXP is worried it might flip the endianness
> of the synthesis of the MDIO controller at some point for devices it
> wants to support using ACPI?
> 
> Does ACPI have a standard way of declaring the endianness of a device?
> We don't really want to put the DT parameter in ACPI, we want to use
> the ACPI way of doing it.

No, and it doesn't need one. If a device is wired up big-endian, then it 
is between the device driver and the device. The OS, and the ACPI 
framework doesn't come into play other than providing a generic way of 
encoding data useful to the device driver. Encoding endian hasn't been a 
common problem, and the tools are already there to deal with it when it is.

g.
