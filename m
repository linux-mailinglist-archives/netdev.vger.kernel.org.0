Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6972CFF19
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 22:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgLEVMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 16:12:31 -0500
Received: from mail-db8eur05on2114.outbound.protection.outlook.com ([40.107.20.114]:14778
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726061AbgLEVM3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 16:12:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNOXpM38zN2PyEbYq6C4Z4hXOeYJFVrhy7dOvsXedkQbdrTmMk+1sAGDvF35UvCUzVitw70DYTGxvayGUyV2UBIF0edA2NGkAsTu+b9H/LlmAXkZ0POJ7MeZq4XGj7GedQ06RgTqbrg+MQGoLLdYqyQtVD4qhZrk5jVg5khF0T3o/7fSEM1mMAdYw9Fgz8clD0usHxpVNhX4nCwo/2k72+lf3P6XfayUPovaX0NJzyvt+FtS5ThIqQSVmrxYQBsJiGWP4kJM2WeJpTdhJ2vSdyOipZwFRzDy1wJmjJ+HOJrE71yvMJSr3SjB9RDbyv4XTZeHNAfSaJhiIXaBsWYq+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jibEGfWesRCILJF8ttZUL+1XOIaY/CCWTdwGTQiCJKc=;
 b=ir3eGMaxIPjHXTZUvTNK0cx2yYcxB0Us1Jz5phFvL0Dc3jpTG2ZBJ33BGNPI5IqL0aUd4sQ+jgjShF9vuknMvwspfiVI0aX4H6sv6Ctv0AjoYzynpVwncflefODD3PdxTP716vsO9iCdV54jG2fwXkzECir5DTnNo1BnT/prG39iccOstWTqpNWM3Yosr5k384Sjav0112t7FmdGyJ4rqcvLG96hlUccAEUHxbYkSNjje91l9Wq5kGD929vM6R+5RcTzooQomBo34aFKUQp3tG6i3xSF+VjEmMla0ox+qnYiNZrpjDnVOHGV8fGUOKZtE3oA+ZqHal9xa80IHVLTzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jibEGfWesRCILJF8ttZUL+1XOIaY/CCWTdwGTQiCJKc=;
 b=JS+l9E48inDpcJXqBZJV25bcqqzFNtwB5PG6ybfHbi9bvkXFCzwqfTR25pDhX8IHiCik35MXEsVXdzIMBjITYAXWIwGQwwrkWTddA8LEBkD9Ig7H9zr+/1U27msuPxd9PQXDVgRg1687ehCqHlj2oqpZwAWSA7URtBJHXIP2Lbg=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM8PR10MB4132.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1ef::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Sat, 5 Dec
 2020 21:11:41 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 21:11:41 +0000
Subject: Re: [PATCH 00/20] ethernet: ucc_geth: assorted fixes and
 simplifications
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Qiang Zhao <qiang.zhao@nxp.com>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
 <20201205125351.41e89579@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <7e78df84-0035-6935-acb0-adbd0c648128@prevas.dk>
Date:   Sat, 5 Dec 2020 22:11:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201205125351.41e89579@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR0202CA0043.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::20) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM6PR0202CA0043.eurprd02.prod.outlook.com (2603:10a6:20b:3a::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Sat, 5 Dec 2020 21:11:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19aa5535-7dea-4354-10e1-08d899625c53
X-MS-TrafficTypeDiagnostic: AM8PR10MB4132:
X-Microsoft-Antispam-PRVS: <AM8PR10MB41329758AEB66534584EA44E93F00@AM8PR10MB4132.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Go5JcHXrUkTaIJdRKvu+m7asRYAhuDFXgw/oQbJA8gBCn7+3nChOr5Pe3Pz8/+8bZcu/fYYfeOKFxn/41OnuGEhG1Ismozh2jiiyB0wpFLCSnRVmyGtcDiMuZ88rHSY5vIYqoqkjngZcJjz/XDfPiWaomJxsEyhATKPV16ZskEGCj6bLtxqNBJcnumD9KcG0Kx8/W1ssCXuMlNOdAX+Y/Qwngdvlfu/LHzxdIcUUEAUJ7rQwsJODDuYN1qXcd5Ahz1D9yglPmzr30dp75FZ2fTvEVsO2MdC5Y3gZ1mzrm3ck4aP+3T786WhW0lsfftJNYz8Z0oPcgJy5davav3SWQ92GYnExfXoWFeG8DVpeA0mwcGHIU1ZylMH6+UiKSaa80rVngEMFF2w5GlSx0xSkwQv2y/zIFM91k/zPCPy7zYaqSejocoB4EqyPTHzbgIqr1dG2cxAAKIjiIr6nlO0wL8cRtpMYiPGXFretT1BE8ryEpuEGaDoZuN8ndLtG9NnZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(39840400004)(136003)(346002)(8976002)(8676002)(16526019)(2906002)(186003)(31686004)(31696002)(8936002)(6486002)(66946007)(44832011)(66556008)(956004)(36756003)(66476007)(478600001)(16576012)(86362001)(966005)(316002)(2616005)(26005)(83380400001)(4326008)(6916009)(54906003)(52116002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?2G1pA49A+9DnNo2lz8D1VYPf5TnFOgK7LlfpvYrtHF8/rF5cAc7Btf2q?=
 =?Windows-1252?Q?45w4MwAAzRhArqcBJEq1L5XXQtsItw0n03rIWciIyzn1Q3WvmrG3OZ1H?=
 =?Windows-1252?Q?sz6OobK+L9r6An+blUhGEbcnVyNDpEGAvdJihHQggbZxrh0deZ+0yHXd?=
 =?Windows-1252?Q?troa7y+K/kp75JItgeUlH++IwEH1giZ1P6E8Lyv2Pwu5oHx9HAVF9Zne?=
 =?Windows-1252?Q?ft5arb0+AvUxuR8WmtBX0UnBbTZ3iYqW5fGPkI1t27Jk8U4gTrIgl+pb?=
 =?Windows-1252?Q?6qHbC/n+0vGCK1PxAf1NmM1UNZeV5X2BDhMoqiRwvB1Vyt4zq6vBAN25?=
 =?Windows-1252?Q?ehMt6RwbrhWVcCqIkaKp4SZQ/QU4v+8ZAEHgsxkUxM0Xtepbe8QILtcl?=
 =?Windows-1252?Q?xkIkowAAXK7Jj0ZotWtX5sEFEUPIAqBcyBsQzV4JgD4DfGsAW5cXg8JS?=
 =?Windows-1252?Q?bQ4Q/+OoJ3LGFvFS8+qRJcUd4h2YsgkMBeZqG9G8gNf/3C1KJoG+Ip/w?=
 =?Windows-1252?Q?lXDQ+4ncHHiwHv5F9AwMmsjIr9w8Z0Sdp5Aw/MMJlHebChz4I6MQSPAY?=
 =?Windows-1252?Q?JjW1zyIpKURE00txQpJ1bqJlUXor2MzLVmzshWq6Q08yrI4Nc/CDZsLX?=
 =?Windows-1252?Q?0Yr7FxQ1I21MzlUFNa6vxd/zGC5ddnRlVR1gLxfkN+3Yiz4AETi9InaF?=
 =?Windows-1252?Q?Tg6s7c2CVTC012VBd+ZZ6VoxutDOKw1iN78fCZL4k/JGDRvCIeOD8zWu?=
 =?Windows-1252?Q?9FbztmB9bCOzgVjUdQZJoY4ZH14zoKL+gT0MF6bSklx7mrBL8mBLWjm0?=
 =?Windows-1252?Q?K7AqL45+i94pcl2SdQ96uxkMsVrDgCW6vphKIjuSzH4CskY+NWt/COnk?=
 =?Windows-1252?Q?hwweUBylULVlY4DSafzDFQc9AaDVZ/PisGdhv8wLfRoFpJ5BRHd9TvWa?=
 =?Windows-1252?Q?yws42zyQGY5LUU1BLiwDrlsoAH/duwx+LbZMr++mmxPk81WZa/HsOgOV?=
 =?Windows-1252?Q?sKQy79D/9hw//MHMaJTlcEzh0cPD2CTQNLuWyqkG/XXQO5z9Np//KXP4?=
 =?Windows-1252?Q?FM8wQkQcnIgfLu8/?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 19aa5535-7dea-4354-10e1-08d899625c53
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 21:11:41.0456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vEdadBX9Ofmzj27UYaVES2z3XejIvCyu+GlebpN+VlIDWmHjAyYCh6wQTYexqPx16L3IB0I+760+HsAkr6yJ+0sYbZTfRC9LlziyO6M1nSU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR10MB4132
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/12/2020 21.53, Jakub Kicinski wrote:
> On Sat,  5 Dec 2020 20:17:23 +0100 Rasmus Villemoes wrote:
>> While trying to figure out how to allow bumping the MTU with the
>> ucc_geth driver, I fell into a rabbit hole and stumbled on a whole
>> bunch of issues of varying importance - some are outright bug fixes,
>> while most are a matter of simplifying the code to make it more
>> accessible.
>>
>> At the end of digging around the code and data sheet to figure out how
>> it all works, I think the MTU issue might be fixed by a one-liner, but
>> I'm not sure it can be that simple. It does seem to work (ping -s X
>> works for larger values of X, and wireshark confirms that the packets
>> are not fragmented).
>>
>> Re patch 2, someone in NXP should check how the hardware actually
>> works and make an updated reference manual available.
> 
> Looks like a nice clean up on a quick look.
> 
> Please separate patches 1 and 11 (which are the two bug fixes I see)

I think patch 2 is a bug fix as well, but I'd like someone from NXP to
comment.

> rebase (retest) and post them against the net tree:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/

So I thought this would go through Li Yang's tree. That's where my
previous QE related patches have gone through, and at least some need
some input from NXP folks - and what MAINTAINERS suggests. So not
marking the patches with net or net-next was deliberate. But I'm happy
to rearrange and send to net/net-next as appropriate if that's what you
and Li Yang can agree to.

Thanks,
Rasmus
