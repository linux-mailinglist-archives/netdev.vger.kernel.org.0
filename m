Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385D62FA157
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 14:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404246AbhARNYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 08:24:03 -0500
Received: from mail-eopbgr80105.outbound.protection.outlook.com ([40.107.8.105]:35748
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392191AbhARNXt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 08:23:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OLq2B2Vfs+Gq3TiSK7Ft7OxFvWodKQHpJOOu0M4gKF8AJzH63rBFHJF4DnWJY7Cj/C9vvN4ZoWOUOsTKqOdfeOI4P8htnPwS7n88ChkkIIClbnmUIkF9XJzxGAogO6m67QxxAlIc36LTiEofS5ftgo/0dFTg9+ooljujL2vIDSmcnW8SfF23XypLUZkTGiww6TvOYLpGKTUB3eqZWjqsvcDfOs3tgH67MXUCTsIJ0i92tTx4crSf/RYbV5UtxNbRb5SiaXvo3JMyuhBT2AMFhoV3057TzYx3SmsI5hN7X50AeyWXzT+tUM/pjJfKXUNH07QfWFVUrY7vfxDFbo54ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eUW3I0JLqCf9tcor3awEHAGicbJjQv5aLhYNuHJHeLo=;
 b=YAf23i1upAizxvreZcLB0vFYETEiwF+CVlhUyp6jO09u/zf+D/iW+fuYs0WOirKPmRQvSVlvsvumIvaI2cpfvVpaypQ0WHPu8spgOFb4BRkqBatzyZ3e7NLZnmTTOPwpJrkuIYy6WMcgdcklTrXVRM2xBmDmofGLtCdBP8HEavLAj+dOaqP6QH1XSOm7AgV8tgAiA/+aWg1sCj/qj+MC2FVpUEndYYDdIPmMBY9tUjQozdiXTXw0WaJQ0Ro4PkXrP5QgJIlw2TlLkLF5nnYXua/4SPZyjvxWPH3bj4sslodNbnZxEFbMtY/wCUHxYucU4d84wrJYSBizkdG7jtrmVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eUW3I0JLqCf9tcor3awEHAGicbJjQv5aLhYNuHJHeLo=;
 b=OYQSNxRYoUtH5njti0DtvnAnAI886S9Zs1FHWhwcctv3vDBguBVDfdoWl/zOCNzFsehRkfjAP7rW2vu3f60c/GP1OXMqDRXeHNzgmffoKg+4l3ma3R5maOsrT2HHcIQn75LBHAJk5Q4Yyde3wcC0zf57a1fPlHwz4UcS5CPtMww=
Authentication-Results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM9PR10MB4404.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:26f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Mon, 18 Jan
 2021 13:23:00 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 13:22:59 +0000
Subject: Re: [PATCH 0/2] net: dsa: mv88e6xxx: fix vlan filtering for 6250
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20210116023937.6225-1-rasmus.villemoes@prevas.dk>
 <20210117210858.276rk6svvqbfbfol@skbuf>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <97021b7f-d1d9-b33f-f6ef-de3df83c17e5@prevas.dk>
Date:   Mon, 18 Jan 2021 14:22:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210117210858.276rk6svvqbfbfol@skbuf>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR08CA0009.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::21) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM6PR08CA0009.eurprd08.prod.outlook.com (2603:10a6:20b:b2::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Mon, 18 Jan 2021 13:22:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5861ab3-444a-4ab7-2e95-08d8bbb42c8f
X-MS-TrafficTypeDiagnostic: AM9PR10MB4404:
X-Microsoft-Antispam-PRVS: <AM9PR10MB4404B614A4D3A605B1A3132A93A40@AM9PR10MB4404.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z2K6cxKwwSI9mZFgppPIqKzmkVRcFdGLaM+2KAb96uDSdFWqhnMaZkY3MGXCIyHc+5J+/lMzM7WRob7R7Ol328IE4yqsGlzXGpGPu4HcdWRiFkDr2J8hqRx1RJWwCpK3fss0z1CnC7kEvyDFmR6tllHxKL8MQEXE/AzsN8zgT9rpFEvaBFwrbM7U6ugj0LFcpYl+kAMKvpjNBwruzKtrfHdGBlzGd/gC2EPbMk41PwNwOc+KJReeeT+M2A3waVQlzF61weSsNtqH55tixnzXjyvCdgod0/1G7pP365+DazsIRAIN/4EQkLUtQZw8Va5buq1LtJUADVvfY5r57d6CaPW8rlYqpU82iNL3LcU9bXE2/Lrzn8dzI8xmh8lChRe6hrbaFKzXcZsrn06//zA+/SKQbvCKgwEl4kOfzTIEBGoOcsG8KL4TfC76Wh0WuAZPLCBKn9ninXu7QOAPNuHvW4T7egPNMug7tDv/8hiI8CE+1JRDvT3Bm0zWCDP9fK2ZXZFtsewAh2fKXWi5K3KQg6ixCu02elqiUbPsAEJED15lsrj210E0CtdVR3Dj/sYJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39840400004)(396003)(86362001)(26005)(54906003)(316002)(6486002)(7416002)(66476007)(66556008)(16576012)(36756003)(52116002)(8976002)(8676002)(966005)(83380400001)(31686004)(8936002)(478600001)(2616005)(44832011)(4326008)(6916009)(31696002)(5660300002)(66946007)(16526019)(186003)(2906002)(956004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?z3Sn2HEx5rX/6jd/ew2YS/DAdEuLl1fPJg6v10Irmu7k2PUB3ITYXWnF?=
 =?Windows-1252?Q?e+3mY8P/KttTJ5Ot7+CxeZtodxGCGOgs6eua7bm8hqCT9kD1GpqCMrAg?=
 =?Windows-1252?Q?rwMHaSQEguAfmc1cKnvpMhPDhPq7A5LI+waiYAJje9gZ1l39VX9PKw4b?=
 =?Windows-1252?Q?tqxA6IBDfglOAYnfyEoZbDuwGNbImlykcSdRI4mo2b/ArjSqky+cxFbe?=
 =?Windows-1252?Q?0fyfSkXILCEBv4cv6uj9/YYJ8RsHGIHPEKWKI6fqrfsZCUQS4EqeZ+Sz?=
 =?Windows-1252?Q?N8pkj7/oA/xcY+fauY07hUSWu55hKSNb6YX+p8oIcxlZMLqHutwDE0cx?=
 =?Windows-1252?Q?7QPmcb+DfNQCl5ArqEp/uCiaOgz3QV1EpP2z71O06IuWXr6dWyJ1W0fN?=
 =?Windows-1252?Q?yX6+Lo6fjXMV0ye+nDdBMzoWGWoTF/umoL3ewaoXa/J0CJqtr0jI+EkG?=
 =?Windows-1252?Q?rcOa5rhvJYTZVoBEkA/JTExsHCzW/PE1VC4t8I20GpUN5ZmfdZERFa88?=
 =?Windows-1252?Q?qbpeX4YVWQvtTj/HCDRl6K0rf54k+DSA7nfxcxiFS7wGsksPO/nSiVbS?=
 =?Windows-1252?Q?zCgp2u4IHB7/14mMDPtx5B8SscIytS472DGbZQB7ke+A2vrtflzqQFnM?=
 =?Windows-1252?Q?sHiUSs4tAeyKpFvqhtPBIfeltxd5IJTMpwmWWnLRmXNiumr03GpTggWo?=
 =?Windows-1252?Q?RLUt4lJ1Hk3Sxz155W0I8GKcXDc0jHuaiFL3hiP/lRdwfpKleveRG4tD?=
 =?Windows-1252?Q?Z/nQ60gkA+yeB66a0Tnz4aXCZl6j5/w+6GMj6eJwDG/1q66Nl/1r5Pv7?=
 =?Windows-1252?Q?F9m8yBN0JjnNbMZdq29xynzWsMNUVzy06N+ExKVMwQmJ0jEbjwjl8tcp?=
 =?Windows-1252?Q?PuP5ArgXdGDqqSxN4yczyjpcHL9nbCIauRt++7QJ6hU19LEMp5NbNr4b?=
 =?Windows-1252?Q?Ae0ul0QqlP7aaCtKZJ+ySfr2zCDrPHBL8TCssOq6k9E1VfEl1mQOhJg8?=
 =?Windows-1252?Q?vG9bWcbStf5CMjMI8JxwPZAMSkb9hlhL045rObX8gajTgEMDa+Ex1MYJ?=
 =?Windows-1252?Q?/dneNN796eR/rsDS?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: a5861ab3-444a-4ab7-2e95-08d8bbb42c8f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 13:22:59.0182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zEDEYyHI8hCUhu3sFwj9ONgvwp0MKHEbFiAxZuJ1RoRN/FdQ+/VnSZH2zvKIyZ/Tjd+lsDxIfNxp/RYDzqOoat9ntOXzE/5muapMj4ZzcBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR10MB4404
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/01/2021 22.08, Vladimir Oltean wrote:
> Hi Rasmus,
> 
> On Sat, Jan 16, 2021 at 03:39:34AM +0100, Rasmus Villemoes wrote:
>> I finally managed to figure out why enabling VLAN filtering on the
>> 6250 broke all (ingressing) traffic,
>> cf. https://lore.kernel.org/netdev/6424c14e-bd25-2a06-cf0b-f1a07f9a3604@prevas.dk/
>> .
>>
>> The first patch is the minimal fix and for net, while the second one
>> is a little cleanup for net-next.
>>
>> Rasmus Villemoes (2):
>>   net: dsa: mv88e6xxx: also read STU state in mv88e6250_g1_vtu_getnext
>>   net: dsa: mv88e6xxx: use mv88e6185_g1_vtu_getnext() for the 6250
> 
> It's strange to put a patch for net and one for net-next in the same
> series. 

Well, maybe, but one is a logical continuation of the other, and
including the second one preempted review comments saying "why don't you
merge the two implementations".

> But is there any reason why you don't just apply the second patch to
> "net"?

That's not really for me to decide? I thought net was just for the
things that needed fixing and should be sent to -stable - which is the
only reason I even split this in two, so there's a minimal logical fix
for the 6250. Otherwise I'd just have squashed the two, so that I don't
add lines only to delete them, along with the rest of the function, later.

Jakub, David, it's up to you.

Rasmus
