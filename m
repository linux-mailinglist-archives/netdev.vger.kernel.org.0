Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572CC6F1B18
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 17:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346202AbjD1PIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 11:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbjD1PIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 11:08:19 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2112.outbound.protection.outlook.com [40.107.212.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D0912D;
        Fri, 28 Apr 2023 08:08:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MzzMYWBO/BxcFtHjdeRV1pqaT7H2LpKQ7qHXyRiE4VRGai7CUaaaJtxFELI2kfrqaoadhpfFhakSIKQSyeVtbFTmNxR1YL7Srdjz/F3YFAoq8WTP3oU5NPBKDVmEl3cFfmqvatbLZM4ib+0Q3SzimdkcN5tiybUBBwh/09bdFpAgAWtcuYPCNHdHrq7lqrpdCy1SQOG0S5qgscKzNa5C3Cme1mWEmsJ9XIoUjlyRY8TGFod9sPpT2+T+kz628/KKr2GzSol92IzTvaQTcSK5JKVii/kPZjKLAPaBgJh56f7YLWuriGweDX2xKCcPa4O2Phg3PNnRu2aA00Nyvp8mAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=04lo9c5AWNkBSu5qw2ynvwZh9e3rLAl1ePpttp9bLP4=;
 b=hnC9UAY8FrpxBT+1ll0uhgm+ABb9o4SZUw6F0SFd13PNTxkUTBInyB5r+UryfJcu2IVIvfsl7pR+lAMqihRpPj2BlOGjKiQ20A4ZfZUUpM2OZ1Ij6uYrZsCKxk0p4VggIjuPmm7NyK9H78oUSuPDhI5Y4HcX/Fufe6zKmKYuTAh88jzBLprsWtfBMsBgZAd/drse3Sn8bU6J64EKtvB+1T/JprVhwm2+QEPYDK3xn1KBBjqX3gMsY7PmoozNrGJee//AqH+OKHBwG4Om2ZnZuVOpZMA7P2jZnAbaXLaO2TZq67AKtjJ7GPz0cyuMiF5zltvYTr3ykoatL5f/WQviFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04lo9c5AWNkBSu5qw2ynvwZh9e3rLAl1ePpttp9bLP4=;
 b=PVg9PY4MlTQaK1oOUvW0JJbeGOhm0QcEfk0VWIrnb7uOO/gEf10qY3sTxzL3Q/AkGlLdOtMViSv667/n5HEZet4iG2v6vgaSb6C5ZFzJ2y66bgY7Nl+o28Bh2ye4LuTTHDXuLUNjvuYa3nd5ejSYXok0tojRr2f7GbkdQQx7fVk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5712.namprd13.prod.outlook.com (2603:10b6:806:210::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.32; Fri, 28 Apr
 2023 15:08:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 15:08:14 +0000
Date:   Fri, 28 Apr 2023 17:08:07 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v5 5/9] net/smc: Introduce an interface for
 getting DMB attribute
Message-ID: <ZEvhV7hlVYtHz2Xh@corigine.com>
References: <1682252271-2544-1-git-send-email-guwen@linux.alibaba.com>
 <1682252271-2544-6-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1682252271-2544-6-git-send-email-guwen@linux.alibaba.com>
X-ClientProxiedBy: AM0PR02CA0035.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::48) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5712:EE_
X-MS-Office365-Filtering-Correlation-Id: e45fda33-cee5-4885-058d-08db47fa63eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PyWVo8AoJ6gsPSKkGZ0pbd0hM+2XKrN0mPJ3GvGBilFuz5ZTIvAFnV6EArytljlA3E+e2OQux5RxsPUPEiRrypLSLsadS0aDYOr/1EvIWEw53K3b3A+qzaAaFK6YXR6nuLgPeLjVXSQptmFI9fnm15ivZK7nDm0KYaLNiJ5TdLwSXD+KETYzzPi04/uKX8bGG0BWZ7bpZWCKDVvtK7poYD2MbwpS0pNMKIq72fygin8KjEhALYt/SqCOIUvgyuuRweGULxDlgb4VK+VZpCVQ7DW5Qu0Dr3D5KGStdhCC+AkFNqz1kwAkuhY7CE4fLJvip91hWQQXtvrVR6eI5tXntdvdw2GfvEZV9xu7xwtqe5meVcm1v6PlnyASKFg6RozPr2mkm+793UjgVlYaWnxL6XaYEG1oYBT95H1tYkNoxOOoNEvNNJupc0m+3KtsilqfPwDRVCyjUCRbPMwiMqeZ50lwxaRbJgAP3owh3qkL82yass2VN+rtDi+Cdr4YKdu/vBr40IjWHkkn5KrkvarC1B9TQ0KRqgXm+ywDHpmYVRW0pAnVc0j3IqjuY6J67p+3uFddzvEAwplLEddTsriohwimkSAGJzkns9YvCPNBlzM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39830400003)(376002)(346002)(136003)(396003)(451199021)(478600001)(86362001)(36756003)(6486002)(186003)(316002)(6512007)(6666004)(66476007)(66556008)(6506007)(66946007)(44832011)(6916009)(4326008)(2906002)(41300700001)(38100700002)(8676002)(5660300002)(2616005)(8936002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lj1BmRG4at3czftzBBmmlnX8zFwLbt09q5pOLMbPee8cx7Or06jfQSdjAVyq?=
 =?us-ascii?Q?byM5v9j9xoMoub6lKCzo/QpCmpDIB/NjLOD7F3vwu5opLIkEKkC27RNElxLF?=
 =?us-ascii?Q?VdVznaObOETUZumX4yHP9d/U3GVz+Yn6o11dcY6Ga3JoRkfKsivZ5UGc0n/Y?=
 =?us-ascii?Q?fYOHy1fYpNrDujAOM2dLj5Ann6jXbZTG4z4Je3CkUCO0NIeEXTnJdOo8ekK6?=
 =?us-ascii?Q?zRqa6lsXxU8Y3sKlhxNTvEb0McuoTMxAxy+WkjD3MVae3ThQYcx5wQ10/J94?=
 =?us-ascii?Q?dX1FoAtf+IH2XVAKb67w4COQsEaM8K0C5CD2l51Nb0GURQ6ZW8FZCSOqi6gF?=
 =?us-ascii?Q?ZPrHvgrxQA7DwUHjcLAOUAddpmlXpuP+063moiUnezRPksUXeYN/C4tv1Tug?=
 =?us-ascii?Q?ejgu3lT7riq2Zpu/lCqdDK96Eycxjo6PcRwDVqh6JtRwdgadnegov9sPUhu4?=
 =?us-ascii?Q?NQvQGG8FVA2+pjwXvaHi0b1gO5acQPnJM8kwQ9xsLnawcCloBS72HohzVRlj?=
 =?us-ascii?Q?2oih8+s/mplc+EyOJXfV5AJ1tJOKcFJhyZ9au0kzTUEXce7ieLTC6KFN6EsO?=
 =?us-ascii?Q?VBRpCwfAD4pJ+spEhsfNpcGuVKElYSGVo1qSekZ25KPBWeYUqhIhirraAEQm?=
 =?us-ascii?Q?AZBRAdNwPndLXDBA7N3uYrFKuhVKnp/QR5YY9UZG3Ccz8NCUH0U6PyVpHlDX?=
 =?us-ascii?Q?DO3xFKESNmM/aSNHIg0woE7USj+zsB+XW1EopkiIPBLYcezWuev6l6UhieCe?=
 =?us-ascii?Q?WuQLxdDh9BYub3Kuxoc6d8MtdS5WCKUDxYqrjebgY2RW8ky0xsRPz0byJesc?=
 =?us-ascii?Q?KutmgmZ8Jm4pSQuWzAcl74LENHmtBSHShwyvq56QQxuit5JIzV/zl6JWBF5Z?=
 =?us-ascii?Q?7WxW2HSXWeODq/xAg03PZfXVJfRkOHLrmZucie66IZnDl8ztCliPRSiDU5B8?=
 =?us-ascii?Q?ljTgbYKiztN85qDb0KZXklZt/bR22rK4KqfeZcWZNHReu3LB264B0W9LYL9V?=
 =?us-ascii?Q?67ta8fPEA/QyZB4yDHYfvRx6SdeatGBzzrPe8T9y2mQTdiqrxHUDbkHslKkA?=
 =?us-ascii?Q?k5nGzK6nG5cMud4FTgRezhEm36B4kwqa5rY9DHNclBYikZUy+ucJ+z6yGJrl?=
 =?us-ascii?Q?20g7mLG3moqYPHhlJ7ffsWNCUuwt84jRccFGpYPafBjJck8x2MP3HqkG/vPz?=
 =?us-ascii?Q?rnjm6AamvDXmp38chjrByZ+s6n+Qam/gTnjRPrrDOthDoQlex86p/e1uhyTE?=
 =?us-ascii?Q?HswBaofWc1CN51B6vMhrvuFKdiHSXUxSIdjQgMTK4IdcxSRiBL3jMiiSeHjc?=
 =?us-ascii?Q?5sN1o+fgF9ZE4ma76raayw22nh26hAeFlqbXOcUwm8JVS5yAG1dvmHDfozO2?=
 =?us-ascii?Q?hPjvJJm0Kx5LUqnIzzYQfrvc3ByiGgaKesljXQVmD5aBjhrAOYYru3ABmpI+?=
 =?us-ascii?Q?eVbvXqGYAcrjo/WqDkXTNyPnfyRlR9x4Kw/jd3RHe/BBW9MyVQgXNN6PPPtu?=
 =?us-ascii?Q?Z2Vk9rAaReuj+oaTeWKhfkK1DaK0Di8kfqa417A6M7/LxVZ8+fDLhT5q4Zo7?=
 =?us-ascii?Q?DsTQSAxJRSLNBX5oTZl50P2DwI9kzkKrMrZ+9d385xCCFr0LmVmwETO9egYj?=
 =?us-ascii?Q?/eq91IA3tO/Xrqb1z46AjYi7gckKdeIoG/9xFVFWu4OkP2UWLAF//4oiWnsr?=
 =?us-ascii?Q?8s7Vqw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e45fda33-cee5-4885-058d-08db47fa63eb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 15:08:14.9158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +hB86DFEF4As0OfEr4oL2TGOEU9NvQZn6KAPy+b4C3jHCQQybW/cSlvU00POJpabSj+2rEEiYqy9bznWI5WI/4W3lVYwmtVlUnzRChefSa8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5712
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 08:17:47PM +0800, Wen Gu wrote:
> On s390, since all OSs run on a kind of machine level hypervisor which
> is a partitioning hypervisor without paging, the sndbufs and DMBs in
> such case are unable to be mapped to the same physical memory.
> 
> However, in other scene, such as communication within the same OS instance
> (loopback) or between guests of a paging hypervisor (eg. KVM), the sndbufs
> and DMBs can be mapped to the same physical memory to avoid memory copy
> from sndbufs to DMBs.
> 
> So this patch introduces an interface to smcd_ops for users to judge
> whether DMB-map is available. And for reuse, the interface is designed
> to return DMB attribute, not only mappability.
> 
> Signed-off-by: Wen Gu <guwen@linux.alibaba.com>

...

> diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
> index 8ad4c71..1d97e77 100644
> --- a/net/smc/smc_ism.c
> +++ b/net/smc/smc_ism.c
> @@ -213,6 +213,14 @@ int smc_ism_unregister_dmb(struct smcd_dev *smcd, struct smc_buf_desc *dmb_desc)
>  	return rc;
>  }
>  
> +bool smc_ism_dmb_mappable(struct smcd_dev *smcd)
> +{
> +	if (smcd->ops->get_dev_dmb_attr &&
> +	    (smcd->ops->get_dev_dmb_attr(smcd) & (1 << ISM_DMB_MAPPABLE)))

nit: this could use BIT(ISM_DMB_MAPPABLE)

> +		return true;
> +	return false;
> +}
> +
>  int smc_ism_register_dmb(struct smc_link_group *lgr, int dmb_len,
>  			 struct smc_buf_desc *dmb_desc)
>  {

...
