Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187B12176C4
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 20:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbgGGSbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 14:31:39 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4278 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728036AbgGGSbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 14:31:38 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 067IBJAs016027;
        Tue, 7 Jul 2020 11:31:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=90H3+ChY0Rwj9+GuMXrRF8IMJEKjvLxb/I8QKWGBqw4=;
 b=Ftjs5t0IzmrcVbTAwk4DneghWV5rVAMR62hXAfF5G5PwpipoGi2wfW+nd4nTxLDD6bs9
 GGZDDjuBG724Qz/jbHRlTcUC9UiOJlXcKH8olhn9MCZ0MiEB2hwEg8BDiLRTNS3nFTul
 ilP9s+ZaNAy0nGJEnFegUXfq2ZDX/fFGMlU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 323a1nk3dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 07 Jul 2020 11:31:32 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 7 Jul 2020 11:31:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WqG9sNPMhVIZHVq2qZ8a+HvLfGiC6bIPNG41fTmF2p6yjS8oqkbep5X7YpVaviDrDeIe7ePp4uKdYCWH8Fv0GYzX08VWGBpEmt3m9rQvYTThCNMHIeJhX9sZpE4zLaLpBZnFvMENSN8vhI3YMHrYz0P/zCMXVA7xRFwttUI9RFUZsKwgb/PiHrAibZIZHvi90dartLRzMPUt8K519iGDHykQqLpfPU+iEByXuefTbwojpO/yypbULt+Wm9FDpvf7/N/cDuZjZDReNBQ3IkbFjFbzS1S+3JW0gj7hKPlNdHREM9Llbm0Qf/7anv9rvmnp3Gesx28Ugl0g0jr+O1V+2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90H3+ChY0Rwj9+GuMXrRF8IMJEKjvLxb/I8QKWGBqw4=;
 b=lJP3kQk0wJzq9aW8a4dGwT7e+HZnEmSPwIXffEtvSs/dUA1ai/7sqpd/Njib6+LfQqdvDjPg1ok1aOMIgnCW2k4jNms9OrRjakzhxJusrZMgHJRoPZ53y2UZHhWey59neuThqDghs5lf13WY+0bq7rNxwSnOr1/SU2PMgu+rh/REXp6G2j160rv3bSIl0zIInWqOG1bwQWvw0SwEThdiGuIlRC627vovSaTmcymZVpGu7PIrzCEsN7KiUptaHYHGKX8wKXSf21gCx2WIZQ0SSwKW9WULQq9p4vfYm8oGzhLkEkJvx8LoPsBqAKgVem/h7+VQDR7En8zhIBMrAa4jIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90H3+ChY0Rwj9+GuMXrRF8IMJEKjvLxb/I8QKWGBqw4=;
 b=jSA47Ed+iXvg3z4RJ1A7EkgmElPMkcPWrLXc3MejYkaSeIbNAmHbPZP/ISDycH+mjGnuJK39vQIsdNMkQ497/mdPDRvjLqO/SacJ0cs+pt/HAHbugOtpjwdHvS8yZ388i3MxI+X7JBKJC1AXltQZQ+Y2ADYtCvLqCtotn6XwinM=
Authentication-Results: katalix.com; dkim=none (message not signed)
 header.d=none;katalix.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2824.namprd15.prod.outlook.com (2603:10b6:a03:158::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Tue, 7 Jul
 2020 18:31:30 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99%7]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 18:31:29 +0000
