Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A364938CC08
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 19:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhEURYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 13:24:10 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:35736 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231865AbhEURYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 13:24:07 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14LHCghw017513;
        Fri, 21 May 2021 17:22:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ZTsygH6mblFDw8MoUh1s+AUBraJt9QQfeiFBgR8qFu0=;
 b=h9sthdOVBYpXX0Excaxc9IqlLbmqDKZTn7L3Y/PZWv3yWG3y7MmxNDO9Fvi5QLInR8nB
 g1gVUvJ6KU71pxvEBK9QhAv6G0YCL1sIvW2J63kQ0GFOTt7VuMZsBjJ0JYBhVuo/7VhX
 QvNIyWwtAkMxXUlrnMXLhsyn/E6pypqgjQqEknAEId4cU/Dz5JPvQJ2xmBGHzWzEJqaq
 1KlZVkKZGK/6Mmvwvpi7bY7v8Wn5WZIs41BQ/h3AuobLk/D40nZhqaOdW05RaFQV/IaH
 BHP/SZrz4i+3XJTcTjHY/RklX3Jc00IG0UNdgeFvMKedInOi93BwOcD8p/FLXko9nQOT Hw== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 38n4u8ryxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 17:22:31 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14LHHTgC054541;
        Fri, 21 May 2021 17:22:30 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3030.oracle.com with ESMTP id 38meehxgcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 17:22:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNTP91HyVf0vRKmmwZ03QK42tb8JJP5EWqHf0qIROi3T604LzPEk+XauNvxaqDCMxSfC98yBIOfOE78xvH+39KVX6mHpATfn1nKnwaFVJpQJeGbBxXzMQW3U5LmFwQFOwXuWpul9J6dhLjknJZrYIID0xPGYxDf2brFSsKkQU/wW1zosG6S9WFQDYNuTtItuzBlWTxK7DkddbR6fC1jWDNlxKYeYbWeL04h2p1iNesMVnpC/kiij9wWECsirf+QC/pIQJqVK5PdPWwA0JrkcUqs1i6Pks29O+jhjWNiaSjIerlhyjnFNyfyrFuzWHCkQfMjd1KdsNuXZG03gXBNqEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTsygH6mblFDw8MoUh1s+AUBraJt9QQfeiFBgR8qFu0=;
 b=nNFMZGPnvZKQgA0tIelBs7jsb/asVkLRQpFI/x16JK2kfGNf+xPrQLCxhwEHdkQTLwJGLMu6qT+ERc0Ab/04UTvGaMUCiD56SMqw64mOx3t4QudpJhBd+ui83otJR+0Ef4CEgmaRc1912Gc2LC+agVdwlNX54hXWYFzwwzUjC6pb+HmXZh7umVcSlK3rmzKRfPiaijqjOH7CjHfR4RV7XKiGpOhEhXe16aTRLW78CsPJHtRq/oAR/UtEc0tyLqqdR2lytc/65CXfQal5Dm3WCLiQxcvEFyE0msHMni0+eYkKMz2FWFlRNE2ZWwtIsK/2LeUC0k/2EGa+IBdJaxkFVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTsygH6mblFDw8MoUh1s+AUBraJt9QQfeiFBgR8qFu0=;
 b=UmmsYfLVKPRQY+0qKExz6SuSqs33dMHIKq8r3y9r+LkWKS4LqTLc0IprMHpiOBYvlRjZpuLNV+U8tpKP8gEJtdrgaYDpb4F9Zpw3jIwOk1eg3P1SO22W3+BUO3dKzvj3ih/i9VZ+qqt5HY7JLLhxP7HB2kayM/uMX/2X/MMUiXQ=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2511.namprd10.prod.outlook.com (2603:10b6:805:41::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Fri, 21 May
 2021 17:22:28 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4129.034; Fri, 21 May 2021
 17:22:28 +0000
Subject: Re: [RFC PATCH v5 03/27] nvme-tcp-offload: Add device scan
 implementation
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org
Cc:     aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com,
        Dean Balandin <dbalandin@marvell.com>
References: <20210519111340.20613-1-smalin@marvell.com>
 <20210519111340.20613-4-smalin@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <3566d254-aa68-d3e2-5333-8d6b1ff367d2@oracle.com>
Date:   Fri, 21 May 2021 12:22:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210519111340.20613-4-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN4PR0701CA0006.namprd07.prod.outlook.com
 (2603:10b6:803:28::16) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by SN4PR0701CA0006.namprd07.prod.outlook.com (2603:10b6:803:28::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Fri, 21 May 2021 17:22:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb09dc8d-d0a7-49e6-b6d7-08d91c7d0232
X-MS-TrafficTypeDiagnostic: SN6PR10MB2511:
X-Microsoft-Antispam-PRVS: <SN6PR10MB25112344ECE2DF03745EF215E6299@SN6PR10MB2511.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:556;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 587GGknoNQYCa3bGyOSuY1JCLhOgnEHTP3JtMNxzrV4YVjlVBVlx/HGdk+HKUZNScuf36cT0dRljCQB/4TvLsHOitZfnjsCMoXiV6of71seT760FiqBPa+C8kne307cDPHn4/FoQloUFckDLjGHTVArzeFKb3WuabpXABqyF7S9SZr+bZ5/5mAgZubdDn8uUwS8al/pAb+DTEuV2d3mPneYvML/8st28KXXlnl1TLWQCxKticxYw7KQKtLaSf1o6qdN29JRf24pHwaHB9VxJXUkujOsFqgbcFdpHyw1C1ZxneBNRh7WsxuYt4MI3sglXComnyu4hPbcWXxO4FYdoRyVbHjqxik8gUd0ZMLSS2ScAguRqmNAp5ouM5tC4rrg1vg5YODjKLx1GpRsxBJ/5dRxTHc1RckJgQ5JkMeZ+KF4xIgEWelRVZTw/Y9OgNbDsG83kQmpH87FjvTtP7vQFqdhOrPmEZIiLQZYQ/2aKxvthDPL2bwqyYt9qs3wL+WmTG+9Zq5gNpHZdaZDmI99stIBoDiQ1Ej11c6koYoVXgFGQt3DWRH+qyziNq6C6zzS6Ymtjss3a5rBC5kf6soBy2ykqodi3w+m8zQLrGkHJHfUf10V+DXnHZ+lcBlGf9pdPvliX4TnhQEXiRBGfYdTYHA3BbDckRQkCTem6pK+jbKvf6c/Ebv2lHsI7CrVLXNcM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(376002)(366004)(396003)(26005)(83380400001)(2906002)(53546011)(7416002)(36916002)(2616005)(956004)(4326008)(6486002)(66476007)(16526019)(44832011)(86362001)(8676002)(478600001)(36756003)(31696002)(66556008)(316002)(8936002)(38100700002)(5660300002)(16576012)(31686004)(66946007)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MVo0dXZQMk9NaFNpcDd5NUlZSk9vb1VnaUhVc2wyWEgvQ3lucTM1ZUc3MnRo?=
 =?utf-8?B?cm40WG1pek9xOGZHTVdRTkNHbTRBbTlsSXhyZkFtK2UrZElwQ3R4WmJBcVBn?=
 =?utf-8?B?eXRpd295aFFNTk1CejU0dmVlQllFWTdBd0JETE1SUi9ISEFIQ0J0endieUpP?=
 =?utf-8?B?MmlpNlFoZDZ5bmZaSHlyN0xsSjd3MW5mRUZuRFRwWFlxNGtOcEtlWlJHL0Fy?=
 =?utf-8?B?QThoNU5JRWhiSHFjM3F1dXlkVm9kaFZyYURYZ0lRSzRDR3VPY3hDWlhVTGx0?=
 =?utf-8?B?NGhWZmRGNXNjNFQ2WTdXamtNMWp0ZENDSFlFTnRiT3hJYnNXMkt0ejRuUWNQ?=
 =?utf-8?B?TEtSc0hwRGcvWnNPbFhGU1hubHV4d3RDSGptTjQ3dnR3dkJ3ZjFrdmVhR2hC?=
 =?utf-8?B?S3ZjNmNqSWUvc1MwWGdKTGNVaE1EMzdidEl4S1NMUFA2c0czMXFyeDM3TVor?=
 =?utf-8?B?aVlTakpHSGhRZkZlSlZnN2dWK25semNzSWlZRjh4dVVvdGQxNkVudmY0Z1lt?=
 =?utf-8?B?Q2ttbmZMSWVlSUwwazhTQ0JYeUJoWVFjN2Qya0RpTkI5N1VwMnN5MUlSdTFv?=
 =?utf-8?B?WWRNWGZCWnhhUnQwL2NmRmRJWjFLdVJoYUNXTzMza24vUG1tR2xvZHdqeTJr?=
 =?utf-8?B?QXZhU0xSdG5kQzNYMlkvQUpGUjhKcklteFp3bFRUUEFBSmtvVUJmUVpYejZI?=
 =?utf-8?B?eEw4SEMxZGVaVEhrc1FGVXpUbEkxemNxSDdwRnBlL2llUjVnd3pwUkpFNTBN?=
 =?utf-8?B?QVE2Qy9WMDI0VXhtcnZVMGxDZTJjYVkyY0l4VzAvdFlmWXEzdjVxTHZjcXR5?=
 =?utf-8?B?T2lHUE83UDQxb2dpY2NndHBGdHpvOEY0ODEvOGFJSkJaNmZaejQ5RWpwVGF3?=
 =?utf-8?B?MXRWT0xRUzVtZ05mZ3ZDUXNSdVRwMG05cXR4NHJib1JoQjZVWFVrMEhvN1dO?=
 =?utf-8?B?UVJ1V3ppTk5KRUxzS2ozZTFMNVg0K05xcWRFaDNaSVpWT2NHMllJQVp1MmxH?=
 =?utf-8?B?WlJIMHJ3Z1piWHlyS3VOZVJ6UHFiWjZIUERzcmkrZ28yUCthZTU2VTB0ZERY?=
 =?utf-8?B?cDQ2Y0xDY2JWbWd1STdHYnQ4R013di9maXU3bWd2MHl5UlZZSFZaaW5pM0Nu?=
 =?utf-8?B?SXBoYS9KcXFNYUUxdFJHZEowVmFlcDNLYjVGSDRUNVZNZUkvZDZ6a3J6b1NL?=
 =?utf-8?B?Z3NJVk9ORlcxWEdna0ZUMWp2MXR4aU9CZ3FxYytmZlhKOW5qS1dhc0FBZTdG?=
 =?utf-8?B?M3ZZNXI0aUlua2lQMkVqTnhZODh0MlVsYTZlZGQyVEtUQzZqM0xxemlMT3ZN?=
 =?utf-8?B?TUxKS1FWMXp6bHZwb1k4eHdlSWdod2tseEpxaWpLN2wyeGsxdUQ5YWkzQkJz?=
 =?utf-8?B?aExCVjBXZXM5anVwRnlkclZCUzRxV0NSa1B0Z2xaY1VPZFhLUzJQeG9ySTBX?=
 =?utf-8?B?eFpVbXRiZ2FYckMrUmxNbXo1YXorY0ZqVEZ0OWRpVVlPQUlqdkc3QVozYXJM?=
 =?utf-8?B?RE9QbDQ4TDlEWVNQSEthbFJyMVNzTmhDSkNLRWxSQ1hBY0VqSXZzeS9tekhD?=
 =?utf-8?B?bHhZaFNJZ1NmNVBqekFDRFVRU2Y0OFlWYXZoaHJtdmFYZDFoQ054QVpVOVJa?=
 =?utf-8?B?MG54Z2dlODNaRnBlS1dZd2F6SitrQkVGTzZVT1JKdkszOU4wVjFQZ2Ixcmhk?=
 =?utf-8?B?NDEvNFhlZVN1cHdIM0tPdWtjMTV1QVVqMnNsNXhJeStSVzNQSWRFRk1DanZR?=
 =?utf-8?Q?WkrXmq6teeH57ULyPcJ0yTjKMK+NKuCc0wcdJzV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb09dc8d-d0a7-49e6-b6d7-08d91c7d0232
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 17:22:28.5382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1UEyalLceDbTkXhEfCkaHRPGR81BPjzAWQxfVCxoCu0lLyFMEcod1Xr1daS7D6FGnSnRVGxyCNHYiGgfHGvzOj/TX2K6Eyyvy00CTj/NpLI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2511
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105210091
X-Proofpoint-GUID: Ts_P3UUsySQzPbbLu3eL62fHN4QFbGWi
X-Proofpoint-ORIG-GUID: Ts_P3UUsySQzPbbLu3eL62fHN4QFbGWi
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/19/21 6:13 AM, Shai Malin wrote:
> From: Dean Balandin <dbalandin@marvell.com>
> 
> As part of create_ctrl(), it scans the registered devices and calls
> the claim_dev op on each of them, to find the first devices that matches
> the connection params. Once the correct devices is found (claim_dev
> returns true), we raise the refcnt of that device and return that device
> as the device to be used for ctrl currently being created.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Dean Balandin <dbalandin@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>   drivers/nvme/host/tcp-offload.c | 94 +++++++++++++++++++++++++++++++++
>   1 file changed, 94 insertions(+)
> 
> diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
> index 711232eba339..aa7cc239abf2 100644
> --- a/drivers/nvme/host/tcp-offload.c
> +++ b/drivers/nvme/host/tcp-offload.c
> @@ -13,6 +13,11 @@
>   static LIST_HEAD(nvme_tcp_ofld_devices);
>   static DECLARE_RWSEM(nvme_tcp_ofld_devices_rwsem);
>   
> +static inline struct nvme_tcp_ofld_ctrl *to_tcp_ofld_ctrl(struct nvme_ctrl *nctrl)
> +{
> +	return container_of(nctrl, struct nvme_tcp_ofld_ctrl, nctrl);
> +}
> +
>   /**
>    * nvme_tcp_ofld_register_dev() - NVMeTCP Offload Library registration
>    * function.
> @@ -98,6 +103,94 @@ void nvme_tcp_ofld_req_done(struct nvme_tcp_ofld_req *req,
>   	/* Placeholder - complete request with/without error */
>   }
>   
> +struct nvme_tcp_ofld_dev *
> +nvme_tcp_ofld_lookup_dev(struct nvme_tcp_ofld_ctrl *ctrl)
> +{
> +	struct nvme_tcp_ofld_dev *dev;
> +
> +	down_read(&nvme_tcp_ofld_devices_rwsem);
> +	list_for_each_entry(dev, &nvme_tcp_ofld_devices, entry) {
> +		if (dev->ops->claim_dev(dev, &ctrl->conn_params)) {
> +			/* Increase driver refcnt */
> +			if (!try_module_get(dev->ops->module)) {
> +				pr_err("try_module_get failed\n");
> +				dev = NULL;
> +			}
> +
> +			goto out;
> +		}
> +	}
> +
> +	dev = NULL;
> +out:
> +	up_read(&nvme_tcp_ofld_devices_rwsem);
> +
> +	return dev;
> +}
> +
> +static int nvme_tcp_ofld_setup_ctrl(struct nvme_ctrl *nctrl, bool new)
> +{
> +	/* Placeholder - validates inputs and creates admin and IO queues */
> +
> +	return 0;
> +}
> +
> +static struct nvme_ctrl *
> +nvme_tcp_ofld_create_ctrl(struct device *ndev, struct nvmf_ctrl_options *opts)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl;
> +	struct nvme_tcp_ofld_dev *dev;
> +	struct nvme_ctrl *nctrl;
> +	int rc = 0;
> +
> +	ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
> +	if (!ctrl)
> +		return ERR_PTR(-ENOMEM);
> +
> +	nctrl = &ctrl->nctrl;
> +
> +	/* Init nvme_tcp_ofld_ctrl and nvme_ctrl params based on received opts */
> +
> +	/* Find device that can reach the dest addr */
> +	dev = nvme_tcp_ofld_lookup_dev(ctrl);
> +	if (!dev) {
> +		pr_info("no device found for addr %s:%s.\n",
> +			opts->traddr, opts->trsvcid);
> +		rc = -EINVAL;
> +		goto out_free_ctrl;
> +	}
> +
> +	ctrl->dev = dev;
> +
> +	if (ctrl->dev->ops->max_hw_sectors)
> +		nctrl->max_hw_sectors = ctrl->dev->ops->max_hw_sectors;
> +	if (ctrl->dev->ops->max_segments)
> +		nctrl->max_segments = ctrl->dev->ops->max_segments;
> +
> +	/* Init queues */
> +
> +	/* Call nvme_init_ctrl */
> +
> +	rc = ctrl->dev->ops->setup_ctrl(ctrl, true);
> +	if (rc)
> +		goto out_module_put;
> +
> +	rc = nvme_tcp_ofld_setup_ctrl(nctrl, true);
> +	if (rc)
> +		goto out_uninit_ctrl;
> +
> +	return nctrl;
> +
> +out_uninit_ctrl:
> +	ctrl->dev->ops->release_ctrl(ctrl);
> +out_module_put:
> +	module_put(dev->ops->module);
> +out_free_ctrl:
> +	kfree(ctrl);
> +
> +	return ERR_PTR(rc);
> +}
> +
>   static struct nvmf_transport_ops nvme_tcp_ofld_transport = {
>   	.name		= "tcp_offload",
>   	.module		= THIS_MODULE,
> @@ -107,6 +200,7 @@ static struct nvmf_transport_ops nvme_tcp_ofld_transport = {
>   			  NVMF_OPT_RECONNECT_DELAY | NVMF_OPT_HDR_DIGEST |
>   			  NVMF_OPT_DATA_DIGEST | NVMF_OPT_NR_POLL_QUEUES |
>   			  NVMF_OPT_TOS,
> +	.create_ctrl	= nvme_tcp_ofld_create_ctrl,
>   };
>   
>   static int __init nvme_tcp_ofld_init_module(void)
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
