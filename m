Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E2C56468D
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 12:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbiGCKCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 06:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiGCKCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 06:02:46 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFA79FEA;
        Sun,  3 Jul 2022 03:02:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UWfD5K7RGaEZfmxkoCAjiQ3kktXv0d/pw9xf+bBVdikq6iH09hyjeebi058H+95W27fA9Xq6hAMJmRpQSfhZEqp5AwgQHTcuS/HCMh95uAnFLqR/sdNbLPNC/dmQC417Nt6EkMGkvxKY2tVAHFj17nixd8jifnhqqFqL72h5jvY1TnjsAQaFFThHitrJa8BQT/2NE6qUPkfj3eIpe+x4JUNxq9EKdhSMKakWJq0x31pFLl+9etkRKRBYVivu6WhoPfFz4I11ELERZHR5lAcgmdpjBNQOOaJ5QDrjWG3wEKXRmCbQHFZnIZmQJDeLPLCJUVqpCMCRTNdS3HUtws6fcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dyq/dw11B6m2VDVMQGtXSHtRaYtS5lusBJRjuQNnNIw=;
 b=DG8TzqCfsGMz/kPYLxQvAVh1drrXOyWgEB8DB46vmkB56YOfcHiuhtcVVAMq5ULIRCqHwyV4mEY7k8+Vxtyae8t1rYbxqxm1BeQwmRjr+oYo6n295bzAsWGitkjpDzA11ONjOaeOTf4PLWiWYN9l4LrM8ro0rKBUY4afdZMAZVcdRrimY76YJV5QuLbVTcJvbEMhL8op5pn71IRCsvDHRRXNDQF02x8Mw79HGQU8SWDCCf4lmlzLIJIHjd6vDbLNsVz1WbILZO4kQ6hqAW0HdwqIcjtrK+VdOy9JmO+AeWjnViOipcbL/+XRcPIKnIibOycOLIrM0yh0zut1RDUJBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dyq/dw11B6m2VDVMQGtXSHtRaYtS5lusBJRjuQNnNIw=;
 b=sUdKwwGaM81rQ6HVC64sQlJNg3oqpgw/ixPTrRHccokEAPXoV5rj4J+D59E7Cv8OYer/4CEzsa1EsZLIcvmY7GGp2e5GgTr1cl0w7SgPIFkuyEU3z3FTLPLc9GK6shY/hbqqH1j3viSgp1rtIBW5wvgb4AgxlCoJASMOyCJCReA46XTTW3FmjPCqoXRs1i7ZH8a2y/MInbUaEk8spBrBID8MiqHCarVjgxlaT9ccER9R6PjLf53OswHDGyQIGBQXqj/WQNAEYUiSm5DvFu013WSO//0ACB8IkGHUA/i1pnUv7CfOeal2r8E8+yRT3viJjypJC0fEiiTZEWY64158qQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN6PR12MB1778.namprd12.prod.outlook.com (2603:10b6:404:106::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Sun, 3 Jul
 2022 10:02:42 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%7]) with mapi id 15.20.5395.018; Sun, 3 Jul 2022
 10:02:42 +0000
Date:   Sun, 3 Jul 2022 13:02:36 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Petr Machata <petrm@nvidia.com>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net 1/3] selftests: forwarding: fix flood_unicast_test
 when h2 supports IFF_UNICAST_FLT
Message-ID: <YsFpPKyeUt26UPw4@shredder>
References: <20220703073626.937785-1-vladimir.oltean@nxp.com>
 <20220703073626.937785-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220703073626.937785-2-vladimir.oltean@nxp.com>
