Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18EF863E6BA
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 01:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiLAAxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 19:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiLAAxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 19:53:30 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE9056574
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 16:53:27 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B10htCu019424;
        Thu, 1 Dec 2022 00:53:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=C1FsL234lkshcJZENakuiziePcD68/mdZaF55K7Yb6M=;
 b=bmgu4jgaTbTA0b2U0hOBU2mS6gbf8w63U06re2wwb3qCRFDSgxDKkEDSOeor2HGmt6Cx
 LZ/nl9Z7BVZ7XcaPDShXZSDEILN+fmBsHEHRmBur+4ikWnuzWgH2w5v/ZBlAjfpWp+7D
 r76kfvug243zLLNJEHCMMIDT6C1omMsa51UXDoFauAIGEflsyDi1jub7RuSLY/UpIQRG
 P2Kmn5HwDutR+uzH7IFVcDMTcYbhZCw5gSMChAUclhgm6bPaCTWO00qrkxZB1MNXQWnj
 wg9zBSvaFiHILtXMsIAIjUR5WDAOqQxOA1vuF4vtbgVmWM/LHpubjyJZ21icXrilBumg Dg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m39k2v7pm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 00:53:10 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B10AIdC007594;
        Thu, 1 Dec 2022 00:53:09 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m3989vjtw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 00:53:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZunkZ+DZNG77p8A/4nSSO6xgjHy5V4884IyI5fK2vPGKvbHQA0hugrzbBcjXEksqYsbMpc9B4EmUFj655fMcAN2cmLaJiDtS4LIqZza9wNyeBnI5Llb0XJq1kss3F/7idi2f2+zLCB38GbHUfPZK/JZPjrBr1Lpnqk9Zehs4zNmSNznfod52cuwrOUG3d911cALpcnRHIfIiB+soNAzDVl9DvnLviSvZxbXr9hzD92E/E6hlInueDs/mky9P3Oqbx0/iDeYNttI4S8lMm8bqUylQlH3/D5Yh2stwlOliKpjOgfJn2eGTyTPxQk2oakagCHJ/bw9TYi43pdV8GDY3fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C1FsL234lkshcJZENakuiziePcD68/mdZaF55K7Yb6M=;
 b=a0DBRGEYalZzkhrJVsX4ryu8D4OM5BCRndIOd+TWczIJ0z5JLHSC2cV0aiGh6hCKmrBrmrVUdO8i/B/h2WID/7xoj3HlHJGoQqYU9ItSZwou+yStrurtzgnVkFFqksz9gP08OVvpvBCTk1AYpfAWSRJ7r9Rdo7SnhqU7oZk1wVU5yDJDaNjrXPlhuvYRv+AYhp4Pn9hAtn0tVyHrl+iFEq+1qBlPXR7s0KPIdZ1gC9lhhYm/XfhCMfYFATfiJ/PBYvH8AirKsFXJ5AbD5DshfZJScy3iErBl0slIRxE5XQGHnbwmzbrr3SyEeQkzHTSrhpcLxb1P4qiJs/b15luwVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C1FsL234lkshcJZENakuiziePcD68/mdZaF55K7Yb6M=;
 b=TjZeHzAG8a3quxy/+KvIop9zeJ686W68jxNZgQ/G/f9yM2BWHxqRHsBAdI4lHPdELr4bFxnjbMVbK0Oe+v69B7OukGOciJbn5JydNBayjKRNVejfm+hTvRylTB7CUoVnmNHW7jl0nOawwRyiNA9DkYw4NCM6oA+uMPBfijxqAq8=
