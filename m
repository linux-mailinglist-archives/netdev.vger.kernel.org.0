Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26FD96DC419
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 10:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjDJIAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 04:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDJIAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 04:00:23 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2093.outbound.protection.outlook.com [40.107.237.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009F93593;
        Mon, 10 Apr 2023 01:00:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XWlzAhcA23fpPF0MvTbneSLpPiePxoBsvrdEYsddAakmqgFmYPGnvYM7fYWNk2q4xxY+RRJ618Kbwzt/Jh+WgydhStL4qOjFnRPKwEo4tR1hlhdAxbfMwCsRlC7h3ndr5xTpQcZRPWgOtkvmceeMSk7kUvSKE6rnHPn4TXPOa1nUA86YUouu3mAa+/f7UUn0Gkp6paHqJZWrRwiZe2qQIzmtYTsWviEfAbsH+sYLIsrsRYfi8xOSl/abDPiQ2PUrikYGU79E31KxelttQ0P52+J0Iph4fBU8VUH043x4GbER7/HGumQ4olEwkzhHAT4gRdjERPfPDL8HUNhWUL5a6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HV1YoNxsGLot80a7fApvRuyimtuKqvUJrAnir49xfqs=;
 b=mA3WWDmmQGl/MMzpYqjVFHXyTrTtwtrd1XgwNrOPuU2aJMZi8blfTqm+xzBAzlVBLWqqrOKFLDkOviYQF2XaxE1f24eqLl3T6v+oPMwkSVkWe8I+KCvtvvwaK8JxonH1WUgH2TvPizlNwi5wEhfDC2n/Hz11nSumIz970d4oCiunhAoCpPU8qNVqYMIJZALZg8CrPVqy+W9PYsADDKZz4Ds2Uh0D9oC5lzgGAp1zkkOXkTDRxKMuCNvbRvOAo3Gle5jwyCeAOXs8jmMfAm6As0Pckgwt95vt/JDAEtoeFETjGwT4v7vJbCgEQjmjb1knCJvKjPiPjL2dCRfJ2k/SGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HV1YoNxsGLot80a7fApvRuyimtuKqvUJrAnir49xfqs=;
 b=hEY+lw/v/demurxjipHwdBSwl49BBP8aFzFVUlb1EbwOeU2ikzK6bFG4AxeKf6Z0fZ/ZhVBbE5+BfUkCYuuMTgT8VsS8pe6OYyv0fvOfbiAxbHHtjuNe4z8Zxk3FoP06IQIKcg1UzKof7FNM5gqB6zNm3oMth0IzAywaN0+EdU0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5668.namprd13.prod.outlook.com (2603:10b6:510:113::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Mon, 10 Apr
 2023 08:00:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 08:00:16 +0000
Date:   Mon, 10 Apr 2023 10:00:08 +0200
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
Message-ID: <ZDPCCASKPiBEbGXM@corigine.com>
References: <20230408065607.1633970-1-harshit.m.mogalapalli@oracle.com>
 <ZDGJI8Q6lWCJdEMR@corigine.com>
 <8f47aa3a-9b71-6788-6d75-ccd96dcdb419@oracle.com>
 <ZDHA0uTelrk1BDb7@corigine.com>
 <20fc5043-71a0-0401-fbda-ade0a8192c04@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20fc5043-71a0-0401-fbda-ade0a8192c04@oracle.com>
X-ClientProxiedBy: AM0PR01CA0120.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5668:EE_
X-MS-Office365-Filtering-Correlation-Id: 95b90a2c-5f34-497f-de85-08db39999e82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pe8rHK2fG0C1yyGMwjq9l/u6iVteI2jA1iwPGQZ/2MaJ5enR1jB61Fyc+fjqjfNanEpUHA+4NuudgL9cjM3AK5Ir63uF5sLHZx9Rp5AhKyOOd82mMa9RcfZrvA72mJZ0+AP7z7JVEFjVwhwaee0bJmJUFSHVo+pc2CnqUIDUF8FdHzukaJlN6HQukK49gpG5Y+JzNnkkEINkN3GSkv7GjkCW1JQrJmE3ubabmBSE7ZPWVZWhSQprLWTDmQfZuyzCTcWDdyvjnvN16ia4XhC974H+lq1gdCLGep5mGU519d1xXdBfSsVAxpT3i+A/Npk6SOMqHqA45zqWieVsm9e2JCW81JH2SyZShoRxFz9/m2zSDB69Rf9c3fgVzhlYKSfEh2yhU/tlbodSv3/MHKfvveO8uhNfJgIIvbxi7ppCl3ya7vn95Mn7FDy/jmd+KsO5yTNNybr1UlBA/NQ7y3ayas+5gl2hcIMEhB0jqI30tjZdk/yK3CfsPI56hU0H+dbn4dLGuxVFcaUzTb4S58Yjfs0CpA3rM0kPhm4OA6ZX5B35ZBGA6PAaCuG4YIiAm3ZDkYZQylx8tfnHaajzp2jthYu1c53hais7IlKw8ao6rQI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(366004)(346002)(396003)(376002)(136003)(451199021)(478600001)(86362001)(83380400001)(36756003)(38100700002)(2616005)(6666004)(6486002)(2906002)(316002)(186003)(6512007)(6506007)(53546011)(44832011)(7416002)(66476007)(8676002)(66556008)(6916009)(41300700001)(8936002)(5660300002)(4326008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/tyMTnQgNwcrvFyvC9uC/EVqP+eTQB0voJLpc7WazcHvROpByH0hT31WEpj0?=
 =?us-ascii?Q?I26WxBqjVa7ZGWhUMLeDcv+00iQY2NAnTgEuGmtOdBGy2uI4J6DzMULaTZmm?=
 =?us-ascii?Q?+VKbnUmR3wX/7jsrb5ZehIP6qEz59SSqo4n0G6iTG8ZiXXKo8ODZaX6AADG+?=
 =?us-ascii?Q?eqZ7BqzkSSGeb2XXlZSEuHvQhrGyqNUkmTB2vH0Qa2bNB1eNGy3+PgR/J3XN?=
 =?us-ascii?Q?4CXPIVg4DwWlr6WiWbO85VcRYUY5hRr1rNUBBY6YXwsVQoGF/DxEsh6MGyyX?=
 =?us-ascii?Q?ed/gaMXHLqAqZXseQrxtYjLTFLGmMi3uvCdLCG9e8Se0LeiYMuK6i01aHV/N?=
 =?us-ascii?Q?DHEdOesHWP9WmSA4cdvF/YZqMWWp4SPpeNmieKOJMzTIIpuGYOqyoYDBm8lQ?=
 =?us-ascii?Q?r1iiPqQ5SxCYFlBdbbUWKcmckoR+Bf/230PufbUK1cnv1AveSRavT34v1/5D?=
 =?us-ascii?Q?iSlsLFUfd998FdV07ibMVmvodSsDhCh/TAzTEDIJg6jQXxbgMt+5E5SLvMfp?=
 =?us-ascii?Q?0NarEAmjqucbi30drNNFRBnoHSNKRt0vNJyE3o38ii4Kg1m5SZkaxWE++YLL?=
 =?us-ascii?Q?pLPCCDHMUojHPXkhRlkUi4/EYrhya1bvJ2FgQlnl5g7HSRUFQKbeiNDYLrvc?=
 =?us-ascii?Q?Qq+6AIxbQPvkQ9Y5gn+rlOxRQ8/d47Nr22HtSSOmGoEkOFfL5hi+pl0A20Sw?=
 =?us-ascii?Q?FbrI2vxjZD9v/giR5KFtCVOxjrTzbB6I4ajQxRid20mlxHEE5rc4bA0rfmeu?=
 =?us-ascii?Q?wQakTQYvYF8jnJHYQIFBImTZr2ULvOpUqOQANeJ5NMS66E11bwb9khYqybsB?=
 =?us-ascii?Q?BQOn6QDKH7mkWukq3or35tnV+AJ5K/voQ7QH4XRCw3EBgPpfqTm7iFbHQuRm?=
 =?us-ascii?Q?dwEEKxeVrz2qF0Kv1CTo9PFBRzSrm2grTJq5LBgmh6BRyqlaR65lq0hqShWA?=
 =?us-ascii?Q?ftI+uRjZNZidttOkUdUsY0aLZ90Tjzy+lWNWBvHNMSqQ4TCoSDdvZfvmUHzj?=
 =?us-ascii?Q?xl68zscbRKC3a/Z1WV9puNsV6PQgwsCYDpaOk5avTyZWD1IBxA1LIoxfqbt2?=
 =?us-ascii?Q?wSEmV3+GMYcvZcWtiqnSKz1/JTz5lc7I7+UXGsMHM9HyRp8RYpzsPvpgyuSr?=
 =?us-ascii?Q?zWDqkSDv2AymgzTceZTnlmkBTe3FWx9OFwyiGp//NUCChbiLqZTcqHglWqXe?=
 =?us-ascii?Q?RrN6svpundWtJHwKe0QrVgsZHUPuQAa5vc1PxQ9Xbxr5ZfNg8VfnY8w2ly2/?=
 =?us-ascii?Q?X2dE3JSUZjancQPYQX1EuValOwPAOYqp27bQDEHqT+vsK0InnI+FHvoHJBC3?=
 =?us-ascii?Q?NkrtooxuQTIrQtXgRiBSoS+s1Gc4X5Rs1qOzNrLlfOPTRD43HaRRFHTSiI16?=
 =?us-ascii?Q?oFRTdY0RXl+oJ0vIQO74dzdh6mMGY249CdNFGmYtZA2njBMZ8tPWjZUk1jOZ?=
 =?us-ascii?Q?ClaBglpyOweQhPY9ujc5NMmNytrmCXEnyovfXatBw6Kv2pSWC+dzT7sMSfbN?=
 =?us-ascii?Q?ZG7zHlbWQHm4WLjrHH4OPu0bEKa0wuebZ1kDjiq4VGOpSL4Sv/VKhsB50XI5?=
 =?us-ascii?Q?kaH5WQNiYiduIpLXQPmfQ04MoZe3L4msVLrZqRMRzsQ+MZGkhdtzYOHJitVU?=
 =?us-ascii?Q?58nIjs4o3YJEgY1QLe4YNczVGXy+dAdLsDqvFd9PZJTmcq5o7yqhuOYSY6tv?=
 =?us-ascii?Q?ubvZ7g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b90a2c-5f34-497f-de85-08db39999e82
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 08:00:15.9423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oLRu6Zu0BjHxsi+FiS5JwdkQAbK39AIhKjxwSpLzH4S4jg8D6xniGUUGrmgui1AKZLREdRf88sg1CzeN95pxkmp7oIYzEwFsKCSK7v8D54A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5668
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 09, 2023 at 01:16:49AM +0530, Harshit Mogalapalli wrote:
> Hi Simon,
> 
> On 09/04/23 1:00 am, Simon Horman wrote:
> > On Sat, Apr 08, 2023 at 11:12:25PM +0530, Harshit Mogalapalli wrote:
> > > Hi Simon,
> > > 
> > > On 08/04/23 9:02 pm, Simon Horman wrote:
> > > > On Fri, Apr 07, 2023 at 11:56:07PM -0700, Harshit Mogalapalli wrote:
> > > > > Smatch reports:
> > > > > 	drivers/net/wwan/iosm/iosm_ipc_pcie.c:298 ipc_pcie_probe()
> > > > > 	warn: missing unwind goto?
> > > > > 
> > > > > When dma_set_mask fails it directly returns without disabling pci
> > > > > device and freeing ipc_pcie. Fix this my calling a correct goto label
> > > > > 
> > > > > As dma_set_mask returns either 0 or -EIO, we can use a goto label, as
> > > > > it finally returns -EIO.
> > > > > 
> > > > > Renamed the goto label as name of the label before this patch is not
> > > > > relevant after this patch.
> > > > 
> > > > nit: I agree that it's nice to name the labels after what they unwind,
> > > > rather than where they are called from. But now both schemes
> > > > are used in this function.
> > > 
> > > Thanks a lot for the review.
> > > I agree that the naming of the label is inconsistent, should we do something
> > > like below?
> > > 
> > > diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
> > > b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
> > > index 5bf5a93937c9..04517bd3325a 100644
> > > --- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
> > > +++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
> > > @@ -295,7 +295,7 @@ static int ipc_pcie_probe(struct pci_dev *pci,
> > >          ret = dma_set_mask(ipc_pcie->dev, DMA_BIT_MASK(64));
> > >          if (ret) {
> > >                  dev_err(ipc_pcie->dev, "Could not set PCI DMA mask: %d",
> > > ret);
> > > -               return ret;
> > > +               goto set_mask_fail;
> > >          }
> > > 
> > >          ipc_pcie_config_aspm(ipc_pcie);
> > > @@ -323,6 +323,7 @@ static int ipc_pcie_probe(struct pci_dev *pci,
> > >   imem_init_fail:
> > >          ipc_pcie_resources_release(ipc_pcie);
> > >   resources_req_fail:
> > > +set_mask_fail:
> > >          pci_disable_device(pci);
> > >   pci_enable_fail:
> > >          kfree(ipc_pcie);
> > > 
> > > 
> > > 
> > > -- but resources_req_fail: has nothing in its block particularly.
> > 
> > I think this situation is common when one names the labels
> > after where they come from. So I'd say this is ok.
> > 
> Thanks I have a sent a V2 with this.
> 
> > An alternative would be to rename all three of labels after what they
> > unwind.
> 
> Other functions in this file are using similar labels. So may be we could
> with above diff(V2 patch).

Yes, I agree that makes sense.
