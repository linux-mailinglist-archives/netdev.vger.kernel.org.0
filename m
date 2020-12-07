Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E052D19ED
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 20:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgLGToJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 14:44:09 -0500
Received: from mail-eopbgr80090.outbound.protection.outlook.com ([40.107.8.90]:37856
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725808AbgLGToI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 14:44:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XNHfYKNS1eUJZwxQVgQ5sFZJzBs+4/M/WIHsPgTweiATNO6kgiBEFF1KDRSmxs/d8bMBIdF35JwsTp7lqDDIxjXI8dQO0xUMzy2YvRVXNQEC0CmEq9N8/i5rf55ggNDikC1GJDjm165yL4o0MW/Gv9z13IwWUvPK8DXeM1TdgrALo5a5hHgwFVUz/n/jz2bvc5SzkdxspcjBKddil8t8gJOFA83G3n6NLwlOO7mxK9yLpHNQH5Sy9pyYLPxpyNViz4sZ/BlWXyAs/WMPNdQ52RVHq3LLqEOFxIijrvmfcrvWQfL+lFp+CLvjbMOqmNQrpGaQLhYWEUzhUjLzuO56zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRhGJ6QVF0lu6s0YkSBuGqkz4ZhDJsfXQHgQiiHFlqI=;
 b=UYiuXndxiVmZpb8wr1MK8O8PIusc5UviVJpJ8oPxnNuTQ53rER+L6Ssca7QjZ+cK2gKlGxOlKLxjH26n54CB3lywvAdxUUTBJiMEXOs3sKDMjKxoWYOv4uQtv3P7hqSgXbgqsz+wjrompj+69bYJPGfISS8VVVtFby0B/d8BKGG7QrRlM9OM2sCeqZ8p3FjQnmxhgI9wcwhbO8j1XOM0oNSzyT6XNthtMlZyQEoSD43MHovroEBJOEVxg9rZZfLh8n8sFkWnVZRMJrbIIccbI1iS1hajiX/pErEZcUJ7gvPMGXTNy0M9bLWRg5D65yp18EpG9azvu88EQVk9pE/r9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRhGJ6QVF0lu6s0YkSBuGqkz4ZhDJsfXQHgQiiHFlqI=;
 b=GfgJKFbEXjMAEGNdSUkPa59h2IbTzYODUgtnREcdTt6N0bZt1fK9bOISBp2q1WbrVahQNux9o8jtS8MW7/dZZX+Dc70smBEXFaKQijYdpGAnikwyVoVrXns0HAK05vX/I4k4u37bSg7qitWul5Ulw82ahGOADTcQ7JJpXVs/1XE=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB2721.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:124::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Mon, 7 Dec
 2020 19:43:19 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Mon, 7 Dec 2020
 19:43:19 +0000
Subject: Re: vlan_filtering=1 breaks all traffic
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
References: <b4adfc0b-cd48-b21d-c07f-ad35de036492@prevas.dk>
 <20201130160439.a7kxzaptt5m3jfyn@skbuf>
 <61a2e853-9d81-8c1a-80f0-200f5d8dc650@prevas.dk>
 <6424c14e-bd25-2a06-cf0b-f1a07f9a3604@prevas.dk>
 <20201205190310.wmxemhrwxfom3ado@skbuf>
 <ecb50a5e-45e5-a6a6-5439-c0b5b60302a9@prevas.dk>
 <20201206194516.adym47b4ppohiqpl@skbuf>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <f47bd572-7d0a-c763-c3b2-20c89cba9e7c@prevas.dk>
Date:   Mon, 7 Dec 2020 20:43:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201206194516.adym47b4ppohiqpl@skbuf>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6P192CA0096.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:8d::37) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM6P192CA0096.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:8d::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18 via Frontend Transport; Mon, 7 Dec 2020 19:43:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 474ce39f-9d54-4bd1-de3b-08d89ae85920
X-MS-TrafficTypeDiagnostic: AM0PR10MB2721:
X-Microsoft-Antispam-PRVS: <AM0PR10MB2721C8FBD7014FA0DA4110F193CE0@AM0PR10MB2721.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FgkWBgqBa/90qrw1Cd/uccfJVWM0Ol8nKhFOyrghU30sD0OCDV9p9NBHnrTdK0r0w+N9Ku+ulhUBG1i074EbShBRBb75SkmEYWoia1udqNjwf1TiHzYVTJ9ITWtsBzt0OZKpkAxGsb2AipN+VljiE9jqKXX+/redbMhJu7VcsvCn9ZGcOel+uKhXpgLt4rNWOVOF+e4+cgtzs6qlzE6EZ4p7R9PZBLtd2YK7pPvbfUpVGRL2O009vrLrslXk9T3/2qTEHWCAOfUNQsv0lQDYh4c9HApavhsMNNg2AXcQOSo6/Jjsx42OHJOPuk1NgK7BYJuEI2QCNVe+X80m2SqYnekuap5YwcuW+LmiC24l5wJqJL1lkBhhS0aDHY3nOsqYEbbfvEDm8onttkrcE4gXy1c8dbPW1gimy09+pTPW43pX9fjdoZaqm2j7or6SrkSGR+7ho1UbCDd8k2KmSNYAZGlkeo5hz4hyEoF0b92ENLbEuGsQmeoe+3cwC01Jo4cX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(39850400004)(376002)(136003)(396003)(366004)(52116002)(4326008)(86362001)(8936002)(6916009)(31696002)(5660300002)(26005)(6486002)(186003)(956004)(2616005)(2906002)(316002)(478600001)(966005)(36756003)(16526019)(8676002)(8976002)(44832011)(16576012)(83380400001)(31686004)(66946007)(66556008)(66476007)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?HF7jTal5hO287OJ8aAitChGRLBAUmeFgMWQRteOQDdOmMoleshhcUx/U?=
 =?Windows-1252?Q?whSMs0LAz4MPedyCLlaJKME3qve+GZfMSJLQHzWnMyAmi9rIaP6gz5GT?=
 =?Windows-1252?Q?MZw/UWBz4Ba+3/agsfBzLx7xvaMj/SNbkgrvfSdObNQfUcanSh6uk+Vf?=
 =?Windows-1252?Q?NSgqF87jFuHZxR4sIzo0/ObUYb5C5LcSupV/hNZTydT/f4uKzbqVlXfs?=
 =?Windows-1252?Q?x9jCzX0Y1E0EiupEnq+sFeF6n8PBjR6DxSPba2eMlw4zVcQr8ofu/chM?=
 =?Windows-1252?Q?/l3xS1bXSAxDjv9NLOMGjZA0hD2jkm5WZagSqHO11sVWl6sw834DJPT3?=
 =?Windows-1252?Q?FMalfZsaiIWoxi4ruL0Xm9S9+PPFzTrpP9tLMn2YO3oVeQ/k9syZyAMU?=
 =?Windows-1252?Q?Em4/tPme3Jcn6meoRgCtk2BlsaU86VaGKfaE5aHHdkOqmpu7T4QqxE3d?=
 =?Windows-1252?Q?aYxw/HufrkKlUBHh00ssrXamu6TiaLeV6Hd+JmTCQHB5SzukM5x75NQP?=
 =?Windows-1252?Q?Uq5XLdtb+s96hfzcKs4K/iMXb3WhgEENwdyIecyFx7YWUdYR4lCmszM0?=
 =?Windows-1252?Q?1F7ySIr4qZrUcHa+YYQiT4Fly8gaEs7aTRCxoF9OFUjs+9i204Ik/ABd?=
 =?Windows-1252?Q?KGVYMWEdhPKdp4BH+8lYy6ioD44xgXDJiq/duUZwQPP+5lIWE0ZXIHy+?=
 =?Windows-1252?Q?t5uUPhNQ0RT/p21twp7Vw53zTXww49tCrcfwr6CU7y9BZLI0Fsljcq7l?=
 =?Windows-1252?Q?XEDQzKriVe38I8Rv2acrUA3TS6vCycntKN72Lt9tsqDg3/N078hDF4Kc?=
 =?Windows-1252?Q?Clh5iJBVnb71LLYb+MDPm+azj/BuCRnNjjkIdoAnQNn/l04gqD0tXyC5?=
 =?Windows-1252?Q?7JAQXrsibpQYbNbkq6gM4A3TKzNlT+eIekGuYYeOJLcWo1BSZ9aifc0u?=
 =?Windows-1252?Q?xDu6CLOdlECHDgHPM8Xz4oN/Wv8PMp3wkixmsmQfLf4CBvhj1cp8TPaO?=
 =?Windows-1252?Q?d1E63c96WLnq1L+t7DXwbzJdXAQ35i8eQMe0qjiBccmSV+0o21pZy7L0?=
 =?Windows-1252?Q?3MnJmWYdfMWeQ01K?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 474ce39f-9d54-4bd1-de3b-08d89ae85920
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 19:43:19.3540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o9AZJbaoX/Kz4L0yS9Y+xk/A90ugcj5+6gNEmO7x2xtMfuNSlgpcvBcosoHdbZBw5VZuqw17hbkV4FNdOYRCPaqUU2VUNwnJrteI/2opa2E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2721
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/12/2020 20.45, Vladimir Oltean wrote:

