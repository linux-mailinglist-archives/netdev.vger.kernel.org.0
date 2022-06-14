Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BC454A328
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 02:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbiFNAjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 20:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233999AbiFNAjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 20:39:54 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2047.outbound.protection.outlook.com [40.107.223.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E8A2CDD1
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 17:39:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jEJgYU/il8E4S46y+rwT7x7HEoFl7DLVJM/tUXB5y0iZHoU1QLfa/iV66jA1QRr08aSSejWjGWZ/R/zAW10q9BW1mU6RitQP97IZi3BNWcst/sEdG5axfrMrEV9qJFq/1iF2813KNtjsTG9hxGm/SxIkZl+uSohV+W/GlqNnmn0PEEJkM4UYqm0aW9HucjVVacSaaD/gfs3kfU9cCz7o2ZTt/XU9vYkvn1pzUc8vOqsa4R/qQCNn0m9clf2EEYlVWkSOAT12vMcmh6/EG8VvQivp0SJxGUhdKTjXNZYMls3k7BgSxM3oKhVJqYT5aCbOcls5I+yo0Oki89akOhx0lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0+5CJnjm+pdw/TMJKDxLz8xOvrbxrqvkq5F6iByD7wI=;
 b=Dm7OaBJcDVlAB4npt1qAPy3E5U+9HBMp7Hwt8n7InvPvtTgQ7UxDTVb66R9AcRQLPCeTxVZXtYr3PNaLTUcrpZVnwlpRsV8AqOlHlvH3+N7VLDFLQuotptSKa5/vGVVl1ynTuCg4qXh7KPt7r3gR7ayKXwnzYJZneR418SvC1Oym6VB0M5mhBJaOqQ2fRhSqtQAUoNjZvNxJY1xjhC2m21x6nBW5cIA43Xe0DbAP+D4v6jFPbCoBG5nMw54Tn5vj1gHv88WGHyzdRahnn84M1xYOVxKXRUqh0b0L6Aowuuj4ipLIa533AODkYPKDl7fqVIUG3o1XBsK5xiMREfobhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+5CJnjm+pdw/TMJKDxLz8xOvrbxrqvkq5F6iByD7wI=;
 b=p6Ci1rhWKdMGbz2kaKJR6ATNTvOyQHbb1FNqKyiWbhTYDljAYPuQarf/vcsxrgFbb3pGoeA9eU37V4Fp+F+kWr6AQkEl5TFUoWZkbhn8lW76k+zMyFILFCJyKaAhtltxB0FChCJuQRMIRBUCFE55f7x1QCTj8DHMmcWVBpxeCFoMz6juQnsjFgeSngtlONi+tXnzZSPQ6X+5lMHFJgLVs1vztnlwEo+Nl8dN+8254XPEnuI5dF87JMDaLIq2ln/nBtxxtAtKgBpN1mWmPZqK1QQEyHsARq5vRaTfA3cUv3MXJuDdEuBeyacmF0+WWUwFR3Lv00SC0CLlgiF4ZK4urg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by LV2PR12MB6015.namprd12.prod.outlook.com (2603:10b6:408:14f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Tue, 14 Jun
 2022 00:39:51 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::e1b5:e575:d59e:91aa]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::e1b5:e575:d59e:91aa%7]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 00:39:51 +0000
Date:   Tue, 14 Jun 2022 09:39:45 +0900
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Mike Manning <mvrmanning@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        Saikrishna Arcot <sarcot@microsoft.com>,
        Craig Gallek <kraig@google.com>
Subject: Re: [PATCH] net: prefer socket bound to interface when not in VRF
Message-ID: <YqfY0WifnVQf++iY@d3>
References: <cf0a8523-b362-1edf-ee78-eef63cbbb428@gmail.com>
 <YqarphOzFTnQRq29@d3>
 <cb80378b-a8da-7dea-ea71-eed25a21a345@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb80378b-a8da-7dea-ea71-eed25a21a345@gmail.com>
X-ClientProxiedBy: TY2PR02CA0040.apcprd02.prod.outlook.com
 (2603:1096:404:a6::28) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a70c0fb-ca87-4820-ac3e-08da4d9e647b
