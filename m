Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D3120AC2C
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 08:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgFZGOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 02:14:10 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23650 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725306AbgFZGOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 02:14:10 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05Q6Cu9w005410;
        Thu, 25 Jun 2020 23:13:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=AiH89HCX7a/rxre6S78rCPnYniNTa94rmQyt+suYNQI=;
 b=FhEm/773v+mpVoM4zDNgWlUuJSiquxI/UnBLDwlgrBpY/Z1qfSo6fX42QT3HGkOp64wf
 W5lhg32izXT/L8YJdeqdO1zMKzWJEdW0hSGT0xrriiePOaOCI3qAyyysZO8dxN2kr6su
 aCopRQAby3CRz8M/U1KHmV7wM90bzFpyX/8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 31ux1gkx55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 25 Jun 2020 23:13:55 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 25 Jun 2020 23:13:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iH7/MgLfIj9FOn01Uju2dMK031egoskmmzAA31s2+Do6a2bodxLN12PrGcZsx43oBIei7biNoBa1D/LChKRzerusEjym4sHOES5edrjgphYleIY6k94KFO1YUGHerDAjKphywLpov3PJKJ/j08DiYjq4zIfJWgR7nGTq1hckQmyfXt9jSjtWaCWyJ7hJgroEFsjzZSjsYpI3m0b2pfUkPuy6TqHipqB9u+C5Qg/Q/sWMJuE3a4oCF3z8Bq9xRgLtgoqAYXzf9xHHM+yQ09u7XI40KOSCxdBcYsxpJ9VJ/DO25MkQ1WpmUpJ9iVQPgxi6nyxl/YVU7xxY5Ty70QvIQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AiH89HCX7a/rxre6S78rCPnYniNTa94rmQyt+suYNQI=;
 b=fRnfZTMfNG2oYG8hqYPjAuGbPd8N7AJx6qt+G7Sl4T6oIHmkh1QWbdxn6l0tFGF8kzo8tyf0e9m1hVYi3F/qHJwXCHyfj8BUcXn+9z8o3YS7+Zr8i2gGrG+4U44KgMMuT+AqOa5CchGK560q2JRnHpGmfCvak99uoJ3AoBnixJMIMbr0FlbGUhaGMXfFRJU3QDe5qAR1EK2NiR1TX/B/HcZMW9bcI/yPWlceKM7pLJuFynlZXcwXj84eAWw+PImafUbHI7bciga5yZkroYLPq+vg7K3ZMSpMtLX4g/ipZIbjZBK8yhDRo0mZLFgjJM3Ot6WHXefaomlhOIf3q36Sfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AiH89HCX7a/rxre6S78rCPnYniNTa94rmQyt+suYNQI=;
 b=dBMNDWX/QqeR9nQIykTiF7F676XM9cFgfLrqLmghlEQqZcGKCs1E4CU+Y9gW9bur9IGSg5MhhK6PAYWOa9HK/yxgr8goe7WjcjXG1jJ3Uwo8lunB7Z0adQs/DeuIwEbEDbQwtrswrFAPdK7vw0O0HdYLmnjze85mFOBEKgmxP8s=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from DM6PR15MB3580.namprd15.prod.outlook.com (2603:10b6:5:1f9::10)
 by DM6PR15MB3273.namprd15.prod.outlook.com (2603:10b6:5:164::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Fri, 26 Jun
 2020 06:13:53 +0000
Received: from DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::c8f5:16eb:3f57:b3dc]) by DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::c8f5:16eb:3f57:b3dc%5]) with mapi id 15.20.3131.021; Fri, 26 Jun 2020
 06:13:53 +0000
Date:   Thu, 25 Jun 2020 23:13:50 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     John Fastabend <john.fastabend@gmail.com>
CC:     <jakub@cloudflare.com>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: Re: [bpf PATCH v2 2/3] bpf, sockmap: RCU dereferenced psock may be
 used outside RCU block
