Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBC520CB44
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 02:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgF2AqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 20:46:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44890 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726395AbgF2AqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 20:46:21 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05T0flQF012053;
        Sun, 28 Jun 2020 17:46:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Zmo9TJe49QTZXvZ9D8WvAcD4wTha2EK5UJ47Sk0iHAw=;
 b=cfr0l2QLMlijGp0gJbcm6j2u3Gupt40qN2Q1cWGcy71Smiuai5jtQJraY1fJudVIIKt8
 bg49xwhmQUJTLjCuucC9mPGDo3hE3FGiULka0/Ux2PfR0hIBBaEfNx8qf6feWwtyW4Op
 Pzefa+yic8PxPrm3XU9Jsz0aVwHV4R3rtiI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31xntbj6m3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 28 Jun 2020 17:46:05 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 28 Jun 2020 17:46:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O/VygH0dBTe3tiVVS9utmeQk0dZzLGkwDFByVFYVqu2D7jqmFbNw860A39p8BGUY9wCrJXB25KiqS9iiVVTu/Ob9clrd93p5v3d0KeWmUiFDQAKmFSGJMURDGKMJFNt0TuPsB6beHYS9tBmhRgpIChsfJ6oZj7xea1h1Ve81L8BkfnOVT+mZCmasa4I8eior7BxinDh6D2W5dTnD42ZEMqwCAu4x8I10J3gLUBKsXCvCMF8Mjl2372sAuxuCoyLRu6HTeIoyHP9AYv+yVurHg9wjUsGIEUWbyxX1Oe2gneHsg38JozZAGPVLd94O7MlqrVLuK7U2X8mAVJUNz6X/6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zmo9TJe49QTZXvZ9D8WvAcD4wTha2EK5UJ47Sk0iHAw=;
 b=nfCZG4HY/lRSpj/iZ3SvEeJgLNF7y9El3uqS3OXAzPrlSzESbRcxkextFfgXEf1Z8VpX4mnuxF701lT5D6CDk6iIb8Kx2fj6LsBwMWD/gvGiiWqouQ7xBeFEq8mVmeK2cDh1k5e+V+XEMvXUjKywi4g6JGhdwwBVBcwAN9zU5ybzsb/Kyi2AA2rBMqp13gB/sUc5ALvZlXd0pPcF9+vwBPc+xPNJSpmMx6jpsEfdKtpueC3YtGa0ySCrhczB0H5N8Y5fq1jticc5/SunTM6g8IQ1USfaih6M12Xl7irRxvCcVSFkJrhQiV0HkeqjykuzzJSNrc12AMCpacr0bqO6OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zmo9TJe49QTZXvZ9D8WvAcD4wTha2EK5UJ47Sk0iHAw=;
 b=YVNpFRf9IsDQPNfo/pOD9EyoqqEfV9FLoCLiRmqFx1IhaSl5Ejovvyq9JbBEUT5IUR187uMKJx6mPOR/+KjzDP8qWYPJxDBJn8693jsJikc4rkMNWLMbjNl6AVmQa3IqMOTaMh4aCI5NgYipPPJwcofzOFNmFb2K2cRVA1eCLcQ=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB3653.namprd15.prod.outlook.com (2603:10b6:610:4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Mon, 29 Jun
 2020 00:45:48 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107%5]) with mapi id 15.20.3131.026; Mon, 29 Jun 2020
 00:45:48 +0000
Date:   Sun, 28 Jun 2020 17:45:45 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH bpf-next 02/10] tcp: bpf: Parse BPF experimental header
 option
