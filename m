Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5CCC2AA22E
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 03:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgKGCRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 21:17:32 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5212 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728269AbgKGCRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 21:17:31 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A72GSaj020621;
        Fri, 6 Nov 2020 18:17:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=V+5nCnM1r/WlXR/Ap0Up0fr3py/LIOdLNCvmB3na9zg=;
 b=LJ288iIqyoHZH4Fqx1C+GXcf0UVvFrdDWH7h9SU3wxKCndigNDg4Zq30jBuBiInfbE14
 a+5WcLZylI9qKrqSq1dXmnWH7RFeasPHkx7OaOi47vgqgqyqXZFJvrhYWdf37qbAgU/1
 zFq4g5dQW29GKSMtpWhWAZvI0PIFV3KXmZ0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34nagxtfu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 06 Nov 2020 18:17:15 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 6 Nov 2020 18:17:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n3bDZ0mqPWA0dJYBX4jCzppX2eEDKCnTOYqaSlrFVBayXFA/sMRYH9INthWgrpDoU7DZ3jlkSSmcoB184mQMx3F1+lLI82vpZ3QfV+ER0nPqiWCiobGLyNYDaST8cESoj12e4S57rh1BdWmvxtkDaNWPTMCQ9UNY+IX1qF5W9DqR9haRw2PXLAOcOWeTynnSf4dcIHTrROlbvyqskcSvWgjQKbdf03agYZGNaLeQNuihRionmJjGfxtUprOlXIUwyP/hbE5uqq2k5Ohw1AHS6YY9utq8tgm2BA/BViLMBOXJUM7Ut2RPuu66ho0R2dToox5qWFw19Ph8m/7qqgPvlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+5nCnM1r/WlXR/Ap0Up0fr3py/LIOdLNCvmB3na9zg=;
 b=ZE8vgo1pmcs5P7GFPP7zhoTa10rJZJ1It3NmRxZbVcHq8W6XzvT34M24qKB9KhxZbxS3mfCJtUli7n465Ih/TJVLjtb9LnWO/SZ7wvTRKv8y9SKcsZTZpSJEj/XEjS4bkkRqdr8c6VXaIQDM5Q1wcTMxiqrh9TyEJKeTe2VnxAu+EO31rVegislWHBR/kWqAUQ6xwXknNFf1JgIfJIhXegZs1b/qKFkNicM9rrkye/W/PkNfJKq13fI5nSTvFTgycLjYnW/1vgRU2zUyP206MIy+FdI7/087ycW2ffccxf0NtcPvpRsRQUiVhcBxyfS+75CT00py4ZJc0W8zXbfI8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+5nCnM1r/WlXR/Ap0Up0fr3py/LIOdLNCvmB3na9zg=;
 b=jtSCtRck69hACyWCvwy4IfwpuCYko1uMxliKqd3Nl3I327UN0lvaGko0kTDXqtVfZdIVLInbQvObDi6p/aAvqZMiRn2gJAVfb4IldwfIvrE/t8hGNhL7xxfw11DkYmY27b3jbfkai4CDy5a9l0fZueoHYHlvVmbTm9VwAPmeaPQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2200.namprd15.prod.outlook.com (2603:10b6:a02:89::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Sat, 7 Nov
 2020 02:17:01 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3499.032; Sat, 7 Nov 2020
 02:17:00 +0000
Date:   Fri, 6 Nov 2020 18:16:55 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
CC:     <netdev@vger.kernel.org>, William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <bpf@vger.kernel.org>
Subject: Re: [PATCHv2 net 2/2] samples/bpf: remove unused test_ipip.sh
Message-ID: <20201107021655.d6y4ag6vkaj5b5jh@kafai-mbp.dhcp.thefacebook.com>
References: <20201103042908.2825734-1-liuhangbin@gmail.com>
 <20201106090117.3755588-1-liuhangbin@gmail.com>
 <20201106090117.3755588-3-liuhangbin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106090117.3755588-3-liuhangbin@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:3041]
