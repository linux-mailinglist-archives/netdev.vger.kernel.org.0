Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B71424B2086
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 09:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348134AbiBKIrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 03:47:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbiBKIrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 03:47:13 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0751BE67;
        Fri, 11 Feb 2022 00:47:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZECJ3Ha92+E8uckx4KJOPucDElT7N41zcNtV5blXoFTpY35PpfRX6c9ENjV4XmAdnXJhu27POjnWP2rDxn93NlAhpEW54sWnvgDYycp1NTS15SZ5pBBtLNUSyhujylpjj4SbDq1l2FAxP1M0oo7TO2gYvbPdlRzowy2NCCo3pWsLgKNxpScC+HxdwHK4Z+SUgnLITF+HYQiF0E0pq1ptgA0lBitrfwiWnF1E1NNxmzX16rqvrFOk38/5kGGeqflEt7f5OMPn1rnGVTowDB2+Iui89BAfMf2aGzGh9IhyyiHm8xrOWE5YXckd9nSvNgVWJiwOb8fewsqocyeHL794A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I9J/i9DLuAFkNgWQ9A5K0S0hIydL8OetIDThXxT61/g=;
 b=d/Hc//YOsZNlBljJaVhbhTwpSbwlVpBiOfupCp5FhhgtWBTQ94gOu3pNHl1dygK7JVNtRHUjvH4LBzhkwyH++tgLiXt8cfObxYkE09ZLEj4vFC1GK5pBLXiNQG17dFNl7AZRH9ySAZR6mfqlm/brU7mpr3quQ2/1h9LVfNI8dzMeWooa8gyXOGpc13FRYQrrcFjY4DAS29IqV7txJlK3LkXBhE7Vub4JKHhfYHx8rQMR8Rqa0V2xVD0sI7ubtNIAWNTWeDvrK9g2X4hBrCNywLKLf6nwq7MLE0FF/E+0uYt7KEBDl7NXZdqoVcwZUy7nZVI+DK+pHBI1nszQ7bwNJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9J/i9DLuAFkNgWQ9A5K0S0hIydL8OetIDThXxT61/g=;
 b=mRACvPryV2otzKu+Ml8U2Vn4I9f4bRz30eeN389h2PLwPKenfbtvCtXglLGp1IbswHqHeLBGQC+FGtbDqwYaW4Xye5YNhcgCmF44C2jPrkImklIL12HxmsHuHWjuXrQnMadTfmQKxJ/1q93adG/eWjV3QJOaw/dscT/DnU8s5gQUWq32cmL3slAGM3SnGREBpeI5T+pg8HDdHSGljtpJhbDKhAuGULEWIu1kaAWqYN1nX3sK7RXgOma67tgDj0yVpdmS8TdC2MhuECFsEy3OnF9UEyHqojza4QgJ5nIpL4sIyWA/0dlGCHe/RbQ1xE89WubHO38upxpQPyuMm81Dcg==
Received: from BN1PR12CA0025.namprd12.prod.outlook.com (2603:10b6:408:e1::30)
 by DM5PR12MB1433.namprd12.prod.outlook.com (2603:10b6:3:73::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Fri, 11 Feb
 2022 08:47:10 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e1:cafe::66) by BN1PR12CA0025.outlook.office365.com
 (2603:10b6:408:e1::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.13 via Frontend
 Transport; Fri, 11 Feb 2022 08:47:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Fri, 11 Feb 2022 08:47:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 11 Feb
 2022 08:46:59 +0000
Received: from [172.27.0.77] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Fri, 11 Feb 2022
 00:46:57 -0800
Message-ID: <93db21c4-7b44-64ba-e873-e9ef4d548707@nvidia.com>
Date:   Fri, 11 Feb 2022 10:46:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH net-next 0/4] net/mlx5: Introduce devlink param to disable
 SF aux dev probe
Content-Language: en-US
To:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1644340446-125084-1-git-send-email-moshe@nvidia.com>
 <20220208212341.513e04bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YgOQAZKnbm5IzbTy@nanopsycho>
 <20220209172525.19977e8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YgS4dFHFPPMITaoV@nanopsycho>
 <b5b3b3c9-dd31-92ba-7704-c721a26aa805@nvidia.com>
 <DM8PR12MB5480819152FAA88B299B427FDC2F9@DM8PR12MB5480.namprd12.prod.outlook.com>
