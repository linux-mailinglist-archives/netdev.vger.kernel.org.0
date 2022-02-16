Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 521B04B8B37
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 15:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234910AbiBPOSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 09:18:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234116AbiBPOSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 09:18:24 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6218E1B6506
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 06:18:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iErb4ILCx0R0FrojMXLuroBwCHnkTPOWb789Ynb8QEAN9CdUDCc6tQA90NGWMBSd8x1gGybjLC6zmBwx6/IQRgJcRbj08FjHLh7PEDnSbfRP+N6aWcp3TlJvjhRn2u+vPK6Z1d9h2lWjdsmJ1qWDuMaBwSn+s1pcfZGjkTsBsCEJi70IBX1fzCANWxrKslyT2FxoXcXxCW9s9zrSmVbLwL3r9HPbaYZ7cxy2eBdvqTVW90K41A15GJOkkyxfKDCd9ZkWG5VSixJnW6+Ii4jGbiH8zD80vz5tLp0T4+nheaOJQH9BGOIWYFoUt0iP/IWmFwIpBfmhLvVhD+/aQoFNrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fz38yL4rZZPZoTGuXGNC6jD5wC2u3hIsMJWXTX/x/oQ=;
 b=NzMHcPSkPahSliPO3oanjxOEs4cpD1DZtoK7PgksxSF8SCkkG4axbon/iLy2un2PbqoVtcmScXqjH/2NeD/ZNqQP5fvPuV8kXeoLTe4qDmaCRdh8ZKq95B0vY6HjK2zkiWUFAVdL/Dz628QqbzFKnLth/DEIQpLsT+7T6SDyDFUz5ISfO4gRggM2Vw0BrpG4H9RftHEOZGgLavp4K/42t7Cs3OMEm7yUJTypQph4l3Cgx+CnnuH+C5wicFgUVTHjGChb2CAFjhtScSyBHENydujWc1aRgasXIVS0DFmBXBEN/TrQRNZ0vyO0uyZHQ6AaGc4NHww3LSGhmMhBG/6K3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fz38yL4rZZPZoTGuXGNC6jD5wC2u3hIsMJWXTX/x/oQ=;
 b=A/TeItOeVaRD/r0EXTwazbdKUyc//rk/uieJFzak4aYkt5AaCvDeeyUgJ+NzRweVC4GUiRNHRuKYWnIqq8DzogkPmgIjNlKY0cCK1QlfC+5H1r7MCgsNLZoDrVGahkCc6Nn/eavE3cldmkXMF/CSpfuF4+oomDqzgHRYhQms9uV4wDiNR3hLqrxYCnJDnJq85dmzXZduNpNwdby3JrMgBHyakUrjq+YCEnSTqpEBKBVcKS/VTXMn0+vFPehxsRi5Iiz6uCgoI+sx+yo08Dvgp+2E78S0YviSHIud9X8cg3oxP7XgCGPOHVbBbJztmvYSRl06OzB+ndi+jdese9ckcw==
Received: from MWHPR1601CA0019.namprd16.prod.outlook.com
 (2603:10b6:300:da::29) by MW3PR12MB4412.namprd12.prod.outlook.com
 (2603:10b6:303:58::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Wed, 16 Feb
 2022 14:18:10 +0000
Received: from CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:da:cafe::73) by MWHPR1601CA0019.outlook.office365.com
 (2603:10b6:300:da::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19 via Frontend
 Transport; Wed, 16 Feb 2022 14:18:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT043.mail.protection.outlook.com (10.13.174.193) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Wed, 16 Feb 2022 14:18:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 16 Feb
 2022 14:18:09 +0000
Received: from [172.27.15.103] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 16 Feb 2022
 06:18:06 -0800
Message-ID: <5c888335-9732-8cdc-eab2-081ddbb8f2df@nvidia.com>
Date:   Wed, 16 Feb 2022 16:18:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:98.0) Gecko/20100101
 Thunderbird/98.0
Subject: Re: [PATCH iproute2-next v2] tc: add skip_hw and skip_sw to control
 action offload
Content-Language: en-US
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Victor Nogueira <victor@mojatatu.com>
CC:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        "Simon Horman" <simon.horman@corigine.com>
References: <1643180079-17097-1-git-send-email-baowen.zheng@corigine.com>
 <CA+NMeC_RKJXwbpjejTXKViUzUjDi0N-ZKoSa9fun=ySfThV5gA@mail.gmail.com>
 <b24054ae-7267-b5ca-363b-9c219fb05a98@mojatatu.com>
 <1861edc9-7185-42f6-70dc-bfbfdd348462@nvidia.com>
 <caeac129-25f4-6be5-76ce-9e0b20b68e7c@nvidia.com>
 <DM5PR1301MB21726E820BC91768462B8C70E7279@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <8a777b6f-0084-5262-40f6-d9400f7e6b15@mojatatu.com>
 <DM5PR1301MB21722969131F70DD7FA350EFE7309@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <280e716c-a588-5c7b-d77e-d5d09bb0148b@mojatatu.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <280e716c-a588-5c7b-d77e-d5d09bb0148b@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1467847-a89c-4901-a728-08d9f157293a
