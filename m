Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49132594EE4
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 04:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbiHPC6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 22:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233398AbiHPC6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 22:58:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0066347;
        Mon, 15 Aug 2022 16:32:18 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27FNR9aQ031996;
        Mon, 15 Aug 2022 23:32:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=LPFkfikKwmmFSNJZ128GbONY7OJfOV+wEbcIpRp+HV8=;
 b=CsJpQHqqIzZ4vC7O72U4o/YenEUZqhTYbPhuH9Mgd3XHuyKCBClEWXnjLfPILh6IdX7S
 UiZtx7L/XcZlpY0mkHtz0Yta2UvK6Z597lXCjw9JJMJjaGmfX+2f84qfG0m1wTgfJcJp
 u5yaFyg+SNCWePHKCAY/BwtzlguEdSOj2rUppf4XeDJZgx39AKs9RioEtIwIG9syYI79
 DGbHyETdQSyvMufViG9eRCQt4LhfcO8Rrgz/b/6H/pM6qNFH/BIW7/NqStytYZ9iHLI9
 9UKutMoe5hqGJMtDfA40EdPjPYTNXpbvD/F4pFgNvvn1vAL2RaoS2wA+LZq0gpn4OWrP Dg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hx3ua48uy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Aug 2022 23:32:08 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27FL52tv023141;
        Mon, 15 Aug 2022 23:32:08 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hx2d1v466-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Aug 2022 23:32:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IRaotehQ1AKKyAhYbpRuUXinih773WkVQEJZJVINoaNLmwl3+PWHqQI32hCq0qWIEEGqrErjUpuQ/N0jWWsSdg7iUagCAGyhG5M5TXIjUgYrE9dOWRrDOzvY5NK538vHEtaIch9Hjrv1I6by0j2DgadIYjgrtUTto8FfLuzZYjgFqXRVeVu5CXK9sbPLSUQE4OV8hN+gpVEMfLLNXw+/e/87iZK2O5SE5uGoNXaB6pMuSaNkDrpO2keZa0+FxeoFoIjQE2pFfrtMOlPN12gz5MBkLF99Tt7Qi9TfCymLlZOmKAzZJUes9aEYLwSHisgC+E0n1vHUMKTBYdNFo+BJyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LPFkfikKwmmFSNJZ128GbONY7OJfOV+wEbcIpRp+HV8=;
 b=eb26ucW1SYaSw5SpOnb4Vc0WAmgH6jeQlnsX4A6gLJm5nmSubGVedr9MrsGPy7sUosp2mqqok/rJO3SyyxXaA89eBanlBhH/jj++VhbminVFAmt0sPgiW+ZltqCSy6jL76fljo9Ed5myNdoiZLL+0slj/aVwP39s+AgSsvMCsxPvTvSTLPfd5Dy+9rQ3uaW+EYE33K2BtjYeH3x4o7wsnAYejzPgiIL5HMGzTqEpvMAX2swcLpP9d/JOEjlpvfNaWIwsUGiYdmTpTaqLeKEY4nANTTYBQqzhY7zeqEabk3BbVvPnUAOdv3MWdUhmZnOj+f5g34xUqoEu7e4dW26d3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LPFkfikKwmmFSNJZ128GbONY7OJfOV+wEbcIpRp+HV8=;
 b=lT/sdYVWGjLesBytEyBQ5WCJbz6AtOlFOjnhPfRVp2f5jvb3XLDb/pfKrIhWQnosXzP93qDLgppx80DJ6PGuE0Wi+OqG1NC9lsAJKFC/9ZHaOQx0CqqQcA5TPbRK4VoNRhynkPgGe0zhaORk/6ccX120tvn+4dFSGMfpigTNhD4=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by DM6PR10MB3755.namprd10.prod.outlook.com (2603:10b6:5:1d1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Mon, 15 Aug
 2022 23:32:05 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649%7]) with mapi id 15.20.5525.010; Mon, 15 Aug 2022
 23:32:05 +0000
Message-ID: <c5075d3d-9d2c-2716-1cbf-cede49e2d66f@oracle.com>
Date:   Mon, 15 Aug 2022 16:32:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Content-Language: en-US
To:     Zhu Lingshan <lingshan.zhu@intel.com>, jasowang@redhat.com,
        mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com
References: <20220815092638.504528-1-lingshan.zhu@intel.com>
 <20220815092638.504528-3-lingshan.zhu@intel.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20220815092638.504528-3-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR04CA0078.namprd04.prod.outlook.com
 (2603:10b6:805:f2::19) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f086930-f7ae-4f90-44af-08da7f165cd9
