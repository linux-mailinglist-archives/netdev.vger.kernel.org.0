Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E146AE707
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 17:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjCGQpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 11:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbjCGQov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 11:44:51 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05hn2203.outbound.protection.outlook.com [52.100.20.203])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663C790B76;
        Tue,  7 Mar 2023 08:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rz3X+wXleTkCiQbvfZyfYpoy4Ieqlq3bJ7erPbxbaYM=;
 b=D1hTEifu4E1ZRzYIOKKoUdIxqiKk4+fL8xBB1mk0mC1fGb8fzYJnSItEdBZ4T7wL9y/cIv8EpvPQ6evpgdeEI3OnlIpq4TyQNR/Mr+VUYy+l2nlAXGrofBovm2jou5mPmxbflnUO2h9tIwLHU8FOXRiAINK6V5XGgrCxYzitXSYvz+XwycLOkMtjay+UzTylI9vRT80bsSz8sUhQZIHw5x20yRqS+E+JZgWz3Cv94ZJnoGMgZ3BOzRTcOn+bq6+JaDk6JAVRt1LNigup2YWmZoORqvsqR0crbAoXGzgHCSPQZ1/CeIFokl1KgjgebkI0l+p+6XHBG12I1+YhUNabUg==
Received: from AS9PR05CA0071.eurprd05.prod.outlook.com (2603:10a6:20b:499::8)
 by VI1PR03MB6381.eurprd03.prod.outlook.com (2603:10a6:800:192::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.25; Tue, 7 Mar
 2023 16:41:19 +0000
Received: from AM6EUR05FT021.eop-eur05.prod.protection.outlook.com
 (2603:10a6:20b:499:cafe::14) by AS9PR05CA0071.outlook.office365.com
 (2603:10a6:20b:499::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29 via Frontend
 Transport; Tue, 7 Mar 2023 16:41:19 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 20.160.56.87)
 smtp.mailfrom=seco.com; dkim=pass (signature was verified)
 header.d=seco.com;dmarc=pass action=none header.from=seco.com;
Received-SPF: Fail (protection.outlook.com: domain of seco.com does not
 designate 20.160.56.87 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.160.56.87; helo=inpost-eu.tmcas.trendmicro.com;
Received: from inpost-eu.tmcas.trendmicro.com (20.160.56.87) by
 AM6EUR05FT021.mail.protection.outlook.com (10.233.240.237) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.16 via Frontend Transport; Tue, 7 Mar 2023 16:41:19 +0000
Received: from outmta (unknown [192.168.82.140])
        by inpost-eu.tmcas.trendmicro.com (Trend Micro CAS) with ESMTP id 3EFF92008088E;
        Tue,  7 Mar 2023 16:41:19 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (unknown [104.47.17.111])
        by repre.tmcas.trendmicro.com (Trend Micro CAS) with ESMTPS id 728C120080075;
        Tue,  7 Mar 2023 16:32:57 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UqULhQClLCyJXvJl43k0BdzMVCYE8Dr08K3AIpaYXaW5CFX3N7/G2N1BqfmnxgXf/d0++wd4BJkHruzEK3etgB44kkpXzrE2qS5f+osD58I6vo83xMNFvyBozaiyP/3JTrsGPLR3mAyj85YW8uGK4q3J1wtbOeK7rQuw36o0SldpD9YvBqWf8Ganbf/Hhli5G5LCpwQDJDoX5YTgCcQ7KZCYvcmxxHNybFh2ZIwkTtl93iqdXFDY3kcT6tFaHWyOG46MrQudNEfatkNeR1bGt+hYZBYe7q2xlHYLs9hGj0aWhpoI1RHyWW3HZ0KffGtnrlDtno9Ys+XRnHK0Rn3YXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rz3X+wXleTkCiQbvfZyfYpoy4Ieqlq3bJ7erPbxbaYM=;
 b=dXALpFVAXso2LqN1ZJScAoeieE6jD8O3i0v88nanJtBGkp/UVRv6XOm3wv4RSae++W0wAYKEZVEOvb8qMafT9PaKQLmCJfuHYZdB28QXJIejp8U3RFNUSyVQsHGRcJ5FbCBbz81LwyRqeZ8zGAmKczPiovcwjcYKfFf8SdJ0OzDPKU0mD48v7a+ErfZ63ZZcK5kG2U7DAPGA2cQj9jITiZpzQRMxRLXigMQkYiuoY7NrBTc8STvYOOc3iOwp/or75kqLG/UYWrkc0xEQ2zv4BV0Jq/EbiFU00QY3JxXcYNBJ1HQdwH5omWW9rS5lSVktrqa/wIVxLdB1yCTChCXw2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rz3X+wXleTkCiQbvfZyfYpoy4Ieqlq3bJ7erPbxbaYM=;
 b=D1hTEifu4E1ZRzYIOKKoUdIxqiKk4+fL8xBB1mk0mC1fGb8fzYJnSItEdBZ4T7wL9y/cIv8EpvPQ6evpgdeEI3OnlIpq4TyQNR/Mr+VUYy+l2nlAXGrofBovm2jou5mPmxbflnUO2h9tIwLHU8FOXRiAINK6V5XGgrCxYzitXSYvz+XwycLOkMtjay+UzTylI9vRT80bsSz8sUhQZIHw5x20yRqS+E+JZgWz3Cv94ZJnoGMgZ3BOzRTcOn+bq6+JaDk6JAVRt1LNigup2YWmZoORqvsqR0crbAoXGzgHCSPQZ1/CeIFokl1KgjgebkI0l+p+6XHBG12I1+YhUNabUg==
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by PAVPR03MB9066.eurprd03.prod.outlook.com (2603:10a6:102:323::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 16:41:09 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e%5]) with mapi id 15.20.6156.027; Tue, 7 Mar 2023
 16:41:09 +0000
Message-ID: <4249c911-91c8-5d56-78c2-460e8711456d@seco.com>
Date:   Tue, 7 Mar 2023 11:41:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next] net: mdio: Add netlink interface
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230306204517.1953122-1-sean.anderson@seco.com>
 <ZAZt0D+CQBnYIogp@shell.armlinux.org.uk>
 <537d82d4-9893-4329-874a-0a4f24af1a0d@lunn.ch>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <537d82d4-9893-4329-874a-0a4f24af1a0d@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0025.namprd13.prod.outlook.com
 (2603:10b6:208:256::30) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|PAVPR03MB9066:EE_|AM6EUR05FT021:EE_|VI1PR03MB6381:EE_
