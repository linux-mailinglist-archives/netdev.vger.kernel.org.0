Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD345A20D8
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 08:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241183AbiHZGYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 02:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiHZGYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 02:24:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FEAA3467;
        Thu, 25 Aug 2022 23:24:07 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27Q4HOVt015653;
        Fri, 26 Aug 2022 06:23:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=g4DEi8XlUamT8yKB5yz9LlGDMbZTRITS+XgvZ7phnps=;
 b=ZQMV87hSBD7wjWPTf+1B5KevA3kKQzqe7tDA/P2QNm2ylOX8PZbkrlRXQJ7YqZmp8iID
 oRZBmzCPKDNvQYXVBdZP2KVWN3D3qDeVQ6FU7CtUcnpvcw/Jn0dYYfsaW4QaHekfScb0
 wcWzvv4nZimy0M78ryrATHGH3jJjypyEcTqeHDzfRoJ1OIsyX3peZ+6wHOPQlTG+8wqT
 Ov+/VESdFCbEzZPQxGp4GynjOU+mNpUAtAikwSdtHtE6CAbrdvznB2wlMMSkxGWERDm4
 EEhqjz6+DRllXbQBFGj45ngSKeHd6G0ZXYM2DKht2TjOMrGeAMKjSuK0Cwr88yP6Dk4t kw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j5aww65jm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Aug 2022 06:23:59 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27Q2Lx4N016739;
        Fri, 26 Aug 2022 06:23:58 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j5n58kxty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Aug 2022 06:23:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UNE67e4xg0mwwrzwdf/zsVJYZXMPkTxqaIksefisDucLDTiAMoy56Pr7RN5iJXt2KzYkzk1XnFeSJOh+J661E89I1rEFdUkUk3MxpM+rNGTvvE+o8c6rfssUjuvttoWznk8QwRXlQutqd/MmkNpFZiz9tr6KFwD2oPCsu2PJCn+ytaqYbtUVSaF9a8CHdwag7SxZ2i4qTsg2BxbXSDZkpHHUUWbT5Kp+gaWjOm42Uu/XiLqyYekXVvahDrs+trF75fDZ13ZmlCJvrEW/jjsJHHChCIjC9/2Big8I3qMwMJEbbbPRwCAcdjwvnFl38IYs6KJuxUgvKVJ2CjagIcuLww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g4DEi8XlUamT8yKB5yz9LlGDMbZTRITS+XgvZ7phnps=;
 b=bGQdmTojpynxMmGqKkxDgRPNKXfz3WnoCj357jQeFzF7MTSirfyxcHmHJkRbdaNh2Fdk6EWZb3W29l/rS7vCsO14JH/o/W8cYRXg3A1XUeSlp3/9nEFKbP2TezPy5PKWIKwPUP7syfoSLDtrUa4ns0uvBDX5KVSI8HexbmHzcGQrfQe7/FUS418yOmJ9+9Opo6OAKVgwObI1cPQETtmbJhrwsA6qmJ1Fde1eIyYxrpdQBP9r1KS+jy3a81JJv3/FNbh/lH3rnR0XxLGIgUporHNSx8YXa9C7Yns+M7lYxIXgBDbugbmy9N/RNOzUI7ZhJSQsEh3AWnOnMhBiqoUY/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g4DEi8XlUamT8yKB5yz9LlGDMbZTRITS+XgvZ7phnps=;
 b=PQybziWdzD0NgHEGQ4RcwXv/Zh8qhIfAPvbOiQr0g9ij+xPdAKwDU3/6x2P1TAzza4+xH/eLo63540/1Zn1DIHlTKThY/ijJQuIHyw1RuB7NNCOdwPAvUAyfhGLSRfoAVDfXqpA7Z43Gr9paVDePZUJkLuwh8nCBKya4AfSPSCQ=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by CO1PR10MB4515.namprd10.prod.outlook.com (2603:10b6:303:9b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 06:23:55 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649%7]) with mapi id 15.20.5566.015; Fri, 26 Aug 2022
 06:23:49 +0000
