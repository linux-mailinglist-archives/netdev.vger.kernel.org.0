Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5410166163B
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 16:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbjAHPm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 10:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjAHPmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 10:42:54 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26445FCE1
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 07:42:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dSfTqUakXRh8vqNIXUkdFPgu/8XXwV4Wa/ZFE0xGUo6wHaEet7MIod7eK9HUw4HuAXc5GHM1P37juaKd7lc3qLr1W5g1+imGFjaju86LudnGQbHJl+TPytw1F2RFlWH3wBq3o3XdXKjL9LXgm3+3x5RHfQLpKnWmzXDIMX2iuFi70Ln3kIuC/zP+/hV+P3Oy8KFm1JZKY4AtQNIhuH0o6fxDcb2SjO77X/P5N6pn7ocxA2jnX2g2Zo04QD/tQdE0PLOM7G3HmMBSguroSHCo+WY2Nv+oUpQ9IVRJ/61rHAQnLUqsrOCBjSaz3aqRR/RMVs335gdxsmJb5ZQ8rWUuNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1jQGruZgiY3S3fpaVXQNCGqU8rfvxD5pKIpNqwpOc5k=;
 b=g/MKciUNkncb6uzaLBYWv6KhZ4YIDzdayX9Hmd+V64WHYIJLHYRVp77mhV3wpZyU4UsND8PJe0MtAnnhMhd9TKdibhphRQwllgotcWVgfpaoqFTyvzu0IRc0CZ5WUlDxn6eJCWXHjYo8QwhdGMTNhW0mfVZpd5QswYcSyRRnFxSsTa5rlMt+jjBtM+LLOsRxvkz4x+Ul7Kaio42mTAaPeJKbbAPbKd4c0TzW87+bne/gDxg9Hh5+qPBFJ263/QwxIPICfmG3sTOHkr07UiLN661dE2tcApav9EhVT1prvlWHYTp64Pgyv5YXKD9b9rDCVQaXJSziFdigro0h4lbHhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1jQGruZgiY3S3fpaVXQNCGqU8rfvxD5pKIpNqwpOc5k=;
 b=Szqg9jwRCvqmEdCi+kAlpR/aVrl/Supbo2y0OikzhfpoIFYZC1irbbCZ4KgoTQNEWJl4VNokK0R2+F2GjJ1wYM8pYZMMyZpJMR+7tw6SQF8eDz2LaYlghpjw8uzHkdcicqJ8fV1MB4TYO7lQ/YPEUtzXpQHSF6pETUTiAW0ZGh+7JhDDj2SSFTVujFEJYVRNetCUF4dp7b+3oW8znMBEsHFTiwdcT0KIcWPeRZ0QLeIfznD91Siu7Uk7LetoCoGUZVvO33XJSejxsbe+7kJlyNhbsMTlrJ0L9gP1oFQy8ht9TrbGEpBzLrqpUeviFi5HKFwa1hyz/AljqjHRwV+fqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS7PR12MB6335.namprd12.prod.outlook.com (2603:10b6:8:94::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Sun, 8 Jan
 2023 15:42:51 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5986.018; Sun, 8 Jan 2023
 15:42:51 +0000
Date:   Sun, 8 Jan 2023 17:42:45 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: Re: [patch net-next v2 2/9] devlink: remove linecards lock
Message-ID: <Y7rkdULcKqIWlkRB@shredder>
References: <20230107101151.532611-1-jiri@resnulli.us>
 <20230107101151.532611-3-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230107101151.532611-3-jiri@resnulli.us>
X-ClientProxiedBy: FR2P281CA0053.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::6) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DS7PR12MB6335:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cad8c1f-2836-45f9-4d6a-08daf18f0074
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MOA76rETVFzBvbl2Ul23O81/WJ22osLADjRi97KQb8P4z0uFYX82OyUytywbLgXj90yBewU+hOwcFL2aOPI7k7n2jwuzFCMAgWClRDtDSKUlrmw299ZWteuvGNHQhvUKQYh2s42V9yYGXMbKw7wPKpbUkLyTt1yv6CaR6+dRhoak8tUmB39t9QTsRpawUl9nFEcnMH1eV4ONH7JaweXMy+5+uznjc1B/0AsOy0Ov/RvWkkaCj3RubBYUz4+BgZLvXbixJOCPLLQcSQe5kZHg+Q/z8nrpK70yj95Jap+h9ChhTxI5tLgz9QSOuYsu6OqkOZnnC/c9ZVykWIiGdjkJf5HoGb6R3igAMQxTjIvygscry+T2Cxu1U4JUtwW4sHokNso7+ktCB3CwqUx57Hz2TzPd27Znsm+wAb25fHGjfRy5U9Thoe1OBhm4l2wKOj480uOiAhbkk+eRGLVgUWyNQrsCRipGbJfGpD0ESeQ6oMfmYm+E0EHHSzBr1pLGh27zElzYq19L9Cs9pYvNVrqJ0WdBB5dIZHB++c0dlTuhHxGCK8y2BqZ7E+NWQjRJmBGp9He/FKDcQhbIA8lYRi7hPwnXM91PNOZgvLkdXRlx+5Br2Ak+dIc9LgMaFFBgp3jEK/WWF/d1pxYiGrASBj24Zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(136003)(366004)(396003)(39860400002)(346002)(376002)(451199015)(478600001)(33716001)(6486002)(316002)(86362001)(38100700002)(83380400001)(6506007)(6512007)(186003)(26005)(9686003)(107886003)(6666004)(5660300002)(7416002)(2906002)(4744005)(8676002)(41300700001)(66556008)(66476007)(6916009)(4326008)(8936002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+beCScWqmJt/po/v+gmrz9ahIJfVLkU7MGI0jME9NwxqPvfUlsZpyy3vjDPb?=
 =?us-ascii?Q?1Kmk0w6GHBwpgHCLSfrQAlUY6DlLAagZ54x3o7aySr5TN0mgHuH+K/XtTTP9?=
 =?us-ascii?Q?6sMWvpUd/LKscZ710+VI0ncbGBT7QmiyKjCy1ljARSJfUfPb9YkV7VtIVmsO?=
 =?us-ascii?Q?gLHEc1wxAqtrXIefF/LMFxX2/lVKz7b1Wjd3laNitYvrndtNf8Xca9PsWkd/?=
 =?us-ascii?Q?BdMbnfGT0ko7jUcKbjt4D5HsGWjVcgbcUFu0I569gaCN72x3C3vWdh0bT2rN?=
 =?us-ascii?Q?T1HmEF5+rW+H5LSC0gFUnw2y2XvU9klqI38FhqtBSVJtrKvVtVsj6BW3Dykx?=
 =?us-ascii?Q?ikXLPzdiVrt9buUZI+SbJVZAv/14HI3oCPx27OuS4V58pKbWZFDvtKMGipWj?=
 =?us-ascii?Q?75fYrj+ERvfxuvY3SQzPur40EBNcYfNXu8VG5KrluXYgRmKnr51IbKYfJZuS?=
 =?us-ascii?Q?Fbs5BZriJGwQsjPg3976bRaB6udnb9eGT8MkL4aWfUP1xE7DJ61lJNsmVRLL?=
 =?us-ascii?Q?IWLHR5XfP4+CSLF86POs59V7gyo2xNGRIvPxLMcZzPPoKLjtFiEKVLBpqPXU?=
 =?us-ascii?Q?XgHJHyzPKfMwOY8UjZlm0UXO6jvgdrpbeSP+dA2wuvw0xjxsEZ9Pkr2BMQ4S?=
 =?us-ascii?Q?a8aT575j78BvNDmqoMi8WUYcQ5PNTdaeQLsNPyoz6+Sei4rsnhUuVONmyvXP?=
 =?us-ascii?Q?ti8YW8uxnqG7S4gfOSPilON8WowniToNLmMwxxNmKrSHEjKCfNMQLkR3pgz/?=
 =?us-ascii?Q?WxCRLEOAIcjnthnO7wopSf/zUTviSU0iPWfzPb/b4fK4TkAiqLBo7N2sfxYM?=
 =?us-ascii?Q?inuJvMTch0rYbyJrNotDQX9fXbl9Us3ZRaFWiram1pXOosDeDEv4fSk524p0?=
 =?us-ascii?Q?D6LSKXHBV9Enyraf1QoYYA7689XJKNiSkE9qg6IqJkkr0ENrpzpmEaSIxQH+?=
 =?us-ascii?Q?X+e20pj+CDYOvNErfy0sVLK1Hp9gthg+BUve07CAC6cuPjsbvyplllDfj4Fj?=
 =?us-ascii?Q?LCEL7xSYYYhoJkY46moEJk9+qYXviukbaxlGalT5jNDT/FQGIoY6m04aDYSs?=
 =?us-ascii?Q?TqDn5tj51uylkrlI8q1QPBlK1BOC2DdfaVUJJ9akIcwQuFm3z6Bde6gQLD2p?=
 =?us-ascii?Q?wb1r2t7VpDhl5RKH7e6OAecm8m46EJPkKBneWa+sa6h2ohK7P5JiC1aJ+r2W?=
 =?us-ascii?Q?N9OROzOK7/vLRcYqbXLtLrJXMtYZyLlgF6QPwL0mYdFy5+5TkSC6+yqVI/bJ?=
 =?us-ascii?Q?xAOkI5+z1HDRv9W2LJO7Ik9YSmHfuyrVOw8+sRsTIPuiISebnDpwWvgvFhxu?=
 =?us-ascii?Q?Xn5RFcd3qf7Vfae1p47REq8KYDAfC59rH0MEcYlvs8uqNNRy+nGufT8SXreJ?=
 =?us-ascii?Q?3f22mnngn+5BdCsgra9zpst7z0QRdaifzK0R4/VXE1ZIAZ0t0tq+gQrIX+2U?=
 =?us-ascii?Q?dk3IoaKaO6F8FwRGx1CgWPaC8OpNtKkCKrAySA/jkXZvpTIDWUWVx3zvLjO7?=
 =?us-ascii?Q?x7uxeGfN/i/Yq3D0wKResh1G1itAWMYTaPv4QLy93mdNVolyjc+h6lhdfQzt?=
 =?us-ascii?Q?4vtxyfkisZYjxlVBCeY4Ngla5i/u0psESuHjG1g0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cad8c1f-2836-45f9-4d6a-08daf18f0074
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2023 15:42:51.7679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V+V1rhR/ovlsJpkji4TLm61yRiGve7GMoPsUI3IJUQQXT+o3QXXKKeR4bV6gn9wVGcdnqZm1NO0ES/CFf0USmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6335
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 07, 2023 at 11:11:43AM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Similar to other devlink objects, convert the linecards list to be
> protected by devlink instance lock. Alongside with that rename the
> create/destroy() functions to devl_* to indicated the devlink instance

s/indicated/indicate/

> lock needs to be held while calling them.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
