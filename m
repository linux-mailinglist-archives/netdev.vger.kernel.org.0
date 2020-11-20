Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49AE2BA079
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 03:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgKTCd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 21:33:29 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28210 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725890AbgKTCd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 21:33:28 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AK2RD45018063;
        Thu, 19 Nov 2020 18:32:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=hmL8vmoIG5UY/Y6j2cEX5wZvHS4dZOfkSHEe9kOg0gc=;
 b=HbSPnMpwYFi/0sTp3C6h4L69abtTnkOrPPi2/g3iS6Bh1dbQF2HVnO9ekbmFba5+QN74
 25DKHTVSV7/Rz12kqmkjKHFXlHtU/ohA2X5a8P/Cbwmw3pStRbaV4kEhj/CMRkcmyFJL
 oSJp/6HWmHD9H1OV7FxWi5g7ykg+u7VZ7u4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 34whfkrd34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Nov 2020 18:32:07 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 18:32:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fvWYoeGE0xFfcWohs89+jhvZrk9jcwyHzaDPX1Bv/L9JMLLmNFNonUgPUE4COdiA9Lf3KEBLzUE5Eyir7ccwv+XkKnIscfdOBbm4NF+l7u9Ga45giriVr2p5VLFjBg89qggNXOQMGcjw8xtc4V29MAfletrmWbmvKZ/Si7G+IrMP6u87qVWJBKJAEdclLR8S4NMgzUe4o05wZ7VDj+PalpmIJ8fgXDLW5mbfk1qs7M9CnbWKRW7OpLvOmqv0oACvTR+ZnC9lSuWIDIjPRjENdLpN7sujdjiYrE32bUMJRlJDdFIx1dKfIvE/oZu5FphgbqhMMbP/A2XEIjBSc0Ed5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hmL8vmoIG5UY/Y6j2cEX5wZvHS4dZOfkSHEe9kOg0gc=;
 b=fYwAOjtfgNTUuRttE5Y1AH0Qtv+sz/UXz+dc/97jwbk2PePnzAVrTpyV2V3soXCQ3bQgH45S16r4Kge9A7BSiH/+QxhLAMX/LmxCv4SDz0AdCndLrKdslweGblBjDunYNDw1qQziKsGCHmz05Gz+DasbTBeLwOrNJ8KkBS5IBHnK4AoktAXvXu4TT3rOVZx1oiUzeA8wIdFSerJ9XFYtHqYF8QFL1UA8hSkv8PNr+qBd/lXxUC9I2eKoApHWZ2kJjpsFwxrAUtK/YAlycT1Lhi+nheaknMDFJiCnWXZiwCOaW+8OwtJas5/sFRnZVpB3rz04SvguTY7PaMVjZuE6Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hmL8vmoIG5UY/Y6j2cEX5wZvHS4dZOfkSHEe9kOg0gc=;
 b=XDtApleL+uHFvVeKT5uWQXsui8oy1fvD0Aka32rw53H8KyNp0hyId1Tkb81NqBGm0nf2VqnvZMr7lpuMA6oO2nr+TLDMJviZUkoLiNMLNmQurtyj+EH+7pPYwvJMiFIsDOhZt6zipz5N9gfm8CvXr7webnGLAMeOGzPEx+4VnSU=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2647.namprd15.prod.outlook.com (2603:10b6:a03:153::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Fri, 20 Nov
 2020 02:32:05 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.034; Fri, 20 Nov 2020
 02:32:05 +0000
Date:   Thu, 19 Nov 2020 18:31:57 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 0/8] Socket migration for SO_REUSEPORT.
Message-ID: <20201120023157.immjndtw4hgcyz75@kafai-mbp.dhcp.thefacebook.com>
References: <20201119014913.syllymkfcohcdt4q@kafai-mbp.dhcp.thefacebook.com>
 <20201119221749.77783-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119221749.77783-1-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:603e]
