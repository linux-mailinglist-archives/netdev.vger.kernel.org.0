Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F51E58E43F
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 02:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiHJAyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 20:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiHJAyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 20:54:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CAE7E824
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 17:54:42 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0DoDm026699;
        Wed, 10 Aug 2022 00:54:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=9kqWOKJjCJkmcv2otATOn4gKoNSekOUXkFMo7Sh+QGM=;
 b=dj4KlofyWv6/t8HVS0KEFKeLF/XYbNTInGGbls7zOJELAbj+E7O+jqleu2ps0qqS8OAo
 34n4BCgoieF1grT/GzOrd8XC+M0zm14TCqX5jH6L23n2s3V1OZ5DbxwWtaB2w6GfsJYl
 z2gyKVtx1L2r9v2WCAH+92LwLUy02FT7YaQk90gK9UPC2MVIqVNdL6DphC4VjtI8IHA4
 R+6x7+epvxsj+eAMG2z5qF3D1GFldxtffgU7GpDtQfTP4FbobELSEL0t9qp8H1liw/tS
 K0PijuyMJCPVpxVORrZcIqbY4H1Tved6MLc65oNENALja+EMBUPk8wzFXQ8GKzrdGbIJ RQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwq90htt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 00:54:27 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0BvJt038374;
        Wed, 10 Aug 2022 00:54:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqh6d0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 00:54:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kw5QI6a3GPy8XXo2YNmIb92AvmsC15NuK+BziMjexg4GSlohgF+2EuBRob9fXyImV/Nj9bJXOLgSW5qGtIgq93wHkUPYCAfI7Ls1Kalosoa7J/V6WOeIopMQLFC/lihc0CVwOKU0aOGOORsAilt5yax16pcYwqwqWlKY0VWbLZNQTgPPbSRLF8J8Br7BbmGd1l+TtS+Rwlv0Evsxi8JTtT6RffnyuEDrtXBJ9bJbhmxRf5m33ka+WhbBnFdAF36HI6oaWyltXeYN2xJhWbB6cla7MoF9RPL7LOn0QDO+jXBjxi9prALWgSd/AJzi6f952RieBut7KKJM1+SaJ0r+xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9kqWOKJjCJkmcv2otATOn4gKoNSekOUXkFMo7Sh+QGM=;
 b=UDEhNiuAObci2pTZ6ffKjtJMk5q09sNN/xOcsvqIAMErR6SXzns2G/wuv1Hu6BelXdR9iL+AKzW/7v8UglfQ46oQiVoARhTQY7aciCElkJh8iFIHbFr0BBFG391L8sWgo49ZesnDimUlE691RDKMbzV3sjSOaJE00fIrLDwLka6QiwkqD7W1/M4QFxgpRknJ8MfHUj2501oFIzvXbljA9W8hHqRKJ75DHxaBFxVyWPpmYSHaJvow4+LpHQbIdbgVqGKLXCtTogaoz/PUSFbCrKRec+6ijPqpWhDOADJR6S6SuUjRqaAZXfmnQ1dzJAjT1VWV1TVdiitlq4qFzJp4bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9kqWOKJjCJkmcv2otATOn4gKoNSekOUXkFMo7Sh+QGM=;
 b=mp1QrEWagFomGMyU20xNEoC3PfM/kGLXM0RhvVw8f02eVaCq93GN+AFkgnqpkDiBhX4/uoDOT1UldJkjuYrMA1QQXjiRcR+OLfAuf3Ws6+3omWbFs+CSAR3oHgDEam4g231vTfwKThzCjF5sa1AoMhFeGaCmLKtNxc9GH9a/cE8=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by SJ0PR10MB5616.namprd10.prod.outlook.com (2603:10b6:a03:3dd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Wed, 10 Aug
 2022 00:54:24 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649%7]) with mapi id 15.20.5525.010; Wed, 10 Aug 2022
 00:54:24 +0000
