Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1551F4B3224
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 01:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354472AbiBLAnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 19:43:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354467AbiBLAnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 19:43:23 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4D5C33
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 16:43:21 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BMck5A015541;
        Sat, 12 Feb 2022 00:43:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=k+dq7AanySVglTR931g9ejavPGRtYZkWEDPNlWmPSKM=;
 b=FApRpONYo1h5EDPe5mU5lblKwlWDETZ6vB+Xq6hKD6Jv4+SvpMFg2IW+OL2RMbByQ68s
 xq6dILD52xPouLn8zAjEWHm3UQxHN8MOuH7OyGZygQb8MuKc/IJgp2G+VXsZCae0gOMj
 BGzDwBmf9/kiyN8j4dkcgzxK9Hfn8rFLachzpwo5HRz7f1NQhPValUbVkLL621TLIQ7+
 jkdlyOhq3Behy7M2FX8RtuPgZT7GGJZ+qO7Bov718rAa6yy7+Rh7lznaZCLoYnNa8oQs
 eievZw4ifXJmzOB+/U3fw5buhVE1/GHhhrcajHCcFZ5388jI3zktl6YtTLxAOix+R/qv SA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e5g98agjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Feb 2022 00:43:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21C0eIcu036378;
        Sat, 12 Feb 2022 00:43:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by aserp3030.oracle.com with ESMTP id 3e51rw5ryw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Feb 2022 00:43:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pu7N0kQL6MBOhMVopM4CjyxePUZ1+7gQWf9LTU+EKRCtlaK0FAd9QUy1QWAy+J00XimRuPOz8zwj8MK2f0raPOrIEHLGZvILWnmn7ePtxpnMQvrWkbSxzUt5XTNzZDGC0B6nyJxYFfhPe1NTVdJd0aa5kXlae8e2ePGmNPcGHhihguNhIW0Z30h9oEwfJqrY8poBT8vmIxu8Jk1CKRykGl1AXnK1nLMel+ckOW5wsWCqVLIsN3+SMTV/CCaatc721yICDvccWBkufaDArgIu7gc2X1ehCZc6yMsZXr2NRdDdRwGj3cn7lqcfBfKHlcqW+rwwzZ8BcsbXpcoEsklVdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k+dq7AanySVglTR931g9ejavPGRtYZkWEDPNlWmPSKM=;
 b=RIdCzjoW/HvRWM+mNdlFgseanOU/LaI2kFkjKWL5raLcLKSOWq4pbZySn5/XxtbfM9A6J7bJ7einWkQ3H6/Ba3DMP4cicOZM2qUXyJtYAqIwxOVyudJ1dr6KFVLLR2B5Co6p8pOoSe0VUKvHQp32CNLM+zSUV5+NzY7UAjd0ndSjTiabl3uftUQs9UpuAtw9oYtkwfRQtFhYeB4aLKEAYGaUm0tJsaitY+WInOPt14m9h0TIV8PmLr2rHLpVze3jhE/e4ZJJxyer0NYmiYMMz3Ma6b1D/hG5NFZmswm3fBmY6PY1o3gFSCdDcl+FpWMNbYHfCv76BSEfdItTql/mZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+dq7AanySVglTR931g9ejavPGRtYZkWEDPNlWmPSKM=;
 b=qpo25HoPOFqOf/rzHiCHyRF3NLHwgHujkRT1yDjZCUSfMf61Z4rAZzP8AarOUG7L+cR6OwYmwGKpApGqSvTbNvhogfYgWTii9cT8I6s1hlhRxkKDWLCoyTeQpVIAyaNUrzi8sEr4kLmTjn5lDbglWVndFLssdM4XYio1VYGOLAs=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by SA2PR10MB4489.namprd10.prod.outlook.com (2603:10b6:806:11a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Sat, 12 Feb
 2022 00:43:12 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::54c5:b7e1:92a:60dd]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::54c5:b7e1:92a:60dd%6]) with mapi id 15.20.4975.015; Sat, 12 Feb 2022
 00:43:12 +0000