Message-ID: <20200629004545.cpiiowlhgnk527f3@kafai-mbp.dhcp.thefacebook.com>
References: <20200626175501.1459961-1-kafai@fb.com>
 <20200626175514.1460570-1-kafai@fb.com>
 <CANn89iK50rqOVy=PmKO-Fe1D-HsHjp4zj-feevouQ2hc1GAQ9Q@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iK50rqOVy=PmKO-Fe1D-HsHjp4zj-feevouQ2hc1GAQ9Q@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR11CA0043.namprd11.prod.outlook.com
 (2603:10b6:a03:80::20) To CH2PR15MB3573.namprd15.prod.outlook.com
 (2603:10b6:610:e::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:807c) by BYAPR11CA0043.namprd11.prod.outlook.com (2603:10b6:a03:80::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Mon, 29 Jun 2020 00:45:47 +0000
X-Originating-IP: [2620:10d:c090:400::5:807c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7452ce58-6b77-4a35-05de-08d81bc5c39e
X-MS-TrafficTypeDiagnostic: CH2PR15MB3653:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR15MB365384972F91726F61823513D56E0@CH2PR15MB3653.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 044968D9E1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2bfP8mm333a36DWysSKHddgQ99QtN0c7rIU41VDUaETyETgfwASdSTGpWCtkY9D8gsXbaaWrcjomW+/tPvMXvpvcKqCIoUbWNwpYrVfmLGBJFD6+NTZ5GVXVtWRlbtPDkl9Kib7S3cLDK1DL30a/4NQKaHuRINrafvkk4H/TzSIvF39bOARqUQPrLj72BIsKEZiU/up/sUOVikB8rhIWvhXSppe66Fp3A97Jg8zqDSeBro1ro2emjsf4m4ZvoIgbw8a87nVuMi+1qbmtn8QwQdR/5nN+AuqmsvgeBVzlobRgJvqtO/L8J1DglBUJkFabfTE2FdzYA85J2Du/7whqeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(346002)(366004)(39860400002)(396003)(376002)(478600001)(66946007)(52116002)(1076003)(7696005)(66476007)(4326008)(66556008)(5660300002)(2906002)(8676002)(86362001)(8936002)(16526019)(186003)(9686003)(54906003)(6916009)(83380400001)(55016002)(316002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 1WbmCcahYVGnyGFBTrqQeYcpQiivBDBcOxknittdRcPK7rMttxFVYNnt5ZyVhKaczX5Moa1jmH7Admt9X+wAHHSUm9tyt34i6rgP6ZiNaNqHoI/oO1U78/BuosKZHLgnuKK7JVeUXrZh/Vpr3/JeRVHbzfCGUSAamZABWtO2tc9goyinnsvbnghPraYBGK3hYFHP4i8kZnRoiyc/dwiQuBDH8cCIZ6pRxU8yA1E0oGcjhFoP4E+PnAYQMsP8LWMazav8h97i5rAPwbawKFNmiCsbSg/KRd1gxOXOa8m22jHPpl9JcHGjPOoSz1mTm8Wq6N23RYgNV0aHfx2SWyqnikIzZM1ywkdQIZ1Sf/s0G/FueSSzoSqTRSZPW88p89nqGrbbcdAShKWyCVEbXe3bn0C4miiQ57Oj/1cuFVBkDDYyNej1uT/gRz90akjCRXQ/Bv3dxHygRkoEygfGIbOmbhEd6t5+RXuP4J+gSMAJznhvIdcsYw1GrgUueV0Vu5hhoBBbLOKOASBo0kblTt9/mg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7452ce58-6b77-4a35-05de-08d81bc5c39e
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2020 00:45:47.9604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XAqobbyDCHCrQZlIV5YTLYa5n30jNb4ZPz/tfs7PL71J45E+3kMrRmL7jfgaEUBM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3653
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-28_11:2020-06-26,2020-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 cotscore=-2147483648 lowpriorityscore=0 mlxscore=0 clxscore=1015
 bulkscore=0 spamscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=994 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006290002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 27, 2020 at 10:17:26AM -0700, Eric Dumazet wrote:
[ ... ]

> It seems strange that we want to add code in TCP stack only to cover a
> limited use case (kind 254 and 0xEB9F magic)
> 
> For something like the work Petar Penkov did (to be able to generate
> SYNCOOKIES from XDP), we do not go through tcp_parse_options() and BPF
> program
> would have to implement its own parsing (without having an SKB at
> hand), probably calling a helper function, with no
> TCP_SKB_CB(skb)->bpf_hdr_opt_off.
> 
> This patch is hard coding a specific option and will prevent anyone
> using private option(s) from using this infrastructure in the future,
> yet paying the extra overhead.
There is a discussion in patch 4 about not limiting this patch set
to option kind 254.  That will affect the usefulness of bpf_hdr_opt_off.

> 
> TCP_SKB_CB(skb) is tight, I would prefer keeping the space in it for
> standard TCP stack features.
> 
> If an optional BPF program needs to re-parse the TCP options to find a
> specific option, maybe the extra cost is noise (especially if this is
> only for SYN & SYNACK packets) ?
> 
> Thanks
