Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF57B3475A9
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 11:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhCXKP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 06:15:26 -0400
Received: from mail-mw2nam12on2081.outbound.protection.outlook.com ([40.107.244.81]:50785
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235599AbhCXKOx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 06:14:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bgMZxmWijv2ANDLsVWQ3710m+CVcddoBW6basd01YMtm/3WvtXDK75G6yNXZqgRc/rgmC+kemN65zoDdrw0WS45cnjmgDkUMsN7IzEsNjbiGj9OS3Iobi0FYYbkviiMLULWdBy6geBD042hizpqlXmleOS/7ZRJIPsHoxd2gA3Z5BdbKO02Culxe0lBUnyLs/lGRbpRifdAHXB+tRUFjkny0ywhT4OAaYoE6+UQpKOUM8LNreiaKYAkH9r2MEvrLDr9SQ4MsMlpSdl2btvElnZELBGKBosjxVLnEheoe8C25BU6CNIZBo7KEp+7RRp7O2sSDYf+0bey9xrclGxbekg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bWJ3WOpDeNtkig+/GI2coiulnGQ7Ls9ek23l4G8gxYc=;
 b=EahMHbi7i4cwAO64rg2jfia+xV/XovTnz0y+wYLOBuDyBJ2KYUTabeiCnZp61t2269QG6W2dGjDVZQIwio+b5bGkLtOOAczlUBTjW7RiqRjOcer27YMn52/rs4aV0f94n5ufOmvS6PtQOUfQttu2Hma84IFrm+iJ5g1Ls7SMM8OWY8zbsR1S4wH1LDMvm8QPotHqxAfG62F6NuHrgCvdTRTn/qKHKxlNDZgYDZrGXo9nstQRgsOJCLXiaZqCsymjwE7AyMDgD7wukPh1Yx8WtCytkpl4cooaInTm+AyDt6hefIOugf5LSv3bA4LU5CEDh7mrr4jnKPYUlwTQo812yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bWJ3WOpDeNtkig+/GI2coiulnGQ7Ls9ek23l4G8gxYc=;
 b=GV7D59RitNG7v8Hr+vJ8DGaHU1A83GB0JYvbFCD2gvuSlYx70+wWlI1KJE1lsTT1H+psEWmbBf38zPijBUhMJfUhYYGfm8Ey3MdQ7Z1H3IRWQQ+KQV0OCKEKL4WLblNws+e8hdRTEV02TZvjlHZr9Y3PrDKmN6+PL4LrHX+tgG+BB9XJ+lCeX0vlSmpjaOXIjrWnCT//LKjjN4ySwKhG2PUMG63ffOzerTwPQjUO1B4vmE1BMkXFKYHLzVh42BPr/uQZrXJsKVo8WsQJrir3+nvZuxG9biXc8oceCn6GRWirzH1P3XiT0hPcf91s17gnXolnBbdNeTCryOW0mITBUg==
Received: from BN6PR13CA0004.namprd13.prod.outlook.com (2603:10b6:404:10a::14)
 by CH0PR12MB5204.namprd12.prod.outlook.com (2603:10b6:610:bb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 10:14:51 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:10a:cafe::18) by BN6PR13CA0004.outlook.office365.com
 (2603:10b6:404:10a::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend
 Transport; Wed, 24 Mar 2021 10:14:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 24 Mar 2021 10:14:50 +0000
Received: from [172.27.0.48] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 24 Mar
 2021 10:14:46 +0000
Subject: Re: [RFC PATCH V4 net-next 1/5] ethtool: Allow network drivers to
 dump arbitrary EEPROM data
To:     Don Bollinger <don@thebollingers.org>,
        'Andrew Lunn' <andrew@lunn.ch>
CC:     "'David S. Miller'" <davem@davemloft.net>,
        'Jakub Kicinski' <kuba@kernel.org>,
        'Adrian Pop' <pop.adrian61@gmail.com>,
        'Michal Kubecek' <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
        'Vladyslav Tarasiuk' <vladyslavt@nvidia.com>
References: <1616433075-27051-1-git-send-email-moshe@nvidia.com>
 <1616433075-27051-2-git-send-email-moshe@nvidia.com>
 <006801d71f47$a61f09b0$f25d1d10$@thebollingers.org>
 <YFk13y19yMC0rr04@lunn.ch>
 <007b01d71f83$2e0538f0$8a0faad0$@thebollingers.org>
 <YFlMjO4ZMBCcJqQ7@lunn.ch>
 <008901d7200c$8a59db40$9f0d91c0$@thebollingers.org>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <811a3af6-84f7-6f44-68c3-eba8be06e3f4@nvidia.com>
Date:   Wed, 24 Mar 2021 12:14:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <008901d7200c$8a59db40$9f0d91c0$@thebollingers.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e51d0cf1-7d69-4e24-3cc3-08d8eeada93c
X-MS-TrafficTypeDiagnostic: CH0PR12MB5204:
X-Microsoft-Antispam-PRVS: <CH0PR12MB5204CED5206100782D36AA59D4639@CH0PR12MB5204.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TjB7bbqCzGGWXVbSNxtw/hzfD0W1xxrvZukapdlP5R85NW+5PU+Vib8QlQ+SV0q3wsr2oe2mP9EHw3GMZxJGR33K90gc15FSN9kcQbxZlx9VpRWKxOH6f9GZ55tT7OnWg5uFpOSInKX4wI7hhCxO8ID7NrkDwxBPh2yjYeETOA6oADS/GC77eC7jfdQ4gPjT6syixkHcm1eBi87rgt4mmDum0Vg9X6HFqTgQKZ9idezon5e7XfEfba6GHKvwFjVkeFuQnKRUZELh67dbgJGhVbNoYgk2bwBXig4DV2HDUYLIoEFYx1Ne5RGtvGWl0xr4mNg9xQbSJOgOoi2m2vDYPvH7rlXRp3fYeJn2bcP8xYUk/duOdwqgc5PpyMIVaWYxTjjoIfTov0nAzxp5n4mhi3No4ojM4ibjXnfpP8BOveUg47Ilu0ZCHdE8NUMidEdD8S3Pdoxs8+urTAZRlEvdIG9wi01MMWWSqK4iq2KVPBR0N/SwJZdRnFfhXpfFf4Kweyw9sRi0Fyuw9K7YQsZ1JHSHbFwqDbNodasjOdJ8+d3c13kr3ReyLO+wq5QAYhp4GEHrkwHY9zE9KpO4P5PUmwcid7BW538KNkx17PwSzzYSboIQ582QS5vDq36vf7f4r50WxIOV+m1A+xnKRPuvCrftsZGPlsq1yK/TwTX+4l/nYYVAeGIYV99H6Ef6Y+VY
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(136003)(39860400002)(36840700001)(46966006)(26005)(4326008)(186003)(70586007)(70206006)(426003)(478600001)(2906002)(8676002)(16526019)(47076005)(54906003)(86362001)(31696002)(36860700001)(2616005)(31686004)(336012)(8936002)(53546011)(36756003)(6666004)(110136005)(356005)(107886003)(82740400003)(316002)(83380400001)(82310400003)(16576012)(7636003)(36906005)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 10:14:50.7366
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e51d0cf1-7d69-4e24-3cc3-08d8eeada93c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5204
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/23/2021 7:47 PM, Don Bollinger wrote:
>>>> I don't even see a need for this. The offset should be within one
>>>> 1/2
>>> page, of
>>>> one bank. So offset >= 0 and <= 127. Length is also > 0 and
>>>> <- 127. And offset+length is <= 127.
>>> I like the clean approach, but...   How do you request low memory?
>> Duh!
>>
>> I got my conditions wrong. Too focused on 1/2 pages to think that two of
>> them makes one page!
>>
>> Lets try again:
>>
>> offset < 256
>> 0 < len < 128
> Actually 0 < len <= 128.  Length of 128 is not only legal, but very common.
> "Read the whole 1/2 page block".
Ack.
>> if (offset < 128)
>>     offset + len < 128
> Again, offset + len <= 128
>
>> else
>>     offset + len < 256
> offset + len <= 256
Ack.
>> Does that look better?
>>
>> Reading bytes from the lower 1/2 of page 0 should give the same data as
>> reading data from the lower 1/2 of page 42. So we can allow that, but
> don't
>> be too surprised when an SFP gets it wrong and gives you rubbish. I would
> The spec is clear that the lower half is the same for all pages.  If the SFP
> gives you rubbish you should throw the device in the rubbish.
>
>> suggest ethtool(1) never actually does read from the lower 1/2 of any page
>> other than 0.
> I agree, despite my previous comment.  While the spec is clear that should
> work, I believe virtually all such instances are bugs not yet discovered.


Agreed, so we will accept offset < 128 only on page zero.

> And, note that the legacy API provides no way to access lower memory from
> any page but 0.  There's just no syntax for it.  Not that we care about
> legacy :-).
>
>> And i agree about documentation. I would suggest a comment in
>> ethtool_netlink.h, and the RST documentation.


Ack, will comment there on limiting new KAPI only to half pages reading.

We may address reading cross pages by user space (implementing multiple 
calls to KAPI to get such data).

>>                   Andrew
> Don
>
>