X-MS-TrafficTypeDiagnostic: DM6PR10MB3755:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QrIdBMxa/oU0IF2W7/njj20aMGR78pXCN5ZcUuflW6/mqPs4aow1FA5BuegVBWxauM9hYxOAx/KTybdvZtg+41Zbv+bPVMde4wYAPA6G6bkqMNTZpB0AIRZA2ePc/Hwo+pgZ3wymWaVpwRA0hf0kiRsnoF9JUhHyHL6rywMw246mE5Y7fXnUK8fBwppPrr2ONc8UvDvyM9qqlBg/PL5Rvdc38OeF6cSX4kaam7sarA906qcX28k1m9V60hSPpJYE+Hwn9Bqld4ab8DIf9FKuS81de11K7vmQUmsRPcDJsWOCsZrWdcAWXDwWUHeiLpU3fVjpInF+vF4nrrEcodwb6DmGe02tSqsYfH1RC7mJCxjk268FP+FM6/d+OoJIIF5xH4RR88ZDthDouRa+9par0c3v0qWjwM+kqai35NOHYP11akkwEWGj9z6TSBP6j3acil4KzG/x7xeBuvlgrsJDhcpn4em2clU1Xs0CAlZ0d+lPEmuLXpAhhttCaFBC+FGcPubJLiYcM0JSvH997N+F12KfZtwBerynm77hVuFICwKyLdjOJJ78DUmlApallS3dqzJbVo3YGIC7IWr7Bpb0cgIUlKc8ScehH7ayuZzXGcs8H63x0Qz1to2CmQv6Wcza4YvyE+95Md5K/hdatpFlwBmetetddjmkyUIuVRf4t2HV0wQlbjlCYTHf5ROefpdUx2Wsr3eVWo3Hp1Y0exPZF9JiPBRP9tRHmJ9MEo23AEklHTrOmvsaC4Bqyq59rewMAXdl7YPayqzx0t7PzoIViYFcXWmggilkZbgkLR62nySpiNizNWdl8ymYsOUFWI6gyl5F7CXD0r294MIfTvOH37qzlLuXIx4MtQIMU8o6wek=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(136003)(366004)(346002)(396003)(83380400001)(31696002)(38100700002)(66476007)(66946007)(8676002)(66556008)(86362001)(316002)(8936002)(2906002)(5660300002)(53546011)(26005)(36916002)(6506007)(6512007)(2616005)(186003)(4326008)(6666004)(6486002)(478600001)(41300700001)(31686004)(36756003)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUYwT1FkQkIxeE5RVVBpb29XelhTQ0VkbENOUkdCeGhaOHJJamlUaFllbGJz?=
 =?utf-8?B?ZjNTZEIxWFoyNit0K3FnZXRHNnJSK1FXOG9IZ2E1WnYrMVNYeXZvcGh0Uk1C?=
 =?utf-8?B?UzVDbWZpNzVYYlNYUHFUZzQ0ZFdpR0xTelM1b0dYTjUzenBtTmRCaFAvOVA0?=
 =?utf-8?B?YndIRWRKN3ZZSVAvRkpMNkRuZHZsUlJXRE84bCtUd0VWQis3K3F0bDZ6Vldk?=
 =?utf-8?B?RVViMi9XWFZESyswNkJnR3NEb3A5aFJKMi9uSC9kbWZuck5VZmFSb2dSMzdm?=
 =?utf-8?B?RTNxMFZJSFBRNW1OK3F3S0NDVWRMR1l1c1JNT0NqNTUyYmYzK1lqc1JTTU5F?=
 =?utf-8?B?Vzc4VS83cFJ0b01CekhzeUlIQU5NSWlBbUYyUmtBZ3BtWnhaM2NRaUpsMi9Z?=
 =?utf-8?B?TTJHWHFncUNGOUNFTlIwWTJBcjYxYy92c200aXp3WHdGSVN5QndmWFdZSjFo?=
 =?utf-8?B?THJKODh4eTlWb0tieUVKWWFzUGJQOXErRHVvWG41QmN3cmlqNmxQTnN6eTl4?=
 =?utf-8?B?TTBFbTJsaVpVMmFkUk5UN29LZlBGOGpjanVpSDY5OUxJck5jVW93SklyeWIv?=
 =?utf-8?B?NmRYUTlSTGF5QU5sNU01ZzA4K2xEUTFCVjVsTWNiZHMyZVY5TVNrMGxHTEx5?=
 =?utf-8?B?djZtTWEyMnR3WU9HaDVvampYN0txZXA3WCtNbWN2RFQwUVVRWFVRNDNLZzY3?=
 =?utf-8?B?NFFjRTc3d3AzdTJJNnBDNFAyUDVxbzRLUEQ1N0poOFRuZzk1YWFIYUZGY0ZM?=
 =?utf-8?B?ZmdLZy8zcEZ3aG9OUWxnTS9iWEVlbnZWUVZidEtyeTM0VFJIemRqbFA5UDBG?=
 =?utf-8?B?MmYrNnRVWHo3VVFEcU1KTEJKc1pLd1g5UWJlWWtLQlJZM2JXS21UdGJQaHRq?=
 =?utf-8?B?Ukt6QUhGMHp4dDYyVHAyV3REcnFFUVJKb3dpUStkZFFtS2F3UW9QTTRNUVRw?=
 =?utf-8?B?QXBWNmV6Y3U0NGZUbGN4ZURRa2p2WTR6MnlwQytjMkkvOEF6UG9LZmpIa1B1?=
 =?utf-8?B?OHRlMXRLVllhSTZQdC80TUtCSTlOU0YrakJ1dnZsUjREMllEK1BlN2VzMG00?=
 =?utf-8?B?MHV2cEkzVUxZVkkrcUNVS2hDUEpla0RKYzhXTE9rYnZSNm80blVzZFdFMWdS?=
 =?utf-8?B?ak82MTNPSVIzSzJPdnNmUkJCY3RyeUh1eUo0UUhtckY1b0gvcG1uNlB5N2Q1?=
 =?utf-8?B?ZHVRZFdHbHhxekNaalNRdUN0dHZzcWJiQ1JzdnZQc2V1MkNDdUlFa3dlSW1J?=
 =?utf-8?B?UkpTQWZDL05JT255OEY0a2dFSGJyYzdsSEpRak05VmZBZVJ0Vm5JZ0ZXckhZ?=
 =?utf-8?B?YUM3S1BRUFB4L09YTlZNMHBIOE1XR0cyUVViSTlhbm1zNm1yVTBEL1VFSXBL?=
 =?utf-8?B?QTdEMDJYeG5XYU0rSkNsRC81ZDJiNmQ5MHBvQTFSbG5pdGZzT29odmM3QUFN?=
 =?utf-8?B?YWtXamlBRmxLTWpxK3VSTEwybXJpc1VFN2dmbHdMQzI0NzM4ZkI5MmVnOTRk?=
 =?utf-8?B?a1JGYkxKamR6RDZGdFo5Z0dieStzQVZtRGJsN0s2dkxRVkg3bEJwM05pL2M4?=
 =?utf-8?B?QnQyZENSMkkvTUVHOXhSOTlmOU9nR1ZZWXZwUDBPRE1GeDhYWHVmYWRNUTE1?=
 =?utf-8?B?aFpsSmx6RTc2QnN5TUxuTEVoa2dycU9kVWZPUGJObW5rYXE3a1dYK05NMUQ2?=
 =?utf-8?B?SlptVnZLMUJITW5EM1IvMGk0M2JhV0pWSCt6bmVRTjlWanBqcUpDK2wvZURC?=
 =?utf-8?B?MHRmbGEzNjdQQWxKYlNiWlhsTXJYaUovNE5XMkpyVmFzYTFkcE1yUHJ2Vmw4?=
 =?utf-8?B?THFrc2pOdWdDQnpUdzUxY0FkWlpVNnNhdUxFU3c1QWc1NUVFUWhOTThzYTd2?=
 =?utf-8?B?ZTlOUDdwdE1XaXBhR2FweitVSGJyZWd0S2V6ZGlVdFdlQjZYcThzV0pvbEl1?=
 =?utf-8?B?NVRXT3RKUmxab0c5SlVOQzZ5dWRDUGN3VW1TSWFET3lvV29DVkQ0QVVxTlhn?=
 =?utf-8?B?bkphR3R2MGZHY2FMTkduRUVTUEVwZG8xYlE0L0FXQUROZVBMdzdYM3QzSmtC?=
 =?utf-8?B?T3RkOWdncmdKaGg1UWJ3OTlaMzYrSWNpdi90NXQ3clhTeVRNSmhhazdyVlBC?=
 =?utf-8?Q?EUYxs9fr8Tou7VKaBJ+yvD+ZI?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?d3puT0JtZ0RidUZzQ1ZJZXhXb1FKYW9ydlFRd0lremFFOVRVMFg3UUhlTURz?=
 =?utf-8?B?cmFrb3NEZTRsRldWWVRUWFZWYkVYK1V0c2Z0OENaOTV3YzFtYjFIOG5GRmZl?=
 =?utf-8?B?Lys4c0RyT2lwcVRxUExCa05peXJGMmY2anVFZnZIZFRpdjBDek52a1NvNVVs?=
 =?utf-8?B?dHN1UjlNbzEvdG5EeDNMYjFEVHA5QmJNU1FHT0pOQlU2bHlQRnU4SnNRNzI2?=
 =?utf-8?B?MkJ1QjVZQnBoZndaWjhXUE8zQ2RXY0loRkdRaUlkbXBmeC9iR1diaUhaZmRP?=
 =?utf-8?B?VkhsYThScFdacW96TGxXcS9HOTVxOXNtbjlITExGR1pDQmJaaWdObmJCWVRN?=
 =?utf-8?B?OG1La1QyeTZ3RnZaZ2htSzh3b25QS2puc3IxY3d3QVZ5enc5V3pxWkcrVXRB?=
 =?utf-8?B?QWhua2h3bG0zRkZGRlp0em9QWjNsMis1aThWZ0dCeDhmQVJjVVpYSlhyRWNX?=
 =?utf-8?B?SlZ5MjBvd3c5ajZrTm11emIrVXRSMVM4S3A4S2hlVHliOU9oc2s5MVBtQkNV?=
 =?utf-8?B?dE9kT1FiVThlWjJhdmhBZks0SHpVekZLallKejNOR2hQTWxNQjI1M0hhKzhs?=
 =?utf-8?B?UndGQk9Jc0pGQm1pQjJnL0s0SEhOalBMTWZudyswZ0FxWWx1dVk0RFNxeW5P?=
 =?utf-8?B?aDdCNmtDUWwwQXNKc1lrdGllTk1OdllFdUg3RGVSSThvclU5SVBsUkVUcVNt?=
 =?utf-8?B?RFJXYXFIaXl4SWl6NElCOTBOMmdtNXlqMXhFVUhIMUlteFdPTlJzbmRyWk9y?=
 =?utf-8?B?K3NlNGFGSTRCSU85ai9vTVFiNlpPNjZtbnBockR3UFBud0NJZGs0S3hDclR0?=
 =?utf-8?B?ck1SZm1Nc214NXQ1UmMvUUc5SGtJL2ZkRU8vSWpYdnVXREtXRUR3aDRuK2dP?=
 =?utf-8?B?NUxyaUd3TkZJcitaUmpzRGlUdWc1TmV4WlBlWWQwa3Y4U1VhUkE4TVR1SUhH?=
 =?utf-8?B?MUxPclc3TnRqaVpiems2K0pNakNoaHE4d2dVZU40Rk5hUTJ6QjZYZ0tWQUd1?=
 =?utf-8?B?MXp1dFpSRE5CSFVrUXIzNmVncTNlWjE4MjZWdFFKWmU1UmYrcVNoenNTeXRF?=
 =?utf-8?B?aGJoL3dBZnFvT2N6NWROaXFZZmRyMzVleEtNdS9jOUdpT0NISUUwOVdLS045?=
 =?utf-8?B?dWZJcnoyN0tIYWFCUWZ4Um1UVVltaGdYSFMzUzFWeG1WVk1JWXk3Ym92N3hD?=
 =?utf-8?B?am9wVTliNEtTVDgzamVKTUhMd1VYYW1yUmdmS09SV0NtaHdKL2IyejR0MHdM?=
 =?utf-8?B?Z3paYnBoSE9FVi9leFlNN1RzdjRkcEdxSG1Ta0NzZEN4K05maEM4d2xBYTl5?=
 =?utf-8?B?T2NSRElIRENzcnpFenRaNi9Oa20wL0J2Vy9hWThTSDBPc3d6cDBwK0IvbVUz?=
 =?utf-8?B?cE1ZSnZabjJFeVl2OUcwb2JlM1VEazlDV3ViM2MxaHBIS28vY0RTNHRVQVor?=
 =?utf-8?B?cmlmRlkzVEFPc3NrYWJJY0pEU28rVUtlc2ZuYW9JYUNUSjYvWnhvd2FZbmV3?=
 =?utf-8?B?YW0yU0xjQTBselVyeGNEcU9qWTZ6emV6aThpYjdLck1QREVUMHEzcnVLVTFs?=
 =?utf-8?Q?rHxx7P6i5TMwwKmoc/QsgkTJfK6m++Gpyh64HzZtwA+b0L?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f086930-f7ae-4f90-44af-08da7f165cd9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 23:32:05.3690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cgxokoCMoSsLOLLIym6wgeD6s/MIsh3wfn1aMJShgPRzt7qhi4uPcGe2pyCKYZWGEgxd7IPS7xBd+y+H9TANdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3755
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-15_08,2022-08-15_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208150090
X-Proofpoint-ORIG-GUID: zfMyYKDd-_j3MBeNLrtUyQ4geuqGguUm
X-Proofpoint-GUID: zfMyYKDd-_j3MBeNLrtUyQ4geuqGguUm
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/15/2022 2:26 AM, Zhu Lingshan wrote:
> Some fields of virtio-net device config space are
> conditional on the feature bits, the spec says:
>
> "The mac address field always exists
> (though is only valid if VIRTIO_NET_F_MAC is set)"
>
> "max_virtqueue_pairs only exists if VIRTIO_NET_F_MQ
> or VIRTIO_NET_F_RSS is set"
>
> "mtu only exists if VIRTIO_NET_F_MTU is set"
>
> so we should read MTU, MAC and MQ in the device config
> space only when these feature bits are offered.
>
> For MQ, if both VIRTIO_NET_F_MQ and VIRTIO_NET_F_RSS are
> not set, the virtio device should have
> one queue pair as default value, so when userspace querying queue pair numbers,
> it should return mq=1 than zero.
>
> For MTU, if VIRTIO_NET_F_MTU is not set, we should not read
> MTU from the device config sapce.
> RFC894 <A Standard for the Transmission of IP Datagrams over Ethernet Networks>
> says:"The minimum length of the data field of a packet sent over an
> Ethernet is 1500 octets, thus the maximum length of an IP datagram
> sent over an Ethernet is 1500 octets.  Implementations are encouraged
> to support full-length packets"
Noted there's a typo in the above "The *maximum* length of the data 
field of a packet sent over an Ethernet is 1500 octets ..." and the RFC 
was written 1984.
Apparently that is no longer true with the introduction of Jumbo size 
frame later in the 2000s. I'm not sure what is the point of mention this 
ancient RFC. It doesn't say default MTU of any Ethernet NIC/switch 
should be 1500 in either  case.

