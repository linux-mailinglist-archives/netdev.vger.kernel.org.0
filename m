Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648DE68DD2E
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 16:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbjBGPhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 10:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbjBGPhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 10:37:52 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2132.outbound.protection.outlook.com [40.107.94.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3345FEF;
        Tue,  7 Feb 2023 07:37:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZ3XYxWlvT6HLnfPeMM/W1NizPOVTQzJl1F/lX7gxmhpt7yikubFgW3hDpL1+QmXimgdgStlSo00Yr6nDKPEcXOxQQBcDC2KI3Bj1VEiBv1OU7WDXnNlP0oo/97tcIXEypMwqjucnc1BMO7J3Gbk6p5wvlKtP1Bheeryesavr2H0qsgcwKK8R6DjcOJq2uBsqBSo/+41ctldzcBmrDJscsAAqmnCIu1NT9guP7SL20WMw1MWZH5j3K7oQWA6ygwrO2E4v412q7ASwwN2DK8dJ4xcL1LX5qwMIqzBWpsCrBkmu+nGw/s4e/BLCnE2NZpIMzA/QypvVQ2xxjejWtG9UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZW5bMRtTUsLJR6IlQAx8h1wujueAHo0/qrjcacDp8jc=;
 b=HFAAlv9aEPcoQmioV52zBJMWXvFyll5dGMNZxxDvZAIQbZoq0nvk8ND0Yz+Zc/+Znun0gSaMlskxFlBfKbO7TZLrGeMz2uNbwRyGDbbAHGvtdt3p4pYPS61G2yivw4cJVGEbutDFlfcJAOVnLsDKzgJUz0tyzZdc3ctv5xN9wpWYw5nPZYESzRlvvY8n/dguwEQr7pcuWryLkCGrpH9hkBjgs3Ws/Te5tkL5Syo7XRUaHvNIhxUNiJVIN/z9qYvYy2zvnD/y1X/OEzmIqxlT5a9XgvTX5nZ2+y5Kh/YMYH02H+EX6YkaRyFZ4fymp4pSclhelDKGZdW00y8w79/9ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZW5bMRtTUsLJR6IlQAx8h1wujueAHo0/qrjcacDp8jc=;
 b=ZIKZfKxu5g2Xf70cG7SvCVNDBfriE7d/N9jNojyzt9v0cHBfSsyJwsFuWDDJrmWgoULl6s9BoSjYQHBiOns2w/ZEut0xc62Srj3Tzq4Xi+Rpf7RJ+O8P//ZB15BK5TGPp0tUKiZsmS1djnE9RNm1buiuAe5yX8QX/xtbnz/PKiU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5242.namprd13.prod.outlook.com (2603:10b6:208:345::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 15:37:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 15:37:41 +0000
Date:   Tue, 7 Feb 2023 16:37:35 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Jules Irenge <jbi.octave@gmail.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH net-next 3/4] s390/qeth: Convert sysfs sprintf to
 sysfs_emit
Message-ID: <Y+JwP3HuNakOeifm@corigine.com>
References: <20230206172754.980062-1-wintera@linux.ibm.com>
 <20230206172754.980062-4-wintera@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206172754.980062-4-wintera@linux.ibm.com>