X-ClientProxiedBy: MWHPR19CA0015.namprd19.prod.outlook.com
 (2603:10b6:300:d4::25) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:603e) by MWHPR19CA0015.namprd19.prod.outlook.com (2603:10b6:300:d4::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Fri, 20 Nov 2020 02:32:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b982ac8e-2195-4879-c550-08d88cfc77d1
X-MS-TrafficTypeDiagnostic: BYAPR15MB2647:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2647C6AA6A7D760130342D8ED5FF0@BYAPR15MB2647.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qanzWQRB9ZxNqDej/9fj1vD0jq0kH7eLhPD4UA6lWFPiGLFe/+i1WBnkgTHXzxoIZjTveHkyhKJNdNd3FIM9c0LMWysqvq5zNSAbKhjO1DKKJA7WX4EqmWbBVGj9RGEPkqEdWiAD8ZDbnNmB9hdHi5LEu6U8DWk64hEbE4POFJR1ibcoV7Ts+t0PFFAs03Y93UxJFKN+PzLcYeBKu+6AMXwj4RuJd5DoifiTFov8wrmwYkl3PSQumlI7El6iw8Tj5OIJ7JatrV6ANTK0E19BeEJQHf3NRvPQO1BVDDpRejDw9p67JzHY+30u+wWh4ZkWKMf46eauG0id9lHbmXoQ2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(136003)(346002)(396003)(366004)(83380400001)(9686003)(316002)(66476007)(16526019)(8676002)(186003)(7416002)(478600001)(66556008)(66946007)(6506007)(86362001)(1076003)(8936002)(55016002)(4326008)(6916009)(7696005)(5660300002)(6666004)(2906002)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: RviiolBJzLwOtwc0tAFIV8fwwQWUGJWfW1HnMAEWeaB7UVIv9jf7Upz2YHvbRT/HQBQvzHvJtzy78mgSpxb1Hv0kydz0Un/WJEiGMqn/SFQDEeBwcMKuvGF//hp/Dh18FNEZ5bQsIlWT+pGjURlMiBjPASBdA/j6O3Q8PHUn380X7Hf1j+YKFUfTHVu+OazIi66jUHTQrBNd9ymp4IA3npaAsJWEuHwknfbdHAwkcsIjBsyk+1wkslSr4yqW6VX/9xE8uqrSGVs6tut+gbI2mi6ZY0OFEIDhcMyzPYBc9BhlJByB8igTglI6taKJZZas4Vwc2mxcaQGZHfbPyD6XNnHuflcDRVnGbFHe5VMSrNTK+v6xNjTnorqNbLkuQyo+75U8SuHO7B1AfmUFDJNw8LdEW7q3u9qqYAujJU49mngLMNlBAx3tsHtnI7dmMmqxGvdHeksYe60jRKAoA7PorrAoyiYAhv8o7sxcCgZmfctOtXNbSXhpnjcra0bka8BTd5Ys2kF/2s25NmoFOpHZJNA6ReD1GJgFgzdqC3W0DQv+IIXFiHt/hmsdf1BTK7MmiL80thyyjVoau1yjQAf69G+wIlVuUUio4J7Ksz7J44fhO4m8n8fFkyFFnqjeF010YEpGI6Qde88ULsxfoCZ+Bx67wELzXR//0a6pu5GLviJ7IpYKXke5R7zbnWwCdyOhvlOExwfFqcDLK+VRFKCeIUuY6Uf9TF20Mc6XCwdki+EA/pU9AhrZAVLM+IiBlGESDMoBA4OZxuk1k8y0e/z+bppptFyzba1wDK0RD9NSEMHgCoXbwsNFMLOdPkrQ8GlZCqT0CQNrrhE0D3gczdMDEqFC+ZssLihFHhr0TE3Dqr1zw6Cd0j/ew+yvt7u9X+XHWfkMUMaqREP+pWE+vCBvmdcDGd1cA3mo4BarkblMtMQ=
X-MS-Exchange-CrossTenant-Network-Message-Id: b982ac8e-2195-4879-c550-08d88cfc77d1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2020 02:32:04.8925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MHDqA30o7JCAzpJ7V8ZoOqJwhD/LIKRVby710zAuQ2oOzgpTSPUy5V6+3fqwCKm1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2647
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_14:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 malwarescore=0 phishscore=0 suspectscore=1 priorityscore=1501
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200017
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 07:17:49AM +0900, Kuniyuki Iwashima wrote:
> From:   Martin KaFai Lau <kafai@fb.com>
> Date:   Wed, 18 Nov 2020 17:49:13 -0800
> > On Tue, Nov 17, 2020 at 06:40:15PM +0900, Kuniyuki Iwashima wrote:
> > > The SO_REUSEPORT option allows sockets to listen on the same port and to
> > > accept connections evenly. However, there is a defect in the current
> > > implementation. When a SYN packet is received, the connection is tied to a
> > > listening socket. Accordingly, when the listener is closed, in-flight
> > > requests during the three-way handshake and child sockets in the accept
> > > queue are dropped even if other listeners could accept such connections.
> > > 
> > > This situation can happen when various server management tools restart
> > > server (such as nginx) processes. For instance, when we change nginx
> > > configurations and restart it, it spins up new workers that respect the new
> > > configuration and closes all listeners on the old workers, resulting in
> > > in-flight ACK of 3WHS is responded by RST.
> > > 
> > > As a workaround for this issue, we can do connection draining by eBPF:
> > > 
> > >   1. Before closing a listener, stop routing SYN packets to it.
> > >   2. Wait enough time for requests to complete 3WHS.
> > >   3. Accept connections until EAGAIN, then close the listener.
> > > 
> > > Although this approach seems to work well, EAGAIN has nothing to do with
> > > how many requests are still during 3WHS. Thus, we have to know the number
> > It sounds like the application can already drain the established socket
> > by accept()?  To solve the problem that you have,
> > does it mean migrating req_sk (the in-progress 3WHS) is enough?
> 
> Ideally, the application needs to drain only the accepted sockets because
> 3WHS and tying a connection to a listener are just kernel behaviour. Also,
> there are some cases where we want to apply new configurations as soon as
> possible such as replacing TLS certificates.
> 
> It is possible to drain the established sockets by accept(), but the
> sockets in the accept queue have not started application sessions yet. So,
> if we do not drain such sockets (or if the kernel happened to select
> another listener), we can (could) apply the new settings much earlier.
> 
> Moreover, the established sockets may start long-standing connections so
> that we cannot complete draining for a long time and may have to
> force-close them (and they would have longer lifetime if they are migrated
> to a new listener).
> 
> 
> > Applications can already use the bpf prog to do (1) and divert
> > the SYN to the newly started process.
> > 
> > If the application cares about service disruption,
> > it usually needs to drain the fd(s) that it already has and
> > finishes serving the pending request (e.g. https) on them anyway.
> > The time taking to finish those could already be longer than it takes
> > to drain the accept queue or finish off the 3WHS in reasonable time.
> > or the application that you have does not need to drain the fd(s) 
> > it already has and it can close them immediately?
> 
> In the point of view of service disruption, I agree with you.
> 
> However, I think that there are some situations where we want to apply new
> configurations rather than to drain sockets with old configurations and
> that if the kernel migrates sockets automatically, we can simplify user
> programs.
This configuration-update(/new-TLS-cert...etc) consideration will be useful
if it is also included in the cover letter.

It sounds like the service that you have is draining the existing
already-accepted fd(s) which are using the old configuration.
Those existing fd(s) could also be long life.  Potentially those
existing fd(s) will be in a much higher number than the
to-be-accepted fd(s)?

or you meant in some cases it wants to migrate to the new configuration
ASAP (e.g. for security reason) even it has to close all the
already-accepted fds() which are using the old configuration??

In either cases, considering the already-accepted fd(s)
is usually in a much more number, does the to-be-accepted
connection make any difference percentage-wise?
