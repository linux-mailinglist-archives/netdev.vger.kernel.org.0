Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C3B1D7057
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 07:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgERFYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 01:24:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30862 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726040AbgERFYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 01:24:32 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04I5Nkmp023622;
        Sun, 17 May 2020 22:24:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=6O2tVz9Vlpr6V6jL+mTZ/sZ3nxUA4A7bM22rW4av/HQ=;
 b=PoS8JaQZ1Xr0mDFIHKnmCf8u94U9kIOFm9EMSD6ZN//EwU2GVtiymQwV90+0nyEpBwFb
 qUpP5AE1pyXOFNAzr+2zaPyPgJJThvNFKe5QWk4JWV9kEOme+eJgBWvrQcCzf09tnaik
 S88ptjHumRgmR9tHsYLyWNReAHbXgagT5a0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31305rg4u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 17 May 2020 22:24:19 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 17 May 2020 22:24:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IwqobRkjgbrqeIzqbB/0//DCZsqWlUTYlnQVqTh8vqId4vAQw5jE4+A1flcxyRkwL0Xc74kvEVGWe3YtP3UqE0zolhx6dUGxL7fB5A9IhYCEL15HC50vpxhNyJrQwdC/cz7ZADSOJzn/DjjbSsBq6Du94X01IXzFzETemxQuz0JABtJ/Shf+HT03CWE/zEW9eM8V3IoLaL265x4Tqv7znQnCe4egVzkR01Lq4G4FyxayligA6VPSSc1CjC760OaCU3aJTrpTd/bx+S+AU7angN516II8Eikrnsgnlouv9U3LMjlOnmxFRVvJjW7syoTh3mIWGOILlsttHUqUFWnGyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6O2tVz9Vlpr6V6jL+mTZ/sZ3nxUA4A7bM22rW4av/HQ=;
 b=SJIbndZGa7hQqkIlMnwK3QKmjRMFy8imwzU4VIRXx5W7iFXZaq2muNtAvWLj7JXiQS38EPvXSFXSIS0dizX4u6VT911CX4dw9A1ZPLnffkbSVD3tvMgbkYymfIrz3RlFJ17rl4ZbMLYU5wWRu/UPZsHmQRPs9QYuRcZbNTGrmWGRkE6k1BQh2At2FucdxjpfbqM+oTvONP2hT/y6of+bRbRfirseCGIsfIsFVZnMR2d1JcLrkQ78DgsTYdTRlySNww2qvCqo24iigxywQ74o8NoooERIl5HjAldajsUKORNW1EfaoBvbkkcOJVhV9NcJZqHddn8JlOnQn72Dfd30Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6O2tVz9Vlpr6V6jL+mTZ/sZ3nxUA4A7bM22rW4av/HQ=;
 b=AtMO0Qa73tePQsmJo2vUJjvth8uckjcnb3TIQ+4G+a58IQkZhFYSRYd+8Ykn0e5WVUUqu4WBQBm1w7hr7HfMmPmthpab3OYz9fVJyZYUx2wSjla3jgRfYsodBu1GaFmwsZMHv5p5LWawvYlv7T3BgbC3jH6b1YgDcgaF+cxq2Pg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3350.namprd15.prod.outlook.com (2603:10b6:a03:109::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.27; Mon, 18 May
 2020 05:24:17 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3000.033; Mon, 18 May 2020
 05:24:17 +0000
Subject: Re: [bpf-next PATCH v2 3/5] bpf: sk_msg add get socket storage
 helpers
To:     John Fastabend <john.fastabend@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>
CC:     <lmb@cloudflare.com>, <bpf@vger.kernel.org>,
        <jakub@cloudflare.com>, <netdev@vger.kernel.org>
References: <158958022865.12532.5430684453474460041.stgit@john-Precision-5820-Tower>
 <158958039839.12532.8701091377815048145.stgit@john-Precision-5820-Tower>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <5fe5a7d7-047a-aac0-b26b-a73806819cd5@fb.com>
Date:   Sun, 17 May 2020 22:24:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <158958039839.12532.8701091377815048145.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::37) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:39c9) by BY5PR03CA0027.namprd03.prod.outlook.com (2603:10b6:a03:1e0::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25 via Frontend Transport; Mon, 18 May 2020 05:24:16 +0000
X-Originating-IP: [2620:10d:c090:400::5:39c9]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c8077c3-1fad-4602-bbac-08d7faebb5b8
X-MS-TrafficTypeDiagnostic: BYAPR15MB3350:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3350BA913A8FE913F5E17B8DD3B80@BYAPR15MB3350.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 04073E895A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WkUgTKi3CYA2tNxSc0kUj7AhsGKTqJKGY9BjveBKx3DzlCPsMCf2TGp8DYcIlPfyT9hF5P1BGSMUZ3V9bcAxgTpBguWdnxRNU09INhWTyOSGVFyyb7S1mIA8eHJ7neWGekX5j4+olKV7JY5xAhrRPkasIS1zp/NoqPfrdcEQvhkDv5EVVjZRq2DXxFI3GbZndWg8YdZGVD9OvU+mahbGKboSrnLZ+HcUBPoCzuzKvQuZDEhMl+Vzug8zSc4/7EOt+I60pdjWdBYemdotj2fYkby8SHhvsC3/za111MU9oRplluvwyDyMsqR9KE2IYWWa2AghLeageddc0m46RcldxJUNO7irLjjoOQaSbDSlEW63ijnsQ6BdrJkbgg49CSFbIQnnQz+2wWCMxemV5/XyFej1PmcKQ1MCgI6pCejl890kByEuFLG7DYBCjmZ5sQKgSpo5X6LRvXw8LuF3SXkFB9Jgqnamj8xv92kPUa0ZI4cSExPXDHVBLBNBA7K0TuVS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(376002)(136003)(366004)(396003)(346002)(6512007)(31696002)(52116002)(8676002)(5660300002)(8936002)(4744005)(478600001)(86362001)(36756003)(2906002)(31686004)(4326008)(6486002)(53546011)(316002)(6506007)(16526019)(186003)(2616005)(66946007)(66556008)(66476007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: M1BQcYnZrSjC8iCDicUUs3EtmyGieGF8REeyvc34nViSl5bm/NdTHWaX/EvGSFj894lTqkktBIez6KH26at+giQLwcBFypYPvME9nw6kU7v7CQQie/pCSJFLnDeJyL12G9uSWBvq1it+cwRA+H0yDf0iRMrKBeBjZco5KpU4JzR+gqsa/ZDHIT5VATio52d2nLX/O2smfKwflCxGKhAUSvEf/nc3k+UZsOr+Me8p8NG8//M/+AvPqRwaaDalrF2s8Ikmj3a1+grro4mNCE5+PJTzmklBVbGmaz8WMJ2RtAotd7V8FgZPxPAQCMssXh6rlDp8QOS4nYB1w/k+w3WB8RCofFW11F5wE+mW8bC5yllurCqdGjVvb4j0I64Vh4INP3UiYXPwlGkj42GTWCpiSAN5e5mt71NkEcj3GAJHqAHZliP+yN/yLkNlFy17UG1UHdaredF1rblXEfCT0H49kZHlLbIyA+x9NNeOocpk9+towrRxamVUlQj2uSx+tx4i58Ae6YiPc1mFEaqCtFuhOg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c8077c3-1fad-4602-bbac-08d7faebb5b8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2020 05:24:17.0894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BxyUTVx+xjZsRViZDznVNOWVNFq8JW9xJ2UZDenTN5WcWbyXjN57xc+6kK7+EYJX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3350
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_01:2020-05-15,2020-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 bulkscore=0 impostorscore=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 clxscore=1015
 cotscore=-2147483648 mlxscore=0 lowpriorityscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005180049
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/15/20 3:06 PM, John Fastabend wrote:
> Add helpers to use local socket storage.
> 
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>   include/uapi/linux/bpf.h |    2 ++
>   net/core/filter.c        |   15 +++++++++++++++
>   2 files changed, 17 insertions(+)

Maybe put tools/include/uapi/linux/bpf.h change also in this patch
to make cross-check easier?

Other than the above,
Acked-by: Yonghong Song <yhs@fb.com>
