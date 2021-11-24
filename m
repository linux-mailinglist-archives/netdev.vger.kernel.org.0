Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A3E45BAF9
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 13:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243052AbhKXMPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 07:15:34 -0500
Received: from mail-vi1eur05on2047.outbound.protection.outlook.com ([40.107.21.47]:12033
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243540AbhKXMOJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 07:14:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B6+Xn5FdFeKhTPqZm4fm/r+bOhYgZKKfKU3lG+2N1Wxwh4bCwoeFLYGGUEjo5fdyiCk5fgFOkHwVFHyEjEP5ktk9s7wlDjtJlufKdJXD+jGPBR9cqb9BMGASqWjFzqH/xJ4sNhDPD+hnZAvlEPWzJKYKUjmeFAked9dy6zyzhj/KOT4WERkk4eBJ6H3MfxaoUUxCae6WwH8/e1WM5jm0DQCt7QsWpvJQgIbxqITIf2k9jBa0zHcpfKeQawIUO3BD8JH1Cr8mg6+uMbivkwSdAYKQfb26dke+o1GPDPvLuXN4uOMYX7Rb5/ZMl+9po3Z7qakpFsto+EtKiHz59JwrQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IRXbpt70tOKPgumQxdZhrjzmfavf8j/Dymp12pUZu0I=;
 b=BGA5qp/u5R5IKSEaUnbFKeOI7GqUI8aculv6PPmX0BB0FHwbAPDF+kcvH3C/3llCaX/qnSEPl9Pq+bYYw/Lz3D66kA0ib19jdhC86pC+IhbZ6k+Ga6a8xzzMXa9M90O8w8+M7Cp+IAWroLCCAgckRvWTHgkubS8w/mwe7AjdUL5wpa8oq5YaS22QHIHC0/exSY5bgMCj9Ykzh7uMkzwB3hcCzb36UEVcc8uZyfjCxXcNvZHHCUhesF+GOHUHUgwihKoTquqN1nOEfofjq9TjQ7YHJic92sWlGv2Hbb/Enb0EY7zLIT+Oml1tfKQR3putUnngu3NiwllnMRJWFT4nEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRXbpt70tOKPgumQxdZhrjzmfavf8j/Dymp12pUZu0I=;
 b=SxW1vDiTmxvMpBTwgRh8YeNXfO8ZcaYeiuSTfAW5tFyfJMwia2edbAZvKXd2i1VRpWHrEmrowQYBrlSNUSvEDJJfJYBVx81XfYVaX0wGOwoRUQ1EFstqDo7Vkcn9Doxw9YwlnazriSq+xiVQk/ZXTwqCe9oco4aRv8OVaB1blvs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by DU0PR04MB9276.eurprd04.prod.outlook.com (2603:10a6:10:357::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 24 Nov
 2021 12:10:57 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::59d5:83c8:cb6a:a115]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::59d5:83c8:cb6a:a115%5]) with mapi id 15.20.4713.026; Wed, 24 Nov 2021
 12:10:57 +0000
Message-ID: <fccedd94-d2a8-ed23-852a-2432637adb12@oss.nxp.com>
Date:   Wed, 24 Nov 2021 13:10:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net] net: stmmac: Disable Tx queues when reconfiguring the
 interface
Content-Language: en-GB
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "Sebastien Laveze (OSS)" <sebastien.laveze@oss.nxp.com>,
        Yannick Vignon <yannick.vignon@nxp.com>
