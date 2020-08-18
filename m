Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81AB6248A91
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 17:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgHRPwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 11:52:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4644 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728353AbgHRPwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 11:52:06 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07IFkFUN018169;
        Tue, 18 Aug 2020 08:51:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=jPtin68RUJlzphoVmTpOCXb35B/4RBY8IlPmu7EH+UY=;
 b=iickDYkCuBfqS+luj93jZseV8CbUqFi4YJMaMnYQw58MxzR6ZxJgzAkE3LYSIk6Ebety
 0zZSQXzxuo3qYMiJLpDqwtOxhaNL2YRdfFNYHTvxBlMOkuTRb+tndWlTPgt10s05gU70
 WrMeWCsgYEGCJVLU1v5NKM5MNEhIllThdNg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304paudaq-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Aug 2020 08:51:47 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 08:51:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hn4qBZ8jMvJ56ki0XCnLDFHrlTy6C3+zanlfInutNkP2nGuXgPR/+CMS37zfGiG48ICtClVdl5Dp1kiRN8a4BR+BiVpmPtryeZlRXGdfbXOBSgkdthi2VmPuf9sRi/WgF/rmwrsknb+MeUztTn/M9+hVKrtcczlrTPz75Jak+0ZWVxmhb74/hRIMRuhmvTUbotf9+ur73a0cehjss0gqU0m86WYhtosKpECM1rCPWpPiznUbOnjgrlohStUAYeOCylc5H8T5tpdWzzc9ogZEdZAinHrkYe2/I1jKvre2aL05lMf5yDIwlslMkzooYvSnFsMI7fxK3Wso26ccJrP1UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPtin68RUJlzphoVmTpOCXb35B/4RBY8IlPmu7EH+UY=;
 b=TaNRVJ5R5X8pZHq+jt1EedK1Xwmph8p6UC/ZOAyH520gmBJ2U/2DyswW4B0BcCGmdwYtBw86U0KBFIe8Uipq1TJ5FTeWX5QfeHJxQBe8ZOk/z5OFUBsVn+0cByexBPrQfZfW1UVey5l6UfTZ34xfcGCGjEXjKfEN1113oPINzJl3YjsAH/o3AAXC2LxvZlzgY25UD+rzOApUyE7f/czEwebxHu9xU5KGSZOlVyrd+PYS2nw6PoyW5qSWWKp78kpaNXz2h1mPP7RiYoPAQxnhgfaErsWXxY60G8vO0l4FtA5u65z9tkwY6pCd3cK5NXVcgqAf1YaIhFNjD+hHBWr79A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPtin68RUJlzphoVmTpOCXb35B/4RBY8IlPmu7EH+UY=;
 b=NvkEbC4ZsaoOYup35mpgnkEUcFxXz4o3khKR8wOjL9Dhuv+8wgnau43c2EfbUBh7tgysMgK4elNcELofTOMGjpXnq1mJUjBvkgvHVSZuC8S9ZUosTMhpoxI+Ad/adgn2E7qq75uXUl/0W2rePPERNn5B6/kOpfHKDU5ld18tW4k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2838.namprd15.prod.outlook.com (2603:10b6:a03:b4::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.22; Tue, 18 Aug
 2020 15:51:36 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Tue, 18 Aug 2020
 15:51:36 +0000
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
Message-ID: <324a9171-f9e2-2ecf-c01f-a53209d7785a@fb.com>
Date:   Tue, 18 Aug 2020 08:51:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200818082008.12143-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0127.namprd02.prod.outlook.com
 (2603:10b6:208:35::32) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:a06c) by BL0PR02CA0127.namprd02.prod.outlook.com (2603:10b6:208:35::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16 via Frontend Transport; Tue, 18 Aug 2020 15:51:34 +0000
X-Originating-IP: [2620:10d:c091:480::1:a06c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33fffb7a-9a90-458f-c457-08d8438e9696
X-MS-TrafficTypeDiagnostic: BYAPR15MB2838:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2838B8015B7E74754ECF878CD35C0@BYAPR15MB2838.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:462;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wXSXIfTFgmgalck+RQ09wLtY0LIkvs3jlOo9ajUKtDklGloMEZPqkhjwftgVSxvKGft7V3ODPJrfit/FrNnI4FCJH3xndPxmHAe8cUf7pKObK7HytJs5hj3K3qVEa1iYyShuZiuydvb3ymYc1auALCAprDcZg0X5au+NE+z4JfXOVz8FUCoejYRvuI0CM3hCjfs+L20gHLOv1+lz4+oVXr1mz+r50L8LG58OJcHbeF3tikq1a2H1WNn7YlvEf88dxZ7cyBCImp+NmzfquyLM69dmru1aeCF5Buc2E3pKIq0Q+y4kPy8YHdijMrMgbcFWffiCOCPTLtyJXbJwn6GkHdkgx9HhkyySpzdvIEiVuXZmUjLcZzW4fay2PVkjOKutkwwVD1T8eRHg3aqJ5Sl1hA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(376002)(346002)(39860400002)(2906002)(31686004)(6486002)(66556008)(8936002)(66476007)(52116002)(316002)(478600001)(8676002)(66946007)(36756003)(31696002)(2616005)(53546011)(4326008)(86362001)(186003)(16526019)(5660300002)(83380400001)(4744005)(921003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 4B5Ru6iAP/JBnrKdcvUFDAjrVYeGRysBjxqn9o944MfVPRxbS1WBu/OS6CRL2V3Li9mS4uwFtD5sI+mguOlSyzDw46AYKtZVB8VjafapdBSJYCA2/IZeAfScd934234JH3nB3hm520TL3jm7jSZTmH6T+uKr0y3Lw0ekURXncXp3JEELWnn0qcZfwOi3Quq7P/kDLSmu/sJKYu7SSxDLwuTIU/eS+xKMelNTikj+PfuiVo8EsCV47ESA5AlF/JVdORpdn71tyZIA508FML/x+pgEVSWpOAyTamGfhIRRJK6g9jhO7SQN79k9IVulkjYvefDIP0A8M9pYMdvlly1Kgq4mnBka3/nFXx+wFkQJfl2j2SK/MASsAWGHoGHiEJf/B69e9v25wAQWmLFQ7s5597faldFI2XKAnLR6mj0pNogShox5zIm9rdX6BvHHOs9i38WpIzQvWn22ZHYrZV/F3vqdSIISbJvZysq8qI0yGOjWC3lEaW6+Wp0cMFfTH6ESqp1VnQfqMAYmyF1r5noND2cHpfssHWpIh3rtPeWgEQtLU2hIIMciW3yz9njxcdRO6TaUYLOQziBGDntX0eVS3jFdrwalQyDBPt8Hpmw9jHeaNhm2GWqQOpyW+TxWO9Oo/S5TP5heDn6c/s8/MIFtRhbrTBgUI0EyPAwDlDlxT4w=
X-MS-Exchange-CrossTenant-Network-Message-Id: 33fffb7a-9a90-458f-c457-08d8438e9696
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2020 15:51:36.6163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hobfydVgqItP98EQswt311w0qCDNS6LdGd04y0UmYo1jtaDusS5HzVJ5alAu1oMG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2838
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_10:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 suspectscore=18 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
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

Also, please tag your patch targeting to 'bpf-next' tree like
[PATCH bpf-next] so people knows which tree the patch targets.

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
>   }
>   
>   
> 
