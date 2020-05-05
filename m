Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E04F1C5EEF
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 19:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730282AbgEEReA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 13:34:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63298 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729663AbgEEReA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 13:34:00 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 045HNNxV027213;
        Tue, 5 May 2020 10:33:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=pLkrZn56eQ1xqGhe1AIIAtezeOb5EIXPOmoqfR0bFs8=;
 b=gs9SczlrE8gTVFsyl8481hSxL9CGHFN4Evw7rRO3SJTv78KXBQvVt+X4soO+VwNEZRTA
 3SMa6GSRXgWiXhOyybSof9GK+h7qOULoStP+drTD3dPw2tJO1cTCw9Sh3wZeKWKWObsA
 h+VMtfJUBRdm7DgGOkQY8NI0VSBxPKrTm1w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 30tfp5gmna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 05 May 2020 10:33:41 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 5 May 2020 10:33:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KuPA0d28/KmhepXUx6s6xkfKTIIfudYVpO8p/TKBVivTWeeQpG9wXtKkSLRZdqts+VNRiJfBX3mYMKGHy1N2zgl1uDr3m2oLIL9/XdLH6xJEpjSy6YIuNKu989ZDdhqw7p177j/ZZqIijRDpuk0mim1nQbiFkSTod5YczN9B7Xi3Wk1Vd/8mnDzGYt93G9bVS23Tzg5rEEtdehUI66NYcTXT4rPGut5NWVCW4+R5GiRYFfuB/cSEALczGUw82wTgLIf10iKG249sT2PeqNFzoWBA525wG+asVuK6HHLC5LwmfABc4A6xoLcumC5ymAXR6HroY04qzRcDCUlB9kAt/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLkrZn56eQ1xqGhe1AIIAtezeOb5EIXPOmoqfR0bFs8=;
 b=MqoeoSY113ZLJJ+HaUsRMlN151UJwQcUjypZFKlXddspCca67sk8FR/XKssY6kM1/KKOB0Q6B6Pov0dZ7go5DaGQtruMP3VR9FjvXQtW0+mVflUaRhd0ElObT8vlz+FdRldoHymtyLfew+CePXY0+3DKpdew2OnBFBinqM8S+TkuzZm1hvXULDBKBF+K3OyZF9O7qJ2D/ub+5ghnjRNQlzxBqXrsp1hX1fECz4jRKI/EbbzffFXfC9i1zWBT6EbzTMYZkUjBhacqA/soFwdAdVuxD14nFww31X/BAnDKl6+WTWy3HKD4jKNdSZP/IIgdjY11ME6GDRusokWPhYjNbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLkrZn56eQ1xqGhe1AIIAtezeOb5EIXPOmoqfR0bFs8=;
 b=GHgfIeDVHlTVqNKwLdKw5CKPd4un5oZAOASF0BZpVSF7VWL0uZ56NEo/dTR9+ThNqGtTvaolMhcgpJMY1wfk773SCbwxoOx0h3wGNCsKsB0N9P+jEd18v0/RSvPUoKD3lXQNuPZVmOUwnAnL0YG6YqJPrMtd2aNmjrPe2UxXp48=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB2566.namprd15.prod.outlook.com (2603:10b6:a03:150::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.27; Tue, 5 May
 2020 17:33:40 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992%7]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 17:33:40 +0000
