Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5921C78A3
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 19:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730037AbgEFRtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 13:49:39 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47486 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728960AbgEFRti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 13:49:38 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046HnFo3030547;
        Wed, 6 May 2020 10:49:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=y40CZl2i0ku2WQwogOAKVJX4pb/yFWh9Z8XnCSETvSk=;
 b=GjzoC6Cnnq+oiCoeyUtOqB0hEpiLQrWeDizAcbioii5jhJh3Knwl1Yp+MKsDR1jyBcG+
 mu2u0IuZbtKmZra9Zr7B0lpVTXxFP7SlX7qf5uH/r0efzxmCDUH1ICX7My+0XDo5YSZa
 tkpFBPun2yo/pILdd97OkL+V2NlFgT2w2uM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30srw02pb0-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 06 May 2020 10:49:21 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 10:48:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mq0OnO+pkBAyqLScWNT/uRA4nMbJ3GmikeMwbqMaJphtyfUDS+cvvpOyOHAoVdlJ4jDC1UI2Zusv+1BfFh0HHdZa1hwq8siFv5Jxug/NQJBX6Sxfesib/8UbgytwkmUSzKXYriaoBJKvb5byXrPoKxmF9V0a3pAFRQHmFmXsO+W8t9tSUOLqE9XLJ7tW52/KnwF6VnEWaEhpWxt8bZPSKNQnmapNOIn1rv+rX9bGZ9pTd+ODdVEJmjZw8PoOvgnfKixuDoJL3zIe/ut7j5mJbVT+YR21oTvJQVmyWtXnARZ715oTNO0febKWdWZOobbbH1ID5FamNpFG5QiY6AYOww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y40CZl2i0ku2WQwogOAKVJX4pb/yFWh9Z8XnCSETvSk=;
 b=I03jCbCe0hTy8F+TFBbTEAxhylc4O0yJJlkHZLKCd6dXImbYbuhgKzXonLD3vFFOk2R6qksaaLKxDo0iyOZzJH4sZSBahXxbqGgkM5azFmtIFVEpHd1KCQ+FO8VwvCMK7JaDUGLhMvEgglhEInx7kcaHA65zqmDyUH34kZhP6NADsrX8r/SDXr3eTK8Uh6MxBDVz8qbFIcNgx6+rc2RYlh0IH5XKELj76emzvpqCrM5Sc00qB60V8FA1FeQUDaCGI5rXIgSKF/QUQpZJJTye7YQVkxLhvLgtbYSkYjsX/PW734mNBk7LZ8XwHLheMsCf/nMMnzfjPX3GHFWvjM//kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y40CZl2i0ku2WQwogOAKVJX4pb/yFWh9Z8XnCSETvSk=;
 b=CWWojt9gMXbJzW4m42ciXWFzgUijyFOrfCZk2SzuCVjv0Cdhs7uycDG0NL8c1cKTd0+dgoZfZLq/OrVwDfnvtSZ66hUtHPXQCIatqZ80MWHfdcM3MO6+bv/WkbrRFgTL5fTorYLSb9/EnZvqyj5pcdWMxZh/hFQCu5p3yxP3sIk=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3833.namprd15.prod.outlook.com (2603:10b6:303:4b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Wed, 6 May
 2020 17:48:47 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%4]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 17:48:47 +0000
Date:   Wed, 6 May 2020 10:48:44 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next v2 1/5] selftests/bpf: generalize helpers to
 control background listener