X-ClientProxiedBy: MWHPR14CA0024.namprd14.prod.outlook.com
 (2603:10b6:300:ae::34) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:3041) by MWHPR14CA0024.namprd14.prod.outlook.com (2603:10b6:300:ae::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Sat, 7 Nov 2020 02:17:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1f08e16-305c-4948-880d-08d882c335e5
X-MS-TrafficTypeDiagnostic: BYAPR15MB2200:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2200DC3969E9070A7F31837FD5EC0@BYAPR15MB2200.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R1ITSyaSJZeLC/no4gq28PvA4nLS7fHrGW0AKCf2E+RbF7fHk5O5TH8ATIYFXutwmKbiPEc+1hmLnh8TtyHUVh4zEbueNqMPz7GMudF0zGJBwtvSNzwlh44GtMOC40DA6b1z3ybMuLDll4QX/H72lbnyO1BL8R5KMJx/Q1f+ppmSFLho1pN7BZHQdyb1UvPkLrn9JmZhDkgB6+NLfzdTARFzfs2TIjbdiQpIFwM0BBrZW5GbTRW5adFH3zVZQtcaCaGuT56Vdlk1v6+uODVSooypRo1UY42ecf4RGWL66F0ZnrNOi7HDNe1cgktkYPWAkUqy/aE5O7gYe5fzIVbtOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(136003)(39860400002)(366004)(8676002)(5660300002)(66476007)(66556008)(8936002)(6916009)(54906003)(478600001)(66946007)(86362001)(4744005)(1076003)(55016002)(186003)(6666004)(16526019)(2906002)(6506007)(7696005)(52116002)(316002)(4326008)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: lzqgZy5bfS06Ml+9MDsvxYJfta7DcdsIXGVdjMIaJeFLKW0ETbN7B16/UxzJvWrbVrUFactNaL6v3P379zVIGnVpeL/6vBmkd8ynGpYMv5soXZB0n0rJgEo2FVBw3ykMTSDR92g/DjcS1W3ey/gi450eZeQ816kv4ecBFSdSrFsT+VSmtg8gFzHYei3XAy/S/+GLdfvQe8U/3baddBrXPU7fYiPXjQiY9CwN1HJbZgnNiPEyIF+miWJWPpTg3rGHpKYAh+K+UgIbkUg0aiA6JCFUCJbt+ftRv6mj1/QB7pJuHSOffyJJ2Ysj0v5hWzz3zwB0vS2H+eAgSTM4ofZ8fra5H51/DQWcFi6HU1Y8zjE0pUfELOojbCNAemc7JREZkM75Llhj97cWFR3fn/V2EgeK+iX0grO/o2HvRnCYLqYmG7oDnHZ0ewGCaaYIL3eTb/G9xVFCOU4Y6q3pjw1l6gE8RwD5sNbg+JkAA6BJdcsHfzz95028nM6b/uKVuP6fpPXaNdcytOg+xp20+Bg9X5Al4BJagfWnLbEuOJj3rKAPjgwFVZB2nPTJ/JYBpZgRvoKD+YNKLRFamUphLSBCPI/zHC+I4KdzRCvr7lgr0r8I+xzNJ9w0PSVz8wPDbUBDbxZi5T9wVoZxojBjJEfboRn106x2UCCyu/0HFlGBVCQD8XfbtBPnnt8INyLsKa1b
X-MS-Exchange-CrossTenant-Network-Message-Id: c1f08e16-305c-4948-880d-08d882c335e5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2020 02:17:00.8613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sNvvCkBDjcjA/pxEa8bjETOig8ha40H2LDFPgzk6McuWlq+01gBJcVNQ6qoq0nxk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2200
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_06:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 suspectscore=2 bulkscore=0 spamscore=0 malwarescore=0 phishscore=0
 adultscore=0 mlxlogscore=687 mlxscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011070014
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 06, 2020 at 05:01:17PM +0800, Hangbin Liu wrote:
> The tcbpf2_kern.o and related kernel sections are moved to bpf
> selftest folder since b05cd7404323 ("samples/bpf: remove the bpf tunnel
> testsuite."). Remove this one as well.
> 
> Fixes: b05cd7404323 ("samples/bpf: remove the bpf tunnel testsuite.")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