Date:   Tue, 5 May 2020 10:33:38 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 4/4] bpf: allow any port in bpf_bind helper
Message-ID: <20200505173338.GA55644@rdna-mbp>
References: <20200504173430.6629-1-sdf@google.com>
 <20200504173430.6629-5-sdf@google.com>
 <20200504232247.GA20087@rdna-mbp>
 <20200505160205.GC241848@google.com>
 <20200505170912.GE241848@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200505170912.GE241848@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: BYAPR07CA0060.namprd07.prod.outlook.com
 (2603:10b6:a03:60::37) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:d580) by BYAPR07CA0060.namprd07.prod.outlook.com (2603:10b6:a03:60::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.30 via Frontend Transport; Tue, 5 May 2020 17:33:40 +0000
X-Originating-IP: [2620:10d:c090:400::5:d580]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e892da5-fb5b-48df-0d38-08d7f11a733b
X-MS-TrafficTypeDiagnostic: BYAPR15MB2566:
X-Microsoft-Antispam-PRVS: <BYAPR15MB25661BD273CA9E879DB97123A8A70@BYAPR15MB2566.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CfiGtqrWG3/K0NBKzRMisSvIp1GLigWA2bYYQNL4nvycbCnGgVdgMawPIV640xkQrZCYHwIW3N4OcKafKQhqAu6QDXZUOnHVjkoL7vwDxPVsemFPO9w6I7DXiqTQgJl2Lnc2f/zEhdoWLXKxf0S87ilV2Xt8yj99nRHwgkWW7aO259hghy4hGaZa0uu91omKAWvergR3+YdDC/yPNPCF2m8Ds3d2Nvw1Sxx7TeVT/oft1Tcfc3oFCYj+WAPCIVfaaAe6sCeCsXY8Xltp+8NDbgynBKuOhTwKLHBAXtRtSkPJ0GOSRbVQk3dIfS72Dv6tbbhhFJjkfhgOablT03BgbEbnMx4yXk0dZDeyFi+ubC1xXRxfTUGjF6Ngwl6HAHzVDlRirLay3HLfWUKZ2XAjKyN8QYct11guEv9bWn69Xa6WmYK02GL0d0h+EQauvoHYvRr8d+w5TPREKkRSzQREurJXpAyJCB2x5eEt7KTDZ++54zNdXZ+JBL6MPeg8dHuRIoEq2MKzqsLKosaNPa3hSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(366004)(33430700001)(9686003)(66556008)(6496006)(1076003)(66476007)(52116002)(33656002)(6916009)(33716001)(186003)(6486002)(66946007)(4326008)(16526019)(2906002)(86362001)(498600001)(5660300002)(33440700001)(8936002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 4zfbPTOtWAi9NgjYdQlMmJsc7jnpqBBO3pOT1oDPJL4i4g5AJ+TIoGkQ5V6LqJcQDEyNkUlWWCqf7H5hRO58FUMm4ZDEjBz+q+yHkfBz9lH8vC/1pSzGRjDtoi/V6gQTZels4LdLdppTKjO1VP53WfilD/ftkE9tLXyJpeNbE1cXXTjpzbAlVHfKeateiiyAR0YcGIn9jM1GoCKSvvJoyUfhHmdxlePSs6+T3uTeFN91rGAVBe+iFWNymsmgUOR51Yws7C+q02ZSnYsyPwh67JSHzbl2klaZrtikxC7y2zmF0PxM2WzyfEB+otN6Z8WYg1Ul/hQZf+5Yah1SREREK9vgmo2UEsF1LcxkNq07FytEUUW8seRLw9eAdFc5FChukSlsocF2ZbF8LhS0TG/ZqhFq+bYHQ7tM5LSoSsTDocaPwKrnMbW1o9OutOxo73YwOYooAUQ4bujjzvboIET755x19mOOsSMb76E617EYnc7VqaivkpFC469Rm5OEL8VVGZNiXxr5LLzsGcBo7Y2Sy35LuabvtHk9D19rxSnehlvVAbcb8vOEH6wgRAbsQo5yaRx8vBdb3AHj/1zuqBSPDUctsh78qoC1L9oG/DKNz5K4X4Q0Q0tQGvg/mbEV0E+igAC1z6Yl7JYb31MS01jKH/FMCymJUnJqlAU+jzbF8rTVKS2OtA4d2k1wHTqz8iCmvBUZHi6y6SPVoBEpyVyFeVPWOQGkPMnPL+dII3XXZEVWNZIOdvJfHgPKkq1snkKltDeUKzOadMBAXpPRCQfqowCK9SIt6moVXq9m4fNFheTu9nXJwVVZeQVdWjCU1AaBQyAGTLlrqvf1CHuHbM47ng==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e892da5-fb5b-48df-0d38-08d7f11a733b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 17:33:40.2557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w6nMFvLhc2EtxzCYrFWLe4UIQnvWQuwH8taQzWynHwD9ZfKdLbAPaZTJxpID7Qak
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2566
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_09:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 suspectscore=3 clxscore=1011 lowpriorityscore=0
 phishscore=0 adultscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050132
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sdf@google.com <sdf@google.com> [Tue, 2020-05-05 10:09 -0700]:
> On 05/05, Stanislav Fomichev wrote:
> > On 05/04, Andrey Ignatov wrote:
> > > Stanislav Fomichev <sdf@google.com> [Mon, 2020-05-04 10:34 -0700]:
> > > > [...]
> > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > index fa9ddab5dd1f..fc5161b9ff6a 100644
> > > > --- a/net/core/filter.c
> > > > +++ b/net/core/filter.c
> > > > @@ -4527,29 +4527,24 @@ BPF_CALL_3(bpf_bind, struct
> > bpf_sock_addr_kern *, ctx, struct sockaddr *, addr,
> > > >  	struct sock *sk = ctx->sk;
> > > >  	int err;
> > > >
> > > > -	/* Binding to port can be expensive so it's prohibited in the
> > helper.
> > > > -	 * Only binding to IP is supported.
> > > > -	 */
> > > >  	err = -EINVAL;
> > > >  	if (addr_len < offsetofend(struct sockaddr, sa_family))
> > > >  		return err;
> > > >  	if (addr->sa_family == AF_INET) {
> > > >  		if (addr_len < sizeof(struct sockaddr_in))
> > > >  			return err;
> > > > -		if (((struct sockaddr_in *)addr)->sin_port != htons(0))
> > > > -			return err;
> > > >  		return __inet_bind(sk, addr, addr_len,
> > > > +				   BIND_FROM_BPF |
> > > >  				   BIND_FORCE_ADDRESS_NO_PORT);
> > >
> > > Should BIND_FORCE_ADDRESS_NO_PORT be passed only if port is zero?
> > > Passing non zero port and BIND_FORCE_ADDRESS_NO_PORT at the same time
> > > looks confusing (even though it works).
> > Makes sense, will remove it here, thx.
> Looking at it some more, I think we need to always have that
> BIND_FORCE_ADDRESS_NO_PORT. Otherwise, it might regress your
> usecase with zero port:
> 
>   if (snum || !(inet->bind_address_no_port ||
>                (flags & BIND_FORCE_ADDRESS_NO_PORT)))
> 
> If snum == 0 we want to have either the flag on or
> IP_BIND_ADDRESS_NO_PORT being set on the socket to prevent the port
> allocation a bind time.

Yes, if snum == 0 then flag is needed, that's why my previous comment
has "only if port is zero" part.

> If snum != 0, BIND_FORCE_ADDRESS_NO_PORT doesn't matter and the port
> is passed as an argument. We don't need to search for a free one, just
> to confirm it's not used.

Yes, if snum != 0 then flag doesn't matter. So both cases are covered by
your current code and that's what I meant by "(even though it works)".

My point is in the "snum != 0" case it would look better not to pass the
flag since:

1) as we see the flag doesn't matter on one hand;

2) but passing both port number and flag that says "bind only to address,
   but not to port" can look confusing and raises a question "which
   options wins? the one that sets the port or the one that asks to
   ignore the port" and that question can be answered only by looking at
   __inet_bind implementation.

so basically what I mean is:

		flags = BIND_FROM_BPF;
		if (((struct sockaddr_in *)addr)->sin_port == htons(0))
			flags &= BIND_FORCE_ADDRESS_NO_PORT;

That won't change anything for "snum == 0" case, but it would make the
"snum != 0" case more readable IMO.

Does it clarify?

-- 
Andrey Ignatov
