Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 795021629B2
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 16:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgBRPo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 10:44:27 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52506 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726445AbgBRPo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 10:44:27 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01IFZ2C7016629;
        Tue, 18 Feb 2020 07:44:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Wj/8ZB6v/9yVX2UCsaXEamrsAECQumbvu+cUFwDoTHY=;
 b=P01c8KPDmi9Q9JlhjfyxwQf74ZtW1BgKEKZxUW+rTF6oBKpgCIFhTAzllmLu5JTCMCcl
 OgjWGKWu1UBpzpJNOQcxSSP1SROiVm/ACHQyn9DukSKIEVavrP1D/mjn8cIj5QkSNC8M
 eBEaMn/RtxHYi5UadH8mK3KUyruhUKg5tPo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2y8c541ts6-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Feb 2020 07:44:09 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 18 Feb 2020 07:44:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q4oJIPLN3G7zw1rKmHeckRRKFssy9eRdz8f3JrBReq5G6ijvWij5Vb+zhS+yFiSFk5zx7+B94hQO1/fGDUijs6gwGFGJhqsSlliMo5cmwy61ObLT9zUAj6ONZhfo9vmDKL8tdfx5Lq9wM637kz8S1vbe2pFjFVUPMtzIg8r5vxfDpdSsTPbiEhtsMfGjdqLwczUjUiIxVhUYOy2dnWcaHc+ZkfFUQ+mbuXMoHfCpxxi4iLGAnPqnAMQzOojDmSG59mz/6c+a8HABmNJy9I7RiRuQrXIbrLo5YGiyoD1T2nX1vM0IhVjnXSIKEeU1XVaqriTulwcvqyCgN3KkY0BHSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wj/8ZB6v/9yVX2UCsaXEamrsAECQumbvu+cUFwDoTHY=;
 b=O+DJJy8oKP8zRUo6E3ktEfjqkcnu3Ye2636WXoghJpj7BhIWdfCmogmy5ZED0VRGUOt8CvcI/341lxeArbqqNCtKe0OEdH2QNZU7JHNxswSSDVdYSZ9XeHrujbqSLbwO23Z9ZfpgxpfHm4yEJnpq9DgcHCKatkopWhqbmccqj7n4GUO1kxCwGpb39K2qnpNtWKQerAmc/C+v61myUGkxL+EsDZuxICLJksUuGRY4oyMYsMlYJeoPHQAfCfnhRrvKoe4DHfXmUP5UElwOVkySl5OrygQ1lnZ08+NX5oG9yu9AKlzKxyDMkypXoal14tboD3c3AvwzPwKOtgPAJ05/uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wj/8ZB6v/9yVX2UCsaXEamrsAECQumbvu+cUFwDoTHY=;
 b=SyUavLzROoPZKdNvI+5D4VRxXVHVc4wuDwguHnz4xAQjIZnPtqjCSyrwHNPME3kWBw8BSSYGfpZVBboHKVu3aSzZUdGrahBsW0mIsPlC0LlvwRBC/dGSCoZDCEbBiV6ngaFrT7/VPmyx4k3DjcAMVcwlK2lW6Gnwcn8qKYr47O4=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (20.178.231.16) by
 DM6PR15MB2777.namprd15.prod.outlook.com (20.179.162.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.27; Tue, 18 Feb 2020 15:44:07 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2729.032; Tue, 18 Feb 2020
 15:44:07 +0000
Subject: Re: [PATCH bpf] bpf: Do not grab the bucket spinlock by default on
 htab batch ops
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20200214224302.229920-1-brianvv@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <8ac06749-491f-9a77-3899-641b4f40afe2@fb.com>
Date:   Tue, 18 Feb 2020 07:43:48 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <20200214224302.229920-1-brianvv@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:300:117::26) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:500::5:fd19) by MWHPR03CA0016.namprd03.prod.outlook.com (2603:10b6:300:117::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Tue, 18 Feb 2020 15:44:06 +0000
X-Originating-IP: [2620:10d:c090:500::5:fd19]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 432b941d-4cf5-4d62-ddee-08d7b4896385
X-MS-TrafficTypeDiagnostic: DM6PR15MB2777:
X-Microsoft-Antispam-PRVS: <DM6PR15MB27777215A8483FC485B060D9D3110@DM6PR15MB2777.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 031763BCAF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(396003)(136003)(376002)(39860400002)(366004)(346002)(189003)(199004)(31686004)(186003)(478600001)(6486002)(86362001)(16526019)(31696002)(110136005)(4326008)(36756003)(6506007)(53546011)(316002)(66476007)(8936002)(52116002)(81166006)(81156014)(2906002)(8676002)(2616005)(6666004)(66946007)(66556008)(6512007)(19627235002)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB2777;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G72V4aPVQWioTAD4W4u+6KEZoCect2rPn78tUr/4QyM+eWM4gLMKY6I4aUlW9RiUpttuh4PEK1KrS+1G6Wl72VH8RjiU8ubfUr/CuIaOnhKjF/k8GvX8Fha4mDmX5dAyaltoCcl4tyXBw6nVbLSVl9glUcxBWXBJQZsaaTH6uEXwQbWu3G3UA+m01Xom0NCi2yqX731veDCCBn+pwxCye2swp7HV+NWiIYxKcl9UV5RwajN14ZOhDIff5QVIeznyfv16wTrVenYIGQzxxcJUlStBZdFpb6FE7AWQu2qoLjWwLUZ6JVACaGnpkz43uhTZYikCk473vJDZkNhvVWrDYj9u6W+g1CyAmboHZYwUTOEs+7un9Q0qAet8S2Xo2IdN8Rpyhy16+S1nMjBBO5VgLGo2eWBTHLNH2Lr1mrmolREcr4EFCCWjgA6J4n5HA3tY
X-MS-Exchange-AntiSpam-MessageData: QfEhRRIONvgbvTA+T0con38uRAnlwJlReSUOeYbLEUYHMg131wJUiMWp06vc0WuOVcHxCKhlkTWoo8RnzfcnYL6D787oboHtULeARGgG4waJlMuMHCXemyQfqz5y1VpRKYHP6Ce4q5sjW3PX4k5Ia6DrFtKJTAg9AyZNg7USLQfRpBrVkNrCnlqExMeSpxEZ
X-MS-Exchange-CrossTenant-Network-Message-Id: 432b941d-4cf5-4d62-ddee-08d7b4896385
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2020 15:44:07.1590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PsnmHpfy3tuaKZT5dyfm9dZx43ApsKv2lqE9hAS5+i8RVrRcKvy2qRMYZ89uoY/6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2777
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-18_04:2020-02-17,2020-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 spamscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 mlxlogscore=774 adultscore=0
 mlxscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002180119
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/14/20 2:43 PM, Brian Vazquez wrote:
> Grabbing the spinlock for every bucket even if it's empty, was causing
> significant perfomance cost when traversing htab maps that have only a
> few entries. This patch addresses the issue by checking first the
> bucket_cnt, if the bucket has some entries then we go and grab the
> spinlock and proceed with the batching.
> 
> Tested with a htab of size 50K and different value of populated entries.
> 
> Before:
>    Benchmark             Time(ns)        CPU(ns)
>    ---------------------------------------------
>    BM_DumpHashMap/1       2759655        2752033
>    BM_DumpHashMap/10      2933722        2930825
>    BM_DumpHashMap/200     3171680        3170265
>    BM_DumpHashMap/500     3639607        3635511
>    BM_DumpHashMap/1000    4369008        4364981
>    BM_DumpHashMap/5k     11171919       11134028
>    BM_DumpHashMap/20k    69150080       69033496
>    BM_DumpHashMap/39k   190501036      190226162
> 
> After:
>    Benchmark             Time(ns)        CPU(ns)
>    ---------------------------------------------
>    BM_DumpHashMap/1        202707         200109
>    BM_DumpHashMap/10       213441         210569
>    BM_DumpHashMap/200      478641         472350
>    BM_DumpHashMap/500      980061         967102
>    BM_DumpHashMap/1000    1863835        1839575
>    BM_DumpHashMap/5k      8961836        8902540
>    BM_DumpHashMap/20k    69761497       69322756
>    BM_DumpHashMap/39k   187437830      186551111
> 
> Fixes: 057996380a42 ("bpf: Add batch ops to all htab bpf map")
> Cc: Yonghong Song <yhs@fb.com>
> Signed-off-by: Brian Vazquez <brianvv@google.com>

Acked-by: Yonghong Song <yhs@fb.com>