Message-ID: <20200506174844.pedoqguvunnwmnih@kafai-mbp>
References: <20200505202730.70489-1-sdf@google.com>
 <20200505202730.70489-2-sdf@google.com>
 <20200506070025.kidlrs7ngtaue2nu@kafai-mbp>
 <20200506162802.GH241848@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506162802.GH241848@google.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR08CA0029.namprd08.prod.outlook.com
 (2603:10b6:a03:100::42) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:b618) by BYAPR08CA0029.namprd08.prod.outlook.com (2603:10b6:a03:100::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Wed, 6 May 2020 17:48:46 +0000
X-Originating-IP: [2620:10d:c090:400::5:b618]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a39b2d87-8341-4d01-4251-08d7f1e5ba0f
X-MS-TrafficTypeDiagnostic: MW3PR15MB3833:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3833E80832F0BF8B4D01BA03D5A40@MW3PR15MB3833.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mTib5DF+aUGKuvSEX7+KDNGoTcGyI9QaiFwt3yQE0X8YkPMsFJEjGRACNLu5c4PTDJY9/L1mH7gkikmonnA00IOEXLAcuaWP7TZAjvNG2OtdCtjTImf11N0XsP1Opnxqau0MqIJDQhalCqUbGp4rCdB/0IKvlxNFaS3JjcKAclWzWBNKGV61Hej9ecbUhQ3wwC4tmvHjHbPlNWvfnpyBXT+XXC2ro93QpQ3GwUI21ThSFOBzFcYtsdf3HTg6gAtTNyIZ2AkNU+0UpEpHZ5fnOoNokHA30JBW6FnyVn2AHEJV9LJanYtZweqFiCMpM4w1gQzDYCaERIW66YyJ8BoOxzf3TSg4myWT2WLasvXK4rlJiHUUvyJujgifm32nyVT/mYJkvWDxCouthy3NDps/FrweYye2vGTu0EeyX++bjNYkH76vYY0cJRHuHIkIDfcdPjP6hrvTl7U1R+H+jnW4sxFELAu/s4o2B84fN9dDS/HYuMPnWgLC7LwN9HS5guuYtRruUWDrzMeLynPNmrWSAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(33430700001)(52116002)(4326008)(186003)(33716001)(3716004)(33440700001)(8676002)(16526019)(6496006)(86362001)(55016002)(8936002)(6916009)(498600001)(9686003)(66476007)(66946007)(66556008)(1076003)(2906002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: fShVf9WPFw+WMlcUtl0YGJEhughFz6bE2BkmhbKmaqQHuoAKaLyhcQ+hhHtDbKcq6AzXRGsZNBGraPTJs36yLBmlj1Rtxtbnxij4lbv4byt504qRPXUUqoewsMzE3EffmOGANR482zUpsYeesh3sD5uImbqr2nadGrmzxYWGAAVzy3pwMNPqTx62WQaeLB8KaCo8NZiwqS6vyZqQ7Ed+JuaPh4iuICglWbDfY/1IDZWegXDDzHk9zQs1Q14yG9qeRtZW7xvZ/BqwpDtu976agDYJyAXmLg9tHZ5AcexEpHUECAPQICP46jCcneNUyX+7zxmJTguf7O1OZx4Sw2qDrRl88BHYUGOnCVRRZXcdK13iklxQbVLZJx38XqJCtFzgU/wAlCDOZA7QHtkCdOm1CA1DtZvkAB+afc+mEOnz0tDT5uVxggNQtSNoQqAiSlxnJGgEefW8yGoYfG9KwqPxw20B4TmGHqy5LyKvRPAAaLd68dU0Kq2I7TirpP5b88yKs16bxB2e4/czbyWO/IS0CPyKctMgYzjHEAdtQyHLFVrci35Ed8y9c304hIlRwjBzQDip8VrE8amZ3KxbB/5DbspEUIwzMM5SBzUnvgrglxjrZ29X1NFwosWEnSLv5efcS0bq0mYE3GzpZXqwtJsWuBVirt9N22RJKA4yfc3AFgETrGUcfkDjwKcG6GW0mGGDM6Ek15YbDrCrFQJAepwkCpVdRoebtNTvU3zeNHG1QiOMYT+lUwN25LHGAJJYqndZG8tc26hxNLcKt+3b0up+h7sD1ga8NXwFyOwqvUGZSoCezZj6xDSeO2oLOXSYzYHpu25YiWQIOw6Ji7oxFIb+lw==
X-MS-Exchange-CrossTenant-Network-Message-Id: a39b2d87-8341-4d01-4251-08d7f1e5ba0f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 17:48:47.0847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uI+uDk7L4voB2rU9fBwAlbvMo8c2lWbcMCpvkgunkK05RVOWDOdfmomsejoi7rh6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3833
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-06_09:2020-05-05,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 malwarescore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 suspectscore=1
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060145
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 09:28:02AM -0700, sdf@google.com wrote:
> On 05/06, Martin KaFai Lau wrote:
> > On Tue, May 05, 2020 at 01:27:26PM -0700, Stanislav Fomichev wrote:
> > > Move the following routines that let us start a background listener
> > > thread and connect to a server by fd to the test_prog:
> > > * start_server_thread - start background INADDR_ANY thread
> > > * stop_server_thread - stop the thread
> > > * connect_to_fd - connect to the server identified by fd
> > >
> > > These will be used in the next commit.
> > The refactoring itself looks fine.
> 
> > If I read it correctly, it is a simple connect() test.
> > I am not sure a thread is even needed.  accept() is also unnecessary.
> > Can all be done in one thread?
> I'm looking at the socket address after connection is established (to
If I read it correctly, it is checking the local address (getsockname())
of the client's connect-ed() fd instead of the server's accept-ed() fd.

> verify that the port is the one we were supposed to be using), so
> I fail to understand how accept() is unnecessary. Care to clarify?
> 
> I thought about doing a "listen() > non-blocking connect() > accept()"
It should not need non-blocking connect().
The client connect() (3WHS) can still finish before the server side
accept() is called.  If the test does not need the accept-ed() fd,
then calling it or not is optional.

Just took a quick look, sk_assign.c and test_sock_addr.c could be
good examples.  They use SO_RCVTIMEO/SO_SNDTIMEO for timeout also.

> in a single thread instead of background thread, but then decided that
> it's better to reuse existing helpers and do proper connection instead
> of writing all this new code.