Message-ID: <efaed995-6f11-cd3b-8feb-ea92519c2141@oracle.com>
Date:   Fri, 11 Feb 2022 16:43:08 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v1 4/4] vdpa: Support reading device features
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
Cc:     jasowang@redhat.com, lulu@redhat.com
References: <20220210133115.115967-1-elic@nvidia.com>
 <20220210133115.115967-5-elic@nvidia.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20220210133115.115967-5-elic@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0039.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::16) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e8496d8-cc20-43a1-2eef-08d9edc0a5c9
X-MS-TrafficTypeDiagnostic: SA2PR10MB4489:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB44892F26724A627F28BAC61AB1319@SA2PR10MB4489.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z45DHPcGeMB/dtkaTPY0newjKoczL52QDvKtwkyCbC2JFMHw8lchmPRWBMJiLBFSiFBTQKwVC3M64N6MOq43l1NcKaHwC6HsQkDsMPIhSEuC9XdBCs2Asg8J/nQtT+AWkL1btq5f5vHU4Lv5Hz+/4hXgmGMSZn/9aAeOWTajJUaBqIsFXMQHhMOuYLami82gk23HusvO3vn90FQosWQJl94o9UgaQxly7chpdZFDRzQKfrOX4Dsggu8qphsj+tKGxbd6h3lrNjWbDMhhwC7teGSWNgrobzu7VaIjhrhyaeiXPV9b/gQuji1buX89U5fFTVjdpC74rAThR9jHIMr6JiLg7jRMSLc/fb/TfEQ4MW8+d0JBykFFnGuqSl6oEO7AYW+AqCWAnWzbjc9bWF40wRP87RKNexzNWvUy0bMh7FhxCll7KD6ldyENEYtGsScBszdBsiaAduZ/I5hnYPghVQJEUzOPfp4JariONCteleR2WTzs7Dxy2HTZz7zcvO6ptQ1XRvF9DUc4R7k+SL6jIOwXQ316XiStgPNELizruzH6HhYHccyWQ76Yzun8OoOVMfDRaZ/E7pAFagIVAoskHHm4wOj/Kx65UIlRfzYsWfDIF07JseTDOlVF8tbZZtH9mZuqrK63kbdsEeztR/zD+FdUcWGaSHXJRLCqLnzTHELu9nWekMp4L9ynkhDJdggJwa+XHhn0Z2fFDaSYSNv7c4GgnNeMm+ZYXOe1ytidsIGR/YAMrGbDZ7Rsm+5N8bYV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(4326008)(186003)(31696002)(66946007)(6512007)(508600001)(8676002)(66476007)(8936002)(6666004)(2616005)(86362001)(83380400001)(2906002)(36916002)(26005)(5660300002)(53546011)(6506007)(38100700002)(6486002)(316002)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGlQVWNhc2NrUHFYai9jbFgrclZHQUgyUEs5bkpwdTU1d2U0KzFEYmVXQVhB?=
 =?utf-8?B?UDRxbC96VDlnODZOdFdYSHlGNmEzTmwrajYyUXQ5U2NoeVdKNzEvWi95UXpy?=
 =?utf-8?B?dFZhMkhnaG9XQVRtMW1sVWhtcnBaRUdTTkh4NTZpTHcwQ29XOHVsUmJiSXh3?=
 =?utf-8?B?V05Kak8xZms2SUlscm96ODh3SmgxWUtkaWxDMVFENFV6eEZHY2xQUDJTcW9O?=
 =?utf-8?B?WldYR2pTdW5yQUVPb25MY3Z3c2p3UEFkeXFpK0J0cmVUSGhsMWJPeFFCaGY4?=
 =?utf-8?B?aHN1ajFEUVRtMU9saVg2Nmd4VXFVUFIzU1BqS1FjbEI3Y3dBS05jWVF3Z3Mx?=
 =?utf-8?B?bFlkSzdMNmkzSmdwNnBNc3EyRG5qejdIc0JzUkRtdFc0RjNjQitOVXl6aDZo?=
 =?utf-8?B?cEJnbUxIOFFFZlh2aSszK2xCbVNlanZNeWRVRnFZblFpaFlOYnNtNDJjVGQ5?=
 =?utf-8?B?UTk1eUo5aC9UR1NaNjNVUUNZZUNIWEtCbERheXNGaHYwM3dKTzg4ZXpETEdY?=
 =?utf-8?B?K1VtcE5xeUpJakd0bm9GdFRiZHJuUlgzdmYybVpvM2c1OEUrSG9JNkMxeEtk?=
 =?utf-8?B?WFpRWEpYa0NVSE41VnAxcVNUTFoxeGJ4TFNpemtxQ3hmcDlYRGZBT0VDclFt?=
 =?utf-8?B?Y2ZRYWI3M3hQMUw0TTlPaXdsZ2F4MmQyRWIrblViaEx5T0tqQXNhUHdzakRk?=
 =?utf-8?B?RVpsbUdlcENxZjZIT3B2bkJTUHVjSDJYcUwvYVhCOEozVkdCb2lUajVCVVpx?=
 =?utf-8?B?Q0RQMHZnM0NlQ1NPcHVQcFp3V3lBbUo0UmtnYWduSjVGeTJJa21hdWNwWFJu?=
 =?utf-8?B?K0pFVzkxUVV3Q3V6RGxjT1o2TVdLL3dleEV6NHRORVk2VVJWUTJvWmhGd1BZ?=
 =?utf-8?B?MGlMRWVsYVBjbHByZzZ3WTRMS1oxRkJPUk1KM29aK0RudVhjTzhxVlpMMnZZ?=
 =?utf-8?B?R1Y2citHYnBhaC9Mczk4VHlzWDk4aTkwNWZkZGhkWVdIOFRSVzFWT2NEdEdV?=
 =?utf-8?B?MkVNOEtoRTVIWU5LdStwTit6UmVscHUwVmt4ZU5ORGhxaHZmeFJqVVd1VjUv?=
 =?utf-8?B?YXhVWU15d1ZrdEVVeDJ3RmxXeUtzdWtHUkxhTElDeDlqTDRRZWRHV1NxRXJO?=
 =?utf-8?B?M1kwU0x1QnR2KzdCMVlwMzAzNk5QSTB1bE5kdEs5WGxpa1ZQTEhHdmZON1hu?=
 =?utf-8?B?MjJtNUs2cmJDUXd3akxZWkEzTnUzSzRzdyt1TStIbmZ3enJnZ0VHNlZDVG5i?=
 =?utf-8?B?TTByMnFlNlc1alo0bHV3VDZuaHRIZmtsQWtQbUVvYlRia29yamNYUGpWMGxi?=
 =?utf-8?B?R01hZlIzc0l1VnRBTG9MR2Q0dEpoYjFSQnVQc2tvTXh4Z1NwUHhmM0sza0xD?=
 =?utf-8?B?VllwQzNOUStBSzI0NHJ2TEJTNlNHMTBYc3FoRFBDdTN5cm5GQTNDUW1qd2Rk?=
 =?utf-8?B?RG0xYjFUMUZiTVN6UUNhN214bEdLMXZqOXRNcFBmZityRzV5UDdhMEdNOThk?=
 =?utf-8?B?K0VYMTNSRnZmY3J2OVEyU1dYaWhsYVlkS09UZmpKcW5VYmlEWDlma2VaU09m?=
 =?utf-8?B?Z2JzV1B5dVVFejBFNzhFeUVQVU5PVmVuQm9weWRnV01Ea3g3SEhhRDZFc295?=
 =?utf-8?B?RXZrU21DUjVIK25HZlpWYTdlc3pzQ1FNdEVwdFdHSmNsK1J0bGVhL2lWVjAr?=
 =?utf-8?B?Rm4va3BxbkxIWXk2aHZnM1FkUktnVHpqck10aUdpVG1rVGVOdEdqcVphZFVG?=
 =?utf-8?B?NVkxQlRiZGxFYXNreDhaV1NTSzh2Qnk0dTFmNVlGVDJJYXlEZ09ZMFZsc2Vh?=
 =?utf-8?B?VHoyb0dza2VFRGZheG93aUpXTlpNRDlHaDE3VTBuTjk3cGRGQzRsNzhwTlRS?=
 =?utf-8?B?Z08wTFVwSlQ5U24rcDFaeG1QdVJ4cUFTM205NFo4T0xHTHRhMkJVOGdTcjR5?=
 =?utf-8?B?MG5RaHhDLzExK0JieFpOTFFka01Pc3NlWEgxMmZ4dWtPTmVvcW91czFQZWsw?=
 =?utf-8?B?eU1ZczlBbHU0VXpGbVoxVkZ6ckFYaHMwK3AxaTJLZXh5VWJ4NWdCSXBxSE5U?=
 =?utf-8?B?NVM3QnlYeUEyam1abEhDY0gxYllzU2FSWktGcUlveXk4V0ZqZlZGTzBmN3lq?=
 =?utf-8?B?aFhGM245MUhndzBjWTFjT29uQmtBRktlTWhNMkZ1c1ZicVhHalpYOFE0RDc0?=
 =?utf-8?Q?aQGhCCL0J8tlxkDZG/94DJ0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e8496d8-cc20-43a1-2eef-08d9edc0a5c9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2022 00:43:12.2127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TD5meBlNGsdezyBm41mu+QvTEfWMmDW6aJRMZCpMTZhBpzgFOEX7/L3lEpJKMTm+hZH8h6GgPW8gXU4BB9+mow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4489
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10255 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202120001
X-Proofpoint-GUID: 9s2j7fe63F7dsp8_Mbd79pq4fDeQplmi
X-Proofpoint-ORIG-GUID: 9s2j7fe63F7dsp8_Mbd79pq4fDeQplmi
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/10/2022 5:31 AM, Eli Cohen wrote:
> When showing the available management devices, check if
> VDPA_ATTR_DEV_SUPPORTED_FEATURES feature is available and print the
> supported features for a management device.
>
> Example:
> $ vdpa mgmtdev show
> auxiliary/mlx5_core.sf.1:
>    supported_classes net
>    max_supported_vqs 257
>    dev_features CSUM GUEST_CSUM MTU HOST_TSO4 HOST_TSO6 STATUS CTRL_VQ MQ \
>                 CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM
It'd be nice to add an example output for json pretty format.

Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>

