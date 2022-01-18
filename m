Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D894930D1
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 23:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349999AbiARWdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 17:33:44 -0500
Received: from mail-dm6nam10on2088.outbound.protection.outlook.com ([40.107.93.88]:61408
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349992AbiARWdc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jan 2022 17:33:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RtO5+Qa4YjMr03iG3obToiyQya6g4zLlL23xqLXas/7BZhuuH/QeSXoqjsUijCzSsL3cxPdbpcQZeZry5l0L7W7Pp7hx1QKNRzVP64Rmu2VdNXiVxQByS8roaN/UdeiAxaU7PddtY9qI1J3CsFjx4vlNg0MitaPSjUAmj2qtvJVTg0ca4eM6BMR8UiGqnkbtRiOWkrF8AY7NqvzZr/l22g4GMk4UKdKf64wDARqLNDSQ0lkJyX2Cb2YxlmvyN2+IZgIqRnY0WQBkAZiEWOxVZMe28aEiR/Ej+eVYONnwEkCddKTuKDgjyb10bVWD3o8o5Pm0o2mhpjLDCCADLT0UmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F/7qLXbW5GuwXZ3uWoqGvK7di5CJRbvbXLeqvel4p2c=;
 b=H+RKwT+orkrq+9WxxTJE380Xihmri9H+CcUQHIvMvXn8vgkJu4wI4qfIGNRdmdQzkx3JrQhB5E+UBsyQXFX01IHPub+u2nSMr9dixC3FOOSEdFcFNcBCLsStV6hHUUIKk/sgcw/Ht42qW98vpkuIGACw1nA+V0HfsGGf/kMqWxHW4Pj/z1492C7So6WHMHlWErSUyiZUCMEUjLhJzg14I18YDefbadGQuc3JOsNO9MrmVafeggWSZ/8jAQXFUacRcdLCpEPXRm2t8Va6O4C40fcsdgdnPnA5F/9pPJk7bPNeQ+kl+tpAOGUyXGm4SaV8YcHvu3wTsswAArnCfk9h4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/7qLXbW5GuwXZ3uWoqGvK7di5CJRbvbXLeqvel4p2c=;
 b=ByEcTjBON/7oDUIItmwZkBPOrTRiOs7krtKTVSQwVx7aO7/q170WAOZIjiiyZjwWWodcIQYL+ebEo5EkckKKsYPPHc3YP2sBZZ3pYMJhweDZAhE4CCJU/TZnOUguSacltKe5T70mVB+dq7EIbFnf9J2O9gCcSmz/lnTDBsGExc+UkPHugVwXMgAAbSCPOqQEmxZwPKgVzKs8A69ifGhrSNwttHpJ9O301To6S+DeFwgIWkGBQi55JG56y9cZcQoSuChX7NaKfMz+UgrDJFgvrhtSS+xK1iHHYYl5m6gjUYouDy8sabcR4Q8IuFDDBNO/+s5zZ64vLHLNrBWkDDQHvQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BL1PR12MB5223.namprd12.prod.outlook.com (2603:10b6:208:315::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Tue, 18 Jan
 2022 22:33:30 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496%6]) with mapi id 15.20.4909.007; Tue, 18 Jan 2022
 22:33:30 +0000
Date:   Tue, 18 Jan 2022 14:33:28 -0800
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>, Parav Pandit <parav@nvidia.com>,
        Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Message-ID: <20220118223328.tq5kopdrit5frvap@sx1>
References: <PH0PR12MB5481E3E9D38D0F8DE175A915DC519@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220111115704.4312d280@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB5481E33C9A07F2C3DEB77F38DC529@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220112163539.304a534d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB54813B900EF941852216C69BDC539@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220113204203.70ba8b54@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB54815445345CF98EAA25E2BCDC549@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220114183445.463c74f5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220115061548.4o2uldqzqd4rjcz5@sx1>
 <20220118100235.412b557c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220118100235.412b557c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
