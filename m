Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF831232738
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 23:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbgG2V57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 17:57:59 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10512 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726560AbgG2V55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 17:57:57 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06TLXWCE016495;
        Wed, 29 Jul 2020 14:57:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Fs1zpTnw3ZVWoHlRGEJiRSNmz7CyCsDuoqWzocJ9ibE=;
 b=Oi0zwQzESejwM0Ilq0rBLFORXKcpx11faOCV/eCyv1hfv7wpjsciqtjYJajCjklK/1vA
 K56Qu+n+G5s5r8kSoHuTlDXEEWuMo5vPS9yJX9w7CDWWS8TifqLyJy+zXODsmOTxTHrB
 OoDhDt41mIa8Kgtn/Ky0U3gMU0URjlql2jQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32h4q9sf7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Jul 2020 14:57:40 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 29 Jul 2020 14:57:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZrJ0Eqf7wi9OmsALv53CIjUXvlBc9DPVWSgOzf9luHHpLLDcHna8dujKTXhCCA9NVKYHNf3YrmmAAK5HTp9ru7w2e63OFR4/036sThG6x+HYkpvDmQgS+OPYNeyfbMQsB5Vmha8SmWdNbDO0X/U0F3fNdXRzPoKinq+dOBsw1oFVpuoI3oeqNJFzQUHrCy85keQuULMoFwiSXHmWyTDJrK8f1PCng4rxrWtGW95VkRVdupDTOt2b7/weoFV0HlU9k61tjDgObCNIYQ07qFX9Sgp/w4P/nMIiJaHAdQU2T6WsycgVluAfVIhU2srW/MZLfyNdp5qZSgqhnLi1ws6eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fs1zpTnw3ZVWoHlRGEJiRSNmz7CyCsDuoqWzocJ9ibE=;
 b=mFXtC3TThHs6+pWMsMn+twfXMRqfFSMEBcDH5zuXhGokR3ci2Jh+aCazrP2vAhNOZJRG4ZTGS9LbNrBKMGu4VWLuAq+QUGzZnLS2zxzzM0K8pEcFCzu1g6LC1F0K4d1bHZLBqUkn6AQoXCrqylLsX1m9N63HdOPv/aG9PwIIT+/JTVhZkg6X2tKWgjKsZoZjjMOVVC6as9e0o676hGn13WgP6xeu5wtj+JFIjjmo1rH+G9tdaWJLcd0Q7/lWPe9I8WZnSc6svrpMmIUPju3OHPN7I1pXyr/+G5OrNCXlAZIRcKTur/BAiGE9dbAXsw92Eng39w2n7tvpWpo1CSkk7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fs1zpTnw3ZVWoHlRGEJiRSNmz7CyCsDuoqWzocJ9ibE=;
 b=G6RfQ0hppw7ur3mGC3iKZIse8Oy2keUIhGiHgEnX2VQd5TzSVD6fH+ZXqXlAGYdKdlFzJH0f5hZtl46QgNHIfeYu/rVjjX4y4PKnUGVj50Aw/kN280YrVACcWqRpTDPnbeXINJPIFojqpM+XJZHfanPz2TnQAS3XGEk/DTouJyE=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2775.namprd15.prod.outlook.com (2603:10b6:a03:15a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Wed, 29 Jul
 2020 21:57:38 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99%7]) with mapi id 15.20.3239.017; Wed, 29 Jul 2020
 21:57:38 +0000