Date:   Tue, 7 Jul 2020 11:31:28 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     <jchapman@katalix.com>, David Miller <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <gnault@redhat.com>
Subject: Re: [PATCH net] l2tp: add sk_reuseport checks to l2tp_validate_socket
Message-ID: <20200707183128.owsu62mnxp3k6lae@kafai-mbp>
References: <20200706121259.GA20199@katalix.com>
 <20200706.124536.774178117550894539.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706.124536.774178117550894539.davem@davemloft.net>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY5PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::31) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:6c3d) by BY5PR04CA0021.namprd04.prod.outlook.com (2603:10b6:a03:1d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23 via Frontend Transport; Tue, 7 Jul 2020 18:31:29 +0000
X-Originating-IP: [2620:10d:c090:400::5:6c3d]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc832ad3-e2da-4205-7be7-08d822a3f743
X-MS-TrafficTypeDiagnostic: BYAPR15MB2824:
X-Microsoft-Antispam-PRVS: <BYAPR15MB28248465206BD9050E14D456D5660@BYAPR15MB2824.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0457F11EAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YIoFSu2wFMRokrfO881BzwrGBTV4POZDQKPtCJTKdH2C2wVRGiDfptg0IW3q0oZAsXdZQWmls8kFZcd/oaeX0gPIJjGH++6nmRVZ/h6OAHW5KPtEIWBzFoIbrvgpHTFOT3/e7UNsEx6ZlyR35TMSZ8g/s0CTcQT1WAiXfkhQW4QZc8sWD8WDjT6nYL8PTkrFnTPRttqkTNhmWFeo4rntWekFbBUvEg1t3IW+IYShRAK/W/AQDaqoCrd+D9QVINutXIAROpHdEWnWgFMa18jzItN0c64Z2bHHD7gy3hzG9KivFbQXrnXYJrjdtNyxJwo2XvAMK16KXymoL9XcGaXWrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(366004)(376002)(39850400004)(396003)(346002)(6496006)(8936002)(86362001)(66946007)(33716001)(66476007)(66556008)(478600001)(55016002)(316002)(9686003)(1076003)(8676002)(4326008)(52116002)(16526019)(186003)(5660300002)(2906002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: vmAxk6ZRwrNV1ObtEyUEwHgBbBCjj5Z60YWaIRf390EAMbccYg/tmYVJlCzn0eXMCesHQInsi3Gp/CKoURMV5v6a8t9yYnt2Fnrub9CUzwg64I+5BcPudjM6tuQoHy5W7s2T2P1K7MOuYRtR5e/ZOeSU6wfHVgEh16KAPQurz6CYpnmvo0e3NZVcJjWd5WFDIirmQOjANIo+WuAfbTSJBpGz4BXjXhMhLCDtEAXNHQqwUIWqJwnIr25/TilDoxbv2YrtZPXEA7M4t9subQeQmUr31UJ8Z4TJMOlyg6kVQta/Rl3LWoRArzpfkmLoTAHJTz0Aoaeb/JYO6cK+eN6gnb+cKdFH+A1dVgQDSs9ybHpRgoXWyXWnCKBGhj0SkjXKk0zqzzo5G6OPdJhF9tCtaUkMx+i7HhZaqA3GZ6i7JBoniVA62l+XB4qjQXtbO9imq6mNK3O5wOMxm/+2BjYy6s+bPwR2poriB2ek8Bv95ulVDld2NeIxm/cz501z4RXnhlJKWNKvVtwsR6hfoBTgUA==
X-MS-Exchange-CrossTenant-Network-Message-Id: fc832ad3-e2da-4205-7be7-08d822a3f743
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2020 18:31:29.8212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9hN4B+bXlHyJ8IDib5V6X7wdPcPgyaAn7ORHgJCi4Fv2K8iL/4hPa+MPE3sVXTVW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2824
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-07_10:2020-07-07,2020-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1011 cotscore=-2147483648 mlxscore=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 impostorscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007070123
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 12:45:36PM -0700, David Miller wrote:
> From: James Chapman <jchapman@katalix.com>
> Date: Mon, 6 Jul 2020 13:12:59 +0100
> 
> > The crash occurs in the socket destroy path. bpf_sk_reuseport_detach
> > assumes ownership of sk_user_data if sk_reuseport is set and writes a
> > NULL pointer to the memory pointed to by
> > sk_user_data. bpf_sk_reuseport_detach is called via
> > udp_lib_unhash. l2tp does its socket cleanup through sk_destruct,
> > which fetches private data through sk_user_data. The BUG_ON fires
> > because this data has been corrupted.
> 
> The ownership of sk_user_data has to be handled more cleanly.
> 
> BPF really has no business taking over this as it is for the protocols
> to use and what L2TP is doing is quite natural and normal.  Exactly
> what sk_user_data was designed to be used for.
> 
> I'm not applying this, please take this up with the BPF folks.  They
> need to store their metadata elsewhere.
Thanks for the report.

The sk_user_data is used when a sk is added to the bpf's reuseport_sockarray.
Before it can be added, the bpf side does check if the sk_user_data has already been
used or not.  It is the similar check like other usages on sk_user_data.

The missing part is the reuseport_detach_sock() should check if a
sk is currently in a reuseport_sockarray before calling bpf_sk_reuseport_detach().
It can be solved by remembering if a sk is added to the reuseport_sockarray.
I will work on a fix by doing this.