Received: from MW4PR10MB6535.namprd10.prod.outlook.com (2603:10b6:303:225::12)
 by MW5PR10MB5873.namprd10.prod.outlook.com (2603:10b6:303:19b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 00:53:06 +0000
Received: from MW4PR10MB6535.namprd10.prod.outlook.com
 ([fe80::d1e:40c4:40e3:e7b5]) by MW4PR10MB6535.namprd10.prod.outlook.com
 ([fe80::d1e:40c4:40e3:e7b5%2]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 00:53:05 +0000
Message-ID: <d4a85c3b-ab0b-a900-06a9-25abdf264e97@oracle.com>
Date:   Wed, 30 Nov 2022 16:53:01 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH V2] vdpa: allow provisioning device features
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, mst@redhat.com,
        eperezma@redhat.com, lingshan.zhu@intel.com, elic@nvidia.com
References: <20221117033303.16870-1-jasowang@redhat.com>
 <84298552-08ec-fe2d-d996-d89918c7fddf@oracle.com>
 <CACGkMEtLFTrqdb=MXKovP8gZzTXzFczQSmK0PgzXQTr0Dbr5jA@mail.gmail.com>
 <74909b12-80d5-653e-cd1c-3ea6bc5dbbde@oracle.com>
 <CACGkMEs7EGUsJ8wtZsj7GEMD9vD6vJNVRUu1fcwUWVYpLUQeZA@mail.gmail.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CACGkMEs7EGUsJ8wtZsj7GEMD9vD6vJNVRUu1fcwUWVYpLUQeZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0165.namprd13.prod.outlook.com
 (2603:10b6:806:28::20) To MW4PR10MB6535.namprd10.prod.outlook.com
 (2603:10b6:303:225::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR10MB6535:EE_|MW5PR10MB5873:EE_
X-MS-Office365-Filtering-Correlation-Id: 902a18f2-e03f-4964-e037-08dad336682f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YKZZ4Z9hLMSpDaafG0ARMt/sBBNWWh9s/j3aDsuAMK5mhiKOUL5SRXgbt8XMEXHqZ16qbcBxIUaz29XjCXDU5LkphFiB8cy5aViIn/M/4QkEJolB4xaLGEIfb7CF5GwpyFFW7sPMFtVfpe4IVhk/MO1mbKFsKJ52g6mOMJOyOKojsYsCCyn43zg0Zqk1apCANxu9njdo97CkvzRj/E10t6h7P6X5rwKp/ASR3mKapQzNWb8NfvDZWrrtY8M5AW1XJ0dAF+sxrKAQLxo2s/5plnwIGS1UyNqDUPdpeAeKDivYaI4Vn7yXKGipwyUVKYT8DEm0yvlzOq7QgBvXqmXE6uzEY3ZcUfJ84FBXLf1lBIsfsVSSE4f+iclfCRIBv8cAuOgYVDGyUIO3OPIa+oYyJEBHCfCbuyCYa7fJL4jo1RdlaP2UHi+rhE6IeOjT57WLg4pMwQwnlNwzfLeAXqV1lRNTWUMRGBTkkpiUcAmEad7Lr9/SGr7xqKLCuefKhTcjjFilPxWdS2Qo1y2OaLOWznJxiJ18ZQ8Dd88XwniiYq5sUilryNnujIA6+20Y2PP/lfB8EYS3E6CkFS/Z2pXVz8XLbLb/LCeFSvTpYJkL96VedgpmZuREqlHSYu665GSMsS65sMP6ixPWkQhhm4jOlOkYcqA1utot4bMP2sX+Ciu4FRBU3dOwi7HmIWpk0KgmxXCFPIAGmqzYhBHpKb+tbNYnTDD6ZGS3HU1JBnnkNLVCuF2V+QJ9SqCx5dT29AA4vhKAY0MRSSa6zHfHqXYrhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR10MB6535.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199015)(36756003)(66476007)(66946007)(53546011)(186003)(6512007)(8676002)(4326008)(316002)(8936002)(41300700001)(478600001)(2616005)(86362001)(36916002)(6666004)(966005)(66556008)(6486002)(6506007)(6916009)(31696002)(26005)(83380400001)(2906002)(5660300002)(31686004)(30864003)(38100700002)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UHlzRHhNKzhlV1ZQUDF6UnUzVlBoR3p5Wkh6WnZNT1FOeDZGZUN6c2RCM004?=
 =?utf-8?B?MHBFcHNmRHBNLzI0eGYwclEwSlovMXkreXNDU01aMWdzNHlUZS9aSTBsQUtX?=
 =?utf-8?B?eXBEWlhpY0c0K2xjTkQyM3V0dXhFNGVuK2lFQm43SlpJamRHYWVpM0dlbERv?=
 =?utf-8?B?bE85ZVZ6aWxsR0N2UkxwalNKQ3A5Q2VWdUpaSW9RcS9wV042SUNNc2tXdE9k?=
 =?utf-8?B?QWVnV09XaU9neWNEaS9aMm9nSVo0elRjL2ZYZFlKN3Vycm9JWkU2WHN1R203?=
 =?utf-8?B?YjE2Zk00QjdYRS8wWlNURXR0OVZDbmVYNHBmR0Z4RytldGhmN01BVldkbXdy?=
 =?utf-8?B?SXRDa09BQ0RTTEZ3cjFkNDZmcDgrTVhFeHZZK05xWDRlMTU4Q2JEcGs5bjJ0?=
 =?utf-8?B?azFKNTdsVDFHOU5EeGxMT3RudHl5eUo4aUlnMUFiWjVVODFOZTd6YXpsbjNl?=
 =?utf-8?B?VzFZSkNIQTBXMkp2eWc2RUVveGU5MW1Kc1puSGpDNTVsZFVJc0kwY3JlVlB1?=
 =?utf-8?B?bUN1cmNsYnVxTlJJcjFzZXBuSDhmcExTNk96REpONENtZ3k2SzZNa0lyZlZN?=
 =?utf-8?B?RXBiTllOQ2dieXpnZ0pRNk1EK0RQL2MwYWMxcFZ6UGkvTFg3UnA2d0JzbFk5?=
 =?utf-8?B?aHFoVTdEdnMrdUFqTFFydXJXVjRMUFdmcUJPU3RuZUx0SE54dXREVUVDY0hr?=
 =?utf-8?B?ZU5LRlFCZi9Cdi9xOWk0Tks4RjUrWjAvQnBmVTZMYWppT0pNUjg1TFJhRGhW?=
 =?utf-8?B?R1VDd0ZESlVBb0FkTU44UFY0WHMrUCtWTEx3UEh4R3hkdDJDcnErMm0vSlZQ?=
 =?utf-8?B?azYxbGhkTklzZ3hmRmVUb0MvbzhJQk5oNkdLZCtneTZBRjRweGlDQnVuVVgz?=
 =?utf-8?B?SDVzdURUdnNXSnd4NmI4SFZhUXBqRHc1bTlpTTNaSVNLQ2tEdUNGc05rMEEz?=
 =?utf-8?B?S2RGY0JibW5PMTgrNmEyRDh3ekZOTkxtanQvY1NoTDJjVWU5RjJ4T2hVa24z?=
 =?utf-8?B?cEt2UHluUEprZnBJeFpPNkhiS1J3Q1QzcGx2L3FRcjVGR3RWOHMvbUFnWDhq?=
 =?utf-8?B?b1I1TlVYek42QU00bkR4dDk0NHV4djVwTXVvWWpQU3hlYTlOaGRMRHFGTWlz?=
 =?utf-8?B?aXd2dmpGSVRnVFBxdUpLVkZpYTZFUjZyc2VkcWFZWjVRSUhoL3oyU3dqT2tV?=
 =?utf-8?B?dVcwK2lwSUhhd2FMMzRiMUc3bHZBN055NU12Tk8wM0JwOHNJY3NuWlhKU2RK?=
 =?utf-8?B?WkVMQ1dCUVo5TitWaXQrRjNzT0UzT2RFUE90aExzNDdaeHdwV1lYMUV5RHhT?=
 =?utf-8?B?Z2F0NnE5WTRrR25Iem5ROGFYb0t5M2pTdm8vZkZzSlR5NEtXejBQSU5BeUZN?=
 =?utf-8?B?OGJ0TUZsbHVhSE5QZWRKRVp6ajFFR0xYNW9uRHNIVE5yUTFCK3VJNDhSRExm?=
 =?utf-8?B?Uy9WVlN1bnZoV2h4N0hVbTJDb1E5a0QwMG8veGE1c1RSNFV2RU13dkpBTHA0?=
 =?utf-8?B?Z2E1Q2lHZWRsUDBOdEd0enJMQlFvR3ZmS05FNjhxcFd0RkJhamdQU2lldUJm?=
 =?utf-8?B?ZXlkOWQ3ZXFTM094VTUydk5Jc3liVldZZXArbzlEMCtpQXZEVElEejFjOEFE?=
 =?utf-8?B?dFBFYTJNT3REei9PYzVOMWZUM2tSdDliRy9RVmN1eUIxd3d1ZVp5dWRhdHZy?=
 =?utf-8?B?K2R0dUtwNDF3WW1EejZ5a2djdTlhSGJuL0IvWjhtMmp1Z3BLWHFId3RTRDJE?=
 =?utf-8?B?Y1M0TEJBd2lLbUg4SVExMG5zME1hMXUvTVZJcmRWM3RmV04zSnJMSEpOc29V?=
 =?utf-8?B?bnZaaWpDekRZN1kvRktHREVuZWJtVFFKMnVHWThNNU5jbnZ6STlpNldlakJH?=
 =?utf-8?B?bHFOWWxnbmY2SnFPcUJYaDBVci9lU3o1VzE5aEU4RTdreXhHRytIb3ZpaFdr?=
 =?utf-8?B?UVQxa1FNN0ZEblp0ZDZicmxJVldiSUNOcmMvQ1NOSGgveG11Q0l0VDd0Rm13?=
 =?utf-8?B?NGNoZzJHU0hZcjBXMTA0Y1NkRkl2ZmdRek05Wno5WnNON2poYXBhbUdEZEky?=
 =?utf-8?B?dXJWamUwazRBelB6TEh2S2JaODhmM0EyVVlrVFNveUlUWGpQZ2dMNlFSMjlQ?=
 =?utf-8?Q?FX216dpgtqB31kfrz3lw4r05i?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?VTRHRGdad04vbzI5Y1VYN1BKSjFkNnlqcFhLUDJxLzBzMWRBeWVQYk1sUHhq?=
 =?utf-8?B?TGRnYzJTK0hKb2dyRXNCYVUzbERqcFNtd3pWMlRjbU9aVElZZCtvMmR0TGZO?=
 =?utf-8?B?SEQ4NVVSNFQxWmxEZmlmR2p0dUp6T1NmalhLbTExUXJvUDQrNnJncCtqQ1Zs?=
 =?utf-8?B?QWViV0d3akx1cXpyU0RLRWJkZXI3ejFJWllnd0piMjd5Q09rS29ZY2lDK3ZT?=
 =?utf-8?B?Z28zL3BJR01Wem9Ha3ozdlZmZlBYRDhiYlFaeGhqNVo4eDN4VEZzNzVUamlt?=
 =?utf-8?B?dWxDZlVENVh2T2hYK05CVHJJUFkzTEV1L2tZUmM3cktFZ1VKSFNYMlJYd3Bk?=
 =?utf-8?B?WFVvNlBZdFBlZHo2Q3lDTGtRMkc0eVBuWmNROUpTOFNFcE5XV1gyM01rZVhE?=
 =?utf-8?B?Zit5ZGpHeHgxWEV5MlJoTU1pRzluMThHY1EzcG5SeEF4WUk3U24yVXNPckVw?=
 =?utf-8?B?aFpoTzVZZWM2cFVvdzhJOTBnSkJDcnZ0a0FJSDVXaWQ5eWo2Uno3K3F5enVp?=
 =?utf-8?B?L2g1endpZVRHZHVmcEE5ZE85ZFBIVmwrakord3lSUE9zZk1hYm1peGpvZEFG?=
 =?utf-8?B?dnlrT3JpUHU2RVVRcXRVK1NYVmxUL3JZbDZKM2pUNTJzUngrVC9TOGdWaEVs?=
 =?utf-8?B?SW1iTUtubERZbGJKL1Vtay9vUTBjNWlKSWxyRmdKOVBuVnRmeDJIZkpwUGlE?=
 =?utf-8?B?NXhLOE9KclN5SnJ3aWdyMUJxeitMdnZqTlVCVDhHcGhYeFJTMzQ2TEVFbTli?=
 =?utf-8?B?SFdqUERYUnBaQm1VVmd5Y0M4NDdVd3hzY0hrcytIUmR6bER6ckZIM0VSYS9O?=
 =?utf-8?B?MnA3N3VEVHlOSy8vemw1V054UUxkSm9ZNldqZkVOSDNNNmF2T0UxNzBkbnJ3?=
 =?utf-8?B?SXFpWHZBK2VxaWR4bDdneGxYVjh2OWhVdGtZcE1URDl3cHR0MDlqTWF4YWFJ?=
 =?utf-8?B?a2w2UWg2UDhjdzBwdkszdGxMbFU0aTBTTURVTDFsZ2x1VFNranB0QTJ5dXp1?=
 =?utf-8?B?bUVyVlZjSzNtbFB2bXpHRm5UZGl6dnp2b0xab1hQWUN4Tkp0c1dubnpuV0p2?=
 =?utf-8?B?dFZWUmwxbVZpeHdDRTJ0VmZnWFhYTU8weEZPYi9DcjdOK0FqQU9ZRVNaS2tC?=
 =?utf-8?B?UGV2WUdYVTRIdHdpN25KK2EyWmp5eWlHZVJZcmdTUzlhNlFVcnUzaEhrOFMr?=
 =?utf-8?B?bjdPQS8wRU9DNGxpM3RoSEFENGJ3QUc4SnNpai9lRUUyeGhPN0ZLamFnTnNr?=
 =?utf-8?B?VGdZMUJpa2dBN0lTUTZrNGlyZVp2dUpDalVFQXpFY2hPN2R2TmwvcGhEUXNU?=
 =?utf-8?Q?DqMsSmCxE9svi2JcuW6s/ZAN0G6rRMR+m7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 902a18f2-e03f-4964-e037-08dad336682f
X-MS-Exchange-CrossTenant-AuthSource: MW4PR10MB6535.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 00:53:05.7884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c9OWokh+5qV6hAOBfZBL6VOjwcK3Gk+0GAkfN5oSqKP4L7I4s5D6GrjPWpI1zvLXUKUvD8ow4ps2YVps+phIpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5873
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-30_04,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010003
X-Proofpoint-GUID: zeHLZrLOSPY3bOYra56F57TXjESbqNWm
X-Proofpoint-ORIG-GUID: zeHLZrLOSPY3bOYra56F57TXjESbqNWm
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for getting back late due to the snag of the holidays.

On 11/23/2022 11:13 PM, Jason Wang wrote:
> On Thu, Nov 24, 2022 at 6:53 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>>
>>
>> On 11/22/2022 7:35 PM, Jason Wang wrote:
>>> On Wed, Nov 23, 2022 at 6:29 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>>>>
>>>> On 11/16/2022 7:33 PM, Jason Wang wrote:
>>>>> This patch allows device features to be provisioned via vdpa. This
>>>>> will be useful for preserving migration compatibility between source
>>>>> and destination:
>>>>>
>>>>> # vdpa dev add name dev1 mgmtdev pci/0000:02:00.0 device_features 0x300020000
>>>> Miss the actual "vdpa dev config show" command below
>>> Right, let me fix that.
>>>
>>>>> # dev1: mac 52:54:00:12:34:56 link up link_announce false mtu 65535
>>>>>          negotiated_features CTRL_VQ VERSION_1 ACCESS_PLATFORM
>>>>>
>>>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>>>>> ---
>>>>> Changes since v1:
>>>>> - Use uint64_t instead of __u64 for device_features
>>>>> - Fix typos and tweak the manpage
>>>>> - Add device_features to the help text
>>>>> ---
>>>>>     man/man8/vdpa-dev.8            | 15 +++++++++++++++
>>>>>     vdpa/include/uapi/linux/vdpa.h |  1 +
>>>>>     vdpa/vdpa.c                    | 32 +++++++++++++++++++++++++++++---
>>>>>     3 files changed, 45 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/man/man8/vdpa-dev.8 b/man/man8/vdpa-dev.8
>>>>> index 9faf3838..43e5bf48 100644
>>>>> --- a/man/man8/vdpa-dev.8
>>>>> +++ b/man/man8/vdpa-dev.8
>>>>> @@ -31,6 +31,7 @@ vdpa-dev \- vdpa device configuration
>>>>>     .I NAME
>>>>>     .B mgmtdev
>>>>>     .I MGMTDEV
>>>>> +.RI "[ device_features " DEVICE_FEATURES " ]"
>>>>>     .RI "[ mac " MACADDR " ]"
>>>>>     .RI "[ mtu " MTU " ]"
>>>>>     .RI "[ max_vqp " MAX_VQ_PAIRS " ]"
>>>>> @@ -74,6 +75,15 @@ Name of the new vdpa device to add.
>>>>>     Name of the management device to use for device addition.
>>>>>
>>>>>     .PP
>>>>> +.BI device_features " DEVICE_FEATURES"
>>>>> +Specifies the virtio device features bit-mask that is provisioned for the new vdpa device.
>>>>> +
>>>>> +The bits can be found under include/uapi/linux/virtio*h.
>>>>> +
>>>>> +see macros such as VIRTIO_F_ and VIRTIO_XXX(e.g NET)_F_ for specific bit values.
>>>>> +
>>>>> +This is optional.
>>>> Document the behavior when this attribute is missing? For e.g. inherit
>>>> device features from parent device.
>>> This is the current behaviour but unless we've found a way to mandate
>>> it, I'd like to not mention it. Maybe add a description to say the
>>> user needs to check the features after the add if features are not
>>> specified.
>> Well, I think at least for live migration the mgmt software should get
>> to some consistent result between all vdpa parent drivers regarding
>> feature inheritance.
> It would be hard. Especially for the device:
>
> 1) ask device_features from the device, in this case, new features
> could be advertised after e.g a firmware update
The consistency I meant is to always inherit all device features from 
the parent device for whatever it is capable of, since that was the only 
reasonable behavior pre-dated the device_features attribute, even though 
there's no mandatory check by the vdpa core. This way it's 
self-descriptive and consistent for the mgmt software to infer, as users 
can check into dev_features at the parent mgmtdev level to know what 
features will be ended up with after 'vdpa dev add'. I thought even 
though inheritance is not mandated as part of uAPI, it should at least 
be mentioned as a recommended guide line (for drivers in particular), 
especially this is the only reasonable behavior with nowhere to check 
what features are ended up after add (i.e. for now we can only set but 
not possible to read the exact device_features at vdpa dev level, as yet).
> 2) or have hierarchy architecture where several layers were placed
> between vDPA and the real hardware
Not sure what it means but I don't get why extra layers are needed. Do 
you mean extra layer to validate resulting features during add? Why vdpa 
core is not the right place to do that?

