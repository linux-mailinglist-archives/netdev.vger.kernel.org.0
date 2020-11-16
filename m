Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E40A2B5364
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 22:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731362AbgKPVDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 16:03:41 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3208 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726219AbgKPVDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 16:03:40 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AGL09hW005412;
        Mon, 16 Nov 2020 13:02:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=9fMxEvmsJNRz8aaW2aLy2ORSCflJRELbs8XvZZ9sayk=;
 b=RkUWjTN5vlsbUvIE5WiuOz66VbZrtCrUTidPkX7xb0lVe/cHxKbI6PLBZXFq3cKHgkHx
 zwCBah0g2ibpC9+FkvTkc5v5wG/MjCZSOqd/a6MamBUC66t6WNfS0rxHDYCf813f1rkU
 4Zj22L9/hfT4eYqS4RZLPE4Dwqs7EQSg6Is= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34tdmrsu7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 16 Nov 2020 13:02:20 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 16 Nov 2020 13:02:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l2ekzzFiyXQqszr58bqzoUe8cUDxMpEIr68bKlZ1QIleyLV5PkrZsRHmN1qRqjaojGKSNeVzxNIZSc6ZaRmVIrRnWnISe+CMsl/+6KDF/KliD/MK2ENQLBpnu/J6AbZdXP3ah3wpSSEYzPHAn8odUaG+IwQJWyMiElGfq95ENMb6JZjULa4bQB3pGkPvKMsGpBsq/9Gbynnkz+t9yrV9k5N+G6/dT/W1xVe9vcTku7+i86mHQ6zNa4YjlmpCHvSL1cWyz+L+LKEe0Eun9pRZ0yWihJmpTWy3VbMgccUBKDhe+PKIyWfMr7fa7SIWFM+RooWjT1EfMfNwfp/VN4ctkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9fMxEvmsJNRz8aaW2aLy2ORSCflJRELbs8XvZZ9sayk=;
 b=fKUJonDCAauRHgcV1PL09j92NEhr+RS5kj0i5mZpwsK509k8uOqbJ9mFBphKNsIOEc4217dOXqANFwUn1sN9iE0PaEGrORCK5tswd0jm32FFtm1GPxI8Rgn/7Du+uQhYdTI6euUheKSh8yjT3xiUY+PCIOfjIKTPiqcc07JppExt3NjusJ+HGXKMu+ZKXh+FejcuBmgLvauHdA+scyZaZrIsen7OUErSFyh7MccWzjwjKzVZY4DB4VaQOzKcqI/6x+9r5cVOwTDqjTUAPcOrvnfmmuC3myfvy4LyC/hctbaKkI8/UFYZAAfk6IaVIrIa4E53CTlSG11pru4dTx/Ptg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9fMxEvmsJNRz8aaW2aLy2ORSCflJRELbs8XvZZ9sayk=;
 b=PiCb4/w0fwDMr91fpOl3uJEBmeGcwDUjmzvkSbk2L3dFPgXA7e8OHfAl/r87IZb51vnj1aNdI8/5mThE7WVLjyt8PLv6K2PQvnPkMoEOYxKArnnwVzTYlHpfs5iuSyWz+wPd2DLI1fIqtAuhCI5y/deZ/Rs0rmES0A6oT5lbGmk=
