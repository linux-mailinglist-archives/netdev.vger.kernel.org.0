Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783AE54E8AF
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 19:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbiFPRei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 13:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiFPReg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 13:34:36 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994812EA3D
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 10:34:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nOmDrxWuslGssjaCjMEg6X2FCO5qkAkkM1Ez2DUHwHP/yknjFgb67Jchk4FWU+dLF8Yhr7wrNs4BLOj1Nw5jAmBe+l5EKEpXyFcFvcYK9Ds8SUBALjM8SD1sILFaQxnDhylLmdMf9/m0KO2OwHrxjobBOEWkraQNVAUx55PuzVkvQ9eBpJSsfsUlwyFTO1hm6NqYgjKqy4qpThMTfZ0kuXKrOWbQmCNZPel1VdTmtHDjYSnLbTeE2Dea7yq3hXnrYPCrvKZUXNg4d/yD53e7GErMKlo9/fra7eyAqusTTdpqchNmGe/UL+zR4zE4Xt12A/42M2DugJYVWBJR2eLKjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3wrNy1Df2RPoeezOGZxzcLdKPU+fO5XYPAKPN0msVAQ=;
 b=fpC/5Dkom+jpn846w8+TkIpmcjtGOC9PdqxZ/LuDU8ftY/5kznf3K6NELj6GyX7uR2A674w4/zFk1ePo2A6xHVJ+5XitnZWImQ439ERsKn3GZ1+3dBt5qdxqQOtjG88iPawvi06TF2nhlqU/5gwyvPVCgDgPccmyBJdycreBXmIvpQIVNqrmHkFB9eVq7hxdSbx7W4oiTflO0YIuBK5+fgt0HuDcfBg6Uz/wouvrykZq0Y5w19g1IooTb7kSd+85A6ofhPP5QpXGPOi4pbtIixcS35oN0CF1AC/yQnX2w3bzXaLcEKIgVmL0CGJy13v6V3sdd20ZmggZI232t+Pxiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3wrNy1Df2RPoeezOGZxzcLdKPU+fO5XYPAKPN0msVAQ=;
 b=V7aOdRKIjXf3nueU/HjOvhKW1W7EcI4qhG9p0Rk+g0pcZfpdcKuCT5XrwLPQeIrMhVzx5d2NPUzXt7UFN2HpkW0Lcf/wxyv0BQ/N0IvkRORR02OPwyn+eycV5qFvzRGIaJeu3cfw82sxCZDGR5nlno9EwLG4tc7/PLHEFuG6GcaZQNjpkgJN4recS92WD3Zto3lMu/o9nze0VU/1qz88Ap2vu3AkiDhDpgzXe/EtE+MNvS+2piE2WRjfBLbxPriWB1tKg+Dl+Tt2axwqRGaYnlvi4Q3geWECQ3GI2wm1yPUX+e2MA/tk6+JPhg0HECeSfPcCXrk+ihhXipTj/bc38g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN6PR12MB1905.namprd12.prod.outlook.com (2603:10b6:404:fe::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Thu, 16 Jun
 2022 17:34:33 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 17:34:33 +0000
Date:   Thu, 16 Jun 2022 20:34:15 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        Daniel Juarez <djuarezg@cern.ch>
Subject: Re: [PATCH ethtool] sff-8079/8472: Fix missing sff-8472 output in
 netlink path
Message-ID: <Yqtpl+DLpH/YDnxy@shredder>
References: <20220616155009.3609572-1-ivecera@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616155009.3609572-1-ivecera@redhat.com>
X-ClientProxiedBy: VI1PR0502CA0009.eurprd05.prod.outlook.com
 (2603:10a6:803:1::22) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5b7df94-3daf-423d-d6ea-08da4fbe798c
X-MS-TrafficTypeDiagnostic: BN6PR12MB1905:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB19058539FE41549DFB75F4E1B2AC9@BN6PR12MB1905.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o7lB70knzMeZ52PFFKVH0CipMVrp+IPw1FmGXf1Ejd+g2kV+4o8Uhs7mutiW7sFQzKOO6uudemwGxaN2fOB0CMLz20t1SnufMbDuCNplkX4cAdveLpepWhMfe9ZXdAM9DdrNICrpijEGeKHHiq8h1oUrHLxgHS93r+xYEB8mnm8eFlCL16OAhxeqrT3eC8r1Ip7j9+NfDOkqD/zpBkMcaf64xdVYxaEz9KcJeTAw3m0xyH7E5Kjx4PRujc8KClCCxf6TpepOmW4xXgM00+w05PmTJO+MPItqsnSsSxKNcgFAd2gcd+2uDnkN6xZ083/37r5UNgJUkwr5PzTQ+2Oq0K3zrQ/7jK2s6VbzMmTWxBynQiGbMxZWcJQWd3jN8xhZeg5aPgKHVwi5QKEzFwU0ooSNAvovrlhC60PGZZjS1RPuk3sEbloOHIFZMjQHbWKy+D6jvM1gloH43JsjO4QwOogFaBMBO62Y95t/6ZwCaLnlsRWWUWD7RpDfq4SjkzQPLQq5zIsTRJtueva6wYELNDmCTNTrSAAW/bRduHVqJuRBZxbA/C14DSUXc5QJ4kea4pzmdc537iLvqFIKVSAmonPJONgXDRElyifBrJ7Yemf/dfjA15/hEL0qtU5AXHBTBFEv/l0bfOSwHBAKSoRiFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(186003)(6666004)(66946007)(26005)(9686003)(86362001)(6506007)(6512007)(38100700002)(4326008)(6486002)(5660300002)(498600001)(33716001)(8936002)(8676002)(2906002)(6916009)(316002)(54906003)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yx0KatV+t+kbaDPSAefZ47xvy/uRinwSsDqwOhWqnZpplV5Cxruu9EsKi88X?=
 =?us-ascii?Q?sPQuyYuEiHHqU6Kmr5tjJZkOTjHw8s2peq3kfJm0s14crIpbzlUx7bSV3kew?=
 =?us-ascii?Q?orjHuafDRNsgdzo84sW/kPumCAaIYqni77nJ+cLe+n0tgaHMX5ubvusB+GbG?=
 =?us-ascii?Q?D3h/QtH2HRIgvq7uHv6YYV9h/5WL8/pFP5kffVsjRbJB6cdu9az6BauCZNKt?=
 =?us-ascii?Q?QXegPh1WiixJzSUcx6HBweh0wnciaFsm6SqbYF/4I0bm1t8RLjOaxoQUjigF?=
 =?us-ascii?Q?bjxLgceP27slWMIxHYs4Wtjub/aErHh7IVU0RtoT/YGWyW6BFyUvEdmYd6fQ?=
 =?us-ascii?Q?3rnHvICp9sw0hocdC/MLTux4lneIAM1zEy7UFlw1AXPDHUmDG4WNtyAuFaCy?=
 =?us-ascii?Q?ZflIfkRnlbJWlyGhh401smxhdb2QA3RjCwcaHjJlS9eybQYFRfmOrLnYDzn/?=
 =?us-ascii?Q?IXlULYOb8Ym9z3gd04IVjk/IuK03QOSSUVs7RHxCW5uDuvt6bSuh4cdErcVJ?=
 =?us-ascii?Q?gF7WfC0ytEBQsY297mQ+bkPbv/j1FDW4I7Z8W72XK4nswyUJgLfmGvQbLl87?=
 =?us-ascii?Q?6Xm9k/h6XhGAoPnCK1JuWY6KeHyHC4k3Tp3acJb1WzHQqBPgCLMZMBh47vmy?=
 =?us-ascii?Q?2Rx+pBFWsAEi20zsQ6j6jbBI+XmCkrev2gxy0IbmwWgLWOTlRDUYgJzEdII9?=
 =?us-ascii?Q?O5nA1txBt4r/SKL+PDUhFi1bmlBOv7ENCd5+O2f6ZBbFoB/7Q68/TNax1DFl?=
 =?us-ascii?Q?IqYpK7Z2NtTkp0GLcbacRuiCAePGEeCoDALYMfiz/ww6uoceJL3gPf9Nrjvi?=
 =?us-ascii?Q?HxZpxDw+k1uMyPPZNXMwoNS3cwirgdkRNaPG0s/7Ty+nRH0gUmmYmd82W4YZ?=
 =?us-ascii?Q?BvL3cnCg/B77avA9DDIlEX/pu2RARq/F2uEgHz8mdv61ukHArGWwUKdZwroY?=
 =?us-ascii?Q?bAqM5YZy/9Ta0s/12YhAJBhnNlxJ+W1a2TYwIEOQgPcl5MPYVZnk8FuzwNct?=
 =?us-ascii?Q?JfXx+k7xxlprLXNJKUBoxv6ZhN5XVDBy6fw7uN2nf7OOd4hgFHIlsZOATsvY?=
 =?us-ascii?Q?mXXbbWyb14nGHo//D3+XSz/Tgvw2Ke+6SaVAdghd8XwhT7hPkwNRPJ5IfSyj?=
 =?us-ascii?Q?P9lP8tJ8LJZRclHc+xXekIZA1TTND1EbAr63+sA5eBCDrd04THoosgWVJkJC?=
 =?us-ascii?Q?DG8YCKSsJL/W36Z7IeJq4kVOfv6a77vzx9mpnzfWTf3xQb/nLphVBu79tzR8?=
 =?us-ascii?Q?m04tHOUSuKXbqNoExyDRlJiaTcquuZ3XLrd5Fmm+j3oPaF5mKwI3Y1p1zY5S?=
 =?us-ascii?Q?YImQQOMLHCM2nDk4M2xaS59EilVL8fV+EZpWU/MI1zEMiTamFRHXWZXMuHfs?=
 =?us-ascii?Q?w00dcJJUAzfCnB2Y3ffQCMjUerM1Purr+PDVx71bneocX7GUkzsCf2bgHaRK?=
 =?us-ascii?Q?O34uQREMjtI+2houpCtk/UTq2i0qDt/YhfNwkq0tfgPngjhbUs3oPrgSpyXI?=
 =?us-ascii?Q?HIaZDcFIQdS9Qm77b6pJ5IdvOy7fUKoRzTSRnLEYuxy2Y+T+FGg4Wc/Uay3l?=
 =?us-ascii?Q?xO5E8HtnHdv1dbZpokdv3tiFLbfUkaxO+P3SXSrRyalVGpjMWVTPFXOJmQer?=
 =?us-ascii?Q?EJJtwRgznrR3h0efd9YSJ3Kf/Qzo/p65hHMFd4vZlHoCwt37us3UzVOBHGjS?=
 =?us-ascii?Q?4N5wcg12828GCbUp0mga5eI5vfks9UxnyzymjSfVBCWVfKx+7+lsTvxOF0+6?=
 =?us-ascii?Q?M713UcJoAg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5b7df94-3daf-423d-d6ea-08da4fbe798c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 17:34:32.9562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m/DeigAMmSgCCkeQb6j1/dT3SB/MZ+GWjncugYpDJJqp5kvVRhnHPoUNRqM+CuEbxrMfXy7GcksC1uBse7iiZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1905
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FORGED_SPF_HELO,PP_MIME_FAKE_ASCII_TEXT,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 05:50:09PM +0200, Ivan Vecera wrote:
> Commit 5b64c66f58d ("ethtool: Add netlink handler for
> getmodule (-m)") provided a netlink variant for getmodule
> but also introduced a regression as netlink output is different
> from ioctl output that provides information from A2h page
> via sff8472_show_all().
> 
> To fix this the netlink path should check a presence of A2h page
> by value of bit 6 in byte 92 of page A0h and if it is set then
> get A2h page and call sff8472_show_all().
> 
> Fixes: 5b64c66f58d ("ethtool: Add netlink handler for getmodule (-m)")
> Tested-by: Daniel Juarez <djuarezg@cern.ch>
> Co-authored-by: Ido Schimmel <idosch@nvidia.com>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>

With Michal's comment:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>

Tested with both netlink and ioctl, but only with SFP modules that lack
diagnostic information, as I don't have these at hand.

Michal, note that for ethtool-next we plan to get rid of sfpdiag.c and
fold it into sfpid.c, so that the latter will be able to handle both
SFF-8079 and SFF-8472 using the same memory map. We felt that it's too
big of a change for the main branch.
