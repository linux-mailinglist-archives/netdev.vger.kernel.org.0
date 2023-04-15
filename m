Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD72F6E2F08
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 06:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjDOEkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 00:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDOEko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 00:40:44 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2066.outbound.protection.outlook.com [40.107.102.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58564EFB;
        Fri, 14 Apr 2023 21:40:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QO6WKNl2LTW8UjywyOwuxbi4hrDQ1aKM+GRzWy43zZGyM257unoYgiGB7UnM0sBlNBDP9yxnH3wnLp2VOjVeZkIEEOLNtFohDyHc8GhHJCPMNisTLzu1zXrA9NcI3vU3vmk7/SpujRYfZ4EIJ/OpA3lc9gNj7qcXouQ+q/IkqhcYsjxamYhGzhlwFllu8CwYFFw2joNxggG17cVTxzQb2CWGUoYPp0sV2E9+P77pGSGzM82FBMccvR19lUeqYSgk8IOLwIFGYYo0PzPrER9hs7046rF3zFA68X9wXcE5WZCAarHMUjzLD3AAZ+OJJxJTTlt7ePj7gpOJG00mgAakJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P4XKMhTVBZlMriZRpjvWgDU1QtoVh7x+MnOfBVz3gg4=;
 b=PRUeLrfvPkahP6UHDWqq98OHfbvJrujwKsF408rHVrHHSf+0qyXx9jI9XX6IubV/g7lZqJtLti2WQ5B/mUGM82b/Du+LA8VyKdHaSKFmeHRUkiICw2pHnm2xcTfKjGdfZbT3w92MQxrgb65Lkb0IfziZTVGMOXpWtU9CWZim3xxIyIf2sbSe+baaqEpc0tiCSt0XAhCTR0bjOA3rIBL6/OntDEFN5pMxWGL7/f1sIFckBi7N9UPD8Zk0LmkVnFuHkne0CC/KLPiLCCYwcjMNiDqLJ5uHmdWP5iiV+jT4fXSgn+PwPrOFPJt6KsO4fvKAKurJuzc2nFqsLoouKraYyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4XKMhTVBZlMriZRpjvWgDU1QtoVh7x+MnOfBVz3gg4=;
 b=GoJqXqim6DqirdBo6R9nb+cxufCZnQ6Q0sA096oP4QDvc9QCKOK7QEsnm6JGMEut9Su8nBn1lGxIc61zieJQ4BXajd02S/yDQrZJWPI/fL/3WX2sg91lq98QJBy5NrMy47oIi17io2el0ysUqdv8nqYnpSG2nHT8IVjryaJmvdRP+KdolrYu5nYJy8ry83zel069bLhC7Ptp7uqC/z8rILdik30s7uDqo00x/EPw/eXZ2wpAvalU3MqMy5le69IierdQTK2mcifoMMRbALvwk+mcYoTcBmiBQ4oebpZkqM0IpDSgNYzfCx4Gv3Bu4bHCjYsKFn9ItiRiaABhyJ6qeg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1340.namprd12.prod.outlook.com (2603:10b6:3:76::15) by
 PH7PR12MB6660.namprd12.prod.outlook.com (2603:10b6:510:212::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Sat, 15 Apr
 2023 04:40:40 +0000
Received: from DM5PR12MB1340.namprd12.prod.outlook.com
 ([fe80::7634:337:4a71:2b78]) by DM5PR12MB1340.namprd12.prod.outlook.com
 ([fe80::7634:337:4a71:2b78%8]) with mapi id 15.20.6298.030; Sat, 15 Apr 2023
 04:40:39 +0000
Date:   Fri, 14 Apr 2023 21:40:35 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Paul Moore <paul@paul-moore.com>,
        Leon Romanovsky <leon@kernel.org>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Saeed Mahameed <saeed@kernel.org>,
        Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
        selinux@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: Potential regression/bug in net/mlx5 driver
Message-ID: <ZDoqw8x7+UHOTCyM@x130>
References: <20230413075421.044d7046@kernel.org>
 <CAHC9VhRKBLHfGHvFAsmcBQQEmbOxZ=M9TE4-pV70E+Y6G=uXWA@mail.gmail.com>
 <ZDhwUYpMFvCRf1EC@x130>
 <20230413152150.4b54d6f4@kernel.org>
 <ZDiDbQL5ksMwaMeB@x130>
 <20230413155139.22d3b2f4@kernel.org>
 <ZDjCdpWcchQGNBs1@x130>
 <20230413202631.7e3bd713@kernel.org>
 <ZDnRkVNYlHk4QVqy@x130>
 <20230414173445.0800b7cf@kernel.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230414173445.0800b7cf@kernel.org>
X-ClientProxiedBy: PH0PR07CA0061.namprd07.prod.outlook.com
 (2603:10b6:510:f::6) To DM5PR12MB1340.namprd12.prod.outlook.com
 (2603:10b6:3:76::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR12MB1340:EE_|PH7PR12MB6660:EE_
X-MS-Office365-Filtering-Correlation-Id: c27beb73-f194-4d43-f318-08db3d6b8fbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XvZTWLpWLfOOVRIvsEhKPSKjZRmgUbAvTXmBUKmQOLMqeCeY1JZ4xZrTg6KAAVhn0Y7skmgwUPwB0Q1G4ilh3Z7IkQQLsliYb/nO/3zP4WcIN6ItkaK89i5LJ5wr58dOqsZGu49HAq/EWEwBSY91oxl7AgXq3rd4Nlh1AaaFf8R58gFo2jVDI6ZAs2BV97HRD28U7JVM5ySlblCCvadqskie2U2SN6fNr4QlCjAHapdgbNnZR6V3IXeopPfnBHtT2qzHM3+9i5/bSYP+5Km/j5l/Dsu+nR+wKnQ+PIncyuagGA0t5l8tyvPjgjFHpUNe/lhp0LZOxamM2oGhwCJVKjPMCpxG57fnd3yLb7TpU+B+yOE1PbB4rxbyQJjdtMPnqfUkUeONqttRvU0e7WoO08c9lWA827BxQqaGczAjtVk55/SVh0afg7d+wVdaT1rb2ZPni1l1LUKFzV1jcK2B/Mwd2tTpNbnVxa/4EmYj8HikUDwENyNpiADfVVmYflqKi18u5619LyFDJAa59tUHamRIOpYYRB71dX49EYofH7ZcBMD9xYW61yBXNsLvb9m9JfYAuhdgFbxR4J+8AOkkp7zqhi6fg7E66O5czi1d8wBkA8QW1JLRRTuAQ87pSO72dE9dUzz9My3V4/C+A5NUeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1340.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(376002)(136003)(366004)(39860400002)(346002)(396003)(451199021)(66899021)(41300700001)(54906003)(66476007)(66946007)(4326008)(6916009)(6486002)(966005)(66556008)(316002)(478600001)(8676002)(86362001)(9686003)(6506007)(83380400001)(6512007)(6666004)(107886003)(26005)(2906002)(5660300002)(33716001)(8936002)(38100700002)(186003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?40pF6bfAVp91QEnI/3qlizjHXLeN1XVx6s7unA6T2TCvE8fCg0tzc/wD6w48?=
 =?us-ascii?Q?esPdQFeR0KQEN6mV/m++9yZ0CdZD6tTLnj46tc1hI8Vu+1iLq2FENZDmiuc/?=
 =?us-ascii?Q?8B4VYSyZvBUCo6LgzOCPzk+5HqAROFkvdK+DENhFwt9+KU9W24OL2jk/+ybE?=
 =?us-ascii?Q?lhAVBH2uQsTdotNQKxS807ldYC82axujdnakFJvycwyvQ5Lntge3D6pHeIzm?=
 =?us-ascii?Q?QbD34hkRZ8ZCEysHUlQE03QsBahmc5A69UXSEsr/TlGoOmRxFX0bQnTwV+jk?=
 =?us-ascii?Q?W5//T/ImRPb9ArQM6HjvTYj1Nz6xa6N4YZke99+uXg/vOCZ58CUkukGRLCil?=
 =?us-ascii?Q?4q4waCU52paBE5I/GfhpAeUPc7OHKkt8sVBgqQnfgJXAzdBjPo2BmpbPvMOC?=
 =?us-ascii?Q?Wb1LQPhiFIGJwYxAegMzBneZ5jqAsN5izM1PO2leE5TT6G1wefYnn/1SbLz2?=
 =?us-ascii?Q?uejJHvcBr0Jx1KLZOqGNTSEzpLBFZskb//eZ5TgGzJyWSgBqtkvz5SJvqzoD?=
 =?us-ascii?Q?ZyqPHJpeksAvbJMf541YHI00pmeCeH6JpD3Nhe8iFy6mmfOnjhSqLXpk2024?=
 =?us-ascii?Q?3ZyD/MF5aAqyhP5muoGT49AyiycfuRmAFA7wHQP9lqPergPFp8TE+qJGA3H5?=
 =?us-ascii?Q?zfOx3X1OCPvIr9QWZ57ySGkHvgqt3dqHW73wxpmsFHyT8LFD92Ewdx13ZsRd?=
 =?us-ascii?Q?83rZaNod7nPxgaXxDBDtoxvPayN+uYHx77+D5gc6gWHNYhlHhn8+vPyVDYgZ?=
 =?us-ascii?Q?MFpkfxevG41ZX1UY8QnuEtqKH+2sClEYjzc8hP3chr6Okb1dMhqYaFEoYLXq?=
 =?us-ascii?Q?e94V9XxlGOqFTz6ztFHJpoW3cSUrDrTDnCVQVUc1FO3JUnTL0XMQe5BQcP4v?=
 =?us-ascii?Q?W9mU3bEm0KmMsAqGPg5WX40aX8MvBrxwomtGQR8+i7lqgA9V6stmBkftzzHi?=
 =?us-ascii?Q?mX5NUuGL9JScv+w0mNw1MsBHs3XqBTOMlL6GHuaVg3rK0PRtx87wL341DFoK?=
 =?us-ascii?Q?EFcHn7kFaFNmW2h9vnUcIjo0Pq4KfNDjjcNosu3a23Pl49j6TLL21ImSjKNp?=
 =?us-ascii?Q?gsClF6arXZTYHsuiWigWHi9nBX2qKP1ShBXc5NiQvn5KX9hODGMy9ABA40Z1?=
 =?us-ascii?Q?3sXjZDhLarRB6nF9UXtcldvEIkXk/qC7ohLuorD33+nacEyVW/ToTNTil+6a?=
 =?us-ascii?Q?CPeyerP7iD25X8NS4IScTlYri15bjUVzCFQ/LUwVYFS8WVh08n0M7Sx7VLQW?=
 =?us-ascii?Q?23YdV8zwaYZpRbBO1OvkmnQeEgMAOpI9lp47k5PeonD7NcZWFPDtFX+yK7b+?=
 =?us-ascii?Q?b+HJkcIqi1Gc2osGK8/HPT8SBs7kz3rpA1Offf589zlLkvH5qflY+cJBpz9U?=
 =?us-ascii?Q?fgZgZHX/RvaolrSddknM60x593ZMxCZvfFPuwHWP041X1eZGNUvy/ISeYWPE?=
 =?us-ascii?Q?RYSUpRe4HLO8WwddW77JZQCDsjE/KR/MwkHbSvHO1RrgqW8P3aD8T2LFqXbr?=
 =?us-ascii?Q?hVybMkNAHcQlb7H9alQEeePvv22KvAn8GkI/EMSlyI1mZSkoLB6b9EagPt3A?=
 =?us-ascii?Q?IAlR+RLnnEzmunFcE3J3kki47A4q6Y+JJIZFTSjC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c27beb73-f194-4d43-f318-08db3d6b8fbe
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1340.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2023 04:40:38.7987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GWoWWTP1M16hgUSO3Yk/JahZP7bM34/I5qDmYjgFVUnMOhaauTCSNahZgnR6aUD3H83Xdz1cbno7XohFIaCMng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6660
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14 Apr 17:34, Jakub Kicinski wrote:
>On Fri, 14 Apr 2023 15:20:01 -0700 Saeed Mahameed wrote:
>> >> Officially we test only 3 GA FWs back. The fact that mlx5 is a generic CX
>> >> driver makes it really hard to test all the possible combinations, so we
>> >> need to be strict with how back we want to officially support and test old
>> >> generations.
>> >
>> >Would you be able to pull the datapoints for what 3 GA FWs means
>> >in case of CX4? Release number and date when it was released?
>>
>> https://network.nvidia.com/files/related-docs/eol/LCR-000821.pdf
>>
>> Since CX4 was EOL last year, it is going to be hard to find this info but
>> let me check my email archive..
>>
>> 12.28.2006   27-Sep-20 - recommended version
>> 12.26.xxxx   12-Dec-2019
>> 12.24.1000   2-Dec-18
>
>That's basically 3 years of support. Seems fairly reasonable.
>
>> >> Upgrade FW when possible, it is always easier than upgrading the kernel.
>> >> Anyways this was a very rare FW/Arch bug, We should've exposed an
>> >> explicit cap for this new type of PF when we had the chance, now it's too
>> >> late since a proper fix will require FW and Driver upgrades and breaking
>> >> the current solution we have over other OSes as well.
>> >>
>> >> Yes I can craft an if condition to explicitly check for chip id and FW
>> >> version for this corner case, which has no precedence in mlx5, but I prefer
>> >> to ask to upgrade FW first, and if that's an acceptable solution, I would
>> >> like to keep the mlx5 clean and device agnostic as much as possible.
>> >
>> >IMO you either need a fully fleshed out FW update story, with advanced
>> >warnings for a few releases, distributing the FW via linux-firmware or
>> >fwupdmgr or such.  Or deal with the corner cases in the driver :(
>>
>> Completely agree, I will start an internal discussion ..
>>
>> >We can get Paul to update, sure, but if he noticed so quickly the
>> >question remains how many people out in the wild will get affected
>> >and not know what the cause is?
>>
>> Right, I will make sure this will be addressed, will let you know how we
>> will handle this, will try to post a patch early next cycle, but i will
>> need to work with Arch and release managers for this, so it will take a
>> couple of weeks to formalize a proper solution.
>
>What do we do now, tho? If the main side effect of a revert is that
>users of a newfangled device with an order of magnitude lower
>deployment continue to see a warning/error in the logs - I'm leaning
>towards applying it :(

I tend to agree with you but let me check with the FW architect what he has
to offer, either we provide a FW version check or another more accurate
FW cap test that could solve the issue for everyone. If I don't come up with
a solution by next Wednesday I will repost your revert in my next net PR
on Wednesday. You can mark it awaiting-upstream for now, if that works for
you.

