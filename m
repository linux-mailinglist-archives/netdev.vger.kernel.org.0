Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6491323146B
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 23:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729226AbgG1VGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 17:06:18 -0400
Received: from mail-am6eur05on2046.outbound.protection.outlook.com ([40.107.22.46]:64224
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728728AbgG1VGQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 17:06:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DyOg0cE2QzRs7lBDUPqYrv/mxTo8kdAid3D4FJjOAi/0V649u/HtWEPdOypYOZTERUNlVi+/Z8UeKQSdh2dWnAQjnqepbOjgUwrhZlxVzsh3ojzjL1kssNySFFUDf8NpqA8f5pXdnK3Ku25jEife2L3FHQGOwawUyTzsh7EnjVFptN7FDWIZHeJvrhe9tIQy3qKXSFsJICXbzObSXY8bcvlvk6qsCTzM2otnQjO4DIamO4iF6bRiHqqbXzF5xMSOkWaeK/n5M8b/HcG+wlXkPurhBXeivYoA4+2lXwbiVWk1A+yemscJ9xYvCQfDTra6IUWwpvHkx/IKNu1QsC/XTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TP62k6X85u9TgqP0If3lxcuNxju//2mnEpwkrnpdEAw=;
 b=WPFYCgh4ONwcLfJNo3CZvPY1wcm1aUL5A7A3wRY5p1+Z+1EmjKwIbS1+uDNDY5SinDgMFY3cODJuDeGQg5vRs+SfIt1VNlPS/gI8v4emo66L8JyANAbP2ALJ4/NhRCuM3GDDCjDv4uIFA+laksdopc4s1E7b5WiLykGeHljQoMqqyAqpTkg9KUmwOVZIkD3x5zZlvRiFDZkMiOzVGyxPfLm1P3PVrl2fAiCjqTAy4Xfn37hOq+aczvxHkRyiIOEdsT9QSTjA9kwMtE7/vHykuMVbdub15vor/Ia1noD5z50DUDsvk9S37pWHyKnvARQoIX41JcWg86F4PZAgoiomqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TP62k6X85u9TgqP0If3lxcuNxju//2mnEpwkrnpdEAw=;
 b=LazNMbluZZ0Gg+pOtC9c4u38qwkHOqKyNjzx/IRJf6QVUXk78WkPCoHapcvI1pQmqlukXSmpoA9/SFXCJf5xUzsnnSwHlaVBRVCuAdid5JrQwqB0IMIpIVKD2ElZTZsHJoQaJ7336xwPoQOk9+/AYctJKa3O2C7/XBU0yX7ovhM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0502MB3835.eurprd05.prod.outlook.com (2603:10a6:7:84::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.30; Tue, 28 Jul 2020 21:06:12 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::56c:7b22:6d6e:ed2b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::56c:7b22:6d6e:ed2b%5]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 21:06:11 +0000
References: <20200727090601.6500-1-kurt@linutronix.de> <20200727090601.6500-5-kurt@linutronix.de> <87a6zli04l.fsf@mellanox.com> <875za7sr7b.fsf@kurt>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 4/9] mlxsw: spectrum_ptp: Use generic helper function
In-reply-to: <875za7sr7b.fsf@kurt>
Date:   Tue, 28 Jul 2020 23:06:08 +0200
Message-ID: <87pn8fgxj3.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::29) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM4P190CA0019.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 21:06:10 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d6d7eeeb-dc44-4624-4bb0-08d8333a0e52
X-MS-TrafficTypeDiagnostic: HE1PR0502MB3835:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0502MB383530992EBFCCE4BDC10C01DB730@HE1PR0502MB3835.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y4jasgffYynisiyJeZUFKBl1iwanQ+z3upSJAav/9C1xC5q2mPJFX7M2sDTgi2DoyP9tVv3EQ5NrdAqEanBRnhFNzEM4KwFpmoKK6Ry1PC9l5jS2mQBOpFfEIi706V1ga0rfHmUEZcDUTGDguWpsZgMQpDESqDOlahkFhv0mflypImI2Umo05NJx2g9zDCV1BLQNLHpzVxeyHR7IYIjHXDGDT21Pc79/ilxwvURGpgg586NUo7T7KR4t9FHHpK4Pdkx3jVz+QFHkRZN+mYB5fPlludVzH+79jPT804qHYu4b+WzMnNJ9xMekTMPxZDW0eQB0rWBjy5zKH4j55Lf73yy8ro6Lm1tA8WQM0Nq3/I1zG4GBycB9l9q/yKOEHLhmajcA7dP0YS8Fi7oEXYpqzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(52116002)(498600001)(2616005)(26005)(186003)(956004)(16526019)(54906003)(36756003)(83380400001)(66946007)(86362001)(66556008)(66476007)(4326008)(7416002)(5660300002)(2906002)(6496006)(6916009)(6486002)(8936002)(8676002)(41533002)(505234006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1vGirOjFpOLX+Q4BHkIVbdyYxsiC3EEXq+1Gdi95fCP/wfF4u0NAmdatNk1WL9AIPZLFHNQJIiC/Ezx/Dcgj60kRS3DMw0zeF4i+5+vyY+P1cTBN9L+8HkLYgsPooWfI844oK+C/DclV06k0+TJVtWxekl2eRRETKiCtAHxp49/EOWu/LmsmaRfjK2DKq7V1Dq42fo6cvfmqcRX1PNzGcNNJYuwPTBnXDp3b084iE5jIct5EMSflhBU1cQ9gRfDboNfTptDRjJQ1EZtWFGmiOMk0/OewTM9T2UyyDh5t5UacoNqdoQdJp+7H/2EK8XZKlcQ+J1mbZL96xQjNUllis5pVQeHM3MMcjYveY88L4PrVU2dSl7t1WtKQu5xl8M8y6ffGTRKcx2PyOqFk0JM+TlaKwhQiwUpiH4pqecsVOb1ZKkBB9SBtcYYWMHSwtMjXBpFwsyBpVqiu/pu6cAVJ6DSk2v90Q4NEZauB+oe3faeOocMB71Z5jRm0BynF8fun
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6d7eeeb-dc44-4624-4bb0-08d8333a0e52
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 21:06:11.6238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eS5Kk/4Htl6pLKcg6wAUjyzPipiTqViJAh4UUBkf1RJBRBCrhjezRjvfHl5REwb56tL9gC+hr4gl74LmVJXbdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0502MB3835
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Kurt Kanzenbach <kurt@linutronix.de> writes:

> On Mon Jul 27 2020, Petr Machata wrote:
>> So this looks good, and works, but I'm wondering about one thing.
>
> Thanks for testing.
>
>>
>> Your code (and evidently most drivers as well) use a different check
>> than mlxsw, namely skb->len + ETH_HLEN < X. When I print_hex_dump()
>> skb_mac_header(skb), skb->len in mlxsw with some test packet, I get e.g.
>> this:
>>
>>     00000000259a4db7: 01 00 5e 00 01 81 00 02 c9 a4 e4 e1 08 00 45 00  ..^...........E.
>>     000000005f29f0eb: 00 48 0d c9 40 00 01 11 c8 59 c0 00 02 01 e0 00  .H..@....Y......
>>     00000000f3663e9e: 01 81 01 3f 01 3f 00 34 9f d3 00 02 00 2c 00 00  ...?.?.4.....,..
>>                             ^sp^^ ^dp^^ ^len^ ^cks^       ^len^
>>     00000000b3914606: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02  ................
>>     000000002e7828ea: c9 ff fe a4 e4 e1 00 01 09 fa 00 00 00 00 00 00  ................
>>     000000000b98156e: 00 00 00 00 00 00                                ......
>>
>> Both UDP and PTP length fields indicate that the payload ends exactly at
>> the end of the dump. So apparently skb->len contains all the payload
>> bytes, including the Ethernet header.
>>
>> Is that the case for other drivers as well? Maybe mlxsw is just missing
>> some SKB magic in the driver.
>
> So I run some tests (on other hardware/drivers) and it seems like that
> the skb->len usually doesn't include the ETH_HLEN. Therefore, it is
> added to the check.
>
> Looking at the driver code:
>
> |static void mlxsw_sp_rx_sample_listener(struct sk_buff *skb, u8 local_port,
> |					void *trap_ctx)
> |{
> |	[...]
> |	/* The sample handler expects skb->data to point to the start of the
> |	 * Ethernet header.
> |	 */
> |	skb_push(skb, ETH_HLEN);
> |	mlxsw_sp_sample_receive(mlxsw_sp, skb, local_port);
> |}
>
> Maybe that's the issue here?

Correct, mlxsw pushes the header very soon. Given that both
ptp_classify_raw() and eth_type_trans() that are invoked later assume
the header, it is reasonable. I have shuffled the pushes around and have
a patch that both works and I think is correct.

However, I find it odd that ptp_classify_raw() assumes that ->data
points at Ethernet, while ptp_parse_header() makes the contrary
assumption that ->len does not cover Ethernet. Those functions are
likely to be used just a couple calls away from each other, if not
outright next to each other.

I suspect that ti/cpts.c and ti/am65-cpts.c (patches 5 and 6) actually
hit an issue in this. ptp_classify_raw() is called without a surrounding
_push / _pull (unlike DSA), which would imply skb->data points at
Ethernet header, and indeed, the way the "data" variable is used
confirms it. (At the same time the code adds ETH_HLEN to skb->len, but
maybe it is just a cut'n'paste.) But then ptp_parse_header() is called,
and that makes the assumption that skb->len does not cover the Ethernet
header.

> I was also wondering about something else in that driver driver: The
> parsing code allows for ptp v1, but the message type was always fetched
> from offset 0 in the header. Is that indented?

Yeah, I noticed that as well. That was a bug in the mlxsw code. Good
riddance :)
