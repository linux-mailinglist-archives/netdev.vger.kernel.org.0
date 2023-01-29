Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE1667FFAD
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 15:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235033AbjA2O7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 09:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234654AbjA2O7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 09:59:15 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745261A4B5
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 06:58:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RRFc8nl+0r+f02Z6yMEciqPy7ERRXhY4+IJUHpI41pTVoiwfiINijVgwqBug+3etEDhZ0pWQRkLjCbG+AZxQ+4QLVPy3Y66Oqae44nnSoE/NgCl/3VTl6jutUFYUOZPQvNQdy/e+ufeSEK1mi+oO56H9MzoLkDInUVEaH5S0nneSat2rSnNqg+k0wkorFHAfje9gND6VvlX0takPClrj3criPl5i9XwNVXEfeOrNj8r0YnTLmAEfY3YOYZLmundDwoB01JVDS19oVNv2Pa7vXRY82IcNjyXzhBc1AOgOz9IXaLT546gu6NnijCJdxrRPly5V6ajkh/6kPXdISnwjOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nvCXA51bai7RTgTDCfRmQTygw96aM1yJ/ZWbjaaoWYQ=;
 b=TuPh6obvtPOJxmUfF/YLBA9J+cMDLwScmoMQoWx6nlAGs2WUqIWuoCken7aJClYgjENYqjnGaygCZd9nk+r4M7a+eAHqGDvPoL5iAyUauv/eHJVZzgOk8ZXVIlbF+cQIm9SROj4/Vmvu1dT7EXA5wYEATfgiXs4SA4HNrWxcVhAtdQuuRLe1dNMBCQ3/A+QNLr9L9ubBhGuozdMlcZ9IUreZ6gu6OdphdB2LHqBHUFBbnBEa5LTXO5tn7aSu21F8MMweLvWgb5MyCRjvuXXIUPTeYyZ75dhREYEx8PGitizLAPo0HADpV9CoUU4PN25XSO4nRE0WMAsNBh5s/uEsEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvCXA51bai7RTgTDCfRmQTygw96aM1yJ/ZWbjaaoWYQ=;
 b=rQS3ZJzJPw+ZpEtUETMDaCcL90CJpGCbqVjGtGBg9Vu9Q+PgFwkk/ypk6pRAwqQ2TC7CscF2iAspYNEYiyuvJXYSaumQrohXydPW0kbBpaaI5fAHS+BN+auaue7jJVyTGRUM+QdIUFsLt09f2RsPxUzY7z710KOExVRx5ZpyqxgFm+jJFJ15v7PWPeD6G1ZH/5wEpPzN84v+vLLXLuyiTix69fSotcJuLVYEqpN6kD1ExOoBFTVkwKh2xRhJTY+KOesdviMH7PFVr92mecpyyGxMBqWN+/mGQoJGIr6clQEVvJicMy1J36nNF95OLmAynx9I1XsqsVV7WIyhq+Zzow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MW4PR12MB6729.namprd12.prod.outlook.com (2603:10b6:303:1ed::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.30; Sun, 29 Jan
 2023 14:58:49 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6043.033; Sun, 29 Jan 2023
 14:58:49 +0000
Date:   Sun, 29 Jan 2023 16:58:42 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 08/16] net: bridge: Add netlink knobs for number
 / maximum MDB entries
Message-ID: <Y9aJom7VhuqY+1+X@shredder>
References: <cover.1674752051.git.petrm@nvidia.com>
 <1bb4bfeaeb14e4b484c6d71adef0b21686468153.1674752051.git.petrm@nvidia.com>
 <e46f0af5-ef19-5260-5524-e53b4e4438f1@blackwall.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e46f0af5-ef19-5260-5524-e53b4e4438f1@blackwall.org>
