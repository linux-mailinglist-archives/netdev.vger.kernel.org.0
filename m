Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574506CD929
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 14:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjC2MMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 08:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjC2MMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 08:12:54 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2134.outbound.protection.outlook.com [40.107.93.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A587119A9;
        Wed, 29 Mar 2023 05:12:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K17OB9fKJFJ9NQzKdVGP1biZt2NpRCQmv6mmH2NXH5P6JbE6I7RGyB8wWq53vmXyVHX16cZZKlEocqRN8PEhrkHq2BGGS/kLsKfM43Stei1gnPUdsk11Lk+rGHdoF/KBAHB+ZYs143hgQhBKyNzdKVwDRyN/dEqbhZTj7nzAOBrkZg09u0n64qMYdSq4AquDO8TEtoTMNSnY8mtvGGcZdl3Xk1Rg1COtext4/FgBEb6C/Iy9RruHuNIqnty7mg/GbuBMGnrklK8AOtyBtsPG5YPR73FFY5w5tfayqtpvYWtmmrlhrD4t+HdHX4Z5NeBU8bO1ffs3U/9oS0Oac/OkwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wZHnGdGSKkyHgvAJs6xgLket3Ji03AUXA88rO3geSv4=;
 b=IVDuNzmc7BGuDsuorc0gYBCCUJLS50QcVUG9PBXwr0+t/hl62hJd888qLbYcl0FFOqa7fgHjoIqhDn5R6++PyJkKxkh/k7dGotIH0v7A4M4kfjw/bcf5ZfnAA232INJJ9nwb6P5+3rwkqRSxn0WtRRHn+FzCA79bmLlkpgo+dGLYuzX5HJIG+2bC9Z85i4jhSLZd5RrM3FzBAnqR7S77K0g393IlSJTO4+WJdGObh1fVrEHr2MUJpuDeUGMtJZhEJ5AOELbfyROG5i59x6iHU6GyWLTwsTLGG39Y4FpKgbW7wiFPM5KpyNMMQ9eJ2K8En+bdXJiEtjdD8HEPvicgkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZHnGdGSKkyHgvAJs6xgLket3Ji03AUXA88rO3geSv4=;
 b=pgEzngkB0Mq/WRSzb3HofQAzohl0NT6OqPvdhHSbBYOiAnsbG4pghWWEr/bH/txioPnJb+IQuni7USaKIhZZY2+Ea9catvA0xlpsa9/da+KjDSrp1NGk8lE0U/CPpuXI2vDPEGax4eImhW2sWQHScNVpDAWgRUmEQOXcOhtdARo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5950.namprd13.prod.outlook.com (2603:10b6:510:169::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Wed, 29 Mar
 2023 12:12:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Wed, 29 Mar 2023
 12:12:48 +0000
Date:   Wed, 29 Mar 2023 14:12:41 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com, drivers@pensando.io
Subject: Re: [PATCH v6 vfio 1/7] vfio: Commonize combine_ranges for use in
 other VFIO drivers
Message-ID: <ZCQrOeX8WtQplYdZ@corigine.com>
References: <20230327200553.13951-1-brett.creeley@amd.com>
 <20230327200553.13951-2-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327200553.13951-2-brett.creeley@amd.com>
X-ClientProxiedBy: AS4P195CA0019.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5950:EE_
X-MS-Office365-Filtering-Correlation-Id: 14d2cda5-7f07-4a5b-ce6e-08db304ee902
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UkhbYa/bIF6RvFMf6UQauAXkmXR+zA5kXri+eMXcrH2NN0U+7CThFDccy2lGmfmNfpJpL3ywAbyysKbrj1iJ/n2l7lfw/e/ubHZKeW3XneeDRf1PTaZRfnYecusLL3CCKrwVZqEpbSHhUynJlxv8Al3MtymsogC3KdrLcHR7D1BvojusyhhonAo6tBNUMtekwbHKZ0kizZtVgYl6+bM6TQomBN738ihG+e3HQySj5lq9pAo8GKQpDOgLASGIY6u0MhZrbGVysdKh6ZlHv9JplKT7wWhkDV9ngXMyZATevuWKIFdVpzQl8p3e/Oh/qB7oPQ+/tS/dP4ooT/2gA/NUPU0s0slGb3FobNxy2mUjx2Kkm/YqQwKp3jBG1IqEOuNmWF+IPGr6q4tn1BmUDVFjCuwmENt3G0IYd4Bf+50a+yEuwwQoBeinTiewuwYJ47pPD59EhJIwh9/SbPHYfQZX2z++Xecc7gyH2yi8GEQHzki7MtgaA0Yl9ePxl3eDWTc/XqmU0bmcjtd/FSiKWDFVhWqEhP+/Tt/s/wQi/vXb95d5W1Qk2Rc3lRHVwdWon3K5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(376002)(346002)(39840400004)(451199021)(316002)(41300700001)(66556008)(36756003)(83380400001)(2906002)(8936002)(66946007)(8676002)(6506007)(86362001)(6916009)(2616005)(6512007)(66476007)(38100700002)(186003)(4326008)(478600001)(6486002)(6666004)(5660300002)(7416002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LF79pm4gETSnLe4UU0F7BgxpGw/SBzVdIKDvuzCsEtcQ+wq7N01Frxv8XQlM?=
 =?us-ascii?Q?e1w8WjOPBqTH0AzdjL/ravQmrbqbTYOXQcjZmSWmq8lVy5be7ckzufsScYtn?=
 =?us-ascii?Q?bgYJU/CIVqGYd/hhR7hxMUgbKW+FqckyJb3hSG0cC+35/4YJmqdzDRFABiE/?=
 =?us-ascii?Q?JZBh0WLusGJJmbBjXko23J27Zv4xH2tr2JueoPBEJez2HGWj2/5xKX6/PWgm?=
 =?us-ascii?Q?4zENLTyrYGXZaZFKiTyVUpWL/yLCMObdaPzCSmdcUspqpwliVk0LLoSnar/U?=
 =?us-ascii?Q?+Bx1zlAxSkhSYporqOwSI/pvglIVJ8VAQZICVFEiXfQrEt/46+mXIEBzExRi?=
 =?us-ascii?Q?CEsTstKPgO+7FEB38COHHxdI4uTroo3UnnB4P8OQOFhVY751WGLFNOhjIT03?=
 =?us-ascii?Q?noaXlxmiMaDQvFyr3zPHhsv9qZTo6U+ijJvcWjAGgYnCJOWNpucRN4p/OCaK?=
 =?us-ascii?Q?FuPORPLrrfAudKjywBXXRSd1ATqpTi332Lbwk3eUGnAyovNGjGJq+1UirVLo?=
 =?us-ascii?Q?Ow/j6UAyIGHG02oFiTns4e5snd1+PBOnitMh5uFFwxiN2dl8d4BwOMRnOxTR?=
 =?us-ascii?Q?O2KYxE7PsD5fHhJeW4QlSUIWIjRRIaBsFB5ONvQ/E3OCVQgWA6DS/TubdwR4?=
 =?us-ascii?Q?+O55pGLUEQwkqVKzXfA3nh4De3zHzsx625LOBLsYa3w1GA88Ik0DJx6nK3n1?=
 =?us-ascii?Q?X7nQ7GbWym0ZfwhPMH6RMwW6W5YMjv85GE13pIoJYnOdvQ3XIMTLs8vYdo36?=
 =?us-ascii?Q?6fXKlEXnChm6lI+Ku3hA7zblcAGPFVl0MZ0BKIVyi4fVy7irMa9rio18DbbO?=
 =?us-ascii?Q?5rp8qCpqEv2TkZtARfVLd4U1m/ZiYqQwVJ6XAVU+CCXOhQRQSTE9eJ61ldVh?=
 =?us-ascii?Q?H8BzX2rdqV7WGCkIJUTRR9EtIsD+s+VPOBK6sfU1iwc5NjO4Icfz+cX3RX6U?=
 =?us-ascii?Q?9MD/yEDW+rAe5x/7D1B9ADOC9E0HsKiKofYcZtPwnpjZ1kPveN6fPuicsEws?=
 =?us-ascii?Q?lza0DW74KLbhd6DDxsvU15Jfdiz4MUO4t3I2xbypQ66cLXjtPTGyLoMA/ANq?=
 =?us-ascii?Q?TEhqzvT2s71NW36Go+KH10Shl5C3HtnNXxPwg+K33uDnQ3N7PeO+GuVjw38e?=
 =?us-ascii?Q?350v7ffKNhj+bNYVBHQWxHYiPCVUK2ixKzuTspiplLI1Wkq2afBl45vndk4X?=
 =?us-ascii?Q?oNFgqTRwWnxYUjsYbSaQms56+CbEz1vIh/s9Kh0yNujAjMtEr4uKGxF67PNY?=
 =?us-ascii?Q?uN4CiKwds8FSlG9J793bGqbBK/692MCHCQqqrrD0Se/ZNOF9b6KIWLfywojh?=
 =?us-ascii?Q?6WphJUM4MwPD1jpvKdZrUaJvsROO5+g4Otlqpw8Ky7NTUBcQzoZuZ+TXgBiH?=
 =?us-ascii?Q?5Miux2BBkkgRRPfvkSIU5e7KC1ywWBmBRkzc1uDvs+jqXuz3tPqAi8ZlblIC?=
 =?us-ascii?Q?3foGKd7j+s3cLb46PtYJTrEFzk9fBpR+OVqreiFDjh7FcDOleuzKMTbT7d0h?=
 =?us-ascii?Q?131cHK+vKSeAES/iGclX5LxBMX5lS5OrwJc1iK2O8hUsjX0ZwbrJ04oGiTD6?=
 =?us-ascii?Q?v3Floofq/EklL0EwE1HcxmovgpTLCXvI/iev3nd0lH0u7rhMFc85sQZ3Q49X?=
 =?us-ascii?Q?TDDxwY+EhgDMdSOilRyzLk8vhC7nqUoQB8HTY+l8QBCRzz+wVbvPxmcajgxm?=
 =?us-ascii?Q?7kQNRg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14d2cda5-7f07-4a5b-ce6e-08db304ee902
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 12:12:48.3882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nivh2NtVyU7PyChLcGa8d5SvrnvPGlbtTUbhIOhUoxN1In9KxtOyMVmSOeyq5zw+/i6XVwi6QNBVQOg5yxYJFCZKhXe+BCFFc/T9/vY8QNo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5950
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 01:05:47PM -0700, Brett Creeley wrote:
> Currently only Mellanox uses the combine_ranges function. The
> new pds_vfio driver also needs this function. So, move it to
> a common location for other vendor drivers to use.
> 
> Cc: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 43bd6b76e2b6..49f37c1b4932 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -864,6 +864,54 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
>  	return 0;
>  }
>  
> +void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
> +			      u32 req_nodes)
> +{
> +	struct interval_tree_node *prev, *curr, *comb_start, *comb_end;
> +	unsigned long min_gap;
> +	unsigned long curr_gap;

I appreciate that this is just moving code from one place to another.
But if you end up respining this series for another reason
you may want to consider rearranging the above two lines so they are in
reverse xmas tree order - longest to shortest.

...
