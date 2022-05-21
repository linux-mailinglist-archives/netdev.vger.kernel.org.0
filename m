Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBD952FAAF
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 12:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351615AbiEUKZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 06:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351385AbiEUKZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 06:25:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BB39A9B5;
        Sat, 21 May 2022 03:25:14 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24L3Y4GX027639;
        Sat, 21 May 2022 10:24:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=1DeIDBefkTlMntld8a9r2AOS8swbniR+hc16af5Gjf4=;
 b=wAKGTyWs4tnhKt67xjhJ9ZoXgxge8MHn6dwOsfBPFljL+CI+HLjh13sVQbQobvy+tN53
 HSrhbHkJ0kY6MSpW4uVroMiJlJjg5iX7CkBi7Ju3C/7SwpiqNgtZaf8XSPygtHu4PAp8
 l+ot2VgGsIkrdyUkPoe/5DQINRDXgBOJvQJFSddSwxA/AwO8bnc/VoMR8gnV1fdx7lJr
 2PYBOhPNdoC6ic7nF1jZ2zKG8IKuGbVgZvIfKc+W2bpkDYw8azA4GhNbrKesyCSrR6PA
 WzaSOC/Cuw1/tY41u2oGTPD1ks9Nu77VPozNuM1kh9QS8ayBbjUvijmnV+hl5I1DyxSr Vw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6pv20e32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 May 2022 10:24:56 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24LALRFP007589;
        Sat, 21 May 2022 10:24:55 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g6ph06s28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 May 2022 10:24:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8swrUG49UvAfu2s2Lp7n6WjSXpH2gzzQWwDkalfGiQ485Qouq2t6l3Od5Ctz9NKyJ4AmAYMmvrgmyOCgOrpfoxwlatw8Ae2KV2QN8jI7cUV0OXrCA6nMY290AnSkYJT9JJmhNg7nA06Bg4pjz3vjGxZ0QIRBiySWH0uuoaJp+tWwkLuqdaQrqwGESGSWJYXHQRX470YNIzVg/fzMQFAAVHz4RkvqbnlOvdxbVFOhbM3UAeGXdVdpV5phrQpf7Mn83f1/eNZyeGsg34X6QCBQYQxe/kcLbHp90jGRATm0RXaNAcbY+kdLZv9VHYAoGLimFWT81Cp71xUqOqz1wS5+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1DeIDBefkTlMntld8a9r2AOS8swbniR+hc16af5Gjf4=;
 b=Fa4Q9NbSNRVZtWClbzBW7aYiG3wPHUy2OeJ5qmyE+U93B2XUeoUWxVBotEqj6kbwW0w7ZAfE9QSfGVmNPD/t8KfTHjP/q8X9v2kx/vSdrQEG+Zn4A54Ho7qXpA7mHv5zwYcyV+NGNoLzbDeo0e11j2guDSbQJN3zPPSGbmWETDu1FQHqiHquuPjuTyhz/4YRcMkebqUYhgJLrR8GK0ghXLydV3eTjTRdGrL85/+Mg5KoJZmBiaPRE6VQ3wDqJcztU1zRcRrFWphC+EBvhrhvrMvYU3liDbSHgkkQTCJhgBIo57MQQCpCW4As9v4hWUxB+wUGLOvezDT1woxP/Jd1vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1DeIDBefkTlMntld8a9r2AOS8swbniR+hc16af5Gjf4=;
 b=t+8T9pRZEVcsv8inSaTp2dWbZ/eIogMpmtct5SdkNwwQyzjTtcLMzinFdS7Kl6ZTXr9JesTM5+s34At+lE3qZ18IU8mc7GO5+Tsu9NYlWiAL7KdWh7X5frZEyww7461FVsw1/xA/SeJTo0XfxgpHJ8PTOk3qgcgl6DDIPbiovWg=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by DM5PR1001MB2155.namprd10.prod.outlook.com (2603:10b6:4:2d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Sat, 21 May
 2022 10:24:53 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::c89:e3f5:ea4a:8d30]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::c89:e3f5:ea4a:8d30%2]) with mapi id 15.20.5273.017; Sat, 21 May 2022
 10:24:53 +0000
