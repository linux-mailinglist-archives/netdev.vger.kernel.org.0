Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09904934D8
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 07:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351716AbiASGIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 01:08:51 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:59341 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351711AbiASGIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 01:08:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1642572526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oW3W5qkGa5aQ5ZAEC6xIqMBBw+ColtJQmCGZwxJivc0=;
        b=Utio9BjmAQn66cmWmd/t7Jtx0nLPDjUCTm7gCbd+zAk+6Cgj7+pQ83wbU4lG4YRaBQciQQ
        l6NGbNQnFqr8I/WCX5tcL7HDgrDI0g5Kdd+3QOyHCQt1Zjli+mpYOISSKohbqFIXG1vJma
        N132G9M+7apKxD6iCeG8Du8BmJ3aCv4=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2059.outbound.protection.outlook.com [104.47.5.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-30-XiOX8zXUNTexm4mV57kLaA-1; Wed, 19 Jan 2022 07:08:45 +0100
X-MC-Unique: XiOX8zXUNTexm4mV57kLaA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gh+ghdq62PCnMXr3vdaMCYVwlBjKPbSBfHgp4CwN0H2R+erhs//azjhaRLjJu7lKNRHa/CX+lE4GkxKfyAZE50zqjkq4QjztmiWZTU6a3hBfVCeUKjYws+a9vQxwV9/din05B85jF3rlZPQPT1FFe0Bi30bRf8pXpTzgw/WKd2FGO5qXKlc+PvjM5sXKrYGaX6DaDTY2fS6tXhjPGDyLB0YPJKBk0fhbCAnOdDswjxHHb/umWPU+WNiyVeRYFbik/m5STv8ZP7LkITtrbwixHGkd0cIOibyTZJuJ3TqcOaq4bnL6IsSXaUaQ1+ULcAi2cqJjLvHv1pjKGQAChbV/hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oW3W5qkGa5aQ5ZAEC6xIqMBBw+ColtJQmCGZwxJivc0=;
 b=mnA6h6sy9S/IH9OCTIOf0MY7wGqpceQnfSZeNc0PwR666pTaQwch1B7QfSaET+q6Ym3kcDo7jhUzUSz0svOijNCjo4WvoiCoOuPs6xk85gbzmVRiuzO6vwgrOTUO23+xsf0tnWZNVzGAlutrPZkphqPFrQhDZjFHHLta3H7ou4s3MgxjnC2ri69riIFyOev4h5nTu2fo8y/7wQjX1xTSCo5l9OwONEoSqrXsfrW2oGbrm3hvV3QIyWUz0hR27h8mLQEYYRyE4YIccxcp2bCSkradGV47uBlyP2y7CcnNAtpkEalqCKccvcUhgdbk3nYfJCgNEbeWqsZ0PsvSCNhNiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com (2603:10a6:7:83::14)
 by DB9PR04MB9284.eurprd04.prod.outlook.com (2603:10a6:10:36c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Wed, 19 Jan
 2022 06:08:43 +0000
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::3837:57a2:45dc:e879]) by HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::3837:57a2:45dc:e879%3]) with mapi id 15.20.4888.014; Wed, 19 Jan 2022
 06:08:43 +0000
