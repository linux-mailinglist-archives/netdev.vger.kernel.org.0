Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75EBD6752C9
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 11:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjATKwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 05:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjATKwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 05:52:08 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2131.outbound.protection.outlook.com [40.107.92.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475F3B775;
        Fri, 20 Jan 2023 02:52:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGa99r7fEFjo51Fz+6GbAcJMHg2nOtWaGxoxmgWknUFD77G18RKSfwFNAQ39qEyZmvD6mBp5MI72qxLtXP8Df3kWLK2UIhvLeQ4K1mR0G0m1NlrqoTrxNQwQZNvJ01OYDl2KVaxlrP+DqCCUQR0/wHp+z0lWH7FN6kRfkdob16oBd7dSAwp8OHKECo8lMQ//qroOpg2/r/F3yCZxP/bAFq435l5XAeMo8yLE8FYEr+lJilam+UNteb+usaRpRKfWgzGeXLLxZLd+6n7lYFrvS6d6PwWTP+CqTDDS/T3upgSZy5+klpfyO4445afz8IgipdGKr1GYt6v5CGcwh7tktQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=chpeb612cI2YQixJPpQpildURixBnLyUmXhTdJTsq3o=;
 b=A3OwBH1SbY19Kt8LL15VyCyErIqcvSm6kxC4yFseqWUeABW56SEo3JXSpcLWIfzA5vLwP7DhxhKpeEl2AJMiXwR4bIO9czVLneMuSj5a/vweH4tFVfLeEs+nhklc7M9g1KfNJwWE8ygfw9fL5cjuVQbFJUFmno5NHfeP1MwO1AZzGsJAg/tpYY+vHaUFytn9SrT1RcL/S/fjQBrTqrjTpwCU5zKRI08d+vMlcw/92TsSLu4fNEa5BSUuYzALz4AS7iaAKCXlPBD/7x/tovmM23adIMlOkjtYdlblWgbUP8ZXD5tRR0Dg3gqueYdJY3K1Ku/e3jn8K8vI/h3aq5lTjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=chpeb612cI2YQixJPpQpildURixBnLyUmXhTdJTsq3o=;
 b=mH9CIbyzAwOYCshxGY+vaPsSUk2e2Oo6WnjJXXfbfbwbNwm/D7L9R5OJLaggSG7J5fhzEEX7p4vGaR+7PH9zCn4EPKCbndR9oA7eiJWjthNkcDH5y5S4a0q3oY8cBg33gcP2kRsmFyC1RH+gX3irxVG8lWe7gMASBcFQTi21nmM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3839.namprd13.prod.outlook.com (2603:10b6:208:1ee::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Fri, 20 Jan
 2023 10:52:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6002.027; Fri, 20 Jan 2023
 10:52:02 +0000
Date:   Fri, 20 Jan 2023 11:51:55 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Oleksij Rempel <linux@rempel-privat.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v1 1/1] net: mdiobus: Convert to use
 fwnode_device_is_compatible()
Message-ID: <Y8pyS/lv1twOoUoW@corigine.com>
References: <20230119175010.77035-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119175010.77035-1-andriy.shevchenko@linux.intel.com>
X-ClientProxiedBy: AS4PR09CA0005.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3839:EE_
X-MS-Office365-Filtering-Correlation-Id: 885754fe-58a4-4e47-2d83-08dafad45ccf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pq+187V68qy62ucwdjWDJAPfU/qFUAmBRSuxWrvZj/Y5r+WZ78F4sFYOFdLRMrqGwdhSIc/Iz5MXQAiVT8zWsHCKZMJXLRNgdhX/YLQHwzWIljcdz6efPA18N98b47VSbGgKyFbAvM0HK6qBPVcVRie7IAxZnrjFEl/S5+EOeFJWFqArrcInN3PKlHnrcOLWOwONjuog0UEjf67EgO3UjJxkgBNdb3+WgsGxRzwGhuOfOQRzj5pZjYVH2RHH6VHQVWiJNyN2nVhTQryLp1ZzVPCUMgpOE32sxiwujHecuNhcNoG8r2uC5zEsUKxhaG1YmWT/cLhwq1OKdhwM2pw2ZQ89wkOo5cwZJEQlnrqFD0UKBZxeweNc6AUaqlI/LK5aH/hIcm3Cgm29lQB/1pgGy0hrpe0m3ROGgGiJvEie6hZOi9deHvD4kb5amQnsnPHRboLLVu5RMPQPlaPjFAGkS/t9iRw0uc38MMsAfAOmKJh9xC54iJGSy4lyryu6LV7k5OqY1cYLtQ6P7Z8nXoiZeln4ZF4KQHJabwpCtHUa7Yo1rDsv7vx2hnxkwiNyrcy2TGy8omMvlRQM/paPDkK2wyJZlh1SLMFPqghaUsEFAAUikGB53dkUggItTiKyJFMd04qG1SB+oUy7vn+BK9DU5lgN1U/6JZpKWqBGsyWwBuHYthH6rwLqkqj3dF3V4ubI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(396003)(366004)(39840400004)(451199015)(6506007)(86362001)(8936002)(7416002)(44832011)(66476007)(558084003)(2906002)(5660300002)(38100700002)(66946007)(66556008)(316002)(6666004)(54906003)(36756003)(4326008)(478600001)(6916009)(6486002)(186003)(41300700001)(8676002)(6512007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qd9w9fKl0dBt7mNcCGOpqS2cfq4u5sBpKH9lGvW1gFW+fB23DMltzEozDKX8?=
 =?us-ascii?Q?XlAQ3yI06auavoYVVJObAcATjEW+tmp1jtuIdtRp4G8ObvMqy5QeChroGW9t?=
 =?us-ascii?Q?C1lKGJDpZlZBRR5JB7gHYoZ6+eFUYxpvKvxcqD8zFehAo9uRI9XasDrRnwQB?=
 =?us-ascii?Q?FD9gSJl+oDTURbEJbHX5qZXtYw3niyytK9K0UsPdyn4QbZPCuoN7kyXuxnJb?=
 =?us-ascii?Q?UOrN4akHOXLAnMDSRj4M8khgPE6viWVP1r2WfTcfo2oP4dgwetbqhDsLyNZv?=
 =?us-ascii?Q?38PhPjLovLTwJxGQW1u00kckP4eJQFeGjHnylyYKgkH7z2IkFZy1P2XcPxcm?=
 =?us-ascii?Q?SOqM0HQHFgIEmJWVqG+l+XHpG0KnfRcMaJ+8Zu8nvQIv9Hs4FRrFQFBEQs5z?=
 =?us-ascii?Q?cWjbXNwA5DXYozxFgtJrz9Fcu6nU0Ovk0dIRdIUEPmwMUvN4ONMuIqRcSvfr?=
 =?us-ascii?Q?nBRv6Gqmie/G13zCYfmn7iXGiOHyEO82NNz1h43Amzh7BWVWtJQYgSnE23o6?=
 =?us-ascii?Q?Dj0bs7hQBE66N9FpZuHb/S8jq/9KfAr5qmoaKt0+MdsOwpZhaw8Y3SO/8mev?=
 =?us-ascii?Q?MOqkj1Zr5/3Ymn0F4cfFsXSUP+5gO55ogAzSeDuw86onYt7IcgK+dNg5PwCf?=
 =?us-ascii?Q?T8r6LdeH7KLkSakTewBiZJsLfyycq50+kMiz0buCT8WXMc79b/UYinEn0stp?=
 =?us-ascii?Q?pqi369eyC+suCv0VijDoTJFNBfxCQTRq90gi/8/sv+zjLGK8Z1nF7CkEjn5s?=
 =?us-ascii?Q?IoQqp/dFfozewchMamOavhRN3HJW5x3K0SO6GkoOuiBkOxMZoAq1569bmd9n?=
 =?us-ascii?Q?b7aHKo9ZdGArQEqXeFsNPpnDkx2k2HY9idF1co5ssQtmAmtGVldND3LgkTkR?=
 =?us-ascii?Q?vL+Thl3pBlRwUmc46b9QEAgLzwdJgzQ+DEDiTUww5BsplKBuvp77u9Z3HEPy?=
 =?us-ascii?Q?aXos3oqF8U/KMzErbv6IaadmDQ5jiy4oS5lQpBcPPR4zleDtuU254KhgJoH2?=
 =?us-ascii?Q?9/zbjuU3/hPMylNmqgufaPFAPwsRYkKT+CU6EqFWiGS71x5XpaTATzvo5UOz?=
 =?us-ascii?Q?EAFGNFDvjJsHMJH0O6X32zWAPRQ+8Vhp/WEvzC87cgQgnTgP8gXs0LylRWQr?=
 =?us-ascii?Q?Cs/H6JdWTFtBe/V5a8UlBDyzCNE/nIhQBf5YLyhOVuYnJfC9k+h4lfCRFbWN?=
 =?us-ascii?Q?Yp0ubrqmyNeLwOrg7spmsuOwLYgWFI9bCMZmILogQz0IV9lfZ1sIvCP3IBKt?=
 =?us-ascii?Q?TV8Pvosd8U7UWW1aLThhfErvjlold+D4tRfN8mMvuaFMplcp5O6ZTbPYlx0v?=
 =?us-ascii?Q?S20Ahap1zNLBfBlTGG3d93IFF63x47c22ycKkfBECpFhZ0cKpRc5LiUZUKcx?=
 =?us-ascii?Q?FSrNYvYnLcZDu/N00NzmGFrFYbrLMIrjyzn2jvKJCCXCzYXLwQGNvUN2VzxM?=
 =?us-ascii?Q?6L0z9exCQqlpy6M4We5HQLHOXiWACYR1eSUe0am5Lb2VJVzw2pDK/qRKxg0p?=
 =?us-ascii?Q?48NZ7dusbg61tmn85DGyj1qNoE1d2ZRCnRSiI2ucMHXOgHWlvQmLk8vKmiLH?=
 =?us-ascii?Q?cwnmoIZS+HYpcblxpGzG1GdzVTDNakcLbaJ1BRDkDIZEmQjS4yRggYZ4msPn?=
 =?us-ascii?Q?3HOOS/M/KSkn2bxuy4Ec1qnWY/lOp1g7gZJEF2R2oOH/ZFD+FO0Qybgnh7Te?=
 =?us-ascii?Q?x3AXsQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 885754fe-58a4-4e47-2d83-08dafad45ccf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 10:52:02.7009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 839g7UQfZnGz1a80aM/0UxKIHFrxB6zmfHei2lP0Mpj4SpqIrCFyVKYvVwyxRTMgw7c0Q/ApsBqHs+9ywlRfNMZG43c9baZ4dkm62E6Na3s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3839
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 07:50:10PM +0200, Andy Shevchenko wrote:
> Replace open coded fwnode_device_is_compatible() in the driver.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
