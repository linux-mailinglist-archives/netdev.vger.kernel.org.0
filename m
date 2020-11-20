Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08CE32BA3F2
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 08:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgKTHxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 02:53:09 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5924 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726629AbgKTHxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 02:53:09 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AK7o2NN004789;
        Thu, 19 Nov 2020 23:53:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=FYveW+VGLYA2OP/pWBSDEMo2489TKSjzIRRHzkReqBY=;
 b=hbajZ5N4UjDHccfPQmKMgAx1kpkcai7aVshoW3afnjgJB7w8ZU8OnDjoND1TZHbQe1aY
 qiSRBzdKNuR/Y4gnfUOGwVVZjLYehxp94JIW+XAH7Tj5MKun3ZIbrhti3FGfLPgBEagg
 4wP6UCmFFg7O4YMnJAH7P07TmwB4xh3D8SY0TQlzV4T+bmQD+BYukroVhOu9iKMUyD3v
 Bz+eEXAGHUqanAqauNJ1qLL1hzjrIB8aE2ykaaN/bpr08jEy1R431tsgygTJxTNFSJnW
 N8M+F/K3QtGwA6Hwe6MNZCurhfKvRq6y4r0RFHSlOq77TBePZPsRHxD140Zhw3nrZ7om 5Q== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 34w7ncy8bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 23:53:02 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 19 Nov
 2020 23:53:01 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 19 Nov 2020 23:53:01 -0800
Received: from [10.193.39.169] (NN-LT0019.marvell.com [10.193.39.169])
        by maili.marvell.com (Postfix) with ESMTP id AC5D13F703F;
        Thu, 19 Nov 2020 23:52:59 -0800 (PST)
Subject: Re: [EXT] [PATCH] aquantia: Remove the build_skb path
To:     "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        "Dmitry Bogdanov [C]" <dbogdanov@marvell.com>
References: <CY4PR1001MB23118EE23F7F5196817B8B2EE8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <2b392026-c077-2871-3492-eb5ddd582422@marvell.com>
 <CY4PR1001MB2311C0DA2840AFC20AE6AEB5E8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB231125B16A35324A79270373E8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311E1B5D8E2700C92E7BE2DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <12fbca7a-86c9-ab97-d052-2a5cb0a4f145@marvell.com>
Date:   Fri, 20 Nov 2020 10:52:58 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:83.0) Gecko/20100101
 Thunderbird/83.0
MIME-Version: 1.0
In-Reply-To: <CY4PR1001MB2311E1B5D8E2700C92E7BE2DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_03:2020-11-19,2020-11-20 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20/11/2020 1:01 am, Ramsay, Lincoln wrote:
> External Email
> 
> ----------------------------------------------------------------------
> The build_skb path fails to allow for an SKB header, but the hardware
> buffer it is built around won't allow for this anyway.
> 
> Just always use the slower codepath that copies memory into an
> allocated SKB.
> 
> Signed-off-by: Lincoln Ramsay <lincoln.ramsay@opengear.com>

Acked-by: Igor Russkikh <irusskikh@marvell.com>

Yep, that could be the only way to fix this for now.

Have you tried to estimate any performance drops from this?

The most harm may be here on smaller packets, for stuff like UDP.

Regards,
  Igor
