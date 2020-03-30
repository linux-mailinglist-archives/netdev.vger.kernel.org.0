Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E450019767F
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 10:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729688AbgC3Ic1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 04:32:27 -0400
Received: from mail-eopbgr80050.outbound.protection.outlook.com ([40.107.8.50]:15366
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729682AbgC3Ic1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 04:32:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AbdZee9dGSFd87dmf4CBtGqzxmcfm4jdOdKZNM0i8GNCVHZXPHRAQDcXKpaOTtgWUDr8mEOghOLL7lYv1bM1PB11rCmueiONtgG1mWCM6/GxMU4YSzyVSzUt9puHpd3NKWWvOEpGY4G+AP2q7FVotrX5X+YpyFMWhvgu34VeW5rKtrAO7TaoqWEy6nBU+LxVpkZkcNyICYmK0UnwtV7q+rRlDUH24DHPYbdWg4E2n3dSYZ+SzKfRzIuFcuhy30R8D9CUSKCCvsF+AtGtst/58D4sYuU1nUlEbAO5f9kDhQfDOqXSQv/ye0CZ9UpvAikufSd9BuTQV++zfBouIspZ3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VpMTwdxRXpWS7fsiYi+1sJcRINQIu8UzZKBtSLy6nis=;
 b=iiJZPyWygB27ZwuUC46jOxC1cbF2Na9XmE+35ahaOQOS2gLWig8YZQErAYQwzyxGHbHfdgtlnmvSBeevYNRDKtw3fbIOGLt9o8zy7agdmd9hJpGqeojrJFE/jlknBYJ2UDq7Rl5a0edy2d5goCIpPDEyTD4HDhT09Q9n7Y9wW4TrrU4bbIsqw94zzAv8hZpZYrsJ7wBWPNE71wUh8OkcgbL0w3588fQyLHxOubATvP7bYK/Mp6bqf2g48k++DKFxSQz2S9nzBfVcXoDJCxcvFM4Qr22BjKgW4QzDKHEz+GFIFCxMpHEaDQ6+WNWqPhQSQVvd+81FUjZs+TKzh/2IbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VpMTwdxRXpWS7fsiYi+1sJcRINQIu8UzZKBtSLy6nis=;
 b=qB+FaX6lpfDub6dQcZh0Ev1zvaRIi8CK22OXZGL2sS0SC9fJfVwoBbA/PcKX6AIm8iFuWkeLWeFAz/z/5dWvWuAF9vKWOzolZdavRze1HwwCKUFoK4tfGb1VddoK2NzA5XjyEVcOjdtR7hEGyMrCi1kClw3yoxUdO++9HwHlCVU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3212.eurprd05.prod.outlook.com (10.170.243.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Mon, 30 Mar 2020 08:32:17 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 08:32:17 +0000
References: <cover.1585331173.git.petrm@mellanox.com> <628ade92d458e62f9471911d3cf8f3b193212eaa.1585331173.git.petrm@mellanox.com> <20200327175123.1930e099@hermes.lan>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next 1/3] tc: p_ip6: Support pedit of IPv6 dsfield
In-reply-to: <20200327175123.1930e099@hermes.lan>
Date:   Mon, 30 Mar 2020 10:32:13 +0200
Message-ID: <87eetafdki.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0094.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::35) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR01CA0094.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Mon, 30 Mar 2020 08:32:16 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c86ef847-d874-4695-4dab-08d7d484daef
X-MS-TrafficTypeDiagnostic: HE1PR05MB3212:
X-Microsoft-Antispam-PRVS: <HE1PR05MB3212BCAC7F6A0DFDD91E0EDEDBCB0@HE1PR05MB3212.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(346002)(136003)(396003)(956004)(316002)(16526019)(186003)(2616005)(81156014)(81166006)(478600001)(26005)(6496006)(6916009)(6486002)(52116002)(36756003)(86362001)(5660300002)(2906002)(4326008)(8676002)(6666004)(8936002)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qQQTNBmctkpBEWZb+1JaqRhU1g6oGNWb04zOBgb9lzZhftnqeU3+5zb8tAZRdipTTUlgVWmj+bU0G4sOgvAN8aght51JchOSkVNn5RReS8bp3R6UHKMe9iIHDC9991A1WoLznI9mIobmmcfh5/J8QTb6ozfJWN5k/w2nlaJ51hMLnhs2S1T0qWVXlmmCpWpTg+DAK2Mcbqe3KAIa+k8sLVCvD/Av4yU31EX1JjrRQfmIhwkyP4rN1U/U09kucfWoJXqPUfUYvDMH5PPytQgGg4rkdU8TW5zF9+Ipp6zxO7AUcZ1tLdVJ8602igDYanAisxn4ffAht/5UR/d+x/5iSqSMOzxeH6zq/jK/aqK/9tZ21pZEu35k3+gcue4hOVYszaL5qWkA+59/fOMnbjW2oFvtnxNbkCkzReDO1BkVyXj388VGMk6bY+NXVrMKoQ3w
X-MS-Exchange-AntiSpam-MessageData: HzoOZQaj/E1gbDTBVPBIzSLsPakynwDgBUgjaH8VTITz6ugHjlgGwRLCEDVf0Iv/A5Fhkct4XzxkWEos4QlZF4zBhGQYTXyo8SPuDjWhrFiJ8w4QZchHOCMVMARhtAX+0cvcIfQlw0oREYFZ5VZT+Q==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c86ef847-d874-4695-4dab-08d7d484daef
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 08:32:17.4169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8zuYmGxSd5yRSPJ4m2HS2jtDJWYYZEGdvvMH5zp/8How7DYRdiGBJrb2zz8D5nM8FVcN8f8+Re+U1TsgNAaHOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3212
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Stephen Hemminger <stephen@networkplumber.org> writes:

>> diff --git a/tc/p_ip6.c b/tc/p_ip6.c
>> index 7cc7997b..b6fe81f5 100644
>> --- a/tc/p_ip6.c
>> +++ b/tc/p_ip6.c
>> @@ -56,6 +56,22 @@ parse_ip6(int *argc_p, char ***argv_p,
>>  		res = parse_cmd(&argc, &argv, 4, TU32, 0x0007ffff, sel, tkey);
>>  		goto done;
>>  	}
>> +	if (strcmp(*argv, "traffic_class") == 0 ||
>> +	    strcmp(*argv, "tos") == 0 ||
>> +	    strcmp(*argv, "dsfield") == 0) {
>> +		NEXT_ARG();
>> +		tkey->off = 1;
>> +		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey);
>> +
>> +		/* Shift the field by 4 bits on success. */
>> +		if (!res) {
>> +			int nkeys = sel->sel.nkeys;
>> +			struct tc_pedit_key *key = &sel->sel.keys[nkeys - 1];
>> +			key->mask = htonl(ntohl(key->mask) << 4 | 0xf);
>> +			key->val = htonl(ntohl(key->val) << 4);
>> +		}
>> +		goto done;
>> +	}
> Why in the middle of the list?

Because that's the order IPv4 code does them.

> Why three aliases for the same value?
> Since this is new code choose one and make it match what IPv6 standard
> calls that field.

TOS because flower also calls it TOS, even if it's the IPv6 field.
dsfield, because the IPv4 pedit also accepts this. I'm fine with just
accepting traffic_class though.