Message-ID: <a6ac322c-636f-1826-5c65-b51cc5464999@oracle.com>
Date:   Thu, 25 Aug 2022 23:23:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
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
 <4678fc51-a402-d3ea-e875-6eba175933ba@oracle.com>
 <e06d1f6d-3199-1b75-d369-2e5d69040271@intel.com>
 <CACGkMEv24Rn9+bJ5mma1ciJNwa7wvRCwJ6jF+CBMbz6DtV8MvA@mail.gmail.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CACGkMEv24Rn9+bJ5mma1ciJNwa7wvRCwJ6jF+CBMbz6DtV8MvA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0181.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::6) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94b979e2-f649-4607-6bc4-08da872b8991
X-MS-TrafficTypeDiagnostic: CO1PR10MB4515:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XTx6MmKVNTl9HyPvq7vKk6qnD2qb90BjQ2qAfq2tIyODur0dg2IHxyDwuyxBmSSy4Cj5c5Jt6YXiemF36dQbgd2KXAZ0qNCP5a312hB9WNiCoCn8OkOFP1frvMwQCcNzMquldttL9akcZ0rY6A5RKgSdVGprmitW2zsXZZ9vJwSqA042IizYYBjB/dI7nu2JdQms/LVmB5UHhVkOtBW8/CZGSMklzlrg6vNgbj3ADQYEzBkg+peVJd+cbhS6W7qodwr6GcPVxt4uQ55Dz1a3rLYh84ucU0u/L8pNGSpBy3itKJ9VtnXfu99Hb8oEAUYG9OIDyPW1QfZ5Ja+VCDGtarw3yJRI20+4Er0LoHm5JeBYDEDJyCzGHodCO97SBPPSZBtUqZlwQ4cBofIgmI0gGxke6aeQMJZFkAKf7397pdylwmyUbyrYDsxOLjk+YOtxq2EUdajrmMGgHdCinF+tQsMzTRpSO23IcSdFOCQn1e9OJ1Rc8ph1SrN2AUKZy/kpPOkxt48ft/v7R7s9x8Ka9j+7ufEI6dR6XVYDcaTnR6c/bXUZnlGLTpCNPf5GTm08RjJESqySlNnC7K3XphTlYSKJiAcrOdBIlif9ONudpfhn9G1lk6PN6KhsB/cxjwRohut8iVD8m6NEto/vlTCHg4behTv5VQzp77aM1Ods3tTcVEjXCFY9iAR9GBPKjHKErpnSIpaHUSMPHRIVQwPxpPYjAnoxaOcLxMnyFOx4h4lZAvJHzzpYamqKQ5DSYcZ0POIsyN0WoOb/kt0q5zzLTe+BX8r6VrwOUaY7B7DIRJyLRKqZwyZS+ankuZiZrOu7TDifhnnFcmb/l0YSjMkYQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(136003)(39860400002)(376002)(366004)(4326008)(66946007)(66556008)(8676002)(36756003)(38100700002)(66476007)(86362001)(110136005)(31696002)(31686004)(2616005)(186003)(53546011)(6512007)(478600001)(26005)(6506007)(6666004)(966005)(36916002)(6486002)(8936002)(5660300002)(316002)(54906003)(41300700001)(83380400001)(2906002)(30864003)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFArK2FFSnU4cEVidHVabTA2Qm0vUGF6WTR0ZkF6US9Mc0dFK3UwVTMwRVAx?=
 =?utf-8?B?QkVZN1JjRVRxM0NlK2ZrQmp5UVdmVEtZN3RJMExwNHkwZ2xERkVvTlF5QVJ0?=
 =?utf-8?B?d0p5VjM2WWFaTHIrei9Zc002bWdvVnJ5QXN6Z3B1SWVoTnpoRVMzdEFOWXNP?=
 =?utf-8?B?bkFEbXZSb3Y1cEdrQ2RUNVhLdFg1WFdEcTNFUG5aMWJkNWczYTd3QUV2MXp5?=
 =?utf-8?B?Q3VkZzVKcWdTc0E3UjdYZnZkMHo3ZUxFVkovWU0zYVFybDc4dmlWU0lIVDJP?=
 =?utf-8?B?OUhlVHNTRkpGSEZIbXdXcXlISlVJQi9OVEwvS3VNcmkxRUd5eDNSSmVDcVA0?=
 =?utf-8?B?ak5GNGFTTlNWU0RwMmZ0clkzbEY5K1d6ZUY2ZjV5V2ZRcjdET1liTkNTSWFS?=
 =?utf-8?B?bDRZQzJSc0o2QVdkWnpjakJubjVHbjRSN2RoTmZzQVByN1htVG82cmtoYytw?=
 =?utf-8?B?VjJUVlE5ZU9qNkFoL3R6YlFaUEpzK0ZrU0J3SVcrUk80RXRIMksxRGpaY1hG?=
 =?utf-8?B?elByVGVCb3Bwa1NtY0pzNlMyY2ZrTVBHOUFqVVhuZDV3c0F1clArNFo0Z1hR?=
 =?utf-8?B?RVJzbkNQc1l1d1lCM3JEQkp2Tit3WFlNL3F0WGpJT3EwMWhCZ3BKZFA5WmFw?=
 =?utf-8?B?MXNPMVNvNWZLa2ZwUk9VMU9vdDErREcvTC9lZjRPKzQ5S25TWU9NOWJvVnVU?=
 =?utf-8?B?WTJjV0grd2MrdTRaV1dHMDZLNWNpMUM5Mkh3blNPeXJ0NnVmZ1g5eXJBaldz?=
 =?utf-8?B?Vmc4UW1XRFRGeVhTSFVxQ1ljQ2pIR2t2cmVtejU5VG1zNkRWVUdoMmlid3h4?=
 =?utf-8?B?TDFGWkd0dDZBcGdYaFp1Wnd6NnluclhHbkN2b0RwOG9tMzB2V0F2WnJKdWlM?=
 =?utf-8?B?Vks4Uk5Eb2hHRFFBOEJKZ01qOEorcGFaUW4rNjRKN1FINmdqVnYxOWpPdnh1?=
 =?utf-8?B?Mngvbnc4QS9KVDVPU0VIOUhabDN0SFoxb0FydU4xcng1cnF2RHNGOU96MVdL?=
 =?utf-8?B?TmtKV2RLcEI5NHdTVENzZmJaeVAwNGJGM0ZBTU85ZmZHRnF3cmdZaTBqVnpz?=
 =?utf-8?B?VUFPUWdJTlE2eTZINDJDbG9Jcjd3T2pEZklXTEdqOWkvOWtGYXFqK2xMOWZy?=
 =?utf-8?B?c25hMFNEVWErRS9pbVN6RFFPK1BFcTFxRW8xcVZQTjhHeXhObjh2UHQwNm1G?=
 =?utf-8?B?aWp3WmNrQk4xV1hSU2xZb1pwTTJjWk9JOFcrQkxBdzhqbU9PUS9iSDAzd0s2?=
 =?utf-8?B?dnpxUUpFRnMzOTZKUm5MS2hBNEp6bzVKTlJ3bDlGakU2TUdTendOWW9DemEz?=
 =?utf-8?B?OVAzWE1ZTHl0aXNLbGpqdlBlRDFMb1ZseEFBSXZJTTlJOUo1THcwMFFjOEsv?=
 =?utf-8?B?UVo4TXhIVWhiYk55Y1o0NGlvS0h1bUJlVW5qdDlCd0pVa0JkVU1ORWNVd1Bl?=
 =?utf-8?B?SnV1WGJHSnhFZDdrVTJKT3JBb1dEa2pPdWZ0MEQ5bXdiZ2g4UjN5OFMwSzZh?=
 =?utf-8?B?UHVMRFBqalJLTWRhVUhucTZzRUxScVJXQ1NkZ1Y0a3lBN3RSS0dlUzhkVCtZ?=
 =?utf-8?B?QnF2V0JBQUtJNUtFZnkrSGkxMDkybmorUUF5UGpIV2NEOUx2Zk9BV1hiWW5B?=
 =?utf-8?B?eGlDY2tPcEZ0ZVVCbTdCWnBWSnY0dzBLNUN1dkVpdHFGRXJlZ0FhYXp5WFNt?=
 =?utf-8?B?b05MOWRsU3BJUFl5SWFtZWErVEdvZitkZklIMkRIUmVPSXZId0RhWE82c1g3?=
 =?utf-8?B?dE93MmNlYjZEUXVROTVwSXFDanNlbXc1RWFNQkVYejdiclp0ekJKVUtJaFZ2?=
 =?utf-8?B?eUprKzNrWWxhaXRXbWNjYkt6NUJKS3hSQ3FOUUpDb1dOSWpxa1FtaWtSRUlY?=
 =?utf-8?B?NHZma3hpTjFVS3Z2SmQwamFGTXR0VHJ0SkJWaWM1alFKV2dkckVwWjd6OTVp?=
 =?utf-8?B?MVk4MUJ4VHBtVjBjbFZ4aGo0NWNqSzloUXVnLzNqeFFNemZ5VG4wN25YVmdl?=
 =?utf-8?B?cWZaN2Z5enNONnRRQTJONkxDb0piMUJMRDlGc3dqK0ZaZi96UWI3T0FFckxU?=
 =?utf-8?B?UlFhSEI4SEI2R3dYeU1DbTdXMlpxdmtabmg1Y3MycnlSOWZqYTJrTjJoNXlR?=
 =?utf-8?Q?DXE+Y4nAB6n1hAPYcq8zkve3e?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94b979e2-f649-4607-6bc4-08da872b8991
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 06:23:48.9261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Wjp+utOnQJWQv0M2KkYoOc56Wo9lZ9FC38FURo34GwxS2FrkrK2RcTTQsW4UqdK7q0fSGg85mnDXcQVKG8Awg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4515
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_02,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208260022
X-Proofpoint-GUID: nWGfBjsu1rP_ePvWfYrlCuTSuydbjAMF
X-Proofpoint-ORIG-GUID: nWGfBjsu1rP_ePvWfYrlCuTSuydbjAMF
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/22/2022 8:26 PM, Jason Wang wrote:
> On Mon, Aug 22, 2022 at 1:08 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>>
>>
>> On 8/20/2022 4:55 PM, Si-Wei Liu wrote:
>>>
>>> On 8/18/2022 5:42 PM, Jason Wang wrote:
>>>> On Fri, Aug 19, 2022 at 7:20 AM Si-Wei Liu <si-wei.liu@oracle.com>
>>>> wrote:
>>>>>
>>>>> On 8/17/2022 9:15 PM, Jason Wang wrote:
>>>>>> 在 2022/8/17 18:37, Michael S. Tsirkin 写道:
>>>>>>> On Wed, Aug 17, 2022 at 05:43:22PM +0800, Zhu, Lingshan wrote:
>>>>>>>> On 8/17/2022 5:39 PM, Michael S. Tsirkin wrote:
>>>>>>>>> On Wed, Aug 17, 2022 at 05:13:59PM +0800, Zhu, Lingshan wrote:
>>>>>>>>>> On 8/17/2022 4:55 PM, Michael S. Tsirkin wrote:
>>>>>>>>>>> On Wed, Aug 17, 2022 at 10:14:26AM +0800, Zhu, Lingshan wrote:
>>>>>>>>>>>> Yes it is a little messy, and we can not check _F_VERSION_1
>>>>>>>>>>>> because of
>>>>>>>>>>>> transitional devices, so maybe this is the best we can do for
>>>>>>>>>>>> now
>>>>>>>>>>> I think vhost generally needs an API to declare config space
>>>>>>>>>>> endian-ness
>>>>>>>>>>> to kernel. vdpa can reuse that too then.
>>>>>>>>>> Yes, I remember you have mentioned some IOCTL to set the
>>>>>>>>>> endian-ness,
>>>>>>>>>> for vDPA, I think only the vendor driver knows the endian,
>>>>>>>>>> so we may need a new function vdpa_ops->get_endian().
>>>>>>>>>> In the last thread, we say maybe it's better to add a comment for
>>>>>>>>>> now.
>>>>>>>>>> But if you think we should add a vdpa_ops->get_endian(), I can
>>>>>>>>>> work
>>>>>>>>>> on it for sure!
>>>>>>>>>>
>>>>>>>>>> Thanks
>>>>>>>>>> Zhu Lingshan
>>>>>>>>> I think QEMU has to set endian-ness. No one else knows.
>>>>>>>> Yes, for SW based vhost it is true. But for HW vDPA, only
>>>>>>>> the device & driver knows the endian, I think we can not
>>>>>>>> "set" a hardware's endian.
>>>>>>> QEMU knows the guest endian-ness and it knows that
>>>>>>> device is accessed through the legacy interface.
>>>>>>> It can accordingly send endian-ness to the kernel and
>>>>>>> kernel can propagate it to the driver.
>>>>>> I wonder if we can simply force LE and then Qemu can do the endian
>>>>>> conversion?
>>>>> convert from LE for config space fields only, or QEMU has to forcefully
>>>>> mediate and covert endianness for all device memory access including
>>>>> even the datapath (fields in descriptor and avail/used rings)?
>>>> Former. Actually, I want to force modern devices for vDPA when
>>>> developing the vDPA framework. But then we see requirements for
>>>> transitional or even legacy (e.g the Ali ENI parent). So it
>>>> complicates things a lot.
>>>>
>>>> I think several ideas has been proposed:
>>>>
>>>> 1) Your proposal of having a vDPA specific way for
>>>> modern/transitional/legacy awareness. This seems very clean since each
>>>> transport should have the ability to do that but it still requires
>>>> some kind of mediation for the case e.g running BE legacy guest on LE
>>>> host.
>>> In theory it seems like so, though practically I wonder if we can just
>>> forbid BE legacy driver from running on modern LE host. For those who
>>> care about legacy BE guest, they mostly like could and should talk to
>>> vendor to get native BE support to achieve hardware acceleration,
> The problem is the hardware still needs a way to know the endian of the guest?
Hardware doesn't need to know. VMM should know by judging from VERSION_1 
feature bit negotiation and legacy interface access (with new code), and 
the target architecture endianness (the latter is existing QEMU code).
>
>>> few
>>> of them would count on QEMU in mediating or emulating the datapath
>>> (otherwise I don't see the benefit of adopting vDPA?). I still feel
>>> that not every hardware vendor has to offer backward compatibility
>>> (transitional device) with legacy interface/behavior (BE being just
>>> one),
> Probably, I agree it is a corner case, and dealing with transitional
> device for the following setups is very challenge for hardware:
>
> - driver without IOMMU_PLATFORM support, (requiring device to send
> translated request which have security implications)
Don't get better suggestion for this one, but I presume this is 
something legacy guest users should be aware of ahead in term of 
security implications.

> - BE legacy guest on LE host, (requiring device to have a way to know
> the endian)
Yes. device can tell apart with the help from VMM (judging by VERSION_1 
acknowledgement and if legacy interface is used during negotiation).

> - device specific requirement (e.g modern virtio-net mandate minimal
> header length to contain mrg_rxbuf even if the device doesn't offer
> it)
This one seems to be spec mandated transitional interface requirement? 
Which vDPA hardware vendor should take care of rather (if they do offer 
a transitional device)?
>
> It is not obvious for the hardware vendor, so we may end up defecting
> in the implementation. Dealing with compatibility for the transitional
> devices is kind of a nightmare which there's no way for the spec to
> rule the behavior of legacy devices.
The compatibility detection part is tedious I agree. That's why I 
suggested starting from the very minimal and practically feasible (for 
e.g. on x86), but just don't prohibit the possibility to extend to big 
endian or come up with quirk fixes for various cases in QEMU.

>
>>>   this is unlike the situation on software virtio device, which
>>> has legacy support since day one. I think we ever discussed it before:
>>> for those vDPA vendors who don't offer legacy guest support, maybe we
>>> should mandate some feature for e.g. VERSION_1, as these devices
>>> really don't offer functionality of the opposite side (!VERSION_1)
>>> during negotiation.
> I've tried something similar here (a global mandatory instead of per device).
>
> https://urldefense.com/v3/__https://lkml.org/lkml/2021/6/4/26__;!!ACWV5N9M2RV99hQ!NRQPfj5o9o3MKE12ze1zfXMC-9SqwOWqF26g8RrIyUDbUmwDIwl5WQCaNiDe6aZ2yR83j-NEqRXQNXcNyOo$
>
> But for some reason, it is not applied by Michael. It would be a great
> relief if we support modern devices only. Maybe it's time to revisit
> this idea then we can introduce new backend features and then we can
> mandate VERSION_1
Probably, mandating per-device should be fine I guess.

>
>>> Having it said, perhaps we should also allow vendor device to
>>> implement only partial support for legacy. We can define "reversed"
>>> backend feature to denote some part of the legacy
>>> interface/functionality not getting implemented by device. For
>>> instance, VHOST_BACKEND_F_NO_BE_VRING, VHOST_BACKEND_F_NO_BE_CONFIG,
>>> VHOST_BACKEND_F_NO_ALIGNED_VRING,
>>> VHOST_BACKEND_NET_F_NO_WRITEABLE_MAC, and et al. Not all of these
>>> missing features for legacy would be easy for QEMU to make up for, so
>>> QEMU can selectively emulate those at its best when necessary and
>>> applicable. In other word, this design shouldn't prevent QEMU from
>>> making up for vendor device's partial legacy support.
> This looks too heavyweight since it tries to provide compatibility for
> legacy drivers.
That's just for the sake of extreme backward compatibility, but you can 
say that's not even needed if we mandate transitional device to offer 
all required interfaces for both legacy and modern guest.

>   Considering we've introduced modern devices for 5+
> years, I'd rather:
>
> - Qemu to mediate the config space stuffs
> - Shadow virtqueue to mediate the datapath (AF_XDP told us shadow ring
> can perform very well if we do zero-copy).
This is one way to achieve, though not sure we should stick the only 
hope to zero-copy, which IMHO may take a long way to realize and 
optimize to where a simple datapath passthrough can easily get to (with 
hardware acceleration of coz).

>
>>>> 2) Michael suggests using VHOST_SET_VRING_ENDIAN where it means we
>>>> need a new config ops for vDPA bus, but it doesn't solve the issue for
>>>> config space (at least from its name). We probably need a new ioctl
>>>> for both vring and config space.
>>> Yep adding a new ioctl makes things better, but I think the key is not
>>> the new ioctl. It's whether or not we should enforce every vDPA vendor
>>> driver to implement all transitional interfaces to be spec compliant.
> I think the answer is no since the spec allows transitional device.
> And we know things will be greatly simplified if vDPA support non
> transitional device only.
>
> So we can change the question to:
>
> 1) do we need (or is it too late) to enforce non transitional device?
We already have Alibaba ENI which is sort of a quasi-transitional 
device, right? In the sense it doesn't advertise VERSION_1. I know the 
other parts might not qualify it to be fully transitional, but code now 
doesn't prohibit it from supporting VERSION_1 modern interface depending 
on whatever future need.
> 2) if yes, can transitional device be mediate in an efficient way?
>
> For 1), it's probably too late but we can invent new vDPA features as
> you suggest to be non transitional. Then we can:
>
> 1.1) extend the netlink API to provision non-transitonal device
Define non-transitional: device could be either modern-only or legacy-only?
> 1.2) work on the non-transtional device in the future
> 1.3) presenting transitional device via mediation
presenting transitional on top of a modern device with VERSION_1, right? 
What if the hardware device can support legacy-compatible datapath 
natively that doesn't need mediation? Can it be done with direct 
datapath passthrough without svq involvement?

