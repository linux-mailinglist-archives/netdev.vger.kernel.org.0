Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC234BC352
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 01:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239928AbiBSAZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 19:25:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237337AbiBSAZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 19:25:25 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9A98933F
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 16:25:06 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21INI7MA032020;
        Sat, 19 Feb 2022 00:25:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=DBCbhpZxsnp2av/R9WSm9fQgDLmM8vf9n8F/hN+DRMA=;
 b=GLJdf/w6Jld5kR6Ol+U+66hnKpwfN+3O8y0zTbrbU3498Oo3UwiqqAZpc7GF4zMl3mDY
 9L2XOgOZOk2zThlL0OVesmBZWNwdruhu5/vJhC3UhtE5RTeqAhsw+Ris27kPT+G0PvTV
 8B8niPHHjhNusQNxiuZw3aj+QJo7MUsIGx+eSvpfhPfF8X4iyIXMUu2ka+cTFR937MN1
 Z81MkistrlxKKNIKqsaZpKIx+gx+bHygdyo+uTS1cTO3HvLqOwUQxlhWP4s+xqU5TCIv
 6BSAEhBie1x4sgJ5dZLvG9tQPys6JZDy+QEkY5acHzrVRJhDiODW2rv/aGmZEgcQfu4H lQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8n3fj856-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 00:25:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21J0GvZr128689;
        Sat, 19 Feb 2022 00:24:59 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by userp3020.oracle.com with ESMTP id 3e8n4y6jge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 00:24:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=liKqCRzwQ1VbA99EOiK7sD7XndSg5CwZR6GLc9yBqqReat+LSwNvDrs4xFUZLVjqXdLye68PcH0Z/xQXXsMp1nJXXTOeXzbhOeMWH9gqL3IchKRsDeKMHmW885QycOOwuhYPbbMj56a5naeV1qWjcXYGWUfSfj3Q/Bvm/oQyXSlfDL03GyTFXE41PJ5fxCcYQgQ07sl4nEXo807TS5qhvs8pFgXv7yi9p6b9vlMQMxp8xKtZYbtSq+WOR5M96cPFDXiN7kyPvrTEwa/HolABLkwgBlwGw6xrfWl//oEnZ/fYV83EGiFIJrW1iZtZmNDeDzQJc6z3W2/swUQYXZgBCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DBCbhpZxsnp2av/R9WSm9fQgDLmM8vf9n8F/hN+DRMA=;
 b=XnHG6TOAIAlWPFcWnWo4mEwiPrCHBW0ys10lkqlRlZmpdMOXXE/MxEKXda8MTI/IZ4ZFiYhxmOIkMvyEHVWIC5G8NDnTKOoOQPP4Gmc6CPrwIfFDAfRDpDy6PnUQt1MNzhkXTijfp40fdfyc4DXdrNKyCivuWm/1Fpo9JYgB//d/oSdrkHjHX1PE9mkSylYlWzsWJUIDkE/bnJUzmTqlVoOk/NwyLdrIm2GXHpd7zDI7W2Un9E425V/DRB2UNHAPa+yQAjEFsS/yH4fMySE9eFnULiNZMYeVLX4897JBOYFLtNQnJXufhOUeTV2hN/830INozYlM6vD9ln8KHVDoOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DBCbhpZxsnp2av/R9WSm9fQgDLmM8vf9n8F/hN+DRMA=;
 b=uabAFOAp+ss/+Pm55bImRvzFNH69rV1yEln62BKVXeu93K8ngkrPQpB+18Bme1opuM/X1MsLBX3ZtEkZmYnOxvnQzyAmERYseLWaJPn0d4k+RzNeG3L1qW5bp12YdggShhRy4IJOhwa7J0VSFYWo1z5PmDVBsAk9Bsy/c7FPpSk=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by MN2PR10MB3376.namprd10.prod.outlook.com (2603:10b6:208:12e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Sat, 19 Feb
 2022 00:24:56 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::54c5:b7e1:92a:60dd]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::54c5:b7e1:92a:60dd%6]) with mapi id 15.20.4995.016; Sat, 19 Feb 2022
 00:24:56 +0000
Message-ID: <0211e7c9-fb05-1801-1808-b2d9cd8f7ebf@oracle.com>
Date:   Fri, 18 Feb 2022 16:24:51 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v2 1/4] vdpa: Remove unsupported command line option
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
Cc:     jasowang@redhat.com, lulu@redhat.com,
        Jianbo Liu <jianbol@mellanox.com>
References: <20220217123024.33201-1-elic@nvidia.com>
 <20220217123024.33201-2-elic@nvidia.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20220217123024.33201-2-elic@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0103.namprd11.prod.outlook.com
 (2603:10b6:806:d1::18) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdd34b3d-eaed-4fab-b3dd-08d9f33e413b
