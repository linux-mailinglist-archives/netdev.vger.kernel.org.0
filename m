Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48058355C39
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 21:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241324AbhDFTfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 15:35:43 -0400
Received: from mail-dm6nam10on2062.outbound.protection.outlook.com ([40.107.93.62]:38497
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241315AbhDFTfn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 15:35:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nuQN27uoVP6xQM4b9H+e66mvE66FcVx/446gFUUTw8/NAtbM1Z/cZt3s1GgD1r4jB0LVP6EMLnoy93dIu2+RvqOnGl/Lzyc8HHMKHWU4qMNkftZTEHShiHpmy74gFgGESh8l2YqxkEH2bF5xwuPcipQIWohqNg1kh5TRhBtgCLinjFldWG3TmyNVLQBEJvs6B81Fur9nCfOvHrdDxQcN6tT2nA6AgPnykn64qCpEtbKI1oK0AQrA17p6NDWIMrsHstMHsAodXvYB2Eh9cEsYLAm0Y9tY1IUcosM40nbZU33/DsM2AHA2a+5SxPP+ugBXOQ77Zk6iZMKsILvRC+3Bkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=efSRLYBdiEqEBn2PxVl9/i/Pia3FeCUii/LQ0qurFz4=;
 b=F1681w9cmibIvPeQxFZfLWPh5YCxZfKpiZo06yXtIhJMi+/HG3RSE1YqS04YaeYgYyvgTdO7wtNnVjS5YjvyFjQLHM6SLtX3DKsg+hSeLyYk/SFWYybzgLJJqtsPD6BnFc7e0oAv1DXg4e57WyLPkYYPTIQRT5CraBU/2/aUqSkaGHijl91lD1rDa2Gh/K4oi3Y6S/0n0XEGEyKB8n8c4uhqV3oPh9Cg2ZpCiY9wqaY4DdaKRkTp7/LU30pmDqtzzMObTQVmLqve4tVm95Wwno44yUbcrByzA8hkzDiLrzQ8hCq3pxgRIZnxS5JC3FDUhLF54A0bAjLmqfMJY1DL/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=efSRLYBdiEqEBn2PxVl9/i/Pia3FeCUii/LQ0qurFz4=;
 b=Ge/PBL6cGl5+DIgZAwy/N02cnEo2OinFZ+O8kdQ+nl5Olik5ixktQ1CXZ04NRidWy0mReDFFay0J4l+0oDS8tLG7XRrHLKy7HObS4GkLWuqUiysHkQxnHo2A/ODRU2CH9IL9XppLMRvMbzfCirNEzx/n18rbY4v8OwHDZ3qq0XfAial9JZMAZ0bWt5VweB6n3ywQ0tOwy9QnEBaTL8wLn6qURxpld3z/8arbFt4QLc+sFrTDxNCJ1GWJWIiIX3gccxHDVOWKmXoJ03xxlO77Qa6u8aZEnz9yIZRS21LBHT4vM+OT03lKj+anJ1ydGI1R5GyChQgAhggfkeX6QuUsew==
Received: from DM3PR14CA0132.namprd14.prod.outlook.com (2603:10b6:0:53::16) by
 DM6PR12MB3961.namprd12.prod.outlook.com (2603:10b6:5:1cc::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.27; Tue, 6 Apr 2021 19:35:33 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:53:cafe::5d) by DM3PR14CA0132.outlook.office365.com
 (2603:10b6:0:53::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29 via Frontend
 Transport; Tue, 6 Apr 2021 19:35:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3999.28 via Frontend Transport; Tue, 6 Apr 2021 19:35:33 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 6 Apr 2021 19:35:31 +0000
References: <20210331164012.28653-1-vladbu@nvidia.com>
 <20210331164012.28653-3-vladbu@nvidia.com>
 <CAM_iQpXRfHQ=Hzhon=ggjPJGjfS1CCkM6iV8oJ3iHZiTpnJFmw@mail.gmail.com>
 <ygnhy2dzadqt.fsf@nvidia.com>
 <CAM_iQpXx4Ex7-=u5W7rDtykbSL0bdnzHhhVJ12cVcswBWYx_5g@mail.gmail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Kumar Kartikeya Dwivedi" <memxor@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH RFC 2/4] net: sched: fix err handler in tcf_action_init()
In-Reply-To: <CAM_iQpXx4Ex7-=u5W7rDtykbSL0bdnzHhhVJ12cVcswBWYx_5g@mail.gmail.com>
Date:   Tue, 6 Apr 2021 22:35:28 +0300
Message-ID: <ygnhv98z9pfj.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9187c03b-bffe-4a3f-991d-08d8f9332545
X-MS-TrafficTypeDiagnostic: DM6PR12MB3961:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3961CE39F0340CA8D4F4C162A0769@DM6PR12MB3961.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1013;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TD/1JZ1EbjR9aF2iPDHm8IF/UFQE9VPABL2XffK93vfJMqfbxv0C3ViLdjokFrJKVHHaQyGq2uFoIGkqisMWa9gPAM0sNSLyDDLQ5pqkiyM5ZZynCSDjF9CR//p3xrOAns+2zX5c/947yj2+EMT7sBbtoGz5SZOZJ3Ar02uthxUcvDNcY9Je1gwBhKu138IrWcsrpoHdi8ERE/RBGEPevobxJx7OtdXQ8ecfyjs4qAkosvQoX0zlx7Q/VJAmhYvUBRtgl8tX3IQsZSUFQdAIvUU51swwE2pBHzKKFz6Yvyqo6OqinEmsw8uGhX2S12YO9EDK3GoN/wXXYQ8i00VGq73bIiSh5Va/eVqQDj6hUeGD9CpXyN2S8K4kVbGJFbuxYtxpmXANHAF5HsWiL1H9tQpVwX+DqXiDBEltvuPZzZSbJ/QNb2TLRFLArEUfl2sXpD0L4ro009aTYTq1U3XIIxfbeBbWXEfzodXVeMS0nRirNZ6EI8vLLvBabQD2VKzhxmjYC29hgzMagfRstpr2igSTG/IIDYcqvHNYuoNWofgDIfVm9yegnp4i1TJ88wuzKBk7GuVpS6BHXyk9gPqq4tbxIvDdYgmq1uYRoA74fsS2m254ASH5GbSCY4C9G3AUaJQoox9C436+8ur1svqEca3H4W6JqV7PWTVy7s++RUs=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(46966006)(36840700001)(16526019)(186003)(47076005)(82310400003)(8936002)(2616005)(316002)(82740400003)(4326008)(36860700001)(6666004)(7636003)(26005)(336012)(356005)(5660300002)(83380400001)(478600001)(8676002)(6916009)(70586007)(426003)(53546011)(70206006)(54906003)(7696005)(86362001)(36906005)(36756003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 19:35:33.5852
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9187c03b-bffe-4a3f-991d-08d8f9332545
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3961
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 06 Apr 2021 at 01:56, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Sat, Apr 3, 2021 at 3:01 AM Vlad Buslov <vladbu@nvidia.com> wrote:
>> So, the following happens in reproduction provided in commit message
>> when executing "tc actions add action simple sdata \"1\" index 1
>> action simple sdata \"2\" index 2" command:
>>
>> 1. tcf_action_init() is called with batch of two actions of same type,
>> no module references are held, 'actions' array is empty:
>>
>> act_simple refcnt balance = 0
>> actions[] = {}
>>
>> 2. tc_action_load_ops() is called for first action:
>>
>> act_simple refcnt balance = +1
>> actions[] = {}
>>
>> 3. tc_action_load_ops() is called for second action:
>>
>> act_simple refcnt balance = +2
>> actions[] = {}
>>
>> 4. tcf_action_init_1() called for first action, succeeds, action
>> instance is assigned to 'actions' array:
>>
>> act_simple refcnt balance = +2
>> actions[] = { [0]=act1 }
>>
>> 5. tcf_action_init_1() fails for second action, 'actions' array not
>> changed, goto err:
>>
>> act_simple refcnt balance = +2
>> actions[] = { [0]=act1 }
>>
>> 6. tcf_action_destroy() is called for 'actions' array, last reference to
>> first action is released, tcf_action_destroy_1() calls module_put() for
>> actions module:
>>
>> act_simple refcnt balance = +1
>> actions[] = {}
>>
>> 7. err_mod loop starts iterating over ops array, executes module_put()
>> for first actions ops:
>>
>> act_simple refcnt balance = 0
>> actions[] = {}
>>
>> 7. err_mod loop executes module_put() for second actions ops:
>>
>> act_simple refcnt balance = -1
>> actions[] = {}
>>
>>
>> The goal of my fix is to not unconditionally release the module
>> reference for successfully initialized actions because this is already
>> handled by action destroy code. Hope this explanation clarifies things.
>
> Great explanation! It seems harder and harder to understand the
> module refcnt here. How about we just take the refcnt when we
> successfully create an action? Something like this:
>
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index b919826939e0..075cc80480bf 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -493,6 +493,7 @@ int tcf_idr_create(struct tc_action_net *tn, u32
> index, struct nlattr *est,
>         }
>
>         p->idrinfo = idrinfo;
> +       __module_get(ops->owner);
>         p->ops = ops;
>         *a = p;
>         return 0;
> @@ -1035,13 +1036,6 @@ struct tc_action *tcf_action_init_1(struct net
> *net, struct tcf_proto *tp,
>         if (!name)
>                 a->hw_stats = hw_stats;
>
> -       /* module count goes up only when brand new policy is created
> -        * if it exists and is only bound to in a_o->init() then
> -        * ACT_P_CREATED is not returned (a zero is).
> -        */
> -       if (err != ACT_P_CREATED)
> -               module_put(a_o->owner);
> -
>         return a;
>
>  err_out:
> @@ -1100,7 +1094,8 @@ int tcf_action_init(struct net *net, struct
> tcf_proto *tp, struct nlattr *nla,
>         tcf_idr_insert_many(actions);
>
>         *attr_size = tcf_action_full_attrs_size(sz);
> -       return i - 1;
> +       err = i - 1;
> +       goto err_mod:
>
>  err:
>         tcf_action_destroy(actions, bind);
>
> The idea is on the higher level we hold refcnt when loading module and
> put it back _unconditionally_ when returning, and hold a refcnt only when
> we create an action and conditionally put it back when an error happens.
> With pseudo code, it is something like this:
>
> load_ops() // module refcnt +1
> init_actions(); // module refcnt +1 only when create a new one
> if (err)
>   // module refcnt -1 when we delete one
>   module_put();
> module_put(); // module refcnt -1
>
> This looks much easier to track. What do you think?
>
> Thanks!

Indeed, your suggestion looks more straightforward. The only thing we
need to mind is that action->init() callbacks assume that caller
releases the module even after calling tcf_idr_create(), so we also need
to modify tcf_idr_release() (used by error handlers in action->init()
implementations) to release the module.

I'll run some tests tomorrow to verify that I'm not missing anything
else.

Regards,
Vlad
