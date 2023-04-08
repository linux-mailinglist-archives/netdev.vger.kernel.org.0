Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3193D6DBCD0
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 21:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjDHTot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 15:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDHTos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 15:44:48 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBC119B7;
        Sat,  8 Apr 2023 12:44:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2YNN52ugDBSxxtQ/YMb9/o0CurPYDiH8bZ38IvFXNU4pLEETKkfcPLlGJpAF9mYxuSJHRpVkuvpkYB1yuYBITwYh7lPAmPNlfHzXr7Y0G3iqzOy9O96me95vdpTvXs/TEjnWikIxEM2Nz6mH75F4pP2ua5FHdK9srWlCvUUntzIE7Gvxud1/WZlC3BjBkza7TGW9FZLYO+jbQOX1UrZnfqO0P57wjPoMM6PZkEoUfWioz1PWfNR5ExgmgLfCj6yw3LqdWLcfESQVXN2aiYEHkgvZCef3lNMb6AkhChISX9iT1TByVblJMor5kWSVNgWEcJCWl1DMzLsSh9kI4FS5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zZnhgcgF2ERBkhaDpCIYODe3xZDPI5fqFEqWjTrbXyk=;
 b=RhD1vapnUSiO275oc5jGQ6mWHi77hCo1PLSgbLc6eh+jwtQNUIsNjg/m4QADh70nJkstUtWyAsps1pGZLV46zwG5SO4mSfRpGSPu2SPsDOO6TNbRwmTeWdnEfj5TFfGLxWqKKsI4gB+5q9VZXy7LqMgjfdZAtFUhGtfq+ymlvvVYtKtXnFrK3e/hfSXy5V2LHlkR+hDmGoxkDEZgGcum9dz46ngESu8Xa+gSypSCDl6IPW73FzhNEH5+v1ck9pb9Y7mSo+I0hU6zIOXxOagGFGdlaOAZzZOJA4iyFhiXPdLzEpkaCRNy9C5J2pm5T4V8brUelMKlX7bHQHgfNVIGoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zZnhgcgF2ERBkhaDpCIYODe3xZDPI5fqFEqWjTrbXyk=;
 b=VWdAFMwAefWwl8XAMpbgur9nLZnd7LQFYzQmWNzlBycsGGWZnJGNmQbpVQNR9XCSxTiGnLJNf3pjsWDaUW99i/ir/5qteB6P54nXZ6pvdS4rh9hUdZFNJ57Rk6vCwlq5hO/v/rcS/AFgTo8o3WudSE72MXQhD7k8zWeHQTXdSNc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5492.namprd13.prod.outlook.com (2603:10b6:806:233::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Sat, 8 Apr
 2023 19:44:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.036; Sat, 8 Apr 2023
 19:44:43 +0000
Date:   Sat, 8 Apr 2023 21:44:35 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-wireless@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arend van Spriel <aspriel@gmail.com>,
        Danny van Heumen <danny@dannyvanheumen.nl>,
        Eric Dumazet <edumazet@google.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Paul Cercueil <paul@crapouillou.net>,
        SHA-cyfmac-dev-list@infineon.com,
        Ulf Hansson <ulf.hansson@linaro.org>,
        brcm80211-dev-list.pdl@broadcom.com, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] wifi: brcmfmac: add Cypress 43439 SDIO ids
Message-ID: <ZDHEI7tbjLJiRcBr@corigine.com>
References: <20230407203752.128539-1-marex@denx.de>
 <ZDGHF0dKwIjB1Mrj@corigine.com>
 <509e4308-9164-4131-4b93-75c42568d1e4@denx.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509e4308-9164-4131-4b93-75c42568d1e4@denx.de>
