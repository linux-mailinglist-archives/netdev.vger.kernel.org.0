Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A88F816AE5B
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 19:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgBXSJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 13:09:55 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25318 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727438AbgBXSJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 13:09:54 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01OI6qQU021416;
        Mon, 24 Feb 2020 10:09:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=DYkox5S3fgVc0XXu5zT9oobYrunoLW0IjDGQVfeIlik=;
 b=ogrGOsYQx7hJb7IZMU+U06b1ZtKgj2aPpRltVcWxSRLjsxrKOxbc+Ry8fRaCrIC3KUtn
 29adxZbX0GQqOoPzLogtogMEzZE4NAuDes/eiP9xusg2435EdUMIY+gpP0L+agRVu/Mw
 a46kNsCS/uI4LTeVw3f2/yv0uu5O4WiHuHo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ybmvkecbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 24 Feb 2020 10:09:52 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 24 Feb 2020 10:09:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BSjd9qqMIDrsUqrArabfpG0uktnX9jFB9BPEiEuMolm/4XtCoxj1NxVEkM79sRDR7f5Fy8qiE1l3O5g6/r7gkKS1i2eiUMXKHMUHRtbwUxXVh6SLB4yAtImRwmiUMakBz/wR4CjrNLxA3jzDe8wYJaO/313aWGWiFtrCQurdbC43PkVfk/UKaBdzeqpi8KpR9m2AxbuL8i74yCtfwqAylDqRY1eZl3tJGcaZQzbfQk4WBht2Ko0HtVxLWBuXzRSgOXx9fUUJmovnNI3Muq7zePtcQ9FHrITCo8bIy9GibvT1eEiMVbH+BecMiQZARKCaqGSBcoQU9nZ/J/Vb/PFebw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DYkox5S3fgVc0XXu5zT9oobYrunoLW0IjDGQVfeIlik=;
 b=HauVPtCMNtf6h4Z3q+33eMEpL7uMPPoNLfJ7hf4bYwi6wf6WTx34Gm6id3s1CHqWtYeIeFVYx4Hqr2gCFPkbVRxNPXEshrsObG9Onrfyl+YF+h6hucw8/lcupVrpIAMFFBmw4FfaegFUYZH8bL87d8bgzxykHpCA1ZnqaeIQwFsfPCfPngFci8aaD0NzsLd0GPI+nxS76HcE5fi2dy7xnGvhgVOc84OiwVIXOs8K6nZnW3SMY9teA33v7oFkH79p5ncWK9IB9nkGxEJ00OAw7jhO0/SQhrgpZmLpjbowo7BGM3Ze7oCtQOePNHWLlHmpZm7GYADKDUhj2paLgA/0bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DYkox5S3fgVc0XXu5zT9oobYrunoLW0IjDGQVfeIlik=;
 b=J7+sdraEws69RlyBqpplqlbEGjKpU75rHpRHhU77kYWY343dNhUFD6ONVvp/NecEXBPQwZOoaYYCxWC7CMPSAXbKMKjomKOZvOLOHGGdSofn0+i6lmFfdrpcep9XNEG6O9IPpMG/tGkwoDVCDDrkTBKWGsVw+lp4RUIf6gnuoCg=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB2933.namprd15.prod.outlook.com (2603:10b6:a03:f6::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.22; Mon, 24 Feb
 2020 18:09:50 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2750.021; Mon, 24 Feb 2020
 18:09:50 +0000
Date:   Mon, 24 Feb 2020 10:09:47 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@cloudflare.com>, Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: Run SYN cookies with
 reuseport BPF test only for TCP
Message-ID: <20200224180947.rwobcmeb4y5vt4ue@kafai-mbp>
References: <20200224135327.121542-1-jakub@cloudflare.com>
 <20200224135327.121542-2-jakub@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224135327.121542-2-jakub@cloudflare.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR12CA0056.namprd12.prod.outlook.com
 (2603:10b6:300:103::18) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:500::4:bf41) by MWHPR12CA0056.namprd12.prod.outlook.com (2603:10b6:300:103::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Mon, 24 Feb 2020 18:09:49 +0000
X-Originating-IP: [2620:10d:c090:500::4:bf41]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c3efe88-e0d1-4d46-6f3d-08d7b954bd1a
X-MS-TrafficTypeDiagnostic: BYAPR15MB2933:
X-Microsoft-Antispam-PRVS: <BYAPR15MB29339A5F10BB0E58F9441FA6D5EC0@BYAPR15MB2933.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 032334F434
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(136003)(366004)(396003)(39860400002)(346002)(376002)(199004)(189003)(52116002)(33716001)(86362001)(9686003)(8936002)(6496006)(4744005)(81166006)(81156014)(8676002)(478600001)(1076003)(316002)(5660300002)(66476007)(66556008)(2906002)(66946007)(6916009)(186003)(16526019)(4326008)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2933;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IOpRbNCGdXs+qcenUlQ41SIiGE6hzMykbQaEGv5YAksYaYna0Gm5fWMLkFh7mNLaVv3h/A7igBKY3CK6EkM/3kwbkDQ+n5PK8DVwJCBALAQqiwmeMcTjzjyd4MLZi0b9NaJKQP8GeIgxb2oWZ2ItKsstNBUgzITJxcFcvkT7mqFG4D9cyPze0QBryh2QTNkdux5YaH0Si7gC33HdD4wHPae3aqiNOcBTGrTlngzIMIItYvUAS4QqEw+hAwOhX7BM9igUVH0J35cNSePVSBVY62B/fI81KexRMnZOrfUff5H6A891aDurx08x5Dtbp5295BIebDgSegTvu8LbDS84gk9xXsMWmqlhRYG6pO09GvoUSN0Pgjlg/Br4eC489YtY73hOGUjILgTAGnq4c9Nt/kR4hp0A6udHZpys6lwZ+imyRHqzH3JMbTIf8TQAJTmy
X-MS-Exchange-AntiSpam-MessageData: rQYRqyFV3EL1q+sVAxZBOCjjRf7gyUpNWqc8J90/r7sh8/xxgCPw2/0ckQz4RSE0IHvoEANtV5X65g66d4ZlWxp2iQsqVd3pTOyAJIDuIVN9wISHIQpqK5t5eHtS0GQtaT/u5ZmMTF8IQ38JB8v56KaJFpXNreS0FubwA1gSCHvFZYiGE9Ta4FD+XQ+eEkKg
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c3efe88-e0d1-4d46-6f3d-08d7b954bd1a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2020 18:09:50.0470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IBxjRNjKB8bE/C7erX1+BDvYrp94GcutnLPsgGSiDymevCbJloz46NbqFk4tOpx/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2933
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-24_07:2020-02-21,2020-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 clxscore=1015 spamscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 priorityscore=1501 mlxlogscore=964 bulkscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002240133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 02:53:27PM +0100, Jakub Sitnicki wrote:
> Currently we run SYN cookies test for all socket types and mark the test as
> skipped if socket type is not compatible. This causes confusion because
> skipped test might indicate a problem with the testing environment.
> 
> Instead, run the test only for the socket type which supports SYN cookies.
Acked-by: Martin KaFai Lau <kafai@fb.com>
