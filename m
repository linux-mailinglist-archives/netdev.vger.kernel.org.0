Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2AD5392FC
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 16:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345183AbiEaOMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 10:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345026AbiEaOMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 10:12:42 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E881E3D7
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 07:12:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NQ4zPA0JmE9q0uo2/HWo+pEOsqjppkF4jZ0Z6MYIUssJLvdbdOpfwP6lr87Nc8/kwtFZjOK8lgDh1OzrdLH+XVZKKxY9tcsdRELp66jbtg5hnb0m5m8Vuw828G1Zd4QME8Fuh+jL+ojFVba/rLZULtdoQO7EoIvxaBa8Vw8nrrk3bgYTXR+Q54ciAZVW5gokHBuqroQvmpffjTs2eQqrbVXtdknxPAlJWsCJgFu/tqCHyz8T6xqex9m4yZSO+aa6OyN+kdxH/oRRtoehw0PmtIlKNziMZzMruIfg5si5YdCcFOMNmXP2bKijmvKP1f90XhW0qp+tlREU08Wg87XRvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uVKXe/Z3Bu/w/NntQEMfHJZZkC6jtqAF2Ed2XBxydRw=;
 b=LfBR8hqD4jJqeXIGtiNeppwpAufWE8Upm+F86186qK9A1m/tVbyGO5Q4l0MC1hkS8Ni6bT0RNU8NvYiz9FUXqqIjW4kW5J0KlkoyvH7UDd/85UHtBz1oyiySIot5XiuHoabsEXQG3p5ZCDzemW0cMY80UMiG+fIcqbYyNiUrsdHtfggejIktpXHp/CLo0bIo4pypqVa+LgF8ymPV2BCiTFsv20yNNk/nOiG7TI9s+nBwECebdMCy+fw/KG/qEDO9jhBgVE+lWCdDAFelY+xUteys4Ul8M0uF3MEyuhdaScBrIZyKMGXuj59epT64vXMEM5T79NC40t9Qpq4CMkFUzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uVKXe/Z3Bu/w/NntQEMfHJZZkC6jtqAF2Ed2XBxydRw=;
 b=jixfyeaY7W23I/gDynzer/O5hvKpqvNK2dSPBTlzicS2g3sT7xn7q3s6F4XGQZYo5VxQ9BOhOq3hxV7MZiQqLYXUw4GodnX1K8kdSmVGo5ajkWhDUA/XcKYR/TmoWyCZNITJV2uTBhBDLsnHy3TimMDeJCBUGGUeLyiOUfCmsRiEXNl+I6A7KLrfyzbzUt+WE/CYA5ParSQgp3SNjO0+0QH/mYzkPlbMdbDP68hmpNVR8Qd2lQ0CvQUS66uddBqc8qBBWUT7vLmzzJqCuYbSE5GRmYhZ/Qejrzm3M3wyRsXtKb3nXzF0WiUsqgGqo86wC0IyBR+cm2L29ea9MVbEag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by LV2PR12MB5968.namprd12.prod.outlook.com (2603:10b6:408:14f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19; Tue, 31 May
 2022 14:12:39 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::99d2:88e0:a9ae:8099]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::99d2:88e0:a9ae:8099%2]) with mapi id 15.20.5314.012; Tue, 31 May 2022
 14:12:39 +0000
Date:   Tue, 31 May 2022 17:12:32 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2-next] ip: Convert non-constant initializers to
 macros