X-ClientProxiedBy: AM0PR02CA0195.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5492:EE_
X-MS-Office365-Filtering-Correlation-Id: 94a9dd1c-4b30-4845-3541-08db3869b2fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rgvOIPaUoPfHHg89Q4JWbhoVI/9KYM9h3EBONDGrDU0YUCRpD+xCMJ4dbLIMNTSSb9ch+/F4ssbqz2CyAilXC1HI2egg7TeQtCPzyIq/NMTriaKMMQl4oco8etKNSR29r8mCeLe3Tcx/2QPFG9cMQO6Vy9K2I4gqHtW9laNsgePHRJpNnkhCLDiq1KvdrVf+YOM26Iu8Gte07rM9CUoJ+M6rozRPTV0DaJtbyYOMWPgMC0rh2iWmgoIHi0uRavfw6q0GRZu7tit4Zbi07PBtvJ9Pp8akjb8wRtaXVjN4FUoJLb5gPcTZKdbyW0CpxCv/u9TipMeoQZ1ZSiqGXtXDXHQVaLIrcLvsG4g1tJqI5j5LsXOICx7rJok6sPNQ0C0Dx41jm3iBMAKy1QA7Dnc+kfHJRztn/Iy0ORiLycNICht5H/HUrk4Iug2wS+4HL38XbXmGKZTrAXBuUco1yGeESPf0W5u5cOdPUepqqYnV+Y26W9aQShdo9DBHGC6BK1KvhQqwJrRiX8HH9p0dKawleZBR/aRkHD5jEI1R1+CRilyrn4yhwN1ls1d9IMcj71yh03UlJurBGB8GWhpdYzfeuXe/YFfgyof/BFVWLDQVA/o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(39840400004)(396003)(366004)(451199021)(316002)(6512007)(2616005)(186003)(478600001)(53546011)(6666004)(6486002)(54906003)(6506007)(6916009)(44832011)(5660300002)(2906002)(36756003)(38100700002)(4326008)(41300700001)(66946007)(8936002)(86362001)(66556008)(7416002)(66476007)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J454SePRibrKNgw5zATXZTUPA5kloO2ypyBaesqd6+EBPZkE5bykSj30ZwdR?=
 =?us-ascii?Q?JKc2dJBmNPfwFNzXG858SlAry1m7S1rjyTzAmHueCUfSryY6BJHR1d88nRtt?=
 =?us-ascii?Q?PZYGwXbkZzrPYEJdwaffjJ4xoZkWowHJ1pjzzi1LalRtUJkdQvIOeI99TLIQ?=
 =?us-ascii?Q?2t8Ycdb+ET4nCUckIYNtZ23CA4TdZZBUJV1+v6CRula6PDkdGvoO7HKFxU2t?=
 =?us-ascii?Q?cdWkrWsPQaLLyZsyHDXdSAn5wNawt3Qa+4AVGySGyI8noDvuinkqGF41+UxL?=
 =?us-ascii?Q?dKMmDDJuKvivpB8hoeJ5hxQya30IcTeNpRQ7P83iJ6cCv6nuqK2+CSoH4pVr?=
 =?us-ascii?Q?AV6RX8ef7VM5nhoXXzg24LvUiQktV+HNAcHjOxZ8dvZ7t5jaFs2QSiXxOdYy?=
 =?us-ascii?Q?2SScYfHQdSsXvVED+Fz9DcudItXA0VMenSl5dKFZnAbUznUCtvmLVR5uiU1m?=
 =?us-ascii?Q?u+SetLlcs4ctX1Ix8/WNN4bI5I/RtsgjUN/uUrb0QXnt1J1qbHIG4Rpi91G5?=
 =?us-ascii?Q?Yg6ikpK4PKaxBfkMgaL0mzhT7M7VFBJY/6fcAh35m27RUV6XhiBZvJcDUPSA?=
 =?us-ascii?Q?vYDv9VvDQjNak9YcsqGzjMJJOVb+AavEv4vdQGVzi1gAIWwLsU0G/eN5CEad?=
 =?us-ascii?Q?nCcJS+WwwdJvR4SA7tJ7iHjbYm1zeSSC5tQN1cgFlVN+AkedF+dC/HHjEdZS?=
 =?us-ascii?Q?NCoKj/Y1WgB8VcvJMuxYBpbHAzsw1O2QENteIpph6tJ0reoQ26kKv12dd6E2?=
 =?us-ascii?Q?T0W1CxUdNV6EeOKEL2YQ4ZvJttqJoZML5jxOBowqRx8YJmfJpEeMvDNujmcV?=
 =?us-ascii?Q?xJquNo8YxsKxfmaroJLTY7uk4xF5mCdIBbZkH41RT8xVE63GByPpzGW9XfKd?=
 =?us-ascii?Q?1kEREuZOpXB1c6fJfE6PHjnUgH4CE4SOv17O3CQbznV5IN3vMg1WQ2qdXaJs?=
 =?us-ascii?Q?oDtHhlRyFkZvI8OVcGxD2Pl3lIKvUq2CSy4UDsvn4YiTuRht/ifwi9W53pfg?=
 =?us-ascii?Q?9/tyy0GA7S8qIjZbKeu0Mo32jFZImpmUHGwI/uja4ICG36lfnbPfMfykwArs?=
 =?us-ascii?Q?oKuBRkpehLtQLhK/GpNAF7rXG08v6rrzKkCJdlmRGN0JT2LUI111GpID+37o?=
 =?us-ascii?Q?YY6XcaWkw8K5zQiIpY1CSrwMHE+Z4bmErPP8AkVy13mqRiC+9MBBU1fjqLCh?=
 =?us-ascii?Q?81eV7c+HH6aNVNIXLs/H23zeKGrLBj+MKSyqu7375C0TH/2hPmzLuG8vgiDo?=
 =?us-ascii?Q?0imZY0MCxNgBf4B1lqFn7qPwritXl/5b5eL/9JFrqtmnIl1nUTPGsm4nDH8F?=
 =?us-ascii?Q?VXOCV3lw3ctk+oUfzVTO9SmFtqH9++Fbixprk9hRFqZOA0xSGcHDh5NOZcoa?=
 =?us-ascii?Q?ZCango4Cz0VaLNLj8KQ4A2pd1qW8VCo6BaW5uH0EGaZ1N6hJkVM0HKguX53y?=
 =?us-ascii?Q?eskZKL3c/YLbRilcidA2qxixwgEjq/M5/ngB7JlA38kIiamFn5jVtfSN14ue?=
 =?us-ascii?Q?fKqGBa1Jk8iZ08YhaXkcAsepCrCfeopmhUJi4veZd/Hag0H0nxcXSF5vDvtH?=
 =?us-ascii?Q?m3OXXo8zG8cs2Ivwl4iVm+iAVi5CBWtTK7bl9Vs7ihVoeb5z/IZIPSJ3ziUD?=
 =?us-ascii?Q?GM6MxbVaiboTpHT8X9mUKpKx/afM+ZKUS77rhmibb1tBtzwU/mZkoACXrH7P?=
 =?us-ascii?Q?hbLqbg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94a9dd1c-4b30-4845-3541-08db3869b2fc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 19:44:43.5793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qdA5gnX7pwwqsoCEEYJGUrwQlK8qnUXCZxOnTO6QZCWnIBVTKa1XT9XF054rcNUaAf/6fm8MRZCKM0QZHxmGiglt6aRcyb6Uxo2TEWkWJ4Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5492
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 08, 2023 at 06:44:40PM +0200, Marek Vasut wrote:
> On 4/8/23 17:24, Simon Horman wrote:
> > On Fri, Apr 07, 2023 at 10:37:52PM +0200, Marek Vasut wrote:
> > > Add SDIO ids for use with the muRata 1YN (Cypress CYW43439).
> > > The odd thing about this is that the previous 1YN populated
> > > on M.2 card for evaluation purposes had BRCM SDIO vendor ID,
> > > while the chip populated on real hardware has a Cypress one.
> > > The device ID also differs between the two devices. But they
> > > are both 43439 otherwise, so add the IDs for both.
> > > 
> > > On-device 1YN (43439), the new one, chip label reads "1YN":
> > > ```
> > > /sys/.../mmc_host/mmc2/mmc2:0001 # cat vendor device
> > > 0x04b4
> > > 0xbd3d
> > > ```
> > > 
> > > EA M.2 evaluation board 1YN (43439), the old one, chip label reads "1YN ES1.4":
> > > ```
> > > /sys/.../mmc_host/mmc0/mmc0:0001/# cat vendor device
> > > 0x02d0
> > > 0xa9a6
> > > ```
> > > 
> > > Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> > > Fixes: be376df724aa3 ("wifi: brcmfmac: add 43439 SDIO ids and initialization")
> > > Signed-off-by: Marek Vasut <marex@denx.de>
> > 
> > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> > 
> > 
> > > ---
> > > NOTE: Please drop the Fixes tag if this is considered unjustified
> > 
> > <2c>
> > Feels more like enablement than a fix to me.
> > </2c>
> 
> I added it because
> 
> Documentation/process/stable-kernel-rules.rst
> 
> L24  - New device IDs and quirks are also accepted.

Thanks. If I was aware of that, I had forgotten.

> So, really, up to the maintainer whether they are fine with it being
> backported to stable releases or not. I don't really mind either way.

Yes, I completely agree.
