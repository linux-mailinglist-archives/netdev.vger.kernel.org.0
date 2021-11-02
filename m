Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43901442E7E
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 13:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhKBMyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 08:54:03 -0400
Received: from mail-bn1nam07on2120.outbound.protection.outlook.com ([40.107.212.120]:47502
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229530AbhKBMyC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 08:54:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGD973z/ZzvWORUYmDxmfG14T5LpSCvEdQm5xrkPeN4+7ToobAE3omUO/kXI8RhHkS8lE0vECCRjWlI7D3CE0t4RuBYpsz22QD++sRMU2guohmzqObuUGoJJ+/i26r6eCBOfKM7G/ArhmnAOmbal5d6u3NZhUXFEJj/iupUgtXz0aeeAfjOTVdn1U6YxMW/MJ+Pz0CMTeX5BmEB9pfreondajOI6xpDwQNqDYhNlj3+bEL4awTXT6pOJYA7DXRxflkZAergwPi98Nr/MzaJYk/qVT5wEHgB5zb0sNcc3CeuNbx83l7BlV0eoRSqPNAqwKn9WJgFCWUPK+AWkfoKgWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+w/m6+yWc05+iiAvDQcodf1wrAMlkfSOHBA4n4YAZt8=;
 b=Hv7P/Nt0stA3lVBggRckXkVAE3bGC5NkByTV1OHgwEvjD1O8TqtIq8WRG/E+9KSaqvOR+cLm0lMUJlGAZksq23WNjm88/n5C0jNAIizCNXHxVonmcS+q6kgsrCRbcmHP3949L5syaKNIsCGeePjlqj3KhDWSuvAau1q2eqUlJIUxbBsawM5Wrs3s9LWRinCFxQ51awd3hPiJAF4iBIDULqqvX8ZySFXSRImHP0RTVBOHXm6W+8WjYy9MHCx201Z6bKw4uJfBia7elCvD2ehkBUH6f6bLDhrT7fSZwL0bEouIfAkE6JJz/4tw0kkvywuGFbvZQNRAzNihBspDVjQPPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+w/m6+yWc05+iiAvDQcodf1wrAMlkfSOHBA4n4YAZt8=;
 b=PjHHKrMBKV73Ofa+5O3bYt9oB1znuWIpgdt/5+x+HgTlRU4U7uXWUky37W+EUadpgldNoCRX/r5eYW6vA3oyU8mjbKtBvuooh6zMpGGPFYji+NV6gwPFDVtzrOEI02N4ZsYjekgCXu+apO7/G6cDMVK6pFSrK2gluhJi+nZMf38=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4795.namprd13.prod.outlook.com (2603:10b6:510:92::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.6; Tue, 2 Nov
 2021 12:51:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4669.010; Tue, 2 Nov 2021
 12:51:26 +0000
Date:   Tue, 2 Nov 2021 13:51:20 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Oz Shlomo <ozsh@nvidia.com>,
        netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
Subject: Re: [RFC/PATCH net-next v3 0/8] allow user to offload tc action to
 net device
Message-ID: <20211102125119.GB7266@corigine.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <b409b190-8427-2b6b-ff17-508d81175e4d@nvidia.com>
 <cf86b2ab-ec3a-b249-b380-968c0a3ef67d@mojatatu.com>
 <ygnha6io9uef.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ygnha6io9uef.fsf@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0PR02CA0139.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from corigine.com (80.113.23.202) by AM0PR02CA0139.eurprd02.prod.outlook.com (2603:10a6:20b:28d::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Tue, 2 Nov 2021 12:51:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b76125e2-9306-4cc4-1408-08d99dff7b12
X-MS-TrafficTypeDiagnostic: PH0PR13MB4795:
X-Microsoft-Antispam-PRVS: <PH0PR13MB4795F56299EEDBDB55CC470AE88B9@PH0PR13MB4795.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 89w/11ayxTNpOENLnTa5BT4BvLpzYcCO8DbmobZy2lKt8luMaCruMJysFkcc13ldyR5eay95LxF3g/nOlyz722EORttxLCtizI3bW+RpDdqRpSJCUs/ncYN4DkIVyceOHYvlHbKEdhl1D4/yjzpGq+bEzkeMxMDckBf6spm2a29cJd8s3lDVAOzSPPWiiwT1qFAukv+Dl5Ps4O1c0n4z0/AS1zXYWga6ptGWZkq3pNMrl117/wi+ilssTmK3eIZB1su9VB/iK7P3sSz5JRcdwgw/qo3UQA84HlEsPV5snVPCd4Z6cLdCpx67OaPiUgtuRIKhC2tNESrkzwKIsaPq+wzxFrdUbBVosh1zNTwniicXzS8ivXzRRl30Jv2ogoV77rAXGkh88g2Uv+ZKka24xY2Pp8Hmz/wjX3uJgWmjSoTUv1c9tgrzk27m7ITLBZnIsIB34zjdzb76h9J3aHTixyFTwTk1+JXGxNU6DtcySmmenk5TDzSXmj0QpIyFhJIMGk4i0bdevrLDayoJNzL9pJhRb36wpm+PMaKCw645tB3IpmfXEZCapkIVHu0ockYxFWsJEPOBoMQ4L9qBPbDu7WYPgxHvsdhVD+kZnDvulSpQ4R1tQ9NaSdKv9M+jg9WUKbfBIZDnFOWbn6IgKlhbI/IJA0Nbi4ZHpCA7uYtUOtyVvZzNb1ntT1pzyi2Pl6gg5wddHL3SfKUjsYEMaRnRcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39840400004)(396003)(366004)(346002)(136003)(55016002)(66476007)(52116002)(54906003)(7696005)(66556008)(2906002)(8886007)(44832011)(508600001)(66946007)(33656002)(316002)(38350700002)(38100700002)(2616005)(26005)(53546011)(4001150100001)(5660300002)(186003)(956004)(36756003)(1076003)(8936002)(86362001)(8676002)(4326008)(6916009)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kDkrgU9vuxd1PeB8HiM5pbh9VskUJlUclG3My2a9nxGqhLxnyjyEvXHySz2L?=
 =?us-ascii?Q?gbssfDhYNrddVhGpjt7/g5H0Bi2ACTMq8FZnZa5XIibMfzp5mOHDRSZrEyFB?=
 =?us-ascii?Q?jDbgw7+J2nDuXVGh3SYN0mWkTHUdq5VV/xpTk6CmA4IWFv1mjK50N6X4K0gQ?=
 =?us-ascii?Q?/RIT0GvGtNFj5sCavCn0H/UYfeVVbXoGSuUIjhnILOi9hfCfcQ3rEV+DN/OT?=
 =?us-ascii?Q?lb7IuCIJY9xr6mV3b+2vpLTGm86RACTww7fZaH929ptr3ytTiqackw392d7O?=
 =?us-ascii?Q?SOy55bwso/cD2m8VqSVM8cX0d8WJxLlURxRwy0ZqyFSaLjytpfQfIkH52U07?=
 =?us-ascii?Q?eIf5Y7wU54WxGNHmlng4cwvryqSS2bZ08Xojs1RwfKCiUoogYpSxoqtD5u8o?=
 =?us-ascii?Q?EOA99Ku8L8QPHd0l9HkU6v1/wV2M0sjdp1wEKy88W4Yu0zFahA/pwIkSQ18y?=
 =?us-ascii?Q?q4LGbYEAhMdcf/qJnUAz7Cv0NnLPyJWKJq2KHF11G/3o8bfJzJw+9zstI5Ph?=
 =?us-ascii?Q?0xXvqW6Rhk2Ra/FAcA9sTr0hj9/3j1Cque9ydhzQ51ffsX266Qypc+AVCmlb?=
 =?us-ascii?Q?I0grbqXxrft6UNdJiagfS446QL7II87dxXSzM6hegG+66qhYxc0HmAPj6swf?=
 =?us-ascii?Q?qBoARPPsLhUOkonVjstwdm2NW2zU/GIu+eDe68f4uwzuDhpqDXMYTud+s0ER?=
 =?us-ascii?Q?IibK+tr+0oKcKtq8nofyThH6s+RaPcxSdvj90+xWTj02FuuOuWk3xo24BKpq?=
 =?us-ascii?Q?llW1yqSjOoFhlQK3icmb7NU6LoTpfDbPTeQgheLk3fnTLi0HT+KmFMpwtSa2?=
 =?us-ascii?Q?s2093FfBkKLvcjN9AaJqLrlUiRE+SPT1jscQnKOUnnfW/o1ShSGmMg4sD0UY?=
 =?us-ascii?Q?YDmc1+20x0bCP+S3J/WOZRcypVHzZ5D+TfvjeT8xknK8Ebz3vSVjD6eGKzOR?=
 =?us-ascii?Q?gyFlcpZ6+0ylJVfqDbjnQa6mUiBBvX9IsY1fFrJOw2/M0N+YpQNZuiufHMVb?=
 =?us-ascii?Q?5lBVcpAU+DfOFSh7OMomdFnBHmqNToxp2fA6RbkqEA5CsGXJZ091XtFtQDYd?=
 =?us-ascii?Q?O3dlI41CHffZX6Ive38vWqlkkPqZsfR5WBt3mth1twIIZffv9RjqbdLS94A8?=
 =?us-ascii?Q?LXiyjbrRdrgMl+dNWdsDLfFwePJnVQwLV8hAFSfk/dOtdpnSzd2igk2eoApP?=
 =?us-ascii?Q?jIc8S77cL2ZETzEA+eJiwWh+UE1Wkga1Z0rqUu8WUyZ+2hbB3rtq64aw8Lmv?=
 =?us-ascii?Q?LkdAXC7Qbb+boylzPJFCS81+Rh87A4eXxR4iGX5mTvZwCoRuTH5WL6FugJMf?=
 =?us-ascii?Q?0BWlXfDm92mxyBM4xT8CXGHQkMYA5FE63jCq/t6PAxxfi460C8Y91yRuuKuW?=
 =?us-ascii?Q?U+/lGWtovHwU53lrOoxO4wGAhx6tU5G+Py/WeByOQJChMBqQmOu8RtlYqO8Z?=
 =?us-ascii?Q?nXYI9tOtGeO+jw6+9QVnh5VvP3Wha/F+AX1Q7Fjk1LuV3IONt/Eb+Z0lhjCa?=
 =?us-ascii?Q?mUIlct3SX2LEm6KaSqgSOIDgYP2UsBxkzIpOjVrG5LdwKQthLXaIPhNMp3u+?=
 =?us-ascii?Q?vcI2zc6VTnutNcvEmWJT6St8rkp4YG6K0x6UU9/yBIN3hQ0Td6Atj7qyO8iA?=
 =?us-ascii?Q?cNPsQDfCp+QZIe3SSpkAdQj3pEf6YN+gYDJnVMXEtelfwS58d5sOU8SslTTl?=
 =?us-ascii?Q?eMxovd6xu8v9FfA0hQ0oFHNSzEY=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b76125e2-9306-4cc4-1408-08d99dff7b12
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 12:51:25.9128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UUvgA6MOX8e9036ToWlz1TxdiDn+2MeCH79r379pzBFVWT07iuikTWsswkvSquK2Ajdp3spGMc86On2cO4i4T3Npx5LOJMZWqEGlJdcUmW8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4795
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 01, 2021 at 10:01:28AM +0200, Vlad Buslov wrote:
> On Sun 31 Oct 2021 at 15:40, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> > On 2021-10-31 05:50, Oz Shlomo wrote:
> >> 
> >> On 10/28/2021 2:06 PM, Simon Horman wrote:

...

> >> Actions are also (implicitly) instantiated when filters are created.
> >> In the following example the mirred action instance (created by the first
> >> filter) is shared by the second filter:
> >> tc filter add dev $DEV1 proto ip parent ffff: flower \
> >>      ip_proto tcp action mirred egress redirect dev $DEV3
> >> tc filter add dev $DEV2 proto ip parent ffff: flower \
> >>      ip_proto tcp action mirred index 1
> >> 
> >
> > I sure hope this is supported. At least the discussions so far
> > are a nod in that direction...
> > I know there is hardware that is not capable of achieving this
> > (little CPE type devices) but lets not make that the common case.
> 
> Looks like it isn't supported in this change since
> tcf_action_offload_add() is only called by tcf_action_init() when BIND
> flag is not set (the flag is always set when called from cls code).
> Moreover, I don't think it is good idea to support such use-case because
> that would require to increase number of calls to driver offload
> infrastructure from 1 per filter to 1+number_of_actions, which would
> significantly impact insertion rate.

Hi,

I feel that I am missing some very obvious point here.

But from my perspective the use case described by Oz is supported
by existing offload of the flower classifier (since ~4.13 IIRC).
