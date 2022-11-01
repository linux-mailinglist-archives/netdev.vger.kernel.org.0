Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F4A614319
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 03:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiKACRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 22:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKACRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 22:17:40 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11021018.outbound.protection.outlook.com [52.101.52.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E190C1209B;
        Mon, 31 Oct 2022 19:17:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8/EAjsJLVkBURCkWzaKpp5FaUhFWGJ/DQO9PNheC2x40awebjuFKA1WY+Z9jm535AFsIBIzmUKrTDyJkIjAQ/WADLWHOW9bDABtvyC+XWQHYm7Z87fU0fW64CLjBKO7Pr32Z6Ra2BFmyBHEHyfSytDaOPvdBqJFCiqBHUkcpCECKdJTAC9psf8h+e1HvpHYnJ6mjLsRmko+mFQk73Ve2ZulL5DNOlWOEk+tB2BHLgSv+qE/TfBqU3ligUY2zatAX4rwopsNMqP33QqKFlSlZgZAvRKuCBb70mqW8yGeAaKNknUdjx05VZSQ8s7CGWV2LhbHmFtYJ2WuJSoXxoNkdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SKyFbDD0hV2RFntCcK5g0EJ24zZuBp24CNZLOKULoPA=;
 b=kZwu13688rUQcceQF+bjjHzt0pT7K+sZfex+aAS7HJiuJx5VXK3IB987imw5/4K1GyF7cxyNmBRmB+ouAMNtPoa1cWpVEJvUhQb3ZfJaEq2kEAFJD9HCTVK08KPcEjd0VrZDML/hibtb2B4bh0GK72rqHFD2P09SCg0wmIe1qmoTusRk5pg+0/aBQGrgxqg2xJoJ6It5tkk/4LS82b0YbRINC/kOpttFSM1tIg3doouiGiV+hnrXlF8JCvOxqB/9RzEEGs8frYXhavdybCjMoFQSMyWCLxvoJjVhXzOSvhTWCW/IasNKb22aV6+nxbpQ6xNG/md3DxF5keBZ1QsIsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SKyFbDD0hV2RFntCcK5g0EJ24zZuBp24CNZLOKULoPA=;
 b=W69zSxd+lHNAqadNQK55YgYKXmTHYRLk9kPrCJe+uL5vlkCYZRVnHI5yzks8bGVWpGlPtPOYZmNo/4pI3hTw/KWtZTJJm/6KRUBKvZ7v+7TofBXnRCl8y6q/2uWiOi9CHRZOBQXX+R2XUoXacYkTU6w3dBgIbauMw2jXfN2wg3s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by PH7PR21MB3140.namprd21.prod.outlook.com
 (2603:10b6:510:1d4::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.1; Tue, 1 Nov
 2022 02:17:36 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::a746:e3bf:9f88:152f]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::a746:e3bf:9f88:152f%7]) with mapi id 15.20.5813.001; Tue, 1 Nov 2022
 02:17:35 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     sgarzare@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, arseny.krasnov@kaspersky.com,
        netdev@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        wei.liu@kernel.org, linux-hyperv@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v2 0/2] vsock: remove an unused variable and fix infinite sleep
Date:   Mon, 31 Oct 2022 19:17:04 -0700
Message-Id: <20221101021706.26152-1-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-ClientProxiedBy: MW3PR06CA0022.namprd06.prod.outlook.com
 (2603:10b6:303:2a::27) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1092:EE_|PH7PR21MB3140:EE_
