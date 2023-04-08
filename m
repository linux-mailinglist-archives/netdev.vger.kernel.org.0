Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51A96DBBEF
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 17:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjDHPdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 11:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjDHPdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 11:33:03 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2097.outbound.protection.outlook.com [40.107.95.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD7CAF38;
        Sat,  8 Apr 2023 08:33:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KwrhbHlZPazQ/LrjUTr+44NnVFd/LKe2hICPGeJEkXZvuylDXMb39ERsIPoR87iDdhE74sELRCrUPXYir/EK+K0vnQ8MjTRNPA9xC7CBPcx7z7IppC7EomnrQfZ9ENtmF55vqZBBq+t2anOzw4LTD/u3ArUtkQSlBJch09yidKt9q50EgPpRS7OSz7/mplldjLS0sDxybNXD1G2xMNzEe+lq0JgHynBiFWL5JtAUVSB/Dspw/HwGITBTB0PLvN89eakRGiqybVHsqHdeF+yz+2ZmJYZoSZDkCb1csMcvC99dRDQ6BPzsLg1MMHf04dLe1qwUx/htOsSQz5B5ZFBxnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L6PREcIi3qWQyeAU7KUGTBxrNTEKkCkFGjHSr7W5pVE=;
 b=UPmd5gZBsZDRYXmYGcSzF1bhPiPAg9/rTQElF5tjPqA27lNROrcUWOiEE3dK8RL1xHeNM35CnYfiCjF7tYsHeMEyKBAGjCmhjUU2CAMNZghKIRWI3qwz9V/Etrqyn/alwqlIBBFQUpjl+TeiBg0vlw7S50Qvb9MqL3LTZ05q+6Hgk7MLp3UB+XPOW5HAb76xJIxTBlP2rRkZeRV6XBItYX188X47NvUAJ3CLwfJ2iMdvTLUYQE7O5IX8UFJl/A5R8z04j5jM9ZvMn8knf7mbxC3BlwBNTEKonGpnilIWWqfT3OmBqIk0XfSyLZtrNuSsRb9u+nMZVIWauBQB8YthVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L6PREcIi3qWQyeAU7KUGTBxrNTEKkCkFGjHSr7W5pVE=;
 b=J16X4/WMN+3wBlYzoGwtwBvGTaXOGyWEpF197a6tnepGel/KZO790+WxjgazF3D0hSm/n7p05HAdYOE3zTEyCXHLeDzZW6BFBH7hG3BBqWIpEQBdjJqiRRmZGzW+tXpoO0pUG9M98J9CFl9w79fGaGuMHmehFfGHi3Mgq0KBQ+M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5422.namprd13.prod.outlook.com (2603:10b6:510:128::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Sat, 8 Apr
 2023 15:32:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.036; Sat, 8 Apr 2023
 15:32:59 +0000
Date:   Sat, 8 Apr 2023 17:32:51 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     m.chetan.kumar@intel.com, linuxwwan@intel.com,
        loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        error27@gmail.com, kernel-janitors@vger.kernel.org,
        vegard.nossum@oracle.com
Subject: Re: [PATCH net] net: wwan: iosm: Fix error handling path in
 ipc_pcie_probe()
Message-ID: <ZDGJI8Q6lWCJdEMR@corigine.com>
References: <20230408065607.1633970-1-harshit.m.mogalapalli@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230408065607.1633970-1-harshit.m.mogalapalli@oracle.com>
X-ClientProxiedBy: AS4P190CA0047.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:656::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5422:EE_
X-MS-Office365-Filtering-Correlation-Id: 49681a8c-4688-48bd-3523-08db38468830
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2y0mO4GuYO7ofzJh2SggNYfNb1wMhAVxRvDyh0ulI6fPZrUzLzy06ePsUd8+JafRKjqB9F/raKxG0t4/WJMoB8dA4fomf8Jk5KN5ZfaEdyPz7Oe5GbAqu/bYzU4MMK9758QxfNxR9aVSjJS3VRg5FKAw8iNBiNpHb0JzO6+PtTEpvMXHq+TG9Nz5fvPDbHeD9jd9QI+owWvElGjKGcvKNHeE4B4fOFo9lSDC4TzUr+sXM8Yf6slOIzJBQBc3NYa1VEW1yfkqllk5hLIOcM4NIpH+UxjXmFBtjhCMFEPs72xFZi7PMLrzLVjLvZ2vUU7XF70GDvO0o9O+ktnJmKod/uaViku+S0SQI3axkJNfVeDGH+pUpdNc6VwMt3QtYlbUHNKnIjOIWT61SmCH61rVDbDOsDvg3gBKEsxkrDopjn7ScRRpx+hSHJZ00Wt63QgCsmBsFJiIaSgPMSfOeSJHjcXVr1caIohfi0o+4rQ6UZ8yVWDouC8A9vQP5PPCNLrp5Dpln482ORs8Lx1dB8WJH4W9d4Rl6bibMSn4SVUR5n5JylENuB+Balbx87GQZI5z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(366004)(136003)(39840400004)(396003)(451199021)(478600001)(2616005)(186003)(83380400001)(36756003)(38100700002)(86362001)(6506007)(6512007)(6486002)(6666004)(4326008)(6916009)(66476007)(8676002)(66946007)(66556008)(7416002)(8936002)(2906002)(4744005)(41300700001)(5660300002)(44832011)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N7YkBL/03Oi8r9X1GLtPMO4DpvrlW4cbjCu9zxOfZZBCqp0zTLduKntD5Tbj?=
 =?us-ascii?Q?2iCvD9yRLPxEiuifQb8fkKVSIbCoZ4+pshDzXmzXFhyV8/VPmj2hui5D6WQV?=
 =?us-ascii?Q?DU56wkg6e0+Y2JMDQfPGDjySI3Lw7DQrZwJv2uajsxsTiAcUeRYulectFYqc?=
 =?us-ascii?Q?ezmsg/k1Olv08AZptqqP3fCwZvoK1GM+oVLbjnbgvDg3jvBxg5j6T62Gz0fY?=
 =?us-ascii?Q?bk4w3OqmgKeaQi0assr7GWGYZcqbGHN1PkDHJy2R69+H+Ga5+J3xZMHkrkCT?=
 =?us-ascii?Q?Ib8mKZKdbbP9TWP40RJJqGpTu8CJy+48CRrTCENL+T75D9p9AQg6ADfFvX8a?=
 =?us-ascii?Q?JshLla6DIMvK2eOX1EZ6jgm2TRfdsbSptyIKSuyg91rkgrB82afWmDpBW18K?=
 =?us-ascii?Q?4UDc30IK2wix+LXPOzzh61v0mCtG8PT8tkm44VQSEp904Je2QtUHx2fdGlyM?=
 =?us-ascii?Q?Oqj4abjkwomQ0pDl+8E1cqT3IMG1sUUGo4DXA0CVD18y5KkwrBIduq5dTKli?=
 =?us-ascii?Q?F7gQZs01dIKoxJyNmDCbhEjBDZPhtmyIWemdOMQEzI1EK6VE5YznaXsbZQLV?=
 =?us-ascii?Q?PBX7luDXMtm8L7baQHKfdmcU79yss0K41kjJoFhW4SanuNE8WEPsWY2jc4xS?=
 =?us-ascii?Q?UDx0Oz6rpRzksoxyqvS0BhjMPQa+ldPQztyqkkimut12J43orYLTM0yC2kxQ?=
 =?us-ascii?Q?rBthBZkcvGeZdZ/P2dBb2VzuwDIo4M/Py7NYGnn05WJBBMNDM7j3n9IfqXHg?=
 =?us-ascii?Q?F8KIYYcu0A9ZEnFm9iydL0qf7vMZBmgMhipJ8loOd/2JiDAJeDN6p8hmKnT9?=
 =?us-ascii?Q?o08bKCu/FZbSaLfFg2R+12dLkIH8JB6x+szkQ8ADmTA9wtTy+1Y9KK3tMZHv?=
 =?us-ascii?Q?54A6rAvjIL8De5PL5DF1dKjZN/e7zIMOwXjYY9G8KWSnoOShrtpEBW9woB/R?=
 =?us-ascii?Q?RrlvcfoyVkOearfd1/M8t4Zv4Gj0ARnGHvMbeIk1oVVfF1lIa5QlAqi3mWU+?=
 =?us-ascii?Q?yAO70TSjTSn2BEoo3fl2WGg3OxzUfo/GEczz6z7hCh57ZcVCtQd+OCurWlNi?=
 =?us-ascii?Q?5lWoePjhBPcCkgEEyiK/jWmf938GLYpP5vTU6dATLI5fflMfaZ8NVxUsjIN9?=
 =?us-ascii?Q?ZdNyiCDEV0iZqBCHEOtDKPDOqWb+9mYJWRd1rf0cKduhpI+sgDl/7daGcB45?=
 =?us-ascii?Q?FDcHHJRayQsIszJmZ1H09QzbvxOz/a4r3Ob8Tv8AE4+ra68Yd4YYUiAAdNMu?=
 =?us-ascii?Q?LXwOdNXqr9wVHZJ4Cxby1c3XbOMKoYbqy74Y2qSyq3zbklXIRol5Q6JXvpdu?=
 =?us-ascii?Q?H0iVudlz67n4HAXOCAsxf4wtzN/CxExI9auYGumRoYLV9mksBNUe77/hqz08?=
 =?us-ascii?Q?6FQjeZYI2hGbBPN7kpjMGGGicjg+peVU/j3q0ZzF6fcXXhLb30MFjm4AI96y?=
 =?us-ascii?Q?sUyfztKq3HjviLEMT5BNLl7bTRcvdL60rnu8T04XeWEIbskVy7Y5SGxmxMVw?=
 =?us-ascii?Q?9fyKbNQRlU2WO3fJ/znJxqyKPRNEQPPYHLfqtZEbAht4MG8rrV5Hm+M5mxTm?=
 =?us-ascii?Q?sNW6oUCqxskDNA5WdUYWQa9thBdJWeIxc4S8sHqoJ0gUjx4qyhGhaBwnQuz1?=
 =?us-ascii?Q?pO0GV0Cp0A71SikNXXt3wkxY/RZiCJymbNXszCU+mcH9LfUMMZbMiuVo4Map?=
 =?us-ascii?Q?Wn9ukQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49681a8c-4688-48bd-3523-08db38468830
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 15:32:58.9088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7HnkH5mZ22HWb9XY5ab4s0lLyMc+bNmXgObbXjpmPmn4MxdihoVmNeKTeByHdiUhcC3sJBgxg2d23dGpLhp91nQaL9rZJynShqH2j1HzJrE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5422
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 11:56:07PM -0700, Harshit Mogalapalli wrote:
> Smatch reports:
> 	drivers/net/wwan/iosm/iosm_ipc_pcie.c:298 ipc_pcie_probe()
> 	warn: missing unwind goto?
> 
> When dma_set_mask fails it directly returns without disabling pci
> device and freeing ipc_pcie. Fix this my calling a correct goto label
> 
> As dma_set_mask returns either 0 or -EIO, we can use a goto label, as
> it finally returns -EIO.
> 
> Renamed the goto label as name of the label before this patch is not
> relevant after this patch.

nit: I agree that it's nice to name the labels after what they unwind,
rather than where they are called from. But now both schemes
are used in this function.
> 
> Fixes: 035e3befc191 ("net: wwan: iosm: fix driver not working with INTEL_IOMMU disabled")
> Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> ---
> This is based on static analysis, only compile tested.

I agree with your analysis.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
