Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D595A531F87
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 02:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbiEXABy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 20:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbiEXABw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 20:01:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F36264D31;
        Mon, 23 May 2022 17:01:50 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NMhwG0032381;
        Tue, 24 May 2022 00:01:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=qyRq24xBkEq/hXeo8gMtg05VmrgCCG3jrh7vGomdtA0=;
 b=Uqoh46fmICLIcx3Ae44UbpbUX2eT6QidYYs6geM4cyCvbcziSzSiSZmhBOqOCd6kHrFf
 QfxBDLfc42qs6czkOVI2U25WnDlbMk0/Lcka/RkW0PR3Jd2g8xPMZRT5cPFMdWWQ3/IZ
 20Z/4aNL7apKBcKQcoh0HjOzyhuCWDOnRaCt7kWBZQnTNaPlMz8LIbqdo7tceC99Ek7Y
 zfXzFLgWu1UeehTU0jsoQZUyuT2On+6ACXb82CBlzIIXzVD0s0Eq9/l22paxv3FhwB8g
 Edf25rAWfzmPGyXzNoDDm4X8DwKYUmRy1XZIJUbBztjywqAL20cqpXn0GV7GpHdpKW0Q UA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6rmtvtfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 00:01:33 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24NNwJN5025568;
        Tue, 24 May 2022 00:01:33 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g6ph254rx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 00:01:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CvF07w5Mbo4kPfPCnmDFBkrQ2UHUQsKM4yxEtr/AMxxpFGi5AaK2PhocuMb0G8SpCjmF6f2vmdPhAI7frPz2YSYBc4oyKcSmyTqjdUb8NvAl40+LJ/iKPtWEz0f3IN+mwzPqabHzlZTxFt8twOsPNSw3XouC3McAPPgey+v2/4ogna+7/5T5MGw5dngHtK3hEQjcYmqGdpmUs9oOq/jxuyuHgIwtsniKdsHvn3ygKMBdWf6bc5wq/s8s4oSmeqf+vwuXw8RlxV80EDTDmIyl1bgzB9+PyL0zS4JuW9Z4VOiw1HYtvkHt04cikGS65PheH1YpO3y32V8RYZ6mgI2PrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qyRq24xBkEq/hXeo8gMtg05VmrgCCG3jrh7vGomdtA0=;
 b=EHNR6sxEfxNNpy2lhSmi48394Mg+K6WzKjuPSz6gG/AK/an3Su1BatREypQ3Du4HHFEr4K7iMWD7vAdIfaEei/ABQ71t2oDsRpkgsMhYynjFf3e0DSP8jck6++TyZ7E6BK50meEdoZ4DstXknnN7dv6CsjIUHAuedaAB0ePNClIkKgcG0bxDqUN+b65b+y2zOgJdjg050jZo7b8a/O21XjWRFo/qB6JuDdZz1qu44+/N247TQuWzTc+RfTRIdluU396lPgMURSKYD4GPidC1ZGvHs7PCU2N9Y9fWvuZjMk/UVjlyw5QFxac87hjHiFegraRPUeaKIeAk/US0y+K0wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qyRq24xBkEq/hXeo8gMtg05VmrgCCG3jrh7vGomdtA0=;
 b=wu1Ut7POhkdGK5u+WD03SN4tuLQSfIVPm4R3ODs70OlzhXy1cOQnhwAPPV/Bf7KAH33NcAlOqlv8KHpgTNf8wgmR6GZEWlUikLEuAsgiYTYtXsJq9A3Uh6RyB+Rnc4UtmhAavxJlic9J4l8i4+EFkLnP2+Mb7BzJeC5xOJHzdoE=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by BYAPR10MB3173.namprd10.prod.outlook.com (2603:10b6:a03:153::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Tue, 24 May
 2022 00:01:30 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::c89:e3f5:ea4a:8d30]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::c89:e3f5:ea4a:8d30%2]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 00:01:30 +0000