Message-ID: <YpYiUJlmp0X5jH0S@shredder>
References: <7feecdf0b0354cd31de7f716e10ed122066ba061.1653996204.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7feecdf0b0354cd31de7f716e10ed122066ba061.1653996204.git.petrm@nvidia.com>
X-ClientProxiedBy: VI1PR0101CA0070.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::38) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e6a2366-70cc-44a4-fc4c-08da430f9eae
X-MS-TrafficTypeDiagnostic: LV2PR12MB5968:EE_
X-Microsoft-Antispam-PRVS: <LV2PR12MB59681A45F6108BDFC0951557B2DC9@LV2PR12MB5968.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1TViYXHDt8UnkwwUh9I7s1rRu/L4yQhe+LHviU8YOWeWOXYT5DM72El6J8Af+A+GE4AM5wHgks1U8so0imf6YGm9qNUGwHQQgFq9cAZV2ca8JRjXN+ZMK9G4GG25rnzgivoJeVKDg3S/8D/d7C3aHQpsx28I6pvyf2IJppzYhA2g/mre0vIGCFIfime15UX1xfr5YmESn9+5PFpvm6iEG+l24lqAihmSkiw201HHsapunfGk9i14/x7Un4idD6flkfYQLFtaTJ9NSX8XeQ5EjyzMPvDAg+wvQ0+cMPmfXLv72K/bzirgMD6owZ1R1ZMsn5nVt4SC3lC9xRcuAdXuSvRdl8KLZlHy93LZIhMBsRcZ/Ju+eFcKW5j//9ajbD3P1G+d+gPbUxwiL2oAcO3DT7qE5aaAATR3uaVHMBQBIsFB9VCdEpXpK9KVILg1AtHgDrdACDk1Pfcm2pxUiegSR5Ydm+Q6/qvDmfoe6Pp22elj7eQU+b9dhvQKSw5X+TgqbGt/9thdbDRTAAJ9N3A94FfwfT79iX2GqRpsj2MpfvdORqKajpWcr7GBFTTHclbqUD4Cr1NfWe+KVlrvgZfCCp5cYIpBGgv6ZAxUTscTVwjilHhmQAhgFBRiG+6yO5L7c4odl4QFEqp8chLnyLxswVmoZ9jXP5L9pgr2OC5n0i5OkAdhuTqw0bVhyDB5k4p5P7KplKGaO2nOomRFcaXnNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6636002)(6486002)(5660300002)(316002)(66946007)(38100700002)(54906003)(186003)(86362001)(6512007)(4744005)(9686003)(33716001)(66476007)(4326008)(6862004)(66556008)(8676002)(508600001)(6666004)(8936002)(26005)(2906002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hy0wc6IQ12cH6nVXXUMcU28qZHtjn0Cc5QHyiOoU5TcqYftjHaDh121p7NZU?=
 =?us-ascii?Q?p7WMpqf7NJZcOhEbPfaqqnjvvTzF8B+fHlPEOntPWnXLe5QnD9f/wcd45YVN?=
 =?us-ascii?Q?R70sHA+hGHOoEcRqoe0UCQc0NvEspoThlcJORWxXIBGY4GZTCXG/2C82mQzD?=
 =?us-ascii?Q?bn7oTudV2hOS4h1NO8ODxfrbbUyTcm3G9kcCTTId2pbrC5HEWHNMTyUVBEaz?=
 =?us-ascii?Q?tiuoxY9WNG31IMdHk7My948lIZTg7wUIF1vqzC0wqS7Eh7+OHP8oJT5uTp0R?=
 =?us-ascii?Q?3ohIjWAO7QH++O+qjtwWgrPCeHYAKyrbGqSdreBzs7ssCgT5Zy9x3IwOSo1Z?=
 =?us-ascii?Q?zHxZW9dKeRT9kUwaqWfEUdF/edIT/sAttYU9apKoSqPTZQnCk9gP65sqJ7LS?=
 =?us-ascii?Q?uKR6UcmEoRvvDrt09W9oK5PdaaEqbSno2C3NlB06RTBP9nhqrIP3n316gViZ?=
 =?us-ascii?Q?WZYdmZPx8MHuLOKCPb6or6bGzGxTEd/b6FXZTTnv6S3jZSXxcusAxPDbPw0R?=
 =?us-ascii?Q?NgBFAK6DBghNl5GPh9HUUPvwgRy2xknjygkoDuibl7OYr05btnvx0e/JWC7k?=
 =?us-ascii?Q?pF/9bgxFav7J2wxjtntlt9lD5WrEwGvceoCBbaFhK3kYOlH2IBaezFIBUsnC?=
 =?us-ascii?Q?awCtOGmyb+iSZLmen4Vyj7205SGJrjrWyNqTI4n7OiM6uHqqas3zUYm3/aJm?=
 =?us-ascii?Q?G3KpBGYv82lr5njB9AB9nD9H/s+RJWunOOE01Wl1Dp0ffCaLZMTI10uMT0VT?=
 =?us-ascii?Q?biCCGSKtfWdfwxIruAnt6tmsDyHaeiNANEL6s4DGyI5PoKrY5PvuTBEN/ZUa?=
 =?us-ascii?Q?iGP0wBHmumc/q5Hp91AoABCJopZhdppFdnoZb9O0++tGRNXPKlZ8xVtypK9t?=
 =?us-ascii?Q?qYlQC/j7Xi0PV7FXjfmvMH76LQzudik5inLpOzVQpowUn3f0yOKOxkdQeSII?=
 =?us-ascii?Q?2mgYHash8wM+Pwy48+BIUJ2b5ppYw8vPcjLJa3P5B50XxydZCVeQkafxWk1F?=
 =?us-ascii?Q?Z6N+OHiIVGg9iH7g1MYrfwKV5lU4/Q7BWbxidyAj2GwOcVs2y9nkG7OhOG0R?=
 =?us-ascii?Q?IhZp8yX+BvsvxOKWXbafrTtj/kCMWNndJUbfbdBXL/4w180KITzO/2Ip6u2l?=
 =?us-ascii?Q?QSg7gOz0Zi8HLDvhxyQJXv7qMlyssbEZxE+MQWStquyp6/mouS58imrxN8dM?=
 =?us-ascii?Q?RgDhyOz2Bfh9PDQJ0twzxijz59MWnPlHGG75fOR8OTpdsw4bEIE0lDLysxhY?=
 =?us-ascii?Q?jRehjt2qUicOVw3CByDF76bgztCkvfvIGp3YR8oiPXNapjLSbRJw+44vui3w?=
 =?us-ascii?Q?SvkoEwgOeEHTN1vKsZ//hp4Qh5kk514MLPSCLukpQK3UmPUJjc7D1dFFcngA?=
 =?us-ascii?Q?dwPf+Fh68qpXtte2Q3UOz/biRjU0hLsykejQwYlmS5LbK8s7ilscN+N9agmD?=
 =?us-ascii?Q?dIszalD4yhf5lHsbpemsTox0rsxt5iZeiBJGxkzgLGHdx9zxU0O/VFe+4CKL?=
 =?us-ascii?Q?3UhB8NpU1FE9iQzV0szgPYt2RsvR54pMimY2OC9h5aOAG8H+OvQsKJNUTg1K?=
 =?us-ascii?Q?OvPSDaTfjwVYQepsXTB3kEbU3r2GII3KpjppNcnUJi9ZYKXMYJIWQ0+Yvxox?=
 =?us-ascii?Q?7+/T/l9NOe/bJj5LBy3hdPTWrN2k1nV5KK6HxPvYUUM+xy8vknDHnMk+uQDj?=
 =?us-ascii?Q?NZM+OCJrfK943oDT76SHSZ/l2FuSWdB2REW6UT0vxtPfpjl4slHxYQiPtXgz?=
 =?us-ascii?Q?Ax06O13kBA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e6a2366-70cc-44a4-fc4c-08da430f9eae
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 14:12:39.3590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FnBoyt5cY0sI03xInUzKdxXdVX9jy3kFNRL3YQJcPEEkVtU9UVLOqvExecam35isQmiLrCJ95M9so9A4HZ+ZMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5968
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 31, 2022 at 01:35:48PM +0200, Petr Machata wrote:
> As per the C standard, "expressions in an initializer for an object that
> has static or thread storage duration shall be constant expressions".
> Aggregate objects are not constant expressions. Newer GCC doesn't mind, but
> older GCC and LLVM do.
> 
> Therefore convert to a macro. And since all these macros will look very
> similar, extract a generic helper, IPSTATS_STAT_DESC_XSTATS_LEAF, which
> takes the leaf name as an argument and initializes the rest as appropriate
> for an xstats descriptor.
> 
> Reported-by: Stephen Hemminger <stephen@networkplumber.org>
> Signed-off-by: Petr Machata <petrm@nvidia.com>

Patch is directed at iproute2-next, but code is already in main branch

Fixes: d9976d671c37 ("ipstats: Expose bond stats in ipstats")
Fixes: 36e10429dafc ("ipstats: Expose bridge stats in ipstats")
Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Fixes the build issue with clang on my laptop