X-MS-TrafficTypeDiagnostic: MN2PR10MB3376:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB33761A069ECF24BA502A21E2B1389@MN2PR10MB3376.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:221;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CnFNhJimgevPxRHYyxBdd+WPW+xNkcHVZqo1rZnCgWJS1PDOpaWGQJyubLIZGhEx506iBimW9imqPsDZJB4FYmxopc5s5P43kBuEkW+9KSJfgH0KdgMbVwKrHI993QPcBNj2vQ6KizTbtP4tyzcAfzVcOaSuARA7fxiyUUGCEe2jL8PFLllgXTjp4lsCp1RGxOGRbEvvs97ZzrHI2Flcwn6TSeVVfPGHGMptQDbAzTwS0aY0agLS54cojmmu0v1gCkXSlcXPk3ISLMLt5O8SZIzEpk76f5Ffq52oW0M31zHtNkcCcG80ikTKbGaJOet7i0SfhDJDPDSRlz/zhkk5dNUy1wWBdYIKKvidDcco27cWOg2SgAQ20kEevYIF4YAW5lsnECYJ+/XwVXv+sVTj7PxsUlymhnNik2owNTvp2R3ak9sMZveAYpuoNSn1ORXesq/g5Xlp7iAErsRAT7OCfF+wiYcgz1/vGCSChuBbA5jcqqKlZITDt7xpPRaIDC3HcDIS2EithHL1yyMRylIOQWd1EfWas+ae9irroWilXXr+dJuQ/Ea+xAISnm3ywxP8T2dA6Oi89NxRj0FfJkh1i2Owj0pF0CCGGS/Z+HBJeh2J43r+fKdZIFwjBg9rosRxpuH9qWnHIA2Yc7Ipsbh6Zssj3LXhtBDj9CxYjDaxgN/TtnwdqUFsUP3KXurD04ayGk1SNhlteWmcY0c0d0AeozgdAG9/Fzuzk8cYpYRxYyA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(38100700002)(5660300002)(6486002)(508600001)(36916002)(53546011)(6512007)(31696002)(316002)(36756003)(26005)(186003)(4744005)(8936002)(83380400001)(66476007)(66556008)(66946007)(4326008)(8676002)(2906002)(2616005)(6506007)(6666004)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTljbnU0a0V6Q2VhT2dHbzZtSDN2MHkrdHY5eVJlV0pyeHkvVGxZYTdnTXpy?=
 =?utf-8?B?OWFJakNLam9VM0dsa1h4cFl4b3puY1JpcjQya1pKQWM2MlVxVkJ1Q2U2Y3lT?=
 =?utf-8?B?Mkg2WXEvdzA4VGhTN2JuNlJZaERBS1h5WWVMRGIvVVJjaFZHbTY0MU9RN1pZ?=
 =?utf-8?B?a3hQYitiSTlxdGJCWGhZRmdYdWQyZ3dlanVxdDM1T0ExMkkrbHExdlZiVEc4?=
 =?utf-8?B?QzI3VVZOc0plWU1ZL09vME5mdWMyenE0VGk2UEdId1doSm1tTXFLc1d4eFVH?=
 =?utf-8?B?bTljSW5xTjh3ZUo4L3JaUVdqNGo2SFozTndmTWwydHNXNHRhR21RTWJ6VkpL?=
 =?utf-8?B?VVg4WGZoNElaSTZ4dHNkcFdncHlaai9jN095elk0aC96WGI1a3cyVWNmbmJX?=
 =?utf-8?B?RXZpSnVYdXJDMFRuVkJMNmlTZjdFRGtjdkt4NnE3ZjhQMWJ1Q2huMXVWckhk?=
 =?utf-8?B?cXNLcW9VZ1pBeW9idlZVUGxWdnRvOWVQMDBmb0FDU2ZWMjRDeVRNeVlmQVgv?=
 =?utf-8?B?WXM3UGVsNzZQSk1QWkVpRXJkNmhjQzgxNDI0WlhSSXRGUmxxWXpJSGtmZk9q?=
 =?utf-8?B?NGNQdXFvUjRENzQ4WHhjdXk5NnpmOXNsc0Z3YzRNWFc5czJTWmg5Z3FUd1Rq?=
 =?utf-8?B?aVJqY2xiNmVoYSs1US94TkJLL2lCbFpLdi83NmQ3NHFLUk9zTnZFaThsZnNk?=
 =?utf-8?B?RFltaWNSeXQ2b0ZZZm55eEEyMTJCZnFHamlvaWNGVFBmQjZhUHJEbVM2THd0?=
 =?utf-8?B?c1pEU2ZyL2RHMVV2WDNJMmZFZVhlSlRvUGpzUWhwbjZIU2c4aXRubXFzeXZK?=
 =?utf-8?B?Y1hUeE0rNEdXNkJWZDJUeDZ1SzFqQkFuSFFnb2Z2cDRLVUJBOUlBVEJHNi83?=
 =?utf-8?B?M0dNVzh1RU5nVlJZcjVIaFBGVlFkUi85YzBhak8xK1RtK2JaYXZVdnN0bmhs?=
 =?utf-8?B?MzB5L215L1FwcmoyNXVVeDEzV0RNWHNiaWlZUFdSVHJQTU9US0hNQ2NjVllR?=
 =?utf-8?B?dXlKUUdnTGQvT2xRUmtsRERRM2gxRDF5OHFIcGFBNlprSUI2ZHdZSmFYKzEr?=
 =?utf-8?B?ZFVxbFBpSnJBTFRHVFEwU1ZhSEdxWmZOaGZ2Ry9FS0t1Nko1OG1SRzRGL1pE?=
 =?utf-8?B?dXU1aTk0ODV1Nzk5UGk0czZUN0Nla3hVOWlXS0tLa3N6d1VycmhMcERxa2RO?=
 =?utf-8?B?LzBmRW5zanZWM2RGbVhKaFppc2dKbWx1MnNyeTh3ZmtGSnlTN0ZMOWRGdTVm?=
 =?utf-8?B?ZFEwaHZLSzFoN1JHZmZLL3ZxaDZISGtnZEtxNFNhdkRDaURSekpnanQxdGJo?=
 =?utf-8?B?WmR5TVAvUDM2MExYdzBTOU1aemRBVU1uakxDd1NUK08vMTQwemNzZXBuVWU4?=
 =?utf-8?B?Mnh4VGRsK0tvUXZtUFUxTmpaNVhyZzdMUWV2SXhua3FueDcxNnhqRmtoSEJw?=
 =?utf-8?B?VGRGSkIrUzBXY2xzdlFwODBaT2dSaXY1VHcwOE4xS3kxd29odzJIcThXU0Zv?=
 =?utf-8?B?REpRRHhoUFFqbWlhSldxa005OS91djR5dEpBK2oveFd3bTlPckdxaTlLdi9C?=
 =?utf-8?B?bXZ3NUZ4Vmg1U2VKK3o5c3Nsdmd2YmtKcjk0Wnd1Z1VtMGRCbnJyUWV3cE4v?=
 =?utf-8?B?VXFCbk5jYmR1NGpkM003eDFQaDVEQnNBRUI5V2htTTI1aHJrY2xSd3VKN1Yw?=
 =?utf-8?B?QXBXcVpZa1BrK3FDWkZoQUxKZjB4Uys0Vk1CVWEzaU5DMWtlS21FQ0JGQVRh?=
 =?utf-8?B?T0R6Q2ZmMU4wT2toMUx2UUJaVG9ka2gxM1UyaTFldnU2YmVteHlnQ2VOSk9W?=
 =?utf-8?B?RW5kZU9SUGlnVVRCUmZwOEJpaGgvcEdLUmk0MHVyaEhMc1hnbVJmUFNYMXRr?=
 =?utf-8?B?SVhla0hEbmdSWmxDdEVFSVU0S21hM1pnSEVBZ0Z4L3JnTTBVbysvK0tKenVw?=
 =?utf-8?B?Ryt6S1BLS0dBYklMcmx3M004aFJXOHRFdTBBaExCWkhlL2FiaFhnMytkQW5O?=
 =?utf-8?B?RjNPbG9EN3dialNhR3NLdVdkYkdTSDdhdExmVVlqSjRySDFzVVVjK1ZpZEts?=
 =?utf-8?B?VXNZZUpvZWRIcHNGUk4rTkhuMVpqaEx6UDFaWjdORHJpTmlFRE53SjI1WG95?=
 =?utf-8?B?bjNTejhIQzBTVWM4dks3VlJTdHFVTGVzb3ZQUGFnQk9PWDgyQ3pSbGtadE1G?=
 =?utf-8?Q?OyW+dNA0BRNBhIsfTqTjTd4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdd34b3d-eaed-4fab-b3dd-08d9f33e413b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2022 00:24:56.5557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YUEEsXJb9ufYGwZvXh2dOY8Di8FP6NWsxYmi1adJgtOCdszx/qhzLo/i8gKBSI8twMYyWoMvXXRLh3uGqIQ/2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3376
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10262 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202190000
X-Proofpoint-GUID: zrQdq9n9W-6sQLanbUxZaJw6zl5oAswO
X-Proofpoint-ORIG-GUID: zrQdq9n9W-6sQLanbUxZaJw6zl5oAswO
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/17/2022 4:30 AM, Eli Cohen wrote:
> "-v[erbose]" option is not supported.
> Remove it.
>
> Acked-by: Jason Wang <jasowang@redhat.com>
> Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---
>   vdpa/vdpa.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> index f048e470c929..4ccb564872a0 100644
> --- a/vdpa/vdpa.c
> +++ b/vdpa/vdpa.c
> @@ -711,7 +711,7 @@ static void help(void)
>   	fprintf(stderr,
>   		"Usage: vdpa [ OPTIONS ] OBJECT { COMMAND | help }\n"
>   		"where  OBJECT := { mgmtdev | dev }\n"
> -		"       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] }\n");
> +		"       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] }\n");
>   }
>   
>   static int vdpa_cmd(struct vdpa *vdpa, int argc, char **argv)

