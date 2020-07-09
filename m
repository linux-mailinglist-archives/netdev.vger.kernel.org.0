Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066B821A73A
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 20:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgGISrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 14:47:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60002 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726116AbgGISrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 14:47:52 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 069IjWIP024241;
        Thu, 9 Jul 2020 11:47:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=pUgz+LgpYsbsEiI4WdWuVY6z43J5v86rTuHphG0u+8g=;
 b=WNo4cDPzaaYUBjR8oymegZyzn+PaIHC1TBAmAcHh64gSS6sPnNXE/t06LLmctwyhBa8i
 j9BvnR7t3lGeNxudHefdZrWgM4A+fQv7GPCRM0Fnbl9Y8/EsEckvU3SLPkLA8CfmCQjf
 7GZT+SJYqRJafoN5E23TB6pJa/VbhfJzhCE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 325k2ue1qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 09 Jul 2020 11:47:35 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 9 Jul 2020 11:47:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fnrIygtRa7pH49tt4jXC1BA3WzkcUs3yq2UyFmzEqyZIPVRuK9aTolNVSxeMWoMiT0TmI9jCGE+49E2oFJwErieDtFOp31GJSqT87Wv66iFdzbLTsTudzi6NRDYlySCzgSclC6Fmpm8AhxPuwSO2/uy4kFtRb3VUL5TTKey9XZyShnKHTh0K9JyJLEOMx6DohTnAiquck31TgR0F6GI5/JOTBYTjgUc9h/sHrhJQoBfSwVzncw7KUo31DA6Nyl8i9Wj/Lp14lW7VaeYwPoybjE7NMwiYpRRw2sNsTimu9A75bSZxhm6ZoPqRDJVvNwt+jcqF8opkQJblPR0sH5AioQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pUgz+LgpYsbsEiI4WdWuVY6z43J5v86rTuHphG0u+8g=;
 b=dca5so4F0zb1Wc1/aiVb3KcxMGGUNYrOu/cFfQGoU8C4co9k09jFNVZ/Sss4kSW6bpLaGNVml7M0JkiylgGrCyqQHO+ptgAotL0i+CFSBNMCO26BQ3XIx+fF/+aEkAWvHGZkTaiZ9DETKDpD4AR+6bS+Eo4tNj7ALUnjdY8sBr24NyJj8opaoO3XBE2+oGXyvVkW22khr5NOukCIqzij6fQAfYLIjBF1USv/+7ytjtfZhtr7M/FaOHsMbQ32O7BzUMPXJKE4wIHJw2+i9MZBVAWFuOtFTWtF58c4G1NLgnVmhjjCdrIB8iWlNLkZLUR72UeYU1gGZ3+XjFhsCy+FgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pUgz+LgpYsbsEiI4WdWuVY6z43J5v86rTuHphG0u+8g=;
 b=HcZXpfJDMKDq7IVj+NUJs2YtqqvhRvOqJGx6fgpi1+7XbdUDORvP8UI7UT09VssmLZfDXthaSrTQWy/tDVii/a45mB62I7oG6P1lFwYafPOVnvB1qTX/AVtrEK6qEYRRLKNkYqBjUKF8XmBOa7QUabpNYwlyVYL4Nr7kmSpEC54=
Authentication-Results: katalix.com; dkim=none (message not signed)
 header.d=none;katalix.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2567.namprd15.prod.outlook.com (2603:10b6:a03:151::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23; Thu, 9 Jul
 2020 18:47:31 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99%7]) with mapi id 15.20.3174.023; Thu, 9 Jul 2020
 18:47:31 +0000
Date:   Thu, 9 Jul 2020 11:47:29 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     James Chapman <jchapman@katalix.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 bpf 2/2] bpf: net: Avoid incorrect
 bpf_sk_reuseport_detach call
