Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E60467C746
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 10:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236920AbjAZJ2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 04:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236988AbjAZJ2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 04:28:41 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F186D37A
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 01:28:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+qK0YP0FRYFTtgACQgea2mpdqxvDfhI+ueXf3B4+8F1MCbI0JgTXv6CXwF1q7MgVCWdL550033j8437tfCEnVafkRIhAlEdJVy40SycvEJZoQZfWtqRQmoRqbkUGJ/31i2YnQd+/0QbUKj51iHD+NdV1GlUuBr7IenulupkzW5JFTEmuZYzHoH7kOYhjBIEi7oRGLWBEa1F8M5F9NHDDtcDhPLy57ACiJ1EPfewLiglClN5MO7GF6a0iL1Ti7JZyAyJJeuN6BlUzfaw5LlOWYeKnyjroAWBFQHBhCTZyT8pH8gllD0oxCbsUs5r4+4sfahsPRwKUH9vt46dkI+Ibw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JqR2TAfYx31dANetN5XjKZ+Wa61mp07L4GZ+S7y5ZGo=;
 b=aXt3ZSpsXwcrMltjqL+7NrQMm0SFrbPeXwfh8BcHj2S0YDm5iHx6piWoKrOvmx3dR7A7YZNHO3T2LTV/Lli1wHvdoS+kzB1vZoh2OQTnSrEeAMsTJLwn0FBiO+zHKkuakp4GNsUNucg0REvOCrUIyD548Gb5l4Xsg8B9eZxh45LXiQUnHi7Lvx0WEVcLGBmTIGVoAedxGLZvYgk3b4OIaI9n+Om4PbSsu00CC4HmzyzaIXb0sPH3nvX2JC6RrHX6Xje5b6/nLrDiY595tNbS2Ik7q/XTAJYKivyM2o/I13IRib0GG+a9L+RKHu0kuY/29OsEVFi/X/r1KqkakOrF/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JqR2TAfYx31dANetN5XjKZ+Wa61mp07L4GZ+S7y5ZGo=;
 b=QbcuY0P+3mVwTwWDQ/ZntD+xS8mBpWd3981zIPIQ0Cka0zZWBcgZ3MYzh2pc54N22CCYh94C3uM8wfVCPGzZ3ZjMEUGSxX1VQ92nWCAj4UTzAr1bIL6dDpSN4O+XPb40Um8MPdpDXIJlEdXVPlb+RKy2oSk8cEz99yJVQCIZMvjn+FKOjqd2s74TDTlnMox0MQhE5GlAYXQ2eJqr8WmanLFqLx6fCXd5VU47Jeaz4ZP39Csnpe5NwxwRoxUff+fu1FnbDUq56iMsK30VY/vW11LnumlV1GHohgHXgLJW5tzggF4m0OhspyygFnzRJ7oUUZseS0EXIVp6aVY28j6/6w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL1PR12MB5061.namprd12.prod.outlook.com (2603:10b6:208:310::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 09:28:23 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 09:28:23 +0000
Date:   Thu, 26 Jan 2023 11:28:16 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        petrm@nvidia.com, simon.horman@corigine.com, aelior@marvell.com,
        manishc@marvell.com, jacob.e.keller@intel.com, gal@nvidia.com,
        yinjun.zhang@corigine.com, fei.qin@corigine.com,
        Niklas.Cassel@wdc.com
Subject: Re: [patch net-next v2 09/12] devlink: protect devlink param list by
 instance lock
Message-ID: <Y9JHsBwSzKP2XtWW@shredder>
References: <20230126075838.1643665-1-jiri@resnulli.us>
 <20230126075838.1643665-10-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126075838.1643665-10-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR08CA0119.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::21) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BL1PR12MB5061:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bcd28aa-3681-4ff8-d269-08daff7fab9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IXDC6zd4WPhTuO1jyHXJ3lh47Q8IW/DAVSWpLjL6yWQxvtnnTElyEIPUrNrwMlZZKkSoAhay0ipTKnbU7Nr25rLdsAT0EY7rn6kwcGvwSD0fwQ+nj4QgbJK0dLXdwgaCh0/djkpbx3ok3S+KSQ2eqmzFYkNsf9u+gWE5C5pECqsBrrsnbkAxLcuoyFb8B1ohATuzxClfNBCkOddVjWNDsUQMCJ/sAiQLZv6BtMeFk3ykMXqt++z6q2O7qr3R6p6Ipq5bSA84MPqsMfFKqtrEGfZUyIwcZAzB0bfhnrwyBFd+UI4miBY3NM1bFKlOWzjZNflusClut7r1lS/rRps4vdKv177Nf++MfU4DHbkiVthdhgwssHzMHjASxLdbbALk4aJyxsxUrKzTGL1TsJg3wXHy3KsoFKcbBWOG53gTf1Mfyp4KyloPP0e8asKJQBTK9iqJr+Jstcr9mTNfTRFfKa5LlwK7jj9F40thSlbRhowg9Ijvpa1P2yP8wcUk+miltm5TFs2rfEDv4Zv8eY6lc9Z7lId0Yz7NPlNeJwiQbDYeUAFFVh3SCFLcuoTFqIdYI91M2mhXp4v4M9+Eme1gl/oTvqRcRo8VB7jtg3RhtcPNEcuTdlIpacA+XJvudvHTE+Qw3bFHVY+oMKKwGCx9Yw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(366004)(396003)(346002)(376002)(136003)(39860400002)(451199018)(66556008)(66476007)(6916009)(8936002)(41300700001)(4744005)(7416002)(5660300002)(2906002)(33716001)(66946007)(8676002)(478600001)(4326008)(6486002)(38100700002)(86362001)(83380400001)(316002)(186003)(26005)(9686003)(6512007)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8EFNDHtMrlOosa2pZ6MxuYydTpt72XregJhBqPkNsdyUDPkz1FH80xd/MWR1?=
 =?us-ascii?Q?FL24niizTQOflOE/A7KoPDSws8bSSzxRVe4PEtwZBIyucQGacU/Wz498q6E3?=
 =?us-ascii?Q?pVC/5upu0owJsJQg3KibWasSfwRr7I3p5c8Ojo2px8fDlsWSH+BA5KLn4VIm?=
 =?us-ascii?Q?akuk0KW0q6XRGliM8K2mgbGv1/lX+h5u8dmdx0B2ZHIl5ATWfbPQncGLHtri?=
 =?us-ascii?Q?uhAZLQ+CcQT4C2hwZpP/VEJ4aacX5vF9xsoB7wm4DzIHb0o2CJlh0rsYZw78?=
 =?us-ascii?Q?RNfTeOAtnQxrrvJRP6fd0SZ9MhiSZ19Gg3/xKn+nlG9OAR1PjGPbcDQhggz8?=
 =?us-ascii?Q?uArS84RjLi9/P2yF2UNy15rXY78Lh+7SmT4IvtRjnqu7kh2pGHH3BoefdLQ1?=
 =?us-ascii?Q?+q/jGhP+yttuDOM9GnXzVeVcjeu4sQ7BJ3VS+S/jFWZeE8xnCpWhxk0bhGVz?=
 =?us-ascii?Q?NhL7AG4gtuy23CXZ/JOuIDFUTN1LZk48md/QC3Jix+J1Lh18dNXlH3oI6AAf?=
 =?us-ascii?Q?3J1sX4JECroBvaIi6svMHU1CRErh6RhdwMDyScl/t/Xsgep9l+veSMpPPORa?=
 =?us-ascii?Q?T4AXYwFp/iXUiZGvKZ+FmLRFYi4WxYZhJHfc9YB/4k/O9yHwVHW1/fd7k22E?=
 =?us-ascii?Q?vdHxYmuDhI7NIX/E9sQgA9nlOVPntWzqSJ/eNKPfgbpIpryYIGR9dzNKzzfH?=
 =?us-ascii?Q?yFN+vPfY+avFgdVXJ6PIxFtpMriD137QUTQkFbgSsoSD7Bkxa1cfmHriYWYB?=
 =?us-ascii?Q?ai4e5ZJSL4JAI1+UxtbURCDvxFlMTZ6PXHHnWHsFjChhwnLDHbFfYD8+VA2m?=
 =?us-ascii?Q?KU3kbiAAqiPYEh0ULrgo/kVwgnw4hCCGSmrPTlzgHAxd/2Eb4KSD0BOb/VlE?=
 =?us-ascii?Q?N21U5WjD7rCGi99u73jY5iVb/0MChvynGDxW7YhFETPlflFgmdWIOvoZHSO+?=
 =?us-ascii?Q?WpF2TEQnceryGJzH7XO0wFyNZWpQqSpo2sN+Y5g3AjFw+eSYGGM7awfgRcyP?=
 =?us-ascii?Q?6CqG1MP5urZugL3bjx8TCEaNV0RJXmdVmiEE4nQQRQfmN7x63VR93FNaP7Pl?=
 =?us-ascii?Q?K+78oHgpScKiyl/3rMvhfyivM20LE2C+9WAlEy1QIfUBynuymMfFYGPkFFKI?=
 =?us-ascii?Q?nlTZoqt0uEU7jPHFJRn6hdcQ5Y4H0kO6FbqDuKnRuQvqSkAi4+zNYom/TPCQ?=
 =?us-ascii?Q?I3VDeQvNfHWRIXRDiHAbgEOmLHTr45kgBvIWl1Ruqj50yt9GdBWhWrqzzHQP?=
 =?us-ascii?Q?ubF8pzO6pseCmQyzjlf9bOcuFK8eLlrwixXRuDq0EbFqQB4SGYazqXwjRdg4?=
 =?us-ascii?Q?A4MHdQGvJLzWpIqehOd0HZblbmdZ6zfS7HAbyOEnJ/pTiuozHWKruq4ux/IR?=
 =?us-ascii?Q?TP91DEfhdmYmjIxRjRk1THr8l9RADQzX4o2g0bWexG8zf2C5Bscwha7mAWI9?=
 =?us-ascii?Q?B697qgYBmuoSon2ahEUmN0RVWfzAiWVmKwq0d/hu70N2sLZFZDmsNl+ElQ8e?=
 =?us-ascii?Q?Kx23kp/5dn0utMTtBRkhg2cnFnXPwTDoJ0Vq5n+fd7q7alvS/7MJ5b68YbNI?=
 =?us-ascii?Q?/mtbN5rBK2BXAYDejN7zqAeGOL/n/DeqbJx4allG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bcd28aa-3681-4ff8-d269-08daff7fab9c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 09:28:23.3332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SNoU7NyY6WMszSaAmqHVhtmb1VQX8HG7Q83CDZVx5/oHjr3CxmyPVhA+eo27YJdFCTVT+x3rAVi7bMwNjSQvLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5061
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 08:58:35AM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Commit 1d18bb1a4ddd ("devlink: allow registering parameters after
> the instance") as the subject implies introduced possibility to register
> devlink params even for already registered devlink instance. This is a
> bit problematic, as the consistency or params list was originally
> secured by the fact it is static during devlink lifetime. So in order to
> protect the params list, take devlink instance lock during the params
> operations. Introduce unlocked function variants and use them in drivers
> in locked context. Put lock assertions to appropriate places.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
