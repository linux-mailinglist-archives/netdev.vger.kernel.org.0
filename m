Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864B01C5FDD
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730673AbgEESQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:16:58 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58338 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730334AbgEESQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 14:16:57 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045IAoFA004484;
        Tue, 5 May 2020 11:16:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=dOxHLODbgtc/YIGXW1grc4t0aJA346W13Gi7BzmKR4E=;
 b=Dnjrr6+FKRPtkMV0H0rIFPkCg8JMAq6G1pr+5ruhimeSICSTh8BDTF/emP93kpWSYe+U
 ps6fTrz6yZxH6vvAwH6M0UzaTFvcVS8A5M7/jtS0z3/cljXYMo9ROZxqinxKwGnbNXKU
 3K3I6+NDoinUyMN3enwCUiaEZ2bqg1h0Dfk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30ss0wvna4-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 05 May 2020 11:16:40 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 5 May 2020 11:16:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJmIdheRz+PN/ySl5MQFQwmeJYcVTrZta3moE5iY9YoE8E/i126X7Mi3JMCtmjNeLv6sjprqmRDiT+0n10iUeAhmonb6BVdGAnLFb8U8VXM5q+ARNjwzeA7oFd0MwvO1zFg1UUtjKMvZnF3chZAE2HHsTEo6ZcuwsY8tqP184E8/lME5yJsyxuxZkRPLYimOGTr/a8lnxuDnqqnB4E2+qltfuXVwJV9UE8nRuFnhlSCTiIIOOF2Dj8YbpeSoR5+Y8yLUfjafUeNEbZeVKH4LfVtsrHnQZwcgmVYVAM2Q9ejUafXZ2fTauBOBMS3PNlucEaCCkJGqzrIlmAAYi2kaHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dOxHLODbgtc/YIGXW1grc4t0aJA346W13Gi7BzmKR4E=;
 b=Xv8AbqZ/oqpCXMhJ4hnC8QjGJGqXzhEoE9SXD+4LJ4KviPc0zRb87LmXkqNS6zq7gYUh8YIHHGi3jH3JdByGo3Ps3ggjjvIHcVhG65UMPc1b/FqiaUVtgQRMChNDoLPhkkv2TgkV8vuQMbA1x4tFV+wGiTmS964gwiD7bH45CxIGPUN3qOwkrvES78claV71asYoQ3DKjL9jbjJTkJvLxC+iFjAuMPCF2hhHvN7I6CQjie+uLvWjC72PtTa3FjCk4tMvLh9N4n44zfCp93MPBYKgpvSgOPxSBTnxnTMnyhImL8FyyFPB+mSMEeP4+jVGtfyXw7NCjAN2LpcmnZV/oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dOxHLODbgtc/YIGXW1grc4t0aJA346W13Gi7BzmKR4E=;
 b=bBEHo+NMXUAl9f2nZge3optjK1tZsU7eT+yEpd71VL5ewpSi8aEzZExVzTvj5RKIMtx0ZeEfLcYN0tsjOdA10gy2x5pMk6IVMy5b5xC8IxRR8xR6sMewDTmnPKFdxQ7K4mzs66TQDzY8HHde+7hWJxApoEi/H7CuTS6PAmjG3Cc=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Tue, 5 May
 2020 18:16:36 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%4]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 18:16:36 +0000