X-MS-TrafficTypeDiagnostic: LV2PR12MB6015:EE_
X-Microsoft-Antispam-PRVS: <LV2PR12MB60158E1945E87B47126FEFB3B0AA9@LV2PR12MB6015.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lydFAlwPZG0xyZvq3o9bopV6ZzGVxSWMnGrxyeOIsndMwz6lstMqsZ/ZlbdGavrFWaM9fdYdz/OlHUQgtooaxktqy8LJDAB4ggT/Ym8g1bsA2zFce+cUqM1EVC+varee1Ct/L0a8l43SWeEbaxLvozdYKvRoLnGivxQCeD7/ej9Pi3hbZ2QkU4TkoEFBv/WaUApPnZO1JPg0YWJyl26LxaUnFsPp6aB6Obq2AaK9U82dJWlNEwNSoAt2MMgZXAbUKuN/7KUJ17x8ZC1c4zLuZumZTYMx0393mLLQHC/R0jvdv+c6JfUO61RmhvI3D0Ag+54oDgvh0zjwcYxfHFINGDSuRG+6P5jl/HhEIpqCM34hxW1FJ3LzjCZmMx8u/Vd+2L0tkS0jCcc0jLiQ/l6T8rOHilO4wdgC7MyLDsjg9JCp9rI/xfEyAtAlne7i2WGmTYHUPgEe4oTIZUmzr4e74n1yaRWNozj+lckPxrO+LU2THSKxaDIkN3bAsMX1yKX/gpvV2JGq9sXSuakFNBeeoy8IEMHg6rPq4quWHZZJChSN85Yys3KhOtKgFxVMeCtYqE8ZHBfyOfw6KxLUaPHzAmGQgNfveWuyiCLnR08C/Hx4Wq6L8+XRL1aTFUOrYnmU9xgL896P76xVatfPrCDoJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(6506007)(86362001)(53546011)(5660300002)(508600001)(66946007)(9686003)(6666004)(38100700002)(6512007)(26005)(8936002)(8676002)(2906002)(54906003)(6916009)(83380400001)(316002)(33716001)(6486002)(66556008)(4326008)(186003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?juneb0kasUmNTvViPT9xOJjyaBDEb4YC47WGiT7yJwQMFxN461+a0TZyabHB?=
 =?us-ascii?Q?nlc7RUkz5oEEiR48r+bqzcL1XMynwHzMkGawzoyaRz93VL1VNPS5BZxXhqO8?=
 =?us-ascii?Q?06+HWCxdSuiB3S5XIVdMK0XhJM6ri7JBml3ZCfXRGxQLnSzgMos43LSUm+SX?=
 =?us-ascii?Q?nOMlJynuRmIeb5eOnRpOO3oMFUtQUdUIZ6LgmAZmH/MWOsEzyDLTmVM6mPIE?=
 =?us-ascii?Q?SeY1Hlc03F9w2GV+wO+utpg6ui9c/xIDy8FBEAGEK+aqVrbynt7Aaec/89vt?=
 =?us-ascii?Q?iKY2BDtbsC3Y49rBhLMNUcIAvAPMNs6ggXuK0x9vzbYCwAMCJkL53B9vJFHr?=
 =?us-ascii?Q?ODimw/JG/wCCt3T6srs1YEP8AWX8c2x6jgT4UXz8Cp1aKj5ZyK/iyiajTGT1?=
 =?us-ascii?Q?LqN1fReZ5nz9gv5vJ0o4dqcJrCjNgTB1zbiUyvLD3WINBLQ83phRDmmqEXsy?=
 =?us-ascii?Q?A5i0ysSvmRWkJ+4S4hGbRMnxjmBuAQ30T3Jm26l5EzNpjVl89Hu4z1nMATGu?=
 =?us-ascii?Q?4YQO+2bhb+ePX+Q8Oki4XEZzED8HamwEowVx3iSQcZ2pLrMmtLaRDh93BDK7?=
 =?us-ascii?Q?KXaLFY8b81D5fAjZr9vFK2I/iJNpUlupU/rO6JcAvW/0Z4byk6sD4davOhuv?=
 =?us-ascii?Q?lOKwB+vfJjOlpmXDxnBe2RFiGpepbn6kIqftw6p5lgWuG2K2ZA5NB366kg/5?=
 =?us-ascii?Q?M1SqbcFoMC5/cVe59CjdruocMvhNK4GJL8pottPlfPWXTDkb4RvRyIKOcOW+?=
 =?us-ascii?Q?woVk9opsHP1tUfgyqhiJ+oKG8N7v0um8OPWhFPMFcWC4buFmjGBqTeNRDB7z?=
 =?us-ascii?Q?5ntTJ3g92O3twBNDEYv1b0fdjnVJQForCUI7T8zYsNyKzVk9HldaDtSACV0I?=
 =?us-ascii?Q?HsR+PWoEyVUE46yFnOnvZgUPE0elnNg7oP+pTJDCiMuw3yy5/yY1W95AvSPB?=
 =?us-ascii?Q?6GVxGasnTmweFLGsvnTAdERrb524G3hcq6moEqXPGfk2BC0B8gN2RRaXMbJM?=
 =?us-ascii?Q?yQC3KvlUbc66yaWpCHzqv2Pc6OpLxISy9MFBVOfLd6NoFNe970GHZyrnMSeJ?=
 =?us-ascii?Q?2Dq6oFEMBglM19aJMjo6GN+X37B8FatexGTQ/r0DSvD2HzjgJhDhyxQQIyVz?=
 =?us-ascii?Q?neaBHS4PS571ZPxwAFOku4efG4x+RCZznxMHbM56YZgrWbUL/XNXu98O2NID?=
 =?us-ascii?Q?2aQZNyc9DSIZZJGN//LLBz8NoiIVkwOPZYFR7hvP1zSzwhxIzHM/jDXZ4x30?=
 =?us-ascii?Q?6ll10bf0iiaI7y44qbeIstmUmxM6skriBYjsxJM2lSyyGuwRgRlJMqSMxCLr?=
 =?us-ascii?Q?G3RZ/q3z3Q3YfQiJ8ex0qegQoIKmx/jdW/urF+tDFmCK/t9WRlm8mYHBPDgU?=
 =?us-ascii?Q?CG3NPwarQXXYG0y8KZpabth9jbtjWzsYOG0V66pxaqHMHuHf30TacHikOY09?=
 =?us-ascii?Q?9wZMrrxf1ysZZ+8QC5H+p7BHZLl8eW7tW7okBhJk8SMm9QgfQsW3IdCgkHzy?=
 =?us-ascii?Q?WncctlLqpHmArlBxJxz71ZePBdO0zWZVmGvEttSGWGFakuii81o7kEhggWRt?=
 =?us-ascii?Q?34b6Ct/ILXbMFIDnqgkvv+1WxwIG9FupCk83SaXYhvX+IJSZz4ry0Zxcmmpf?=
 =?us-ascii?Q?V8LdNewV+Xgo0at3jK7JgkM0nP8KK1uw05u+6ozSPyCwx9B2EkE9JxsbIQxP?=
 =?us-ascii?Q?LVeo81OcvBA8qqDdJhWm/HBOv+zQ/u8cC1Gl/1ufAk8nlF2WLkxwr5yQGZmb?=
 =?us-ascii?Q?RpLNcj0PIw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a70c0fb-ca87-4820-ac3e-08da4d9e647b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 00:39:51.4063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OZirVaaQLGecj16jIldxnA7Fa+q3ibmQrJ8IonC5GCySrch14XfyXMCYbFqP4AVfA5LhKEHLyIOfLK3HK8uljA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB6015
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-06-12 21:52 -0600, David Ahern wrote:
[...]
> > 
> > Hi Mike,
> > 
> > I was looking at this commit, 8d6c414cd2fb ("net: prefer socket bound to
> > interface when not in VRF"), and I get the feeling that it is only
> > partially effective. It works with UDP connected sockets but it doesn't
> > work for TCP and UDP unconnected sockets.
> > 
> > The compute_score() functions are a bit misleading. Because of the
> > reuseport shortcut in their callers (inet_lhash2_lookup() and the like),
> > the first socket with score > 0 may be chosen, not necessarily the
> > socket with highest score. In order to prefer certain sockets, I think
> > an approach like commit d894ba18d4e4 ("soreuseport: fix ordering for
> > mixed v4/v6 sockets") would be needed. What do you think?
> > 
> > Extra info:
> > 1) fcnal-test.sh results
> > 
> > I tried to reproduce the fcnal-test.sh test results quoted above but in
> > my case the test cases already pass at 8d6c414cd2fb^ and 9e9fb7655ed5.
> > Moreover I believe those test cases don't have multiple listening
> > sockets. So that just added to my confusion.
> > 
> > Running 9e9fb7655ed5,
> > root@vsid:/src/linux/tools/testing/selftests/net# ./fcnal-test.sh -t use_cases
> 
> use_cases group is a catchall for bug reports. You want run all of the
> TCP and UDP cases to cover socket permutations and I know some of those
> cover dual listeners (though I can't remember ATM if that is only the
> MD5 tests).

I was talking specifically about the two test cases quoted in Mike's
original posting, in case that wasn't clear.

> If not, you can add them fairly easily and illustrate your
> point.

What about reuseport_bindtodevice.c from my previous message? Running it
on the current net/master (619c010a6539) shows:

root@vsid:~# ./reuseport_bindtodevice
IPv4 TCP ... fail
IPv4 UDP unconnected ... fail
IPv4 UDP connected ... pass
IPv6 TCP ... fail
IPv6 UDP unconnected ... fail
IPv6 UDP connected ... pass
FAIL

> 
> As for compute_score, it does weight device binds a bit higher. TCP:
> 
> score =  sk->sk_bound_dev_if ? 2 : 1;
> 
> UDP:
> if (sk->sk_bound_dev_if)
>         score += 4;

I think there was a misunderstanding. A higher score does not lead to a
higher preference for a socket in many cases. That's the pitfall I tried
to describe earlier.