Message-ID: <9f68802c-2692-7321-f916-670ee0abfc40@oracle.com>
Date:   Mon, 23 May 2022 17:01:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 1/4] vdpa: Add stop operation
Content-Language: en-US
From:   Si-Wei Liu <si-wei.liu@oracle.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>, dinang@xilinx.com,
        Eli Cohen <elic@nvidia.com>,
        Laurent Vivier <lvivier@redhat.com>, pabloc@xilinx.com,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        Xie Yongji <xieyongji@bytedance.com>, habetsm.xilinx@gmail.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        tanuj.kamde@amd.com, Wu Zongyong <wuzongyong@linux.alibaba.com>,
        martinpo@xilinx.com, Cindy Lu <lulu@redhat.com>,
        ecree.xilinx@gmail.com, Parav Pandit <parav@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
References: <20220520172325.980884-1-eperezma@redhat.com>
 <20220520172325.980884-2-eperezma@redhat.com>
 <79089dc4-07c4-369b-826c-1c6e12edcaff@oracle.com>
 <CAJaqyWd3BqZfmJv+eBYOGRwNz3OhNKjvHPiFOafSjzAnRMA_tQ@mail.gmail.com>
 <4de97962-cf7e-c334-5874-ba739270c705@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <4de97962-cf7e-c334-5874-ba739270c705@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 086429e7-4e43-4e75-a04e-08da3d188e5f
