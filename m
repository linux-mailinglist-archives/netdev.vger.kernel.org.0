Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F79434FAFA
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbhCaH7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 03:59:48 -0400
Received: from mail-co1nam11on2069.outbound.protection.outlook.com ([40.107.220.69]:43565
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234273AbhCaH7q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 03:59:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eRtYawaGqvWuj9c03ddGU81p7r0k7tiqvxFtPGJkCd/9VFSwEH256C99rNE3gOtySf1M4loAo58X/tpeAvNXfkwDLYpv0HpHwNQMOT9602n1dAAISQpC0ElzJuS2OqcLjeqBCllrjPmjlNrs3dKSk7md4OALlrfzbYT8792RTj5XC/UevPOrnERukqx9ATr6tfRuqiuv2xoYQlg5zKeIQmzq0+Hw4dd8ajsgRpbUT81UDMQzIoxmqH0Fz9aGYRkrRQYjNXaLsMcVyuxkSoDpSSjMEn0TybSPo6KX8SFYfsj4d94qyTn9/kiE63e68lVx7gP8GttcFsijueW9b4Jh+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GCexuLTxgP1kr4moKiS3JDsfUSw4LNw/1gqSahYVQ/w=;
 b=TzuwIzXZRk6sADvVUgigk6atG+AY71DHb6IijTnyiHSGIppgRbCRvxoBvAk9IFcFvowkCQSPPbQvTdjlKy0NsQVCw4VZxFNQtJaZjgYyobBJb9HMIIdCmuGmyqodMiHTsOCcCrtY0K5IY+TBL8waIIjmTKKn8+O9bMYEUAzh1EoYH5nxMv/vUW2ZvGhVRm64ivNrft+JiZQeJzGXUYkpA5FrpYoFBKit+PgVaR6TMhuQ1TVBBvt9Dux1Q9BwbO79TskG7y290rGKpFEtn2PUOi3/Wk/8i090T5sOUXSL7AcFiYV77ve6sUehEFTDU00zhYwrc4DOtcPy1vyQLRfHMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GCexuLTxgP1kr4moKiS3JDsfUSw4LNw/1gqSahYVQ/w=;
 b=ZYxbi4LtxB6UjsdY8Wwv4/oE8UdM9id1v4aW4iuEB13FXCYpd8iD+0dt/5bpRfliAO8aayp5JfmWtGCfRWMzop2swHHoFj2gnlKaGIrAKa8fTcJkk69lW5TbpylDTG6gGVJ8yHuHaZgqf6ifU1xLDP0PNZU3e0P3PoASxyMGFwDVI0hFG2xnOcx+gBgtKZMxNGgoMZMywACbRyL5MQQmWOHtwU9xo1kYOWDiwVFEMQHbzrzPg44lAcIAkHwlhpEpuLx31Dn0G78RI9sTkWhKRPD6Hbr/OoJjeemIoke/t1Gg1zt25tWLGTI/ReKQJMLFCGtmj06EXhtEydsUsDW5sQ==
Received: from MW4PR03CA0165.namprd03.prod.outlook.com (2603:10b6:303:8d::20)
 by CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Wed, 31 Mar
 2021 07:59:44 +0000
Received: from CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::19) by MW4PR03CA0165.outlook.office365.com
 (2603:10b6:303:8d::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26 via Frontend
 Transport; Wed, 31 Mar 2021 07:59:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT005.mail.protection.outlook.com (10.13.174.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 31 Mar 2021 07:59:44 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 31 Mar 2021 07:59:40 +0000
References: <20210329225322.143135-1-memxor@gmail.com>
 <CAM_iQpVAo+Zxus-FC59xzwcmbS7UOi6F8kNMzsrEVrBY2YRtNA@mail.gmail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH v2 1/1] net: sched: bump refcount for new action in ACT
 replace mode
In-Reply-To: <CAM_iQpVAo+Zxus-FC59xzwcmbS7UOi6F8kNMzsrEVrBY2YRtNA@mail.gmail.com>
Date:   Wed, 31 Mar 2021 10:59:37 +0300
Message-ID: <ygnh8s63hhxy.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52b5c3a5-cab5-4afc-6d15-08d8f41af21d
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4262ABC3C91CC8FD1C99A48FA07C9@CH2PR12MB4262.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EwtG37koOeF0pVWrrzMwiWBA3IXfornRFPS0PDSCFLJIKkzBXLTTB5ntDZoGSJNy6G5/dRkoNxORah/GVI+PbJ9AMr7lnJABy15MQ8bfEMnhGmE0bWKoUGN4DLSuv3YJq5LABXTgtVjtgOT56t4BMC2efp8rrx0fUGlMcHzQQZZ43zMCiXsd06tK/AJli6j2CI8b5i+7WugxyT7KFDSNQY2AvnmLTiMhnE6yNXowy2iF+oNaLuF11MLIHsZAihHbUqHYwEMnjI3w1SNtgvQ+mf9jHhpLt5922UxDnOw4GOu3CohnXmRaqKEF0iTG0OKLioKzJqPkjoGuA+aED9GafTCVyrTxrsvZGaEhac1Ouqv9kLBTQuRZQPP9RGO6GPF+d+0P/TEshTnmduoZWqG8vUyFdxic5yt70NN82iegARc42W7hVzo53bkGMQuzUCAA9flwY5BrA6bUJdMGHj8kbIQlGwwDFGM60+QqKLL7Db3Faxv+U4znC4xN5UrAspH0PH58I+dTh0KFLsqZ3C5kdOQs9btiMxm38rlBDse6fwR9Y4Kob8cYulecsQXxKpVovLgwrU5GYNoizUilr4PSDu1HLOdjretmcNqGqURMgnR0aWEUUdDzHL3Y+jvwOdwxN1pXILrixVXZFR/TUSOKUhs9zFyAK0uvsjsXGPqnKBg=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(46966006)(36840700001)(7696005)(36906005)(36756003)(4326008)(186003)(426003)(36860700001)(7636003)(2616005)(2906002)(316002)(336012)(54906003)(26005)(356005)(53546011)(82740400003)(83380400001)(8676002)(5660300002)(8936002)(70586007)(16526019)(478600001)(6666004)(86362001)(47076005)(82310400003)(70206006)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 07:59:44.0237
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52b5c3a5-cab5-4afc-6d15-08d8f41af21d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4262
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed 31 Mar 2021 at 07:40, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Mon, Mar 29, 2021 at 3:55 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
>> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
>> index b919826939e0..43cceb924976 100644
>> --- a/net/sched/act_api.c
>> +++ b/net/sched/act_api.c
>> @@ -1042,6 +1042,9 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>>         if (err != ACT_P_CREATED)
>>                 module_put(a_o->owner);
>>
>> +       if (!bind && ovr && err == ACT_P_CREATED)
>> +               refcount_set(&a->tcfa_refcnt, 2);
>> +
>
> Hmm, if we set the refcnt to 2 here, how could tcf_action_destroy()
> destroy them when we rollback from a failure in the middle of the loop
> in tcf_action_init()?
>
> Thanks.

Hmm, you might be right. Also, the error handling code in
tcf_action_init() looks incorrect:

err:
	tcf_action_destroy(actions, bind);
err_mod:
	for (i = 0; i < TCA_ACT_MAX_PRIO; i++) {
		if (ops[i])
			module_put(ops[i]->owner);
	}
	return err;

It looks like here the modules for all actions that successfully
completed their init has already been release by either
tcf_action_init_1() on action overwrite or by tcf_action_destroy() on
action create. I'll try to come up with tests that validate these corner
cases.

Regards,
Vlad