>
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---
>   vdpa/include/uapi/linux/vdpa.h |  1 +
>   vdpa/vdpa.c                    | 11 +++++++++++
>   2 files changed, 12 insertions(+)
>
> diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
> index a3ebf4d4d9b8..96ccbf305d14 100644
> --- a/vdpa/include/uapi/linux/vdpa.h
> +++ b/vdpa/include/uapi/linux/vdpa.h
> @@ -42,6 +42,7 @@ enum vdpa_attr {
>   
>   	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
>   	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,          /* u32 */
> +	VDPA_ATTR_DEV_SUPPORTED_FEATURES,	/* u64 */
>   
>   	/* new attributes must be added above here */
>   	VDPA_ATTR_MAX,
> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> index 99ee828630cc..44b2a3e9e78a 100644
> --- a/vdpa/vdpa.c
> +++ b/vdpa/vdpa.c
> @@ -83,6 +83,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
>   	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
>   	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
>   	[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
> +	[VDPA_ATTR_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
>   };
>   
>   static int attr_cb(const struct nlattr *attr, void *data)
> @@ -535,6 +536,16 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
>   		print_uint(PRINT_ANY, "max_supported_vqs", "  max_supported_vqs %d", num_vqs);
>   	}
>   
> +	if (tb[VDPA_ATTR_DEV_SUPPORTED_FEATURES]) {
> +		uint64_t features;
> +
> +		features  = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_SUPPORTED_FEATURES]);
> +		if (classes & BIT(VIRTIO_ID_NET))
> +			print_net_features(vdpa, features, true);
> +		else
> +			print_generic_features(vdpa, features, true);
> +	}
> +
>   	pr_out_handle_end(vdpa);
>   }
>   