X-MS-TrafficTypeDiagnostic: BYAPR10MB3173:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB3173C983C73C33F1E7BD3FA9B1D79@BYAPR10MB3173.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cdLY0uyQ/ZElSFiLKqq2pgtq7FdR80ZecnEANIvjOiOlHzN8nKr5eqhI3mgKPAUwQ8uMvXGFWW+Q1HbdrQAWFNrjdj+C/fOHL/YamRpB8qSV7NG51fzusmN1+6Q3YsXr7uxl9iCVGNxjH//M7AZoqicJSvkhWwt8aCMJ/Zhwv8fldiPoGqmz6wp51SwCFjP4atfuGNWKRq7U5NZRn4gpHncDYqNWteHAtka6RQZcx88NIFTQ77Fp8MgmhXTmDmhX9IORLApgPdlD4LuYodstyEg0XBDHLKnAMhCBiqBbrn6lhXRDH6Ka/BjoFJ9pe9kAqD6JWvd6hx9Sr7hDDDGTllq1cudTRPT+uTjVKEWDi4tY54Fj3EyHPUJ+vtZsC2F2q7lzVnqslSAcx1qqiopC042H5qtMQOuvLgJR8ZWSWto/RtehS9CZCBreIcHYdptx7IBCjlDFNO7hn/jXKelNhLKXrBjFmH8cujjOKf+cfPbFzpmldJTVt3c5C/OmMbQk+rnqCcqFXebcMKGZMpyCDNmCYeEuQZqeVOwC9EpS8xf5xwtTTOk2Qda/eyP4wbCBFj9ajClj9sTJ/i0frRoQkZbh17FpHV9q/ryeK1fZqeqdKgcnpy/CFdulWm6Wkye5a4zw3PD6c2ItdebegqjAj5A1qYwexk/3q1kYbG9wulsLaAgDq/MdTXumtX7dqvq6n5DymynCmzvGiZfo+WnCJqhZN3vf1EnZjg1LR9W7eNdrCEsL8BRCHZEQIWkahC7w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(6486002)(31686004)(2906002)(26005)(6512007)(36756003)(6916009)(316002)(54906003)(36916002)(31696002)(186003)(38100700002)(8936002)(4326008)(53546011)(5660300002)(6506007)(508600001)(86362001)(66574015)(83380400001)(7416002)(8676002)(66946007)(6666004)(66476007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RlRJQk5hUFdDRkdrSDVTQ3BZS2R2YWd2bHJqWVdwR3pjMkF1aDBDMUc4WDY2?=
 =?utf-8?B?RUNMcFVvZGtNWjArMzZSd2tsOERmczFOUlQzTmFzWmVKUFdBRkJBZUhnWFZi?=
 =?utf-8?B?c1pHbGNQV1BqMnJLUnB2eEF6N3lUckJML1dYaWtacTFuRDJGbW03WnNmaVQ4?=
 =?utf-8?B?S01KZmFGSDRhN0p2RjI1WE53anhqWWF3OWpBYWEzdHpjTjhmVUc3NWVSWXdn?=
 =?utf-8?B?SDBDZks0SHRjT3JwVjdnMTVlZGpPYUxkN3pVcDRtTmI1eURzME5UUkdHc0FZ?=
 =?utf-8?B?TFYwU2h6SlVNa2M3TnFOTUdnT2JzUlAyWUZuOXZMM3lCZVY3WnBSL2FqbmZ1?=
 =?utf-8?B?WkJyN2owa2JpTWRtRmo2Z2JsTEV3RGdZZm1kQno3b2djdjg4YjEvNEUxRWdp?=
 =?utf-8?B?V1hGRHg3TERVdG9QeGtmNzdNMDV4WmZibmxVV05XbW5xSlZWOGJzOU14bnpT?=
 =?utf-8?B?ZGh0UFMvUVRHMFN1bnllTlE5dUo5QzVDWjBqTkV3a2JZSWFjWlZRemIxWjBB?=
 =?utf-8?B?RnNvL2FDL1g5Q2R4TktNaHhxeC9SL3d6bExLTTVFY1Uxa1lNSGZXY0kyUGlG?=
 =?utf-8?B?YzFlcEMrUFBFejRkZEhyWkhwZHFFSk1mckIra25GWFA4dFhGYS9MSWJZYThj?=
 =?utf-8?B?VmcrU0VtZVcyendIU3BBYk1LL0ZoVkJoQkZKZE5xQWhneDNISitaMW5RZVRR?=
 =?utf-8?B?THNRSUtVWGM3cTFNTGFWM2V5UEFUVk4xekVJd3M3dzRSaGJGUzBYN3dXcDZI?=
 =?utf-8?B?dzJSMU11YjQ2R2VDSDkyWjEyMHAvSXd4UVBWMnBEYjFVeHI2azlWRyszZ2Fm?=
 =?utf-8?B?SHBJN2h3T0xBZ24vZFM0NUZ6UzlXYlh2YnJYWmZUZ29jUnZQNkhQUm55ZUNH?=
 =?utf-8?B?azZycmt0S2orNGVJZlRRVGxnWVFqRnk3Uy85Zjd1MWhqWXgveWhZb2dqbGE2?=
 =?utf-8?B?bGdQUmRCN1V0QjhuQVNNOFV5S2xZNkxsRTlmS0h6MG9UbmxlY1ZIRkJEak16?=
 =?utf-8?B?eWs0ckZmNWdkcnJGQko4V1R1L3lacWJ1QlM5b2hYVmtMNWJLT0RtSEVPQUF1?=
 =?utf-8?B?bEtnQXJNMVNkQTQ3SjZ3dEZRWkZWRWxNeGhweXNYZ3hobkxZdnY3c3FiU2Vx?=
 =?utf-8?B?MlArNndQZUZMME9XNW5mWmlXMlBuMUFwd0orK01Rc216TnNqV1NtVUVyaFVw?=
 =?utf-8?B?dDRNTTZiT1lsakpaZlpUbGEwZWRqM1VwTEVZWTdrZkxFdmpzVzFzTGVoMUFk?=
 =?utf-8?B?Nk9lWWUvU29RSUZIK25XUzZwNENnNW1GcEtJSHBlUHBKR1JCanRiNXFoZk9H?=
 =?utf-8?B?MlNwOFNKVmUyYTVXUEpjbG96QVdLazVPT01uRzBzb1VldGZTNkZZdWhjbDNQ?=
 =?utf-8?B?bzcvS24zTlRyVkY5SlBQVlRuRHJPT1owQzFMdDFGWHFKTnAwNm5KbWkxOGk1?=
 =?utf-8?B?dXR2ck5pem9wV3dnRVc2Qkw1dnkxMFJ0S0ZuUFJJNGhLOHZYOUFzMDJnaDll?=
 =?utf-8?B?ZWMyZCs2aDFjSHRrbzN6R2J1UVdLKzYybXBxTnFqUTE4dnFtc0xuMyt0TFdM?=
 =?utf-8?B?eDVid3Y5emd6ZFczVnhSL1lsdk9wT3l1dEMxT0hMZ29BYUtIOEl3T1hoeCtn?=
 =?utf-8?B?RXlNU3hCeld0dm1YUzgvalFRMXhZK1V0OWVteVZRbG5aMWJZcXVNZForUmtC?=
 =?utf-8?B?Yy9BWi91aENZVTBsTm1iR01MQjl2V2I3c0l5ZGZHcVlYN2FtMjIxMU4yeGZ4?=
 =?utf-8?B?QllmdnR2TDkwVXJhMEtVdGJPM2FVVU8xTWQ1ekZIV3BISSszZ25teVo1aGV2?=
 =?utf-8?B?SGxJMDh1VFhMOStZRTNiMUYvRndPdFVQZ1p3dDBVUW1nQU5VSmFVUXBKaUdL?=
 =?utf-8?B?c1U4bTRrSlRoOUFmcXhwMmo4Ly9aREcwV2h3MzRuNno3QmVNUjJuMUswd2ZU?=
 =?utf-8?B?UGtLQ2thSG5aMFRBWm5zU3lFbGY3UGJsaTdPazVLSklwZ2o3SzZZellYVHRj?=
 =?utf-8?B?T1hmL3JTempDN0Q1b2FiSTlTRGxJZUJidzN3S08xSEdFWTBwK2RUaVBPcEVF?=
 =?utf-8?B?OFdiWUt0eW43aHlPWS9mRzVqVHhkRXVMUUNJNk1EcU9vMHRUSU05YzdYeVBK?=
 =?utf-8?B?WjZrREtRb2NybUNzR0E0a0FvVjVERk42S2ZNK2pUdkkzdmo0bGduY3dtR01E?=
 =?utf-8?B?bUdYYktJMFhsOVZMdlNPRU9lSSt2UFk4bk56eiswWWtTQS83ZWRQby9CWndz?=
 =?utf-8?B?S1Q1WjFvK1ErKzRzRnZrZFhkS013ZC9NNEIzRGlhNDNlT2xJaGh4WFVQYTFk?=
 =?utf-8?B?NVBHZGQ1RDh2OWdMUUVJd2lHK2t5ajVhTTdkODhvOHZ4WVpRbnFTOW1NVUx0?=
 =?utf-8?Q?ZXw1AMwnr18m2Cy0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 086429e7-4e43-4e75-a04e-08da3d188e5f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 00:01:30.5362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4X97nxx/xaZyz+y2vEfwjvO4GgtogHTMvjn9yUPyv8VbhBJ4yOSrr5WkHewdJtTWBONo+xuNO5ZtoBTX3SETQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3173
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-23_10:2022-05-23,2022-05-23 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205230123
X-Proofpoint-GUID: ToxyOj29RwLtRaUMfUF91ZIQBQzXURB5
X-Proofpoint-ORIG-GUID: ToxyOj29RwLtRaUMfUF91ZIQBQzXURB5
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/23/2022 4:54 PM, Si-Wei Liu wrote:
>
>
> On 5/23/2022 12:20 PM, Eugenio Perez Martin wrote:
>> On Sat, May 21, 2022 at 12:13 PM Si-Wei Liu <si-wei.liu@oracle.com> 
>> wrote:
>>>
>>>
>>> On 5/20/2022 10:23 AM, Eugenio Pérez wrote:
>>>> This operation is optional: It it's not implemented, backend 
>>>> feature bit
>>>> will not be exposed.
>>>>
>>>> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>>>> ---
>>>>    include/linux/vdpa.h | 6 ++++++
>>>>    1 file changed, 6 insertions(+)
>>>>
>>>> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>>>> index 15af802d41c4..ddfebc4e1e01 100644
>>>> --- a/include/linux/vdpa.h
>>>> +++ b/include/linux/vdpa.h
>>>> @@ -215,6 +215,11 @@ struct vdpa_map_file {
>>>>     * @reset:                  Reset device
>>>>     *                          @vdev: vdpa device
>>>>     *                          Returns integer: success (0) or 
>>>> error (< 0)
>>>> + * @stop:                    Stop or resume the device (optional, 
>>>> but it must
>>>> + *                           be implemented if require device stop)
>>>> + *                           @vdev: vdpa device
>>>> + *                           @stop: stop (true), not stop (false)
>>>> + *                           Returns integer: success (0) or error 
>>>> (< 0)
>>> Is this uAPI meant to address all use cases described in the full blown
>>> _F_STOP virtio spec proposal, such as:
>>>
>>> --------------%<--------------
>>>
>>> ...... the device MUST finish any in flight
>>> operations after the driver writes STOP.  Depending on the device, it
>>> can do it
>>> in many ways as long as the driver can recover its normal operation 
>>> if it
>>> resumes the device without the need of resetting it:
>>>
>>> - Drain and wait for the completion of all pending requests until a
>>>     convenient avail descriptor. Ignore any other posterior descriptor.
>>> - Return a device-specific failure for these descriptors, so the driver
>>>     can choose to retry or to cancel them.
>>> - Mark them as done even if they are not, if the kind of device can
>>>     assume to lose them.
>>> --------------%<--------------
>>>
>> Right, this is totally underspecified in this series.
>>
>> I'll expand on it in the next version, but that text proposed to
>> virtio-comment was complicated and misleading. I find better to get
>> the previous version description. Would the next description work?
>>
>> ```
>> After the return of ioctl, the device MUST finish any pending 
>> operations like
>> in flight requests. It must also preserve all the necessary state (the
>> virtqueue vring base plus the possible device specific states)
> Hmmm, "possible device specific states" is a bit vague. Does it 
> require the device to save any device internal state that is not 
> defined in the virtio spec - such as any failed in-flight requests to 
> resubmit upon resume? Or you would lean on SVQ to intercept it in 
> depth and save it with some other means? I think network device also 
> has internal state such as flow steering state that needs bookkeeping 
> as well.
Noted that I understand you may introduce additional feature call 
similar to VHOST_USER_GET_INFLIGHT_FD for (failed) in-flight request, 
but since that's is a get interface, I assume the actual state 
preserving should still take place in this STOP call.

-Siwei

>
> A follow-up question is what is the use of the `stop` argument of 
> false, does it require the device to support resume? I seem to recall 
> this is something to abandon in favor of device reset plus setting 
> queue base/addr after. Or it's just a optional feature that may be 
> device specific (if one can do so in simple way).
>
> -Siwei
>
>>   that is required
>> for restoring in the future.
>>
>> In the future, we will provide features similar to 
>> VHOST_USER_GET_INFLIGHT_FD
>> so the device can save pending operations.
>> ```
>>
>> Thanks for pointing it out!
>>
>>
>>
>>
>>
>>> E.g. do I assume correctly all in flight requests are flushed after
>>> return from this uAPI call? Or some of pending requests may be subject
>>> to loss or failure? How does the caller/user specify these various
>>> options (if there are) for device stop?
>>>
>>> BTW, it would be nice to add the corresponding support to vdpa_sim_blk
>>> as well to demo the stop handling. To just show it on vdpa-sim-net IMHO
>>> is perhaps not so convincing.
>>>
>>> -Siwei
>>>
>>>>     * @get_config_size: Get the size of the configuration space 
>>>> includes
>>>>     *                          fields that are conditional on 
>>>> feature bits.
>>>>     *                          @vdev: vdpa device
>>>> @@ -316,6 +321,7 @@ struct vdpa_config_ops {
>>>>        u8 (*get_status)(struct vdpa_device *vdev);
>>>>        void (*set_status)(struct vdpa_device *vdev, u8 status);
>>>>        int (*reset)(struct vdpa_device *vdev);
>>>> +     int (*stop)(struct vdpa_device *vdev, bool stop);
>>>>        size_t (*get_config_size)(struct vdpa_device *vdev);
>>>>        void (*get_config)(struct vdpa_device *vdev, unsigned int 
>>>> offset,
>>>>                           void *buf, unsigned int len);
>

