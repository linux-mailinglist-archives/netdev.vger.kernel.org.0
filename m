Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56445B24A4
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 19:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbiIHRbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 13:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiIHRbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 13:31:44 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1416B9A6A9;
        Thu,  8 Sep 2022 10:31:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FO1Ylo5QsENT8r4vHAimcRrgoTK5kv7aT7Y4O76ANJqGYlaJMHQNboidoamK18EZIN/8AC/dRiy5SIboUDCliFCp+9C54b9UR2hTTWPt3MRG8X5P8Ln4a+Uvh2xdk91W6+b8LKeGIjfa/2A4N/pmHWQX3/0bkchIFxDI6DHvhO5yYi29Nm88RxuxoerBHCKnzXJwse1zlnt4mgxbtY8oLUKOKqXyeJAfuey6+JBJz1LJf4NkF94zQRmocFP1aaE1Q5wFxofXA13S8vwUAb9dBm4CzMf9x4jaV1UHnmIlAzos0C0ZzKBSu868xdbYYSWNjHvIImSaRUZZdjcc7aGsZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CHS8NN/QCCRkF6n+Ry2epkdBZVTjteE89MZRb+nFFMk=;
 b=R7frQSU9AcloaPp7mXmoIq2IcRUF3UslYDk5twBzo4SXOlbtQdIiuq5oCNlfdhKoMiDwVtX2oQmUtzBO7VFzasj5KgPBvnU2zmWEF/hx9qUBUmMhis0aHgdjMAovxbLsjEiAocSmczoppNSdzQYargfYa1HsoxzNNYehgU9QgPTCL0+TWrgg6s1DLfGFBCi0WRgLhEeeKfyCx/EQSJ3F9aP0cBb6SufMk8291GEiJeDpWFVFtLnfzQyzEMlqApQ/sHFSEJOnzomzVHr27B24p84zzNopNb4NNxFyy5D+BV4xdBg97ncO/JF3wbg9khwtxQWEr0tKx0TLgHA+jvImOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHS8NN/QCCRkF6n+Ry2epkdBZVTjteE89MZRb+nFFMk=;
 b=hWMPDM7tOC3Dqt08yG+ZuFij1iDacgIkCeFaHuY4RlpJTbHjeJj/hsM6CkpnYUMdLW+08dFqco/TS6wmHwXLM2xqxL1fR7E0jTxmQ4BbNp7QxYDJblZJmEW/svBANN2FLBNB5wJR8tTEgK2yyQZY20b1dvpozFHNr/0Hibc7ZfuagvQiqXbAGVGZp7XqjpYy8s1ohIdbqijBpSbFxae3dG+01EdZrmM72Fr/RuWSHGmDsfLe5oIbA/r8yB1IE2H8zUvFdTHzZ1KX3Fd69Oj/y1fXZ0q4lx0/ioeYXlHKuwikEfia+SqEE9QT8zxUvwGXRsN3j5RUnuYrf/aS3fWaaA==
