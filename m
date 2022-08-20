Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2717F59ACC5
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 11:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343768AbiHTI4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 04:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244085AbiHTI4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 04:56:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59672659EB;
        Sat, 20 Aug 2022 01:56:02 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27K7iafJ014010;
        Sat, 20 Aug 2022 08:55:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=yXSdLwQ8e93IJRZgUMR3j0/w1eZBFfA6OUC5pF9V/wo=;
 b=HGFK7fr3QmoHPRuQrRs1OwAT7Y8/ffKsmnWlTH+Hr8xl1+7nCztNAGWTZ46qiA3Scw4p
 dv4JPgtu9zQ8ryhU6SVINSR4jsubJzJaTRjAiREsVLUSHTS25EO02VYtUzGJ3WDPGH14
 68Cg3ZCgjHoyEaJshZ7Jq2WbBAuPlU7OTjNTs76/yvkWN0z/w7jdDlf0nP4KlQKmN2J0
 vHia6CSWQgV7h9k0kcEMmK8JY6BpKTVzYoKCgXYgc3vXqsSgNSNiSwfPRr3Qnc4iq/j2
 hEDKGB1dQ58qFASPYiDIYP96fQJv0TfvSi4PWslKuHmfP2K+YzSrHVBj7PZ6dVYfom4R Cg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j2ug2g4g8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 Aug 2022 08:55:45 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27K8c2rh016810;
        Sat, 20 Aug 2022 08:55:44 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3j2p26dgn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 Aug 2022 08:55:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YasqVDbP1iTxUdcmY8O8CPaHru5BH3CxW3I0Ex+w4+5eY9w8fk8zkGKbsIAFhORiGo/J4f48VnWLptQyczUXWJCibcoZjzWWpqfVa82zGu83Ua7yDrnpy7XyLDloLx8fzGcly0Nw3aSrhAIwPEAPtaKBM5qCNmHppPhQ+IDcJW8UQpiphYXHb7KhaUv2MAvVrcXiNl0remaRwB58mU6n4BHkpL+BPs8zd84N9ou4kbC982IhoCmpqjTj0I6Opf7PzMcx7FKCarSyCaoN1HOyPiPR16U7nSubX5kuUiLvchWLgvSRdHlr9h+5KLkmlqBmWKcPfGT6KjuPuVxVOIjZXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yXSdLwQ8e93IJRZgUMR3j0/w1eZBFfA6OUC5pF9V/wo=;
 b=EGBa3sdNM9efFrrcfir2OvYI7+EZRYQHKj1ICHLshAHS4tAgihrOUuekwyWxrLy1sltvUSY7uxREHm9p/T4V9+B3KS77bctmlV6QXbR94NWl5W/vgDuJu6EbCsWr3VBfKzY5Vt3vji4U/VAScGA1g1zjxOLNlxQl83Bkv6UVB/xJHGs2SnYd1beGkQhHOicZuxJkudzsVKC9Ci20Xu377Fdsh8WI7guMJWD9om2etVqK4/QG4KG5SsHrUI3/KevkCOqa+FXvV47Vxdz56g/ytyJJkLJT+nszSw7RoWcUwHIHcUAvVOBWkeXnx8c16Qed1pgp5GFuwl3T/eqziepblQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yXSdLwQ8e93IJRZgUMR3j0/w1eZBFfA6OUC5pF9V/wo=;
 b=hDmPn9W/M+Hidc+NdqRpBXGZJ/umjSd1BBArvqiNJ3x/cMBaT8yZCMvwpyLgG5gubcye3oTUB1CweWpISZbhFxPvcmJNekwdUYZAjW1UVlZwIjzOWmDljTdfbzAXqPRAvfUGumXS961c1pZGPpFYVm7aDHtWiZtlO6bfqCvykck=
