Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18693DF0A2
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236746AbhHCOsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:48:09 -0400
Received: from mail-dm6nam10on2093.outbound.protection.outlook.com ([40.107.93.93]:40064
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236687AbhHCOra (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 10:47:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=itumNC1scQTgGmDfEqDGT/WVcTLbBTH+JT6rKu1qbk19gkr6dyA/pzJY4/CBdlYefS+Wpv806fTe1W9/tMyHbKqt1UXYsPEP9iIw9rw+mgMjYL6L4Q0uBS2ErNslcGEq7K8uF9TclxNcr9NGx2bpRssWdrFLbBtuOSjMhvKip7PpTvA0w/Vn3uQmaiT31fJTT5H8hhDaoyf1UgdNbnBDM63Ig27/bZ+FvKxeZwo/6U7Z5XcjiHSNQzrN2hlRCcmoFrwIuuO0mkTi/nrwEhbHR9l6hKMFErSVKX64iopthP15AhmnZa3PVgI4fuvL27jprlXGjrbJBXefbVO0KiL69w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1XYCORuAY4Jijg29t/w2JzfZfyZ7oAh4xv8zm0IMGo=;
 b=nXKa3YSpWdgqcTjBET9fGe1omJWDBYUjcdBxxIztcmjzExRn7L1JbfGOUzJQA99rfVOPcT6QYgDjI1lmDvdvo5/KNQtXo2uvfOPHAeFyqZBvPbOE0I0VtvWQxz9Ws1RCyGYhAMuUchBojP67JVybZUNpBK+ZjxZmQB4d2WyLGqhOeSEvRrHSSLKAjBTce/8B4IhPaL9rd9MP+NrvzseniRMRnaG8SVKvVCdA5eHJ24MvR7muuJbnh9f+3TBk1WzqR8aEhpBnY+UCxMSJW59nSk31t9c3OP1Xa+10wsqxWE2KV6WUum8Ix6lDTEbrSCtoxubpAcLjR3f+JF4z9JWV2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1XYCORuAY4Jijg29t/w2JzfZfyZ7oAh4xv8zm0IMGo=;
 b=Sh6ASO644xpuSVGsvdH1lV7vl5kkOUDk0OIefZ9UWCOtlnxW2N2jO0lVjmYO+8jflcPzQeQN3nI9oPur1DMYPPAIKYMsfh/cQWeOy3rOdBkcJRAgPWPextmjA3kAj0t6kmm2VGcHdvYY2TW++I2RfC2YSh6nOdgFN7paRczZGqQ=
Authentication-Results: mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4969.namprd13.prod.outlook.com (2603:10b6:510:92::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.12; Tue, 3 Aug
 2021 14:46:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%9]) with mapi id 15.20.4373.023; Tue, 3 Aug 2021
 14:46:28 +0000
Date:   Tue, 3 Aug 2021 16:46:19 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Roopa Prabhu <roopa@nvidia.com>
Subject: Re: [PATCH net-next 1/3] flow_offload: allow user to offload tc
 action to net device
Message-ID: <20210803144615.GA17597@corigine.com>
References: <20210728074616.GB18065@corigine.com>
 <7004376d-5576-1b9c-21bc-beabd05fa5c9@mojatatu.com>
 <20210728144622.GA5511@corigine.com>
 <2ba4e24f-e34e-f893-d42b-d0fd40794da5@mojatatu.com>
 <20210730132002.GA31790@corigine.com>
 <a91ab46a-4325-bd98-47db-cb93989cf3c4@mojatatu.com>
 <20210803113655.GC23765@corigine.com>
 <2eb7375d-3609-3d94-994a-b16f6940b010@mojatatu.com>
 <20210803123153.GD23765@corigine.com>
 <3907f67e-a362-e69c-2891-280cf6c7fb23@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3907f67e-a362-e69c-2891-280cf6c7fb23@mojatatu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: LO3P265CA0018.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by LO3P265CA0018.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:bb::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Tue, 3 Aug 2021 14:46:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b110659c-13ec-4ce9-c831-08d9568d7981
X-MS-TrafficTypeDiagnostic: PH0PR13MB4969:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4969C98A8AF7F5164A004078E8F09@PH0PR13MB4969.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iVrs+ari5/IeSrfzrJ9AoAcDDnqv9itwKa7QKdl6hZz0T8urCdOXv0pk7GQTB7rq787T1PMDsmbTy5sKLY9EHXdpVgKkOGKs5l53TlQM+8VdFb67cbK4wmJicqBjBDTzd5UAz+T7AkrZYNOth4QsPckTDQjBJZXdWabeabvc4blxwPzcE5t1W4BHP7iH+TMuiEHkLx7eSKdpqsrPyDSqEjS5SjtGRXPz2W0gZRYCIw5rrgYVtu7gY86yvzRkN7ETUOHN5x0cN+1a5i8UVkiyuSZ9uhUUxvriiXWV2ZgzYLGQ5ykgpU1ie5QJH3dWOSXXYw1Cd//1NkfR3gQ7WhYVxVAT5pHiHuFCbfPMeZ1iOOdgg9zCtAn3AqLqnMAkiBUDcyAsCsmcOaq1hqAw8rU/kMPgch5fXbR6LXJ5pBxXxINNMF/t4KnUd6xhUhH1+woMal7M4u8SC1TtdG49N8z3FGM9SK4WfGZ5OEKWJJ1Llaw5114GKOHKgXkv4wZxl7RimlUh8/lPKevwsqtZp4YvlbSSwPmR45yECv+ctoU6aRTIwK72UQ2WZrWVA/nY1O6X48oNSf0J46QMQ1mp995vYY1zyZTaeKYZE/5wEqSjeYrOXSqvK60qN1ahXbD5gikhJX3PiXoDT55Eam3jIbm48Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(136003)(376002)(39840400004)(55016002)(2616005)(8886007)(53546011)(8936002)(2906002)(33656002)(6916009)(5660300002)(52116002)(7696005)(1076003)(186003)(54906003)(6666004)(316002)(8676002)(7416002)(4326008)(66556008)(36756003)(508600001)(66946007)(86362001)(38100700002)(66476007)(83380400001)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TjlIFaLdhHhqpXR4P1jVraQrWb/0R7x+Amw7fVCNm9Hk2PGaKa/B3KMSbB5c?=
 =?us-ascii?Q?ptL0ASUU8vSh5/aCfyGSXax13z7wzkwUnuTuslIyOoQKiaQ5wzUroOvUdfED?=
 =?us-ascii?Q?E8UydyecClidmUOnR3d2xDwFBnC0JxOlLdHBwUWaJej13fgMwkLTpiMEWZPK?=
 =?us-ascii?Q?rd8wGoYXWB9o0yCGKADo+zk6h8o3cqlJ48tXHBInkpvBju5oDi3KuQrPCInl?=
 =?us-ascii?Q?/pPLMbPKTZyd3v5jE0+rGAqwEQ7Z3XEyjFrmfVrUzX01tmQ/16d0fh5liANv?=
 =?us-ascii?Q?Z+8903LZA6aqAtNfZko5mSkMQjfw3vpb0+UhrO1UhC2iPOyjHTa4Qn/Uq2Vb?=
 =?us-ascii?Q?j22lDY240dcwX5CvltIX06wWN6Z01DRv1EU5UxM3mP7RDTpv96T05Xin0MOF?=
 =?us-ascii?Q?+mBfyxvB/qwHMvDibgESEAwAn+4GvODy/eIeXW6M1Y7dPB6mPW2g8I6lLnid?=
 =?us-ascii?Q?cNg+oVfAIura40ZJ/ekwuCgiMOz9TPsnmeSqVcVoDkCVdKNM+DbsUdsSwoik?=
 =?us-ascii?Q?hg05+pAscC45XUKEhZCe5HcbVrZpgjkChiPMfXwf8pNWK9sLbLz13HIhgHzt?=
 =?us-ascii?Q?In8aDtaP77mkIvz9l6c6tzrQNigXtmW+HymdJvbjpck9vYsXGRgnquHHDZva?=
 =?us-ascii?Q?ef+IreOgHwXyOxAWTTomdPGldUpEZr0nePA/njYM24iGqrz/oeBM/o8dVz71?=
 =?us-ascii?Q?J2GxWsFd9fGEQo80Gsc/rBQ57Uj8/p3uKHslW9qoZv4Z2hzMi4TffDLoflS2?=
 =?us-ascii?Q?Bxvi8g1XzXwjLOMQfZ4hvm1/Dy42U1YcUHwCHTyFycMZM/6WUF/33+noM1Wk?=
 =?us-ascii?Q?SGvillCqypLGX3dzbRwyof1jTCsChzgVlXDC1RFroEodGN2GY3aT++JY6oO1?=
 =?us-ascii?Q?XI/WZ/VsPyQ2hPMxu8vIhNzrqgqHeW4dyJOpX1mo7+tF5fpejNmxwHZ0gs2f?=
 =?us-ascii?Q?aMIywQwX6UaGHgjyd/4oVoPIBOWc0XRDhuiizFaDJW4RwJwu682wNmkzWecB?=
 =?us-ascii?Q?qKt8b26GREC7Nl+Zl2FR/NV+FtTDoJhq0g4lf4aWaVZusnNex3bIRDIQgnVg?=
 =?us-ascii?Q?5P4PFhSmzwDwIHxy+3D1CgmPbm+Uq3pUmokXvQTPRiE5Il78q1X5Q8cFoEjc?=
 =?us-ascii?Q?5JQ5D1Qp3Sk5TD5fDlQQDrn9M/acof4HetVnlTnrZJVQHrZwOQDevaG/ke4/?=
 =?us-ascii?Q?U1OAO+uZ3/AAJJmYPsmUxmit6rO0fuG6V9GoLjJhd4gSDgymvrIlrJ/0oS04?=
 =?us-ascii?Q?03Kq4nX1pP/Uk1zQrdNBx/Shpihk0tHDp6aHrqxnTrl0rY/x6dZxkbvL/neK?=
 =?us-ascii?Q?0ShPkpbHZw/xiWKci9t0hAkAs/NE6AhZ+kCNhgjErY2MveFZ8PYAYq53sDE6?=
 =?us-ascii?Q?JI+XHcPdDeHlMBdc0nyiraGNzxtr?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b110659c-13ec-4ce9-c831-08d9568d7981
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 14:46:28.0881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YbZmKfiQ1GQxtqLtCeHgBT69ijMFgT/INeRYfri0Gb179MBrQ4MY/4rZe7ftZgPB9+VbKazH36DqgixN0ZyP8OPrqejJ94oTM1mid5tcKPI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4969
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 09:01:45AM -0400, Jamal Hadi Salim wrote:
> On 2021-08-03 8:31 a.m., Simon Horman wrote:
> > On Tue, Aug 03, 2021 at 07:45:13AM -0400, Jamal Hadi Salim wrote:
> 
> 
> > Thanks, I will look into this. But it would make my life slightly easier if
> > 
> > a) You could be more specific about what portion of cls_api you are
> >     referring to.
> > b) Constrained comments to a topic to a single sub-thread.
> > 
> 
> Context, this was on the comment i made on 2/3 here:
> 
> -----
> -        ret = tcf_del_notify(net, n, actions, portid, attr_size, extack);
> +        tcf_action_offload_cmd_pre(actions, FLOW_ACT_DESTROY, extack,
> &fl_act);
> +        ret = tcf_del_notify(net, n, actions, portid, attr_size, extack,
> &fallback_num);
> +        tcf_action_offload_del_post(fl_act, actions, extack, fallback_num);
>           if (ret)
>               goto err;
> ----
> 
> where a notification goes to user space to say "success" but hardware
> update fails.
> 
> If you look at fl_change() which does the offload you'll see that it
> returns err on any of sw or hw failure (depending on request).
> Notification of success is done in cls_api.c - example for
> creating/replacing with this snippet:
> 
> ---
>         err = tp->ops->change(net, skb, tp, cl, t->tcm_handle, tca, &fh,
>                               flags, extack);
>         if (err == 0) {
>                 tfilter_notify(net, skb, n, tp, block, q, parent, fh,
>                                RTM_NEWTFILTER, false, rtnl_held);
>                 tfilter_put(tp, fh);
>                 /* q pointer is NULL for shared blocks */
>                 if (q)
>                         q->flags &= ~TCQ_F_CAN_BYPASS;
>         }
> ---

Thanks for the context Jamal, much appreciated.
