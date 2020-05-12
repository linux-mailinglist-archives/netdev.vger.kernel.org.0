Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820F61CF71D
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 16:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730340AbgELO1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 10:27:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52972 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725929AbgELO1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 10:27:08 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04CEPJZR021239;
        Tue, 12 May 2020 07:26:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=GJAChrJpQyp0A0H29DBp8q5Z4pmfZBMMvfMG+qdvkK8=;
 b=EwRbJoEaOgJrCuv4HhHew7UI/pkW5Dgay/ESqmMItOhnVSNOYEXg1TLPMq250UdOH3f5
 2QIKajRb2urnsyHFVUVqTj9zuR2KJwI7IZPwF7uollOT69GVtgQqOenDnDktebd/I1i4
 wycokduzw2m30EhKwovG1Mi9OZUU1bX6yIg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30xc7e4kwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 May 2020 07:26:51 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 07:26:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FEmsixtUoXad4V/W69VCq7Iolr+bCwzBGu8qMHSj0wAQxgsLZmIL37ZqfVakTOXISngIAiUcZP0I/c+KQgezDk5Tr+2zfSMHffPcBMWLkrDd3/LU2u0gpyrcNqNXAITuJIkbIvtD6wVASi3P6707YYdr6X9Xb3RjiuQeqSpQ1MiHy0OYJlJp2UMSJZN0H5TLD+SQp3SIgEoRRbD+MrGPhAtHvHER4FcU4L3loqu4xIabEnepaaffql3M487/oFbau7uuF+71gs8zQMetTtP2dcOQ9GQbXb+sT6/uM333Jo9ztuDcQnXSIs9z8rmZXfpFUfb//QT5SQCCq31zM7SPOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJAChrJpQyp0A0H29DBp8q5Z4pmfZBMMvfMG+qdvkK8=;
 b=jy3iQzreLg2KuGwo1NwbwMlRuZhUoyBR3W0G1lwoJuBYk4vcZWOe3e3nqmTuYlS86Twb016NXk7Uoew+1uVdxjWiBkE6BGzsHOthGD3vs2+SAgaLTUwO6GHt1JLNhCpAF0khUy2vHSMbqVrAOPCXB1Vy4ArHBtDNYU6vovxh0QQZ7jhHovKtOvfM8Lc7GYvQ/Y37ei7bV0BQ0WujAMzn3gn6mXXPFamW4pWDxuNoUN4EckDc+JC1nXDuC+nvExuOFyW0EP3l+4sgNmEqFfGdtmouneBinhUUwrXucEHLIWuQxwoNzBkMSXnkHWjZe1AU06SYvJla6y7sTfJS5nds9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJAChrJpQyp0A0H29DBp8q5Z4pmfZBMMvfMG+qdvkK8=;
 b=j5uRYYHqXsLOwaLUuIGrAu8b5OzNLi4phXW3KcVDytFNO5gBFWJT8tDU0H+d+tB/fDFUuk9u8jv4w+mTOuZrwLXNlHDuqid6wTI2n2yAawm2dW2CMq5J2bxw3sIYBIUJLyWOM4/pC7LJJdNSXz7CJvgp2OhMjjfO0z9Tu6ctJMg=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2360.namprd15.prod.outlook.com (2603:10b6:a02:81::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Tue, 12 May
 2020 14:26:50 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 14:26:50 +0000
Subject: Re: [PATCH bpf-next v4] libbpf: fix probe code to return EPERM if
 encountered
To:     Eelco Chaudron <echaudro@redhat.com>, <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <kafai@fb.com>, <songliubraving@fb.com>,
        <andriin@fb.com>, <toke@redhat.com>
References: <158927424896.2342.10402475603585742943.stgit@ebuild>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <7e23f4d2-7cc5-9976-dead-ad2e993015ab@fb.com>
Date:   Tue, 12 May 2020 07:26:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <158927424896.2342.10402475603585742943.stgit@ebuild>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0064.namprd02.prod.outlook.com
 (2603:10b6:a03:54::41) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:d0f0) by BYAPR02CA0064.namprd02.prod.outlook.com (2603:10b6:a03:54::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Tue, 12 May 2020 14:26:49 +0000
X-Originating-IP: [2620:10d:c090:400::5:d0f0]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57df26ac-a8b4-4662-1c30-08d7f6808252
X-MS-TrafficTypeDiagnostic: BYAPR15MB2360:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2360A9625AF845BCB0F4FA41D3BE0@BYAPR15MB2360.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Tva67SFREySj61z3P+kxyGlKGxF0orozO6GLL26giFxHrqW+yxCE3cWjWFLRTd95UsVy8Z0tsrM/BW0J/YxvAuKn842PhgJ1qEHq7AqKGhlLB32aQVLWrJ8reBGQDFXkX+whRcJH2U9BLqz2cEg7fAdh1kY6m0HNSYvdb0T4MHB/PmXMBPEbDsk6zpqBAmg0kFPPEJfura0j/ZOG9xK8ENjn3/DClMj2ZNMqdyxL63fg0tyL0a4oUzY9vo8KROITG/6FddHlj8tNPae5/mcF+ZpYDbcZtBt1n/EZ290cCkBgWsMdwLE7Y7PSqUxlPTkiE4Hxj9feZyLZJvXrpDjgbRGUmsjqzihnzCnlLZfX1+y/Te//ywf6gRv2vXgcj674iRI8gRWrKWm8FR/Vp9DMoMYb0VQ8sPYYT+s4PujmM/KRkVG+xwtTrN0NZrCWaYTc818Y40hdC5rK88SSoeDgU/Mz4eTfm2u9aOosCUWiC0dwGzr6z1ojLzkn5iS2lL4eL3Ibfnsp+SlpOthJI72h1eBHc1E285aFOBbsKmfrD+o3qYdaOb/bsLAdNgwOPLM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(366004)(136003)(39860400002)(396003)(33430700001)(33440700001)(53546011)(6506007)(6486002)(16526019)(186003)(4744005)(5660300002)(316002)(2616005)(52116002)(36756003)(31686004)(6512007)(478600001)(2906002)(4326008)(86362001)(8676002)(66556008)(8936002)(66476007)(31696002)(66946007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: muscuObZ/2aNj93BwsLBsnstmV4P9AWkBbzP2Zp1/zsr4reNleLT+Q+U4TdmCU0cRo8U1t5rYwy43s4oJWhYDwwt+7L1XGlPz1LuO5pDLs6Rr1oxmb4uDzDEaBXTOa4+2Se10oP+iKkNn3iD66syJpBPli4c0sCACQN59wKRafa3LKNx1/FFPkQgDEFkny6c/eex7lXoMK+twohyQSomwACR/UQvzU+6HpYCXo14poKxa4fZ7QJNUtSDFDvskAOFc7G4IvTz3QHXw8t4n0IKyfoYzkLrUCj9MQoGAd6sqZssZQAO1/PvOHWQU+qwU+WgTWQtcbDHosksmtzEyoKUB12k4OkAPHQNXQjlMSdXGrowsnj/JqyNZld4uRsdlCOm2mfw19bmZoJjrBa0FhBDxlixfLVEaRAejC69TOUDpMbpU9j5AjGzAYX/qntWsr6eLvX3xYcPVrm7Vshgx7wKIiLaiAaUdY0mGxAa+UZjh74W6sodSgArLIrgVIkG6CSLar2fsscspdvC4u930SBC6w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 57df26ac-a8b4-4662-1c30-08d7f6808252
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 14:26:50.1329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vff0NBR9GUTPfcLimzrlzp3zQaZSD01Agd75cMzX22wUsrebicSpDSt/WG+uHtNq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2360
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_04:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 adultscore=0 impostorscore=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120109
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/12/20 2:04 AM, Eelco Chaudron wrote:
> When the probe code was failing for any reason ENOTSUP was returned, even
> if this was due to no having enough lock space. This patch fixes this by
> returning EPERM to the user application, so it can respond and increase
> the RLIMIT_MEMLOCK size.
> 
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

Acked-by: Yonghong Song <yhs@fb.com>
