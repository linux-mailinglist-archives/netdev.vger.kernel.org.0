Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02CC2810BB
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 12:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387692AbgJBKtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 06:49:09 -0400
Received: from mail-eopbgr70057.outbound.protection.outlook.com ([40.107.7.57]:43443
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726017AbgJBKtI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 06:49:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qv0p5WSSRt3Sp6uTKUXwDFp+xxw5/OdLgsrBQfVkZwc=;
 b=mmXAigbtz411fIlP5g6SrNx5b3xQ1O9SA6ck41bFP6etuCp6Dgygkvp0dXVVlZRtktG9lqEDmkwmQ69MCN2LhUnIjq0Yo8rvgSIHGhQhTGSvEoPrQlR98u2WZRoMGVrDO/wdVJhgOsNL1AOQ2X/nCzZRuZ9cOBseMDOjK7xJo1o=
Received: from AM5PR0402CA0006.eurprd04.prod.outlook.com
 (2603:10a6:203:90::16) by VI1PR08MB3630.eurprd08.prod.outlook.com
 (2603:10a6:803:84::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35; Fri, 2 Oct
 2020 10:49:03 +0000
Received: from AM5EUR03FT013.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:203:90:cafe::92) by AM5PR0402CA0006.outlook.office365.com
 (2603:10a6:203:90::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend
 Transport; Fri, 2 Oct 2020 10:49:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT013.mail.protection.outlook.com (10.152.16.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.34 via Frontend Transport; Fri, 2 Oct 2020 10:49:03 +0000
Received: ("Tessian outbound 7a6fb63c1e64:v64"); Fri, 02 Oct 2020 10:49:03 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: a241ee8e960ce8cb
X-CR-MTA-TID: 64aa7808
Received: from 3ae1a93271b8.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id CACC7A5C-BB9C-4082-A004-8A912DB9AC3D.1;
        Fri, 02 Oct 2020 10:48:57 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 3ae1a93271b8.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 02 Oct 2020 10:48:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gYAIZUfZvxa3PtKJWoU7jZVfrV6OJQTKSkRv0Zslww7v1vOd/5c3fVjuhhBDslgYGd8GJqWzvsoSSWq5JJG2TnPALUPXiAtUOzV/tpqAtn94BNljdqcZKUTZ+nv3YBd5ot+RHL+kNzViY7OKp3a6l9jRoA9lPgBRGJH3PZ1fFSf/Ey39W24/0+xjIE5A1HPoaMatPve05/Sh7jbaEY/GmGJPwBXiPDPip9hxw+Obi8uJXw7kUzY3YMWXKclxwiwhQdPtGFm+hfuJudsKLqcwb7dmcpCjuBUjOnFYOD3iRIWqVSWpPmqzuYNhvDqQ/tXIz6K5e3qRO5fmUPxL7sdokA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qv0p5WSSRt3Sp6uTKUXwDFp+xxw5/OdLgsrBQfVkZwc=;
 b=A/yQc0vw26RPPwToqQKbOjNJbOrfeh/qC6eCWYtiMNfzZd+lXDhnmH0L204dAtnWHfIx4JmNj9kI1to6OYPEbdClD2lvpTZUFuqudR/Cqi4pMveLhK/nQNjLllU+D8Yu+tT67WdAAHrocDAWw99K9I6qkgPgU6ZP6H3TLdhQZHhqcskbRwoTYtw/ZZCwRBnflW7Jlb73A9wYg+OgDLY1ohlnI3mjv72zKTS4ljhV4kNdzYkeWtwZeRZTOfX/rDLD+ZnPt4wjZZHmCzDn+P703M/F+rsjRU7rYRpifp6cJB0/Oe0NvmLjeiNK15vdmM/zqhhBNfetTH4i9J8VMAPzcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qv0p5WSSRt3Sp6uTKUXwDFp+xxw5/OdLgsrBQfVkZwc=;
 b=mmXAigbtz411fIlP5g6SrNx5b3xQ1O9SA6ck41bFP6etuCp6Dgygkvp0dXVVlZRtktG9lqEDmkwmQ69MCN2LhUnIjq0Yo8rvgSIHGhQhTGSvEoPrQlR98u2WZRoMGVrDO/wdVJhgOsNL1AOQ2X/nCzZRuZ9cOBseMDOjK7xJo1o=
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
Received: from DB8PR08MB4010.eurprd08.prod.outlook.com (2603:10a6:10:ab::15)
 by DB6PR0801MB1717.eurprd08.prod.outlook.com (2603:10a6:4:3c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38; Fri, 2 Oct
 2020 10:48:56 +0000
Received: from DB8PR08MB4010.eurprd08.prod.outlook.com
 ([fe80::2d77:cba8:3fc8:3d4f]) by DB8PR08MB4010.eurprd08.prod.outlook.com
 ([fe80::2d77:cba8:3fc8:3d4f%3]) with mapi id 15.20.3412.029; Fri, 2 Oct 2020
 10:48:55 +0000
Subject: Re: [net-next PATCH v1 3/7] net: phy: Introduce fwnode_get_phy_id()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, nd <nd@arm.com>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
 <20200930160430.7908-4-calvin.johnson@oss.nxp.com>
 <20200930163440.GR3996795@lunn.ch>
 <20200930180725.GE1551@shell.armlinux.org.uk>
 <20200930181902.GT3996795@lunn.ch>
 <20201001040016.GC9110@lsv03152.swis.in-blr01.nxp.com>
From:   Grant Likely <grant.likely@arm.com>
Message-ID: <72a8e64d-20db-ef01-e9d2-7d437eb2211f@arm.com>
Date:   Fri, 2 Oct 2020 11:48:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20201001040016.GC9110@lsv03152.swis.in-blr01.nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0062.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::26) To DB8PR08MB4010.eurprd08.prod.outlook.com
 (2603:10a6:10:ab::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.16.178] (188.30.19.167) by LNXP265CA0062.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:5d::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Fri, 2 Oct 2020 10:48:51 +0000
X-Originating-IP: [188.30.19.167]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dd98424f-586a-464c-c7d4-08d866c0c71f
X-MS-TrafficTypeDiagnostic: DB6PR0801MB1717:|VI1PR08MB3630:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR08MB363096CF11A3ADDEB5B3C38A95310@VI1PR08MB3630.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: +kpKMZg2lEsPuotVLpKNd3NfKU6j93PY3IS36T7NQm5mqBSMSMKd5fJhJ6Evc6iSKw1vlq5u9RzeRaA2ts/Q4+p4TqWRfApOpFuL25RnbSQKX/P7GbfUlUfawsg5RAo4CNqaoeX98rhmJqDxL2gtc3on3vT6GXQzwv2fjCqxucFAKfPnALOSF1cePchHXaKWmkGhFZs+dfgTgAU+9/h7rVT5bZKnLPB8FyA6VdO24IW9q9UJbXaUCqe3ZOOI3euDCaW4niRTSy2dFJnNcvA664IrdObbWfjgAcektBsLFjJyQiDbNivzuvU6YNZbhx6LLzFRwNN9zdpuhrGf8rPN2g/7c6v3mrLPC9Intun82KQ5dPP1kQ+kJk7BTpc84YEe
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB4010.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(366004)(396003)(52116002)(83380400001)(55236004)(26005)(7416002)(186003)(478600001)(16526019)(6486002)(31686004)(31696002)(5660300002)(36756003)(8676002)(54906003)(110136005)(2616005)(956004)(66476007)(16576012)(66946007)(316002)(86362001)(44832011)(8936002)(4326008)(53546011)(2906002)(66556008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: M1GKAaoE5hpzl0ra9u0uSHSqZwU2Inyd74tJNfM8cH4PqcN6LVgtidcUemWdtA5DpgNUFx1DcyS4nV9YlCRNeFjB3zF/Ts3lydYuHfDG20/VXctK9+KF6ZoLj0b7U40mfzrixxWewFSVI/ScuNkfa65fvYKFAjJ4SiZ2lz11N2aCBWfb9HG5GT30o8bkzouoZ0YzcUX8nUMskA9ilZEFuxPSLZh0i+B1+kzNuB4GT+i6mg3Du1Rpjcbr6oVZ6ykpsK6QR8wbDHDjx75KV9cn1TufLHtpJTuoDZ/zRejDv99q4e/LVhGwf/avTyVEf2GDywzW/bG9bpIsuHjXN6MIIg3w4xuRaTBQbkYFqnyqUd/5gYPJQiKwiGpkptAQuS0ZDHohGXCCBe8v/rFQrwwv4v+yA7wBNeAXhvkgIuzOIUPvN9/KBhNJkR9nQWx4ZwOlaYwd4iYjMoiWP103ZAqzGY3tUT1YKTM1zOD3+3GsAMwTkjJmXWXK93H6iT4dWGhECPjbn/9KU/fk0DozkK+M9fQs9u3C6R4udpJyofXJYMPqF7LL0uA4M04mnzcM7/IyP/pqdYs5sHlQWJHPsttMhqNZ0uSqaUZnJPtDOHisvR0TBvkcLjLJudGvvWOhNhWaqItrONQqJScNqO+VlbnhDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0801MB1717
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT013.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 35b8a635-5479-460b-6fd5-08d866c0c1a6
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J82gvFenAGMh+asPYOucqP00EM79X0rUh/vNiOZzBLmU+3rX1aZksjG6Oz5lPbYcNCFE+wObP8WZgY+wweXU7yKzMUorYM3cOywJQyDm3hUD5ba11IIEX/9ZjWPD5mtzzHbG5vew9vZ3wBL8wFd5U3uXr1GWRnDthDhKr3lYX+/KU9ZION0GkoyRRhzDuDjxJLIU5/SYvx2ovnA9w0jU+PIq1jDHXy8Lb8PHtlHfdV++fjoOOGEXpM+P/ohER2BKUP2bwgzhu6saB1P56IO8xs9BR800EWENQ8nY3UWlx+TObcCNqGuLYJa9GvfoTG2J4W2qCQyu/yqukCP2kCiLzT+oUSq/40RNWzRnMSQYLS/6uR5/B+O0hKsQMaeoSMUl6RSLUtA2uRfYuOTzl0+FpD9iHO79g47bVrxlLMYQ9HfwJ0XV658kRAZEyrmjZGDy
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(39850400004)(396003)(136003)(376002)(346002)(46966005)(53546011)(86362001)(450100002)(478600001)(36756003)(81166007)(55236004)(82310400003)(31686004)(16526019)(83380400001)(26005)(186003)(956004)(5660300002)(2616005)(54906003)(6486002)(4326008)(70206006)(70586007)(2906002)(16576012)(110136005)(44832011)(8936002)(356005)(8676002)(82740400003)(336012)(47076004)(36906005)(316002)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 10:49:03.2428
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd98424f-586a-464c-c7d4-08d866c0c71f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT013.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3630
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01/10/2020 05:00, Calvin Johnson wrote:
> On Wed, Sep 30, 2020 at 08:19:02PM +0200, Andrew Lunn wrote:
>> On Wed, Sep 30, 2020 at 07:07:25PM +0100, Russell King - ARM Linux admin wrote:
>>> On Wed, Sep 30, 2020 at 06:34:40PM +0200, Andrew Lunn wrote:
>>>>> @@ -2866,7 +2888,15 @@ EXPORT_SYMBOL_GPL(device_phy_find_device);
>>>>>    */
>>>>>   struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
>>>>>   {
>>>>> -	return fwnode_find_reference(fwnode, "phy-handle", 0);
>>>>> +	struct fwnode_handle *phy_node;
>>>>> +
>>>>> +	phy_node = fwnode_find_reference(fwnode, "phy-handle", 0);
>>>>> +	if (is_acpi_node(fwnode) || !IS_ERR(phy_node))
>>>>> +		return phy_node;
>>>>> +	phy_node = fwnode_find_reference(fwnode, "phy", 0);
>>>>> +	if (IS_ERR(phy_node))
>>>>> +		phy_node = fwnode_find_reference(fwnode, "phy-device", 0);
>>>>> +	return phy_node;
>>>>
>>>> Why do you have three different ways to reference a PHY?
>>>
>>> Compatibility with the DT version - note that "phy" and "phy-device"
>>> are only used for non-ACPI fwnodes. This should allow us to convert
>>> drivers where necessary without fear of causing DT regressions.
>>
>> Ah.
>>
>> A comment would be good here.
> 
> Sure. Will add comment.

Actually, I agree with Andrew. I don't see why new properties are being 
defined for following a reference from a property to a PHY node. This 
function shouldn't need to change at all.

g.