Message-ID: <20200626061350.seduf7s7cthqbnov@kafai-mbp.dhcp.thefacebook.com>
References: <159312606846.18340.6821004346409614051.stgit@john-XPS-13-9370>
 <159312679888.18340.15248924071966273998.stgit@john-XPS-13-9370>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159312679888.18340.15248924071966273998.stgit@john-XPS-13-9370>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR07CA0086.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::27) To DM6PR15MB3580.namprd15.prod.outlook.com
 (2603:10b6:5:1f9::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:7d5a) by BYAPR07CA0086.namprd07.prod.outlook.com (2603:10b6:a03:12b::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Fri, 26 Jun 2020 06:13:51 +0000
X-Originating-IP: [2620:10d:c090:400::5:7d5a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a16ce86c-f499-4d26-1e76-08d8199819cf
X-MS-TrafficTypeDiagnostic: DM6PR15MB3273:
X-Microsoft-Antispam-PRVS: <DM6PR15MB3273400EB673A5E60CD06FD1D5930@DM6PR15MB3273.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wFj59d2EojrrIqyVMQpZ/Pwhri6sI8KjujhFG21mFI3O/XZ8YWXbmm+FLahdKJrzBBf95Z49UaEY0sNWeDMb+ZrWmAUFMLSbqvUHWnKqX7X2wauiFf9XhGRORs59XoBw3intYS+p2zj37sVcrxcm9/6Ufrx7XjENZXlS1qVa7k6ro3FQpC3n1GBdEv3aVE9CHLlTmrLg5+e42/X3GTj8XJKyssBczWmEGhuvsjHUvLKcYnqdR9MT/GDowhtPAn3XGa97W6AHwqxLsShZX4mGEYmEmfTox2heCB2FowmbTvE4ZS3rqSZNi3S0HS6RmKfJviMBhmzXMpvfEWK7GAvVYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB3580.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(366004)(136003)(39860400002)(396003)(83380400001)(8676002)(478600001)(66946007)(5660300002)(66476007)(2906002)(66556008)(55016002)(9686003)(4326008)(1076003)(6916009)(7696005)(316002)(86362001)(186003)(16526019)(6506007)(8936002)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: BhPzF6ZTXvvstmilBf/ZQhLzcSLZTdNQ0R+4Zs3JqYo4K63H+1ssj70GbnWzxaESemw+kYvHGY40ZBgrxibuzOJykP2KxiuEmhtL0el1mXaBaA9zRZosUXJ10gWUbpA0Slz2rt/PeZZqSzwrWiE0QxgTREac7R4ziyGLcC0Z5MgEcxFhbqMoMnJIyLVBglkB4kvK0inRy+msiCY+3PogP7YXelkzJ9/WNBjRlqeQq/EzKGzRLQN/oss6yHD2juoOH3Cr9KCHvJEny+jW3z1sym+tGkNbwYB2hOmdWBfIOMYanFe1WOoclLIgGGmOES32Afi3pCkZJ5LnfYhk4zESYv8ylqPhPwJi9KucqjZl7TF8w2yx4ylI9A8pVLV7B1ZuBI0jpzXM72FrCAgAuzQ0z6zadYt65CP7/qzcvDfJfQpZbNt1e9GBkFTc7uJ13VZGS/xv0Hlr0CQ1O6Ao8//u9CH47dPYz31Q9n8YS/Te1XcV9Azu8EXVT7tBc02M+kCQ2yv5qtzMrRFKkai4HHUPww==
X-MS-Exchange-CrossTenant-Network-Message-Id: a16ce86c-f499-4d26-1e76-08d8199819cf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB3580.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 06:13:53.4061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aQ0QrrczFd/kodFbICRBD7AM6ewyx2eMjJGYpgivY23nVtl9tcGDk2vQbdCqzrzc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3273
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_01:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 cotscore=-2147483648 phishscore=0 spamscore=0
 mlxscore=0 bulkscore=0 impostorscore=0 suspectscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260045
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 04:13:18PM -0700, John Fastabend wrote:
> If an ingress verdict program specifies message sizes greater than
> skb->len and there is an ENOMEM error due to memory pressure we
> may call the rcv_msg handler outside the strp_data_ready() caller
> context. This is because on an ENOMEM error the strparser will
> retry from a workqueue. The caller currently protects the use of
> psock by calling the strp_data_ready() inside a rcu_read_lock/unlock
> block.
> 
> But, in above workqueue error case the psock is accessed outside
> the read_lock/unlock block of the caller. So instead of using
> psock directly we must do a look up against the sk again to
> ensure the psock is available.
> 
> There is an an ugly piece here where we must handle
> the case where we paused the strp and removed the psock. On
> psock removal we first pause the strparser and then remove
> the psock. If the strparser is paused while an skb is
> scheduled on the workqueue the skb will be dropped on the
> flow and kfree_skb() is called. If the workqueue manages
> to get called before we pause the strparser but runs the rcvmsg
> callback after the psock is removed we will hit the unlikely
> case where we run the sockmap rcvmsg handler but do not have
> a psock. For now we will follow strparser logic and drop the
> skb on the floor with skb_kfree(). This is ugly because the
> data is dropped. To date this has not caused problems in practice
> because either the application controlling the sockmap is
> coordinating with the datapath so that skbs are "flushed"
> before removal or we simply wait for the sock to be closed before
> removing it.
> 
> This patch fixes the describe RCU bug and dropping the skb doesn't
> make things worse. Future patches will improve this by allowing
> the normal case where skbs are not merged to skip the strparser
> altogether. In practice many (most?) use cases have no need to
> merge skbs so its both a code complexity hit as seen above and
> a performance issue. For example, in the Cilium case we always
> set the strparser up to return sbks 1:1 without any merging and
> have avoided above issues.
Thanks for the details explanation.  I have to admit that I cannot
fully comprehend the concurrency situation in skmsg and psock.
The change makes sense to me after reading the description though.

Acked-by: Martin KaFai Lau <kafai@fb.com>
