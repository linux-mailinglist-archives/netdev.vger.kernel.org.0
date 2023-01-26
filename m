Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7274667D2C6
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 18:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbjAZRKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 12:10:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbjAZRKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 12:10:50 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBB46DFD8
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 09:10:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eT9Qir4Wsuox+VZPX0ilGNmnuW5iWIxrVb8+dZJGW2eVmILn+l+IkaSjShNkoKzF4QWN8zQXdj5tXTMaFI7s5AhhaZgmZR1a7iqTPJWNFejyodbCcq95lNMNvyce74l4VU2ZKCQxNAT+uj+uiavdzbhI2TKAkUavYm7AnkzVSET6nX2A/VgxfI3bAZi60Hv3vGH7KqZZskE6+b6tCuYgGsbX8uKoM5HPM6OHAQ6trrRXsmHmPM6I9l4d8E2xtgRwXGkluPViuyEfKabkamYUGbcNN3ySgGBi1Eg6vahVZbTNBgyDf8hh8qBpRiMgeLmDBuK/KS4pCbhz8yh/LK1dEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8eAR4MbL0xVHPFGv1zaBoYDdp+hZVqxZp82IyAFvkS8=;
 b=ViFDIajqgpV+Z+vj5OZmkiLDQi3Do1v5WYeYXzOGFdrq7ACPaL/huU7TSdYZJr3vBp4MjYZ0Vs9GBnpvJgxHNlb8bL4ZPQktpGB04dhN+NI0arH/N8ncd7QxXLENwjcMl0foaXFqdAFbM788hYm64V7hKrL+WQ82J4n7z2luapA8EhQ0NNQ86UERgRepRmx/5wxMZ0DMvKIhZGf9AK08DMWULgcRQcDYrxYSctd9OiBE5aJLxVz3M2u7O9QO7jK4u9hzcWwaFpIGEGGz+r4Nw7tSgLk1X46v1cVk2RDdiC0jwbsRuuyHN0shreFqFORRlPO58zvS8kZJW9AFUWzC9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8eAR4MbL0xVHPFGv1zaBoYDdp+hZVqxZp82IyAFvkS8=;
 b=DZYk25tJ3cfpu9TQX8Y1pGpMzTqJnm3V7SWQEnSHtI1u8JltP99HdvDdNmWQfBIlYZnPhZrDr3wfLrJQXR/7vyCs8V6jUMl3QCwGxVAcR6WrFMTO0zdQcy9bmpgh321gegCSi5DA8VV5P+8tQxPKFGiQf165/5MN5AEf3xIE9ZQuphz9hA0oDNWEh8vjcEvzyvru4gsjZYshxlbOrDqvRsF/L7ss74zE3qA/l/glm3eHzOleOpgs8wJW+xrqpgUV+43CMwvUZxX8MYyMOLIbux90p/pwUcuIpRqVH536alFsZvROypsDd44gZ5UwURjyFHORnVdPgibOfmyvkfoPQg==