References: <20211123185448.335924-1-yannick.vignon@oss.nxp.com>
 <20211123200751.3de326e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211124100626.oxsd6lulukwkzw2v@skbuf>
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
In-Reply-To: <20211124100626.oxsd6lulukwkzw2v@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0025.eurprd03.prod.outlook.com
 (2603:10a6:208:14::38) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.161.68.231] (81.1.10.98) by AM0PR03CA0025.eurprd03.prod.outlook.com (2603:10a6:208:14::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Wed, 24 Nov 2021 12:10:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c15abf0-f3c0-4f57-1816-08d9af4378a7
X-MS-TrafficTypeDiagnostic: DU0PR04MB9276:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <DU0PR04MB9276557B014FE346E246DEAFD2619@DU0PR04MB9276.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eAsOj5qBDok5XlwMniJFTXc+oPPQ8lZJvazLT5WscqlOv1tHqElrKCAOyhquH4N0SShZllW7WiAKa/MH2I8HMWSRgHfwSQpj4vvYwQKqFwd5+UPs4keb2L9i48FsxJq7+ZiwaKfV0i5Ci0uxev5DkuYafCDOq2X9Yv1Q0c2yzahWdDyaZ/koLpAGtQPQjCisGmxbd0gcfCAKvnJ3HgUGuHmTXE9dOR9BOfDg6ayF4id0y1L0xPMM0PQKuG9ikS3TSEvOgZX9uqS8wxb5YZ2ZRVv0Ei6vA18MMwrTivqqWujEFkOvL7ktkLs8ZpgTA5qEIvFP5TK5Ttt7Kabhc+R1GXFPOErVkT6BuuHEhIlpkUHv0MtSKWb/0RkGXGFq9rZWRnjX9BHy7jWTxP4w9WI42EDnwY9nl1N+jiXeSxzkz6HAu4pGGy7l1pGyqsZtQsVcgEOOqynlvNLZQcsEYzpEv7xBwMVX2fF0vx1wH2ci4/2gW+Zxm+t7+y7Z9gvswdrjxcVprW6JjH78DHxqGoy8jKhkdh1w08eQai4gfo16afycva5kHAp/FAz0pgYRdweQarUvW85+0z3tnWZwa96Iqg3u3GU/q/ivc0wDLGdWN7MSQ8AZ8BX5K9M0I55pZDLxcx0RCeq+5FQj/nQ85kztKdLNVXMnxxj43l4DnLNIzyqzgdDPyRrsB91pWF0zvRzhVpriHswBT5pbKu6yYdo/O+Ewic1dJm3Llvk0z8yBm34RCckxpdjCAc928ewYgUwqaA4qbyNpVV14y7G88tdzHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(8676002)(53546011)(52116002)(83380400001)(66476007)(2616005)(16576012)(956004)(4326008)(2906002)(44832011)(86362001)(186003)(6486002)(508600001)(31686004)(31696002)(8936002)(316002)(54906003)(110136005)(38350700002)(38100700002)(26005)(66946007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHFZcDZjZThrTFhlZ1pZa1FLZnNub0pqVEJvVXN3a1Z2V2E1VTllb0Y3TEtJ?=
 =?utf-8?B?NXZtUUtsUlpBY3dKd1RjSkVlZ0VSRzFSUW1FSnMyMnF6Y0w0cFF4RlVkWjBn?=
 =?utf-8?B?eGI4SzVGcDh4ckUzNWlUOXBpR1M4TjdHTkI1VjVVbkxsOFplMENKMys2SmFn?=
 =?utf-8?B?czJGVlAvZ0lGMWlHL0QrWk8zSDhyQTBCbUw0UzBjazRnVlppYzdmL3pkY2t0?=
 =?utf-8?B?M1JRckU3bURzMHFuaVQzMWtzbGRFWndTcmtTZ2FxTWZHSHpGWkNVY1FEQ2Zv?=
 =?utf-8?B?SUJXN2dvRkxKSXBkZWNaWEVqME5SbzBESENSQjhQYnQwaGxseDF0ZE5GTmwx?=
 =?utf-8?B?enpNaEZUb0FlS1dsWlIrRGtVaGJnWjJkUWNYUzkzbnUzSG1WL0RIUVJVelRW?=
 =?utf-8?B?SFI0RG4zUXRTNndiNGQyc2RIcnYrWWNCbGRiQm14eHQwdDR5V3A4NmtQZFE0?=
 =?utf-8?B?TTExaDBpUXZBdjAyNDVodmUxdk5kZWNjWlRqM2JBWDZhL0tiOWhjS2ZUTUYy?=
 =?utf-8?B?Mnk1MnMyMU4yVjVLT3NaZ2NOaGNiVFpHMkVWTVpUMnlJSTdiYU1VSkYyNTdR?=
 =?utf-8?B?QmdTV1pzeThydDFtTEROVWkzRTVVdzZrQzZ2dHpjM0p6K2E5cTRsRDdyTEtC?=
 =?utf-8?B?UEplczh1ZDRUeEtrN2ZyTjlSb2dFWUtpUXNKRUJvTjUxWGVqZy9VdVJaY2tD?=
 =?utf-8?B?TjJ1QkFXNU94N09tcERkY3NiNHZQcFArNXJDK08vUVhHNU5wVnJBNlNISzRy?=
 =?utf-8?B?R1hFRnh2VzVZNkFJNTBFRTNLMG1XRU9BOGw1T2lSVnhPdU1zcVpjZ0RibC9Q?=
 =?utf-8?B?aXpoSTN4cGJnQWw4WjNJTmFpRVZKZHkyZU9vNnk4Q0luakVRelE2dTk0YTJX?=
 =?utf-8?B?WW5maVp6aEM3WmlCNEdoVlBkMlFaclVOUnNwdkR0NXhnQ3JZNjFDUjd1cTNX?=
 =?utf-8?B?clk1bHFKbk8zWHBidnhyZ0hPRVE5UGUwcVFUMG9WWGxpbDA5UmZNNTRhVXdQ?=
 =?utf-8?B?MG8vcjdPakRzcnNlRUNuRzA3MHplNHFmUUZkM3lnVlQrL2txMVFGMWM3T1ZP?=
 =?utf-8?B?bGx4TWFPV2NBR1picldpelJIa1BnQ25GMXVVeUh3T3FqNXhEcEl2UW9peFpP?=
 =?utf-8?B?aFF4dmN2SUx4d0pWTFVkbU55UXpDM3daUTIyLzVXaUhWSzQvSWpWZlFJcHdF?=
 =?utf-8?B?KytmNzBLTWZuWmJTeFFYZTMxTVNHVG1wRnMrUEdRdzBKQWVrNHIrS0laaGZE?=
 =?utf-8?B?WjQ1ekpCVjJJc1NNL1BvQzI4eG5wRElPT05oVzdCcDNTbUo3VzJ0dVNPdE44?=
 =?utf-8?B?Z1NBUlJEdjVMY0R4SFBWSzVmOTBCb0VRdVdZaG01Nm1wMklibEdON1FZTjNH?=
 =?utf-8?B?Q3NIdW9TazQwWGUyN3BQSk91ZnV5OWR1bVdxUWxFdlJkK1lSU3hHNCtRT1JO?=
 =?utf-8?B?bHdhS1dXcjFCck1IN0VKcTIxeEtjQnNIbExLRUFlTUZzUmV0RURrZURKRWFJ?=
 =?utf-8?B?VVptNHNNQStPeER5U1IvMnlOWlpIVmhYeUZ1emFhRGlVUWtydmUzTFFlejJ2?=
 =?utf-8?B?bHJUZllsVTkrYWNKVDBIaHVkd1FxeEhyQjdmOWJBMnB2cDFSdVNqNnptc1FS?=
 =?utf-8?B?TXpnODBCY1ZZdlMxaHJjMjVFakVSeU5uWS9aMGdpd1ArUjNEOU9WRUdRVHNn?=
 =?utf-8?B?Rk45NXNGMkNkUnBmR2NhWDlhdVk4RUgva2J3ZVByYVBWUGtVd0w0cnZ1U0Jn?=
 =?utf-8?B?VmR4R25LdDR0cFZHY1Z3KzFCYnVtRWU1aHdsUUp0cC9yWnJLQ0s2Wkp4UHNR?=
 =?utf-8?B?endKRkU1VjhCYnRoZXNCVFpmS2NERHBpMDcrM2o3TEhwNzBzc3VnelcxNWdn?=
 =?utf-8?B?NFhIbGNSNzdKRFI4cFVLR0xhbGtlMFNraDBtalc5eFA2YTZXMW9OUWw0VFF4?=
 =?utf-8?B?TGVHSkwxK3lQQ25ocXpEWFZpZEpxNkF1ZVNHMWxwdDVoZEhEenRDM3p5clhR?=
 =?utf-8?B?QXdVNVllWUNML2JzUGxuSWphZklxN3JyZ3l2RTlCVWRpbEd3VGRoMDBtalV1?=
 =?utf-8?B?MXNONVIyV2dOQTVNRE1OWGYyWWw5RThGYXdvWlFSM3pXcEF3bGNlMllzMlgz?=
 =?utf-8?B?NkJSSFVsN1RVYTJUMEtDS1ZIem5mbTE0RVIyQzg5V3JGTTA0VTdaSXptY09W?=
 =?utf-8?Q?Jg5msvoFbRiYmmC6NmuYhtY=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c15abf0-f3c0-4f57-1816-08d9af4378a7
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 12:10:57.4050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7VrU3qT/BojGtstkoJa+AfurM3bPbQj96zTHcvI/Bu3yUzdBF+Kwpg4Iki8M+USHC6OkLKWUKP9FUjFLKC7Znw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9276
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/24/2021 11:06 AM, Vladimir Oltean wrote:
> On Tue, Nov 23, 2021 at 08:07:51PM -0800, Jakub Kicinski wrote:
>> On Tue, 23 Nov 2021 19:54:48 +0100 Yannick Vignon wrote:
>>> From: Yannick Vignon <yannick.vignon@nxp.com>
>>>
>>> The Tx queues were not disabled in cases where the driver needed to stop
>>> the interface to apply a new configuration. This could result in a kernel
>>> panic when doing any of the 3 following actions:
>>> * reconfiguring the number of queues (ethtool -L)
>>> * reconfiguring the size of the ring buffers (ethtool -G)
>>> * installing/removing an XDP program (ip l set dev ethX xdp)
>>>
>>> Prevent the panic by making sure netif_tx_disable is called when stopping
>>> an interface.
>>>
>>> Without this patch, the following kernel panic can be observed when loading
>>> an XDP program:
>>>
>>> Unable to handle kernel paging request at virtual address ffff80001238d040
>>> [....]
>>>   Call trace:
>>>    dwmac4_set_addr+0x8/0x10
>>>    dev_hard_start_xmit+0xe4/0x1ac
>>>    sch_direct_xmit+0xe8/0x39c
>>>    __dev_queue_xmit+0x3ec/0xaf0
>>>    dev_queue_xmit+0x14/0x20
>>> [...]
>>> [ end trace 0000000000000002 ]---
>>>
>>> Fixes: 78cb988d36b6 ("net: stmmac: Add initial XDP support")
>>> Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
>>
>> Fixes tag: Fixes: 78cb988d36b6 ("net: stmmac: Add initial XDP support")
>> Has these problem(s):
>> 	- Target SHA1 does not exist
> 
> You caught him backporting! Although I agree, things sent to the "net"
> tree should also be tested against the "net" tree.
> 

That would be more like forward-porting in this case, since I first 
fixed the issue on an older 5.10 kernel :)
And yes, I did reproduce the bug and confirm the fix on the tip of the 
netdev branch yesterday before sending the patch. But I guess I looked 
at the wrong branch when adding the Fixes tag...

Will post a V2 to fix the Fixes tag.

