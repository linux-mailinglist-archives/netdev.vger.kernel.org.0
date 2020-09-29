Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1665527D330
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 17:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbgI2Pyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 11:54:40 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:6821
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725497AbgI2Pyj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 11:54:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0oVHSS33b88D0ztovOHCwVgFf+5wVnvert1uE7lnVIQ=;
 b=dYJyK4Nd3AJoxXe98s71t0mEmhYkI6U19lqUEkERm+FJiWF3cFSYJaksDwPxJicVmDnhvGHik0b6TR80NtmevNTR3VNkWrIK8tGpWctMTfkGwAKJd3oAFn1usTXTdu4fpSJQ8+Qs9fnzEMJwUWreX20170wXoNjK9EFIAV7lDUs=
Received: from MR2P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:33::25)
 by DB6PR0802MB2264.eurprd08.prod.outlook.com (2603:10a6:4:85::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Tue, 29 Sep
 2020 15:54:34 +0000
Received: from VE1EUR03FT041.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:500:33:cafe::94) by MR2P264CA0109.outlook.office365.com
 (2603:10a6:500:33::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend
 Transport; Tue, 29 Sep 2020 15:54:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT041.mail.protection.outlook.com (10.152.19.163) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.21 via Frontend Transport; Tue, 29 Sep 2020 15:54:33 +0000
Received: ("Tessian outbound a0bffebca527:v64"); Tue, 29 Sep 2020 15:54:33 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: f88da8818471738d
X-CR-MTA-TID: 64aa7808
Received: from 2ce578929680.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id A86CD2B5-9F4B-42B5-B1A0-EBE2334E0C22.1;
        Tue, 29 Sep 2020 15:53:55 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 2ce578929680.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 29 Sep 2020 15:53:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TAQyave8UQ8hB3bUVAfzJf/5aLj8iOd8fstyEuc/0lvO/TUNoRbiDEYAgjwrBw8A4I1skqHfFNCZ7BkfarfXPyndT9K4tdgFzcvbaCjwEUFgm0yT/2+MyN8n5PdafTMSz5nTU5Mxku2XTt7Z5V+NErvaV8JRnNQFsM5SYnFMNrxjUAROkL/kseDLqrapYE+aMKO/WapTHKPeXxSSQ0eVQ73JWttj1F/vJhJ0v0o8WW/1A1fJDKcQMr9gvNutfLFTyjfTDfOGgC61tuyVhTDrFRFKIp1dogq9Z4Q77TRRGmtSpXBDVe1cYox7HgcuZcwuDGfXtvn+M2S9K0/Ns3m0Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0oVHSS33b88D0ztovOHCwVgFf+5wVnvert1uE7lnVIQ=;
 b=n+yPZ3SxWiF7V7EhG3QwVNZM69NaE2Jj4GxrhSVYLa5QU2fdZpsmzo3hPoTVY9TSJ/DHyNc9sxpxOJb9Rrlb+vLlIyE3J4lKMzGx4sOsmMWZd/awUYp91tfrgSChbSA0WDIElgU+yT6plfbiPSYDgaPQex7pf9gXaOu+M8C4aVqfrI4o6cILxiC7VcyPY25h77wtCeJdJjPAdg9ks+8Xp/OWuuEbVpQaRnimG4KX1bB02VEroxHG83tPP4j6iBK7jTfdKnw5NhSrlk6vU3ovHcB7bZueMphOLWSVLKGukjWxbP2oh5ddwZ1Jq5x4Ddj/IwAhfnA0/zmze2n0KPzITQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0oVHSS33b88D0ztovOHCwVgFf+5wVnvert1uE7lnVIQ=;
 b=dYJyK4Nd3AJoxXe98s71t0mEmhYkI6U19lqUEkERm+FJiWF3cFSYJaksDwPxJicVmDnhvGHik0b6TR80NtmevNTR3VNkWrIK8tGpWctMTfkGwAKJd3oAFn1usTXTdu4fpSJQ8+Qs9fnzEMJwUWreX20170wXoNjK9EFIAV7lDUs=
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
Received: from DB8PR08MB4010.eurprd08.prod.outlook.com (2603:10a6:10:ab::15)
 by DB7PR08MB3323.eurprd08.prod.outlook.com (2603:10a6:5:1c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Tue, 29 Sep
 2020 15:53:51 +0000
Received: from DB8PR08MB4010.eurprd08.prod.outlook.com
 ([fe80::2d77:cba8:3fc8:3d4f]) by DB8PR08MB4010.eurprd08.prod.outlook.com
 ([fe80::2d77:cba8:3fc8:3d4f%3]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 15:53:51 +0000
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
To:     Andrew Lunn <andrew@lunn.ch>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org, nd <nd@arm.com>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <f7d2de9c-a679-1ad2-d6ba-ca7e2f823343@arm.com>
 <20200929051703.GA10849@lsv03152.swis.in-blr01.nxp.com>
 <20200929134302.GF3950513@lunn.ch>
From:   Grant Likely <grant.likely@arm.com>
Message-ID: <8dff0439-100c-cdee-915f-e793b55f9007@arm.com>
Date:   Tue, 29 Sep 2020 16:53:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20200929134302.GF3950513@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0060.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::24) To DB8PR08MB4010.eurprd08.prod.outlook.com
 (2603:10a6:10:ab::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.16.178] (188.30.19.167) by LO2P265CA0060.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:60::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21 via Frontend Transport; Tue, 29 Sep 2020 15:53:48 +0000
X-Originating-IP: [188.30.19.167]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 353cad33-73de-4a9a-f8b7-08d8648ff5dc
X-MS-TrafficTypeDiagnostic: DB7PR08MB3323:|DB6PR0802MB2264:
X-LD-Processed: f34e5979-57d9-4aaa-ad4d-b122a662184d,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0802MB2264F9B4CC11B3487AEB589895320@DB6PR0802MB2264.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: rH7dhhU4MPYMBeTjgsZeU5+C6uGyP932iv7xpSuXtl5x1iGdafMXPwUu+gCJuTDx2JCiso60hmVRWdHCBm2nO+ja7heTNO6KFOnUqdvljysRSE3GcfC1Yp/3LJK2zH35ccEOudq4eJRWCW2i/S8pgs3DLVl2M9IUuj+H8xuPBEgv7O6ueJvEseJflpDhmSxOQQ6Dvn89qh7B3QRYm7JPIv1nn1tB2vVclzLdGCfQPh5zzddswcNBIG0tWp7dH+gtXnzYTASJWlLLkB8UsQSyO0728VzTVW8Gv//qCX2oFYJu6jUWbwj5zujKjkXGpfKaJDJQD7jSBal7TFozJRBaBwoEGps4LuLiTZYlmikiF+/oPsbbGkIO9ED7LbReZCXm9faZpI5OMysdwbcLkA6RQOsvfZWPxkSDKlCYIjYdXgBMrWH9TTS4UXLka90yqHt2ivskHRFwO9UUyPmS1EDt7KwwWvtCjgBjnrUs7uiqkm9AkOlrakPDWufHcTo8PDMY
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB4010.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(376002)(346002)(396003)(54906003)(2616005)(316002)(83380400001)(4326008)(55236004)(53546011)(956004)(66556008)(5660300002)(66946007)(8676002)(44832011)(966005)(8936002)(2906002)(16526019)(52116002)(31686004)(31696002)(6486002)(7416002)(16576012)(86362001)(36756003)(66476007)(110136005)(478600001)(186003)(26005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: DhRv4u0/o7dk3CePpti+LqvR8Rp626BMVyMb1onRObF9M8rtrghVbGaJQ2tm/gGNWviYralNF8pqTsprmxAISnL9quLk58hsfL+RUuggayLOOWq6D7Hb4y0tB8g2prdAsfM+eQ6BNtByiXL+GUbE3KtSJnaltrohtJyywy8abNUG9CIfwjC0EwG8s8Lajegk9CdfiKISLNp6quouJcMvm4iU9/m10nrOLk1ZTupdD9UXRVgjZ60acsekUMmAvh5OTr6353ArkN3OaipJMiFHDLk6MSxzWnulonqa14mi+R4/tCmqEsRRIt89zO8NgOsbWKRFwEq0x+h7fH9+Y70H6x8Uo6ynkTuG39FqMwpAVnxajrC3IZkkLJQ8AikblWNft1irN7f63ewok7LB/YKFlVQuAQCg0lSdeNlsyTu090LcGIQBzvy5hzYBeakFQUQwyocy3oMtyNKJWUjryJ8PKPTP6tH0Q0XkCIQjEB1wJhYliQ0q3jHO6ZdazCzsqlViqRx0HI8NKo/pZRvMt8aPxlmtShucNkwBhqiOuOI5P/PVZHDeoV4g6gTuB1gnzrq2YN9qurp5m5vySOk77L+w2PzswY5JQNF40l9KYE1qN9YGklAIBiHKz/dVcptXnVXNAeonGC2YM6OrJRGNUQQoxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3323
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT041.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: e6778230-cd96-4f9c-cd37-08d8648fdc2a
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oloPcf10tuxgSENzWK0t6XekOQhluddGAlPJ/hYelAF/NEsHb4+vNmPKf/Fb0e/BEDJbQMUsjNxC/jnc34/MyrtjZ5bzuyKBe8JR3gFGxWZhTP9fhUI8ZAmb0IK3lmCEVdktMoFprZR1kvztgCONcYTkCIK+1rfPZl915g7nleadZOU1FKT9+Lhy3pCb28Tl/+zxg684n0QzI6+1EabqdpWo9WvoXm4G1BVw88W8jF3Pl0PyHwL6aCiQSwtuCbo7sLVzscsqDJBNEpNoEf8mp6EeEBQnC5CvTSWAMvdXGjhDF37KjrD5S8iSKKxJI4xfM6bGJna8+7kXs400mmQxa30PnZBoPFr9zqtKI5ZXyIZR7I79LzakePkh/PYv7RzNTlsIg5VMedtzNSdp0n+pa2mwuGU864hgnMnqS9Z/Z8N/97t70rfFolYyKMXZ3xDYXEyyAWAn7BL09GD95xm/qEUzhR3T8xAsB6JDEXQAL9DIkpFv8yC/GQ/6qLty9VHKVyLZOJRQA6Yg8GMPXTNGCAcuNcGZSU2WKtkPUvNToEnfpxLIKmkjE35Fejmri08O
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(376002)(46966005)(70586007)(5660300002)(47076004)(356005)(83380400001)(8936002)(6486002)(110136005)(54906003)(82740400003)(82310400003)(16576012)(36906005)(316002)(81166007)(70206006)(956004)(44832011)(336012)(53546011)(55236004)(26005)(966005)(2906002)(186003)(16526019)(36756003)(4326008)(450100002)(31696002)(31686004)(8676002)(2616005)(478600001)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 15:54:33.9433
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 353cad33-73de-4a9a-f8b7-08d8648ff5dc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT041.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2264
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29/09/2020 14:43, Andrew Lunn wrote:
> On Tue, Sep 29, 2020 at 10:47:03AM +0530, Calvin Johnson wrote:
>> Hi Grant,
>>
>> On Fri, Sep 25, 2020 at 02:34:21PM +0100, Grant Likely wrote:
>>>> +DSDT entry for MDIO node
>>>> +------------------------
>>>> +a) Silicon Component
>>>> +--------------------
>>>> +	Scope(_SB)
>>>> +	{
>>>> +	  Device(MDI0) {
>>>> +	    Name(_HID, "NXP0006")
>>>> +	    Name(_CCA, 1)
>>>> +	    Name(_UID, 0)
>>>> +	    Name(_CRS, ResourceTemplate() {
>>>> +	      Memory32Fixed(ReadWrite, MDI0_BASE, MDI_LEN)
>>>> +	      Interrupt(ResourceConsumer, Level, ActiveHigh, Shared)
>>>> +	       {
>>>> +		 MDI0_IT
>>>> +	       }
>>>> +	    }) // end of _CRS for MDI0
>>>> +	    Name (_DSD, Package () {
>>>> +	      ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>>>> +	      Package () {
>>>> +		 Package () {"little-endian", 1},
>>>> +	      }
>>>
>>> Adopting the 'little-endian' property here makes little sense. This looks
>>> like legacy from old PowerPC DT platforms that doesn't belong here. I would
>>> drop this bit.
>>
>> I'm unable to drop this as the xgmac_mdio driver relies on this variable to
>> change the io access to little-endian. Default is big-endian.
>> Please see:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/freescale/xgmac_mdio.c?h=v5.9-rc7#n55
> 
> Hi Calvin
> 
> Are we talking about the bus controller endiannes, or the CPU
> endianness?

This is orthogonal to the MDIO bus issue. This is a legacy of the xgmac 
IP block originating in PowerPC platforms with a big-endian bus wiring. 
The flag here tells the driver to use little endian when accessing MMIO 
registers.

> If we are talking about the CPU endiannes, are you plan on supporting
> any big endian platforms using ACPI? If not, just hard code it.
> Newbie ACPI question: Does ACPI even support big endian CPUs, given
> its x86 origins? >
> If this is the bus controller endianness, are all the SoCs you plan to
> support via ACPI the same endianness? If they are all the same, you
> can hard code it.

I would agree. The ACPI and DT probe paths are different. It would be 
easy to automatically set the little-endian flag by default when xgmac 
is described via ACPI.

g.