Received: from MW4PR04CA0192.namprd04.prod.outlook.com (2603:10b6:303:86::17)
 by CH0PR12MB5297.namprd12.prod.outlook.com (2603:10b6:610:d4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 17:10:28 +0000
Received: from CO1NAM11FT088.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::c5) by MW4PR04CA0192.outlook.office365.com
 (2603:10b6:303:86::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Thu, 26 Jan 2023 17:10:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT088.mail.protection.outlook.com (10.13.175.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21 via Frontend Transport; Thu, 26 Jan 2023 17:10:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:10:12 -0800
Received: from fedora.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:10:07 -0800
References: <20230124170510.316970-1-jhs@mojatatu.com>
 <20230124170510.316970-19-jhs@mojatatu.com> <877cxacndc.fsf@nvidia.com>
 <CAM0EoMmgSWqvmvuN-Qv+cf8pf=Mtzp7d70+5C1DfjUKb5w6+GA@mail.gmail.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     <netdev@vger.kernel.org>, <kernel@mojatatu.com>,
        <deb.chatterjee@intel.com>, <anjali.singhai@intel.com>,
        <namrata.limaye@intel.com>, <khalidm@nvidia.com>, <tom@sipanda.io>,
        <pratyush@sipanda.io>, <jiri@resnulli.us>,
        <xiyou.wangcong@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <simon.horman@corigine.com>
Subject: Re: [PATCH net-next RFC 19/20] p4tc: add dynamic action commands
Date:   Thu, 26 Jan 2023 19:04:07 +0200
In-Reply-To: <CAM0EoMmgSWqvmvuN-Qv+cf8pf=Mtzp7d70+5C1DfjUKb5w6+GA@mail.gmail.com>
Message-ID: <87cz71fcib.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT088:EE_|CH0PR12MB5297:EE_
X-MS-Office365-Filtering-Correlation-Id: 8097cefe-87d9-4e17-d582-08daffc03874
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o6nB8HBjm1MG+9ra2iMPYFaS9aRuCMB/WyijgCEKvrd3LGjDnPDQxyz2nbFsWxPwX6TZIcGf7hgAxBsEu2H70wu7kYeqQ4DkKYyPzbTF0TwBCI78Wgx/ooggf7uYDBxBInIw415wHhl17pOdnyhwu3GdgXPaRh3n6spgi5oAg1PTtEtG/7g5e8/BlVF92MUaURXUNEHtGFmkrGVZBcI/bgK3Xa5Cour4J1JrdcxVzWuvowYmqK741j/X7MPjswcdejplzfpXCVejAKLYbqEjltJlOix9LOYxELLEVTZdfLkUbiseJqtMUdaKcR0OI0NAv5jqzBPtGpT9cuR+v4NU16XQ0MzPFmpdaZOKP4OKhNkZurntgKdjM/ixH7wkxPNcdHX3uJ8vNNFwLNmHo7XqiTOheZ/y9DqvCk4NUFZi4YNvkXJ+aA0WRx7vL+7E2fa5R121AHxYHhMKR+VkcSkZpTD2F+uL0n3DccFFU3o+x4UiHibkRboFmT0y8i8YkvlXwX/boZyFpDPMmMjrr2dCLC9MTluGRkgJdIj1eeoCagaz5AcF8x/OJ1lhvk31CkUzLJb4YVnNr/WipS9Maglw7sxj4yJMLMJCAKJ7qY98el2ssuGjS0G6lGIhJWreO/cNbUssCXiTfYt7lkbV3NjbySDBOplyt8N2kzdhTm0/YatQmJygB053uPPJl0ISwsWWOLdeq6kIDTjS5GyxGKHwP4A2pSIl2gMnlLZaUoKC4W5nlSzpvHNoiYD+IcwEAnk0
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(376002)(136003)(396003)(451199018)(36840700001)(40470700004)(46966006)(2906002)(5660300002)(7416002)(30864003)(8936002)(41300700001)(36860700001)(47076005)(426003)(26005)(186003)(336012)(478600001)(53546011)(2616005)(16526019)(7636003)(40460700003)(82740400003)(36756003)(356005)(83380400001)(40480700001)(86362001)(70206006)(70586007)(7696005)(316002)(6916009)(4326008)(8676002)(82310400005)(54906003)(32563001)(21314003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 17:10:27.1393
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8097cefe-87d9-4e17-d582-08daffc03874
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT088.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5297
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 26 Jan 2023 at 07:52, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On Wed, Jan 25, 2023 at 4:31 PM Vlad Buslov <vladbu@nvidia.com> wrote:
>>
>>
>> On Tue 24 Jan 2023 at 12:05, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>> > In this initial patch, we introduce dynamic action commands which will be
>> > used by dynamic action in P4TC.
>> >
>> > The are 8 operations: set, act, print and branching
>> >
>> > ================================SET================================
>> >
>> > The set operation allows us to assign values to objects. The assignee
>> > operand("A") can be metadata, header field, table key, dev or register.
>> > Whilst the assignor operand("B") can be metadata, header field, table key,
>> > register, constant, dev, param or result. We'll describe each of these operand
>> > types further down the commit message.
>> >
>> > The set command has the following syntax:
>> >
>> > set A B
>> >
>> > Operand A's size must be bigger or equal to operand B's size.
>> >
>> > Here are some examples of setting metadata to constants:
>> >
>> > Create an action that sets kernel skbmark to decimal 1234
>> >  tc p4template create action/myprog/test actid 1 \
>> >  cmd set metadata.kernel.skbmark constant.bit32.1234
>> >
>> > set kernel tcindex to 0x5678
>> >  tc p4template create action/myprog/test actid 1 \
>> >  cmd metadata.kernel.tcindex constant.bit32.0x5678
>> >
>> > Note that we may specify constants in decimal or hexadecimal format.
>> >
>> > Here are some examples of setting metadata to metadata:
>> >
>> > Create an action that sets skb->hash to skb->mark
>> >  tc p4template create action/myprog/test actid 1 \
>> >  cmd set metadata.kernel.skbhash metadata.kernel.skbmark
>> >
>> > Create an action that sets skb->ifindex to skb->iif
>> >  tc p4template create action/myprog/test actid 1 \
>> >  cmd set metadata.kernel.ifindex metadata.kernel.iif
>> >
>> > We can also use user defined metadata in set operations.
>> >
>> > For example, if we define the following user metadata
>> >
>> > tc p4template create metadata/myprog/mymd type bit32
>> >
>> > We could create an action to set its value to skbmark, for example
>> >
>> > tc p4template create action/myprog/test actid 1 \
>> > cmd set metadata.myprog.mymd metadata.kernel.skbmark
>> >
>> > Note that the way to reference user metadata (from iproute2 perspective)
>> > is equivalent to the way we reference kernel metadata. That is:
>> >
>> > METADATA.PIPELINE_NAME.METADATA_NAME
>> >
>> > All kernel metadata is stored inside a special pipeline called "kernel".
>> >
>> > We can also use bit slices in set operations. For example,
>> > if one wanted to create an action to assign the first 16 bits of user metadata
>> > known as "md" to kernel metadata tcindex, one would right the following:
>> >
>> > tc p4template create action/myprog/test actid 1 \
>> > cmd set metadata.myprog.tcindex metadata.kernel.md[0-15]
>> >
>> > If we wanted to write the last 16 bits of user metadata "mymd" to kernel
>> > metadata tcindex, we'd issue the following command:
>> >
>> > tc p4template create action/myprog/test actid 1 \
>> > cmd set metadata.myprog.tcindex metadata.kernel.md[16-31]
>> >
>> > of course one could create multiple sets in one action as such:
>> >
>> >  tc p4template create action/myprog/swap_ether actid 1 \
>> >   cmd set metadata.myprog.temp hdrfield.myprog.parser1.ethernet.dstAddr   \
>> >   cmd set hdrfield.myprog.parser1.ethernet.dstAddr hdrfield.myprog.parser1.ethernet.srcAddr \
>> >   cmd set hdrfield.myprog.parser1.ethernet.srcAddr  metadata.myprog.temp
>> >
>> > ================================ACT================================
>> >
>> > The act operation is used to call other actions from dynamic action
>> > commands. Note: we can invoke either kernel native actions, such as gact and
>> > mirred, etc or pipeline defined dynamic actions.
>> >
>> > There are two ways to use the act command.
>> > - Create an instance of an action and then calling this specific instance
>> > - Specify the action parameters directly in the act command.
>> >
>> > __Method One__
>> >
>> > The basic syntax for the first option is:
>> >
>> > act PIPELINE_NAME.ACTION_NAME.INDEX
>> >
>> > Where PIPELINE_NAME could be a user created pipeline or the native
>> > "kernel" pipeline. For example, if we wanted to call an instance of a mirred
>> > action that mirrors a packet to egress on a specific interface (eth0) then
>> > first we create an instance of the action kind an assign it an index as
>> > follows:
>> >
>> > tc actions add action mirred egress mirror dev eth0 index 1
>> >
>> > After that, we can then use it on a command by indicating the appropriate
>> > action name and index.
>> >
>> > tc p4template create action/myprog/test actid 1 \
>> > cmd act kernel.mirred.1
>> >
>> > Note that we use "kernel" as the pipeline name. That's because mirred is
>> > a native kernel action. We could also call pipeline specific action from
>> > a dynamic action's commands, so for example, if we created the
>> > following action template:
>> >
>> > We can do the same thing but with user created actions, we could do the
>> > following:
>> >
>> > tc p4template create action/myprog/test actid 1 param param1 type bit32
>> >
>> > Add an instance of it:
>> >
>> > tc actions add action myprog/test param param1 type bit32 22 index 1
>> >
>> > We could call it using the following command:
>> >
>> > tc p4template create action/myprog/test actid 12 \
>> > cmd act myprog.test.1
>> >
>> > __Method Two__
>> >
>> > The syntax for the second method is: act ACTION_NAME PARAMS
>> > The second method can only be applied to user defined actions
>> > and allows us to invoke action and passing parameter directly in the
>> > invocation.
>> >
>> > So the above example from method1 would turn into the following:
>> >
>> > tc p4template create action/myprog/test actid 12 \
>> > cmd act myprog.test constant.bit32.22
>> >
>> > ================================BRANCHING================================
>> >
>> > We have several branch commands: beq (branch-equal), bne (branch-not-equal),
>> > bgt (branch-greater-then), blt (branch-less-then), bge (branch-greater-then),
>> > ble (branch-less-equal)
>> >
>> > The basic syntax for branching instructions is:
>> >
>> > <compare-operation> <A> <B> <then-clause> / <else-clause>
>> >
>> > Where compare-operation could be beq, bne, bg1, blt, bge and ble.
>> >
>> > A is one of: header field, metadata, key or result field (like
>> > result.hit or result.miss).
>> > B is one of: a constant, header field or metadata
>> >
>> > A and B don't need to be the same size and type as long as B's size is
>> > smaller or equal to A's size.
>> > Note, inherently this means A and B cant both be constants.
>> >
>> > Let's take a look at some examples:
>> >
>> > tc p4template create action/myprog/test actid 1 \
>> >  cmd beq metadata.kernel.skbmark constant.u32.4 control pipe / jump 1 \
>> >  cmd set metadata.kernel.skbmark constant.u32.123 control ok \
>> >  cmd set metadata.kernel.skbidf constant.bit1.0
>> >
>> > The above action executes the equivalent of the following pseudo code:
>> >  if (metadata.kernel.skbmark == 4) then
>> >     metadata.kernel.skbmark = 123
>> >  else
>> >     metadata.kernel.skbidf = 0
>> >  endif
>> >
>> > Here is another example, now with bne:
>> >
>> > tc p4template create action/myprog/test actid 1 \
>> > cmd bne  metadata.kernel.skbmark constant.u32.4 control pipe / jump else \
>> > cmd set metadata.kernel.skbmark constant.u32.123 \
>> > cmd jump endif \
>> > cmd label else \
>> > cmd set metadata.kernel.skbidf constant.bit1.0 \
>> > cmd label endif
>> >
>> > Note in this example we use "labels". These are a more user-friendly
>> > alternative to jumps with numbers, but basically what example action
>> > above does is equivalent of the following pseudo code:
>> >
>> >  if (metadata.kernel.skbmark != 4) then
>> >     metadata.kernel.skbmark = 123
>> >  else
>> >     metadata.kernel.skbidf = 0
>> >  endif
>> >
>> > This example is basically the logical oposite of the previous one.
>> >
>> > ================================PRINT================================
>> >
>> > The print operation allows us to print the value of operands for
>> > debugging purposes.
>> >
>> > The syntax for the print instruction is the following:
>> >
>> > PRINT [PREFIX] [ACTUAL_PREFIX] operA
>> >
>> > Where operA could be a header field, metadata, key, result, register or
>> > action param.
>> > The PREFIX and ACTUAL_PREFIX fields are optional and could contain a prefix
>> > string that will be printed before operA's value.
>> >
>> > Let's first see an example that doesn't use prefix:
>> >
>> > sudo tc p4template create action/myprog/test actid 1 \
>> >  cmd print metadata.kernel.skbmark \
>> >  cmd set metadata.kernel.skbmark constant.u32.123 \
>> >  cmd print metadata.kernel.skbmark
>> >
>> > Assuming skb->mark was initially 0, this will print:
>> >
>> > kernel.skbmark 0
>> > kernel.skbmark 123
>> >
>> > If we wanted to add prefixes to those commands, we could do the following:
>> >
>> > sudo tc p4template create action/myprog/test actid 1 \
>> >  cmd print prefix before metadata.kernel.skbmark \
>> >  cmd set metadata.kernel.skbmark constant.u32.123 \
>> >  cmd print prefix after metadata.kernel.skbmark
>> >
>> > This will print:
>> >
>> > before kernel.skbmark 0
>> > after kernel.skbmark 123
>> >
>> > ================================PLUS================================
>> >
>> > The plus command is used to add two operands
>> > The basic syntax for the plus command is:
>> >
>> > cmd plus operA operB operC
>> >
>> > The command will add operands operB and operC and store the result in
>> > operC. That is: operA = operB + operC
>> >
>> > operA can be one of: metadatum, header field.
>> > operB and operC can be one of: constant, metadatum,  key, header field
>> > or param.
>> >
>> > The following example will add metadatum mymd from pipeline myprog and
>> > constant 16 and store the result in metadatum mymd2 of pipeline myprog:
>> >
>> > tc p4template create action/myprog/myfunc \
>> >    cmd plus metadata.myprog.mymd2 metadata.myprog.mymd constant.bit32.16
>> >
>> > ================================SUB================================
>> >
>> > The sub command is used to subtract two operands
>> > The basic syntax for the sub command is:
>> >
>> > cmd sub operA operB operC
>> >
>> > The command will subtract operands operB and operC and store the result in
>> > operC. That is: operA = operB - operC
>> >
>> > operA can be one of: metadatum, header field.
>> > operB and operC can be one of: constant, metadatum,  key, header field
>> > or param.
>> >
>> > The following example will subtract metadatum mymd from pipeline myprog
>> > and constant 16 and store the result in metadatum mymd2 of pipeline
>> > myprog:
>> >
>> > tc p4template create action/myprog/myfunc \
>> >    cmd sub metadata.myprog.mymd2 metadata.myprog.mymd constant.bit32.16
>> >
>> > ================================CONCAT================================
>> >
>> > The concat command is used to concat upto 8 operands and save the result to
>> > a lvalue.
>> > The basic syntax for the sub command is:
>> >
>> > cmd concat operA operB operC [..]
>> >
>> > The command will concat operands operB and operC and optionally 6 more
>> > store the result in operC.
>> >
>> > It goes without saying that operA's size must be greater or equal to
>> > the sum of (operB's size + operC's size .... operI's size)
>> >
>> > operA can be one of: metadatum, a key, a header field.
>> > operB .. operI can only be a constant, a metadatum, a key, a header field
>> > or a param.
>> >
>> > The following example will concat metadatum mymd from pipeline myprog
>> > with header field tcp.dport and store the result in metadatum mymd2 of
>> > pipeline myprog:
>> >
>> > tc p4template create action/myprog/myfunc \
>> >   cmd concat \
>> >   metadata.myprog.mymd2 metadata.myprog.mymd hdrfield.myprog.myparser.tcp.dport
>> >
>> > ================================BAND================================
>> >
>> > The band command is used to perform a binary AND operation between two
>> > operands. The basic syntax for the band command is:
>> >
>> > cmd band operA operB operC
>> >
>> > The command will perform the "operB AND operC" and store the result in
>> > operC. That is: operA = operB & operC
>> >
>> > operA can be one of: metadatum, header field.
>> > operB and operC can be one of: constant, metadatum,  key, header field
>> > or param.
>> >
>> > The following example will perform an AND operation of constant 16 and
>> > mymd metadata and store the result in metadatum mymd2 of pipeline myprog:
>> >
>> > tc p4template create action/myprog/myfunc \
>> >    cmd band metadata.myprog.mymd2 metadata.myprog.mymd constant.bit32.16
>> >
>> > ================================BOR================================
>> >
>> > The bor command is used to perform an binary OR operation between two
>> > operands. The basic syntax for the bor command is:
>> >
>> > cmd bor operA operB operC
>> >
>> > The command will perform the "operB OR operC" and store the result in
>> > operC. That is: operA = operB | operC
>> >
>> > operA can be one of: metadatum, header field.
>> > operB and operC can be one of: constant, metadatum,  key, header field
>> > or param.
>> >
>> > The following example will perform an OR operation of constant 16 and
>> > mymd metadata and store the result in metadatum mymd2 of pipeline myprog:
>> >
>> > tc p4template create action/myprog/myfunc \
>> >    cmd bor metadata.myprog.mymd2 metadata.myprog.mymd constant.bit32.16
>> >
>> > ================================BXOR================================
>> >
>> > The bxor command is used to perform an binary XOR operation between two
>> > operands. The basic syntax for the bxor command is:
>> >
>> > cmd bxor operA operB operC
>> >
>> > The command will perform the "operB XOR operC" and store the result in
>> > operC. That is: operA = operB ^ operC
>> >
>> > operA can be one of: metadatum, header field.
>> > operB and operC can be one of: constant, metadatum,  key, header field
>> > or param.
>> >
>> > The following example will perform a XOR operation of constant 16 and
>> > mymd metadata and store the result in metadatum mymd2 of pipeline myprog:
>> >
>> > tc p4template create action/myprog/myfunc \
>> >    cmd bxor metadata.myprog.mymd2 metadata.myprog.mymd constant.bit32.16
>> >
>> > ===============================SND PORT EGRESS===============================
>> >
>> > The send_port_egress command sends the received packet to a specific
>> > network interface device. The syntax of the commands is:
>> >
>> > cmd send_port_egress operA
>> >
>> > operA must be of type dev, that is, a network interface device, which
>> > exists and is up. The following example uses the send_port_egress to send
>> > a packet to port eth0. Note that no other action can run after send_port_egress.
>> >
>> > tc p4template create action/myprog/myfunc \
>> >    cmd send_port_egress dev.eth0
>> >
>> > ===============================MIRPORTEGRESS===============================
>> >
>> > The mirror_port_egress command mirror the received packet to a specific
>> > network interface device. The syntax of the commands is:
>> >
>> > cmd send_port_egress operA
>> >
>> > operA must be of type dev, that is, a network interface device, which
>> > exists and is up. The following example uses the mirror_port_egress to mirror
>> > a packet to port eth0. Note that the semantic of mirror here is means that
>> > we are cloning the packet and sending it to the specified network
>> > interface. This command won't edit or change the course of the original
>> > packet.
>> >
>> > tc p4template create action/myprog/myfunc \
>> >    cmd mirror_port_egress dev.eth0
>> >
>> > Co-developed-by: Victor Nogueira <victor@mojatatu.com>
>> > Signed-off-by: Victor Nogueira <victor@mojatatu.com>
>> > Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
>> > Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
>> > Co-developed-by: Evangelos Haleplidis <ehalep@mojatatu.com>
>> > Signed-off-by: Evangelos Haleplidis <ehalep@mojatatu.com>
>> > Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
>> > ---
>> >  include/net/p4tc.h           |   68 +
>> >  include/uapi/linux/p4tc.h    |  123 ++
>> >  net/sched/p4tc/Makefile      |    2 +-
>> >  net/sched/p4tc/p4tc_action.c |   89 +-
>> >  net/sched/p4tc/p4tc_cmds.c   | 3492 ++++++++++++++++++++++++++++++++++
>> >  net/sched/p4tc/p4tc_meta.c   |   65 +
>> >  6 files changed, 3835 insertions(+), 4 deletions(-)
>> >  create mode 100644 net/sched/p4tc/p4tc_cmds.c
>> >
>> > diff --git a/include/net/p4tc.h b/include/net/p4tc.h
>> > index d9267b798..164cb3c5d 100644
>> > --- a/include/net/p4tc.h
>> > +++ b/include/net/p4tc.h
>> > @@ -594,4 +594,72 @@ void tcf_register_put_rcu(struct rcu_head *head);
>> >  #define to_table(t) ((struct p4tc_table *)t)
>> >  #define to_register(t) ((struct p4tc_register *)t)
>> >
>> > +/* P4TC COMMANDS */
>> > +int p4tc_cmds_parse(struct net *net, struct p4tc_act *act, struct nlattr *nla,
>> > +                 bool ovr, struct netlink_ext_ack *extack);
>> > +int p4tc_cmds_copy(struct p4tc_act *act, struct list_head *new_cmd_operations,
>> > +                bool delete_old, struct netlink_ext_ack *extack);
>> > +
>> > +int p4tc_cmds_fillup(struct sk_buff *skb, struct list_head *meta_ops);
>> > +void p4tc_cmds_release_ope_list(struct net *net, struct list_head *entries,
>> > +                             bool called_from_template);
>> > +struct p4tc_cmd_operand;
>> > +int p4tc_cmds_fill_operand(struct sk_buff *skb, struct p4tc_cmd_operand *kopnd);
>> > +
>> > +struct p4tc_cmd_operate {
>> > +     struct list_head cmd_operations;
>> > +     struct list_head operands_list;
>> > +     struct p4tc_cmd_s *cmd;
>> > +     char *label1;
>> > +     char *label2;
>> > +     u32 num_opnds;
>> > +     u32 ctl1;
>> > +     u32 ctl2;
>> > +     u16 op_id;              /* P4TC_CMD_OP_XXX */
>> > +     u32 cmd_offset;
>> > +     u8 op_flags;
>> > +     u8 op_cnt;
>> > +};
>> > +
>> > +struct tcf_p4act;
>> > +struct p4tc_cmd_operand {
>> > +     struct list_head oper_list_node;
>> > +     void *(*fetch)(struct sk_buff *skb, struct p4tc_cmd_operand *op,
>> > +                    struct tcf_p4act *cmd, struct tcf_result *res);
>> > +     struct p4tc_type *oper_datatype; /* what is stored in path_or_value - P4T_XXX */
>> > +     struct p4tc_type_mask_shift *oper_mask_shift;
>> > +     struct tc_action *action;
>> > +     void *path_or_value;
>> > +     void *path_or_value_extra;
>> > +     void *print_prefix;
>> > +     void *priv;
>> > +     u64 immedv_large[BITS_TO_U64(P4T_MAX_BITSZ)];
>> > +     u32 immedv;             /* one of: immediate value, metadata id, action id */
>> > +     u32 immedv2;            /* one of: action instance */
>> > +     u32 path_or_value_sz;
>> > +     u32 path_or_value_extra_sz;
>> > +     u32 print_prefix_sz;
>> > +     u32 immedv_large_sz;
>> > +     u32 pipeid;             /* 0 for kernel */
>> > +     u8 oper_type;           /* P4TC_CMD_OPER_XXX */
>> > +     u8 oper_cbitsize;       /* based on P4T_XXX container size */
>> > +     u8 oper_bitsize;        /* diff between bitend - oper_bitend */
>> > +     u8 oper_bitstart;
>> > +     u8 oper_bitend;
>> > +     u8 oper_flags;          /* TBA: DATA_IS_IMMEDIATE */
>> > +};
>> > +
>> > +struct p4tc_cmd_s {
>> > +     int cmdid;
>> > +     u32 num_opnds;
>> > +     int (*validate_operands)(struct net *net, struct p4tc_act *act,
>> > +                              struct p4tc_cmd_operate *ope, u32 cmd_num_opns,
>> > +                              struct netlink_ext_ack *extack);
>> > +     void (*free_operation)(struct net *net, struct p4tc_cmd_operate *op,
>> > +                            bool called_for_instance,
>> > +                            struct netlink_ext_ack *extack);
>> > +     int (*run)(struct sk_buff *skb, struct p4tc_cmd_operate *op,
>> > +                struct tcf_p4act *cmd, struct tcf_result *res);
>> > +};
>> > +
>> >  #endif
>> > diff --git a/include/uapi/linux/p4tc.h b/include/uapi/linux/p4tc.h
>> > index 0c5f2943e..e80f93276 100644
>> > --- a/include/uapi/linux/p4tc.h
>> > +++ b/include/uapi/linux/p4tc.h
>> > @@ -384,4 +384,127 @@ enum {
>> >  #define P4TC_RTA(r) \
>> >       ((struct rtattr *)(((char *)(r)) + NLMSG_ALIGN(sizeof(struct p4tcmsg))))
>> >
>> > +/* P4TC COMMANDS */
>> > +
>> > +/* Operations */
>> > +enum {
>> > +     P4TC_CMD_OP_UNSPEC,
>> > +     P4TC_CMD_OP_SET,
>> > +     P4TC_CMD_OP_ACT,
>> > +     P4TC_CMD_OP_BEQ,
>> > +     P4TC_CMD_OP_BNE,
>> > +     P4TC_CMD_OP_BLT,
>> > +     P4TC_CMD_OP_BLE,
>> > +     P4TC_CMD_OP_BGT,
>> > +     P4TC_CMD_OP_BGE,
>> > +     P4TC_CMD_OP_PLUS,
>> > +     P4TC_CMD_OP_PRINT,
>> > +     P4TC_CMD_OP_TBLAPP,
>> > +     P4TC_CMD_OP_SNDPORTEGR,
>> > +     P4TC_CMD_OP_MIRPORTEGR,
>> > +     P4TC_CMD_OP_SUB,
>> > +     P4TC_CMD_OP_CONCAT,
>> > +     P4TC_CMD_OP_BAND,
>> > +     P4TC_CMD_OP_BOR,
>> > +     P4TC_CMD_OP_BXOR,
>> > +     P4TC_CMD_OP_LABEL,
>> > +     P4TC_CMD_OP_JUMP,
>> > +     __P4TC_CMD_OP_MAX
>> > +};
>> > +#define P4TC_CMD_OP_MAX (__P4TC_CMD_OP_MAX - 1)
>> > +
>> > +#define P4TC_CMD_OPERS_MAX 9
>> > +
>> > +/* single operation within P4TC_ACT_CMDS_LIST */
>> > +enum {
>> > +     P4TC_CMD_UNSPEC,
>> > +     P4TC_CMD_OPERATION,     /*struct p4tc_u_operate */
>> > +     P4TC_CMD_OPER_LIST,    /*nested P4TC_CMD_OPER_XXX list */
>> > +     P4TC_CMD_OPER_LABEL1,
>> > +     P4TC_CMD_OPER_LABEL2,
>> > +     __P4TC_CMD_OPER_MAX
>> > +};
>> > +#define P4TC_CMD_OPER_MAX (__P4TC_CMD_OPER_MAX - 1)
>> > +
>> > +enum {
>> > +     P4TC_CMD_OPER_A,
>> > +     P4TC_CMD_OPER_B,
>> > +     P4TC_CMD_OPER_C,
>> > +     P4TC_CMD_OPER_D,
>> > +     P4TC_CMD_OPER_E,
>> > +     P4TC_CMD_OPER_F,
>> > +     P4TC_CMD_OPER_G,
>> > +     P4TC_CMD_OPER_H,
>> > +     P4TC_CMD_OPER_I,
>> > +};
>> > +
>> > +#define P4TC_CMDS_RESULTS_HIT 1
>> > +#define P4TC_CMDS_RESULTS_MISS 2
>> > +
>> > +/* P4TC_CMD_OPERATION */
>> > +struct p4tc_u_operate {
>> > +     __u16 op_type;          /* P4TC_CMD_OP_XXX */
>> > +     __u8 op_flags;
>> > +     __u8 op_UNUSED;
>> > +     __u32 op_ctl1;
>> > +     __u32 op_ctl2;
>> > +};
>> > +
>> > +/* Nested P4TC_CMD_OPER_XXX */
>> > +enum {
>> > +     P4TC_CMD_OPND_UNSPEC,
>> > +     P4TC_CMD_OPND_INFO,
>> > +     P4TC_CMD_OPND_PATH,
>> > +     P4TC_CMD_OPND_PATH_EXTRA,
>> > +     P4TC_CMD_OPND_LARGE_CONSTANT,
>> > +     P4TC_CMD_OPND_PREFIX,
>> > +     __P4TC_CMD_OPND_MAX
>> > +};
>> > +#define P4TC_CMD_OPND_MAX (__P4TC_CMD_OPND_MAX - 1)
>> > +
>> > +/* operand types */
>> > +enum {
>> > +     P4TC_OPER_UNSPEC,
>> > +     P4TC_OPER_CONST,
>> > +     P4TC_OPER_META,
>> > +     P4TC_OPER_ACTID,
>> > +     P4TC_OPER_TBL,
>> > +     P4TC_OPER_KEY,
>> > +     P4TC_OPER_RES,
>> > +     P4TC_OPER_HDRFIELD,
>> > +     P4TC_OPER_PARAM,
>> > +     P4TC_OPER_DEV,
>> > +     P4TC_OPER_REG,
>> > +     P4TC_OPER_LABEL,
>> > +     __P4TC_OPER_MAX
>> > +};
>> > +#define P4TC_OPER_MAX (__P4TC_OPER_MAX - 1)
>> > +
>> > +#define P4TC_CMD_MAX_OPER_PATH_LEN 32
>> > +
>> > +/* P4TC_CMD_OPER_INFO operand*/
>> > +struct p4tc_u_operand {
>> > +     __u32 immedv;           /* immediate value */
>> > +     __u32 immedv2;
>> > +     __u32 pipeid;           /* 0 for kernel-global */
>> > +     __u8 oper_type;         /* P4TC_OPER_XXX */
>> > +     __u8 oper_datatype;     /* T_XXX */
>> > +     __u8 oper_cbitsize;     /* Size of container, u8 = 8, etc
>> > +                              * Useful for a type that is not atomic
>> > +                              */
>> > +     __u8 oper_startbit;
>> > +     __u8 oper_endbit;
>> > +     __u8 oper_flags;
>> > +};
>> > +
>> > +/* operand flags */
>> > +#define DATA_IS_IMMEDIATE (BIT(0)) /* data is held as immediate value */
>> > +#define DATA_IS_RAW (BIT(1))  /* bitXX datatype, not intepreted by kernel */
>> > +#define DATA_IS_SLICE (BIT(2))        /* bitslice in a container, not intepreted
>> > +                               * by kernel
>> > +                               */
>> > +#define DATA_USES_ROOT_PIPE (BIT(3))
>> > +#define DATA_HAS_TYPE_INFO (BIT(4))
>> > +#define DATA_IS_READ_ONLY (BIT(5))
>> > +
>> >  #endif
>> > diff --git a/net/sched/p4tc/Makefile b/net/sched/p4tc/Makefile
>> > index b35ced1e3..396fcd249 100644
>> > --- a/net/sched/p4tc/Makefile
>> > +++ b/net/sched/p4tc/Makefile
>> > @@ -2,4 +2,4 @@
>> >
>> >  obj-y := p4tc_types.o p4tc_pipeline.o p4tc_tmpl_api.o p4tc_meta.o \
>> >       p4tc_parser_api.o p4tc_hdrfield.o p4tc_action.o p4tc_table.o \
>> > -     p4tc_tbl_api.o p4tc_register.o
>> > +     p4tc_tbl_api.o p4tc_register.o p4tc_cmds.o
>> > diff --git a/net/sched/p4tc/p4tc_action.c b/net/sched/p4tc/p4tc_action.c
>> > index f47b42bbe..f40acdc5a 100644
>> > --- a/net/sched/p4tc/p4tc_action.c
>> > +++ b/net/sched/p4tc/p4tc_action.c
>> > @@ -147,7 +147,7 @@ static int __tcf_p4_dyna_init_set(struct p4tc_act *act, struct tc_action **a,
>> >  {
>> >       struct tcf_p4act_params *params_old;
>> >       struct tcf_p4act *p;
>> > -     int err = 0;
>> > +     int err;
>> >
>> >       p = to_p4act(*a);
>> >
>> > @@ -156,6 +156,14 @@ static int __tcf_p4_dyna_init_set(struct p4tc_act *act, struct tc_action **a,
>> >
>> >       goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
>> >
>> > +     err = p4tc_cmds_copy(act, &p->cmd_operations, exists, extack);
>> > +     if (err < 0) {
>> > +             if (exists)
>> > +                     spin_unlock_bh(&p->tcf_lock);
>> > +
>> > +             return err;
>> > +     }
>> > +
>> >       params_old = rcu_replace_pointer(p->params, params, 1);
>> >       if (exists)
>> >               spin_unlock_bh(&p->tcf_lock);
>> > @@ -358,9 +366,15 @@ static int dev_dump_param_value(struct sk_buff *skb,
>> >
>> >       nest = nla_nest_start(skb, P4TC_ACT_PARAMS_VALUE);
>> >       if (param->flags & P4TC_ACT_PARAM_FLAGS_ISDYN) {
>> > +             struct p4tc_cmd_operand *kopnd;
>> >               struct nlattr *nla_opnd;
>> >
>> >               nla_opnd = nla_nest_start(skb, P4TC_ACT_PARAMS_VALUE_OPND);
>> > +             kopnd = param->value;
>> > +             if (p4tc_cmds_fill_operand(skb, kopnd) < 0) {
>> > +                     ret = -1;
>> > +                     goto out_nla_cancel;
>> > +             }
>> >               nla_nest_end(skb, nla_opnd);
>> >       } else {
>> >               const u32 *ifindex = param->value;
>> > @@ -557,10 +571,48 @@ static int tcf_p4_dyna_act(struct sk_buff *skb, const struct tc_action *a,
>> >  {
>> >       struct tcf_p4act *dynact = to_p4act(a);
>> >       int ret = 0;
>> > +     int jmp_cnt = 0;
>> > +     struct p4tc_cmd_operate *op;
>> >
>> >       tcf_lastuse_update(&dynact->tcf_tm);
>> >       tcf_action_update_bstats(&dynact->common, skb);
>> >
>> > +     /* We only need this lock because the operand's that are action
>> > +      * parameters will be assigned at run-time, and thus will cause a write
>> > +      * operation in the data path. If we had this structure as per-cpu, we'd
>> > +      * possibly be able to get rid of this lock.
>> > +      */
>> > +     lockdep_off();
>>
>> The comment explains why the lock is required, but doesn't address the
>> lockdep off/on. Could you elaborate on why it is needed?
>>
>
> Note: we can invoke actions from other actions.
> Reason it is needed is there is a deadlock false positive splat in the
> following scenario:
> A dynamic action will lock(dynact->tcf_lock) for its data and then
> invoke a totally
> different dynamic action (with totally independent data) which will also protect
> its data by invoking its tcf_lock.

Is the ordering of recursive action execution while holding the lock
well defined? Is there anything preventing action A from calling B
(maybe indirectly via some chain of actions) and vice versa resulting
ABBA deadlock?

> We will add more description as such.
> Does this also address what you said on "doesnt address the lockdep off/on"?

Yep.

> Unfortunately this is in the datapath - not sure how much cost it adds.

I would assume lockdep_off/on doesn't result any performance impact on
production kernels that are compiled without lockdep, just prefer to
"cooperate" with lockdep by assigning classes where possible instead of
disabling it outright. Not sure whether it is an option this case
though.

