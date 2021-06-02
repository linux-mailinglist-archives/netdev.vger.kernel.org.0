Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF343993CD
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 21:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhFBTsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 15:48:42 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:20786 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229467AbhFBTsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 15:48:42 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 152JQoM6019248;
        Wed, 2 Jun 2021 19:46:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=tjAU6bHiDIpLRO7FN5D2s1r8kmGxpUQBIPPqkGCBAR0=;
 b=WN8oYZMzHOn9EO4UVD463ChgWPsYDwjYHfwK4OMYfkfXUayoeKzyfS+1m023NRdRL8MU
 meZDqMyTn7cVkDuxd2F1Y00HPrSVRGaCy4Vk0nlf6ktv/t2dcJWUeoc8LIiScHZq0sIZ
 VYxv9z9Hw9ephMeHrQjz4FSpiuhpHd83eboel8GCmQoGtnClavUQXwzo508kNCpXG618
 zwrZvt6BK1X6XG9x+mIZtP7HtachpoadKMB4nNnsCovSl56cJKJPt/rvluUctgza530d
 kffoqrwr2CzX57bi37OZ+FJ4pE4nbNmSwkg4Ua8pGsRBSFznFPyzkGkoID/VUCYiuF9I 5g== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 38wqjf0hvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 19:46:53 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 152Jj5UQ159275;
        Wed, 2 Jun 2021 19:46:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by aserp3020.oracle.com with ESMTP id 38udecvb1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 19:46:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6eKUxWpsdsIQoCcjnIn3bOx6NYwQbCHD5WH7gg1P1KG3q2IzgHIxvhQToZOxiTHt9XexASKbLcKBds3BDs14CF4DxN/oVY/znwF0nw8rhgOxqZKhu/i9X3El8WyRd9obItcVHlZLeOWEuKmhoH48k5YPw73B7zvvfsXOnXKb6iTLrqza7BPg9I0beZZe87+jh1AW+WJreNJbf9MyXV1kj/hAi1ySdpnMDfr6LWdZYbwutb1K1765uwLXXaa8PuHgdzaPwO+x17Qr87Xr/AHR6wFLyNwcc2hHvLHxzAoqEpJh99pqNT9RSLi23unn8JXMfYj7Lcfq4PzfTuijjvGRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tjAU6bHiDIpLRO7FN5D2s1r8kmGxpUQBIPPqkGCBAR0=;
 b=e3jfCGAnCC7UEbBB4+MeXtPZOlAU/UmMrL6PJW7YtnTAg9fnnkF+tWm0sfb1k2g5SfUXxOakynaaq9lVAiuBKjjxbL3C3xI0ojGZDVvwnDOfnV7b82Ol76XyfVTLPP25nhJKFkNOiiD1bntLHb4lN5n+8S7o1e9//VVPxKJXbcwrMOKoZk6JbDM6DDr9p10ijuk7zEh5L01z1VxlpM4o2M7/7kszv3VF/LN3GJFKo63KR8uNbQ12g2g3aS0yKuAdtRafTUg75tcyuEJqHygJc/Qpyfuw4kBS1KVAks/KoU1EE24QcpKwCMTXo7jdnkzTMnVxX6RSnCNz9lhaY2005g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tjAU6bHiDIpLRO7FN5D2s1r8kmGxpUQBIPPqkGCBAR0=;
 b=GemJ0Ty25yK02JjcaeAeOxePqHgEtTAn7XDcdLjSvJ/FRBTR+zpV/iB/Bvotda29BA3paPELm9xcmlP9Ax/UCRosnElmyPYExwbJe+Z2M83DRi7nQmEggtX1Scbfe4DEkOZuhtlM/73hlH5OS4dNfWFM1pCiw9zF4SeKkSJMIGM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by BYAPR10MB2917.namprd10.prod.outlook.com (2603:10b6:a03:87::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Wed, 2 Jun
 2021 19:46:47 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::103c:70e1:fefe:a5b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::103c:70e1:fefe:a5b%7]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 19:46:47 +0000
Subject: Re: [PATCH] net: bonding: Use strscpy() instead of manually-truncated
 strncpy()