Message-ID: <42e6d45b-4fba-1c8e-1726-3f082dd7a629@oracle.com>
Date:   Tue, 9 Aug 2022 17:54:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V4 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
References: <20220722115309.82746-1-lingshan.zhu@intel.com>
 <20220722115309.82746-6-lingshan.zhu@intel.com>
 <PH0PR12MB5481AC83A7C7B0320D6FB44CDC909@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220809152457-mutt-send-email-mst@kernel.org>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20220809152457-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0011.namprd04.prod.outlook.com
 (2603:10b6:a03:40::24) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 722133c2-4039-442f-b31b-08da7a6ade67
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5616:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1kfUgOS2Og450UudTuQnmJbaSoK3jZS1LunAS1STUCMnY4iHP4eBqalWP+NmOSBaLuedZZ+XCj313USu/IL2zKFIM29WK1GCMNO9blKNqvfEKqNQVAAzP9lxFdnskSZkUrMWQUJc7L/G6/J7hbHnhnez71GR5LG0ipRQ8eqHUAu4+JmVYGlgFXzI/222Z7tkWppL9hSmCbCjTCZ9C4x4GcNxUmV8o9URDYWNwAHIhqqjx692PqxlsdmCmifRXvYadLozK3a/qJUE5GtSJXMpBHyl03UnND5pY/T4uf3B+8+DVg3NpJo9pMP/XuawaUNULOgPsJkwuXCqlSZoD/663sQat2mklCUmjmXGHt0RdjtOlWh3tSLZcMV0DQCXnEQgaqsQOJ8ZIxty5PSIJ5pd2xU6/bhX9UJud2V+Rzkpiz6jMpsigov4zhjF+De1Soi60OdDUytKzqOfFNzTxdKZHEKw7sz9sIBLoANmtIs/kInCw5UwqJ+puqklO6VkT0TafcuTf6D4hjqcR6R6y3opGghQRoXN/TkIA5TxshSa9otP7ZXn7hu8jnxVTYkVFK8BLkCpwsMwfYk1j2Mf3inWCSp1ramnVjaRsJT1e14q3M9aSVFj+7sjhNtAfBvjExS+TikhZndAZeNW0dl1TzH8ERXZzQUFO7U9n6QQFYrXEoDpKlsmrlbRxtYIsLxedQGp4z8qSBwGfzuUsHdRS2f/slU+OszwtN5QlNguqjZmQSREU3nGFgTYuKZiLAbRiL/IiHqezD0RaGRLqy507BjEL+sVTrX3BAI+WVNyG8gfvs/VucXqL0ZHikOFHZ1dwm3f/zv/82t8gUEZ3xRfcdiQKn6bzJtyVICkPSwKxsmtWWU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(136003)(366004)(376002)(396003)(186003)(83380400001)(53546011)(8936002)(2616005)(31686004)(38100700002)(478600001)(316002)(36756003)(36916002)(6486002)(110136005)(66556008)(54906003)(5660300002)(66946007)(8676002)(4326008)(66476007)(6666004)(41300700001)(26005)(6512007)(6506007)(86362001)(31696002)(2906002)(966005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NjdMRkhqbktwNDkvemxER3hLZU5wVkJjVUhJb1JzYjFXZkdxaDByYmtYZUk5?=
 =?utf-8?B?R0JYejk1MXoyMTlIaDllc3RNRUFlZm5SMEZhaWNCaVZTK3A0WVFERmN1QVZq?=
 =?utf-8?B?d1R1bktuczFnOG5CWHVFZ1BqektOcU9KODVQVHdFUFpIYmd1WDV3bjloaHVX?=
 =?utf-8?B?ekYxVnBMek1oZEp6ZUk5L0dPTW82NWNZT01PRkRDakpNR01FaVBYMTI4SW9z?=
 =?utf-8?B?RTB2M3o3UndONnB5MmNsTHhGV3Q3TzMyOTZqemsxVHg1bWpHc25IcWp1eUsy?=
 =?utf-8?B?NGU4bFRIc1BTN1Fid0s3ZkZYZ3E5OHlBdU1kdjJQZ0J4ajJWMGZKTlo5V3F4?=
 =?utf-8?B?bGJFUmNQYjR4dVBpR3JiT240M3Y4QWRrVFl0U1BnR1o1a011QkFLLzBzQm9q?=
 =?utf-8?B?dkUvNkR2UFMrZzFaaURLQVU0Ri9rVmFzd3ZNUWRmVkl3NVkyTjUyYVZEZEZQ?=
 =?utf-8?B?eDJzV2lzWHJuSGxVVkhhU1JDalZNMDdVMjN4ck44NlIrTnM4UVo2cTRORWxv?=
 =?utf-8?B?a2IvKzFWTmI4Q29qUWhPMjJWSlhsUzduM2JYMjI4T2JhT2tSZUZ3WkJPSFNw?=
 =?utf-8?B?bnZlN1lJVWtQeFBFZ2RURjloRzdla1kySTlOMy85ZlA0OXNKL0wwWDZ5eXZa?=
 =?utf-8?B?TlNMSG5ndEp1RnRLWkN0SisyVmcvc3Yrd0cxV0hmOE1JZDZUUFg2RndDSks5?=
 =?utf-8?B?T3FLbVJRSWsrMzlTNVNmWnlYSWxvdnFjU1BLd09kSUQycWhMdWdIdDI2dWdV?=
 =?utf-8?B?YzNiWUh6VkorUkF1OW5YSXJxcUdjaUdSMmkzQnQ1RUVidCttVW5mSzVGSi9Z?=
 =?utf-8?B?OWw2cFNLRUF3NHVWYjVHSG9Hc1p1YUJtVFhWUWdERk9aSDBoWTVMZHI0OHh1?=
 =?utf-8?B?RlJ4TXRUemxoaFpGUkNUK1JXUUN5UlFqUG95YisrcTRoT0ZlVThWOEdRQkgw?=
 =?utf-8?B?K05BYUVOeXlyV2tDZ1NyZGdQZCswRnBXWVFNdmZoMWFMTzJqR2NLS3ZYYlA2?=
 =?utf-8?B?L0Q2N2lvTGc5SUJjQXRtcm5jRTF0UGJOR1FaRmhhWFBxMlkrZ3BXaHhML2tD?=
 =?utf-8?B?QjQ4algzc0lrcmRnMDJUUVVqVEJBZGFkL0hlMGl5Ym0zWTNwWWI5clU3ajl4?=
 =?utf-8?B?U0lPb3g4VGNUcU5NWjNDbFNDMy9mdFUrMGxKMWRYZWVXY2J2cXJaRThMWCs2?=
 =?utf-8?B?RzR4NWNVOEkrTnpKMmd3bUJqaTJzUE04L3c5U1hPOGk3SnovNkVzSUVlODda?=
 =?utf-8?B?ZmxKQXllazNoTG4zOEtPR2ZQM0gvY1pTOVNoM2tZV3ovT2o2UG01MDFrMVVa?=
 =?utf-8?B?OFYvVVJSNmZrK3ZtQUIrOEdHQitaUkZKWjdVSjBvNEkyNlZEQTNRWXp1ZXIz?=
 =?utf-8?B?TGxXeHRWc2NWeTRJQmNiSk9kUmg4WFdsNktweHpSRlNKcngzelFEcXVuYUUr?=
 =?utf-8?B?YWl6ZjhRMlVSaXJYV3RWSDEvUXVhWksvblNTSy9jSXQxMDNGMVBpVU96TlA3?=
 =?utf-8?B?OTR2eloxRm01WWErSHg0SlBmREphWW44dUtPYW15Z0xGL2hES2RPVHY0QnpS?=
 =?utf-8?B?UWFxcUhQRjk5d1RVL3JTUHdwWldMTlNLdTVSVkk0MWNNZzlKQkpSMjYzei9D?=
 =?utf-8?B?cktMQXArMHRwd21QeWw0NHdTdHRuM3h5TnNINHd0anc4aFZmR2gybnlOVjNv?=
 =?utf-8?B?MzFrMDVDTkZ6UE9WSmt1RTZTRmE3S2FHdDY4MDRHU0M1eTlWcjdnb3ZJcmtq?=
 =?utf-8?B?cGxIQ1ZOb3E3MXVWMHd4cmZzUnZueUJnajM0VEVSMFlPYXo2YnRwdXJVZXZX?=
 =?utf-8?B?dllFcC9UR1M2WHdHT3BvOTdtN3FJUG1kUExvUWYxcGN3b2dwdzc2S0MzYXY3?=
 =?utf-8?B?Z1NGT3kzQm9GdFJtTmo4ZXd2SUZYdXZsVkpUR0IrN0k4a1FTSCtKbFRZZ1pt?=
 =?utf-8?B?d0kwaEJoa08rY2NvZlRRUkdValRDOEVoaFBzYWN2MGJGZHRhZTNKQWtnRGtS?=
 =?utf-8?B?ODN2T2RjSVRqRUZ0cHNtNDhrWHlUczZJdmVhNERrU0dESWpYbGEyWGF3M0lU?=
 =?utf-8?B?RUpYY2ltWlV4V1p3YmtNcitZemRiOTdSaHJ6NXBXUjFPOHBVWlRoZ08rNk10?=
 =?utf-8?Q?bdi7eJzgic3yaWV7+KF76JFtD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 722133c2-4039-442f-b31b-08da7a6ade67
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 00:54:24.4837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2YpSb9r+Er8LHp93orxspAxXnF18tqOeAUxbKNe8Ymckb4h7I5UbO+Rb4qRZY9xAgK215LFFsvW1HYWm/qeFow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-09_05,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100001
X-Proofpoint-GUID: EsRPezdREO-ew2JNF9kuIygxX5pMaSZv
X-Proofpoint-ORIG-GUID: EsRPezdREO-ew2JNF9kuIygxX5pMaSZv
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/9/2022 12:36 PM, Michael S. Tsirkin wrote:
> On Fri, Jul 22, 2022 at 01:14:42PM +0000, Parav Pandit wrote:
>>
>>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>>> Sent: Friday, July 22, 2022 7:53 AM
>>>
>>> If VIRTIO_NET_F_MQ == 0, the virtio device should have one queue pair, so
>>> when userspace querying queue pair numbers, it should return mq=1 than
>>> zero.
>>>
>>> Function vdpa_dev_net_config_fill() fills the attributions of the vDPA
>>> devices, so that it should call vdpa_dev_net_mq_config_fill() so the
>>> parameter in vdpa_dev_net_mq_config_fill() should be feature_device than
>>> feature_driver for the vDPA devices themselves
>>>
>>> Before this change, when MQ = 0, iproute2 output:
>>> $vdpa dev config show vdpa0
>>> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 0
>>> mtu 1500
>>>
>>> After applying this commit, when MQ = 0, iproute2 output:
>>> $vdpa dev config show vdpa0
>>> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 1
>>> mtu 1500
>>>
>> No. We do not want to diverge returning values of config space for fields which are not present as discussed in previous versions.
>> Please drop this patch.
>> Nack on this patch.
> Wrt this patch as far as I'm concerned you guys are bikeshedding.
>
> Parav generally don't send nacks please they are not helpful.
>
> Zhu Lingshan please always address comments in some way.  E.g. refer to
> them in the commit log explaining the motivation and the alternatives.
> I know you don't agree with Parav but ghosting isn't nice.
>
> I still feel what we should have done is
> not return a value, as long as we do return it we might
> as well return something reasonable, not 0.
Maybe I missed something but I don't get this, when VIRTIO_NET_F_MQ is 
not negotiated, the VDPA_ATTR_DEV_NET_CFG_MAX_VQP attribute is simply 
not there, but userspace (iproute) mistakenly puts a zero value there. 
This is a pattern every tool in iproute follows consistently by large. I 
don't get why kernel has to return something without seeing a very 
convincing use case?

Not to mention spec doesn't give us explicit definition for when the 
field in config space becomes valid and/or the default value at first 
sights as part of feature negotiation. If we want to stick to the model 
Lingshan proposed, maybe fix the spec first then get back on the details?

-Siwei

>
> And I like it that this fixes sparse warning actually:
> max_virtqueue_pairs it tagged as __virtio, not __le.
>
> However, I am worried there is another bug here:
> this is checking driver features. But really max vqs
> should not depend on that, it depends on device
> features, no?
>
>
>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> ---
>>>   drivers/vdpa/vdpa.c | 7 ++++---
>>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
>>> d76b22b2f7ae..846dd37f3549 100644
>>> --- a/drivers/vdpa/vdpa.c
>>> +++ b/drivers/vdpa/vdpa.c
>>> @@ -806,9 +806,10 @@ static int vdpa_dev_net_mq_config_fill(struct
>>> vdpa_device *vdev,
>>>   	u16 val_u16;
>>>
>>>   	if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0)
>>> -		return 0;
>>> +		val_u16 = 1;
>>> +	else
>>> +		val_u16 = __virtio16_to_cpu(true, config-
>>>> max_virtqueue_pairs);
>>> -	val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
>>>   	return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP,
>>> val_u16);  }
>>>
>>> @@ -842,7 +843,7 @@ static int vdpa_dev_net_config_fill(struct
>>> vdpa_device *vdev, struct sk_buff *ms
>>>   			      VDPA_ATTR_PAD))
>>>   		return -EMSGSIZE;
>>>
>>> -	return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver,
>>> &config);
>>> +	return vdpa_dev_net_mq_config_fill(vdev, msg, features_device,
>>> +&config);
>>>   }
>>>
>>>   static int
>>> --
>>> 2.31.1
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization

