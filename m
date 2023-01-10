Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E789B663B72
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 09:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237853AbjAJIl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 03:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbjAJIky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 03:40:54 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91A21EE
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 00:40:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e7SGjcFMsZtgNFByV0LiAq8SzBZRJibKytTpjW9eF9TvMHVVfw5jrbe8HBxIFq5duxQ6iQPDIeErtkzHe/VOlDfHOZ4pKq47Oz/Ei23imJdWR/2QY/kR5Yw9eYhfzX/5Dc7VfOfNc0B4UQDPpXg6Q5T5BgQPaoEPl9e0II+8dBCiUvEQBmdJ+6Xca/XXq+EbP316vjD62VT5EuzGfqiBs6s97tcFYdBUCl7yK9XRYf1Jb5Xr9ae6z3kzLzN3XpBvcRnF4gz8MteJA5NBrNPVLUp/0phDbIFvN83lPjT09oVRkUqdwthXxwmcMD9JmrhZgdgxR3QZmBn9FwWciq0MbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xzk7PymHi8wMwqxM4P+bgkxn4hny0Ibe5XHP4/khtj0=;
 b=W4AVthev0I2AreQQWAqTb/y9+aQaVUlmw16ielO9wVdb3nl1Y1xf0Ibz2CjCJvIxc+A1VlYE4+19+NPEOEecUFLz2GlKqAKednC+qm6tEwGLGlg4CguhGTKPeWxDaJ1WnAI9MEovw/N34kLQ4FnNj0nJP+pfggqHIvg9UXct1SsL2WkHMbbDT9PsVdvzMHKdfXYE8trdrFws0Sc2KueiFMGJsDnaQuLoUOTfja8iJ+yHzWJCOHmosmacWznroRNJZIbipR6+mXReXmeEIdxnJ773GTdpupBMa3bvGN2VWq4Y4zR6sSRBTLDuGlN4y5Ls/xBcxtkYqWB0BLCmZgJlPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xzk7PymHi8wMwqxM4P+bgkxn4hny0Ibe5XHP4/khtj0=;
 b=aVYoKthjckDQVW2gWOrYiCmYyUzwBhUIyWzhvoK1gJb5FFHEeByyGuslNAZQgk3quVd61PTfwz9C+tlmBj1r8QcNoj+Hqf21RCcoKDDUxllh7qaQnsIDEDREbNO5eZioWDN5V+60Md0KuRjI1haN9aEfJsC1xlM4Uj2RYf9UXG2MkLwagmYpcI60R9n32fJ3cr5hdph3wjGoQwOU4tpA520sK7llvHptxDEanXZHsdEb8H/1q7iRmCnmStPFZRKmMNcwgCciqLAu8NwekNX+5wuQI/G8XPRVSnxJbgUHTsOBPNtKd5aw9ol+dFPH0vZcPEk+zM3zYThv1BtJLfSUHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB7525.namprd12.prod.outlook.com (2603:10b6:8:113::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 08:40:49 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 08:40:49 +0000
Date:   Tue, 10 Jan 2023 10:40:42 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: Re: [patch net-next v3 00/11] devlink: features, linecard and
 reporters locking cleanup
Message-ID: <Y70kij7+UBsHcZZA@shredder>
References: <20230109183120.649825-1-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109183120.649825-1-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR09CA0161.eurprd09.prod.outlook.com
 (2603:10a6:800:120::15) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM4PR12MB7525:EE_
X-MS-Office365-Filtering-Correlation-Id: b50d271c-a5f8-4f83-b87c-08daf2e65fc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M+smB+0dhp8+EOfhLV2CmO0UW6EvFMKNTzBQUeT3RtRLcYmo9KfCh3bVMHgnZakuyiW1Bz+jjBObTovunyad3JKt3uNWutvBuiTsbOvIEy5CUKSgOToV9pGgtZfubBIX3SGPh+LVzy2PyLaNK4V+IqoipegQgGO26wEknD292zCjxdREAIOYMXBptK2dCnusndiVBHlJEIz+IIxqbmAkmhpqX58LhmAMF8CyaYV6YDIMycYr0MkpIdwyWxugnqmB+jN/3v2HF8+09LHtcgcHOY6O/PgYYh2o+rURI3zGU06GmusmESyr91qvBGD9O2UmJtqFbTHyUk4+u+5ig3nWKToGDZj7Lw16TJ4b7MDWhAjA3asr1vPvOmzd1aewqoBBo0ZPBYWtfE8zOWh6LBlgApJngDQJZueMGNIjaoTLXR8SDDO18Zha3F6JvouA+Jg/l29W/3xDM9MF9yy/72FoTCyjHbBYz81fgZwyIzSR99GGA4JK77abSf//G2DFzM6SnFn7IMPJYUTR7YKy62M2hWXrGLh7sZv8aGG5lkV15Cu42ljKukh+Rpr0CcHtMPC27ZzUcpUbMF14JDnUt8e9tS7aDYY7U2Y93zvv68Dp3vvPLAg5tNFoNvsX1UQKKE7UoPh/hCz0J4dJ4zmO39fZAyosWT63um77yWehYt2WNPbUvOnc6GrZhmPQTvNXYXQy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(136003)(376002)(346002)(366004)(39860400002)(451199015)(478600001)(4326008)(86362001)(4744005)(8676002)(5660300002)(66556008)(7416002)(38100700002)(66476007)(66946007)(41300700001)(8936002)(316002)(83380400001)(6486002)(2906002)(6916009)(26005)(6506007)(33716001)(186003)(9686003)(6512007)(6666004)(107886003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JXhOcynKlMlMiWDj/7901Z5Ltc2RLantaf9A/2i1Dl20vu1mykd3C3Ak0r/p?=
 =?us-ascii?Q?BNjAcyWOAM13TWP06TrrIhIFlO7vZsdX8WwObLiQePLmAyh2ktsQo5tevaW+?=
 =?us-ascii?Q?cWMhRgvi7thJzivUkfStO4q+xSekK9pLJHUmapfyZdnuNUft6yt6+9gpktGW?=
 =?us-ascii?Q?bCD8q1SGQH2qsfXSSmrMJA4Flti5RWAsunzD8hoDnIwMmkf6kOz+SLuubLzP?=
 =?us-ascii?Q?rnGgv1TI3Xko3bPb5VEv64pPkfwGil1TItGR6tEQ6BU0POoR2f5qvidqLvZn?=
 =?us-ascii?Q?XqQ8KIKC+mYgMtz0D3B9eyi+9Y3wqOAlCHvOWAPYlSlZLpI2Hz/dZnNxY0Dl?=
 =?us-ascii?Q?21WluLBwE88VckvVF0O8dFiQtw/ovraRZV6Dnhu+xP3jFqZ5KcrVXtggas3M?=
 =?us-ascii?Q?1bhixMqx2W8Crm8YXe+vsEDgJwgf8lquwbOwlP198tqCc+/DC9hFU7D7ik8b?=
 =?us-ascii?Q?rBrJFxm0HcI+7a2LoWwwpkcK3v3Ps+pPKeGBz0yuBEmXYezj8EOPFcyfJ4Z8?=
 =?us-ascii?Q?VsgtckHMtpw1DbnsnFPmlX5JZuh3XQonqNoLTw9Ws9LZYdjx3tSeMXotwJEu?=
 =?us-ascii?Q?LJV1n5wqL7nFXv12cakNYGFN/mBTJSiUj7+HKsTiaBLjuXJWuvdp8ADoIsle?=
 =?us-ascii?Q?Fy6VRowqOUg+QhJHXg0G4iHpo2EKd3ua+W/1RDkngIJqT1Zon0+yCibMpp4k?=
 =?us-ascii?Q?n5MCKMDKEyM5dq09+NEVvP6QnaaL0aSWC9RW5K/1Eyh89EANSZwsoCkN8Z8n?=
 =?us-ascii?Q?l7hrm8MQ6Ht70JenMbmRdjS3gfph6/E9ccluhsgfAlnndOS6cE/wn5VbPY82?=
 =?us-ascii?Q?iqo8BaAwMK84He2dMSbD6UMQ/e2aluq+t9gefpAozzDbIxD+R+rHrCuuIbjK?=
 =?us-ascii?Q?jQXJpshFbVKiM69KHX/8690FA8gmbUQL0BBBJ6oi9cvG7o3VyyKaz1LX/sIt?=
 =?us-ascii?Q?GtT7wrmNuJYJcbUWagtgy4ITjZ40nx1rffmUv+25aRqo6Y4c+Q8z6dLWbmU6?=
 =?us-ascii?Q?sRn6DuQbrKDoEmSr/VAm32h42ucunUt7lWqH9dM3bfsJppqbHjAMOc5+2qyb?=
 =?us-ascii?Q?qcDqQPvKTxM4dkbdjz9y00wPcrDADCMMo9g3q4hjGWBSUXwVMN2zEYDEByvt?=
 =?us-ascii?Q?tSboUQmND1v/9TqZ9ANTi3RzBIUwClgZemF2Lz8Hz5emrB/2P/xOMZORHs8Z?=
 =?us-ascii?Q?Be9gQGkwNPQ02eqWIeKkkuSQsV3p0rSh218WdY5ro1h0mUOULR1XHG9vLahH?=
 =?us-ascii?Q?XdXVCsJVXPPOUvwOCDXiXq0/X/HWPOaE8y+cnu+VwY0p2iOTgvwHn8WOvK18?=
 =?us-ascii?Q?rECkhYphx9WRu7h3s15hgxlxuOVU3Mj96GGxyiraMwzAFm2C/oV2ONDNDl0D?=
 =?us-ascii?Q?eIWECNLfSHNqPkzRYOPQkL9mQab9ifIIY9SF23xYQhM2LJiaSQEDr/5fK1UW?=
 =?us-ascii?Q?oW+kKuznof+kS7WprORurhk5C/xCu8TqQpcLyeDqEnNC1h7FoP6jI4BoG7nn?=
 =?us-ascii?Q?3HlsV8LdzQ2lZGMTff3CzHVbShfHdYMiVKULZXwF0YpOMX6OBg4jl5afIh9A?=
 =?us-ascii?Q?YQ6FaNG7SLxK8VnlHQrZB+9mw4kothJ6WhrBUs5F?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b50d271c-a5f8-4f83-b87c-08daf2e65fc3
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 08:40:49.0502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YhkS1K0Aoha21UFxnfqLjHj44rcaYfHjnFwwuWVpq/uQt/C2CReuBxIPJc3cckONgSlK23TBKrt1P3vfe1ZNhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7525
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 07:31:09PM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> This patchset does not change functionality.
> 
> In the first patch, no longer needed devlink features are removed.
> 
> Patches 2-7 removes linecards and reporters locks and reference counting,
> converting them to be protected by devlink instance lock as the rest of
> the objects.
> 
> Patches 8 and 9 convert linecards and reporters dumpit callbacks to
> recently introduced devlink_nl_instance_iter_dump() infra.
> Patch 10 removes no longer needed devlink_dump_for_each_instance_get()
> helper.
> 
> The last patch adds assertion to devl_is_registered() as dependency on
> other locks is removed.

Asked Petr to queue this for testing, so we should be able to report
results tomorrow.