X-ClientProxiedBy: SJ0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::31) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e726ded-321b-4941-e09d-08d9dad28d7c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5223:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5223FFC4AD8C6FE6FA1E1347B3589@BL1PR12MB5223.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L6uMya47tJhpq1uPmoAV4iLjGjKXqmoOwsMT0tSs0CqT/yD4xUjMqeO3xoB6nGCNH7GI7acaRYIPj7qN5CJoKT0x1cvEMkSbIygM7C3ZJWj2wJvg0+pntmbBig/pREkFIGNSW6OeH9TxXnLnGFv3uiH5dJ1UXj6NKAYvssSSN4JlRzfMbJmBTfp48R4qFYjC/tK3SWXFpI0sIu1Eh0vV+qYy0QhzJIE6/10yFvcVHahKRe0j4IjeORwlcSMr7fRB/hSBxYaTL8Ec+9ybeeuJOzEc6oe3qE5NBhnDL118ktqcs+FPKscGivJvLxDxuZrrbgkHW2jRUMW9ZW2NieuZlQhtD+7ziunIk2/ANKE+TE6gmEODqxOdWfcfRipdm/KCYByI0QIa1/K8sWHW/JeLLk7a22y1PygZlRz1xIKEl0w8Bfpvvi8IgXTaZj7f/tYSsPTFD65WDDY4a6CrynOuO9UBISNRw0ejk7IcIxbLcAU8qeW5QiRYw5ruWlGtKn7TfZUO1vqRYGJ6V82mVvIRONMhzqsnJ3CCY91+0kGxgOxh1fmVicuJYrTIoolx2VDCC8KFWlgufsEXS2YFrVETe20L5qTAus3DSVzWFTD+lDoCbszuFWoe0HfmgMhC/nsYIEVztBj6OIHeuWEO1kZtIDtHmwTm+q9xqQPmLBaLi5fUanq5nUGGlAxfb6lT2+X/9Ye2Fk0hKECNdttTBJCpbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(186003)(2906002)(86362001)(54906003)(316002)(33716001)(38100700002)(6486002)(83380400001)(38350700002)(1076003)(8936002)(4326008)(52116002)(66556008)(8676002)(107886003)(66946007)(66476007)(6506007)(9686003)(6512007)(508600001)(26005)(6916009)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NhFAgx2K4yy+iEAI/dJpIyh4sVuzSW/nCKWNtS4a1QbLeNFhYe2OiOsstce/?=
 =?us-ascii?Q?ne4BZRoprZwPbTI4o6rF0gjcdlZM07puRzRwQs5j0oTKyHGTAxKXe6LxFDz9?=
 =?us-ascii?Q?V4OYw0rsSHSonxpvwy0+ST7tWpTLDq6Lci7zWnpKx25rtqmtO8i54KnKRy0n?=
 =?us-ascii?Q?dEGjONBiaByFIe2MGNDwULulw4lYulFpsL90hYr6MJI8P8iHot8cIH6LuNE6?=
 =?us-ascii?Q?Wrnd+2Lvz67+MK/JUhNQrYDjMycvT9F5IaYaa/RBPakUjIP5l7y6zYU5A/nd?=
 =?us-ascii?Q?qqUN7PeiqcOBmJaXLu3I3vpZdVTeIrb9aUDT+0OdZxolYn/wnwJrQJwFqps8?=
 =?us-ascii?Q?fY7CQAB/KtQIgT3YiJXIw1Gdu6q5AKTHaeAkvXzWsiNNpYo8m6+EkK827kUp?=
 =?us-ascii?Q?AvzrjPEer31icfeJPR3g3OhHjkm4moCdfV4zBmQutp7T+KTiINg97SJP7q3S?=
 =?us-ascii?Q?XBwm/XImCRsAuOEHHyyFnZsRsu5ze75B9rRQ2LmqEuB6/gLsKhZfez7etXfE?=
 =?us-ascii?Q?JzxZIN66gnG/3MK5Hme6S47gpbh73wrUPiOOdFR7MWGdp3DNTSeWpeVD2uxU?=
 =?us-ascii?Q?I8hpLBqom7GQ1oU2u19uUd+UpfFXfF4OZBzSbG/GEHC7vGHhH6T1zr9KRCUV?=
 =?us-ascii?Q?JOAwf9tZYEYkgyt4qix5A4Z6bEn6YswypT5znJmaVoZptsRmFtXCDNFFIKvm?=
 =?us-ascii?Q?fv0YypRk8A7b9tTCUf8mk07OpAwm+ck21LFjgGQuJBVMh1AP/7KvLm8TX+1N?=
 =?us-ascii?Q?i2NVrF+oJVMaZi40qiN90lLpz33XaDQHFfVYq5cAaUEm5d1LJVXV9UG7olQX?=
 =?us-ascii?Q?J2ouR8U2qhdfdolp2+/6oiGLWeWHKxYllIt839/tFE/WoRJHbgPN1lKt1me3?=
 =?us-ascii?Q?BUC+DMdUvhtQcgBw3V+HzfQ4CrmjbeLYQuioTWPc1KkiKlt9LT7Smo3/00/x?=
 =?us-ascii?Q?QJsCm4fivvebQTWRn86j0kVqlLFtEp8jNbD/qwmxvAXf1mNoGzloH/y8/IRd?=
 =?us-ascii?Q?S6dfboK19BOSPp+4B5l95kfwJk8/UjS/33kj2vH2KW/gO1PsEQ8G3Z6XSr4K?=
 =?us-ascii?Q?NVmCeHAhzm31nXsNq3PSspbNzLhm8OQohpNjDLG1+cc3PiyBqTSI0ZKtMXX3?=
 =?us-ascii?Q?s26oXUhtOd+RBaVpy3617ZyPZbQjf8Ea95KsxDb914Fwq9RHElvJodX9u/Z+?=
 =?us-ascii?Q?JFnnCDjGsRKOsXXd5MaQFzG9OC8DXDaoC73Xqb06xDH+Fk+oCwPd+sMkG4rR?=
 =?us-ascii?Q?rPGFXeROvu05IHv56/IFHGaP6yPTqGZhPe0g04kpeL/NI+44Thrux1H4uPo6?=
 =?us-ascii?Q?vzUnzkfLLVW2KMTz8CPu4KI5z8cla0BuZe3fa4BnlSPbbgrI+8LIwPULo4Rp?=
 =?us-ascii?Q?/y3hXUoeJi5HEEiMSZAWhb21XG8Oe7/Y8suH03QWm37C4iTBkWSHfo3NDn7V?=
 =?us-ascii?Q?l5qt9Y5FHiNZzjYGFArFMQEmX7eEsPeg/9uyk3Mq8CZYJpobVscMY0T3b1c3?=
 =?us-ascii?Q?0wenDn3XYQkg7tI6Btoa+xqgSLMf9gtr023j8Fi6AjYH9+DOejRiodI4dKlL?=
 =?us-ascii?Q?8csFNUNJ23joYWq6SXvP273qou98ioCOXACSzwvHLBrgU5fGjUVfxS4TWrOx?=
 =?us-ascii?Q?lBJRQZBKAnGaRlbtGPJ98EE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e726ded-321b-4941-e09d-08d9dad28d7c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 22:33:30.3425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wFBtklQhoklIibZHlnxJD6a5ATLDt5kutVNCJ+UDkRelCxskR7xxox06TzewKEHJLpv+UUgJguaF+eJ92IZrNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5223
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18 Jan 10:02, Jakub Kicinski wrote:
>On Fri, 14 Jan 2022 22:15:48 -0800 Saeed Mahameed wrote:
>> On 14 Jan 18:34, Jakub Kicinski wrote:
>> >> HV is composing the device before giving it to the VM.
>> >> VM can always disable certain feature if it doesn't want to use by ethtool or other means.
>> >> But here we are discussing about offering/not offering the feature to the VF from HV.
>> >> HV can choose to not offer certain features based on some instruction received from orchestration.
>> >
>> >I'm still missing why go thru orchestration and HV rather than making
>> >the driver load more clever to avoid wasting time on initializing
>> >unnecessary caps.
>>
>> unfortunately for "smartnics" of this era, many of these initilizations
>> and resources are only manged by FW and the details are hidden away from
>> drivers, we need the knobs to tell the FW, hey we don't need all of these
>> features for this particular vf, save the resources for something else.
>> After all VF users need only a small portion of all the features we offer
>> to them, but again unfortunately the FW pre-allocates precious HW
>> resources to allow such features per VFs.
>>
>> I know in this case smartnic === dumb FW, and sometimes there is no way
>> around it, this is the hw arch we have currently, not everything is a
>> nice generic flexible resources, not when it has to be wrapped with FW
>> "__awesome__" logic ;), and for proper virtualization we need this FW.
>>
>> But i totally agree with your point, when we can limit with resources, we
>> should limit with resources, otherwise we need a knob to communicate to FW
>> what is the user intention for this VF.
>>
>> >> Privilege.
>> >> VFs have SMFS today, but by default it is disabled. The proposed knob will enable it.
>> >
>> >Could you rephrase? What does it mean that VFs have SMFS but it's
>> >disabled? Again - privilege means security, I'd think that it can't have
>> >security implications if you're freely admitting that it's exposed.
>>
>> I think the term privilege is misused here, due to the global knob proposed
>> initially. Anyway the issue is exactly as I explained above, SW steering requires
>> FW pre-allocated resources and initializations, for VFs it is disabled
>> since there was no demand for it and FW wanted to save on resources.
>>
>> Now as SW steering is catching up with FW steering in terms of
>> functionality, people want it also on VFs to help with rule insertion rate
>> for use cases other than switchdev and TC, e.g TLS, connection tracking,
>> etc ..
>
>Sorry long weekend here, thanks for the explanation!
>
>Where do we stand? Are you okay with an explicit API for enabling /
>disabling VF features? If SMFS really is about conntrack and TLS maybe

I am as skeptical as you are. But what other options do we have ? It's a
fact that "Smart" VFs have different use-cases and customization is
necessary to allow full scalability and better system resource
utilization.

As you already said, PTP for instance makes total sense as a VF feature
knob, for the same reason I would say any standard stateful
feature/offloads (e.g Crypto) also deserve own knobs.

If we agree on the need for a VF customization API, I would use one API
for all features. Having explicit enable/disable API for some then implicit
resources re-size API for other features is a bit confusing.

e.g.

# Enable ptp on specific vf
devlink port function <port idx> set feature PTP ON/OFF

# disable TLS on specific vf
devlink resource set <DEV> TLS size 0

And I am pretty sure resource API is not yet available for port functions (e.g
before VF instantiation, which is one of the main points of this RFC, so some
plumbing is necessary to expose resource API for port functions.

TBH, I actually like your resources idea, i would
like to explore that more with Parav, see what we can do about it .. 

>it can be implied by the delegation of appropriate bits meaningful to
>netdev world?

I don't get this point, netdev bits are known only after the VF has been fully
initialized.

And sometimes users want TLS without the optimization of SMFS, so as a vendor
driver maintainer i would prefer having control knobs per feature, instead of
maintaining some weird driver feature discovery and brokerage logic..







