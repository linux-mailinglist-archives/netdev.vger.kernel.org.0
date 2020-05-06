Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E9E1C7D05
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 00:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729875AbgEFWGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 18:06:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47786 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728621AbgEFWGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 18:06:44 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046Ljqes025421;
        Wed, 6 May 2020 15:04:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=N9hSj9NDXFrGOhGBoOv0mjohWD7xsdq/VJYqx+FaFy8=;
 b=fdeZSXiWbHx33jVrADcn9p3dC4e03WHwYDW6XDN8G9oAYPCylUUkEPwl6dOaf0TffIPY
 F42LLXP56eMTJy/s3KTWrzNSXIU91v0bM2+o2qapIgLyoXiy2t00OsirYCSHpIvMSqFv
 8IB6qmx8vaag1n7lg1vgKodTTs0MZOYK5EE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30up69cs3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 06 May 2020 15:04:48 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 15:04:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4+xHJzGc7ot1OxBevffBgR/kFp79BJXEoNe3OucRPSzR8OR/jZ9Jaa2nLXNSJO8+JC1mOVldee2uNy8IdOwzCV1AZPmnJlIRQ8OVssu4ADGpdyWi4tpZ1RESrfUI+UMtI2wrG9nZNkPnPcaYhGhI/hnL4dWLj95jbhbwAZ47UokkaE3AImylsc+ERPYGJN6HPL3WVRpSNLYZH6TsmgWUfLFt+zkHQ0ItBK0+s3JZ/lVvJFllGHsCWaVRCEjmEcvq/dsHHdRAOYxo4CCIVhpiDDQOW3G5ZSjTucKhcaIjS+UYXFAO0hUkFk34/9vt6TGSuHxsJuasPZ80efu7a3l+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9hSj9NDXFrGOhGBoOv0mjohWD7xsdq/VJYqx+FaFy8=;
 b=N7r3sLf0RHL0xSzA9l0oX+i+nh+g7fQOLP/T2OxTKmsm+n00uC99KFiZlok/3QIEaVk0nQrerOLcPL7RdZ6/QrDDLpE3OH8D9IoEDX7fqH7IZbmh7Z02hZSoxZG2z7hK/Qmxwgx+AuPil0NMxNkOYVrVdQhyNaobsCAu1aPsO7jJbEC1wSYNkkOBOBHWGXcdHQpkQy0G0ccrrQQWOl5M+jaB1mt4QA290TgFvDwa+qejldMNrtQ9ORHZRQbfGVCJBVMoJgrOdYHSabY6frU6uNyiIGgJsTXCEYCL5TTTydaB/5+yza1bzg3TEzGRhGUKWj7kfPvmDKHUZReINqe1Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9hSj9NDXFrGOhGBoOv0mjohWD7xsdq/VJYqx+FaFy8=;
 b=N7rEJHAZiI8v/zNW9qAhjkKDn/WnfLrEF0UhyyB4yYOF3yyiTQHSDV7Z3ItX+Ls6ziSwWkA2GkkBsHH4tqKIldJiR+oLIYD2Q8xeFjGCmz6ddUvOWlJYUd130fCB+DfpbZMEAQ8MRl/aJl8xZ8e3rmdwQUW7Pajy+s8WX2fGV8E=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3834.namprd15.prod.outlook.com (2603:10b6:303:4e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Wed, 6 May
 2020 22:04:47 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%4]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 22:04:47 +0000
Date:   Wed, 6 May 2020 15:04:43 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jason Yan <yanaijie@huawei.com>
CC:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <udknight@gmail.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <x86@kernel.org>, <hpa@zytor.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <songliubraving@fb.com>, <yhs@fb.com>,
        <andriin@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, <lukenels@cs.washington.edu>,
        <xi.wang@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] bpf, i386: remove unneeded conversion to bool
