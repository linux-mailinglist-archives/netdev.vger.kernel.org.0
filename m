Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31001D042C
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 03:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731695AbgEMBJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 21:09:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46194 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728131AbgEMBJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 21:09:13 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04D18xrH024018;
        Tue, 12 May 2020 18:09:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=od8vjAg7ZwiQ43zmK7cZ9SMbqgVLfj0Dd9ZnVaqe0yI=;
 b=bnRzCjbkOWg04OFGAIcl87kb3tJRNCEUbCcmkT4fbFtIpv61ZYT0xcvvFyQxXAsCGkbF
 nTc/dXahQVVJjupmTQu3+xXBWY0ZGNtc5GkH+gbKakKTupzXpL9HiEz3mY775+rSZggN
 AzLn8fBN7CIzvBaZbqsC48yye1xcHunStyA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3100x21xj0-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 May 2020 18:09:01 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 18:08:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P5uQens/8rgq983KYiwzG6rIQV8s6DXwYgjJNqesPyM0SIBy/edQJ1spCUIYmGgTe7BCenFGqcBTI+Bh/Z4p8YcvfZmZ3RV4s/kUPi8lL0ZWHMqAn1gTeOTtmFr4eSlhpX264k8UNjdlCA5/yUK8TmBJ42ORkbd2sF60aTNzfD1MaiGNH/MwdkpQ1PtVQBwobGT2/N+lniMw/GN533Xq59i6krCpZ46+S7JtdeTWS3UdHwjXCNf/t0fbqC1oAI1+xNghk0KlISuGkxRh9RO3xyzB5Vu4H5KzEhpplbO7OswHrfBW0vYdA1Aj3xmw637j32jvrMHihRlFpmpAyXXPkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=od8vjAg7ZwiQ43zmK7cZ9SMbqgVLfj0Dd9ZnVaqe0yI=;
 b=lJqtdFh8fPGdnURGVokFj0CVTol5YmW1s7xDQ+tvmAD2WaRkLT/ryW+nUiQYlUrhX0Extvqsbkacm3AHD/gdas2LR+z9FALdMOcfC7aCaO+rwqC0w5FXgzP6e6m03yPxuGYTbudOEuSRq66ev0IOtUJR1IsVuPKq/t/cfe3nqOf1NlFZZDe1gP9AetNjdtJzvkyzyDAq60dfHqwWnWm2nlkw+xOC1s0pCyZrH01jg5Ivr0w1n9M/fvJEqrpeBYD4E+rh6OMUUrmZFl1yGly+e/ZzShemCShaHSIHvnKLXaxU/t1LCCO9IlrYAFH6gu9eAXvUE3d/3CcqvBzSOMHLPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=od8vjAg7ZwiQ43zmK7cZ9SMbqgVLfj0Dd9ZnVaqe0yI=;
 b=AfvwzsaANZZgCAlUc7IrILPQV4I6n+4bQ6b7E1M08e9V0iDTRkam7Lm8FNez2YMIFXfPKafFkOK4+N31073xJy9Fnxv3ezKp2KVlhmgtoYZx+MkfeP6mTi6IItOIhYM6eRrnVSFSe8hqQUfTpXChpkrRTo2PSGItLvA0FHaIN9A=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2903.namprd15.prod.outlook.com (2603:10b6:a03:f5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Wed, 13 May
 2020 01:08:46 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 01:08:46 +0000
Subject: Re: [PATCH v3 bpf-next 1/4] selftests/bpf: extract parse_num_list
 into generic testing_helpers.c
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200512192445.2351848-1-andriin@fb.com>
 <20200512192445.2351848-2-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <aeab8680-6b9b-6cee-e1f7-d4db12fee784@fb.com>
Date:   Tue, 12 May 2020 18:08:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200512192445.2351848-2-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0021.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::34) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:dfef) by BY5PR16CA0021.namprd16.prod.outlook.com (2603:10b6:a03:1a0::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Wed, 13 May 2020 01:08:45 +0000
X-Originating-IP: [2620:10d:c090:400::5:dfef]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 828ad57d-e7bb-4da7-4f08-08d7f6da2fc3
X-MS-TrafficTypeDiagnostic: BYAPR15MB2903:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB29037595BA1697B5E121A9EBD3BF0@BYAPR15MB2903.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Du+4LpBfU7IIEwTm6NAaSvLSgFNIFFMZy9svWVslV7/+EiNnoBdsccJkO10LEfLU6MuiWcSkBnBMjovlhDBFVKbtn6OxmyyY7IyDhTw3zQ/MYy4OKz9JykjfDJ1iwxrArl3tkY683nD02W9auOLckhbDV1nK1tjLXF9Mikt4MVOergWu7xzC05dnQWRyrJgadFE98dMtTAoDDwejaxMal0fEZ+thg/pspCw8Mq3IT+1A7GcpJueoyQhBI+cZoCaK1xpWMRtqymIGO97rjAMhYVHOENhezStBdVLb2mS3cCb75DHih09/iSMLD0GGSrNKfozUXrkhMpPIcSfG5pb8VFe9P3Nd51KeZjfBPIg8xU2a/XGQU77vk9b9DWQavOLHEyZ57CjcKIjSE8BsLYzxiR0lGXz8Gm556yyUo5WWFxryeXw1I64yuNlpHibvU7ZMfQzVuHtiV1MR9EjKwLEysLh8SnDQ1teO7FeF3ir7+QQpEogABtIMvNNmIFYG88mVOy92ritPZYI3Hpjsnd83bV5EDtvUVf6HsFvBziIFrqu+KH5+XZyLUALCB5nZnoVbI7ksPBGFYNIy+3Sa38YX6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(136003)(346002)(376002)(366004)(33430700001)(53546011)(478600001)(8936002)(2906002)(558084003)(316002)(4326008)(6506007)(31696002)(2616005)(6666004)(186003)(52116002)(16526019)(86362001)(66946007)(6486002)(5660300002)(33440700001)(66476007)(6512007)(31686004)(66556008)(36756003)(8676002)(41533002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: uZVLIsbrhLt2Xl9lxflXRG6ldO+rWDnus6wqz1fTRwfV/pah4FtYaV4BgVhqGg52wUuz0BfagMcKn+3jhxMmgRW8EkNBa2LxjWVwrqCoeFt9K/RHveDsnY++TJ9g0G2OSpeaNH9KwsZtF4/ImfMOBLjZj90DeQ1sWx5f2bcb7qJ4phnVOavxuURwA47lsvdjTGqb2JoBoot1jMEkBML/M7+mBh8nGGQduLsRQTYgc59u5d6TCBnIwo+crMgmXkVwxhysCqjNZVWkEjh7BJ4SWcDJoFjDlNXhUuSN7e96V22vmS/5P8jTBYC8kREWsDJ8s4Vc8639BVnebcFUbELBvQBNkwQ1A8ri6jZfnSZJZ5dhPnNRrkuGj/O23C+C2u6q3v3SpcbZ5gcD1f7MX/CyF4nLSat36gm6pp9HSmdYsJEXT2vP/L2uZuwLDil8h4422R4bkgIj1flk8Vux0PkNx7ktnQ9mr8gH+2aYKq62V8qeyhe7eEwULiIcg/6BVugoDUYZ1nbX6t/FOKK1Y8OoeA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 828ad57d-e7bb-4da7-4f08-08d7f6da2fc3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 01:08:46.5154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xAVOkHlRwnAoJt4+Z0VEsWlvxBHnG5YjcpLUukPKJMZnl0IGJ4czmKHNuS9BoePD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2903
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_08:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 cotscore=-2147483648
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130008
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/12/20 12:24 PM, Andrii Nakryiko wrote:
> Add testing_helpers.c, which will contain generic helpers for test runners and
> tests needing some common generic functionality, like parsing a set of
> numbers.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Yonghong Song <yhs@fb.com>
