Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93FCF6E1A95
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 05:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjDNDD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 23:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjDNDD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 23:03:26 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B926A213E;
        Thu, 13 Apr 2023 20:03:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QKXQBmqKYZaZ1RseKfrbHsSMC6N/tjDiPYvreAaiwFTjeSx8NFJJ4N1Ko8SB52i4DrjQBF6G69iuKKOVo87ydyGzFFcpYuXW6utm9/hCdG59+Z9v2dTYKAXvWGJQ5eTrvgSzSMbuHB7iIKV4p0nm0Z4WoaRGkvB9/Isz/WIAIj/d22xBQoMEK4AuE9plVJOJDcFIhM3qDNQ2c6R3YCqPKvCkYd+1ilMs5IOP33uXbBwMXOWxSA+BE2ez6zWcKxKwvQNn6ZAMHVqD8gpXDIvqKm0zlxXvva5SD+0LoCeoervr419oS+MRn/0XlpM9R+w9s+qP6HQHOx78Y9MWizUfzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CuRrrpFUyoo/7M3JbM5dh+a2KOFxDwgzMFlTHVxdTts=;
 b=fefA2EtXr0FIDTjxkOyI41A5k/QCAmnPFkPKjFy4KQjigOtzUhe2Idq0IP08qT1qDXpsTIJ28UGCUzmd3ek3M6YFrwAWmTldcwDDhmKQG/QvE3J/+YfoB6doO3adGC+RugP5899K/A2MGQ1vnm4W7I6Q1sHGqiL0kYL4xrrZ/SD4NfYPedY5ZJ0LZhI1g/39vkZ/xlwZCl2Az+azuKebDICe6/pSD4Qwobeliaz0+s4yOe1XfMFAXWEpXNR1XvNE4R8LozCxsZ50PT+bNXO1Twvguoz9AJt7/J9EK6vYXzH95Rk9Blkq2WfxUGO2p3yo5FdE04Hey8n07m7FWLpWSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CuRrrpFUyoo/7M3JbM5dh+a2KOFxDwgzMFlTHVxdTts=;
 b=OCJVbGxLEj8dDeSj5WCuZAodSkqZvm2qmSmfxX3DvINHZcMI9BY338B+xRyGL7JhEPFiyhkjkhl7buJqLwrhBMC61rPnxyFWUDrImT5pJ2Xt29Ots7HymV9TBRiDOcMR0zG4i1FU/sRqrXVnU21D8+ypgnaxmiIaQyD/IYDdFqiHDco0LByf98KEFIE/OrT1mtDyTATv9ivGxPY0/icRTqzmvxrnQDK3bk3JZco4La29/9nPWjuTyYqNef1qpcX9E+P/fIVSlVMCKUDl8EeIPWJKJvwINcHNZxAQDC4PujDUKJXLUcKkl8mw+UDAepf7Iu0F6a3kd19/xqQOljxgqg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1340.namprd12.prod.outlook.com (2603:10b6:3:76::15) by
 BL0PR12MB5505.namprd12.prod.outlook.com (2603:10b6:208:1ce::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.30; Fri, 14 Apr 2023 03:03:22 +0000
Received: from DM5PR12MB1340.namprd12.prod.outlook.com
 ([fe80::7634:337:4a71:2b78]) by DM5PR12MB1340.namprd12.prod.outlook.com
 ([fe80::7634:337:4a71:2b78%8]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 03:03:22 +0000
Date:   Thu, 13 Apr 2023 20:03:18 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Paul Moore <paul@paul-moore.com>,
        Leon Romanovsky <leon@kernel.org>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Saeed Mahameed <saeed@kernel.org>,
        Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
        selinux@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: Potential regression/bug in net/mlx5 driver
Message-ID: <ZDjCdpWcchQGNBs1@x130>
References: <CAHC9VhTvQLa=+Ykwmr_Uhgjrc6dfi24ou=NBsACkhwZN7X4EtQ@mail.gmail.com>
 <1c8a70fc-18cb-3da7-5240-b513bf1affb9@leemhuis.info>
 <CAHC9VhT+=DtJ1K1CJDY4=L_RRJSGqRDvnaOdA6j9n+bF7y+36A@mail.gmail.com>
 <20230410054605.GL182481@unreal>
 <20230413075421.044d7046@kernel.org>
 <CAHC9VhRKBLHfGHvFAsmcBQQEmbOxZ=M9TE4-pV70E+Y6G=uXWA@mail.gmail.com>
 <ZDhwUYpMFvCRf1EC@x130>
 <20230413152150.4b54d6f4@kernel.org>
 <ZDiDbQL5ksMwaMeB@x130>
 <20230413155139.22d3b2f4@kernel.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230413155139.22d3b2f4@kernel.org>
X-ClientProxiedBy: BYAPR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::31) To DM5PR12MB1340.namprd12.prod.outlook.com
 (2603:10b6:3:76::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR12MB1340:EE_|BL0PR12MB5505:EE_
X-MS-Office365-Filtering-Correlation-Id: ad3c3bb0-0645-48af-bfa8-08db3c94cdd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YdQ8OdxLrCckAqMliV02N3U/Q//IQLfaGAzXywZquslT0ePQusMNop5r6LS6jWLwTWoxLXw3X6ylNbtOhutRYJSKlTwNis6bwMhgyQOzbnHFGgaAoVVMA7FvhQGeNOBBb7RRQILt/A3E/RU6xaB/ZcxVyuIDk+DGR0avjNy845qg/srLtFa5R3BiHHuVLZvTxSuSCt/VLoY96wwrAVIc36zEWsXX6DW1zPwtBFPuprN6bTa+aDfKDq6IdDIIabeF/JFgBXO709uUfsKZ2GSCvqALAeR7/gBXxtF3DWAxEXqPUsCPdiWxQ75vS8sw9NifX5m/iprjWjefeMKSFMNBIzQbVv/GK01t29X8gghGJIkZPdi54H0xqatt7XNYeHNo1q8r6Mgl9ZagdIJymj5/4Yd+5Pwf/HVfH63jYD1jeXjlCvwtH4oPi53dDv1BiFvB3kLETGy+brckjb/xwKVEgT0rGrBNsSbvGcSptJlkHZ3tmjc52iyYR/OY2ymsvVo1sX58t6X3KfGAnNRQDNwMDLYvNitfPHK0Zz1lUw8EJMEqSr89/xGMNdx2IDxDX57V
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1340.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(376002)(39860400002)(396003)(346002)(136003)(366004)(451199021)(107886003)(83380400001)(86362001)(26005)(6486002)(6506007)(6512007)(9686003)(6666004)(316002)(54906003)(478600001)(186003)(6916009)(4326008)(66556008)(66946007)(66476007)(38100700002)(33716001)(8936002)(5660300002)(2906002)(8676002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y6eOTUMOnlFDa1BPASyBXZG8KZvQHSCjGTQf3+TGtAsNJJ+o9HPwzNd2i6qz?=
 =?us-ascii?Q?lrapHFVa2moYepudQ//Bax6uGt0c0CVov2oYz1g6zPyguQ/s11vp02A4YpnM?=
 =?us-ascii?Q?2vk9ojI0ktskfw4zydm2Yt5/jT4Eilw/FBUxaJVaQLtXwm6SmV9Y2OHOc3HN?=
 =?us-ascii?Q?yVw2yfrnofvuxHs45gahkW9BeoPfeEWwzKzHOOxhE7gsX4vA8TBnRy9HOgx1?=
 =?us-ascii?Q?ADnvxjphbV2CPRiwoIbVtCb39+1oILQRs6E5p9HXg2yTuKDsTAGAfAfP202a?=
 =?us-ascii?Q?HeYoXgcNgyfQG+B480QsuGkavh9JkBBhQFFuAJ52OQd37NEUbE2b7+XpGQjq?=
 =?us-ascii?Q?HrIyGu6issILOnRIe47kltkVee3DbtPTMuSKJgi5gBSn0zsPvDmu7asIr/+9?=
 =?us-ascii?Q?IovdlT1wyxM5uUepp7H9KBkhdG0lDa7uzjIHZijdWe8VeylFvRrP4FZBjkkl?=
 =?us-ascii?Q?Pb1Xp9vQSqZo85JAwS8bDk7E/QOwAcuuNUN0jXYE9uwKYm4ViASgEGbao52o?=
 =?us-ascii?Q?I0Onc6GqXE1K+H8VY5Ny1H1lIWwJAFZzpKyA+OvWGPN4vJXSCEDxo3uQqbhI?=
 =?us-ascii?Q?itJJ7pk0ISbxTCgQYKEUQXXjoA1YC6ZKpX9CuNQ9Ws99Y1m0IjV83Ovcitfw?=
 =?us-ascii?Q?/7NDi/4kKais0ylmdVfS7Aow8epDRaVjps/lHE61+HH4md1JUdSqpCaPpex/?=
 =?us-ascii?Q?8Kpmu2IV5gIn2UFrikB4w79AG2cZoZhG8ou+fWZy6udu9TbbZoSsL3zU+c6l?=
 =?us-ascii?Q?Km2ouZK2yUhcDsZm57qnZjc4nVjhzCzEfO84U+ugaFpfCzfqBA8M1hX3aWVU?=
 =?us-ascii?Q?CY9iSvJ70v5ACMXAZttfkhCztlhSmvnWcc/SCyK7UkEScRLDPdPWrpiysFIK?=
 =?us-ascii?Q?t5ECTZSaUtGuwz1VWLHQEwzitFXRWDETXSFlE69fLm3EsLbpFszH38JEzmf8?=
 =?us-ascii?Q?Cu+dlA7/oQeazL0P9Z5ED4Ymm/ArE3NFzKrdwuFx7NgrSut5jwyTqr2u1/j5?=
 =?us-ascii?Q?P4KDrs7E8o9CYyd7/u3626kkAk9jw5WdE21+4L6rIfYhBeqS9OQOPIqa/mIU?=
 =?us-ascii?Q?YBO3StZm9UX1xkv/IMZMBvrJlwivL0NVtPKlK/ODVF8HZTzKRqKw0bsMoTbK?=
 =?us-ascii?Q?J1g3hu1M4qdFnbWn2OZUcxNcDMBhwKlXMrNEtHL0US6XwvTZg2b2Rnwh2K7I?=
 =?us-ascii?Q?bJl8NAqXohJUTGWmA9fdKW4yV6lQzW1U/6Tdo4sjLNVbdmrH3EVj3x0XSXQp?=
 =?us-ascii?Q?x6+chi2HGr6sr7szb1fhEt+15QcMGKCMVKt0RM8I9yXX6MlbwDHBLAejUSKx?=
 =?us-ascii?Q?Ja+l4dMTJtOgVgSrR4v3vy5RINudEx9aJCkTKO3NNrE2JNmuj9DW542WFb2B?=
 =?us-ascii?Q?9/ECx28fRzLUjI0q2/yuFwPOJ2W8sKkkdZtlsTZjKoDVtIIwrqC7YADf2syJ?=
 =?us-ascii?Q?6prg8AxZjZmxXb+0/HQEfvk0FOqCwTQGOLg8nxHenaUPJ6vqZ/S9Pmsupabm?=
 =?us-ascii?Q?h+VSUHPQsTVqgirsFX8TVeqxWqTviBMIVPpEmCSHW1PDtj284it16gs+MoaC?=
 =?us-ascii?Q?vq2eSsYzxk9m8TyCAGFE0FVVJx3TUR4/NxA1YovG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad3c3bb0-0645-48af-bfa8-08db3c94cdd6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1340.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 03:03:21.7328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Ath9vrLGu1qyo47X7kjKa/gNMfqRLZuN1aMTeOuZYWTE6pg4E8h3RffwSxPCnGDC37Z5o1J8cRqgGPPPDGimg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5505
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13 Apr 15:51, Jakub Kicinski wrote:
>On Thu, 13 Apr 2023 15:34:21 -0700 Saeed Mahameed wrote:
>> >On a closer read I don't like what this patch is doing at all.
>> >I'm not sure we have precedent for "management connection" functions.
>> >This requires a larger discussion. And after looking up the patch set
>>
>> But this management connection function has the same architecture as other
>> "Normal" mlx5 functions, from the driver pov. The same way mlx5
>> doesn't care if the underlaying function is CX4/5/6 we don't care if it was
>> a "management function".
>
>Yes, and that's why every single IPU implementation thinks that it's
>a great idea. Because it's easy to implement. But what is it for
>architecturally? Running what is effectively FW commands over TCP?

Where did you get this idea from? maybe we got the name wrong, 
"management PF" is simply a minimalistic netdev PF to have eth connection
with the on board BMC .. 

I agree that the name "management PF" sounds scary, but it is not a control
function as you think, not at all. As the original commit message states:
"loopback PF designed for communication with BMC".

>
>> We are currently working on enabling a subset of netdev functionality using
>> the same mlx5 constructs and current mlx5e code to load up a mlx5e netdev
>> on it..
>>
>> >it went in, it seems to have been one of the hastily merged ones.
>> >I'm sending a revert.
>>
>> But let's discuss what's wrong with it, and what are your thoughts ?
>> the fact that it breaks a 6 years OLD FW, doesn't make it so horrible.
>
>Right, the breakage is a separate topic.
>
>You say 6 years old but the part is EOL, right? The part is old and
>stable, AFAIU the breakage stems from development work for parts which
>are 3 or so generations newer.
>

Officially we test only 3 GA FWs back. The fact that mlx5 is a generic CX
driver makes it really hard to test all the possible combinations, so we
need to be strict with how back we want to officially support and test old
generations.

>The question is who's supposed to be paying the price of mlx5 being
>used for old and new parts? What is fair to expect from the user
>when the FW Paul has presumably works just fine for him?
>
Upgrade FW when possible, it is always easier than upgrading the kernel.
Anyways this was a very rare FW/Arch bug, We should've exposed an
explicit cap for this new type of PF when we had the chance, now it's too
late since a proper fix will require FW and Driver upgrades and breaking
the current solution we have over other OSes as well.

Yes I can craft an if condition to explicitly check for chip id and FW
version for this corner case, which has no precedence in mlx5, but I prefer
to ask to upgrade FW first, and if that's an acceptable solution, I would
like to keep the mlx5 clean and device agnostic as much as possible.

>> The patchset is a bug fix where previous mlx5 load on such function failed
>> with some nasty kernel log messages, so the patchset only provides a fix to
>> make mlx5 load on such function go smooth and avoid loading any interface
>> on that function until we provide the patches for that which is a WIP right
>> now.
>
>Ah, that's probably why I wasn't screaming at it when it was
>posted. I must have understood it then. The commit title is quite
>confusing by iteself - "_Enable_ management PF initialization".
>

Yes the naming is misleading, this not what the name suggests, just a minimal
PF ethernet channel to the BMC, no body is planning to run "raw FW commands
over TCP", you don't need "special PF" to do this :) .. 
In fact any vendor could already be doing this on any normal
PF, so I think you are basing your argument on an irrelevant claim.

>Why is it hard to exclude anything older than CX6 from this condition?
>That part I'm still not understanding.. can you add more color?

CX arch and mlx5 are forward compatible, we try to keep mlx5 device
agnostic and use the CX well-defined feature discovery protocols to boot
the correct set of features.