X-ClientProxiedBy: LO2P265CA0455.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::35) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MW4PR12MB6729:EE_
X-MS-Office365-Filtering-Correlation-Id: 434fb108-23ce-48e1-addc-08db020953f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KVJ9mPdZUo8c1f6PYCWlkL3ql1aHo1psvJMDr13ErXqZJ9kOYswxMbXDU4hsrB7fsGUmDtli2glZf6PBCB8Ls65UDBBWzqEiVAGO1rn3yagAXG0j8Y77ZG1hIpCrMxdMKJP83Oz2pcf+kB2SAsqNQ25XsbP6Dqzr9YbJAJ5TYpLs3GNPewlRie+nHAMc9AB5VOHlaPiqOFrFE2sgDuoc/kKF9mg+sq0HXUtmG4QOWBVF1lpEH/ytqRLQckN5Fs7EbmHgf9bwy9TwYNcZEP2i0ygAl64daAyKro9fZIwa2MpDplmcSTZYaY4R+vO/GYn+iWXavHTsbBFjMl95z1ZCcIYrl2KZfG8u/EiQGHh1HZMQAeN6MV0h4DLxW7/+2H1Z4GMJfSTbKwsATixnEL1N1jzSNF2MMeoRfQguD1uCT1blX6zIUZ7ZP4mrw+zomiMxW4WQ6c1vXIhvvLcZFgJH2qciILahqtgpHIVCay7M9RsQGt5JguKRUNRDi1KV0Ebm1PD4Ce8TRaYibTiKSMmZlGzpyEUbwxlTFK847jHmUySjF9zUJWtoOuPIIDYzqV5F9yrdPReXb1US4qeZelNKFmRFFlQvZbZzpM7K53FSqL/koJkDJPfmcIAOY3PzYy8a8Hn7+/tnubIJLJIBbTutIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(366004)(39860400002)(376002)(346002)(136003)(396003)(451199018)(33716001)(38100700002)(86362001)(2906002)(54906003)(6666004)(478600001)(6486002)(8936002)(5660300002)(316002)(66946007)(66476007)(6916009)(4326008)(4744005)(66556008)(83380400001)(186003)(9686003)(6512007)(26005)(53546011)(41300700001)(6506007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dEHTOgXZzrKTqa6MFeGdCOQW1TRnmKyHRHtP4ofiKhSY1zEKOCID2JZTmx0Y?=
 =?us-ascii?Q?joSjB1d7FlW3j8s0+63ut46oC4ywnZ+WeZDtyfC/HR8WM2c2+PbYPOn0x0J9?=
 =?us-ascii?Q?zZBxJjzXudwcLKzlKRWTxYUb2Mg/A00Phqf8lrajMHWCIKoOsxN3T9lpRNEM?=
 =?us-ascii?Q?jAAjAzS6K5lA2rSm5LD3fYCSowUm5vPU+jJ+ZE/S3ZnIPTGgZde3F3nPnkNF?=
 =?us-ascii?Q?qZ6BLzezg0KZpRGUBGpBq4gLXgG3FGdksQfLxEo0SElQPU8uofQ4nyzHKGvS?=
 =?us-ascii?Q?WpOpOkw6GAMyZ1LgjgYqh0mYXmhn0CCa5x2eOHZET+sozra2Wn81mWwfgkuh?=
 =?us-ascii?Q?7Ddq5hN2KtU5HVkPQQ9iYPvwlN+hWeQNs6UWZ+Bf5rn/NVnsfcGUV4UoGQTY?=
 =?us-ascii?Q?xI0TzHNklbZJT/0euFDArdcKp1lRPP3lMynP73RtL2CNthY1KMfOfOLEnIYi?=
 =?us-ascii?Q?vn0m16755sJTqSRstfh5u3zs/buEm9kRm7DAUK5lIBehoN8UvBFC+VrnFQ7P?=
 =?us-ascii?Q?vVYyOXOTdPSj95Z7vj8Xba3PBFS7JbZpPiYYb8xsVfG2Xl6ZLBM04t4anNVj?=
 =?us-ascii?Q?NYJg0M8Frp8a4fgg4zbVU2UNvHIKFQsiQzY7ilFRu0LcrFt3bxaC0JdkbOna?=
 =?us-ascii?Q?iRZ/Ss7vbbftNsIElSiKFDqgvGNyySObEsSPh1BzD0acRTfc1y2SEGv+Q5go?=
 =?us-ascii?Q?qSoA79cMQWBIUvg7GP0P4MYoO241f+gghRFx2VNOK3ltZG0BikbCCNST0soh?=
 =?us-ascii?Q?V/SFvhG28/9NU8tZ9yzk2RwAZbaR9OeIBHtLnXNUS2ki9HQneg11+ny6tL/Z?=
 =?us-ascii?Q?lihU0zLol66TyKo1SOt8gXE2bb9JDnkDJg4OWTS+b1zY2SXf8tRNQvamen4o?=
 =?us-ascii?Q?kAp6tA3Gko3BSudWH9Xkr/v7N0NtIgE24bKu/MFVxvyf2b3DSHor+EFSIDEy?=
 =?us-ascii?Q?n1ob+Yp46U5G2bYGrkEp4RFXQRKGPNCDJnNH5rZmOU7U+cLn1rbbLo/FIlB4?=
 =?us-ascii?Q?0545GiwpLr14o4HvGowXqCgO/RnyR+JwBlwlNdIRbMN3NOJssgrg1u49BgUf?=
 =?us-ascii?Q?K0PBd7c55MMQDjjzYtgKjVqM4eUBIC9AECDYnEu8vQe4SCZni4sZ1KMEhsMe?=
 =?us-ascii?Q?hz6RZYHTbXi2aS6TmAaFKYcuxMk9pNHaHJzXVdVw4qzoQpJv4ULuuheRQsje?=
 =?us-ascii?Q?Shd4/oPHcoaOf0iAFxegmcXoJd1tFWeLpoT4edLtCDd46qzTCxv/rkpx99Gt?=
 =?us-ascii?Q?gcOJRc8+tc9V8kBtlg4eNUThoaaPa1xwIConsag+6wUUMqhF4LgRKay22K4v?=
 =?us-ascii?Q?rMStUHLeBN54jcTFc7gGc3dRum87uentSiA6sqGBCKK6Ur56gIxFztOXRdIL?=
 =?us-ascii?Q?QVuvXAVU6MCd6ygo2xYlX7+cQP8V7OhstPlRAwoyrPIGJw6Rqjlg3d7b9/t9?=
 =?us-ascii?Q?ZZguGNlhvZZpy/B3nTT4S7G0+s3zliJTSirHCasuthKHcNY9z0WRXUlNLeGQ?=
 =?us-ascii?Q?EvIcgPAWuK2GTX/tTJc05NR9eTlQi1J+RWlJDcqRGfHOcpM4rM7t74gtIlAC?=
 =?us-ascii?Q?o11+0AcS8KLuki1b+f7mhukmQYBlbxiMDvjF4VBk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 434fb108-23ce-48e1-addc-08db020953f5
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 14:58:49.2595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7M1BeP0ITEWHAGezfen2rpny080x/yLGGSf2EbuwADqF4UAerkC1LMuIarzcnTQY/8ZVwQTSeUI1SLTvTSQvjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6729
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the review, Nik!

On Sun, Jan 29, 2023 at 12:07:31PM +0200, Nikolay Aleksandrov wrote:
> On 26/01/2023 19:01, Petr Machata wrote:
> > +static int
> > +br_multicast_pmctx_ngroups_set_max(struct net_bridge_mcast_port *pmctx,
> > +				   u32 max, struct netlink_ext_ack *extack)
> > +{
> > +	if (max && max < pmctx->mdb_n_entries) {
> > +		NL_SET_ERR_MSG_FMT_MOD(extack, "Can't set mcast_max_groups=%u, which is below mcast_n_groups=%u",
> > +				       max, pmctx->mdb_n_entries);
> 
> Why not? All new entries will be rejected anyway, at most some will expire and make room.

Looking at the code of the global limit ('mcast_hash_max') and also
testing it, I see that the above is not enforced there either so doing
what you suggest will at least make the port and port-vlan limits
consistent with the global limit in this regard.

> 
> > +		return -EINVAL;
> > +	}
> > +
> > +	pmctx->mdb_max_entries = max;
> > +	return 0;
> > +}
