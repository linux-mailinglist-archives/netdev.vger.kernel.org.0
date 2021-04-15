Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7585436136F
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 22:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbhDOUZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 16:25:38 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59942 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234748AbhDOUZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 16:25:36 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13FKJWbE068674;
        Thu, 15 Apr 2021 20:24:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=E2eGj+h0d64mKRK+lUpCREp2sW8OWjcXgeLC7UN/nOU=;
 b=Thb8y1/Kfk9mLEGFRwWsNMQyJjywVXw3MG4OkojBo8e69WktUPhXiZk+8Rgvhl76SvZ0
 /8ubnb7OuJmlLaVM846FYLEv6tZSxElNDmffAcpGQVwFFGbZs42PiMJO9SZqDhnXvbHg
 Fq5biEM4vcHEDXEpLLsoE47efeUeUMSyjGFQ+ys3QId+51s3+Qs7v5xuOmxFqBDKUm2z
 YJhV0puMhe39vwQxjz4HHfL49Hj8bYWo496drdX0m6nZFvaQhm3gO9GNDc0qHsaivYPe
 FLOMbUUgbl7/isPPtoCu/ABb9gC3mn4GKn0f5u0sHvByKus9CDNM3A/ZDyEBxHIjxJ90 tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37u1hbq9m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Apr 2021 20:24:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13FKJeX2017600;
        Thu, 15 Apr 2021 20:24:34 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by userp3020.oracle.com with ESMTP id 37unsw55b4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Apr 2021 20:24:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MsDLBVdzZcE4oYXAgWz4fGTVq5jGWGgEhDs14AP/36L7yjG9qiyCocV1Xq09QKF7iudqKxmBjk9NndVciP75GKsej2Am9Bf6/bOH9L/V/Y3lxkAcQbxUmJuHCvx40+vO1uUCw5by1t8d7QFtzQdv4ENLKYaI9pDqrUDllnfrv5O8SPZeh4q5Lo+YTu8R42PY2Izk40GdiVeOG+t93mXSwAViSNMGv3rNABAI7e57HIn5t2HNhyW8CZIZZBRxMhdzWJvOC4XMYG85cVK6tmCRhgh6vRHeZPDhjNZBIQTS4Yv+y41wyzH9LLlaParqL4RLP0yvQQSDwtd6SlRkFn32nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E2eGj+h0d64mKRK+lUpCREp2sW8OWjcXgeLC7UN/nOU=;
 b=EWZUWcgsfVrHFw4ZKyeDi4qcQ40EcAKBoUpw1DoH9t/dk+gJHA8sX6dZAxUjlD2+BK7wGk2mqQjPstIjIVUslCMfsSMcoyAFoL6AcmcRDlfATpgiSggc2W0OT90XNSNFbeW9iVgkAJmPG++kKBB6mzX0Ql1Rf6BoPjL6wzpSWD/no1oEoRoQvilIpzWkvbHAG6NkzsOHfFT10hyZvgGc5xlnspfb03X89x9yLYS2fY9C9XkwAWeJAfTJ/57KtH5PpanpsH9XrFuR8pUV/18snNVeXkrGqXPHOs5LyQKozpj680Max4sUzXjSc5689LBXrtOoi/LPU1PxgkGrApPMgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E2eGj+h0d64mKRK+lUpCREp2sW8OWjcXgeLC7UN/nOU=;
 b=Qgm0i43cS6CzFHWS9KlFuVSF/3OP3R9sxltKjDWdppsC3v17TuWQc5qMAYetF/zX+aWcJxEbwZYZZBLwvMfMYjaSCzYS3I0NVTbArKWU6AJFNBZyArlJ/vR/d4CSF4Af7ubEfcONdS5lcM+2e6jbU/5Y4Bw7wMbYUpl8gitvoJQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2999.namprd10.prod.outlook.com (2603:10b6:a03:85::27)
 by SJ0PR10MB4784.namprd10.prod.outlook.com (2603:10b6:a03:2d4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 20:24:30 +0000
Received: from BYAPR10MB2999.namprd10.prod.outlook.com
 ([fe80::50f2:e203:1cc5:d4f7]) by BYAPR10MB2999.namprd10.prod.outlook.com
 ([fe80::50f2:e203:1cc5:d4f7%7]) with mapi id 15.20.4020.022; Thu, 15 Apr 2021
 20:24:30 +0000
Date:   Thu, 15 Apr 2021 16:24:15 -0400
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
Subject: Re: [Resend RFC PATCH V2 07/12] HV/Vmbus: Initialize VMbus ring
 buffer for Isolation VM
Message-ID: <YHig78Xra5tEQhMD@dhcp-10-154-102-149.vpn.oracle.com>
References: <20210414144945.3460554-1-ltykernel@gmail.com>
 <20210414144945.3460554-8-ltykernel@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414144945.3460554-8-ltykernel@gmail.com>
X-Originating-IP: [138.3.200.21]
X-ClientProxiedBy: SA9PR13CA0179.namprd13.prod.outlook.com
 (2603:10b6:806:28::34) To BYAPR10MB2999.namprd10.prod.outlook.com
 (2603:10b6:a03:85::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-154-102-149.vpn.oracle.com (138.3.200.21) by SA9PR13CA0179.namprd13.prod.outlook.com (2603:10b6:806:28::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.6 via Frontend Transport; Thu, 15 Apr 2021 20:24:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6caeb20-f388-48fa-5e55-08d9004c7917
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4784:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4784F0908960C1B6B665D7FF894D9@SJ0PR10MB4784.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VfO8k15dQsbIbvUiz76RgBiaBFn2tnF2M2iX74+T6ijrJ37NymbKXxZCVuenbCN3IXHzT4W5zfJviiURtf4Qzg7ilRkPUvt6gx2PlFCLm4RSd43LDCOklD8/AuiS1aJM6STZFhwbhD5j37ZCcO6KEV8mnS0g4pQQxU04Aeg1u+TpaX1laJRX2fyUi8kVelw0YtHm0yIZd5z5WxH27hMfDiZ5heSF/JFPrqzknrB9HcyO5kQDw5UFqyxl4yGbnOh+dS6tPlc5UrjPjkfoalS8HVgpjN4pQlGrwA0wrExtNbXDVU3j1QUCmuNUBBdKWu8Rp5WTPZ7tCSD7xiTubNZ+fsg3sMI1q77VXzeQrbeUMOEOHTCbJXViXiNWg/7V50dfH2B91DuiH0IQuJr+Q4RPx9IVnruUn0WNfEYpJ3cXrzTlDoA1aWqIjwG9btVMm8NZBZSNUdVjOEUmki325opUUGo0Ks5KsC5wdzLJU+LtxkM2ZOus/kHv/Usty6vRaT8pmzebbILRvdcmpcQMLOR45errhAilljUZ7dND9I7N3YWbYYBhPyi0qjyhqWedvsDEfSZHCAhs774xOrBg4vJYwPzGy/8MpyqMFXZTDLMgy6CxkDP5dc717VtX35GUadRyUMouVWSdd+XNazrQhz80pnHCOHnGim2vkutgRmrXGiQCnZPJpqZbGhd6cwqtEPTW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2999.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(39860400002)(366004)(376002)(5660300002)(83380400001)(66556008)(45080400002)(8676002)(66946007)(186003)(66476007)(16526019)(8936002)(86362001)(956004)(55016002)(316002)(6916009)(26005)(478600001)(52116002)(2906002)(38350700002)(7696005)(38100700002)(7416002)(4326008)(6666004)(7406005)(102196002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qDG3XUTEmPN54Zswiys/i90sVDsM0CMpnG5V16EHfM9O+yM/HzlitEQGdedJ?=
 =?us-ascii?Q?Xz3stI7LoH0OZkKncawFxcIopHYoIemYjUd1bLS/RwnOslnbVrR0Gs0ZKXSM?=
 =?us-ascii?Q?jxh3c67/P9kNmFwpaZfPEnq40eUJsvpJW1JuPr4/v1pkhAuvjiCeouqW1+fL?=
 =?us-ascii?Q?qETThvW+1EHSStaovctQPWXCAv/um9A48OkgCHIzIW9IvPtRdsPB99jiPeai?=
 =?us-ascii?Q?3BsEXqyIXeTbrnDgMTJYm1LuYsyKCIa6JWslPfv3mcQ/H5uZPum08ceXXbN8?=
 =?us-ascii?Q?XuEs51+yGc3pT3imCkNxt18tWrwzC4JFzSiTdaXBjyzM4mux4BtTmu/CmRLU?=
 =?us-ascii?Q?+pV96EW4ZY2T+gJh6eusgLebxaDasK0xTcjz91MQXSIxkvzV1LT066upH2+G?=
 =?us-ascii?Q?bBtCSSTJ+LgtZo8+//t+497LMLWvM5r57c/yrBerb+XmD0WL5WdxWwSvU+us?=
 =?us-ascii?Q?QTW3u95xUjaeIwDcYl4f3xIAJYA5PE4OtJYbMRn/KrP2WjYZRJogjfHBHrz9?=
 =?us-ascii?Q?sChHfQK/eGHbapQnbsDPrs2yGAV9b5+etI2CL/nvBtv32a8SYv5u443OckN9?=
 =?us-ascii?Q?Y3pGQBlxqk5Qy7xcBd2VXolaxFDrztEL2x9iUK4v7Q+J5ercH/JE2Fs1AVWH?=
 =?us-ascii?Q?VuBiheFFmx7DJYckxPsb6hyhRykRLy6RXphEkE5LEUyr9pnPB0/NpkndJG2c?=
 =?us-ascii?Q?7qekA+5IQBnLzeRj+D6zUN4t19ReC1DIDxFh4/kiKHZEYOSNd07a9gMTXYUG?=
 =?us-ascii?Q?plNwdqe0ILkKjjbHbvmVRnKpMSgViTtV6AS74I8jZR1Jp4Zq9panlrGf6JzR?=
 =?us-ascii?Q?pamHVmCluZZbkPQfrNvQxFyM5ohhWZaYp7WHhozRFltIlTkqIEFGsCfj+tQ3?=
 =?us-ascii?Q?dfmR7wHLcoJGnXc+K+ikWF8Qy8XjkgFVgMPG1qx+yFj5Ansf7zTmWkgcD1zB?=
 =?us-ascii?Q?zXmnOfqmEAek2ObTBJId2tL32DvWgoj/PDnmndb8MW5jMQyX0k9jYTnn11TT?=
 =?us-ascii?Q?EwBP9rWaAg2Hw0SbcGaxvz3u+pc75sTRRnbIOxjQ6Stzpe6ppqsFWgu6+TpI?=
 =?us-ascii?Q?404Iga7oeHlxvWZKIDXQX0Ct7ev6PHouvvCfQTkca48Xa3j5jRjWzQn09tiO?=
 =?us-ascii?Q?R6cvFpgJvroFvt0E5FKItl3igveAnhq+o1cEG5qQ/eTKkL1VVa0hphkVXj9G?=
 =?us-ascii?Q?ws1ZGj/Yib1g1o7rxuw8jbCvIsWvyHcUuIEhN5Ljya79j1ufG+INXcS6/Sp9?=
 =?us-ascii?Q?ZPpLvVtC2OG2xPLswE2kEOAJsCz5nap/0Qt/5Qv/OqMxCJIf2WQ0pKA86iQ6?=
 =?us-ascii?Q?s7CCUALJ9sQP090pMVd8hYGx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6caeb20-f388-48fa-5e55-08d9004c7917
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2999.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 20:24:30.6000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FiAJ/1RGmfZ+aPW97lumitlsqpbO7XI8+86WHnhBcaN/3XKia4fpQd2sS/AELmQP0vTpRfu3hY4QAmYdDKWOiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4784
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104150126
X-Proofpoint-GUID: MUtg9PECzo0uqIMayrgsO2rqnEhpICF9
X-Proofpoint-ORIG-GUID: MUtg9PECzo0uqIMayrgsO2rqnEhpICF9
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104150126
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 10:49:40AM -0400, Tianyu Lan wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> VMbus ring buffer are shared with host and it's need to
> be accessed via extra address space of Isolation VM with
> SNP support. This patch is to map the ring buffer
> address in extra address space via ioremap(). HV host

Why do you need to use ioremap()? Why not just use vmap?


> visibility hvcall smears data in the ring buffer and
> so reset the ring buffer memory to zero after calling
> visibility hvcall.

So you are exposing these two:
 EXPORT_SYMBOL_GPL(get_vm_area);
 EXPORT_SYMBOL_GPL(ioremap_page_range);

But if you used vmap wouldn't you get the same thing for free?

> 
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  drivers/hv/channel.c      | 10 +++++
>  drivers/hv/hyperv_vmbus.h |  2 +
>  drivers/hv/ring_buffer.c  | 83 +++++++++++++++++++++++++++++----------
>  mm/ioremap.c              |  1 +
>  mm/vmalloc.c              |  1 +
>  5 files changed, 76 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
> index 407b74d72f3f..4a9fb7ad4c72 100644
> --- a/drivers/hv/channel.c
> +++ b/drivers/hv/channel.c
> @@ -634,6 +634,16 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
>  	if (err)
>  		goto error_clean_ring;
>  
> +	err = hv_ringbuffer_post_init(&newchannel->outbound,
> +				      page, send_pages);
> +	if (err)
> +		goto error_free_gpadl;
> +
> +	err = hv_ringbuffer_post_init(&newchannel->inbound,
> +				      &page[send_pages], recv_pages);
> +	if (err)
> +		goto error_free_gpadl;
> +
>  	/* Create and init the channel open message */
>  	open_info = kzalloc(sizeof(*open_info) +
>  			   sizeof(struct vmbus_channel_open_channel),
> diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
> index 0778add21a9c..d78a04ad5490 100644
> --- a/drivers/hv/hyperv_vmbus.h
> +++ b/drivers/hv/hyperv_vmbus.h
> @@ -172,6 +172,8 @@ extern int hv_synic_cleanup(unsigned int cpu);
>  /* Interface */
>  
>  void hv_ringbuffer_pre_init(struct vmbus_channel *channel);
> +int hv_ringbuffer_post_init(struct hv_ring_buffer_info *ring_info,
> +		struct page *pages, u32 page_cnt);
>  
>  int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
>  		       struct page *pages, u32 pagecnt);
> diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
> index 35833d4d1a1d..c8b0f7b45158 100644
> --- a/drivers/hv/ring_buffer.c
> +++ b/drivers/hv/ring_buffer.c
> @@ -17,6 +17,8 @@
>  #include <linux/vmalloc.h>
>  #include <linux/slab.h>
>  #include <linux/prefetch.h>
> +#include <linux/io.h>
> +#include <asm/mshyperv.h>
>  
>  #include "hyperv_vmbus.h"
>  
> @@ -188,6 +190,44 @@ void hv_ringbuffer_pre_init(struct vmbus_channel *channel)
>  	mutex_init(&channel->outbound.ring_buffer_mutex);
>  }
>  
> +int hv_ringbuffer_post_init(struct hv_ring_buffer_info *ring_info,
> +		       struct page *pages, u32 page_cnt)
> +{
> +	struct vm_struct *area;
> +	u64 physic_addr = page_to_pfn(pages) << PAGE_SHIFT;
> +	unsigned long vaddr;
> +	int err = 0;
> +
> +	if (!hv_isolation_type_snp())
> +		return 0;
> +
> +	physic_addr += ms_hyperv.shared_gpa_boundary;
> +	area = get_vm_area((2 * page_cnt - 1) * PAGE_SIZE, VM_IOREMAP);
> +	if (!area || !area->addr)
> +		return -EFAULT;
> +
> +	vaddr = (unsigned long)area->addr;
> +	err = ioremap_page_range(vaddr, vaddr + page_cnt * PAGE_SIZE,
> +			   physic_addr, PAGE_KERNEL_IO);
> +	err |= ioremap_page_range(vaddr + page_cnt * PAGE_SIZE,
> +				  vaddr + (2 * page_cnt - 1) * PAGE_SIZE,
> +				  physic_addr + PAGE_SIZE, PAGE_KERNEL_IO);
> +	if (err) {
> +		vunmap((void *)vaddr);
> +		return -EFAULT;
> +	}
> +
> +	/* Clean memory after setting host visibility. */
> +	memset((void *)vaddr, 0x00, page_cnt * PAGE_SIZE);
> +
> +	ring_info->ring_buffer = (struct hv_ring_buffer *)vaddr;
> +	ring_info->ring_buffer->read_index = 0;
> +	ring_info->ring_buffer->write_index = 0;
> +	ring_info->ring_buffer->feature_bits.value = 1;
> +
> +	return 0;
> +}
> +
>  /* Initialize the ring buffer. */
>  int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
>  		       struct page *pages, u32 page_cnt)
> @@ -197,33 +237,34 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
>  
>  	BUILD_BUG_ON((sizeof(struct hv_ring_buffer) != PAGE_SIZE));
>  
> -	/*
> -	 * First page holds struct hv_ring_buffer, do wraparound mapping for
> -	 * the rest.
> -	 */
> -	pages_wraparound = kcalloc(page_cnt * 2 - 1, sizeof(struct page *),
> -				   GFP_KERNEL);
> -	if (!pages_wraparound)
> -		return -ENOMEM;
> -
> -	pages_wraparound[0] = pages;
> -	for (i = 0; i < 2 * (page_cnt - 1); i++)
> -		pages_wraparound[i + 1] = &pages[i % (page_cnt - 1) + 1];
> +	if (!hv_isolation_type_snp()) {
> +		/*
> +		 * First page holds struct hv_ring_buffer, do wraparound mapping for
> +		 * the rest.
> +		 */
> +		pages_wraparound = kcalloc(page_cnt * 2 - 1, sizeof(struct page *),
> +					   GFP_KERNEL);
> +		if (!pages_wraparound)
> +			return -ENOMEM;
>  
> -	ring_info->ring_buffer = (struct hv_ring_buffer *)
> -		vmap(pages_wraparound, page_cnt * 2 - 1, VM_MAP, PAGE_KERNEL);
> +		pages_wraparound[0] = pages;
> +		for (i = 0; i < 2 * (page_cnt - 1); i++)
> +			pages_wraparound[i + 1] = &pages[i % (page_cnt - 1) + 1];
>  
> -	kfree(pages_wraparound);
> +		ring_info->ring_buffer = (struct hv_ring_buffer *)
> +			vmap(pages_wraparound, page_cnt * 2 - 1, VM_MAP, PAGE_KERNEL);
>  
> +		kfree(pages_wraparound);
>  
> -	if (!ring_info->ring_buffer)
> -		return -ENOMEM;
> +		if (!ring_info->ring_buffer)
> +			return -ENOMEM;
>  
> -	ring_info->ring_buffer->read_index =
> -		ring_info->ring_buffer->write_index = 0;
> +		ring_info->ring_buffer->read_index =
> +			ring_info->ring_buffer->write_index = 0;
>  
> -	/* Set the feature bit for enabling flow control. */
> -	ring_info->ring_buffer->feature_bits.value = 1;
> +		/* Set the feature bit for enabling flow control. */
> +		ring_info->ring_buffer->feature_bits.value = 1;
> +	}
>  
>  	ring_info->ring_size = page_cnt << PAGE_SHIFT;
>  	ring_info->ring_size_div10_reciprocal =
> diff --git a/mm/ioremap.c b/mm/ioremap.c
> index 5fa1ab41d152..d63c4ba067f9 100644
> --- a/mm/ioremap.c
> +++ b/mm/ioremap.c
> @@ -248,6 +248,7 @@ int ioremap_page_range(unsigned long addr,
>  
>  	return err;
>  }
> +EXPORT_SYMBOL_GPL(ioremap_page_range);
>  
>  #ifdef CONFIG_GENERIC_IOREMAP
>  void __iomem *ioremap_prot(phys_addr_t addr, size_t size, unsigned long prot)
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index e6f352bf0498..19724a8ebcb7 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2131,6 +2131,7 @@ struct vm_struct *get_vm_area(unsigned long size, unsigned long flags)
>  				  NUMA_NO_NODE, GFP_KERNEL,
>  				  __builtin_return_address(0));
>  }
> +EXPORT_SYMBOL_GPL(get_vm_area);
>  
>  struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
>  				const void *caller)
> -- 
> 2.25.1
> 
