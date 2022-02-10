Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A214B1583
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 19:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbiBJSrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 13:47:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiBJSrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 13:47:39 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2097.outbound.protection.outlook.com [40.107.96.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4436283;
        Thu, 10 Feb 2022 10:47:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQeFapmDDhKt17JYfcjkoBsr9xQ6uq3sEGXYcMBrXEyHeuBDkAULecR1iU07JFeGEzWgoVGpRTLuZbWv0Z9L3SbD1tuhBLv0ELC46PV3AMwzQbgXlux8TULSMtRX66q7zIlUl00AxHmqLjiInqX9eyldcwAXtwLp1QhlICvj1RDDdhAOjI28e48BccCu5iVNd7uUzPIyOY/OvUjxiwrJjCkLb59z98v3HDKvz8uK3ISdS0QM9/Xlov9GyeEJIvGTypYKMtCnl85YnH3S0PI/xWk+VTGca9cY5tPFp4ipHVKf8GFjOU38E38qtFU5dtYyTsQjJ2tnxQjxNSt/X4K3tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UjRSQVwame1TweewDzMbgPwRJQIow7rVAEHj+KOLjTM=;
 b=m3yC5kze8aLmn3bkU8b8O9pRtbzI+//yoo6Wtl/cOYhYEaV12tPoVtGbPvl7T57Z3sGvQutfUIOOv0jPbF7rulwkqhXOVczc+EMQh14tSVL63IHcfifjT3cwfrValMfKZujSFNOjBAUx/S0Hf1CgMJrGkWsO9uz1xYiFtZ/QevbStKl9PXPDiFViO4H4uaqkYUgJoFqamB2BRSnTVc5hqH0EPgrpd3xqqVvReWUwYLwxbFgcISKS1fwyBV06i/1vX1jeBV5Yq9tX6tB/0dIBHi1lZ9DNXGyHnAcg07yiIH7SbLe/MFlN90HKocIrYNijFmxtCM0+HUFbc9hrfFmfYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UjRSQVwame1TweewDzMbgPwRJQIow7rVAEHj+KOLjTM=;
 b=N2+JTfm0l7gx0FY+XeHg5PRRfgrK8qRz2v1P9ss8tovxVrneaBWf5t/H2b2vumSjGsewOzU/nXcUuxHqVNOVe80xGFaDJGljSrnIQE5YQBreO23fcI8TUa02WYepmNsIarB/DnqL/Y1/AJ+bqkY9yNO4Av6yW+rm+AK6Dh66jqs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3924.namprd13.prod.outlook.com (2603:10b6:5:28f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.6; Thu, 10 Feb
 2022 18:47:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%7]) with mapi id 15.20.4975.014; Thu, 10 Feb 2022
 18:47:37 +0000
Date:   Thu, 10 Feb 2022 19:47:31 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        John Hurley <john.hurley@netronome.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        oss-drivers@corigine.com, netdev@vger.kernel.org
Subject: Re: [PATCH] nfp: flower: Fix a potential theorical leak in
 nfp_tunnel_add_shared_mac()
Message-ID: <YgVdw1Ic7iEmvqx1@corigine.com>
References: <49e30a009f6fc56cfb76eb2c922740ac64c7767d.1644433109.git.christophe.jaillet@wanadoo.fr>
 <YgUNdJgC9dNJN82P@corigine.com>
 <80a6083b-97ac-e24d-7791-1b5bdb318da5@wanadoo.fr>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <80a6083b-97ac-e24d-7791-1b5bdb318da5@wanadoo.fr>