From:   Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <DM8PR12MB5480819152FAA88B299B427FDC2F9@DM8PR12MB5480.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29cf8a4d-0270-452b-f305-08d9ed3b169d
X-MS-TrafficTypeDiagnostic: DM5PR12MB1433:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1433CF7AE6E971634665F1BDD4309@DM5PR12MB1433.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fcHtJqfxtjFTce8wDhmv9psgFa4g04fi6VCXeAQd3yFhn0bby17qjVKLDWpnI8F/6j+o5smPPfXgHbMFFF5kRI7bxM+TOqz0HBCxItfOomEhEW4UFEc8JA7NCqS6rwaDCUPtJP3G/szLqXRvPkFrQZ0CiM7VrhiKrKJK8iKep036XpPvr8LCmmRtwihbYovIFL+Ogy2pWUtSzzRTOs4DuRrbjiSnyPnml88INMh4IlLhm2mTK0Q+qLOMzwwq0AC+9jW37diLfsWCLCvqC3Sq8YC4/MAPSPjyXxR/cZNsXEWJMcIY/f2b11rrbZIoSY0s35pTKJzlsEbveto318OImis6dq3v8M1ineyjLAeED9fHxLOFU6PUx6cQBSYqCp7GCLMfm1O/Q2MrJnT2yCo4xVFWpm9aoUhz7mZ2iXPvobyE+BsWtfRCze6DMLrMm99tRXvn/jZBG8KApmSB+b4Ul+i6Je1KRQ2ouYNRgajUkPwSdnyiVMylzh2w/i+c+DQxE8Q4JlOyQ1IG8nxDriiVoilLiw/H/pU2HGHgTIZmwbaquLBAF20R0Xb73K7E5LlDuA+T4BmDZypm+GrohNDUjcvbE3lYPaU1HcZI7MCZJztPAOJ5Gcxkt+W208Bte7XwHxT1pRF1yrFvr+Sv7/IxnHRtk+zZ1TbMInw7LrT5NlQgLMmNsKrKSVTHXzVM+Hq8vwZmzbGMiMz6pBlLnyW7tI9jh2t79Gcj35eev89GixJ4VRmclI3THzrPoOXf+NvrzKhB8CIetK8vCmxKRp2PWOex5dAVHRTqbAO9IajZg8S+PjkTOAg0HKeYXKJImrTj24zASck8T6QNewF97RdC3Q==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(5660300002)(2616005)(336012)(426003)(31696002)(508600001)(31686004)(8936002)(186003)(6666004)(83380400001)(966005)(36756003)(53546011)(16526019)(26005)(2906002)(40460700003)(36860700001)(86362001)(82310400004)(47076005)(356005)(54906003)(110136005)(316002)(16576012)(70586007)(4326008)(81166007)(8676002)(70206006)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 08:47:08.6220
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29cf8a4d-0270-452b-f305-08d9ed3b169d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1433
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/10/2022 9:09 PM, Parav Pandit wrote:
>> From: Moshe Shemesh <moshe@nvidia.com>
>> Sent: Thursday, February 10, 2022 3:58 PM
>>
>> On 2/10/2022 9:02 AM, Jiri Pirko wrote:
>>> Thu, Feb 10, 2022 at 02:25:25AM CET, kuba@kernel.org wrote:
>>>> On Wed, 9 Feb 2022 09:39:54 +0200 Moshe Shemesh wrote:
>>>>> Well we don't have the SFs at that stage, how can we tell which SF
>>>>> will use vnet and which SF will use eth ?
>>>> On Wed, 9 Feb 2022 10:57:21 +0100 Jiri Pirko wrote:
>>>>> It's a different user. One works with the eswitch and creates the
>>>>> port function. The other one takes the created instance and works with it.
>>>>> Note that it may be on a different host.
>>>> It is a little confusing, so I may well be misunderstanding but the
>>>> cover letter says:
>>>>
>>>> $ devlink dev param set pci/0000:08:00.0 name enable_sfs_aux_devs \
>>>>                value false cmode runtime
>>>>
>>>> $ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11
>>>>
>>>> So both of these run on the same side, no?
>> Yes.
> In this cover letter example it is on same side.
> But as Jiri explained, both can be on different host.
>
>>>> What I meant is make the former part of the latter:
>>>>
>>>> $ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11
>>>> noprobe
>>> I see. So it would not be "global policy" but per-instance option
>>> during creation. That makes sense. I wonder if the HW is capable of
>>> such flow, Moshe, Saeed?
> At present the device isn't capable of propagating this hint.
> Moreover, the probe option is for the auxiliary devices of the SF (net, vdpa, rdma).
> We still need to probe the SF's main auxiliary device so that a devlink instance of the SF is present to control the SF parameters [1] to compose it.
>
> The one very good advantage I see of the per SF suggestion of Jakub is, the ability to compose most properties of a SF at one place on eswitch side.
>
> However, even with per SF approach on eswitch side, the hurdle was in assigning the cpu affinity of the SF, which is something preferable to do on the host, where the actual workload is running.
> So cpu affinity assignment per SF on host side requires devlink reload.
> With that consideration it is better to control rest of the other parameters [1] too on customer side auxiliary/mlx5_core.sf.1 side.
>
> [1] https://www.kernel.org/doc/html/latest/networking/devlink/devlink-params.html
>
>> LGTM. Thanks.
>>
>>>> Maybe worth clarifying - pci/0000:08:00.0 is the eswitch side and
>>>> auxiliary/mlx5_core.sf.1 is the... "customer" side, correct?
>>> Yep.
> It is important to describe both use cases in the cover letter where customer side and eswitch side can be in same/different host with example.
>
> Moshe,
> Can you please revise the cover letter?


Yes, I will send revised version.