X-MS-Office365-Filtering-Correlation-Id: 2981e0af-8b8d-4910-523d-08db1f2ac72d
X-TrendMicro-CAS-OUT-LOOP-IDENTIFIER: 656f966764b7fb185830381c646b41a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: e2EPSTGLorgSZuK6BYVahPzDH+keB+cjAq6+ahag7QNur9VaeEKQNnUXhr75UnSwfSDTb2LKch/EYl34equ/GFE769+f5gnvS8aNIOIWnPe6+FMRcm4/oCVSdMS3fArrmnuq1kM1FTXtQsZ77JOIrtbpzQFT0Bz6vkp4tDZMxP/GQ+awIt4VmFsmANmYqi5zSEakIWo1/n0s5E+xaeUHf8S5heNARSmxYhbsCQQYQU6xTQ5Q28suIlGyHyli0D7XuOR7PjdjhXfodKsB8uQS/cbt2sWAltYj0G+O8iMow7yjuCLgZ1pGpnxgZgpOWEAcSP80nz7uYr8dPG2KJP9Mz0Ux6fXOuD+BdVuf6Q35KigQLU+RwOiZYPJKPC+rs3ElCEOxsxuBXBHHyN2hyODqIm8rLO4wWOk5rohQwl2FhY4v3WrarPrrkITrAk62pqc3B6ix+++EFnRH5GkKei39qqcnzcEGCBnvX7f4iK+yg4Eqi26eHKh4YSdSXDlSRdE/gbmqsl1yYVYdizDXdBapcHoLaL93BxK12HGrTS7MDWOBM7iqdtpLEu9HIxqI+W6DoUdCDAby1mKtbtZ8jC+MfBGhwOjcaklekzPmaZxTjbfMp77sG6O3V53HGwd4DYNLLPJlfEYcJTZvEmGVlZFmAS4l9CvNR0XE3P9oXFBZGzijKeXU21I5bF4F2S2sEpVylLLTE/L3FMbCapdC7SDYIZvj3m1mKzBZSxTWYPkLQTGGyMg7HjKxby+36SjN7OUawEp8N2dbgpkHXkz88zfYlQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(346002)(39850400004)(376002)(396003)(451199018)(38100700002)(31696002)(86362001)(38350700002)(5660300002)(36756003)(7416002)(44832011)(2906002)(4326008)(8676002)(8936002)(66946007)(66476007)(41300700001)(66556008)(2616005)(53546011)(186003)(83380400001)(316002)(110136005)(478600001)(54906003)(6512007)(6666004)(52116002)(6506007)(26005)(31686004)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR03MB9066
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM6EUR05FT021.eop-eur05.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 459e71eb-4066-433d-f39c-08db1f2ac0e1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0CMgbxrE2icv2QJ361veFOJktDIjpRB9bOtmgc9FmH5sTmyHr3Oz7ohX8UMgAS/hvfokvcyMMyJpCaRJCDAX5ANpewNMgK35UdGB8/J0nnxaHOd0JN+jFZQhBuTYauztsQIbhMb9HayyPjaPFsfknP+mreaOPgLLRhFto1pUe9RP1i+0Z6BV4lVnkj1ydfmCYo/Afrb6QicSAO6Xwe14dM1M/ZEZTQ7YnZkBntF2038d3Fi5yIu1KMEHwOSOJbYAdNE2PFDM3UqjUnN4c0OYYnT9/QSpuL2f+ttSfbWRrSzaZdVVJIc9rqRJ14n6sN3J0SJ3DMLAkUgNaY/5kRdzfIKUQ6ORoXMucNZa8OSVAWdfS/JlOE/Zg+qhe76kbQjvcGI3pAgGWdhbvjW/3dxjSpA/r+n1P5dlSewRl4gwZ48EZuiJZmgNe71LyoyXVavQ5LsjSsPcOhouFalDKKM6iSZtWiebL/HR1scMtVCvtfzjY4TYXvq0eFV/PgcBLDSo1c91ft9uZzmMWjaEfCxHwJYxSprqT+wRSqo0ksJNdnFKRYXD6EuuFybDR8JbGuzK5krkwIVk8lyHg2EKof5HlyCr6XscbBVHHpcYVVYwUUzUwV2odoARdeLRAaeuBZdgJbpqwZt9Ejfe0yuD9Hn7o1WBnkXJTi5eubVtaOncLevKagFFpKK9YgB3b/J3SXfF8GLnvB7YxkLAWRRAk4FnmJL/vRm0F91kbbxd4IL3ZRl7GCRnrN4kxviCs3HMKjkCMGqWP3JpNQ41Lo5Ov6+RWO7HmIblrmggCcBht6mKtl2klrSwAPr6Nkm8zPFlOtZL7mdFnnjv1aWM2SJqlicgmg==
X-Forefront-Antispam-Report: CIP:20.160.56.87;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:inpost-eu.tmcas.trendmicro.com;PTR:inpost-eu.tmcas.trendmicro.com;CAT:NONE;SFS:(13230025)(136003)(376002)(39850400004)(346002)(396003)(451199018)(5400799012)(36840700001)(46966006)(31686004)(7416002)(186003)(36756003)(82310400005)(5660300002)(2616005)(336012)(26005)(8936002)(4326008)(41300700001)(53546011)(6512007)(40480700001)(86362001)(31696002)(34020700004)(316002)(34070700002)(36860700001)(83380400001)(2906002)(44832011)(47076005)(6506007)(70206006)(8676002)(70586007)(110136005)(6486002)(6666004)(7636003)(478600001)(54906003)(7596003)(356005)(82740400003)(43740500002)(45980500001)(12100799021);DIR:OUT;SFP:1501;
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 16:41:19.3312
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2981e0af-8b8d-4910-523d-08db1f2ac72d
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bebe97c3-6438-442e-ade3-ff17aa50e733;Ip=[20.160.56.87];Helo=[inpost-eu.tmcas.trendmicro.com]
X-MS-Exchange-CrossTenant-AuthSource: AM6EUR05FT021.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB6381
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/7/23 08:47, Andrew Lunn wrote:
> On Mon, Mar 06, 2023 at 10:48:48PM +0000, Russell King (Oracle) wrote:
>> On Mon, Mar 06, 2023 at 03:45:16PM -0500, Sean Anderson wrote:
>> > +static int mdio_nl_eval(struct mdio_nl_xfer *xfer)
>> > +{
>> > +	struct mdio_nl_insn *insn;
>> > +	unsigned long timeout;
>> > +	u16 regs[8] = { 0 };
>> > +	int pc, ret = 0;
>> 
>> So "pc" is signed.
>> 
>> > +	int phy_id, reg, prtad, devad, val;
>> > +
>> > +	timeout = jiffies + msecs_to_jiffies(xfer->timeout_ms);
>> > +
>> > +	mutex_lock(&xfer->mdio->mdio_lock);
>> > +
>> > +	for (insn = xfer->prog, pc = 0;
>> > +	     pc < xfer->prog_len;
>> 
>> xfer->prog_len is signed, so this is a signed comparison.
>> 
>> > +		case MDIO_NL_OP_JEQ:
>> > +			if (__arg_ri(insn->arg0, regs) ==
>> > +			    __arg_ri(insn->arg1, regs))
>> > +				pc += (s16)__arg_i(insn->arg2);
>> 
>> This adds a signed 16-bit integer to pc, which can make pc negative.
>> 
>> And so the question becomes... what prevents pc becoming negative
>> and then trying to use a negative number as an index?
> 
> I don't know ebpf very well, but would it of caught this?  I know the
> aim of this is to be simple, but due to its simplicity, we are loosing
> out on all the inherent safety of eBPF. Is a eBPF interface all that
> complex? I assume you just need to add some way to identify MDIO
> busses and kfunc to perform a read on the bus?
Regarding eBPF over netlink, the last time this was discussed, Tobias said

> - Why not use BPF?
> 
>   That could absolutely be one way forward, but the GENL approach was
>   easy to build out-of-tree to prove the idea. Its not obvious how it
>   would work though as BPF programs typically run async on some event
>   (probe hit, packet received etc.) whereas this is a single execution
>   on behalf of a user. So to what would the program be attached? The
>   output path is also not straight forward, but it could be done with
>   perf events i suppose.

I'm not familiar enough with eBPF to comment further.

--Sean