Authentication-Results: der-flo.net; dkim=none (message not signed)
 header.d=none;der-flo.net; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3256.namprd15.prod.outlook.com (2603:10b6:a03:10f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Mon, 16 Nov
 2020 21:02:18 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.028; Mon, 16 Nov 2020
 21:02:18 +0000
Date:   Mon, 16 Nov 2020 13:02:09 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Florian Lehner <dev@der-flo.net>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <peterz@infradead.org>,
        <mingo@redhat.com>, <acme@kernel.org>
Subject: Re: [FIX bpf,perf] bpf,perf: return EOPNOTSUPP for bpf handler on
 PERF_COUNT_SW_DUMMY
Message-ID: <20201116210209.skeolnndx3gk2xav@kafai-mbp.dhcp.thefacebook.com>
References: <20201116183752.2716-1-dev@der-flo.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116183752.2716-1-dev@der-flo.net>
X-Originating-IP: [2620:10d:c090:400::5:8f7f]
X-ClientProxiedBy: CO2PR18CA0045.namprd18.prod.outlook.com
 (2603:10b6:104:2::13) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:8f7f) by CO2PR18CA0045.namprd18.prod.outlook.com (2603:10b6:104:2::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Mon, 16 Nov 2020 21:02:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88b29657-0db4-4161-f390-08d88a72e6e5
X-MS-TrafficTypeDiagnostic: BYAPR15MB3256:
X-Microsoft-Antispam-PRVS: <BYAPR15MB325619F6C53BD153358FD073D5E30@BYAPR15MB3256.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DlYpOGzqIhgEkd8WvpAX/A7BzZMb2rcO2mRjdFxtfjLuMWx4WOKHwhEcs6CrUemgf+9TeRJ0BhUPLQ2NpzThnEtcqlcoMwFUlm6VR/mPXdJTnuhlUvFtj5E3788DcqJtBS0+PA6i+OAvcj5U8i4JHWS+jdrEysU0dy16NclqDRylI95k+KSswhebLLvpKslvW+cYKK8OSpqf/AxT7gcODI4z0rC96BKe7JNvC/fWS/VdiOL5C9Ppue8tkuy01K555AQfSDJz7EzYvmxj6YoJo12V+z6qJxJQgF/dM4eBanML9kTp/fEztvwm7sDVbSTo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(39860400002)(346002)(136003)(366004)(7416002)(6666004)(2906002)(6916009)(5660300002)(4744005)(9686003)(478600001)(55016002)(6506007)(186003)(66946007)(316002)(66556008)(16526019)(1076003)(52116002)(7696005)(66476007)(8676002)(4326008)(8936002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Uyh1tz/JicAnSyRng4pyjthFmQi76SNSMWNu/4J6NVwGMrtZPhRz1y8YHaRgJENOFIQu+0hMSIGvD7scCPRrT6nrK7+Zoxvv+4E9KrRJd7OVv3u4I/G2PxoGg00+ICQW9HayEHGlVD15kiRK3OTnP1QHNvJm3q30ehKuyc8VnblSUBDiCR8rucVC4K+35Rxk5qY+CWrtsJmUkRpDyQgjXn2c7F28+rsLJXOaKj0JxxdFxpeEfdjlUGIB9+nRn4f+XiUaWIgp57dVChbRRavoRwgzcKLVHRD9SJWJknU1JBP4BZZ1EHe039cFn48RF5yRyFgZFD6QF3dawXnJoiENrSZltBhF0zwfmcOz6yIisscd4030yR+6gw3N+PAoaQDr342P9i9LT4lLgtn1php/qKZzcia2jYdGOZ8VWd0tJHtyk0devupT+Uz1Yyyx5B4NULXPth3htaFnV24ewtT3pdtc8voftDU13TCvcqhwOAS/tUPaMjE6tTcp3mAPVU52gms+iq5uP2ICdr8hVJaXWRr09A/37PmyEIaudp9tfV/KETIj9KfsE7NeBFaRv6/TJ+ATDOsXGXJxyAxHQB6oDZ13mup/5HXvGVXRw6xnWbaEbGT98RpDTgyH3d0PN2WKXhPq5+HlbM4wEAPNfNqY82GUyR5Si2nHXeT2+LQ3HovbpInkOrp/H4dxPaWK4ZE0We3LT7p0ZTMqV9jwsej7Pek3I0L4dhTLKUF3FisUpTYwmwb1WK6cHJDIu/i0GFHLDzL5KDXpuF9YxSdSSu5Aq1RQca+tZ+pYgNnKeqk+jsqHJD8i3lxQ1hfXJgSIT5A8BzijELMcOXfuP0m9bmhCH02AJy5e4whJ7WHTzhv8axLlA7IfKmq8B1O9t+yXbr+4hs+N7pQ5kTePQ/WlwyS8yWqUsUFM3z4bhqLp/cor57c=
X-MS-Exchange-CrossTenant-Network-Message-Id: 88b29657-0db4-4161-f390-08d88a72e6e5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2020 21:02:18.0178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tdArEQ6fCd22JEQD9M8yjsPgeR0rE9as7w8kNeHmjeZTj5BdXhm+GW1OjopHf/mW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3256
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_11:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 clxscore=1011 priorityscore=1501 mlxscore=0
 suspectscore=1 adultscore=0 phishscore=0 mlxlogscore=744 spamscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011160124
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 07:37:52PM +0100, Florian Lehner wrote:
> bpf handlers for perf events other than tracepoints, kprobes or uprobes
> are attached to the overflow_handler of the perf event.
> 
> Perf events of type software/dummy are placeholder events. So when
> attaching a bpf handle to an overflow_handler of such an event, the bpf
> handler will not be triggered.
> 
> This fix returns the error EOPNOTSUPP to indicate that attaching a bpf
> handler to a perf event of type software/dummy is not supported.
> 
> Signed-off-by: Florian Lehner <dev@der-flo.net>
It is missing a Fixes tag.