Message-ID: <20200506220443.pmszq4jnfr2pcjp4@kafai-mbp>
References: <20200506140352.37154-1-yanaijie@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506140352.37154-1-yanaijie@huawei.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR07CA0068.namprd07.prod.outlook.com
 (2603:10b6:a03:60::45) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:3fcc) by BYAPR07CA0068.namprd07.prod.outlook.com (2603:10b6:a03:60::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Wed, 6 May 2020 22:04:45 +0000
X-Originating-IP: [2620:10d:c090:400::5:3fcc]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bfb23930-c184-476e-1e3f-08d7f2097d3f
X-MS-TrafficTypeDiagnostic: MW3PR15MB3834:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3834748C79C1BC2593636F6CD5A40@MW3PR15MB3834.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XI4U/XWYwXeB/fdOSYFQIVUpigxOh+Dva1ms2Xm3nmEPBYAC4pO6BRpHBSp7MAfJUoOAXd88+ptv5aJ/ZVKau4Asxu2HIV+eInNIXXjbaXvgfxP56xa6dSujO+8a/FlmMCISsmy76dF0ulUcT/LF96egjyxXWtzgV1CU6nq+tzP4QBHX08VCbtEpklHZ2oBAn/jMaRUdctf6iqXT28FpHo/civPq9bqEMyXvS3CLx9xcQ8Czwd+Fg0TiHGeet0CZ6wC3GALC6L0RHrM7VfjxyVsPQ0E4RYGucHR3PD+dsp30RdHpU1uxy2mmDUnCdt7aZQRXtsfvrp9KQ1uwZVGXZ+7Nbztyj79VUK7Vowp6g0Se64mcape+jPFZUIEBGahh/NqL5m8eJe/eCmIOzMz0EmxXC2zrIKNkGq6sQthgZC5lYSfwc83BpUuJ2qJYM6kkuSCL5a5BDSG2tIVqhGXAxYde1oq9ascegoGpmu90N3YuWPp/LFcpedow+gs479Fig3ALLxpOFMFtSsS62e4Iaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(346002)(136003)(39860400002)(376002)(33430700001)(66556008)(66476007)(186003)(66946007)(55016002)(478600001)(1076003)(4326008)(316002)(33716001)(16526019)(33440700001)(2906002)(558084003)(86362001)(8936002)(8676002)(6496006)(9686003)(6916009)(7416002)(52116002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: uaG0LGcBV5TxWdZ0QK2Rr6EhMgYsVQt2KlPkE23eZnA4LWnp+ezR/iPvKxvUQE8snbDO7aVp6pTJbLKCTDLUoA42omjW/TjvKDMV7sGuXCyUaYCFEO2hlvB30AgeaNKZ/HPG+VQ7xQs34pWgGrTeg6N9mN4D60MH9H88KB7b7hIgCTGoKInbzieweADY7LiThoCeIYKmO5OQEEjXcqr1p93/CihOqIqlF/N3jBg5eaTR4r1e4b/t3GHUFGpSp3wVb+daGiU6xhP0Jl4u0Au87v6BED+A9OK9xTbQa+9k5xA2D4Ua9LsPYRZrrTYx2utnguUBdzNCVuG9riFYW5nCWEfhiTivUGdBc60+j16LWLhJZS4Ylbv4xhRT2fen4aVc+J9HiQz7geY2zn1t4whc6hOIjOZnEK7HER6iOmEsGMSN7pA+wbdVu9h8DL0gRQiLbiAgLWClhnrU41fFWSHc3NjDqZDbh1rexh+dMOfDRBvnQLAwGMbWqv34X0026E8GIFFNYFC4iKc1wSbUlrDCBGOPapp8LBC3O18ISHfM5MyYRYzIKZa62lCz4n1P8VMyXM6cAWKx3bFHAHKzuiQp5VHLr+BFn3In41+fLKq4VNBbikQiwNZlhiqnapc8bsnAGiLOZ53VVizl7ntnY3rwB/v/pDmXerySKxoWQDhuy7I0YVqgo0orb5MCQ83n5yI51mHxavJbbLkxWAKpYtRICz/3mUOxq3EsFVE8FQMtL+gaUhuX3clBtbBOgECsxI4JMZVU/vgOLSYNZojcD/pUYeCfkISRpVXR9+41chZJt54jwYIeiOH5a2ByLwFX1J7FnZwb5yosIOHVoldiswKGBg==
X-MS-Exchange-CrossTenant-Network-Message-Id: bfb23930-c184-476e-1e3f-08d7f2097d3f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 22:04:47.1247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /9zaox/Va7RbQbKlXQIB/ggZPtRlXMJGRKXopQZ42K38RCmh9xfIe14DA7GcGGGj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3834
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-06_09:2020-05-05,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 clxscore=1011 bulkscore=0 impostorscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 malwarescore=0 mlxlogscore=533
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060175
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 10:03:52PM +0800, Jason Yan wrote:
> The '==' expression itself is bool, no need to convert it to bool again.
> This fixes the following coccicheck warning:
Make sense.

It may belong to bpf-next instead.

Acked-by: Martin KaFai Lau <kafai@fb.com>
