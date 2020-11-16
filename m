Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570A32B4D87
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 18:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387589AbgKPRid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 12:38:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15724 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387509AbgKPRiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 12:38:24 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AGHTYKG022760;
        Mon, 16 Nov 2020 09:38:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=8zM6cjAvTNDuiRY31Hjf0oCboOhyyMaLbMJsrWQ4E0s=;
 b=Usx9JrLw9op2CuYna5zoa2UsnMXJxkFPXrV7VDWEJIQDzDVe4oU6oxMpEbEgElPt7RUP
 5xujqLb3Pox5ZZl/YSgzAf9fW04ZLf/yCzwPBtFp7WIBnj0iUAyhQAE5xTQjPjvAW9YF
 N5i1U32vynB7YXwEvcMdLNv04VnqjDFlhK0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34u09gwx6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 16 Nov 2020 09:38:09 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 16 Nov 2020 09:37:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BGVpQf8UJAB6XRCue/gyOoVSxu5j970U0WU6ou4kc7dzgNqgYnrXunnonqNIapY8M9TA0dlZXnbBUKLGYaBkWsmwzAqCDcFO7xvsTi7c4cztV8nYJ45vWmU4FZr9lqdXe2FIT4DSeyUeexUsO1TAxLzreDLjnL/X0jp5GWoV/SyPhYTRi4LDajFzhS7kB+c471IjDBbSBy6ZZOc8VHZo1R1NE7/Vp+I3WyvCyv4y+c4LAdoHs4Y7S9PtgKvEyNP+n+m8dCwje2OaZ79fdyRRn9ij7faWMxODNitIYCp625W+a+pOMENv+Z1zdQco0qxKWSCZkzFw6npo6gbdKNa8Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zM6cjAvTNDuiRY31Hjf0oCboOhyyMaLbMJsrWQ4E0s=;
 b=WM5Wae7hvfg49EFDcQL7Y9gAmAe0BCP8VJZ39lEt6kqma3rT7fNb3szMFMWFTyNlLOZzQe0aQsRiZojf7RWUjkDvrnyGfzt7U4NW3BeKrOX2aeB+Ymf08pxJcM0asqy56i4wSJmPRnRdTf15/CNAxgwpRvg53z1bq7zUsgv9ybsmVIUxd08u5baoTllDGMqFdkJ3arT8ZSfqNuP7VbrbRbbs8hjKpxkj/4KwlAQkOqXQHqjnzE8dR/dmbCdpoWSgJDoKeal18Csrs06FEMN7GxPo4wp/G0TuxKk83mbnLIA9W6rBmx/h00dhqiQH9afb7mnV88A2YtzkCivPSmuBVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zM6cjAvTNDuiRY31Hjf0oCboOhyyMaLbMJsrWQ4E0s=;
 b=TV0E7v47vPy7bW9k6MRQHnKsi/8EaCAvKk0Gr9AYjCkNpGkNR6oHPcOmds/4ANcTBChp3PJ6FVaRtXvti0cPpzEj8D4N+um8RsooxAyz9uX3CfcX3bPOy1lru0YmPKzedWFi4BNyPITGw60pgu9XA6OYJeRTYlgLj6kgEBckgJ8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2200.namprd15.prod.outlook.com (2603:10b6:a02:89::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Mon, 16 Nov
 2020 17:37:42 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.028; Mon, 16 Nov 2020
 17:37:42 +0000
Date:   Mon, 16 Nov 2020 09:37:34 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2 bpf-next 3/4] bpf: Allow using bpf_sk_storage in
 FENTRY/FEXIT/RAW_TP
Message-ID: <20201116173734.a5efp2rvg43762ut@kafai-mbp.dhcp.thefacebook.com>
References: <20201112211255.2585961-1-kafai@fb.com>
 <20201112211313.2587383-1-kafai@fb.com>
 <20201114171720.50ae0a51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201114171720.50ae0a51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Originating-IP: [2620:10d:c090:400::5:8f7f]
