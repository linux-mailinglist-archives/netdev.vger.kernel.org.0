Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0343B1C0DEC
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 07:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgEAFzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 01:55:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30226 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726452AbgEAFzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 01:55:15 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0415k2rZ021041;
        Thu, 30 Apr 2020 22:54:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=grnGdsLOW6YFRRNqTbstkoVSO3yLREvKozzYLNIQClE=;
 b=hDFvnWjslTCYwGY+rDwS67MBPYgu/lfylawFezav1SQJv0SGIgEm3HmN/YE1qhUQyPv9
 8tzP0mAppjLq9U5//6Db+Y78y0HC+37DkAT21h6kC6nZOasSWO8aqMRUN68ITs75CU8N
 xYpeWFQtHp45MdpRNF0EtadrjGbVnS2/2l4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 30r7ee1s1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 30 Apr 2020 22:54:57 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 30 Apr 2020 22:54:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ue8X0MvqjdMoM5ZQfYFf0AKCC60Wth5Te9vOXM7SajsI0lkT1RY7HkvCxMAkR5IUQW7rMKkDqaugWxk1eymXKp9EASmbFWpECxn+4jpmlpLvVtlnrmrXxyQj/fsafLGMqe45SNNJAPd4WsiptzcPKqPLEbPgzAQXK2c1BCxq2HCn1nh2s7y+mfurRq+BLvV0/sTavDduQk7x3jl87H4pJp1i3y4zOHplI3njQN1wzWPdTc5XTBd23y4i1ZDmW4dofcoY669t6qecDofr9cBQwPFv8oV2siFKvXvnPLTmjstTSP/z0tknDJGFY+nRoGYbUi8bOj2yazVCtSW+NMjPDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=grnGdsLOW6YFRRNqTbstkoVSO3yLREvKozzYLNIQClE=;
 b=EzYVboVAUwAuFuKlamsIt8ToAnVK+oL5v/w4NjTp+ALQGTzpNdNYPDq9VuIR6MxUg55gW9svNco1HVa6j79dAMjfdeJ02NtMXjPvl0Yg1pOnCQ+GLoXixkDm+3yRaoPxAKBPgbwKjcc0CmNW0B6RL8ruP+o/Bw4ZdwBa1KjzA2I56kloZVrdnsx9/QSrWpIaz53I1+JcZRUOyuz3AwFYewwdmehKeB2hiROYieIBvS0QqUiB8dmWWTvfWtEu+BbsalhtlIORi8+pOHsYcju32LWPpHDvhEAzcKp9O6mAOKJ2zckVEdYsF6cCg/B6TWHdCTdrPj9L7NUGoTFcGSjXrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=grnGdsLOW6YFRRNqTbstkoVSO3yLREvKozzYLNIQClE=;
 b=bxGVRb+EKssHRKp2FOB56JBhwkul3TwVnc4pOT5shkkSczD0hiiJvdwmoKa5nb5qCZV5Md/UXUhEJAeHJd9RrmKgXE71rpNATBppo4Ecj29/9uyBasYpnsFCkR2hz16d4s3sdzDjGPy67rSAcAf0T+8/bOzBbBolFjvrnuXW3Lo=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3771.namprd15.prod.outlook.com (2603:10b6:303:4f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Fri, 1 May
 2020 05:54:38 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%4]) with mapi id 15.20.2958.020; Fri, 1 May 2020
 05:54:38 +0000
Date:   Thu, 30 Apr 2020 22:54:35 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH bpf-next v3] bpf: bpf_{g,s}etsockopt for struct
 bpf_sock_addr
