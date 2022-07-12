Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA019571B91
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 15:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbiGLNnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 09:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbiGLNnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 09:43:35 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2070.outbound.protection.outlook.com [40.107.101.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290D5B93CA
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 06:43:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fa5uHENQdzIfyE1hkVvQNqvdVCnx46sS9k02W/eWM8Bsr4CsdgkJ5l670EAUiQ3Rpv0CWiYeKCjE4QDWBQT6vSTB/OajLhxhOkmu6cpAQcV/L76GswzrYcqRMZann2SOQQJZGyrzeTVVD1YMf+xEEqes7rfM8AibsDjZAUP90KbMH0o7x+b+Hc0TI9Ocx6cAWhKTQq6Hvr0uqClai2lcnN1eQDzWCelt4YgtGh8kkFoqtERdl2hqGIukYnwf5UeQOv8KmU29KxWCW5kPQ0EsyoKzpmDCy1zw6pAKbNZHxF5lBMUy8692pO+HSYvQAbGbe64KDPwGdy1d2Ij00H6gew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OJqeYepjqqD2M4DUWgFCiiAtFcZoiFkaKvlPJsNJHMo=;
 b=SqRMEiePwA/dzMsBSV522vUKNEvQ41856nDA2p3VTENnZ3U7hogx7oTPW+LrjUK0gFVSSCyeXtjWz/f6dDevA1mgMTxWQ7ei/IugK/IzUcbaAfat5+S2Obc475ctCJhI170UZSVBkdMb+giED3VQa4OUanagzHHI7Zluxd0TsAdDlIHYC5BWKYxvxc4M5rthojaTHqmqhA1MUcW4/DR40urbepbPlUpx2KSWyeQJPK4ngqmI4V1PlZyBM5TGCzCENtZ9oo5vnlQ2d3LH2KnrmM4VpDk6l9kwd4CatR81Nw7UQttRk+yQAwO/xwZpVENSaMj5dy2mt9ZV29jm5dppnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OJqeYepjqqD2M4DUWgFCiiAtFcZoiFkaKvlPJsNJHMo=;
 b=XSFykAAZhf3aNGybZdUj6HATk+20t+jOh9MZMYlUps2S/bxgibVEB693jSUwrZUpkPKXNYaShYKTSV9e9th/DLggDK2EPjxhO0Pk5PRHxccTQvPchp4wmCuUq4UgllcQEO8bxiAQu2XPejJvhS7QEC6jQ0nyj8N0eBipStskxNsD5rk037Om+MYBAFX0AAuo3sRIgs0WUXD5qzn/uSd3WcvjxRoxqlIzzUDRXKpHZ1r3OQZd/Ra/fJKII/IeLeT2vjwEqdQ0FQyuFowjw2M2skD/0QMi4dZ3MmlPJpFsxLz/IAUIgEFoLm+iET/ork90gtx/d/SfTXeAeIbu6uWWmw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL1PR12MB5080.namprd12.prod.outlook.com (2603:10b6:208:30a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Tue, 12 Jul
 2022 13:43:07 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 13:43:07 +0000
Date:   Tue, 12 Jul 2022 16:43:01 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, mlxsw@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: Re: [patch net-next RFC 00/12] net: devlink: prepare mlxsw and
 netdevsim for locked reload
Message-ID: <Ys16Zcd/2OGLF6x7@shredder>
References: <20220712110511.2834647-1-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712110511.2834647-1-jiri@resnulli.us>
X-ClientProxiedBy: LO2P265CA0455.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::35) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3859498-29e2-4534-afa1-08da640c73bb
X-MS-TrafficTypeDiagnostic: BL1PR12MB5080:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D8rhIyG1wml9x1Hh5Y+3EeSBoy/cJF/19WtZ4KtxlHcfRlrN5FZU2cBiwaU2CtiCJ6LcZvXVQV6je7XAOhsSIaOkSBtnsSaKajJzRkg+nVyUMHBCVD6srJ3LlBxbPs+78BGy3cXEn1s9sCOAQ7dW96pbz8ktlBwDH7Gtoh0v/g9pkU8nqockQ94EFrtjRJ7a2FgY3b7PsFDIdLgmIwMI9xdbkVzq0+d7HzseN+ZgDEk4bLIrUWkXa1YUAPxJjOSJvoGCxVIaRN+2W+8Lh26osdpC7kLPgv3QYa9ljAkmA1ghw7dNgFyAtrTAz0mGxyaMVpnHuB78Ynuh/5rogEM7ehht3ZjZHL8viE2NYWeJo7xF8gF3ZDGRucp6Mml/LB9pE5jM5LkI1llfVhHjbq0QkwjJVeD3p40KcjPzYOGgHV63L3dDiIszdwW59oWfoOoRuoHBvN5AVDzO7nOu4Jq48N2tCtovHIxSFu7k725aZclteZRwqDWmmIjnBtvERhu7bF4KtrDxty7EBhH4WLAq8st4m+jHSfI0Rymp2Gwu8ig0OeTf4M3MCKaTCPp96HKTCKdBXYSQOR2fiea5XKEqW5gU2c1aSweQn+9/XTS+NIQK3cvVh74x0D0cIMb2r0M0n9AnC9Iqj6CYgkJoEg4Q240KHft9iROT3a3vFSfHm9TE0G9IygcLL4U1u+sx03fQTWcOLlhQoK1jh/FA8dHGPUhFdMRwInLJNXB2qFfuDEBvm8LktBuAUibAGC/DAvCQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(41300700001)(33716001)(6666004)(9686003)(316002)(107886003)(478600001)(6506007)(2906002)(6916009)(6512007)(86362001)(26005)(38100700002)(4326008)(186003)(4744005)(66556008)(8936002)(66476007)(6486002)(83380400001)(66946007)(5660300002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CHMlpPCWxA2c0cDRPKss6fRHYksK+4H2qjc+Y2z3soSC+AAu4esqCoVlW3Xp?=
 =?us-ascii?Q?MH24Pk58eaIVG60J2kw990lXi/bfJ23nIV6HDwsvp38e8+4ime7Di4ZlbnTS?=
 =?us-ascii?Q?sviu6ouf/OAbNExuXEPS+p66y1VDPWuDcYZjj/cpQ71xpadX4OlqcqaWPYGK?=
 =?us-ascii?Q?8ygb9fBSMwHlJr+IPxuudxEnqeQUo1FZlPvgEoYBoglsZ9mjEgh/0btRmIlL?=
 =?us-ascii?Q?D95z7Nx+xuYXroxd5claf3+zI5Q88zmp9toU4PGTxsqDePQ1U8t9at1v1sI8?=
 =?us-ascii?Q?1xh9dpMMa1uTBsaWQdQzvW17bUivVXCRGi46ZnTAGwutJp+scX7J9FJe98t3?=
 =?us-ascii?Q?E8A+hcYMpb6Disa776LdNMltDMBtrCkR+jixEwt8ZGo38nHp0irJhbi5Shnk?=
 =?us-ascii?Q?QY6H++XDm8Bmj2MzpwojRD/m7kpVJTOmg9EWZvOMCogHNyGKXdKp6U1OC5j7?=
 =?us-ascii?Q?xc8Mfgc1JPUYwzs7p0jgxn0EGm6mIVNicnul0zkiUWbjiZdy2yxpqJaOw8fx?=
 =?us-ascii?Q?Fe+WBymZORGt3B+B2KZx0a31mSFYJb1nEaURUqbfOaD1ouzvO/SFDi/0rIGG?=
 =?us-ascii?Q?IHG7RZQqVyNUHL4P27zm2AGN6MQeJxmtEWITq/mohDMd2bAHkpeBj13WO0Vt?=
 =?us-ascii?Q?TJtYLEG8wSV93lhjHphUsy3DxdTgL03TQZcWPeykYhUAaCQlTuXB5CBxCSM8?=
 =?us-ascii?Q?0Z6e5VF1MJpPC1DVy5j69pXQj9VitLnIgWWvX7BVewqUGxNuRfFCU37IFLZ0?=
 =?us-ascii?Q?geKraXMxjpEiMLVVWeRXAtwVPAZsYFABK5bayikyetI5sO1htx1FKW94RqQk?=
 =?us-ascii?Q?GuUD1ngTo1wJab0PFUm9tHH7+wwRgctkg0ucVXZYObqq3vyDkSDCm7FikWrs?=
 =?us-ascii?Q?j4qCDS+2HSpfpxRCnBj9I1Cf0mn/ddqPFOYtjfK5MnKjFnTqUvBMkCflzdwP?=
 =?us-ascii?Q?I4Bd+kIMzEgULc0AasbnUCpFzvBQRcybYZYYL8gAKjJYVa/qJnSXRUhx7Ju8?=
 =?us-ascii?Q?/sd6wNHwSmBzPbTiPpW7Eu0xENaQUmobt1lrn3ZMvk3L67PAqDY3V7HPC42M?=
 =?us-ascii?Q?SAnK3fF1sj16RbpcdjEHKA5oMquHuGQsJwvCnXxdWBs5Tydw0SboS71l6qZI?=
 =?us-ascii?Q?1UoQW+mIw8/fkdV9ZdAygDVLBTVTFgb0yTXJi3iWjLjytZ+sLp4uH+4jhfC0?=
 =?us-ascii?Q?9+9o+AIVcOXeIPsLszn4LGR1ZYoYRQp2nSZcD3GmpHE1DqopVzg3qGUIhacd?=
 =?us-ascii?Q?Fe18OWoG0B6OqKYaZUB0yuOiq5UIRqRYOKnO7XcBghfAL0Vp3M/NXE46xSmv?=
 =?us-ascii?Q?vUn9idpqOlfUkXe8J98uJDAiyr2ZhooJKQct8LapSV9FwGm2smklsmUnQJQf?=
 =?us-ascii?Q?5jg3kt9rRpKSwuUmmVHxvIbQMdNPtigfyDwkcN+RuPqqOyDVY8M+lmlGuOM9?=
 =?us-ascii?Q?J8T2xJVDoTAVoB7zaHQKqXJOGglm+WX7gGxw9hVxUAnz1Q9rl7de2cMDXwOZ?=
 =?us-ascii?Q?w4ZzbMpe5g7PaYq5xhrC+vI16zWneEgVphVePevxAgN40bE7eFGCsNF8lwpi?=
 =?us-ascii?Q?+8Z7JuL1EEgFyPcdIQW1p177u5eR0ZMTCxATbg//?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3859498-29e2-4534-afa1-08da640c73bb
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 13:43:07.1504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ocdFqC7plzXUdZJ+ZxmceHkbxSGT1SzxgRZ1wztyHYXy0F0Xs6m3mdQoy88SG4giTFKk5MD7hKE9gAePTAgpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5080
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 01:05:01PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> This is preparation patchset to be able to eventually make a switch and
> make reload cmd to take devlink->lock as the other commands do.
> 
> This patchset is preparing 2 major users of devlink API - mlxsw and
> netdevsim. The sets of functions are similar, therefore taking care of
> both here.
> 
> I would like to ask you to take this RFC for a test spin, will send v1
> after you give me a go.

Pointed out some potential issues. Will test next version
