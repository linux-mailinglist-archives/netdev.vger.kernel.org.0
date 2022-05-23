Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB93531F75
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 01:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiEWXzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 19:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiEWXzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 19:55:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375C253E30;
        Mon, 23 May 2022 16:55:13 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NMiBf0009700;
        Mon, 23 May 2022 23:54:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=iYDKCdbHOgcCBiIQxLpumkSHcWtQlp/pvSVdwC+ByKM=;
 b=lMgAGZPx+MbMkm18s4+VpA/7McyjSs1VB/PG9KxwRAtfzvd1LhfoNl5fUNUBZeniW+ud
 4NxaISuVqaZaom3xMcGnmPh9C3Xo2b6GISg6tzEYw8l03MJ6wf8ATXKvPjR/HdLdPD2P
 JC/K2lzUmRQqCmO4lTbSNw01H3iuV3em21dy51kpGR1E9FuQv+LLYe5hUusEMOZ5d9Cd
 U2XDIthhQ3eVEllPy59HzcUXXYYG9yruW2kldZg+aXyk+0Wq5jilF6+XXJ5bCp6N45m5
 JJyj2If5qJzMVWRQawLbIKHz8AcodVvY1dFmPtWBXa1phsC0O2NtN7oUUJbtBzyjNaub kQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6pp04uqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 23:54:54 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24NNkRdt010379;
        Mon, 23 May 2022 23:54:52 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g6ph7s3sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 23:54:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SQhJ7MqCM5sRTpXyVvVQihXA1V38Dn5TMfEYqm9ZXGU+BZzJQJKYwoUVRUXM0ktIXIRj+ZybmpG+tGVfEn7pV4uhqCfpAHz+0uUh3v4fWzdm+Lz5XHvilz97Gk4mqe8FObf3ZlKOfMn3FQspn0U/Ky40CLLR5WirXlrEwR8dJVjbBiTiaQPjrz+ph2FpovNtUYUjq4mntXNyKLin6Z73kneGbQsvhi92tmvbsuib7+aPQfG5HNVZ78lhn2gHdoHr6m1uFFeMhZ+BM7NkyNRMYNqFEvRwzFt1Zd/lPScvoxDnjn95/61VcExI3DGOVz+p0Bj88XbseYqMfbjTPFKocw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iYDKCdbHOgcCBiIQxLpumkSHcWtQlp/pvSVdwC+ByKM=;
 b=gTBpItgu2hVgElgwnHdCWqnUPCf/EYKzcv4ta1K2H9rgiET8gfqeJhNetmyVbLi9vxVrmxCm6X9e0772dC5Rac3r5Z9UzOWxccNDvJ/eRmkgyZAdQ3cdmBRxgrYbtMwqia/c7ICIU+fUuarUEVFGnydoPgNQ6GKexHKZHn1p3T0+ilm6/0wFRXoeqWXVYQ/K3DLjZlPdmZsGzg04lFArCtL3Gs1XmtMc9DfnzHDKUwKSHD8mH9gcvMbz8PLnEf0K0625uBk0hbwVzOJf7qTi7iPIDmW3qO/GiKqNK9b5MHWZZZmbSletB4p2SeuWLWS4oW8zrLrgyuamp8/cmEMAwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iYDKCdbHOgcCBiIQxLpumkSHcWtQlp/pvSVdwC+ByKM=;
 b=TTQgETCeGrBZRsfsfYe0Zon+jfLaGgAqllQAsWCGZtcCFcscclpHVYWWBYPpCReHg22IrZN6XvDq9ILNeHtu6SBBpxdpFE4LEcJiHesx2kG5EhMLY2tMxB+lZTI+n+vvGATynRHN/8jb/9jo26b87UH1DLWdVdLkRNujWnqNrBc=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by MWHPR10MB1856.namprd10.prod.outlook.com (2603:10b6:300:10e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.18; Mon, 23 May
 2022 23:54:50 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::c89:e3f5:ea4a:8d30]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::c89:e3f5:ea4a:8d30%2]) with mapi id 15.20.5273.023; Mon, 23 May 2022
 23:54:49 +0000
Message-ID: <4de97962-cf7e-c334-5874-ba739270c705@oracle.com>
Date:   Mon, 23 May 2022 16:54:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 1/4] vdpa: Add stop operation
Content-Language: en-US
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
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CAJaqyWd3BqZfmJv+eBYOGRwNz3OhNKjvHPiFOafSjzAnRMA_tQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR1PR80CA0003.lamprd80.prod.outlook.com
 (2603:10d6:200:21::13) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d46f06e7-1c5b-40da-90d8-08da3d179f70