X-ClientProxiedBy: AM0PR10CA0063.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db213b95-ba39-4080-cbc0-08d9ecc5cec8
X-MS-TrafficTypeDiagnostic: DM6PR13MB3924:EE_
X-Microsoft-Antispam-PRVS: <DM6PR13MB3924AABD120E723AAE918E18E82F9@DM6PR13MB3924.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N56ZszKZ7MJELzbbh+yNLG1SNb0ZbYoNWAe29ZV4i/zd0fEgP6SsjUBjYig0ZCcM4m9WKpuv9PeWzShYmKO1/lKqU+OT8cxW5mYUT6zhoE4G7oiHeLWbrkQs0GS/bV+Ohp3XchqEwTbW63k8m6sFxSIg1VKEPktXVrFcosqYRWCYra0o4hMX9oQUtDw1XbzPbWyRuWLgBpFaD8YtVHgB9qzj8PhT1dBt1UEL4jYL9NgLVijJL/JnTPX4zHBzvwPCv3rFYX5JAnyLisELfAre3SVvnzxQIvJbhM9tVomIWoHdxxCy7Z+gFSyHyCfHEiJt6/Oob9M+xuB3O9/tYT5qAzPwLDxhmLxoQ56RMCzWNAyXA2grm/G18VomYEIWtBTQgka7wk021yv2kYPHoyToFq99uImNPmdCiSbyH8cw6/Wh07mABR9MeQy0plvmysH5RnE2gICiwE/eSJCkhE+fCzrVCMv7yawlhOA8bETEpvEKyAOZ8ktrs2KbvSVpg/Pt1iRHTD5m0ZYis9q8nsah1ymzz2GEVXN9vzbe10YqH5w59X24Xi/t2Cr0ha3ZgfWErV1hnQin3ultse7wAlTpPLVbxyrQsqO9DW2WPTdhcEHC6N9N8OyR8vBi+ozS0ULwAYZ3f/m2rC1C0TZ0sRUAd/BsAnqAc84m1TQxpQdoBZb5iJQ3z3gDePPAu0Y8HbAWi2UuAL2LrqseytCQGa67eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(346002)(136003)(396003)(39840400004)(376002)(6916009)(8936002)(54906003)(66556008)(4326008)(8676002)(66476007)(186003)(66946007)(86362001)(316002)(38100700002)(52116002)(6506007)(2616005)(6512007)(36756003)(6486002)(508600001)(83380400001)(66574015)(44832011)(2906002)(5660300002)(6666004)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zkl2ZFhFcWVZOFBvYjFmMnFBZGNzSGxtR2RkbWFBWHFTbjlWUVppWGREZm55?=
 =?utf-8?B?R0luendTU1A5V243WXp3K1U0bm1UNnJTU2s0SE9mZ2cvaWJlTWlXN3cyVXB3?=
 =?utf-8?B?ZnNWWWw0SjVEc216bkYzaVBTM1Zicml4a0lxbHdkb2MvaG5BQjlKODYyemlo?=
 =?utf-8?B?Q2ZPUmQzZkR0a3JjZFdVUlhBeWNDVzJyandsUDZyT1dqZGR1NUgzcTJjWGhX?=
 =?utf-8?B?aXcyQWoyMnVSUXhRVnc3SGF1OXBoUWl4dFRSenpZa2UrSWozZHNDdjFxenZz?=
 =?utf-8?B?NWFCN1FERkFJejBRbDg5aVRjQjdUSy8vdXplUjRRSUlTNVZJTWEwWmdpU1pH?=
 =?utf-8?B?cnBTeE5oRTV0aHlWNUttVzZEeWd6cmkvTkZYWkxEclJHd0tHYmhIYnV5T3ZY?=
 =?utf-8?B?NHBFMlBwdjhWREhvaGU0dUtRc3hmdG1JVmRXVVdNeTlBMXRxRE5rL2xLM0Rx?=
 =?utf-8?B?NWtlVXdzeU03UmFPV0YzN011ZnpYbktRUUsxSE5GN0Y4RHZLTVZHd0gzdmRM?=
 =?utf-8?B?WW55UkYvdDlPK3htaWNwaHlrZzNudjI3aHFKbHo0ck50OE1LTUZOMWVDV1BZ?=
 =?utf-8?B?Q2haNS85ejlCbWk0b2d4cmJnMGZYMEpISG1Nb1Q1dlRzS2dndW5QNXd1UkNU?=
 =?utf-8?B?YXhiOEI3S0N4aFM0ZlpGS0V4b25xUlIvWHVnUkRzTUlmb25aMnUycUx5WUFj?=
 =?utf-8?B?MWhzdUJiWWRWNzVrdjN6MktKNXZGWTlxSU80dlVPdG14Mm94YVB0OEpBRHh5?=
 =?utf-8?B?V1llV0VvU1JtV0FQQVlTQjFoWXhJcENkR0ozaVczbDZZcWNSM1RSaHdSMGRI?=
 =?utf-8?B?cStsTGxXOHlwS2o4aFpjczlTeUNaSWNaU2cxMDlFdG5UUGlrbXUxS2Y5WWd0?=
 =?utf-8?B?Q1JxaHpWOEZzRVNPQ3oxRmRYdmZPdVhiLzJQcU9scTZmUWlUUWI0NUlSWXM4?=
 =?utf-8?B?VkhTd0R6RmpYKytsV1MxTTYzWHliclZkaFUvVEZPWDNtVXVaOTNjb2cwbFhZ?=
 =?utf-8?B?WlZPTkdiUk9aU0s3MWlDakY3ajVnZWVZcGg0MmVnMHhLYTlQYnBGY1QveVhz?=
 =?utf-8?B?TDJLaW4xQk53Mms2eEx5bHBpM1ZkNXFaK2d6ZUZ6ZGJlbkxNdll2VEg4cDF4?=
 =?utf-8?B?V1BKTTFsbmJFdmY0WlhETlFJWVBDTDhRWWd6NXFFSlBHQnhzV0pVb0tkNGtG?=
 =?utf-8?B?NElxdVdLY3V6NWQrQ3JoUkRUV2NUbEhjZTJpeThLaTVHeXdmM2gxdi8xWE5q?=
 =?utf-8?B?ZWZ0cWQwVWxIUld2T2t4amhYaVRkcVBPMWRLUlZmaE91aGpwU2gzeURnNHVa?=
 =?utf-8?B?NWJPdDEzZS9la1lmZWFvQmtJSEkzQWZDWGpxU1FxSU1uOHk0M1VTZmM2WXY3?=
 =?utf-8?B?L2NmZHJkb0VPT1BlejRqNzg4cWRGL2U1a21zS2hEVlo5T2RBZHFPdkUwNG9i?=
 =?utf-8?B?U3pzZVNsdmdMVk1HWTZGWHZPNEpvcnFqVEZnV1BpUjIyckFVRC9WNVhuTmFr?=
 =?utf-8?B?Tk95Nk5IdzJvYUtxK3dnNzdORWtpUVg2cnp2YlNaWXJYQVdVU3M0UHdsY0FZ?=
 =?utf-8?B?cnlldHM4M0lrVy9wTjdSSTVLU3IwcEJiRVZZYWswNWZhZ2NXRHBNSGlMMzBK?=
 =?utf-8?B?dFlVc1doT0VmendLQjJGNGZqOGFXeU0yU2o3YW54M2ZidXJrK1Zia0RoQS9C?=
 =?utf-8?B?OUtrc0NBaGZxOEoyUzY1WHd6SWRjU25KZnRKRVFNcGR6OU9KMDY2MjZ5bFN6?=
 =?utf-8?B?d3ZDbVpaa1FJZTE3NTVvQmVpZlFvaTl1MXRDYjVRZU0wY3JMc1pUTjVNQ0xq?=
 =?utf-8?B?MGFnS2Vsd3E2cGVDNlhtVS9uN0J1SDNIUmk4TXRVbjBuTVZJVUt2UHM0dmN2?=
 =?utf-8?B?Vjg1RFdiS1ZYU016N2ZuUVc3TURGN2xRNWJrbGN6NDN0bGt5aTgvYU8xSmNp?=
 =?utf-8?B?Wm5tYlAxWlV6ZzFZWmtsSmVMYlpMYjZ2ekJzQkhISmNLWGNCN2ZOVnN3U0x3?=
 =?utf-8?B?b2ZCTWh1d0twWEpsZUlqa1c1WmFLMlI3TmJON2hPRmhSUE9ZN3Z0OTRkbERO?=
 =?utf-8?B?ckVWanQwRkIwYVMwTzdUajdkeUJzS0lFVmJ3djdZNUhKSGJhZElWWWF2ZFNm?=
 =?utf-8?B?UFdpQS9qdC9kWVNIdzJscUxLSU1FVEJHV2ZGWktxSlZtVXdTakVaODdFbzE5?=
 =?utf-8?B?MlRHVS9kTXhtYTh5cGFaYk5VUWJDdVYrblphN3JnQjlMaWpOTUpHVnVINC9w?=
 =?utf-8?B?VXJGRGRPRzVCV2p2UzdKN3hycjRtSGEwVjZlSktycUNFekl0T0RsOWNmVlJw?=
 =?utf-8?B?Q1pDTVd3dWVKWS9Bb3FLRFJibEU5bUdRSmlSeitPeHFkT0E4VUQ0dz09?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db213b95-ba39-4080-cbc0-08d9ecc5cec8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 18:47:37.4426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M/lNSEfSe7MSKPM5WAUBQfBp+x1CBVJ/3+FPr8KPBFKgbdql+00d5YSQRslTHKdRkFQI/3Jshtf7CtKs8PxVwLSfybL0Kj1G0HpStiecxfQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3924
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 07:39:29PM +0100, Christophe JAILLET wrote:
> Le 10/02/2022 à 14:04, Simon Horman a écrit :
> > Hi Christophe,
> > 
> > On Wed, Feb 09, 2022 at 07:58:47PM +0100, Christophe JAILLET wrote:
> > > ida_simple_get() returns an id between min (0) and max (NFP_MAX_MAC_INDEX)
> > > inclusive.
> > > So NFP_MAX_MAC_INDEX (0xff) is a valid id
> > > 
> > > In order for the error handling path to work correctly, the 'invalid'
> > > value for 'ida_idx' should not be in the 0..NFP_MAX_MAC_INDEX range,
> > > inclusive.
> > > 
> > > So set it to -1.
> > > 
> > > While at it, use ida_alloc_xxx()/ida_free() instead to
> > > ida_simple_get()/ida_simple_remove().
> > > The latter is deprecated and more verbose.
> > > 
> > > Fixes: 20cce8865098 ("nfp: flower: enable MAC address sharing for offloadable devs")
> > > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > 
> > Thanks for your patch.
> > 
> > I agree that it is indeed a problem and your fix looks good.
> > I would, however, prefer if the patch was split into two:
> > 
> > 1. Bug fix
> > 2. ida_alloc_xxx()/ida_free() cleanup
> 
> I'll send a v2.
> 
> I added it because some other maintainers have asked for it in other similar
> patches. Everyone's taste is different :).

Thanks, much appreciated.
