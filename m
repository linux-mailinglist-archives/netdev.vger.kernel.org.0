Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4982432C3EC
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236557AbhCDAJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:09:05 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35236 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1452377AbhCCHcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 02:32:15 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1237TF5W031129;
        Tue, 2 Mar 2021 23:31:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=MnsbSZYnsVBDmkSN1F2k9xa8TBIhiyBKZGEq9RggBNE=;
 b=AGQn1iezsY1tztVFURbNuwChTMTKLVwVFulXVh7tFlv/4hC8A2ov+RI6rxBuMZa8XFmS
 JvDA7BqyyFpsy6RIvgddh227+k/hBmDyDEIG9oRPANHt20i+6aR6LmnLVMHaCUvnO7Wj
 I8+4tIbhlU9Z596oVVtDtF3z6gAlUolGVAo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 372107s70u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 02 Mar 2021 23:31:15 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 2 Mar 2021 23:31:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W+F0vZvjEd+pbc79pLxgp87BAUq/zip0/W3ntyyNimFvRb1XyZdMX3Lzi0bfAU/fkLioykMw2sMyzb4yl17yzWR972uZmwRu2JnrK+TOrn+72I+6oC3IvCRX7q7POAqsvW3oIxOQfcTH20BuG+uHot5t+6uIkUrw4FdK+Elu7uZVuuRRW1ml0X/vUGNWy2HB3E21gjydHWM5z0wfKSjhK+/71FcEfBd+zjVIvn3VwD1+ht9JDNG3VRotmB0SoTKEKiFPB0JNfwqkF6ISWkkzQ5APxrOAaqYT9TNUluh83qkH1KCNyAkLYw6Z3M/8/zyACVEtFHZG775FXLdIix/y+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MnsbSZYnsVBDmkSN1F2k9xa8TBIhiyBKZGEq9RggBNE=;
 b=JBf1BmDWLiNFYbKSLwgRF0CSuGZ4Co65Co43qo4GYplq6G8pBnKKcGfpZ53JB/wkLVVI0mcITEGoiMwrwiBTHdeb/OA4MBQQE1LDdnD6OFxXeFdTuV/AuBftZ/Qj4w33Hs9tEwSYJAerpaEgLa7blAh6BTePyoZyzsNoxjm0OIl/7fMWeoomaVQtzNNCIhBXBd7EDSB+bgTkJig0Mgbzy0V5My4Ds1Nlssz+dPe3Pir0x7gnjNOOtb1ex3p+o5oYCT+VAx7NazBBmQPRYLmPqQI7X2MkQkMCO7YnGfkHpoYyL3yQNX+VFdIrZ+w8Lh1Vk+Dn6b4PNgiJrYsXGVJwZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3982.namprd15.prod.outlook.com (2603:10b6:806:88::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 3 Mar
 2021 07:31:12 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.3890.030; Wed, 3 Mar 2021
 07:31:12 +0000
Subject: Re: [PATCH] bpf: Simplify the calculation of variables
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, <ast@kernel.org>
CC:     <daniel@iogearbox.net>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1614756035-111280-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <1432ba0b-0d37-0d75-32b2-32353f6692c6@fb.com>
Date:   Tue, 2 Mar 2021 23:31:08 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
In-Reply-To: <1614756035-111280-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:e54b]
X-ClientProxiedBy: MWHPR12CA0044.namprd12.prod.outlook.com
 (2603:10b6:301:2::30) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::1a32] (2620:10d:c090:400::5:e54b) by MWHPR12CA0044.namprd12.prod.outlook.com (2603:10b6:301:2::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 3 Mar 2021 07:31:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f8e3e14-3443-48f0-f7a1-08d8de165218
X-MS-TrafficTypeDiagnostic: SA0PR15MB3982:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB398218E13629866ABC08D07BD3989@SA0PR15MB3982.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GDrTMoIjz0xVp9MrA/ugACQzZba9A7PCByDhgl52s0pkwWq4a70K9ZuzFptv0kJ2hta+bF+XKMFa5qhs1NBvxuQrKu8xFpwTOpsd0HTwFD50cKCMZ0CFsE/uxlu2TV2qTyNCiA82SuqTmCMgnVRacMEADsd+pLNECW4UoOzfoczdWj0l6Ly21v4LZDSorXO/1Ek65P59+Es22S0X8rHDmzjn9aXhHGK+xlETk4zOLMYNlS7s3JckMRNq0aSkgsi4TqW8QoKuaJ+YHtkMtd77FDreFQwq+koTpNwLPJ1Y+9TkI/nebdn/oLKcfMPO/3DGybcGijFWgrZTYvoio2AVxmzFu0nhKSxR4blsqT8FwGJQdu0WaulR0vNCBYoKBiAxjg5mcbRu6MaSW0RDIWChmLzzsC9zAV3tm3eVLs6z5xFZnBpSI8Zg4ZmYUXklQOX5U7WIOQ//DyecbuJykfykgjpWRVRurzdqFmPUVmZ4BihIMCMKoA9tZRrnbEg+C/Uek0HFo1YPKdOSeA8thddJrUQ6bUa+6OFOSDT90eRjtHYhvBm7aY7248BqUjycftgXuQkfSAggoobHbxp2ckdeb/B4rcRhKrPmvJCotSyn818=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(396003)(376002)(39860400002)(52116002)(478600001)(31686004)(2906002)(4744005)(83380400001)(8676002)(66556008)(66476007)(36756003)(66946007)(16526019)(186003)(31696002)(4326008)(5660300002)(53546011)(316002)(86362001)(8936002)(6486002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aW8zL1h6YlkzYXVPUmVLUGp2b0hpTUQ4M2QzN3JTVFNHUmZpVzhTcHMxTnc5?=
 =?utf-8?B?RVpIWWduTm92RjdxblA4cFdhZjMwM21Db1M1MnJGS09STGlYOGJKbkZDd3JU?=
 =?utf-8?B?b010dzZ2TkFMbjU0NTJDdTQ1SmI1L0pXOSt2bmdtN0gzYmdCemVNMEs0YzRK?=
 =?utf-8?B?bEFuRHNHNVlqSTFaV0l1dkZrWkxYdmhEYkN6S2FhbGpiTEpxSldJTjVJMzFU?=
 =?utf-8?B?OUtNL3RZMS81dGxkSS9aTEo2MVpCSmJJbnVOWFMzeUFWWGVBTDRkVXRKUXY4?=
 =?utf-8?B?K1dJclQwa04wNFVPUGZPbk56MlRwaGZOb3ZZZytJYXRuNGQ5bTlOSWZBc01l?=
 =?utf-8?B?aGdXdE9sMEtIWW9KSFlaZHY4U0Vxc3FUbXp4MU9oMDdHUFhkdWRSV3B2aG5Y?=
 =?utf-8?B?MXZyaVRWdWdnamQxN01YWVU2M1lwckM4eVI3eXF3RW5ybEpLalBoWTQyb0dm?=
 =?utf-8?B?ZTgzaDJWdXhxTHdlUTF3SFRBSWdZbjRRMEpZbXFteVYzM3BHZGJvMEd1bTBs?=
 =?utf-8?B?S1lwZm5yb3ZMeTZGWHJ5eUN3Mk1mMkJtMWpPbHkvK1dMWnBlK0V3WWdCZUQ5?=
 =?utf-8?B?eUN4MU9MQi9aSW9WZlBHOVRzVDgrQi9sMVV5SDVHMlkwLzNxZmoybDZtNGg3?=
 =?utf-8?B?K2Q0TlplNURRVVpPUmhNNFRVMFozNWg5MmRYVXZJRmVMUzd1L1FnLzhGMW9X?=
 =?utf-8?B?Mmc1ZWo2Z1dId202bXU4RjhGZFlrQXZNRTFJTy9DUlpDd1NaWXNiczhlUFl5?=
 =?utf-8?B?dVkvNGpjMW44N0VWcWRsSWtEd3ljd3pESUtnTVB6TzVnem1DZitCeEdIWHRU?=
 =?utf-8?B?TTdZUklnNkhoT3FYM2lzblFoeVV6a2dxWlZGcnlnbTFJa3VJSnhidVEvNE1a?=
 =?utf-8?B?RUpzMGh3ZEVSYndVdndDQmcwNi92VUN0ZVVJNUJlVEppcmFxaDRnNXErTDBi?=
 =?utf-8?B?Y1BQWGlwVkhWdlloc0ltVnhQMnViUjNrQkNMNFZBUGVZaFN1Vm5jd0NNUDBy?=
 =?utf-8?B?MHJ6NWtxa3pGT1h2STkwRitPTUhKcHhLcUIrYWs4MFRoVlFrMnJvQm93Ly94?=
 =?utf-8?B?SkV6YllZOFpKYXA1WEtvalZjaStVWTU0SUkyT2NmT2JJY2luTDlNNXIyU2d5?=
 =?utf-8?B?M0FDQzJ5Uk9vR1pMekdTbnBmOXhHQk5PckVxejRvUHNsNlIzUWhYbVhTa01H?=
 =?utf-8?B?M2E5TXFLYzlIL3ZjUUNZVDNXTGZqcWJzUjlMMzBaemtyaFBxWjFSRWRFTFV3?=
 =?utf-8?B?SkxVTjhuUCs2M3BsaUdjQXlUWTFybTE2QmJZZWxDdFM2QkRtbTNYeENkVHhV?=
 =?utf-8?B?UEFYbDdLOGQvaFJFbGtpenJxK0VyTXR4MkxQeTR2bWlnbTh6NVk0NkpvSTg3?=
 =?utf-8?B?MmllKytlcXUxdEZITE05TTcwcnZObXpmKzFiYTdUczhoZVFGeFFwOGZwaHV1?=
 =?utf-8?B?TDlPOGd4U1hiQzNIaDc4OUwyNTI5Nk9nZC9oWWhNeDNlZWszMVBDOFF1NHN0?=
 =?utf-8?B?djVaVTEzTEttNVkwOXYzYVI0RFpkRkNRYlpiKzdheG1GZFFYajczWEpYMG9F?=
 =?utf-8?B?akFXQkpHbklTbEJ4U1JYdk5HdDR1ZVNDd1NwU3dTaEwxRDd3aEhabFZIcjVN?=
 =?utf-8?B?RFEzaE5qR3lmcU1yZ1F3NXQzZjYwS200cDV6NkhmeXJ1VC9DbVhTdXdrbkUz?=
 =?utf-8?B?aWc1QjZoRVh6ZCtvUFhDQWUycHRNblJ6R1dqTUQrTHJMU0pxUHRFUjN0VEVa?=
 =?utf-8?B?SkV5cms2WkpvRzNERDhvMisreXYwZnhycy9JZ3J1aC9uNnJHbHdGbnFFdUY4?=
 =?utf-8?Q?S1ryYyUwksiaiVZgKMPsIdIygYIz1V3acf42A=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f8e3e14-3443-48f0-f7a1-08d8de165218
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2021 07:31:12.2429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RHAWyMKBSmymDOlONoCLVL0hZm+9+IT+0JiYvv6NWM7np6vrMwSFSAiLroJqKNi3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3982
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_08:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=965 phishscore=0
 impostorscore=0 adultscore=0 malwarescore=0 clxscore=1011 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103030057
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/2/21 11:20 PM, Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
> 
> ./tools/bpf/bpf_dbg.c:1201:55-57: WARNING !A || A && B is equivalent to
> !A || B.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Acked-by: Yonghong Song <yhs@fb.com>
