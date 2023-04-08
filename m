Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1013C6DBCC2
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 21:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjDHTal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 15:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjDHTal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 15:30:41 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2091.outbound.protection.outlook.com [40.107.223.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077C61AC;
        Sat,  8 Apr 2023 12:30:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OaMtMnYM5RYdAmiM8bTk6NvcH6SFIs8JpF0Q2T9UO8jhs/CPcLj9YEisQfixtR1yDQnIsunuLyPRr0JP7yULG7yShOEUhLLyCwCCfwcuxcTS4Sk2b0OYissRrYfEXyVRJtNrtbTBGYkP64na+uUJndLKIFHSlFAJB4vwdh6afv173tC2ErkA/hVYRlfjLXepdFsJAuUTamDw2ryJpeFFpdvm9EX479hesjl3v8SYXU7fpV8sYBUkssn2X/0lQOq+y8XbNVT2WdbM4UhZLfhVf30sOjk4wdkd556lL+Nf6ng6XPu0jeoe1guQD7ScaMYzXMTZGqgl2GQsjLYJ4Q2THQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SflFUFNbiy3HKi1Oij2MWl2N/GDLASIf+1Jj9zB4YFY=;
 b=FaKt5cxqBn9Mpcw91Q6ZoG9+1wJuBQlCP34u2gDPXr7m9BDEb1mYrH4BK8HuGdvBHcn+l2NLmimVvwM2E59xEEZMVqvd91xbIWjIQZuQOpnQWNlTBcsOPbM3i/XrI4zy+uHgATi+iG/28OKmCNYZHVIhIDguTYVbbwNamvI8XyxfCKI5BRZmf0R+uhvKflS9+16CUodJe7qj82lNrucWpDoWEYWD3OSKLRSkmaMhWSSJZEwpGxqySbtwJrvLmyH8vN2uXdO8EW64cwb7MLt+maWk57VyaGB/W5wk7pW2Qfl5BwV5SudibHEfsiX7QloNmeD6VN1xHtCQaIkaLjfBGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SflFUFNbiy3HKi1Oij2MWl2N/GDLASIf+1Jj9zB4YFY=;
 b=uycbIWG2L5+7qpvHyo0ANTwcceElVsaVw16xTDsLVZcavHLgjwtuuOBscX+enIWFwH4kHjYn0ocUQShd0w+hZkuXTQX78WEESQEpMa+e8Xc/p8kjLDqYZL5A0XfAc3B4K+3wkIwjrVnqzgCDCWlmddsWZwYPj7kw7DX0gW3oROg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5500.namprd13.prod.outlook.com (2603:10b6:a03:421::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Sat, 8 Apr
 2023 19:30:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.036; Sat, 8 Apr 2023
 19:30:35 +0000
Date:   Sat, 8 Apr 2023 21:30:26 +0200
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
Message-ID: <ZDHA0uTelrk1BDb7@corigine.com>
References: <20230408065607.1633970-1-harshit.m.mogalapalli@oracle.com>
 <ZDGJI8Q6lWCJdEMR@corigine.com>
 <8f47aa3a-9b71-6788-6d75-ccd96dcdb419@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f47aa3a-9b71-6788-6d75-ccd96dcdb419@oracle.com>
X-ClientProxiedBy: AM3PR03CA0070.eurprd03.prod.outlook.com
 (2603:10a6:207:5::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5500:EE_
X-MS-Office365-Filtering-Correlation-Id: 993e27bd-a081-4960-f799-08db3867b97a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MECSO6xkxviAYiwoJs9t003PFR+4Rrlgkt6yo3zWZBHAh2j1T6GoHpkI/4YG+sDbZREUKS/lf60n/oZ6Fu/6RWiSM8C1GJcGQ4UBrrnkB8CK1YukW/vmxhIitmrr4G1JjkSIUf7YdMaysZ5cCC0cawOXpiM2kZ6ZF1Eb0m572ZL5PHNwEZk8aDOgucYeTYuzx/mh+c5asGaeQo/CqyZP3fYuTxmGPE2EcNV5N9V2eD4I8PJOkmwnbHGlMFUCEho0vkLEY0aL8u2UJaBlIi8bqLEskhAeTjb9uNJTbxqnNjOQwS9j3EeuHZeJY5R8vHyzYZMoMZyPNbMBlPJdWcYwKUmztgR12dDHmOaIJmkSX4pm+fuEDRvVzwwdxkaAHqIljMU5KZMYA+/M5CnZ4I65iWg76vR7jMdj+InZlnVBnrSldYr247EgjKN2E7P8ue7Zlr3EWbrkN+bcqAqFd3PyAALjvLL84+1Ahl37NmLKsrdjWO7kQUIqywb7LAxsSufsw3oQTigagKGjTnkTtSZoQQvZ93rM8kkhYyy096/grHQ/sQ5hM4E3Sfq2fTPaTbhUaWuci/SI5zk3jKA7k3XhppS6AOm7CI8dIfS1SRKRSLg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(39840400004)(366004)(376002)(451199021)(478600001)(316002)(83380400001)(2616005)(53546011)(36756003)(6666004)(6506007)(186003)(38100700002)(6512007)(86362001)(6486002)(8936002)(41300700001)(44832011)(2906002)(5660300002)(7416002)(4326008)(6916009)(8676002)(66556008)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OY/7WLq3ek+KQNU3gFWayTMdqwxW+58vg5HHdVpeRszz5/WMzCk1RzyYPnk0?=
 =?us-ascii?Q?rZFtTTy43hMbA4BUvFsLAJj5pye4fSa3nOjnWPmCVhRs8Jz3F9PAN83ypSU2?=
 =?us-ascii?Q?7VL8Mc8nlFnxG0Uru6NlkaxwufvZViF4JQJw7IX0mo6JguxZgS11C3vZdwwI?=
 =?us-ascii?Q?RZepoVcnhaEgC97XYsrkRol19VpmciuB6tGvqHxatd/JUzT4kceS0DckVvPY?=
 =?us-ascii?Q?8QJKES6d/LfdRK09VkSAQVVMsgOSHm7JTEqxJKwUsp9zSjyHkARo00bL0R8r?=
 =?us-ascii?Q?YwQete/kx92nQSxtn99uDU8VSJnD/CrkPN0ZjunG5EFEt4FrhgcGuAsPMunt?=
 =?us-ascii?Q?KgiWbzmSoVWek8Unsztu+OPlQCETOORjC3O9nSbd/pEQkIKP63Dtq0ZSeLzM?=
 =?us-ascii?Q?3fzroVDfukeOfmgnjAN9qpusZuidY9VdsHLGR8C6JIKN0s/vj0JJsKjXiLov?=
 =?us-ascii?Q?NwvvvxJmAiTNYLBw6Lw5ANqUByQ2/l7XDJy7phoMtg28s/H41BLn3GN9ZwLd?=
 =?us-ascii?Q?Vq4EWGbAgqe1nXWbSWxg0e/lUuTQ+Jli/mKGxXnddvZLa1pVWx00seTbx/bL?=
 =?us-ascii?Q?AhhM0q/9aGJRu2ZGzMcaG10GZ5+hS3MeaF+JeW7NhX5mMYNCXQauxQkEixcc?=
 =?us-ascii?Q?PePCBU9aoYqF7EiCBzbLWT/crXk7MmmqJZ0yyS2f1/F2fJfTOSqSQKltA14T?=
 =?us-ascii?Q?HpW0zKEqYv8tpyi+ZGyagAv7E8Uy9X5JRKGw4q8o9fFQXaeX2fJTCoq/dkSC?=
 =?us-ascii?Q?zLTdkXAppZkDW99CHAWM7wX+1ocuCERq1eRzX8r9t9f/R20sm3MV8Y91CT0u?=
 =?us-ascii?Q?INFD8+6H6hJnUsIHtsqz7mZiGtGGmrlXVh3XXdkat2Eozf9OPVlAvIEu87iD?=
 =?us-ascii?Q?2/tSwNGEuCdejwjdvMK+RBUwZe81Hj9Xy5ihIMkGdPYjkltwSJ7Z0dPS4FgK?=
 =?us-ascii?Q?ihysqF43HJBKp87MsPNfXWtWgggbTONz2BodfZvgVFbesCtyX0EZWVSAV9go?=
 =?us-ascii?Q?F1BptdLs9EcV1pxWto7SEvJns5+/KOVoztF/u+mtZ7MAcu0Sofw39aHCI6pP?=
 =?us-ascii?Q?01e/EqRGLBXv+CTgP1ZyTLp3rZr9d5R/J6f36NQesvb4SaV5BjA5Pu0IpTje?=
 =?us-ascii?Q?VapZkZ0vCvrWxfOt9ueoFyek9P/2I3fXXzZjd30iXjzXrpl/MvFPKLIprNR6?=
 =?us-ascii?Q?pxF+wOjT7EeL43XyU6iLdf14lq7Tqs3abf2/gZRw2y5+rybUntaBXZjzmPWA?=
 =?us-ascii?Q?uCFIDrTePbrK+FDv+bqJUKyHLFjiBKBZt+sPTb+G+4VmVFU44R3gIb+D55ri?=
 =?us-ascii?Q?Jt4ZLDxnhO1qcYI0e8d45gT+1OSaOYSbieiHC2wcvhhVblrIFvPifNCM1nfa?=
 =?us-ascii?Q?7vRBlMNxENZCXvxWtLwUixX8Gppc5mc9cxfye/rEY88NqS+fRldM+4l0978V?=
 =?us-ascii?Q?CbQFwJzbjE5jxvoTJC8dBGH06KlelV6/zgWxy7DmEIZiHaELuWHzXC7bd8qx?=
 =?us-ascii?Q?UTyzK/U5mKlnexh5QcdhPEltRtph14S2Fl7A0kEkyTxxvLRWnL8WTdrJF41p?=
 =?us-ascii?Q?YRaADilwt/KDCU0MqeL0gRQUNAR+0qmhuuSeqHtGoeMMCIuVBaYwLQ4T1J4B?=
 =?us-ascii?Q?u2F/3BDgVmeyYLPkY7OLXNPz+Gablx4CQ8n4U/+uE1kwY0furnDBHvkuM2YU?=
 =?us-ascii?Q?mbBqpQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 993e27bd-a081-4960-f799-08db3867b97a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 19:30:35.2475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ttv88hRRDQKp+qqWBqi00Mr3MFG72FKQ3Q5mnTY2YtrtWc6cKhqR3UECVLwMtfIDSLXCVTOv9sRQQKto1Fk2lEAGcrEqoWjSMdQhHKvtkPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5500
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 08, 2023 at 11:12:25PM +0530, Harshit Mogalapalli wrote:
> Hi Simon,
> 
> On 08/04/23 9:02 pm, Simon Horman wrote:
> > On Fri, Apr 07, 2023 at 11:56:07PM -0700, Harshit Mogalapalli wrote:
> > > Smatch reports:
> > > 	drivers/net/wwan/iosm/iosm_ipc_pcie.c:298 ipc_pcie_probe()
> > > 	warn: missing unwind goto?
> > > 
> > > When dma_set_mask fails it directly returns without disabling pci
> > > device and freeing ipc_pcie. Fix this my calling a correct goto label
> > > 
> > > As dma_set_mask returns either 0 or -EIO, we can use a goto label, as
> > > it finally returns -EIO.
> > > 
> > > Renamed the goto label as name of the label before this patch is not
> > > relevant after this patch.
> > 
> > nit: I agree that it's nice to name the labels after what they unwind,
> > rather than where they are called from. But now both schemes
> > are used in this function.
> 
> Thanks a lot for the review.
> I agree that the naming of the label is inconsistent, should we do something
> like below?
> 
> diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
> b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
> index 5bf5a93937c9..04517bd3325a 100644
> --- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
> +++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
> @@ -295,7 +295,7 @@ static int ipc_pcie_probe(struct pci_dev *pci,
>         ret = dma_set_mask(ipc_pcie->dev, DMA_BIT_MASK(64));
>         if (ret) {
>                 dev_err(ipc_pcie->dev, "Could not set PCI DMA mask: %d",
> ret);
> -               return ret;
> +               goto set_mask_fail;
>         }
> 
>         ipc_pcie_config_aspm(ipc_pcie);
> @@ -323,6 +323,7 @@ static int ipc_pcie_probe(struct pci_dev *pci,
>  imem_init_fail:
>         ipc_pcie_resources_release(ipc_pcie);
>  resources_req_fail:
> +set_mask_fail:
>         pci_disable_device(pci);
>  pci_enable_fail:
>         kfree(ipc_pcie);
> 
> 
> 
> -- but resources_req_fail: has nothing in its block particularly.

I think this situation is common when one names the labels
after where they come from. So I'd say this is ok.

An alternative would be to rename all three of labels after what they
unwind.
