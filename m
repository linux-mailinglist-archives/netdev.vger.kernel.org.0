Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1DB52FA95
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 12:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238675AbiEUKNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 06:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235635AbiEUKNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 06:13:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A869346B;
        Sat, 21 May 2022 03:13:45 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24L3Y7DN004684;
        Sat, 21 May 2022 10:13:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=qscWYfOqE5Go2+R5Nsp3asBo4699WTxs4pI4VEWlAQA=;
 b=kLVVzDq3SwtCM4uRWPux822jm6sYsfnG33sGLO/60+VOaOeJZCyvy0cd8kYaewhJ7Vw4
 0C88c7DJx1kmWnFKQapH3WfDaypXX0hKpwDvDp/yP3OFv9cdtH1pYuwBNAOQbm0FA1he
 xHwRJS1iYFyiUlQEjBfEHTBSjyt1KjuSOHWK8bopqDDEWTD2U5Gsa2DmDfQ8/9GCnYeR
 qBP4BBSQD/Cpw53Tuqjs6+1P8Yf2Z98zqHs7I4xQnZjiJ00H/Q7gZn+8Vc4sEp7pCzkV
 oRznUUpMfug/VyByPLXx6dD5beDI4WRRGkKO/SXSCGMQ/jYymvucsB2mzvdx7rQxJjV3 AQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6pgbge42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 May 2022 10:13:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24LAA89E013930;
        Sat, 21 May 2022 10:13:27 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g6ph5xts8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 May 2022 10:13:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fK8hWcEEcfty6L45OWBQ19qY+BilFYYuLeBBYCYf0k0LEA+UyY/tnGmz2vAOu0+9GMMaOcOF7adzrfpIByksKzGXXvA1bluBQcDEGzr/+DO4gqgh5AbR2WYVy0Fy6ggFHtp72UaeatArSY6hQWkOdLSemOyR+oKRYMSGol3E2OnafwNbEuRgdWXClDqyliQiShjOoV1uDx/EEEr2oJ6ZkeNpSkve0UeWhpHKnC1LsGLmtMAQ8Gek2MjV4lSma5wzPiHob7Ei1eo6wauQ6fStnQDdwMpqSgmzMu9+5boLsbygXUVeRwYd15Uz+sUMgITkKCERVomfW7yChQwws7swfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qscWYfOqE5Go2+R5Nsp3asBo4699WTxs4pI4VEWlAQA=;
 b=RG7e0/CalLTKu7IhScfL7A8wTm6d7xhWXejqYCzt1oioIBYjV0N79P5zCQfkfKzrn3vjiiiXrVFFdIZXns1j/SZD72Nno/F5ImW0ARe5yNMOrD4wFUNyS79s1gLw1wt3DDqjDu53Jxla1r1+m/IsQit65BVLHxqeWKoMYEfFPAQCyGwWF0+8nHWD0bU3yFH07JmsgDzKP+FkuXc7SjKDH2C3sraIFz4IAbwzywozFzReYtlPbivP6PDtFYSnd0Tf9TCHH/N4HKC1sh973p+VfE3oeK0LiBa9mU5wps+dc/vLQPS1oxMgAVmNLkaFKe2Y6rCvlaRk6DD1pBXAt3k3aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qscWYfOqE5Go2+R5Nsp3asBo4699WTxs4pI4VEWlAQA=;
 b=Qg/1jmQpA94CqcOTW355h+Va+rg1wEzqFSFMOoSpWuQDsgEYL4Qyu4ei07ZZ8xYRygF8itg/p+OQyhEqp89Qf407Mj3DIdcUIQxyAJnIcgJ9En4FlRkYKpfYVyE7b/VUzuiuADBfjTzjtdjJs35CCgJlamEI45fY/pTMGrv+NmQ=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by DS7PR10MB4896.namprd10.prod.outlook.com (2603:10b6:5:3a0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Sat, 21 May
 2022 10:13:25 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::c89:e3f5:ea4a:8d30]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::c89:e3f5:ea4a:8d30%2]) with mapi id 15.20.5273.017; Sat, 21 May 2022
 10:13:25 +0000
