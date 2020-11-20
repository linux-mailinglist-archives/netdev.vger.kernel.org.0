Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400A92BBA1B
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgKTXVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:21:37 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17330 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728515AbgKTXVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:21:36 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKNE9Qn009681;
        Fri, 20 Nov 2020 15:21:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=vAoJQofT9/61Eme/Xw+Gwz5fbyoBJw/QmzluRPZt2qY=;
 b=Q+nKrT5MqH5mN/hUg3+YIao3ePKHHb+WUfY3iHEk2doVYo0Oz2rZbk2fXUMWsbJH+de7
 93LMNTyX+6S4tXa1L7S4vPDmQt3NsdUJTw+VjR1NLaEV3h5NzWfbDkJvrxbhMQDLzw9y
 /ddPDXJ5cNclIuj0Engmri1yNCz7EWv50nY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34xemp37ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 Nov 2020 15:21:21 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 20 Nov 2020 15:21:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCnsuk4/b5N3MHKCyX3QtroJH/4NknXBlwjb8m9iUiJAqN5udCyOYXxOjuDMCp7htcdACWuF/PB2wAlo5jlx6JP5r8vbnYHEFaLalTXQS+w99qBHWeqAsXACc70uxbBQGv/uj+8/fscCo3ubGsBfCHhcJ3sMgKFstqI2g+Md7XZDIDeBgwXQWRf6CgIPGy8TjzEHUN0OD7S2LObcTB9MCo3X4hpb5WXYPVUfIYAuSJBrnQ6foPM9w/a13cSqmkHee0W3ZGMWc8ycZbKyLqREwXXU0WYP12MEnsJJRxdnH4q7LXv/BJDPhrM4c/iFSU/GQ2KdsXJMzWZC1vWJWUoamg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAoJQofT9/61Eme/Xw+Gwz5fbyoBJw/QmzluRPZt2qY=;
 b=LuLfwqvBj890o+Cnhb+dhRfDMq0tdwaqXjN/S3zQHy1e1wmhgdPJFqNxDkcODF7cu53uDJ/Pwysw+0C11IMG9/6RbBiUGRWP4+HKYo3nBNuGPJ2eRXFVuKwVmef8UCMgtjbWOo+cs+SQd3d6dMZ78Wl89fn9rmWbe67o6gG1cWGBVKgNi8LXzPXxn9/Ii2DAwuJRWESSf4oOk0+JvhX4pU1ya26rtGO04cVuZzYyiMeiuCB6pToxXnZNm6ySq2OKfydgBx//Pa20oK59rOd+d3CmaYqooAU/Z1t7uEnY8o24zT+LffWU1ntFshi2isG5ULTNgFvS7TKARJmq4/xfmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAoJQofT9/61Eme/Xw+Gwz5fbyoBJw/QmzluRPZt2qY=;
 b=MnIc+9sTPzmXkWLnuVQ2aKGxNhuCX/56Pz+xWJTvte96PPnOiM+WcTNRXpBxXODgS+8H1Vf/3mPcXNENrjVlVKulF9HXx2zHvDtLXwz8o6VCz3YZYPOFXFLMzvQl+y73ptLrRGWulqht1i8ry80vEqPjNdqNSWPkBRAzunv3LYs=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2696.namprd15.prod.outlook.com (2603:10b6:a03:156::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Fri, 20 Nov
 2020 23:21:17 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.034; Fri, 20 Nov 2020
 23:21:17 +0000
Date:   Fri, 20 Nov 2020 15:21:11 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 5/6] selftests/bpf: add bpf_sidecar kernel
 module for testing
Message-ID: <20201120232111.urepi4sqrr5oekf3@kafai-mbp.dhcp.thefacebook.com>
References: <20201119232244.2776720-1-andrii@kernel.org>
 <20201119232244.2776720-6-andrii@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119232244.2776720-6-andrii@kernel.org>
