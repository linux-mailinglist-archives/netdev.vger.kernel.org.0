Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF34B24A368
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 17:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgHSPnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 11:43:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43888 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726887AbgHSPnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 11:43:03 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JFV8on012903;
        Wed, 19 Aug 2020 08:42:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=u60+/fIYCzWmyiRPv00pQ77l9VVg/0WJ9DqrqUP94O4=;
 b=DjRt/lfkQDOXBX8arZLVvw5Jdhcpsb8GRsUa4SNkC4Nx+TZWri961M7ywiCN1/gBJ8ac
 reAXO3FpOWZl2XF4ZrWjw+GT5G4ZcVYSvH6KRPj28AP95gca2XjQVBruaX9BM4Dadljz
 K7xK1gjaa8PtL4tvUyxVvvQeOjJAxX1LFUk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304p3h52w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Aug 2020 08:42:49 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 08:42:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gUHPTdo5CBSY6gBKNMVw+TCeWE6Yy1hcbWKGuxSxaUOYZKsV0GzfB3q4wVUN0994xrhGy/o13Xtev8+mNAnCt6NBH+ocCwHpOwTfJ60pzHmnmtPzSFD8vQ7I7rStTD6e9ed2AtrrqSUTxFdXSuYZcP/ObodreALehmJ7PcDeE1UJ9LvsB+lBbKYQ0z9Kvw34aGdTfKwZ+CrxRdSBlKs9+ym6pIHclMNkCJixvRnXYP4s9p5ZNNnHrBYiWpSbOXIW7oUpNrr7I5xO/QOnLmCsFByloVaWVFcGxCNoDpSYrzj9n6tF5ASbRjByEhBoh3Z9p0fRzjSP6x7BG2a4CHbB0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u60+/fIYCzWmyiRPv00pQ77l9VVg/0WJ9DqrqUP94O4=;
 b=gwZjQ3RbkejdsFrR6Ktz1zDZQczZNOwsCKehbl8hmNzxc9il1GfY5cBc2BJTff7T91ecijWF/LNH48YXRvRhXYX0omCKiHXsNyCujx2GNNKWx7qR3RqLyxfRqLILv6M03Ft16VKtU0Z7g7y4QYCJnjMuaF977FQG8j2QuGgr0H8uFfQdoXmvhV+9v18Kefb4JV7O8VkEo4WxcLSJ59IX3ZnEPG+XH+aAwxa2tTK6Tg4YyWXc7hN84YPzGbHIkl1KM+xa68250d/NGmYJ/WVLArqzQN14TgGs9LwqIeTnxUwBZFwqes532DteXoRAAFJ4UzRvNwewBqrYuHSZh4zcwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u60+/fIYCzWmyiRPv00pQ77l9VVg/0WJ9DqrqUP94O4=;
 b=PZTFfjudqemaRa5aSN0sI0HOCt+LAHsc607dho9/3Se5khkhJZvP3R9CahCOKepe3i6Q0QZT6v+0SCMWalsQ22cLZj1NHrZzc02EhGa8hCCvF662jfMSATB+xWFBfTFE0947DmkvWSOfRCx3AwIdh/A3/1BxbHx1kDtYVsOeraQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3617.namprd15.prod.outlook.com (2603:10b6:a03:1fc::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Wed, 19 Aug
 2020 15:42:47 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 15:42:48 +0000
Subject: Re: [PATCH bpf] libbpf: fix map index used in error message
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        <daniel@iogearbox.net>, <ast@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20200819110534.9058-1-toke@redhat.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <4f2312df-07a1-668e-7df9-5fbaf8e459a4@fb.com>
Date:   Wed, 19 Aug 2020 08:42:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200819110534.9058-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0041.namprd13.prod.outlook.com
 (2603:10b6:208:257::16) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:9a2) by BL1PR13CA0041.namprd13.prod.outlook.com (2603:10b6:208:257::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.16 via Frontend Transport; Wed, 19 Aug 2020 15:42:46 +0000
X-Originating-IP: [2620:10d:c091:480::1:9a2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6aac494-bb92-4902-2e55-08d8445685d7
X-MS-TrafficTypeDiagnostic: BY5PR15MB3617:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB36177782D53CDCC5EDF16C27D35D0@BY5PR15MB3617.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:400;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YIN3Pg7WhvWScVyKu/DUVsW2f4d+IfYbiE7L+z/rJC9Ykjp26JuRDlpyesZqqnKWZ/zmYXOb56rAjGXczAuaiUdw8hVlCFoR7P7TqDkktqRTOwzhOaRze0157MgML35WEVSUmM3pvCxXvyrCpQ77kEVs0QeZxCSbTkHbaZHVfo6IH0PTzDzxFn4sl3rBtrpITM7ua2lr+rJfqYSEhO5mtQ0oChGAzglEABAlfvsY0mY7t1HKANlHTHufc9k5hIMBAdTfCPRfP26R5ztDDXuoF579c8eTONqyX4xZqnEq1ybtcAY4BvXfCPp0r90bkpxa5zAg4gzLH6szSkjEtqoOWM+dxI0ue9ttzOXERZoLTSvYh1xS8M76NuX5oE+zYCqN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(396003)(366004)(136003)(66946007)(16526019)(4326008)(5660300002)(66476007)(15650500001)(31696002)(8676002)(36756003)(8936002)(2906002)(186003)(66556008)(6666004)(478600001)(316002)(6636002)(53546011)(52116002)(2616005)(31686004)(6486002)(558084003)(86362001)(83380400001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: /gUbB+HkbalHxCmzxm8ETmPtyjYLyOINmi+Q8qyXOpAOfM5k92x1xwWGn/N+7tGnA9fyWrNMFt8sARGjMuTKNpl9wCVu3qEzTjGRQKWp1vU+xAW+NwFCWunOPr0qCv5Kaxau+e6EAT2cR8+cGAor8MBDYsROPBxjlE0VcrwGB1JkXgtqMczii45fxSm7gbHtEZIS8CoBai3gLLsjryxOApXnPYXLc466Oi44sLflakKYyPg3lAO35jKtUM2WcIMiGIvzJQHxMpdXC1zOPLUf4KtvaB1PtDaLm1Y31XbV9daw5CQaf4zICxuCYGSqTXhwl9PnZju79QAi2bNwPlJPU4ZhVoytr0ahobsi2XxvLGOCXzc8Of0uirnY8K+/E5pKgQNr4GlT8O45wAdwNSj8OdnXC0CqvoJeY8X1Qq7QWhd87DZb0lDVijmPsrEGCeoO1kwmGVzDJGYSAxahC+wCMe1jiKemjtLMlr8pCraASi8UcGklVdshynHSrBswkFCcHO4sgnldHszmbXoSchLO+oZID4DU3upsj3tek/upf6CLaMg+YQvh58xdgUA+WZN19MBcrRvCz4R+FG8dB124VjKCmq/ojIGaxBo/y3H4XX+3kk8mvGhVEvafLWygp9GsZ/QgYz2ViFhHUGa4YTxXdvAWSYT0NQziNfDeQWn/BNTWY6EJj9kTZJqyQxDhIhmz
X-MS-Exchange-CrossTenant-Network-Message-Id: f6aac494-bb92-4902-2e55-08d8445685d7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 15:42:47.9131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GekuX6yyUP/RxKCfU7+DLSxcdhIrhkcUlMZJ5pjmREzQycP1AKLttQlMfQcEkj22
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3617
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_09:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 mlxscore=0 clxscore=1011 suspectscore=0 adultscore=0
 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/20 4:05 AM, Toke Høiland-Jørgensen wrote:
> The error message emitted by bpf_object__init_user_btf_maps() was using the
> wrong section ID.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Acked-by: Yonghong Song <yhs@fb.com>
