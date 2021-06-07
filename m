Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B63739DFF0
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 17:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhFGPGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 11:06:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29726 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230226AbhFGPGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 11:06:14 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 157ExgW4004745;
        Mon, 7 Jun 2021 08:04:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Pta+f7h55oeKQoGATYfXmDcbv7CoW0g3RFVVnZ16hGw=;
 b=IbgfoquuINSqXWWMuRlSAqPQwYvHXaVgKzWj+4gMhOtQa+nB8LtO4KmMRJu25fgK8lto
 k1ahq9SunBR+zOBhVRfFj1EF10XrR7Ue5ElyRxYc+ae5p7/LjeblU+v3LZC915fSaj43
 VVIBJuGRwSjMy9eLnjbiHnKAgXCuR6KL78Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 39073usar8-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 07 Jun 2021 08:04:07 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 08:04:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GWwEd5TYgS1irBc+fBZlDWSngRwDRinycYHfKWU6aV8LWQD98FmNqF41ShpkNS+OjybUNfuCVUl2MNbHqGvM1QssXK61Ve1jqAf6/+t2mbn5437jDwbQJrYY3YijJbWr6ZOXV99jIQWAYrqOLzhLgwvDTpR7V/WVHyz6extH89H/YXEYTjgc9rKrK2jcY5XKhIFdW92HrhdCAVFD4M3zhiPJNio/gMJYPnmMh3CuqIM5Rd2zVaBDqqRESlnZI9gTAp4q7O49SHGdJUd1h6nJqUMzLBscbflyVJ+lgO0ww7zHjK8QkdKntGFyZal+bdbKg4xu4sCVmzrlKy3c/FkoWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pta+f7h55oeKQoGATYfXmDcbv7CoW0g3RFVVnZ16hGw=;
 b=kZBwJTiHfDeUEUUr5XxrqaKh5iGjGCo35jOFgnnexaPxOD1lvAvE/yLtJEkedWc0WTyp0bgmWAJdoqEUQI6qBIQ7URk2s0kNd7MCSEt3/9U3rfV2KhdDw5W8N8Wc+FIofJ0tDVXTD74HLjy0ETET7QDyjqkwDSglRXlnna5r4ZwFQ2cgNxRAQ3QYkU7iIx4jJ0qab5dNCb98joW+RhgKF5p21azENAiCNSYCE87kYW9/GHdCOxUX6tvA0i75WWO3flBZerSkzsGSaR1isRGteo63SHsbLtad1Y3QT2B5EIUC+gcnAUebyxWxcCPWWYmvNxAb7IiaS6dKATMtnGmAIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2461.namprd15.prod.outlook.com (2603:10b6:805:24::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Mon, 7 Jun
 2021 15:04:03 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 15:04:03 +0000
Subject: Re: [PATCH] libbpf: Fixes incorrect rx_ring_setup_done
To:     Kev Jackson <foamdino@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <YL4aU4f3Aaik7CN0@linux-dev>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <39e483bc-6aa5-7ee2-1aed-ad0844b30146@fb.com>
Date:   Mon, 7 Jun 2021 08:04:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <YL4aU4f3Aaik7CN0@linux-dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:db22]
X-ClientProxiedBy: BY3PR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:a03:254::23) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1097] (2620:10d:c090:400::5:db22) by BY3PR05CA0018.namprd05.prod.outlook.com (2603:10b6:a03:254::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.12 via Frontend Transport; Mon, 7 Jun 2021 15:04:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f83a681-e687-4375-cd48-08d929c57cf1
X-MS-TrafficTypeDiagnostic: SN6PR15MB2461:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB24617C1F9DA665D18C382E23D3389@SN6PR15MB2461.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1xbe685jN7GNZn2V+mXAigiV+dIXJAK/+FAyCo0jVjeJRBTloQdAGHwaTRNgGX89O2YHQv/SEm1S8Hj/AcGbPTKkG6hr2VuDE+1aMZQTbtjyQKShiz1ZGs6bpSzBVQ1LjoERB0KUs8VRAb4wLQ3yAdSBkYnIzYrmuczaKFgoAfKuJxHB2YvWs+4St2966r+88BnuZnScpZKBIrU6DouzEILyfyZQnM9Wz+LEWN7zJXztSnhqqom6s5Lqe15CizI7zYWx1gYNOnpXKDhKY72sG0f3x56DRgQr2uoyXAJ3ijKv9rcBI78FEu8q0uWf6gIgnE0dmDx2mFtpyNwlLtmraUgithbHhs7Oe267qRFqyoRaveKqvU4dmJard3mpH5kVHpTXzhLkC+gdqu+nU5HHGHIKGtXFAAa0JSPIzf0adXrNochlinE3a4JJo99xZeOo4zpSGbf9x0szqCyDYOVOiD5YQfiDXWDWw0SqHoxuegVl0TF7FXFUdgz8XmHnBzUNfnlEna41wsBW9UElU7KX2WZ/Wy3Ulgn8NB6rSeBR0iyGhf3BPTxYG58IYjQM8TdW7/eCwo8PndyjSFXMX7T7g1m84pQHVc1u5eet4fR1dHXLkVissQhK28568H8TQRUiuRjNsdo+kVYgn0N06LPpDGiy7riHvNMpLKoMEuo56z42ILz24P+kiA2wv9RnCcmZsuM9p2dG/wL1HSsJ+4xR9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(396003)(346002)(8676002)(8936002)(316002)(2616005)(52116002)(4744005)(31686004)(83380400001)(36756003)(186003)(921005)(16526019)(110136005)(53546011)(4326008)(66946007)(86362001)(66476007)(66556008)(31696002)(2906002)(7416002)(5660300002)(38100700002)(6486002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d3NLZy9ZcTZuNVFrTlFJU2djS0YvaFVDZFc0S3I4Z0NITHY3MCtBOE9LN2U0?=
 =?utf-8?B?THFHK3VGV2loV2xHMkQyQzJ5M2NNWjMzSFc5Sjkzc3VuaFVpd21rOHl3T2FW?=
 =?utf-8?B?OGsxVUlTL2xON3orT0s5UlR5R0wvdU9QVGpZL3NQQndQb3AzVXNVS3NVVkdR?=
 =?utf-8?B?QXNaWi8walVXMEk3T2gxR2tSRWVMYmJEWUJjdlZ5azdHSy9wajJCaExQTFcr?=
 =?utf-8?B?dllVazlJdVBWUkc3eXRTTUhCekN4V1JZS010ZTNncWMwSzNTZXlqd0pqcWVF?=
 =?utf-8?B?RkQyaWphUHpDWXhmdDB1ckFucTVCSGl4RHAzVlg2Y2dSQWw0WnUwNXNPd0JD?=
 =?utf-8?B?akVpTjVrRWsrLzJvcUE5c3V6VTAvMkYyU0VXZk9jdE9OVHQ2UFcyVStDNlRq?=
 =?utf-8?B?ZWZZQmxIelh2aEp3YzhMbVZrWjRDSGRqSkExMWlBTHBXQUk0NFE2NWEvcnhp?=
 =?utf-8?B?T1Z2Y3VKZExBWnQrd1dRZkQ1RWJPR2JyN3RCVU9vZ2h2OFM0QWY1VU1rdDV6?=
 =?utf-8?B?dGVXSmp6NEl5b0RaRXBKOVhkemlPVVJ6ZFRDMUM3S2haR053VGJRVjFoaHBi?=
 =?utf-8?B?Z1ZodDUranNnSCtTNTlHSkh2WXlxWk9RM3FqWk52ZkJIa3U0Mnp0MUl6aEZi?=
 =?utf-8?B?azIxVXJyWDVVa1lyam9WZmx4WkswTTNVUUFSd3RUSC9RQ2xxV21jbS9YcHg4?=
 =?utf-8?B?bXRRVC9xQy9iR1U1ek9sN1N1b2llUjJXbjlKaDhTQ0xxdVhUOGdvWkRCbFVp?=
 =?utf-8?B?ZExxSGpjcDVqcWlDY0krY0NPMlh5Nk9FcDNuSTEyUnZpbXlneFQ3Zmk3Rk9k?=
 =?utf-8?B?SDZuNHRSdFVxV2lUTmc0c3UzcnJ4dFE0OFV5QkZkWG1RT1g5M0hvT3l2UXU0?=
 =?utf-8?B?ejFDMzBBZldTd2JnSlFkZlUwa1czdEI0OXEzMFYvMVJGYld1TE5ncDBYV2xX?=
 =?utf-8?B?V3cwL1JBdHdLNWFDUnhxZ1NBbXV5TVQrQ0NsQVNpejJ2R0pPZ1c2TGFVWmJj?=
 =?utf-8?B?NEJYLzA5OGN4Z3pjSjlkT3R6Z2o2RzZhZFI2aStMaGZDbUsxUHNmbk1TRFpr?=
 =?utf-8?B?MEtiODFvb2oveEsxOEJkajNUOG45QnJhWU9lTnlwbFlUWWhXUkNaSVNQWkpU?=
 =?utf-8?B?S0JZakRwNDEwbkNCM0hLd25hQ2xJZTBHY3BvVEZUWEtzNEI5ZE9YV1ZIbkM2?=
 =?utf-8?B?QnBKQ0NoeW1zNnNXaUZ1UnRRQ3Jvd2Vyd3plUi9FYjJ1aWxOVFpGc1dSRUhu?=
 =?utf-8?B?ZHZxOXZaNlhlUHk4dmRlMFpHLzZEVEZRTHhuZCtEVUFnallUamNEMExNSjR5?=
 =?utf-8?B?VGpHY0Z0bWlsM0ZuWC9MTVdXaVF2N1VFbnZmcGxtdWRoSktLNGUxWnZoYzBX?=
 =?utf-8?B?S3d4cjdRYTNzZ3BNTlJkbzJMK1FvVzVWU2tjc0xHbHMvc0NUMWJ4SkJxWkRp?=
 =?utf-8?B?ZHBkcDlaQzY2U2RZNG9LQ1duNkVKRk1rZ0JvWDUrZEpEanJKQys0SDd1dkEw?=
 =?utf-8?B?KzU1RFp3QmV0NW5OTUdqS1E0VGM1ejVMTGZmWFpTcnhBRnYvTG9sckV2Z2lX?=
 =?utf-8?B?NGRqTk9sbGo3TGQ1UzdUZksrbzZXMVlHMXBvUDVmK0VDd1pKWVNTc2ppL0du?=
 =?utf-8?B?dkNUU0oyeXRoMHlFTlVDNDJQcEhxYlpVdSsvWlgwSmhYZVprYnVxK0ZkMnhE?=
 =?utf-8?B?L2MzeDlLVHZ4SFFZWDRXNitLelczSTdGaVBvTU1sdXAxQlo4T2J4dEpMY1lz?=
 =?utf-8?B?ZjJ6czBVRzNIQTlXZmFsQjhWdUluS2ZodVRkbGRHZWdGNE50MGpldEI5aVQ2?=
 =?utf-8?Q?OikwGwdZkFV24gZACQ52AmYJNpwivza1ArZj8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f83a681-e687-4375-cd48-08d929c57cf1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 15:04:03.2112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GpnKBF6xXxrMoLPrWzs1UaSfSaMFRdi+Dhkv/OPS/raIHtOXyNMD8xUi4/+LZ3PF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2461
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: iISFb6858_n7LfdcaC0OxVMgbPPjaBUW
X-Proofpoint-GUID: iISFb6858_n7LfdcaC0OxVMgbPPjaBUW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-07_11:2021-06-04,2021-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=999 priorityscore=1501 suspectscore=0 spamscore=0
 impostorscore=0 malwarescore=0 adultscore=0 mlxscore=0 clxscore=1011
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106070109
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/21 6:08 AM, Kev Jackson wrote:
> When calling xsk_socket__create_shared(), the logic at line 1097 marks a
> boolean flag true within the xsk_umem structure to track setup progress
> in order to support multiple calls to the function.  However, instead of
> marking umem->tx_ring_setup_done, the code incorrectly sets
> umem->rx_ring_setup_done.  This leads to improper behaviour when
> creating and destroying xsk and umem structures.
> 
> Multiple calls to this function is documented as supported.
> 
> Signed-off-by: Kev Jackson <foamdino@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>
