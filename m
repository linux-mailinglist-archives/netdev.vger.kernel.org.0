Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2AD248A7D
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 17:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgHRPvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 11:51:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51256 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728134AbgHRPvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 11:51:00 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07IFkbJG032031;
        Tue, 18 Aug 2020 08:50:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=4PWLoBsdxS36xqpdk+AAzby0MuVztKk3ncQ+IxugYLM=;
 b=dS6PVip2W1speGbUVdpXtFqMWIsfLtXMMN2TXOfeYxcj1DBDmbAjOab9mvEltnf2H4VW
 MzJEl4MpxLwg51gmkTyCr9zpFGzjBX5kpMGGPSE8v6otGcBlaYaM4A4FQT1sLSYeVmba
 2fw0nkqVNxCz3fW6XstBpey8AMQfjmsTI4E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304p3bdjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Aug 2020 08:50:43 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 08:50:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SDSvlBeH+C43r4XT7YRE1Ij/Czx/KEI9xXFd++9wbo2PH4B2FITmXoKnZHh7A+iadDWeGKY3iXajiBGqIDGX9CVGBoLDwZknrIR/AYMuLtPImkifKDm+nke/EZ9W9mN1xq0QJoFs7eqLxPln4Za87Cw3UipNV4iA6Hwemzkjxj+M3kPPzGJ4rp+2iaz4lEyWMNPUJI/AbKgqwiNTFly0tsX9bT52MuOrIqvlzFXcXnujUca8j1GK9dLZkxRKcap+aWkZyLUmNrO/2gLzzRoV+zAU0r1fn5t6bNIyn7MzP2TW8fJA9WIg4acSFNX1tQtZRUXJQxGcbPzDSy1pNpEx9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4PWLoBsdxS36xqpdk+AAzby0MuVztKk3ncQ+IxugYLM=;
 b=mZp/7MGXGj82tYQAJO2fKzM8PIGXy2ovPtZTAAKLv/KMXaX9Da2KcB0uHqTOLZdPiynFZoX9nXm24bENfFXvjPL/iIdqAbo9J522Pum75xDFYJouBFcflQIK+lJCuEw3+Ul7V6aNbwxarbMWO9havTtXFGuGXY0UgPR+7QVuRR2IAD1za51QYdzgnNEbzmFXo/gS9jkLJ8xvOhTwuCR7fGzpjKEQ9iHAvlCB6UQ8J656kj6ChdVfdIFFjUbhVacMoV/qF2jQZ3oHweQNMQXXJEzYaJcAiod33hWa7SdJBRR4Zs/FqqaHPM+x++J5NRTxzN5TkaCuaAbRlghHM8qxFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4PWLoBsdxS36xqpdk+AAzby0MuVztKk3ncQ+IxugYLM=;
 b=d5fkWh1EGvMWcLh/lCi36M1nMYJg7sRUok/FHzNbRB6E7ty5lcydL+jxcBVMRYjQRBFWpz7p8Bz0byfef/Z9X/IQEDxiyWVhH/dU1kf2U4FsY555we9HqVkP80NvOliYC01ImLhiyxNsNTXoQ+HLxL4jjIUwHJvLgoUqDO0r564=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2951.namprd15.prod.outlook.com (2603:10b6:a03:f7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.22; Tue, 18 Aug
 2020 15:50:41 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Tue, 18 Aug 2020
 15:50:41 +0000
Subject: Re: [PATCH] libbpf: simplify the return expression of
 build_map_pin_path()
To:     Xu Wang <vulab@iscas.ac.cn>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <kafai@fb.com>, <songliubraving@fb.com>,
        <andriin@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>
References: <20200818082008.12143-1-vulab@iscas.ac.cn>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <f563e6a7-1f7a-9d9d-4278-e8e677e6c214@fb.com>
Date:   Tue, 18 Aug 2020 08:50:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200818082008.12143-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0130.namprd02.prod.outlook.com
 (2603:10b6:208:35::35) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:a06c) by BL0PR02CA0130.namprd02.prod.outlook.com (2603:10b6:208:35::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16 via Frontend Transport; Tue, 18 Aug 2020 15:50:38 +0000
X-Originating-IP: [2620:10d:c091:480::1:a06c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8838f889-4943-4df8-cb8c-08d8438e7569
X-MS-TrafficTypeDiagnostic: BYAPR15MB2951:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB29512CE6313FF802E189FFB9D35C0@BYAPR15MB2951.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:529;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NcCoG2kUhSx6gyJDa98/kn3La78QGf+07EzCnxBHKBsAeEcVwGG5ptgTx5+mz6dDCMt3JJ6fOnAzKR3gn5a+g/Hw1pKsjWhvAEI6T2o0R1ERaa3h9T6QBwr8EIWjhoamjBbPJqa2i0Z3pGSJLDnH32hYcSr1Cpq39WUd5oh1H3osb0fHXuTkMPdZfnChYsXZkzpW7xXcbryrHvpxg0QTm+iuC1ifNfu7QnQk1au7RLUv3u1WBK/6VHk4dwWjKDX6z924eFLpfXrMwdenaEJYjR1fIeo4ZI6bYk0UckRe99ItuAj8MSPvlwQQdI9e4mb/xUogFtWCR0i6qJ+UCOAdDh9xTmQwPHbVUJN1onJ63bGl4pVVZS41iPcVkELmczXbN3H3OpHa0GyGjITohSb+0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(346002)(376002)(366004)(186003)(4744005)(31696002)(2906002)(478600001)(66476007)(52116002)(66946007)(53546011)(31686004)(6486002)(83380400001)(36756003)(2616005)(16526019)(66556008)(86362001)(316002)(4326008)(5660300002)(8936002)(6666004)(8676002)(921003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: zCPod8/zc8uWUabFwxYij8KmTiNMNjpm5PQbENHmyq/KQfAscfUUI1295nq1xjx0QIRDGZ5dVs73+7sLuDn+Pb229LmfH7ChW7Dzh20wlE2L6oRk/1aWV8Mo3lgPmxT12yvAlf92PLy4j3MemMq3mU649HpZa/pmZzNmXpdMOO8ssBvelURIvd3spTQmWoIqW4PIHELYxkBGv2fx4Tte/zxa/fsdCmJd4VyiDBQ/OgFTplD1A7BMzwRvcaYC7NEkdz8KSJrDMcgxpEHVMc9bqrAqlZhvOC67cVa5A2Zqw6pxwmpduZ+3RD8nU+z8aBGnDuhr42+As/1vIX3jynC7Lmn9PZJOjxv4C5xrkpeUuHS1/HqFLPmhbG7T1vqcnrbiQq3FrkgpeeZrxQRzq29UpMaRxCEH2TJ6DfehK1K0bNWKbWeUnqrkQjHxso0bkKiDzJQ2wEjspXXFCfPuy4b5kiSE9H6XktqMT9RjkdTeh342edXXhaBAIZmnVBlZ2GRfAJj0K0K+1eLNIzSnD1tcYkss+Cpp2qWiD7WpWEmpN9hi5JOUiJsQYhFoB+FXGkMusQ6hF35xi2aqlK41aEjZZJ0i9WhBwzmmx83TzsDQYg/4GRSatFjrNIX+xaqXCCgWx2KpxHRs4anVwYdKGpQQT+0NxlLNNok1HdYkeb1wF2M=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8838f889-4943-4df8-cb8c-08d8438e7569
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2020 15:50:40.9538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bjcdd4LYigltJwZOcmQxpbvgoRAhH4sc3sWsrY7VBKHFUMwtm9NNxpIFYlGQ38OV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2951
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_10:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 mlxscore=0 clxscore=1011 suspectscore=18 adultscore=0
 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180113
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/20 1:20 AM, Xu Wang wrote:
> Simplify the return expression.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
> ---
>   tools/lib/bpf/libbpf.c | 6 +-----
>   1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 5055e1531e43..b423fdaae0b6 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1935,11 +1935,7 @@ static int build_map_pin_path(struct bpf_map *map, const char *path)
>   	else if (len >= PATH_MAX)
>   		return -ENAMETOOLONG;
>   
> -	err = bpf_map__set_pin_path(map, buf);
> -	if (err)
> -		return err;
> -
> -	return 0;
> +	return bpf_map__set_pin_path(map, buf);

After the above, the variable `err` will not be used any more, which
may incur an unused variable warning. Could you remove it?

>   }
>   
>   
> 