X-MS-TrafficTypeDiagnostic: MW3PR12MB4412:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB4412366CDC4A9833A8F4C489B8359@MW3PR12MB4412.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uoG21S328wkaMuMtimFX+LLe6Lyu5v7urreVPUyWREJSarfr5BrR8m/cGOMKQ5voOHexfxgaOmqu5Hfc4U+u1/YckKM+U3FngvFeLFFFF1Fdg0UJCB4cffS+ehyCB7DaPJTevi5hMMZH3m2KuuNWFNYJSPZG0NklThFt+BQXxezmyJQbScFEb3lKzDfwAd8COb6zx7AVT8zY0aNszm78HXGJnjJHRoRz9WEn2wCi5Wnb9rH4Qj9nc8Wy8sepKCmvJ/BVzylfiOAPXBOc1vq92votGWgtANvpHdchKHWye+zTVlmAAnD/lRd2FxWEmiQMVas0oIe8dMb5UWFGXDFbSsE1GxGvNJfJ9b0Jivbi9eZKSWfsF0Z96TK5o4yhxmwlV+bNWO+8/KyqNDy67O7nWFLlFI5BQdlBJ0PBxnvRKtEYw+E+/uJtKDwboRQCSwgQIJ1kgLZaqBBdiyx9P/ePoCdGqfR0tY/J2/jEO7377wm8P4FcNCbNFa8kLUMGwNRozdyfm//qTghmLrpixcoCP8+59oqg2uPnf6zOie+d6ysMABEuFymISY637yz3UOgY4zCXt7gftz1gFInAtFsbhbGEDJY0kNL4M4hxSxQ1V9Ubenf/tlIOUkzZc32Snn9jnsZZapzGdn+RtQX+561crwYoC7AE9+V5q7LThd1sWczkoN/C1Qcn4CMrs6j0cSWWMXlRccg3BEr4ns+47s02S+OCB3qhYOu0GUbVUiaF+GVzRgf4p8sLxfwjWoB/3d2C/xzscZ2eJknpIZSySxZ1gA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(31686004)(26005)(31696002)(2906002)(36860700001)(47076005)(36756003)(40460700003)(8936002)(16526019)(110136005)(16576012)(316002)(54906003)(426003)(53546011)(186003)(81166007)(356005)(83380400001)(336012)(4326008)(8676002)(70586007)(508600001)(86362001)(82310400004)(5660300002)(2616005)(70206006)(21314003)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 14:18:10.4232
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1467847-a89c-4901-a728-08d9f157293a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4412
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-02-16 2:51 PM, Jamal Hadi Salim wrote:
> On 2022-02-11 05:01, Baowen Zheng wrote:
>> Hi Jamal:
>> Sorry for the delay of the reply.
>>
> 
> I guess it is my turn to say sorry for the latency ;->
> 
>> On February 2, 2022 7:47 PM, Jamal wrote:
>>> On 2022-02-02 04:37, Baowen Zheng wrote:
>>>> Hi Roi:
>>>> Thanks for bring this to us, please see the inline comments.
>>>>
> 
> [..]
>>>
>>> Probably the language usage is causing the confusion and I missed 
>>> this detail
>>> in the output as well. Let me see if i can break this down.
>>>
>>> Either both action and  filter are in h/w or they are not. i.e
>>>
>>> action in h/w  + filter in h/w == GOOD
>>> action in h/w  + filter in s/w == BAD
>>> action in s/w  + filter in h/w == BAD
>>> action in s/w  + filter in s/w == GOOD
>>>
>>> The kernel patches did have those rules in place - and Baowen added 
>>> tdc tests
>>> to check for this.
>>>
>>> Now on the workflow:
>>> 1) If you add an action independently to offload before you add a 
>>> filter when
>>> you dump actions it should say "skip_sw, ref 1 bind 0"
>>> i.e information is sufficient here to know that the action is 
>>> offloaded but there
>>> is no filter attached.
>>>
>>> 2) If you bind this action after to a filter which _has to be offloaded_
>>> (otherwise the filter will be rejected) then when you dump the 
>>> actions you
>>> should see "skip_sw ref 2 bind 1"; when you dump the filter you 
>>> should see
>>> the same on the filter.
>>>
>>> 3) If you create a skip_sw filter without step #1 then when you dump you
>>> should see "skip_sw ref 1 bind 1" both when dumping in IOW, the 
>>> not_in_hw
>>> is really unnecessary.
>>>
>>> So why not just stick with skip_sw and not add some new language?
>>>
>> If I do not misunderstand, you mean we just show the skip_sw flag and 
>> do not show other information(in_hw, not_in_hw and in_hw_count), I 
>> think it is reasonable to show the action information as your 
>> suggestion if the action is dumped along with the filters.
>>
> 
> Yes, thats what i am saying - it maintains the existing semantics people
> are aware of for usability.
> 
>> But as we discussed previously, we added the flags of skip_hw, 
>> skip_sw, in_hw_count mainly for the action dump command(tc -s -d 
>> actions list action xxx).
>> We know that the action can be created with three flags case: skip_sw, 
>> skip_hw and no flag.
>> Then when the actions are dumped independently, the information of 
>> skip_hw, skip_sw, in_hw_count will become important for the user to 
>> distinguish if the action is offloaded or not.
>>
>> So does that mean we need to show different item when the action is 
>> dumped independent or along with the filter?
>>
> 
> I see your point. I am trying to visualize how we deal with the
> tri-state  in filters and we never considered what you are suggesting.
> Most people either skip_sw or skip_hw in presence of offloadable hw.
> In absence of hardware nobody specifies a flag, so nothing is displayed.
> My eyes are used to how filters look like. Not sure anymore tbh. Roi?
> 

Hi,

Is the question here if to show different information
when actions are dumped independently or with a filter?

then I think yes. when actions are dumped as part of the filter
skip showing skip_sw/skip_hw/in_hw/not_in_hw flags as it's redundant and
it's always whatever the filter state is.

I also noticed we can improve extack msgs when a user will try to mix
the state like adding a filter without skip_hw flag but use action index
that is created with skip_hw.
I noticed currently there is no informative extack msg back to the user.

Thanks,
Roi


> cheers,
> jamal
> 
> 