X-ClientProxiedBy: AM4PR0302CA0032.eurprd03.prod.outlook.com
 (2603:10a6:205:2::45) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5242:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e8c7992-9537-4555-0345-08db09214016
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7aAV1AB7B6PyyENr7Kr7lrPXN9XwAfKiTnF0beSbCyOpJ4nzx7f9NkkVyEM7eQC+k6yVyA3uoDlMcr9YvEt5X+YtMqsv/NOFbbqTMpYfFomOS3Z5PqKVlG36XnZpHT1aLStY2W6eb4VyCFFVIqrlwqB8C+JHodieUZC/UBim+y4gQHd36CPxdKUWzMTvCaL+jDeBD/QZhUhUMK8BrRD58Ueu9nBRQeaPEMhzVUxa7jpD/b5u3uOZy16dz47fELQZTviyTAnJptTJOCM3Il5XWv1bGmheVrBMQZHK5/livhoSeQJme1AfwaBoH2Gnq6GhZM+YyYdHPrndpF3bFS2hUacO9peN+4y8tfAPvw0TW3Bqzri6VOgqfsWQ2yzz9yboMheYS8cgFatvdEG4bP+kcZPIB5FXf6hhPpYYv3XijfQVe6rdx7P3+gCoHkG+HQC3qlewc2RMLJLCdWAmPeLKW4HKhU+TNmATelH8r+Xo2hKp4bIaV26+jlEJH0mZLrc8yHDIhjSFXB/IUGmMQL6rLJXuQHf1HCzA51RQUV8YBoc5bzYcB040vfX8fTVWKNAeIS9HaODHJrnIWhe5bVnDimZXomKFee8cYCzPRHwMnHG2RD5/1liM6GTyLZkU2WOWYlzPxYlGC2aSFVZ8lw+FA27yUpbccUlXZdxVUEUoR7XaJftNHq/qzLvqNlhITzvHZJXm7o6DCI1b2ONvWczWnHM1jNJIN6NHtMRXo0ngZJA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(396003)(136003)(366004)(376002)(346002)(451199018)(6512007)(36756003)(6486002)(6666004)(54906003)(4744005)(6506007)(8676002)(478600001)(44832011)(66556008)(5660300002)(2906002)(8936002)(66476007)(41300700001)(6916009)(4326008)(38100700002)(66946007)(316002)(186003)(2616005)(86362001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?diFl6NndGATjhRyAnYPHRhsJvmjpzQOS0gJ+fIaF1QorLeZW5fh1lrFCZK0K?=
 =?us-ascii?Q?RGf4thNlD4Xrb4J5G5FigoBVdAqpcYi6t3Kc6uTTaZFMRtSCLVd8lPUX0kr1?=
 =?us-ascii?Q?7clXGaduzgcIwgbWsUcc+qCVTuYWNePO4cL8WTEYFTxvnjVIyLcSHqCcJAJw?=
 =?us-ascii?Q?2HgtJNcIQZnr/ZySg+Zk6bYsbCfsVFbDfAWWFwSxvb6QTpRgTkO/Mdl7ykkI?=
 =?us-ascii?Q?Uy9SuXsZVS6EZWVy0j/67WpP05KivrSIHrp9GomvqCTRA0TN9TLePuImtNM1?=
 =?us-ascii?Q?zfwmOg+vTD0WzHzFbCcz5xr8UghE/pu+G818RY3M6m/3L00kgPZk8Glre3O9?=
 =?us-ascii?Q?RY0tad5NS7crN0SFZmdEhYR4t4wuNxbPQnHXD3PBokbDpWd2WMdgK1o2YL5x?=
 =?us-ascii?Q?15bi2DftUiqqHyWLiHAHhozdXflG8NCg7MCD0EpVr71BBCN/i95YuVUUFnyW?=
 =?us-ascii?Q?gViMwLAoaDfqoBP7u+dKGKeeIQz6xnHWHpGSXvBx7M4peRatE2nhB9pEPqUY?=
 =?us-ascii?Q?DybWs50ty54MfMirYwMnqV+4gSE+1y+gkY1+k+pEirn6XOQmHDu5znNamst9?=
 =?us-ascii?Q?zvhJeGgXnt+bDlExNQHyMK1XJ2+SCM3TEaxhzV+AcMB4LuBNYKWNJRRRcLq9?=
 =?us-ascii?Q?Y9clzlol/L+EKKPsgsFIq+xuwrBbz0ihoc+5KE/yIVcJfBJKfTNTon3cztaq?=
 =?us-ascii?Q?16pYLumhsNtAUL9JNL7Ue9KNSpt6W1kaMbiXgGkMlQewWceQuQB7n9nbXLUi?=
 =?us-ascii?Q?oh3gEeJnKD+7F4HQBbQRxhLx4KmN7AdeqNjQXgi/6dgwGtGQTrVt5LyhH1AZ?=
 =?us-ascii?Q?fu0EKgVoeM0erh7/INErZvgkhgbGxN7fyuef+3llsIV0fGLO5aI/+U7cPmNl?=
 =?us-ascii?Q?EP1gTr7R08V2gFyL45A7R0ckx3OGFwxu2tiIhE3zlbA/IygNavzlEepUw08H?=
 =?us-ascii?Q?PcP9aFq73+Qt96Ee8ZoaLXQLr63s20BrFNiNS8OvuHOlv/4u/BfnPNGsnxsc?=
 =?us-ascii?Q?XrHZYolqCAyNk8YxNCpa4YNhVKez+BBOAfSzPeZywMV2KVeEqSaDW8ukMG5D?=
 =?us-ascii?Q?RZRpTAD5L1JzwxO9A6+ELywT7nXWGyz+DYAtiBEFqgUpihCJTmaerzkGsQrR?=
 =?us-ascii?Q?cb+SwPQwcZz/bSLYVXnkqU1BXZGkpqxqufhMvw7SffteY/YCeW+Y5sEjC1kN?=
 =?us-ascii?Q?JK/4S59b3S8fr/bfdHD9myhPM73ggvLrZ2eU1g7twM2999QWw8DTTPppSgGP?=
 =?us-ascii?Q?H7pRmEyIKIIxKvZF1q6tcJw1Uj4vKDRJEJ5g9XfPL9+oUC0oW9AxqCic4ZvU?=
 =?us-ascii?Q?xr9QdYD/CZDSPYzwLAhlKLngRiBQUkTBW8n4vA3PvlfpJ17AY+e8bnR6mHvX?=
 =?us-ascii?Q?5DSqb6fE6tdGB3zgdkmDPjkyVNRxDtQr78eK40Ne0mslz5rmvcpq5i75vqdp?=
 =?us-ascii?Q?c1GpH6ONzUyfbqdvBnhPzHGkQPrhjXtXQiES83YeUyY86dArdkqg6Jzzuvvd?=
 =?us-ascii?Q?550jtpIQOYcZi51PlOilJ3zTOit+hPB4EnIi9qEFsmP0iYLj6MG8ks6Kdkdk?=
 =?us-ascii?Q?TCPvWaymmNtUQ85k9AbSQ22h8sbMXG+RH6dx4xIFuj2Fy0tDyQ2ep8c9M5RP?=
 =?us-ascii?Q?c3HGPYvxF2kzMAvaalpTWB8NRpgbSpWsxXr2NpHjbuW38DM8BJPiAnTf/6MD?=
 =?us-ascii?Q?b3ywqQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e8c7992-9537-4555-0345-08db09214016
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 15:37:41.8687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oNp5i+ayWudWUjD3GdbNcw7XQDGa3WsVo/xNBmTmg5bdCuPi5wJN4Xid4Vj25FZ5Bfremi5cvD0G4lyBnoZrSrFsimPb7Cl0k1q3UQC5AGM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5242
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 06:27:53PM +0100, Alexandra Winter wrote:
> From: Thorsten Winkler <twinkler@linux.ibm.com>
> 
> Following the advice of the Documentation/filesystems/sysfs.rst.
> All sysfs related show()-functions should only use sysfs_emit() or
> sysfs_emit_at() when formatting the value to be returned to user space.
> 
> Reported-by: Jules Irenge <jbi.octave@gmail.com>
> Reported-by: Joe Perches <joe@perches.com>
> Reviewed-by: Alexandra Winkler <wintera@linux.ibm.com>

s/Winkler/Winter/ ?

> Signed-off-by: Thorsten Winkler <twinkler@linux.ibm.com>
> Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>

Code changes look good to me.
