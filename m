Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE355357D99
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 09:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbhDHHuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 03:50:20 -0400
Received: from mail-dm6nam10on2046.outbound.protection.outlook.com ([40.107.93.46]:43360
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229505AbhDHHuT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 03:50:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jUS+K2bvNe8n5K2g2o6/if7R2pZhvQKYV5+0I/FFV49B1m8kbmgcsarq3S8vrAcAk5mjBqrzlnokJq7B/zLfz42iBfmSI4EG2JqvZhe2GMfKmHVwu2VY5l5W8c1fBhySUqrdS07diLez/ihwP4aOQfKTldNhNW1EXNj/CZTwW2dsV4GhWAlxDZKzl4HkNVmGHtfcs5XXdDRW+5MnC6mAPloMBsVBJv8iheKDnisKS96rLrMjBDOKKzZAiikBODqnIFgWafVOwUXXBn4exmBMJqGHp9N5VQSLr/VPtqbMle//Ew8OeHaikrwxdvV55UX3H3bzQCSr4RpjnNs+pbkKvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rna7lMMUo99qerhq5Ydgkz1Z3VLFTTz23wle0FltYIY=;
 b=oggG1iWZaFQMEGZJG/4d95qgyImZN6sli0xENk//5ULec//IrqcUrMZDWL6BPb0AYJ+QDvML3it7hRdEwRrfacqWPVEke9LTiGMOV1JEBLNekYIJJdm3n8r79K7bX2vtyRwVCzY8HAavdJngyi7JW7yEt17z2BjIJ7bJy/XluIwC/jDRWh8EFsp6j1t0ynG/GG6gilGdjuiZDtqgQssZ7X+tdGw1b2kn7NwgqBGkxN4Imw96MTjqVkWjrijmZJSeVLg8c/ugYwWWraAFdtBBlArQsEmzZ6CvxNwV8+OvktqVakOPEujpobWolvsTq7Qt8lsafTBFjMFX7MyqjLVOFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rna7lMMUo99qerhq5Ydgkz1Z3VLFTTz23wle0FltYIY=;
 b=nacIKEl06Es4dj6XiobBBLnwv+W+1m6lhcHpVZbIEFbpUVNFiDIGZZlM94pc4ftj/omCrR0hWz8fc5J+ehbbCi7T8mNjx84SWwRVKoONyRRs4e5omjV3pBfvtDMCaAz6PABYofVodS8FyPQUBzIfcobVOEnmHz/qSCvGfTY9CyD2iW0jo1NvuJAvozgslPOhByEtoqmrIf6uoyG9IQzSNTwPw/MKD1Hh03l7/ojpwkKWcZRIpgUxB1aJUxU6mHCRInOP+nLt7Icgugsq4NknQ6sgRyRxMqhBvTPD3HZssr1S9p843S/Lh8klzH0NpbDRO4o/A6uvrgA/UqKNL467Xg==
Received: from MWHPR15CA0027.namprd15.prod.outlook.com (2603:10b6:300:ad::13)
 by MN2PR12MB3279.namprd12.prod.outlook.com (2603:10b6:208:105::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Thu, 8 Apr
 2021 07:50:07 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ad:cafe::c0) by MWHPR15CA0027.outlook.office365.com
 (2603:10b6:300:ad::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Thu, 8 Apr 2021 07:50:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 07:50:07 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 8 Apr 2021 07:50:02 +0000
References: <20210407153604.1680079-1-vladbu@nvidia.com>
 <20210407153604.1680079-3-vladbu@nvidia.com>
 <CAM_iQpXEGs-Sq-SjNrewEyQJ7p2-KUxL5-eUvWs0XTKGoh7BsQ@mail.gmail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Kumar Kartikeya Dwivedi" <memxor@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "Marcelo Ricardo Leitner" <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
Subject: Re: [PATCH net v2 2/3] net: sched: fix action overwrite reference
 counting
In-Reply-To: <CAM_iQpXEGs-Sq-SjNrewEyQJ7p2-KUxL5-eUvWs0XTKGoh7BsQ@mail.gmail.com>
Date:   Thu, 8 Apr 2021 10:50:00 +0300
Message-ID: <ygnhsg419pw7.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a503e581-c6d2-43ae-1716-08d8fa62eda4
X-MS-TrafficTypeDiagnostic: MN2PR12MB3279:
X-Microsoft-Antispam-PRVS: <MN2PR12MB32793BBEE79CC6CBA35025F7A0749@MN2PR12MB3279.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DrjNrXgWtBAL7agxFseFrzocZROO28aK5zmsyWC+85McM+1b53b664Et7ElemVEgkUrELqnkL1ZKkXe7ZXVA6u2p6aysit3s/OgDE+AJWOrXHWMv3pkiAy7/oaTKQCv2HzH7OC8izCiucb2U5Yn5vykYBEcuROO5JlvB/8c0Z/fBm5839hN/kWtSF3VfCDtLra5ZXwXD1t/W84JrnjSoCxJitHDrQePdlc5fOkiA+8jFOipd+Wx8C09Wbhp7lUk3QoGs39zoduJ3L9+fD2hrIg3BP8CQXkverNtadaN4qVvK5k2ThH/Xn5gOXWkVWu92ROPzAMbsAgM2iM7BGsYYPPZrzjM4lu8fMuiC15e89xHepPSYir5h3inhNr3Y/vpBetwAZpxP4DC9cjoGoBLOIh6ixPWKy5H81eEm4eFw2c8pk/sj+OVtlrKOSqF7HXHsVpEEcnWgbDc+tdbmdqSumyR3EUwimW4X5K20SzlQZc0YvePUg2g3bwe6JadvStmPpehtfdva5ghy4tGVRQum4LEwInlOlB/pTyZq5IrraoeoqgOae/UG8Ddsz8YkcaDF5yPZOtPsjDyu6MLZK2akfA739MC0fPpBfXba0gmqrZ5Xz/RJFmjg8va1oT9hlts/UtoaUENn/61lfpoQ7rbmG6Jo7K6XUetF2IO7EgEiZXM=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(346002)(376002)(46966006)(36840700001)(86362001)(4326008)(82310400003)(53546011)(316002)(70206006)(70586007)(426003)(47076005)(26005)(7416002)(8676002)(2616005)(7636003)(36860700001)(7696005)(8936002)(83380400001)(2906002)(478600001)(36756003)(82740400003)(54906003)(36906005)(110136005)(5660300002)(356005)(16526019)(186003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 07:50:07.2438
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a503e581-c6d2-43ae-1716-08d8fa62eda4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3279
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 08 Apr 2021 at 02:50, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Wed, Apr 7, 2021 at 8:36 AM Vlad Buslov <vladbu@nvidia.com> wrote:
>>
>> Action init code increments reference counter when it changes an action.
>> This is the desired behavior for cls API which needs to obtain action
>> reference for every classifier that points to action. However, act API just
>> needs to change the action and releases the reference before returning.
>> This sequence breaks when the requested action doesn't exist, which causes
>> act API init code to create new action with specified index, but action is
>> still released before returning and is deleted (unless it was referenced
>> concurrently by cls API).
>>
>> Reproduction:
>>
>> $ sudo tc actions ls action gact
>> $ sudo tc actions change action gact drop index 1
>> $ sudo tc actions ls action gact
>>
>
> I didn't know 'change' could actually create an action when
> it does not exist. So it sets NLM_F_REPLACE, how could it
> replace a non-existing one? Is this the right behavior or is it too
> late to change even if it is not?

Origins of setting ovr based on NLM_F_REPLACE are lost since this code
goes back to Linus' Linux-2.6.12-rc2 commit. Jamal, do you know if this
is the expected behavior or just something unintended?

>
>> Extend tcf_action_init() to accept 'init_res' array and initialize it with
>> action->ops->init() result. In tcf_action_add() remove pointers to created
>> actions from actions array before passing it to tcf_action_put_many().
>
> In my last comments, I actually meant whether we can avoid this
> 'init_res[]' array. Since here you want to check whether an action
> returned by tcf_action_init_1() is a new one or an existing one, how
> about checking its refcnt? Something like:
>
>   act = tcf_action_init_1(...);
>   if (IS_ERR(act)) {
>     err = PTR_ERR(act);
>     goto err;
>   }
>   if (refcount_read(&act->tcfa_refcnt) == 1) {
>     // we know this is a newly allocated one
>   }
>
> Thanks.

Hmm, I don't think this would work in general case. Consider following
cases:

1. Action existed during init as filter action(refcnt=1), init overwrote
it setting refcnt=2, by the time we got to checking tcfa_refcnt filter
has been deleted (refcnt=1) so code will incorrectly assume that it has
created the action.

2. We need this check in tcf_action_add() to release the refcnt in case
of overwriting existing actions, but by that time actions are already
accessible though idr, so even in case when new action has been created
(refcnt=1) it could already been referenced by concurrently created
filter (refcnt=2).

Regards,
Vlad

