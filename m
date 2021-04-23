Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908CB368D05
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 08:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236799AbhDWGTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 02:19:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11150 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230504AbhDWGTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 02:19:19 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 13N69w01024138;
        Thu, 22 Apr 2021 23:18:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=sPjmUqvkk0RR+EjlmY6/c4dIyMGvw5ro2jMQLu5FEQk=;
 b=KSDBflUHiaB2r1Y0/fpZeVldd6T10NGCWmnfLyL6zCnpElqQDmO7ivXOJ145PfPyooVz
 3oOhDMEb4AX5DlFbA+Sc5txNg9ysof+TUeUKT4y75zn5BdheQl7njUwrTLsgJM/pvXXX
 heT17NfJi1qBnGY71TKtKnxdU/I0sPL8X+g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 383h1uj9pp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 22 Apr 2021 23:18:24 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 23:18:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IjB9hzj5Ulviz+JLA4keWWOIhndMHEcbacsNRP1GbmAc8xOyqS6sHS3tXTohYuyPgib9NXep1668/aVQvZEZp6yhbXMgTAVWO/+xEd4RaYMf7/3iDeseMPomfqRD43bqkqD/Rl0cgpxxDdypFIPlYs8R9Ie1VNpxY8NNidYT7djhJt6x2EdSB8E/rkeNF0V7zLyOhcBXFXLfZ+FsZISLoh4z/WL15wyelEt2Y918yNokQHHDtnhBwealo0X3OAy9g5oWVeLYau8WjNu+cReMJw9DOi8zXIY9C5BJdsQIpY7DvHNXmcS5tbTAY8OF1vtAtL/I2UHHjOv0UcmsbrTmjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sPjmUqvkk0RR+EjlmY6/c4dIyMGvw5ro2jMQLu5FEQk=;
 b=P8rR/8izRL2YXHzYP0nwewtR2EURnT0kKzUOjaYeC8ZQxCgqrED/fleDvFr0YUqGsF+9WWV9TU53854fRC9XnubcjTO9kI/yFCiosJCtYL4OFJt8HSDC28xhIVNsdb98SQPNSdnaVR6sWH9s86xt4Zgqe5hrgMTL7DSyc+IcET9ndFEgsYRFpQhbuXUKw1rgTHOn3BJDzAc8MuJZpBMruYauUp6K1nSoyCHHHgXK8c7hJ+Hd/j8HKI5oxbicpBBfXuMaBrRqjyYNPokcjWCozjre9/xhr68S/yiiLFIZYP12yohpUYVyDEOpohV5LuX/bi5u4vXKD0g++U8Si6c45Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3968.namprd15.prod.outlook.com (2603:10b6:806:8d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 23 Apr
 2021 06:18:23 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Fri, 23 Apr 2021
 06:18:23 +0000
Subject: Re: [PATCH v2] kallsyms: Remove function arch_get_kallsym()
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, <ast@kernel.org>
CC:     <daniel@iogearbox.net>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
References: <1619084946-28509-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ac65180a-c55f-4ee8-398e-64b0fcbaa0aa@fb.com>
Date:   Thu, 22 Apr 2021 23:18:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <1619084946-28509-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:c7f9]
X-ClientProxiedBy: MW4PR04CA0160.namprd04.prod.outlook.com
 (2603:10b6:303:85::15) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:c7f9) by MW4PR04CA0160.namprd04.prod.outlook.com (2603:10b6:303:85::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 06:18:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b476efb-4fd9-465e-0cee-08d9061f98e8
X-MS-TrafficTypeDiagnostic: SA0PR15MB3968:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB3968CDE1964E23DE7A9C0DEFD3459@SA0PR15MB3968.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iEtObSkXw9WM/HROpWzr2SFTsFg+THKHyUD24MmHK8UXc9WsVVmZ54DT/NaiToNPiR3t7dD6lSr6BWK6hH++LgpafdJalmep97+ZSxsXSrQtTFiOP/uBnFmVFKUOsCR+LOe8kqFMpriKJS5lJuVTjh7v0C1D1Ocb9IUtBuAVXFkj2BDqAt06U4vExUagVoC293Rmeu29AIJyjDJahoFxK3hv74JVh+UzkjiqG7LKqrm6YCQbAnnsIXlJ4vGGnwpiy3PFJHp9IcJ4s2tCOiu7Iun11Qwt/dJOAE0d1SWKRGuwwLtE3T48bkDBziyOK0LKXkrtHjXE4xPxRJAC+rI3Cwv29q4IvqDFNjFIjUjKWRRq6dMdeR01hjIZG3686A+baEP13VVDpNJgvYSGc6bQZ8gsrDiXWXCZerV5xHRrxwSADGPA95pANYXuQKAUlanHfkRbJXRQ+jP5TQ8v71AVPJ6H39kaikxPgP+xUw7tJZDdrXrce44JedbLAiRjeEw35GalpujscroBfH4OmC1UovEjFxHbr7VWuzjNXy+gn9le5d7wNE7hLzMrhLH9LyuPjl8Eq/gYdDt4G2Krqty7dX0lPKHHnHdLiqE+yxACvGSeb86mJ/Eyh9BRY8YQphVF07nDNnSz6qMMvQb9U8UAavTiOvgOjh6m0meLtR9T69UvYlJH7Zx/tC3naSoNXGp9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(136003)(366004)(396003)(376002)(36756003)(8676002)(2616005)(66946007)(66556008)(316002)(38100700002)(7416002)(66476007)(8936002)(53546011)(16526019)(52116002)(186003)(2906002)(4326008)(83380400001)(86362001)(478600001)(6486002)(31686004)(31696002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UEx2QWhLMzV4T1Z0UFpPZkN3aUpCbE1LMFJMQlpWUW1DZi9UYUQ0Wm5ia25T?=
 =?utf-8?B?L1ZVekxzcVh3QzlUa1BDaWZkTi9mZ0J5MkN5S2lnaWlVTlVwUjN3K0xvQW1Y?=
 =?utf-8?B?cUZmbW9oUkNwb1podjZ3bnIxU2xmeHR6QmJteG5MQ1hDU3dnOUV4TkNVZjQ2?=
 =?utf-8?B?OU5aVHFadzU1OURJbzhNb2I3UlY0SldDZVVEWE5sUVk0SGFiVlNvenhsZ0I5?=
 =?utf-8?B?OUE1V3VuSGI0MGd3bEhqNGRqVHo0dThYd0JxWmlaeEVWQ0ZVMTJIR2NqMTlO?=
 =?utf-8?B?VUE1NUpLa2lDOEdpMWVkWE9Kd3B1c1d5aC8rTmFLNGdlb1loUzN2eUEyS0dY?=
 =?utf-8?B?NHFNNGk4d0s3bGxMZGZFZkhqSXJHeEEwNURnZGVEWXNKQkpKa1lkZGlia1pO?=
 =?utf-8?B?MkpDVzZCZTNqeFlReklxUnlJdlAzeFJWOFFtcDBCV2ttRmxUalkzdGRlVTFz?=
 =?utf-8?B?VTRnTEdkNVJXa0RkTEFVYkF0TzZoNzB3ZkxJYVNpLyswSUIrZ01mSW51Q21j?=
 =?utf-8?B?bnljaHorMXV6aFhRYlZDS0gxVUNidXdMVHdvdmliY2tpbHBXSTNQa1RZQTVW?=
 =?utf-8?B?ZW5LQ1hvQ0xtYUJIayszaFhmOHNSTmRaSEZzRnRDazFWd0ZqbmxNakdlUmRC?=
 =?utf-8?B?UnJReXk1WmpwM0lzMXJCZVlnK2V4NlVYZHBhWFJNeDVqS0JSTXZjNkl4cFM0?=
 =?utf-8?B?YUo3NGYvNWpQMHNEM21vQW1RZ0l5UzRvUWpaWXRlazFiTERsOGdwV3RBQzJC?=
 =?utf-8?B?ZUhXUDFjWEdGc0h6SUZxZFYwVmdxaFJMYVNuQzlqYlp3Y1ArZkt1VzNMUHIv?=
 =?utf-8?B?bWg3TGdGRUgrYjVJR2FVamgyTWJnTnEzWWRIcFZFY0t3bmRnb1RmaHBnMU83?=
 =?utf-8?B?T2d3VHZ3emJYQUYzMGdmVWFWampXVC9aelY1NXpOdjZqcVRqMy9iU3dPQnhO?=
 =?utf-8?B?Z2JEZ3lBWlRoem1VOVB0ZTV4ZHhYaE90MERKV0hNZHUzaTh5S0wvY2lqZ3JL?=
 =?utf-8?B?T2FiUkZITjJxaXZaT0R5Umx2RWYxOWZ3NU5hKzNFdFRha3IzT0pkWnpoWndW?=
 =?utf-8?B?d2YraEpKdVZkeFVEY043WGc0Z3dScmJpWGZFWUZFaFNHbWVJbVVlMzhtT3Mw?=
 =?utf-8?B?TGN3U0x4dnVnN3RMei9rSUx1M3ByZGZpckxySWZCNnEzckpLOFB5Slh5RXpj?=
 =?utf-8?B?T2hKaVdtWHBFTlBjbzhLdmorUnJjb2hJdCtsZXUvakpBTGpPREYzclZmY3ZG?=
 =?utf-8?B?VzdQMUJ0R09oWHp5bkJMem10RThVTEJHSkJXbnFTUC9hNXNmWm0zQjdjalJ5?=
 =?utf-8?B?OFZTbDhxOFNBUDFZTWdLVUdVM2NoTXl2bzRVdytWSGg3TkdyUjNuTDNwRHZl?=
 =?utf-8?B?SUo2MGtVSGMxbXp0WDJlZ3pHakhyT1Q4WlZqRXlIZE04RmhsdzgwSFpjNFU4?=
 =?utf-8?B?OHAzckpIODhYR3I3N2Q3dFhWeXdObFFHcW8vK2o2TUkrTGZsU05GeWVGV0Fo?=
 =?utf-8?B?TDk1OXcrMFFMWHJ2OTJHUFNkMkpYUmhleCtReWtrd3EyaWJYWDYzMnFZNjgx?=
 =?utf-8?B?SmlESXBIdlVRT2g1Mmd3dEkzV2FYUnlaVG1RY2VyTnA1UlVVWUh4dGx4cHNX?=
 =?utf-8?B?Q1VRT29JNStabklYbjFmTlRQa21xSWp5VmhoSVg5WElGZUwxR3Z1dFVYNisx?=
 =?utf-8?B?b3JhL20zR096Smg0L0VJNTJnTlUzODIyRnNGa2pGVG9iMzliOS9UZFBJTFQ1?=
 =?utf-8?B?bUt4dXJqOEtTSGNYUFk4cDVINEVqM3lSc2FZZi90RHlBdUhobEIybFBOL3Nh?=
 =?utf-8?Q?lJNM4eJgodaPSY3Vm0TFh1ql5KtqY83HnesoU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b476efb-4fd9-465e-0cee-08d9061f98e8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 06:18:23.0132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZWB4dD0NMUsP8U0BoTzM0vqqRPutKmkzPnGN0YWbggaN8XA+9sjbBf4eGGbKtd2E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3968
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: H8fKu_657Vli4lJ8EGHgFUd-5SDVPfp3
X-Proofpoint-ORIG-GUID: H8fKu_657Vli4lJ8EGHgFUd-5SDVPfp3
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_15:2021-04-22,2021-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 adultscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104230041
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/21 2:49 AM, Jiapeng Chong wrote:
> Fix the following sparse warning:
> 
> kernel/kallsyms.c:457:12: warning: symbol 'arch_get_kallsym' was not
> declared. Should it be static?
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
> Changes in v2:
>    -Remove function arch_get_kallsym().
> 
>   kernel/kallsyms.c | 18 ++----------------
>   1 file changed, 2 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 8043a90..49c4268 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -454,24 +454,10 @@ struct kallsym_iter {
>   	int show_value;
>   };
>   
> -int __weak arch_get_kallsym(unsigned int symnum, unsigned long *value,
> -			    char *type, char *name)
> -{
> -	return -EINVAL;
> -}

This is originally added by
   d83212d5dd67 kallsyms, x86: Export addresses of PTI entry trampolines
by Alexander Shishkin.
The original patch has a x86 specific implementation but later
it is removed.

Maybe Alexander Shishkin can take a look?

> -
>   static int get_ksymbol_arch(struct kallsym_iter *iter)
>   {
> -	int ret = arch_get_kallsym(iter->pos - kallsyms_num_syms,
> -				   &iter->value, &iter->type,
> -				   iter->name);
> -
> -	if (ret < 0) {
> -		iter->pos_arch_end = iter->pos;
> -		return 0;
> -	}
> -
> -	return 1;
> +	iter->pos_arch_end = iter->pos;
> +	return 0;
>   }
>   
>   static int get_ksymbol_mod(struct kallsym_iter *iter)
> 
