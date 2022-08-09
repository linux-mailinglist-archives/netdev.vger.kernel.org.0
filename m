Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B18A258D6C0
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 11:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239906AbiHIJuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 05:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239837AbiHIJuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 05:50:15 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2044.outbound.protection.outlook.com [40.107.94.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86063BA8
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 02:50:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hFDWEct1FPcK1pO7nCrHUyWFYbb3ttkopectTsTAmgD3Jd3dgcEPF8k4QQ6unjJeUI1Xelk6t1I8gg5eqhee+A12aknXg1qzJzJsCqc0qVYL6Egku/qX+cP1fGpqw2hvFR/6F/UCjHLgVmrVGf021/cMyqIUPL9QDz03BWdMkUKjCAXGTDJUYCo3TbUPZimkWtdugqLp/bT9ivxXNF8qJmuYHksCjBQdFGWEzUgnn7CkxiAIO7DdwnkBRWob45ls1/ITjsfpoiAaqV+0Fi6yR4KuU1F0hIOq7/T8RC+mTub45HQ6XYgaHvqLFbG44H48ZIkn5VHJS2IcgdBdT2qm0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OtKyH25xOFsABryTZ5uBbD7g56mSpR/aOFf/Y+Su99M=;
 b=K921D+6WqYGVROe+wqJXgCFPNENklN63fUbfnn5Oe42e5idnBdth5gyYl0eNvx/t62epHAuHU4wRh383JqbVjM+sJQMiSZRAwlDYuJh9pDSfPC8NB2Mm8Hik7x4hkd+Xop7FqXAPQEFdyPJV8XRDqzzo0RRQd/y4RMyoGkejclgX3Hu49ehMrZRdAIiY8p07GJ6ErnoHg+Ssi9DDAXPR6vuZewj5HINcwcU4KzppTFCg9P6EovCcfHoNKZu1jAhjChNhZQZZ/3g8rEFbq9cUa/DPlQ3h5RjuCTOzEO/NyAfODHsnv1Tu2ROmQ7WCmW37ZkDAgp2kXNeenwqYFzP7Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OtKyH25xOFsABryTZ5uBbD7g56mSpR/aOFf/Y+Su99M=;
 b=o4PvqBikzt3c0/cOmiKj+hklG5/akNz8haEL5IWdWJw7aiRGn6JiHAt8QrNFbdQtQu3UQ8NJsY5Rwy88qoWpeQDiytMVX2KLIcl2WpVQoILeI2d/AKzRjYUmibBHjVQtiBswuVI80BAG1XLrmfm+THdTWWA4EybzFXMRvV7HzA84Tvtvqv4waNHvMoQSHVpe1qwjf74lDQQXLUdp7xy+hwiUJn8iXLYe1mTEP9OnWRn4eCzdpSVFviws632NhDyGkKny+0SMV/BzDRGLRcsC4qb6MvJZmjeVQX+N5rTfWql3/5yJ6+1VGZ9JGwvdppfuEHV7KJCTXoMLgGuRXQJo9w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5988.namprd12.prod.outlook.com (2603:10b6:8:6b::20) by
 BY5PR12MB4099.namprd12.prod.outlook.com (2603:10b6:a03:20f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Tue, 9 Aug
 2022 09:50:11 +0000
Received: from DM4PR12MB5988.namprd12.prod.outlook.com
 ([fe80::e8b0:f622:2dbd:78c1]) by DM4PR12MB5988.namprd12.prod.outlook.com
 ([fe80::e8b0:f622:2dbd:78c1%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 09:50:10 +0000
Date:   Tue, 9 Aug 2022 11:50:05 +0200
From:   Jiri Pirko <jiri@nvidia.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [RFC iproute2 0/6] devlink: add policy check for all attributes
Message-ID: <YvItzTbgCITbArWw@nanopsycho>
References: <20220805234155.2878160-1-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805234155.2878160-1-jacob.e.keller@intel.com>
X-ClientProxiedBy: FR3P281CA0097.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::15) To DM4PR12MB5988.namprd12.prod.outlook.com
 (2603:10b6:8:6b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a0a4389-0cf9-47e6-dde1-08da79ec8c9c
X-MS-TrafficTypeDiagnostic: BY5PR12MB4099:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: edi/DKNLY6z+IjH5vFLxziWEW9gk5XK9NhVudh4rwPPqTGzH3rD5Yd89j+1apfqcZNfKHyddfIJlmve9ITzg8I4d5MuvMfgotdozvkaS4RbTAqugvnsB4GvePZWVTN4E8Lq9IDzm7gZkJxDSMD/g/mQQNHmysljvYyjTbltGGn8MMH+a74EqnoEtxWF1bEWFjX3X1H8+6tvPNXyAAYcRhsNiKyfKyXNDdnXxFcsHE6T/JhPEgEMG01gMNf/SB/hMKSTRgPh4o4DAdp6GjqsgN3B21ETdQFI712lAC+KsiNbKW2lkIEF7PJpYTG5Plvgr7XB4kdA+GWl5bRNmRuDheP0Z2WJA/UJ5ZL/2wIKsR44S1HnHeVNCaRsg51Id3mBGXw1XlIh+9Pi4JBYMdIcl50SJZ8BFjRqZ6fZw+Dw4R6b+IIh82VIqpEImQY5oGnanurg0mSvxM72xTjcIpRMLvkXxWllna3j7fOv6XP7WKQejtK7kwpJB3Xg2wevWlZsVH/9Pkd9yeivKDDlxdyb3Qzsq0m9YyuI7fG+RUp05Ulgeb3tTI1MKtdPRmJGJWUG13QDDvPZyTBxipeUpleJyP2MIzhh+l+dVfWt5aDV04jhrPpOTI7vvIxzX4A3fwaqBdRqg7UIaBrrEMpvm6FUd2IKLtKRUloMsPQwLGWa8QL4avXGxPnjPCqdR/ND8nrOeIOY1UKvdqvQWJ5EhqX3uhs1myVsQrHGW8Jw8mvJiHf+zZAkeSF2ekyKvsuXuZ1Vc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5988.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(8936002)(66556008)(66476007)(66946007)(4326008)(8676002)(38100700002)(33716001)(5660300002)(478600001)(4744005)(6506007)(186003)(6666004)(6512007)(9686003)(41300700001)(26005)(2906002)(6916009)(316002)(54906003)(83380400001)(6486002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OgLTVoV+fjKzmLGnhMUFpCRovsKWIDwgXP8ONCqXse9ooWL1RZGq3a4Ublca?=
 =?us-ascii?Q?7mujhn8NiEMjY1b7Xna+Y4QuXezSysxnidXKJMrO1NYgzDUiA+mjsXGR5hlE?=
 =?us-ascii?Q?CSwUTTE5cOovm7454MX6OluCpCJVMh0GirkhbfPpGWcILsUy432WxGpBGVSF?=
 =?us-ascii?Q?OFXHyBFJ4N/gBodZAXwUPKp3jiJr7VT7Hh0E0/nGxEhe21ySA64fX323FhBo?=
 =?us-ascii?Q?9wm8UkUj7drUGkzY3MJ3p2lWbSIgOXx1uWOJJVTVuJNICj/c75uQ6M+QETlK?=
 =?us-ascii?Q?YqToP2/cW5Ma3qn6O3Qx6jVuGt8wYqRLlze84jkacFx0lomYs71WeBP9BYS0?=
 =?us-ascii?Q?KOxMVp3sinoI4Xf0bXUe5FM9F0UJvrP7JaTT2ZcgWQwp9d2ke46AtM4is4+p?=
 =?us-ascii?Q?h/LkvmfhAAkOOOkFgL5n0G0b7Jpzs4WiB3IypED8zH1G8HTj0rkoIIXjHz2/?=
 =?us-ascii?Q?nKiszV8vpu/giAIsOhtZCQGkpQBObKxcJdq04PU8ltG2ctJ30YM0REWHetie?=
 =?us-ascii?Q?mo3UMoGAbuWdEvX1SXBYtIr/uDRaPcRbvjTwRC/TyPWqY83dcilzJRs+Beks?=
 =?us-ascii?Q?c9qk3iPPs3PyHtgtQMlURFZPkicrejuZcE4kK1N7OCKfkfJZZTQLgoJRjhKE?=
 =?us-ascii?Q?RX6g8Dike08HwHU8RFEoaZvIf0wN6AmYkh9z7qBCs6Cg7yOlZ7gT92UAyF3P?=
 =?us-ascii?Q?KD4DzCph7cpvfgjsOEO/i6phPVL3/fneCOR2jqaKzPt81BzqKvqYKVV264e3?=
 =?us-ascii?Q?nWb0aH5ippwIDm66vy3N1iTa4laD/KADiOX0tzsBzpU95chTMwi1MyoroE7Q?=
 =?us-ascii?Q?EOUUi35WJYJ5Pii/LD1weE+mj+Kbil3rqZv3C0HwxsjQQBI6JBcNxzVh/5Vu?=
 =?us-ascii?Q?o50y67ifksz0Ex6C9AYcBCaWjeaEVOBDHWf9G+jq7soKFg7PrvmTbaVI6ZnD?=
 =?us-ascii?Q?GrhbVLNUwcJF7sGN/ODRvgSQrfa9npyU3R11M/5/XvGzUwAWKaVwwpXcAT1L?=
 =?us-ascii?Q?HnHlhnawKU6hCSzUVqjrJdwPNA+nO/CB+jpDqtpTQcz6uKbGG+l0O8nBVG45?=
 =?us-ascii?Q?ia98gduFPJjf1TJeJvGLKUIWxBE9+JyThv25hJs9hDqDS4XYnep63DSvjPlT?=
 =?us-ascii?Q?FDpZhuOC/Qc3r4kzZKSYBqZ+QMnmKUXVWfAS+UVpB/6vZuKrtxhHxegTEw/6?=
 =?us-ascii?Q?fCtSUAFme+DWZPDiKdWc/Hz1Qulth0DBv3KJakGh96nl6BfxhyI8x0hQC+V5?=
 =?us-ascii?Q?W6x11YMdLMjlak4M4r46IlI0thlpBvCtZiRAmkjmGejgwDEV8e5sRnKT9vpz?=
 =?us-ascii?Q?j5ESpC8ZsETObyaRnwP/YRGgJrhPSxNP2/zcJuYrLTLcaXTJh8Fm928unDFM?=
 =?us-ascii?Q?+TAXgc9qSvQSMZ3TCNOEyworwgAAqDPQgRVnwNXWn4oowB3TXmBgCeXwvvu+?=
 =?us-ascii?Q?C05lk6d3X5cYepJplzPSf5Jwbq1NoPwgOOH+3rCq9vAc3jogotnL476YnC4C?=
 =?us-ascii?Q?XbDmpk7pyAvMhlFRa+tMTDggnrvWO7j+RgYnuF37i5XVLCC+tJ4EGUD70uB2?=
 =?us-ascii?Q?gyNPDsRWPfyIchV3DgkwCSWPBsBLd8lRZPuPDsKt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a0a4389-0cf9-47e6-dde1-08da79ec8c9c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5988.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 09:50:10.6710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tkL5Z/chA1t8Rp5AQZCFN3ruu3/XJTY/EDTz/Zyzfo+i4ULFU9HWlSx2Cye549Z2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4099
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Aug 06, 2022 at 01:41:49AM CEST, jacob.e.keller@intel.com wrote:
>This series implements code to check the kernel policy for the devlink
>commands to determine whether or not attributes are supported before adding
>them to netlink messages.
>
>It implements a new mnlu_gen_get_op_policy to extract the policy
>information, and uses it to implement checks when parsing option arguments.
>This is intended to eventually go along with improvements to the policy
>reporting in devlink kernel code to report separate policy for each command.
>
>I think checking every attribute makes sense and is easier to follow than
>only checking specific attributes. This will help ensure that future
>attributes don't accidentally get sent to commands when they aren't
>supported (once the devlink kernel policy is improved to report correct
>information for each command separately).

This patchset looks good to me. Thanks!
