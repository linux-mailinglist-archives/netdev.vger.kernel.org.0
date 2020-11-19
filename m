Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7D72B9EAE
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 00:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgKSXvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 18:51:15 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34248 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725937AbgKSXvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 18:51:14 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AJNliMc028765;
        Thu, 19 Nov 2020 15:50:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Iac4l1k9Mjc5TQJe1gfjLYUzVfnpQ4c4H+sQgQIdb6k=;
 b=FfdYHotU1gkhnnRRdVxG3ToyBcsfIrpsUl1LXuZ7+c+qRj9MfnRvIg7T5bvf1B81rNAV
 1xj/zVGRXWIEnu0RjjIh6TQ8O9xgITnA7T9psXbEccUECNcDw0FkzP5eB8NK/kCuFP3l
 1EyvXe/CjkGolfh6CS7sBM7bmMmLdROgzRs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 34whfkqpxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Nov 2020 15:50:53 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 15:50:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nkwv6mfKgtL3fPbgU4o0NM43GdX60OzxwZ77q+MG+d4c+bCKTiIX6xG2OQu4EVUP/+bwTCwTik/N+/SV62clNknuXtsSkP2pcVu20EX02cE7lV2CIi0DWlJTg9H0bwYWNCbUwZ4JI3BwtTfTE1Hrb87S3c79L9LN4K5IZ8icYYAsj/ExpDY1+lablTW7CVJtwGliYV0/wojiCvDwp5LF9i10QFubUdx9+nYthUCv7AtFS78e6wbIAILFpbsHU08Tm1YbdPe4qi6PjhopXl3HKljHdxWPU2UHbVPkkWI29i+YEy+298tKtJEH6C9fuAHnXyeO3dTT08F50IQYQKAOCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iac4l1k9Mjc5TQJe1gfjLYUzVfnpQ4c4H+sQgQIdb6k=;
 b=OwKEmqKivDyeHMxPgFsTQc3hh/hiVq33YtJTaERsDwexyTGy6BOh/i+FmLY8pSB7Jvd/P85ym1XkeGMmpUJDgTcZhPwgVtghmYc6GVMk6Gnb/nzy25mZ6vu2E6waFuj3DsXGaFxmcfFqcIPrCdV/ToGdLmHbpk6PQFlRB5VM6ecaJHNgOEWRsevijNiMuqUQlgTcoZSud4a7+jKr/1Y/6hLgtSXXm2VvmLXGpibFycPGSCjtVpNGpzTLWFyKgnemMiyEd+iFnd6VVXKk/3N3G/JS0V7SvXEM72T9wG5iD1SYXWmMSj2reem1sl2fKHQYHmXsJyK7xDF/50GdeCFxuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iac4l1k9Mjc5TQJe1gfjLYUzVfnpQ4c4H+sQgQIdb6k=;
 b=kEzIGNISXngjzyeTfqvENF6iSBNJFKfIrNAmHab90XSjZyEjzQOjPFJIQV/UURVxUxvYD/ILN8PxNThRbMGeTAdpuaJGmTb1gIpHgXw9N/J5iBA26FzBbaqESo2qNW2rHX0noofeoHocIoxLzdZQKNqr0v4KRp3aY+uFW30hG30=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2773.namprd15.prod.outlook.com (2603:10b6:a03:150::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Thu, 19 Nov
 2020 23:50:50 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.034; Thu, 19 Nov 2020
 23:50:50 +0000
Date:   Thu, 19 Nov 2020 15:50:42 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Florent Revest <revest@chromium.org>
CC:     <bpf@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <yhs@fb.com>, <andrii@kernel.org>,
        <kpsingh@chromium.org>, <revest@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] bpf: Expose bpf_sk_storage_* to iterator programs
Message-ID: <20201119235042.mefu5pzrggwtzab4@kafai-mbp.dhcp.thefacebook.com>
References: <20201119162654.2410685-1-revest@chromium.org>
 <20201119162654.2410685-3-revest@chromium.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119162654.2410685-3-revest@chromium.org>
