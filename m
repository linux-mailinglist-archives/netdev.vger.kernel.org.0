Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6733468EC9C
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 11:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjBHKQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 05:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbjBHKQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 05:16:47 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2114.outbound.protection.outlook.com [40.107.92.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1827145BCB
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 02:16:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4yu/aMX61gyHGuIotbBk5LL7jwBfaoluMkl7H2H7AX3TonXxmVrTnsYxNS8fkcNNi2JfcVUIcMWYAn1Vw/fSdbdsEx31+vgDGjBqP9LzYZ2h/FOlPXU5amRzriq6hX2kclcYJNfGaodqtDs8No2d9oOo5pAM2cUyp6xyHXyoMc9C55XFfuXA/5AYajENCgiwGooyE4wO8Fp00R4IfBIzjmiWEIRehmyOpEOqnHT1nFAxHN1uIU7XWQ7YuNAhPfBMMEi5mhpJM9u18hx/ya6QDi+O+bd9ajiioNYV7d8Jr0Hy8m7Ls2wKl2az58hSyoHoHo9c8yV/TXdDm8yuxHekw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o1biNqHz17UHnoYyY24UlFeS5ePaawMVEasb+LTuSuo=;
 b=Ssc3OStt6ZYlgtoAx41ih9j0Sr4BK8IFyUBhE5n7EjkueM/JLq2XpPosoHHeNmg7s21h4Z0D3Nm5a20VKl9+Q0kBcP6FdpcIcvjaD6CRDCHbkaJnoD+qfCB6RI3n6XFYF8bdIM8XnkEHkkP7a3Eo9C8Ew4AKWKGoj/QlksPjav25euRMZnS4lnvTqGqoqCT65H+oPiDQiE2yOXqL8eEky+Kj9UXgQLX+BxsIYx2VHRkvgPRry6/+/LgmLX2tJAepKXoVwR3QDTWQ6cGUbATw3YaH05L5K4KkF0g6FAdhMAmw6t92eem63bnJEphhFXACughcpujnYZWgCo8iULdCyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o1biNqHz17UHnoYyY24UlFeS5ePaawMVEasb+LTuSuo=;
 b=aXCxxCWHQAzMVs0rHVKPTBAiVofbHgInIM4Vb3Jxy3VdkOvVvd2gi6dGwZnUQBM4IQX8pdQ/fU5zwKt4/xg4URCnOS+Bn6zC6vBYWkJGbsaD4TV/oCLl+gO88ElRWCBQRt5Xpg6kLRLSYcBbQV4NHVM5wUGhPW41WFugJHt59/c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5148.namprd13.prod.outlook.com (2603:10b6:208:33b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 10:16:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 10:16:24 +0000
Date:   Wed, 8 Feb 2023 11:16:17 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCHv2 net-next 3/5] openvswitch: move key and ovs_cb update
 out of handle_fragments
Message-ID: <Y+N2cRqDnDvLx52C@corigine.com>
References: <cover.1675810210.git.lucien.xin@gmail.com>
 <d7a2bbc1b84729d619f20446b51ab461b788adb6.1675810210.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7a2bbc1b84729d619f20446b51ab461b788adb6.1675810210.git.lucien.xin@gmail.com>
X-ClientProxiedBy: AM3PR07CA0140.eurprd07.prod.outlook.com
 (2603:10a6:207:8::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5148:EE_
X-MS-Office365-Filtering-Correlation-Id: f13b06d1-7ec1-4f4a-3639-08db09bd8863
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fswkBFv8zl+1ZD3avphQHhYwUYHIYJkBYsASd+H+unnbpLw1QJKmWYYpOTsfX/CGnKon2V9iOcpIoB2+korH690S4vMlmnk5PeddJ271vyd1Zv3XnpXa57CAyvkjTgt3/1gHEUtewZ+Uh6wt0eTGxG9fWJM94TD+uDl4E7aBiJV7FC9FQl/DYaSYdwu2XR4Zo2hfsM3HWyaXt0dbtrfSj/Ax9Ol8ZE2VKe3y9zNKhjxd3y+/uTuLWrrXjLannUgo3A+XS+GG/j4wVSOYlTOidI1yTNZ4bPlua160aYXoYNfH1FQoZjvBaRHNi4J5xM4U6c5u3HnSOnoj9rZnnHb84XJs+w/WF/TDT8W4LMrG5Wt1oz0opzE8JsJep2nnyUMSIHA3eIgiE6TIaiGMLD/BpBAQEixmpeYpDolIlng5aoaf1mJK2iHyDAWuTlp+3D5zhXuEFRfM6nW1UnN4WdFufPPJ9EW53JZR3bOtWBSSMFDAXMCBjLGbmneqEGPeKcMNFRfDVrVBt15u7FqJQBOhhBvYYt/1JTA+zgZxsRGzinUx51myUDrpjyHvRg0KrpCTLoyNGzmMa9AOjKvihMMOTgB7RacqcKd0+CglmyCVU8fOjrc4BTSV5NiWSNsxdkSjsXfQri2DharJMdED/N0GewapOhGVNrEuumpnd6Vp50dQDyFvZtbrvPL15YZO3jp/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(346002)(39840400004)(366004)(451199018)(66556008)(66476007)(6916009)(6486002)(15650500001)(66946007)(41300700001)(316002)(478600001)(54906003)(83380400001)(38100700002)(4744005)(44832011)(8676002)(186003)(2906002)(6512007)(86362001)(2616005)(8936002)(6666004)(5660300002)(6506007)(7416002)(36756003)(4326008)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mcIjZ/hiFBG15UtohCyJIx2rcWy0LG8GogbIxH7xUvx/MQ5eMFVS/k7IXbsy?=
 =?us-ascii?Q?bwXOR/vY28s1nzUUhKkfAc2UKf6l1uofszC50kcWgZltv5lUPCBJUw9UxQoV?=
 =?us-ascii?Q?Lau5IynVTS1OXIYBcDv1cKk5Jb/bEHLHHXJ0Oo/g2M/53tq9kqQmb8pL0owy?=
 =?us-ascii?Q?gwKmi6CAGNStfgwgxzk1zlTTBzllyIuZg7hsKQikrIQSBum+97UDJyBOcdq8?=
 =?us-ascii?Q?BTS8Zo5+63T9tDCdbmrhUYrrx/K/+mLA5wh+4qnB6Y6+VCyatxvFJ1TD1bU/?=
 =?us-ascii?Q?ed/bRxZ9DsEFFqsi404PDIL/FZK/pu3w09ciTtHdONGnAuMlYd6wUOEiPMvK?=
 =?us-ascii?Q?/tGAq2fOCpXBmz7wDxkBruqZfrHFIaji1Gi4WQa1fmsuXeVHjC0uyl2MxXXk?=
 =?us-ascii?Q?T4IzrE/bIjVEhe5nbVmLPyJbkTlJXt9+mUNqlhTnusONQRLJ3xittAMYGWbP?=
 =?us-ascii?Q?qi7MFHn5h0z27/BmVWzLHox+sZMvJ1TPuyvct/sD0MJxYAtK0s8Jruo7zCGC?=
 =?us-ascii?Q?DULAUvMeFQ6NTqREFxNtUnxOeoK3Od2E2G2yKhxAmzOArbyZxAlI5zoksNTY?=
 =?us-ascii?Q?asBinaQAhsGRT020HeoFoua0vp/KgNAdIo0Fsbg2rSpiItUXY7rQvSK018E5?=
 =?us-ascii?Q?e78gbKgwS5htangTo8kBpLu7pgJyZtc7oPfwQusWDnATqBLuANQMvJVTYlft?=
 =?us-ascii?Q?fjNva1HNE6rzIlNu0iCafYEIIWnKHkiyuS4CBil8rwwozWTC+FsjhtgrF4up?=
 =?us-ascii?Q?EuhyQJA2BTbEiVZr05ufe91l3E72kbis+PLQPS1oiKixdea8TNEAjyrvASGm?=
 =?us-ascii?Q?XdSkEWVnncmYflC40gsCWXrZ4k5zKlTUyUKb4fsESOJFNKpht4f+fhavrUQu?=
 =?us-ascii?Q?Omruj5tN+kT+bKLa+vky6aQGMg2oMmwG05HvY4kxuQdXjzYxLMagXVZhRyy3?=
 =?us-ascii?Q?AZdheaFWGxuVp8JLq9OLbnF5wEEWz3VOtewlJR1M2tjOnVqRi1cWlq9ghPbh?=
 =?us-ascii?Q?+kMZNoiszbazSKu5caEnFdmRwKsFhxXFNCOak7waMeZc7kfkggL6sBnqj7eZ?=
 =?us-ascii?Q?0J/y/UfgPDUFfYCWcCxZZZZThfDeiCjHoVyI+pbN3IUdV4VPyqmGDnkdy3K9?=
 =?us-ascii?Q?hCOMyeoucgHXByLeN7ZUfDKcyj3bMzeiDZaEyPJfVJfjE/cLMsPfVOQjIs31?=
 =?us-ascii?Q?8nLuwA1aO4/RselP/M9ORGkMUYxEGmaJ/uFJLMXfg5UPNCYpZFk6Zfu+Su02?=
 =?us-ascii?Q?RxDel7LvzoEY/hT0HvVaH+NHsWKFa9rLr9GvRvs3SbbYqANXLIeW2V7czsLH?=
 =?us-ascii?Q?v7OZIcf2fOsIu8iQ53L1iv5uDq3WdnsPdQ7YJumRU+txgwpPPpaezYGHc5u+?=
 =?us-ascii?Q?t1PSG11D2fslR5WbfrxLKRSR9+B9FSMyRjypYfL6/VicTMH6YITRNq5Ai+DD?=
 =?us-ascii?Q?iSkpOW3eAfs32vRytx3zI3eNHRC01odPsBbDRtNu94pn1ebYl/T+xOgjb91/?=
 =?us-ascii?Q?ViHe539HaSAM99wFU1XVX9dKbWn0pJ+AI2n8689Rnn/2NfZZVe/VrliXIH2P?=
 =?us-ascii?Q?fcgKajFLiRxsXSgt1TRskA/JCL9LU3Oc8WjTh8gy3Rvyrd2J2uaGW/brs2WT?=
 =?us-ascii?Q?DP7y84TVli5UdhUm0ea3FrPacDi2JT5SYPsbaU3gmzOu6qREVuzebyEdi/p9?=
 =?us-ascii?Q?gFxQTg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f13b06d1-7ec1-4f4a-3639-08db09bd8863
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 10:16:24.6604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tj4FH854CeWcrK5XCfnLnPBItfL4qI9VzdgZROP+moaQAmdpaz5LG8uTNDYXQp9noylXQZKbRAJkntsprb6q1MAHYT49R1WmPhUWvJIkp2E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5148
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 05:52:08PM -0500, Xin Long wrote:
> This patch has no functional changes and just moves key and ovs_cb update
> out of handle_fragments, and skb_clear_hash() and skb->ignore_df change
> into handle_fragments(), to make it easier to move the duplicate code
> from handle_fragments() into nf_conntrack_ovs later.
> 
> Note that it changes to pass info->family to handle_fragments() instead
> of key for the packet type check, as info->family is set according to
> key->eth.type in ovs_ct_copy_action() when creating the action.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