X-ClientProxiedBy: LO4P123CA0572.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::22) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbbfce3b-b003-42d0-6a2f-08da5cdb2b75
X-MS-TrafficTypeDiagnostic: BN6PR12MB1778:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JqPo0F4cnWwhewbnyy9ZjLxkx5rNGSsT0DfmZShow9703kn4kCpHljIjDEdq/Y6zD7sc7vu4HLHzKT37X14gluAhpYzhmxaoykfg1/Gr2YL17gMReiaM6kj5G9Mt7slvycD1iugsaPhZNr7wiBSYDSgX4fXqxnUfh3j8bE90Dv1BxOyhwDGVZ06zBblYyJnktqT8HQHQeeajUDFoZCqZJ/i7eIKqbilhu8Gin81kwX8GZLUgZf0yWexw/wTfaZPnSVRZrWPPtEplr1eMe5JV6lYlAn+o4Ld/ToTmIkg3qyIaOiSiAKPCcN45p5isg2duFa3sO6BiE3qr2ESzWTcv9G8sKKZ0XNqnxpzjcq9oC9GEBIp7YBNGnMuBRygFcSA8aq4TRJIx7xORdZiDdKnUsxzBTWTcAYVOofm2kkmhKgYyBuX86dTf7t7+y2bYkil3zPw/JC5rzJx3II4kYLwvoFfiZ/VxGV/CgkHMyvTxd9wA/xlmilgVta/V+7/rxk+i3UwqvXua7V2YxG2fDO9AtgQV8OBQFhkCxIq+MItvD+TCn4vovs6wwbejB7+uvf6c9u4A3yOK2K5WrT9JVaOOA3c0XyH66YLIAfiwtEJaJWD9uPxT79Ilg60j60hsIYP2Bgg5oZM7+ol8ace3D2ww3FWWX4T3vID6Y3jlfhSSyWVfCEX3ROdz0HZi6MosmM3zZRTLR0RKiePimm3FSDVfXRcgrKgZQkga0EwJQpMUoVKJFRQujruMcPuBDVxfT+Em1PG1LSkDk2nUN0f88qShOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(83380400001)(41300700001)(5660300002)(478600001)(6666004)(8936002)(2906002)(6486002)(6916009)(54906003)(33716001)(316002)(186003)(38100700002)(66946007)(66556008)(66476007)(4326008)(8676002)(6506007)(26005)(6512007)(9686003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QnLtB2muM9CLk/DK35EOiRDeGpUH51PrD55ByCee2yoDBcyojdPFDRZKIigI?=
 =?us-ascii?Q?FKoSZVP3VigHoUElN8SUBtNQjIXBxrD1PgWGuiHSB7TymSinl+Tx0pZSXeEY?=
 =?us-ascii?Q?cgF6A3Qr5iIfZnr79+5sJ8jfxpA2UlKCwlivCgONPUenz8HWJ9orMSKf/YfT?=
 =?us-ascii?Q?MHCF7hnjooUpRqt2PzcRfExp9vZQsDTh732e+8Y+BVQTF0eJv4RB+qv7ZD9z?=
 =?us-ascii?Q?xa3LH6W2zq+OFwyZ7X4AKHT7nZSvGiNP4oIznE4wAhGgKKr3WW1x2rLESU+6?=
 =?us-ascii?Q?/O4SLxcZnl9XZ9zSCjpXzO+flxB/ezGkqOdhz65M7EYho0Mb9pvLWriWj6uf?=
 =?us-ascii?Q?5YRgYhXHAxIZiDwkPQImQDzv1g8j3Lz1JoWzQEZhNysLAzf9xgkQNmu1KNqk?=
 =?us-ascii?Q?QQtSvcQ9Ypi92pPJqaPseChfkMtzbCqITiP4f31zEn3E0KGGes+Fppg0fB02?=
 =?us-ascii?Q?7pnBn1s4sNtqDlEbbpO5mZa3ZXmNz3VwlqDZgDMUncqMFOfn0EBJpu2S/NGY?=
 =?us-ascii?Q?1RlmJnKZ72pPxwjdif6OTIg170/a82/vhptqHKt9PiOkXCpRrK1hmom7hO9s?=
 =?us-ascii?Q?ftkdui/ntcBLZ8Rpr2VCzjOAxLMOwxKnsmGA0UztXMD9V1vXkVCZjpgk/oJj?=
 =?us-ascii?Q?WYZN9UYcATrvQxDohgxv3UzRkT+v4Vfr5IhaNRlPyrdBUXMd+XSlQRg+sfkT?=
 =?us-ascii?Q?z0jd3ZUmaT8vXNjh+mnFWl3/04I24dvxhFdVSnp9RJ6aXLsXnXv6qFcw8Ro7?=
 =?us-ascii?Q?kYeGjOuwpTMuRNqEphR40vl++I2qw0BoZa+0rD2EaQK3fb0+j2nUoVrxB+77?=
 =?us-ascii?Q?q5jhxbuQw72jPpJ4tkl3X6UOyNx5SprEuWQoS+It8Vn/4mMXw5WDyIO5xpvU?=
 =?us-ascii?Q?Y9/z28SIYax+lB10k6CkYoyKsG/iLjr/+pbFFD1ldo01HTrtfuEHzx/Cd3Hm?=
 =?us-ascii?Q?XKhDxR+6FoVJ+nf7+n7miar+nlkUc48RGwXsWxlfjXzf1uVJ3PnzNElaCZKU?=
 =?us-ascii?Q?Cqi3625r415iuUsQ4GYp44cYDSDRVFGlhH8BEdfJ18xkfWA/0651ahoDzlRd?=
 =?us-ascii?Q?WGxLUH+SMA+F1t1zTLtiK3g6V9+d+Wk+NGegQwuh3wuMfxCmI73c5B6BxBWa?=
 =?us-ascii?Q?/cXz2Pp+aG+fD65jX2rh6AB9lYBhMy1lqA6Ys+Y6Id9/GRVS8EvIDLYJzF/6?=
 =?us-ascii?Q?C7t3WslQbmf2P8UXumCNvBYU1ypUyz19FNVjjISP1XqKg8O65Korkq13afQP?=
 =?us-ascii?Q?oSywt8VVVyLmKAygGEhG7dia2fyVsnRzI+Yc63ODzoGa4PaBHut+L8IK6n/y?=
 =?us-ascii?Q?uDKWaCQ5HY/jzeW8V2g/bHAr2VKZeyDbDCGjNsW0n/j0pDktBnpNz95Kh0k4?=
 =?us-ascii?Q?UFOTB+haVV+cRtz2aEryTvY2IyykBqaH1D8f+bkEOO93bMlcJOzmr/Yl6JFJ?=
 =?us-ascii?Q?62DjSQKAaktrlU4ixL0CHU6/BeTBXGlnscxMgZH87gHhhky8i0+RLjQE6A+U?=
 =?us-ascii?Q?LnWkf089Yr+QvlEQUkembcQdPm76KhMIQ3FVGJ6mD8/2utIvqJpn5GG8nZZZ?=
 =?us-ascii?Q?ov6WFEBcPgzhijZWW/dHcYqUgM4DxM0DsMxjXHtS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbbfce3b-b003-42d0-6a2f-08da5cdb2b75
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2022 10:02:42.4304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3fLn7hGAkhRKm/Q4BXwmjRA2y0VvjVY5h6jVexiRdAPb8l7TQVY9AMkY2oWaChaTOQRhZf9GbDVnQJbFMGAXBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1778
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 03, 2022 at 10:36:24AM +0300, Vladimir Oltean wrote:
> As mentioned in the blamed commit, flood_unicast_test() works by
> checking the match count on a tc filter placed on the receiving
> interface.
> 
> But the second host interface (host2_if) has no interest in receiving a
> packet with MAC DA de:ad:be:ef:13:37, so its RX filter drops it even
> before the ingress tc filter gets to be executed. So we will incorrectly
> get the message "Packet was not flooded when should", when in fact, the
> packet was flooded as expected but dropped due to an unrelated reason,
> at some other layer on the receiving side.
> 
> Force h2 to accept this packet by temporarily placing it in promiscuous
> mode. Alternatively we could either deliver to its MAC address or use
> tcpdump_start, but this has the fewest complications.
> 
> This fixes the "flooding" test from bridge_vlan_aware.sh and
> bridge_vlan_unaware.sh, which calls flood_test from the lib.
> 
> Fixes: 236dd50bf67a ("selftests: forwarding: Add a test for flooded traffic")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