X-ClientProxiedBy: MW4PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:303:8f::33) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:8f7f) by MW4PR03CA0028.namprd03.prod.outlook.com (2603:10b6:303:8f::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28 via Frontend Transport; Mon, 16 Nov 2020 17:37:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20919657-ea56-42a8-f52c-08d88a565206
X-MS-TrafficTypeDiagnostic: BYAPR15MB2200:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB220046175F070E9700DE37A5D5E30@BYAPR15MB2200.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Hs8d1Z7DArLPaHRJ+aARahKYe6rohOsNIKAPkUb7nBMjJlv2UFHEEU5VeanwGyfoUbBjmvHMmeqRv3TxXhkCKdgLbN7XBP2eRjzvtfMbl+VKGyuJcd/n404OHndxbBQBltZYrQeyAcADJN0KfN29ScV+xyXDeP3FRO1b1f6IdlzYtfrsoidua+bHib7lVHd6VggnEkpLARNjqimgRL8vk33q0FxKgMPOzX8uRzIW4FgVcAlmnvb4bKd00v3J5+EJn5m/FkF1pr835L0FV9abi/iml19c7/kOAkOjx0qvwH+ekio+d9BETw1WQyJ2QhwtGq+r3GKkbCtZbjNMpJ8Yw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(396003)(376002)(136003)(83380400001)(5660300002)(9686003)(316002)(1076003)(55016002)(2906002)(4326008)(86362001)(54906003)(66556008)(478600001)(7696005)(66476007)(52116002)(8676002)(186003)(16526019)(4744005)(66946007)(6916009)(8936002)(6666004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: SA7ndQub0VUNzWf3sg9erBypKg3HRpAgu+64NzqC0rcDi+QGQiQ37POMpTI8PFuwcxJ38A0fC+fd3q7E6SmmGHON2j3vqaSViTisRyOTfbfH96LcZC5n+5NItzkk6zTWWu64aoXgTIPy1oX6SVDvMSW++lI5NXfcIctDGAr96tHEWlB9wP0GMcBRsSsAfXEYX9OCKowdAizheUvoYuI21DSeQHpH2urviz3OOapLc/wO5kx50lpeBqJV0DzUDv4RllnfrmJamSm0X6eEuHERV1GvMJz4QchqE5vJRcph31alqXD6AeeNsouDn8G7sqMBkptklDq0JB8bWg7a0VgchwjgTLpNp9nYnSsKlrqbP14Sd29pB1D9Z4whhBD3TsLzBoIPSUkTA8CSghEmONGaM6inYUTL4iSAc/yalJc47pLC/oyLEKzCo0nUiRp4N4HFqUQhxwkq+Y4exIO1snmX3F1xihB/gpB99yxemIYMIgafuGBePRRomLKDghiWZSnOCTVSEPZr5XaXEVCHTlyJswQV1tPAG+4gDu1uQbwuiDowEQm4QtOasak+bz+ECEYYsnU4WsVrCL++smRph7f4GuxlcOV74oa38AaHk0fnpGhCh66jglBmPaOYl4O4ftdYwBpCL75q01v5GHBoKMRkV+0YRwmBe94ZztwdXg0GfYwtsgCs0ODnGF0rZBKE47nKdrLjISJRX9tmagi4nLJQPCFKqSb1XRD+0a8VNjql3HB6qATnAzFyU+pZK5EVGA+CZgIx5Osv3AB8TVBURd3dsCmJQtVyEqEWqmHW3T3A6C1ZNz2pl/be3pYZUE5yu4gs6TC56cgrnRyO/G+cWhNDp00dnxToHM2DcPsx8f4cLZy1J8GTBaHGqlwt384yroCp2uiz9ZRWKpFaVWiDNAPZWly1vDUPRya4ORHdtzfHUxo=
X-MS-Exchange-CrossTenant-Network-Message-Id: 20919657-ea56-42a8-f52c-08d88a565206
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2020 17:37:42.7899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wiciTZ/UD5jk1bLvgygeQu5ZY6I917K5ytkQX5nQMokzVV5+WosLcZYHQJvSvV9T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2200
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_09:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 spamscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=935 suspectscore=1 mlxscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011160102
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 05:17:20PM -0800, Jakub Kicinski wrote:
> On Thu, 12 Nov 2020 13:13:13 -0800 Martin KaFai Lau wrote:
> > This patch adds bpf_sk_storage_get_tracing_proto and
> > bpf_sk_storage_delete_tracing_proto.  They will check
> > in runtime that the helpers can only be called when serving
> > softirq or running in a task context.  That should enable
> > most common tracing use cases on sk.
> 
> > +	if (!in_serving_softirq() && !in_task())
> 
> This is a curious combination of checks. Would you mind indulging me
> with an explanation?
The current lock usage in bpf_local_storage.c is only expected to
run in either of these contexts.
