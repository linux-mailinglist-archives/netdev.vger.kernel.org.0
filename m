Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB156E2C6E
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjDNWUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjDNWUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:20:11 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D4449F5;
        Fri, 14 Apr 2023 15:20:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f456QW6MdJpsos198HqmOZ2APKODfqF2ofxrhH3M2FLXCsU2wj9HY1rvFvWoSCiSfGTGxfEw2e/Cb0mmZ9gxFwHo1CFrqzZmDN1OCAaMylqTNvYrpqkHQY2ytxIR6cBGpQRlPTQJxFmKCY5VI8E7/SN3M6e75rCnpON9uE42WeotbPHjMuJnlXsU+k2B2JxsbFrjAs9sz0d/exhdnkkSLeIwITWD8hf+pPOfHVRBlvwjfXoWzZtEHHxmZiObhtPzK2QLjEWHg2nRl5Xm1mSUfVCwSVk1kaJiH27eMw5+9ZQKP9M36SWXCCwNIQcyGLHrjWXGp/nRNJTCV9+Jf8bZXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WH2E2uguLVWJuZiGDXqQEVgO6zSi1YPo0GmY5Cf6XL0=;
 b=CYVRlJzh8IVDzLIHZEFSYLizCZjTPmATt2mpp95CfNpbWX/wagoD51CkIsZjc7/qac64TcWP+YFGq6NYYDU1dd3Pyj72HM7vk4FaAHwGFgBUkT/OX53DqWgOQtakfah9rrdtOijo40zOSaUu0dmQSZLyUCsg6leQF5/uNL1k7Ibx21Xcxg0JjraPoMQ7tF5TVsgHjMPCq4vSZoPud4Agd6tFKSMsf86fACGS8JW8yOPqBGJw6hCrBDjRTpYWXkozQC6ixBh7R6bMFCuzTJzdto3Uqmhqe6Bw+gtiZvVPl10CyDRu58c9JB14DSSSHiNqluQFKZNnSMtohx1JZEapGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WH2E2uguLVWJuZiGDXqQEVgO6zSi1YPo0GmY5Cf6XL0=;
 b=uODJBHN6X/pBg7fqbe/p6DDhDPZTBX1I5HlIoH90np6jzZ2R31h9boTFo5wovxStgZkPZ00K/hAkMh/KJPpKLcPyJgkWNMHE4WXX8BXg8yOhuWEe9p//nIyG1YGP1703KPcd2OU0dzn7QcmCGWJ7BCY6yeje/RS+F8omN2stb10fLGR7ysDeQlyFaDHCjtFjaIWjKyvvbnANbM6qd+5+UBp1DrMsHGzXWTpkhAdTuYHbMF3yMAUqIa6szn/+UWrPeJVSkPF1rn4DC8TF4FiuVBROCI6MEcmdL0NJjjY7JhBuixcPFpAmaeF3kpImHtd2WxiqJGlWCcekC/z3pPTn1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1340.namprd12.prod.outlook.com (2603:10b6:3:76::15) by
 BL1PR12MB5730.namprd12.prod.outlook.com (2603:10b6:208:385::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.38; Fri, 14 Apr 2023 22:20:04 +0000
Received: from DM5PR12MB1340.namprd12.prod.outlook.com
 ([fe80::7634:337:4a71:2b78]) by DM5PR12MB1340.namprd12.prod.outlook.com
 ([fe80::7634:337:4a71:2b78%8]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 22:20:04 +0000
Date:   Fri, 14 Apr 2023 15:20:01 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Paul Moore <paul@paul-moore.com>,
        Leon Romanovsky <leon@kernel.org>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Saeed Mahameed <saeed@kernel.org>,
        Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
        selinux@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: Potential regression/bug in net/mlx5 driver
Message-ID: <ZDnRkVNYlHk4QVqy@x130>
References: <CAHC9VhT+=DtJ1K1CJDY4=L_RRJSGqRDvnaOdA6j9n+bF7y+36A@mail.gmail.com>
 <20230410054605.GL182481@unreal>
 <20230413075421.044d7046@kernel.org>
 <CAHC9VhRKBLHfGHvFAsmcBQQEmbOxZ=M9TE4-pV70E+Y6G=uXWA@mail.gmail.com>
 <ZDhwUYpMFvCRf1EC@x130>
 <20230413152150.4b54d6f4@kernel.org>
 <ZDiDbQL5ksMwaMeB@x130>
 <20230413155139.22d3b2f4@kernel.org>
 <ZDjCdpWcchQGNBs1@x130>
 <20230413202631.7e3bd713@kernel.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230413202631.7e3bd713@kernel.org>
X-ClientProxiedBy: SJ0PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::10) To DM5PR12MB1340.namprd12.prod.outlook.com
 (2603:10b6:3:76::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR12MB1340:EE_|BL1PR12MB5730:EE_
X-MS-Office365-Filtering-Correlation-Id: 924c1a21-a68c-4cd7-5736-08db3d36651f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HK9phQIE0CsX/4vhHP/TmiuhgnIdUPfjBFVFUVBkPfygx3QV1j5Wi3aIST4fk4u3A1c6HzrI4vDTKtWPQH0IvePZwZrIHH3MAegEz2bvu7NXbaSn0b6i9WmY2gLwbAebth5nzOa7t7UZH2/0ER90ByNV9UDahTTqGTYTQe3C8DV9Xa4Tp7vuKlaRPcWnWHmNDKcHZuTh8nXbdlb43nEPNPEe8yzDHFzlN+BsRcjBtpUAK/q5xzl+XjK55imgXxgJ914+xhDCPDc7OqIDpAXDNcBPfmZXdfZ3421erC5xenYpZxbqMflNfertk1fQDH/jNhr2rSpEl6eT6rAjDdkRVq5IF3ekfFa0GiO3ExoZovAYG14IjS4Iw28OeP9dR71xVhaArnQreJ28HdsatWHEVO0voIDtpGPVzq/AASCyeS3L9EzBCVXWLfWH8b2+flPTOKK39Mgi87j+UjkOdM362W/2b9he/F6tErI6opSdZMDhRixa/ze6Mduyou5bf/8sM3YYgzbMmVXEGkr/xhqUytmtB26hjwUdN3a6Erxo+T8GAn2yxFBYOUbMacv9xXfChujDyIxr1jz9cQ3YKbV403+f6VfCyyk7MAy/6soc0vM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1340.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(451199021)(66476007)(8676002)(6916009)(66556008)(2906002)(4326008)(66946007)(41300700001)(6486002)(966005)(66899021)(86362001)(5660300002)(8936002)(316002)(478600001)(83380400001)(54906003)(9686003)(186003)(26005)(6512007)(107886003)(6666004)(6506007)(33716001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZrSqlZudHycd8VZit0/bxOzw/qkDBfnfPMPeWfmqaMPi/NYVQX45ZkBJ4IkN?=
 =?us-ascii?Q?7BRKqHuJjkvcQyrL3BxthJHKmgw2pOKni/fI/noceYrrI/DB4jvJRkfgXgBc?=
 =?us-ascii?Q?rebXOCPKKMQqLzBkLW6GURy2Tg85evTQt2Ln8DOi78fqEajjD4bZz/GkSbYZ?=
 =?us-ascii?Q?g41ur3nxXPq096LE5ilSDUy/ePISoUaEdWEK2Oj8NdMA9MQ3IaUyjL3nFlbw?=
 =?us-ascii?Q?Fj9jXE30i+1usVrZV5oGcJvOSctmSZrHIelRHz6HxplzWTERGArogTEHVwI3?=
 =?us-ascii?Q?vttHsT0rUG2HDWrR6qEXPrZSXch0+bfRSM0gQKUlVsASiIwHaZv2F8k6Br5n?=
 =?us-ascii?Q?P8q6vWW6xwOymuy3hsaL2j+tFJhiZMmFoeewDGN9Bf+vpaOrnx7m+fwiMUnC?=
 =?us-ascii?Q?SNNbbj6K8iNlz2VanOv0PKMX2dOAVkUy23KdTFAQUscIY2uFJGELQYMINBAf?=
 =?us-ascii?Q?tavK+7zNZRxLTbQMYpkjV4XDGIpP0GbI1RLSbC4qJzTNJQLoMiZ6lNaaGOWB?=
 =?us-ascii?Q?4/6ko139dk3fi6YafOJua37ewyKfigw9lJMkKruR3lOodRqpN7o5eNXMBR2u?=
 =?us-ascii?Q?IVY/H9W/lmWt4YISLgVZI+7MxdazwLRBV5tTM/LdybfPt8l7t7EhLHDDMnnc?=
 =?us-ascii?Q?XhI2YNdXDqVnzVTX9mbEnInC3eyJzm9rwZntFi50PamFwh5AjR2dD5QU7SGB?=
 =?us-ascii?Q?bDOdZWODPgieR6juGTYLcSQq3RA1UvNVBWXBDvsAwLONGajEGV2FQaN7dHBJ?=
 =?us-ascii?Q?eCYTS7vbDxt2faU6lUtjUjx9pVWQQJhbN226P9rSTNT1/YWmeDKw/Xlc8ENh?=
 =?us-ascii?Q?mBDgZGZi9DSvZAFcBodN/e0fJLEcrFailR5lNtXkniJSZOFBAh6ZJer7Y16J?=
 =?us-ascii?Q?1ZkhGEV3karcL/NQnl5cxt/+vSPPesGQaThN6CbcbVzV1WLTk5a6/xwe3u7B?=
 =?us-ascii?Q?Ep3U7axzZ7WHc8IyFPL+uJzKWdMr7MqIi1FeB2ajsxNDB/+Gel10oIY7ofsS?=
 =?us-ascii?Q?hz779doQ0oAiP4ACSnh+yAqKwhpFmp//oIRwGUox2uTfMd6ZfvXn69jyM82e?=
 =?us-ascii?Q?CxavEwWfDPZuUIFIOjUlg4+c4CvrHbdqFc+Xd+K665vprjQhHiyh2oWeuAs9?=
 =?us-ascii?Q?5iUZBUxBwh/1TUWLu0EksCuxTimM+ZGSRILWMn4kA7Y/mB6nijwCN3TK6nTa?=
 =?us-ascii?Q?5dUwvUpJ/Yyu9WVXni9GR+vGO4EDWWGUSwjjZ6HKKok4uqE7xpnDbGSqXJW3?=
 =?us-ascii?Q?yhIeEME3v924v03R9dabrjIu4+OeLpzXfl0MaiN/4UZXLCuLmj9aLmsD8EW+?=
 =?us-ascii?Q?QOigO5RoMNnYnMfVVBDIm8QtJdY3VpmZbKDz5q/h+u648ldnpggnv/BOxtJO?=
 =?us-ascii?Q?QNhAdXJGyFBq7ONShTdKJydIbZyTak1Rnu+YAU6jkhWxpPZRMs5ZDH24ko4P?=
 =?us-ascii?Q?0A87/UPDTd1MLbXGxGY0PYm+Qg7TwZHOAcinc1ynnQDfOr0c81gjFI0P5lPw?=
 =?us-ascii?Q?oXg3++1DOidtnYYcWZFN3AuzSVsNDULb8OP7PgoknPwBQ4Bir1HeaxpvjNEC?=
 =?us-ascii?Q?BGdq1o3Uegk/zhijzuOop6yMTYxg7zJKwXM8wS5w?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 924c1a21-a68c-4cd7-5736-08db3d36651f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1340.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 22:20:03.9481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XbWyRD//v3QGiZYeZUhTxssefMPd9dnU6QuSaYt027xgDcXna9WEGle7gb1FAqtMlMfO6TF4YH3UIVyNofhSkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5730
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13 Apr 20:26, Jakub Kicinski wrote:
>On Thu, 13 Apr 2023 20:03:18 -0700 Saeed Mahameed wrote:
>> On 13 Apr 15:51, Jakub Kicinski wrote:
>> >On Thu, 13 Apr 2023 15:34:21 -0700 Saeed Mahameed wrote:
>> >> But this management connection function has the same architecture as other
>> >> "Normal" mlx5 functions, from the driver pov. The same way mlx5
>> >> doesn't care if the underlaying function is CX4/5/6 we don't care if it was
>> >> a "management function".
>> >
>> >Yes, and that's why every single IPU implementation thinks that it's
>> >a great idea. Because it's easy to implement. But what is it for
>> >architecturally? Running what is effectively FW commands over TCP?
>>
>> Where did you get this idea from? maybe we got the name wrong,
>> "management PF" is simply a minimalistic netdev PF to have eth connection
>> with the on board BMC ..
>>
>> I agree that the name "management PF" sounds scary, but it is not a control
>> function as you think, not at all. As the original commit message states:
>> "loopback PF designed for communication with BMC".
>
>Can you draw a small diagram with the bare metal guest, IPU, and BMC?
>What's talking to what? And what packets are exchanged?
>

Yes, Working on that...

>> >> But let's discuss what's wrong with it, and what are your thoughts ?
>> >> the fact that it breaks a 6 years OLD FW, doesn't make it so horrible.
>> >
>> >Right, the breakage is a separate topic.
>> >
>> >You say 6 years old but the part is EOL, right? The part is old and
>> >stable, AFAIU the breakage stems from development work for parts which
>> >are 3 or so generations newer.
>>
>> Officially we test only 3 GA FWs back. The fact that mlx5 is a generic CX
>> driver makes it really hard to test all the possible combinations, so we
>> need to be strict with how back we want to officially support and test old
>> generations.
>
>Would you be able to pull the datapoints for what 3 GA FWs means
>in case of CX4? Release number and date when it was released?
>

https://network.nvidia.com/files/related-docs/eol/LCR-000821.pdf

Since CX4 was EOL last year, it is going to be hard to find this info but
let me check my email archive.. 

12.28.2006   27-Sep-20 - recommended version
12.26.xxxx   12-Dec-2019
12.24.1000   2-Dec-18


>I understand the challenge of backward compat with a multi-gen
>driver. It's a trade off.
>
>> >The question is who's supposed to be paying the price of mlx5 being
>> >used for old and new parts? What is fair to expect from the user
>> >when the FW Paul has presumably works just fine for him?
>> >
>> Upgrade FW when possible, it is always easier than upgrading the kernel.
>> Anyways this was a very rare FW/Arch bug, We should've exposed an
>> explicit cap for this new type of PF when we had the chance, now it's too
>> late since a proper fix will require FW and Driver upgrades and breaking
>> the current solution we have over other OSes as well.
>>
>> Yes I can craft an if condition to explicitly check for chip id and FW
>> version for this corner case, which has no precedence in mlx5, but I prefer
>> to ask to upgrade FW first, and if that's an acceptable solution, I would
>> like to keep the mlx5 clean and device agnostic as much as possible.
>
>IMO you either need a fully fleshed out FW update story, with advanced
>warnings for a few releases, distributing the FW via linux-firmware or
>fwupdmgr or such.  Or deal with the corner cases in the driver :(
>

Completely agree, I will start an internal discussion .. 

>We can get Paul to update, sure, but if he noticed so quickly the
>question remains how many people out in the wild will get affected
>and not know what the cause is?

Right, I will make sure this will be addressed, will let you know how we
will handle this, will try to post a patch early next cycle, but i will
need to work with Arch and release managers for this, so it will take a
couple of weeks to formalize a proper solution.