>
>> This inheritance predates the exposure of device
>> features, until which user can check into specific features after
>> creation. Imagine the case mgmt software of live migration needs to work
>> with older vdpa tool stack with no device_features exposure, how does it
>> know what device features are provisioned - it can only tell it from
>> dev_features shown at the parent mgmtdev level.
> The behavior is totally defined by the code, it would be not safe for
> the mgmt layer to depend on. Instead, the mgmt layer should use a
> recent vdpa tool with feature provisioning interface to guarantee the
> device_features if it wants since it has a clear semantic instead of
> an implicit kernel behaviour which doesn't belong to an uAPI.
That is going to be a slightly harsh requirement. If there's an existing 
vDPA setup already provisioned before the device_features work, there is 
no way for it to live migrate even if the QEMU userspace stack is made 
live migrate-able. It'd be the best to find some mild alternative before 
claiming certain setup unmigrate-able.

>
> If we can mandate the inheriting behaviour, users may be surprised at
> the features in the production environment which are very hard to
> debug.
I'm not against an explicit uAPI to define and guard device_features 
inheritance, but on the other hand, wouldn't it be necessary to show the 
actual device_features at vdpa dev level if it's not guaranteed to be 
the same with that of the parent mgmtdev? That is even needed before 
users are allowed to provision specific device_features IMO...