X-MS-Office365-Filtering-Correlation-Id: e7412859-85b3-462a-c617-08dabbaf3d42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lP7yqv0Y4oJl5WaMU1Jb4Kj6BaUk9vZe+HytuUeJOEdNrJLXXT3nQy5k1FoEdLeB9SIQ5WV35fIrr3AN8zP4ZWAZC2kenrU4Qu6/EQpMwR8tOPy69vPkpjR4oHN2qyRSOvUjaI6wfwt+oTOsWzr1jzEhAty7UX4WEu9QwCxizNEAtNFi6kC0GheTRhP/SCCGhUHG3UvFfBtoP2q558NOhalw1nEnqmpQMKlgawIt7D/cEIp90w1xrApGQlNl7UhZcZuY8tiahmXXwQtnln6b5pCFKDsQMM9ZtbtKvrNUr1zKoy7YNiTSRFaCf/yUkNJqyq9hYgcvp7UJ6jDC8pAopDpzZnvixXl9AroaGP+AtzR7YfXVVa3JB8v9N3tJODMXp9oUpovcpXStjD/O9QbmWCL4JAy4SELSs8/zaC3fJeDUyByNXgjqAYYw8UGNQaT948QFQpanRa+ww24bRvZ+6lxTIm9GLiiuaRHvmB9LxJ3q5o0Xm3cZHzsj9ZF31aPPX4mz1fW6TvfDMH/7WLs27c2KyaSQ4mNeHF8qwbwS4FlhaMf6ptE3nt4wr69AyedFVqPfLKnIABSJ0SFMeDS06jMs/rZNZJOK4vNvRE/+vMlkdz/VvHhXv8icm0LZoPuVQ3YNuF6gp8PkSj1mQQkRWQAZv2PNjmzaxYeY1CIRLXJwlQs/O2mDX4RWWlIxqIEdD4In6aY/RLe0WMHyaWRJgzWGNheRlABXYbc+XFbUzN4JQq2+fCyjOK7U1QHScHKq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(451199015)(10290500003)(316002)(52116002)(6506007)(107886003)(6512007)(6666004)(2616005)(478600001)(6486002)(41300700001)(8936002)(8676002)(36756003)(4326008)(66556008)(66476007)(3450700001)(5660300002)(7416002)(38100700002)(4744005)(82960400001)(86362001)(82950400001)(2906002)(83380400001)(1076003)(66946007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ouve6Jt41HuR7jJaZJ8VYHc+ymXhlSRSuEvhqP8ciMtyGtG3NzGrM1xSYjWg?=
 =?us-ascii?Q?h8ODXIkdiYCGuLFRxUqMEKRFZWjghRGOwZT4Ywx1Q82dddTUjKxNEjwR58Eq?=
 =?us-ascii?Q?aiVOLme15uLFE3sj227GFKwompkoZcGMoOBupIJBdMy14dqD85ES7dn3dvgs?=
 =?us-ascii?Q?s9YTDSoR8TT3fZIpB69PB0UmS9AE0KjNZWbBaIgPqLhEK5y5+1Y8I3piH6GG?=
 =?us-ascii?Q?d86E6pedOctANct1FrgyIE5NiRR7nfNTY2yUMzJrNBvSYnSzxHmjiqRfG/LW?=
 =?us-ascii?Q?gOIXQl0LX3AtG6X3rvE3e32jg38QN7WL3XbWib+ybp318yBXWctbU4Kp0rwU?=
 =?us-ascii?Q?o7JZp/cOibHYinGtR7pZnkhYEovEX4ogUc/fvSFyEkL2zQgOwj3RDq9TrxEX?=
 =?us-ascii?Q?VfIGZZbPCkIncPPmkATTPwuSkJYsOo2F2fpGa7HtWrTLGDbF/M/R56BuJpJb?=
 =?us-ascii?Q?XhzpnSA1gekxTK0P3YH+9GX56o5i0L35W91xw1b+ldQzzzuX4gsUnNqi1wnW?=
 =?us-ascii?Q?X9+uzowZJ6EzYFLZAnIvvD2eZHndhLzkii6F/gkm0bFo2dm00XcQYVXtKavl?=
 =?us-ascii?Q?nGExpDPHuIEKDRdi3HDpIkX8fMj6YutO/5TcJu9qD+aj2HmK0Ns8yqtwJETC?=
 =?us-ascii?Q?/ucrlfmE9M6CGi+mrgKp00dgJEfdzlXh4C0JNp51wr1c9BpqcHiwZ3r3Q29z?=
 =?us-ascii?Q?KvJRh9Bc/JOD/5rlb4e+W+mXYKaJRqi8teks7a2s2uOwGJ4ThcLUNiPpu2L5?=
 =?us-ascii?Q?NTAlHj6WF+YHCm4RqKsGIL5X0SqBPTjeU0r3H4ouqDddGDUFZFDbSSsFwJmg?=
 =?us-ascii?Q?VXWbmQZNRumudq/GGhtekZTVWF8zYW2f56MQu/5lGOZEXovwk6JpHChIWTyt?=
 =?us-ascii?Q?jkU+V1lC3mHsBy0dBhp+6X9f/OEFb/5FIT72yhR94xdZy1vZJHRsk/7OJ3LD?=
 =?us-ascii?Q?eJ3ng5RhU32CYF3/kjSvF6zh+0Y14G0+8SWdV0dizRhvowZT8ZD/ZQYRWcZm?=
 =?us-ascii?Q?trKPpaWjdiH1pncgHkSlPnelkRtGSSZn6i6GpTYtHKamSXB2ICC4FFWHS93y?=
 =?us-ascii?Q?dC7GOtAtDD7lD7nMeC70dc9dj3Bu/pMWoJq5s8kYHFfk5Rq+LZpG70gidZ6U?=
 =?us-ascii?Q?R90TUA/l4+aL+thH0C8VnWbdbnfqM1T0kUN8vCH43k5jH4cyy40eZ8c0D45q?=
 =?us-ascii?Q?71rHou9W/aIIczZGeQFlPW2uzb0OY6y0rGf/TZLNfRgrZBjx0vM/vSET+5PS?=
 =?us-ascii?Q?bLkHZe13vpERZBMj1pbzw+idZv1uZVA/AHUZnwkTeZTETCkkw0YBZC2XJ5KM?=
 =?us-ascii?Q?RapMmZ7k95735Nwfu+sJqCMWFyfAdaDYM05f2jcxTiOsS7M7A8y9gwX7HVgO?=
 =?us-ascii?Q?0PenJoH4u/Z8Y1JY7vfckJNBc4qChy+AdtBQ2/209TF7Z6iKXUvp/83FQlJ4?=
 =?us-ascii?Q?8KoQo+V9gFx7g6u/DDbSA6Ax+Q36WTU1RJmzmGPScUN6qjz7v8l3u0ebRS1s?=
 =?us-ascii?Q?1QcgHFcRAAiKBseWy4EgVns90Z/iBfMsMNyVMIDRR8Cssa95PUksZ8rGuig3?=
 =?us-ascii?Q?yNNACKdeZnDX7Ehkxsf8q0uItwGSGTy/rx5IycJsZr7nKkXcMaPHAO2ntl+P?=
 =?us-ascii?Q?StxyYUo1i66xn+P3vc3JLL54gNAK74RwHnjLC5UIRKZJ?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7412859-85b3-462a-c617-08dabbaf3d42
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 02:17:35.4066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Is7fY6t84cyF4FjB8ctBTnRLybeYPdIiTkcXLa/ycbcghMkeHjVZPxRvOCX5XbAtpZvQ367Hss4P0rGJ/3ytuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3140
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 removes the unused 'wait' variable.
Patch 2 fixes an infinite sleep issue reported by a hv_sock user.

Made v2 to address Stefano's comments.
Please see each patch's header for changes in v2.

Dexuan Cui (2):
  vsock: remove the unused 'wait' in vsock_connectible_recvmsg()
  vsock: fix possible infinite sleep in vsock_connectible_wait_data()

 net/vmw_vsock/af_vsock.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

-- 
2.25.1