Message-ID: <20200501055435.lfqqn2sprwclw2fa@kafai-mbp>
References: <20200430233152.199403-1-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430233152.199403-1-sdf@google.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MW2PR16CA0037.namprd16.prod.outlook.com
 (2603:10b6:907:1::14) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:da9a) by MW2PR16CA0037.namprd16.prod.outlook.com (2603:10b6:907:1::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Fri, 1 May 2020 05:54:37 +0000
X-Originating-IP: [2620:10d:c090:400::5:da9a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f842ac18-53c2-4544-7332-08d7ed942217
X-MS-TrafficTypeDiagnostic: MW3PR15MB3771:
X-Microsoft-Antispam-PRVS: <MW3PR15MB37716079397129B2A0474258D5AB0@MW3PR15MB3771.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0390DB4BDA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qjEokMuIy2ElASsLMKoUzGVl/8Oga/swl8pM3CWD0a6HQ7SjYqETJgIoUVgi4jJA4wBPgsdk9V9jackhtWJykPBWmjFhG+MSjwaLr+Ykm+dYdFqRLHVQdOn64HqGqbbp1qvA4o0ES4mS0cjJ1xNorfWSxt6RFl9Rt5EgigAr2+WkQbDZ6XNTziG+X+GjTgAGvgddCeiAIo7nlS385dLGwoKtNcOJm9hUjSJyjCebeypQo2kt1k54RSpzOFgrDaZCAk9/YKKHYeUQQuyAj2/si6mSkKb85slRmc0oI1xpOZ2zH/tuYUMUWP2u8iBB8XxyqClkbWPg6XdmoHm7ZFwrG7yO4CxVFUzp/LUuHM2MR/ef1NFRO8dgFPKvkMuxQLzxT2PNhLKYu0vAtdn6Gv+OUKMpjeB0eZhrpeVrrqJX5X1gP0iHSIHz5lurtZVcLD5sFp3v5h11PtpFhUFhjpNVq2VcQkc6cka2ouV/BeYybEV+Nk8TNvZlipOfYd11QAOX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(396003)(136003)(346002)(39860400002)(376002)(1076003)(55016002)(8936002)(478600001)(9686003)(4744005)(5660300002)(66476007)(66556008)(2906002)(86362001)(6916009)(8676002)(316002)(186003)(66946007)(16526019)(33716001)(4326008)(52116002)(6496006)(142933001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: JU+4tKMUa1eB+3Ys1SZLZA2Ny2lQ5vYtC7HYwOuFT9kYX+Mdo8kZkwIH4QXVf99WBgJDO/ALEGL6YgDefRO+ilzclpnHGdemJzdNQVg9kaXEhmWADmbV/LtSp2rhzPVe/cy37FC6mTD21u0XZOjWgGS6JUPw1lCKyVtemzfE9Vnwkq620YnDhJAuIPFd6T4sJTlkxfXcAvDAiqdLe9igKM7KO51SZ0V/zERm6Snh9L3p/VTiJwWGCpEk3InNPAwP3WbMxf9kUA0N6pKWKUCSGD54+hJ776tFQOFvTuFo0OLTtgcgf0hInmGnv5K3S84Ori+A+HU7bddVl9Br2i5BNwvcqWyCjSEZYrWNbpKXaqmdWBen+EZZTJ5SqVZu8j5/Kujfey2AhruW8JULxg2k2ohFqLLaaDE74mFRnXOpblvAp2Xv+U4rlxxtkHfkbjQwvjW37Enn1NLppzCX8RX6454335uxT4+mMPzEq7B9fyg7mHiAC5gX/plnQLqQlw2VwipjX+a7hKAlGAeSn+/uXMgfV4ytr0yUbtKdbynIkZP5eaI2Ajcu/XZqD2hNjHB1zwntg2DnSXuUm6KUKjv7HS0Sa+RtNCKhVtxoOwEnq6Li6wO/k4/CaXqatKHMEJLBhywcQluvW7JqiXO/Kp7FK/8RmiclBXSnbkFyR5b6P8vY2K7KvSX6dSjN+owSGQo8Jf9NXoQh2k9H5b0HnG9LK2V+GT9tgYUBZoxKPzi4526SsOmdjaC4c+hQ7lBXm3tseVwTva+9X1L0N7NDAvf/tSovUZMilwLKf34KoawxK/XlOLYrmoDglYq42LK8yyLkh4o7yKOqOJbBXqUl8ehRTA==
X-MS-Exchange-CrossTenant-Network-Message-Id: f842ac18-53c2-4544-7332-08d7ed942217
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2020 05:54:38.1946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jps6y1LyDZVV2lFUA8ogFhT8d5EoxnMM9OY7Mob21eQg8dZsJZSA7HFsymPVCUMu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3771
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_01:2020-04-30,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 spamscore=0 mlxscore=0 impostorscore=0 adultscore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 mlxlogscore=953
 phishscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005010042
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 04:31:52PM -0700, Stanislav Fomichev wrote:
> Currently, bpf_getsockopt and bpf_setsockopt helpers operate on the
> 'struct bpf_sock_ops' context in BPF_PROG_TYPE_SOCK_OPS program.
> Let's generalize them and make them available for 'struct bpf_sock_addr'.
> That way, in the future, we can allow those helpers in more places.
> 
> As an example, let's expose those 'struct bpf_sock_addr' based helpers to
> BPF_CGROUP_INET{4,6}_CONNECT hooks. That way we can override CC before the
> connection is made.
> 
> v3:
> * Expose custom helpers for bpf_sock_addr context instead of doing
>   generic bpf_sock argument (as suggested by Daniel). Even with
>   try_socket_lock that doesn't sleep we have a problem where context sk
>   is already locked and socket lock is non-nestable.
Acked-by: Martin KaFai Lau <kafai@fb.com>