X-Originating-IP: [2620:10d:c090:400::5:603e]
X-ClientProxiedBy: MWHPR14CA0009.namprd14.prod.outlook.com
 (2603:10b6:300:ae::19) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:603e) by MWHPR14CA0009.namprd14.prod.outlook.com (2603:10b6:300:ae::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Thu, 19 Nov 2020 23:50:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6066631-0977-4415-e4d5-08d88ce5f182
X-MS-TrafficTypeDiagnostic: BYAPR15MB2773:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB27739E44B6B3E39EFA851C96D5E00@BYAPR15MB2773.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r0N+HAnL3tCaH5KqmhO8N1qj+h8SF21A51gOVdARmW4TIT+W5mLAyy45KWFgaN0LWjbLFFs3i2UDQLUkru/9pJ9ZsV8h+qZc4wBmDSe7T0/IBdu8gcCWUCkXxL7dOqMGbruqa8YyvbPwhHid+oV30kIonwxPd28ZAOCwe0O8TekOSSCuNTXFiOf8CqMjpA7eqUVWfeoG1AApOLtaQbjYrHzXQdhnBMc0wFkhE6XAobl7E0UZy8UegEMiKZQg5OjcKmU+f107w0RRU9pOVD/le2LUCE3x1DyYQ7mc+mrdUVdXG5DB/vqhP7kR1mQDAgS/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(346002)(366004)(396003)(4744005)(5660300002)(6916009)(6506007)(4326008)(52116002)(8676002)(186003)(2906002)(16526019)(7416002)(7696005)(8936002)(1076003)(316002)(66476007)(9686003)(66946007)(66556008)(55016002)(478600001)(83380400001)(86362001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: bqssdkv0d8j5Q1qjHX7ZPxXtGl5yO1M/OlV088c+zDYGBMSdY0+GWQKqYZz5qr96a6w16W1hNsXjzwq5IUqMmgQhKAPURHqxhydPY7cNHaebChzdYaQ1d723BRFd6JE6CKJ0q1IwfYnUBQHDJUYvP4nw9JDyKO7kkGCA3NZKJ6XXJ8846Ni7ZAIGam4m2JxnBk4a0TOcmXNhqrBHcx0BvlR9A7Mu0k2LmSW5uDlInLCkP+dT2FzPB66Vw2xGupROeshyGt9k45NMZNCYg2mw7pKVX67DvXnyVuGQmMYT/adqq+SqFbFuAV2dao2dutYD+9KxFur0VctqHGwYnYKj0slauNKl1Bp3L/W2QIfE6FeQ44btutfdy0FmCNKURHWx55aSB/xVzGiTa0pGYTVorbBBYqDIgVEEPbIRc0vbdtOv8vrc0gI54T16r55F3ksD6b/FNmuWywcboevi6RzWABSZuA6EujTZM6+qgnZrVt9o0RZSXPbHxbK9nCNH8HtXBgOi7eWFKJO6EhojZxS0mt7iD+5ynvB0zP8dMkcqPeXox8DpuakZa415aFEDvk2gN0C2KSiOOSIoHCqqKVTbegbgGd4GdxK8RpmM762P4l4suuVUb+ZkyfDIubzlDeA6ubPuv0j7pFCqZYEWPo36ZB7Iub3/cK2DGUDNAPTxxniLmdiGJoLFD16m+Kr8IUQZXLryK6fPoIjTGKBwi0Pej2/6XJj6a0kHrOHISM5f+BiL/areKGmVfJhbhNnYt2XA2eTWTt2wNtIyNGAgRiBbSo0cv7jnu4zAJ11HWlWa3UI7lj6VMUumw7NV1L6NILl0Kt/cRUnI61F+42SWvnLRQRCsZt8d1KX1n3bJshCyT+817jj55doi4itxS2wkl+LZqhuxDxxzD2pSMNcd0r/0zzbYHbq1VErov+AuhwOcLx4=
X-MS-Exchange-CrossTenant-Network-Message-Id: e6066631-0977-4415-e4d5-08d88ce5f182
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2020 23:50:50.2890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jm+IS78aUkcz5fUXktRUusXDt3NiOUivLzB/SbbQvz9mb2pc0UqWjOUqN4BznTrz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2773
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_14:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 malwarescore=0 phishscore=0 suspectscore=1 priorityscore=1501
 impostorscore=0 mlxlogscore=903 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190164
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 05:26:52PM +0100, Florent Revest wrote:
> From: Florent Revest <revest@google.com>
> 
> Iterators are currently used to expose kernel information to userspace
> over fast procfs-like files but iterators could also be used to
> manipulate local storage. For example, the task_file iterator could be
> used to initialize a socket local storage with associations between
> processes and sockets or to selectively delete local storage values.
> 
> This exposes both socket local storage helpers to all iterators.
> Alternatively we could expose it to only certain iterators with strcmps
> on prog->aux->attach_func_name.
I cannot see any hole to iter the bpf_sk_storage_map and also
bpf_sk_storage_get/delete() itself for now.

I have looked at other iters (e.g. tcp, udp, and sock_map iter).
It will be good if you can double check them also.

I think at least one more test on the tcp iter is needed.

Other than that,

Acked-by: Martin KaFai Lau <kafai@fb.com>