Message-ID: <20200709184729.jg2y2g6crxlazlqo@kafai-mbp>
References: <20200709061057.4018499-1-kafai@fb.com>
 <20200709061110.4019316-1-kafai@fb.com>
 <20200709105833.GA1761@katalix.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709105833.GA1761@katalix.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR05CA0086.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::27) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:7541) by BYAPR05CA0086.namprd05.prod.outlook.com (2603:10b6:a03:e0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.10 via Frontend Transport; Thu, 9 Jul 2020 18:47:30 +0000
X-Originating-IP: [2620:10d:c090:400::5:7541]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 294b2dee-fee6-4a87-007b-08d8243888bf
X-MS-TrafficTypeDiagnostic: BYAPR15MB2567:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2567268E70701EAFCA8A8AD5D5640@BYAPR15MB2567.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04599F3534
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OAZVBUC/yaYrwT0h533p+cMHzLEfqn2VeRh99pas9PgZAjQmpuzsFqhAGZI51PgAH039/fwG2FnbMKILG8r19VdaFwZKXP8levfKTcu7DkK8hQj2LKdzWa61liZauv6t5Fqsa3bX93DEob+/8pBo1fNQ4RvPaFcrrGHyPiWFn0fM3sjgJkpnqQWDo6JqxHJ20wOQ2gmzqtAFD2LDMdWb7itNAC1F71QRmShfp1waKqwSHf7hCAJ8Rr/+BufPcvXDK5kgXDMgqGp30C2Ig6G9iOqL/XqTsCVKuY+YUqHtL7pj0+o289D9bVILSdJyghUvS/H4vG1XLKXcD17ctHTUvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(376002)(39860400002)(346002)(366004)(136003)(1076003)(83380400001)(316002)(66476007)(54906003)(66556008)(66946007)(6916009)(33716001)(4326008)(9686003)(478600001)(6496006)(8676002)(52116002)(2906002)(5660300002)(55016002)(16526019)(53546011)(86362001)(186003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ULR2mwcyFDzTqCO5hm9QGNkNqivt4N05HU+tgePST9Os67oiZ9nX265ZDc9bLWdho6mPJmdd8OqDk2dnhfde9nZ69RKyO0LzieYhnM7zJlK/aQ9bKI2AbPqELXOqPeXmoM7lCNa8rdRVUp6PBuyjjeXYCrtJGFXGwF1vmh32TLFSUr2mzE+h5wdBlzGdQpStzoIwcNc5F2IILJKIQyQIcoCNOoNChpbmthOaVZU7Z+10X3e5N4XZrIOXmTWeQ+N7MvC1pNfoYeJVM0v0DPtHAq0868V0DTw9temEarB8ffJ9/J15+ew9GBWd68LVTwiaOtvj+WkZMf5fb5/gKPqW9FreR1ihT+J1kVLFM1oXbSr1bjsh633hgioQyKvqaA9qn0wFQ+mL3+HB9ebqm1mMclFEbZs7jhN6joxx99tm3Z+U6BUeETAH2vJ/y/40vQWFxU808EFRaAwkkLs2RXI3qPd2TOUwdN7wcnhX2PogNDf5kE5GhlLX+KuBiKo1W8zbCnPWg/8GUuPwYhRdMU3ByQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 294b2dee-fee6-4a87-007b-08d8243888bf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2020 18:47:30.8449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TpTXyOecHgoUIY50Msy1KCxqeWiRoffECrbc7d7qgxwjQmRZpXN4FuEi4gqMGnX2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2567
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-09_10:2020-07-09,2020-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 mlxscore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090129
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 11:58:33AM +0100, James Chapman wrote:
> On  Wed, Jul 08, 2020 at 23:11:10 -0700, Martin KaFai Lau wrote:
> > bpf_sk_reuseport_detach is currently called when sk->sk_user_data
> > is not NULL.  It is incorrect because sk->sk_user_data may not be
> > managed by the bpf's reuseport_array.  It has been reported in [1] that,
> > the bpf_sk_reuseport_detach() which is called from udp_lib_unhash() has
> > corrupted the sk_user_data managed by l2tp.
> > 
> > This patch solves it by using another bit (defined as SK_USER_DATA_BPF)
> > of the sk_user_data pointer value.  It marks that a sk_user_data is
> > managed/owned by BPF.
> 
> I have reservations about using a bit in sk_user_data to indicate
> ownership of that pointer. But putting that aside, I confirm that the
> patch fixes the problem.
> 
> Acked-by: James Chapman <jchapman@katalix.com>
> Tested-by: James Chapman <jchapman@katalix.com>
> Reported-by: syzbot+9f092552ba9a5efca5df@syzkaller.appspotmail.com
Thanks for the test!

One bit	of sk_user_data	has already been used to indicate SK_USER_DATA_NOCOPY.
I think using another bit is the cleanest fix for the bpf/net branch instead
of tracking this somewhere else.