Received: from BN8PR10MB3283.namprd10.prod.outlook.com (2603:10b6:408:d1::28)
 by DM5PR10MB1274.namprd10.prod.outlook.com (2603:10b6:4:b::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5525.11; Sat, 20 Aug 2022 08:55:40 +0000
Received: from BN8PR10MB3283.namprd10.prod.outlook.com
 ([fe80::88d3:9d3:f63b:f644]) by BN8PR10MB3283.namprd10.prod.outlook.com
 ([fe80::88d3:9d3:f63b:f644%7]) with mapi id 15.20.5546.019; Sat, 20 Aug 2022
 08:55:40 +0000
Message-ID: <4678fc51-a402-d3ea-e875-6eba175933ba@oracle.com>
Date:   Sat, 20 Aug 2022 01:55:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        Yongji Xie <xieyongji@bytedance.com>,
        "Dawar, Gautam" <gautam.dawar@amd.com>
References: <c5075d3d-9d2c-2716-1cbf-cede49e2d66f@oracle.com>
 <20e92551-a639-ec13-3d9c-13bb215422e1@intel.com>
 <9b6292f3-9bd5-ecd8-5e42-cd5d12f036e7@oracle.com>
 <22e0236f-b556-c6a8-0043-b39b02928fd6@intel.com>
 <892b39d6-85f8-bff5-030d-e21288975572@oracle.com>
 <52a47bc7-bf26-b8f9-257f-7dc5cea66d23@intel.com>
 <20220817045406-mutt-send-email-mst@kernel.org>
 <a91fa479-d1cc-a2d6-0821-93386069a2c1@intel.com>
 <20220817053821-mutt-send-email-mst@kernel.org>
 <449c2fb2-3920-7bf9-8c5c-a68456dfea76@intel.com>
 <20220817063450-mutt-send-email-mst@kernel.org>
 <54aa5a5c-69e2-d372-3e0c-b87f595d213c@redhat.com>
 <f0b6ea5c-1783-96d2-2d9f-e5cf726b0fc0@oracle.com>
 <CACGkMEumKfktMUJOTUYL_JYkFbw8qH331gGARPB2bTH=7wKWPg@mail.gmail.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CACGkMEumKfktMUJOTUYL_JYkFbw8qH331gGARPB2bTH=7wKWPg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0039.namprd11.prod.outlook.com
 (2603:10b6:806:d0::14) To BN8PR10MB3283.namprd10.prod.outlook.com
 (2603:10b6:408:d1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2ddf563-2a18-4b35-9d0c-08da8289c1f8
X-MS-TrafficTypeDiagnostic: DM5PR10MB1274:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F0sNGhwiJ5To7IWfrVvuKVaHaLlyhvLyeoNZq3zW/p/br6G//LoQL8wlPFAik/HHJDuAJzPVKXqHxtyuukYmh0EBJd4pVQtQZDIjsqp8NKaVzppdnIzng23w3i+/30unKJpfEBCvMU4qh8g80sTdd6dlZryRGCqv3HpqKqxFDu5ER31970C1r+Q9MQYVvrHAI2WCIDk88ktZUZAohy2hkRNkAgYL+k+mW9dEa/iViOhcB1r1bqxjydnsOIgVd3G+sBgGzpJt2I7kGcXttbPsnO/OYnM3dmJH9TbqoPDBqs/hfPmF3sQM/cBoKKNi01q9okbwaOcQpmbK3cewB3At0OrLfttCGA2HX1yqkk/C541qqqnmL5+nFrBT9uz08dCIoqaLMbfJ+fq1CXbv8lf7hOPeRV073kS74XcnWo2QAR3Ip5iFJ15cvIti2SltVO6gvNP2WG/DmqBhq2N77k4NS0EZDoHUrEDZ/ZQZbSJ2PW2+p9kNYr8GybtntoYTmhAQBPQAUWYeXQgU1BQuOFzO5P6AiFKrDwzTUpHl4ouRXI+Mi0Xx9ngRAF57BBQVVUcm0W5RElOxtr9U8I4/a1ZooBVjTov110EeRVB/3UPvF9xsaEcvPikuSWZ6H87brQUBb6Ms5aLt+iy52ut13+FJn/QWK7ZQFrcrtlSmoo9mP3n4QshembpAZBRNgodrqmCZphaldgiUmLqG39odz+mBr6lHweTreb/uFQaFBQ6AxhGBcs9CYftAxBwJwZz7JE8uXPl495C5PasEFc+BvGLrkniMeOTlrwVCjYZBegG121Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3283.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(39860400002)(346002)(396003)(136003)(36916002)(6506007)(6666004)(53546011)(86362001)(6486002)(41300700001)(54906003)(478600001)(6916009)(316002)(31696002)(2616005)(186003)(38100700002)(6512007)(26005)(83380400001)(36756003)(4326008)(66946007)(66476007)(8676002)(5660300002)(31686004)(8936002)(66556008)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MS9neG4yVnZPU3ZqYW53dTM3Sy9RS0k2MkpsU05TSDFRdzZJRmRzZWdtdkJO?=
 =?utf-8?B?S0dyZ2Jyc0QvMU1JWW5QRStONk50QTJZZTl3cXhJZUtVZVN3MWJxcy9Zd2tp?=
 =?utf-8?B?aFNsNk01VTBrWkVUVkdpdzczM291MUVUMHdDZVdySkx1WW4vQm4vUXJrVjVh?=
 =?utf-8?B?WjJtOFFhK05ZRVZJajhnOXB0ZGRLdmptVUs5amwrcS9UOGVTTjFLSWVHcHdL?=
 =?utf-8?B?K1hxQ0tsYjJVKzJVckpzODVWbGplWmZ0SHppWGM4WXM3bTVxWEorTEJNeFVr?=
 =?utf-8?B?cDViOE1TTW5Ua1hZWGk1QTZRc1FQQ3BBcG5UUmd5Z2Nld0lIRHN5OVBnMzU3?=
 =?utf-8?B?TnNtZW5Bb1RNZ1JSaFJEZ0lKTGJHYkFsZ1FiZWxBYzRTVjFsREVXTmxhbldU?=
 =?utf-8?B?N1B5NUg3dTE3eXNDTFJrWFNleVk0WDIyYkRtOHpDMDV5VDhMamhRdEdlNzlw?=
 =?utf-8?B?L1VzZUdVK0dYamIzZkZBZHErWUJNdGM4V1FiMEI5WVVsemxjeTR5cDFPYzVZ?=
 =?utf-8?B?dURoLzhjRGtmejRRNE93VkVSSFZFY2YxcFd6TXZBN0FnbWNDSWhzRDNncGph?=
 =?utf-8?B?aHZFT2JLMmVpRkJjVjVHTkNPV2hqZWN3aUtuKzZzMC90MkU4Z0xmcHA5Rm5W?=
 =?utf-8?B?d2M1dVBBWC9EejNSRzkyaWc2QzhHaUl0RUNtL1Rib2hSUzlDb253MzlDL3dF?=
 =?utf-8?B?V2hrRXNoVUJhdVVvdEwrUkJHZHV0WkZ4N1huOEptbXM4UWU0NWdyaUV6ZkVG?=
 =?utf-8?B?d2lFWFRMSTk5RFNaUEJieU1JS1RaSlFnbE8yczd3SUY4cS9rRW9KUUllcUVp?=
 =?utf-8?B?a3BreVFyaitLMVVOai83YkI2cTlKUTdvdWJqbnhMNGIwMStCcXJWS1YyS0dK?=
 =?utf-8?B?YThwY3M1NUhVNXo2M09LNUFJbnA1OUtsVkw0THg3UVJuaGg1b1c0OTVhOGd2?=
 =?utf-8?B?K1pxSUJqK1R3UTBqYUpvazQvbFF5a2JJZWlRMGF5blBnaWk0Z2lPenVFWlhl?=
 =?utf-8?B?UWZGM3ZoalBrZkcyT1pQSzVMMmtKZTBoWHlNTU1CTFRtTTJqa3R6N1BGR3pr?=
 =?utf-8?B?RTRWQyt2NXczU1lZL0k3OWd3VldIWjN1NzU3NUNsUnFwZEV2aFlxeTJBN1RV?=
 =?utf-8?B?ZmJGLzFuRU8vSjF0Q2ExOGxzbkVQMUNKUDR0WUh0QmZIYk8wRzJ4VWlsMDdD?=
 =?utf-8?B?eHZSbXg4bHJKYWFFbjhtMSs2TDZsb3JCcmhwRHAwZ0QvNVVRM3A3d0pLTlZG?=
 =?utf-8?B?b2JtK3JiYzZtTEU1amsyMjhtQmlHS3k4c3lDZTBqSWlleWhDVVV4R05qNFJI?=
 =?utf-8?B?SEdiVnhsVzZ2M2ZPbjNEVUF0Sk10bDJLYnUxNFd2YWlMN1Q3dlRPNDlCa2g0?=
 =?utf-8?B?TktIelpzRGJidDM5bmtzVWFSOVB1RzUrcS9KT1RzWUJpcHlucXM2WU55LzNU?=
 =?utf-8?B?SDgyb09KQWNkVVVOV2dCQ1NqamwrV2l2RGZNckM0NXg3amdWcUtlYXNobkFz?=
 =?utf-8?B?ejZpOVNrQTgzVnZFQUlVY2ZndDVPMnBQL2drSDdzRzFYU1F4amd6SSt4SUhi?=
 =?utf-8?B?VnhUN1NXdnJMNDBpS3JrQjZiNUc0T1VKSGtSdlFpYjZvL1pEVGxLSXN0dnYr?=
 =?utf-8?B?aG5aTm9aZ1RDc2gzM2l5WDVqR1hqZ3IyZ0FXSFhmV2FxY2xtUkY0YUQ2WmZa?=
 =?utf-8?B?WGJsVzBzK0l0K0lmNDVJaDkrVnUrZGpxTVkvWlRxcVdLNGhpZjNNa0JFY3pY?=
 =?utf-8?B?djVISzFCMFBoYUlDUmQ4alhUaVUzK0gyWDFPM1oyZzNHQXNYeWpBYzJ4QW10?=
 =?utf-8?B?WnFjSUdVM0UzTDE2WXZUTExNOEN4ZWgra1lLS2RCWGJJajhtUE80N2s2bVNZ?=
 =?utf-8?B?TEVFQnBtV0E3VjlndW9DTFNLcnBqcFFPZ2oyWHoybXVMZS9veXNHaEtPWU1s?=
 =?utf-8?B?Y3lQS3FYNkw3azhBQ2JZQ29QSUh2N292QkJrUlBjWjh3NDB4NjE3NUZZNEdw?=
 =?utf-8?B?dVN2Ty9HVkhDdTJ6VCt3SFFXRkROcG5rUVJoUFNjb1c1NmZIQTRHQVNjTjJW?=
 =?utf-8?B?NkYyUEk4Ni9pRXc2VGViOVZFL0QrTjlIbDg1YUxJVU00b0xpcVNuNWxwUlJu?=
 =?utf-8?Q?kbLKwk5rHtFphuCbYUjpr1YTv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2ddf563-2a18-4b35-9d0c-08da8289c1f8
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3283.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2022 08:55:40.5428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SF/eL8QvC3mbV8o2oQLAYFcghVcRCkXB7xdC4wPwQ98AtK3+FLmoQvOCJwpW0BoZyA8kJvMRPBESw9KUhgmCug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1274
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-20_05,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208200035
X-Proofpoint-GUID: _3aaAMzj04opqg7d_7e2QhaMYwri-tUV
X-Proofpoint-ORIG-GUID: _3aaAMzj04opqg7d_7e2QhaMYwri-tUV
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/2022 5:42 PM, Jason Wang wrote:
> On Fri, Aug 19, 2022 at 7:20 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>>
>>
>> On 8/17/2022 9:15 PM, Jason Wang wrote:
>>> 在 2022/8/17 18:37, Michael S. Tsirkin 写道:
>>>> On Wed, Aug 17, 2022 at 05:43:22PM +0800, Zhu, Lingshan wrote:
>>>>> On 8/17/2022 5:39 PM, Michael S. Tsirkin wrote:
>>>>>> On Wed, Aug 17, 2022 at 05:13:59PM +0800, Zhu, Lingshan wrote:
>>>>>>> On 8/17/2022 4:55 PM, Michael S. Tsirkin wrote:
>>>>>>>> On Wed, Aug 17, 2022 at 10:14:26AM +0800, Zhu, Lingshan wrote:
>>>>>>>>> Yes it is a little messy, and we can not check _F_VERSION_1
>>>>>>>>> because of
>>>>>>>>> transitional devices, so maybe this is the best we can do for now
>>>>>>>> I think vhost generally needs an API to declare config space
>>>>>>>> endian-ness
>>>>>>>> to kernel. vdpa can reuse that too then.
>>>>>>> Yes, I remember you have mentioned some IOCTL to set the endian-ness,
>>>>>>> for vDPA, I think only the vendor driver knows the endian,
>>>>>>> so we may need a new function vdpa_ops->get_endian().
>>>>>>> In the last thread, we say maybe it's better to add a comment for
>>>>>>> now.
>>>>>>> But if you think we should add a vdpa_ops->get_endian(), I can work
>>>>>>> on it for sure!
>>>>>>>
>>>>>>> Thanks
>>>>>>> Zhu Lingshan
>>>>>> I think QEMU has to set endian-ness. No one else knows.
>>>>> Yes, for SW based vhost it is true. But for HW vDPA, only
>>>>> the device & driver knows the endian, I think we can not
>>>>> "set" a hardware's endian.
>>>> QEMU knows the guest endian-ness and it knows that
>>>> device is accessed through the legacy interface.
>>>> It can accordingly send endian-ness to the kernel and
>>>> kernel can propagate it to the driver.
>>>
>>> I wonder if we can simply force LE and then Qemu can do the endian
>>> conversion?
>> convert from LE for config space fields only, or QEMU has to forcefully
>> mediate and covert endianness for all device memory access including
>> even the datapath (fields in descriptor and avail/used rings)?
> Former. Actually, I want to force modern devices for vDPA when
> developing the vDPA framework. But then we see requirements for
> transitional or even legacy (e.g the Ali ENI parent). So it
> complicates things a lot.
>
> I think several ideas has been proposed:
>
> 1) Your proposal of having a vDPA specific way for
> modern/transitional/legacy awareness. This seems very clean since each
> transport should have the ability to do that but it still requires
> some kind of mediation for the case e.g running BE legacy guest on LE
> host.
In theory it seems like so, though practically I wonder if we can just 
forbid BE legacy driver from running on modern LE host. For those who 
care about legacy BE guest, they mostly like could and should talk to 
vendor to get native BE support to achieve hardware acceleration, few of 
them would count on QEMU in mediating or emulating the datapath 
(otherwise I don't see the benefit of adopting vDPA?). I still feel that 
not every hardware vendor has to offer backward compatibility 
(transitional device) with legacy interface/behavior (BE being just 
one), this is unlike the situation on software virtio device, which has 
legacy support since day one. I think we ever discussed it before: for 
those vDPA vendors who don't offer legacy guest support, maybe we should 
mandate some feature for e.g. VERSION_1, as these devices really don't 
offer functionality of the opposite side (!VERSION_1) during negotiation.

Having it said, perhaps we should also allow vendor device to implement 
only partial support for legacy. We can define "reversed" backend 
feature to denote some part of the legacy interface/functionality not 
getting implemented by device. For instance, 
VHOST_BACKEND_F_NO_BE_VRING, VHOST_BACKEND_F_NO_BE_CONFIG, 
VHOST_BACKEND_F_NO_ALIGNED_VRING, VHOST_BACKEND_NET_F_NO_WRITEABLE_MAC, 
and et al. Not all of these missing features for legacy would be easy 
for QEMU to make up for, so QEMU can selectively emulate those at its 
best when necessary and applicable. In other word, this design shouldn't 
prevent QEMU from making up for vendor device's partial legacy support.

>
> 2) Michael suggests using VHOST_SET_VRING_ENDIAN where it means we
> need a new config ops for vDPA bus, but it doesn't solve the issue for
> config space (at least from its name). We probably need a new ioctl
> for both vring and config space.
Yep adding a new ioctl makes things better, but I think the key is not 
the new ioctl. It's whether or not we should enforce every vDPA vendor 
driver to implement all transitional interfaces to be spec compliant. If 
we allow them to reject the VHOST_SET_VRING_ENDIAN  or 
VHOST_SET_CONFIG_ENDIAN call, what could we do? We would still end up 
with same situation of either fail the guest, or trying to 
mediate/emulate, right?

Not to mention VHOST_SET_VRING_ENDIAN is rarely supported by vhost today 
- few distro kernel has CONFIG_VHOST_CROSS_ENDIAN_LEGACY enabled and 
QEMU just ignores the result. vhost doesn't necessarily depend on it to 
determine endianness it looks.
>
> or
>
> 3) revisit the idea of forcing modern only device which may simplify
> things a lot
I am not actually against forcing modern only config space, given that 
it's not hard for either QEMU or individual driver to mediate or 
emulate, and for the most part it's not conflict with the goal of 
offload or acceleration with vDPA. But forcing LE ring layout IMO would 
just kill off the potential of a very good use case. Currently for our 
use case the priority for supporting 0.9.5 guest with vDPA is slightly 
lower compared to live migration, but it is still in our TODO list.

Thanks,
-Siwei

>
> which way should we go?
>
>> I hope
>> it's not the latter, otherwise it loses the point to use vDPA for
>> datapath acceleration.
>>
>> Even if its the former, it's a little weird for vendor device to
>> implement a LE config space with BE ring layout, although still possible...
> Right.
>
> Thanks
>
>> -Siwei
>>> Thanks
>>>
>>>
>>>>> So if you think we should add a vdpa_ops->get_endian(),
>>>>> I will drop these comments in the next version of
>>>>> series, and work on a new patch for get_endian().
>>>>>
>>>>> Thanks,
>>>>> Zhu Lingshan
>>>> Guests don't get endian-ness from devices so this seems pointless.
>>>>