> It would be interesting to see what is the ingress drop reason, if that
> could be deduced from the drop counters that are incrementing in ethtool -S.

I don't see anything obvious from running ethtool -S before/during/after
ping.

> Since you've already made the effort to boot kernel 5.9, you could make
> the extra leap to try out the 5.10 rc's and look at the VTU using
> Andrew's devlink based tool:
> https://github.com/lunn/mv88e6xxx_dump
> 
> # devlink dev
> mdio_bus/d0032004.mdio-mii:11
> mdio_bus/d0032004.mdio-mii:12
> mdio_bus/d0032004.mdio-mii:10
> # ./mv88e6xxx_dump --device mdio_bus/d0032004.mdio-mii:10 --vtu
> VTU:

Thanks for the hint. Unfortunately:

# uname -a
Linux (none) 5.10.0-rc7-00035-g66d777e1729d #194 Mon Dec 7 16:00:30 CET
2020 ppc GNU/Linux
# devlink dev
mdio_bus/mdio@e0102120:10
# mv88e6xxx_dump --device mdio_bus/mdio@e0102120:10 --vtu
VTU:
Error: devlink: The requested region does not exist.
devlink answers: Invalid argument
Unable to snapshot vtu

--atu, --global1 and --global2 does work, but the latter two say
"Unknown mv88e6xxx chip 186a" (and 186a is 6250 in hex, so I think that
should have been printed in decimal to reduce confusion). Whether that
has anything to do with --vtu not working I don't know - the global1/2
registers to seem to get printed correctly.

Rasmus