X-MS-TrafficTypeDiagnostic: MWHPR10MB1856:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1856F4C448B16AC7F48CAF50B1D49@MWHPR10MB1856.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jhmdrJX04bistXXC8l49pbUQvpPpxIyvUYBiU21tYuvQBLVB9vUjX+WkthVeRT18IQ2hxxFMwvfvvkMcZ6j0tbWxzAlrZ8byiQQZcF0NrWGWfMQ1RBH6tL1MR3tSq93PhyLYpBNaaicBKPRSBEj0qZGKoG1lAQ6ev5wzWRUEzRUr3OaFml1SARgENN8Bwb8EOA3hlnrU6xdq3KBxGd1GY5LPhNbT3NRumuBbE7XecgViVcO/CyWTQ3J3YOLTbdrAqLAKAYXoygAxU9+QcBHbXdu6m2gGHkMJD/DOQUMyQiABOYKVaoQVRT2JN7Y0ou5JY4OGP8zufqiD/a9Gtt9/omDPrVnyMeZANH9JkmZxQb8jUuQxgJOjQvYR3S7kjZ6dic/8EzpxTXvHIEzcOoWWGJpx9dJBDm0fNOBx5TIGaMr8XTMaNZJ9ucCY/IJRYKisGoNs9pAMgWjg0UcLgCEOCPwlt6nxnCHQrrcYce0e3PZBVoTSj7/VWhXI1WLlUyuNt7IyE+ud6rKRKL9NwA1azm6SHYXdN3nvRbt+rxnRl9bMhdSvfUIeqwG40AEpR3+wx64hUOqgWEjklFQ42itudIOxUmA8C7mcfnjlj+0fI1tDws7Q6gl8ONfrD9u22A4RAGgkHY3mRpTrEbslStlYPm0inHTAjzqpiPrAcQK3YoJJ5hv8/I+M8o3CChT6WZbe3ngC6DScPd+XZi1HmwAxsXBP4AWTIF/Y9maz2HXU6EkDpzwIDkHcZAJ+K8qPHoTu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(86362001)(31696002)(4326008)(66556008)(8676002)(66946007)(2906002)(8936002)(5660300002)(316002)(26005)(6512007)(31686004)(7416002)(2616005)(53546011)(38100700002)(508600001)(54906003)(6506007)(6916009)(6666004)(36916002)(66574015)(36756003)(83380400001)(6486002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEFaVWNEYmdmN2FWT2lrbDNoWEpETmdkc3l4UGJJazdOM0JjMEFxT3lVMjBk?=
 =?utf-8?B?ekFqNHd4U3k4THVyUjF6ck1xYXc5NnlLQlNRdlM4L2s3b3VLK0FZekpvUFNG?=
 =?utf-8?B?ak5FUEhIOWtEVlJMNUQ1L3VFQmpFTEZVWThHc042SDdlMWxUbHJnWVFzNEtQ?=
 =?utf-8?B?dmFDVmZUajZSbStFMkczS0JYdHFOOEplYnBib3piNlVzVHAzKzFjNVhydDln?=
 =?utf-8?B?R09pY0lmRmNoVU1yZnhkVUx3N2JSVzdxaFlDUlo5em9pVnpMRlN1NW1sZ0FP?=
 =?utf-8?B?K2RYQmpFdnZybENKcUcxOEdBQTREZitSd1RXdVBNRXRlNEtETG4wb2xIeU1k?=
 =?utf-8?B?SlJuS3BGVUhhLzVpczNUZGN4QVU1MnZIZ3ZEYmJ0Y1JVb3hvTldrdHJaTFBU?=
 =?utf-8?B?OW0vczAzQVhORnBtR1pKaXJPRCtFazVXZkM4b3NJcDA4Z1oyMEhJRzhyWGE2?=
 =?utf-8?B?N0ZBV0xtY2pUZk9VN0w5bkpMVHRvQ1VSS0V0Ym84cUhMSlYzNEtkVzdiQ21z?=
 =?utf-8?B?ZnhZTEJBZ2l1TEtxNkNGWFRPUWNOeVAza2xiS091dktSSVhxU0hPcWdleUVK?=
 =?utf-8?B?UHhaT0pKT2dJcDMvNjNvMnFWaVN4VGRMZ3k3eXlKWjdvZTV1cEx1c3IyTWts?=
 =?utf-8?B?OTU5WFBBSThmYTEwNUU1SkpKRFFyT0FxK0d6clFtd0ZoWXVVNy9vbUsvMWZm?=
 =?utf-8?B?WVBtbCtRQ0orOXFDS0NqbHlKNWZCM2NTZ2t1SzcxdWtMK3puYXRlT3lqRmdl?=
 =?utf-8?B?WnFYRjA1ZldJaWMzSHEzT242NnZJRG5XeWVldElZNXFFbXF5bkxnTnk2MXZM?=
 =?utf-8?B?QjkvWEh6QTNLOVV1dlgxYUFheis3Ny9pQXE0N2FHUGFLUHJ3aDdRMk1SMkJx?=
 =?utf-8?B?N0RMOUd2VUVvYWR3N3BLOGU0TXlYMm9zL3RVR0FFcmpZaEdNSlNhTW8rbEtG?=
 =?utf-8?B?M29GVnVFOEE2aTIrL1ZaK2RBS253Um4xOUpIc2NSSGZ4NW5jclFMd0xSazd6?=
 =?utf-8?B?SGpicGZyTTJUcm1wblRNZFFtbmpyRVNwZE9YejNPZUZSTzRiRlArclExeVha?=
 =?utf-8?B?M3ZQMGRmVEhZeDROQ0FBRENBbkRkN1lIQnhzbm0zYVVjM0hnNHd1SzlROTRE?=
 =?utf-8?B?UHBGWUxXdjlRNG8yMXU2ZmhnK1NUMCt1cUtUc3NkK2JUc3NIbkxwQi8zZ3Fj?=
 =?utf-8?B?Y3NyNFEwL2g0R3F3N2Q2UzR4TmtuQ2N4OUgxcmhhVmFPdnRCc3hCODVxbmhi?=
 =?utf-8?B?VDY0QjcvUmZ5MFFpcFNidHhYWm1wb0VnWHlqNldvWHJGREdzS0ljaHdGQnJt?=
 =?utf-8?B?VCtVK2ZFSlE5YjgwN0txOWpCcUgrZFM5R29icmZ0TGxDR0lJR1V5Z0tiYlBa?=
 =?utf-8?B?ZzkxK1hpdUFtOHduVzVmVXQzRnlQYytJTUxlTndXclVKTVpuVlRyZ3Q0cFhX?=
 =?utf-8?B?Skd6Q0FET2ZOaUNJRmJEUTR0STM0ZmpJN08yaDBKc2NKMjRSQ1ZWRWxYaTZD?=
 =?utf-8?B?TytzSEhZMlExdU5LVGVDZWtXeVZuNzRXTGdKN2F0OFRTS0NwM2pMbXFRVmkx?=
 =?utf-8?B?T1FIZzFsT0FGU2VSaWNKRUlibmZ0NmtGNkNmL2EzVThpY3dJcEFib0VQRTVH?=
 =?utf-8?B?akFMT1dpSnF2NmpFMzZMTzZPNnVxUmRuV2xsQUMva25LaTVmUzZtdUE1bi81?=
 =?utf-8?B?YlJtR0djWEEySmtZdlltRHo2eXN2WCtDVzVTc3ZvT2hjT1E4Nkxzdkx1ZjRS?=
 =?utf-8?B?b2UrRUhlNkRYWEFnQTJOdEhhSXpObVJraFZ0aEtZTUFXWndTUVoxOHdxUUx1?=
 =?utf-8?B?cjJ3Y2VHbWw0WnU0OXJRWkVUcUc3dG91WUhsSXlOWkQ0RzlnN0hPTzk4NWJM?=
 =?utf-8?B?dlVJMS8yUUhtN054eDVpaGZtbVlhNlphdTBycEVGUXJWcS95Wkc1RWowSjRU?=
 =?utf-8?B?Mk56MDhyNEUrYUpYcTJYRG8rSjZIQS9sTmI2TDBqRDNaREN6UzVaU0NSd3Fm?=
 =?utf-8?B?aDRGNkJDdFROZjVCTG5MaUc3T0g3TnNvTmxHbkRZS1hPN2Q4V2lSWjdoSldl?=
 =?utf-8?B?NFBGc2RucDZrckJIQzY0a3UzRmNTOGV6eDNKa2lPdnVFVUNidm52b1VsSDFE?=
 =?utf-8?B?MUFjaGhxR1BrMmdqajdRTWxRT3F1b1FZbDhIdytSUlRYKzA3bWNhNzdOaFJw?=
 =?utf-8?B?U3dFSCtBaFBmcHBLZHA4a29Gam9UUWVXcE52ZzNqdld3Q2JPNnE0b0ZNUnE5?=
 =?utf-8?B?Y2lQd1Zid241YkdZZHErYzFCbUh3YjJZM3pkd1JuSXplYWQ1cTlEbFNRR252?=
 =?utf-8?B?WG5WY0JxVis0T3JuTTBlTlNLeWY2Q1hMUTZRTituZjVWV3VZL0YzV2tnMnJ1?=
 =?utf-8?Q?Dw5+k2lF+JicxRZw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d46f06e7-1c5b-40da-90d8-08da3d179f70
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 23:54:49.7655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tlC579FdndJSVgP39NI/qcl/ULz++kezBfgFUnurWEmtdcLvyIeg/emqaog2UnG3Lb4LhCP+FdiizK5RZsnHvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1856
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-23_10:2022-05-23,2022-05-23 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205230122
X-Proofpoint-ORIG-GUID: TM6HVkkxWgrjXOodyohUzvZPQ2NKCYFS
X-Proofpoint-GUID: TM6HVkkxWgrjXOodyohUzvZPQ2NKCYFS
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/23/2022 12:20 PM, Eugenio Perez Martin wrote:
> On Sat, May 21, 2022 at 12:13 PM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>>
>>
>> On 5/20/2022 10:23 AM, Eugenio Pérez wrote:
>>> This operation is optional: It it's not implemented, backend feature bit
>>> will not be exposed.
>>>
>>> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>>> ---
>>>    include/linux/vdpa.h | 6 ++++++
>>>    1 file changed, 6 insertions(+)
>>>
>>> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>>> index 15af802d41c4..ddfebc4e1e01 100644
>>> --- a/include/linux/vdpa.h
>>> +++ b/include/linux/vdpa.h
>>> @@ -215,6 +215,11 @@ struct vdpa_map_file {
>>>     * @reset:                  Reset device
>>>     *                          @vdev: vdpa device
>>>     *                          Returns integer: success (0) or error (< 0)
>>> + * @stop:                    Stop or resume the device (optional, but it must
>>> + *                           be implemented if require device stop)
>>> + *                           @vdev: vdpa device
>>> + *                           @stop: stop (true), not stop (false)
>>> + *                           Returns integer: success (0) or error (< 0)
>> Is this uAPI meant to address all use cases described in the full blown
>> _F_STOP virtio spec proposal, such as:
>>
>> --------------%<--------------
>>
>> ...... the device MUST finish any in flight
>> operations after the driver writes STOP.  Depending on the device, it
>> can do it
>> in many ways as long as the driver can recover its normal operation if it
>> resumes the device without the need of resetting it:
>>
>> - Drain and wait for the completion of all pending requests until a
>>     convenient avail descriptor. Ignore any other posterior descriptor.
>> - Return a device-specific failure for these descriptors, so the driver
>>     can choose to retry or to cancel them.
>> - Mark them as done even if they are not, if the kind of device can
>>     assume to lose them.
>> --------------%<--------------
>>
> Right, this is totally underspecified in this series.
>
> I'll expand on it in the next version, but that text proposed to
> virtio-comment was complicated and misleading. I find better to get
> the previous version description. Would the next description work?
>
> ```
> After the return of ioctl, the device MUST finish any pending operations like
> in flight requests. It must also preserve all the necessary state (the
> virtqueue vring base plus the possible device specific states)
Hmmm, "possible device specific states" is a bit vague. Does it require 
the device to save any device internal state that is not defined in the 
virtio spec - such as any failed in-flight requests to resubmit upon 
resume? Or you would lean on SVQ to intercept it in depth and save it 
with some other means? I think network device also has internal state 
such as flow steering state that needs bookkeeping as well.

A follow-up question is what is the use of the `stop` argument of false, 
does it require the device to support resume? I seem to recall this is 
something to abandon in favor of device reset plus setting queue 
base/addr after. Or it's just a optional feature that may be device 
specific (if one can do so in simple way).

-Siwei

>   that is required
> for restoring in the future.
>
> In the future, we will provide features similar to VHOST_USER_GET_INFLIGHT_FD
> so the device can save pending operations.
> ```
>
> Thanks for pointing it out!
>
>
>
>
>
>> E.g. do I assume correctly all in flight requests are flushed after
>> return from this uAPI call? Or some of pending requests may be subject
>> to loss or failure? How does the caller/user specify these various
>> options (if there are) for device stop?
>>
>> BTW, it would be nice to add the corresponding support to vdpa_sim_blk
>> as well to demo the stop handling. To just show it on vdpa-sim-net IMHO
>> is perhaps not so convincing.
>>
>> -Siwei
>>
>>>     * @get_config_size:                Get the size of the configuration space includes
>>>     *                          fields that are conditional on feature bits.
>>>     *                          @vdev: vdpa device
>>> @@ -316,6 +321,7 @@ struct vdpa_config_ops {
>>>        u8 (*get_status)(struct vdpa_device *vdev);
>>>        void (*set_status)(struct vdpa_device *vdev, u8 status);
>>>        int (*reset)(struct vdpa_device *vdev);
>>> +     int (*stop)(struct vdpa_device *vdev, bool stop);
>>>        size_t (*get_config_size)(struct vdpa_device *vdev);
>>>        void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
>>>                           void *buf, unsigned int len);