Message-ID: <79089dc4-07c4-369b-826c-1c6e12edcaff@oracle.com>
Date:   Sat, 21 May 2022 03:13:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 1/4] vdpa: Add stop operation
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
 <20220520172325.980884-2-eperezma@redhat.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20220520172325.980884-2-eperezma@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR16CA0005.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::18) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f667cfc5-1270-468c-f51d-08da3b128adb
X-MS-TrafficTypeDiagnostic: DS7PR10MB4896:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB4896E29AEECC8049AC0317B8B1D29@DS7PR10MB4896.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZCA/pie8XZ/CIs6LFrCPEiSwAlHBUtvJipR19TzkoRotNgfaqH7Bb1aweArnWc8DUqo38MMLxZ0AHzZSUlxG24Ia7+svCCgoAirObEas05c+hcbRXyn7XACmOWmI/2FKzg6QKdEK+JqFC6Tkqlcm0nyN0lcGsdt1reeySNFxRlbmSj3cvP2NGXG//WHjTr3ayYMxLOdjX/+vGqhoewEaFAmARBm+wKM8hIAvMyf9nsjKSxML5wuOlneZRmwhjt8U7VtNYmhD6Zs/4cVxcM3pQuwsKot8ZZzhlDBbIBY2Lhx/UR1r4ai4+1Y+JAb7Wqtck+JpnVn1aVAuZwQ9+cN81Bqmb9WaDgugi9S5FAejuIeFAopPL1HYVVWuKr3t2+U4p75SYFssEBsiXw6K7y2yoCQLKUgnD5pX0u7MlNCdpSWp/C8cBi8Tjvp7wqVfBDxPNs4dBuPG+HB72hPUCsxQbohv2SvIUXZ965mO+29ySYBpR7GLU72b5uImyRYfWSUcRZLMTtuRS3AXcMbMgFyAJI8uBh7JV8vsMBRuSvpA14LdQhqyo3otWlAkftyaM+46RjRkzu/hkhK/LZoF3iBPy5OVzgAs1+nEZCeLhoEEojDl1l7H0H25XL4i1Yj9DOKpo0qv8scQO8HSxW6DUP5uQgQFlxB4z6OCcADc99rv/OjAGA5Gir+nYY3Xa159f68HUezxWEY604v6sPq0m7caUivOcBoGqSCCOq8NvIvzczc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(66476007)(508600001)(66556008)(6486002)(7416002)(38100700002)(2906002)(26005)(4326008)(6512007)(31686004)(6506007)(53546011)(36916002)(316002)(86362001)(54906003)(8676002)(2616005)(66574015)(186003)(5660300002)(83380400001)(110136005)(8936002)(36756003)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1E4SU1iOERGNHVVcmgxV3cxNWYxVXQzTjBJZ1ptOXZ6bHJnOWozRERqb0hP?=
 =?utf-8?B?YmIrZUtoK0E0V3cwZGw0dlJjZWtXV2VqUW1pOUcxcjhETVZZT1B3ZmpCL2Yw?=
 =?utf-8?B?UDB2TlcwM1ovbWQzbjduYm5vdzVFTHVDQ1laUm1hRHlUUVFIVEQxVDgvZTBM?=
 =?utf-8?B?enVnRXluZW9IcFFuMEI3NmVtcmw5alpNeUM4VFFUY2xlb2gxbEprQ3FaYlFv?=
 =?utf-8?B?RmQ5NTdqWUplQWg4NFYxR1VqdmpFQW9KV2NuaFVreThmYUtkczFlUHdha0Rs?=
 =?utf-8?B?cGtTVVFldUZuenFMOFgwZVREcGFxVURuY2lJaE1OV2huRStJTEdlVVc4eXJv?=
 =?utf-8?B?RVRrUGZOV3FOZ1hzdWFZdTdHMGZSRWZiSjdtQ0FCZ2p2bk1MTnYwVUg4b29a?=
 =?utf-8?B?NStMWkN1ZmZnZ2tnUldPZ0xjVVEzcFZKMWkxOTRhemVuTm5nb1lSaEhhejFv?=
 =?utf-8?B?ODNxYXI3MmJETWo4dmV5NkFFR21HcTdNMmhSbW1Qb1FxeDU1VGpRMmFhcG9B?=
 =?utf-8?B?Z1VMMTA4eTBqT1Y4WWV6SkpRa05VWXpNZjN3SDRBZzBWcXV1bzNGRmdPSkxY?=
 =?utf-8?B?OFZpYmJIc09jSnYzZmQ3TDBjM1JoVFFLSmVyek85d1VaYUsyN0xtUDJFMzZp?=
 =?utf-8?B?QmlrbDJyMlp2THVxcERBTDZMMmN1REZmeUZDaERNanlnNS9saFp1cHd5czAy?=
 =?utf-8?B?MHVxNHhHNUlrTW9kdzVNQjJQUUhyTklZQWlmWjc2REloQWZySUI1aDBRSll3?=
 =?utf-8?B?R09uMkZBQXZMS0tlc3lSM2ovdnZpVmhCbXM4U1ZCV25zTTJRV3VyNVVhYWk3?=
 =?utf-8?B?OUovQUpwd2pHZ2NEcFluNGVXS0t1M2lXbHVTYVZqU0tJS0VrcURibUE1SEFP?=
 =?utf-8?B?TEVGbEUwL0hiVUQwc0dQUTlEY0tqSEFmbjZHV1EvRDdRVGc3cmc4TGRiK2I4?=
 =?utf-8?B?Z1pTN0JHcnR0UktOWHljNXRjWktaZnVvMmZoZFdVVldmai9lbWVIS2M1WTlz?=
 =?utf-8?B?U3VNeWRhd3BxS0ZkUjlET1M2UEdUTzBJcjd6K0luUmo5eTVQeHMxS0xDWlMz?=
 =?utf-8?B?Z01YWjE0RTEwU28zTmNKeTJWcFYxdyt0OHl5a3ZxZ1Jwb2NVRnZhTm5xamo0?=
 =?utf-8?B?bWR4R2xHZkRxdmpYLzUwV25WanhmZ3lCVDBKa0t5WUN5Z3BpRG1XbVZPTGQ2?=
 =?utf-8?B?OU5QUldlWXAzOW1lNDFiK3h5WkVmbjhIMm02OHhMeFZ1NzNicGtjV29JdEI1?=
 =?utf-8?B?RWNhdSsrZk9KY2pLak1DUVBuN1EvcUVhZXMxZHFnanZocDFCUlg4TXB5K3NO?=
 =?utf-8?B?NUJZQ0JzYmZOV0U0cGxZTC9BajBSZDlNTW1NVDhGczduSUI4UzBzVldXb3Aw?=
 =?utf-8?B?d09GY2MzbzkxNHhDaTNPbk1FSzRERWgvcWJUOXI1VUsxN1NMdFcxcVRGRHV1?=
 =?utf-8?B?bjdJT1lDTlc4TFhjcDR4T2dKZDIyTTFRMTBMa0pERDNtaUp2N3NRcVVsa2VD?=
 =?utf-8?B?TDZ3cTdsNFMrblpKaXlRcWRxQlVHWk9Bb25ydFBCUWNWTjVxYU96cVYzSTlQ?=
 =?utf-8?B?MFFOcGdZK1JJZlVGMVJIQkhsQjFhQitwenkvUnI1RnYwK0dlc0R4VmlNcHAx?=
 =?utf-8?B?M2ZWYlB0Sml1WGlQVWhSbzY5OEZla0l0OUJEcTR1bzJwS0EzZklDbXNaWWtu?=
 =?utf-8?B?cnZVdTBuNDNvWnEyMTRTWFh1U0ViR2VuZkJtVDRjZ1J2ZVBIQ2M5TklQRTAx?=
 =?utf-8?B?RlFsbVJhN1Y2NmcwR3lpeUk1dGhGTjBKU042MVFLZlVYYjhUR2ZUcmdmWkhM?=
 =?utf-8?B?TnJBYWh2blZ4d2orSitkVVdkdkxWenJ0OFYydkpZUTk0ZE90T0NQZDB2VlB5?=
 =?utf-8?B?WlJUdk91QWNYaGM2bkpOcVdWbHk5NFlUUWxsdDltWWNYR1UwcmpyRm1KWkVO?=
 =?utf-8?B?Y1Bjc3FweGpBSG1ybmM5RE5XK3dMM3RBam15NktMaEw5eDV0Ymw1TmNIY3lJ?=
 =?utf-8?B?ajJhWDNlamZRTnU2TzJJYUF5VG9Xd2pZTnd3NjByMWEvVUZYcTV5YTY5dmtW?=
 =?utf-8?B?ZlI2VG5kQXhoTWx4SSt3ZUN0TWZrSHlSaUxSN3Y4OUVVSU9SeXNVV1dSSDlw?=
 =?utf-8?B?SEo1TnRYQ2NXWm1PUXdEbUMyMFlmcnRINUJDR0thdjJiZm9RbmN5S0RiazhJ?=
 =?utf-8?B?QVkxZ3RKQmZzM3l4K1g4bnVGbUMxVzUxa0VIcnZ2UlFERmNCUmxGUVZqMmZr?=
 =?utf-8?B?c053SlRrT2RUZUhsNUNFZVZPKzBKdkh4dkEyS2ZXUWZTb3Y2YjJSOFFxbVB5?=
 =?utf-8?B?ZkFHNkJyWHl3R1c5TFh5QTBhTTVXbGdGd0FMeHdvQ1lCRmJGdVBVUT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f667cfc5-1270-468c-f51d-08da3b128adb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 10:13:25.3967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 69YWO+q2+LHqSQd0Tsw2C0fZq1KtOnRIHVgP1VLmQTvsq08ebJahTxpkFm/U4i1zJQTkohzhypi3U/cZsW9cIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4896
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-21_03:2022-05-20,2022-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205210062
X-Proofpoint-ORIG-GUID: 3ZK2lHW8acN80MO4fd1kTSD_GSOYxkrG
X-Proofpoint-GUID: 3ZK2lHW8acN80MO4fd1kTSD_GSOYxkrG
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
> This operation is optional: It it's not implemented, backend feature bit
> will not be exposed.
>
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> ---
>   include/linux/vdpa.h | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index 15af802d41c4..ddfebc4e1e01 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -215,6 +215,11 @@ struct vdpa_map_file {
>    * @reset:			Reset device
>    *				@vdev: vdpa device
>    *				Returns integer: success (0) or error (< 0)
> + * @stop:			Stop or resume the device (optional, but it must
> + *				be implemented if require device stop)
> + *				@vdev: vdpa device
> + *				@stop: stop (true), not stop (false)
> + *				Returns integer: success (0) or error (< 0)
Is this uAPI meant to address all use cases described in the full blown 
_F_STOP virtio spec proposal, such as:

--------------%<--------------

...... the device MUST finish any in flight
operations after the driver writes STOP.  Depending on the device, it 
can do it
in many ways as long as the driver can recover its normal operation if it
resumes the device without the need of resetting it:

- Drain and wait for the completion of all pending requests until a
   convenient avail descriptor. Ignore any other posterior descriptor.
- Return a device-specific failure for these descriptors, so the driver
   can choose to retry or to cancel them.
- Mark them as done even if they are not, if the kind of device can
   assume to lose them.
--------------%<--------------

E.g. do I assume correctly all in flight requests are flushed after 
return from this uAPI call? Or some of pending requests may be subject 
to loss or failure? How does the caller/user specify these various 
options (if there are) for device stop?

BTW, it would be nice to add the corresponding support to vdpa_sim_blk 
as well to demo the stop handling. To just show it on vdpa-sim-net IMHO 
is perhaps not so convincing.

-Siwei

>    * @get_config_size:		Get the size of the configuration space includes
>    *				fields that are conditional on feature bits.
>    *				@vdev: vdpa device
> @@ -316,6 +321,7 @@ struct vdpa_config_ops {
>   	u8 (*get_status)(struct vdpa_device *vdev);
>   	void (*set_status)(struct vdpa_device *vdev, u8 status);
>   	int (*reset)(struct vdpa_device *vdev);
> +	int (*stop)(struct vdpa_device *vdev, bool stop);
>   	size_t (*get_config_size)(struct vdpa_device *vdev);
>   	void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
>   			   void *buf, unsigned int len);