Date:   Wed, 29 Jul 2020 14:57:32 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     John Fastabend <john.fastabend@gmail.com>
CC:     <daniel@iogearbox.net>, <ast@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [bpf PATCH v2 0/5] Fix sock_ops field read splat
Message-ID: <20200729215717.mkgd4hnokybwzsda@kafai-mbp.dhcp.thefacebook.com>
References: <159603940602.4454.2991262810036844039.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159603940602.4454.2991262810036844039.stgit@john-Precision-5820-Tower>
X-ClientProxiedBy: BYAPR02CA0027.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::40) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:68b8) by BYAPR02CA0027.namprd02.prod.outlook.com (2603:10b6:a02:ee::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Wed, 29 Jul 2020 21:57:38 +0000
X-Originating-IP: [2620:10d:c090:400::5:68b8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8886d59a-4604-4f02-2994-08d8340a68ab
X-MS-TrafficTypeDiagnostic: BYAPR15MB2775:
X-Microsoft-Antispam-PRVS: <BYAPR15MB27756E6B335FBF8F5644EEE4D5700@BYAPR15MB2775.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i4AMMFeibUJ8AXuqV5eOaQ/Ws/N8obxUmEBaKj5FdNOIdeGRORC5Uq+XuipPrteYnSU8vs6pL8gpE60G0JuLNvzb61bWutNHWzDCnyCFgVpAi2IKvG3hXwS9pDdjCc2be3mJq/XZcIe7NaaK3TQf9EO6J1gOPRSr5McVO5ePymj3iuhm2KTbdIP1VxkGE7bJy5su3+/4DLHrBSIVOixqtRAJgcXdVQl1frrGfs7pUpH6QY7BMuJeDcZ44N/TOQTtzvM/t0qIARVp4RfZHVRnW63zMZLdI4rwRysUg35ahEoIzbnjU2nIVvPTlbPfk64z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(396003)(346002)(376002)(366004)(136003)(6506007)(66556008)(66946007)(4326008)(7696005)(52116002)(55016002)(66476007)(5660300002)(83380400001)(316002)(8676002)(8936002)(9686003)(1076003)(6666004)(16526019)(478600001)(86362001)(6916009)(186003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: zIkx7awNifQ/JHn/s4M/JJ9tDnqgK9ut+Lh/zuWRzJ6U8N0LB7t3mrOZ0+wRII+ou7HaFRbzcsQIOWrsgVwAgGRxKkFx2TSHcjN1dE79mGeUAHJkjOXMBtCdBsR9drdE7bvihCkrH5i/OnVZxkHYStsQXg9TtJa0RXhJJTlTXUinPNyHtzhJoDPifpNktDUV3AEfUwGHTn7xp1d2LYHViFHrbbQoy0XneiXSbwpFVtFooWDsVDdZyjcNWD0QAeNEBOS5edYh/m/sypOOgUBL0Ajo2EdWgKtnweBwwKfRZSx4AH9M2UXeaIO2LlA9jzlpmiJ44JiH306vkpMcy3O47nQsWaSuo0jIssLyXc6IDv4zNhK/EUvUd7J7TeP5Ngg6UoEtmthjxkSABZwZbqczc2Y6bD/8fCT1GnYBu8wo/o8rE5grMjmL7kT8opgllwYUMPTDaddmFXEIb05e9Zdc4zT7HMHj1qyTWfqAo/9mSQq145TNs0jTHovjUz1MdB9+YljOo22xW3MYoQkqWIP8zw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8886d59a-4604-4f02-2994-08d8340a68ab
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2020 21:57:38.5898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hXDAlPCQQSjhupoOvAzST88MH05Tz96vfz2MCRPFQz4RWJSohn4jJ8ky5qN8yccl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2775
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-29_14:2020-07-29,2020-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=980
 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 bulkscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007290145
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 09:22:36AM -0700, John Fastabend wrote:
> Doing some refactoring resulted in a kernel splat when reading sock_ops
> fields.
> 
> Patch 1, has the details and proposed fix for sock_ops sk field access.
> 
> Patch 2, has the details and proposed fix for reading sock_ops->sk field
> 
> Patch 3, Gives a reproducer and test to verify the fix. I used the netcnt
> program to test this because I wanted a splat to be generated which can
> only be done if we have real traffic exercising the code.
> 
> Patch 4, Is an optional patch. While doing above I wanted to also verify
> loads were OK. The code looked good, but I wanted some xlated code to
> review as well. It seems like a good idea to add it here or at least
> shouldn't hurt. I could push it into bpf-next if folks want.
> 
> Patch 5, Add reproducers for reading scok_ops->sk field.
> 
> I split Patch1 and Patch2 into two two patches because they have different
> fixes tags. Seems like this will help with backporting. They could be
> squashed though if folks want.
> 
> For selftests I was fairly verbose creating three patches each with the
> associated xlated code to handle each of the three cases. My hope is this
> helps the reader understand issues and review fixes. Its more or less
> how I debugged the issue and created reproducers so it at least helped
> me to have them logically different patches.
LGTM also.  Thanks for the fixes and the tests!

Acked-by: Martin KaFai Lau <kafai@fb.com>