>
> virtio spec says:"The virtio network device is a virtual ethernet card",
Right,
> so the default MTU value should be 1500 for virtio-net.
... but it doesn't say the default is 1500. At least, not in explicit 
way. Why it can't be 1492 or even lower? In practice, if the network 
backend has a MTU higher than 1500, there's nothing wrong for guest to 
configure default MTU more than 1500.

>
> For MAC, the spec says:"If the VIRTIO_NET_F_MAC feature bit is set,
> the configuration space mac entry indicates the “physical” address
> of the network card, otherwise the driver would typically
> generate a random local MAC address." So there is no
> default MAC address if VIRTIO_NET_F_MAC not set.
>
> This commits introduces functions vdpa_dev_net_mtu_config_fill()
> and vdpa_dev_net_mac_config_fill() to fill MTU and MAC.
> It also fixes vdpa_dev_net_mq_config_fill() to report correct
> MQ when _F_MQ is not present.
>
> These functions should check devices features than driver
> features, and struct vdpa_device is not needed as a parameter
>
> The test & userspace tool output:
>
> Feature bit VIRTIO_NET_F_MTU, VIRTIO_NET_F_RSS, VIRTIO_NET_F_MQ
> and VIRTIO_NET_F_MAC can be mask out by hardcode.
>
> However, it is challenging to "disable" the related fields
> in the HW device config space, so let's just assume the values
> are meaningless if the feature bits are not set.
>
> Before this change, when feature bits for RSS, MQ, MTU and MAC
> are not set, iproute2 output:
> $vdpa vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false mtu 1500
>    negotiated_features
>
> without this commit, function vdpa_dev_net_config_fill()
> reads all config space fields unconditionally, so let's
> assume the MAC and MTU are meaningless, and it checks
> MQ with driver_features, so we don't see max_vq_pairs.
>
> After applying this commit, when feature bits for
> MQ, RSS, MAC and MTU are not set,iproute2 output:
> $vdpa dev config show vdpa0
> vdpa0: link up link_announce false max_vq_pairs 1 mtu 1500
>    negotiated_features
>
> As explained above:
> Here is no MAC, because VIRTIO_NET_F_MAC is not set,
> and there is no default value for MAC. It shows
> max_vq_paris = 1 because even without MQ feature,
> a functional virtio-net must have one queue pair.
> mtu = 1500 is the default value as ethernet
> required.
>
> This commit also add supplementary comments for
> __virtio16_to_cpu(true, xxx) operations in
> vdpa_dev_net_config_fill() and vdpa_fill_stats_rec()
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vdpa/vdpa.c | 60 +++++++++++++++++++++++++++++++++++----------
>   1 file changed, 47 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index efb55a06e961..a74660b98979 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -801,19 +801,44 @@ static int vdpa_nl_cmd_dev_get_dumpit(struct sk_buff *msg, struct netlink_callba
>   	return msg->len;
>   }
>   
> -static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
> -				       struct sk_buff *msg, u64 features,
> +static int vdpa_dev_net_mq_config_fill(struct sk_buff *msg, u64 features,
>   				       const struct virtio_net_config *config)
>   {
>   	u16 val_u16;
>   
> -	if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0)
> -		return 0;
> +	if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0 &&
> +	    (features & BIT_ULL(VIRTIO_NET_F_RSS)) == 0)
> +		val_u16 = 1;
> +	else
> +		val_u16 = __virtio16_to_cpu(true, config->max_virtqueue_pairs);
>   
> -	val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
>   	return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, val_u16);
>   }
>   
> +static int vdpa_dev_net_mtu_config_fill(struct sk_buff *msg, u64 features,
> +					const struct virtio_net_config *config)
> +{
> +	u16 val_u16;
> +
> +	if ((features & BIT_ULL(VIRTIO_NET_F_MTU)) == 0)
> +		val_u16 = 1500;
As said, there's no virtio spec defined value for MTU. Please leave this 
field out if feature VIRTIO_NET_F_MTU is not negotiated.
> +	else
> +		val_u16 = __virtio16_to_cpu(true, config->mtu);
> +
> +	return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16);
> +}
> +
> +static int vdpa_dev_net_mac_config_fill(struct sk_buff *msg, u64 features,
> +					const struct virtio_net_config *config)
> +{
> +	if ((features & BIT_ULL(VIRTIO_NET_F_MAC)) == 0)
> +		return 0;
> +	else
> +		return  nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR,
> +				sizeof(config->mac), config->mac);
> +}
> +
> +
>   static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
>   {
>   	struct virtio_net_config config = {};
> @@ -822,18 +847,16 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>   
>   	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>   
> -	if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac),
> -		    config.mac))
> -		return -EMSGSIZE;
> +	/*
> +	 * Assume little endian for now, userspace can tweak this for
> +	 * legacy guest support.
You can leave it as a TODO for kernel (vdpa core limitation), but AFAIK 
there's nothing userspace needs to do to infer the endianness. IMHO it's 
the kernel's job to provide an abstraction rather than rely on userspace 
guessing it.

> +	 */
> +	val_u16 = __virtio16_to_cpu(true, config.status);
>   
>   	val_u16 = __virtio16_to_cpu(true, config.status);
>   	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
>   		return -EMSGSIZE;
>   
> -	val_u16 = __virtio16_to_cpu(true, config.mtu);
> -	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> -		return -EMSGSIZE;
> -
>   	features_driver = vdev->config->get_driver_features(vdev);
>   	if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
>   			      VDPA_ATTR_PAD))
> @@ -846,7 +869,13 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>   			      VDPA_ATTR_PAD))
>   		return -EMSGSIZE;
>   
> -	return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver, &config);
> +	if (vdpa_dev_net_mac_config_fill(msg, features_device, &config))
> +		return -EMSGSIZE;
> +
> +	if (vdpa_dev_net_mtu_config_fill(msg, features_device, &config))
> +		return -EMSGSIZE;
> +
> +	return vdpa_dev_net_mq_config_fill(msg, features_device, &config);
>   }
>   
>   static int
> @@ -914,6 +943,11 @@ static int vdpa_fill_stats_rec(struct vdpa_device *vdev, struct sk_buff *msg,
>   	}
>   	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>   
> +	/*
> +	 * Assume little endian for now, userspace can tweak this for
> +	 * legacy guest support.
> +	 */
> +
Ditto.

Thanks,
-Siwei
>   	max_vqp = __virtio16_to_cpu(true, config.max_virtqueue_pairs);
>   	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, max_vqp))
>   		return -EMSGSIZE;

