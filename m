Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF693DEDAE
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 14:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235658AbhHCMPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 08:15:19 -0400
Received: from mail-sn1anam02on2064.outbound.protection.outlook.com ([40.107.96.64]:36244
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234524AbhHCMPR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 08:15:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mgjV2vfPpDLS/y1Fu+2FLVMwi4ZwatlkhkgYaSdFwnqfzMfOfJdLt7bnsZvytTkLtsxHxLUuG+q4mwPlr+YEmX3V8cesYcg1oc86drpL3h26cWSX3ITvEIpO50kHyvQQg8FjdIuC/sFt/NeXQz2a70zQIjVw/O2iSHIB8E27GCCCLgqbkQCYOIRc/iuvqr5hxUT4HOa6tqv+2XIm3Z5LbZgGwbOpmgm6FwSU+YlErdKD7mG/suS55Koipe7rbhyeYng6X1b3zBywyhL3t0rm4CsVmXWkN1GtDBfRUJmFC/h0xkp2udB0/pQi14V/xkpThnaeGzSp3H1sP7Y17wTD1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svmmceMY7QC6VXUfJ8WnVmqOmYUVmsiDchLktpxgTOk=;
 b=Ac/7L1XaRDJJRK8RkkcZ88m1E+6hPGMal5B+phNzW0cL82HBEZicHllGSPg2bU9Wh86CDY6WZx+CcTkOsFPbLdoNVoi0oMVIJ4jVg4RsgqaD/c2Ihy9V9lqTUkLdb8OdHJdavXIY8YTD0rDWxVn0TcmkRvNidmJqNPu+iGDjtmyNsI0pBo0Ni5l2jHH+YDQZOmujL7Aw3E6mMz+N45gQuKpbZDoeLMiL3QlbQx53ompsbePwW/gRnfcWiyos+3Dph63WOfIefE4sd2aEa8w5pgpgXIR3OyZ040edtgCMgkrvAWV+chO5ZskBh5LcA3INuXcgLhSGdYp0XHsLekcJDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=resnulli.us smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svmmceMY7QC6VXUfJ8WnVmqOmYUVmsiDchLktpxgTOk=;
 b=mqQCotIOAQzNEn97IzWeGGcJMhcPqu/8r4Ql7PqmhJ2JAV4kOSJYak1Prr+bJ9tBTneJY25lkYHCETkDo4orOK78VO9BD5psLZcHOkXSd+Fe1u3tDu2Wx93p19Z7QR9ocE9R1iOVJ24y9/G93S5GohHcIPMbH6Ii1JjpVw4pFBWOHHh53e9mS+jbxo9hxhepbffFqdyYqtIxFR6pPxTBXfjlF29k3aLXOhe8rfKdSmalcwLU/I8Jwt5sZj70jYL/aRCG/NnhJMGTbkQoL0OorUSGuyP7J5eTKbazk58wB10hP9mmr4BxEmXkYxVR2TOzIMEdka60bvFX2ahBEDglqw==
Received: from CO2PR04CA0079.namprd04.prod.outlook.com (2603:10b6:102:1::47)
 by MWHPR12MB1278.namprd12.prod.outlook.com (2603:10b6:300:10::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20; Tue, 3 Aug
 2021 12:15:05 +0000
Received: from CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:102:1:cafe::6) by CO2PR04CA0079.outlook.office365.com
 (2603:10b6:102:1::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend
 Transport; Tue, 3 Aug 2021 12:15:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT041.mail.protection.outlook.com (10.13.174.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4373.18 via Frontend Transport; Tue, 3 Aug 2021 12:15:05 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 3 Aug
 2021 12:15:05 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.187.5) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 3 Aug 2021 12:15:01 +0000
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-2-simon.horman@corigine.com>
 <ygnhim12qxxy.fsf@nvidia.com>
 <13f494c9-e7f0-2fbb-89f9-b1500432a2f6@mojatatu.com>
 <20210727130419.GA6665@corigine.com> <ygnh7dhbrfd0.fsf@nvidia.com>
 <95d6873c-256c-0462-60f7-56dbffb8221b@mojatatu.com>
 <ygnh4kcfr9e8.fsf@nvidia.com> <20210728074616.GB18065@corigine.com>
 <7004376d-5576-1b9c-21bc-beabd05fa5c9@mojatatu.com>
 <20210728144622.GA5511@corigine.com>
 <2ba4e24f-e34e-f893-d42b-d0fd40794da5@mojatatu.com>
 <ygnhv94sowqj.fsf@nvidia.com>
 <31fb2ae6-2b91-5530-70c8-63b42eb5c39d@mojatatu.com>
 <996ecc2d-d982-c7f3-7769-3b489d5ff66c@mojatatu.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <oss-drivers@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        "Ido Schimmel" <idosch@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Roopa Prabhu <roopa@nvidia.com>
Subject: Re: tc offload debug-ability
In-Reply-To: <996ecc2d-d982-c7f3-7769-3b489d5ff66c@mojatatu.com>
Date:   Tue, 3 Aug 2021 15:14:58 +0300
Message-ID: <ygnhsfzqpvwd.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2d62e64-370f-4810-17cd-08d956785403
X-MS-TrafficTypeDiagnostic: MWHPR12MB1278:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1278DE7B8BC6AD8FF14DC68CA0F09@MWHPR12MB1278.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Raat8WiA7b2b+MfCRZBU8CwfYSSbMtAKkmLxP4w2iEh0N2yL6icbLu1AYQ8uPXDoO5xAmyWn4Bgh82bhfyocLFFDHLHzmjQp8wqGEEYgpCXucH1FqTtVyRtAn0+qWXJctkjmXXXucdFxFWO/cMTowrK/hsFIbC8AoABQUyIZLFB57NPUPAieZl3L14fDZ4QN21ygBfT8Uqt/ZNvbLWVTtaAoSm96yK5OPCeKe+EABVoh61EhKNhFRuyXxjmGUjBXAAaf5+kE5PQZyNJDRbN3b5m6nhFrl7+SVBgt+yfKw9+SfPFRUt/Em2/XRfOWFToEGhkHOlTI/OWH1mg6d2WDjj1Fuc8bdyZyThcNe5rBt872agV44FbB/2KWcXdAx3ZV2dhEAcxNiVQTGtBsH2txB8kalhjCY4qlyc+AKyHXK6sLQgHWznUXpEVQOKu2FQzmrjf0FXGvaq0+f3YWhrQ3evQ0osbsuN5JFBiUZcwmrpow/CC7CJeVv/rpQhzeLqkFMTwFvgNp/wwEyHVDUOJoFdU3161Peq/eXvtbimcmas6OIwtCZnid9CDRszjR+/5QA7LDxw2WF9lxgOgFFt1GMbDlFtXufwxOA1TggLHbf7Zyn4HSfI90OsF4XugihK5Y05yiFGPhYv7HKppMvNEeYQ9ayFO/fpR7cTIKTcA3oQlPlWM/LRTMZ9LlDnl/NsQG6Utyn57L+l5EDbGmLMKq/rXqbvmSl+GB0Tm/P9t0FuUtI1kHHF5CESSU1bdFhDeExsFRpSk7Y90OA2i/9lFvbGAazr7OdZWNpADg5/3TFPjkkHcS8EuKDHXDEZnN091y
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(396003)(46966006)(36840700001)(7636003)(6666004)(3480700007)(86362001)(7696005)(2616005)(82310400003)(47076005)(82740400003)(426003)(4326008)(53546011)(2906002)(7416002)(26005)(356005)(6916009)(8676002)(36860700001)(54906003)(316002)(36906005)(5660300002)(186003)(107886003)(336012)(16526019)(4744005)(966005)(8936002)(478600001)(70206006)(70586007)(83380400001)(36756003)(4226004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 12:15:05.4089
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2d62e64-370f-4810-17cd-08d956785403
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1278
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 03 Aug 2021 at 15:02, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> I just changed the subject line..
>
> On 2021-08-03 5:57 a.m., Jamal Hadi Salim wrote:
>> On 2021-07-30 7:40 a.m., Vlad Buslov wrote:
>>> On Fri 30 Jul 2021 at 13:17, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>>> On 2021-07-28 10:46 a.m., Simon Horman wrote:
>> 
>>>
>>> Filters with tunnel_key encap actions can be offloaded/unoffloaded
>>> dynamically based on neigh state (see mlx5e_rep_neigh_update()) and fib
>>> events (see mlx5e_tc_fib_event_work()).
>>>
>> Thanks. Will look and compare against the FIB case.
>> 
>
> So unless i am mistaken Vlad:
> a) there is no way to reflect the  details when someone dumps the rules.
> b) No notifications sent to the control plane (user space) when the
> neighbor updates are offloaded.

Correct.

>
> My comments earlier are inspired by debugging tc offload and by this:
>
> https://patches.linaro.org/cover/378345/
>
> cheers,
> jamal

