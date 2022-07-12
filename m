Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54256571AE8
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 15:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiGLNP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 09:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiGLNP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 09:15:26 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F374D836
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 06:15:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bi4VmC8oML0L7NzxLNx/qCWAPVEmddvgGyy++F60j8XMpoIR7cRxxawR+z8vBpKwsiA2An7qTPIuQ+q7Z1Jk6jCbMqAaBqnD2I0Tymq1aorefvynofLZu6l3P8oOsivEfzx1R3kW5HAGUvQ5raoZbfPRem69mZThJnlO2v5fKexxQrZacZdlZieHiMUC6k/xMKxf+Q1e9+duoFf5SbLimwbmgi6ygh0rGeLBTbvSOaBog6dYxw+VWgtuMIElV6x2JGw7lJY3C7KmMHj1JgUCscq0E27SPYDO4p9+THPJ2s5j17/CIvyicVd7v8WiiTF/j6meK9EL2YWyQaUKqryGtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UeKtMZvXlH/bki+VR2EWxSAqGGuQnqedBfePTYo9ytI=;
 b=GZTWvQSwj6vGIwhPr5lfrIQ+6rUNmtkGEi7uhpchI2TLPhbE80AS6sHh4z6RfjJg1rl6f5IhXXlKaX7AxhO+q3s2rLi03g099VKHVEtSxeiNbD0CI9FIO026Q52xvXIxrslNtaCtCMbCcQ4zd/65u5phEzgw98ufWmlrddihykFO1vZxrtL3lXfptgJIxO9ryDPS6Ufuig04ve9I3TAr1+OaRIo4AA6rlZmnq7A54Ecym4zBoy/IQHDodwvlZtWJGyXWhShBtn8J0pRb3PtTgO3Q3TK6TfueCWC6nD8XUv+soMT2Bb5tl0clyqhLV/CFuQY53QA+uaiuLiYsg4YewQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UeKtMZvXlH/bki+VR2EWxSAqGGuQnqedBfePTYo9ytI=;
 b=s7XaNtECpsehefZ0OSeqYzahw3zcOqStWBLMeYpbBbbgf1w1PdwkCA8tnDcJz5OEVxRE4UxuBCsxcl0XuthlXtwEsV8o6vm/gO8At0xh3DhldO0WbbuuHyFJcYO0jX+AykJQ6Tm7w45MWm5DYj5QJFNKd5EZGB0/2HJChbBjM0H3fYR6utoIK9++mh22cA7Wx/iGaxJ5rLVSXT8sYWTaJkceTpNzhUe8kW0ZTLw3DRVd37+voQeCsGq+T5XuPEPHyOA7m+GLwlDTUkO/EOX4Dy9zAPHhJFqFS37yI7HUW1R4I7eH3CHgA8H8p7FRUaOuqnp+nVweGKI/rrhL6ylQDg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ1PR12MB6241.namprd12.prod.outlook.com (2603:10b6:a03:458::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Tue, 12 Jul
 2022 13:15:22 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 13:15:21 +0000
Date:   Tue, 12 Jul 2022 16:15:16 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, mlxsw@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: Re: [patch net-next RFC 02/10] net: devlink: add unlocked variants
 of devling_trap*() functions
Message-ID: <Ys1z5G2ZkHSe5eRo@shredder>
References: <20220712110511.2834647-1-jiri@resnulli.us>
 <20220712110511.2834647-3-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712110511.2834647-3-jiri@resnulli.us>
X-ClientProxiedBy: LO4P123CA0052.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::21) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 871edd92-0883-41b9-d6ae-08da6408931f
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6241:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X1BbEjCI1O8+UrPoeC5Aqw8RmolybTmW/S35ujLiA4le7J7kHZMmKQwhi1EfQXT86EJIjryktsyfPENfe8liHaD6MBYVg8E5e8dmc9J0hHCjZXw+OwEo0sNq48OOcwXLgPGAtfl4AvYaqjMpB8RpXAR5K3vwDU9BfEdN0oe4K6O/qAoCRDpHbpnJBpDrXklIxmdObU9gq6tOgdU6iDMmHDMd319r4oSj/ehm+UzrwiJnBXBNYPhMnduMfhvkukN35xdE2KZE5nhC4G8F6PvyFoRi65wmBYXX8r6DoGCFWORBDWheob6KgTdUBOLW/CM9YnRp52l5dMiC3a34gmlaRemdtbLes9i49RhMaJvnRe0FoYr0MffnFnHacuI2v1Nzm6iGC5H71L+kMvmOpfNvQa1cGQEPW6VxW/n6BMhfXRDcxTqL00SdsLGRVoKvS0ghlGVFYsG5FmU/3p65a6xbI+tU+ngTtuQK20bVmuXo4OYU2GqNvRE6uf4PAIGf9AWdeD4/VxlJfVXVmH+FmS6YUo0JsRZ7vBTgZvGIQZ0SbS3TYZX6g7ICW7QwShlbMx/AdBZjM4i06uBEoEpIhtY0vhGqKC2OGqAQetHeBqxSJEn1UUpwXeUPlXB8ih+p9X57E2NsSBZH9YQ+0FPFoP9GXt8kAu8K66WIkbAj5ZXZwY5MsFzQP/Ii9iWFcpk2gGr/Ml8TkyFk2HdWnwr5hT49hV1iOapW6kfKd+/LQgrkXtN4MOfB+rBgwzLg/2BR8QV8CYMtOQXdx5sVLhrZTkuXcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(8936002)(2906002)(38100700002)(5660300002)(4744005)(83380400001)(186003)(4326008)(66946007)(6486002)(107886003)(6916009)(6666004)(6512007)(41300700001)(33716001)(66476007)(26005)(316002)(9686003)(66556008)(478600001)(8676002)(6506007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sZ8MCGF30tqkgC4tDa/rITXNDLfpnp1ukLVd/Ia4D2Gwk99eqRZ6nALw40SE?=
 =?us-ascii?Q?YoN5rBHe4ZoA4VyfGd/ldfIcNK29yWYdo3zj+FjahQFJygQ74CXa4Zh2Xt2j?=
 =?us-ascii?Q?IWM2w16Wa8uhH1S/0LdW29ZGtKlxmP4uNpjMTyI6MbbevGdTrACpP6Ka8Ks5?=
 =?us-ascii?Q?XrweqUuSuxdrZGeZPKCvFh2VWFIi2hX3qFkJCHBWkdj7ohwrBDS/A1qOFGd3?=
 =?us-ascii?Q?98EZTBBgfQiUAh/I31pjP3b86f2jCZcABC3/O00DmIZoT+XICbV/gM+v1ps2?=
 =?us-ascii?Q?v0nwWprNfimee6M2BeRekvXXDZAvcG8blrefD0dYOQ0wCx4Tz870HQxmUfbJ?=
 =?us-ascii?Q?2T/txE6h3jup1yCfNgAXYgGSGxFCZIjWaY0QgRjj5khEEjA5AksGI7lV9Kqk?=
 =?us-ascii?Q?V2z3pRLJqVwCR+6vKH+RCdvuEfaeIpWxiuv4JFN2MPAuWqIhc7Xp8mZV9/Dj?=
 =?us-ascii?Q?0IH1lhQIBxxRrOS4LRsX63E8xOH7g8HpHF3cLxLBfnoY82Z+SZPHRCRMLWJm?=
 =?us-ascii?Q?QL4XgsMbBBWeg6WbRsCrPrmeBzC01oDqQMJj0XCsAOHi2qz03bLdbKW+/srk?=
 =?us-ascii?Q?uxTvZSSNPBehBCoFclD746onW95UeC0LsFg+TB9O462rMWKFS94WUgTucBit?=
 =?us-ascii?Q?c6dHOG/fEgEvhf3PgHk862K61YLe5qXXbqA0rMXVXpcneKSxUx66ku3dunH5?=
 =?us-ascii?Q?cvYlK3BwpztmjEmqo7xehgfZn+3AgPph1iQ9c0U8jK5Q/lGxfGp4VjbF5utK?=
 =?us-ascii?Q?SLVcAaF9QpRuQAfeDApkBGpSsstAUgiJIDJ/q01JwBDjMMGjYow3HdWfde/r?=
 =?us-ascii?Q?W+zOQdS+5NqP5kHVgscnuCM33z3mHlEytID2hbaYCkcQJxsBtDw30LuwHc9B?=
 =?us-ascii?Q?cdtaGyBhRR+kMm0AhJvkhtVvjvZq7fZ4ao/NPSNSXmlrFFNvP3Q83rJDC0W2?=
 =?us-ascii?Q?SIBvXbQF7CJ1/fR/x7lfvmsA2QWE8Kp6sUrMmRYjkn1RbOM4sqha4xHJvF4Z?=
 =?us-ascii?Q?cqODbRAiFBo66Qjsli8+moQlaReah35v2Up8ljsMJ/9pz7f6/3QkKvhyKOvy?=
 =?us-ascii?Q?qzr8JeowIuQfHcPzxE4H1pOl4TyC9VjM/9F13YalB5IQWZUrf7Iie/TE0RQP?=
 =?us-ascii?Q?IHiqjoVbTh4DXEjIijFD9k6A69TGciF/UkoKQza3F06NAtUjzQtXhHyx9d4r?=
 =?us-ascii?Q?b4PkIs/GknaE9FDwA2Rt2ecGJ/Nvv3Dy0nPP2eS7rUGpaHS9P4e7xWu+iLZr?=
 =?us-ascii?Q?qxrA8HtNgVWOAf7T3Ct6wspmuIC9IQNMPF48LwZbm/ehgwfEh47INwEfCzDw?=
 =?us-ascii?Q?W3SSTTKUXn7CAvtpbBKgkZpky5vdZLd63Q4LGyLbm0HKuD6j+Y99dHO5NxOB?=
 =?us-ascii?Q?Nxv/WvkCdlyKrBw05JzhrzURvLrqQ9jBxPVKbMyuZHQ5ZKEms0VkYRhPCPNq?=
 =?us-ascii?Q?WGCA4IDp3N2LCoe4j55p4Bi2jJBBBp5r0PKgiVXtchTctZr6wZN5QHb50hd3?=
 =?us-ascii?Q?7G+YHlQpSdgKwH5NneNV80iGyBrNckWMu/Px7gLxrLczwx/I5YPzX/Q0iqaX?=
 =?us-ascii?Q?fmFn+ELqGus16DmY+OdDIh8FGAsCp1WIEERH5eZN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 871edd92-0883-41b9-d6ae-08da6408931f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 13:15:21.8605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dzKZTXWsX7DsM/Cz5IHeDjXRxZ0i0LoXQ2aEH19YOlk5D1KDKyg1r9x0vtltHxIulSpzCQTBdFEHtrdAaj4oXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6241
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In subject: s/devling/devlink/

On Tue, Jul 12, 2022 at 01:05:03PM +0200, Jiri Pirko wrote:
> From: Moshe Shemesh <moshe@nvidia.com>
> 
> Add unlocked variants of devl_trap*() functions to be used in drivers
> called-in with devlink->lock held.
> 
> Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Please fold patch #6 into this. I guess the only reason for the
artificial split is that mlx5 does not use the functions from patch #6.

[...]

> +int devlink_traps_register(struct devlink *devlink,
> +			   const struct devlink_trap *traps,
> +			   size_t traps_count, void *priv)
> +{
> +	int ret;
> +
> +	devl_lock(devlink);
> +	ret = devl_traps_register(devlink, traps, traps_count, priv);

Most of the related code (including patch #6) uses 'err' instead of
'ret'

> +	devl_unlock(devlink);
> +
> +	return ret;
> +}
