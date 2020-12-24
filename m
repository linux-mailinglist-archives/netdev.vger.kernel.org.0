Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8971E2E253B
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 08:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbgLXHdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 02:33:12 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61990 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725747AbgLXHdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 02:33:12 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BO7QeX5021134;
        Wed, 23 Dec 2020 23:32:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=qyAtjEJh0oGiL51M+hEsi+h4PaIYCIN/7tFxMM0uvpw=;
 b=Q2T8B08IoDWKvQU5aOCczYzZm50p5dHZvfb3FvpU5GABW3OUQ9SOtkRFdXOC374ecDrN
 nG+z/GgO6XxSypWAaK7iz92o36m9Ca9w8X3lxSa5qegdIOX3On7+z9U18CsFyubQO+6H
 xc/2EG5U+y27hml72OQFee9zplPwEEQdPUA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35mfabs9j6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 23 Dec 2020 23:32:06 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Dec 2020 23:32:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nK/8dj5Q7c1tIHM5c5tzRwDexmh+JNCrXX9BEVPX1FL6KGz8omFZOldcc/+KGhuuOUVhPXhNVPcVBsRoGhTpwDbu/yU+xTUuJDOcaWucIMw9d5U2PpDPEL5xaQfawdo1cIGdXAiwfNQhs4A7xLh8OvRmGpbOdotZkjxMFbJWTZfQ5aKL7G7lgUk/kc4wwuoriiS2VPjs+GSqUXHA51b1QST7Rs6HtoX5jcIHYvd3VEUhSTr9DrXhIfYNyvA2QwCzMKLKSb0dUsxqDhcpBnJ18TcGTT7X5w0NkwXnQLz8gSr6UXXnTIptBRwj8m5p1xCi/GiLusbl6YD+XKAiLngPPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qyAtjEJh0oGiL51M+hEsi+h4PaIYCIN/7tFxMM0uvpw=;
 b=QShbKrTCpHSWwhhkOKauv1OSj+EUbZ5yDByrTBrpFs2A2w/A7AtRIJB4Po7AYVeoAcUMOWIL8Htc373b0SXJAfnY9XEGgu9LJ7lqm10T0HKBF6ZrWtYihZyqsBmJ1z/MPGY4sMIH/bSJT9nmPyynKu5WS1aKU+6O5wnjJFPSwOAILd5iGIqG3j00UNWc75kKds4+15oxHwkn5nYpyRVdYmZry7WwyFGj9TV1w/NLXA85+s9vGpbv8Nn3vXAguvsKqQtQyClQ1DGv0Mk2m9IzR7rgyj5+imlMB3KW1G30IBuwSkVv5EXiinMnIqW+zDjV643Ym0pE95kFg67GIWNNTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qyAtjEJh0oGiL51M+hEsi+h4PaIYCIN/7tFxMM0uvpw=;
 b=IZzn5F0pURRhgp4TmKhxua6seRcfZP4HMxD+qM5YCrKBfSN5z4ThOaGqxFlqn3mKynOcT3Ng3XglM7Tybj36+/163R3RGHpEs27aPitwRIbkfh4ug2Y14eyjifbP+fPjZWDMH5zwld/gmyKA+WZdLWTcKu9B5OX8MrV6Y7GbnnQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2246.namprd15.prod.outlook.com (2603:10b6:a02:8d::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.30; Thu, 24 Dec
 2020 07:32:03 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3676.034; Thu, 24 Dec 2020
 07:32:02 +0000
Subject: Re: [PATCH] bpf: fix: address of local auto-variable assigned to a
 function parameter.
To:     YANG LI <abaci-bugfix@linux.alibaba.com>, <ast@kernel.org>
CC:     <daniel@iogearbox.net>, <davem@davemloft.net>, <kuba@kernel.org>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <kpsingh@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1608793298-123684-1-git-send-email-abaci-bugfix@linux.alibaba.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <bd622b3f-7912-e61d-8101-379ebbdf094f@fb.com>
Date:   Wed, 23 Dec 2020 23:31:58 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <1608793298-123684-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:20ab]
X-ClientProxiedBy: CO2PR04CA0139.namprd04.prod.outlook.com (2603:10b6:104::17)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::135f] (2620:10d:c090:400::5:20ab) by CO2PR04CA0139.namprd04.prod.outlook.com (2603:10b6:104::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27 via Frontend Transport; Thu, 24 Dec 2020 07:32:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67040cb3-7c71-445c-077f-08d8a7de01ea
X-MS-TrafficTypeDiagnostic: BYAPR15MB2246:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB224679D02BE2606D18AA315CD3DD0@BYAPR15MB2246.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O/u2nNteFuuAaRF1ZpdWFMjamFgd+WNgf+aw21Bcq4UeftGCb0Hlon7tG74WqaUYmaiJU/inVCICkoH4xuqOC9vM0/vMst1nbrVBOs5hD1V41pLVDUGtlvovsVcjS3gVpsXrx5iS5213R6g1UjewTLG0ag6Y84fnzVhWVFD0P1YFUcoFN2cyiT0GeBZ5spm+C8A3o/+W+AnUdYC8SFgobjgXYqa5FpJvjVLz8l6/0mFfPFCWPW985CpprUfLbpKKn3FN5/XK4hPOZ2UNqyerggJb1RiY1qITSbdBVzDzzpu+oh6MQhLPtQaEqM/tWMSrEe1m86u02oodHwkfckEsWGT7nkBxfy3cKkSNU6i6/if7FDmO+jhFf7eF+4O3R/6TUTPm6KuFGCieU2BIl/eoPlGq7Pc3temHsjaYbYlCwVs821He95AMM5mGDpp8nK3zSlJB6sBn4dxHyPzIghS2sVUZi+is7J1Jx2LQcdngwGg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(136003)(376002)(346002)(2616005)(8936002)(4326008)(36756003)(31686004)(6486002)(7416002)(83380400001)(6666004)(66556008)(186003)(86362001)(316002)(52116002)(8676002)(66946007)(5660300002)(478600001)(53546011)(31696002)(2906002)(16526019)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TFBmcFQrZ2lHbC9ybjlMR3FNcjNWbjVMZ0hpMjBmK0VqS3NuZFdmeHo2WmNi?=
 =?utf-8?B?NGlDM1JpcVZVbmsya2oxZlBSbVlXd2hGYWN0aGlld3ZVcVZodEdVMHVlYytX?=
 =?utf-8?B?L0ZzcDF6ZWlIOFBUWlFYK2w2NW9nbk9oKzdPQzdEWjRYQ0hlU2lWZ016QzZs?=
 =?utf-8?B?NklUU0wvcVE5cGh2RC8yd1FWb0FoQ09vT0thM0VKWmlPNHhtR3NCSm9NWWtl?=
 =?utf-8?B?ZThydjQ2RUMrM0lSZW1PM3FUM0pxaXZsVTYwbTRNYklwLzZ6S3VMZGVNeUdU?=
 =?utf-8?B?WkVDNFNpK1FINlN3YUVVeC9WV0hpQmhoS0x3NUlKeWdGYXJZVVNkOElLZmtv?=
 =?utf-8?B?RjU1ZnZMZGxhOW9yYUxyZ0hVcUg1U3FZNVkvUzNRaENHQk9HbitMRGxFRjFM?=
 =?utf-8?B?M0djcmErdTVJM0RvZUV3VmdVbHlxc2IrUHBHZzlwblVCWlZ5bFk4QWl1Q3lG?=
 =?utf-8?B?VDRYdThMRy9xWDJkN0dZajg4eVRQbTZ6TmxqK01hZHl2RTN1eFpHcGY0V1JG?=
 =?utf-8?B?dFNXNFRwQi9pTzVsLzZWUXBVS0c5L1NSaWhOL09TL3BjMzRKNDlaZ2Qzb3Fp?=
 =?utf-8?B?T09vekJBdEJWNytSMXBFUjQrOFg1TlRpN0VoYzBpVkpHZ1U2MUhPTHpLSEMr?=
 =?utf-8?B?b1ZZTkJ2MXo5S3gwMXhKN05SUExaUGJYbnY5czk4a3llaDh1VWc1VXN0NElO?=
 =?utf-8?B?STdUbVhtTTdocDlUeGVFYXRmd2x3SW51YTVoUlpweDl2eHd3eUk0UG41UDdh?=
 =?utf-8?B?T1dtVHRreVlBb2E4bFVCVHhjckdEbkFSeDVGbVdRVEpRc1llZk1vMm1wWkk3?=
 =?utf-8?B?NlBlK3FNbGxXeEdpLzBFUFl3blpqVXZTVUtRbW1Ea2FHc1RZTnB1RWVQVkR1?=
 =?utf-8?B?YnQyRFN2YXVXTEtENitjOXo2aWRibkVpNXpOK1hSRUxZdDV5UUdZZXlkZi9C?=
 =?utf-8?B?ZW5LVlJrYTR0N3crR0pCbzlBQzloeXNGSWtUKzBYcDlQcEcrSmJlMlVsL2R2?=
 =?utf-8?B?ckUxYjRsekpQS29zcVNlZ0NHVVQ4eTl0OE56czA1bk5PcTZZZEg4M1ZzSzR3?=
 =?utf-8?B?UjlXQXErd1orS3Fra3FtSUVGMGlTZm9kY0huUkdpaVcwWWxDbWRYcURvcEV6?=
 =?utf-8?B?Zjc2bU1yVnpraW16L1NVY0JTVStyeVRpdkZJWWY2M3NPUWt2WmdoVXdJREZT?=
 =?utf-8?B?Y2FkOGVFbStJQmxweDI5QTJRdjVKNk53bmtEblNVVDBwRlllUExYbVQ1cDlh?=
 =?utf-8?B?bGNyOW9INnZsKzlNd0t1WWlUUXVqaEtFQ3FlWlYwZzFhTlE0RUJSOXJRRFdq?=
 =?utf-8?B?RlNWcmRobThlc251Ry9vRHFpK3NSalV0NlBuamRXK0piUGR3OTZ1Wkc4bFo2?=
 =?utf-8?B?R2JLVmtMaHhPRkE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2020 07:32:02.8808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 67040cb3-7c71-445c-077f-08d8a7de01ea
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xFSsyfkrwKvw65EeCqZ8PcJQkoyWTTB0o7w2mBMaVkKI4JiR4TwZs/NH1avbCqfA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2246
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-24_05:2020-12-24,2020-12-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1011 mlxscore=0 bulkscore=0 impostorscore=0 suspectscore=0
 phishscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012240045
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/23/20 11:01 PM, YANG LI wrote:
> Assigning local variable txq to the outputting parameter xdp->txq is not
> safe, txq will be released after the end of the function call.
> Then the result of using xdp is unpredictable.
> 
> Fix this error by defining the struct xdp_txq_info in function
> dev_map_run_prog() as a static type.
> 
> Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
> Reported-by: Abaci <abaci@linux.alibaba.com>
> ---
>   kernel/bpf/devmap.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index f6e9c68..af6f004 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -454,7 +454,7 @@ static struct xdp_buff *dev_map_run_prog(struct net_device *dev,
>   					 struct xdp_buff *xdp,
>   					 struct bpf_prog *xdp_prog)
>   {
> -	struct xdp_txq_info txq = { .dev = dev };
> +	static struct xdp_txq_info txq = { .dev = dev };
>   	u32 act;
>   
>   	xdp_set_data_meta_invalid(xdp);

exposing txq outside the routine with 'static' definition is not
a good practice. maybe just reset xdp->txq = NULl right before
function return?

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index f6e9c68afdd4..50f5c20a33a3 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -475,6 +475,7 @@ static struct xdp_buff *dev_map_run_prog(struct 
net_device *dev,
         }

         xdp_return_buff(xdp);
+       xdp->txq = NULL;
         return NULL;
  }

-bash-4.4$
