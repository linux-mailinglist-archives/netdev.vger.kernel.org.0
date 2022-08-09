Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D050D58D437
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 09:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237177AbiHIHHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 03:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234860AbiHIHHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 03:07:22 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0723220BC4
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 00:07:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NpGFDQZQbeuu/va+yq2mSDCRwfcbrLuYJoOiDZV5ygDDe+9/3X0swNanjHQF9i7Buj46m+7LMQiOo08yW4ExDeYPLqw9NYT9bsWzqcivGid0x5ghkMdSzumGfud0TXP7Fl1hdHZhO0dpAEVbWEILa6p5yvnAMHvw2YOW6MreaZ479YOolwbXAmWiM5hAlG2k51Pf0WyIeX+oYFSP17vz40XZwCiXIgunhpH3jqGlFxiHbVLRjFgdfNrI8oDRJKDcImq1xgxRBnsEHJKCxffy5I6w4BsB5oslJDGtgZicdQ8Bh7aBKykKUm26DQ1o0uX+/B36q0VPLGvzeCLMWoJN4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8YYxl28kgoFPXbk6zPJ+KkKznkmQ/0CSjrHMahcL96I=;
 b=Izy6aR7JwR95/vaK32NmdBbrjia999RtQuhCoCMubT+6BQAEy5PBmB45dIAH6Tst5AoFiuaSdBs3BKCqjckXGvc7iwOB7mrwgOaywPj/v0Akcg+16O7RnCO8+FfOpND/Quf0dnkq1S7XSmMA8MXvXlxJ6fk+pe7iEf/Q8Jf041nqp7wU4RFh8O2Bt1hJ9glHk5HrkD/EDlGO9LJ3ffvaq1dJ0Wye3enKBQ7jmE9fLo7PpaOQi+mkcNwqK1plv87WNXcZnVzOEAnu912Itjbo/wRonYgfklCm8UWs+sXThX7QvSWT3dZpmgJ0BJ66gfx03VoSzI2krn0ivRNSxCkUHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8YYxl28kgoFPXbk6zPJ+KkKznkmQ/0CSjrHMahcL96I=;
 b=j1/RNEXxyV8qsBDxJ62hJeijhvLWuurFUkjovQv0Y7JFsqMubmBkiDdeEXiW5lru1E9MunUlmhjhcPCPfpTSR78nEl4Dju8jUzTwVRqLSwt0Xe810aaLD+D9Jrz/J3m/bZYNJwNGuwRFGq5uJt6E9eK6EZljWPBnmrbhZyLpmnbDw/AdWt+rOpu2rj5ceSSs+V5GfIjsE447g3WCa8IlSTy1+691ysl4BRi6M20rJC23m82L9i7kr6l9DXqfAvpsVhgx2KME5GWolgdjKFYABkJpDrEW11gv5amFaNmIECTQMqHnbFxZVSJ2Sp3V29fkiFIlcVOI7lsEhnABHlaEHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by BL0PR12MB4689.namprd12.prod.outlook.com (2603:10b6:208:8f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Tue, 9 Aug
 2022 07:07:18 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::1135:eee6:b8b0:ff09]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::1135:eee6:b8b0:ff09%6]) with mapi id 15.20.5504.019; Tue, 9 Aug 2022
 07:07:18 +0000
Date:   Tue, 9 Aug 2022 09:07:09 +0200
From:   Jiri Pirko <jiri@nvidia.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [RFC iproute2 0/6] devlink: add policy check for all attributes
Message-ID: <YvIHnSoZpO8pufH/@nanopsycho>
References: <20220805234155.2878160-1-jacob.e.keller@intel.com>
 <YvDmNO6/QtXfJW8h@nanopsycho>
 <PH0PR11MB5095F7729B6A1EF25D6E052CD6639@PH0PR11MB5095.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB5095F7729B6A1EF25D6E052CD6639@PH0PR11MB5095.namprd11.prod.outlook.com>
X-ClientProxiedBy: AS9PR06CA0191.eurprd06.prod.outlook.com
 (2603:10a6:20b:45d::9) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af34c798-dfeb-4b0a-48ae-08da79d5cbe8
