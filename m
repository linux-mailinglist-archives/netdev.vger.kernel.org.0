Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D9738CB85
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 19:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhEURH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 13:07:59 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:64700 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229896AbhEURH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 13:07:56 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14LH6E8c020660;
        Fri, 21 May 2021 17:06:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Xafuo6zLBIWj1TxYjx5qjh2lxHbztLEkP8hIFe/iYr4=;
 b=dF09RaDgGBxnZbuMGGgVx1Rt8qdAAkHhcwNKyaadU5RvOU+xZDPgreBgT7kYpg7lCs3b
 8HFYdfFkYVbXNLPir7z8b9O+QsGM8PzyRq+28/4cZca8GoHOz8L5tUyvVQ6tqbOnqPf6
 Jq01ChpsuRcOHzlnmdWd8MCXF4PgskAGbuqkvdXy/SlD6UDDGstNW7UHcHQL0pJ4OrsB
 v0TbqHQtfyhUYCXeDIuMV2BMSn9ea6drtmZMAe9Qkjm6YMTwe0e8vDmKcY8iDVDMNM6Z
 OHMcCWkE6vJm5rLFvWEJiA1uGVTqomhaWq6sIicS2ZGl5rXwNAPjZyYFUPh9qaCgOHxK tw== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 38n4utryxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 17:06:13 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14LH4W9U001233;
        Fri, 21 May 2021 17:06:12 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3030.oracle.com with ESMTP id 38megnrjxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 17:06:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXLHn/YXXCKNivUUr3sqQtbVJRLkSK5BXQsEmei0J0ODSBz7EYPrB/Mrwc7WVTeX1ehdFV2u1jo/+lxoEEKAJNcCSeGJ7WH1kAsOfqhmt5k1WgueFSCAoG1BgZy2My8cWVeOKQ6NRkCnzJJ2HFEsmqazP+EYsjDOwgw1bdqV5AoQUr/Cr6nuhZoCMwSB5Aqu+4Ysu9zSn6i/6WSCi0m1s/ZxshZHU2MA0zifHCT7YxQSlzeRzPFiFd4WFq5hFNVGGbPXlH0D3skx6MFCG3fmJGATX72NZDS/1Ew2Ve4YvgB/z30sjwjP69qUCjttoXeTcoY4SUO9Z0bGk+IMoMWJjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xafuo6zLBIWj1TxYjx5qjh2lxHbztLEkP8hIFe/iYr4=;
 b=AJdVp9/0uE8Ar7LhNen1bTF9S4O5zLeax99raKVkgwpCnpgKnEDH4yua05FeYZAzWRm1+caGJUJ8w/J6V+PV6KqgUQd62bZR+uyrwzQykDlwD3vLQVKxP1jFRc0ETTAyUqgnN7Nx/blh228wZaLPa+QUs9EF6RSwlm2Bg51rulbaWFiCetrNRz2fnz9NuI5H2IviR4O7RssHvdaSMhDp5ahc3y0dlW03vgz0laKrJDayychv3yq7EGeZNN+s9sr0hITmR+1l8AHAvzLuNP8fJcQ4u+PRWREa4FyJ7TLlpNcrOYydp9Qej/W7CLeNaXhh1VN6qVHCh0ZBlxqAJuFtFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xafuo6zLBIWj1TxYjx5qjh2lxHbztLEkP8hIFe/iYr4=;
 b=JdOYiSuHO8Rz8iXA0Vnq7pmmfT37USOYoM9IPsIWEZaqBXp929jAUN3hPxDEZSRIAO4cIQMAKRZKKz5MZBjiUzcPCejtd3BqLB07FutHIFpMd0ArL80yzZY8U7sJOANOf+bRMPBFUujIpvWJJez9EODJJwzd9g3kDjcba/cWAJU=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4795.namprd10.prod.outlook.com (2603:10b6:806:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Fri, 21 May
 2021 17:06:09 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4129.034; Fri, 21 May 2021
 17:06:09 +0000
Subject: Re: [RFC PATCH v5 01/27] nvme-tcp-offload: Add nvme-tcp-offload -
 NVMeTCP HW offload ULP
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org
Cc:     aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com,
        Dean Balandin <dbalandin@marvell.com>
References: <20210519111340.20613-1-smalin@marvell.com>
 <20210519111340.20613-2-smalin@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <2790fe4a-1dc0-a8a5-d8f9-ef6eb73b323a@oracle.com>
Date:   Fri, 21 May 2021 12:06:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210519111340.20613-2-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN4PR0801CA0003.namprd08.prod.outlook.com
 (2603:10b6:803:29::13) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by SN4PR0801CA0003.namprd08.prod.outlook.com (2603:10b6:803:29::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Fri, 21 May 2021 17:06:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6508750d-1581-433b-d06e-08d91c7aba6c
X-MS-TrafficTypeDiagnostic: SA2PR10MB4795:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4795BAC5BB190D8100838B7CE6299@SA2PR10MB4795.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dGeQtZGPEQ3q2VW0e1H+FeFHaVY/YtdKFtfdomi4AIc8SS+HqOYTsgB7dUN2QKcBb1Za90s98hzagcbw6OevZ+fV6KAngNfWX1E/uopMpb+LXgDwAgf6gDYJ+uuhiAzdihpUwAuoYB56byoKCBy+F+kzr4RPNKAJc2z51D+10p68TBEMHmPH2zpbZ9Nu0RjMmnFPYpha5AvEUwVzm+9Lp+XrUxTUuia8B/6JSrQ0XBZoOR+kHtXGT79jdPqpKXbrnrcJpDZTrGuUn/LRjNnND4bW9gPP2sJwYtbt7tyNAmOkzWuxtsqycseiSSP4bYlzdOzBJ9oec6rXbEZh/3fuxDwabtGFtUP1PYRVY0hsn8hBFZyVFzPsvp8Ok0Y5vA2J9kIzrsvnfMr842YwNtlqR5mq9sBfaFzYZLcM0Je2Xh97U1VwOJPyjqPBI1yKOtyMB7y15f66C96pv/J50JxK6zVYJDqy6Ou9VRrLvAyFGyy2AN/FsrCDOmDod+TXVogdjscvlvHKUE3QWGS+VYv6SMnYtp+iFGUzJyBwUF6AYJorjzEG9UHwnOg1/1B/4TtW2QpsKxwgDGF7xY16/FYrgPefFUCv9tP0hmXgq7mRQiQ6TS2P712sfrlL1hfxd+qWvXOY+M/GDE79sKWktBgvPXWAlVt5kXovn3cv8uIZvI86h1w5IvSzJpg5f5ZdLKUjVlmYMFaarUeTyJZu56wRvqanM00Uj84TGwKXZ6SItBBCiDQ2/5LKeYw30zTij5AglFpjChDONm9pCP70y2r0l0PWV3vzYVM9K7k93PdIXy4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(39860400002)(136003)(396003)(8936002)(36756003)(38100700002)(16526019)(36916002)(26005)(53546011)(4326008)(66476007)(478600001)(66556008)(30864003)(186003)(66946007)(44832011)(31686004)(6486002)(956004)(966005)(316002)(83380400001)(2906002)(8676002)(5660300002)(2616005)(31696002)(7416002)(16576012)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VUJjV2Z2NnJwbWFyZGFvT1FiaExyRFZPWWNNV0EzMDFYaWF5V3NDRVpFNVVF?=
 =?utf-8?B?RXFJdGJZLzlhTjNvQ1ZVSi9mRnNYYnhucTI0NHNobng4OFVPblhjdVYvOTlZ?=
 =?utf-8?B?SEVoUUdFWm1XUWlzZDdKSitvZFBGdzk3K3lGRkNrZkFPYjU1SFcwMGtHY0Z3?=
 =?utf-8?B?TE9FUFdMVlMvblZlOWlaRkg0ZEFpZFVhNkxXdStudm1sK21oZkUwdzl5SWdY?=
 =?utf-8?B?TDk2UXJqT21BZHZ0Tmh6b3VWS3hFNHJrbWxidWZnc1ZoK0ZSNTVNUnB3RnJK?=
 =?utf-8?B?MFIrK290UkRlMWNSaTZJZlJBR0t2SmdFbHBGaERabjE4bVJjVlk2TWxjRUFh?=
 =?utf-8?B?T0NWKzlRUmVqZ2g1SjQrVzB4ckJsUzZJQ3NUSVA2MjB2Ui9YeER4elZBQ0hy?=
 =?utf-8?B?aTdPemN2OW5UR0tXMDZ1R1Zsc0NwaitFR2VyN3EwRWRjYnJta2M4bi9weGE0?=
 =?utf-8?B?bUorVVE0aTFhQXJHTlBiZG1IS2tsME54OWNEZ0Ezc2t6WkIwUUlEdVFPd05G?=
 =?utf-8?B?dDB2N0MxRnJsN1cwZVJsZEJjaEhyVDVwQjEzbEQrOThOSFZqZjZFQzZJaG5t?=
 =?utf-8?B?dHdLb3VwS1REeklnWVBWN2NnK1RUZHhkTlliRUFuNDhXLzZBZWs2ZElQeDQ3?=
 =?utf-8?B?S29qTDhnN29Idk1vaUptRzE2SHF1R0JsblhBVE1PaC9LWU53QXJRNzdCK1k3?=
 =?utf-8?B?cVJTaHBaRU1vMVhtMndQaG9oZC8zRmZwcmdFdHRYVnVDckdYbW10cnlLSmE3?=
 =?utf-8?B?U04rSDNIVk5EY0RFVGpFNW05VHRRY2cvaVhRSWQ5alRlTURFc1ZueXRHZXVk?=
 =?utf-8?B?SW53MWxrTkN6NVdkdXFHdlIzaDU2MW9rNklkeHU1WkxyVlM4V2RrbGtuYnls?=
 =?utf-8?B?dUhxNFFTcWI2dE4yZG15T3dvajJhNWdET2kyL0NYZGI5S0ZTNUNZay81SGFK?=
 =?utf-8?B?a254RGMxQXE0c3JQODFock92Y3FldlJ3eXFzekdzcEFRZHZSRk9zSmZ1anh2?=
 =?utf-8?B?UmZxZUkvanJqQUxWT0dhNGt1WFFSOTZqMnY2NmtLajRHQlJqcXVLMUdQK1lr?=
 =?utf-8?B?Z1ZpNFlNak5ScnpIQ2hETUIrelo3a2c3OXdPT1FaVnBZaWhsazlDTDg3cm95?=
 =?utf-8?B?bXE4RTB2TzYvMHdFVStva2Via0dhQVoyNUhHVEZuKytIZ3hKT0dXeVViMDgz?=
 =?utf-8?B?VUdySTlNV3lUb0dIUmNZeE5JbmRybG1Zc1l5S1IxSG1OanNJMENKWks2b2RD?=
 =?utf-8?B?ZE5OZXBFSVNyS3QwQTVvUGF6MTFMVzgvYWgwdG4yR2xndXlMa3k2OThmNzc0?=
 =?utf-8?B?SnFpYTV1MDM1SXZvaUFibWJMS1BCblJUYjJic2ZiR2JtUnNaN2lvZTVjSlRx?=
 =?utf-8?B?b1BycVpFOEpFQU9HbHA4K3BFTlZKWVZ3WHA4dXBYZmIvSWpQQjAyYWFIWlNP?=
 =?utf-8?B?SG4yT3hTRGFvMnNvVUhTc3o1RTNGdllmakRKMWhscWNheEoxY1QrM1diNGxt?=
 =?utf-8?B?TnFHOU1CaHRPV1J0cnpzK1hzZy82dk9iTHh2aWpYcWhxK0hzdXVteDNKcTRD?=
 =?utf-8?B?cWhvdHhSNk1wVVRHVExjd3U1U3k0RG1NVURqNUtoYklsQlVCY1BuZjkwd2VT?=
 =?utf-8?B?Unl1ellnZmlTeXNZS0ZHYTdVK2hkdlpuVDZ1TnpCckM3NkFaZitkM2Z3Wno2?=
 =?utf-8?B?cjc0c08xaEtQTFJDYmpXUEdZSE5wK2N1MEF0N2xpei9jeUt6SWVXcHJNQVR5?=
 =?utf-8?Q?vD+fGTvuO5boHgFAQYpuJZymCeWnm08Rw/hE+YO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6508750d-1581-433b-d06e-08d91c7aba6c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 17:06:09.1265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YD+1sANCEmo1pV2WM2DtrJEL9vK2M2rJcdDJPkrKYWb/H1PAabTlZkXLEp2JiJkynshalLFgTS3EeqXEvVonxA4WU+3iUl1Q6tOnAvXHEl0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4795
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210089
X-Proofpoint-GUID: _pqnpfc8pCv63Dav0m07y0V5UCJekna5
X-Proofpoint-ORIG-GUID: _pqnpfc8pCv63Dav0m07y0V5UCJekna5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/19/21 6:13 AM, Shai Malin wrote:
> This patch will present the structure for the NVMeTCP offload common
> layer driver. This module is added under "drivers/nvme/host/" and future
> offload drivers which will register to it will be placed under
> "drivers/nvme/hw".
> This new driver will be enabled by the Kconfig "NVM Express over Fabrics
> TCP offload commmon layer".
> In order to support the new transport type, for host mode, no change is
> needed.
> 
> Each new vendor-specific offload driver will register to this ULP during
> its probe function, by filling out the nvme_tcp_ofld_dev->ops and
> nvme_tcp_ofld_dev->private_data and calling nvme_tcp_ofld_register_dev
> with the initialized struct.
> 
> The internal implementation:
> - tcp-offload.h:
>    Includes all common structs and ops to be used and shared by offload
>    drivers.
> 
> - tcp-offload.c:
>    Includes the init function which registers as a NVMf transport just
>    like any other transport.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Dean Balandin <dbalandin@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>   MAINTAINERS                     |   8 ++
>   drivers/nvme/host/Kconfig       |  16 +++
>   drivers/nvme/host/Makefile      |   3 +
>   drivers/nvme/host/tcp-offload.c | 126 +++++++++++++++++++
>   drivers/nvme/host/tcp-offload.h | 212 ++++++++++++++++++++++++++++++++
>   5 files changed, 365 insertions(+)
>   create mode 100644 drivers/nvme/host/tcp-offload.c
>   create mode 100644 drivers/nvme/host/tcp-offload.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bd7aff0c120f..49a4a73ea1c7 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13092,6 +13092,14 @@ F:	drivers/nvme/host/
>   F:	include/linux/nvme.h
>   F:	include/uapi/linux/nvme_ioctl.h
>   
> +NVM EXPRESS TCP OFFLOAD TRANSPORT DRIVERS
> +M:	Shai Malin <smalin@marvell.com>
> +M:	Ariel Elior <aelior@marvell.com>
> +L:	linux-nvme@lists.infradead.org
> +S:	Supported
> +F:	drivers/nvme/host/tcp-offload.c
> +F:	drivers/nvme/host/tcp-offload.h
> +
>   NVM EXPRESS FC TRANSPORT DRIVERS
>   M:	James Smart <james.smart@broadcom.com>
>   L:	linux-nvme@lists.infradead.org
> diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
> index a44d49d63968..6e869e94e67f 100644
> --- a/drivers/nvme/host/Kconfig
> +++ b/drivers/nvme/host/Kconfig
> @@ -84,3 +84,19 @@ config NVME_TCP
>   	  from https://github.com/linux-nvme/nvme-cli.
>   
>   	  If unsure, say N.
> +
> +config NVME_TCP_OFFLOAD
> +	tristate "NVM Express over Fabrics TCP offload common layer"
> +	default m
> +	depends on INET
> +	depends on BLK_DEV_NVME
> +	select NVME_FABRICS
> +	help
> +	  This provides support for the NVMe over Fabrics protocol using
> +	  the TCP offload transport. This allows you to use remote block devices
> +	  exported using the NVMe protocol set.
> +
> +	  To configure a NVMe over Fabrics controller use the nvme-cli tool
> +	  from https://github.com/linux-nvme/nvme-cli.
> +
> +	  If unsure, say N.
> diff --git a/drivers/nvme/host/Makefile b/drivers/nvme/host/Makefile
> index cbc509784b2e..3c3fdf83ce38 100644
> --- a/drivers/nvme/host/Makefile
> +++ b/drivers/nvme/host/Makefile
> @@ -8,6 +8,7 @@ obj-$(CONFIG_NVME_FABRICS)		+= nvme-fabrics.o
>   obj-$(CONFIG_NVME_RDMA)			+= nvme-rdma.o
>   obj-$(CONFIG_NVME_FC)			+= nvme-fc.o
>   obj-$(CONFIG_NVME_TCP)			+= nvme-tcp.o
> +obj-$(CONFIG_NVME_TCP_OFFLOAD)	+= nvme-tcp-offload.o
>   
>   nvme-core-y				:= core.o ioctl.o
>   nvme-core-$(CONFIG_TRACING)		+= trace.o
> @@ -26,3 +27,5 @@ nvme-rdma-y				+= rdma.o
>   nvme-fc-y				+= fc.o
>   
>   nvme-tcp-y				+= tcp.o
> +
> +nvme-tcp-offload-y		+= tcp-offload.o
> diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
> new file mode 100644
> index 000000000000..711232eba339
> --- /dev/null
> +++ b/drivers/nvme/host/tcp-offload.c
> @@ -0,0 +1,126 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright 2021 Marvell. All rights reserved.
> + */
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +/* Kernel includes */
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +
> +/* Driver includes */
> +#include "tcp-offload.h"
> +
> +static LIST_HEAD(nvme_tcp_ofld_devices);
> +static DECLARE_RWSEM(nvme_tcp_ofld_devices_rwsem);
> +
> +/**
> + * nvme_tcp_ofld_register_dev() - NVMeTCP Offload Library registration
> + * function.
> + * @dev:	NVMeTCP offload device instance to be registered to the
> + *		common tcp offload instance.
> + *
> + * API function that registers the type of vendor specific driver
> + * being implemented to the common NVMe over TCP offload library. Part of
> + * the overall init sequence of starting up an offload driver.
> + */
> +int nvme_tcp_ofld_register_dev(struct nvme_tcp_ofld_dev *dev)
> +{
> +	struct nvme_tcp_ofld_ops *ops = dev->ops;
> +
> +	if (!ops->claim_dev ||
> +	    !ops->setup_ctrl ||
> +	    !ops->release_ctrl ||
> +	    !ops->create_queue ||
> +	    !ops->drain_queue ||
> +	    !ops->destroy_queue ||
> +	    !ops->poll_queue ||
> +	    !ops->init_req ||
> +	    !ops->send_req ||
> +	    !ops->commit_rqs)
> +		return -EINVAL;
> +
> +	down_write(&nvme_tcp_ofld_devices_rwsem);
> +	list_add_tail(&dev->entry, &nvme_tcp_ofld_devices);
> +	up_write(&nvme_tcp_ofld_devices_rwsem);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(nvme_tcp_ofld_register_dev);
> +
> +/**
> + * nvme_tcp_ofld_unregister_dev() - NVMeTCP Offload Library unregistration
> + * function.
> + * @dev:	NVMeTCP offload device instance to be unregistered from the
> + *		common tcp offload instance.
> + *
> + * API function that unregisters the type of vendor specific driver being
> + * implemented from the common NVMe over TCP offload library.
> + * Part of the overall exit sequence of unloading the implemented driver.
> + */
> +void nvme_tcp_ofld_unregister_dev(struct nvme_tcp_ofld_dev *dev)
> +{
> +	down_write(&nvme_tcp_ofld_devices_rwsem);
> +	list_del(&dev->entry);
> +	up_write(&nvme_tcp_ofld_devices_rwsem);
> +}
> +EXPORT_SYMBOL_GPL(nvme_tcp_ofld_unregister_dev);
> +
> +/**
> + * nvme_tcp_ofld_report_queue_err() - NVMeTCP Offload report error event
> + * callback function. Pointed to by nvme_tcp_ofld_queue->report_err.
> + * @queue:	NVMeTCP offload queue instance on which the error has occurred.
> + *
> + * API function that allows the vendor specific offload driver to reports errors
> + * to the common offload layer, to invoke error recovery.
> + */
> +int nvme_tcp_ofld_report_queue_err(struct nvme_tcp_ofld_queue *queue)
> +{
> +	/* Placeholder - invoke error recovery flow */
> +
> +	return 0;
> +}
> +
> +/**
> + * nvme_tcp_ofld_req_done() - NVMeTCP Offload request done callback
> + * function. Pointed to by nvme_tcp_ofld_req->done.
> + * Handles both NVME_TCP_F_DATA_SUCCESS flag and NVMe CQ.
> + * @req:	NVMeTCP offload request to complete.
> + * @result:     The nvme_result.
> + * @status:     The completion status.
> + *
> + * API function that allows the vendor specific offload driver to report request
> + * completions to the common offload layer.
> + */
> +void nvme_tcp_ofld_req_done(struct nvme_tcp_ofld_req *req,
> +			    union nvme_result *result,
> +			    __le16 status)
> +{
> +	/* Placeholder - complete request with/without error */
> +}
> +
> +static struct nvmf_transport_ops nvme_tcp_ofld_transport = {
> +	.name		= "tcp_offload",
> +	.module		= THIS_MODULE,
> +	.required_opts	= NVMF_OPT_TRADDR,
> +	.allowed_opts	= NVMF_OPT_TRSVCID | NVMF_OPT_NR_WRITE_QUEUES  |
> +			  NVMF_OPT_HOST_TRADDR | NVMF_OPT_CTRL_LOSS_TMO |
> +			  NVMF_OPT_RECONNECT_DELAY | NVMF_OPT_HDR_DIGEST |
> +			  NVMF_OPT_DATA_DIGEST | NVMF_OPT_NR_POLL_QUEUES |
> +			  NVMF_OPT_TOS,
> +};
> +
> +static int __init nvme_tcp_ofld_init_module(void)
> +{
> +	nvmf_register_transport(&nvme_tcp_ofld_transport);
> +
> +	return 0;
> +}
> +
> +static void __exit nvme_tcp_ofld_cleanup_module(void)
> +{
> +	nvmf_unregister_transport(&nvme_tcp_ofld_transport);
> +}
> +
> +module_init(nvme_tcp_ofld_init_module);
> +module_exit(nvme_tcp_ofld_cleanup_module);
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/nvme/host/tcp-offload.h b/drivers/nvme/host/tcp-offload.h
> new file mode 100644
> index 000000000000..949132ce2ed4
> --- /dev/null
> +++ b/drivers/nvme/host/tcp-offload.h
> @@ -0,0 +1,212 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright 2021 Marvell. All rights reserved.
> + */
> +
> +/* Linux includes */
> +#include <linux/dma-mapping.h>
> +#include <linux/scatterlist.h>
> +#include <linux/types.h>
> +#include <linux/nvme-tcp.h>
> +
> +/* Driver includes */
> +#include "nvme.h"
> +#include "fabrics.h"
> +
> +/* Forward declarations */
> +struct nvme_tcp_ofld_ops;
> +
> +/* Representation of a vendor-specific device. This is the struct used to
> + * register to the offload layer by the vendor-specific driver during its probe
> + * function.
> + * Allocated by vendor-specific driver.
> + */
> +struct nvme_tcp_ofld_dev {
> +	struct list_head entry;
> +	struct net_device *ndev;
> +	struct nvme_tcp_ofld_ops *ops;
> +
> +	/* Vendor specific driver context */
> +	void *private_data;
> +	int num_hw_vectors;
> +};
> +
> +/* Per IO struct holding the nvme_request and command
> + * Allocated by blk-mq.
> + */
> +struct nvme_tcp_ofld_req {
> +	struct nvme_request req;
> +	struct nvme_command nvme_cmd;
> +	struct list_head queue_entry;
> +	struct nvme_tcp_ofld_queue *queue;
> +	struct request *rq;
> +
> +	/* Vendor specific driver context */
> +	void *private_data;
> +
> +	bool async;
> +	bool last;
> +
> +	void (*done)(struct nvme_tcp_ofld_req *req,
> +		     union nvme_result *result,
> +		     __le16 status);
> +};
> +
> +enum nvme_tcp_ofld_queue_flags {
> +	NVME_TCP_OFLD_Q_ALLOCATED = 0,
> +	NVME_TCP_OFLD_Q_LIVE = 1,
> +};
> +
> +/* Allocated by nvme_tcp_ofld */
> +struct nvme_tcp_ofld_queue {
> +	/* Offload device associated to this queue */
> +	struct nvme_tcp_ofld_dev *dev;
> +	struct nvme_tcp_ofld_ctrl *ctrl;
> +	unsigned long flags;
> +	size_t cmnd_capsule_len;
> +
> +	u8 hdr_digest;
> +	u8 data_digest;
> +	u8 tos;
> +
> +	/* Vendor specific driver context */
> +	void *private_data;
> +
> +	/* Error callback function */
> +	int (*report_err)(struct nvme_tcp_ofld_queue *queue);
> +};
> +
> +/* Connectivity (routing) params used for establishing a connection */
> +struct nvme_tcp_ofld_ctrl_con_params {
> +	/* Input params */
> +	struct sockaddr_storage remote_ip_addr;
> +
> +	/* If NVMF_OPT_HOST_TRADDR is provided it will be set in local_ip_addr
> +	 * in nvme_tcp_ofld_create_ctrl().
> +	 * If NVMF_OPT_HOST_TRADDR is not provided the local_ip_addr will be
> +	 * initialized by claim_dev().
> +	 */
> +	struct sockaddr_storage local_ip_addr;
> +
> +	/* Output params */
> +	struct sockaddr	remote_mac_addr;
> +	struct sockaddr	local_mac_addr;
> +	u16 vlan_id;
> +};
> +
> +/* Allocated by nvme_tcp_ofld */
> +struct nvme_tcp_ofld_ctrl {
> +	struct nvme_ctrl nctrl;
> +	struct list_head list;
> +	struct nvme_tcp_ofld_dev *dev;
> +
> +	/* admin and IO queues */
> +	struct blk_mq_tag_set tag_set;
> +	struct blk_mq_tag_set admin_tag_set;
> +	struct nvme_tcp_ofld_queue *queues;
> +
> +	struct work_struct err_work;
> +	struct delayed_work connect_work;
> +
> +	/*
> +	 * Each entry in the array indicates the number of queues of
> +	 * corresponding type.
> +	 */
> +	u32 io_queues[HCTX_MAX_TYPES];
> +
> +	/* Connectivity params */
> +	struct nvme_tcp_ofld_ctrl_con_params conn_params;
> +
> +	/* Vendor specific driver context */
> +	void *private_data;
> +};
> +
> +struct nvme_tcp_ofld_ops {
> +	const char *name;
> +	struct module *module;
> +
> +	/* For vendor-specific driver to report what opts it supports */
> +	int required_opts; /* bitmap using enum nvmf_parsing_opts */
> +	int allowed_opts; /* bitmap using enum nvmf_parsing_opts */
> +
> +	/* For vendor-specific max num of segments and IO sizes */
> +	u32 max_hw_sectors;
> +	u32 max_segments;
> +
> +	/**
> +	 * claim_dev: Return True if addr is reachable via offload device.
> +	 * @dev: The offload device to check.
> +	 * @conn_params: ptr to routing params to be filled by the lower
> +	 *               driver. Input+Output argument.
> +	 */
> +	int (*claim_dev)(struct nvme_tcp_ofld_dev *dev,
> +			 struct nvme_tcp_ofld_ctrl_con_params *conn_params);
> +
> +	/**
> +	 * setup_ctrl: Setup device specific controller structures.
> +	 * @ctrl: The offload ctrl.
> +	 * @new: is new setup.
> +	 */
> +	int (*setup_ctrl)(struct nvme_tcp_ofld_ctrl *ctrl, bool new);
> +
> +	/**
> +	 * release_ctrl: Release/Free device specific controller structures.
> +	 * @ctrl: The offload ctrl.
> +	 */
> +	int (*release_ctrl)(struct nvme_tcp_ofld_ctrl *ctrl);
> +
> +	/**
> +	 * create_queue: Create offload queue and establish TCP + NVMeTCP
> +	 * (icreq+icresp) connection. Return true on successful connection.
> +	 * Based on nvme_tcp_alloc_queue.
> +	 * @queue: The queue itself - used as input and output.
> +	 * @qid: The queue ID associated with the requested queue.
> +	 * @q_size: The queue depth.
> +	 */
> +	int (*create_queue)(struct nvme_tcp_ofld_queue *queue, int qid,
> +			    size_t q_size);
> +
> +	/**
> +	 * drain_queue: Drain a given queue - Returning from this function
> +	 * ensures that no additional completions will arrive on this queue.
> +	 * @queue: The queue to drain.
> +	 */
> +	void (*drain_queue)(struct nvme_tcp_ofld_queue *queue);
> +
> +	/**
> +	 * destroy_queue: Close the TCP + NVMeTCP connection of a given queue
> +	 * and make sure its no longer active (no completions will arrive on the
> +	 * queue).
> +	 * @queue: The queue to destroy.
> +	 */
> +	void (*destroy_queue)(struct nvme_tcp_ofld_queue *queue);
> +
> +	/**
> +	 * poll_queue: Poll a given queue for completions.
> +	 * @queue: The queue to poll.
> +	 */
> +	int (*poll_queue)(struct nvme_tcp_ofld_queue *queue);
> +
> +	/**
> +	 * init_req: Initialize vendor-specific params for a new request.
> +	 * @req: Ptr to request to be initialized. Input+Output argument.
> +	 */
> +	int (*init_req)(struct nvme_tcp_ofld_req *req);
> +
> +	/**
> +	 * send_req: Dispatch a request. Returns the execution status.
> +	 * @req: Ptr to request to be sent.
> +	 */
> +	int (*send_req)(struct nvme_tcp_ofld_req *req);
> +
> +	/**
> +	 * commit_rqs: Serves the purpose of kicking the hardware in case of
> +	 * errors, otherwise it would have been kicked by the last request.
> +	 * @queue: The queue to drain.
> +	 */
> +	void (*commit_rqs)(struct nvme_tcp_ofld_queue *queue);
> +};
> +
> +/* Exported functions for lower vendor specific offload drivers */
> +int nvme_tcp_ofld_register_dev(struct nvme_tcp_ofld_dev *dev);
> +void nvme_tcp_ofld_unregister_dev(struct nvme_tcp_ofld_dev *dev);
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
