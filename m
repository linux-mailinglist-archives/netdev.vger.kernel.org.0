Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB1C1D3417
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 17:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgENPBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 11:01:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46254 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728127AbgENPBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 11:01:09 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04EEorcm005470;
        Thu, 14 May 2020 08:00:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=4n/wuN5QDwFdFWsRX9AkWANLhfK4zlDMecclEqXO/ME=;
 b=LSRtSoiiiVVpU0MPw5bykCA7NQbDApF7x66/P46aJG0Vg6HuiViw3bz9W5SJJC74cpMG
 IX0hV9jPS6IiBZN+7tUwZPbJc4TeTGWhS6RqIRQPdlaXSLMS/fKlIpeORkMCdL+Uaya0
 IFhHIemImd1VmXLrjZZ1VfEgZQSbkTWFrSI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3100wybvnx-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 14 May 2020 08:00:51 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 14 May 2020 08:00:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GlS7IQFdesDEL0Fl6ldCf0uPIrNXuiJvzYpsvuS9C8EvFYxoaVObBWLTPe8WnXlWUUCMGFH5jcVACdgJuMTakMwUCJE9qRtRBECEIjVJ3qnpmSqKDGNLJerHSI94k/abBrn0uK1rxUZgz6aWsR98d2KuXif0XOqQO6eromQVtFtG1YF8ltgfm3Fsedy1RIwgMj9vj7sgmEVRv0/cb2pRL7eI8mZHdMQdKwiewFe5OMQdmMfr8EGJn/j1qY5aifOCQ6N4XwkAyM0R1xQJAUM0ouvoCvs5GwFCwUrNX8HUVKaVWwMHo1p2QxCwlcOGJo+XNUIzoyuHQRUyHFY0qL1ENA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4n/wuN5QDwFdFWsRX9AkWANLhfK4zlDMecclEqXO/ME=;
 b=Pa7KBsJwVGwAcT9TZRADMK78T/10uH2y/Ecv4Fq/2a3M9B9KtPIGSB2qi1RTMLdlem15Fx2YbWZEgNCrAESFt6S1JZIbGlaGJLXArw4BDvdHrn4lIkCBYPegUiMRQoAnWtiZj0S/lSl9+QRad7gS/BDeobUQSvlfb0FZeLoS6dYVTpObmcFhuzg9tWXwZx2zv8BwQY8a5pCqFYqhoGv0cyLIVVtGvHmwqKTdhFmJukJJBDEojy0E5ea7j3cTYpp6uiDrLWsOEtleO00dr+0E9wJc+LY9x9v+3y0vow94LwOkMnzzTYNwigq0w+XJi3or+yOFOjUD/SUBUAV9BoNpaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4n/wuN5QDwFdFWsRX9AkWANLhfK4zlDMecclEqXO/ME=;
 b=X4JWUAzbwfNBfWVwZXpZzDXhE6d4WIQ5UJDiItzu9CSm/+XEV3bq/e8d3m6StF2XGZzLPVHLNANrD8OiqqxhWTGO5fQusWG+0ZssOH3wdtrQSEGdnJzza9w0R/RyNu7JhRoUBvEbxIiu3wm4ixx6CZ3BvSmbEUOAdhrwcJu9HDc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2629.namprd15.prod.outlook.com (2603:10b6:a03:14f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Thu, 14 May
 2020 15:00:43 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3000.022; Thu, 14 May 2020
 15:00:43 +0000
Subject: Re: [PATCH][next] selftest/bpf: fix spelling mistake "SIGALARM" ->
 "SIGALRM"
To:     Colin King <colin.king@canonical.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200514121529.259668-1-colin.king@canonical.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <bae961e3-a3ae-2652-6f4e-df97f501db0e@fb.com>
Date:   Thu, 14 May 2020 08:00:41 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200514121529.259668-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:a03:180::22) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:3bff) by BY5PR13CA0009.namprd13.prod.outlook.com (2603:10b6:a03:180::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.11 via Frontend Transport; Thu, 14 May 2020 15:00:42 +0000
X-Originating-IP: [2620:10d:c090:400::5:3bff]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef30043f-28e6-4414-d2b4-08d7f817931e
X-MS-TrafficTypeDiagnostic: BYAPR15MB2629:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2629897504C2234EB923682DD3BC0@BYAPR15MB2629.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:486;
X-Forefront-PRVS: 040359335D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mta0yQtvG7LGzCMuBWIMcX6JlTk+Jp7eSz70+k9SJTC3Qz0Xm0dpkosz2xd3IxTZf7QAYoqRTZiVRSUieOImX2cakEAvBk3l1iHwI/9PPBogZ+TErfjFdR2SRasdE7iqxrn6iC6r6/Lmb7/dW68b1ZBlSQ5x9jR+XcLtNBmnS4aw5tnXQ/np8jBKlKcOzfUAozPMnNH2DIs/h8n5uvT9U8z4z8Nyvkc6wam1fBcthXLiw90jaZm0UCSdptcQRz3rm4D8X8QY0r1XNPSEQ5gUyqyUng6fKsgzKGuOl0vxkqwVPU6E88hmPJm1y3sGbpDTRiCCg9E2+37thEjfNzFcHDQ7neazhPv1vYSCJNpfxjIGTxv8QFet5VDNUvHb7AsDEu2i94pqWa9kFiBRxh6ohXloUQqSKr5fDh3Lr5nWv1BUEBVvwlt0jsz7q3oPEi1wGtBRQJTRzCSAroA6xPnwj4HUofdzZ7oVI1pxXEbDyqna2eU7TLxSsfkADyTLMDU3XeAtrvSqXDfI1/XOV39xZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(366004)(39860400002)(136003)(396003)(110136005)(86362001)(186003)(52116002)(31696002)(53546011)(31686004)(6506007)(8936002)(7416002)(8676002)(2616005)(316002)(36756003)(5660300002)(2906002)(478600001)(6486002)(558084003)(66946007)(4326008)(66556008)(16526019)(6512007)(66476007)(921003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: zbDR5vX0OWfkuuTCe19Tml8b/VGpX67c29fwdi4jzYaKv7ZzgD7xz1acSTzLLzCSXlJbxab0BUyK+ddMqQOYMV8OSP53NquDqpvgYPx4LaSga7L9vqxW4fs/j/QS462/DuRa0Z5OFgudsDxhTydres2F/yki+edyK6jZAqlS5WuTIMT9y26pfguOIjDrjLtYveJlCpgCH2qfH59hpIRuRoVCi+kp3PPe7AxZgWNJompplUxJ66WrXcIR9O1e5kNl3L3gXNCIU4Bn3oWUrHF0ejGnH3s+Qg1yJcLuyAK4iWLZO8f1O4S5R5zSKgAZHj1I6wLhNWB8y0vu4vGkvBOQMu1u7zzXdc7E+/qExEakmoTqzkH2WIXsl9wyMe+ZT40jwVqjSMUmc7kWuPbRbRLi/V6BF6coFueR47zUYtE0fNzfmQh+dCa2fxEnzSwo0RntGStg4JVDBM6S0KaGPeuyv1Z4YfWDzsjDXL0KC7YX6Yt/sJdEXfXtmY/j8JOANPoqgFhREYfHmGvm+6UnNQl9Ag==
X-MS-Exchange-CrossTenant-Network-Message-Id: ef30043f-28e6-4414-d2b4-08d7f817931e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2020 15:00:43.4040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U7fG7ac31Vvf7Jgl2xMkLJaZlJQpC8diQiVJQUwpd2ZAu18nDvEYEdLSG8TG+4Qe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2629
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_05:2020-05-14,2020-05-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 mlxlogscore=827
 cotscore=-2147483648 impostorscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1011 bulkscore=0 phishscore=0 malwarescore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140132
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/14/20 5:15 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in an error message, fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Yonghong Song <yhs@fb.com>
