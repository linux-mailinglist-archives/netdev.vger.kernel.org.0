Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43C246C8713
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 21:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbjCXUvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 16:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbjCXUvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 16:51:36 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2119.outbound.protection.outlook.com [40.107.223.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15F6158AE
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 13:51:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvfmLMf9rT2e0DZZtSs+iHgaBUeX/B1Z+qU3VAxhqV9fBTkuy7g0/y2rnpWsvILre3+oM4k61aglch2oTOhV9+goXOHgv+pUweoTrwq/h+XeJ27Hgw5jIxgEYmCDy7+gLC3WkvoBGET9phdC8elwaaOZzgVN5WXZRQ6HnnCrgZ9jMlYLh0lagI2I+x/anbl1LEfQEFYqyQl2Y7lFF0KJaqm+ZIKSAIzLR8kJryrcOzpHsHPMZMcC6pfxJzFosctWhv9KovtDdgfolxPURl4fWKoEvrJDEQEKC9RcBDn/eoGmdjr2LXH48tWBa2qyzCDbULYz5i0I0zLxsRGeDJVwIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=40Vi3ZLgwVl1BRiAyqoC13WhWeWgz/Lib4ia+gPcqUc=;
 b=DKC5hU5BY1NObTBxVF+UlbQuws6Y+NZxNGvY/QzvtnRHEgqbKZAj8zrA1zEJC2ZwBl8WehwqS5iS+0ii65JlCvqfCm+DT8BAfU7NmmbfnejlLsfo9Sg9Gu0IerhSZBVEdE1fu4xh2ac8bJJ4MUs/Wxh4hgYCbSTSWGX9InnZYvquWwFx61siP02A5I+zIVQ1RCv7RAu/30G6j4g6iXl3Mu9v/Bvad6c7wFpQkTlWBHAFFCvHr3pCyTQyYQQC2mc//jGvOFs/LtUuIT6EzyogYS2WM8URiitNfPEbOAzriJdYchrlpdHIN6KD8X6y9mZwwN3hSB9xvMt1yeO35pXMSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=40Vi3ZLgwVl1BRiAyqoC13WhWeWgz/Lib4ia+gPcqUc=;
 b=oVHgAVsqYoQ7pnqBx0eF5d5A+9b8M1BOIDTJHnt/cpBHzD9nQfkcvJ8xY2F19kTvV9cx1pKCuZA8UmBTmHAAjFhkZRbzdYxwLFPBbjpbxjGSNocvf6KqhamqM/6cXP4m5+xLxrbDfECmLee6d8Rvx2M3D6O6Ya98a31pLWNI3V0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6253.namprd13.prod.outlook.com (2603:10b6:806:2ec::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.39; Fri, 24 Mar
 2023 20:51:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.040; Fri, 24 Mar 2023
 20:51:34 +0000
Date:   Fri, 24 Mar 2023 21:51:28 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 3/3] net: phy: constify fwnode_get_phy_node()
 fwnode argument
Message-ID: <ZB4NUG2N4ZBrZMpS@corigine.com>
References: <ZB1sBYQnqWbGoasq@shell.armlinux.org.uk>
 <E1pfdeL-00EQ6W-5M@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pfdeL-00EQ6W-5M@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AM0PR02CA0176.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6253:EE_
X-MS-Office365-Filtering-Correlation-Id: 83fd98ec-e939-46ee-64ec-08db2ca98da4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 59p4tg8HIUScqo/skug/ABMQz+XjmTOAlatvI3W/EcyJuK0JvsfQ04jRcTQXp0/vJ8QOS3ieHdk8nNpKYAjXgX10YSK1hCgv1b9pjsDlBRiZkBSluxi0qx7zXyM4GpC0FhOrOEhCqAmusdWz0jnil+j6tDy7jJNGMDzsA+LkYCnLtjf29wTULdKrTih2T/xgIsWiwdkI/KkmRpcu+j6jC2TraFbFRgKd98MMykKQlRuRV946w+Q90VU5hFyF3cYKRR9i/co25BdF6PpoqjqIZx1iIhNNjAOFMrFhGVIT2Kx0t23+gco+9qK4TOQy0c+Ja+WHhZxOoLmRYY0BC3Rft6vLu2ljuF7jim1DC/FIrE+Rh2Ki3SDuBHEg9PdlJ7abM3TvLOkkvyINsblHBhM9bM5KjWld4e/z4xptp5xZj6u366FNmA0oiKkoQlPNsCBayGyg2dA0qg/dSaEr2ka/r4/W4U6YonleEqfcWv/1qmByJbeIKTwWSyQh7O/EnsBU7DsXUqCVl13ddhiYUlUTtRhqg3ilJEAVy92Qwdk1ciNfsU9BrnRV14Rrcj1HzC3mzHLOg8rnC8dJujT/xXy/2V7K0vDU+OEijabq8fUkZ+08KvMtkRYZvP3SrfaLXCTUPpxiX0zQMNJs/4p5oIk6tQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(376002)(366004)(136003)(396003)(346002)(451199021)(478600001)(66946007)(6486002)(558084003)(6666004)(4326008)(8676002)(44832011)(66476007)(54906003)(316002)(86362001)(36756003)(66556008)(2906002)(2616005)(38100700002)(6512007)(6506007)(186003)(5660300002)(41300700001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HEUjfLYE/YLt3q3lzDubQv45sfgn6FKjg2djNRISLZTJb6He0/ywlQihGM1Q?=
 =?us-ascii?Q?b+AEDKCynTj7WNk5qLuAlSHjppe1ezBHc+x7wZ0F5nMeOhQ1YTN+y0d12hsk?=
 =?us-ascii?Q?w2nreyEomhOy9RSIz3fg9gkIBXNkm9Zb5488HRlGRtjBkP2nxHKxXEQedF1E?=
 =?us-ascii?Q?mdoPwRjKuEwJKfFNsoFbJGkXLn/XNDwTqejeqt/uz3wRZpj+ghwWC5KdVE8L?=
 =?us-ascii?Q?KTl1BhqfG9LChkUhJXngnRSRTgtd0LE8xiZzBzUYSPL8JX0v1TXJ57OJeW6s?=
 =?us-ascii?Q?6nrtyzu0NmT8NxBgcM8rOJoN90HewSufFYc8kF20Qza/+7QWBe/qviw++E0v?=
 =?us-ascii?Q?G/Lc5soGlfM3D1vdx1GjYHi/g++c+gYMA3BmKujpOkMpRN6h3B6vqwyNhkeU?=
 =?us-ascii?Q?+tz23sAkv41olqwUa96D9MthGazfgoGzW1OuS9i+n7/44cNNTcMb1wVNs6NK?=
 =?us-ascii?Q?2Ue5RLAT538K2+cmBia4ln5iZd7NUavTNpz9Ej0xU8Ra5/rWxMUU520JvkQ/?=
 =?us-ascii?Q?5+mSGiieKZjfrh/P5IJYODcLN85eGoCz4a8+14ihSG7hmB+jzO37OMLJVfx+?=
 =?us-ascii?Q?QB7n7+5h0XdcyqQnFPFB5+SrFe47UVTXJbNovyniUm4SltzN28Vz43FXeJHt?=
 =?us-ascii?Q?z0fqqg5Kc4ktEi7sumAXBO8F0b+xdR1V6j+BFIY6OMO+RdjbVgkqCwum+UTo?=
 =?us-ascii?Q?sUZxYUCnDRhmdPtM0ERTycy8WCIaXyMqdtwKFogUeEvhxiU3zbowl3U0q6lW?=
 =?us-ascii?Q?79PTQFhQHfjdBP1AeyUjSFtdvLOIMt2ZgGsWld8T0cbr620AdP8a5DBxG8Tc?=
 =?us-ascii?Q?Yx1qbLC3cNR67gkRcdaXzH5PkvSEluWxP04FlWu2U87pdoRdsDzI6qLUwyxf?=
 =?us-ascii?Q?gX9etbVWqpTY/VbVd0w2pI9sB/XjgXy/MzrPjGtxWZhOF7eXV54uGADo7Ifn?=
 =?us-ascii?Q?SEF6XKJs3kCLTAWJrnJLpIyqdXQxSlRpt4mekyLT186lvujCGB6IvE8lu4xZ?=
 =?us-ascii?Q?vkyTXDISEjy36jUlvgGTQaZR54SBSeyxWM+L4BfityBajjIWTUZVqgX4unVi?=
 =?us-ascii?Q?Y3lYwSgqXa4iN86bcv5Nrp4qzweIjQ82MGbC0oLjLmnTN1zzisv1W6jVKzJn?=
 =?us-ascii?Q?cFHtszLkelQN2f74HT9RPdTW7xu3/+Z4HQ37g7gBkEdUfsa/92a0MNhq2V/C?=
 =?us-ascii?Q?4eZ1sCR2TBLZyu68nw7cJ6pjMKXdOTix4WDAUNXQOElM4iYYzjN1D0ol4j7d?=
 =?us-ascii?Q?A539OWuqNsSYUvpwta3o2LGE4YNyega9zAZ5wMtiIElRhrJQsOC5uHV80dh6?=
 =?us-ascii?Q?QT5GUDo2rAH+hsh14JfIJw/r1sw5DHMuHFvjOWGguN++GXeerjcmkzkrVzH/?=
 =?us-ascii?Q?Zy8AqfwzcO4jb1ReqwS3T7RYeNQv8V4OC+YkFazpkVXVcM5XFir0odRCnNau?=
 =?us-ascii?Q?TzQU2xOmYs1nspG3i9CFQV8K8VsXb6qsvfgpLLFUL4/RT1ihSWl7hbXzDGJN?=
 =?us-ascii?Q?R3oFn5yjQRPOrq3VNDqkqnongMryFw6whhr2sqvl1a87DngYr/nW8pSMiVcW?=
 =?us-ascii?Q?kKCfh/WbIkpp1cZOjT1ArQLQmdKReRr2JTLK0FrvA8KvTKYZWdtM1kGUEIiV?=
 =?us-ascii?Q?45N/iy0alHqb57A4VVqPyRig2dVhdbWvG8NpRxVja+dJTFdO43jGoUcsDwtP?=
 =?us-ascii?Q?m+ONVg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83fd98ec-e939-46ee-64ec-08db2ca98da4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 20:51:34.2232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WpYufTORHoiwPLZ1mKSbkqbz2lpP3QKwKdWCohhmUtd4ND0/efVdZcwqrcvF9KCDFjnIgeL/BxKTpyt5q1uvvefkNaYTfx7wYjE6rlLwGSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6253
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 09:23:53AM +0000, Russell King (Oracle) wrote:
> fwnode_get_phy_node() does not motify the fwnode structure, so make
> the argument const,
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

