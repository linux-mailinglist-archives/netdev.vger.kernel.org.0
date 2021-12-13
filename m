Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4864D472FBF
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 15:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239372AbhLMOuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 09:50:07 -0500
Received: from mail-bn1nam07lp2041.outbound.protection.outlook.com ([104.47.51.41]:37996
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230122AbhLMOuG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 09:50:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KFtctjxQ5ya2B9MGceMEFAeOpgji93xPx01eCGJWB+gWnFKqBoj3Y7iRMQmI9RU+roiQ7QjLN1BMlnCA8m5dSCBQ+VlT0LMbJCe+tgQaBHllZV3kmAMvoj9Thb3uc81kiLRHrQnSBN0nElfbek8s7FdFbXCJZsguMu/2+X72aiiAnor+05juMxIVx1PPx7YjyhO2e6X8FK+kioVDQZLrFIoulGvA1eBlAjCF/+CPov2X6z6V7jpE8SsyWUpoESHPJvBAvHxXk3seVJ81riEOuxkBxrRmf6duE20Z0JrKCUtH4Qx/fSN1a40NLgl8NHhEn2/WRlL9bvV0r9n59UJyng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7+sCz98cMGuoEejX6/JU7StP6agmyv+Smn0WFDxviMk=;
 b=IdM1xZ1OHz5uXGy55O+Oocz/1SwYFdGfqV41PYNA+UA0ERrao2VF/9ZqA/7QlErokH/PH3JOiTqdzNZRa3ZsjftopqDpgAaEdtRU0CKRKNuWCuXstcNYH4YDmSErIaHy1BRD5p0/sReu/upnZZDnh+8UPWAoKinZUMGmaIpFp7RWvVQcMWquS3v09Gon6YINOqUN5dIPPc0kyuqD+Z640TcaSkvUwoM53cmTVwsVHQ9cjRD65kp6o5WFx7d5w3l8Vgs9DPkyMNpYazj6YqNwKK6agflb0k6VaYurloRN2xo08Hf+wenV+RYOT1mh9V1h/lhJ+MrbEtWvXhe6rAVW8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+sCz98cMGuoEejX6/JU7StP6agmyv+Smn0WFDxviMk=;
 b=k6HWjXZ4/llrdbaDfTJiiultE6ytJ8FeT/X59VXHgM2gSGMFZE+zvPY8Fou1UcRGe9NK7FEQPyThgpTzjB7VdYJUd9jbeY41lFzXtw6KPM0gsZQ+IaLrfsMZ04WUT/RioL/Zq+0ctkVcP67A+LaCpl7uGylifWRu9tyY2JeaNuU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.12; Mon, 13 Dec
 2021 14:50:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Mon, 13 Dec 2021
 14:50:02 +0000
Date:   Mon, 13 Dec 2021 15:49:56 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
Subject: Re: [PATCH v6 net-next 04/12] flow_offload: return EOPNOTSUPP for
 the unsupported mpls action type
Message-ID: <20211213144955.GA24044@corigine.com>
References: <20211209092806.12336-1-simon.horman@corigine.com>
 <20211209092806.12336-5-simon.horman@corigine.com>
 <6e56aa1e-25a2-9bb7-aee3-6a2954216b73@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e56aa1e-25a2-9bb7-aee3-6a2954216b73@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0PR02CA0119.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1aa0cf04-3857-41dc-18c1-08d9be47d80f
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB48420E9CDA90BF018068713DE8749@PH0PR13MB4842.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V4HFbw0BqXQ/3a3ocdtmUktRhnyHrsLFCP5TiYz4LxBuVoIUKfCTYVDNJCR4/FcjCC4o1rwSPq8lGCzNuQ0k2E72j9PXlH0VX5uTykx6MJ7PqLnZZb242r5jQV+A0w5MQMQ/KrahrHFlNlctrnZQ5H6D+yzhhTYQRaP/rV3Gv+BKQDLBeNyDrtEmrhCCpPVynvfIautpyRUen8G7s3xwz6OXtdx6vZZ5E8AWtX/7wqSAOHz/tFgO/iSBDGrP8vfEQNObH9qJ5CK2el+SIqf/xWqghLMNg6TQpF4mklQ82d44HyA+glGrDPYzl4Fr4WCCahJlxh/cipLtUqrdaCdI9TAsKSqMc4AEooiQLlPHhKNUkgWtPnRslY/RBE5rf++kj0AXe179Q71Pt1ZJvIPubPksq6tpegJMRrYHDxwnIwbY61KZYk1DiYjF9o3tiAB5jD5ZSptt4Bh5h+agWt9+we3eJNN1pOBtBfyq0VO+Jtzgrky5U3BNoXNgnK1cHoQJ3srIyIppZoAmBWbGxV5bKw7VAfsAlE5nu/XZri76kHpetP+FEtBlqflZ8SXKa0bPaYsbXcuhqYR4V3C49gvp4w/i7BCU9QM6osEBX86aYLcdSS6EVs1gb2wEaSTXZn4qemgbsNs7Iv92st/6yZvjly8HHRBRUgm7RL7SYGkI+bow+ZOS1mnhXzr3ChrH8xOteZ4VWBGYA/vl/OCFsJphXoAIWPij2UgfzmD5/iakmAA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(39830400003)(396003)(346002)(136003)(366004)(2616005)(107886003)(38100700002)(5660300002)(316002)(8936002)(86362001)(6916009)(8676002)(66946007)(1076003)(54906003)(186003)(66556008)(66476007)(4326008)(966005)(508600001)(52116002)(44832011)(2906002)(53546011)(6506007)(6512007)(33656002)(6666004)(83380400001)(6486002)(36756003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0TRdzGYVZgo+4MAsXlvNUtJyaQKBt+6BTb98nKYwgQ6J2FtmF7QE55yzxlqK?=
 =?us-ascii?Q?lFWPbTnuHCXgEEkrA5JpehlqTNLx1hVhydgi+ZyUphTuf7b/uonryChSvj/L?=
 =?us-ascii?Q?wkwjycdi1bNZi9xPcyQaBMqG77PtBxlcGjmO1OTCAy7k62MNOUfRjXZVdc0A?=
 =?us-ascii?Q?oZlz5jGt0jRxCSkgvpHqAC4nkn6YzWEyqfAF1wjZ68blnIjuKaJPtQxXBXBh?=
 =?us-ascii?Q?hg056VZfjT1oF0qd8oPhasIbwNnljdXVXPh69VhTI8l49S2Uq785oA8MuDHP?=
 =?us-ascii?Q?2YiDJUXS7LdNvlISJF3tvbRiI4u9JEoIiOWIVNt+xD8zrEwF9+c8nwB2ruWo?=
 =?us-ascii?Q?MJ7aqTy/haGhnBF5Fn8GsqNhVOFRUxt0OiKYW0lxIZ3ygDBA0akQ6w2Rv4Bt?=
 =?us-ascii?Q?jxxwYwZaxUErO62ISA8MKaSssWTaJlu5QDu5+rvzXGJZJdjrPeyoyE6YLkvi?=
 =?us-ascii?Q?GEmrDr0f0+xtDYASbiIlB6NwYuVEOarBpkvBPDHLW6ZE7u+s0avISMVOQB+H?=
 =?us-ascii?Q?XwIi7rKgvSww3euYzJ3jurHMvJBrhEeNwV0XGJ5Qc45MaVCtwP+3M1essE4O?=
 =?us-ascii?Q?1FXSe5O6J/DLsibsB6MqkJWYxQhCT3AzwReyE5Si9YhtwLht4GAAYc+n8h7Q?=
 =?us-ascii?Q?FKlZf3LYp7Mk4Ivg1tdJpk2LOL7W05nNjcC3S+GGjA9VXSDRxhLJ+YPDrkD7?=
 =?us-ascii?Q?Z+4x5GZT37vq2pK1AMj3KnK/HCowIV05TDnUpmwcw7jcSrhTUdHkrdXxvn0D?=
 =?us-ascii?Q?BOnBX2xLv0R+cCpj2rzJ4Ua0hvulu3j3iopvbPlnKsROsS9e1cK7s8gdS4mb?=
 =?us-ascii?Q?OUz7lKJKE3OOF5SV2O3bq6VrBzczd91cbPLsuvQvJJPS6OdK3SE8v6BJ3haJ?=
 =?us-ascii?Q?EsvRW7JVJrGbIxgWGYVn7n8CTZwb0k9m0hPxbhgAGfj1t7WecU1EGTbXUZVQ?=
 =?us-ascii?Q?++yd9XUqjmf0Td/56wRPyx1QfnHyQft0hOS5bGEScAWmHofLHbA4p9Q/TDX9?=
 =?us-ascii?Q?A+l9VO79ef1FfqiF/Q3lZdY0z4QKTmPvn/38Z601GAfirh5TVSTJzCGhrgYh?=
 =?us-ascii?Q?lb4qHK5nnTIOvz7LQ7kLb/7AvkChw+e6CNGKQT8qjGOGhufyDV5XuVsb0CO0?=
 =?us-ascii?Q?QLpsfn6eRJymES0HE+Zwh7IYVrmga/GT8Wfr/gDnS8qVoyC1uSy6Ik4JQvFm?=
 =?us-ascii?Q?f7Y/jKeuAcvcaiJRw7dTpeJiUR/xBMCRWLaHzKiwbJ7qtxpLxwOvPpiSrFOm?=
 =?us-ascii?Q?TeOcXUC/ogyer7dXpmCZvLPh15an6tqr97L9t9qyv0oIeEdZf5pGyCzgji2s?=
 =?us-ascii?Q?s33t62ESx6TKNgPyx1g8QeGinnXWoa0J7s9P2dmBwZGPZc3CXAL9lk0kToCD?=
 =?us-ascii?Q?7KAHqLSaBfUNrdKlPS7BVepsyfpK96ZUm2RsVKFXkZLziH9cf0M1z4aS5Lqb?=
 =?us-ascii?Q?FSTLL3VaVGap2I6QqWKlBrXJgP+Ih87cieJIxxWN4lX1NWg3TSgLnZElgLt2?=
 =?us-ascii?Q?tI2XkBU25WR2CZ7nCO4NUgDONk7VJkxUaEDb5zxZLZpgthJ1oBnn8v6eOwDZ?=
 =?us-ascii?Q?PVCehsCzOgBGRkHgGMY/Hq+KsUDqSl7WAtxn5A6m66N1hxLsgX9lSkywkkVH?=
 =?us-ascii?Q?Vi4rNam+qpTMQBB6l42FSxF3Gi5qWaZMPBsZP2+fVaOGywBmnqkoLwEFz80Y?=
 =?us-ascii?Q?6B3bc63hrHo3GTnH6Y6yRY8gFpH+qBtlzDCFG9avHZq5Yzas6HSzdABNncYa?=
 =?us-ascii?Q?rzuA+gZ45A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aa0cf04-3857-41dc-18c1-08d9be47d80f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 14:50:02.7454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: chYri/Iihdz+LFMwRKmUPbiZeH5ShN95PUV5TpMaUShhiijwEkkH6sO3Nne15hvynHvZmyB3DAdKdGbwQqk8weEsf+3Nj0t0bnJIwUrq4bk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4842
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 12, 2021 at 02:41:53PM +0200, Roi Dayan wrote:
> 
> 
> On 2021-12-09 11:27 AM, Simon Horman wrote:
> > From: Baowen Zheng <baowen.zheng@corigine.com>
> > 
> > We need to return EOPNOTSUPP for the unsupported mpls action type when
> > setup the flow action.
> > 
> > In the original implement, we will return 0 for the unsupported mpls
> > action type, actually we do not setup it and the following actions
> > to the flow action entry.
> > 
> > Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> > Signed-off-by: Simon Horman <simon.horman@corigine.com>
> > ---
> >   net/sched/cls_api.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> > index d9d6ff0bf361..7a680cae0bae 100644
> > --- a/net/sched/cls_api.c
> > +++ b/net/sched/cls_api.c
> > @@ -3687,6 +3687,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
> >   				entry->mpls_mangle.ttl = tcf_mpls_ttl(act);
> >   				break;
> >   			default:
> > +				err = -EOPNOTSUPP;
> >   				goto err_out_locked;
> >   			}
> >   		} else if (is_tcf_skbedit_ptype(act)) {
> 
> should we have this commit in net branch with a fixes line
> so it will be taken also to stable kernels?
> 
> 6749d5901698 net: sched: include mpls actions in hardware intermediate
> representation

Thanks Roi,

I think that is a good idea and I have submitted the patch accordingly.

https://lore.kernel.org/netdev/20211213144604.23888-1-simon.horman@corigine.com/

FWIIW, I believe the problem was introduced by:

cba370a93684 ("flow_offload: return EOPNOTSUPP for the unsupported mpls action type")