X-MS-TrafficTypeDiagnostic: BL0PR12MB4689:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lGfJYH7ybGTV7wnFXWDVcftXfHzX9sq9PtaoZMtqBAcBFyj4DiJGyrbiz/lA62nOOlhaRLm9L+LW9A9FbD+/VYGII+Jl8Q/t07sg2N59bVrLSZFzHKo49Nv5msuFS5xpJuoVWgtIan+HXO65oAg75qDg4BCV+NF0a2M3Umg4jdCC+4UK7Os5XnDFcj+t/kQ7g/iLrer4Md7+PdOJP70Rr9rHzOxWAZTFlPzhxiPcv+1PMqeu7vyHC1cEOIYub6p8GCrrGJceZQrzhwhcU4fJEdC5XJV2Y8QQYrv+yKEJSTpCxKvXFsasYzBlA2dOhYHL9Nc6jOvh0howvT1NEZuRVt/9bzCmDWla3js4mfU8/elLtloJ2tdSQIkGI2Qv+75Lz/WPOecvjvDqP64admt/frIEnO0A2RQ5Xg+MP1wMvir6Tox+jaeWj1F/b/8TWI9kJHKKYhI2DFhRq3F+6tQeLazaOGuKyVWHgsvRABRB6VV4T9ZpolI28c4qisDzBXTX1fWvgEWzmc0+2NdUGsQ8S7kBaHMrlFN5pZRDOwPLZ/moK9xnn8ktwBuYWYF4h/97IZtvabxnFX8av6Rt3Ss/XT4gRVCmylCZKu/arN3Lz+HQ8m9wHDZBybqkgcy4xX7LT38v1DP3uEHGWMcRB0HV3ryxT6wC0diOT6956U4em2gOt58PgCcFBI+KhhnqJGN8cEAPichFiXYGUMRrOhnmuv3hqlpwpiiICZgQZpjZiPQm0P0gZi8hLAnycdusdLu6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(376002)(396003)(346002)(39860400002)(366004)(6862004)(8936002)(8676002)(4326008)(66556008)(478600001)(6486002)(66476007)(26005)(66946007)(9686003)(6512007)(41300700001)(6666004)(53546011)(2906002)(6506007)(86362001)(5660300002)(38100700002)(33716001)(186003)(83380400001)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?69FHC2p6ZpbWlFyrUYwpTcjSHxSY40riVRUR34Xp1JyEv73hfb4C8evwnd0v?=
 =?us-ascii?Q?0KvRqb75CQCrqx3WPymr8a9T4AsWWOHJdhX4CZgRWR4BRvkJIJm4O5Xsqkux?=
 =?us-ascii?Q?Ui8j9CZIJhNBudzcOjg1lPFkp4OArP3k+99stl+oPmRwqIRIviNek21c3tN9?=
 =?us-ascii?Q?wtu3mroHphG3bLSWAWGt2CXnYvGk/s2HqJPC00N0xdmxUioO2WBt9mF2FaGn?=
 =?us-ascii?Q?zN8eOCJNEjwhWNQZZyTTdTxxEFljyRQEHOCbgnaucYs6LflXrNOBTG5Kvn/i?=
 =?us-ascii?Q?VR9KAGm/4T+XqZV4fD7nJn/SeBYgn40PaD/SUQTc74skUgJexf37f7yAds6K?=
 =?us-ascii?Q?JXBir9pdlltzrWZKATXbE0z7q9n4ZnZPZFIU+yNM3DfLklATHOLU1DplcUZD?=
 =?us-ascii?Q?UHGswkficnNABu/wBjGpVfsqfMHbZsvHcLQYr4Vf+M1OplvyBzlvhD02cB/A?=
 =?us-ascii?Q?sfKrH4/GZPQZ9WdssPV1+k9qry1bqoD1hvYbRQptrDbFDWWg6XyG/LQK4vOa?=
 =?us-ascii?Q?m00iuycT4Ib9llgQpHRSvxqTLAlwAlHUX6Of43YRHDo8WnK6sCI34EfurY4z?=
 =?us-ascii?Q?C8A9/jxUrgt4cbx2KBpQAJ5gUzakXgpvRcAJqntJjLEdJThKNg0v6GA/myr+?=
 =?us-ascii?Q?aCWI4kOgmzeH7AewFUkCA0dV6r4iPYBbFUuVtjuzVqPgL4MOML4AXWRXNj+R?=
 =?us-ascii?Q?riZLMGmM/n6tCUkGujguvU5lME5Ljhhqw4UI4bQnc/9LYXpMJrAST/F5dpw1?=
 =?us-ascii?Q?u78O84EndlTnO+q+LLurD1Ct7yMJ5RF/UtPE+o52CPmaq0A/s0ienOFR+y98?=
 =?us-ascii?Q?dJC6PUpTLX1xiKLQNrSVwUlRnBk5XZLv1WfL4CLVpkuxZ6dMEPGLmeO9l6BA?=
 =?us-ascii?Q?TqhLeZkkddR+SEiLq8HBC9Ra1JrvX1p2mkv5zDfsjvgIsCTnhX8rAvQ8VBpt?=
 =?us-ascii?Q?HIyjFQ248ISk+VTSCwy1p5lsgfn9tPn0a4Q4//Wj7EuEu6YFsSru33/n6Ybm?=
 =?us-ascii?Q?sXLVbtzMEs2ZHQOqoXHJifcHz/YlnmGWLQ8C9Ibfc27/1qIM8dfnR6KcjM/3?=
 =?us-ascii?Q?mJBc88btWQn3+h9l9mJn5d1N/tHlJff9YLgEL9NpFbo58294lWc7bK377Vmz?=
 =?us-ascii?Q?G7mQcJqyDGUqvCAZRV5uvrm3Tuea66ienGqq/Yx6tmnwH9XiGfv3M0sxW4c9?=
 =?us-ascii?Q?HmXttQlfUhyISfKFeWkX/x7+nMAfn2jhy65G4qfFASJdqKI+/x6VNdrsQ9zU?=
 =?us-ascii?Q?An6mkzAG3em5/+gsaw5xWFVe5i0fDVCGJuHH3euzFx2Nm8ydMA4XLRocXjXc?=
 =?us-ascii?Q?git/TLL4MT/pmYfAClyiU1yMWBFNhXdYaZdYsavV9adJNuzex1GWh+3XbDCk?=
 =?us-ascii?Q?T5rUH6mEffZ7WoqtwpFzElMjEkQCQJbNIoGsQye45tJv3KYpw3edLRw7GErm?=
 =?us-ascii?Q?tB1F5jeqWir/DuJbbD32t2pOOJAXifqMEPfr2yRR+eQHwqdlMUGGxEvZ/rmi?=
 =?us-ascii?Q?VAG3eFwXel1JoZZ0YP2taTB98eA97EkrUdYDI5VJaCldK8mkTqf81FiertsG?=
 =?us-ascii?Q?wGk18vsPD8cqvqpxdCwmtzBU8NxndkMEVZ+M6AAh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af34c798-dfeb-4b0a-48ae-08da79d5cbe8
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 07:07:18.3901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sgRRD/DKb+COzXHpsytn1V+jgIAimIRgYd0qh628wIkeHgvHrdecnR3lX+UvXGOa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4689
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Aug 08, 2022 at 07:02:49PM CEST, jacob.e.keller@intel.com wrote:
>
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@nvidia.com>
>> Sent: Monday, August 08, 2022 3:32 AM
>> To: Keller, Jacob E <jacob.e.keller@intel.com>
>> Cc: netdev@vger.kernel.org; Jonathan Corbet <corbet@lwn.net>; David S. Miller
>> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub Kicinski
>> <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; David Ahern
>> <dsahern@kernel.org>; Stephen Hemminger <stephen@networkplumber.org>
>> Subject: Re: [RFC iproute2 0/6] devlink: add policy check for all attributes
>> 
>> Sat, Aug 06, 2022 at 01:41:49AM CEST, jacob.e.keller@intel.com wrote:
>> 
>> 
>> [...]
>> 
>> >This is intended to eventually go along with improvements to the policy
>> >reporting in devlink kernel code to report separate policy for each command.
>> 
>> Can you explain this a bit please?
>
>Currently devlink only reports a global policy which is the same for every command. This means that commands like DEVLINK_CMD_FLASH report the same attributes as valid as other commands like DEVLINK_CMD_INFO_GET. The policy (if the command is strict) would only require that attributes be one of the known attributes according to the general devlink policy.
>
>However, none of the commands accept or honor all the attributes. The netlink policy support allows each command to report an individual policy that would only include the attributes which the command uses and would honor the meaning of.
>
>Without per-command policy, there is no way for user space to tell when the kernel changed support for some attribute (such as the DEVLINK_ATTR_DRY_RUN I recently proposed). Yes, you can use maxattr to determine of the kernel knows about the attribute, but that doesn't guarantee that every command supports it.
>
>The per-command policy would report only the subset of attributes supported by the command. In strict validation, this would also make the kernel reject commands which tried to send other attributes. Ideally we would also have nested attribute policy, so each nested attribute would express the policy for the subset of attributes which are valid within that nest as well.
>
>By adding policy checking support to user space, we can make sure that at least iproute2 userspace won't accidentally send an unsupported attribute to a command, but that only works once the policy for the command in the kernel is updated to list the specific policy. Right now, this will effectively get the generic policy and indicate that all known attributes in the policy table are accepted.
>
>Note that this means strict validation on its own is not enough.  It doesn't really matter if a command is set to strict validation when the validation still allows every attribute in the general policy, regardless of whether the command currently does anything with the attribute. Any of the unsupported ones get silently ignored, with no warning to the user.
>
>Related to this, also think we should determine a plan for how to migrate devlink to strict validation, once the per-command policy is defined and implemented. However, I am not sure what the backwards-compatibility issues exist for switching.
>
>Hope this explains things,

It is, thanks.

Do you have patches for the per-cmd policy?


>Jake