X-Originating-IP: [2620:10d:c090:400::5:603e]
X-ClientProxiedBy: MW4PR03CA0164.namprd03.prod.outlook.com
 (2603:10b6:303:8d::19) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:603e) by MW4PR03CA0164.namprd03.prod.outlook.com (2603:10b6:303:8d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21 via Frontend Transport; Fri, 20 Nov 2020 23:21:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5876fa68-ed7d-4f76-4f98-08d88daafb35
X-MS-TrafficTypeDiagnostic: BYAPR15MB2696:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2696D8444F3B1A969563A76FD5FF0@BYAPR15MB2696.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QCSrcW78XzXtX6I//0/+In6JgDiuAmv/q29FjaVi/ZGmvwdDbjNW2WQG0P97vwndjPYqtHBiCzbiNz0FgAMvSOUnk6AHR0o3Uo9funB5JyaO+0Z+fccOQLZ9x3HsIN75DImqgsfdk/QxdqmIweiJScDM09HxWDhBBUYIkMFhT2WtZF2kz+hUOxmWTXYzCFMokx9oN0hSVXfDg9rf963JZkI3CV4jNag4r4olcUTBud5j7HZwKBMVKARzGnCuZz0PLX3a1FGFiRlCui4Z0AyxR9y6Bin0IazUA1GMakwa2xWJGj5yp5BT+13S4/UPizkG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(39860400002)(346002)(376002)(5660300002)(8676002)(55016002)(2906002)(4744005)(7696005)(52116002)(316002)(6916009)(4326008)(66946007)(66476007)(66556008)(478600001)(9686003)(1076003)(6666004)(86362001)(8936002)(16526019)(186003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: rOJe4oBNbcp4pmmpEwp3HRzYaaFhf4JfNJiZuRVKjSzH9ZFwAWMM9YSrl+yl1G4fRNkQtPcbcY1NErymWDhH2QliHjflmilrZ/w0cUwocInZQ34VITvi4NrPUEtOFIKBDSJt5gDgCFz8tFhwKUAhkClM2c6HAYpa9kbriytcrBa9VrvdJHJYkyIAyHy8h+C1D8bt29PAABzNY5fcR0EFrh5gem7V1Rr2AVW6/Ygpp0/HpNn335GCsOtHeQlKQCa3WfixadHjm5p6rRYIkJi7LOsGUXuiVOMEUOl5FADXYxhkXod3v89Tot158HZzMCEAZJVxKf9mRFFKcMRDpVftJyOm/xY75jsb0n/6tTHLzD1wiU0g67qSVvUIp/jpdBYBQ7OiM6ChmSXPERcE4yHFdQ3na0w8zqR4KKVaTZ5Voi5B3PV0afLMWluU4riR+HrH9O30M4wFIAm66GSzZwlDZxoD16L+lQ7hgPTuzFFnOVapR6thS15EpmhNQQNOiLIkxbP5sEqs4CJAsWVYnP4Xyx1MpSORu8hqn0IweXdvVd8ttqMHyvjBrU7zhtJsQ59vPd96sTucClMkFcZtpQtqfLFW9fsbicRkW/XIdwPMaxpD1+oMYLQTv1h42C4Cf+HZucAcyzWk7+64HHctsafEmTTagOeFemV8RFjiHEw4Ot89mbcFAbWLj0U2BdhubM6LTS5Spe3GuNAZOvxNpUMIsQe1o6fNuQ+AYWSpf/TLCPaSMXWNIvYLYQtJ0NBrRt1ZyucGKzLVaCdKCJpblJIAO4Dejk9mg/4KZlidpcKsjZB/ZofkB7MxBroyLUxfkM/UX+4mq8EAP9/b6RPlcd1S9PnKatlROND3kdBB2g2LQyeyID8KyXvsaK4gxKOleqvQfAn7r3j7rjRiOnsyAeE/EEr9rSn47UlXtExGxBpAOVK8fNWIHounws4hnRPOtQnQ
X-MS-Exchange-CrossTenant-Network-Message-Id: 5876fa68-ed7d-4f76-4f98-08d88daafb35
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2020 23:21:17.2886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4qTzIb0BBU8jAKGyWQzVdQDobAGbPLrd+P81Ri50DPr4+sK7rsQG9HdcAgm8dD4f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2696
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_17:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=1
 adultscore=0 impostorscore=0 clxscore=1015 mlxlogscore=788 spamscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200153
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 03:22:43PM -0800, Andrii Nakryiko wrote:
> Add bpf_sidecar module, which is conceptually out-of-tree module and provides
> ways for selftests/bpf to test various kernel module-related functionality:
> raw tracepoint, fentry/fexit/fmod_ret, etc. This module will be auto-loaded by
> test_progs test runner and expected by some of selftests to be present and
> loaded.
Acked-by: Martin KaFai Lau <kafai@fb.com>