Message-ID: <c1a31c3f-46c0-f0a2-eb43-757914d46ac3@oracle.com>
Date:   Sat, 21 May 2022 03:24:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 2/4] vhost-vdpa: introduce STOP backend feature bit
Content-Language: en-US
To:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, martinh@xilinx.com,
        hanand@xilinx.com, dinang@xilinx.com, Eli Cohen <elic@nvidia.com>,
        lvivier@redhat.com, pabloc@xilinx.com, gautam.dawar@amd.com,
        Xie Yongji <xieyongji@bytedance.com>, habetsm.xilinx@gmail.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        tanuj.kamde@amd.com, Wu Zongyong <wuzongyong@linux.alibaba.com>,
        martinpo@xilinx.com, lulu@redhat.com, ecree.xilinx@gmail.com,
        Parav Pandit <parav@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
References: <20220520172325.980884-1-eperezma@redhat.com>
 <20220520172325.980884-3-eperezma@redhat.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20220520172325.980884-3-eperezma@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0053.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::28) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e8f4805-1e9b-4f07-a496-08da3b1424be
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2155:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB21558D5055DAE9F7B7DF56D4B1D29@DM5PR1001MB2155.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IXvLWFNK9GexK+w09Eq+Ca4JvBNKjm3ezSi9TznpUuetV/CqqPRpRiUGdZ3RMVwnQ2RvmrL0c31Cmzbrl39iOyI29tnBXtbwczWjW803xbLacT4nRCKKlES5Wf15v06wB3AMeVR/abF7Kt3vKKcuG6h05W+IRat56cq6/jphc3rd7oFHlOcm9yze9gWtEfc4ova+m5b9PsGyBFo+GN8Dba3L6o6lJ9xfgQ5g6U+8M3eJarOqAa8s5U/G4UzfBseKWBRcVI9SjV53zrkInz2j0FiEPBGCxHO3WKMUKCSXfhVsijYwR4uSBx/x4/mtSlmnCaa51zEWqEnEQTg6xbXVqwmwBKbO4rBxeqoEDAJqmDNwCvOiLy7D0u4ZvDK4sjWvNVkMApPPBf6tn0L/DFXoUzXlt8aSqBOXGcaLsuRhJJdaSOQqTRt7/2aXmbbVqMlEWIr6AtZ+sAgcf44IcQijooo2RF+EvWXVGLW2jhPdil2WUTDH4zYO91jgZlddjEbSSHX4r8Dl0XzGyIXjFhaAEJAtuojpazJNRZYctU4piLSBK9sKGNoi2v+ZVrFxZ5Z33+2ZxDh99bCHiLzg/Hcv9UIUnLKF7UJZ2yJWMMJ7SNZ0YzZ/T2Yn4yFD9PMc3faZJ06dw88kad1+l+DiFam6l3nv283q+AdOLM/DtfIb7AEPorcqlU5/4VumLDqJqyCBr7yJzZaD/RrijBH/hn2q5fuviNaIVacUjZqFyo9QyYHxe0k//1LLebtX90TQ1VWF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(316002)(36916002)(6506007)(8676002)(31696002)(54906003)(86362001)(36756003)(508600001)(66556008)(66946007)(110136005)(38100700002)(83380400001)(7416002)(2616005)(4326008)(5660300002)(186003)(8936002)(31686004)(2906002)(53546011)(26005)(6512007)(66476007)(66574015)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXhpNUFDK3h1SzJLbExFdTY0YWdGR0VqY2JiTEwzY3VMR0l3Sm1IWFJyWm4y?=
 =?utf-8?B?dmVxdmlUTzJRalFPV0RwU0hJWlcwdi85K2hGM2dudThYdmZrNW1KMndnWkZS?=
 =?utf-8?B?UWNTQ0xVNlBKdEd2anJpS0FLdjA3YytyTjB6UitVdWhMMWV3T2dDbEg0U2hi?=
 =?utf-8?B?QnVkRVNpNStOR0ZGQWVteHJsYlo1QThXa05oMTUxUjhCenVLU28xbVI4bDcx?=
 =?utf-8?B?eEU0TTVqY0tCY0dobUluTXVRdXpkTk4yd0dYSVhRTzliekpOWmUxaUg2UmZG?=
 =?utf-8?B?bkhvMkxEbnIydndXc2VpWEIwWjl1elhWb2NmSWpMSC9FWVY0ckY5OHZmdzBp?=
 =?utf-8?B?SUJFOENINkRtVjM3bm4vMEZBR0JYQmhvbjRaaDhPYzdQZnJBdzk3ZVpndkNU?=
 =?utf-8?B?MzlBNG5qdWIrWm8xWG9HT1M1VGZjd0VnUEgrbHN5bkJ0dGt5a1RsRFFhdHpQ?=
 =?utf-8?B?dzMrMmpQZEdLazF0SGtuVlNNOUlNM3F5YmRvUjdoV3ovTjl0ZFdZQS84cjRq?=
 =?utf-8?B?d0liRnRhTlVJNWRTNHV1blFxU0RvbW9DejFKL1lqK3dqME1NV3BIRWNSd09Q?=
 =?utf-8?B?RGh6all6VndaRjBFRWlFOWc0cU9JakJ5Yy9rS2xlZDhKbGdUTFVkdXhqTG05?=
 =?utf-8?B?Uk1SWURIRk13YW9MbHJaTENESVZWRFdzVDRSWGd0dmRydXpRYTJvdmhHejR1?=
 =?utf-8?B?V3FDalljWk5rZ2RPbC9OdGdoOXNFUXJGaHA5aE42YTEzdHRYRXEzTENZM0NB?=
 =?utf-8?B?dllNeXBnb1hRZXdjTjJWd1l5THFXSDFDSnQyR1ZzQ0JpaVA1QWtxVSs2WHlF?=
 =?utf-8?B?ZzNKdUNGT3VjNTRybGxNdU5vc0ZPSnpEL2hsK2pRNUREdFZ6QUtCSTZnOHA4?=
 =?utf-8?B?STB5bDZ0a3NDcEFlcDRQUXhKai9TdmVleEJZZWxhWEFsMG5FVlpSN29FNW1a?=
 =?utf-8?B?aXEremVMaVVnamJ0KzBId0lYeEFKVC9wTEFvU2x2M3BVcEpxQXdWSzVsTmRv?=
 =?utf-8?B?bEFuc3QwZ0hLRklYVXRyT1NBNlVGTkZ2Nk1yUUxjZVprYnRUZ0h1eFlhL2Z5?=
 =?utf-8?B?N1A2djFLNko4REVwc255T0ZPcDJnbHNUeVRaRUNwWkNqQmFqUUgyZFh5THha?=
 =?utf-8?B?ckl0R0Yyc1NucWtpdTJoK0ZMVURSMUR4M2lBNU5ER0F2dElMTnhNeEdCZXJk?=
 =?utf-8?B?ZkRCTG1UZ25Vb3YxcVorbnI4cFVwdHZkWUE4RHZ5YVRZVUc5dDNaVnllcWJz?=
 =?utf-8?B?RTBxMEhUTURiR25iRS93L3RqK0RuNWtMQ09VTk56eFlNdFVxL0IxSExIbFNO?=
 =?utf-8?B?bDl6U2dqaWovSHBzWmIxb0tUWXR3M2RkQjRHa0hISjhlU2ZmaDNjM0dESUI5?=
 =?utf-8?B?bFdZeURhaFhHQmRsN2lTR0ludnFuY2ZPV3E3OXNmOVhZbStJTEtpVEZidGRS?=
 =?utf-8?B?Vnk2YUQ4aFpCN2pjUFJSS3NkMHZ2Ly9VTjJFcDBnN0Y0bmc2dlp5RFhXZUVE?=
 =?utf-8?B?Y2s1c0hQRjFoYk1idDI5STc5OUtIaEF3c1RBbGRCelVhb0crUTlDSnRmZ3ls?=
 =?utf-8?B?M0x0Ti9PUzkvejNGUXNTVTBJcUY2a2RLVmZPaGJVNmdlNEdZbEtzckdqN0t4?=
 =?utf-8?B?eWRoSis5NjZWNWVmcHJFbWhJV2NhSEIxdEtBdUhtRTJ3ZStKQWcvbWgrZUR1?=
 =?utf-8?B?RjJDdzF6L1h4Q1RKeGcxbWVLbjJtVkl5YjFqL2U0NUlEdlhDUDNFeVpGSE9V?=
 =?utf-8?B?MjNYWFFxUXd4Z2xTM1JYMDhTMTR5L3NtbDVwcVQrWlh1bTlqUExJYXFiSTFE?=
 =?utf-8?B?UEtQMU9TVDgvb0hNdHpHOWh1L3VKbVVUQkVnaGE4RE1lOWF5a3VOWVJhSTBo?=
 =?utf-8?B?aXRSTEZmdUlPSHBYNUtSQ0MyRzRRWUFyRE1LVzhwQ3pWSTliam1SVTR6M3pY?=
 =?utf-8?B?enJ4RmVVNko4MVBwbm5nSEUydUsvMWU2SkNuSFQ2RS9tbXUrMjhGY1VkVFd0?=
 =?utf-8?B?KzZ2UTNUbHlEYzdCV3ZuQ1FYTlEveFJ1bTZDeVJOcjQ4TEVnRlM5akkwWlVm?=
 =?utf-8?B?dkduVFE1Y2hoZnFuU28rOCtVNGxycjV0c1BmOXQ5MmxLK2lwNUJZNkVxa2Zu?=
 =?utf-8?B?c1lLaXg3V3dobGs5TDVkSU52cE43cXU5UUFxMFNQUWVmQm9NQkVPLzg4NGp4?=
 =?utf-8?B?bk42cENsTUpEK1Q5ZW1UdXVvWjRCOVQ4Nlg0bldUeUQxbzhCVTlBRTZkaFU2?=
 =?utf-8?B?QWF2MVBTYldselF6dHlaUEpFTzlkL013N284WVZEb3JKQm1CV2hyM2xDY2Ex?=
 =?utf-8?B?VVY4NlJlV2ZKZUlPbDVvNWR4eEFSMTJRRTBydEh4OXFsWnh3M1paZTZMUVhJ?=
 =?utf-8?Q?73J2pIVU3cGy/gJY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e8f4805-1e9b-4f07-a496-08da3b1424be
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 10:24:52.9923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b4Kgvcpgfg7OBu9OD2x8x3YUAGX92ik92s/Ax+uoen183PzK1yXOeBqkkgyh3/BcZFxFLSUmkrBKq0GBfRfy7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2155
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-21_03:2022-05-20,2022-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205210063
X-Proofpoint-GUID: UnTg3cVVkXFEpohaTCzWoCSlbGW2F8FM
X-Proofpoint-ORIG-GUID: UnTg3cVVkXFEpohaTCzWoCSlbGW2F8FM
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/20/2022 10:23 AM, Eugenio Pérez wrote:
> Userland knows if it can stop the device or not by checking this feature
> bit.
>
> It's only offered if the vdpa driver backend implements the stop()
> operation callback, and try to set it if the backend does not offer that
> callback is an error.
>
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> ---
>   drivers/vhost/vdpa.c             | 13 +++++++++++++
>   include/uapi/linux/vhost_types.h |  2 ++
>   2 files changed, 15 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 1f1d1c425573..a325bc259afb 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -347,6 +347,14 @@ static long vhost_vdpa_set_config(struct vhost_vdpa *v,
>   	return 0;
>   }
>   
> +static bool vhost_vdpa_can_stop(const struct vhost_vdpa *v)
> +{
> +	struct vdpa_device *vdpa = v->vdpa;
> +	const struct vdpa_config_ops *ops = vdpa->config;
> +
> +	return ops->stop;
> +}
> +
>   static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *featurep)
>   {
>   	struct vdpa_device *vdpa = v->vdpa;
> @@ -577,6 +585,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>   			return -EFAULT;
>   		if (features & ~VHOST_VDPA_BACKEND_FEATURES)
>   			return -EOPNOTSUPP;
> +		if ((features & VHOST_BACKEND_F_STOP) &&
VHOST_BACKEND_F_STOP is not part of VHOST_VDPA_BACKEND_FEATURES. There's 
no chance for VHOST_BACKEND_F_STOP to get here.

-Siwei
> +		     !vhost_vdpa_can_stop(v))
> +			return -EOPNOTSUPP;
>   		vhost_set_backend_features(&v->vdev, features);
>   		return 0;
>   	}
> @@ -624,6 +635,8 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>   		break;
>   	case VHOST_GET_BACKEND_FEATURES:
>   		features = VHOST_VDPA_BACKEND_FEATURES;
> +		if (vhost_vdpa_can_stop(v))
> +			features |= VHOST_BACKEND_F_STOP;
>   		if (copy_to_user(featurep, &features, sizeof(features)))
>   			r = -EFAULT;
>   		break;
> diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
> index 634cee485abb..2758e665791b 100644
> --- a/include/uapi/linux/vhost_types.h
> +++ b/include/uapi/linux/vhost_types.h
> @@ -161,5 +161,7 @@ struct vhost_vdpa_iova_range {
>    * message
>    */
>   #define VHOST_BACKEND_F_IOTLB_ASID  0x3
> +/* Stop device from processing virtqueue buffers */
> +#define VHOST_BACKEND_F_STOP  0x4
>   
>   #endif