To:     Kees Cook <keescook@chromium.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>
Cc:     kernel test robot <lkp@intel.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210602181133.3326856-1-keescook@chromium.org>
From:   Rao Shoaib <rao.shoaib@oracle.com>
Message-ID: <b53fc81b-2348-54f1-72ca-d143d34bf780@oracle.com>
Date:   Wed, 2 Jun 2021 12:46:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
In-Reply-To: <20210602181133.3326856-1-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [73.170.87.114]
X-ClientProxiedBy: SJ0PR03CA0072.namprd03.prod.outlook.com
 (2603:10b6:a03:331::17) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.188] (73.170.87.114) by SJ0PR03CA0072.namprd03.prod.outlook.com (2603:10b6:a03:331::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Wed, 2 Jun 2021 19:46:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fbcf7c9-5040-404f-fea7-08d925ff2872
X-MS-TrafficTypeDiagnostic: BYAPR10MB2917:
X-Microsoft-Antispam-PRVS: <BYAPR10MB29170F5E05F79BF9CC14DC52EF3D9@BYAPR10MB2917.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G7NHeIyUSN+7SZMY8DxlvXt6ofyEPhIJz3BtgPcmwS5Ru9IERfGRLEf/vlYFptOC0yd7VFkDWJpkJK9hQrPkXl0rlk+gGd8rSzV+itJ7OM8H3+k5EhG8vcjIMxign3VigT3+ReA/R5rxjzIRNRt6BQl4mIUxaio1ZjNDsxE9giXQF4dat4RjR45HPwrXxzsOzf3UGGQGauSHvMV9eAgebgk9TNFE30JDcS7I1Q4ulmLpxjkZfljkA8qU9yheuesOHYfm0+x+wROgZpIz66VPHuEk8jhEr6PCKQp1io8pePnKMktkdvK/I+0QzwXCH32Uj/9k9ZYyftkTgn65Jdp5S6cF8aoXukZAeyDzvLEmFer5DvzyEPXwLNaICacouBUgqPCD6ToF1I4ClN9s28OtrVHFxYSxvRtzz2/cFSamKevuB4BSowJIhALfd/XLBtXM06y2rMDUe8ruK0dmLXQjjef5oUD6RXmHykH3U4NncQIVC60hEIjZmRFxMJG0c1tSjGEBEqDH2v80ZJ5oQR2OL2hHqPL3j902naMHQrvCtcdJruK+ozZnHpmpbCob5Mejahs53D+9HI+A2P+NTZcw5pKILCHIzrLl3DLeP79OLC9Ybt68ClV3ZjCbE9qOvOZPTCrBLSJxfdbehagBn9dVdE7O0w2raxUT3mTSrftUovEzR6SRRkb+oEMpsE4bX5jVzI0WEPVwZXQ9AyXTa5cJ4qz2t6s38+laRpkxL9hapCDIuUyzJguBRU7hmyi/pIpJfYDLDZjPu1pK83Go5ZQV1IPLDms52GMc83dTLfij2UdS007gqbNZHt46A92X3EVq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(376002)(346002)(39860400002)(31696002)(36756003)(44832011)(31686004)(53546011)(66556008)(6486002)(66476007)(66946007)(26005)(16526019)(7416002)(110136005)(86362001)(4326008)(2616005)(186003)(2906002)(83380400001)(8936002)(8676002)(478600001)(966005)(5660300002)(956004)(316002)(54906003)(38100700002)(16576012)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dWZ2aGZQRm56UkRwb1gwd2FtSjBTWTgxY3VHYzM1aTR4YUFmRDZzMjh5QU5T?=
 =?utf-8?B?S3NRM2IwVWo0MmNTanBIRXhFTmJmaWVEdXJsa0tTazhWTzdsMEM1am9sTDFP?=
 =?utf-8?B?d2F4YzRoM0M2V3ZUQmwxdWwvQ3dBeUtiU0o5YXE4Vm5RNjVrYUJMRW9qNEZY?=
 =?utf-8?B?V1NLOEJ2aWdwYTBtL0NmQmhRL1g3SUdiR2xWUkVHemNWbTlQaXlYRDlvY3Fn?=
 =?utf-8?B?RTErS24wbEgrMGdvcUhLYnlMOWNjdzFEalJiK0tCek80cXdGUEJ6bnhTQksv?=
 =?utf-8?B?RE5OTnRZdFJlNVF5WDFHbGN3Qnp0YkREa1VQUXcwcGVTTk1OS0FPNDg2dVVp?=
 =?utf-8?B?b3d2UktUdmdlUHRJcG5Id0ZtSnNWclNYRTRNRHBsaEVXMDhqRk1hL1pLamxV?=
 =?utf-8?B?dS9XbFlkZ3plQThPSldndXphdGwzQmZZQWNSaklJSFAwRmhvU2hZVXF6T2Uy?=
 =?utf-8?B?YjZTOHpqSWhUbXlUVDVBc3dNK1E2ZlNjNExYZnRzc0pJMjNCMUZEZHFwQmZq?=
 =?utf-8?B?bkNVY0RCcXBUM3p0clBaNzc5bzlPT3lhZGRNT2tqcXlMbkpaTlE2UU9XeHVo?=
 =?utf-8?B?WmozSEkyeXNMZXdKZG85YmVBMnhwQXkxS2x0eHRPUGxhWGZabW5YRXZwcDZH?=
 =?utf-8?B?V2xheDFXTmZyNXEzK1RpWVg0TTg0S2tQZUFDN3VoeTFLTHU0enhkNzNMakx0?=
 =?utf-8?B?MVpkQWtoTUJvTERZejFnV0FIYnpGTUlXeXpLT1ZIZDFyb0lUWEZjcWxCdjdt?=
 =?utf-8?B?ZnIzQ3VYVE5Tc2RXK0ZPNDQ0emhFN05laU1PTzdVU2pHOW4vbXE0QXJrelJD?=
 =?utf-8?B?SUQvQzkzZHIzMkFBOU1ZeUhSek1jdTJtRmtZanVuOGdSYXdCTjVNbE9VRkd5?=
 =?utf-8?B?NzB4b1MzcWlJaHEvekV4L3kyb2pzb01PK0pXRy9iZ1ppamVYbElRM29VK3ZE?=
 =?utf-8?B?bkZKbWJrdTBRQWlneVdFWGRWYldvVEd3bGttTS9salJETklqb2ZCbXZ5UC9I?=
 =?utf-8?B?WVJ3ODgwUTloZ2pQQWdDK3ZzWDNKZ3R1U2s3SGJ6SkFGaVZuV0lRcU90T2RZ?=
 =?utf-8?B?MkUySithRXo1RVlxVlZQMXFyaWtpK3lKc1dUd2JUTGxoRjk1Mm9KQlZqM3Z0?=
 =?utf-8?B?SldvdThIQ3d5U1JKSERpTGlBVWcwNXRhMDhCVk41dDBhKzlKQnVrMjAycGlx?=
 =?utf-8?B?Z0xIeVVEQXBZNlN2ZmhGeDhpb1lDQWtINndLRE0zNlBWdlRENDhWUGV4L2Iv?=
 =?utf-8?B?VkVscXdEakZaN1hpMEFPaFlSL2IzenpzcXNmeE5TRXhiK1RCOEYwekh4ZU5u?=
 =?utf-8?B?TWUwWkc2ZkJ3VUxNZDVBaWJLazdSNUhhdGh0KzErSnlwUTdEanRDaVJ0NDhD?=
 =?utf-8?B?Sjlva0xad1psT0xDSXBMaGc3b0RqUVBNYktGd1VWSDVxUEtQcU12UWxBQTVQ?=
 =?utf-8?B?WjVmZi9PdCtuaGNtTFAzSTB4UU9HVU12WG96cDNFc0V6ekJ2ei9qeE1MYldh?=
 =?utf-8?B?UTY5SE9NNlg4Q3NYVDJLN3NHeU85WHByRExDVmVCUXpmRTZDaTRPdno3M21O?=
 =?utf-8?B?b2UzeHZQNTBFRjVvVU1ZSDdYVU84emlIZDgwMVUrR21TT200VWJKMHBLSjkv?=
 =?utf-8?B?Mllvam5DNksxby9OVzBJU2VYN3kyZjhpTXRYdW8yS0YzUnFwRnNGZitQV3lD?=
 =?utf-8?B?d2JOOFA1Vmg2eU1heDFxUDhITlZiNVNuS1F0K0hMNE1TNFVGd2RYTlV2ZGI3?=
 =?utf-8?Q?dvTRoOON+/yBPrGcqZq/TQ7oxjN29EP/v+jmMj5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fbcf7c9-5040-404f-fea7-08d925ff2872
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 19:46:47.6881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UqOEic9pIaIMdohUgElhGkZreBAQzrP0Gwa5pC+eBSas6O8AaEsIJ8lEy4u8S4WyLySNg1A+YfCikTKNqpS/Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2917
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10003 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020124
X-Proofpoint-ORIG-GUID: dg8YlJCRDJInh5PiEcykc3bHUzEFW6ex
X-Proofpoint-GUID: dg8YlJCRDJInh5PiEcykc3bHUzEFW6ex
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Would it make sense to also replace the other strncpy in the same file.

Shoaib

On 6/2/21 11:11 AM, Kees Cook wrote:
> Silence this warning by just using strscpy() directly:
>
> drivers/net/bonding/bond_main.c:4877:3: warning: 'strncpy' specified bound 16 equals destination size [-Wstringop-truncation]
>      4877 |   strncpy(params->primary, primary, IFNAMSIZ);
>           |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/lkml/202102150705.fdR6obB0-lkp@intel.com
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>   drivers/net/bonding/bond_main.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index c5a646d06102..ecfc48f2d0d0 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -5329,10 +5329,8 @@ static int bond_check_params(struct bond_params *params)
>   			(struct reciprocal_value) { 0 };
>   	}
>   
> -	if (primary) {
> -		strncpy(params->primary, primary, IFNAMSIZ);
> -		params->primary[IFNAMSIZ - 1] = 0;
> -	}
> +	if (primary)
> +		strscpy(params->primary, primary, sizeof(params->primary));
>   
>   	memcpy(params->arp_targets, arp_target, sizeof(arp_target));
>   
