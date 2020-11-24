Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565072C2C2C
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 17:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390055AbgKXQAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 11:00:34 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30242 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389900AbgKXQAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 11:00:34 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOFs1Td030470;
        Tue, 24 Nov 2020 08:00:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : references
 : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=2Cp/O05wElPFuQCT1UAIhgt5/hJ9YyI/PIe7GbBr4Qg=;
 b=dvEq90QyWFCNPhs//0RrWkbaWKTfrrRYjUueMJGbrok5ww1b/R2krHQAf9+dUolD7HBa
 SHo0VBJmwtL0+9k8Ce+tEcMKYn3AQ8ioCYrpuv3xTeqUM8E3m4SS3HDkywFKpu3TkVJW
 RWK7SccQeWbHGPfaiWUsNJwnzZkRdWFEBg8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34ym1tj8fa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 24 Nov 2020 08:00:11 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 24 Nov 2020 08:00:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YD1D3pqNVEGYy/JzibbW+NaCdZLmWQH4qGyB7fP1RzQ9aPS9GEL8EokBOwzHRZLJ1408TlW1CPGmPBNEX0mi1PukzPVn4iUcQwdfsx2o+gKEX5nXRE31lfDzA3QmLRW6TeYRsDVVpmQZnKqtjya+8LfpZJ8Y4y3mLx5a1ondc72hC3U+/IZwYnMCE8pCY4gZ1zk9iqO13rFz3BSE7hBNB1TcKejVKluVU9ZW7djXnV4xRs5x+gfnkL373qp+3q9v5eEwS/D6tTzjj3IDO46kMLpThFTdaH9Z785nR+OhsL8MX4Vvq7Mg4OLOLBLNNaIS87OxHB8qeqlZqVo7b/RIbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Cp/O05wElPFuQCT1UAIhgt5/hJ9YyI/PIe7GbBr4Qg=;
 b=Y08cVfovvwe1l/s5t9wGOJOtLhNO5tcPYts3JahdkxYDP72GMlxx3ydzoA+Rt+r79UL31xE926MoJTIOUIqEgERRnhsC9Sj8rdxmvAeLbkKpY07L2d/aV/08E9BcqEITYDmlclXh/tE0G2JL2NaY1E05E4M87qpl+Np9d+mxtHutUpSL2cXsbZb35CzONhKcKF2tXycujl4tb8hvxk7NNRr1CEJP8A4a58eC/ArRfQ7Ad1rEg/M7+cZZSdB/B06CG5uIeCndADm5UuMQ9PSovlJ3T70732VQKJoIt5CbMWqncaDEr/MZ3udGJ5mfaawAuNENhhFcLcz+D55Uk7jizA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Cp/O05wElPFuQCT1UAIhgt5/hJ9YyI/PIe7GbBr4Qg=;
 b=QzrRamXTeAh+Fghgx3OnafwzDfvnwqBReCyBYKkrr0IYbd7ZIBo+gs3hkYnnsvZi4ouwUcrsNtZN7KImxZl0+JkFW9w7sTMwJiWx+ZUi9oXXdNQhbJdMYI5HM3vY22qpQABwKS8OFwBgVen9SvsKQXAFGfgf5SIh+lpOU7a+BdA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3461.namprd15.prod.outlook.com (2603:10b6:a03:109::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Tue, 24 Nov
 2020 16:00:08 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3589.029; Tue, 24 Nov 2020
 16:00:08 +0000
Subject: Re: [PATCH 1/1] tools/bpftool: fix error return value in
 build_btf_type_table()
To:     Zhen Lei <thunder.leizhen@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20201124104100.491-1-thunder.leizhen@huawei.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <47b51fb4-0a47-9d8e-187d-14bb7d475b05@fb.com>
Date:   Tue, 24 Nov 2020 08:00:06 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
In-Reply-To: <20201124104100.491-1-thunder.leizhen@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:4987]
X-ClientProxiedBy: CO1PR15CA0073.namprd15.prod.outlook.com
 (2603:10b6:101:20::17) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::10b2] (2620:10d:c090:400::5:4987) by CO1PR15CA0073.namprd15.prod.outlook.com (2603:10b6:101:20::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21 via Frontend Transport; Tue, 24 Nov 2020 16:00:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff432443-1c8c-4040-6b6b-08d89092046d
X-MS-TrafficTypeDiagnostic: BYAPR15MB3461:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3461E4C8AA6D83F74444CC0FD3FB0@BYAPR15MB3461.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3hcRisNYiHXXokDRH/G9GycogLbEEaavumM+8OglHgZUfS6Z3zfTf3frtPqi5+lZ0e719ZAtKsJyUAfIf55JKXqCXvKdI814Yu0bs+sugNMsPMazC6fMIXYb/a5pqbpztSqcGubq5ipg2iy/vNQyQetPXvJY95SB98qrSmwms1TlSqNiUUIkxkYhmKe2EEEZe/K01sTHPPAxWrYCCscsTw7m6ISuREFwWBDLkaygq7g0KvVKtGsHHsrDcy8hA45zvxeiR80dN96Z7mbpSiD3wT4kdllCg4oHXU4F2nRfZn018nEoQLom+9V09wLTyG3Ie25Ly0dlVr3yv5r6QcP1F4loIMEdJUxxa5kByE+39ktJ4c2XF3jLk3Wr2j9m2E2zocK1Rrh9Ie/4thWiPoGOow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(346002)(396003)(136003)(31696002)(921005)(31686004)(52116002)(66946007)(8936002)(53546011)(8676002)(316002)(66556008)(66476007)(36756003)(2616005)(86362001)(4744005)(5660300002)(110136005)(186003)(478600001)(6486002)(2906002)(16526019)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bUVMbU9xZnZhUEJRemNYMVZieFF5Q1ZDRWlYWm1Rekt4Y0ExeUx3NDBUeE5o?=
 =?utf-8?B?bUovMnU1UndrTHJURGpmQW8xWVAzUmNJNmpRRGhCZEFncEVpNUpId2VZcXlH?=
 =?utf-8?B?cFp5U0dIZllEd2FnUERZTUwxM0RHNUYrdGNnTnVEd3F5NGhNSEE4c2p5d1Vl?=
 =?utf-8?B?Q3FES1Z0MnpGNWFJT1BjZXArdFN4eHZNQmgreFh2QmRrQ21SVTQzZjFuejFm?=
 =?utf-8?B?VWxuU09yQWhuam5uSkY1d3l6bVBzeVE4QjhrcjlieisrOUx1MUR5a2N1YVp6?=
 =?utf-8?B?UG9OSkl1UnBmUUQydzNFejVYRURpMXhYS1pNNldiRkRrT3BGOHdMdU9Pc0FB?=
 =?utf-8?B?RnRJUEVJWVlzeFZqODlBRG1MbjljVHh1ZTBWT2RyK0NxUkpRZS9kOW8xWU1U?=
 =?utf-8?B?UUxBcXM1b2ZBa3o2b25HS0gxeUh3V2dDd1JzZ2F5Z0hDMDlEZTdkZFgvKzFT?=
 =?utf-8?B?Q3JBVWp0c0VxOHpzTW01THNXYjArM20vK0pDakluUUx0NnVNMGlQcjlGZ0RR?=
 =?utf-8?B?dG1QOHBmWDBrRDdRakszY1RESmFpckdQSVBBbWFVNXFaRWNYSUE4SWhMcTEy?=
 =?utf-8?B?eVNuRDF5NklXZkRJRlhkUkRHa2FQbmNyaEZ3UW5ndVRmYTQwaWtmMHVoM2dL?=
 =?utf-8?B?ay94MXdsVlRnWDZySms4bFBIWkl3L3dmbnh6QThYR3RoUXpJTWFlVE5Hc3Vi?=
 =?utf-8?B?Y3lwdDVxZVBSV0Fza2RuSWZSL05adkE2TnYya0hFUVdPeVowdHRKVC9hMEpH?=
 =?utf-8?B?WnVOWHNYRE0rbW1ZWG1MQ29uQ1pIbG4vK04xWkN1VXdJOTNPRDRCZHJKUWlU?=
 =?utf-8?B?VVVXQlI0OFBZY21yZ1ZmYXk2Y242UG1uWFh3ZXpraG5PV2VtODRDL1NxLzVC?=
 =?utf-8?B?Y3BBL3c1THNqSHZnRkRSNU5aa3RFbXN0SDkyU3k4ZWlXNU5FOHlocUYwbjFw?=
 =?utf-8?B?QngwUVlyWTVhQWc2MmxWSWk4ZDNFb1hmRm9vZFRwc1l1bVU1THJYTTNHM0tw?=
 =?utf-8?B?eHltek5udXdVKzEvVUJtUmViRmRONVgyZ0w2aUhIMlZDRVp1bHI4aDBDWk5j?=
 =?utf-8?B?UHUzZm51dGxlbjQwd3Uwc0xjZ0JVcXAxWXFsT2d3RzY2WXhyRWhKNGFtMkEz?=
 =?utf-8?B?aC8xazdJVFRMeVlRTG1OaW8rNG9JeHZXY0dvMHBydEFsbmoxYTY1MTMxK2V5?=
 =?utf-8?B?dG9MeWtlaUoxUnhPNXRoTTc2d0w5T1dlSUR6TW1SbVFsRi8zR0wxTUtKMUl5?=
 =?utf-8?B?RUhLN2x6cmdiTUQxcWJ0aTdBMUhzQ1RmMzB6cTZkUzNoSXdoSW05SzFsUlRh?=
 =?utf-8?B?SHdUcjMySHhNSCs0TE1DWGRETHRaTnlYWVlWOWJxTzRzUVRmNUJqOXkyYjRQ?=
 =?utf-8?B?b3BnM3RUdnRBMWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ff432443-1c8c-4040-6b6b-08d89092046d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2020 16:00:08.8259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z9zTkP3rCXqyTLRucykLVSa6gNpRug6arXONxV+4qKpRz/gaWScJ3IDrtyND0+i+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3461
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_04:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 clxscore=1011 mlxlogscore=999 priorityscore=1501 mlxscore=0
 spamscore=0 suspectscore=2 bulkscore=0 phishscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240099
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/24/20 2:41 AM, Zhen Lei wrote:
> An appropriate return value should be set on the failed path.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>

LGTM.

Acked-by: Yonghong Song <yhs@fb.com>

Also this is a bug fix. It should probably be targeted to bpf tree. So,

Fixes: 4d374ba0bf30 ("tools: bpftool: implement "bpftool btf show|list"")

> ---
>   tools/bpf/bpftool/btf.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
> index 8ab142ff5eac..2afb7d5b1aca 100644
> --- a/tools/bpf/bpftool/btf.c
> +++ b/tools/bpf/bpftool/btf.c
> @@ -693,6 +693,7 @@ build_btf_type_table(struct btf_attach_table *tab, enum bpf_obj_type type,
>   		obj_node = calloc(1, sizeof(*obj_node));
>   		if (!obj_node) {
>   			p_err("failed to allocate memory: %s", strerror(errno));
> +			err = -ENOMEM;
>   			goto err_free;
>   		}
>   
> 
