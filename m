Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B8A674A67
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 04:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjATD5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 22:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjATD5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 22:57:04 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B672AB2795
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 19:56:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/DA/8zR9tGlnSdsXJ/SDPR8VVr/lxwv/x0lNCZ94IewClJZUCGyv1s6EEiuhd7BZmaBHIZJxET6pjBy6SIEHyYAZ+5LHwpe6KhdjcS9FPPZIWMjZqIjzUwZEwvxFBlmr8KWL5kINkJMJ49qHitZZwcSx5tjXyINWzlb14E1Ca/e6rNb+QuJRUqgf+Vy8UinypmE5KZCFv3fY3QLB+DNaaQie5ljYL5oO3UI9+V/uzFxMzcGa8gxerxAZU/DuxkfP8u7e3EIm1QCBTbIRbtbuIzHlbIVEhwvnD95Hi6FiNAh3iOo/U29OqPhtjHaImFcY4jzq+/mwrQf+a0wu+B85A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iy+5JzNPXilwj/CGW2cWBrroOIEQ6xwntfq/hylY6lE=;
 b=HtbDXWHOWLKnJv1TKRZfHKQcizLFKUE/YOHyVwYqfgAqgqDPoQEsSS/XHJwb5PwVKitU3q89MrRZmVJCb0vAmsiyIjgZBqQFxKQ+Hz2bfSqKcw3/PzeOfxTNoPHv5PQpeksYsl3eIl6biJ5jZ8bkSnXflBEtIxnmRUjd2FWYeDb16omjVD4FlBYmdEYs8QprfxNt+ETH4097bCxFmXOiuvEC8a8JhQheD8oHypGwo7TQvQRNietb4A9p8ZdpKSQX5e8MLCLL2jXmP+pFjKe6BjiGFpq6BPIVPnKC/IOWjBkqC/3exyjUTlrfxYQkjLApbmwOHC7ny5WVBkG0RZznCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iy+5JzNPXilwj/CGW2cWBrroOIEQ6xwntfq/hylY6lE=;
 b=N2Ff0Ou8tZPNsqqHyWXWOKPCuZ5pbp9xunIrl5PZ534MP5xjU32h8pwGn2993Dw5SZZmXJfXg8+FVbStm3oP3zlAqFy/WqNsOuMAIS4NucOt/3dbYSavrqic2/zIWqOSBZZSMz/stHPTLLJZDful2O0AaBT7EzbG15QHI5rRgqGIbc2d1pS0RJ14z6b/iVftA/CTHtPFn9F2Km4HZjBc9W86csT8UIGQ4ZTGCDW+waSLA5iXdB/oP5T3meqyXvsHLr5o+wZu07SF+nnQ1e+ydBMe9lqmWP3Of3Bo8++sGesPRmcVb5cT7hFfEuiG495phaqlK47DSd4jWK5BfibLQw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by CH2PR12MB4908.namprd12.prod.outlook.com (2603:10b6:610:6b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Fri, 20 Jan
 2023 03:56:41 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab%7]) with mapi id 15.20.5986.018; Fri, 20 Jan 2023
 03:56:40 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [net-next 03/15] net/mlx5: Add adjphase function to support
 hardware-only offset control
References: <20230118183602.124323-1-saeed@kernel.org>
        <20230118183602.124323-4-saeed@kernel.org>
        <739b308c-33ec-1886-5e9d-6c5059370d15@intel.com>
        <20230119194631.1b9fef95@kernel.org>
Date:   Thu, 19 Jan 2023 19:56:24 -0800
In-Reply-To: <20230119194631.1b9fef95@kernel.org> (Jakub Kicinski's message of
        "Thu, 19 Jan 2023 19:46:31 -0800")