Date:   Tue, 5 May 2020 11:16:34 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next 3/4] net: refactor arguments of inet{,6}_bind
Message-ID: <20200505181634.sd2m63wu7lf22z3x@kafai-mbp>
References: <20200504173430.6629-1-sdf@google.com>
 <20200504173430.6629-4-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504173430.6629-4-sdf@google.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY5PR17CA0065.namprd17.prod.outlook.com
 (2603:10b6:a03:167::42) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:3100) by BY5PR17CA0065.namprd17.prod.outlook.com (2603:10b6:a03:167::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Tue, 5 May 2020 18:16:36 +0000
X-Originating-IP: [2620:10d:c090:400::5:3100]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b30130d9-1e06-4caa-c29b-08d7f12072de
X-MS-TrafficTypeDiagnostic: MW3PR15MB3883:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3883FD10BA10ABB23DB5A6E1D5A70@MW3PR15MB3883.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:169;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PIcfJ+4bO3EAHLhAHvpVtkuwGJfL3vg26Q6DxqcuWyO1fGMuBh9RhOT+O+sIw0097YI5JZvbw5X9VhcVlu1YBqR+8vz71SCZFGCE+S8Q0tF3BiEVS1jlIeOk+nI1Ol+3xHiNMzuIBB7NFtA3s/aeWxrFM/AI2IeCqpOkeRtI7tGeV+KYBflMC1xWo4n9Z+DQneIKAyqorCruUVwgbuMooJVN2nBM+i9dFdXDsYdigCryLZO9OSTTrbxcFtbCfKuWEH3RdTKoiRoAYbooztsbA2KZMXUrJU/Lu89ByamDre3iHkhk2eyUFBYS1nHX/72Mo60WxqoOKq6u9or23cgzTV01grO8bttOQc6Bgsw9fQl0aIkiUnOCdm/WwhzYLn5YYim9jmXqDdAGBSbSIEeovUGMLOaXlWfqJQ4jg74Fxc7Wb7PG0pyQnmvOQHJQ/el2mWz//EKZHqnUhuR2EZQqHZMuOCWfC31iLlzVFmjL2/Or3JA5Oojr7YiDuKpq/ZUIWrM1YFvBcRjfEcSImy4tCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(33430700001)(6496006)(16526019)(66556008)(33716001)(86362001)(52116002)(5660300002)(186003)(1076003)(2906002)(6916009)(55016002)(9686003)(8936002)(4326008)(66476007)(498600001)(33440700001)(66946007)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: GrEqy2Zbitx4VwcWu482zzy4ix5qJl8ClOe+8CWETZa8y3FHYSEzCXS2eMOWCfcKHe825SNnHiWBV/D1ZuxDoV06+tMxQs8+wFnHnhB/KSzII2t8oTR3u35vC5KZEqdRoFHAKlZPCar/l1knPcXkpp+gBrj6Rc2bPQWoOIi3j38HlbI5PCNG/RGQqdLk2DtuFmj/nqoQu4hj6aqQenkJhmvMiMwXRc2myBx2Aoa1J483ckVkIlJZnD1nWdrdjGZEGvFhJCs4spVI3RMlMQwoSMPW0N7QH6MKAi+UNDLPYyf1HhZINFNEEJusoZmffT8wW2KEH+4Grbb/Urmjity6CHwIwz4XaHkdPIr0wT1Bx6VIOgJ1uA4F/vRRJ4f7OADCR8GMGHNZTGXgmAOpvv/+Vr5UJGMB+ZujBPK3ClvQa8lNHhHfB8Xd63PY/19I7EDFytsubUzWZGDqhOwVf+/+Mw/8hF7VvtHzEhXvX3iA8jX7M4PU21z3uO/xBmqGINqE0adgtu6ZOaQNso3A/tvumBN3jECcbmnNr+v8uP8Lsj64dj39UZLRnoDx6+GEt8cO4IVsi4V7CsijSAMjR0S/lGCnd3ziNjLPLuAJKIHqGJu48JqyoOjxRV0PTdAzOEo2nPEywJeLoFyR+JTnHRA3jepoAMJq32ZYKjBrYVqZcuKZ3wxEsKntdp4REnZied+5cyclUfa2R4I1DX6cWfgsfQVJ5AwTDyKRYSijCFM+uU2MD+rwxIRMoQu5YATu8J3pPE1UCGcxdIdKAjOTD5MEnuAre2T7mn8GMFs/6WLlH/9XppcB5Ec/6NlcYQM/tPww2m1En6+PSbcq23GKpBk2zg==
X-MS-Exchange-CrossTenant-Network-Message-Id: b30130d9-1e06-4caa-c29b-08d7f12072de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 18:16:36.6993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E1pGo9tsi/47cj2IDERvNDnQGl5lXMSTrw3PJkRye6INUmrh7C60rKk707M3E4Ph
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3883
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_10:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 suspectscore=0
 clxscore=1015 spamscore=0 malwarescore=0 adultscore=0 impostorscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005050139
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 04, 2020 at 10:34:29AM -0700, Stanislav Fomichev wrote:
> The intent is to add an additional bind parameter in the next commit.
> Instead of adding another argument, let's convert all existing
> flag arguments into an extendable bit field.
> 
> No functional changes.
> 
> Cc: Andrey Ignatov <rdna@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/net/inet_common.h |  6 +++++-
>  include/net/ipv6_stubs.h  |  2 +-
>  net/core/filter.c         |  6 ++++--
>  net/ipv4/af_inet.c        | 10 +++++-----
>  net/ipv6/af_inet6.c       | 10 +++++-----
>  5 files changed, 20 insertions(+), 14 deletions(-)
> 
> diff --git a/include/net/inet_common.h b/include/net/inet_common.h
> index ae2ba897675c..a0fb68f5bf59 100644
> --- a/include/net/inet_common.h
> +++ b/include/net/inet_common.h
> @@ -35,8 +35,12 @@ int inet_shutdown(struct socket *sock, int how);
>  int inet_listen(struct socket *sock, int backlog);
>  void inet_sock_destruct(struct sock *sk);
>  int inet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len);
> +// Don't allocate port at this moment, defer to connect.
nit. stay with /* ... */

> +#define BIND_FORCE_ADDRESS_NO_PORT	(1 << 0)
> +// Grab and release socket lock.
> +#define BIND_WITH_LOCK			(1 << 1)