Date:   Wed, 19 Jan 2022 14:08:44 +0800
From:   Geliang Tang <geliang.tang@suse.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.linux.dev
Subject: Re: [PATCH iproute2-next] mptcp: add id check for deleting address
Message-ID: <20220119060844.GA14367@dhcp-10-157-36-190>
References: <0e01aafaba6df6ff7adf255999d64259d7ae8d50.1642204990.git.geliang.tang@suse.com>
 <93dd20fc-e22e-2536-85f6-5442b3f19adc@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93dd20fc-e22e-2536-85f6-5442b3f19adc@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: HK2PR02CA0127.apcprd02.prod.outlook.com
 (2603:1096:202:16::11) To HE1PR0402MB3497.eurprd04.prod.outlook.com
 (2603:10a6:7:83::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c09f27a-7d61-4112-dac6-08d9db122510
X-MS-TrafficTypeDiagnostic: DB9PR04MB9284:EE_
X-Microsoft-Antispam-PRVS: <DB9PR04MB9284B53B8C007FE0C7345709F8599@DB9PR04MB9284.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HX1CVjlaFviYeKqZqFRFYLmo2h8ExxbCWD3cqzZyJsaYzrJiGaJK0CabpQB0ZYMp60TFNssIQG8Rx3L61OtwrWwnXkNWrEy3jW6USm6cryRg1RCOWFDOWmxbm/lSykCGoJC2g0sT1nS7yTzJZJqoturDA5gdXLw8t5jSi4+p77kqtG9hodvhzeiDjF/wD/rpOULAAWDbghIjhRMWFCgUzuecA/6qBowaRCWM6RJo+gftSmOWmxFjR5+roI88U3pqESy6dQamrNDv/dd3pKTIBh17i3H8QT6nxULlvJXDqlSraCkFQLsaB56iKfJ2nMp6fDyzUzZzzyTaVKWh5Gr4EufDTzI65xs4SlZt8qFRzaDNZ0B4DoyqmyyNyC4Rr6a4COEUA3efcSzaQBZnQL/kAI3i7S4spP0zQinTP224+v13/EEw1vo6Sodb5imQZldJixZgs481XtEh778CeAGSMAm74VmsKAhDpS7ituWuc81zTdxzDJRGnum/odXT+BCdAXEoHUgF6yur9L6VZMl+03Zj4slLF3brO2Qb0dpzUrFVoWzV8qKJi28hdFhWm48dzARX2SqA7+Ew+zTCtCb0TwpuEqjFaiKs5qACTk6dWkWtEALNsNoyezkVvEj1WXi0kjKGuX9jxo/zgmrnPcQasoNIM6+zWwSQFmi8crY/Hnel85F3F2mO8X1NLs90cJM4mScMda0qrSja7VWA1OGrWWkteIbGB8sNjSOn7qU7zFQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB3497.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(316002)(38100700002)(54906003)(83380400001)(66556008)(66476007)(66946007)(4326008)(44832011)(1076003)(8676002)(6916009)(26005)(33716001)(5660300002)(2906002)(6512007)(6506007)(508600001)(33656002)(53546011)(966005)(55236004)(9686003)(86362001)(186003)(6486002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VzaUBp06MBOb0JjqIZsO6M+4nCf3WBmEthD5vNjprpLw7falWKIzg+EcpJvG?=
 =?us-ascii?Q?9dQf3QusIYdS3H+VPU7IXlpkXfQtHAvHvu8Q3NocMHbRHi8B4TvD4mEnmIrk?=
 =?us-ascii?Q?xOpe1IZvqevjOWpWPs+kDImOs7zg5sJ5kUo0HyQUstxPykeNbe12uqlt/wZM?=
 =?us-ascii?Q?efVtwEnPoEpLX7yPyFdqRusAUaYQn3PhKjd2ypClYMORJDch0drxkfkVBALu?=
 =?us-ascii?Q?dF0g35rgTf+MeZKiEg+LsGoapWhm8B+HRwFjkhWh5KXrwTNGv1kQT7bBZprb?=
 =?us-ascii?Q?PzAy8nT9Hu/ej4rlIXeF/qSlROl1k38yhNjPdERVl1aGvkDqiRm11eohIpvK?=
 =?us-ascii?Q?rWWTa8zzR6/rGsBKAVdl0ml9XTwHHW2crdYSO0OmDEFtMdWn8oxJdUfG8vfj?=
 =?us-ascii?Q?EAUkrVjvigDC5w4bTBHBRJobEEsns2tt+XFPxVDNwT3Ei4YfYxfhslS3nC+f?=
 =?us-ascii?Q?qLGi3jTbCM29NJiILZ8JuKPuG97mwJSFN4VAXwsYT69rBtTBjBykY3+Q9bxW?=
 =?us-ascii?Q?Z8yp5cDx1KRZxMF7w9bC0BmdI8EcLOPDI4d5DRM+qp2UvOqCLZP+kJb5hwpP?=
 =?us-ascii?Q?EdGjzN+nUYSVK2mNLh8Cz494oSzGXYyKxEvUK69YRx0MxuOs9YlD5cMArmNQ?=
 =?us-ascii?Q?pdx1BIheA4gwpYpI78jZEuagg6Fj/RvI8DC8i72f12o6trDROWQv8LsN+QEz?=
 =?us-ascii?Q?mXpxqsnuN4ny1zxqkWZ0H2oxzz3Mh4FpizNWwLSJGcmZodQq0CG3Kll08pmb?=
 =?us-ascii?Q?8g+96caHYSEHWRPj5Ea+BH2OgJ3S2IxSP6VLFtry0UPmvfkqjkYxJeswcSnk?=
 =?us-ascii?Q?Zv6/j57A3GkG6SM19/zm8Ftl/lEbbUMcIFpvtVc4YZX85oqsCX2QQk80rxql?=
 =?us-ascii?Q?EbhZg+IKa7NajcEkoWYQCbJuvCR+x6sH0KgJLUFHPJktnz0xFbEsrs7nojng?=
 =?us-ascii?Q?RzhurcoF32ePBpX7zs67QaLLKOZ3EEHSp807cwaiHK85mWb/yMdMvuZQEjJx?=
 =?us-ascii?Q?7SCwE4CwC7JPY6PoS6GKfaZyCqKb/Yym5ZnBGCqgxbWKBc4MQb84N5z1xDnR?=
 =?us-ascii?Q?Pr1sMtticGRqm7Njpp92jNm+KxHtB7vQdtD6qHals5RMt1XIpbINOxKX4dJK?=
 =?us-ascii?Q?W4mchpR2nE2FVZvnTYJqpphaKZ3BiKoAuWGzxRrxKwxhODTwnjcBDG3Gs7bL?=
 =?us-ascii?Q?vl/bFZ3Jvagb8dTjzvEUpjb8jp649c6DPtxu+hUZxV0H359AX1xTIu/8h9mM?=
 =?us-ascii?Q?TaI0INXRFAey8lDSoEnHNl9F5QgJQlAvTM4Q0a6QY5ohBJNURRyYtHaKK3dI?=
 =?us-ascii?Q?Al3bWk/SlSiP/duCasYakxxGM+0UeTDH1tJ5VAqZkSSUExyJILifTykmLUg8?=
 =?us-ascii?Q?VY039LRPvnHm2bNE+LjwnNHD0piiDRk++RF4c9iMbZQCNULERkGyGzWNqyZu?=
 =?us-ascii?Q?/KW96oAe2bMvx8rI4++TFE8ik9pt++hk9lYriIQQcHDLr01blVuuKlTAwm4k?=
 =?us-ascii?Q?+NQ2pap4KoM5ftFBIwj1wMUsKzBMTNfNIcFVSL76E7cyTQUDNZ1ddaWmO9Zf?=
 =?us-ascii?Q?/RQEFM4M9ML1KtmxTmq875DqDxjjqgP8SdJ/EUboImcFVCTGrF22ZMRoYqMF?=
 =?us-ascii?Q?hGhS7HUGxV2dv5fWP+AlyQg=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c09f27a-7d61-4112-dac6-08d9db122510
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB3497.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 06:08:43.0203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nhpRERizpd/9K47H5As3jfSPIxx2tQ3Dg7qeCY0L7AQSuxd5b5DLWIm/7jFrU3yQHiBe6yFVOQ/RXEs1dBOPgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9284
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Thanks for your review.

On Sat, Jan 15, 2022 at 08:42:25AM -0700, David Ahern wrote:
> On 1/14/22 5:10 PM, Geliang Tang wrote:
> > This patch added the id check for deleting address in mptcp_parse_opt().
> > The ADDRESS argument is invalid for the non-zero id address, only needed
> > for the id 0 address.
> > 
> >  # ip mptcp endpoint delete id 1
> >  # ip mptcp endpoint delete id 0 10.0.1.1
> > 
> > Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/171
> 
> meaning bug fix? If so please add a Fixes tag with the commit that
> should have required the id.

This patch isn't a fix, no Fixes tag needed. I dropped the Closes tag in
v2.

> 
> > Signed-off-by: Geliang Tang <geliang.tang@suse.com>
> > Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> > ---
> >  ip/ipmptcp.c        | 11 +++++++++--
> >  man/man8/ip-mptcp.8 | 16 +++++++++++++++-
> >  2 files changed, 24 insertions(+), 3 deletions(-)
> > 
> > diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
> > index e7150138..4363e753 100644
> > --- a/ip/ipmptcp.c
> > +++ b/ip/ipmptcp.c
> > @@ -24,7 +24,7 @@ static void usage(void)
> >  	fprintf(stderr,
> >  		"Usage:	ip mptcp endpoint add ADDRESS [ dev NAME ] [ id ID ]\n"
> >  		"				      [ port NR ] [ FLAG-LIST ]\n"
> > -		"	ip mptcp endpoint delete id ID\n"
> > +		"	ip mptcp endpoint delete id ID [ ADDRESS ]\n"
> >  		"	ip mptcp endpoint change id ID [ backup | nobackup ]\n"
> >  		"	ip mptcp endpoint show [ id ID ]\n"
> >  		"	ip mptcp endpoint flush\n"
> > @@ -103,6 +103,7 @@ static int get_flags(const char *arg, __u32 *flags)
> >  static int mptcp_parse_opt(int argc, char **argv, struct nlmsghdr *n, int cmd)
> >  {
> >  	bool adding = cmd == MPTCP_PM_CMD_ADD_ADDR;
> > +	bool deling = cmd == MPTCP_PM_CMD_DEL_ADDR;
> >  	struct rtattr *attr_addr;
> >  	bool addr_set = false;
> >  	inet_prefix address;
> > @@ -156,8 +157,14 @@ static int mptcp_parse_opt(int argc, char **argv, struct nlmsghdr *n, int cmd)
> >  	if (!addr_set && adding)
> >  		missarg("ADDRESS");
> >  
> > -	if (!id_set && !adding)
> > +	if (!id_set && deling)
> >  		missarg("ID");
> > +	else if (id_set && deling) {
> 
> brackets on the 'if () { .. }' since they are needed on the else.

Updated in v2. And v2 was sent out a few days ago.

Thanks,
-Geliang

> 
> > +		if (id && addr_set)
> > +			invarg("invalid for non-zero id address\n", "ADDRESS");
> > +		else if (!id && !addr_set)
> > +			invarg("address is needed for deleting id 0 address\n", "ID");
> > +	}
> >  
> >  	if (port && !(flags & MPTCP_PM_ADDR_FLAG_SIGNAL))
> >  		invarg("flags must have signal when using port", "port");
> 