Received: from MW4P220CA0020.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::25)
 by CH2PR12MB5004.namprd12.prod.outlook.com (2603:10b6:610:62::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 8 Sep
 2022 17:31:41 +0000
Received: from CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::33) by MW4P220CA0020.outlook.office365.com
 (2603:10b6:303:115::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19 via Frontend
 Transport; Thu, 8 Sep 2022 17:31:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT022.mail.protection.outlook.com (10.13.175.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.13 via Frontend Transport; Thu, 8 Sep 2022 17:31:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 8 Sep
 2022 17:31:40 +0000
Received: from [172.27.0.38] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 8 Sep 2022
 10:31:36 -0700
Message-ID: <83fe2fa1-7f49-35f5-ba4b-5662175bbe31@nvidia.com>
Date:   Thu, 8 Sep 2022 20:31:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [GIT PULL] Please pull mlx5 vfio changes
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <maorg@nvidia.com>, <cohuck@redhat.com>,
        Leon Romanovsky <leon@kernel.org>
References: <20220907094344.381661-1-leon@kernel.org>
 <20220907132119.447b9219.alex.williamson@redhat.com>
 <YxmMMR3u1VRedWdK@unreal>
 <20220908105345.28da7c98.alex.williamson@redhat.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20220908105345.28da7c98.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT022:EE_|CH2PR12MB5004:EE_
X-MS-Office365-Filtering-Correlation-Id: 422b76bb-fd93-47b3-0e02-08da91bffdf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ao0Q9dAK+HtVRhsfzZvKwB4gj8GhdxBARTd2qH1QfY2czwnsIytlZgq5Ir/v3UPteuxoLjLodv5rQVaWT5icbvhjqN1yChvt1nkSi53N/kT5nW16Ps5O6pURlrpGiDrRG/tGe+TsvRkKsWaNL2V7JzYe3ZzjQUTjnuOqUdx3PDXz28zjjK24LsU++sqbK7Lj4cBReMwdJQeUaJF1HlVYmI/iHE4WZsn9awj2G1jNo7XT1KSHiri3SQenrOVKIQoClqBXqIsikmyqwUH7KfFzTNh9TOxT/4ECYvcv99KATBbzkJFiVkfNedfJnK1yHQWS7sW1CcRPxYe4nnQq3WQIwnLwNRpKFKQKv8mja00mc/xFpZoAuS9gDT7POSdR77MnSB9JowjKX3FxVaFUDSZf+GAn+0rggRP5mp4ghWk9SrVFbH9kCj7tGz3NffPcmb0Ap213/CJusXBaSydDvRbJpgCL4OkF6BhX87zLbYmWsisReYrzNkRGOyQ9zqr8krbAT0l4+JvEm3L3Hpk6svIsLC157rJgjLlca7v/CcJ7mAXkNd4xsOqBRs3QM4V2aUDphQRiaJgRA9PZW6UijQty0eh688lHanVKSnBT8IlGDqas+zEpPO1i8OCNIgeu8jiPsJlkJsHXTbmQLOAD9AAYEJRf5FOxYJjnoIEkUrjcYMSP7ycDqz56loTMvsdsQvkj6aEMlofXnQeNsOwu5OyZ7IrZUcjhXsNqo4MyOEugZszB6Azv4h4XmwOnCCNSJYoyabNh2e26uMO4nxSwXm9jXGSk4cQteJWGljo09XTL10ViMKhtFCPyCjyFBKRLuRDvjyv3d4UYxHduFrbkd5IZBxbNuzi2eGx/CjHINR6wuWWa1JUDrd+vJLrKNHepij6dYgx444cLjZUGQVAMENfoZQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(396003)(39860400002)(36840700001)(46966006)(40470700004)(16576012)(70206006)(47076005)(2616005)(966005)(54906003)(8676002)(478600001)(53546011)(70586007)(40480700001)(36756003)(16526019)(336012)(6916009)(2906002)(186003)(426003)(83380400001)(31686004)(316002)(81166007)(86362001)(4326008)(356005)(26005)(41300700001)(82740400003)(5660300002)(36860700001)(82310400005)(8936002)(40460700003)(31696002)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 17:31:41.0729
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 422b76bb-fd93-47b3-0e02-08da91bffdf5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5004
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/09/2022 19:53, Alex Williamson wrote:
> On Thu, 8 Sep 2022 09:31:13 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
>
>> On Wed, Sep 07, 2022 at 01:21:19PM -0600, Alex Williamson wrote:
>>> On Wed,  7 Sep 2022 12:43:44 +0300
>>> Leon Romanovsky <leon@kernel.org> wrote:
>>>    
>>>> Hi Alex,
>>>>
>>>> This series is based on clean 6.0-rc4 as such it causes to two small merge
>>>> conficts whis vfio-next. One is in thrird patch where you should take whole
>>>> chunk for include/uapi/linux/vfio.h as is. Another is in vfio_main.c around
>>>> header includes, which you should take too.
>>> Is there any reason you can't provide a topic branch for the two
>>> net/mlx5 patches and the remainder are rebased and committed through
>>> the vfio tree?
>> You added your Acked-by to vfio/mlx5 patches and for me it is a sign to
>> prepare clean PR with whole series.
>>
>> I reset mlx5-vfio topic to have only two net/mlx5 commits without
>> special tag.
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git topic/mlx5-vfio
>> Everything else can go directly to your tree without my intervention.
> Sorry, I knew the intention initially was to send a PR and I didn't
> think about the conflicts we'd have versus the base you'd use.  Thanks
> for splitting this out, I think it'll make for a cleaner upstream path
> given the clear code split.
>
> Yishai, can you post a v7 rebased on the vfio next branch?


Sure

Do you want me to include in V7 the two net/mlx5 patches that are part 
of the PR or that you'll take them first from the PR, publish your 
vfio/next tree and I'll drop them from V7 ?

> The comment
> I requested is now ephemeral since it only existed in the commits Leon
> dropped.  Also feel free to drop my Acks since I'll add new Sign-offs.
> Thanks,

OK, will drop them.

>
> Alex
>