(that is the reason why I urged Michael to merge this patch soon before 
6.1 GA: 
https://lore.kernel.org/virtualization/1665422823-18364-1-git-send-email-si-wei.liu@oracle.com/, 
for which I have a pending iproute patch to expose device_features at 
'vdpa dev show' output).

>
>> IMHO it's not about whether vdpa core can or should mandate it in a
>> common place or not, it's that (the man page of) the CLI tool should set
>> user's expectation upfront for consumers (for e.g. mgmt software). I.e.
>> in case the parent driver doesn't follow the man page doc, it should be
>> considered as an implementation bug in the individual driver rather than
>> flexibility of its own.
> So for the inheriting, it might be too late to do that:
>
> 1) no facility to mandate the inheriting and even if we had we can't
> fix old kernels
We don't need to fix any old kernel as all drivers there had obeyed the 
inheriting rule since day 1. Or is there exception you did see? If so we 
should treat it as a bug to fix in driver.

> 2) no uAPI so there no entity to carry on the semantic
Not against of introducing an explicit uAPI, but what it may end up with 
is only some validation in a central place, right? Why not do it now 
before adding device features provisioning to userspace. Such that it's 
functionality complete and correct no matter if device_features is 
specified or not.

Thanks,
-Siwei

>
> And this is one of the goals that feature provisioning tries to solve
> so mgmt layer should use feature provisioning instead.
>
>>>> And what is the expected behavior when feature bit mask is off but the
>>>> corresponding config attr (for e.g. mac, mtu, and max_vqp) is set?
>>> It depends totally on the parent. And this "issue" is not introduced
>>> by this feature. Parents can decide to provision MQ by itself even if
>>> max_vqp is not specified.
>> Sorry, maybe I wasn't clear enough. The case I referred to was that the
>> parent is capable of certain feature (for e.g. _F_MQ), the associated
>> config attr (for e.g. max_vqp) is already present in the CLI, but the
>> device_features bit mask doesn't have the corresponding bit set (e.g.
>> the _F_MQ bit). Are you saying that the failure of this apparently
>> invalid/ambiguous/conflicting command can't be predicated and the
>> resulting behavior is totally ruled by the parent driver?
> Ok, I get you. My understanding is that the kernel should do the
> validation at least, it should not trust any configuration that is
> sent from the userspace. This is how it works before the device
> provisioning. I think we can add some validation in the kernel.
>
> Thanks
>
>> Thanks,
>> -Siwei
>>
>>>> I think the previous behavior without device_features is that any config
>>>> attr implies the presence of the specific corresponding feature (_F_MAC,
>>>> _F_MTU, and _F_MQ). Should device_features override the other config
>>>> attribute, or such combination is considered invalid thus should fail?
>>> It follows the current policy, e.g if the parent doesn't support
>>> _F_MQ, we can neither provision _F_MQ nor max_vqp.
>>>
>>> Thanks
>>>
>>>> Thanks,
>>>> -Siwei
>>>>
>>>>> +
>>>>>     .BI mac " MACADDR"
>>>>>     - specifies the mac address for the new vdpa device.
>>>>>     This is applicable only for the network type of vdpa device. This is optional.
>>>>> @@ -127,6 +137,11 @@ vdpa dev add name foo mgmtdev vdpa_sim_net
>>>>>     Add the vdpa device named foo on the management device vdpa_sim_net.
>>>>>     .RE
>>>>>     .PP
>>>>> +vdpa dev add name foo mgmtdev vdpa_sim_net device_features 0x300020000
>>>>> +.RS 4
>>>>> +Add the vdpa device named foo on the management device vdpa_sim_net with device_features of 0x300020000
>>>>> +.RE
>>>>> +.PP
>>>>>     vdpa dev add name foo mgmtdev vdpa_sim_net mac 00:11:22:33:44:55
>>>>>     .RS 4
>>>>>     Add the vdpa device named foo on the management device vdpa_sim_net with mac address of 00:11:22:33:44:55.
>>>>> diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
>>>>> index 94e4dad1..7c961991 100644
>>>>> --- a/vdpa/include/uapi/linux/vdpa.h
>>>>> +++ b/vdpa/include/uapi/linux/vdpa.h
>>>>> @@ -51,6 +51,7 @@ enum vdpa_attr {
>>>>>         VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
>>>>>         VDPA_ATTR_DEV_VENDOR_ATTR_NAME,         /* string */
>>>>>         VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,        /* u64 */
>>>>> +     VDPA_ATTR_DEV_FEATURES,                 /* u64 */
>>>>>
>>>>>         /* new attributes must be added above here */
>>>>>         VDPA_ATTR_MAX,
>>>>> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
>>>>> index b73e40b4..d0ce5e22 100644
>>>>> --- a/vdpa/vdpa.c
>>>>> +++ b/vdpa/vdpa.c
>>>>> @@ -27,6 +27,7 @@
>>>>>     #define VDPA_OPT_VDEV_MTU           BIT(5)
>>>>>     #define VDPA_OPT_MAX_VQP            BIT(6)
>>>>>     #define VDPA_OPT_QUEUE_INDEX                BIT(7)
>>>>> +#define VDPA_OPT_VDEV_FEATURES               BIT(8)
>>>>>
>>>>>     struct vdpa_opts {
>>>>>         uint64_t present; /* flags of present items */
>>>>> @@ -38,6 +39,7 @@ struct vdpa_opts {
>>>>>         uint16_t mtu;
>>>>>         uint16_t max_vqp;
>>>>>         uint32_t queue_idx;
>>>>> +     uint64_t device_features;
>>>>>     };
>>>>>
>>>>>     struct vdpa {
>>>>> @@ -187,6 +189,17 @@ static int vdpa_argv_u32(struct vdpa *vdpa, int argc, char **argv,
>>>>>         return get_u32(result, *argv, 10);
>>>>>     }
>>>>>
>>>>> +static int vdpa_argv_u64_hex(struct vdpa *vdpa, int argc, char **argv,
>>>>> +                          uint64_t *result)
>>>>> +{
>>>>> +     if (argc <= 0 || !*argv) {
>>>>> +             fprintf(stderr, "number expected\n");
>>>>> +             return -EINVAL;
>>>>> +     }
>>>>> +
>>>>> +     return get_u64(result, *argv, 16);
>>>>> +}
>>>>> +
>>>>>     struct vdpa_args_metadata {
>>>>>         uint64_t o_flag;
>>>>>         const char *err_msg;
>>>>> @@ -244,6 +257,10 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
>>>>>                 mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, opts->max_vqp);
>>>>>         if (opts->present & VDPA_OPT_QUEUE_INDEX)
>>>>>                 mnl_attr_put_u32(nlh, VDPA_ATTR_DEV_QUEUE_INDEX, opts->queue_idx);
>>>>> +     if (opts->present & VDPA_OPT_VDEV_FEATURES) {
>>>>> +             mnl_attr_put_u64(nlh, VDPA_ATTR_DEV_FEATURES,
>>>>> +                             opts->device_features);
>>>>> +     }
>>>>>     }
>>>>>
>>>>>     static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
>>>>> @@ -329,6 +346,14 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
>>>>>
>>>>>                         NEXT_ARG_FWD();
>>>>>                         o_found |= VDPA_OPT_QUEUE_INDEX;
>>>>> +             } else if (!strcmp(*argv, "device_features") &&
>>>>> +                        (o_optional & VDPA_OPT_VDEV_FEATURES)) {
>>>>> +                     NEXT_ARG_FWD();
>>>>> +                     err = vdpa_argv_u64_hex(vdpa, argc, argv,
>>>>> +                                             &opts->device_features);
>>>>> +                     if (err)
>>>>> +                             return err;
>>>>> +                     o_found |= VDPA_OPT_VDEV_FEATURES;
>>>>>                 } else {
>>>>>                         fprintf(stderr, "Unknown option \"%s\"\n", *argv);
>>>>>                         return -EINVAL;
>>>>> @@ -615,8 +640,9 @@ static int cmd_mgmtdev(struct vdpa *vdpa, int argc, char **argv)
>>>>>     static void cmd_dev_help(void)
>>>>>     {
>>>>>         fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
>>>>> -     fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ]\n");
>>>>> -     fprintf(stderr, "                                                    [ max_vqp MAX_VQ_PAIRS ]\n");
>>>>> +     fprintf(stderr, "       vdpa dev add name NAME mgmtdevMANAGEMENTDEV [ device_features DEVICE_FEATURES]\n");
>>>>> +     fprintf(stderr, "                                                   [ mac MACADDR ] [ mtu MTU ]\n");
>>>>> +     fprintf(stderr, "                                                   [ max_vqp MAX_VQ_PAIRS ]\n");
>>>>>         fprintf(stderr, "       vdpa dev del DEV\n");
>>>>>         fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
>>>>>         fprintf(stderr, "Usage: vdpa dev vstats COMMAND\n");
>>>>> @@ -708,7 +734,7 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc, char **argv)
>>>>>         err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
>>>>>                                   VDPA_OPT_VDEV_MGMTDEV_HANDLE | VDPA_OPT_VDEV_NAME,
>>>>>                                   VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU |
>>>>> -                               VDPA_OPT_MAX_VQP);
>>>>> +                               VDPA_OPT_MAX_VQP | VDPA_OPT_VDEV_FEATURES);
>>>>>         if (err)
>>>>>                 return err;
>>>>>