Message-ID: <87tu0luadz.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0028.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::41) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|CH2PR12MB4908:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d843b03-b62b-4482-13eb-08dafa9a55ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aXa2oLNbQqNb5AOXTLtLmDT3UlgppS0GJGufZhJAhuoTcz/0U7SvTO546DuqKyu3p1o6Jo1h1vGXVBO0nu6IvoH6b6SUxcobHE1rD7ulJJcFU9hICaeaC7hzQUs5BLTJrzQ2fuIpxaankzRthPekButiPdkfInx7iiuX1L61fJquzToAzuyPr9twkmP+lpgo9H9Dbiy3hSZWFPAOqIdN/d9MpCXMpgRQCqvgYV1MN6TowvVUJ8QC8oHYWEdr166eUwJZo6i8mawXsS+Cbt+A4polC0Wu4tqDMQXKDseg7M/MmbicKLLbRAYL1in5lDyMF8xU2QaU/KQMiEPs+zf6z4mLo1Wuh2vty8nfzcWiMoUCxkakTMhiffkQVNV/vWG7UBpV8yUZBge39yC454SyAw5Fl4neaJ73V1M3aatqCfO5zzjWbryfF7XOiJJypPdeXH1Ugi3ldcJJIyR23DifAXieqs3cgQKPV8MkbkcC15TlxqTIlHfFxJGYTAjtjBewFnH5giOSEeJc/qCVSLJ03KeUjhXxAnfa0OFLaq2J7OBl+kCeu+J+v+d7g203Lp3U5w1Nyv4gX7QnbhFji9M33h3YKExhZfHpbU/zlGLL1cH+ZyCmVtxkEk3XdgoYug3SIvyI6Bd1bXTdbxpMqoYbmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(136003)(39860400002)(366004)(451199015)(6486002)(478600001)(6512007)(83380400001)(186003)(316002)(2906002)(5660300002)(2616005)(66556008)(6506007)(86362001)(66476007)(36756003)(41300700001)(66946007)(38100700002)(8676002)(54906003)(6916009)(4326008)(6666004)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?soZvuMv30rI11/urjG7UmIJk5jMzflxp3TXVm9VADfHc3fmyJ7FVgwejfE/I?=
 =?us-ascii?Q?uLEAfhlKY2zh88/8VDC+foSN2RdcvWgN8uZbQBxCjFutzflIRK3NJxaSF9uF?=
 =?us-ascii?Q?TYqNbUSYcRHypBrL3f8ERlxv7GHTuLhVgt2JXpN0xOv0H6QiZQyA/iccATrd?=
 =?us-ascii?Q?DRvho7fUNwNV2w9fxEt4Yr7XJcMIuv05BdDnBJ3O6l1njRXPI23OJ/DeqpO6?=
 =?us-ascii?Q?roHPQ972biddHknSlHUSblAD+P/AwGS3I7KlOwbFiQgWvOyb+0oQkq8bMRLs?=
 =?us-ascii?Q?nhUHuBB/Z46C9A7LxdrOqquxaN766kdwkNiGNmaM9YrVVEv57xe7eOl7W3F+?=
 =?us-ascii?Q?LIv6wE3dwbo9DbE2Vi3UCjTWeTiPU5m+CYSwKvHRNMwQiqi4fIdGQnKjm+6e?=
 =?us-ascii?Q?qUKAeAZxO5S0i57MoSyIxKVBisjDWuMiH4meoZKLDQRjp2c/ZP8QxHb/RQD+?=
 =?us-ascii?Q?lfVx4j2pyL1uuJrJm7hJRcvOrziDhrOjDKqa74K7k2JRO5yOI20hg5mRc2Ma?=
 =?us-ascii?Q?ansc68CS2l4Cf4hS/JgKrE461HmIwhtHThp48ieH9FAfeUThLCGT3BByJlFz?=
 =?us-ascii?Q?ebV/C/YlKJHPt1xrmAKcOoA0dxlHjtGEgqlBMRoIwo9CWcpjAl3hei5zCwGS?=
 =?us-ascii?Q?OARse5RQmWFp6Qjaow/vyIavYvmFdcPB6Jm+jCuMZwgZ9O5kLd4aFN/YSTYn?=
 =?us-ascii?Q?742I3iHPCXe/sX6RedtRjhGoK2v59ZK5cexdxPZW9rTuKuCgpeScwdkvWfjG?=
 =?us-ascii?Q?d2q5Alj+hP2T1K4t5gGekIXxVjM8nyIU3k7gLSjDSZ1UPn0o1P5TMr3ZoU4U?=
 =?us-ascii?Q?v4+kq1TcbDzMw/yQYl3QDVHxmV+lvtKNSEukpzU667mLf/3DzAL4vd08z4hT?=
 =?us-ascii?Q?WbU8EVo7SF4hHEiWQbifwCDGCCV5CRpoOvTDBGowwY3KotGo8TS7YQ52XbOp?=
 =?us-ascii?Q?xW8wknP4NIxZn4jV40EAyM4XQ/GPmSQO77kZjjfh/PDs/8f64wiBJ01PXM5n?=
 =?us-ascii?Q?A5JhEBVffgkYZBfh3KUzT2uoTL8DFQAl03aE3xzjO2YfciVVPA5oN0dxmUW1?=
 =?us-ascii?Q?irCltTr17819mOgq0pELfUBqn5RnILw5VGSQuJO4zo/T6inQXopnpEoRhQqM?=
 =?us-ascii?Q?4Hs/Cf1n+KQry/7u/S0m0nUG8b+UdypNrwUn5XWaapS5qWRA4yPt96w5E5FB?=
 =?us-ascii?Q?iKBOthSpIySgEi2VXYUM3x9PK59x5az5TRQpDkZ1HUCTm4vIA8TGabTGWh+8?=
 =?us-ascii?Q?5BYerQUtv43ROnoC8dr3uELz62ODgiJ5XFsQAKGmU53ZmT1TkjpLYPgw9Dyh?=
 =?us-ascii?Q?y4nunmQLRDiP13AQH9CBN09vaXIKAptBJ4YmOoslzU+bgXZuTbxc3ayjkoij?=
 =?us-ascii?Q?SvsJWfYCmhrKlbamjoIxg7H9YimfJcRoWkRnZCb0YY7zYD4HPhZDoi0SBeUi?=
 =?us-ascii?Q?6jxmjnllo3e8J3j+1VXiaUGG0B7rpKLI8Cq2YLIfW72APQItFJ0Ecudvoq5R?=
 =?us-ascii?Q?V55mafyG7LI8Mc9CBfJeeUfUYKBI+74yE44FNZO/XNf9/tLBzloXeP+ULdeP?=
 =?us-ascii?Q?yr+floTXHNDq+Cejk9z7//kFI8Ngcnsu0KeeL9LQJSK0fueHy7rljGULg817?=
 =?us-ascii?Q?wa+PZTJzgqVwBN3ntDnKcXpQURj24vdc5cjaI+U+2tphdISOiPuo2x7KC0CZ?=
 =?us-ascii?Q?K+Zcug=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d843b03-b62b-4482-13eb-08dafa9a55ff
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 03:56:40.3221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OEbQvwg7AWpxsSuu0kVsBdXsBk9QXuQffwSPdmQPe55dWySSL194pneZ3v4wtaQZNmOXDiZajtbCA97RsAhLOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4908
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Jan, 2023 19:46:31 -0800 Jakub Kicinski <kuba@kernel.org> wrote:
> On Wed, 18 Jan 2023 13:33:56 -0800 Jacob Keller wrote:
>> > The adjtime function supports using hardware to set the clock offset when
>> > the delta was supported by the hardware. When the delta is not supported by
>> > the hardware, the driver handles adjusting the clock. The newly-introduced
>> > adjphase function is similar to the adjtime function, except it guarantees
>> > that a provided clock offset will be used directly by the hardware to
>> > adjust the PTP clock. When the range is not acceptable by the hardware, an
>> > error is returned.
>> 
>> Makes sense. Once you've verified that the delta is within the accepted
>> range you can just re-use the existing adjtime function.
>
> Seems like we should add a "max_time_adj" to struct ptp_clock_info
> and let the core call adjphase if the offset is small enough to fit.
> Instead of having all drivers redirect the calls internally.

With guidance from Saeed on this topic, I have a patch in the works for
advertising the max phase adjustment supported by a driver through the
use of the PTP_CLOCK_GETCAPS ioctl. This is how the ptp stack handles
advertising the max frequency supported by a driver today. In linuxptp,
this ioctl is wrapped in a function call for getting the max frequency
adjustment supported by a device before ptp is actually run. I believe a
similar logic should occur for phase (time) adjustments. This patch
would introduce a "max_phase_adj" in ptp_clock_info that would be
handled in ptp_clock_adjtime in the ptp core stack.