>
> The previous transitional vDPA work as is, it's probably too late to
> fix all the issue we suffer.
What do you mean work as-is, what's the nomenclature for that, 
quasi-transitional or broken-transitional? and what are the outstanding 
issues you anticipate remaining? If it is device specific or vendor 
driver specific, let it be. But I wonder if there's any generic one that 
has to be fixed in vdpa core to support a truly transitional model.
>
> For 2), the key part is the datapath mediation, we can use shadow virtqueue.
Sure. For our use case, we'd care more in providing transitional rather 
than being non-transitional. So, one device fits all.

Thanks for all the ideas. This discussion is really useful.

Best,
-Siwei
>
>>> If we allow them to reject the VHOST_SET_VRING_ENDIAN  or
>>> VHOST_SET_CONFIG_ENDIAN call, what could we do? We would still end up
>>> with same situation of either fail the guest, or trying to
>>> mediate/emulate, right?
>>>
>>> Not to mention VHOST_SET_VRING_ENDIAN is rarely supported by vhost
>>> today - few distro kernel has CONFIG_VHOST_CROSS_ENDIAN_LEGACY enabled
>>> and QEMU just ignores the result. vhost doesn't necessarily depend on
>>> it to determine endianness it looks.
>> I would like to suggest to add two new config ops get/set_vq_endian()
>> and get/set_config_endian() for vDPA. This is used to:
>> a) support VHOST_GET/SET_VRING_ENDIAN as MST suggested, and add
>> VHOST_SET/GET_CONFIG_ENDIAN for vhost_vdpa.
>> If the device has not implemented interface to set its endianess, then
>> no matter success or failure of SET_ENDIAN, QEMU knows the endian-ness
>> anyway.
> How can Qemu know the endian in this way? And if it can, there's no
> need for the new API?
>
>> In this case, if the device endianess does not match the guest,
>> there needs a mediation layer or fail.
>> b) ops->get_config_endian() can always tell the endian-ness of the
>> device config space after the vendor driver probing the device. So we
>> can use this ops->get_config_endian() for
>> MTU, MAC and other fields handling in vdpa_dev_net_config_fill() and we
>> don't need to set_features in vdpa_get_config_unlocked(), so no race
>> conditions.
>> Every time ops->get_config() returned, we can tell the endian by
>> ops-config_>get_endian(), we don't need set_features(xxx, 0) if features
>> negotiation not done.
>>
>> The question is: Do we need two pairs of ioctls for both vq and config
>> space? Can config space endian-ness differ from the vqs?
>> c) do we need a new netlink attr telling the endian-ness to user space?
> Generally, I'm not sure this is a good design consider it provides neither:
>
> Compatibility with the virtio spec
>
> nor
>
> Compatibility with the existing vhost API (VHOST_SET_VRING_ENDIAN)
>
> Thanks
>
>> Thanks,
>> Zhu Lingshan
>>>> or
>>>>
>>>> 3) revisit the idea of forcing modern only device which may simplify
>>>> things a lot
>>> I am not actually against forcing modern only config space, given that
>>> it's not hard for either QEMU or individual driver to mediate or
>>> emulate, and for the most part it's not conflict with the goal of
>>> offload or acceleration with vDPA. But forcing LE ring layout IMO
>>> would just kill off the potential of a very good use case. Currently
>>> for our use case the priority for supporting 0.9.5 guest with vDPA is
>>> slightly lower compared to live migration, but it is still in our TODO
>>> list.
>>>
>>> Thanks,
>>> -Siwei
>>>
>>>> which way should we go?
>>>>
>>>>> I hope
>>>>> it's not the latter, otherwise it loses the point to use vDPA for
>>>>> datapath acceleration.
>>>>>
>>>>> Even if its the former, it's a little weird for vendor device to
>>>>> implement a LE config space with BE ring layout, although still
>>>>> possible...
>>>> Right.
>>>>
>>>> Thanks
>>>>
>>>>> -Siwei
>>>>>> Thanks
>>>>>>
>>>>>>
>>>>>>>> So if you think we should add a vdpa_ops->get_endian(),
>>>>>>>> I will drop these comments in the next version of
>>>>>>>> series, and work on a new patch for get_endian().
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Zhu Lingshan
>>>>>>> Guests don't get endian-ness from devices so this seems pointless.
>>>>>>>

